<?php
/**
 * 売り買いモデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/26
 */
class Urikai extends Zend_Db_Table
{
    protected $_name = 'urikais';

    // フィルタ条件
    protected $_filter = array('rules' => array(
        '*'        => array(),
        '会社情報' => array('fields' => 'company_id', 'NotEmpty', 'Int'),
        '売り買い' => array('fields' => 'goal',       'NotEmpty'),
        '内容'     => array('fields' => 'contents',   'NotEmpty'),
        '画像'     => array('fields' => 'imgs',),
        'TEL'      => array('fields' => 'tel',),
        'FAX'      => array('fields' => 'fax',),
        'メールアドレス' => array('fields' => 'mail',),

        // '解決日'   => array('fields' => 'end_date',),
    ));

    // 内容がJSONのカラム
    private $_jsonColumn = array('imgs');


    /**
     * 売り買い一覧を取得
     *
     * @access public
     * @return array 売り買い一覧
     */
    public function getList($q)
    {
      //// WHERE句 ////
      $where = $this->_makeWhere($q, true);
      if (!$where) { throw new Exception('検索条件が設定されていません'); };

        //// LIMIT句、OFFSET句 ////
        $orderBy = " ORDER BY uk.created_at DESC ";
        if (!empty($q['limit'])) {
            $orderBy.= $this->_db->quoteInto(' LIMIT ? ', $q['limit']);
            if (!empty($q['page'])) {
                $orderBy.= $this->_db->quoteInto(' OFFSET ? ', $q['limit'] * ($q['page'] - 1));
            }
        }

        // SQLクエリを作成
        $sql = "SELECT
          uk.*,
          co.company
        FROM
          urikais uk
          LEFT JOIN companies co
            ON co.id = uk.company_id
        WHERE
          {$where}
          {$orderBy};";
        $result = $this->_db->fetchAll($sql);

        $result = B::decodeTableJson($result, $this->_jsonColumn);

        return $result;
    }

    /**
     * 検索クエリからWHERE句の生成
     *
     * @access private
     * @param  array   $q     検索クエリ
     * @param  boolean $check 検索条件チェック
     * @return string  where句
     */
    private function _makeWhere($q, $check=false) {
        $arr = array();

        if (!empty($q['company_id'])) {
            $arr[] = $this->_db->quoteInto(' uk.company_id = ? ', $q['company_id']);
        }

        // 目的
        if (!empty($q['goal'])) {
            $arr[] = $this->_db->quoteInto(' uk.goal = ? ', $q['goal']);
        }

        if (!empty($q['period']) && $q['period'] > 0) {
            $arr[] = $this->_db->quoteInto(' uk.created_at > current_date - ? ', intval($q['period']));
        }

        // 終了していない
        if (!empty($q['is_notend'])) {
            $arr[] = ' uk.end IS NULL = ? ';
        }

        $arr[] = ' uk.deleted_at IS NULL ';

        return implode(' AND ', $arr);
    }

    /**
     * 件数を取得
     *
     * @access public
     * @param  array $q 検索クエリ
     * @return integer 機械総数
     */
    public function getCount($q)
    {
        //// WHERE句 ////
        $where = $this->_makeWhere($q);

        //// SQLクエリを作成・一覧を取得 ////
        $sql = "SELECT count(uk.*) AS count FROM urikais uk WHERE uk.deleted_at IS NULL AND {$where};";
        $result = $this->_db->fetchOne($sql);
        return $result;
    }

    /**
     * 売り買い情報を取得
     *
     * @access public
     * @param  integer $id        機械ID
     * @param  integer $companyId 会社ID
     * @return array   売り買い情報
     */
    public function get($id, $companyId=NULL) {
        if (empty($id)) { throw new Exception('IDが設定されていません'); }

        $where = '';
        if (!empty($companyId)) {
            $where = $this->_db->quoteInto(' AND company_id = ? ', $companyId);
        }

        // SQLクエリを作成
        $sql = "SELECT uk.* FROM urikais uk WHERE uk.id = ? AND uk.deleted_at IS NULL {$where} LIMIT 1;";
        $result = $this->_db->fetchRow($sql, $id);

        // JSON展開
        $result = B::decodeRowJson($result, $this->_jsonColumn);

        return $result;
    }


    /**
     * 売り買いを登録
     *
     * @access public
     * @return array 売り買い一覧
     */
    public function set($id=NULL, $data)
    {
        // フィルタリング・バリデーション
        $data = MyFilter::filter($data, $this->_filter);

        // JSONデータ保管
        foreach ($this->_jsonColumn as $val) {
            $data[$val] = !empty($data[$val]) ? json_encode($data[$val], JSON_UNESCAPED_UNICODE) : null;
        }

        if (empty($id)) {
            // 新規処理
            $res = $this->insert($data);
        } else {
            // 更新処理
            $data['changed_at'] = new Zend_Db_Expr('current_timestamp');
            $res = $this->update($data, array(
                $this->_db->quoteInto('id = ?', $id)
            ));
        }

        if (empty($res)) {
            throw new Exception("売り買い情報が保存できませんでした id:{$id}");
        }

        // メール通知
        //// 新規登録用の会社一覧(ランクB以上) ////
        $companyTable = new Companies();
        $companyList  = $companyTable->getList(array('rank' => $companyTable::RANK_B));

        $mailsend = new Mailsend();
        $company  = $companyTable->get($data['company_id']);
        $now      = date('Y/m/d H:i');
        $uk       = $data['goal'] == "cell" ? "売りたし" : "買いたし";
        $maxId    = $this->_db->fetchOne('SELECT max(id) FROM urikais LIMIT 1;');

        //// 通知メール送信内容 ////
        $body = <<< EOS
マシンライフに売りたし買いたしの書きこみがありました。

No. {$maxId} {$uk}
依頼主: {$company['company']}
https://www.zenkiren.net/company_detail.php?c={$company['id']}
書きこみ日時: {$now}

＜内容＞
{$data['contents']}

画像ありの詳細情報はこちら
http://www.zenkiren.net/admin/urikai_detail.php?id={$maxId}

この書きこみへのお問い合わせは、以下の問い合わせ先へお願いいたします。
※ このメールへの返信ではお問い合わせできません。

問い合わせTEL: {$data['tel']}
問い合わせFAX: {$data['fax']}
問い合わせメールアドレス: {$data['mail']}

問い合わせフォーム:
http://www.zenkiren.net/contact.php?c={$data["company_id"]}&mes=No.{$maxId}[[{$uk}]]について問合せ


マシンライフ｜全機連の中古機械情報サイト
http://www.zenkiren.net/

全日本機械業連合会
http://www.zenkiren.org/
EOS;
        $subject = 'マシンライフ:売りたし買いたし通知';

        //// メール送信 ////
        // $sends = array("bata44883@gmail.com", "kazuyoshih@gmail.com");
        // foreach ($sends as $to) { $mailsend->sendMail($to, null, $body, $subject); }

        foreach ($companyList as $co) {
            if (empty($co["contact_mail"])) { continue; }

            $b = <<< EOS
{$co["company"]} 様

{$body}
EOS;

            $mailsend->sendMail($co["contact_mail"], null, $b, $subject);
        }

        return $this;
    }

    public function set_end_date($id)
    {
        if (empty($id)) { throw new Exception("売り買い情報が指定されていません id:{$id}"); }

        // 更新処理
        $res = $this->update(array("end_date" => new Zend_Db_Expr('current_timestamp')), array(
            $this->_db->quoteInto('id = ?', $id)
        ));

        if (empty($res)) {
            throw new Exception("売り買い情報が保存できませんでした id:{$id}");
        }

        return $this;
    }

    public function unset_end_date($id)
    {
        if (empty($id)) { throw new Exception("売り買い情報が指定されていません id:{$id}"); }

        // 更新処理
        $res = $this->update(array("end_date" => null), array(
            $this->_db->quoteInto('id = ?', $id)
        ));

        if (empty($res)) {
            throw new Exception("売り買い情報が保存できませんでした id:{$id}");
        }

        return $this;
    }



    /**
     * 売り買い論理削除
     *
     * @access public
     * @param  array $id 売り買いID配列
     * @return $this
     */
    public function deleteById($id) {
        if (empty($id)) {
            throw new Exception('削除する売り買いIDが設定されていません');
        }

        $this->update(
            array('deleted_at' => new Zend_Db_Expr('current_timestamp')),
            array(
                $this->_db->quoteInto(' id IN(?) ', $id)
            )
        );

        return $this;
    }
}

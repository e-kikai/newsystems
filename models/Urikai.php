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
        '目的'     => array('fields' => 'goal',       'NotEmpty'),
        '内容'     => array('fields' => 'contents',   'NotEmpty'),
        // '解決日'   => array('fields' => 'end_date',),
    ));

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
        // $result = B::decodeRowJson($result, array_merge($this->_jsonColumn));

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
//         $mailsend = new Mailsend();
//         $uModel   = new User();
//         $user     = $uModel->get($data['user_id']);
//         $now      = date('Y/m/d H:i:s');
//
//         //// 通知メール送信内容 ////
//         $body = <<< EOS
// マシンライフに書きこみがありました。
//
// 書き込み場所 : {$data['target']}
// 書き込みユーザ : {$user['user_name']}
// 書き込み時間 : {$now}
//
// ＜内容＞
// {$data['contents']}
//
//
// 全日本機械業連合会
// http://www.zenkiren.org/
// EOS;
//         $subject = 'マシンライフ:書き込み通知';
//
//         //// メール送信 ////
//         $sends = array("bata44883@gmail.com", "kazuyoshih@gmail.com");
//         foreach ($sends as $to) {
//             $mailsend->sendMail($to, null, $body, $subject);
//         }

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

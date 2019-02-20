<?php
/**
 * チラシメールモデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2017/10/16
 */
class Flyer extends Zend_Db_Table_Abstract
{
    protected $_name = 'flyers';

    // 内容がJSONのカラム
    // private $_jsonColumn = array('design_imgs');

    // フィルタ条件
    protected $_filter = array('rules' => array(
        // '会社ID'               => array('fields' => 'company_id', 'Digits', 'NotEmpty'),
        // 'キャンペーンID'       => array('fields' => 'campaign', 'NotEmpty'),
        'タイトル'             => array('fields' => 'title', 'NotEmpty'),
        'メール表題'           => array('fields' => 'subject', 'NotEmpty'),

        '送信元名称'           => array('fields' => 'from_name', 'NotEmpty'),
        // '送信元メールアドレス' => array('fields' => 'from_mail', 'EmailAddress', 'NotEmpty'),
        '送信元メールアドレス' => array('fields' => 'from_mail', 'NotEmpty'),
        '送信日時'             => array('fields' => 'send_date'),

        'ステータス'           => array('fields' => 'status'),

        'TOP画像'              => array('fields' => 'design_top_img'),

        'メイン本文'           => array('fields' => 'design_main_text'),
        'サブ本文'             => array('fields' => 'design_sub_text'),
        'リンクボタン'         => array('fields' => 'design_button', 'NotEmpty'),
        // 'リンク先URL'          => array('fields' => 'design_url', array('Callback', 'Zend_Uri::check'), 'NotEmpty'),
        'リンク先URL'          => array('fields' => 'design_url', 'NotEmpty'),
        'リンクボタン下文章'   => array('fields' => 'design_bottom_text'),

        '画像_01'              => array('fields' => 'design_img_01'),
        '画像_02'              => array('fields' => 'design_img_02'),
        '画像_03'              => array('fields' => 'design_img_03'),
    ));

    /**
     * 入札会商品一覧を取得
     *
     * @access public
     * @return array チラシメール一覧
     */
    public function getList($q = null) {
        /// WHERE句 ///
        $where = $this->_makeWhere($q);

        //// LIMIT句、OFFSET句 ////
        $orderBy = ' ORDER BY f.id DESC ';
        if (!empty($q['limit'])) {
            $orderBy.= $this->_db->quoteInto(' LIMIT ? ', $q['limit']);
            if (!empty($q['page'])) {
                $orderBy.= $this->_db->quoteInto(' OFFSET ? ', $q['limit'] * ($q['page'] - 1));
            }
        }

        //// SQLクエリを作成・一覧を取得 ////
        $sql = "SELECT f.* FROM flyers f WHERE f.deleted_at IS NULL AND {$where} {$orderBy};";
        $result = $this->_db->fetchAll($sql);

        // JSON展開
        // $result = B::decodeTableJson($result, array_merge($this->_jsonColumn, array('spec_labels')));

        return $result;
    }

        /**
     * 検索クエリからWHERE句の生成
     *
     * @access private
     * @param  array $q 検索クエリ
     * @param boolean $check 検索条件チェック
     * @return string where句
     */
    private function _makeWhere($q, $check=false) {
        $arr = array();

        // 掲載会社ID
        if (!empty($q['company_id'])) {
            $arr[] = $this->_db->quoteInto(' f.company_id IN(?) ', $q['company_id']);
        }

        //// ここまでで、検索条件チェック ////
        if ($check == true && count($arr) == 0) {
            return false;
        }

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
        $sql = "SELECT count(f.*) AS count FROM flyers f WHERE deleted_at IS NULL AND {$where};";
        $result = $this->_db->fetchOne($sql);
        return $result;
    }

    /**
     * チラシ情報を取得
     *
     * @access public
     * @param  integer $id        機械ID
     * @param  integer $companyId 会社ID
     * @return array   機械情報を取得
     */
    public function get($id, $companyId=NULL) {
        if (empty($id)) { throw new Exception('IDが設定されていません'); }

        $where = '';
        if (!empty($companyId)) {
            $where = $this->_db->quoteInto(' AND company_id = ? ', $companyId);
        }

        // SQLクエリを作成
        $sql = "SELECT f.* FROM flyers f WHERE f.id = ? AND f.deleted_at IS NULL {$where} LIMIT 1;";
        $result = $this->_db->fetchRow($sql, $id);

        // JSON展開
        // $result = B::decodeRowJson($result, array_merge($this->_jsonColumn));

        return $result;
    }

    /**
     * 在庫機械情報をセット
     *
     * @access public
     * @param  array   $data      入力データ
     * @param  integer $id        機械ID
     * @param  integer $companyId 会社ID
     * @return $this
     */
    public function set($data, $id, $companyId)
    {
        // 会社情報のチェック
        if (empty($companyId)) { throw new Exception("会社情報がありません"); }

        // フィルタリング・バリデーション
        $data = MyFilter::filter($data, $this->_filter);

        // // JSONデータ保管
        // foreach ($this->_jsonColumn as $val) {
        //     $data[$val] = json_encode($data[$val], JSON_UNESCAPED_UNICODE);
        // }

        if (empty($id)) {
            // 新規処理
            $data['company_id'] = $companyId;
            $res = $this->insert($data);
        } else {
            // 更新処理
            if (!$this->checkUser($id, $companyId)) {
                throw new Exception("このチラシメールはあなたの会社のものではありません id:{$id} {$companyId}");
            }
            $data['changed_at'] = new Zend_Db_Expr('current_timestamp');
            $res = $this->update($data, array(
                $this->_db->quoteInto('id = ?', $id),
                $this->_db->quoteInto('company_id = ?', $companyId),
            ));
        }

        if (empty($res)) { throw new Exception("チラシ情報が保存できませんでした id:{$id}"); }

        return $this;
    }

    /**
     * campaign IDをセット
     *
     * @access public
     * @param  array   $campaign campaign ID
     * @param  integer $id       チラシID
     * @return $this
     */
    public function setCampaign($campaign, $id)
    {
        $data = array(
          'campaign'   => $campaign,
          'changed_at' =>  new Zend_Db_Expr('current_timestamp')
        );
        $res = $this->update($data, array($this->_db->quoteInto('id = ?', $id),));

        if (empty($res)) { throw new Exception("チラシ情報が保存できませんでした id:{$id}"); }

        return $this;
    }


    /**
     * 一番最後のIDを取得
     *
     * @access public
     * @return integer 一番最後のID
     */
    public function getLastId()
    {
        //// SQLクエリを作成・取得 ////
        $sql = "SELECT max(f.id) AS last_id FROM flyers f;";
        $result = $this->_db->fetchOne($sql);
        return $result;
    }

    /**
     * 所有会社のチェック
     *
     * @access public
     * @param  array  $id チェックする在庫機械ID
     * @param integer $companyId 会社ID
     * @return boolean 在庫が貴社のものならtrue
     */
    function checkUser($id, $companyId)
    {
        // $machine = $this->get($id);
        $flyer = $this->_db->fetchRow('SELECT * FROM flyers WHERE id = ? LIMIT 1;', $id);
        return $flyer['company_id'] == $companyId ? true : false;
    }

    /**
     * チラシ報を論理削除
     *
     * @access public
     * @param  array $id 機械ID配列
     * @return $this
     */
    public function deleteById($id, $companyId) {
        if (empty($id)) {
            throw new Exception('削除する機械IDが設定されていません');
        }

        $this->update(
            array('deleted_at' => new Zend_Db_Expr('current_timestamp')),
            array(
                $this->_db->quoteInto(' id IN(?) ', $id),
                $this->_db->quoteInto(' company_id = ? ', $companyId),
            )
        );

        return $this;
    }

    ///////////////////////////////////////

    // mailchimpAPL
    function doAPI($query, $action, $data, $_conf)
    {
        /// cURL初期化 ///
        $ch = curl_init($_conf->mailchimp_url . $query);

        // curl_setopt($ch, CURLOPT_POST,           true);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST,  $action);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_USERPWD,        "anystring:" . $_conf->mailchimp_api_key);
        curl_setopt($ch, CURLOPT_HTTPHEADER,     array("Content-Type: application/json"));
        curl_setopt($ch, CURLOPT_POSTFIELDS,     json_encode($data));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true );

        $result = curl_exec($ch);
        curl_close($ch);

        return json_decode($result, true);
    }

    function apiCreateCampaign($flyer, $company, $_conf) {
        $data = array(
            "type"         => "regular",
            "recipients"   => array("list_id" => $_conf->mailchimp_list_id),
            "content_type" => "html",
            "settings"     => array(
                "subject_line"     => $flyer["subject"],
                "title"            => $company["id"] . ".". $company["company"] . ":" . $flyer["title"],
                "from_name"        => $flyer["from_name"],
                "reply_to"         => $_conf->mailchimp_reply_mail,
                "use_conversation" => false,
            ),
            "tracking"     => array(
                "oepns"         => true,
                "html_clicks"   => true,
                "text_clicks"   => true,
                "goal_tracking" => false,
                "ecomm360"      => false,
            )

        );
        $res = $this->doAPI('campaigns', 'POST', $data, $_conf);

        return $res["id"];
    }

    function apiUpdateCampaign($flyer, $company, $_conf) {
        $data = array(
            "recipients" => array("list_id" => $_conf->mailchimp_list_id),
            "settings"   => array(
                "subject_line"     => $flyer["subject"],
                "title"            => $company["id"] . ".". $company["company"] . ":" . $flyer["title"],
                "from_name"        => $flyer["from_name"],
                "reply_to"         => $_conf->mailchimp_reply_mail,
                "use_conversation" => false,
            ),

        );
        $res = $this->doAPI('campaigns/' . $flyer["campaign"], 'PATCH', $data, $_conf);

        // var_dump($res); exit;

        return $res["id"];
    }

    function apiSetHtml($flyer, $html, $_conf) {
        $data = array("html" => $html,);

        $res = $this->doAPI('campaigns/' . $flyer["campaign"] . '/content', 'PUT', $data, $_conf);

        return true;
    }

    /// キャンペーン取得 ///
    function apiGetCampaign($flyer, $_conf) {
        return $this->doAPI('campaigns/' . $flyer["campaign"], 'GET', null, $_conf);
    }

    /// レポート取得 ///
    function apiGetReport($flyer, $_conf) {
        return $this->doAPI('reports/' . $flyer["campaign"], 'GET', null, $_conf);
    }

    /// 送信テスト実行 ///
    function apiTest($flyer, $mail, $_conf) {
        $data = array(
            "test_emails" => array($mail),
            "send_type"   => "html",
        );
        $res = $this->doAPI('campaigns/' . $flyer["campaign"] . '/actions/test', 'POST', $data, $_conf);

        return true;
    }

    /// 送信実行 ///
    function apiSend($flyer, $_conf) {
        if (empty($flyer["send_date"])) {
            $res = $this->doAPI('campaigns/' . $flyer["campaign"] . '/actions/send', 'POST', null, $_conf);
        } else {
            $data = array("schedule_time" => date("Y-m-d\TH:i:00+09:00", strtotime($flyer["send_date"])));
            $res  = $this->doAPI('campaigns/' . $flyer["campaign"] . '/actions/schedule', 'POST', $data, $_conf);
        }

        return true;
    }

    // スケジュールキャンセル
    function apiUnschedule($flyer, $_conf) {
        $res = $this->doAPI('campaigns/' . $flyer["campaign"] . '/actions/unschedule', 'POST', null, $_conf);
    }
}

<?php
/**
 * 機械情報モデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
class BidOpen extends Zend_Db_Table_Abstract
{
    protected $_name = 'bid_opens';

    // 内容がJSONのカラム

    // フィルタ条件
    protected $_filter = array('rules' => array(
        'タイトル'     => array('fields' => 'title', 'NotEmpty'),
        '主催者名'     => array('fields' => 'organizer', 'NotEmpty'),

        '登録開始日時' => array('fields' => 'entry_start_date', 'NotEmpty'),
        '登録終了日時' => array('fields' => 'entry_end_date', 'NotEmpty'),

        '下見開始日時' => array('fields' => 'preview_start_date', 'NotEmpty'),
        '下見終了日時' => array('fields' => 'preview_end_date', 'NotEmpty'),

        '入札開始日時' => array('fields' => 'bid_start_date', 'NotEmpty'),
        '入札終了日時' => array('fields' => 'bid_end_date', 'NotEmpty'),

        '入札日時(一般ユーザ向け)' => array('fields' => 'user_bid_date', 'NotEmpty'),

        '請求日'       => array('fields' => 'billing_date', 'NotEmpty'),
        '支払日'       => array('fields' => 'payment_date', 'NotEmpty'),
        '搬出開始日'   => array('fields' => 'carryout_start_date', 'NotEmpty'),
        '搬出終了日'   => array('fields' => 'carryout_end_date', 'NotEmpty'),

        // '表示開始日時' => array('fields' => 'display_start_date', 'NotEmpty'),
        // '表示終了日時' => array('fields' => 'display_end_date', 'NotEmpty'),

        // 'セリ分かれ開始日時' => array('fields' => 'seri_start_date'),
        // 'セリ分かれ終了日時' => array('fields' => 'seri_end_date'),

        '最低入札金額' => array('fields' => 'min_price', 'Digits', 'NotEmpty'),
        '入札レート'   => array('fields' => 'rate', 'Digits', 'NotEmpty'),
        '消費税'       => array('fields' => 'tax', 'Digits', 'NotEmpty'),
        // '元引き手数料' => array('fields' => 'motobiki', 'Digits', 'NotEmpty'),
        // 'デメ'         => array('fields' => 'deme', 'Digits', 'NotEmpty'),

        // '出品点数制限方法' => array('fields' => 'entry_limit_style', 'Digits'),
        // '出品点数制限数'   => array('fields' => 'entry_limit_num', 'Digits'),
    ));

    protected $_filterAnnounce = array('rules' => array(
        '商品リストお知らせ' => array('fields' => 'announce_list',),
        '指図書フラグ'       => array('fields' => 'sashizu_flag',),
    ));

    /**
     * 入札会開催一覧を取得
     *
     * @access public
     * @param  string  $q   検索クエリ
     * @return array 機械検索結果一覧
     */
    public function getList($q=null) {
        //// WHERE句 ////
        $where = '';

        // 入札
        if (!empty($q['isopen'])) {
            $where = ' AND o.entry_start_date <= now() AND o.carryout_end_date >= now() ';
        }

        if  (!empty($q['isdisplay'])) {
            $where = ' AND o.bid_start_date <= now() AND o.user_bid_date >= now() ';
        }

        if  (!empty($q['islast'])) {
            $where = 'AND o.carryout_end_date > now() ';
        }

        //// LIMIT句、OFFSET句 ////
        $orderBy = ' ORDER BY o.bid_end_date DESC ';
        if (!empty($q['order'])) {
            if (($q['order']) == 'bid_end_date') {
                $orderBy = ' ORDER BY o.bid_end_date ASC ';
            }
        }

        if (!empty($q['limit'])) {
            $orderBy.= $this->_db->quoteInto(' LIMIT ? ', $q['limit']);
            if (!empty($q['page'])) {
                $orderBy.= $this->_db->quoteInto(' OFFSET ? ', $q['limit'] * ($q['page'] - 1));
            }
        }

        //// SQLクエリを作成・一覧を取得 ////
        $sql = "SELECT
          o.*,
          count(m.*) as count
        FROM
          bid_opens o
          LEFT JOIN bid_machines m
            ON m.bid_open_id = o.id AND
            m.deleted_at IS NULL
        WHERE
          o.deleted_at IS NULL
          {$where}
        GROUP BY
          o.id
        {$orderBy};";
        $result = $this->_db->fetchAll($sql);
        foreach($result as $key => $bo) {
            $result[$key]['status'] = self::checkStatus($bo);
        }

        // JSON展開
        // $result = B::decodeTableJson($result, array_merge($this->_jsonColumn, array('spec_labels')));

        return $result;
    }

    /**
     * 機械件数を取得
     *
     * @access public
     * @return integer 機械総数
     */
    public function getCount($q)
    {
        //// WHERE句 ////
        $where = $this->_makeWhere($q);

        /// SQLクエリを作成・一覧を取得 ////
        $sql = "SELECT
            count(m.*) AS count
        FROM
            machines m
            LEFT JOIN companies c
                ON m.company_id = c.id
            LEFT JOIN genres g
                ON (m.genre_id = g.id)
        WHERE
            m.company_id IN ( SELECT id FROM companies WHERE deleted_at IS NULL ) AND
            {$where};";
        $result = $this->_db->fetchOne($sql);
        return $result;
    }

    /**
     * 入札会開催情報を取得
     *
     * @access public
     * @param  string  $id 入札会開催ID
     * @return array 入札会開催情報を取得
     */
    public function get($id) {
        if (empty($id)) {
            throw new Exception('入札会開催IDが設定されていません');
        }

        // SQLクエリを作成
        $sql = "SELECT
          o.*,
          count(m.*) as count
        FROM
          bid_opens o
          LEFT JOIN bid_machines m
            ON m.bid_open_id = o.id AND
            m.deleted_at IS NULL
        WHERE
          o.deleted_at IS NULL AND
          o.id = ?
        GROUP BY
          o.id
        LIMIT
          1;";
        $result = $this->_db->fetchRow($sql, $id);

        // JSON展開
        // $result = B::decodeRowJson($result, array_merge($this->_jsonColumn, array('spec_labels')));
        $result['status'] = self::checkStatus($result);

        return $result;
    }

    /**
     * 入札会開催情報のステータスを取得
     *
     * @access static public
     * @param  array $bo 入札会開催情報
     * @return string 入札会ステータス
     */
    static public function checkStatus($bo)
    {
        $now = time();
        if (strtotime($bo['entry_start_date']) > $now) {
            return 'before';
        } else if  (strtotime($bo['entry_start_date']) <= $now && strtotime($bo['entry_end_date']) > $now) {
            return 'entry';
        } else if  (strtotime($bo['entry_end_date']) <= $now && strtotime($bo['bid_start_date']) > $now) {
            return 'margin';
        } else if  (strtotime($bo['bid_start_date']) <= $now && strtotime($bo['bid_end_date']) > $now) {
            return 'bid';
        } else if  (strtotime($bo['bid_end_date']) <= $now && strtotime($bo['carryout_end_date']) > $now) {
            return 'carryout';
        } else {
            return 'after';
        }
        return 'disable';
    }

    /**
     * 入札会開催情報のステータスの日本語表示
     *
     * @access static public
     * @param  array $status 入札会ステータス
     * @return string 入札会ステータス(日本語)
     */
    static public function statusLabel($status) {
        if      ($status == 'before')   { return '入札会開始前'; }
        else if ($status == 'entry')    { return '出品期間'; }
        else if ($status == 'margin')   { return '入札開始前'; }
        else if ($status == 'bid')      { return '下見・入札期間'; }
        else if ($status == 'carryout') { return '入札終了・搬出期間'; }
        else if ($status == 'after')    { return '入札会終了'; }

        return '不明';
    }

    /**
     * 入札会の入札数一覧を取得
     *
     * @access static public
     * @return array 入札会の入札数一覧
     */
    public function getBidCountList() {
        //// SQLクエリを作成・一覧を取得 ////
        $sql = "SELECT
          bo.*,
          bbt1.count,
          bbt1.company_count,
          bbt1.result_count,
          bbt2.result_price_sum
        FROM
          bid_opens bo
          LEFT JOIN (
            SELECT
              bm1.bid_open_id,
              count(bb1.*) AS count,
              count(DISTINCT bb1.company_id) AS company_count,
              count(DISTINCT bb1.bid_machine_id) AS result_count
            FROM       bid_bids bb1
            INNER JOIN bid_machines bm1 ON bm1.id = bb1.bid_machine_id
            WHERE      bb1.deleted_at IS NULL AND bm1.deleted_at IS NULL
            GROUP BY   bm1.bid_open_id
          ) bbt1 ON bbt1.bid_open_id = bo.id
          LEFT JOIN (
            SELECT
              bm2.bid_open_id,
              sum(bb2.result_price) AS result_price_sum
            FROM
              (SELECT bb21.bid_machine_id, max(bb21.amount) as result_price FROM bid_bids bb21 WHERE bb21.deleted_at IS NULL GROUP BY bb21.bid_machine_id) bb2
            INNER JOIN bid_machines bm2 ON bm2.id = bb2.bid_machine_id
             WHERE     bm2.deleted_at IS NULL
            GROUP BY   bm2.bid_open_id
          ) bbt2 ON bbt2.bid_open_id = bo.id
        WHERE
          bo.deleted_at IS NULL
        ORDER BY
          bo.id DESC;";
        $result = $this->_db->fetchAll($sql);
        foreach($result as $key => $bo) {
            $result[$key]['status'] = self::checkStatus($bo);
        }

        return $result;
    }

    /**
     * 入札会情報を論理削除
     *
     * @access public
     * @param  array $id 入札会ID
     * @return $this
     */
    public function deleteById($id) {
        if (empty($id)) {
            throw new Exception('削除する入札会IDが設定されていません');
        }

        $this->update(
            array('deleted_at' => new Zend_Db_Expr('current_timestamp')),
            array(
                $this->_db->quoteInto(' id IN(?) ', $id),
            )
        );

        return $this;
    }

    /**
     * 入札会情報をセット
     *
     * @access public
     * @param array $data 入札会データ
     * @param  array $id 入札会ID
     * @return $this
     */
    public function set($data, $id=null)
    {
        // 入力された日時を整形
        if (!empty($data['entry_start_time'])) {
            $data['entry_start_date'] = $data['entry_start_date'] . ' ' . $data['entry_start_time'];
        }
        if (!empty($data['entry_end_time'])) {
            $data['entry_end_date'] = $data['entry_end_date'] . ' ' . $data['entry_end_time'];
        }

        if (!empty($data['bid_start_time'])) {
            $data['bid_start_date'] = $data['bid_start_date'] . ' ' . $data['bid_start_time'];
        }
        if (!empty($data['bid_end_time'])) {
            $data['bid_end_date'] = $data['bid_end_date'] . ' ' . $data['bid_end_time'];
        }

        if (!empty($data['user_bid_time'])) {
            $data['user_bid_date'] = $data['user_bid_date'] . ' ' . $data['user_bid_time'];
        }

        if (!empty($data['carryout_start_time'])) {
            $data['carryout_start_date'] = $data['carryout_start_date'] . ' ' . $data['carryout_start_time'];
        }
        if (!empty($data['carryout_end_time'])) {
            $data['carryout_end_date'] = $data['carryout_end_date'] . ' ' . $data['carryout_end_time'];
        }

        /*
        if (!empty($data['display_start_time'])) {
            $data['display_start_date'] = $data['display_start_date'] . ' ' . $data['display_start_time'];
        }
        if (!empty($data['display_end_time'])) {
            $data['display_end_date'] = $data['display_end_date'] . ' ' . $data['display_end_time'];
        }
        */

        if (!empty($data['seri_start_time'])) {
            $data['seri_start_date'] = $data['seri_start_date'] . ' ' . $data['seri_start_time'];
        }
        if (!empty($data['seri_end_time'])) {
            $data['seri_end_date'] = $data['seri_end_date'] . ' ' . $data['seri_end_time'];
        }

        // フィルタリング・バリデーション
        $data = MyFilter::filter($data, $this->_filter);

        if (empty($id)) {
            // 新規処理
            $res = $this->insert($data);
        } else {
            // 更新処理
            $data['changed_at'] = new Zend_Db_Expr('current_timestamp');
            $res = $this->update($data, $this->_db->quoteInto('id = ?', $id));
        }

        if (empty($res)) {
            throw new Exception("入札会情報が保存できませんでした id:{$id}");
        }

        return $this;
    }

    /**
     * 入札会情報をセット
     *
     * @access public
     * @param array $data 入札会お知らせデータ
     * @param array $id 入札会ID
     * @return $this
     */
    public function setAnnounce($data, $id)
    {
        if (empty($id)) {
            throw new Exception('お知らせ変更する入札会IDが設定されていません');
        }

        // フィルタリング・バリデーション
        $data = MyFilter::filter($data, $this->_filterAnnounce);

        // 更新処理
        $data['changed_at'] = new Zend_Db_Expr('current_timestamp');
        $res = $this->update($data, $this->_db->quoteInto('id = ?', $id));

        if (empty($res)) {
            throw new Exception("入札会お知らせ情報が保存できませんでした id:{$id}");
        }

        return $this;
    }


    /**
     * リストNoのセットと商品リストPDFの生成
     *
     * @access public
     * @param array $data 入札会データ
     * @param  array $id 入札会ID
     * @return $this
     */
    public function makeList($id, $filePath, $fileName, $_smarty)
    {
        // 出品期間中かのチェック
        $bidOpen = $this->get($id);
        if (empty($bidOpen)) {
            throw new Exception("入札会情報が取得出来ませんでした");
        }

        //// リストNoのセット処理 ////
        // 機械情報を取得
        $bmModel = new BidMachine();
        $bidMachineList = $bmModel->getList(array('bid_open_id' => $id, 'order' => 'list_no'));
        $maxListNo = $bmModel->getMaxListNo($id);

        foreach($bidMachineList as $key => $m) {
            if (empty($m['list_no'])) {
                $maxListNo++;
                $bidMachineList[$key]['list_no'] = $maxListNo;
                $bidMachineList[$key]['ex_no'] = $id . '-' . $maxListNo;
                $bmModel->update(array('list_no' => $maxListNo), $this->_db->quoteInto('id = ?', $m['id']));
            }
        }

        //// リストPDFの生成 ////
        //// 表示変数アサイン ////
        $res = $_smarty->assign(array(
            'bidOpenId'      => $id,
            'bidOpen'        => $bidOpen,
            'bidMachineList' => $bidMachineList,
            // 'countAll'       => $countAll,
        ))->fetch("system/test/mpdf_test_02.tpl");

        // echo $res; exit;

        include("mpdf/mpdf.php");
        $mpdf=new mPDF('ja', 'A4', 12, '', 10, 10, 15, 15, 9, 9, 'L');
        $mpdf->SetHeader($bidOpen['title'] . ' 出品商品リスト');
        $mpdf->setFooter('{PAGENO}');
        $mpdf->WriteHTML($res);

        $mpdf->Output($filePath . $fileName, 'F');

        // 更新処理
        $data['list_pdf']   = $fileName;
        $data['changed_at'] = new Zend_Db_Expr('current_timestamp');
        $res = $this->update($data, $this->_db->quoteInto('id = ?', $id));

        return $this;
    }


    /**
     * マイリスト使用状況を取得
     *
     * @access public
     * @param  string  $id 入札会開催ID
     * @return array マイリスト使用状況を取得
     */
    public function getMylistLog($id) {
        if (empty($id)) {
            throw new Exception('入札会開催IDが設定されていません');
        }

        // SQLクエリを作成
        $sql = "SELECT
          a.created_at ::DATE AS DATE,
          ip,
          hostname,
          count(*) as count
        FROM
          actionlogs a
          LEFT JOIN bid_machines bm
            ON bm.id = a.action_id
        WHERE
          ACTION = 'bid_mylist' AND
          bm.bid_open_id = ?
        GROUP BY
          a.created_at ::DATE,
          ip,
          hostname
        ORDER BY
          DATE DESC,
          hostname,
          ip;";
        $result = $this->_db->fetchAll($sql, $id);

        return $result;
    }
}

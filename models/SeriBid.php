<?php
/**
 * 機械情報モデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2017/02/24
 */
class SeriBid extends Zend_Db_Table_Abstract
{
    protected $_name = 'seri_bids';

    // 内容がJSONのカラム

    // フィルタ条件
    protected $_filter = array('rules' => array(
        '商品ID'   => array('fields' => 'bid_machine_id', 'Digits', 'NotEmpty'),
        '会社ID'   => array('fields' => 'company_id', 'Digits', 'NotEmpty'),
        '入札金額' => array('fields' => 'amount', 'Digits', 'NotEmpty'),
        // '入札担当者' => array('fields' => 'charge', 'NotEmpty'),
        // '備考欄'     => array('fields' => 'comment',),
    ));

    /**
     * 入札会入札履歴一覧を取得
     *
     * @access public
     * @param array $q 検索クエリ
     * @return array 入札履歴結果一覧
     */
    public function getList($q) {
        if (empty($q['bid_open_id'])) {
            throw new Exception('入札会開催IDが設定されていません');
        } else if (empty($q['company_id'])) {
            throw new Exception('会社IDが設定されていません');
        }

        //// WHERE句 ////
        $where = '';
        // if (empty($q['delete'])) {
        //     $where = ' b.deleted_at IS NULL AND ';
        // }

        //// SQLクエリを作成・一覧を取得 ////
        $sql = "SELECT
          b.*,
          m.list_no,
          m.name,
          m.maker,
          m.model,
          m.year,
          m.min_price,
          c.company
        FROM
          seri_bids b
          LEFT JOIN bid_machines m
            ON m.id = b.bid_machine_id AND
            m.deleted_at IS NULL
          LEFT JOIN companies c
            ON c.id = m.company_id AND
            c.deleted_at IS NULL
        WHERE
          {$where}
          m.bid_open_id = ? AND
          b.company_id = ?;";
        $result = $this->_db->fetchAll($sql, array($q['bid_open_id'], $q['company_id']));

        return $result;
    }

    /**
     * 件数を取得
     *
     * @access public
     * @return integer 機械総数
     */
    public function getCount($q)
    {
        //// WHERE句 ////
        $where = $this->_makeWhere($q);

        //// SQLクエリを作成 ////
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
     * 入札情報を取得
     *
     * @access public
     * @param  int $id 入札ID
     * @param  int $companyId 会社ID
     * @return array 入札会開催情報を取得
     */
    public function get($bidId, $companyId) {
        if (empty($bidId)) {
            throw new Exception('入札IDが設定されていません');
        }

        // SQLクエリを作成
        $sql = "SELECT
          b.*,
          m.bid_open_id,
          m.name,
          m.maker,
          m.model,
          m.year,
          c.company
        FROM
          seri_bids b
          LEFT JOIN bid_machines m
            ON m.id = b.bid_machine_id AND
            m.deleted_at IS NULL
          LEFT JOIN companies c
            ON c.id = m.company_id AND
            c.deleted_at IS NULL
        WHERE
          b.id = ? AND
          b.company_id = ?
        LIMIT
          1;";
        $result = $this->_db->fetchRow($sql, array($bidId, $companyId));

        return $result;
    }

    public function getByBidMachineId($bidMachineId)
    {
        if (empty($bidMachineId)) { throw new Exception('入札会商品IDが設定されていません'); }

        // SQLクエリを作成
        $sql = "SELECT
          bb.*,
          c.company
        FROM
          seri_bids bb
          LEFT JOIN companies c
            ON c.id = bb.company_id
        WHERE
          bb.bid_machine_id = ?
        ORDER BY
          amount DESC,
          id;";
        $result = $this->_db->fetchAll($sql, $bidMachineId);

        return $result;
    }

    public function getMaxAmountByBidMachineId($bidMachineId)
    {
        if (empty($bidMachineId)) { throw new Exception('入札会商品IDが設定されていません'); }

        $sql = "SELECT max(bb.amount) FROM seri_bids bb WHERE bb.bid_machine_id = ?;";
        $result = $this->_db->fetchOne($sql, $bidMachineId);

        return $result;
    }

    /**
     * 入札情報を論理削除
     *
     * @access public
     * @param  array $id 入札ID
     * @param  array $companyId 入札会ID
     * @return $this
     */
    // public function deleteById($bidId, $companyId) {
    //     if (empty($bidId)) {
    //         throw new Exception('削除する入札IDが設定されていません');
    //     }
    //
    //     //// チェックのために、商品と入札会情報を取得 ////
    //     $bid = $this->get($bidId, $companyId);
    //
    //     $boModel = new BidOpen();
    //     $bidOpen = $boModel->get($bid['bid_open_id']);
    //
    //     $e = '';
    //     if (empty($bidOpen)) {
    //         $e = '入札会情報が取得出来ませんでした';
    //     } else if ($bidOpen['status'] != 'bid') {
    //         // 入札期間のチェック
    //         $e = $bidOpen['title'] . " は、現在「下見・入札期間」ではありません\n";
    //         $e.= "下見・入札期間 : " . date('Y/m/d H:i', strtotime($bidOpen['bid_start_date'])) . " ～ " . date('m/d H:i', strtotime($bidOpen['bid_end_date']));
    //     }
    //     if (!empty($e)) { throw new Exception($e); }
    //
    //     $this->update(
    //         array('deleted_at' => new Zend_Db_Expr('current_timestamp')),
    //         array(
    //             $this->_db->quoteInto(' id IN(?) ', $bidId),
    //             $this->_db->quoteInto(' company_id = ? ', $companyId),
    //         )
    //     );
    //
    //     return $this;
    // }

    /**
     * 入札情報をセット
     *
     * @access public
     * @param array $data 入札会データ
     * @param integer $companyId 入札会社ID
     * @return $this
     */
    public function set($data, $companyId)
    {
        if (empty($companyId)) {
            throw new Exception('入札する会社IDが設定されていません');
        }

        // フィルタリング・バリデーション
        $data['company_id'] = $companyId;
        $data = MyFilter::filter($data, $this->_filter);

        //// チェックのために、商品と入札会情報を取得 ////
        $bmModel = new BidMachine();
        $machine = $bmModel->get($data['bid_machine_id']);

        $boModel = new BidOpen();
        $bidOpen = $boModel->get($machine['bid_open_id']);

        $maxAmount = $this->getMaxAmountByBidMachineId($data['bid_machine_id']);

        $e = '';
        if (empty($bidOpen)) {
            $e = '入札会情報が取得出来ませんでした';
        } else if (empty($bidOpen['seri_start_date']) || empty($bidOpen['seri_end_date'])) {
            // セリ分かれ開催のチェック
            $e = $bidOpen['title'] . " では、セリ分かれは開催されません\n";
        } else if (strtotime($bidOpen["seri_start_date"]) > time() && strtotime($bidOpen["seri_end_date"]) <= time()) {
            // セリ期間のチェック
            $e = $bidOpen['title'] . " は、セリ分かれ開催期間ではありません\n";
            $e.= "セリ分かれ開催期間 : " . date('Y/m/d H:i', strtotime($bidOpen['seri_start_date'])) . " ～ " . date('m/d H:i', strtotime($bidOpen['seri_end_date']));
        } else if ($data['amount'] < $bidOpen['min_price']) {
            $e = "入札金額が、最低入札金額より小さく入力されています";
            $e.= "最低入札金額 : " . $bidOpen['min_price'] . '円';
        } else if (($data['amount'] % $bidOpen['rate']) != 0) {
            $e = '入札金額が、入札単位の倍数ではありません';
        } else if (!empty($maxAmount) && $maxAmount >= $data['amount']) {
            $e = '入札金額が、現在の最高入札金額より低く入力されています';
        }

        if (!empty($e)) { throw new Exception($e); }

        $res = $this->insert($data);

        if (empty($res)) {
            throw new Exception("セリ入札情報が保存できませんでした");
        }

        if ($data['amount'] >= $machine['seri_price']) { return "success"; }
        else                                           { return "none"; }
    }
}

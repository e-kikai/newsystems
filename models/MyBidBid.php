<?php

/**
 * ユーザ入札モデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/16
 */
class MyBidBid extends MyTableAbstract
{
    protected $_name = 'my_bid_bids';

    // フィルタ条件
    protected $_insert_filter = array('rules' => array(
        '*'        => array(),

        '商品ID'   => array('fields' => 'bid_machine_id', 'Digits', 'NotEmpty'),
        'ユーザID' => array('fields' => 'my_user_id', 'Digits', 'NotEmpty'),
        '入札金額' => array('fields' => 'amount', 'Digits', 'NotEmpty'),
    ));

    /**
     * 入札会期間のチェック
     *
     * @access public
     * @param  array  $open   入札会情報
     * @return string エラー内容(エラーがなければ空白)
     */
    public function check_date_errors($bid_open)
    {
        $e = '';

        if (empty($bid_open)) {
            $e = '入札会情報が取得出来ませんでした';
        } else if (!in_array($bid_open['status'], array('bid', 'carryout', 'after'))) {
            $e = "{$bidOpen['title']}は現在、入札会の期間ではありません\n";
            $e .= "入札期間 : " . date('Y/m/d H:i', strtotime($bid_open['bid_start_date'])) . " ～ " . date('m/d H:i', strtotime($bid_open['bid_end_date']));
        }

        return $e;
    }

    /**
     * 入札終了期間のチェック
     *
     * @access public
     * @param  array  $open   入札会情報
     * @return string エラー内容(エラーがなければ空白)
     */
    public function check_end_errors($bid_open)
    {
        $e = '';

        if (empty($bid_open)) {
            $e = '入札会情報が取得出来ませんでした';
        } else if (!in_array($bid_open['status'], array('carryout', 'after'))) {
            $e = "{$bid_open['title']}は、まだ終了していません\n";
            $e .= "入札期間 : " . date('Y/m/d H:i', strtotime($bid_open['bid_start_date'])) . " ～ " . date('m/d H:i', strtotime($bid_open['bid_end_date']));
        }

        return $e;
    }

    public function select_count_by_bid_machine_id()
    {
        $select = $this->_db->select()
            ->from("my_bid_bids", ["bid_machine_id", "count(*) as c"])
            ->where("deleted_at IS NULL")
            ->group("bid_machine_id");

        return $select;
    }

    /**
     * 機械IDごとの入札件数集計
     *
     * @access public
     * @param  array  $bid_machines 集計する機械情報
     * @return array 機械IDごとの入札件数
     */
    public function count_by_bid_machine_id($bid_machine_ids)
    {
        $select = $this->select_count_by_bid_machine_id()->where("bid_machine_id IN (?)", $bid_machine_ids);

        $res = $this->_db->fetchAll($select);

        $return = [];
        foreach ($res as $r) {
            $return[$r["bid_machine_id"]] = $r["c"];
        }

        return $return;
    }

    public function results_by_bid_machine_id($bid_machine_ids)
    {
        $sql = "SELECT
            bm.id,
            bb1.id AS bid_id,
            bb1.amount,
            bb1.sameno,
            bb1.my_user_id,
            bb1.uniq_account,
            bb1.name,
            bb1.company,
            bb3.same_count
        FROM bid_machines bm
        LEFT JOIN (
            SELECT DISTINCT ON (bb.bid_machine_id)
                bb.*,
                u.uniq_account,
                u.name,
                u.company
            FROM my_bid_bids bb
            LEFT JOIN my_users u ON u.id = bb.my_user_id
            WHERE bb.deleted_at IS NULL
            AND u.deleted_at IS NULL
            AND u.freezed_at IS NULL
            ORDER BY bb.bid_machine_id, amount DESC, sameno DESC, bb.created_at ASC
        ) bb1 ON bb1.bid_machine_id = bm.id
        LEFT JOIN (
            SELECT
                bid_machine_id,
                count(CASE WHEN (bid_machine_id, amount) IN (
                    SELECT bb2.bid_machine_id, max(bb2.amount)
                    FROM my_bid_bids bb2
                    WHERE bb2.deleted_at IS NULL
                    GROUP BY bb2.bid_machine_id
                ) THEN 1 END) AS same_count
            FROM my_bid_bids
            WHERE deleted_at IS NULL
            GROUP BY bid_machine_id
        ) bb3 ON bb3.bid_machine_id = bm.id
        WHERE bm.deleted_at IS NULL
        AND bm.canceled_at IS NULL
        AND bm.id IN (?)
        AND bb1.amount IS NOT NULL
        ORDER BY bm.id;";

        $res = $this->_db->fetchAll($this->_db->quoteInto($sql, $bid_machine_ids));

        $return = [];
        foreach ($res as $r) {
            $return[$r["id"]] = $r;
        }

        return $return;
    }

    function bid_machines2ids($bid_machines, $label = "id")
    {
        $ids = [0];
        foreach ($bid_machines as $bm) $ids[] = $bm[$label];

        return $ids;
    }

    static public $_adds = [0.1, 0.3, 0.5, 1, 1.5, 2, 2.2, 3];

    /**
     * 自動入札用、金額生成処理
     *
     * @access public
     * @param  int  $amount 元の入札金額
     * @return array 加算した入札金額
     */
    static function auto_amount($amount)
    {
        $digits = pow(10, floor(log10($amount)));
        $late   = MyBidBid::$_adds[array_rand(MyBidBid::$_adds)];

        return $amount + ($digits * $late);
    }
}

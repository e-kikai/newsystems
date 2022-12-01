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
     * 出品期間のチェック
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
     * 機械IDごとの入札件数集計
     *
     * @access public
     * @param  array  $bid_machine_ids 集計する機械ID
     * @return array 機械IDごとの入札件数
     */
    public function count_by_bid_machine_id($bid_machine_ids)
    {
        $sql = "SELECT bid_machine_id, count(*) as c
            FROM my_bid_bids
            WHERE deleted_at IS NULL AND bid_machine_id IN (?)
            GROUP BY bid_machine_id;";

        $res = $this->_db->fetchAll($this->_db->quoteInto($sql, $bid_machine_ids));

        $return = [];
        foreach ($res as $r) {
            $return[$r["bid_machine_id"]] = $r["c"];
        }

        return $return;
    }

    public function results_by_bid_machine_id($bid_open_id)
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
            WHERE bb.deleted_at IS NULL AND u.deleted_at IS NULL
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
        AND bm.bid_open_id = ?
        AND bb1.amount IS NOT NULL
        ORDER BY bm.id;";

        $res = $this->_db->fetchAll($this->_db->quoteInto($sql, $bid_open_id));

        $return = [];
        foreach ($res as $r) {
            $return[$r["id"]] = $r;
        }

        return $return;
    }
}

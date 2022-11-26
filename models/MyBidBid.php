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
    protected $_changeFilter = array('rules' => array(
        '商品ID'   => array('fields' => 'bid_machine_id', 'Digits', 'NotEmpty'),
        'ユーザID' => array('fields' => 'my_user_id', 'Digits', 'NotEmpty'),
        '入札金額' => array('fields' => 'amount', 'Digits', 'NotEmpty'),
        '備考欄'   => array('fields' => 'comment',),
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
}

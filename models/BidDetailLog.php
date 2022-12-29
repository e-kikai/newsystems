<?php

/**
 * 入札会詳細ログ
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/12/23
 */
class BidDetailLog extends MyTableAbstract
{
    protected $_name = 'bid_detail_logs';

    const ROBOTS     = "(goo|google|yahoo|naver|ahrefs|msnbot|bot|crawl|amazonaws|rate-limited-proxy|spider)";
    const RAND_STR   = 'abcdefghijklmnopqrstuvwxyz0123456789';
    const UTAG_SIZE = 12;

    // フィルタ条件
    protected $_insert_filter = array('rules' => array(
        '商品ID'   => array('fields' => 'bid_machine_id', 'Digits', 'NotEmpty'),
        'ユーザID' => array('fields' => 'my_user_id', 'Digits', 'NotEmpty'),
        'utag'     => array('fields' => 'utag'),
        'utag'     => array('fields' => 'utag'),
        'r'        => array('fields' => 'r', 'NotEmpty'),
        'リファラ' => array('fields' => 'referer'),
        'IP'       => array('fields' => 'ip'),
        'ホスト'   => array('fields' => 'host'),
    ));

    /**
     * utag設定
     *
     * @access public
     * @return this
     */
    public function set_utag()
    {
        // utagがない場合は、utagを設定する
        if (empty($_SESSION['utag'])) {
            $_SESSION['utag'] = substr(str_shuffle(str_repeat(BidDetailLog::RAND_STR, BidDetailLog::UTAG_SIZE)), 0, BidDetailLog::UTAG_SIZE);
        }

        if ()

        return this;
    }


}

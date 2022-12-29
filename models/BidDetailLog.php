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
    protected $_primary = 'id';

    const ROBOTS     = "(goo|google|yahoo|naver|ahrefs|msnbot|bot|crawl|amazonaws|rate-limited-proxy|spider)";
    const RAND_STR   = 'abcdefghijklmnopqrstuvwxyz0123456789';
    const UTAG_SIZE = 12;

    // フィルタ条件
    protected $_insert_filter = array('rules' => array(
        '商品ID'   => array('fields' => 'bid_machine_id', 'Digits', 'NotEmpty'),
        'ユーザID' => array('fields' => 'my_user_id', 'Digits'),
        'utag'     => array('fields' => 'utag'),
        'r'        => array('fields' => 'r'),
        'リファラ' => array('fields' => 'referer'),
        'IP'       => array('fields' => 'ip'),
        'ホスト'   => array('fields' => 'host'),
    ));

    public static function ip()
    {
        return isset($_SERVER["HTTP_X_FORWARDED_FOR"]) ? $_SERVER["HTTP_X_FORWARDED_FOR"] : $_SERVER["REMOTE_ADDR"];
    }

    /**
     * utag設定
     *
     * @access public
     * @return boolean IP,host,utagがあれば、true
     */
    public static function set_utag()
    {
        // IPチェック
        $ip = BidDetailLog::ip();
        if (empty($ip)) return false; // IP取得できない場合はfalse

        if (empty($_SESSION["ip"]) || $_SESSION["ip"] != $ip) {
            $_SESSION["ip"]   = $ip;
            $_SESSION["host"] = gethostbyaddr($ip);
        }
        if (empty($_SESSION["host"])) return false; // hostname取得できない場合はfalse

        if (preg_match('/(google|yahoo|naver|msnbot|ahrefs|baidu)/', $_SESSION["host"])) return false;

        // utagがない場合は、utagを設定する
        if (empty($_SESSION['utag'])) {
            $_SESSION['utag'] = substr(str_shuffle(str_repeat(BidDetailLog::RAND_STR, BidDetailLog::UTAG_SIZE)), 0, BidDetailLog::UTAG_SIZE);
        }

        return true;
    }

    /**
     * 機械IDごとのアクセス件数集計
     *
     * @access public
     * @param  array  $bid_machine_ids 集計する機械ID
     * @return array 機械IDごとのウォッチ件数
     */
    public function count_by_bid_machine_id($bid_machine_ids)
    {
        $sql = $this->_db->quoteInto("SELECT bid_machine_id, count(*) as c
    FROM bid_detail_logs
    WHERE bid_machine_id IN (?)
    GROUP BY bid_machine_id;", $bid_machine_ids);

        $res = $this->_db->fetchAll($sql);

        $return = [];
        foreach ($res as $r) {
            $return[$r["bid_machine_id"]] = $r["c"];
        }

        return $return;
    }
}

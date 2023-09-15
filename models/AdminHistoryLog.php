<?php

/**
 * 会員ページ機能ログモデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2023/08/03
 */
class AdminHistoryLog extends MyTableAbstract
{
    protected $_name    = 'admin_history_logs';
    protected $_primary = 'id';

    // フィルタ条件
    protected $_insert_filter = array('rules' => array());

    /// ログ書き込み ///
    public function write($user, $page, $event, $datas)
    {
        if (BidDetailLog::set_utag()) {
            $_conf = Zend_Registry::get('_conf');

            $this->my_insert(
                [
                    "company_id" => !empty($user['company_id']) ? $user['company_id'] : null,
                    "is_system"  => (!empty($user['role']) && $user['role'] == "system"),
                    "utag"       => $_SESSION["utag"],
                    "ip"         => $_SESSION["ip"],
                    "host"       => $_SESSION["host"],
                    "referer"    => str_replace($_conf->site_uri, "/", $_SERVER['HTTP_REFERER']),
                    "page"       => $page,
                    "event"      => $event,
                    "datas"      => json_encode($datas, JSON_UNESCAPED_UNICODE),
                ]
            );
        }
    }
}

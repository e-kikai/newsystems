<?php

/**
 * ユーザ入札取引モデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/24
 */
class MyBidTrade extends MyTableAbstract
{
    protected $_name = 'my_bid_trades';
    protected $_mailsend;
    protected $_smarty;

    function __construct()
    {
        /// メールサーバ設定 ///
        $conf = new Zend_Config_Ini(APP_PATH . '/config/mailsend.ini');
        $this->_mailConf = $conf->conf->toArray();

        /// メール送信クラス ///
        $this->_mailsend = new Mailsend();

        /// Smarty(本文生成用) ///
        $this->_smarty = Zend_Registry::get('smarty');

        parent::__construct();
    }

    // フィルタ条件
    protected $_insert_filter = array('rules' => array(
        '商品ID'   => array('fields' => 'bid_machine_id', 'Digits', 'NotEmpty'),
        'ユーザID' => array('fields' => 'my_user_id', 'Digits', 'NotEmpty'),
        '内容'     => array('fields' => 'comment', 'NotEmpty'),
        '回答'     => array('fields' => 'answer_flag'),
    ));

    /**
     * 取引投稿通知メール送信(ユーザ -> 出品会社)
     *
     * @access public
     * @param  array $my_user ユーザ
     * @param  array $company 会社情報
     * @param  array $bid_machine 商品情報
     * @param  array $comment 内容
     * @return boolean メール送信したらTrue
     */
    public function send_mail2company($my_user, $company, $bid_machine, $comment)
    {
        $subject = "マシンライフWeb入札会 : ユーザからの取引投稿のお知らせ - 管理番号 : ";
        $subject .= "{$bid_machine['list_no']}  {$bid_machine['name']}  {$bid_machine['maker']}  {$bid_machine['model']}";

        $body = $this->_smarty->assign(array(
            'my_user'     => $my_user,
            'company'     => $company,
            'bid_machine' => $bid_machine,
            'comment'     => $comment,
        ))->fetch("mail/trade2company.tpl");

        $this->_mailsend->sendMail($company["contact_mail"], $this->_mailConf['from_mail'], $body, $subject);
    }

    /**
     * 取引投稿通知メール送信(出品会社  -> ユーザ)
     *
     * @access public
     * @param  array $my_user ユーザ
     * @param  array $company 会社情報
     * @param  array $bid_machine 商品情報
     * @param  array $comment 内容
     * @return boolean メール送信したらTrue
     */
    public function send_mail2user($my_user, $company, $bid_machine, $comment)
    {
        $subject = "マシンライフWeb入札会 : 出品会社からの取引投稿のお知らせ - 管理番号 : ";
        $subject .= "{$bid_machine['list_no']}  {$bid_machine['name']}  {$bid_machine['maker']}  {$bid_machine['model']}";

        $body = $this->_smarty->assign(array(
            'my_user'     => $my_user,
            'company'     => $company,
            'bid_machine' => $bid_machine,
            'comment'     => $comment,
        ))->fetch("mail/trade2user.tpl");

        $this->_mailsend->sendMail($my_user["mail"], $this->_mailConf['from_mail'], $body, $subject);
    }
}

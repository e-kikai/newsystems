<?php
/**
 * 大宝機械サイトお問い合せ送信モデルクラス
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2012/04/13
 */
class DContact extends Zend_Db_Table_Abstract
{
    protected $_name = 'contacts';
    // protected $_mailsend;
    protected $_mailConf;
    // protected $_testFlag = false;

    function __construct()
    {
        //// メールサーバ設定 ////
        // $conf = new Zend_Config_Ini(APP_PATH . '/config/mailsend.ini');
        // $this->_mailConf = $conf->conf->toArray();
        $conf = new Zend_Config_Ini(APP_PATH . '/config/mailsend.ini');
        $this->_mailConf = $conf->conf->toArray();
        // $this->_testFlag = $conf->test;

        //// メール送信クラス ////
        // $this->_mailsend = new Mailsend();

        //// メール送信処理 ////
        $tr = new Zend_Mail_Transport_Smtp($this->_mailConf['server']['name'], $this->_mailConf['server']);
        Zend_Mail::setDefaultTransport($tr);

        parent::__construct();
    }

    // フィルタ条件
    protected $_filters = array('rules' => array(
        // 'お名前'           => array('fields' => 'user_name',     'NotEmpty'),
        // '会社名'           => array('fields' => 'user_company',),
        '会社名'           => array('fields' => 'user_company', 'NotEmpty'),
        '担当者名'         => array('fields' => 'user_name'),

        'TEL'              => array('fields' => 'tel',),
        'FAX'              => array('fields' => 'fax',),

        // 'メールアドレス'   => array('fields' => 'mail',          'NotEmpty', 'EmailAddress'),
        'メールアドレス'   => array('fields' => 'mail',          'NotEmpty'),
        '都道府県'         => array('fields' => 'addr1',),
        'お問い合わせ内容' => array('fields' => 'message',       'NotEmpty'),
        // 'お知らせメール'   => array('fields' => 'mailuser_flag',),

        '連絡方法'         => array('fields' => 'return',),
        // '時間帯'           => array('fields' => 'return_time',),

        '機械ID'           => array('fields' => 'machine_id', 'Int'),
        '会社ID'           => array('fields' => 'company_id', 'Int'),
        // 'ユーザID'         => array('fields' => 'user_id',    'Int'),
    ));

    /**
     * UTF-8をiso-2022-jpに変換
     *
     * @access protected
     * @param string $data 入力文字列
     * @return string 変換後の文字列
     */
    protected function _utf2iso($data)
    {
        return mb_convert_encoding($data, 'iso-2022-jp', 'UTF-8');
    }

    /**
     * 中古機械情報ページの問い合わせをセット、通知メールを送信
     *
     * @access public
     * @param  array $data 入力データ
     * @return $this
     */
    public function sendMachine($companyId, $data)
    {
        // メールブラックリスト
        if ($data['mail'] == '07.05.15.oga@gmail.com') { return $this; }

        /// 会社情報を取得 ///
        $companyTable = new Companies();
        $company      = $companyTable->get($companyId);
        /// dummy ///
        // $site_url = "https://www.zenkiren.net/system/playground/daihou/";
        // $site_url = "http://test-daihou.zenkiren.net";
        $site_url = "http://www.daihou.co.jp";
        $siteName = "{$company['company']} ウェブサイト";

        //// お問い合せ内容の整理 ////
        $d = array(
            'user_name'     => $data['name'],
            'user_company'  => $data['company'],
            'mail'          => $data['mail'],
            'tel'           => $data['tel'],
            'fax'           => $data['fax'],
            'return_time'   => $data['ret'],
            'message'       => $data['message'],
            // 'user_id'       => $data['user_id'],
            'addr1'         => $data['addr1'],
            // 'mailuser_flag' => $data['mailuser_flag'],
        );

        // お問い合わせ先
        $targets = '';

        /// 機械についての問い合わせ ///
        if (!empty($data['machineId'])) {
            // 対象が在庫機械の場合
            $where = $this->_db->quoteInto('m.id IN (?)', $data['machineId']);
            $sql = 'SELECT m.*, c.company, c.contact_mail FROM machines m LEFT JOIN companies c ON m.company_id = c.id WHERE ' . $where;

            $machineList = $this->_db->fetchAll($sql);
            if (empty($machineList)) {
                throw new Exception('お問い合わせ先の機械情報を取得できませんでした');
            }

            foreach($machineList as $m) {
                // 送信内容
                $body = <<< EOS
{$siteName}のお問い合せフォームから、
在庫機械についてのお問い合わせがありました。

＜お客様情報＞
会社名 : {$data['company']}
担当者名 : {$data['name']}
都道府県 : {$data['addr1']}
メールアドレス : {$data['mail']}
TEL : {$data['tel']}
FAX : {$data['fax']}
{$data['ret']}

＜お問い合わせ機械＞
管理番号 : {$m['no']}
{$m['name']} {$m['maker']} {$m['model']}
{$site_url}detail.php?m={$m['id']}

＜お問い合わせ内容＞
{$data['message']}


{$siteName}
{$site_url}
EOS;
                $subject = "{$siteName}: 中古機械についてのお問い合せ通知";

                //// メール送信・お問い合わせ内容の保存 ////
                // $this->_mailsend->sendMail($company['contact_mail'], $data['mail'], $body, $subject);
                $mail = new Zend_Mail('ISO-2022-JP');
                $mail->setFrom(
                    $this->_mailConf['from_mail'],
                    mb_encode_mimeheader($this->_utf2iso($siteName), 'iso-2022-jp')
                    )
                //   ->addTo(array($data['mail']))
                  ->addTo(array($company['contact_mail']))
                  ->setSubject($this->_utf2iso($subject))
                  ->setReplyTo($data['mail'])
                  ->setBodyText($this->_utf2iso($body))
                  ->send();

                $this->set($d + array('machine_id' => $m['id'], 'company_id' => $companyId));

                $targets.= "{$m['no']} {$m['name']} {$m['maker']} {$m['model']}\n";
            }
        } else {
            // 対象が会社
            $where = $this->_db->quoteInto('c.id IN (?)', $companyId);
            $sql = 'SELECT * FROM companies c WHERE ' . $where;

            $companyList = $this->_db->fetchAll($sql);
            if (empty($companyList)) {
                throw new Exception('お問い合わせ先の会社情報を取得できませんでした');
            }

            foreach($companyList as $c) {
                // 送信内容
                $body = <<< EOS
{$siteName}のお問い合せフォームから、
お問い合わせがありました。

＜お客様情報＞
会社名 : {$data['company']}
担当者名 : {$data['name']}
都道府県 : {$data['addr1']}
メールアドレス : {$data['mail']}
TEL : {$data['tel']}
FAX : {$data['fax']}
{$data['ret']}

＜お問い合わせ内容＞
{$data['message']}


{$siteName}
{$site_url}
EOS;
                $subject = "{$siteName}:お問い合せ通知";

                //// メール送信・お問い合わせ内容の保存 ////
                // $this->_mailsend->sendMail($company['contact_mail'], $data['mail'], $body, $subject);
                // $this->_mailsend->sendMail($data['mail'], $data['mail'], $body, $subject);
                $mail = new Zend_Mail('ISO-2022-JP');
                $mail->setFrom(
                    $this->_mailConf['from_mail'],
                    mb_encode_mimeheader($this->_utf2iso($siteName), 'iso-2022-jp')
                    )
                    //   ->addTo(array($data['mail']))
                    ->addTo(array($company['contact_mail']))
                    ->setSubject($this->_utf2iso($subject))
                    ->setReplyTo($data['mail'])
                    ->setBodyText($this->_utf2iso($body))
                    ->send();

                $this->set($d + array('machine_id' => NULL, 'company_id' => $companyId));

                $targets.= "{$c['company']}\n";

                // トラッキングログ(Web入札会用)
                // if (preg_match('/\/bid_detail.php\?m\=([0-9]+)/', $data['message'], $matches)) {
                //     $bmModel    = new BidMachine();
                //     $bidMachine = $bmModel->get($matches[1]);

                //     $tlModel = new TrackingLog();
                //     $tlModel->set(array(
                //         "bid_open_id"     => $bidMachine["bid_open_id"],
                //         "bid_machine_ids" => $bidMachine["id"],
                //         "contact_id"      => $this->_db->fetchOne("SELECT max(id) FROM contacts;"),
                //     ));
                // }

            }
        }

        //// お問い合わせ確認メール ////
        // 送信内容
        $body = <<< EOS
※ このメールは、自動返信メールです。
このメールに直接返信しないようお願いします。

{$data['name']}様

{$siteName}のお問い合せフォームから、
お問い合わせありがとうございました。

お問い合わせをましたので、
回答をしばらくお待ちください。

＜お問い合わせ内容＞
{$targets}

{$data['message']}

＜お客様情報＞
会社名 : {$data['company']}
担当者名 : {$data['name']}
都道府県 : {$data['addr1']}
メールアドレス : {$data['mail']}
TEL : {$data['tel']}
FAX : {$data['fax']}
{$data['ret']}


{$siteName}
{$site_url}
EOS;
        $subject = "{$siteName}:お問い合せ送信確認";
        // $this->_mailsend->sendMail($data['mail'], $this->_mailConf['from_mail'], $body, $subject);
        $mail = new Zend_Mail('ISO-2022-JP');
        $mail->setFrom(
            $this->_mailConf['from_mail'],
            mb_encode_mimeheader($this->_utf2iso($siteName), 'iso-2022-jp')
    )
          ->addTo(array($data['mail']))
          ->setSubject($this->_utf2iso($subject))
          ->setReplyTo($data['mail'])
          ->setBodyText($this->_utf2iso($body))
          ->send();

        return $this;
    }

    /**
     * お問い合わせデータ保存
     *
     * @access public
     * @param  string $data 内容
     * @return $this
     */
    public function set($data)
    {
        // フィルタリング・バリデーション
        $data = MyFilter::filtering($data, $this->_filters);

        // メールブラックリスト
        if ($data['mail'] == '07.05.15.oga@gmail.com') { return $this; }

        /// サイトフラグ ///
        $data["message"] = "<自社ウェブサイトからの問い合わせ>\n\n" . $data["message"] ;

        /// お問い合わせ内容の保存 ///
        if (!$result = $this->insert($data)) {
            throw new Exception('お問い合わせ情報が保存できませんでした');
        }

        // // /// Mailchimpリスト登録 ///
        // // if ($data["mailuser_flag"] == 1) {
        // //     $fModel      = new Flyer();
        // //     $json = array(
        // //         "email_address" => $data["mail"],
        // //         "status"        => "subscribed",
        // //         "merge_fields"  => array(
        // //             "FNAME" => $data["user_name"],
        // //             "LNAME" => $data["user_company"],
        // //         ),
        // //     );
        // //     $_mconf = new Zend_Config_Ini(APP_PATH . '/config/mailchimp.ini');

        // //     $res = $fModel->doAPI('lists/' . $_mconf->mailchimp_list_id . '/members/' . md5($data["mail"]), 'PUT', $json, $_mconf);
        // // }

        return $this;
    }
}

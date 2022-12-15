<?php

/**
 * お問い合せモデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
class Mailsend
{
    protected $_mailConf;
    protected $_testFlag = false;

    function __construct()
    {
        /// メールサーバ設定 ///
        $conf = new Zend_Config_Ini(APP_PATH . '/config/mailsend.ini');
        $this->_mailConf = $conf->conf->toArray();
        $this->_testFlag = $conf->test;

        /// メール送信処理 ///
        $tr = new Zend_Mail_Transport_Smtp($this->_mailConf['server']['name'], $this->_mailConf['server']);
        Zend_Mail::setDefaultTransport($tr);
    }

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
     * 汎用メール送信処理
     *
     * @access public
     * @param string $to 送信先
     * @param string $from 返信先
     * @param string $body 内容
     * @param string $subject タイトル
     * @return $this
     */
    public function sendMail($to, $from, $body, $subject, $file = null, $type = 'text')
    {
        // テスト用
        if ($this->_testFlag) {
            $to = 'bata44883@gmail.com';
            // $to = 'qqgx76kd@galaxy.ocn.ne.jp';
        }

        // メールブラックリスト
        if ($from == '07.05.15.oga@gmail.com') {
            return $this;
        }

        $mail = new Zend_Mail('ISO-2022-JP');
        $mail->setFrom(
            $this->_mailConf['from_mail'],
            mb_encode_mimeheader($this->_utf2iso($this->_mailConf['from']), 'iso-2022-jp')
        )
            ->addTo(array($to))
            ->setSubject($this->_utf2iso($subject));

        // HTMLメールかどうか
        if ($type == 'html') {
            $mail->setBodyHtml($this->_utf2iso($body));
        } else {
            $mail->setBodyText($this->_utf2iso($body));
        }

        // 返信元
        if (!empty($from)) {
            $mail->setReplyTo($from);
        }

        // 添付ファイル
        if (!empty($file) && !empty($file['tmp_name'])) {
            $fdata = file_get_contents($file['tmp_name']);

            // 添付データ作成
            $at = $mail->createAttachment($fdata);
            $at->type        = $file['type'];
            $at->filename    = $file['name'];
            $at->disposition = Zend_Mime::DISPOSITION_INLINE;
            $at->encoding    = Zend_Mime::ENCODING_BASE64;
        }

        // メール送信
        $mail->send();

        return $this;
    }
}

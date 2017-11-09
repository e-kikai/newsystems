<?php
/**
 * トラッキングユーザクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.1.0
 * @since 2016/06/14
 */
class TrackingUser extends MyTable
{
    protected $_name          = 'tracking_users';
    protected $_primary       = 'id';

    //// 共通設定 ////
    protected $_jname         = 'トラッキングユーザ';
    // protected $_view          = 'view_companysites';

    // protected $_filters       = array('rules' => array(
    //     '会社ID'       => array('fields' => 'company_id', 'Digits', 'NotEmpty'),
    //     'サブドメイン' => array('fields' => 'subdomain',  'Alnum',  'NotEmpty'),
    //     '閉鎖フラグ'   => array('fields' => 'closed',     'Digits'),
    // ));
    //
    // protected $_memberFilters = array('rules' => array(
    //     'ページ内容'   => array('fields' => 'contents',),
    //     'サイト設定郡' => array('fields' => 'page_configs',),
    //     '会社設定郡'   => array('fields' => 'company_configs',),
    //     'テンプレート' => array('fields' => 'template',),
    // ));

    /**
     * トラッキングコードをチェックし、なければ新規生成
     *
     * @access public
     * @return array   情報を1件取得した連想配列
     */
    public function checkTrackingTag()
    {
        if (!($hostname = self::checkRobot())) { return false; } // ロボットをエスケープ

        if (!empty($_COOKIE['tracking_tag'])) {
            $trackingTag = $_COOKIE['tracking_tag'];
            $res = self::getByTrackingTag($trackingTag);
        }

        // トラッキング情報がなければ新規作成
        if (empty($res)) {
            // リファラ、都道府県の処理はとりあえずスキップ
            $trackingTag = self::createTrackingTag();
            $data = array(
                'tracking_tag' => $trackingTag,
                'ip'           => $_SERVER['REMOTE_ADDR'],
                'hostname'     => $hostname,
            );

            parent::set(null, $data);

            $res = self::getByTrackingTag($trackingTag);
        }

        setcookie('tracking_tag', $trackingTag, time()+60*60*24*730);

        return $res;
    }

    /**
     * トラッキングコードからトラッキングユーザ情報を取得
     *
     * @access public
     * @param  intetger $trackingcode トラッキングコード
     * @return array   トラッキングユーザ情報を1件取得した連想配列
     */
    public function getByTrackingTag($trackingTag) {
      $sql = 'SELECT * FROM tracking_users WHERE tracking_tag = ?;';
      $res = $this->_db->fetchRow($sql, $trackingTag);
      return $res;
    }

    /**
     * トラッキングコードを生成
     *
     * @access public
     * @return string トラッキングコード
     */
    public function createTrackingTag()
    {
      return md5(uniqid(rand(),1));
    }

    /**
     * アクセスされたホストがロボットかどうかチェック
     *
     * @access public
     * @return ロボットであればfalse、なければstring ホスト名
     */
    public function checkRobot()
    {
        $hostname = gethostbyaddr($_SERVER['REMOTE_ADDR']);
        if (preg_match('/(google|yahoo|naver|msnbot|ahrefs|baidu)/', $hostname)) {
            return false;
        } else {
            return $hostname;
        }
    }
}

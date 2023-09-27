<?php

/**
 * 認証処理サービスクラス
 */
class MyAuth extends Zend_Db_Table
{
    protected $_name = 'my_users';
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

    /**
     * 認証情報を格納するセッション名前空間
     *
     * @access private static
     */
    private static $_namespace = 'my_user';

    /**
     * 認証失敗時にリダイレクトするURL
     *
     * @access private static
     */
    private static $_redirect = '/mypage/login.php';

    // TODO: passwd_remember_mail_send($account)
    // TODO: change_passwd_remember($account, $passwd, &passwd_check)

    /**
     * ログイン処理
     *
     * @access public
     * @param  string $account アカウント（メールアドレス）
     * @param  string $passwd パスワード
     *  @param boolean $check セッション永続化チェック
     * @return boolean ログインが成功すればtrue
     */
    public function login($mail, $passwd, $check = false)
    {
        // ログイン情報を取得
        $my_user_model = new MyUser();
        $result        = $my_user_model->get_by_mail($mail);

        // ログイン確認
        if (isset($result['id']) && sha1($passwd) == $result['passwd']) {
            // 認証されているか？
            if (empty($result["checkd_at"])) return false;

            // ログイン情報の保持（パスワードだけ除く）
            unset($result['passwd']);
            $_SESSION[self::$_namespace] = $result;

            // セッション永続化情報を入力
            $_SESSION['session_persistence'] = $check ? true : false;

            // 最終ログイン日時
            $_SESSION['session_last_login'] = time();

            return true;
        } else {
            return false;
        }
    }

    /**
     * パスワード変更処理
     *
     * @access public
     * @param  string  $account アカウント
     * @param  string  $nowPasswd 現在のパスワード
     * @param  string  $passwd 変更するパスワード
     * @param  string  $passwdChk 確認パスワード
     * @return $this
     */
    public function changePasswd($account, $nowPasswd, $passwd, $passwdChk)
    {
        // アカウントチェック
        if ($_SESSION[self::$_namespace]['mail'] != $mail) {
            throw new Exception('現在のメールアドレス、パスワードが正しくありません');
        }

        // 現在のパスワードでログインチェック
        if ($this->login($account, $nowPasswd) != true) {
            throw new Exception('現在のアカウント、パスワードが正しくありません2');
        }

        // パスワードチェック
        if (!preg_match('/^[a-zA-Z0-9@.+-]*$/', $passwd)) {
            throw new Exception('パスワードには英数字のみ使用できます');
        } else if ($passwd != $passwdChk) {
            throw new Exception('新しいパスワードと、確認パスワードが違います');
        }

        // パスワード更新
        $res = $this->_db->update(
            'my_users',
            array('passwd' => $passwd),
            $this->_db->quoteInto('id = ?', $_SESSION[self::$_namespace]['id'])
        );
        if (!$res) {
            throw new Exception('パスワード変更処理が失敗しました');
        }

        return $this;
    }

    /**
     * 認証処理
     *
     * @access public static
     * @param  string  $return 非認証時、リダイレクトするURL
     * @return boolean ログインしていれば、認証ユーザ情報
     */
    public static function is_auth($return = NULL)
    {
        // 認証失敗で、ログインページにリダイレクト
        if (MyAuth::check() == false) {
            $redirect = !empty($return) ? $return : self::$_redirect;
            $_SESSION["flash_alert"] = "マイページにログインしていません。";
            header('Location: ' . $redirect);
            exit;
        }
    }

    /**
     * 認証チェック
     *
     * @access public static
     * @return boolean 認証成功でTRUE
     */
    public static function check()
    {
        return isset($_SESSION[self::$_namespace]) ? true : false;
    }

    /**
     * 認証情報の取得
     *
     * @access public static
     * @return ログインしていれば、認証ユーザ情報
     */
    public static function get_user()
    {
        if (isset($_SESSION[self::$_namespace]['id'])) {
            return $_SESSION[self::$_namespace];
        }
    }

    /**
     * ログアウト処理
     *
     * @access public static
     * @return boolean ログアウトすればtrue
     */
    public static function logout()
    {
        // // セッション変数を全て解除する
        // $_SESSION = array();

        // // セッションを切断するにはセッションクッキーも削除する
        // // Note: セッション情報だけでなくセッションを破壊する
        // if (isset($_COOKIE[session_name()])) {
        //     setcookie(session_name(), '', time() - 42000, '/');
        // }

        // // 最終的に、セッションを破壊する
        // session_destroy();
        // return true;

        // MyAuthが追加されたためsession_destroyまではしない
        if (isset($_SESSION[self::$_namespace])) {
            unset($_SESSION[self::$_namespace]);
            return true;
        } else {
            return false;
        }
    }

    /**
     * 非ログイン時のリダイレクト先を設定
     *
     * @access public static
     * @param  string $url リダイレクト先URL
     */
    public static function set_redirect($url)
    {
        self::$_redirect = $url;
    }

    /**
     * リダイレクト先を取得
     *
     * @access public static
     * @return string $namespace リダイレクト先
     */
    public static function get_redirect()
    {
        return self::$_redirect;
    }

    /**
     * ユーザ情報を保存するセッション名前空間を設定
     *
     * @access public static
     * @param string $namespace セッション名前空間
     */
    public static function setNamespace($namespace)
    {
        self::$_namespace = $namespace;
    }

    /**
     * ユーザ情報を保存するセッション名前空間を取得
     *
     * @access public static
     * @return string $namespace セッション名前空間
     */
    public static function getNamespace()
    {
        return self::$_namespace;
    }

    /**
     * 管理者の代理ログイン処理
     *
     * @access public
     * @param  int $my_user_id 代理ログインするユーザID）
     * @return boolean ログインが成功すればtrue
     */
    public function system_login($my_user_id)
    {
        // 代理ログイン
        $my_user_model = new MyUser();
        $my_user = $my_user_model->get($my_user_id);

        if (empty($my_user)) {
            throw new Exception('ユーザ情報が取得出来ませんでした id:' . $my_user_id);
        }

        $_SESSION[self::$_namespace]['my_user_id'] = $my_user['id'];
        $_SESSION[self::$_namespace]['name']       = $my_user['name'];
        $_SESSION[self::$_namespace]['company']    = $my_user['company'];

        // 最終ログイン日時
        $_SESSION['session_last_login'] = time();

        return true;
    }

    /**
     * 登録確認メール送信
     *
     * @access public
     * @param  int $data メール送信するユーザのメールアドレス
     * @return boolean メール送信したらTrue
     */
    public function send_confirmation_mail($mail)
    {
        $my_user_model = new MyUser();
        $my_user = $my_user_model->get_by_mail($mail);

        if (!empty($data["checked_at"])) {
            throw new Exception("メールアドレスの確認は既に行われています。");
        }

        $subject = "マシンライフWeb入札会 : 登録確認メール";
        $body    = $this->_smarty->assign(array(
            'my_user' => $my_user,
        ))->fetch("mail/sign_up_confirmation.tpl");

        $this->_mailsend->sendMail($mail, $this->_mailConf['from_mail'], $body, $subject);
    }

    /**
     * パスワード変更メール送信
     *
     * @access public
     * @param  int $data メール送信するユーザのメールアドレス
     * @return boolean メール送信したらTrue
     */
    public function send_passwd_remember_mail($mail)
    {
        $my_user_model = new MyUser();
        $my_user = $my_user_model->get_by_mail($mail);

        $subject = "マシンライフWeb入札会 : 登録確認メール";
        $body    = $this->_smarty->assign(array(
            'my_user' => $my_user,
        ))->fetch("mail/passwd_remember.tpl");

        $this->_mailsend->sendMail($mail, $this->_mailConf['from_mail'], $body, $subject);
    }

    /**
     * google reCaptcha確認
     *
     * @access public
     * @param  string $response 取得したパラメータ
     * @param  string $secret   シークレットキー
     * @return boolean 認証結果
     */
    public function check_recaptcha($response, $secret)
    {
        $url = 'https://www.google.com/recaptcha/api/siteverify';

        //パラメータを指定
        $data = array(
            'secret'   => $secret,
            'response' => $response,
        );

        $context = array(
            'http' => array(
                // POST メソッドを指定
                'method'  => 'POST',
                'header'  => implode("\r\n", array('Content-Type: application/x-www-form-urlencoded',)),
                'content' => http_build_query($data)
            )
        );

        $api_response = file_get_contents($url, false, stream_context_create($context));

        $obj = json_decode($api_response);

        return $obj->success;
    }


    /**
     * 認証処理
     *
     * @access public
     * @param  string $account ユーザID
     * @param  string $token 認証トークン
     * @return boolean ログインが成功すればtrue
     */
    public function confirmation($id, $token)
    {
        // ログイン情報を取得
        $my_user_model = new MyUser();
        $my_user       = $my_user_model->get($id);

        // 認証処理
        if ($this->check_token($id, $token)) {
            if (empty($my_user["checkd_at"])) {
                $my_user_model->update(
                    array('checkd_at' => new Zend_Db_Expr('current_timestamp')),
                    array(
                        $this->_db->quoteInto(' id = ? ', $my_user['id'])
                    )
                );
            }

            return true;
        } else {
            return false;
        }
    }

    /**
     * トークンチェック処理
     *
     * @access public
     * @param  string $account ユーザID
     * @param  string $token 認証トークン
     * @return boolean ログインが成功すればtrue
     */
    public function check_token($id, $token)
    {
        $my_user_model = new MyUser();
        $my_user       = $my_user_model->get($id);

        // 認証処理
        return isset($my_user['id']) && $token == $my_user['check_token'];
    }

    /**
     * 管理者の代理ログイン処理
     *
     * @access public
     * @param  string $companyId 代理ログインする会社ID）
     * @return boolean ログインが成功すればtrue
     */
    public function systemLogin($my_user_id)
    {
        // 代理ログイン
        // ログイン情報を取得
        $my_user_model = new MyUser();
        $my_user = $my_user_model->get($my_user_id);

        if (empty($my_user)) throw new Exception('ユーザ情報が取得出来ませんでした id:' . $my_user_id);

        // ログイン情報の保持（パスワードだけ除く）
        unset($my_user['passwd']);
        $_SESSION[self::$_namespace] = $my_user;

        // 最終ログイン日時
        $_SESSION['session_last_login'] = time();

        return true;
    }
}

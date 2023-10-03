<?php

/**
 * 認証処理モデルクラス
 */
class Auth extends Zend_Db_Table_Abstract
{
    protected $_name = 'user';

    /**
     * 認証情報を格納するセッション名前空間
     *
     * @access private static
     */
    private static $_namespace = 'user';

    /**
     * 認証失敗時にリダイレクトするURL
     *
     * @access private static
     */
    private static $_redirect = '/login.php';

    /**
     * ログイン処理
     *
     * @access public
     * @param  string $account アカウント（メールアドレス）
     * @param  string $passwd パスワード
     *  @param boolean $check セッション永続化チェック
     * @return boolean ログインが成功すればtrue
     */
    public function login($account, $passwd, $check = false)
    {
        // ログイン情報を取得
        $sql = 'SELECT * FROM users WHERE deleted_at IS NULL AND account = ? AND passwd = ? LIMIT 1;';
        // $result = $this->_db->fetchRow($sql, array($account, hash('sha512', $passwd)));
        $result = $this->_db->fetchRow($sql, array($account, $passwd));

        if (isset($result['id'])) {
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
        if ($_SESSION[self::$_namespace]['account'] != $account) {
            throw new Exception('現在のアカウント、パスワードが正しくありません');
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
            'users',
            array('passwd' => $passwd, "passwd_changed_at" => new Zend_Db_Expr('current_timestamp')),
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
     * @param  string  $area 認証エリア
     * @param  string  $return 非認証時、リダイレクトするURL
     * @return boolean ログインしていれば、認証ユーザ情報
     */
    public static function isAuth($area = NULL, $return = NULL)
    {
        // ACL設定
        $acl = self::getAclInstance();

        // roleの設定
        if (isset($_SESSION[self::$_namespace]['role'])) {
            $role = $_SESSION[self::$_namespace]['role'];
            $code = 4;
        } else {
            $role = 'guest';
            $code = 2;
        }

        // 認証
        if (!$acl->isAllowed($role, $area)) {
            $redirect = !empty($return) ? $return : self::$_redirect;
            header('Location: ' . $redirect . '?e=' . $code);
            exit;
        }

        // 会員メニューのみ、3時間でログイン認証を行う
        if ($area == 'member' && empty($_SESSION['session_persistence'])) {
            if ($_SESSION['session_last_login'] < strtotime('-3 hours')) {
                $redirect = !empty($return) ? $return : self::$_redirect;
                header('Location: ' . $redirect . '?e=5');
                exit;
            } else {
                // ログイン日時の更新
                $_SESSION['session_last_login'] = time();
            }
        }
    }

    public static function check($area = NULL)
    {
        // ACL設定
        $acl = self::getAclInstance();

        // roleの設定
        if (isset($_SESSION[self::$_namespace]['role'])) {
            $role = $_SESSION[self::$_namespace]['role'];
        } else {
            $role = 'guest';
        }

        return $acl->isAllowed($role, $area);
    }

    /**
     * ACLを設定
     * @access public static
     * @return Zend_Acl インスタンス
     */
    public static function getAclInstance()
    {
        $acl = new Zend_Acl();
        $acl->addResource('catalog') // 電子カタログ
            ->addResource('eips')    // EIPS
            ->addResource('machine') // 在庫ページ
            ->addResource('mylist')  // 在庫ページ：マイリスト
            ->addResource('member')  // 会員ページ
            ->addResource('system')  // 管理者ページ

            ->addRole('guest')            // ゲスト(非ログイン)
            ->addRole('user',   'guest')  // 非会員ユーザ
            ->addRole('catalog', 'user')   // カタログ限定ユーザ
            ->addRole('member', 'catalog') // 会員
            ->addRole('system', 'member') // 管理者

            ->allow('guest', 'machine') // テスト時期のみ

            // ->allow('user',   'machine')  // テスト時期のみ
            ->allow('user',   'mylist')

            ->allow('catalog', 'catalog')

            ->allow('member', 'eips')
            ->allow('member', 'member')

            ->allow('system', 'system');
        return $acl;
    }

    /**
     * 認証情報の取得
     *
     * @access public static
     * @return ログインしていれば、認証ユーザ情報
     */
    public static function getUser()
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
    public static function setRedirect($url)
    {
        self::$_redirect = $url;
    }

    /**
     * リダイレクト先を取得
     *
     * @access public static
     * @return string $namespace リダイレクト先
     */
    public static function getRedirect()
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
     * @param  string $companyId 代理ログインする会社ID）
     * @return boolean ログインが成功すればtrue
     */
    public function systemLogin($companyId)
    {
        // 代理ログイン
        $cModel = new Company();
        $company = $cModel->get($companyId);

        if (empty($company)) {
            throw new Exception('会社情報が取得出来ませんでした id:' . $companyId);
        }

        $_SESSION[self::$_namespace]['company_id'] = $company['id'];
        $_SESSION[self::$_namespace]['company']    = $company['company'];

        // 最終ログイン日時
        $_SESSION['session_last_login'] = time();

        return true;
    }
}

<?php

/**
 * 入札会ユーザモデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/16
 */
class MyUser extends MyTableAbstract
{
  protected $_name = 'my_users';

  const SYSTEM_MY_USER_ID = 2;
  const RAND_STR = 'abcdefghijklmnopqrstuvwxyz0123456789';

  // フィルタ条件
  protected $_insert_filter = array('rules' => array(
    '*'          => array(),

    '氏名'     => array('fields' => 'name', 'NotEmpty'),
    'TEL'        => array('fields' => 'tel', 'NotEmpty'),
    '〒'               => array('fields' => 'zip', 'NotEmpty'),
    '住所(都道府県)'   => array('fields' => 'addr_1', 'NotEmpty'),
    '住所(市区町村)'   => array('fields' => 'addr_2', 'NotEmpty'),
    '住所(番地その他)' => array('fields' => 'addr_3', 'NotEmpty'),

    'メールアドレス'   => array('fields' => 'mail', 'NotEmpty'),
  ));

  protected $_update_filter = array('rules' => array(
    '*'          => array(),

    '氏名'     => array('fields' => 'name', 'NotEmpty'),
    'TEL'        => array('fields' => 'tel', 'NotEmpty'),
    '〒'               => array('fields' => 'zip', 'NotEmpty'),
    '住所(都道府県)'   => array('fields' => 'addr_1', 'NotEmpty'),
    '住所(市区町村)'   => array('fields' => 'addr_2', 'NotEmpty'),
    '住所(番地その他)' => array('fields' => 'addr_3', 'NotEmpty'),
  ));

  /**
   * 情報をinsert(オーバーライド)
   *
   * @access public
   * @param array $data 入力データ
   * @return      $this
   */
  public function my_insert($data)
  {
    $data = $this->insert_filtering($data);

    // $data = array_merge($this->_default_data, $data); // 初期値
    // $data["uniq_account"] = uniqid("", 1);
    $data["uniq_account"] = MyUser::generate_uniq_account();
    $data["check_token"]  = sha1(uniqid(mt_rand(), true));
    $data["passwd"]       = sha1($data["passwd"]);

    $res = $this->insert($data);

    if (empty($res)) throw new Exception('情報が保存できませんでした。');

    return $this;
  }

  /**
   * メールアドレスからユーザ情報を取得(認証用)
   *
   * @access public
   * @param  string $mail メールアドレス
   * @return array  ユーザ情報を取得
   */
  public function get_by_mail($mail)
  {
    if (empty($mail)) throw new Exception('取得するメールアドレスがありません。');

    $select = $this->my_select()->where("mail = ?", $mail);
    $result = $this->fetchRow($select);

    return $result;
  }

  /**
   * パスワードを変更処理
   *
   * @access public
   * @param  string $passwd パスワード
   * @param  int   $my_user_id ユーザID
   * @return array  $this
   */
  public function update_passwd($passwd, $my_user_id)
  {
    $res = $this->update(
      [
        "passwd"     => sha1($passwd),
        "changed_at" => new Zend_Db_Expr('current_timestamp'),
      ],
      $this->_db->quoteInto("my_users.id = ?", $my_user_id)
    );

    if (empty($res)) throw new Exception('パスワードが保存できませんでした。');

    return $this;
  }

  /**
   * ユニークアカウントを生成
   *
   * @access  public
   * @return string  ユニークアカウント(10桁)
   */
  static public function generate_uniq_account()
  {
    return substr(str_shuffle(str_repeat(MyUser::RAND_STR, 10)), 0, 10);
  }
}

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

  // フィルタ条件
  protected $_change_filter = array('rules' => array(
    '*'          => array(),

    '氏名'     => array('fields' => 'name', 'NotEmpty'),
    // '会社名'     => array('fields' => 'company'),

    'TEL'        => array('fields' => 'tel', 'NotEmpty'),
    // 'FAX'        => array('fields' => 'fax'),

    '〒'               => array('fields' => 'zip', 'NotEmpty'),
    '住所(都道府県)'   => array('fields' => 'addr_1', 'NotEmpty'),
    '住所(市区町村)'   => array('fields' => 'addr_2', 'NotEmpty'),
    '住所(番地その他)' => array('fields' => 'addr_3', 'NotEmpty'),

    'メールアドレス'   => array('fields' => 'mail', 'NotEmpty'),
    // 'パスワード'       => array('fields' => 'passwd', 'NotEmpty'),

    // 'ユニークアカウント' => array('fields' => 'uniq_account', 'NotEmpty'),
    // '認証用トークン'     => array('fields' => 'check_token', 'NotEmpty'),
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
    $data = $this->filtering($data);

    // $data = array_merge($this->_default_data, $data); // 初期値
    $data["uniq_account"] = uniqid("", 1);
    $data["check_token"]  = sha1(uniqid(mt_rand(), true));
    $data["passwd"]       = sha1($data["passwd"]);

    $res = $this->insert();

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
}

<?php

/**
 * 入札会ユーザモデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/16
 */
class MyUser extends Zend_Db_Table_Abstract
{
  protected $_name = 'my_users';

  // フィルタ条件
  protected $_changeFilter = array('rules' => array(
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
   * ユーザ情報をセット
   *
   * @access public
   * @param array   $data 入力データ
   * @param int     $id   ユーザID
   * @return        $this
   */
  public function set($data, $id = null)
  {
    // フィルタリング・バリデーション
    $data = MyFilter::filter($data, $this->_changeFilter);

    if (empty($id)) {
      // 新規処理
      // 認証トークン、ユニークアカウントを生成
      $data["uniq_account"] = uniqid("", 1);
      $data["check_token"]  = sha1(uniqid(mt_rand(), true));
      $data["passwd"]       = sha1($data["passwd"]);

      $res = $this->insert($data);
    } else {
      // 更新処理
      // if (!empty($data["uniq_account"])) $data["passwd"] = sha1($data["passwd"]);
      $data['changed_at'] = new Zend_Db_Expr('current_timestamp');

      $res = $this->update($data, $this->_db->quoteInto('id = ?', $id));
    }

    if (empty($res)) throw new Exception('ユーザ情報が保存できませんでした。');

    return $this;
  }

  /**
   * 入札会ユーザ一覧を取得
   *
   * @access public
   * @param  mixed  $q 検索クエリ
   * @return array メンバー一覧
   */
  public function getList($q = NULL)
  {
    $where = ' mu.deleted_at IS NULL '; // 条件クエリ
    if (!empty($q['id'])) {
      $where .= $this->_db->quoteInto(' AND c.id IN (?) ', $q['id']);
    }

    $order = "mu.id DESC"; // 並び替えクエリ

    // SQLクエリを作成
    $sql    = "SELECT * FROM my_users mu WHERE {$where} ORDER BY {$order};";
    $result = $this->_db->fetchAll($sql);
    if (empty($result)) {
      throw new Exception('ユーザ情報を取得できませんでした');
    }

    return $result;
  }

  /**
   * ユーザ情報を取得
   *
   * @access public
   * @param  string $id ユーザID
   * @return array  ユーザ情報を取得
   */
  public function get($id)
  {
    /// メンバ情報を取得 ///
    if (!intval($id)) throw new Exception('取得するユーザIDがありません。');

    // SQLクエリを作成
    $sql    = 'SELECT * FROM my_users WHERE deleted_at IS NULL AND id = ?';
    $result = $this->_db->fetchRow($sql, intval($id));

    if (empty($result)) throw new Exception('ユーザ情報を取得できませんでした。');

    return $result;
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
    /// メンバ情報を取得 ///
    if (empty($mail)) throw new Exception('取得するメールアドレスがありません。');

    // SQLクエリを作成
    $sql    = 'SELECT * FROM my_users WHERE deleted_at IS NULL AND mail = ?';
    $result = $this->_db->fetchRow($sql, $mail);

    return $result;
  }

  /**
   * ユーザ情報を論理削除
   *
   * @access public
   * @param  array $id ユーザID
   * @return $this
   */
  public function delete_by_id($id)
  {
    if (empty($id)) throw new Exception('削除するユーザIDが設定されていません');

    $this->update(
      array('deleted_at' => new Zend_Db_Expr('current_timestamp')),
      array(
        $this->_db->quoteInto(' id IN(?) ', $id)
      )
    );

    return $this;
  }
}

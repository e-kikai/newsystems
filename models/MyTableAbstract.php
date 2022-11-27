<?php

/**
 *  テーブルベースクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/16
 */
class MyTableAbstract extends Zend_Db_Table_Abstract
{

  // フィルタ条件
  protected $_insert_filter = ['rules' => []];
  protected $_update_filter = ['rules' => []];

  protected $_default_data  = [];

  /**
   * 論理削除込のセレクト生成
   *
   * @access public
   * @return        deleted_at含むセレクト
   */
  public function my_select()
  {
    return $this->select()->setIntegrityCheck(false)
      ->from($this->_name, '*')
      ->where("{$this->_name}.deleted_at IS NULL")->order("{$this->_name}.id DESC");
  }

  /**
   * IDから情報を取得(論理削除込)
   *
   * @access public
   * @param  string $id 取得するID
   * @return array  ユーザ情報を取得
   */
  public function get($id)
  {
    /// メンバ情報を取得 ///
    if (!intval($id)) throw new Exception('取得するIDがありません。');

    $select = $this->my_select()->where("{$this->_name}.id = ?", $id);
    $result = $this->fetchRow($select);

    if (empty($result)) throw new Exception('情報を取得できませんでした。');

    return $result;
  }

  /**
   * 登録用フィルタリング・バリデーション
   *
   * @access public
   * @param array   $data 入力データ
   * @return array フィルタリング後のデータ
   */
  public function insert_filtering($data)
  {
    return MyFilter::filter($data, $this->_insert_filter);
  }

  /**
   * 更新用フィルタリング・バリデーション
   *
   * @access public
   * @param array   $data 入力データ
   * @return array フィルタリング後のデータ
   */
  public function update_filtering($data)
  {
    return MyFilter::filter($data, $this->_update_filter);
  }

  /**
   * 情報をセット
   *
   * @access public
   * @param array   $data 入力データ
   * @param int     $id   ID
   * @return        $this
   */
  public function set($data, $id = null)
  {
    if (empty($id)) {
      $this->my_insert($data);  // 新規処理
    } else {
      $this->my_update($data, $id); // 更新処理
    }

    return $this;
  }

  /**
   * 情報をinsert
   *
   * @access public
   * @param array $data 入力データ
   * @return      $this
   */
  public function my_insert($data)
  {
    $data = $this->insert_filtering($data);

    $data = array_merge($this->_default_data, $data); // 初期値

    $res = $this->insert($data);

    if (empty($res)) throw new Exception('情報が保存できませんでした。');

    return $this;
  }

  /**
   * 情報をupdate
   *
   * @access public
   * @param array $data 入力データ
   * @param int   $id   ID
   * @return      $this
   */
  public function my_update($data, $id)
  {
    $data = $this->update_filtering($data);

    $data['changed_at'] = new Zend_Db_Expr('current_timestamp'); // 更新日時

    $res = $this->update($data, $this->_db->quoteInto("{$this->_name}.id = ?", $id));

    if (empty($res)) throw new Exception('情報が保存できませんでした。');

    return $this;
  }

  /**
   * 情報を論理削除
   *
   * @access public
   * @param  array $id ID
   * @return $this
   */
  public function my_delete($id)
  {
    if (empty($id)) throw new Exception('削除するIDがありません。');

    $this->update(
      array('deleted_at' => new Zend_Db_Expr('current_timestamp')),
      array(
        $this->_db->quoteInto(" {$this->_name}.id IN (?) ", $id)
      )
    );

    return $this;
  }
}

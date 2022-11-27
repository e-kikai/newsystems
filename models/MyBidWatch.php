<?php

/**
 * ユーザ入札ウォッチリストモデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/24
 */
class MyBidWatch extends MyTableAbstract
{
  protected $_name = 'my_bid_watches';

  // フィルタ条件
  protected $_insert_filter = array('rules' => array(
    '商品ID'   => array('fields' => 'bid_machine_id', 'Digits', 'NotEmpty'),
    'ユーザID' => array('fields' => 'my_user_id', 'Digits', 'NotEmpty'),
  ));


  /**
   * ユーザと入札機械IDから1件取得
   *
   * @access public
   * @param  int   $my_user_id      ユーザID
   * @param  int   $bid_machine_id  入札機械ID
   * @return array ウォッチ情報
   */
  public function get_by_user_machine($my_user_id, $bid_machine_id)
  {
    if (empty($my_user_id) || empty($bid_machine_id)) {
      $res = [];
    } else {
      $select = $this->my_select()
        ->where("my_user_id = ?", $my_user_id)
        ->where("bid_machine_id = ?", $bid_machine_id);
      $res = $this->fetchRow($select);
    }

    return $res;
  }
}

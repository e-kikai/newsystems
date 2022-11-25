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
  protected $_changeFilter = array('rules' => array(
    '商品ID'   => array('fields' => 'bid_machine_id', 'Digits', 'NotEmpty'),
    'ユーザID' => array('fields' => 'my_user_id', 'Digits', 'NotEmpty'),
  ));
}

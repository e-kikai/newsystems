<?php

/**
 * ユーザ入札取引モデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/24
 */
class MyBidTrade extends MyTableAbstract
{
  protected $_name = 'my_bid_trades';

  // フィルタ条件
  protected $_insert_filter = array('rules' => array(
    '商品ID'   => array('fields' => 'bid_machine_id', 'Digits', 'NotEmpty'),
    'ユーザID' => array('fields' => 'my_user_id', 'Digits', 'NotEmpty'),
    '内容'     => array('fields' => 'comment', 'NotEmpty'),
  ));
}

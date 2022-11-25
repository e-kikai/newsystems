<?php

/**
 * ユーザ入札モデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/11/16
 */
class MyBidBid extends MyTableAbstract
{
  protected $_name = 'my_bid_bids';

  // フィルタ条件
  protected $_changeFilter = array('rules' => array(
    '商品ID'   => array('fields' => 'bid_machine_id', 'Digits', 'NotEmpty'),
    'ユーザID' => array('fields' => 'my_user_id', 'Digits', 'NotEmpty'),
    '入札金額' => array('fields' => 'amount', 'Digits', 'NotEmpty'),
    '備考欄'   => array('fields' => 'comment',),
  ));
}

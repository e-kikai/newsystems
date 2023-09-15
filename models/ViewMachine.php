<?php

/**
 * 閲覧用在庫機械情報モデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2023/06/13
 */
class ViewMachine extends MyTableAbstract
{
    protected $_name = 'view_machines';

    // フィルタ条件
    // protected $_insert_filter = array('rules' => array(
    //   '商品ID'   => array('fields' => 'bid_machine_id', 'Digits', 'NotEmpty'),
    //   'ユーザID' => array('fields' => 'my_user_id', 'Digits', 'NotEmpty'),
    // ));

    /// チャットボット用検索SELECT初期化 ///
    function select_base()
    {
        return $this->_db->select()
            // ->setIntegrityCheck(false)
            ->from("view_machines as vm", null)
            ->where("vm.deleted_at IS NULL");
    }

    /// 登録履歴用検索SELECT初期化 ///
    function select_base_all()
    {
        return $this->_db->select()
            ->from("view_machines as vm", null);
    }
}

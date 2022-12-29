<?php

/**
 * 凍結解除処理
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2022/12/28
 */

require_once '../../../lib-machine.php';

/// 認証処理 ///
Auth::isAuth('system');

/// 変数を取得 ///
$my_user_id = Req::post('id');

/// 凍結解除処理 ///
$my_user_model = new MyUser();
$res = $my_user_model->update(
  [
    "freezed_at" => null,
    "changed_at" => new Zend_Db_Expr('current_timestamp'),
  ],
  $_db->quoteInto("my_users.id = ?", $my_user_id)
);

$_SESSION["flash_notice"] = "凍結を解除しました。";

header('Location: /system/my_users/');
exit;

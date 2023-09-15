<?php

/**
 * ユーザマイページトップページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2023/06/05
 */

require_once '../../../lib-machine.php';
try {
    // 状態リセット
    $_SESSION["chat_query"] = [];

    $machine_model = new Machine();
    // $count_select = $machine_model->select()->setIntegrityCheck(false)
    $count_select = $_db->select()
        ->from("view_machines as vm", null)
        ->where("vm.deleted_at IS NULL")
        ->columns("count(vm.id) as co");

    $count = $_db->fetchOne($count_select);

    // // 特大ジャンル一覧取得
    // $xl_select = $machine_model->select()->setIntegrityCheck(false)
    //     ->from("xl_genres as xl", ["id", "xl_genre"])
    //     ->where("xl.deleted_at IS NULL")
    //     ->where("xl.id < 6")
    //     ->order("order_no ASC");
    // $xl_genres = $_db->fetchAll($xl_select);

    // $selectors = [];
    // foreach ($xl_genres as $xl) {
    //     $selectors[$xl["xl_genre"]] = [
    //         "action" => "add",
    //         "target" => "xl_genre",
    //         "value"  => $xl["id"],
    //     ];
    // }

    $selectors = [
        "商品をさがす" => [
            "action" => "add",
            "target" => "machines_category",
            "value"  => 1,
        ],
        "一週間の新着を見る" => [
            "action" => "add",
            "target" => "news",
            "value"  => "-7day",
        ],
        "本日の新着を見る" => [
            "action" => "add",
            "target" => "news",
            "value"  => "-1day",
        ],
    ];

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle'       => "マシンライフ チャットボット(beat)",
        // 'pageDescription' => "Web入札会へようこそ {$my_user->company} {$my_user->name} さん。",

        "messages" => [
            [
                "player"    => "bot",
                "content"   => "ようこそマシンライフへ。\nどんな商品をおさがしですか？" . number_format($count) . "件",
                "selectors" => $selectors,
            ],
        ],
    ))->display('_pg/chatbot/index.tpl');
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => "マシンライフ チャットボット(beat)",
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}

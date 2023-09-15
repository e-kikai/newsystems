<?php

/**
 * 出品履歴ページ
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2023/06/05
 */

require_once '../../../lib-machine.php';
try {
    /// 認証 ///
    Auth::isAuth('member');

    if (!Company::check_sp($_user["company_id"])) throw new Exception("このページの閲覧権限がありません。");

    /// セレクタ ///
    $range_selector = [
        "2年以内" => "2",
        "3年以内" => "3",
        "4年以内" => "4",
        "5年以内" => "5",
        "6年以内" => "6",
        "7年以内" => "7",
        "全期間"  => "99",
    ];

    /// 変数取得 ///
    $machine_id = !empty($_GET["id"]) ? $_GET["id"] : "";
    $maker      = !empty($_GET["maker"]) ? $_GET["maker"] : "";
    $model      = !empty($_GET["model"]) ? $_GET["model"] : "";
    $model      = preg_replace("/[^0-9A-Za-z]/", "", mb_strtoupper(mb_convert_kana($model, "KVa")));
    $range      = !empty($_GET["range"]) && in_array($_GET["range"], $range_selector) ? $_GET["range"] : "2";

    // if (empty($machine_id)) throw new Exception("機械IDがありません。");

    // ジャンル
    $xg_select = $_db->select()->from("xl_genres as xg")
        ->where("xg.deleted_at IS NULL")
        ->where("xg.id <= ?", XlGenres::MACHINE_ID_LIMIT)
        ->order("xg.order_no");
    // echo ($xg_select->__toString());
    $xl_genres = $_db->fetchAll($xg_select);

    $lg_select = $_db->select()->from("large_genres as lg")
        ->where("lg.deleted_at IS NULL")
        ->where("lg.xl_genre_id <= ?", XlGenres::MACHINE_ID_LIMIT)
        ->order("lg.order_no");
    $large_genres = $_db->fetchAll($lg_select);

    $large_genre_id = null;
    if (!empty($_GET["large_genre_id"])) {
        foreach ($large_genres as $lg) {
            if ($_GET["large_genre_id"] == $lg["id"]) {
                $large_genre_id = $lg["id"];
                break;
            }
        }
    }

    $vm_model = new ViewMachine();

    /// 検索元の機械を取得 ///
    $machine = [];
    if (!empty($machine_id)) {
        $machine_select = $vm_model->select_base_all()->columns('vm.*')
            ->where("vm.id = ?", $machine_id);
        // echo ($machine_select->__toString());

        $machine = $_db->fetchRow($machine_select);

        if (empty($model)) {
            $model          = $machine["model2"];
            $maker          = $machine["maker"];
            $large_genre_id = $machine["large_genre_id"];
        }

        // if (empty($model)) $model                   = $machine["model2"];
        // if (empty($maker)) $maker                   = $machine["maker"];
        // if (empty($large_genre_id)) $large_genre_id = $machine["large_genre_id"];
    }

    // if (empty($model)) {
    //     throw new Exception("型式がないので、登録履歴を取得できませんでした");
    // } else if ($machine["xl_genre_id"] > XlGenres::MACHINE_ID_LIMIT) {
    //     throw new Exception("この商品は機械カテゴリではありません。");
    // }

    // 同じ機械の登録履歴を取得
    $histories = [];

    if (!empty($model)) {
        $histories_select = $vm_model->select_base_all()
            ->columns('vm.*')
            ->where("vm.model2 ILIKE ?", "%{$model}%")
            ->where("vm.xl_genre_id <= ?", XlGenres::MACHINE_ID_LIMIT)
            ->where("vm.created_at >= now() + ?", "-{$range}year")
            // ->where("vm.large_genre_id = ?", $machine["large_genre_id"])
            // ->orWhere("vm.maker = ?", $machine["maker"])
            // ->where("vm.large_genre_id = {$_db->quote($large_genre_id)} OR vm.maker =  {$_db->quote($maker)}")
            ->order("vm.created_at DESC");

        // ジャンル、メーカー条件
        $maker_like = "{$maker}%";
        if (!empty($maker) && !empty($large_genre_id)) {
            $histories_select->where("vm.large_genre_id = {$_db->quote($large_genre_id)} OR vm.maker ILIKE {$_db->quote($maker_like)}");
        } else if (!empty($maker)) {
            $histories_select->where("vm.maker ILIKE {$_db->quote($maker_like)}");
        } else if (!empty($large_genre_id)) {
            $histories_select->where("vm.large_genre_id = {$_db->quote($large_genre_id)}");
        }

        // echo ($histories_select->__toString());

        $histories = $_db->fetchAll($histories_select);
    }

    /// ロギング ///
    // if (!empty($model)) {
    $admin_history_log_model = new AdminHistoryLog();
    $admin_history_log_model->write($_user, "histories",  "search", [
        "machine_id"     => $machine_id,
        "model"          => $model,
        "large_genre_id" => $large_genre_id,
        "maker"          => $maker,
        "range"          => $range,
    ]);
    // }

    if (!empty($machine)) {
        $pankuzu = [
            'search.php?l='         . $machine['large_genre_id'] => $machine['large_genre'],
            'search.php?g='         . $machine['genre_id']       => $machine['genre'],
            'machine_detail.php?m=' . $machine['id']             => "{$machine['name']} {$machine['maker']} {$machine['model']}",
        ];
    } else {
        $pankuzu = [
            '/admin/' => '会員ページ',
        ];
    }

    /// 表示変数アサイン ///
    $_smarty->assign(array(
        // 'pageTitle'      => "{$machine['maker']} {$machine['model']} : 同型式の在庫登録履歴",
        'pageTitle'      => "同型式の在庫登録履歴",
        'pankuzu'        => $pankuzu,
        "xl_genres"      => $xl_genres,
        "large_genres"   => $large_genres,
        "large_genre_id" => $large_genre_id,
        "maker"          => $maker,
        "model"          => $model,
        "range"          => $range,
        "machine"        => $machine,
        "histories"      => $histories,
        "range_selector" => $range_selector,
    ))->display('admin/histories/index.tpl');
} catch (Exception $e) {
    /// 表示変数アサイン ///
    $_smarty->assign(array(
        'pageTitle' => "機械の在庫登録履歴",
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}

<?php

/**
 * 出力処理
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2023/06/05
 */

require_once '../../../lib-machine.php';
try {
    // 状態がない場合の初期化
    if (empty($_SESSION["chat_query"])) $_SESSION["chat_query"] = [];

    // 出力のベース
    $message = [
        "player"    => "bot",
        "content"   => "...",
        "selectors" => [],
    ];
    $machines = [];

    $model = new ViewMachine();
    $select_base = $model->select_base();

    // 処理分岐
    switch ($_GET["action"]) {
        case "select"; // 大選択肢
            $machine_select = make_machines_select($select_base, $_SESSION["chat_query"]);

            switch ($_GET["target"]) {
                case "xl_genre":
                    $message["content"] .= "\nおさがしの商品の大ジャンルは？";

                    $select = make_selector_select_by_machines($machine_select, "xl_genre_id", "xl_genre");
                    $xl_genres = $_db->fetchAll($select);
                    $message["selectors"] = make_selectors("add", "xl_genre", $xl_genres);

                    break;
                case "large_genre":
                    $message["content"] .= "\nおさがしの商品の詳しいジャンルは？";

                    $select = make_selector_select_by_machines($machine_select, "large_genre_id", "large_genre");
                    $lg_genres = $_db->fetchAll($select);
                    $message["selectors"] = make_selectors("add", "large_genre", $lg_genres);

                    break;
                case "genre":
                    $message["content"] .= "\nおさがしの商品の、より詳しいジャンルは？";

                    $select = make_selector_select_by_machines($machine_select, "genre_id", "genre");
                    $genres = $_db->fetchAll($select);
                    $message["selectors"] = make_selectors("add", "genre", $genres);

                    break;
                case "addr1":
                    $message["content"] .= "あなたの所在地はどちらですか？";

                    $select = make_selector_select_by_machines($machine_select, "addr1", "addr1");
                    $genres = $_db->fetchAll($select);
                    $message["selectors"] = make_selectors("add", "addr1", $genres);

                    break;
            }
            break;
        case "add":
            // クエリに追加
            $_SESSION["chat_query"][$_GET["target"]] =  $_GET["value"];

            // 件数取得
            $machine_select = make_machines_select($select_base, $_SESSION["chat_query"]);
            $count_select   = clone $machine_select;
            $count_select->columns("count(*)");
            $count = $_db->fetchOne($count_select);
            echo ($machine_select->__toString());

            $message["content"] = "ここまでの在庫数は、" . number_format($count) . "件です。";

            // 次の選択肢
            $message["selectors"] = make_big_selectors($_SESSION["chat_query"]);

            // 在庫情報取得
            if (empty($no_machines)) {
                $select = clone $machine_select;
                $select->columns("vm.*")
                    ->order("created_at DESC")->limitPage(1, 5);

                $machines = $_db->fetchAll($select);
            }

            break;
    }



    /// 表示変数アサイン ///
    $_smarty->assign(array(
        "message"  => $message,
        "machines" => $machines,
    ))->display('_pg/chatbot/_message.tpl');
} catch (Exception $e) {
    /// 表示変数アサイン ///
    // $_smarty->assign(array(
    //     'pageTitle'       => "マシンライフ チャットボット(beat)",
    //     'errorMes'  => $e->getMessage()
    // ))->display('error.tpl');

    echo "error! : " + $e->getMessage();
}

////////////////////////////////////////////////////////////////

/// 選択肢の生成 //
function make_selectors($action, $target, $values = [])
{
    $res = [];
    foreach ($values as $va) {
        $res[$va["name"]] = [
            "action" => $action,
            "target" => $target,
            "value"  => $va["id"],
        ];
    }

    return $res;
}

/// 取得SELECT ///
function make_machines_select($select_base, $queries)
{
    // 取得SELECT
    $select = clone $select_base;

    if (!empty($queries["xl_genre"])) {
        $select->where("vm.xl_genre_id IN (?)", $queries["xl_genre"]);
    }
    if (!empty($queries["large_genre"])) {
        $select->where("vm.large_genre_id IN (?)", $queries["large_genre"]);
    }
    if (!empty($queries["genre"])) {
        $select->where("vm.genre_id IN (?)", $queries["genre"]);
    }
    if (!empty($queries["addr1"])) {
        $select->where("vm.addr1 IN (?)", $queries["addr1"]);
    }
    if (!empty($queries["capacity"])) {
        $select->where("vm.capacity IS NOT NULL");
    }

    if (!empty($queries["news"])) {
        $select->where("vm.created_at > now() + ?", $queries["news"]);
    }

    if (!empty($queries["catalog_id"])) {
        $select->where("vm.catalog_id IS NOT NULL OR (pdfs IS NOT NULL AND vm.pdfs <> '[]')");
    }
    if (!empty($queries["commission"])) {
        $select->where("vm.commission = 1");
    }
    if (!empty($queries["top_img"])) {
        $select->where("vm.top_img IS NOT NULL AND vm.top_img <> ''");
    }
    if (!empty($queries["youtube"])) {
        $select->where("vm.youtube IS NOT NULL AND vm.youtube <> ''");
    }
    return $select;
}

/// 選択肢取得SELECT by 在庫 ///
function make_selector_select_by_machines($select_base, $id, $name)
{
    $select = clone $select_base;

    return $select->distinct()
        ->columns(["id" => $id, "name" => $name])
        ->order($id);
}

// 大選択肢をクエリから作成
function make_big_selectors($queries)
{
    $res = [];

    // ジャンル
    if (empty($queries["xl_genre"])) {
        $res["ジャンルからさがす"] = ["action" => "select", "target" => "xl_genre",];
    } else if (empty($queries["large_genre"])) {
        $res["詳しいジャンルからさがす"] = ["action" => "select", "target" => "large_genre",];
    } else if (empty($queries["genre"])) {
        $res["より詳しいジャンルからさがす"] = ["action" => "select", "target" => "genre",];
    }

    // その他
    if (empty($queries["addr1"])) {
        $res["出品されている地域からさがす"] = ["action" => "select", "target" => "addr1",];
    }
    if (empty($queries["capacity"])) {
        $res["能力値が登録されている商品は？"] = ["action" => "add", "target" => "capacity", "value" => true,];
    }

    if (empty($queries["catalog_id"])) {
        $res["電子カタログ・資料PDFが添付されている商品は？"] = ["action" => "add", "target" => "catalog_id", "value" => true,];
    }
    if (empty($queries["commission"])) {
        $res["試運転可能な商品は？"] = ["action" => "add", "target" => "commission", "value" => true,];
    }

    if (empty($queries["top_img"])) {
        $res["画像のある商品は？"] = ["action" => "add", "target" => "top_img", "value" => true,];
    }
    if (empty($queries["youtube"])) {
        $res["動画を見られる商品は？"] = ["action" => "add", "target" => "youtube", "value" => true,];
    }

    return $res;
}

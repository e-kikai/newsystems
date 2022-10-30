<?php
/**
 * クラスタ一覧テスト
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2021/10/28
 */
//// 設定ファイル読み込み ////
require_once '../../../lib-machine.php';

define('CLUSTERS_CSV',    "./ml_clusters_200.csv");
// define('C_NORMS_CSV',    "./ml_norms_all_01.csv");
define('C_NORMS_DIR',     "./ml_norms_03");
define('C_LF_SCORES_DIR', "./ml_lf_scores_03");

// define('C_TH_NORMS_CSV', "./ml_norms_th_01.csv");

try {
    //// 認証 ////
    # Auth::isAuth('system');

    //// 変数を取得 ////
    $clusterId = Req::query('cid');
    $queryId   = Req::query('qid'); // vectorソート
    $lfId      = Req::query('lfid'); // local featureソート

    // CSVファイルの内容を取得
    $file = new SplFileObject(CLUSTERS_CSV, 'r');
    $file->setFlags(SplFileObject::READ_CSV);
    $header = [];
    foreach ($file as $row) {
        // 最終行をスキップ
        if (empty($row) || count($row) != 2) { continue; }

        // ヘッダーを取得
        if (empty($header)) {
            $header = $row;
            continue;
        }

        // csvヘッダーをキーにして値を格納
        $item[] = array_combine($header, $row);
    }

    /// クラスタ情報整理 ///
    $clusters = [];
    $ids      = [];
    $title    = "クラスタテスト";
    $machines = [];

    foreach ($item as $it) {
        $cid = $it["cluster_id"];

        if (empty($cid)) { continue; }

        if (empty($clusters[$cid])) {
          $clusters[$cid]["first"] = $it["id"];
          $clusters[$cid]["count"] = 1;
        } else {
          $clusters[$cid]["count"] ++;
        }

        /// 検索する場合 ///
        if (!empty($clusterId) && $cid == $clusterId) {
            $ids[] = $it["id"];
        }
    }

    ksort($clusters);

    $mModel = new Machine();

    /// クラスタトップ機械情報を取得 ///
    $cMachineIds = [];
    foreach ($clusters as $cl) {
        $cMachineIds[] = $cl["first"];
    }

    $q = array(
      'id'     => $cMachineIds,
      "delete" => "each",
    );

    $cMachines = $mModel->getList($q);

    // var_dump($cMachines);

    $cMachineById = [];
    foreach ($cMachines as $ma) {
        $cMachineById[$ma["id"]] = $ma;
    }

    /// クラスタ中身 ///
    if (!empty($ids)) {
        $q = array(
          'id'     => $ids,
          "delete" => "each",
        );

        $machines = $mModel->getList($q);

        $cm = $cMachineById[$clusters[$clusterId]["first"]];

        $title = $title . " " . $clusterId . " : " . $cm["name"];

        /// ベクトル比較結果からソート ///
        if (!empty($queryId)) {
            $query_machine = $mModel->get($queryId);

            // CSVファイルの内容を取得
            $file = new SplFileObject(C_NORMS_DIR . "/norms_c_" . sprintf('%04d', $clusterId) . ".csv", 'r');
            // $file = new SplFileObject(C_TH_NORMS_CSV, 'r');
            $file->setFlags(SplFileObject::READ_CSV);
            $header = [];
            $sorts  = [];
            foreach ($file as $row) {
                if (empty($header))          { $header = $row; }            // ヘッダーを取得
                elseif (empty($row))         { continue; }                  // 最終行をスキップ
                elseif ($row[0] == $queryId) { $sorts[$row[1]] = $row[2]; } // 該当IDのもののみ取得
            }

            /// 検索結果をソート ///
            asort($sorts); // IDソート
            // $sort_keys = array_keys($sorts);

            $sort_keys = [];
            foreach ($machines as $key => $ma) {
                if (!empty($sorts[$ma['id']])) {
                    $sort_keys[$key] = $sorts[$ma['id']];
                } else {
                    $sort_keys[$key] = 10000;
                }
            }

            array_multisort($sort_keys, SORT_ASC, $machines);
        } else if (!empty($lfId)) { // /local feature ソート ///
            $query_machine = $mModel->get($lfId);

            // CSVファイルの内容を取得
            $file = new SplFileObject(C_LF_SCORES_DIR . "/lfsearch_c_" . sprintf('%04d', $clusterId) . ".csv", 'r');
            // $file = new SplFileObject(C_TH_NORMS_CSV, 'r');
            $file->setFlags(SplFileObject::READ_CSV);
            $header = [];
            $sorts  = [];
            foreach ($file as $row) {
                if (empty($header))       { $header = $row; }            // ヘッダーを取得
                elseif (empty($row))      { continue; }                  // 最終行をスキップ
                elseif ($row[0] == $lfId) { $sorts[$row[1]] = $row[2]; } // 該当IDのもののみ取得
            }

            /// 検索結果をソート(スコア高い順) ///
            asort($sorts); // IDソート

            $sort_keys = [];
            foreach ($machines as $key => $ma) {
                if (!empty($sorts[$ma['id']])) {
                    $sort_keys[$key] = $sorts[$ma['id']];
                } else {
                    $sort_keys[$key] = 0;
                }
            }

            array_multisort($sort_keys, SORT_DESC, $machines);
        }
    }

    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle'  => $title,
        'pankuzu'    => array('/system/' => '管理者ページ', '/system/playground/cluster.php' => 'クラスタテスト'),

        'clusters'    => $clusters,
        'cMachineById'=> $cMachineById,
        'machines'    => $machines,

        'clusterId'   => $clusterId,
        'sorts'       => !empty($sorts) ? $sorts : [],

        'queryId'     => $queryId,
        'lfId'        => $lfId,

        'query_machine' => !empty($query_machine) ? $query_machine : null,

    ))->display("system/playground/cluster.tpl");
} catch (Exception $e) {
    //// 表示変数アサイン ////
    $_smarty->assign(array(
        'pageTitle' => 'クラスタテスト',
        'pankuzu'    => array('/system/' => '管理者ページ', '/system/playground/cluster.php' => 'クラスタテスト'),
        'errorMes'  => $e->getMessage()
    ))->display('error.tpl');
}

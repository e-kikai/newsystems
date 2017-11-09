<?php
/**
 * AJAXでクロール設定(既存情報ID)取得
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.2
 * @since 2013/01/03
 */
//// 設定ファイル読み込み ////
require_once '../../../lib-machine.php';
try {
    //// 認証 ////
    // Auth::isAuth('system');
    
    // タイムアウトを長く設定 
    set_time_limit(3000);
    
    //// パラメータ取得 ////
    $companyId = Req::query('id');
    $company   = Req::query('company');
    
    $update   = Req::query('update');
    
    //// 会社情報のチェック ////
    $sql = 'SELECT * FROM companies WHERE id = ? AND company = ?;';
    $res = $_db->fetchRow($sql, array($companyId, $company));
    
    if (empty($res)) {
        throw new Exception('会社情報を取得できませんでした');
    }
    
    // 既存機械のUID一覧を取得
    $where = '';
    if (!empty($update)) {
        $where.= ' AND used_change IS NOT NULL '; // 変更済みのもののみ取得
    }
    
    $sql = "SELECT used_id FROM machines WHERE deleted_at IS NULL AND used_id IS NOT NULL AND company_id = ? {$where};";
    $res = $_db->fetchCol($sql, $companyId);
    
    // 結果をJSONに変換して出力
    exit(json_encode($res));
} catch (Exception $e) {
    echo $e->getMessage();
}

<?php
/**
 * ファイルアップロード処理
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.1
 * @since 2012/08/02
 */
//// 設定ファイル読み込み ////
require_once '../../lib-machine.php';
try {
    //// 認証 ////
    Auth::isAuth('machine');
    
    $t = Req::post('t');
    $m = Req::post('m');
    $c = Req::post('c');
    
    // ファイルアップロード処理
    $f = new File();
    $f->setPath($_conf->tmp_path);
    $fList = $f->uploadFiles($_FILES['f'], 'f_' . date('YmdHis'), $t);
    
    /*
    $fList = array();

    // ファイルタイプ・拡張子の設定
    $filetype = $t == "pdf" ? 'application/pdf' : 'image/jpeg';
    $ex = $t == "pdf" ? 'pdf' : 'jpeg';
    
    // var_dump($_FILES);
    if (!empty($_FILES['f'])) {
        foreach($_FILES['f']['name'] as $key => $val) {
            $type = $_FILES['f']['type'][$key];
            // ファイルタイプのチェック
            if ($filetype == 'image/jpeg') {
                if ($type != 'image/jpeg' && $type != 'image/pjpeg') { continue; }
            } else {
                if ($type != $filetype) { continue; }
            }
            
            // ファイルをアップロード
            $fn    = 'upload_' . date('YmdHis') . '_' . $key .'.' . $ex;
            $fpath = $_conf->tmp_path . '/' . $fn;
            move_uploaded_file($_FILES["f"]["tmp_name"][$key], $fpath);
            $fList[] = $fn;
        }
    }
    */
} catch (Exception $e) {
    echo $e->getMessage();
}
?><!DOCTYPE html>
<html lang='ja'>
<head>
<script type="text/javascript" src="../libjs/jquery.js"></script>
<script type="text/JavaScript">
var fList = <?=json_encode($fList); ?>;
var c = '<?=$c; ?>';
var t = '<?=$t; ?>';
var m = '<?=$m; ?>';

$(function() {
    //// アップロード後に、ファイルを表示 ////
    if (fList.length) {
        window.parent.upload_callback(c, fList);
    }
    
    location.href = './upload.php?c=' + c + '&t=' + t + '&m=' + m;
});
</script>
<style>
</style>
</head>
<body>
</body>
</html>

<?php
require_once 'Smarty/Smarty.class.php';

/**
 * Smarty派生クラス
 */
class MySmarty extends Smarty
{
    public function __construct($conf)
    {
        // Smartyクラスのセットアップ
        parent::__construct();
        $this->template_dir = $conf->templates_path;
        $this->compile_dir  = $conf->templates_c_path;
        $this->caching      = false;
        // $this->trusted_dir  = array($conf->root_dir);

        // プラグインディレクトリの追加
        $temp = $this->plugins_dir;
        $temp[] = dirname(__FILE__) . '/smarty_plugins';
        $this->plugins_dir = $temp;

        // デフォルトでescapeするように設定
        $this->default_modifiers = array(
            'escape:"html"',
            'mb_convert_kana:"KVrn"',
            'default:""'
        );

        // 設定ファイルの$conf をアサイン
        $this->assign('_conf', $conf->toArray());
    }
}

<?php
/**
 * リクエスト取得クラス
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
class Req
{
    /**
     * POST変数取得
     * 
     * @access public static
     * @param string $key 取得する変数のキー
     * @param string $default 非セット時のデフォルト値     
     * @return mixed 取得した変数・配列
     */
    static public function post($key = null, $default = null)
    {
        if (null === $key) {
            return $_POST;
        }
        return (isset($_POST[$key])) ? $_POST[$key] : $default;
    }
    
    /**
     * GET変数取得
     * 
     * @access public static
     * @param string $key 取得する変数のキー
     * @param string $default 非セット時のデフォルト値     
     * @return mixed 取得した変数・配列
     */    
    static public function query($key = null, $default = null)
    {
        if (null === $key) {
            return $_GET;
        }
        return (isset($_GET[$key])) ? $_GET[$key] : $default;
    }
    
    /**
     * queryのエイリアス
     * 
     * @access public static
     * @param string $key 取得する変数のキー
     * @param string $default 非セット時のデフォルト値     
     * @return mixed 取得した変数・配列
     */
    static public function get($key = null, $default = null) {
        return self::query($key, $default);
    }
}

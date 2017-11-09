<?php
/**
 * 大ジャンルテーブルクラス
 * 
 * @access public
 * @author 川端洋平
 * @version 0.2.0
 * @since 2014/10/24
 */
class XlGenres extends MyTable
{
    protected $_name     = 'xl_genres';
    protected $_primary  = 'id';

    //// 共通設定 ////
    protected $_view     = 'view_xl_genres';
    protected $_jname    = '大ジャンル';

    protected $_filters  = array('rules' => array(
        '大ジャンル名'       => array('fields' => 'xl_genre',      'NotEmpty'),
        '大ジャンル名(カナ)' => array('fields' => 'xl_genre_kana',),
        '並び順'             => array('fields' => 'order_no',      'Int', 'NotEmpty'),
    ));

    protected $_orderBys = array(" t.order_no, t.id DESC ");
    
    /**
     * 機械用大ジャンル一覧を取得
     *
     * @access public
     * @param  array $q 検索クエリ
     * @return array ジャンル一覧
     */
    public function getMachineList($q=null)
    {
        // 検索対象VIEWを一時的に機械用に変更
        $tempView    = $this->_view;
        $this->_view = 'view_machine_xl_genres';

        $result = $this->getList($q);

        // デフォルトのVIEWに戻す
        $this->_view = $tempView;

        return $result;
    }

    /**
     * 検索クエリからWHERE句の生成
     *
     * @access protected
     * @param  array   $q 検索クエリ
     * @param  boolean $check 検索条件チェック     
     * @return string  生成したwhere句
     */
    protected function _makeWhereSqlArray($q, $check=false) {
        $whereArr = array();

        return $whereArr;
    }
}

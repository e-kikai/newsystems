<?php
/**
 * 大ジャンルテーブルクラス
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.2.0
 * @since   2014/10/24
 */
class LargeGenres extends MyTable
{
    protected $_name    = 'large_genres';
    protected $_primary = 'id';

    //// 共通設定 ////
    protected $_view    = 'view_large_genres';
    protected $_jname   = '中ジャンル';

    // フィルタ条件
    protected $_filters = array('rules' => array(
        '大ジャンルID'       => array('fields' => 'xl_genre_id',      'Int', 'NotEmpty'),
        '中ジャンル名'       => array('fields' => 'large_genre',      'NotEmpty'),
        '中ジャンル名(カナ)' => array('fields' => 'large_genre_kana',),
        '並び順'             => array('fields' => 'order_no',         'Int', 'NotEmpty'),
        '非表示オプション'   => array('fields' => 'hide_option',      'Int',),
    ));
    
    protected $_orderBys = array(" t.xl_order, t.order_no, t.id DESC ");

    //// 非表示オプション選択肢 ////
    static protected $_hideOptions = array(
        '' => '表示',
        1  => '非表示',
        2  => 'カタログ専用'
    );

    static public function getHideOptions() { return self::$_hideOptions; }

    /**
     * 機械用中ジャンル一覧を取得
     *
     * @access public
     * @param  array $q 検索クエリ
     * @return array ジャンル一覧
     */
    public function getMachineList($q=null)
    {
        // 検索対象VIEWを一時的に機械用に変更
        $tempView    = $this->_view;
        $this->_view = 'view_machine_large_genres';

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
                
        // 特大ジャンルID（複数選択可）
        if (!empty($q['xl_genre_id'])) {
            $whereArr[] = $this->_db->quoteInto(' t.xl_genre_id IN(?) ', $q['xl_genre_id']);
        }

        return $whereArr;
    }
}

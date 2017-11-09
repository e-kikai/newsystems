<?php
/**
 * 掲載会社情報テーブルクラス
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.2.0
 * @since   2014/11/06
 */
class Groups extends MyTable
{
    protected $_name              = 'groups';
    protected $_primary           = 'id';

    //// 共通設定 ////
    protected $_jname             = '団体情報';
    protected $_view              = 'view_groups';

    /**
     * 検索クエリからORDER BY句の生成
     *
     * @access protected
     * @param  array   $q 検索クエリ
     * @return string  生成したwhere句
     */
    protected function _makeOrderBySql($q)
    {
        // デフォルトは階層構造順
        $orderBy = " t.level, t.root_id, t.parent_id, t.id ";

        return " ORDER BY " . $orderBy;
    }

}
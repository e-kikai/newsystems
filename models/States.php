<?php
/**
 * 都道府県テーブルクラス
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2014/11/27
 */
class States extends MyTable
{
    protected $_name     = 'states';
    protected $_primary  = 'id';

    //// 共通設定 ////
    protected $_view     = 'view_states';
    protected $_jname    = '都道府県';

    /**
     * 都道府県一覧を取得(トップページ用機械件数あり)
     *
     * @access public
     * @return array 都道府県一覧
     */
    public function getListByTop()
    {
        // SQLクエリを作成
        $sql = "SELECT
          s.* ,
          m2.count
        FROM
          view_states s 
          LEFT JOIN (SELECT addr1, count(*) as count FROM machines m WHERE m.deleted_at IS NULL AND (m.view_option IS NULL OR m.view_option <> 1) GROUP BY addr1) m2
            ON m2.addr1 = s.state
        ORDER BY
          s.order_no, 
          s.region_order;";
        $result = $this->_db->fetchAll($sql);

        return $result;
    }
}

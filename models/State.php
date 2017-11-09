<?php
/**
 * 都道府県モデルクラス
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2013/03/04
 */
class State extends Zend_Db_Table
{
    protected $_name = 'states';
    
    /**
     * 都道府県一覧を取得
     *
     * @access public
     * @param string  $t 対象
     * @param integer  $g 対象団体ID
     * @param integer  $l 取得数          
     * @return array お知らせ一覧
     */
    public function getList()
    {
        // SQLクエリを作成
        $sql = "SELECT
          s.* ,
          r.region,
          m2.count
        FROM
          states s 
          LEFT JOIN regions r 
            ON r.id = s.region_id 
          LEFT JOIN (SELECT addr1, count(*) as count FROM machines m WHERE m.deleted_at IS NULL AND (m.view_option IS NULL OR m.view_option <> 1) GROUP BY addr1) m2
            ON m2.addr1 = s.state
        ORDER BY
          r.order_no, 
          s.order_no;";
        $result = $this->_db->fetchAll($sql);
        return $result;
    }
}

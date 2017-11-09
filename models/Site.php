<?php
/**
 * クロールサイトモデルクラス
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/05/25
 */
class Site extends Zend_Db_Table_Abstract
{
    protected $_name = 'sites';

    /**
     * クローラサイト情報取得
     *
     * @access private
     * @param  int  $site_id サイトID
     * @param  int  $usr_id ユーザID
     * @return boolean 成功すればtrue
     */
    public function getSite($siteId = NULL)
    {
        // SQLクエリを作成
        if (!empty($siteId)) {
            $where = $this->_db->quoteInto(' id = ? AND ', $siteId);
        }
        $where.= ' deleted_at IS NULL ';
        
        $sql = "SELECT s.* FROM sites s WHERE {$where} ORDER BY s.order_no, s.id;";
        $result = $this->_db->fetchAll($sql);
        return $result;
    }
}

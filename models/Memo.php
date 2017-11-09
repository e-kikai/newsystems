<?php
/**
 * メモモデルクラス
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/08/27
 */
class Memo extends Zend_Db_Table_Abstract
{
    protected $_name = 'sites';
    
    private $_categoryList = array('メモ', '引合', '下見', '仕入', '見積', '在庫登録', '売却', 'その他');
    
    // 内容がJSONのカラム
    private $_jsonColumn = array('machines');
    
    /**
     * メモジャンル一覧取得
     *
     * @access public
     * @return array メモジャンル一覧
     */
    public function getCategoryList()
    {
        return $this->_categoryList;
    }
    
    /**
     * メモ一覧取得
     *
     * @access public
     * @param integer $companyId 会社ID
     * @return array メモ一覧
     */
    public function getList($companyId) {
        // SQLクエリを作成
        $sql = "SELECT
          m.*,
          u.name
        FROM
          memo m 
          LEFT JOIN users u 
            ON m.user_id = u.id 
        WHERE
          m.deleted_at IS NULL AND
          u.deleted_at IS NULL AND
          company_id = ?
        ORDER BY
          m.created_at DESC;";
          
        $result = $this->_db->fetchAll($sql, $companyId);
        
        if (empty($result)) {
            throw new Exception('メモ情報を取得できませんでした');
        }
        
        // JSON展開
        $result = B::decodeTableJson($result, $this->_jsonColumn);
        return $result;
    }
    
    /**
     * メモ情報取得
     *
     * @access public
     * @param integer $id メモID     
     * @param integer $companyId 会社ID
     * @return array メモ情報
     */
    public function get($id, $companyId) {
        // SQLクエリを作成
        $sql = "SELECT
          m.*,
          u.name
        FROM
          memo m 
          LEFT JOIN users u 
            ON m.user_id = u.id 
        WHERE
          m.deleted_at IS NULL AND
          u.deleted_at IS NULL AND
          id = ? AND
          company_id = ?
        ORDER BY
          m.created_at DESC;";
          
        $result = $this->_db->fetchRow($sql, array($id, $companyId));
        
        if (empty($result)) {
            throw new Exception('メモ情報を取得できませんでした');
        }
        
        // JSON展開
        $result = B::decodeRowJson($result, $this->_jsonColumn);
        return $result;
    }
}

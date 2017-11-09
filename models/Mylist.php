<?php
/**
 * マイリストモデルクラス
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/17
 */
class Mylist extends Zend_Db_Table_Abstract
{
    protected $_name = 'mylists';
    
    public $_targets = array('machine', 'genres', 'company', 'catalog', 'eips');

    /**
     * 該当マイリスト配列を取得
     *
     * @access public
     * @param int $id ユーザID
     * @param string $target マイリスト対象
     * @return array 該当マイリスト配列
     */
    public function getArray($id, $target)
    {
        // SQLクエリを作成
        $sql = "SELECT query FROM mylists 
            WHERE deleted_at IS NULL AND user_id = ? AND target = ?;";
        $result = $this->_db->fetchCol($sql, array($id, $target));
        return $result;
    }
    
    /**
     * マイリスト登録
     *
     * @access public
     * @param int $id ユーザID
     * @param string $target マイリスト対象
     * @param array 登録内容(複数可)
     * @return Mylist
     */
    public function set($id, $target, $querys)
    {
        // 現在のマイリスト内容を取得し、登録内容と比較
        $now  = $this->getArray($id, $target);
        $diff = array_diff($querys, $now);
        if (empty($diff)) { throw new Exception('この情報はマイリスト登録済です'); }
        
        // マイリスト登録
        $this->_db->beginTransaction();
        try {
            foreach ($diff as $q) {
                $this->_db->insert('mylists', array(
                    'user_id' => $id,
                    'target'  => $target,
                    'query'   => $q
                ));
            }
            $this->_db->commit();
        } catch (Exception $e) {
            $this->_db->rollBack();
            // echo $e->getMessage();
            throw new Exception('マイリストの登録に失敗しました');
        }
        
        return $this;
    }
    
    /**
     * マイリスト削除
     *
     * @access public
     * @param int $id ユーザID
     * @param string $target マイリスト対象
     * @param array 削除内容(複数可)
     * @return Mylist
     */
    public function logicalDelete($id, $target, $querys)
    {
        // 現在のマイリスト内容を取得し、登録内容と比較
        $now   = $this->getArray($id, $target);
        $inter = array_intersect($querys, $now);
        if (empty($inter)) { throw new Exception('この情報はマイリスト登録されていません'); }
        
        // マイリスト削除
        $this->_db->beginTransaction();
        try {
            $where = $this->_db->quoteInto(' query IN (?) ;', $inter);
            $sql = "UPDATE mylists 
            SET
              deleted_at = CURRENT_TIMESTAMP 
            WHERE
              deleted_at IS NULL AND
              user_id = ? AND
              target = ? AND {$where};";
            $this->_db->query($sql, array($id, $target));
            $this->_db->commit();
        } catch (Exception $e) {
            $this->_db->rollBack();
            echo $e->getMessage();
            // throw new Exception('マイリストの削除に失敗しました');
        }
        
        return $this;
    }
}

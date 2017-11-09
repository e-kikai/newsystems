<?php
/**
 * 所属団体モデルクラス
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/17
 */
class Group extends Zend_Db_Table_Abstract
{
    protected $_name = 'groups';
    
    // 階層問い合わせ用SQL定数
    const WITH_RECURSIVE_SQL  = "WITH RECURSIVE r AS ( 
      SELECT
        1         AS LEVEL, 
        id        AS root_id, 
        groupname AS treenames,
        groupname AS rootname, 
        NULL      AS parentname,
        * 
      FROM
        groups 
      WHERE
        deleted_at IS NULL AND
        parent_id IS NULL 
      UNION ALL 
      SELECT
        r.LEVEL + 1, 
        r.root_id, 
        r.treenames || ' ' || g.groupname, 
        r.rootname,
        r.groupname AS parentname,
        g.* 
      FROM
        groups g, 
        r 
      WHERE
        r.deleted_at IS NULL AND
        r.id = g.parent_id AND
        r.LEVEL < 10
    )";

    /**
     * 所属団体一覧を取得
     *
     * @access public
     * @return array ジャンル一覧
     */
    public function getList()
    {
        $sql = self::WITH_RECURSIVE_SQL . ' SELECT r.* FROM r ORDER BY r.level, r.root_id, r.parent_id, r.id;';
        $result = $this->_db->fetchAll($sql);

        return $result;
    }
    
    /**
     * 所属団体情報を取得（複数可）
     *
     * @access public
     * @param  string  $id   ジャンルID（複数可）
     * @return array ジャンル情報を取得
     */
    public function get($id) {
        //// ジャンル情報を取得 ////
        if (empty($id)) { return false; }
        
        // SQLクエリを作成
        $sql = "WITH RECURSIVE r AS ( 
          SELECT
            1         AS LEVEL, 
            id        AS root_id, 
            groupname AS pankuzu, 
            * 
          FROM
            groups 
          WHERE
            parent_id IS NULL 
          UNION ALL 
          SELECT
            r.LEVEL + 1, 
            r.root_id, 
            r.pankuzu || ' ' || g.groupname, 
            g.* 
          FROM
            groups g, 
            r 
          WHERE
            r.id = g.parent_id
        ) 
        SELECT * FROM r where id = ?;";
        $result = $this->_db->fetchRow($sql, $id);
        
        return $result;
    }
}

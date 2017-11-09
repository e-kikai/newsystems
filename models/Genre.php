<?php
/**
 * ジャンルモデルクラス
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/17
 */
class Genre extends Zend_Db_Table_Abstract
{
    protected $_name = 'genres';
    
    // 表示オプション定数
    const HIDE_DELETE  = 1; // pow(2,0);
    const HIDE_CATALOG = 2; // pow(2,1);

    /**
     * 大ジャンル一覧を取得
     *
     * @access public
     * @return array ジャンル一覧
     */
    public function getLargeList($hideOption=NULL)
    {
        // 表示オプション
        $h = self::HIDE_DELETE | $hideOption;
        
        $sql = 'SELECT
          l.*, 
          count(m.*) as count
        FROM
          large_genres l 
          LEFT JOIN genres g 
            ON g.large_genre_id = l.id 
          LEFT JOIN machines m 
            ON m.genre_id = g.id AND
            m.deleted_at IS NULL AND
            (m.view_option IS NULL OR m.view_option <> 1) 
        WHERE
          (hide_option IS NULL OR hide_option & ? = 0) 
        GROUP BY
          l.id 
        ORDER BY
          l.order_no, 
          l.id;';
        $result = $this->_db->fetchAll($sql, $h);
        return $result;
    }
    
    /**
     * 特大ジャンル一覧を取得
     *
     * @access public
     * @return array 特大ジャンル一覧
     */
    public function getXlList($hideOption=NULL)
    {
        // 表示オプション
        $h = self::HIDE_DELETE | $hideOption;
        
        $sql = 'SELECT
          x.*, 
          count(m.*) as count
        FROM
          xl_genres x
          LEFT JOIN large_genres l 
            ON l.xl_genre_id = x.id 
          LEFT JOIN genres g 
            ON g.large_genre_id = l.id 
          LEFT JOIN machines m 
            ON m.genre_id = g.id AND
            m.deleted_at IS NULL AND
            (m.view_option IS NULL OR m.view_option <> 1) 
        WHERE
          (hide_option IS NULL OR hide_option & ? = 0) 
        GROUP BY
          x.id 
        ORDER BY
          x.order_no, 
          x.id;';
        $result = $this->_db->fetchAll($sql, $h);
        return $result;
    }
    
    /**
     * ジャンル一覧を取得
     *
     * @access public
     * @return array ジャンル一覧
     */
    public function getList()
    {
        // $sql = 'SELECT g.* FROM genres g ORDER BY g.order_no, g.id;';
        $sql = 'SELECT
          g.*,
          count(m.*) AS count 
        FROM
          genres g 
          LEFT JOIN large_genres l 
            ON g.large_genre_id = l.id 
          LEFT JOIN machines m 
            ON m.genre_id = g.id AND
            m.deleted_at IS NULL AND
            (m.view_option IS NULL OR m.view_option <> 1) 
        GROUP BY
          g.id, 
          l.order_no 
        ORDER BY
          l.order_no, 
          g.order_no, 
          g.id;';
        
        $result = $this->_db->fetchAll($sql);
        
        // JSON展開
        $result = B::decodeTableJson($result, array('spec_labels'));
        return $result;
    }
    
    /**
     * 大ジャンル情報を取得（複数可）
     *
     * @access public
     * @param  string  $id   ジャンルID（複数可）
     * @return array ジャンル情報を取得
     */
    public function getLargeGenre($id) {
        //// ジャンル情報を取得 ////
        if (empty($id)) { return false; }
        
        $where = $this->_db->quoteInto(' a.id IN (?) ', $id);
        
        // SQLクエリを作成
        $sql = "SELECT
          string_agg(a.large_genre, ' /') AS label, 
          sum(count)                      AS count 
        FROM
          ( 
            SELECT
              l.*, 
              count(m.*) AS count 
            FROM
              large_genres l 
              LEFT JOIN genres g 
                ON g.large_genre_id = l.id 
              LEFT JOIN machines m 
                ON m.genre_id = g.id 
            GROUP BY
              l.id
          ) a
        WHERE
          {$where};";
        
        $result = $this->_db->fetchRow($sql);
        
        return $result;
    }
    
    /**
     * ジャンル情報を取得（複数可）
     *
     * @access public
     * @param  string  $id   ジャンルID（複数可）
     * @return array ジャンル情報を取得
     */
    public function get($id) {
        //// ジャンル情報を取得 ////
        if (empty($id)) { return false; }
        
        $where = $this->_db->quoteInto(' g.id IN (?) ', $id);
        
        // SQLクエリを作成
        $sql = "SELECT
          g.*, 
          l.large_genre, 
          l.large_genre_kana, 
          l.hide_option 
        FROM
          genres g 
          LEFT JOIN large_genres l 
            ON l.id = g.large_genre_id 
        WHERE
          {$where}
        ORDER BY
          g.id;";
        $result = $this->_db->fetchAll($sql);
        
        // JSON展開
        $result = B::decodeTableJson($result, array('spec_labels'));
        return $result;
    }
}

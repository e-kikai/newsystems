<?php
/**
 * メーカーモデルクラス
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2012/04/17
 */
class Maker extends Zend_Db_Table
{
    protected $_name = 'makers';

    /**
     * メーカー名一覧を取得
     *
     * @access public
     * @return array メーカー名一覧
     */
    public function getList($q)
    {
        // ジャンルID（複数選択可）
        $where = '';
        if (!empty($q['maker'])) {
            $where = $this->_db->quoteInto(' WHERE m.maker IN(?) ', $q['maker']);
        }
        
        // SQLクエリを作成
        $sql = "SELECT
          mas.maker, 
          mas.maker_kana, 
          string_agg(m2.maker, '|') AS makers, 
          string_agg(m2.maker_kana, '|') AS makers_kana 
        FROM
          makers m 
          LEFT JOIN makers m2 
            ON m2.maker_master = m.maker_master 
          LEFT JOIN makers mas 
            ON mas.maker = m.maker_master 
        {$where} 
        GROUP BY
          mas.maker, 
          mas.maker_kana 
        ORDER BY
          mas.maker, 
          mas.maker_kana;";
        $result = $this->_db->fetchAll($sql);
        return $result;
    }
    
    /**
     * メーカー名一覧を取得
     *
     * @access public
     * @return array メーカー名一覧
     */
    public function get($maker)
    {
        // ジャンルID（複数選択可）
        if (empty($maker)) { return array(); }
        
        // SQLクエリを作成
        $sql = "SELECT
          mas.maker, 
          mas.maker_kana, 
          string_agg(m2.maker, '|') AS makers, 
          string_agg(m2.maker_kana, '|') AS makers_kana 
        FROM
          makers m 
          LEFT JOIN makers m2 
            ON m2.maker_master = m.maker_master 
          LEFT JOIN makers mas 
            ON mas.maker = m.maker_master 
        WHERE
          m.maker = ?
        GROUP BY
          mas.maker, 
          mas.maker_kana 
        ORDER BY
          mas.maker, 
          mas.maker_kana;";
        $result = $this->_db->fetchRow($sql, $maker);
        return $result;
    }
}

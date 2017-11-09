<?php
/**
 * ジャンルテーブルクラス
 * 
 * @access public
 * @author 川端洋平
 * @version 0.2.0
 * @since 2014/10/24
 */
class Genres extends MyTable
{
    protected $_name        = 'genres';
    protected $_primary     = 'id';

    //// 共通設定 ////
    protected $_view        = 'view_genres';
    protected $_jname       = 'ジャンル';
    protected $_jsonColumns = array('spec_labels');

    protected $_filters     = array('rules' => array(
        '大ジャンルID'      => array('fields' => 'large_genre_id', 'Int', 'NotEmpty'),
        'ジャンル名'        => array('fields' => 'genre',          'NotEmpty'),
        'ジャンル名(カナ)'  => array('fields' => 'genre_kana',),
        '能力項目名'        => array('fields' => 'capacity_label',),
        '能力単位'          => array('fields' => 'capacity_unit',),
        '命名規則'          => array('fields' => 'naming',),
        '並び順'            => array('fields' => 'order_no',       'Int', 'NotEmpty'),
        // 'その他能力項目群'  => array('fields' => 'spec_labels',    'NotEmpty'),
    ));

    protected $_orderBys = array(" t.xl_order, t.large_order, t.order_no, t.id DESC ");

    /**
     * 機械用ジャンル一覧を取得
     *
     * @access public
     * @param  array $q 検索クエリ
     * @return array ジャンル一覧
     */
    public function getMachineList($q=null)
    {
        // 検索対象VIEWを一時的に機械用に変更
        $tempView    = $this->_view;
        $this->_view = 'view_machine_genres';

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

        // 大ジャンルID（複数選択可）
        if (!empty($q['large_genre_id'])) {
            $whereArr[] = $this->_db->quoteInto(' t.large_genre_id IN(?) ', $q['large_genre_id']);
        }

        return $whereArr;
    }
    
    /**
     * 機械名、メーカー、型式で過去の機械情報からジャンルIDを検索する
     *
     * @access public
     * @param  string  $name  機械名
     * @param  string  $maker メーカー名
     * @param  string  $model 型式
     * @return integer 検索したジャンルID
     */
    public function searchGenreIdByMachine($name = null, $maker = null, $model = null) {
        $result = null;

        //// 1.メーカー、型式での検索 ////
        if (!empty($maker) && !empty($model)) {
            $sql = "SELECT
  m.genre_id, 
  count(*) AS c
FROM
  view_machines m 
WHERE
  m.model2 = regexp_replace(upper(?), '[^0-9A-Z]', '', 'g') AND
  (m.maker_master = ? OR m.maker_master = (SELECT maker_master FROM makers WHERE maker = ?  LIMIT 1)) 
GROUP BY
  m.genre_id
ORDER BY
  c DESC LIMIT 1;";

            $result = $this->getOne($q, array($model, $maker, $maker));
        }

        //// 2.機械名での検索 ////
        if (empty($result) && !empty($name)) {
            $sql = "SELECT m.genre_id, count(*) AS c FROM machines m WHERE (m.name = ? OR m.hint = ?) GROUP BY m.genre_id
              ORDER BY c DESC LIMIT 1;";

            $result = $this->_db->fetchOne($sql, array($name, $name));
        }

        //// 3.ジャンルでの検索 ////
        if (empty($result) && !empty($name)) {
            $sql = "SELECT g.id, count(*) AS c FROM genres g WHERE g.genre = ? GROUP BY g.id ORDER BY c DESC LIMIT 1;";

            $result = $this->_db->fetchOne($sql, $name);
        }

        //// 4.どのジャンルにも当てはまらない場合は、その他(390)を入れる ////
        if (empty($result)) { $result = 390; }
        
        return $result;
    }
}

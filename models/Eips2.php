<?php
/**
 * EIPSテーブルモデルクラス
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/05/25
 */
class Eips2 extends Zend_Db_Table_Abstract
{
    protected $_name = 'eipses2';
    
    // ORDER BYデフォルト
    const ORDER_BY_DEFAULT  = ' g.large_genre_id, e.genre_id, e.capacity, e.name, e.maker, e.model ';
    
    // ORDER BY候補一覧
    private $_orderBys = array(
        'name'     => ' ',
        'named'    => ' g.large_genre_id DESC, e.genre_id DESC, e.capacity DESC, ',
        'insert'   => ' e.created_at::date DESC, ',
        'insertd'  => ' e.created_at::date, ',
        'delete'   => ' e.deleted_at::date DESC, ',
        'deleted'  => ' e.deleted_at::date, ',
        'company'  => ' e.company, ',
        'companyd' => ' e.company DESC, ',
    );
    
    // 日付選択候補一覧
    private $_periods = array(
        '-1days'   => '24時間以内',
        '-2days'   => '2日前',
        '-3days'   => '3日前',
        '-1weeks'  => '1週間',
        '-2weeks'  => '2週間',
        '-1months' => '1ヶ月',
        'input'    => '期間指定'
    );
    
    /**
     * EIPS検索結果取得
     *
     * @access public
     * @param  array $q 検索クエリ
     * @return array EIPS検索結果一覧
     */
    public function search(array $q)
    {
        return array(
            'eipsList'    => $this->getList($q),
            'count'       => $this->getListCount($q),
            'makerList'   => $this->getMakerList($q),
            'genreList'   => $this->getGenreList($q),
            'queryDetail' => $this->queryDetail($q)
        );
    }
    
    /**
     * EIPS一覧を取得
     *
     * @access private
     * @param  array $q 取得する情報クエリ
     * @return array カタログ情報一覧
     */
    public function getList(array $q)
    {
        //// 期間指定WHERE句 ////
        $where = $this->_makeQueryWhere($q);
        
        //// WHERE句 ////
        $temp = $this->_makeWhere($q);
        if (!empty($temp)) {
            $where.= ' AND ' . $temp;
        }
        
        //// LIMIT句、OFFSET句を作成 ////
        $limit = '';
        if (!empty($q['limit']) && intval($q['limit'])) {
            $l = intval($q['limit']);
            $limit = $this->_db->quoteInto(' LIMIT ? ', $l);
            
            if (!empty($q['page']) && intval($q['page']) > 0) {
                $p = intval($q['page']);
                $limit.= $this->_db->quoteInto(' OFFSET ? ', ($l * ($p - 1)));
            }
        }
        
        //// ORDER BY句を作成 ////
        if (!empty($this->_orderBys[$q['order']])) {
            $orderBy = $this->_orderBys[$q['order']];
        } else {
            $orderBy = reset($this->_orderBys);
        }
        
        //// 検索クエリを作成・実行 ////
        $sql = "SELECT
          e.*,
          g.genre
        FROM
          eipses2 e
          LEFT JOIN genres g 
            ON g.id = e.genre_id 
        WHERE
          {$where} 
        ORDER BY
          {$orderBy}
          " . self::ORDER_BY_DEFAULT . "
        {$limit};";
        $result = $this->_db->fetchAll($sql);
        
        return $result;
    }
    
    /**
     * EIPS件数を取得
     *
     * @access public
     * @param  array $q 取得する情報クエリ
     * @return integer カタログ総件数
     */
    public function getListCount(array $q)
    {
        //// 期間指定WHERE句 ////
        $where = $this->_makeQueryWhere($q);
        
        //// WHERE句 ////
        $temp = $this->_makeWhere($q);
        if (!empty($temp)) {
            $where.= ' AND ' . $temp;
        }
        
        // 検索クエリを作成・実行
        $sql = "SELECT count(e.*) FROM eipses2 e WHERE {$where};";
        $result = $this->_db->fetchOne($sql);
        return $result;
    }
    
    /**
     * EIPSのジャンル一覧を取得
     *
     * @access public
     * @param  array $q 検索クエリ
     * @return array ジャンル一覧
     */
    public function getGenreList(array $q)
    {
        //// 期間指定 ////
        $where = $this->_makeQueryWhere($q);
        
        //// WHERE句 ////
        $temp = $this->_makeWhere($q, 'genre_id');
        if (!empty($temp)) {
            $where.= ' AND ' . $temp;
        }
        
        //// 検索クエリを作成・実行 ////
        $sql = "SELECT
          g.*, 
          count(e.*) AS count 
        FROM
          eipses2 e 
          LEFT JOIN genres g
            ON g.id = e.genre_id 
        WHERE
          {$where}
        GROUP BY
          g.id 
        HAVING
          g.id IS NOT NULL
        ORDER BY
          g.large_genre_id,
          g.order_no,
          g.id;";
        $result = $this->_db->fetchAll($sql);
        return $result;
    }
    
    /**
     * EIPSのメーカー一覧を取得
     *
     * @access public
     * @param  array $q 検索クエリ
     * @return array メーカー一覧
     */
    public function getMakerList(array $q)
    {
        //// 期間指定 ////
        $where = $this->_makeQueryWhere($q);
        
        //// WHERE句 ////
        $temp = $this->_makeWhere($q, 'maker');
        if (!empty($temp)) {
            $where.= ' AND ' . $temp;
        }
                
        //// 検索クエリを作成・実行 ////
        $sql = "SELECT
          e.maker, 
          count(e.*) AS count 
        FROM
          eipses2 e
        WHERE
          {$where}
        GROUP BY
          e.maker
        HAVING
          e.maker IS NOT NULL AND
          e.maker != '-'
        ORDER BY
          e.maker;";
        $result = $this->_db->fetchAll($sql);
        return $result;
    }
    
    /**
     * クロールで取得した機械情報の保存
     *
     * @access public
     * @param  string $siteId クロールしたサイトID
     * @param  string $data クロールで取得した機械情報
     * @return string INSERT数、UPDATE数の表示
     */
    public function setCrawledData($siteId, $dataJson) {
        //// 取得したデータを保存する ////
        if (!intval($siteId)) {
            throw new Exception('クロールサイト情報がありません');
        }
        
        // データをJSONからデコード
        if (empty($dataJson)) {
            throw new Exception('データがありません');
        }
        $data = json_decode($dataJson, true);
        if (empty($data[0]['uid'])) {
            throw new Exception('データJSONデコードに失敗しました');
        }
    
        // 変数初期化
        $now = date('Y-m-d H:i:s'); // 現在のタイムスタンプ
        $insertNum = 0;
        $updateNum = 0;

        $baseWhere = $this->_db->quoteInto(' site_id = ?', $siteId);
        
        // 更新用情報(changed_atのみ変更)
        $updateM = array(
            'changed_at' => $now,
            'deleted_at' => NULL
        );
        
        foreach ($data as $m) {
            // 機械情報に必要な情報を追加
            $m['site_id']    = $siteId;
            $m['changed_at'] = $now;
            // $m['deleted_at'] = NULL;
            $updateM['capacity'] = $m['capacity'];
            
            /*
            //// 画像ファイルURL配列のimplode ////
            if ($m['img_urls']) { $m['images'] = implode("\r\n", $m['img_urls']); }
            */
            
            //// 不要な配列要素を削除 ////
            unset($m['genre_hint'], $m['genre_name'], $m['img_urls']);
            
            //// UPDATEのWHERE句の作成 ////
            $where = $baseWhere . $this->_db->quoteInto(' AND uid = ?', $m['uid']);
            
            //// 更新できないときは、新規登録 ////
            $res = $this->update($updateM, $where);

            
            if (!$res) {
                $this->insert($m);
                $insertNum++;
            } else {
                $updateNum++;
            }
        }
        
        return "{$updateNum} machines update / {$insertNum} machines insert success.";
    }
    
    /**
     * クロールで取得した機械情報で、売却された機械の論理削除
     *
     * @access public
     * @param  string   $site_id    クロールしたサイトID
     * @param  string   $crawl_date クロールした日時（それ以前から更新されていない情報を削除）
     * @return string   削除件数の表示
     */
    public function deleteCrawledData($siteId, $date) {
        if (empty($date)) { throw new Exception('日時情報がありません'); }
        $time = date('Y-m-d H:i:s', strtotime($date));
    
        // 更新された機械が0の場合、削除しない
        $sql = 'SELECT
          count(*) 
        FROM
          eipses2 
        WHERE
          site_id = ? AND
          changed_at >= ? AND
          deleted_at IS NULL;';
        $res = $this->_db->fetchOne($sql, array($siteId, $time));
        if ($res == 0) {
            return 'no update/insert machine.';
        }

        // 更新されなかった機械情報を論理削除する
        $where = $this->_db->quoteInto(' site_id = ?', $siteId);
        $where.= $this->_db->quoteInto(' AND changed_at < ? ', $date);
        $where.= ' AND deleted_at IS NULL ';
        $result = $this->update(array('deleted_at' => $time), $where);
        
        return $result . ' machines delete success.';
    }
    
    /**
     * 期間指定配列を取得する
     *
     * @access public
     * @return string array 期間指定配列
     */
    public function getPeriods()
    {
        return $this->_periods;
    }
    
    /**
     * 検索クエリからWHERE句の生成
     *
     * @access private
     * @param array $q 検索クエリ
     * @param string $ignore WHEREを生成しない条件項目
     * @return string where句
     */
    private function _makeWhere(array $q, $ignore=NULL)
    {
        $arr = array();
        
        // EIPS ID（複数選択可）
        if (!empty($q['id'])) {
            $arr[] = $this->_db->quoteInto(' e.id IN (?) ', $q['id']);
        }
        
        // ジャンルID（複数選択可）
        if (!empty($q['genre_id']) && $ignore != 'genre_id') {
            $arr[] = $this->_db->quoteInto(' e.genre_id IN (?) ', $q['genre_id']);
        }
        
        // メーカー
        if (!empty($q['maker']) && $ignore != 'maker') {
            $arr[] = $this->_db->quoteInto(' e.maker IN (?) ', $q['maker']);
        }
        
        // 型式
        if (!empty($q['model']) && $ignore != 'model') {
            // 部分一致
            $sql = ' e.keywords LIKE ? ';
            $mo = '%' . $this->modelFilter($q['model']). '%';
            $arr[] = $this->_db->quoteInto($sql, $mo);
        }
        
        // マイリスト
        if (!empty($q['mylist']) && $ignore != 'mylist') {
            $sql = ' CAST ( e.id AS text) IN ( 
                SELECT query
                FROM mylists
                WHERE deleted_at IS NULL AND user_id IN (?)) ';
            $arr[] = $this->_db->quoteInto($sql, $q['mylist']);
        }
        
        return implode(' AND ', $arr);
    }
    
    /**
     * クエリ・期間指定からWHERE句の生成
     * 候補がなければ、新規登録、24時間以内
     *
     * @access private
     * @param  array $q 検索クエリ
     * @return string where句
     */
    private function _makeQueryWhere(array $q)
    {
        $query  = !empty($q['query'])  ? $q['query']  : NULL;
        $period = !empty($q['period']) ? $q['period'] : NULL;
        $date   = !empty($q['date'])   ? $q['date']   : NULL;
        
        $userId = !empty($q['user_id']) ? $q['user_id'] : NULL;
        
        $arr           = array();
        $periodCol     = ' e.created_at ';
        $periodDefault = ' -1days ';
        
        // 検索指定
        if ($query == 'deleted') {
            $arr[] = ' e.deleted_at IS NOT NULL ';
            
            $periodCol = ' e.deleted_at ';
        } else if ($query == 'mylist') {
            $sql = " CAST ( e.id AS text) IN (SELECT query FROM mylists WHERE deleted_at IS NULL AND target = 'eips' AND user_id = ?)";
            $arr[] = $this->_db->quoteInto($sql, $userId);
            
            $periodDefault = NULL;
        } else {
            // news(デフォルト)
            // $arr[] = ' e.deleted_at IS NULL ';
        }
        
        // 期間と日付
        if ($period == 'input' && !empty($date)) {
            // 日付指定
            $arr[] = $this->_db->quoteInto($periodCol . ' >= ? ', $date);
        } else if (!empty($period) || !empty($periodDefault)) {
            // 期間指定
            if (empty($this->_periods[$period]) || $period == 'input') {
                $period = $periodDefault;
            }
            
            $arr[] = $this->_db->quoteInto($periodCol . ' > current_timestamp + ? ', $period);
        }
        
        // ジャンルがない情報を除外
        $arr[] = ' e.genre_id IS NOT NULL ';
        
        return implode(' AND ', $arr);
    }
    
    /**
     * 検索クエリの詳細を取得
     *
     * @access public
     * @param  array  $q   検索クエリ
     * @return array フィルタリング後の検索クエリ
     */
    public function queryDetail($q)
    {
        $detail = array();
        $query  = array();
        $label  = array();
        
        // ジャンルID（複数選択可）
        if (isset($q['genre_id'])) {
            $temp[] = $this->_db->quoteInto("
                SELECT 'g' as key, g.id as id, g.genre as label
                FROM genres g
                WHERE g.id IN(?) ",
                $q['genre_id']
            );
        }
        
        // ジャンルID（複数選択可）
        if (isset($q['model'])) {
            $detail[] = array(
                'key'   => 'mo',
                'data'  => $q['model'],
                'label' => $q['model'],
            );
        }
        
        // メーカー名
        if (isset($q['maker'])) {
            $detail[] = array(
                'key'   => 'ma',
                'data'  => $q['maker'],
                'label' => $q['maker'],
            );
        }
        
        // URIクエリ、ページタイトルラベル生成
        foreach ($detail as $val) {
            $label[] = $val['label'];
            $query[] = $val['key'] . '[]=' . $val['data'];
        }
        
        return array(
            'detail' => $detail,
            'query'  => implode('&', $query),
            'label'  => implode('／', $label)
        );
    }
}


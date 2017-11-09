<?php
/**
 * access_logテーブルモデルクラス
 *
 */
require_once 'Zend/Db/Table.php';
class Actionlog extends Zend_Db_Table_Abstract
{
    protected $_name = 'actionlogs';
    
    /**
     * アクションログをに挿入
     *
     * @access public
     * @param  string $target 対象システム
     * @param  string $action アクション
     * @param  string $id アクションID(テーブルはアクションによって変化)
     * @param  string $contents そのた内容
     * @return $this
     */
    public function set($target, $action, $id=NULL, $contents=NULL)
    {
        // ロボットをエスケープ
        $hostname = gethostbyaddr($_SERVER['REMOTE_ADDR']);
        if (preg_match('/(google|yahoo|naver|msnbot|ahrefs|baidu)/', $hostname)) { return $this; }

        // エスケープ
        $user_id = !empty($_SESSION['user']['id']) ? $_SESSION['user']['id'] : NULL;
        
        $q = array(
            'target'    => B::filter($target),
            'action'    => B::filter($action),
            'user_id'   => $user_id,
            'ip'        => $_SERVER['REMOTE_ADDR'],
            'hostname'  => $hostname,
            'action_id' => B::filter($id),
            'contents'  => B::filter($contents)
        );
        $result = $this->_db->insert('actionlogs', $q);
        
        return $this;
    }
    
    /**
     * access_logチェック（再読み込み対策）
     *
     * @access public
     * @param  string $url 入力するページURL
     * @param  string $referer リファラURL
     * @param  string $topUrl トップURL（URLチェック用）
     * @return boolean
     */
     /*
    public static function check($url, $referer, $topUrl)
    {
        // エスケープ
        $url        = urldecode($url);
        $referer    = urldecode($referer);
        
        // 正規表現でページURLとリファラを比較する
        if (!preg_match('/' . preg_quote($url, '/') . '$/', $referer)) {
            return true;
        } elseif (($url == '/') && ($referer != $topUrl)) {
            return true;
        } else {
            return false;
        }
    }
    */
    
    /**
     * access_log一覧を取得する
     *
     * @access public
     * @param  array $q 取得クエリ
     * @return array access_log一覧
     */
    public function getList($q)
    {
        //// 検索クエリからWHERE句の生成 ////
        $arr = array();
        $limit = '';
        
        // Googlebot,yahooを除外
        $arr[] = " hostname NOT LIKE '%google%' ";
        $arr[] = " hostname NOT LIKE '%yahoo%' ";
        $arr[] = " hostname NOT LIKE '%naver%' ";
        $arr[] = " hostname NOT LIKE '%ahrefs%' ";
        $arr[] = " hostname NOT LIKE '%msnbot%' ";
        
        if (empty($q['month']) || $q['month'] == 'now') {
            $arr[] = $this->_db->quoteInto(' CAST(l.created_at as DATE) >= ?', date('Y-m-d', strtotime('- 7day')));
            $arr[] = $this->_db->quoteInto(' CAST(l.created_at as DATE) <= ?', date('Y-m-d'));
        } else {
            $arr[] = $this->_db->quoteInto(' CAST(l.created_at as DATE) >= ?', date('Y-m-01', strtotime($q['month'])));
            $arr[] = $this->_db->quoteInto(' CAST(l.created_at as DATE) <= ?', date('Y-m-t', strtotime($q['month'])));
        }
        
        if (!empty($q['action'])) {
            $arr[] = $this->_db->quoteInto(' l.action = ?', $q['action']);
        }
        
        if (!empty($q['target'])) {
            $arr[] = $this->_db->quoteInto(' l.target = ?', $q['target']);
        }
        
        if (!empty($q['user_id'])) {
            $arr[] = $this->_db->quoteInto(' l.user_id = ?', $q['user_id']);
        }
        
        $where = !empty($arr) ? ' WHERE ' . implode(' AND ', $arr) : '';
        
        //// LIMIT句、OFFSET句を作成 ////
        if (!empty($q['limit'])) {
            $offset = intval($q['limit'] * ($q['page'] - 1));
            $limit  = $this->_db->quoteInto(' LIMIT ? ', $q['limit']);
            $limit .= $this->_db->quoteInto(' OFFSET ? ', $offset);
        }
        
        //// 検索クエリを作成・実行 ////
        $sql = "SELECT
          l.*, 
          u.user_name, 
          u.role 
        FROM
          actionlogs l 
          LEFT JOIN users u 
            ON u.id = l.user_id
        {$where}
        ORDER BY created_at DESC {$limit};";
        $result = $this->_db->fetchAll($sql);
        
        return $result;
    }
    
    /**
     * access_log総数を取得する
     *
     * @access public
     * @param  array $q 取得クエリ
     * @return integer access_log総数
     */
    public function getListCount($q)
    {
        //// 検索クエリからWHERE句の生成 ////
        $arr = array();
        $where = '';
        
        if (!empty($q['action'])) {
            $arr[] = $this->_db->quoteInto(' l.action = ?', $q['action']);
        }
        
        if (!empty($q['target'])) {
            $arr[] = $this->_db->quoteInto(' l.target = ?', $q['target']);
        }
        
        if (!empty($q['user_id'])) {
            $arr[] = $this->_db->quoteInto(' l.user_id = ?', $q['user_id']);
        }
        
        if (!empty($arr)) {
            $where = ' WHERE ' . implode(' AND ', $arr);
        }
        
        //// 検索クエリを作成・実行 ////
        $db = $this->getAdapter();
        $sql = "SELECT count(*) FROM actionlogs l {$where};";
        $result = $this->_db->fetchOne($sql);
        
        return $result;
    }
    
    /**
     * 各会社の機械ごと詳細ページ表示数を取得する
     *
     * @access public
     * @param  integer $companyId 会社ID
     * @return array 機械IDと表示数のペア
     */
    public function getMachineCountPair($companyId)
    {
        //// 検索クエリからWHERE句の生成 ////
        $arr = array();
        $where = '';
        $limit = '';
        
        // Googlebot,yahooを除外
        /*
        $arr[] = " hostname NOT LIKE '%google%' ";
        $arr[] = " hostname NOT LIKE '%yahoo%' ";
        $arr[] = " hostname NOT LIKE '%naver%' ";
        $arr[] = " hostname NOT LIKE '%ahrefs%' ";
        $arr[] = " hostname NOT LIKE '%msnbot%' ";
        */
        
        if (!empty($arr)) { $where = ' AND ' . implode(' AND ', $arr); }
        
        //// 検索クエリを作成・実行 ////
        $sql = "SELECT
          a.action_id, 
          count(*) 
        FROM
          actionlogs a 
        WHERE
          a.target = 'machine' AND
          a.ACTION = 'machine_detail' AND
          a.created_at > CURRENT_TIMESTAMP + '-1week' AND
          a.action_id IN ( 
            SELECT
              m.id 
            FROM
              machines m 
            WHERE
              m.company_id = ? AND
              m.deleted_at IS NULL {$where}
          ) 
        GROUP BY
          a.action_id;";
        $result = $this->_db->fetchPairs($sql, $companyId);
        
        return $result;
    }
}

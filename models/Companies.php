<?php
/**
 * 掲載会社情報テーブルクラス
 *  
 * @access  public
 * @author  川端洋平
 * @version 0.2.0
 * @since   2014/11/06
 */
class Companies extends MyTable
{
    protected $_name              = 'companies';
    protected $_primary           = 'id';

    //// 共通設定 ////
    protected $_jname             = '会社情報';
    protected $_view              = 'view_companies';
    
    // 内容がJSONのカラム
    protected $_jsonColumns       = array('infos', 'imgs', 'offices', 'bid_entries');
    protected $_memberJsonColumns = array('infos', 'imgs', 'offices');

    // 検索SQLのORDER BY句
    protected $_orderBys          = array(
        'group'   => ' t.root_id, t.group_id, t.company_kana, t.id ',
        'region'  => ' t.region_order_no, t.state_order_no, t.company_kana, t.id ',
        'company' => ' t.company_kana, t.company, t.id ',
    );
    
    // フィルタ条件
    protected $_filters           = array('rules' => array(
        '会社名'               => array('fields' => 'company',           'NotEmpty'),
        '会社名カナ'           => array('fields' => 'company_kana',      'NotEmpty'),
        '代表者名'             => array('fields' => 'representative',    'NotEmpty'),

        '〒'                   => array('fields' => 'zip',               'NotEmpty'),
        '住所(都道府県)'       => array('fields' => 'addr1',             'NotEmpty'),
        '住所(市区町村)'       => array('fields' => 'addr2',             'NotEmpty'),
        '住所(番地その他)'     => array('fields' => 'addr3',             'NotEmpty'),
        '緯度'                 => array('fields' => 'lat',               'Float'),
        '経度'                 => array('fields' => 'lng',               'Float'),

        '代表TEL'              => array('fields' => 'tel',               'NotEmpty'),
        '代表FAX'              => array('fields' => 'fax',               'NotEmpty'),
        '代表メールアドレス'   => array('fields' => 'mail',              'EmailAddress'),
        'ウェブサイトアドレス' => array('fields' => 'website',           array('Callback', 'Zend_Uri::check')),
        '団体ID'               => array('fields' => 'group_id',          'Digits'),
        'ランク'               => array('fields' => 'rank',              'Digits'),
        '親会社ID'             => array('fields' => 'parent_company_id', 'Digits'),
    ), 'filters' => array(
         'rank'                => array(array('Callback', 'Companies::formatRank')),
    ));
    
    protected $_memberFilters     = array('rules' => array(        
        '担当者'                     => array('fields' => 'officer',      'NotEmpty'),
        'お問い合わせTEL'            => array('fields' => 'contact_tel',  'NotEmpty'),
        'お問い合わせFAX'            => array('fields' => 'contact_fax',  'NotEmpty'),
        'お問い合わせメールアドレス' => array('fields' => 'contact_mail', 'EmailAddress'),
        'その他情報'                 => array('fields' => 'infos',),
        '営業所情報'                 => array('fields' => 'offices',),
        'TOP画像'                    => array('fields' => 'top_img',),
        '画像ファイル'               => array('fields' => 'imgs',),
    ));

    // 会員ランクのレート
    const RANK_A = 200;
    const RANK_B = 100;
    const RANK_C = 0;

    protected static $_rankRatio = array(
        200 => 'A会員',
        100 => 'B会員',
        0   => 'C会員',
        201 => '支店・営業所',
        202 => '特別会員',
    );

    //// 配列定数のGETTER ////
    static public function getRankRatio() { return self::$_rankRatio; }

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

        if (!empty($q['id'])) {
            $whereArr[] = $this->_db->quoteInto(' t.id IN (?) ', $q['id']);
        }
        
        if (!empty($q['group_id'])) {
            $whereArr[] = $this->_db->quoteInto(' t.group_id IN (?) ', $q['group_id']);
        }
        
        if (!empty($q['root_id'])) {
            $whereArr[] = $this->_db->quoteInto(' t.root_id IN (?) ', $q['root_id']);
        }
        
        if (!empty($q['notnull'])) {
            $whereArr[] = ' t.count IS NOT NULL ';
            $whereArr[] = ' t.rank >= 200 ';            
        }

        if (!empty($q['rank'])) {
            $whereArr[] = $this->_db->quoteInto(' t.rank >= ? ', self::formatRank($q['rank']));
        }

        if (!empty($q['rankeq'])) {
            $whereArr[] = $this->_db->quoteInto(' t.rank = ? ', self::formatRank($q['rankeq']));
        } else if (isset($q['rankeq'] ) && $q['rankeq'] === '0') {
            $whereArr[] = ' (t.rank = 0 OR t.rank IS NULL) ';
        }

        if (!empty($q['is_parent'])) {
            $whereArr[] =' t.parent_company_id IS NULL ';
        }
        // var_dump($whereArr);
        return $whereArr;
    }

    /**
     * 検索クエリからORDER BY句の生成
     *
     * @access protected
     * @param  array   $q 検索クエリ
     * @return string  生成したwhere句
     */
    protected function _makeOrderBySql($q)
    {
        $sort = '';
        if      (!empty($q['is_region'])) { $sort = 'region'; }
        else if (!empty($q['notnull']))   { $sort = 'company'; }

        return parent::_makeOrderBySql(array('sort' => $sort));
    }

    
    /**
     * 所属団体から会社情報件数(メール送信用)を取得
     *
     * @access public
     * @param  string $id 団体ID(NULLの場合は、すべて)
     * @return array  団体情報と件数(メールアドレスがある場合のみ)
     */
    public function countForMail($groupId=NULL)
    {
        $whereSql = '';
        if (!empty($groupId)) {
            $whereSql.= $this->_db->quoteInto(' c.group_id IN ( SELECT g2.id FROM groups g2 WHERE g2.parent_id = ? ', $groupId);
            $whereSql.= $this->_db->quoteInto(' OR c.group_id = ? ) AND ', $groupId);
        }
        
        $sql = "SELECT count(c.*) FROM view_companies c WHERE {$whereSql} (c.mail IS NOT NULL AND c.mail <> '');";
        $result = $this->_db->fetchOne($sql);

        return $result;
    }
    
    /**
     * 所属団体から会社情報一覧数(メール送信用)を取得
     *
     * @access public
     * @param  string $groupId 団体ID(NULLの場合は、すべて)
     * @return array  会社情報一覧(メールアドレスがある場合のみ)
     */
    public function getListForMail($groupId=NULL)
    {
        $whereSql = '';
        if (!empty($groupId)) {
            $whereSql.= $this->_db->quoteInto(' c.group_id IN ( SELECT g2.id FROM groups g2 WHERE g2.parent_id = ? ', $groupId);
            $whereSql.= $this->_db->quoteInto(' OR c.group_id = ? ) AND ', $groupId);
        }
        
        $sql = "SELECT c.company, c.mail FROM companies c WHERE {$whereSql} (c.mail IS NOT NULL AND c.mail <> '');";
        $result = $this->_db->fetchAll($sql);

        return $result;
    }
    
    /**
     * 会社情報をセット(会員ページ用)
     * 
     * @access public
     * @param  intetger $companyId 会社ID      
     * @param  array    $data      入力データ
     * @return $this
     */                    
    public function memberSet($companyId, $data)
    {
        if (empty($id)) { throw new Exception('会社IDがありません'); }
        
        //// フィルタリング・バリデーション・JSONエンコード(会員ページ用の保存項目)  ////
        $data = MyFilter::filter($data, $this->_memberFilters, $this->_jsonColumns);
        
        // 会員ページ用なので変更のみ、新規登録は行えない        
        $data['changed_at'] = new Zend_Db_Expr('current_timestamp');
        $result = $this->update($data, $this->_db->quoteInto('id = ?', $companyId));
        if (empty($result)) { throw new Exception('会社情報が保存できませんでした'); }
        
        return $this;
    }
    
    /**
     * 会社情報をセット(管理者ページ用)
     * 
     * @access public
     * @param  integer $companyId 会社ID 
     * @param  array   $data      入力データ
     * @return $this
     */                    
    public function set($companyId = null, $data)
    {
        //// フィルタリング・バリデーション ////
        $data = MyFilter::filter($data, $this->_filters);
        
        if (empty($companyId)) {
            // 新規処理
            // デフォルトとして問い合わせ情報に代表者のものをコピー
            $data['contact_tel']  = $data['tel'];
            $data['contact_fax']  = $data['fax'];
            $data['contact_mail'] = $data['mail'];
            $res = $this->insert($data);
        } else {
            // 更新処理
            $data['changed_at'] = new Zend_Db_Expr('current_timestamp');
            $res = $this->update($data, $this->_db->quoteInto('id = ?', $companyId));
        }
        
        if (empty($res)) { throw new Exception('会社情報が保存できませんでした'); }
        
        return $this;
    }
    
    /**
     * 会社情報(Web入札会商品出品登録)をセット
     * 
     * @access public
     * @param  integer $companyId 会社ID 
     * @param  array   $data      入力データ
     * @return $this
     */                    
    public function setBidEntries($companyId, $data)
    {
        if (empty($companyId)) { throw new Exception('会社IDがありません'); }
        
        // JSONデータ保管
        $temp['bid_entries'] = json_encode($data['bid_entries'], JSON_UNESCAPED_UNICODE);
        $temp['changed_at']  = new Zend_Db_Expr('current_timestamp');
        
        $result = $this->update($temp, $this->_db->quoteInto('id = ?', $companyId));
        
        if (empty($result)) { throw new Exception('会社情報(Web入札会商品出品登録)が保存できませんでした'); }
        
        return $this;
    }

    /**
     * 会社情報のランクをチェック
     * 
     * @access public
     * @param  mixed   $data チェックするランク情報
     * @param  mixed   $rank 比較対象のランク情報
     * @return boolean チェック結果
     */                    
    static public function checkRank($data, $rank)
    {
        // 20141231までは、チェック処理をしない
        // return true;
        
        $data = self::formatRank($data);
        $rank = self::formatRank($rank);

        return $rank <= intval($data) ? true : false;
    }

    /**
     * ランクの表示文字列を取得
     * 
     * @access public
     * @param  mixed  $data 表示文字列を取得するランク情報
     * @return string 表示文字列
     */                    
    static public function getRankLabel($data)
    {
        $data = self::formatRank($data);
        return self::$_rankRatio[$data];
    }

    /**
     * 会社情報のランク情報を整形(数値だった場合は下の一番近いものに整形、)
     * 
     * @access public
     * @param  mixed   $data 整形するランク情報
     * @return integer 整形されたランク数値
     */                    
    static public function formatRank($data)
    {
        $result = 0; // ランク数値のデフォルトは0(C会員)

        if (empty($data)) {
            // 値がNULLの場合は、デフォルト
        } else if (is_numeric($data)) {
            if (!empty(self::$_rankRatio[$data])) {
                // 丁度の値がある場合は、そのままの数値を返す
                $result = $data;
            } else {
                // 丁度の値でない場合は、低い方の近似値を探す
                foreach(self::$_rankRatio as $val => $r) {
                    if ($data - $val >= 0 && $val > $result) { $result = $val; }
                }
            }
        } else if ($temp = array_search($data, self::$_rankRatio)) {
            // ランク情報が文字列で渡された場合、配列を検索
            $result = $temp;
        } 

        return $result;
    }
}

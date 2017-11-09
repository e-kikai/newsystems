<?php
/**
 * 自社サイトテーブルクラス
 * 
 * @access public
 * @author 川端洋平
 * @version 0.2.0
 * @since 2014/11/05
 */
class Companysites extends MyTable
{
    protected $_name          = 'companysites';
    protected $_primary       = 'companysite_id';

    //// 共通設定 ////
    protected $_jname         = '自社サイト';
    protected $_view          = 'view_companysites';
    protected $_jsonColumns   = array('page_configs', 'company_configs');
    
    protected $_filters       = array('rules' => array(
        '会社ID'       => array('fields' => 'company_id', 'Digits', 'NotEmpty'),
        'サブドメイン' => array('fields' => 'subdomain',  'Alnum',  'NotEmpty'),
        '閉鎖フラグ'   => array('fields' => 'closed',     'Digits'),
    ));

    protected $_memberFilters = array('rules' => array(
        'ページ内容'   => array('fields' => 'contents',),
        'サイト設定郡' => array('fields' => 'page_configs',),
        '会社設定郡'   => array('fields' => 'company_configs',),
        'テンプレート' => array('fields' => 'template',),
    ));

    // テンプレート配色
    protected static $_templateColors = array(
        'red'         => array(0),
        'orange'      => array(30),
        'yellow'      => array(60),
        'yellowgreen' => array(90),
        'lime'        => array(120),
        'green'       => array(150),
        'sky'         => array(180),
        'cyan'        => array(210),
        'blue'        => array(240),
        'purple'      => array(270),
        'moa'         => array(300),
        'pink'        => array(330),
    );

     // テンプレート装飾(未実装)
    protected static $_templateDecos = array('01' => '');

    //// 配列定数のGETTER ////
    static public function getTempalteColors() { return self::$_templateColors; }
    static public function getTempalteDecos()  { return self::$_templateDecos; }
    static public function getTempalteList()   {
        $res = array();
        foreach (self::$_templateDecos as $dKey => $d) {
            foreach (self::$_templateColors as $cKey => $c) {
                $res[] = "{$cKey}_{$dKey}";
            }
        }

        return $res;
    }

    const URL_RULE = "/^\/s\/([^\/]*)/"; // URLからサブドメインを取得する正規表現ルール

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

        // 会員条件によって
        
        return $whereArr;
    }

    /**
     * 自社サイト情報を会社IDから取得
     *
     * @access public
     * @param  integer $companyId 会社ID
     * @return array   自社サイト情報
     */
    public function getByCompanyId($companyId)
    {
        //// 自社サイトを取得 ////
        if (empty($companyId)) {
            throw new Exception('取得する会社IDがありません');
        }
        
        // SQLクエリを作成
        $sql = "SELECT s.* FROM view_companysites s WHERE s.company_id = ?; ";
        $result = $this->_db->fetchRow($sql, $companyId);
        
        // JSON展開
        $result = B::decodeRowJson($result, $this->_jsonColumns);

        return $result;
    }

    /**
     * 自社サイト情報をURLからサブドメインを切り出す処理を行ってから取得
     *
     * @access public
     * @param  string $url サイトURL
     * @return array  自社サイト情報
     */
    public function getByUrl($url)
    {
        if (empty($url)) { throw new Exception('取得するサイトURLがありません'); }

        //// URLからサブドメイン取得 ////
        if (!preg_match(self::URL_RULE, $url, $re)) { throw new Exception('このURLのサイトはありません'); }
        
        //// 取得したサブドメインから、サイト情報を取得する ////
        return $this->getBySubdomain($re[1]);
    }

    /**
     * 自社サイト情報をサブドメインから取得
     *
     * @access public
     * @param  string $subdomain サブドメイン(サイト名)
     * @return array  自社サイト情報
     */
    public function getBySubdomain($subdomain)
    {
        if (empty($subdomain)) { throw new Exception('取得するサイト名がありません'); }
        
        // SQLクエリを作成
        $sql = "SELECT s.* FROM view_companysites s WHERE s.subdomain = ?;";
        $result = $this->_db->fetchRow($sql, $subdomain);

        if (empty($result))            { throw new Exception('サイト情報を取得できませんでした'); }
        if (!empty($result['closed'])) { throw new Exception('このサイトは、現在閉鎖されています'); }
        
        // JSON展開
        $result = B::decodeRowJson($result, $this->_jsonColumns);

        return $result;
    }

    /**
     * 自社サイト情報をセット(会員ページ用、会社IDで識別する)
     * 
     * @access public
     * @param  intetger $companyId 会社ID      
     * @param  array    $data      入力データ
     * @return $this
     */                    
    public function memberSetByCompanyId($companyId, $data)
    {
        if (empty($companyId)) { throw new Exception('会社IDがありません'); }
        
        /// 画像ファイルを実ディレクトリに移動 ////
        if (!empty($data['company_configs']['top_img'])) {
            $_conf = Zend_Registry::get('_conf');
            $f     = new File();
            $data['company_configs']['top_img'] = $f->checkOne(
                $data['company_configs']['top_img'], array(),
                $_conf->tmp_path,
                $_conf->htdocs_path . '/media/companysite',
                true);
        }
        
        //// フィルタリング・バリデーション・JSONエンコード(会員ページ用の保存項目)  ////
        $data = MyFilter::filtering($data, $this->_memberFilters, $this->_jsonColumns);

        // 会員ページ用なので変更のみ、新規登録は行えない        
        $data['changed_at'] = new Zend_Db_Expr('current_timestamp');
        $result = $this->update($data, $this->_db->quoteInto('company_id = ?', $companyId));

        if (empty($result)) { throw new Exception('会社情報が保存できませんでした'); }
        
        return $this;
    }
    /**
     * 情報を保存(管理者ページ用)
     * 
     * @access public 
     * @param  integer $id   保存対象のID(NULLの場合は新規登録)
     * @param  array   $data 保存する情報
     * @return $this
     */                    
    public function set($id=null, $data)
    {
        // 保存するサブドメインがすでに使われていないかチェックする
        if (!$this->checkSubdomain($data['subdomain'], $id)) {
            throw new Exception('このサイト名はすでに作成されています');
        }

        // 新規作成時、すでに同じ会社IDでページが作成されていないかチェック
        if ($id == null) {
            $sql = 'SELECT companysite_id FROM view_companysites WHERE company_id = ?;';
            $res = $this->_db->fetchOne($sql, $data['company_id']);
            if (!empty($res)) { throw new Exception('この会社のサイトはすでに作成されています'); }
        }

        parent::set($id, $data);

        return $this;
    }

    /**
     * サブドメイン・会社IDがすでに使用されているかチェックする
     * 
     * @access public
     * @param  string  $subdomain     チェックするサブドメイン
     * @param  integer $companysiteId 更新時、現在使用中のサブドメインをチェックから除外する
     * @return $this
     */                    
    public function checkSubdomain($subdomain, $companysiteId=null)
    {
        $sql = 'SELECT companysite_id FROM view_companysites WHERE subdomain = ? AND companysite_id <> ?;';
        $result = $this->_db->fetchOne($sql, array($subdomain, intval($companysiteId)));

        return empty($result) ? true : false;
    }

    static function hsv2rgb($h, $s, $v, $a=1)
    {
        if ( $s == 0 ) {
            $r = $v * 255;
            $g = $v * 255;
            $b = $v * 255;
        } else {
            $h = ($h >= 0) ? $h % 360 / 360 : $h % 360 / 360 + 1;
            $var_h = $h * 6;
            $i = (int)$var_h;
            $f = $var_h - $i;
             
            $p = $v * ( 1 - $s );
            $q = $v * ( 1 - $s * $f );
            $t = $v * ( 1 - $s * ( 1 - $f ) );
             
            switch($i){
                case 0:
                    $var_r = $v;
                    $var_g = $t;
                    $var_b = $p;
                    break;
                case 1:
                    $var_r = $q;
                    $var_g = $v;
                    $var_b = $p;
                    break;
                case 2:
                    $var_r = $p;
                    $var_g = $v;
                    $var_b = $t;
                    break;
                case 3:
                    $var_r = $p;
                    $var_g = $q;
                    $var_b = $v;
                    break;
                case 4:
                    $var_r = $t;
                    $var_g = $p;
                    $var_b = $v;
                    break;
                default:
                    $var_r = $v;
                    $var_g = $p;
                    $var_b = $q;
            }
            // $r = $var_r * 255;
            // $g = $var_g * 255;
            // $b = $var_b * 255;

            $r = floor($var_r * 255);
            $g = floor($var_g * 255);
            $b = floor($var_b * 255);  
        }
        //return array($r, $g, $b);
        if ($a < 1) { return "rgba({$r}, {$g}, {$b}, {$a});"; }
        else        { return "#".sprintf('%02x', $r). sprintf('%02x', $g) . sprintf('%02x', $b); }
    }
}
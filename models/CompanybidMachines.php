<?php
/**
 * 会員入札会機械テーブルクラス
 * 
 * @access public
 * @author 川端洋平
 * @version 0.2.0
 * @since 2014/10/15
 */
class CompanybidMachines extends MyTable
{
    protected $_name        = 'companybid_machines';
    protected $_primary     = 'companybid_machine_id';

    //// 共通設定 ////
    protected $_view        = 'view_companybid_machines';
    protected $_jname       = '会員入札会機械';
    protected $_jsonColumns = array('imgs');
    
    // フィルタ条件
    protected $_filter = array('rules' => array(
        '会員入札会ID' => array('fields' => 'companybid_open_id', 'Digits'),
        '商品番号'     => array('fields' => 'list_no',            'NotEmpty'),
        '機械名'       => array('fields' => 'name',               'NotEmpty'),
        'ジャンルID'   => array('fields' => 'genre_id',           'Digits', 'NotEmpty'),
        'メーカー'     => array('fields' => 'maker',),
        '型式'         => array('fields' => 'maker',),
        '年式'         => array('fields' => 'year',),
        '仕様'         => array('fields' => 'spec',),
        '最低入札金額' => array('fields' => 'min_price',          'Digits'),
        '入札金額備考' => array('fields' => 'min_price_comment',),
        
        // 画像ファイルJSON(file_name)
        '画像'         => array('fields' => 'imgs',),
    ));

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
        
        // 会員入札会ID(必須)
        if (!empty($q['companybid_open_id'])) {
            $whereArr[] = $this->_db->quoteInto(' t.companybid_open_id IN(?) ', $q['companybid_open_id']);
        } else {
            throw new Exception('取得する会員入札会が選択されていません'); 
        }
        
        // 特大ジャンルID（複数選択可）
        if (!empty($q['xl_genre_id'])) {
            $whereArr[] = $this->_db->quoteInto(' t.xl_genre_id IN(?) ', $q['xl_genre_id']);
        }

        // 大ジャンルID（複数選択可）
        if (!empty($q['large_genre_id'])) {
            $whereArr[] = $this->_db->quoteInto(' t.large_genre_id IN(?) ', $q['large_genre_id']);
        }
        // ジャンルID（複数選択可）
        if (!empty($q['genre_id'])) {
            $whereArr[] = $this->_db->quoteInto(' t.genre_id IN(?) ', $q['genre_id']);
        }
        
        // 機械ID（複数選択可）
        if (!empty($q['id']) && count($q['id'])) {
            $whereArr[] = $this->_db->quoteInto(' t.companybid_machine_id IN(?) ', $q['id']);
        }
        
        // リストNo（複数選択可）
        if (!empty($q['list_no']) && count($q['list_no'])) {
            $whereArr[] = $this->_db->quoteInto(' t.list_no IN(?) ', $q['list_no']);
        }
        
        // メーカー
        if (!empty($q['maker'])) {
            $whereArr[] = $this->_db->quoteInto(' t.maker IN (?) ', $q['maker']);
        }
        
        // 下見会場
        if (!empty($q['location'])) {
            $whereArr[] = $this->_db->quoteInto(' t.location IN (?) ', $q['location']);
        }
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
        // デフォルトはリストNo順
        $orderBy = " substring('a' || t.list_no from '^[^0-9]+'), to_number(substring(t.list_no from '[0-9]+$'),'9999999999'), t.{$this->_primary} ";

        return " ORDER BY " . $orderBy;
    }

    /**
     * 会員入札会機械情報をセット
     * 
     * @access public     
     * @param  array   $data 会員入札会データ
     * @param  array   $file アップロードファイル
     * @param  integer $id   入札会バナーID
     * @return $this
     */                    
    public function set($id=null, $data, $file=null)
    {        
        //// 画像をアップロードする前に、情報のフィルタリング・バリデーションを行う ////
        if (!empty($this->_filter)) {
            $data = MyFilter::filtering($data, $this->_filter);
        }

        /*
        //// バナー画像アップロード ////
        if (!empty($file['tmp_name'])) {
            $f = new File();
            $f->setPath(Zend_Registry::get('_conf')->htdocs_path . '/media/banner/');
            $data['banner_file'] = $f->upload($file, 'banner_' . date('YmdHis'), 'image/*');
        }
        */
        parent::set($id, $data);

        return $this;
    }

    public function getXlGenreList($q)
    {
        //// WHERE句 ////
        $whereSql = $this->_makeWhereSql($q);
        
        //// SQLクエリを作成・一覧を取得 ////
        $sql = "SELECT
          t.xl_genre_id,
          t.xl_genre,
          t.xl_order_no,
          count(t.xl_genre_id) AS count,
          ( 
            SELECT
              bm2.imgs 
            FROM
              view_companybid_machines bm2 
            WHERE
              (bm2.imgs IS NOT NULL OR bm2.imgs <> '[]' OR bm2.imgs <> '') AND
              bm2.companybid_open_id = ? AND
              bm2.xl_genre_id = t.xl_genre_id 
            ORDER BY
              random() 
            LIMIT
              1
          ) as imgs
        FROM
          view_companybid_machines t
        {$whereSql}
        GROUP BY
          t.xl_genre_id,
          t.xl_genre,
          t.xl_order_no
        ORDER BY
          t.xl_order_no,
          t.xl_genre_id;";
        $result = $this->_db->fetchAll($sql, $q['companybid_open_id']);

        // JSON展開
        $result = B::decodeTableJson($result, array('imgs'));
        
        return $result;
    }
    
    public function getLargeGenreList($q)
    {
        //// WHERE句 ////
        $whereSql = $this->_makeWhereSql($q);
        
        //// SQLクエリを作成・一覧を取得 ////
        $sql = "SELECT
          t.large_genre_id,
          t.xl_genre_id,
          t.large_genre,
          t.large_order_no,
          count(t.large_genre_id) AS count 
        FROM
          view_companybid_machines t
        {$whereSql}
        GROUP BY
          t.large_genre_id,
          t.xl_genre_id,
          t.large_genre,
          t.large_order_no
        ORDER BY
          t.large_order_no,
          t.large_genre_id,
          t.xl_genre_id;";
        $result = $this->_db->fetchAll($sql);
        return $result;
    }
}

<?php
/**
 * 会員入札会テーブルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.2.0
 * @since 2014/10/08
 */
class CompanybidOpens extends MyTable
{
    protected $_name        = 'companybid_opens';
    protected $_primary     = 'companybid_open_id';

    //// 共通設定 ////
    protected $_jname       = '会員入札会'; // テーブルの論理名
    protected $_jsonColumns = array('preview_locations', 'pdf_files');

    // フィルタ条件
    protected $_filter = array('rules' => array(
        '会社ID'       => array('fields' => 'company_id',           'Digits'),
        '入札会名'     => array('fields' => 'bid_name',             'NotEmpty'),
        '主催者名'     => array('fields' => 'organizer',            'NotEmpty'),

        // 下見会場JSON(会場名、住所、備考)
        '下見会場'     => array('fields' => 'preview_locations',    'NotEmpty'),
        '下見開始日'   => array('fields' => 'preview_start_date',   'NotEmpty'),
        '下見終了日'   => array('fields' => 'preview_end_date',     'NotEmpty'),
        '下見期間備考' => array('fields' => 'preview_date_comment', 'NotEmpty'),

        '入札会場名'   => array('fields' => 'bid_location',         'NotEmpty'),
        '入札会場住所' => array('fields' => 'bid_address',),
        '入札会場備考' => array('fields' => 'bid_comment',),
        '入札日時'     => array('fields' => 'bid_date',             'NotEmpty'),
        '入札日時備考' => array('fields' => 'bid_date_comment',),

        '事務局'       => array('fields' => 'office',),
        '事務局住所'   => array('fields' => 'office_address',),
        '事務局備考'   => array('fields' => 'office_comment',),

        'コメント'     => array('fields' => 'bid_comment',),

        // PDFファイルJSON(file_name => title)
        'PDFファイル'  => array('fields' => 'pdf_files',),
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

        // 終了した入札会も表示する
        if (empty($q['end']) || $q['end'] != 'all') {
            $whereArr[] = ' (t.preview_end_date > now() OR t.bid_date > now()) ';
        }

        return $whereArr;
    }

    /**
     * 会員入札会情報をセット
     *
     * @access public
     * @param  array $data 入札会バナーデータ入札会バナーデータ
     * @param  array $file アップロードファイル
     * @param  integer $id 入札会バナーID
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
}

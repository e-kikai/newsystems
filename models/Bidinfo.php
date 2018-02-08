<?php
/**
 * 入札会バナーモデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.2.0
 * @since 2014/09/04
 */
class Bidinfo extends MyTable
{
    protected $_name    = 'bidinfos';
    protected $_primary = 'id';

    // フィルタ条件
    protected $_filter = array('rules' => array(
        '入札会名'   => array('fields' => 'bid_name',           'NotEmpty'),
        // 'リンクURL'  => array('fields' => 'uri',                array('Callback', 'Zend_Uri::check')),
        'リンクURL'  => array('fields' => 'uri'),
        '主催者名'   => array('fields' => 'organizer',          'NotEmpty'),
        '入札会場'   => array('fields' => 'place',              'NotEmpty'),

        '下見開始日' => array('fields' => 'preview_start_date', 'NotEmpty'),
        '下見終了日' => array('fields' => 'preview_end_date',   'NotEmpty'),
        '入札日時'   => array('fields' => 'bid_date',           'NotEmpty'),
        'バナー画像' => array('fields' => 'banner_file',),
    ));

    // 検索SQLのORDER BY句
    protected $_orderBys          = array(
        'default'  => ' t.bid_date DESC, t.id DESC',
        'bid_date' => ' t.bid_date, t.id',
    );

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
            $whereArr[] = ' (t.preview_end_date >= CURRENT_DATE OR t.bid_date::date >= CURRENT_DATE) ';
        }

        return $whereArr;
    }

    /**
     * 入札会バナー情報をセット
     *
     * @access public
     * @param  array   $data 入札会バナーデータ入札会バナーデータ
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

        //// バナー画像アップロード ////
        if (!empty($file['tmp_name'])) {
            $f = new File();
            $f->setPath(Zend_Registry::get('_conf')->htdocs_path . '/media/banner/');
            $data['banner_file'] = $f->upload($file, 'banner_' . date('YmdHis'), 'image/*');
        }

        parent::set($id, $data);

        return $this;
    }
}

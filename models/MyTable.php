<?php

/**
 * テーブル基底クラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.2.0
 * @since 2014/10/08
 */
class MyTable extends Zend_Db_Table_Abstract
{
    /// 共通設定のデフォルト ///
    protected $_jname             = '';      // テーブルの論理名
    protected $_view              = '';      // SELECT対象(デフォルトは$_nameと一緒)
    protected $_filters           = array(); // フィルタ・バリデータ条件
    protected $_jsonColumns       = array(); // 内容をJSONエンコード・デコードするカラム
    protected $_orderBys          = array(); // 検索SQLのORDER BY句の候補配列(先頭の要素がデフォルト)

    protected $_canCheckDeletedAt = true;    // 取得条件に'deleted_at IS NULL'を含めるかどうか
    protected $_canSetChangedAt   = true;    // 保存時に'changed_at'を入れるかどうか

    public function __construct()
    {
        // $_viewが定義されていない場合、$_nameをディフォルトにする
        if (empty($this->_view)) {
            $this->_view = $this->_name;
        }

        parent::__construct();
    }

    /**
     * 情報一覧を取得
     *
     * @access public
     * @param  array $q 検索クエリ
     * @return array    取得した情報一覧の2次元配列
     */
    public function getList($q = null)
    {
        /// WHERE句を生成 ///
        $whereSql   = $this->_makeWhereSql($q);

        /// ORDER BY句を生成 ///
        $OrderBySql = $this->_makeOrderBySql($q);

        /// LIMIT句、OFFSET句を生成 ///
        $limitSql   = $this->_makeLimitSql($q);

        /// SQLクエリを作成・一覧を取得 ///
        $sql = "SELECT t.* FROM {$this->_view} t {$whereSql} {$OrderBySql} {$limitSql};";
        $result = $this->_db->fetchAll($sql);

        /// JSON展開 ///
        if (!empty($this->_jsonColumns)) {
            $result = B::decodeTableJson($result, $this->_jsonColumns);
        }

        return $result;
    }

    /**
     * 検索クエリからWHERE句の生成(このメソッドはできるだけオーバーライドしない)
     *
     * @access protected
     * @param  array   $q 検索クエリ
     * @param  boolean $check 検索条件チェック
     * @return string  生成したwhere句
     */
    protected function _makeWhereSql($q, $check = false)
    {
        $whereArr = $this->_makeWhereSqlArray($q, $check);

        // 削除日チェック
        if ($this->_canCheckDeletedAt) {
            $whereArr[] = ' t.deleted_at IS NULL ';
        }

        if (!empty($whereArr)) {
            return ' WHERE ' . implode(' AND ', $whereArr);
        } else {
            return '';
        }
    }

    /**
     * 検索クエリからWHERE句の生成用の配列を生成(このメソッドをオーバーライドする)
     *
     * @access protected
     * @param  array   $q 検索クエリ
     * @param  boolean $check 検索条件チェック
     * @return string  生成したwhere句
     */
    protected function _makeWhereSqlArray($q, $check = false)
    {
        $whereArr = array();

        // 作成例
        /*
        // 特大ジャンルID（複数選択可）
        if (!empty($q['xl_genre_id'])) {
            $whereArr[] = $this->_db->quoteInto(' m.xl_genre_id IN(?) ', $q['xl_genre_id']);
        }

        // TOP画像があるかどうか
        if (!empty($q['is_img'])) {
            $whereArr[] = " m.top_img IS NOT NULL AND m.top_img <> '' ";
        }

        /// ここまでで、検索条件チェック ///
        if ($check == true && count($whereArr) == 0) {
            return false;
        }
        */

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
        // 何も指定していない時のデフォルトは、IDの降順
        $orderBy = " t.{$this->_primary} DESC ";

        if (!empty($this->_orderBys)) {
            if (!empty($q['sort']) && array_key_exists($q['sort'], $this->_orderBys)) {
                $orderBy = $this->_orderBys[$q['sort']];
            } else {
                // 先頭要素をデフォルトとして扱う
                $orderBy = reset($this->_orderBys);
            }
        }

        return " ORDER BY " . $orderBy;
    }

    /**
     * 検索クエリからLIMIT句、OFFSET句の生成
     *
     * @access protected
     * @param  array   $q 検索クエリ
     * @return string  生成したLIMIT句、OFFSET句
     */
    protected function _makeLimitSql($q)
    {
        $limitSql = '';
        if (!empty($q['limit'])) {
            $limitSql .= $this->_db->quoteInto(' LIMIT ? ', $q['limit']);
            if (!empty($q['page'])) {
                $limitSql .= $this->_db->quoteInto(' OFFSET ? ', $q['limit'] * ($q['page'] - 1));
            }
        }

        return $limitSql;
    }

    /**
     * 総件数を取得
     *
     * @param  array   $q 検索クエリ
     * @return integer 総件数
     */
    public function getCount($q)
    {
        /// WHERE句 ///
        $whereSql = $this->_makeWhereSql($q);

        /// SQLクエリを作成・一覧を取得 ///
        $sql = "SELECT count(t.*) AS count FROM {$this->_view} t {$whereSql};";
        $result = $this->_db->fetchOne($sql);

        return $result;
    }

    /**
     * 情報を1件取得
     *
     * @access public
     * @param  integer $id $_primaryで設定したIDカラムの値
     * @return array   情報を1件取得した連想配列
     */
    public function get($id)
    {
        if (empty($id)) {
            throw new Exception("{$this->_jname}のIDが設定されていません");
        }

        // 削除日チェック
        $deletedAtSql = '';
        if ($this->_canCheckDeletedAt) {
            $deletedAtSql = ' t.deleted_at IS NULL AND ';
        }

        // SQLクエリを作成
        $sql = "SELECT t.* FROM {$this->_view} t WHERE {$deletedAtSql} t.{$this->_primary} = ? LIMIT 1;";
        $result = $this->_db->fetchRow($sql, $id);

        /// JSON展開 ///
        if (!empty($this->_jsonColumns)) {
            $result = B::decodeRowJson($result, $this->_jsonColumns);
        }

        return $result;
    }

    /**
     * 論理削除(deleted_atにcurrent_timestampを入れる処理)
     *
     * @access public
     * @param  array $id $_primaryで設定したIDカラムの値(複数可)
     * @return $this
     */
    public function deleteById($id)
    {
        if (empty($id)) {
            throw new Exception("削除する{$this->_jname}のIDが設定されていません");
        }

        // 削除条件SQLのWHERE句(該当IDかつ既に削除されていないもの)
        $whereArr = array();
        $whereArr[] = $this->_primary . $this->_db->quoteInto(' IN(?) ', $id);
        $whereArr[] = ' deleted_at IS NULL ';

        $this->update(
            array('deleted_at' => new Zend_Db_Expr('current_timestamp')),
            $whereArr
        );

        return $this;
    }

    /**
     * 情報を保存(新規・変更)
     *
     * @access public
     * @param  array   $data 保存する情報
     * @param  integer $id   保存対象のID(NULLの場合は新規登録)
     * @return $this
     */
    public function set($id = null, $data)
    {
        /// 保存する情報のフィルタリング・バリデーション・JSONエンコード ///
        $data = MyFilter::filtering($data, $this->_filters, $this->_jsonColumns);

        /// 保存処理 ///
        if (empty($id)) {
            /// 新規処理 ///
            $res = $this->insert($data);
        } else {
            /// 更新処理 ///
            if ($this->_canSetChangedAt) {
                $data['changed_at'] = new Zend_Db_Expr('current_timestamp');
            }
            $res = $this->update($data, $this->_primary . $this->_db->quoteInto(' = ? ', $id));
        }

        if (empty($res)) {
            throw new Exception("{$this->_jname}が保存できませんでした id:{$id}");
        }

        return $this;
    }
}

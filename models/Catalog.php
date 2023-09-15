<?php

/**
 * catalogsテーブルモデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.2
 * @since 2012/04/19
 */
class Catalog extends Zend_Db_Table_Abstract
{
    protected $_name = 'catalogs';

    // テンプレート候補一覧
    private $_templates = array('list', 'image_l');

    // フィルタ条件
    protected $_filter = array('rules' => array(
        '*'          => array(),
    ));

    /**
     * カタログ検索結果取得
     *
     * @access public
     * @param  array $q 検索クエリ
     * @param boolean $extra 型式特別取得
     * @return array カタログ検索結果一覧
     */
    public function search($q, $extra = false)
    {
        // 型式特別取得
        if ($extra) {
            $q = $this->_modelEx($q);
        }

        return array(
            'catalogList' => $this->getList($q),
            'count'       => $this->getListCount($q),
            'makerList'   => $this->getMakerList($q),
            'genreList'   => $this->getGenreList($q),
            'queryDetail' => $this->queryDetail($q)
        );
    }

    /**
     * カタログ一覧を取得
     *
     * @access private
     * @param  array  $q 取得する情報クエリ
     * @return array カタログ情報一覧
     */
    public function getList($q)
    {
        //// WHERE句 ////
        $where = $this->_makeWhere($q);
        if (empty($where)) {
            throw new Exception('検索条件が設定されていません');
        };

        //// LIMIT句、OFFSET句を作成 ////
        if (!empty($q['limit']) && intval($q['limit'])) {
            $l = intval($q['limit']);
            $limit = $this->_db->quoteInto(' LIMIT ? ', $l);

            if (!empty($q['page']) && intval($q['page'])) {
                $p = intval($q['page']);
                $limit .= $this->_db->quoteInto(' OFFSET ? ', ($l * ($p - 1)));
            }
        } else {
            $limit = '';
        }

        //// 検索クエリを作成・実行 ////
        $sql = "SELECT
          c.*,
          array_to_string(array_agg(g.id), '|') AS genre_ids,
          string_agg(g.genre, '|')    AS genres
        FROM
          catalogs c
          LEFT JOIN catalog_genre cg
            ON cg.catalog_id = c.id
          LEFT JOIN genres g
            ON g.id = cg.genre_id
        WHERE
          c.deleted_at IS NULL AND
          {$where}
        GROUP BY
          c.id
        ORDER BY
          c.maker_kana COLLATE \"ja_JP.utf8\" asc,
          c.models,
          c.created_at DESC
        {$limit};";
        $result = $this->_db->fetchAll($sql);
        return $result;
    }

    /**
     * カタログ情報の件数を取得
     *
     * @access public
     * @param  array  $q 取得する情報クエリ
     * @return integer カタログ総件数
     */
    public function getListCount($q = NULL)
    {
        //// WHERE句 ////
        $where = '';
        if (!empty($q)) {
            $where = ' AND ' . $this->_makeWhere($q);
        }

        // 検索クエリを作成・実行
        $sql = "SELECT count(c.*) FROM catalogs c WHERE c.deleted_at IS NULL {$where};";
        $result = $this->_db->fetchOne($sql);
        return $result;
    }

    /**
     * カタログ情報をIDから1件取得
     *
     * @access public
     * @param  string  $id カタログID
     * @return array カタログ情報
     */
    public function get($id)
    {
        $sql = 'SELECT c.* FROM catalogs c WHERE c.id = ? AND c.deleted_at IS NULL;';
        $result = $this->_db->fetchRow($sql, $id);
        return $result;
    }

    /**
     * カタログ情報をUIDから1件取得
     *
     * @access public
     * @param  string  $uid UID
     * @return array カタログ情報
     */
    public function getByUid($uid)
    {
        $sql = 'SELECT * FROM catalogs WHERE uid = ? AND deleted_at IS NULL ORDER BY id;';
        $result = $this->_db->fetchRow($sql, $uid);
        return $result;
    }

    /**
     * カタログのメーカー一覧を取得
     *
     * @access public
     * @param  array $q 検索クエリ
     * @return array メーカー一覧
     */
    public function getMakerList($q = NULL)
    {
        //// WHERE句 ////
        $where = '';
        if (!empty($q)) {
            $where = ' AND ' . $this->_makeWhere($q);
        }

        //// 検索クエリを作成・実行 ////
        $sql = "SELECT
          c.maker,
          c.maker_kana,
          count(*) AS count
        FROM
          catalogs c
        WHERE
          c.deleted_at IS NULL
          {$where}
        GROUP BY
          c.maker,
          c.maker_kana
        ORDER BY
          c.maker_kana COLLATE \"ja_JP.utf8\" asc,
          c.maker;";
        $result = $this->_db->fetchAll($sql);
        return $result;
    }

    /**
     * カタログのメーカー件数を取得
     *
     * @access public
     * @param  array $q 検索クエリ
     * @return array メーカー件数
     */
    public function getMakerCount($q = NULL)
    {
        //// WHERE句 ////
        $where = '';
        if (!empty($q)) {
            $where = ' AND ' . $this->_makeWhere($q);
        }

        //// 検索クエリを作成・実行 ////
        $sql = "SELECT
          count(DISTINCT c.maker)
        FROM
          catalogs c
        WHERE
          c.deleted_at IS NULL
          {$where};";
        $result = $this->_db->fetchOne($sql);
        return $result;
    }

    /**
     * カタログのメーカー一覧(該当ジャンル情報込)を取得
     *
     * @access public
     * @param  array $q 検索クエリ
     * @return array メーカー一覧(件数順)
     */
    public function getMakerGenreList($q = NULL)
    {
        //// WHERE句 ////
        $where = '';
        if (!empty($q)) {
            $where = ' AND ' . $this->_makeWhere($q);
        }

        //// 検索クエリを作成・実行 ////
        $sql = "SELECT
          a.maker,
          a.maker_kana,
          count(*) AS count,
          string_agg(CAST (a.id AS text), '|') AS genre_ids
        FROM
          (
            SELECT DISTINCT
              c.maker,
              c.maker_kana,
              g.id
            FROM
              catalogs c
              LEFT JOIN catalog_genre cg
                ON cg.catalog_id = c.id
              LEFT JOIN genres g
                ON cg.genre_id = g.id
            WHERE
              g.id IS NOT NULL AND
              c.deleted_at IS NULL
              {$where}
          ) a
        GROUP BY
          a.maker,
          a.maker_kana
        ORDER BY
          count DESC,
          a.maker_kana COLLATE \"ja_JP.utf8\" asc;";
        $result = $this->_db->fetchAll($sql);
        return $result;
    }

    /**
     * カタログのジャンル一覧を取得
     *
     * @access public
     * @param  array $q 検索クエリ
     * @return array ジャンル一覧
     */
    public function getGenreList($q = NULL)
    {
        //// WHERE句 ////
        $where = '';
        if (!empty($q)) {
            $where = ' AND ' . $this->_makeWhere($q);
        }

        //// 検索クエリを作成・実行 ////
        $sql = "SELECT
          g.*,
          count(c.*) AS count
        FROM
          catalogs c
          LEFT JOIN catalog_genre cg
            ON cg.catalog_id = c.id
          LEFT JOIN genres g
            ON g.id = cg.genre_id
        WHERE
          c.deleted_at IS NULL
          {$where}
        GROUP BY
          g.id
        HAVING
          g.id IS NOT NULL
        ORDER BY
          g.order_no,
          g.id;";
        $result = $this->_db->fetchAll($sql);
        return $result;
    }

    /**
     * テンプレート一覧格納・取得
     *
     * @access public
     * @param  array $p 格納するテンプレート
     * @param  array $ignore 格納・取得を拒否するテンプレート
     * @return string 格納したテンプレート
     */
    public function template($p = NULL, $ignore = NULL)
    {
        // 初期化
        if (empty($_SESSION['catalog']['listTemplate'])) {
            $_SESSION['catalog']['listTemplate'] = $this->_templates[0];
        }

        // テンプレート候補一覧にあれば格納
        if (
            !empty($p) &&
            in_array($p, $this->_templates)
        ) {
            $_SESSION['catalog']['listTemplate'] = $p;
        }

        // テンプレート拒否の処理
        if (!empty($ignore) && in_array($p, (array)$ignore)) {
            $_SESSION['catalog']['listTemplate'] = $this->_templates[0];
        }

        // テンプレートの取得
        return $_SESSION['catalog']['listTemplate'];
    }

    /**
     * 検索クエリからWHERE句の生成
     *
     * @access private
     * @param  array $q 検索クエリ
     * @return string where句
     */
    private function _makeWhere($q)
    {
        $arr = array();

        // カタログID（複数選択可）
        if (isset($q['id'])) {
            $arr[] = $this->_db->quoteInto(' c.id IN (?) ', $q['id']);
        }

        // ジャンルID（複数選択可）
        if (isset($q['genre_id'])) {
            $sql = ' c.id IN (SELECT catalog_id FROM catalog_genre WHERE genre_id IN (?)) ';
            $arr[] = $this->_db->quoteInto($sql, $q['genre_id']);
        }

        // メーカー
        if (isset($q['maker'])) {
            $arr[] = $this->_db->quoteInto(' c.maker IN (?) ', $q['maker']);
        }

        // 型式
        if (!empty($q['model'])) {
            // 部分一致
            $sql = ' c.keywords LIKE ? ';
            $mo = '%' . $this->modelFilter($q['model']) . '%';
            $arr[] = $this->_db->quoteInto($sql, $mo);
        }

        // UID
        if (!empty($q['uid'])) {
            // 部分一致
            $uid = str_replace(array('?', '*'), array('_', '%'), $q['uid']);
            $arr[] = $this->_db->quoteInto(' c.uid LIKE ? ', $uid);
        }

        // マイリスト
        if (isset($q['mylist'])) {
            $sql = ' CAST ( c.id AS text)  IN (
                SELECT query
                FROM mylists
                WHERE deleted_at IS NULL AND user_id IN (?)) ';
            $arr[] = $this->_db->quoteInto($sql, $q['mylist']);
        }

        return implode(' AND ', $arr);
    }

    /**
     * 型式特別取得
     *
     * @access public
     * @param  array $q 検索クエリ
     * @return array カタログ検索結果一覧
     */
    function _modelEx($q)
    {
        // 型式が入力されていない場合は、そのまま返す
        if (empty($q['model'])) {
            return $q;
        }

        // 型式を整形して、アルファベットと整数に分ける
        $mArray = array();
        $model = strtoupper(B::filter($q['model']));
        preg_match_all('/([A-Z]+|[0-9]+)/', $model, $tempArray);
        $mArray = $tempArray[0];

        // チェック
        while (count($mArray) > 0) {
            $moTemp = implode('', $mArray);

            // メーカー + ジャンル + 型式
            if (!empty($q['maker']) && !empty($q['genre_id'])) {
                $testQuery = array(
                    'maker'    => $q['maker'],
                    'genre_id' => $q['genre_id'],
                    'model'    => $moTemp,
                ) + $q;
                if ($this->getListCount($testQuery) > 0) {
                    return $testQuery;
                }
            }

            // メーカー + 型式のみ
            if (!empty($q['maker'])) {
                $testQuery = array(
                    'maker'    => $q['maker'],
                    'genre_id' => NULL,
                    'model'    => $moTemp,
                ) + $q;
                if ($this->getListCount($testQuery) > 0) {
                    return $testQuery;
                }
            }

            // ジャンル + 型式のみ
            if (!empty($q['genre_id'])) {
                $testQuery = array(
                    'maker'    => NULL,
                    'genre_id' => $q['genre_id'],
                    'model'    => $moTemp,
                ) + $q;
                if ($this->getListCount($testQuery) > 0) {
                    return $testQuery;
                }
            }

            // 型式のみ
            $testQuery = array(
                'maker'    => NULL,
                'genre_id' => NULL,
                'model'    => $moTemp,
            ) + $q;
            if ($this->getListCount($testQuery) > 0) {
                return $testQuery;
            }

            // 配列から後ろの要素を削除
            array_pop($mArray);
        }

        // 該当なしならそのまま出力(結果は0になる)
        return $q;
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

        // メーカー名
        if (isset($q['uid'])) {
            $detail[] = array(
                'key'   => 'mo',
                'data'  => 'uid' . $q['uid'],
                'label' => 'UID ' . $q['uid'],
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

    /**
     * カタログ情報をセット
     *
     * @access public
     * @param array $data 入力データ
     * @param  array $id カタログID
     * @return $this
     */
    public function set($data, $genres, $id)
    {
        // フィルタリング・バリデーション
        $data = MyFilter::filter($data, $this->_filter);

        if (empty($id)) {
            // 新規処理
            // $res = $this->insert($data);
            $res = $this->_db->insert('catalogs', $data);

            $temp = $this->getByUid($data['uid']);
            $id = $temp['id'];
        } else {
            // 更新処理
            $data['changed_at'] = new Zend_Db_Expr('current_timestamp');
            $res = $this->update($data, $this->_db->quoteInto('id = ?', $id));
        }

        // ジャンルの設定
        $sql = 'SELECT genre_id FROM catalog_genre WHERE catalog_id = ?;';
        $result = $this->_db->fetchCol($sql, $id);
        $deleteGenres = array_diff($result, $genres);
        $insertGenres = array_diff($genres, $result);

        // ジャンル登録
        foreach ($insertGenres as $g) {
            // $this->_db->insert('catalog_genre', array('catalog_id' => $id, 'genre_id' => $g));
            $res = $this->_db->insert("catalog_genre", array('catalog_id' => $id, 'genre_id' => $g));
        }

        // ジャンル削除
        foreach ($deleteGenres as $g) {
            $this->_db->delete('catalog_genre', array(
                $this->_db->quoteInto('catalog_id = ?', $id),
                $this->_db->quoteInto('genre_id = ?', $g),
            ));
        }

        if (empty($res)) {
            throw new Exception("在庫機械情報が保存できませんでした id:{$id}, uid:{$data['uid']}");
        }

        return $this;
    }

    public function modelFilter($model)
    {
        return preg_replace('/[^A-Z0-9]/', '', strtoupper(B::filter($model)));
    }
}

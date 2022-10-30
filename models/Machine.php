<?php
/**
 * 機械情報モデルクラス
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2012/04/13
 */
class Machine extends Zend_Db_Table_Abstract
{
    protected $_name = 'machines';

    // 内容がJSONのカラム
    private $_jsonColumn = array('others', 'imgs', 'pdfs');

    // 旋盤の能力変換表
    private $_latherCap = array(
        9 => 1500,
        8 => 1200,
        7 => 1000,
        6 => 800,
        5 => 600,
        4 => 360,
        3 => 240,
    );

    // フィルタ条件
    protected $_filter = array('rules' => array(
        '*'          => array(),
        '機械名'     => array('fields' => 'name',       'NotEmpty'),
        'ジャンルID' => array('fields' => 'genre_id',   'NotEmpty', 'Digits'),
        'カタログ'   => array('fields' => 'catalog_id', 'Digits'),
        '年式'       => array('fields' => 'year',       'Digits'),
        '能力'       => array('fields' => 'capacity',   'Float'),

        '緯度'       => array('fields' => 'lat',        'Float'),
        '経度'       => array('fields' => 'lng',        'Float'),
    ));

    // ORDER BY句用定数
    const ORDER_BY_COMPANY_ASC = ' m.member_id, ';
    //const ORDER_BY_CAPACITY    = " large_order_no, genre_order_no, coalesce(m.capacity, 99999999), m.maker_master, m.model2, m.model ";
    const ORDER_BY_CREATED_AT  = ' m.created_at DESC, ';
    // const ORDER_DEFAULT = " large_order_no, genre_order_no, m.capacity, m.maker_master, m.model2, m.model ";
    const ORDER_BY_RANDOM      = ' RANDOM(), ';

    const ORDER_BY_IMG_RANDOM  = " CASE WHEN m.top_img = '' OR m.top_img IS NULL THEN 9 ELSE 1 END, RANDOM(), ";

    const ORDER_DEFAULT        = " large_order_no, genre_order_no,
     CASE WHEN m.capacity = 0 OR m.capacity IS NULL THEN 9 ELSE 1 END, m.capacity,
     CASE WHEN m.maker_master_kana = '' OR m.maker_master_kana IS NULL THEN 9 ELSE 1 END, m.maker_master_kana, m.maker_master,
     CASE WHEN m.model2 = '' OR m.model2 IS NULL THEN 9 ELSE 1 END, m.model2, m.year DESC, m.model ";

    // テンプレート候補一覧
    private $_templates   = array('list', 'image', 'map', 'company');

    // 表示オプション候補
    private $_viewOptions = array('表示', '非表示', '商談中');

    // 年式用元号一覧
    private $_gengoList   = array('令和' => 2018, '平成' => 1988, '昭和' => 1925, '大正' => '1911', '明治' => 1867);

    // その他能力
    private $_otherSpecs = array(
        'x2'     => array(array(0,1),              '✕'),
        'x3'     => array(array(0,1,2),            '✕'),
        'c3'     => array(array(0,1,2),            ' : '),
        't2'     => array(array(0,1),              '～'),
        'nc'     => array(array('maker', 'model'), ' '),
    );

    public function getOtherSpecs()
    {
        return $this->_otherSpecs;
    }

    /**
     * 機械総数を取得
     *
     * @access public
     * @return integer 機械総数
     */
    public function getCountAll()
    {
        $sql = 'SELECT count(m.id) FROM view_machines m WHERE m.deleted_at IS NULL AND (m.view_option IS NULL OR m.view_option <> 1);';
        $result = $this->_db->fetchOne($sql);
        return $result;
    }


    /**
     * 登録会社数を取得
     *
     * @access public
     * @return integer 登録会社数を取得
     */
    public function getCountCompany()
    {
        $sql = 'SELECT count(DISTINCT m.company_id) FROM view_machines m WHERE m.deleted_at IS NULL;';
        $result = $this->_db->fetchOne($sql);
        return $result;
    }

    /**
     * 機械検索結果取得
     *
     * @access public
     * @param  array $q 検索クエリ
     * @return array 機械検索結果一覧
     */
    public function search($q)
    {
        $fq = $this->queryFilter($q);

        // 一覧のみ取得する
        if (!empty($q['onlyList'])) {
            return array(
                'machineList' => $this->getList($fq),
            );
        }

        // フィルタ条件一覧を同時取得
        return array(
            'machineList'  => $this->getList($fq),
            'makerList'    => $this->getMakerList($fq),
            'genreList'    => $this->getGenreList($fq),
            'companyList'  => $this->getCompanyList($fq),
            'addr1List'    => $this->getAddr1List($fq),
            'capacityList' => $this->getCapacityList($fq),
            'queryDetail'  => $this->queryDetail($q),
            'count'        => $this->getCount($q),
        );
    }

    /**
     * 条件から在庫機械一覧を取得
     *
     * @access public
     * @param  array  $q 検索クエリ
     * @return array 機械検索結果一覧
     */
    public function getList($q) {
        //// WHERE句 ////
        $where = $this->_makeWhere($q, true);
        if (!$where) { throw new Exception('検索条件が設定されていません'); };

        ///// ORDER BY句 ////
        $orderBy = 'ORDER BY ';
        if (!empty($q['sort'])) {
            if ($q['sort'] == 'company') {
                $orderBy.= self::ORDER_BY_COMPANY_ASC;
            } else if ($q['sort'] == 'created_at') {
                $orderBy.= self::ORDER_BY_CREATED_AT;
            } else if ($q['sort'] == 'random') {
                $orderBy.= self::ORDER_BY_RANDOM;
            } else if ($q['sort'] == 'img_random') {
                $orderBy.= self::ORDER_BY_IMG_RANDOM;

            } else if ($q['sort'] == 'no') {
                $orderBy.= ' m.no, ';
            } else if ($q['sort'] == 'no_int') {
                $orderBy.= " CAST(REGEXP_REPLACE(m.no, '[^0-9]', '') as INTEGER), ";
            } else if ($q['sort'] == 'name') {
                $orderBy.= ' m.name COLLATE "ja_JP.utf8" , ';
            } else if ($q['sort'] == 'maker') {
                $orderBy.= ' m.maker COLLATE "ja_JP.utf8" , ';
            } else if ($q['sort'] == 'model') {
                $orderBy.= ' m.model, ';
            } else if ($q['sort'] == 'year') {
                $orderBy.= ' m.year, ';
            }
        }
        $orderBy.= self::ORDER_DEFAULT;

        //// LIMIT句、OFFSET句 ////
        if (!empty($q['limit'])) {
            $orderBy.= $this->_db->quoteInto(' LIMIT ? ', $q['limit']);
            if (!empty($q['page'])) {
                $orderBy.= $this->_db->quoteInto(' OFFSET ? ', $q['limit'] * ($q['page'] - 1));
            }
        }

        //// SQLクエリを作成・一覧を取得 ////
        $sql = "SELECT m.* FROM view_machines m WHERE {$where} {$orderBy};";
        $result = $this->_db->fetchAll($sql);

        // JSON展開
        // $result = B::decodeTableJson($result, array_merge($this->_jsonColumn, array('spec_labels')));
        $result = B::decodeTableJson($result, array_merge(array('pdfs')));

        // // その他能力を仕様と結合する
        // if (!empty($q['is_ospec'])) {
        //     foreach($result as $key => $m) {
        //         $oSpec = $this->makerOthers($m['spec_labels'], $m['others']);
        //         if (!empty($oSpec)) {
        //             $result[$key]['spec'] = $oSpec . ' | ' . $m['spec'];
        //         }
        //     }
        // }

        return $result;
    }

    /**
     * 条件から新着在庫機械一覧を取得
     *
     * @access public
     * @param  array  $q 検索クエリ
     * @return array 機械検索結果一覧
     */
    public function getNewsList($q) {
        //// WHERE句 ////
        $where = $this->_makeWhere($q, true);
        if (!$where) { throw new Exception('検索条件が設定されていません'); };

        ///// ORDER BY句 ////
        $orderBy = 'ORDER BY created_at DESC ';
        if (!empty($q['sort'])) {
            if ($q['sort'] == 'company') {
                $orderBy = 'ORDER BY ' . self::ORDER_BY_COMPANY_ASC;
            } else if ($q['sort'] == 'created_at') {
                $orderBy = 'ORDER BY ' . self::ORDER_BY_CREATED_AT;
            }
        }

        //// LIMIT句、OFFSET句 ////
        if (!empty($q['limit'])) {
            $orderBy.= $this->_db->quoteInto(' LIMIT ? ', $q['limit']);
            if (!empty($q['page'])) {
                $orderBy.= $this->_db->quoteInto(' OFFSET ? ', $q['limit'] * ($q['page'] - 1));
            }
        }

        //// SQLクエリを作成・一覧を取得 ////
        $sql = "SELECT
          *
        FROM
          (
            SELECT DISTINCT
                ON (m.company_id) m.*
            FROM
              view_machines m
            WHERE
              {$where}
            ORDER BY
              m.company_id,
              m.created_at DESC
          ) p2 {$orderBy};";
        $result = $this->_db->fetchAll($sql);

        // JSON展開
        $result = B::decodeTableJson($result, array_merge($this->_jsonColumn, array('spec_labels')));

        return $result;
    }

    /**
     * 機械件数を取得
     *
     * @access public
     * @param  array $q 検索クエリ
     * @return integer 機械総数
     */
    public function getCount($q)
    {
        //// WHERE句 ////
        $where = $this->_makeWhere($q);

        //// SQLクエリを作成・一覧を取得 ////
        $sql = "SELECT count(m.*) AS count FROM view_machines m WHERE {$where};";
        $result = $this->_db->fetchOne($sql);
        return $result;
    }

    /**
     * 検索条件内のメーカー一覧取得
     *
     * @access public
     * @param  array $q 検索クエリ
     * @return array メーカー一覧
     */
    public function getMakerList($q)
    {
        //// WHERE句 ////
        $where = $this->_makeWhere($q);

        ///// ORDER BY句 ////
        $orderBy = 'ORDER BY count DESC, maker_kana collate "ja_JP.utf8" ASC ';
        if (!empty($q['sort'])) {
            if ($q['sort'] == 'maker') {
                $orderBy = 'ORDER BY maker_kana collate "ja_JP.utf8" ASC, maker, count DESC ';
            }
        }

        //// SQLクエリを作成・一覧を取得 ////
        /*
        $sql = "SELECT
            mc.maker_master AS maker,
            coalesce(ma.maker_kana, mc.maker_master) AS maker_kana,
            coalesce(ma.makers, mc.maker_master) AS makers,
            mc.count
          FROM
            (SELECT m.maker_master, count(maker) AS count  FROM view_machines m WHERE m.maker <> '' AND {$where} GROUP BY m.maker_master) mc
            LEFT JOIN view_makers ma
              ON mc.maker_master = ma.maker_master
          {$orderBy};";
        */

        $sql = "SELECT
            mc.maker_master AS maker,
            mc.maker_master_kana As maker_kana,
            ma.makers,
            mc.count
          FROM
            (SELECT m.maker_master, m.maker_master_kana, count(maker) AS count
               FROM view_machines m WHERE m.maker_master <> '' AND m.maker_master <> '(不明)' AND m.maker_master NOT LIKE ' %' AND {$where}
               GROUP BY m.maker_master, m.maker_master_kana) mc
            LEFT JOIN view_makers ma
              ON mc.maker_master = ma.maker_master
          {$orderBy};";

        $result = $this->_db->fetchAll($sql);
        return $result;
    }

    /**
     * 検索条件内のジャンル一覧取得
     *
     * @access public
     * @param  array $q 検索クエリ
     * @return array ジャンル一覧
     */
    public function getGenreList($q)
    {
        //// WHERE句 ////
        $where = $this->_makeWhere($q);

        //// SQLクエリを作成・一覧を取得 ////
        $sql = "SELECT
          g.*,
          mc.count
        FROM
            (SELECT m.genre_id, count(genre_id) AS count FROM  view_machines m WHERE {$where} GROUP BY m.genre_id) mc
          LEFT JOIN genres g
            ON mc.genre_id = g.id
        ORDER BY
          g.order_no,
          g.id;";
        $result = $this->_db->fetchAll($sql);
        return $result;
    }

    /**
     * 検索条件内のジャンル一覧取得
     *
     * @access public
     * @param  array $q 検索クエリ
     * @return array ジャンル一覧
     */
    public function getLargeGenreList($q)
    {
        //// WHERE句 ////
        $where = $this->_makeWhere($q);

        //// SQLクエリを作成・一覧を取得 ////
        $sql = "SELECT
          l.*,
          mc.count
        FROM
            (SELECT m.large_genre_id, count(large_genre_id) AS count FROM  view_machines m WHERE {$where} GROUP BY m.large_genre_id) mc
          LEFT JOIN large_genres l
            ON mc.large_genre_id = l.id
        ORDER BY
          l.order_no,
          l.id;";
        $result = $this->_db->fetchAll($sql);
        return $result;
    }

    /**
     * 検索条件内の都道府県一覧取得
     *
     * @access public
     * @param  string  $q   検索クエリ
     * @return array 都道府県一覧
     */
    public function getAddr1List($q)
    {
        //// WHERE句 ////
        $where = $this->_makeWhere($q);

        //// SQLクエリを作成・一覧を取得 ////
        $sql = "SELECT
          s.STATE as addr1,
          s.order_no AS sorder,
          r.order_no AS rorder,
          count(m.*) AS count
        FROM
          view_machines m
          LEFT JOIN states s
            ON s.STATE = m.addr1
          LEFT JOIN regions r
            ON r.id = s.region_id
        WHERE
          s.STATE IS NOT NULL AND
          {$where}
        GROUP BY
          s.STATE,
          rorder,
          sorder
        UNION
        SELECT
          r.region as addr1,
          0 AS sorder,
          r.order_no AS rorder,
          count(m.*) AS count
        FROM
          view_machines m
          LEFT JOIN states s
            ON s.STATE = m.addr1
          LEFT JOIN regions r
            ON r.id = s.region_id
        WHERE
          r.region IS NOT NULL AND
          {$where}
        GROUP BY
          r.region,
          rorder,
          sorder
        ORDER BY
          rorder,
          sorder; ";
        $result = $this->_db->fetchAll($sql);
        return $result;
    }

    /**
     * 検索条件内の能力一覧取得
     *
     * @access public
     * @param  string  $q   検索クエリ
     * @return array 都道府県一覧
     */
    public function getCapacityList($q)
    {
        //// WHERE句 ////
        $where = $this->_makeWhere($q);

        //// SQLクエリを作成・一覧を取得 ////
        $sql = "SELECT
          m.capacity_label,
          m.capacity_unit,
          m.capacity,
          count(m.capacity) as count
        FROM
          view_machines m
        WHERE
          m.capacity IS NOT NULL AND
          m.capacity_label IS NOT NULL AND
          m.capacity_label <> '' AND
          {$where}
        GROUP BY
          m.capacity_label,
          m.capacity_unit,
          m.capacity
        ORDER BY
          m.capacity_label,
          m.capacity_unit,
          m.capacity;";

        $res = $this->_db->fetchAll($sql);

        $result  = array();
        foreach($res as $key => $r) {
            $capTmp = intval($r['capacity']);
            if ($capTmp < 10) {
                // 10以下は、0～にまとめる
                $log = 1;
                $cap = 0;
            } else {
                $log = intval(log10($capTmp));
                $cap = intval($capTmp / pow(10, $log)) * pow(10, $log);
            }

            if ($key == 0 ||
              $temp['capacity_label'] != $r ['capacity_label'] ||
              $temp['capacity_unit'] != $r ['capacity_unit'] ||
              $temp['capacity'] != $cap) {
                if (!empty($temp)) { $result[] = $temp; }
                $temp = array(
                    'capacity_label' => $r['capacity_label'],
                    'capacity_unit'  => $r['capacity_unit'],
                    'capacity'       => $cap,
                    'capacity_max'   => $cap + pow(10, $log),
                    'count'          => $r['count'],
                );

            } else {
                $temp['count'] += $r['count'];
            }
        }
        if (!empty($temp)) { $result[] = $temp; }

        return $result;
    }

    /**
     * 検索条件内の会社一覧取得
     *
     * @access public
     * @param  array $q 検索クエリ
     * @return array 会社一覧
     */
    public function getCompanyList($q)
    {
        //// WHERE句 ////
        $where = $this->_makeWhere($q);

        //// SQLクエリを作成・一覧を取得 ////
        $sql = "SELECT
          c.*,
          mc.count AS count
        FROM
          (SELECT m.company_id, count(company_id) AS count FROM view_machines m WHERE {$where} GROUP BY m.company_id) mc
          LEFT JOIN view_companies c
            ON mc.company_id = c.id
        ORDER BY
          c.company_kana collate \"ja_JP.utf8\" asc, c.company, c.id;";
        $result = $this->_db->fetchAll($sql);

        // JSON展開
        $result = B::decodeTableJson($result, array('infos', 'imgs'));
        return $result;
    }

    /**
     * 機械情報を取得
     *
     * @access public
     * @param  integer $id        機械ID
     * @param  integer $companyId 会社ID
     * @return array   機械情報を取得
     */
    public function get($id, $companyId=NULL) {
        if (empty($id)) { throw new Exception('機械IDが設定されていません'); }

        $where = '';
        if (!empty($companyId)) {
            $where = $this->_db->quoteInto(' AND company_id = ? ', $companyId);
        }

        // SQLクエリを作成
        $sql = "SELECT m.* FROM view_machines m WHERE m.id = ? AND m.deleted_at IS NULL {$where} LIMIT 1;";
        $result = $this->_db->fetchRow($sql, $id);

        // JSON展開
        $result = B::decodeRowJson($result, array_merge($this->_jsonColumn, array('spec_labels')));

        return $result;
    }

    /**
     * 同じ機械情報を取得
     *
     * @access public
     * @param  integer $id 機械ID
     * @return array   機械情報一覧を取得
     */
    public function getSameList($id) {
        if (empty($id)) { throw new Exception('機械IDが設定されていません'); }

        // SQLクエリを作成
        $sql = "SELECT
          m.*
        FROM
          view_machines m
        WHERE
          (maker_master, model2) = (SELECT maker_master, model2 FROM view_machines WHERE id = ?) AND
          model2 <> '' AND
          m.deleted_at IS NULL AND
          m.id <> ?
        ORDER BY
          m.id DESC;";
        $result = $this->_db->fetchAll($sql, array($id, $id));

        // JSON展開
        $result = B::decodeTableJson($result, array_merge($this->_jsonColumn, array('spec_labels')));

        return $result;
    }

    /**
     * ログより機械情報を取得
     *
     * @access public
     * @param  integer $id 機械ID
     * @return array   機械情報一覧を取得
     */
    public function getLogList($id) {
        if (empty($id)) { throw new Exception('機械IDが設定されていません'); }

        // SQLクエリを作成
        $sql = "SELECT
          m.*
        FROM
          machines m
          RIGHT JOIN (
            SELECT
              a2.action_id,
              count(a2.action_id) as count
            FROM
              actionlogs a2
            WHERE
              a2.target = 'machine' AND
              a2.ACTION = 'machine_detail' AND
              a2.created_at > CURRENT_TIMESTAMP + '-1week' AND
              a2.action_id <> ?
              AND
              ip IN (
                SELECT DISTINCT
                  a.ip
                FROM
                  actionlogs a
                WHERE
                  a.action_id = ? AND
                  a.target = 'machine' AND
                  a.ACTION = 'machine_detail' AND
                  a.created_at > CURRENT_TIMESTAMP + '-1week' AND
                  a.ip <> ?
              )
              GROUP BY
                action_id
          ) ac ON m.id = ac.action_id
        WHERE
          deleted_at IS NULL
        ORDER BY
          ac.count DESC,
          m.created_at DESC
        LIMIT
          18;";
        $result = $this->_db->fetchAll($sql, array($id, $id, $_SERVER['REMOTE_ADDR']));

        // JSON展開
        // $result = B::decodeTableJson($result, array_merge($this->_jsonColumn, array('spec_labels')));
        $result = B::decodeTableJson($result, $this->_jsonColumn);

        return $result;
    }

    /**
     * よく見られている機械を取得する
     *
     * @access public
     * @param  array $q 検索クエリ
     * @return array 機械検索結果一覧
     */
    public function getFaviList($q)
    {
        //// WHERE句 ////
        $where = $this->_makeWhere($q, true);
        if (!$where) { throw new Exception('検索条件が設定されていません'); };

        ///// ORDER BY句 ////
        $orderBy = 'ORDER BY ac.count DESC ';
        if (!empty($q['sort'])) {
            if ($q['sort'] == 'company') {
                $orderBy = 'ORDER BY ' . self::ORDER_BY_COMPANY_ASC;
            } else if ($q['sort'] == 'created_at') {
                $orderBy = 'ORDER BY ' . self::ORDER_BY_CREATED_AT;
            }
        }

        //// LIMIT句、OFFSET句 ////
        if (!empty($q['limit'])) {
            $orderBy.= $this->_db->quoteInto(' LIMIT ? ', $q['limit']);
            if (!empty($q['page'])) {
                $orderBy.= $this->_db->quoteInto(' OFFSET ? ', $q['limit'] * ($q['page'] - 1));
            }
        }

        //// 検索クエリを作成・実行 ////
        $sql = "SELECT
          m.*
        FROM
          view_machines m
          INNER JOIN (
            SELECT
              action_id,
              count(*) AS count
            FROM
              view_machine_logs a
            WHERE
              a.log_created_at > CURRENT_TIMESTAMP + '-1month'
            GROUP BY
              a.action_id
          ) ac
            ON m.id = ac.action_id
        WHERE {$where} {$orderBy};";
        $result = $this->_db->fetchAll($sql);

        // JSON展開
        $result = B::decodeTableJson($result, array_merge($this->_jsonColumn, array('spec_labels')));

        return $result;
    }

    /**
     * 最近見た機械情報を取得
     *
     * @access public
     * @param  string $limit 表示件数
     * @return array 機械情報一覧を取得
     */
    public function getIPLogList($limit=18) {
        // SQLクエリを作成
        $sql = "SELECT
          m.*
        FROM
          view_machines m
          RIGHT JOIN (
            SELECT
              a.action_id,
              max(a.log_created_at) AS created_at
            FROM
              view_machine_logs a
            WHERE
              a.log_created_at > CURRENT_TIMESTAMP + '-1month' AND
              a.ip = ?
            GROUP BY
              a.action_id
          ) ac
            ON m.id = ac.action_id
        WHERE
          m.deleted_at IS NULL
        ORDER BY
          ac.created_at DESC
        LIMIT
          ?;";
        $result = $this->_db->fetchAll($sql, array($_SERVER['REMOTE_ADDR'], $limit));

        // JSON展開
        $result = B::decodeTableJson($result, array_merge($this->_jsonColumn, array('spec_labels')));

        return $result;
    }

    /**
     * 機械情報を論理削除
     *
     * @access public
     * @param  array $id 機械ID配列
     * @return $this
     */
    public function deleteById($id, $companyId) {
        if (empty($id)) {
            throw new Exception('削除する機械IDが設定されていません');
        }

        $this->update(
            array('deleted_at' => new Zend_Db_Expr('current_timestamp'), 'used_change' => null),
            array(
                $this->_db->quoteInto(' id IN(?) ', $id),
                $this->_db->quoteInto(' company_id = ? ', $companyId),
            )
        );

        return $this;
    }

    /**
     * 機械情報を論理削除(used_id以外、クロール一括登録用)
     *
     * @access public
     * @param  array $rex ユニークID配列(入力されたもの以外を削除)
     * @return $this
     */
    public function deleteByNotUsedId($usedId, $companyId) {
        if (empty($usedId)) {
            return "No delete. / ";
        }

        $res = $this->update(
            array('deleted_at' => new Zend_Db_Expr('current_timestamp')),
            array(
                $this->_db->quoteInto(' used_id IS NOT NULL AND deleted_at IS NULL AND used_id NOT IN(?) ', $usedId),
                $this->_db->quoteInto(' company_id = ? ', $companyId),
            )
        );

        return "{$res} machines delete. / ";
    }

    /**
     * クロールで取得した機械情報の保存(クロール一括登録用)
     *
     * @access public
     * @param  string $companyId クロールした会社ID
     * @param  string $dataJson  クロールで取得した機械情報(JSON)
     * @return string INSERT数、UPDATE数の表示
     */
    public function setCrawledData($companyId, $dataJson) {
        $context = stream_context_create(
            [
            'ssl' => [
                'verify_peer'      => false,
                'verify_peer_name' => false
            ]
        ]);

        //// データをJSONからデコード ////
        if (empty($dataJson))       { throw new Exception('データJSONがありません'); }
        $data = json_decode($dataJson, true);
        if (empty($data[0]['uid'])) { return 'No update and insert.'; }

        //// ジャンル情報(機械名マッチングテーブルの生成) ////
        // CSVを取得
        if (($ugf = B::file2utf(dirname(__FILE__) . '/../machine/public/system/csv/crawl_genres.csv')) === FALSE) {
            throw new Exception('ジャンル変換表CSVファイルが開けませんでした');
        }

        $uGList = array();
        while (($ug = fgetcsv($ugf, 10000, ',')) !== FALSE) {
            $uGList[strtoupper(B::f($ug[0]))] = B::f($ug[1]);
        }

        // DBのジャンル一覧を事前に取得する
        $sql = 'SELECT id, genre FROM genres WHERE large_genre_id <> 33;';
        $res = $this->_db->fetchAll($sql);
        foreach ($res as $g) {
            $uGList[strtoupper($g['genre'])] = $g['id'];
        }

        //// 会社情報を取得 ////
        $cModel  = new Company();
        $company = $cModel->get($companyId);
        if (empty($company)) { throw new Exception('会社情報がありません'); }

        //// 会社ごとに特別に処理するフラグ ////
        // メカニー : 画像のhttpヘッダを取得して更新確認
        $headFlag  = in_array($companyId, array(232));
        // 三善機械 : ファイル命名規則を変更
        $namedFlag = in_array($companyId, array(23));

        // 立川商店 : ファイル命AWS
        $awsFlag = in_array($companyId, array(13));

        //// 登録件数・変更件数の初期化 ////
        $insertNum = 0;
        $updateNum = 0;

        //// 登録・変更用DB処理の共通部分 ////
        // WHERE句、会社ID
        $baseWhere = $this->_db->quoteInto(' company_id = ?', $companyId);

        // 更新用・登録用情報(changed_atのみ変更)
        $updateM = array(
            'changed_at' => date('Y-m-d H:i:s'), // 現在のタイムスタンプ
            'deleted_at' => NULL
        );
        $insertM = array('company_id' => $companyId);

        //// ファイル処理クラスの初期化 ////
        $fModel = new File();
        $_conf = Zend_Registry::get('_conf');

        foreach ($data as $m) {
            $usedName = B::f($m['name']);
            $hint     = preg_replace('/\s/', '', strtoupper($m['hint']));

            // ジャンルマッチ : 機械名(ヒント)テーブルから取得
            if (empty($m['genre_id'])) {
                if (!empty($uGList[$hint])) { $m['genre_id'] = $uGList[$hint]; }
            }

            // どのジャンルにも当てはまらない場合は、「その他機械」
            if (empty($m['genre_id'])) { $m['genre_id'] = 390; }

            //// 機械名 ////
            $capacity  = !empty($m['capacity']) ? B::f($m['capacity']) : null;
            // $m['name'] = $this->makeName($usedName, $m['genre_id'], $capacity);
            $m['name'] = $usedName;
            $m['hint'] = $hint;

            //// 画像・PDFファイルの取得 ////
            $m['top_img'] = '';
            $m['imgs']    = array();
            $m['pdfs']    = array();

            //// 画像ファイルの取得・保存処理 ////
            if (!empty($m['used_imgs'])) {
                foreach($m['used_imgs'] as $i) {
                    // ファイル名の生成
                    if ($namedFlag) {
                        // 三善機械 : 命名規則が特殊
                        $img = 'c_' . $companyId . '_' . preg_replace('/[^0-9a-zA-Z_]/', '', $m['uid']) . '__' . preg_replace('/[^0-9a-zA-Z_]/', '', preg_replace('/^(.*(\/|\?))/', '', $i));
                    } else if ($awsFlag) {
                        // 立川商店 : AWSなのでファイル名が長い
                        $ftemp = preg_replace('/(\?.*)$/', '', $i);
                        $img = 'c_' . $companyId . '_' . preg_replace('/[^0-9a-zA-Z]/', '', $m['uid']) . '_' . preg_replace('/^(.*(\/|\?))/', '', $ftemp);

                    } else {
                        $img = 'c_' . $companyId . '_' . preg_replace('/[^0-9a-zA-Z]/', '', $m['uid']) . '_' . preg_replace('/^(.*(\/|\?))/', '', $i);
                    }

                    if (!preg_match('/\./', $img)) { $img.= '.jpeg'; } // 拡張子のない場合は付加

                    if ($m['top_img'] != $img && !in_array($img, $m['imgs'])) {
                        // ファイルの格納パス
                        $realPath = dirname(__FILE__) . '/../machine/public/media/machine';
                        $tempPath = dirname(__FILE__) . '/../machine/public/media/tmp';
                        $filePath = $realPath . '/' . $img;

                        // @ba-ta 20181129 ファイル格納パス確認
                        if (!@file_exists($tempPath)) { mkdir($tempPath, '0777'); }

                        // メカニー : httpヘッダからファイルサイズを取得
                        // if ($headFlag) { $headers = @get_headers($i, true); }

                        // ファイル未取得の場合は、同期元からファイルをダウンロード
                        // if (!file_exists($filePath) ||
                        //     ($headFlag && filesize($filePath) != $headers["Content-Length"])) {
                        // if (!file_exists($filePath)) {
                        //     if ($fileData = @file_get_contents($i)) {
                        //         file_put_contents($filePath, $fileData);
                        //
                        //         // サムネイル生成
                        //         $fModel->makeThumbnail($realPath, $img);
                        //     } else { continue; }
                        // }

                        // @ba-ta 20181110 存在確認
                        // $response = @file_get_contents($_conf->media_dir . "machine/" . $img, NULL, NULL, 0, 1);
                        $headers = @get_headers($_conf->media_dir . "machine/" . $img);

                        // if ($response === false) {
                        // if (empty($response)) {
                        if (strpos($headers[0], 'OK') == false) {
                            if ($fileData = @file_get_contents($i, false, $context)) {
                                file_put_contents(($tempPath . '/' . $img), $fileData);

                                // サムネイル生成
                                $fModel->makeThumbnail($tempPath, $realPath, $img);

                                rename($tempPath . '/' . $img, $realPath . '/'. $img);
                            } else { continue; }
                        }

                        // 画像ファイル名データの格納
                        if (empty($m['top_img']))       { $m['top_img'] = $img; }
                        else if ($m['top_img'] != $img) { $m['imgs'][]  = $img; }
                    }
                }
            }

            //// PDFファイルの取得・保存処理 ////
            if (!empty($m['used_pdfs'])) {
                foreach($m['used_pdfs'] as $key => $i) {
                    // ファイル名の生成
                    $pdf = 'c_' . $companyId . '_' . $m['uid'] . '_' . preg_replace('/^(.*\/)/', '', $i);
                    if (!preg_match('/\./', $pdf)) { $pdf.= '.pdf'; } // 拡張子のない場合は付加

                    if ((empty($m['pdfs']) || !in_array($pdf, $m['pdfs']))) {
                        // ファイルの格納パス
                        $filePath = dirname(__FILE__) . '/../machine/public/media/machine/' . $pdf;

                        // ファイル未取得の場合は、同期元からファイルをダウンロード
                        // $response = @file_get_contents($_conf->media_dir . "machine/" . $pdf, NULL, NULL, 0, 1);
                        $headers = @get_headers($_conf->media_dir . "machine/" . $pdf);

                        // if (empty($response)) {
                        if (strpos($headers[0], 'OK') == false) {

                            if ($fileData = @file_get_contents($i, false, $context)) {
                                file_put_contents($filePath, $fileData);
                            } else { continue; }
                        }

                        // PDFファイル名データの格納
                        $m['pdfs'][$key] = $pdf;
                    }
                }
            }

            //// 在庫場所 ////
            $location = B::f($m['location']);
            if ($location == '本社') {
                // 本社の場合は、会社情報の住所情報を格納
                $m += array(
                    'addr1' => $company['addr1'],
                    'addr2' => $company['addr2'],
                    'addr3' => $company['addr3'],
                    'lat'   => $company['lat'],
                    'lng'   => $company['lng'],
                );
            } else {
                //
                foreach($company['offices'] as $o) {
                    if ($location == $o['name']) {
                        $m += array(
                            'addr1' => $o['addr1'],
                            'addr2' => $o['addr2'],
                            'addr3' => $o['addr3'],
                            'lat'   => $o['lat'],
                            'lng'   => $o['lng'],
                        );
                        break;
                    }
                }
            }
            // 在庫場所がない場合は、空白
            $m += array('addr1' => null, 'addr2' => null, 'addr3' => null, 'lat' => null, 'lng' => null,);

            //// その他能力(空白) ////
            $m['others'] = array();

            //// UPDATEのWHERE句の作成 ////
            $where = $baseWhere . $this->_db->quoteInto(' AND used_id = ?', (string)$m['uid']);

            //// 不要な配列要素を削除 ////
            $usedId = $m['uid'];
            unset($m['used_imgs'], $m['used_pdfs'], $m['uid']);

            // JSONデータ保管
            foreach ($this->_jsonColumn as $val) {
                $m[$val] = json_encode($m[$val], JSON_UNESCAPED_UNICODE);
            }

            //// 更新・登録処理 ////
            $res = $this->update($updateM + $m, $where);
            if (!$res) {
                // 該当するユニークIDがなく更新できない時は、新規登録処理を行う
                $this->insert($insertM + $m + array('used_id' => $usedId));
                $insertNum++;
            } else { $updateNum++; }
        }

        return "{$updateNum} machines update / {$insertNum} machines insert success.";
    }

    //// 名前・主能力 ////
    public function makeName($usedName, $genreId, $capacity=null)
    {
        // ジャンル情報を取得
        $sql = 'SELECT * FROM genres WHERE id = ? LIMIT 1;';
        $g   = $this->_db->fetchRow($sql, $genreId);

        if (empty($g)) { return $usedName; }

        //// 命名規則を取得 ////
        $name = $g['naming'];

        if (!empty($capacity)) {
            // 尺のもの(旋盤専用)
            if (preg_match('/(%lather%)/', $name)) {
                if ($capacity >= 2000) {
                    $name = preg_replace('/(%lather%)/', ($capacity / 1000) . 'm', $name);
                } else {
                    foreach ($this->_latherCap as $key => $val) {
                        if ($capacity >= $val) {
                            $name = preg_replace('/(%lather%)/', $key . '尺', $name);
                            break;
                        }
                    }
                }
            }

            // 能力を名前に結合
            $name = preg_replace('/(%capacity%)/', $capacity,           $name);
            $name = preg_replace('/(%unit%)/',     $g['capacity_unit'], $name);
        }

        // 選択・自由記入(入力されたものそのまま)
        $name = preg_replace('/(%free%|%select.*%)/', $usedName, $name);
        return preg_replace('/(%.*%)/', '', $name);
    }

    /**
     * テンプレート一覧格納・取得
     *
     * @access public
     * @param  array  $p 格納するテンプレート
     * @param  array  $ignore 格納・取得を拒否するテンプレート
     * @return string 格納したテンプレート
     */
    public function template($p=NULL, $ignore=NULL)
    {
        // 初期化
        if (empty($_SESSION['machine']['listTemplate'])) {
            $_SESSION['machine']['listTemplate'] = $this->_templates[0];
        }

        // テンプレート候補一覧にあれば格納
        if (!empty($p) &&
            in_array($p, $this->_templates)) {
            $_SESSION['machine']['listTemplate'] = $p;
        }

        // テンプレート拒否の処理
        if (!empty($ignore) && in_array($p, (array)$ignore)) {
            $_SESSION['machine']['listTemplate'] = $this->_templates[0];
        }

        // テンプレートの取得
        return $_SESSION['machine']['listTemplate'];
    }

    /**
     * 検索クエリからWHERE句の生成
     *
     * @access private
     * @param  array   $q     検索クエリ
     * @param  boolean $check 検索条件チェック
     * @return string  where句
     */
    private function _makeWhere($q, $check=false) {
        $arr = array();

        // 特大ジャンルID（複数選択可）
        if (!empty($q['xl_genre_id'])) {
            $arr[] = $this->_db->quoteInto(' m.xl_genre_id IN(?) ', $q['xl_genre_id']);
        }

        // 大ジャンルID（複数選択可）
        if (!empty($q['large_genre_id'])) {
            /*
            $arr[] = $this->_db->quoteInto(' m.genre_id IN
                ( SELECT id FROM genres WHERE large_genre_id IN
                ( SELECT id FROM large_genres WHERE id IN(?))) ',
                $q['large_genre_id']);
            */
            $arr[] = $this->_db->quoteInto(' m.large_genre_id IN(?) ', $q['large_genre_id']);
        }

        // @ba-ta 20140917 特大、大ジャンルが検索条件にある場合、その他のジャンルは非表示
        if ((!empty($q['large_genre_id']) || !empty($q['xl_genre_id'])) && empty($q['keyword'])) {
            // $arr[] = $this->_db->quoteInto(' m.genre NOT LIKE ? ', 'その他%');
        }

        // ジャンルID（複数選択可）
        if (!empty($q['genre_id'])) {
            $arr[] = $this->_db->quoteInto(' m.genre_id IN(?) ', $q['genre_id']);
        }

        // 掲載会社ID
        if (!empty($q['company_id'])) {
            $arr[] = $this->_db->quoteInto(' m.company_id IN(?) ', $q['company_id']);
        }

        /*
        // 新着情報
        if (isset($q['news']) && $q['news'] > 0) {
            $arr[] = $this->_db->quoteInto(' m.created_at > current_date - ? ', intval($q['news']));
        }
        */
        if (!empty($q['period']) && $q['period'] > 0) {
            $arr[] = $this->_db->quoteInto(' m.created_at > current_date - ? ', intval($q['period']));
        }

        if (!empty($q['start_date'])) {
            $arr[] = $this->_db->quoteInto(' CAST(m.created_at as DATE) >= ? ', $q['start_date']);
        }

        if (!empty($q['end_date'])) {
            $arr[] = $this->_db->quoteInto(' CAST(m.created_at as DATE) <= ? ', $q['end_date']);
        }

        // 日付のピンポイント指定
        if (!empty($q['date'])) {
            $arr[] = $this->_db->quoteInto(' CAST(m.created_at as DATE) = ? ', $q['date']);
        }

        // 機械ID（複数選択可）
        if (isset($q['id']) && count($q['id'])) {
            $arr[] = $this->_db->quoteInto(' m.id IN(?) ', $q['id']);
        }

        // メーカー
        if (!empty($q['maker'])) {
            $arr[] = $this->_db->quoteInto(' m.maker_master IN (?) ', $q['maker']);
        }

        // TOP画像があるかどうか
        if (!empty($q['is_img'])) {
            $arr[] = " m.top_img IS NOT NULL AND m.top_img <> '' ";
        }

        // youtube動画があるかどうか
        if (!empty($q['is_youtube'])) {
            $arr[] = " m.youtube IS NOT NULL AND m.youtube <> 'http://youtu.be/' ";
        }

        // ウォッチリストがあるかどうか
        if (!empty($q['is_watch'])) {
            $wModel = new Watchlist();
            $watchlist = $wModel->getList();
            if (!empty($watchlist)) { $arr[] = $this->_db->quoteInto(' m.id IN (?) ', $watchlist); }
            else { $arr[] = ' 1 = 2 '; }
        }

        // キーワード検索
        if (!empty($q['keyword'])) {
            $temp = " m.name || ' ' || coalesce(m.maker, '') || ' ' || coalesce(m.model, '') || ' ' || coalesce(m.model2, '') || ' ' || " .
                " coalesce(m.no, '') || ' ' || coalesce(m.hint, '') || ' ' || " .
                " coalesce(m.addr1, '') || ' ' || coalesce(m.addr2, '') || ' ' || " .
                " coalesce(m.location, '')  || ' ' || " .
                // " g.genre || ' ' || coalesce(c.company, '') ILIKE ? ";
                " m.genre || ' ' || coalesce(m.company, '') ILIKE ? ";
            $k= preg_replace("/(\s|　)+/", ' ', $q['keyword']);
            foreach(explode(" ", $k) as $key => $val) {
                $arr[] = $this->_db->quoteInto($temp, '%'.$val.'%');
            }
        }

        // ORキーワード検索
        if (!empty($q['orkeyword'])) {
            $temp = " m.name || ' ' || coalesce(m.maker, '') || ' ' || coalesce(m.model, '') || ' ' || coalesce(m.model2, '') || ' ' || " .
                " coalesce(m.no, '') || ' ' || coalesce(m.hint, '') || ' ' || " .
                " coalesce(m.addr1, '') || ' ' || coalesce(m.addr2, '') || ' ' || " .
                " coalesce(m.location, '')  || ' ' || " .
                // " g.genre || ' ' || coalesce(c.company, '') ILIKE ? ";
                " m.genre || ' ' || coalesce(m.company, '') ~ ? ";
            $ork = trim(preg_replace("/(\s|　|\||｜)+/", '|', $q['orkeyword']));
            if (!empty($ork)) {
              $arr[] = $this->_db->quoteInto($temp, 'xxxxx|' . $ork . '|xxxxx');
            }
        }

        // 管理番号OR
        if (!empty($q['no'])) {
            $nos = preg_replace("/(\s|　)+/", ' ', $q['no']);
            $arr[] = $this->_db->quoteInto(' m.no IN (?) ', explode(' ', $nos));
        }

        //// ここまでで、検索条件チェック ////
        if ($check == true && count($arr) == 0) {
            return false;
        }

        // 削除フラグ
        if (isset($q['delete'])) {
            if ($q['delete'] == 'delete') {
                // 削除のみ取得
                $arr[] = ' m.deleted_at IS NOT NULL ';
            } else if ($q['delete'] == 'each') {
                // 削除・在庫両方取得(削除日時関係なし)
            } else {
                // 在庫のみ取得
                $arr[] = ' m.deleted_at IS NULL ';
            }
        } else {
            // デフォルト(在庫のみ取得)
            $arr[] = ' m.deleted_at IS NULL ';
        }

        // 表示オプション(NULL:表示、1:非表示、2:商談中)
        if (isset($q['view_option'])) {
            if ($q['view_option'] == 'full') {
                // 全て取得(無条件)
            } else {
                // 「非表示」以外取得
                $arr[] = ' (m.view_option IS NULL OR m.view_option <> 1) ';
            }
        } else {
            // デフォルト(「非表示」以外取得)
            $arr[] = ' (m.view_option IS NULL OR m.view_option <> 1) ';
        }

        return implode(' AND ', $arr);
    }

    /**
     * 検索クエリをフィルタリング
     *
     * @access public
     * @param  array  $q   検索クエリ
     * @return array フィルタリング後の検索クエリ
     */
    public function queryFilter($q)
    {
        $res = array();

        // 特大ジャンルID（複数選択可）
        if (!empty($q['xl_genre_id'])) {
            $res['xl_genre_id'] = B::arrayIntFilter($q['xl_genre_id']);
        }

        // 大ジャンルID（複数選択可）
        if (!empty($q['large_genre_id'])) {
            $res['large_genre_id'] = B::arrayIntFilter($q['large_genre_id']);
        }

        // ジャンルID（複数選択可）
        if (!empty($q['genre_id'])) {
            $res['genre_id'] = B::arrayIntFilter($q['genre_id']);
        }

        // 掲載会社ID
        if (!empty($q['company_id'])) {
            $res['company_id'] = B::arrayIntFilter($q['company_id']);
        }

        // 新着情報(改め、表示期間)
        if (!empty($q['period']) && intval($q['period']) > 0) {
            $res['period'] = intval($q['period']);
        }

        if (!empty($q['start_date'])) {
            $res['start_date'] = B::f($q['start_date']);
        }

        if (!empty($q['end_date'])) {
            $res['end_date'] = B::f($q['end_date']);
        }

        if (!empty($q['date'])) {
            $res['date'] = B::f($q['date']);
        }

        // メーカー名
        if (!empty($q['maker'])) {
            $res['maker'] = B::f($q['maker']);
        }

        // TOP画像があるかどうか
        if (!empty($q['is_img'])) {
            $res['is_img'] = 1;
        }

        // youtube動画があるかどうか
        if (!empty($q['is_youtube'])) {
            $res['is_youtube'] = 1;
        }

        // ウォッチリストがあるかどうか
        if (!empty($q['is_watch'])) {
            $res['is_watch'] = 1;
        }

        // 機械ID（複数選択可）
        if (isset($q['id']) && count($q['id'])) {
            $res['id'] = B::arrayIntFilter($q['id']);
        }

        // 削除フラグ
        if (isset($q['delete'])) {
            $res['delete'] = B::f($q['delete']);
        }

        // 表示オプション
        if (isset($q['view_option'])) {
            $res['view_option'] = B::f($q['view_option']);
        }

        // 検索キーワード
        if (isset($q['keyword'])) {
            $res['keyword'] = B::f($q['keyword']);
        }

        // ORキーワード
        if (isset($q['orkeyword'])) {
            $res['orkeyword'] = B::f($q['orkeyword']);
        }

        // 管理番号
        if (isset($q['no'])) {
            $res['no'] = B::f($q['no']);
        }

        // その他能力を仕様と結合する
        if (isset($q['is_ospec'])) {
            $res['is_ospec'] = B::f($q['is_ospec']);
        }

        // ソート
        if (isset($q['sort'])) {
            $res['sort'] = B::f($q['sort']);
        }

        // LIMIT OFFSET(ページ)
        if (isset($q['limit'])) {
            $res['limit'] = B::f($q['limit']);
            if (isset($q['page'])) {
                $res['page'] = B::f($q['page']);
            }
        }

        return $res;
    }

    /**
     * 検索クエリの詳細を取得
     *
     * @access public
     * @param  array  $q 検索クエリ
     * @return array フィルタリング後の検索クエリ
     */
    public function queryDetail($q)
    {
        $temp = array();
        $res  = array();

        // 特大ジャンルID（複数選択可）
        if (!empty($q['xl_genre_id'])) {
            $temp[] = $this->_db->quoteInto("
                SELECT 'x' as key, x.id as id, x.xl_genre as label
                FROM xl_genres x
                WHERE x.id IN(?) ",
                $q['xl_genre_id']
            );
        }

        // 大ジャンルID（複数選択可）
        if (!empty($q['large_genre_id'])) {
            $temp[] = $this->_db->quoteInto("
                SELECT 'l' as key, l.id as id, l.large_genre as label
                FROM large_genres l
                WHERE l.id IN(?) ",
                $q['large_genre_id']
            );
        }

        // ジャンルID（複数選択可）
        if (!empty($q['genre_id'])) {
            $temp[] = $this->_db->quoteInto("
                SELECT 'g' as key, g.id as id, g.genre as label
                FROM genres g
                WHERE g.id IN(?) ",
                $q['genre_id']
            );
        }

        // 掲載会社ID
        if (!empty($q['company_id'])) {
            $temp[] = $this->_db->quoteInto("
                SELECT 'c' as key, c.id as id, c.company as label
                FROM companies c
                WHERE c.id IN(?) ",
                $q['company_id']
            );
        }

        // メーカー
        if (!empty($q['maker'])) {
            foreach((array)$q['maker'] as $m) {
                $temp[] = $this->_db->quoteInto("
                    SELECT 'm' as key, 1 as id, ? as label ",
                    $m
                );
            }
        }

        // UNION句
        $sql = implode(' UNION', $temp);

        if ($sql != '') {
            $res = $this->_db->fetchAll($sql);
        }

        return $res;
    }

    /**
     * 選択用年号一覧の生成
     *
     * @access public
     * @return array 選択用年号一覧
     */
    public function makeYearList()
    {
        $yearList = array('' => '-');
        for ($i = date('Y'); $i >= 1900; $i--) {
            foreach ($this->_gengoList as $gengo => $firstYear) {
                if ($i > $firstYear) {
                    $y = $i - $firstYear;
                    $yearList[$i] = $i . ' (' . $gengo . ($y == 1 ? '元' : $y) . '年)';
                    break;
                }
            }
        }

        return $yearList;
    }

    /**
     * 機械所有会社のチェック
     *
     * @access public
     * @param  array  $id チェックする在庫機械ID
     * @param integer $companyId 会社ID
     * @return boolean 在庫が貴社のものならtrue
     */
    function checkUser($id, $companyId)
    {
        // $machine = $this->get($id);
        $m = $this->_db->fetchRow('SELECT * FROM machines WHERE id = ? LIMIT 1;', $id);
        return $m['company_id'] == $companyId ? true : false;
    }

    /**
     * 在庫機械情報をセット
     *
     * @access public
     * @param  array   $data      入力データ
     * @param  integer $id        機械ID
     * @param  integer $companyId 会社ID
     * @return $this
     */
    public function set($data, $id, $companyId)
    {
        // 会社情報のチェック
        if (empty($companyId)) {
            throw new Exception("会社情報がありません");
        }

        // @ba-ta 20140114 入札会商品からの登録
        if (!empty($data['bid_machine_id'])) {
            $bidMachineId = $data['bid_machine_id'];
        }
        unset($data['bid_machine_id']);

        // フィルタリング・バリデーション
        $data = MyFilter::filter($data, $this->_filter);

        // JSONデータ保管
        foreach ($this->_jsonColumn as $val) {
            $data[$val] = json_encode($data[$val], JSON_UNESCAPED_UNICODE);
        }

        if (empty($id)) {
            // 新規処理
            $data['company_id'] = $companyId;
            $res = $this->insert($data);

            // @ba-ta 20140114 入札会商品からの登録
            if (!empty($bidMachineId)) {
                $id = $this->_db->lastInsertId('machines', 'id');

                // 入札会商品に機械IDを保存
                $bmModel = new BidMachine();
                $bmModel->update(array('machine_id' => $id), $this->_db->quoteInto('id = ?', $bidMachineId));
            }
        } else {
            // 更新処理
            if (!$this->checkUser($id, $companyId)) {
                throw new Exception("この在庫機械情報はあなたの在庫ではありません id:{$id} {$companyId}");
            }
            $data['changed_at'] = new Zend_Db_Expr('current_timestamp');
            $res = $this->update($data, array(
                $this->_db->quoteInto('id = ?', $id),
                $this->_db->quoteInto('company_id = ?', $companyId),
            ));
        }

        if (empty($res)) {
            throw new Exception("在庫機械情報が保存できませんでした id:{$id}");
        }

        return $this;
    }

    /**
     * 機械情報を一括変更
     *
     * @access public
     * @param  string  $column    変更するカラム
     * @param  string  $data      変更するデータ
     * @param  array   $id        変更する機械ID配列
     * @param  integer $companyId 会社ID
     * @return $this
     */
    public function setMultiple($column, $data, $id, $companyId) {
        if (empty($id)) {
            throw new Exception('変更する機械IDが設定されていません');
        }

        if (!in_array($column, array('view_option', 'commission'))) {
            throw new Exception('変更する項目が設定されていません');
        } else if (!is_int($data)) {
            throw new Exception('変更する内容が間違っています');
        }

        $this->update(
            array($column => $data),
            array(
                $this->_db->quoteInto(' id IN(?) ', $id),
                $this->_db->quoteInto(' company_id = ? ', $companyId),
            )
        );

        return $this;
    }

    /**
     * 在庫情報登録用メーカー一覧を取得
     *
     * @access public
     * @param  array $q 検索クエリ
     * @return array メーカー一覧(件数順)
     */
    public function getMakerGenreList($q=NULL)
    {
        //// WHERE句 ////
        $where = '';
        if (!empty($q)) {
            $where = ' AND ' . $this->_makeWhere($q);
        }

        //// 検索クエリを作成・実行 ////
        $sql = "SELECT
          m.maker,
          sum(m.c) AS count,
          string_agg(CAST (m.genre_id AS text), '|') AS genre_ids
        FROM
          (
            SELECT
                c.maker,
                c.genre_id,
                count(*) AS c
              FROM
                machines c
              WHERE
                c.deleted_at IS NULL AND
                (maker IS NOT NULL AND maker <> '')
                {$where}
              GROUP BY
                c.maker,
                c.genre_id
          ) m
        GROUP BY
          m.maker
        ORDER BY
          count DESC;";
        $result = $this->_db->fetchAll($sql);
        return $result;
    }

    // その他能力を文字列に結合する共通処理
    public function makerOthers($specLabels, $others)
    {
        if (empty($specLabels) || empty($others)) { return ''; }

        $temp = array();

        foreach($specLabels as $lKey => $l) {
            $v = '';
            if (!empty($others[$lKey])) {
                if (!empty($this->_otherSpecs[$l['type']])) {
                    // 複数値表示
                    foreach($this->_otherSpecs[$l['type']][0] as $j) {
                        if ($others[$lKey][$j]) {
                            if ($v != '') { $v.= $this->_otherSpecs[$l['type']][1]; }  // セパレータ表示
                            $v.= $others[$lKey][$j]; // 能力値表示
                        }
                    }
                } else { $v = $others[$lKey]; } // 単数値表示
            }

            if ($v == '') { continue; }

            if (!empty($l['label'])) { $v = $l['label'] . ':' . $v; }
            if (!empty($l['unit']))  { $v.= $l['unit']; }

            $temp[] = $v;
        }

        return implode(' | ', $temp);
    }


    /**
     * サイトマップ用の複合検索条件リスト作成
     *
     * @access public
     * @param  string  $select 検索条件(とりあえずハードコーディング)
     * @param  integer $num 取得件数条件
     * @return array   検索結果一覧
     */
    public function getDoubleSearchList($select, $num=10)
    {
        //// SELECT(GROUP BY)句 ////
        $select = ' m.large_genre_id, m.large_genre, m.maker_master ';
        $where  = " (m.maker_master <> '' AND m.maker_master <> '(不明)' AND m.maker_master IS NOT NULL) ";

        //// 検索クエリを作成・実行 ////
        $sql = "SELECT
          {$select}, count(*) as count
        FROM
          view_machines m
        WHERE
          m.deleted_at IS NULL AND (m.view_option IS NULL OR m.view_option <> 1) AND {$where}
        GROUP BY
          {$select}
        HAVING
          count(*) >= ?
        ORDER BY
          {$select}, count DESC;";

        $result = $this->_db->fetchAll($sql, $num);

        return $result;
    }
}

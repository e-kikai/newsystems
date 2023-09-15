<?php

/**
 * 機械情報モデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
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
        '機械名'     => array('fields' => 'name', 'NotEmpty'),
        'ジャンルID' => array('fields' => 'genre_id', 'NotEmpty', 'Digits'),
        'カタログ'   => array('fields' => 'catalog_id', 'Digits'),
        '年式'       => array('fields' => 'year', 'Digits'),
        '能力'       => array('fields' => 'capacity', 'Float'),

        '緯度'       => array('fields' => 'lat', 'Float'),
        '経度'       => array('fields' => 'lng', 'Float'),
    ));

    // ORDER BY句用定数
    const ORDER_BY_COMPANY_ASC = ' m.member_id, l.order_no, g.order_no, m.maker, m.model ';
    const ORDER_BY_CAPACITY    = ' l.order_no, g.order_no, m.capacity, m.name, m.maker, m.model ';
    const ORDER_BY_CREATED_AT  = ' m.created_at DESC ';

    // テンプレート候補一覧
    private $_templates = array('list', 'image', 'map', 'company');

    // 表示オプション候補
    private $_viewOptions = array('表示', '非表示', '商談中');

    // 年式用元号一覧
    private $_gengoList = array('平成' => 1988, '昭和' => 1925, '大正' => '1911', '明治' => 1867);

    // その他能力
    private $_otherSpecs = array(
        'x2' => array(array(0, 1), ' × '),
        'x3' => array(array(0, 1, 2), ' × '),
        'c3' => array(array(0, 1, 2), ' : '),
        't2' => array(array(0, 1), ' ～ '),
        'nc' => array(array('maker', 'model'), ' '),
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
        $sql = 'SELECT count(*) FROM machines WHERE deleted_at IS NULL AND (view_option IS NULL OR view_option <> 1);';
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
        $sql = 'SELECT count(DISTINCT company_id) FROM machines WHERE deleted_at IS NULL;';
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

        if (!empty($q['onlyList'])) {
            return array(
                'machineList' => $this->getList($fq),
            );
        }

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
     * @param  string  $q   検索クエリ
     * @return array 機械検索結果一覧
     */
    public function getList($q)
    {
        //// WHERE句 ////
        $where = $this->_makeWhere($q, true);
        if (!$where) {
            throw new Exception('検索条件が設定されていません');
        };

        ///// ORDER BY句 ////
        $orderBy = 'ORDER BY ' . self::ORDER_BY_CAPACITY;
        if (!empty($q['sort'])) {
            if ($q['sort'] == 'company') {
                $orderBy = 'ORDER BY ' . self::ORDER_BY_COMPANY_ASC;
            } else if ($q['sort'] == 'created_at') {
                $orderBy = 'ORDER BY ' . self::ORDER_BY_CREATED_AT;
            }
        }

        //// LIMIT句、OFFSET句 ////
        if (!empty($q['limit'])) {
            $orderBy .= $this->_db->quoteInto(' LIMIT ? ', $q['limit']);
            if (!empty($q['page'])) {
                $orderBy .= $this->_db->quoteInto(' OFFSET ? ', $q['limit'] * ($q['page'] - 1));
            }
        }

        //// SQLクエリを作成・一覧を取得 ////
        $sql = "SELECT
          m.*,
          c.company,
          c.contact_tel,
          c.contact_fax,
          c.contact_mail,
          g.genre,
          g.large_genre_id,
          g.capacity_label,
          g.capacity_unit,
          g.spec_labels,
          l.large_genre
        FROM
          machines m
          LEFT JOIN companies c
            ON m.company_id = c.id
          LEFT JOIN genres g
            ON (m.genre_id = g.id)
          LEFT JOIN large_genres l
            ON (g.large_genre_id = l.id)
        WHERE
          c.deleted_at IS NULL AND
          {$where}
        {$orderBy};";
        $result = $this->_db->fetchAll($sql);

        // JSON展開
        $result = B::decodeTableJson($result, array_merge($this->_jsonColumn, array('spec_labels')));

        return $result;
    }

    /**
     * 機械件数を取得
     *
     * @access public
     * @return integer 機械総数
     */
    public function getCount($q)
    {
        //// WHERE句 ////
        $where = $this->_makeWhere($q);

        //// SQLクエリを作成・一覧を取得 ////
        $sql = "SELECT
          count(m.*) AS count
        FROM
          machines m
          LEFT JOIN companies c
            ON m.company_id = c.id
          LEFT JOIN genres g
            ON (m.genre_id = g.id)
        WHERE
          m.company_id IN ( SELECT id FROM companies WHERE deleted_at IS NULL ) AND
          {$where};";
        $result = $this->_db->fetchOne($sql);
        return $result;
    }

    /**
     * 検索条件内のメーカー一覧取得
     *
     * @access public
     * @param  string  $q   検索クエリ
     * @return array メーカー一覧
     */
    public function getMakerList($q)
    {
        //// WHERE句 ////
        $where = $this->_makeWhere($q);

        //// SQLクエリを作成・一覧を取得 ////
        $sql = "SELECT
          m.maker,
          count(m.*) AS count
        FROM
          machines m
          LEFT JOIN companies c
            ON m.company_id = c.id
          LEFT JOIN genres g
            ON (m.genre_id = g.id)
        WHERE
          m.company_id IN ( SELECT id FROM companies WHERE deleted_at IS NULL ) AND
          {$where}
        GROUP BY
          m.maker
        ORDER BY
          m.maker;";

        $result = $this->_db->fetchAll($sql);
        return $result;
    }

    /**
     * 検索条件内のジャンル一覧取得
     *
     * @access public
     * @param  string  $q   検索クエリ
     * @return array ジャンル一覧
     */
    public function getGenreList($q)
    {
        //// WHERE句 ////
        $where = $this->_makeWhere($q);

        //// SQLクエリを作成・一覧を取得 ////
        $sql = "SELECT
          g.*,
          count(m.*) as count
        FROM
          machines m
          LEFT JOIN companies c
            ON m.company_id = c.id
          LEFT JOIN genres g
            ON (m.genre_id = g.id)
        WHERE
          m.company_id IN ( SELECT id FROM companies WHERE deleted_at IS NULL ) AND
          {$where}
        GROUP BY
          g.id
        ORDER BY
          g.order_no,
          g.id;";
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
          m.addr1,
          s.order_no,
          count(m.*) AS count
        FROM
          machines m
          LEFT JOIN companies c
            ON m.company_id = c.id
          LEFT JOIN genres g
            ON (m.genre_id = g.id)
          LEFT JOIN states s
            ON s.state = m.addr1
        WHERE
          m.company_id IN ( SELECT id FROM companies WHERE deleted_at IS NULL ) AND
          {$where}
        GROUP BY
          m.addr1,
          s.order_no
        ORDER BY
          s.order_no;";

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
          g.capacity_label,
          g.capacity_unit,
          m.capacity,
          count(m.capacity)
        FROM
          machines m
          LEFT JOIN companies c
            ON m.company_id = c.id
          LEFT JOIN genres g
            ON (m.genre_id = g.id)
          LEFT JOIN states s
            ON s.state = m.addr1
        WHERE
          m.company_id IN ( SELECT id FROM companies WHERE deleted_at IS NULL ) AND
          m.capacity IS NOT NULL AND
          g.capacity_label IS NOT NULL AND
          g.capacity_label <> '' AND
          {$where}
        GROUP BY
          g.capacity_label,
          g.capacity_unit,
          m.capacity
        ORDER BY
          g.capacity_label,
          g.capacity_unit,
          m.capacity;";

        $result = $this->_db->fetchAll($sql);
        return $result;
    }

    /**
     * 検索条件内の会社一覧取得
     *
     * @access public
     * @param  string  $q   検索クエリ
     * @return array 会社一覧
     */
    public function getCompanyList($q)
    {
        //// WHERE句 ////
        $where = $this->_makeWhere($q);

        //// SQLクエリを作成・一覧を取得 ////
        $sql = Group::WITH_RECURSIVE_SQL . " SELECT
          c.*,
          count(m.*) AS count,
          r.level,
          r.treenames,
          r.root_id,
          r.groupname,
          r.rootname
        FROM
          machines m
          LEFT JOIN companies c
            ON m.company_id = c.id
          LEFT JOIN r
            ON r.id = c.group_id
          LEFT JOIN genres g
            ON (m.genre_id = g.id)
        WHERE
          c.deleted_at IS NULL AND
          r.deleted_at IS NULL AND
          {$where}
        GROUP BY
          c.id,
          r.level,
          r.treenames,
          r.root_id,
          r.groupname,
          r.rootname
        ORDER BY
          c.company_kana,
          c.id;";
        $result = $this->_db->fetchAll($sql);

        // JSON展開
        $result = B::decodeTableJson($result, array('infos', 'imgs'));
        return $result;
    }

    /**
     * 機械情報を取得
     *
     * @access public
     * @param  string  $id   機械ID
     * @return array 機械情報を取得
     */
    public function get($id, $companyId = NULL)
    {
        if (empty($id)) {
            throw new Exception('機械IDが設定されていません');
        }

        $where = '';
        if (!empty($companyId)) {
            $where = $this->_db->quoteInto(' AND company_id = ? ', $companyId);
        }

        // SQLクエリを作成
        $sql = "SELECT
          m.*,
          c.company,
          c.tel,
          c.fax,
          c.contact_tel,
          c.contact_fax,
          c.contact_mail,
          g.genre,
          g.large_genre_id,
          g.capacity_label,
          g.capacity_unit,
          g.spec_labels,
          l.large_genre
        FROM
          machines m
          LEFT JOIN companies c
            ON (m.company_id = c.id)
          LEFT JOIN genres g
            ON (m.genre_id = g.id)
          LEFT JOIN large_genres l
            ON (g.large_genre_id = l.id)
        WHERE
          m.deleted_at IS NULL AND
          c.deleted_at IS NULL AND
          m.id = ?
          {$where}
        LIMIT
          1;";
        $result = $this->_db->fetchRow($sql, $id);

        // JSON展開
        $result = B::decodeRowJson($result, array_merge($this->_jsonColumn, array('spec_labels')));

        return $result;
    }

    /**
     * 機械情報を論理削除
     *
     * @access public
     * @param  array $id 機械ID配列
     * @return $this
     */
    public function deleteById($id, $companyId)
    {
        if (empty($id)) {
            throw new Exception('削除する機械IDが設定されていません');
        }

        $this->update(
            array('deleted_at' => new Zend_Db_Expr('current_timestamp')),
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
    public function deleteByNotUsedId($usedId, $companyId)
    {
        if (empty($usedId)) {
            return "no delete / ";
        }

        $res = $this->update(
            array('deleted_at' => new Zend_Db_Expr('current_timestamp')),
            array(
                $this->_db->quoteInto(' used_id IS NOT NULL AND deleted_at IS NULL AND used_id NOT IN(?) ', $usedId),
                $this->_db->quoteInto(' company_id = ? ', $companyId),
            )
        );

        return "{$res} machines delete / ";
    }

    /**
     * クロールで取得した機械情報の保存(クロール一括登録用)
     *
     * @access public
     * @param  string $companyId クロールした会社ID
     * @param  string $dataJson クロールで取得した機械情報(JSON)
     * @return string INSERT数、UPDATE数の表示
     */
    public function setCrawledData($companyId, $dataJson)
    {
        //// データをJSONからデコード ////
        if (empty($dataJson)) {
            throw new Exception('データJSONがありません');
        }

        $data = json_decode($dataJson, true);
        if (empty($data[0]['uid'])) {
            return 'no update / insert';
        }

        //// ジャンル情報(機械名マッチング) ////
        // CSVを取得
        if (($ugf = B::file2utf(dirname(__FILE__) . '/../machine/public/system/csv/crawl_genres.csv')) === FALSE) {
            throw new Exception('ジャンル変換表CSVファイルが開けませんでした');
        }

        $uGList = array();
        while (($ug = fgetcsv($ugf, 10000, ',')) !== FALSE) {
            $uGList[B::f($ug[0])] = B::f($ug[1]);
        }

        //// 会社情報を取得 ////
        $cModel = new Company();
        $company = $cModel->get($companyId);
        if (empty($company)) {
            throw new Exception('会社情報がありません');
        }

        // 変数初期化
        $insertNum = 0;
        $updateNum = 0;
        $baseWhere = $this->_db->quoteInto(' company_id = ?', $companyId);

        // 更新用・登録用情報(changed_atのみ変更)
        $updateM = array(
            'changed_at' => date('Y-m-d H:i:s'), // 現在のタイムスタンプ
            'deleted_at' => NULL
        );
        $insertM = array('company_id' => $companyId);

        foreach ($data as $m) {
            $usedName = B::f($m['name']);

            //// ジャンルのマッチング ////
            // ジャンルマッチ1: 機械名から検索
            if (empty($m['genre_id'])) {
                $sql = 'SELECT * FROM genres WHERE large_genre_id <> 33 AND genre = ? LIMIT 1;';
                $res = $this->_db->fetchRow($sql, $usedName);

                if (!empty($res)) {
                    $m['genre_id'] = $res['id'];
                }
            }

            // ジャンルマッチ2: 機械名(ヒント)テーブルから取得
            if (empty($m['genre_id'])) {
                if (!empty($uGList[$m['hint']])) {
                    $m['genre_id'] = $uGList[$m['hint']];
                }
            }

            // どのジャンルにも当てはまらない場合は、「その他機械」
            if (empty($m['genre_id'])) {
                $m['genre_id'] = 390;
            }

            //// 機械名 ////
            $capacity = !empty($m['capacity']) ? B::f($m['capacity']) : null;
            $m['name'] = $this->makeName($usedName, $m['genre_id'], $capacity);

            //// 画像・PDFファイルの取得 ////
            $m['top_img'] = '';
            $m['imgs'] = array();
            $m['pdfs'] = array();

            // 画像
            if (!empty($m['used_imgs'])) {
                foreach ($m['used_imgs'] as $i) {
                    // ファイル名の生成・格納
                    $img = 'c_' . $companyId . '_' . preg_replace('/[^0-9a-zA-Z]/', '', $m['uid']) . '_' . preg_replace('/^(.*\/)/', '', $i);
                    if (!preg_match('/\./', $img)) {
                        $img .= '.jpeg';
                    } // 拡張子のない場合

                    if ($m['top_img'] != $img && !in_array($img, $m['imgs'])) {
                        // ファイルのダウンロード
                        $filePath = dirname(__FILE__) . '/../machine/public/media/machine/' . $img;
                        if (!file_exists($filePath)) {
                            // ファイルがない場合は、ファイルをDL
                            if ($fileData = @file_get_contents($i)) {
                                file_put_contents($filePath, $fileData);
                            } else {
                                continue;
                            }
                        }

                        // データの格納
                        if (empty($m['top_img'])) {
                            $m['top_img'] = $img;
                        } else if ($m['top_img'] != $img) {
                            $m['imgs'][]  = $img;
                        }
                    }
                }
            }

            // PDF
            if (!empty($m['used_pdfs'])) {
                foreach ($m['used_pdfs'] as $key => $i) {
                    // ファイル名の生成・格納
                    $pdf = 'c_' . $companyId . '_' . $m['uid'] . '_' . preg_replace('/^(.*\/)/', '', $i);
                    if (!preg_match('/\./', $pdf)) {
                        $pdf .= '.pdf';
                    } // 拡張子のない場合

                    if ((empty($m['pdfs']) || !in_array($pdf, $m['pdfs']))) {
                        // ファイルのダウンロード
                        $filePath = dirname(__FILE__) . '/../machine/public/media/machine/' . $pdf;
                        if (!file_exists($filePath)) {
                            // ファイルがない場合は、ファイルをDL
                            if ($fileData = @file_get_contents($i)) {
                                file_put_contents($filePath, $fileData);
                            } else {
                                continue;
                            }
                        }

                        // データの格納
                        $m['pdfs'][$key] = $pdf;
                    }
                }
            }


            //// 在庫場所 ////
            $location = B::f($m['location']);
            if ($location == '本社') {
                $m += array(
                    'addr1' => $company['addr1'], 'addr2' => $company['addr2'], 'addr3' => $company['addr3'],
                    'lat' => $company['lat'], 'lng' => $company['lng'],
                );
            } else {
                foreach ($company['offices'] as $o) {
                    if ($location == $o['name']) {
                        $m += array(
                            'addr1' => $o['addr1'], 'addr2' => $o['addr2'], 'addr3' => $o['addr3'],
                            'lat' => $o['lat'], 'lng' => $o['lng'],
                        );
                        break;
                    }
                }
            }
            // 在庫場所がない場合は、空白
            $m += array('addr1' => null, 'addr2' => null, 'addr3' => null, 'lat' => null, 'lng' => null,);

            //// 能力(空白) ////
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

            //// 更新できないときは、新規登録 ////
            $res = $this->update($updateM + $m, $where);
            if (!$res) {
                $this->insert($insertM + $m + array('used_id' => $usedId));
                $insertNum++;
            } else {
                $updateNum++;
            }
        }

        return "{$updateNum} machines update / {$insertNum} machines insert success.";
    }

    //// 名前・主能力 ////
    public function makeName($usedName, $genreId, $capacity = null)
    {
        // ジャンル情報を取得
        $sql = 'SELECT * FROM genres WHERE id = ? LIMIT 1;';
        $g = $this->_db->fetchRow($sql, $genreId);

        if (empty($g)) {
            throw new Exception('ジャンルがありません');
        }

        // 命名規則
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
            $name = preg_replace('/(%capacity%)/', $capacity, $name);
            $name = preg_replace('/(%unit%)/', $g['capacity_unit'], $name);
        }

        // 選択・自由記入(入力されたものそのまま)
        $name = preg_replace('/(%free%|%select.*%)/', $usedName, $name);
        return preg_replace('/(%.*%)/', '', $name);
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
        if (empty($_SESSION['machine']['listTemplate'])) {
            $_SESSION['machine']['listTemplate'] = $this->_templates[0];
        }

        // テンプレート候補一覧にあれば格納
        if (
            !empty($p) &&
            in_array($p, $this->_templates)
        ) {
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
     * @param  array $q 検索クエリ
     * @param boolean $check 検索条件チェック
     * @return string where句
     */
    private function _makeWhere($q, $check = false)
    {
        $arr = array();

        // 大ジャンルID（複数選択可）
        if (!empty($q['large_genre_id'])) {
            $arr[] = $this->_db->quoteInto(
                ' m.genre_id IN
                ( SELECT id FROM genres WHERE large_genre_id IN
                ( SELECT id FROM large_genres WHERE id IN(?))) ',
                $q['large_genre_id']
            );
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
            $arr[] = $this->_db->quoteInto(' m.created_at >= ? ', $q['start_date']);
        }

        if (!empty($q['end_date'])) {
            $arr[] = $this->_db->quoteInto(' m.created_at <= ? ', $q['end_date']);
        }

        // 機械ID（複数選択可）
        if (isset($q['id']) && count($q['id'])) {
            $arr[] = $this->_db->quoteInto(' m.id IN(?) ', $q['id']);
        }

        // メーカー
        if (!empty($q['maker'])) {
            $arr[] = $this->_db->quoteInto(' m.maker IN (?) ', $q['maker']);
        }

        // キーワード検索
        if (!empty($q['keyword'])) {
            $temp = " m.name || ' ' || coalesce(m.maker, '') || ' ' || coalesce(m.model, '') || ' ' || " .
                " coalesce(m.no, '') || ' ' || coalesce(m.hint, '') || ' ' || " .
                " coalesce(m.addr1, '') || ' ' || coalesce(m.addr2, '') || ' ' || " .
                " coalesce(m.location, '')  || ' ' || " .
                " g.genre || ' ' || coalesce(c.company, '') LIKE ? ";
            $k = preg_replace("/(\s|　)+/", ' ', $q['keyword']);
            foreach (explode(" ", $k) as $key => $val) {
                $arr[] = $this->_db->quoteInto($temp, '%' . $val . '%');
            }
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
        /*
        if (isset($q['news']) && intval($q['news']) > 0) {
            $res['news'] = intval($q['news']);
        }
        */
        if (!empty($q['period']) && intval($q['period']) > 0) {
            $res['period'] = intval($q['period']);
        }

        if (!empty($q['start_date'])) {
            $res['start_date'] = B::f($q['start_date']);
        }

        if (!empty($q['end_date'])) {
            $res['end_date'] = B::f($q['end_date']);
        }

        // メーカー名
        if (!empty($q['maker'])) {
            $res['maker'] = B::f($q['maker']);
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
     * @param  array  $q   検索クエリ
     * @return array フィルタリング後の検索クエリ
     */
    public function queryDetail($q)
    {
        $temp = array();
        $res  = array();

        // 大ジャンルID（複数選択可）
        if (!empty($q['large_genre_id'])) {
            $temp[] = $this->_db->quoteInto(
                "
                SELECT 'l' as key, l.id as id, l.large_genre as label
                FROM large_genres l
                WHERE l.id IN(?) ",
                $q['large_genre_id']
            );
        }

        // ジャンルID（複数選択可）
        if (!empty($q['genre_id'])) {
            $temp[] = $this->_db->quoteInto(
                "
                SELECT 'g' as key, g.id as id, g.genre as label
                FROM genres g
                WHERE g.id IN(?) ",
                $q['genre_id']
            );
        }

        // 掲載会社ID
        if (!empty($q['company_id'])) {
            $temp[] = $this->_db->quoteInto(
                "
                SELECT 'c' as key, c.id as id, c.company as label
                FROM companies c
                WHERE c.id IN(?) ",
                $q['company_id']
            );
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
     * @param array $data 入力データ
     * @param  array $id 機械ID
     * @param int $companyId 会社ID
     * @return $this
     */
    public function set($data, $id, $companyId)
    {
        // 会社情報のチェック
        if (empty($companyId)) {
            throw new Exception("会社情報がありません");
        }

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
        } else {
            // 更新処理
            if (!$this->checkUser($id, $companyId)) {
                throw new Exception("この在庫機械はあなたの在庫ではありません id:{$id} {$companyId}");
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
     * @param string $column 変更するカラム
     * @param string $data 変更するデータ
     * @param array $id 機械ID配列
     * @param integer $companyId 会社ID
     * @return $this
     */
    public function setMultiple($column, $data, $id, $companyId)
    {
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
    public function getMakerGenreList($q = NULL)
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
}

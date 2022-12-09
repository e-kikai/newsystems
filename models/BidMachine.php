<?php

/**
 * 入札会商品モデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
class BidMachine extends Zend_Db_Table_Abstract
{
  protected $_name = 'bid_machines';

  // 内容がJSONのカラム
  private $_jsonColumn = array('others', 'imgs', 'pdfs');

  // フィルタ条件
  protected $_filter = array(
    'rules' => array(
      // '*'          => array(),
      '入札会ID'     => array('fields' => 'bid_open_id', 'NotEmpty', 'Digits'),
      '機械ID'       => array('fields' => 'machine_id', 'Digits'),
      '最低入札金額' => array('fields' => 'min_price', 'Digits'),

      '機械名'       => array('fields' => 'name', 'NotEmpty'),
      'メーカー'     => array('fields' => 'maker',),
      '型式'         => array('fields' => 'model',),
      '仕様'         => array('fields' => 'spec',),
      'その他仕様'   => array('fields' => 'others',),
      '附属品'       => array('fields' => 'accessory',),
      'コメント'     => array('fields' => 'comment',),
      '引取留意事項' => array('fields' => 'carryout_note',),
      '試運転'       => array('fields' => 'commission', 'Digits'),

      '送料負担'       => array('fields' => 'shipping', 'Digits'),
      '送料負担備考欄' => array('fields' => 'shipping_comment'),

      'ジャンルID'   => array('fields' => 'genre_id', 'NotEmpty', 'Digits'),
      '会社ID'       => array('fields' => 'company_id', 'NotEmpty', 'Digits'),
      '年式'         => array('fields' => 'year', 'Digits'),
      '能力'         => array('fields' => 'capacity', 'Float'),

      '在庫場所'     => array('fields' => 'location',),
      '都道府県'     => array('fields' => 'addr1',),
      '市区町村'     => array('fields' => 'addr2',),
      '番地その他'   => array('fields' => 'addr3',),

      // 'TOP画像'      => array('fields' => 'top_img', 'NotEmpty',),
      'TOP画像'      => array('fields' => 'top_img',),

      '画像'         => array('fields' => 'imgs',),
      'PDF'          => array('fields' => 'pdfs',),
      'YoutubeID'    => array('fields' => 'youtube',),

      '緯度'         => array('fields' => 'lat', 'Float'),
      '経度'         => array('fields' => 'lng', 'Float'),

      'セリ分かれ価格' => array('fields' => 'seri_price', 'Digits'),
      '即決'           => array('fields' => 'prompt',     'Digits'),
    ),
    'options' => array(
      'presence'     => 'optional',
    )
  );

  // 手数料テーブル
  protected $_feeTable = array(
    '100000'  => array(5, 10),
    '1000000' => array(4, 10),
    '2000000' => array(3, 8),
    '3000000' => array(3, 7),
    'else'    => array(3, 5),
  );

  // 送料負担enum
  public static function shipping_enum()
  {
    return [
      0   => "落札者負担",
      100 => "出品会社負担",
      200 => "店頭引取り",
    ];
  }

  public static  function shipping($shipping)
  {
    $shipping_enum = BidMachine::shipping_enum();

    if (!empty($shipping_enum[$shipping])) {
      return $shipping_enum[$shipping];
    } else {
      return $shipping_enum[0];
    }
  }

  public function getFeeTable()
  {
    return $this->_feeTable;
  }

  /**
   * 最低入札金額から手数料を計算
   *
   * @access public
   * @param  int $minPrice 最低入札金額
   * @return array 手数料と手数料%の連想配列
   */
  public function makeFee($minPrice)
  {
    $temp = array();
    foreach ($this->_feeTable as $tkey => $t) {
      if ($tkey == 'else' || $tkey >= $minPrice) {
        $temp['jPer'] = $t[0];
        $temp['jFee'] = $minPrice * $t[0] / 100;
        $temp['rPer'] = $t[1];
        $temp['rFee'] = $minPrice * $t[1] / 100;
        break;
      }
    }

    return $temp;
  }

  /**
   * 入札会商品一覧を取得
   *
   * @access public
   * @param  int $bidOpenId 入札会開催ID
   * @return array 機械検索結果一覧
   */
  public function getList($q = null)
  {
    if (empty($q['bid_open_id'])) {
      throw new Exception('入札会開催IDが設定されていません');
    }

    /// WHERE句 ///
    $where = $this->_makeWhere($q);
    if (!empty($where)) {
      $where = ' AND ' . $where;
    }

    /// ORDER BY 句 ///
    if (!empty($q['order'])) {
      if ($q['order'] == 'name') {
        $orderBy = " ORDER BY xl_order_no, large_order_no, genre_order_no, bm.name, coalesce(bm.capacity, '999999'), bm.maker, bm.model, bm.id ASC ";
      } else if ($q['order'] == 'maker') {
        $orderBy = ' ORDER BY bm.maker, bm.model, bm.id ASC ';
      } else if ($q['order'] == 'model') {
        $orderBy = ' ORDER BY bm.model, bm.maker, bm.id ASC ';
      } else if ($q['order'] == 'year') {
        $orderBy = " ORDER BY coalesce(bm.year, '9999') ASC, large_order_no, genre_order_no, bm.maker, bm.model, bm.id ASC ";
      } else if ($q['order'] == 'year_desc') {
        $orderBy = " ORDER BY coalesce(bm.year, '0') DESC, large_order_no, genre_order_no, bm.maker, bm.model, bm.id ASC ";
      } else if ($q['order'] == 'company') {
        $orderBy = ' ORDER BY bm.company_kana, bm.id ASC ';
      } else if ($q['order'] == 'min_price') {
        $orderBy = ' ORDER BY bm.min_price, bm.id ASC ';
      } else if ($q['order'] == 'min_price_desc') {
        $orderBy = ' ORDER BY bm.min_price DESC, bm.id ASC ';
      } else if ($q['order'] == 'location') {
        $orderBy = ' ORDER BY region_order_no, state_order_no, bm.id ASC ';
      } else if ($q['order'] == 'id') {
        $orderBy = ' ORDER BY bm.id ASC ';
      } else if ($q['order'] == 'list_no') {
        $orderBy = " ORDER BY coalesce(list_no, '999999'), xl_order_no, large_order_no, genre_order_no, coalesce(capacity, '999999'), bm.maker, bm.model, bm.id ASC";
      } else if ($q['order'] == 'random') {
        $orderBy = ' ORDER BY random() ';
        // } else if ($q['order'] == 'reccomend') {
        //     // ML結果
        //     $trackingUserTable = new TrackingUser();
        //     $trackingUser = $trackingUserTable->checkTrackingTag();
        //     $caseWhere = "";

        //     if (!empty($trackingUser)) {
        //         $tbuTable = new TrackingBidResult();
        //         $recommendIds = $tbuTable->getBidMachineIds($q['bid_open_id'], 'user', $trackingUser['id']);

        //         if (!empty($recommendIds)) {
        //             $recommendIdsArray = implode(", ", $recommendIds);
        //             $caseWhere = " CASE WHEN bm.id IN ( " . $recommendIdsArray . " ) THEN 1 ELSE 2 END, ";
        //         }
        //     }

        //     $orderBy = " ORDER BY " . $caseWhere . " coalesce(list_no, '999999'),  bm.id, xl_order_no, large_order_no, genre_order_no, coalesce(capacity, '999999'), bm.maker, bm.model, bm.id ASC ";
      } else {
        // $orderBy = ' ORDER BY bm.id ASC ';
        $orderBy = " ORDER BY coalesce(list_no, '999999'),  bm.id, xl_order_no, large_order_no, genre_order_no, coalesce(capacity, '999999'), bm.maker, bm.model, bm.id ASC ";
      }
    } else {
      // $orderBy = ' ORDER BY bm.id ASC ';
      $orderBy = " ORDER BY  coalesce(list_no, '999999'), bm.id, xl_order_no, large_order_no, genre_order_no, coalesce(capacity, '999999'), bm.maker, bm.model, bm.id ASC ";
    }

    /// LIMIT句、OFFSET句 ///
    if (!empty($q['limit'])) {
      $orderBy .= $this->_db->quoteInto(' LIMIT ? ', $q['limit']);
      if (!empty($q['page'])) {
        $orderBy .= $this->_db->quoteInto(' OFFSET ? ', $q['limit'] * ($q['page'] - 1));
      }
    }

    /// 全取得できるようにID条件を手動追加 ///
    if ($q['bid_open_id'] == 'all') {
      $idWhere = ' bm.bid_open_id  IS NOT NULL ';
    } else {
      $idWhere = $this->_db->quoteInto(' bm.bid_open_id = ? ', $q['bid_open_id']);
    }

    /// SQLクエリを作成・一覧を取得 ///
    $sql = "SELECT bm.* FROM view_bid_machines bm WHERE {$idWhere} {$where} {$orderBy};";
    $result = $this->_db->fetchAll($sql);

    // JSON展開
    $result = B::decodeTableJson($result, array_merge($this->_jsonColumn, array('spec_labels')));

    return $result;
  }

  /**
   * 入札会商品件数をを取得
   *
   * @access public
   * @param  int $bidOpenId 入札会開催ID
   * @return array 商品件数
   */
  public function getCount($q = null)
  {
    if (empty($q['bid_open_id'])) {
      throw new Exception('入札会開催IDが設定されていません');
    }

    /// WHERE句 ///
    $where = $this->_makeWhere($q);
    if (!empty($where)) {
      $where = ' AND ' . $where;
    }

    /// SQLクエリを作成・一覧を取得 ///
    $sql = "SELECT count(bm.*) FROM view_bid_machines bm WHERE bm.bid_open_id = ? {$where} LIMIT 1;";
    $result = $this->_db->fetchOne($sql, $q['bid_open_id']);

    return $result;
  }

  public function getXlGenreList($q)
  {
    if (empty($q['bid_open_id'])) {
      throw new Exception('入札会開催IDが設定されていません');
    }

    /// WHERE句 ///
    $where = $this->_makeWhere($q);
    if (!empty($where)) {
      $where = ' AND ' . $where;
    }

    /// SQLクエリを作成・一覧を取得 ///
    $sql = "SELECT
          x.*,
          mc.count,
          (
            SELECT
              top_img
            FROM
              view_bid_machines bm2
            WHERE
              bm2.bid_open_id = ? AND
              bm2.xl_genre_id = x.id
            ORDER BY
              random()
            LIMIT
              1
          ) as top_img
        FROM
          (
            SELECT
              bm.xl_genre_id,
              count(xl_genre_id) AS count
            FROM
              view_bid_machines bm
            WHERE
              bm.bid_open_id = ?
              {$where}
            GROUP BY
              bm.xl_genre_id
          ) mc
          LEFT JOIN xl_genres x
            ON mc.xl_genre_id = x.id
        ORDER BY
          x.order_no,
          x.id;";
    $result = $this->_db->fetchAll($sql, array($q['bid_open_id'], $q['bid_open_id']));
    return $result;
  }

  public function getLargeGenreList($q)
  {
    if (empty($q['bid_open_id'])) {
      throw new Exception('入札会開催IDが設定されていません');
    }

    /// WHERE句 ///
    $where = $this->_makeWhere($q);
    if (!empty($where)) {
      $where = ' AND ' . $where;
    }

    /// SQLクエリを作成・一覧を取得 ///
    $sql = "SELECT
          l.*,
          mc.count
        FROM
          (
            SELECT
              bm.large_genre_id,
              count(large_genre_id) AS count
            FROM
              view_bid_machines bm
            WHERE
              bm.bid_open_id = ?
              {$where}
            GROUP BY
              bm.large_genre_id
          ) mc
          LEFT JOIN large_genres l
            ON mc.large_genre_id = l.id
        ORDER BY
          l.order_no,
          l.id;";
    $result = $this->_db->fetchAll($sql, $q['bid_open_id']);
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
    if (empty($q['bid_open_id'])) {
      throw new Exception('入札会開催IDが設定されていません');
    }

    /// WHERE句 ///
    $where = $this->_makeWhere($q);
    if (!empty($where)) {
      $where = ' AND ' . $where;
    }

    /// SQLクエリを作成・一覧を取得 ///
    $sql = "SELECT
          g.*,
          mc.count
        FROM
          (
            SELECT
              bm.genre_id,
              count(genre_id) AS count
            FROM
              view_bid_machines bm
            WHERE
              bm.bid_open_id = ?
              {$where}
            GROUP BY
              bm.genre_id
          ) mc
          LEFT JOIN genres g
            ON mc.genre_id = g.id
        ORDER BY
          g.order_no;";
    $result = $this->_db->fetchAll($sql, $q['bid_open_id']);
    return $result;
  }

  /**
   * 検索条件内の地域一覧取得
   *
   * @access public
   * @param  string  $q   検索クエリ
   * @return array 都道府県一覧
   */
  public function getRegionList($q)
  {
    if (empty($q['bid_open_id'])) {
      throw new Exception('入札会開催IDが設定されていません');
    }

    /// WHERE句 ///
    $where = $this->_makeWhere($q);
    if (!empty($where)) {
      $where = ' AND ' . $where;
    }

    /// SQLクエリを作成・一覧を取得 ///
    $sql = "SELECT
          r.*,
          mc.count
        FROM
          (
            SELECT
              bm.region_id,
              count(region_id) AS count
            FROM
              view_bid_machines bm
            WHERE
              bm.bid_open_id = ?
              {$where}
            GROUP BY
              bm.region_id
          ) mc
          LEFT JOIN regions r
            ON mc.region_id = r.id
        WHERE
          r.region IS NOT NULL
        ORDER BY
          r.order_no;";
    $result = $this->_db->fetchAll($sql, $q['bid_open_id']);
    return $result;
  }

  public function getStateList($q)
  {
    if (empty($q['bid_open_id'])) {
      throw new Exception('入札会開催IDが設定されていません');
    }

    /// WHERE句 ///
    $where = $this->_makeWhere($q);
    if (!empty($where)) {
      $where = ' AND ' . $where;
    }

    /// SQLクエリを作成・一覧を取得 ///
    $sql = "SELECT
          s.*,
          mc.count
        FROM
          (
            SELECT
              bm.addr1,
              count(addr1) AS count
            FROM
              view_bid_machines bm
            WHERE
              bm.addr1 IS NOT NULL AND
              bm.bid_open_id = ?
              {$where}
            GROUP BY
              bm.addr1
          ) mc
          LEFT JOIN states s
            ON mc.addr1 = s.STATE
        ORDER BY
          s.order_no;";
    $result = $this->_db->fetchAll($sql, $q['bid_open_id']);
    return $result;
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
      /*
            $arr[] = $this->_db->quoteInto(' bm.genre_id IN
                ( SELECT id FROM genres WHERE large_genre_id IN
                ( SELECT id FROM large_genres WHERE id IN(?))) ',
                $q['large_genre_id']);
            */
      $arr[] = $this->_db->quoteInto(' bm.large_genre_id IN(?) ', $q['large_genre_id']);
    }

    // 特大ジャンルID（複数選択可）
    if (!empty($q['xl_genre_id'])) {
      /*
            $arr[] = $this->_db->quoteInto(' bm.genre_id IN
                ( SELECT id FROM genres WHERE large_genre_id IN
                ( SELECT id FROM large_genres WHERE xl_genre_id IN
                ( SELECT id FROM xl_genres WHERE id IN(?) ))) ',
                $q['xl_genre_id']);
            */
      $arr[] = $this->_db->quoteInto(' bm.xl_genre_id IN(?) ', $q['xl_genre_id']);
    }

    // ジャンルID（複数選択可）
    if (!empty($q['genre_id'])) {
      $arr[] = $this->_db->quoteInto(' bm.genre_id IN(?) ', $q['genre_id']);
    }

    // 掲載会社ID
    if (!empty($q['company_id'])) {
      $arr[] = $this->_db->quoteInto(' bm.company_id IN(?) ', $q['company_id']);
    }

    // 機械ID（複数選択可）
    if (isset($q['id']) && count($q['id'])) {
      $arr[] = $this->_db->quoteInto(' bm.id IN(?) ', $q['id']);
    }


    // リストNo（複数選択可）
    if (!empty($q['list_no']) && count($q['list_no'])) {
      $arr[] = $this->_db->quoteInto(' bm.list_no IN(?) ', $q['list_no']);
    }

    // メーカー
    if (!empty($q['maker'])) {
      $arr[] = $this->_db->quoteInto(' bm.maker IN (?) ', $q['maker']);
    }

    // 地域
    if (!empty($q['region'])) {
      $arr[] = $this->_db->quoteInto(' bm.region IN (?) ', $q['region']);
    }

    // 都道府県
    if (!empty($q['state'])) {
      $arr[] = $this->_db->quoteInto(' bm.addr1 IN (?) ', $q['state']);
    }

    // キーワード検索
    if (!empty($q['keyword'])) {
      $temp = " bm.name || ' ' || coalesce(bm.maker, '') || ' ' || coalesce(bm.model, '') || ' ' || coalesce(bm.model2, '') || ' ' || " .
        " coalesce(bm.addr1, '') || ' ' || coalesce(bm.addr2, '') || ' ' || " .
        " coalesce(bm.location, '')  || ' ' || " .
        " bm.genre || ' ' || cast(bm.list_no as text) " .
        // " || ' ' || coalesce(bm.company, '') " .
        "ILIKE ? ";
      $k = preg_replace("/(\s|　)+/", ' ', $q['keyword']);
      foreach (explode(" ", $k) as $key => $val) {
        $arr[] = $this->_db->quoteInto($temp, '%' . $val . '%');
      }
    }
    //
    // // ORキーワード検索
    // if (!empty($q['orkeyword'])) {
    //     $temp = " bm.name || ' ' || coalesce(bm.maker, '') || ' ' || coalesce(bm.model, '') || ' ' || coalesce(bm.model2, '') || ' ' || " .
    //         " coalesce(bm.addr1, '') || ' ' || coalesce(bm.addr2, '') || ' ' || " .
    //         " coalesce(bm.location, '')  || ' ' || " .
    //         " bm.genre || ' ' || cast(bm.list_no as text) ~ ? ";
    //     $ork = trim(preg_replace("/(\s|　|\||｜)+/", '|', $q['orkeyword']));
    //     if (!empty($ork)) {
    //       $arr[] = $this->_db->quoteInto($temp, 'xxxxx|' . $ork . '|xxxxx');
    //     }
    // }

    // セリ出品
    if (!empty($q['is_seri'])) {
      $arr[] = ' (bm.seri_price IS NOT NULL OR bm.seri_price <> 0) ';
      $arr[] = ' NOT EXISTS (SELECT id FROM bid_bids WHERE bid_machine_id = bm.id AND deleted_at IS NULL ) ';
    }

    /// ここまでで、検索条件チェック ///
    if ($check == true && count($arr) == 0) {
      return false;
    }

    return implode(' AND ', $arr);
  }

  public function getResultList($bidOpenId)
  {
    if (empty($bidOpenId)) {
      throw new Exception('入札会開催IDが設定されていません');
    }

    /// SQLクエリを作成・一覧を取得 ///
    $sql = "SELECT
          bm.id,
          bb1.id AS bid_id,
          bb1.company_id,
          bb1.company,
          bb1.amount,
          bb1.sameno,
          bb1.charge,
          bb1.comment,
          bb2.count,
          bb2.same_count
        FROM
          bid_machines bm
          LEFT JOIN bid_opens bo
            ON bo.id = bm.bid_open_id
          LEFT JOIN (
            SELECT DISTINCT ON (bb.bid_machine_id)
              bb.*,
              c.company
            FROM
              bid_bids bb
              LEFT JOIN companies c
                ON c.id = bb.company_id
            WHERE
              bb.deleted_at IS NULL
            ORDER BY
              bb.bid_machine_id,
              amount DESC,
              sameno DESC
          ) bb1
            ON bb1.bid_machine_id = bm.id
          LEFT JOIN (
            SELECT
              bid_machine_id,
              count(*) AS count,
              count(
                CASE WHEN (bid_machine_id, amount) IN (
                  SELECT
                    bid_machine_id,
                    max(amount)
                  FROM
                    bid_bids
                  WHERE
                    deleted_at IS NULL
                  GROUP BY
                    bid_machine_id
                )
                THEN 1 END) AS same_count
            FROM
              bid_bids
            WHERE
              deleted_at IS NULL
            GROUP BY
              bid_machine_id
          ) bb2
            ON bm.id = bb2.bid_machine_id
        WHERE
          bm.deleted_at IS NULL AND
          bm.bid_open_id = ?
        ORDER BY
          bm.id;";
    $result = $this->_db->fetchAll($sql, $bidOpenId);
    return $result;
  }

  public function getResultListAsKey($bidOpenId)
  {
    $resultList = $this->getResultList($bidOpenId);

    $resultListAsKey = array();
    foreach ($resultList as $r) {
      $resultListAsKey[$r['id']] = $r;
      unset($resultListAsKey[$r['id']]['id']);
    }

    return $resultListAsKey;
  }

  public function getResultListCompany($bidOpenId, $companyId)
  {
    if (empty($bidOpenId)) {
      throw new Exception('入札会開催IDが設定されていません');
    }

    if (empty($companyId)) {
      throw new Exception('会社IDが設定されていません');
    }

    $sql = "SELECT
          bm.id,
          bb1.id AS bid_id,
          bb1.amount,
          bb1.sameno
        FROM
          bid_machines bm
          LEFT JOIN bid_opens bo
            ON bo.id = bm.bid_open_id
          LEFT JOIN (
            SELECT DISTINCT
                ON (bb.bid_machine_id) bb.*,
              c.company
            FROM
              bid_bids bb
              LEFT JOIN companies c
                ON c.id = bb.company_id
            WHERE
              bb.deleted_at IS NULL AND
              bb.company_id = ?
            ORDER BY
              bb.bid_machine_id,
              amount DESC,
              sameno DESC
          ) bb1
            ON bb1.bid_machine_id = bm.id
        WHERE
          bm.deleted_at IS NULL AND
          bm.bid_open_id = ? AND
          bb1.amount IS NOT NULL
        ORDER BY
          bm.id;";
    $result = $this->_db->fetchAll($sql, array($companyId, $bidOpenId));
    return $result;
  }

  public function getResultListCompanyAsKey($bidOpenId, $companyId)
  {
    $resultListCompany = $this->getResultListCompany($bidOpenId, $companyId);

    $resultListCompanyAsKey = array();
    foreach ($resultListCompany as $r) {
      $resultListCompanyAsKey[$r['id']] = $r;
      unset($resultListCompanyAsKey[$r['id']]['id']);
    }

    return $resultListCompanyAsKey;
  }

  public function getResultByBidMachineId($id)
  {
    if (empty($id)) {
      throw new Exception('入札会商品IDが設定されていません');
    }

    /// SQLクエリを作成 ///
    $sql = "SELECT
          bm.id,
          bb1.id AS bid_id,
          bb1.company_id,
          bb1.company,
          bb1.amount,
          bb1.sameno,
          bb2.count,
          bb2.same_count
        FROM
          bid_machines bm
          LEFT JOIN bid_opens bo
            ON bo.id = bm.bid_open_id
          LEFT JOIN (
            SELECT DISTINCT ON (bb.bid_machine_id)
              bb.*,
              c.company
            FROM
              bid_bids bb
              LEFT JOIN companies c
                ON c.id = bb.company_id
            WHERE
              bb.deleted_at IS NULL
            ORDER BY
              bb.bid_machine_id,
              amount DESC,
              sameno DESC
          ) bb1
            ON bb1.bid_machine_id = bm.id
          LEFT JOIN (
            SELECT
              bid_machine_id,
              count(*) AS count,
              count(
                CASE WHEN (bid_machine_id, amount) IN (
                  SELECT
                    bid_machine_id,
                    max(amount)
                  FROM
                    bid_bids
                  WHERE
                    deleted_at IS NULL
                  GROUP BY
                    bid_machine_id
                )
                THEN 1 END) AS same_count
            FROM
              bid_bids
            WHERE
              deleted_at IS NULL
            GROUP BY
              bid_machine_id
          ) bb2
            ON bm.id = bb2.bid_machine_id
        WHERE
          bm.deleted_at IS NULL AND
          bm.id = ?
        ORDER BY
          bm.id;";
    $result = $this->_db->fetchRow($sql, $id);
    return $result;
  }

  public function getResultCompanyByBidMachineId($id, $companyId)
  {
    if (empty($id)) {
      throw new Exception('入札会商品IDが設定されていません');
    }

    if (empty($companyId)) {
      throw new Exception('会社IDが設定されていません');
    }

    $sql = "SELECT
          bm.id,
          bb1.id AS bid_id,
          bb1.amount,
          bb1.sameno
        FROM
          bid_machines bm
          LEFT JOIN bid_opens bo
            ON bo.id = bm.bid_open_id
          LEFT JOIN (
            SELECT DISTINCT
                ON (bb.bid_machine_id) bb.*,
              c.company
            FROM
              bid_bids bb
              LEFT JOIN companies c
                ON c.id = bb.company_id
            WHERE
              bb.deleted_at IS NULL AND
              bb.company_id = ?
            ORDER BY
              bb.bid_machine_id,
              amount DESC,
              sameno DESC
          ) bb1
            ON bb1.bid_machine_id = bm.id
        WHERE
          bm.deleted_at IS NULL AND
          bm.id = ? AND
          bb1.amount IS NOT NULL
        ORDER BY
          bm.id;";
    $result = $this->_db->fetchRow($sql, array($companyId, $id));
    return $result;
  }

  /**
   * 入札会に出品されている機械ID配列を取得
   *
   * @access public
   * @param array $q 検索条件
   * @return array 入札会開催IDごとの機械ID配列
   */
  public function getMachineIds($q = array())
  {
    /// WHERE句 ///
    $where = '';
    if (!empty($q['status']) && $q['status'] == 'entry') {
      $where .= ' AND bo.entry_start_date <= now() AND bo.bid_end_date > now() ';
    } else {
      $where .= ' AND bo.bid_start_date <= now() AND bo.bid_end_date > now() ';
    }

    if (!empty($q['machine_id'])) {
      $where .= $this->_db->quoteInto(' AND bm.machine_id = ? ', $q['machine_id']);
    }

    /// LIMIT句、OFFSET句 ///

    /*
        // SQLクエリを作成
        $sql = "SELECT
          bo.id,
          bo.title,
          string_agg(bm.machine_id::text, '|') as machine_ids
        FROM
          bid_opens bo
          LEFT JOIN bid_machines bm
            ON bo.id = bm.bid_open_id
        WHERE
          bm.deleted_at IS NULL AND
          bo.deleted_at IS NULL AND
          bm.machine_id IS NOT NULL
          {$where}
        GROUP BY
          bo.id,
          bo.title
        ORDER BY
          bo.id";
        $result = $this->_db->fetchAll($sql);

        if (!empty($result)) {
            foreach ($result as $key => $r) {
                $result[$key]['machine_ids'] = explode('|', $r['machine_ids']);
            }
        }
        */

    // SQLクエリを作成
    $sql = "SELECT
          bm.id as bid_machine_id,
          bm.machine_id,
          bm.min_price,
          bm.bid_open_id,
          bo.title AS bid_title
        FROM
          bid_machines bm
          LEFT JOIN bid_opens bo
            ON bo.id = bm.bid_open_id
        WHERE
          bm.deleted_at IS NULL AND
          bo.deleted_at IS NULL AND
          bm.machine_id IS NOT NULL
          {$where}
        ORDER BY
          bm.machine_id
        ";
    $res = $this->_db->fetchAll($sql);

    $result = array();
    // machine_idをキーに再構成
    if (!empty($res)) {
      foreach ($res as $key => $r) {
        $result[$r['machine_id']] = $r;
      }
    }

    return $result;
  }

  /**
   * 入札会商品情報を取得
   *
   * @access public
   * @param  string  $id 入札会開催ID
   * @return array 入札会開催情報を取得
   */
  public function get($id)
  {
    if (empty($id)) {
      throw new Exception('入札会商品IDが設定されていません');
    }

    // SQLクエリを作成
    $sql = "SELECT
          bm.* FROM view_bid_machines bm  WHERE bm.id = ? LIMIT 1;";
    $result = $this->_db->fetchRow($sql, $id);

    // JSON展開
    $result = B::decodeRowJson($result, array_merge($this->_jsonColumn, array('spec_labels')));

    return $result;
  }

  /**
   * 同じ機械情報を取得
   *
   * @access public
   * @param  string $id 機械ID
   * @return array 機械情報一覧を取得
   */
  public function getSameList($id)
  {
    if (empty($id)) {
      throw new Exception('機械IDが設定されていません');
    }

    // SQLクエリを作成
    $sql = "SELECT
          m.*
        FROM
          view_bid_machines m
        WHERE
          (bid_open_id, maker_master, model2) = (SELECT bid_open_id, maker_master, model2 FROM view_bid_machines WHERE id = ?) AND
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
   * @param  integer $bidOpenId 入札会ID
   * @param  array $limit 最大取得数
   * @return array 機械情報一覧を取得
   */
  public function getLogList($id, $limit = 24)
  {
    if (empty($id)) {
      throw new Exception('機械IDが設定されていません');
    }

    // SQLクエリを作成
    $sql = "SELECT
          m.*
        FROM
          view_bid_machines m
          RIGHT JOIN (
            SELECT
              a.action_id,
              count(a.action_id) as count
            FROM
              view_bid_machine_logs a
            WHERE
              a.log_created_at > CURRENT_TIMESTAMP + '-1month' AND
              a.action_id <> ? AND
              (a.ip, a.bid_open_id) IN (
                SELECT DISTINCT
                  a2.ip,
                  a2.bid_open_id
                FROM
                  view_bid_machine_logs a2
                WHERE
                  a2.action_id = ? AND
                  a2.log_created_at > CURRENT_TIMESTAMP + '-1month' AND
                  a2.ip <> ?
              )
              GROUP BY
                a.action_id
          ) ac ON m.id = ac.action_id
        WHERE
          deleted_at IS NULL
        ORDER BY
          ac.count DESC,
          m.created_at DESC
        LIMIT
          ?;";
    $result = $this->_db->fetchAll($sql, array($id, $id, $_SERVER['REMOTE_ADDR'], $limit));

    // JSON展開
    $result = B::decodeTableJson($result, array_merge($this->_jsonColumn, array('spec_labels')));

    return $result;
  }

  /**
   * 最近見た機械情報を取得
   *
   * @access public
   * @param  integer $bidOpenId 入札会ID
   * @param  array $limit 最大取得数
   * @return array 機械情報一覧を取得
   */
  public function getIPLogList($bidOpenId, $limit = 24)
  {
    // SQLクエリを作成
    $sql = "SELECT
          m.*
        FROM
          view_bid_machines m
          RIGHT JOIN (
            SELECT
              a.action_id,
              max(a.log_created_at) AS created_at
            FROM
              view_bid_machine_logs a
            WHERE
              a.log_created_at > CURRENT_TIMESTAMP + '-1month' AND
              a.bid_open_id = ? AND
              a.ip = ?
            GROUP BY
              action_id
          ) ac
            ON m.id = ac.action_id
        WHERE
          m.deleted_at IS NULL
        ORDER BY
          ac.created_at DESC
        LIMIT
          ?;";
    $result = $this->_db->fetchAll($sql, array($bidOpenId, $_SERVER['REMOTE_ADDR'], $limit));

    // JSON展開
    $result = B::decodeTableJson($result, array_merge($this->_jsonColumn, array('spec_labels')));

    return $result;
  }

  /**
   * よく見られている商品を取得する
   *
   * @access public
   * @param  integer $bidOpenId 入札会ID
   * @param  array $limit 最大取得数
   * @return array 商品一覧
   */
  public function getFaviList($bidOpenId, $limit = 24)
  {
    if (empty($bidOpenId)) {
      throw new Exception('即売会IDが設定されていません');
    }

    /// 検索クエリを作成・実行 ///
    $sql = "SELECT
          m.*
        FROM
          view_bid_machines m
          INNER JOIN (
            SELECT
              action_id,
              count(*) AS count
            FROM
              view_bid_machine_logs a
            WHERE
              a.log_created_at > CURRENT_TIMESTAMP + '-1month' AND
              a.bid_open_id = ?
            GROUP BY
              a.action_id
          ) ac
            ON m.id = ac.action_id
        ORDER BY
          ac.count DESC
        LIMIT
          ?;";
    $result = $this->_db->fetchAll($sql, array($bidOpenId, $limit));

    return $result;
  }

  /**
   * リストNoの最大値を取得
   *
   * @access public
   * @param  array $bidOpenId 入札ID
   * @return integer リストNoの最大値
   */
  public function getMaxListNo($bidOpenId)
  {
    /// 検索クエリを作成・実行 ///
    $sql = "SELECT max(m.list_no) FROM view_bid_machines m WHERE m.bid_open_id = ? LIMIT 1;";
    $result = $this->_db->fetchOne($sql, $bidOpenId);

    return !empty($result) ? $result : 0;
  }

  /**
   * 入札会商品情報を論理削除
   *
   * @access public
   * @param  array $id 入札会商品ID
   * @param  array $companyId 会社ID
   * @return $this
   */
  public function deleteById($id, $companyId)
  {
    if (empty($id)) {
      throw new Exception('削除する入札会商品IDが設定されていません');
    }

    // 出品期間中かのチェック
    $bmModel = new BidMachine();
    $machine = $bmModel->get($id);

    $boModel = new BidOpen();
    $bidOpen = $boModel->get($machine['bid_open_id']);
    if (empty($bidOpen)) {
      throw new Exception("入札会情報が取得出来ませんでした");
    } else if (Auth::check('system') && in_array($bidOpen['status'], array('entry', 'margin', 'bid'))) {
      // 管理者の場合は、入札期間でも登録変更を行えるようにする
    } else if ($bidOpen['status'] != 'entry') {
      throw new Exception($bidOpen['title'] . " は現在、出品期間ではありません");
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
   * 出品商品情報をセット
   *
   * @access public
   * @param array $data 出品商品データ
   * @param  array $id 出品商品ID
   * @return $this
   */
  public function set($data, $id, $companyId)
  {
    // 会社情報のチェック
    if (empty($companyId)) {
      throw new Exception("会社情報がありません");
    }

    // 出品期間中かのチェック
    $boModel = new BidOpen();
    $bidOpen = $boModel->get($data['bid_open_id']);
    if (empty($bidOpen)) {
      throw new Exception("入札会情報が取得出来ませんでした");
    } else if (Auth::check('system') && in_array($bidOpen['status'], array('entry', 'margin', 'bid'))) {
      // 管理者の場合は、入札期間でも登録変更を行えるようにする
    } else if ($bidOpen['status'] != 'entry') {
      throw new Exception($bidOpen['title'] . " は現在、出品期間ではありません");
    }

    // 最低入札金額のチェック
    if (empty($data['min_price'])) {
      throw new Exception("最低入札金額がありません id:{$machineId} {$companyId}");
    } else if ($bidOpen['min_price'] > $data['min_price']) {
      throw new Exception("最低入札金額が、入札会の最低入札金額より小さく入力されています");
    } else if (($data['min_price'] % $bidOpen['rate']) != 0) {
      throw new Exception("最低入札金額が、入札レートの倍数ではありません");
    }

    // セリ価格のチェック
    if (!empty($data['seri_price'])) {
      if ($bidOpen['min_price'] > $data['seri_price']) {
        throw new Exception("セリ分かれ価格が、入札会の最低入札金額より小さく入力されています");
      } else if (($data['seri_price'] % $bidOpen['rate']) != 0) {
        throw new Exception("セリ分かれ価格が、入札レートの倍数ではありません");
      }
    }

    // データの結合
    $data['company_id'] = $companyId;

    // フィルタリング・バリデーション
    $data = MyFilter::filter($data, $this->_filter);

    // JSONデータ保管
    foreach ($this->_jsonColumn as $val) {
      $data[$val] = !empty($data[$val]) ? json_encode($data[$val], JSON_UNESCAPED_UNICODE) : null;
    }

    if (empty($id)) {
      /// @ba-ta 20140925 商品番号の自動付加 ///
      $maxListNo = $this->getMaxListNo($data['bid_open_id']);
      $data['list_no']  = empty($maxListNo) ? 1 : $maxListNo + 1;

      // 新規処理
      $res = $this->insert($data);
    } else {
      // 更新処理
      $data['changed_at'] = new Zend_Db_Expr('current_timestamp');
      $res = $this->update($data, $this->_db->quoteInto('id = ?', $id));
    }

    if (empty($res)) {
      throw new Exception("入札会商品情報が保存できませんでした id:{$id}");
    }

    return $this;
  }

  public function set2machine($machineId, $companyId, $bidOpenId, $minPrice)
  {
    // 出品期間中かのチェック
    $boModel = new BidOpen();
    $bidOpen = $boModel->get($bidOpenId);
    if (empty($bidOpen)) {
      throw new Exception("入札会情報が取得出来ませんでした");
    } else if ($bidOpen['status'] != 'entry') {
      throw new Exception($bidOpen['title'] . " は現在、出品期間ではありません");
    }

    // 該当機械情報の取得
    $mModel = new Machine();
    $machine = $mModel->get($machineId);

    // 自社の機械情報かのチェック
    if ($machine['company_id'] != $companyId) {
      throw new Exception("この入札会商品はあなたの在庫ではありません id:{$machineId} {$companyId}");
    }

    // 最低入札金額のチェック
    if (empty($minPrice)) {
      throw new Exception("最低入札金額がありません id:{$machineId} {$companyId}");
    } else if ($bidOpen['min_price'] > $minPrice) {
      throw new Exception("最低入札金額が、入札会の最低入札金額より小さく入力されています");
    } else if (($minPrice % $bidOpen['rate']) != 0) {
      throw new Exception("最低入札金額が、入札レートの倍数ではありません");
    }

    // 不要情報の削除
    unset($machine['id'], $machine['no'], $machine['created_at'], $machine['changed_at']);

    // データの結合
    $machine['bid_open_id'] = $bidOpenId;
    $machine['min_price']   = $minPrice;
    $machine['machine_id']  = $machineId;

    // フィルタリング・バリデーション
    $machine = MyFilter::filter($machine, $this->_filter);
    // JSONデータ保管
    foreach ($this->_jsonColumn as $val) {
      $machine[$val] = json_encode($machine[$val], JSON_UNESCAPED_UNICODE);
    }

    /// @ba-ta 20140925 商品番号の自動付加 ///
    $maxListNo = $this->getMaxListNo($bidOpenId);
    $machine['list_no']  = empty($maxListNo) ? 1 : $maxListNo + 1;

    $res = $this->insert($machine);

    if (empty($res)) {
      throw new Exception("在庫機械から入札会商品情報が保存できませんでした id:{$machineId}");
    }

    return $this;
  }

  public function getSeriResultList($bidOpenId)
  {
    if (empty($bidOpenId)) {
      throw new Exception('入札会開催IDが設定されていません');
    }

    /// SQLクエリを作成・一覧を取得 ///
    $sql = "SELECT
          bm.id,
          bb1.id AS bid_id,
          bb1.company_id,
          bb1.company,
          bb1.amount,
          bb2.count
        FROM
          bid_machines bm
          LEFT JOIN bid_opens bo
            ON bo.id = bm.bid_open_id
          LEFT JOIN (
            SELECT DISTINCT ON (bb.bid_machine_id)
              bb.*,
              c.company
            FROM
              seri_bids bb
              LEFT JOIN companies c
                ON c.id = bb.company_id
            ORDER BY
              bb.bid_machine_id,
              amount DESC,
              id
          ) bb1
            ON bb1.bid_machine_id = bm.id
          LEFT JOIN (
            SELECT
              bid_machine_id,
              count(*) AS count
            FROM
              seri_bids
            GROUP BY
              bid_machine_id
          ) bb2
            ON bm.id = bb2.bid_machine_id
        WHERE
          bm.deleted_at IS NULL AND
          bm.bid_open_id = ?
        ORDER BY
          bm.id;";
    $result = $this->_db->fetchAll($sql, $bidOpenId);
    return $result;
  }

  public function getSeriResultListAsKey($bidOpenId)
  {
    $resultList = $this->getSeriResultList($bidOpenId);

    $resultListAsKey = array();
    foreach ($resultList as $r) {
      $resultListAsKey[$r['id']] = $r;
      unset($resultListAsKey[$r['id']]['id']);
    }

    return $resultListAsKey;
  }

  /**
   * セリ分かれ金額のみをセット
   *
   * @access public
   * @param array $id         出品商品ID
   * @param int $seri_price セリ分かれ価格
   * @param array $company_id 会社ID
   * @return $this
   */
  public function setSeriPrice($id, $seri_price, $companyId)
  {
    // 会社情報のチェック
    if (empty($companyId)) {
      throw new Exception("会社情報がありません");
    }

    if (empty($id)) {
      throw new Exception("セリ分かれ出品する商品IDがありません");
    } else if (!($m = $this->get($id))) {
      throw new Exception("セリ分かれ出品する商品IDが取得できませんでした");
    } else if ($m["company_id"] != $companyId) {
      throw new Exception("セリ分かれ出品する商品は、貴社の出品商品ではありません");
    }

    // 出品期間中かのチェック
    $boModel = new BidOpen();
    $bidOpen = $boModel->get($m['bid_open_id']);
    if (empty($bidOpen)) {
      throw new Exception("入札会情報が取得出来ませんでした");
    } else if (empty($bidOpen['seri_start_date']) || empty($bidOpen['seri_end_date'])) {
      throw new Exception($bidOpen['title'] . " は、セリ分かれが開催されません");
    } else if (strtotime($bidOpen["seri_start_date"]) <= time()) {
      throw new Exception($bidOpen['title'] . " は現在、セリ分かれ出品期間ではありません");
    }

    // セリ価格のチェック
    if (!empty($seri_price)) {
      if ($bidOpen['min_price'] > $seri_price) {
        throw new Exception("セリ分かれ価格が、入札会の最低入札金額より小さく入力されています");
      } else if (($seri_price % $bidOpen['rate']) != 0) {
        throw new Exception("セリ分かれ価格が、入札単位の倍数ではありません");
      }
    }

    // フィルタリング・バリデーション
    $data = array(
      "seri_price" => $seri_price,
    );
    $data = MyFilter::filter($data, array('rules' => array('セリ分かれ価格' => array('fields' => 'seri_price', 'Digits')), 'options' => array('presence' => 'optional')));

    // 更新処理
    $data['changed_at'] = new Zend_Db_Expr('current_timestamp');
    $res = $this->update($data, $this->_db->quoteInto('id = ?', $id));

    if (empty($res)) {
      throw new Exception("セリ分かれ金額が保存できませんでした id:{$id}");
    }

    return $this;
  }

  /**
   * セリ分かれ即決処理
   *
   * @access public
   * @param array $id         出品商品ID
   * @param array $company_id 会社ID
   * @return $this
   */
  public function setPrompt($id, $companyId)
  {
    // 会社情報のチェック
    if (empty($companyId)) {
      throw new Exception("会社情報がありません");
    }

    if (empty($id)) {
      throw new Exception("即決処理する商品IDがありません");
    } else if (!($m = $this->get($id))) {
      throw new Exception("即決処理する商品IDが取得できませんでした");
    } else if ($m["company_id"] != $companyId) {
      throw new Exception("即決処理する商品は、貴社の出品商品ではありません");
    } else if (!$m["seri_price"]) {
      throw new Exception("即決処理する商品は、セリ分かれに出品されていません");
    }

    // 出品期間中かのチェック
    $boModel = new BidOpen();
    $bidOpen = $boModel->get($m['bid_open_id']);
    if (empty($bidOpen)) {
      throw new Exception("入札会情報が取得出来ませんでした");
    } else if (empty($bidOpen['seri_start_date']) || empty($bidOpen['seri_end_date'])) {
      throw new Exception($bidOpen['title'] . " は、セリ分かれが開催されません");
    } else if (strtotime($bidOpen["seri_start_date"]) > time() && strtotime($bidOpen["seri_end_date"]) <= time()) {
      throw new Exception($bidOpen['title'] . " は現在、セリ分かれ出品期間ではありません");
    }

    // 更新処理
    $data = array(
      'prompt' => 1,
      'changed_at' => new Zend_Db_Expr('current_timestamp'),
    );
    $res = $this->update($data, $this->_db->quoteInto('id = ?', $id));

    if (empty($res)) {
      throw new Exception("即決処理でエラーが発生しました id:{$id}");
    }

    return $this;
  }

  /**
   * 出品キャンセルをセット
   *
   * @access public
   * @param array $data 出品キャンセルデータ
   * @param  int $id 出品商品ID
   * @param  int $company_id 出品会社ID
   *
   * @return $this
   */
  public function set_cancel($data, $id, $company_id)
  {
    // 情報のチェック
    if (empty($company_id)) {
      throw new Exception("会社情報がありません");
    } elseif (empty($id)) {
      throw new Exception("商品情報がありません");
    } elseif (empty($data['cancel_comment'])) {
      throw new Exception("キャンセル理由がありません");
    }

    // // 出品期間中かのチェック
    // $boModel = new BidOpen();
    // $bidOpen = $boModel->get($data['bid_open_id']);
    // if (empty($bidOpen)) {
    //   throw new Exception("入札会情報が取得出来ませんでした");
    // } else if (!in_array($bidOpen['status'], array('margin', 'bid'))) {
    //   throw new Exception($bidOpen['title'] . " は現在、下見・入札期間ではありません");
    // }

    // データの結合
    $data['changed_at']  = new Zend_Db_Expr('current_timestamp');
    $data['canceled_at'] = new Zend_Db_Expr('current_timestamp');

    // 更新処理
    $res = $this->update($data, $this->_db->quoteInto('id = ?', $id));

    if (empty($res)) {
      throw new Exception("出品キャンセルが保存できませんでした id:{$id}");
    }

    return $this;
  }

  /**
   * 出品キャンセルを解除
   *
   * @access public
   * @param  int $id 出品商品ID
   * @param  int $company_id 出品会社ID
   *
   * @return $this
   */
  public function delete_cancel($id, $company_id)
  {
    // 情報のチェック
    if (empty($company_id)) {
      throw new Exception("会社情報がありません");
    } elseif (empty($id)) {
      throw new Exception("商品情報がありません");
    }

    // // 出品期間中かのチェック
    // $boModel = new BidOpen();
    // $bidOpen = $boModel->get($data['bid_open_id']);
    // if (empty($bidOpen)) {
    //   throw new Exception("入札会情報が取得出来ませんでした");
    // } else if (!in_array($bidOpen['status'], array('margin', 'bid'))) {
    //   throw new Exception($bidOpen['title'] . " は現在、下見・入札期間ではありません");
    // }

    // データの結合
    $data = [];
    $data['changed_at']  = new Zend_Db_Expr('current_timestamp');
    $data['canceled_at'] = null;

    // 更新処理
    $res = $this->update($data, $this->_db->quoteInto('id = ?', $id));

    if (empty($res)) {
      throw new Exception("出品キャンセル情報が保存できませんでした id:{$id}");
    }

    return $this;
  }

  /**
   * 自動入札設定をセット
   *
   * @access public
   * @param  int $id 出品商品ID
   *
   * @return $this
   */
  public function set_auto($id)
  {
    $data = [
      'auto_at'    => new Zend_Db_Expr('current_timestamp'),
      'changed_at' => new Zend_Db_Expr('current_timestamp'),
    ];

    // 更新処理
    $res = $this->update($data, $this->_db->quoteInto('id = ?', $id));

    if (empty($res)) {
      throw new Exception("自動入札の設定が保存できませんでした id:{$id}");
    }

    return $this;
  }

  /**
   * 自動入札設定を解除
   *
   * @access public
   * @param  int $id 出品商品ID
   *
   * @return $this
   */
  public function delete_auto($id)
  {
    $data = [
      'auto_at'    => null,
      'changed_at' => new Zend_Db_Expr('current_timestamp'),
    ];

    // 更新処理
    $res = $this->update($data, $this->_db->quoteInto('id = ?', $id));

    if (empty($res)) {
      throw new Exception("出品キャンセル情報が保存できませんでした id:{$id}");
    }

    return $this;
  }
}

<?php
/**
 * 掲載会社情報モデルクラス
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
class Company extends Zend_Db_Table_Abstract
{
    protected $_name = 'companies';
    
    // 内容がJSONのカラム
    private $_jsonColumn = array('infos', 'imgs', 'offices', 'bid_entries');
    private $_jsonEntryColumn = array('infos', 'imgs', 'offices');
    
    // フィルタ条件
    protected $_changeFilter = array('rules' => array(
        '*'          => array(),
        
        '担当者'     => array('fields' => 'officer', 'NotEmpty'),
        'お問い合わせTEL'        => array('fields' => 'contact_tel', 'NotEmpty'),
        'お問い合わせFAX'        => array('fields' => 'contact_fax', 'NotEmpty'),
        'お問い合わせメールアドレス' => array('fields' => 'contact_mail', 'EmailAddress'),
    ));
    
    protected $_systemChangeFilter = array('rules' => array(
        '会社名'     => array('fields' => 'company', 'NotEmpty'),
        '会社名カナ' => array('fields' => 'company_kana', 'NotEmpty'),
        '代表者名' => array('fields' => 'representative', 'NotEmpty'),
        
        '〒'         => array('fields' => 'zip', 'NotEmpty'),
        '住所(都道府県)'   => array('fields' => 'addr1', 'NotEmpty'),
        '住所(市区町村)'   => array('fields' => 'addr2', 'NotEmpty'),
        '住所(番地その他)' => array('fields' => 'addr3', 'NotEmpty'),
        '緯度' => array('fields' => 'lat', 'Float'),
        '経度' => array('fields' => 'lng', 'Float'),
        
        'TEL'        => array('fields' => 'tel', 'NotEmpty'),
        'FAX'        => array('fields' => 'fax', 'NotEmpty'),
        'メールアドレス' => array('fields' => 'mail', 'EmailAddress'),
        'ウェブサイトアドレス' => array(
            'fields' => 'website',
            array('Callback', 'Zend_Uri::check')
        ),
        '団体ID' => array('fields' => 'group_id', 'Digits'),
    ));
    
    /**
     * 掲載会社一覧を取得
     *
     * @access public
     * @param  mixed  $id   会社ID
     * @return array メンバー一覧
     */
    public function getList($q=NULL)
    {
        $where = '';
        if (!empty($q['id'])) {
            $where.= ' AND' . $this->_db->quoteInto(' c.id IN (?) ', $q['id']);
        }
        
        if (!empty($q['group_id'])) {
            $where.= ' AND' . $this->_db->quoteInto(' c.group_id IN (?) ', $q['group_id']);
        }
        
        if (!empty($q['root_id'])) {
            $where.= ' AND' . $this->_db->quoteInto(' r.root_id IN (?) ', $q['root_id']);
        }
        
        if (!empty($q['notnull'])) {
            $where.= ' AND m.count IS NOT NULL ';
            $orderBy = ' c.company_kana, c.id ';            
        } else {
            $orderBy = ' r.root_id, c.group_id, c.company_kana, c.id ';
        }
        
        // SQLクエリを作成
        $sql = Group::WITH_RECURSIVE_SQL . " SELECT
            c.*, 
            m.count, 
            r.level,
            r.treenames,
            r.root_id,
            r.groupname,
            r.rootname
          FROM
            companies c 
            LEFT JOIN r 
              ON r.id = c.group_id 
            LEFT JOIN ( 
              SELECT
                company_id, 
                count(*) as count
              FROM
                machines 
              WHERE
                deleted_at IS NULL 
              GROUP BY
                company_id
            ) m 
              ON m.company_id = c.id 
          WHERE
            c.deleted_at IS NULL AND
            r.deleted_at IS NULL 
            {$where}
          ORDER BY
            {$orderBy};";
        $result = $this->_db->fetchAll($sql);
        if (empty($result)) {
            throw new Exception('会社情報を取得できませんでした');
        }
        
        // JSON展開
        $result = B::decodeTableJson($result, $this->_jsonColumn);
        return $result;
    }
    
    /**
     * 掲載会社一覧を取得
     *
     * @access public
     * @param  mixed  $id   会社ID
     * @return array メンバー一覧
     */
    public function getListRegion($q=NULL)
    {
        // SQLクエリを作成
        $sql = " SELECT
            c.*,
            r.region
          FROM
            companies c 
          LEFT JOIN states s 
            ON s.state = c.addr1 
          LEFT JOIN regions r 
            ON r.id = s.region_id 
          WHERE
            c.deleted_at IS NULL
          ORDER BY
            r.order_no, s.order_no, c.company_kana, c.id;";
        $result = $this->_db->fetchAll($sql);
        if (empty($result)) {
            throw new Exception('会社情報を取得できませんでした');
        }
        
        // JSON展開
        $result = B::decodeTableJson($result, $this->_jsonColumn);
        return $result;
    }
    
    /**
     * 所属団体から会社情報件数(メール送信用)を取得
     *
     * @access public
     * @param  string  $id 団体ID(NULLの場合は、すべて)
     * @return array 団体情報と件数(メールアドレスがある場合のみ)
     */
    public function countForMail($id=NULL)
    {
        $where = '';
        if (!empty($id)) {
            $where.= $this->_db->quoteInto(' c.group_id IN ( SELECT g2.id FROM groups g2 WHERE g2.parent_id = ? ', $id);
            $where.= $this->_db->quoteInto(' OR c.group_id = ? ) AND ', $id);
        }
        
        $sql = "SELECT
          count(c.*) 
        FROM
          companies c 
        WHERE
          {$where}
          c.deleted_at IS NULL AND
          (c.mail IS NOT NULL AND c.mail <> '');";
        $result = $this->_db->fetchOne($sql);

        return $result;
    }
    
    /**
     * 所属団体から会社情報一覧数(メール送信用)を取得
     *
     * @access public
     * @param  string  $id 団体ID(NULLの場合は、すべて)
     * @return array 会社情報一覧(メールアドレスがある場合のみ)
     */
    public function getListForMail($id=NULL)
    {
        $where = '';
        if (!empty($id)) {
            $where.= $this->_db->quoteInto(' c.group_id IN ( SELECT g2.id FROM groups g2 WHERE g2.parent_id = ? ', $id);
            $where.= $this->_db->quoteInto(' OR c.group_id = ? ) AND ', $id);
        }
        
        $sql = "SELECT
          c.company,
          c.mail
        FROM
          companies c 
        WHERE
          {$where}
          c.deleted_at IS NULL AND
          (c.mail IS NOT NULL AND c.mail <> '');";
        $result = $this->_db->fetchAll($sql);

        return $result;
    }
    
    /**
     * メンバー情報を取得
     *
     * @access public
     * @param  string  $id   メンバーID
     * @return array メンバ情報を取得
     */
    public function get($id)
    {
        //// メンバ情報を取得 ////
        if (!intval($id)) {
            throw new Exception('取得する掲載会社IDがありません');
        }
        
        // SQLクエリを作成
        $sql = Group::WITH_RECURSIVE_SQL . " SELECT
            c.*,
            r.level,
            r.treenames,
            r.root_id,
            r.groupname,
            r.rootname
          FROM companies c
          LEFT JOIN r 
              ON r.id = c.group_id 
           WHERE c.deleted_at IS NULL AND c.id = ? LIMIT 1;";
        $result = $this->_db->fetchRow($sql, intval($id));
        if (empty($result)) {
            throw new Exception('会社情報を取得できませんでした');
        }
        
        // JSON展開
        $result = B::decodeRowJson($result, $this->_jsonColumn);
        return $result;
    }
    
    /**
     * 会社情報をセット
     * 
     * @access public     
     * @param array $data 入力データ
     * @param int $id 会社ID 
     * @return $this
     */                    
    public function set($id, $data)
    {
        if (empty($id)) {
            throw new Exception('会社IDがありません');
        }
        
        // フィルタリング・バリデーション
        $data = MyFilter::filter($data, $this->_changeFilter);
        
        // JSONデータ保管
        foreach ($this->_jsonEntryColumn as $val) {
            $data[$val] = json_encode($data[$val], JSON_UNESCAPED_UNICODE);
        }
        
        $data['changed_at'] = new Zend_Db_Expr('current_timestamp');
        
        $result = $this->update($data, $this->_db->quoteInto('id = ?', $id));
        if (empty($result)) {
            throw new Exception('会社情報が保存できませんでした(会社情報がありません)');
        }
        
        return $this;
    }
    
    /**
     * 会社情報(代表者)をセット
     * 
     * @access public     
     * @param array $data 入力データ
     * @param int $id 会社ID 
     * @return $this
     */                    
    public function systemSet($data, $id=null)
    {
        // フィルタリング・バリデーション
        $data = MyFilter::filter($data, $this->_systemChangeFilter);
        
        if (empty($id)) {
            // 新規処理
            // 問い合わせ情報に代表者のものをコピー
            $data['contact_tel']  = $data['tel'];
            $data['contact_fax']  = $data['fax'];
            $data['contact_mail'] = $data['mail'];
            $res = $this->insert($data);
        } else {
            // 更新処理
            $data['changed_at'] = new Zend_Db_Expr('current_timestamp');
            $res = $this->update($data, $this->_db->quoteInto('id = ?', $id));
        }
        
        if (empty($res)) {
            throw new Exception('会社情報(代表者)が保存できませんでした');
        }
        
        return $this;
    }
    
    /**
     * 会社情報(Web入札会商品出品登録)をセット
     * 
     * @access public     
     * @param array $data 入力データ
     * @param int $id 会社ID 
     * @return $this
     */                    
    public function setBidEntries($data, $id=null)
    {
        if (empty($id)) {
            throw new Exception('会社IDがありません');
        }
        
        // JSONデータ保管
        $temp['bid_entries'] = json_encode($data['bid_entries'], JSON_UNESCAPED_UNICODE);
        $temp['changed_at']  = new Zend_Db_Expr('current_timestamp');
        
        $result = $this->update($temp, $this->_db->quoteInto('id = ?', $id));
        if (empty($result)) {
            throw new Exception('会社情報(Web入札会商品出品登録)が保存できませんでした');
        }
        
        return $this;
    }
    
    /**
     * 会社情報を論理削除
     *
     * @access public
     * @param  array $id 会社ID
     * @return $this
     */
    public function deleteById($id) {
        if (empty($id)) {
            throw new Exception('削除する会社IDが設定されていません');
        }
    
        $this->update(
            array('deleted_at' => new Zend_Db_Expr('current_timestamp')),
            array(
                $this->_db->quoteInto(' id IN(?) ', $id)
            )
        );
        
        return $this;
    }
}

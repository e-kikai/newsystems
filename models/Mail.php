<?php
/**
 * メールログクラス
 * 
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/17
 */
class Mail extends Zend_Db_Table
{
    protected $_name = 'mails';
    
    // フィルタ条件
    protected $_filter = array('rules' => array(
        '*'            => array(),
        'タイトル'     => array('fields' => 'subject', 'NotEmpty'),
        // '対象団体'    => array('fields' => 'group_id', 'Digits'),
        '送信対象'     => array('fields' => 'target', 'NotEmpty'),
        '検索値'       => array('fields' => 'val'),
        '検索値ラベル' => array('fields' => 'val_label'),
        '内容'         => array('fields' => 'message', 'NotEmpty'),
    ));
    
    protected $_mailsend;
    
    const MAIL_IGNORE_FILE = '/machine/public/system/csv/mail_ignore.csv';
    
    function __construct()
    {
        //// メールサーバ設定 ////
        $conf = new Zend_Config_Ini(APP_PATH . '/config/mailsend.ini');
        $this->_mailConf = $conf->conf->toArray();
    
        //// メール送信クラス ////
        $this->_mailsend = new Mailsend();
        
        parent::__construct();
    }

    /**
     * メールログ一覧を取得
     *
     * @access public
     * @return array メールログ一覧
     */
    public function getList()
    {
        // SQLクエリを作成
        $sql = "SELECT m.* FROM mails m  ORDER BY m.created_at DESC;";
        $result = $this->_db->fetchAll($sql);
        return $result;
    }
    
    /**
     * メール情報を取得
     *
     * @access public
     * @param  integer $id お知らせID
     * @return array メール情報を取得
     */
    public function get($id) {
        if (empty($id)) {
            throw new Exception('メールIDが設定されていません');
        }
        
        // SQLクエリを作成
        $sql = "SELECT * FROM mails WHERE deleted_at IS NULL AND id = ? LIMIT 1;";
        $result = $this->_db->fetchRow($sql, $id);
        
        return $result;
    }
    
    /**
     * 一括送信メール用のデータを取得
     * 
     * @access public
     * @param array $data 入力データ
     * @param array $file 添付ファイルデータ
     * @return $this
     */             
    public function getSendList($target, $val)
    {
        if (empty($target)) { throw new Exception('送信対象がありません'); }
        
        $list = array();
        if ($target == 'group_id') {
            // 全機連メンバー(団体ID)
            $cModel = new Companies();
            $res = $cModel->getListForMail($val);
            
            foreach($res as $c) {
                if (!empty($c['mail'])) {
                    $list[$c['mail']] = array('name' => $c['company']);
                }
            }
        } else if ($target == 'rankeq') {
            // 全機連メンバー(ランク)
            $cModel = new Companies();
            $res = $cModel->getList(array('rankeq' => $val));
            
            foreach($res as $c) {
                if (!empty($c['mail'])) {
                    $list[$c['mail']] = array('name' => $c['company']);
                }
            }
        } else if ($target == 'contact') {
            // お問い合せ内容
            if (empty($val)) { throw new Exception('送信対象がありません'); }
            $cModel = new Contact();
            if ($val == 'ALL') {
                $res = $cModel->getList('ALL', 'ALL', array('order_by' => 'ASC'));
            } else {
                $res = $cModel->getList('ALL', 'ALL', array('message' => $val));
            }
            
            foreach($res as $c) {
                if (!empty($c['mail'])) {
                    $list[$c['mail']] = array('name' => $c['user_company']. ' ' .$c['user_name']);
                }
            }
        } else if ($target == 'preuser') {
            // 仮登録ユーザ
            if (empty($val)) { throw new Exception('送信対象がありません'); }
            $puModel = new Preuser();
            $res = $puModel->getList(null, 'ALL', array('message' => $val));
            
            foreach($res as $pu) {
                if (!empty($pu['mail'])) {
                    $list[$pu['mail']] = array('name' => $pu['user_name']);
                }
            }
        } else if ($target == 'workinggroup') {
            // ワーキンググループ
            // if (empty($val)) { throw new Exception('送信対象がありません'); }
            
            // CSVを取得
            if (($wgf = B::file2utf(dirname(__FILE__) . '/../machine/public/system/csv/workinggroup_mails.csv')) === FALSE) {
                throw new Exception('ワーキンググループCSVファイルが開けませんでした');
            }
            
            while (($wg = fgetcsv($wgf, 10000, ',')) !== FALSE) {
                if ($wg[2] == 'メールアドレス') { continue; }
                $list[$wg[2]] = array('name' => $wg[0] . ' ' . $wg[1]);
            }
        } else if ($target == 'other' && $val =='test') {
            // テスト送信のみ
            $list['info@zenkiren.net'] = array('name' => '全機連事務局');
        }
        
        //// 非送信リスト ////
        if (($mailIgnore = mb_convert_encoding(file_get_contents(APP_PATH . Mail::MAIL_IGNORE_FILE), 'utf-8', 'sjis-win')) !== FALSE) {
            foreach(explode("\n", $mailIgnore) as $i) {
                $im = trim($i);
                if (!empty($im)) { unset($list[$im]); }
            }
        }
        
        if (empty($list)) { throw new Exception('送信先が取得できませんでした'); }
        
        $list['info@zenkiren.net'] = array('name' => '全機連事務局');
        return $list;
    }
    
    /**
     * 一括送信メール情報をセット、メールを送信
     * 
     * @access public
     * @param array $data 入力データ
     * @param array $file 添付ファイルデータ
     * @return $this
     */             
    public function sendGroup($data, $file=null)
    {
        // 一覧の取得
        $res = $this->getSendList($data['target'], $data['val']);
        
        foreach($res as $mail => $r) {
            $body = $r['name'] . " 様\n\n" . $data['message'] . "\n\n全機連事務局";
            
            $this->_mailsend->sendMail($mail, null, $body, $data['subject'], $file);
        }
        
        // メール送信ログ保存
        $q = array(
            'subject'    => $data['subject'],
            'message'    => $data['message'],
            'target'     => $data['target'],
            'val'        => $data['val'],
            'val_label'  => $data['val_label'],
            'file'       => $file['name'],
            'send_count' => count($res),
        );
        $this->set($q);
        
        return $this;
    }
    
    /**
     * カタログリクエスト一括メール送信
     * 
     * @access public
     * @param array $data 入力データ
     * @return $this
     */             
    public function sendCatalogReq($data)
    {
        // 送信先の一覧の取得
        $res = array();
        $res = $this->getSendList('group_id', null);
        // $res['bata44883@gmail.com'] = array('name' => 'テスト株式会社');
        // $res['ba_ta44883@yahoo.co.jp'] = array('name' => 'test送信');
        
        // 内容
        $subject = 'カタログを探しています';
        $message = <<< EOS
日頃は全機連マシンライフにご協力頂きありがとうございます。
今回全機連会員の方が下記のカタログを探しておられます。
-------------------------------
メーカー : {$data['maker']}
型式     : {$data['model']}

{$data['comment']}
-------------------------------

カタログをお持ちの方は、お手数ですが下記までご連絡頂くようにお願い致します。
以上、宜しくお願い致します。

全日本機械業連合会 マシンライフ委員会 事務局（機械団地事務局内）
jimukyoku@zenkiren.net
TEL : 06-6747-7521
FAX : 06-6747-7525


全日本機械業連合会 マシンライフ
http://www.zenkiren.net/
EOS;
            
        foreach($res as $mail => $r) {
            $body = $r['name'] . " 様\n\n" . $message;
            $this->_mailsend->sendMail($mail, null, $body, $subject);
        }
        
        // リクエスト送信ログ保存
        $q = array(
            'target'     => $data['target'],
            'maker'      => $data['maker'],
            'model'      => $data['model'],
            'comment'    => $data['comment'],
            'user_id'    => $data['user_id'],
            'send_count' => count($res),
        );
        $this->_db->insert('catalog_requests', $q);
        
        return $this;
    }
    
    /**
     * カタログリクエストログ一覧を取得
     *
     * @access public
     * @return array カタログリクエストログ一覧
     */
    public function getCatalogRequestList()
    {
        // SQLクエリを作成
        $sql = "SELECT
          r.*, 
          u.user_name, 
          c.company 
        FROM
          catalog_requests r 
          LEFT JOIN users u 
            ON r.user_id = u.id 
          LEFT JOIN companies c 
            ON u.company_id = c.id 
        ORDER BY
          r.created_at DESC;";
        $result = $this->_db->fetchAll($sql);
        return $result;
    }
    
    /**
     * 一括送信メールログ保存
     * 
     * @access public     
     * @param string $data 内容   
     * @return $this
     */
    public function set($data)
    {
        // フィルタリング・バリデーション
        $data = MyFilter::filter($data, $this->_filter);
        
        //// お問い合わせ内容の保存 ////
        if (!$result = $this->insert($data)) {
            throw new Exception('一括送信メールログが保存できませんでした');
        }
        
        return $this;
    }
    
    /**
     * お知らせを論理削除
     *
     * @access public
     * @param  array $id お知らせID配列
     * @return $this
     */
    public function deleteById($id) {
        if (empty($id)) {
            throw new Exception('削除するお知らせIDが設定されていません');
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

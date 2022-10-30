<?php
/**
 * お問い合せモデルクラス
 *
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2012/04/13
 */
class Contact extends Zend_Db_Table_Abstract
{
    protected $_name = 'contacts';
    protected $_mailsend;

    function __construct()
    {
        //// メールサーバ設定 ////
        $conf = new Zend_Config_Ini(APP_PATH . '/config/mailsend.ini');
        $this->_mailConf = $conf->conf->toArray();

        //// メール送信クラス ////
        $this->_mailsend = new Mailsend();

        parent::__construct();
    }

    // フィルタ条件
    protected $_filters = array('rules' => array(
        // 'お名前'           => array('fields' => 'user_name',     'NotEmpty'),
        // '会社名'           => array('fields' => 'user_company',),
        '会社名'           => array('fields' => 'user_company', 'NotEmpty'),
        '担当者名'         => array('fields' => 'user_name'),

        'TEL'              => array('fields' => 'tel',),
        'FAX'              => array('fields' => 'fax',),

        // 'メールアドレス'   => array('fields' => 'mail',          'NotEmpty', 'EmailAddress'),
        'メールアドレス'   => array('fields' => 'mail',          'NotEmpty'),
        '都道府県'         => array('fields' => 'addr1',),
        'お問い合わせ内容' => array('fields' => 'message',       'NotEmpty'),
        'お知らせメール'   => array('fields' => 'mailuser_flag',),

        '連絡方法'         => array('fields' => 'return',),
        '時間帯'           => array('fields' => 'return_time',),

        '機械ID'           => array('fields' => 'machine_id', 'Int'),
        '会社ID'           => array('fields' => 'company_id', 'Int'),
        'ユーザID'         => array('fields' => 'user_id',    'Int'),
    ));

    /**
     * お問い合わせ一覧を取得
     *
     * @access public
     * @param  integer $companyId 会社ID
     * @param  string  $month     登録月
     * @param  array   $q         その他検索クエリ
     * @return array   お問い合わせ一覧
     */
    public function getList($companyId=NULL, $month=NULL, $q=array())
    {
        $where = ' c.created_at IS NOT NULL ';
        if (empty($companyId)) {
            $where.= ' AND c.company_id IS NULL ';
        } else if ($companyId == 'ALL') {
            $where.= '';
        } else {
            $where.= $this->_db->quoteInto(' AND c.company_id = ? ', $companyId);
        }

        if (empty($month) || $month == 'now') {
            $where.= $this->_db->quoteInto(' AND CAST(c.created_at as DATE) >= ?', date('Y-m-d', strtotime('- 1month')));
            $where.= $this->_db->quoteInto(' AND CAST(c.created_at as DATE) <= ?', date('Y-m-d'));
        } else if ($month == 'ALL') {
            $where.= '';
        } else {
            $where.= $this->_db->quoteInto(' AND CAST(c.created_at as DATE) >= ?', date('Y-m-01', strtotime($month)));
            $where.= $this->_db->quoteInto(' AND CAST(c.created_at as DATE) <= ?', date('Y-m-t', strtotime($month)));
        }

        // メッセージ内容(タグ)から取得
        if (!empty($q['message'])) {
            $where.= $this->_db->quoteInto(' AND c.message LIKE ? ', '%' . $q['message'] . '%');
        }

        if (!empty($q['order_by']) && $q['order_by'] == 'ASC') {
            $orderBy = ' c.created_at ASC, c.id ASC ';
        } else {
            $orderBy = ' c.created_at DESC, c.id DESC ';
        }

        // SQLクエリを作成
        $sql = "SELECT
          c.*,
          m.name,
          m.maker,
          m.model,
          m.year,
          m.no,
          co.company
        FROM
          contacts c
          LEFT JOIN
            machines m ON c.machine_id = m.id
          LEFT JOIN
            companies co ON co.id = c.company_id
        WHERE
          {$where}
        ORDER BY
          {$orderBy};";
        $result = $this->_db->fetchAll($sql);
        if (empty($result)) {
            throw new Exception('お問い合わせ情報を取得できませんでした');
        }

        return $result;
    }


    /**
     * お問い合わせチェックユーザ一覧
     *
     * @access public
     * @return array   お問い合わせユーザ一覧
     */
    public function getMailuserList()
    {
        // SQLクエリを作成
        $sql = "SELECT DISTINCT ON (c.mail)
          c.mail,
          c.user_company,
          c.user_name
        FROM
          contacts c
        WHERE
          c.mailuser_flag = 1
        ORDER BY
          c.mail;";
        $result = $this->_db->fetchAll($sql);

        if (empty($result)) {
            throw new Exception('お問い合わせユーザ情報を取得できませんでした');
        }

        return $result;
    }

    /**
     * お問い合わせメールアドレスリスト(トップ大ジャンル)一覧
     *
     * @access public
     * @return array   問い合わせメールアドレスリスト一覧
     */
    public function getContactMailList()
    {
        // SQLクエリを作成
        $sql = "SELECT
            mail,
            user_company,
            user_name,
            xl_genre_id
        FROM
            (
            SELECT
                c.mail,
                c.user_company,
                c.user_name,
                vm.xl_genre_id,
                ROW_NUMBER() OVER(
                PARTITION BY c.mail
                ORDER BY
                count(*) DESC
                ) AS rno
            FROM
                contacts c
            LEFT JOIN view_machines vm
        ON
                vm.id = c.machine_id
            WHERE
                c.machine_id IS NOT NULL
                AND c.mailuser_flag IS NOT NULL
                AND c.mailuser_flag = 1
            GROUP BY
                c.mail,
                c.user_company,
                c.user_name,
                xl_genre_id
            ) tbl
        WHERE
            rno = 1
            AND xl_genre_id IS NOT NULL
        ORDER BY
            mail;";
        $result = $this->_db->fetchAll($sql);

        if (empty($result)) {
            throw new Exception('お問い合わせメールリストを取得できませんでした');
        }

        return $result;
    }

    /**
     * お問い合わせログ集計表を取得
     *
     * @access public
     * @param  integer $companyId 会社ID
     * @return array   お問い合わせ一覧
     */
    public function getSS($companyId=NULL, $month=NULL)
    {
        $where = ' (user_id <> 1 OR user_id IS NULL)  '; // テスト用データを除外
        if (!empty($companyId)) {
            $where.= $this->_db->quoteInto(' AND c.company_id = ? ', $companyId);
        }

        if (empty($month)) {
            $start    = '2013-01-01';
            $end      = date('Y-m-d');
            $rate     = 'YYYY/MM';
            $interval = '1 month';
        } else {
            if ($month == 'now') {
                $start = date('Y-m-01');
                $end   = date('Y-m-d');
            } else {
                $start = date('Y-m-01', strtotime($month));
                $end   = date('Y-m-t', strtotime($month));
            }
            $rate    = 'YYYY/MM/DD';
            $interval = '1 day';
        }

        if ($start == '1970-01-01') {
            throw new Exception('月指定が間違っています');
        }

        // SQLクエリを作成
        $sql = "SELECT
          to_char(a, ?) AS MONTH,
          COALESCE(c.zenkiren, 0) AS zenkiren,
          COALESCE(c.company, 0) AS company,
          COALESCE(c.machine, 0) AS machine,
          COALESCE(c.total, 0) AS total,
          COALESCE(ac.machine_detail, 0) AS detail,
          COALESCE(ac.bid_detail, 0) AS bid_detail,
          COALESCE(ac.admin_bid_detail, 0) AS admin_bid_detail,
          COALESCE(ac.pdf, 0) AS pdf
        FROM
          generate_series(?, ?, INTERVAL '{$interval}') AS a
          LEFT JOIN (
            SELECT
              to_char(created_at, ?) AS MONTH,
              sum(CASE WHEN company_id IS NULL THEN 1 ELSE 0 END) zenkiren,
              sum(
                CASE
                  WHEN machine_id IS NULL AND
                  company_id IS NOT NULL
                  THEN 1
                  ELSE 0
                  END
              ) company,
              sum(CASE WHEN machine_id IS NOT NULL THEN 1 ELSE 0 END) machine,
              count(*) AS total
            FROM
              contacts
            WHERE
              {$where}
            GROUP BY
              MONTH
          ) c
            ON c.MONTH = to_char(a.a, ?)
          LEFT JOIN (
            SELECT
              to_char(created_at, ?) AS MONTH,
              -- count(*) AS detail
              sum(CASE WHEN action = 'machine_detail' THEN 1 ELSE 0 END) machine_detail,
              sum(CASE WHEN action = 'bid_detail' THEN 1 ELSE 0 END) bid_detail,
              sum(CASE WHEN action = 'admin_bid_detail' THEN 1 ELSE 0 END) admin_bid_detail,
              sum(CASE WHEN action = 'PDF' THEN 1 ELSE 0 END) pdf
            FROM
              actionlogs
            WHERE
              -- target = 'machine' AND
              -- action = 'machine_detail' AND
              hostname NOT LIKE '%google%' AND
              hostname NOT LIKE '%yahoo%' AND
              hostname NOT LIKE '%naver%' AND
              hostname NOT LIKE '%ahrefs%' AND
              hostname NOT LIKE '%msnbot%' AND
              {$where}
            GROUP BY
              MONTH
          ) ac
            ON ac.MONTH = to_char(a.a, ?)
        ORDER BY
          MONTH DESC;";

        $result = $this->_db->fetchAll($sql, array($rate, $start, $end, $rate, $rate, $rate, $rate));
        if (empty($result)) {
            throw new Exception('お問い合わせログ集計表を取得できませんでした');
        }
        return $result;
    }

    /**
     * 中古機械情報ページの問い合わせをセット、通知メールを送信
     *
     * @access public
     * @param  array $data 入力データ
     * @return $this
     */
    public function sendMachine($data)
    {
        // メールブラックリスト
        if ($data['mail'] == '07.05.15.oga@gmail.com') { return $this; }

        //// お問い合せ内容の整理 ////
        $d = array(
            'user_name'     => $data['name'],
            'user_company'  => $data['company'],
            'mail'          => $data['mail'],
            'tel'           => $data['tel'],
            'fax'           => $data['fax'],
            'return_time'   => $data['ret'],
            'message'       => $data['message'],
            'user_id'       => $data['user_id'],
            'addr1'         => $data['addr1'],
            'mailuser_flag' => $data['mailuser_flag'],
        );

        // お問い合わせ先
        $targets = '';

        if (!empty($data['machineId'])) {
            // 対象が在庫機械の場合
            $where = $this->_db->quoteInto('m.id IN (?)', $data['machineId']);
            $sql = 'SELECT m.*, c.company, c.contact_mail FROM machines m LEFT JOIN companies c ON m.company_id = c.id WHERE ' . $where;

            $machineList = $this->_db->fetchAll($sql);
            if (empty($machineList)) {
                throw new Exception('お問い合わせ先の機械情報を取得できませんでした');
            }

            foreach($machineList as $m) {
                // 送信内容
                $body = <<< EOS
{$m['company']} 様

マシンライフのお問い合せフォームから、
在庫機械についてのお問い合わせがありました。

＜お客様情報＞
会社名 : {$data['company']}
担当者名 : {$data['name']}
都道府県 : {$data['addr1']}
メールアドレス : {$data['mail']}
TEL : {$data['tel']}
FAX : {$data['fax']}
{$data['ret']}

＜お問い合わせ機械＞
管理番号 : {$m['no']}
{$m['name']} {$m['maker']} {$m['model']}
http://www.zenkiren.net/machine_detail.php?m={$m['id']}

＜お問い合わせ内容＞
{$data['message']}


マシンライフ｜全機連の中古機械情報サイト
http://www.zenkiren.net/
EOS;
                $subject = 'マシンライフ:中古機械についてのお問い合せ通知';

                //// メール送信・お問い合わせ内容の保存 ////
                $this->_mailsend->sendMail($m['contact_mail'], $data['mail'], $body, $subject);
                $this->set($d + array('machine_id' => $m['id'], 'company_id' => $m['company_id']));

                $targets.= "{$m['no']} {$m['name']} {$m['maker']} {$m['model']} → {$m['company']}\n";
            }
        } else if (!empty($data['bidMachineId'])) {
            // 対象がWeb入札会一括問い合わせの場合
            $bmModel = new BidMachine();
            $bidMachineList = $bmModel->getList(array('bid_open_id' => $data['bidOpenId'], 'id' => $data['bidMachineId']));

            //// 入札会情報を取得 ////
            $boModel = new BidOpen();
            $bidOpen = $boModel->get($data['bidOpenId']);

            if (empty($bidMachineList)) {
                throw new Exception('お問い合わせ先のWeb入札会商品情報を取得できませんでした');
            }

            $_bidBatchLog =& $_SESSION['bid_batch_log'];
            $tlModel = new TrackingLog();

            foreach($bidMachineList as $m) {
                // 送信内容
                $body = <<< EOS
{$m['company']} 様

マシンライフのお問い合せフォームから、
{$bidOpen['title']} 出品商品についてのお問い合わせがありました。

＜お客様情報＞
会社名 : {$data['company']}
担当者名 : {$data['name']}
都道府県 : {$data['addr1']}
メールアドレス : {$data['mail']}
TEL : {$data['tel']}
FAX : {$data['fax']}
{$data['ret']}

＜お問い合わせ商品＞
◆出品番号:{$m['list_no']} {$m['name']} {$m['maker']} {$m['model']}

＜お問い合わせ内容＞
{$data['message']}


マシンライフ｜全機連の中古機械情報サイト
http://www.zenkiren.net/
EOS;
                $subject = "マシンライフ:{$bidOpen['title']} 出品商品についてのお問い合せ通知";

                //// メール送信・お問い合わせ内容の保存 ////
                $this->_mailsend->sendMail($m['contact_mail'], $data['mail'], $body, $subject);
                $d['message'] = "◆出品番号:{$m['list_no']} {$m['name']} {$m['maker']} {$m['model']}\n\n" . $data['message'];
                $this->set($d + array('machine_id' => NULL, 'company_id' => $m['company_id']));

                $targets.= "◆出品番号:{$m['list_no']} {$m['name']} {$m['maker']} {$m['model']} → {$m['company']}\n";

                // 一括問い合わせログ
                $_bidBatchLog[$m['id']] = date('Y/m/d H:i');

                // トラッキングログ
                $tlModel->set(array(
                    "bid_open_id"     => $bidOpen["id"],
                    "bid_machine_ids" => $m["id"],
                    "contact_id"      => $this->_db->fetchOne("SELECT max(id) FROM contacts;"),
                ));
            }

             $_SESSION['bid_batch'] = [];
        } else if (!empty($data['companyId'])) {
            // 対象が会社
            $where = $this->_db->quoteInto('c.id IN (?)', $data['companyId']);
            $sql = 'SELECT * FROM companies c WHERE ' . $where;

            $companyList = $this->_db->fetchAll($sql);
            if (empty($companyList)) {
                throw new Exception('お問い合わせ先の会社情報を取得できませんでした');
            }

            foreach($companyList as $c) {
                // 送信内容
                $body = <<< EOS
{$c['company']} 様

マシンライフのお問い合せフォームから、
お問い合わせがありました。

＜お客様情報＞
会社名 : {$data['company']}
担当者名 : {$data['name']}
都道府県 : {$data['addr1']}
メールアドレス : {$data['mail']}
TEL : {$data['tel']}
FAX : {$data['fax']}
{$data['ret']}

＜お問い合わせ内容＞
{$data['message']}


マシンライフ｜全機連の中古機械情報サイト
http://www.zenkiren.net/
EOS;
                $subject = 'マシンライフ:お問い合せ通知';

                //// メール送信・お問い合わせ内容の保存 ////
                $this->_mailsend->sendMail($c['contact_mail'], $data['mail'], $body, $subject);
                $this->set($d + array('machine_id' => NULL, 'company_id' => $c['id']));

                $targets.= "{$c['company']}\n";

                // トラッキングログ(Web入札会用)
                if (preg_match('/\/bid_detail.php\?m\=([0-9]+)/', $data['message'], $matches)) {
                    $bmModel    = new BidMachine();
                    $bidMachine = $bmModel->get($matches[1]);

                    $tlModel = new TrackingLog();
                    $tlModel->set(array(
                        "bid_open_id"     => $bidMachine["bid_open_id"],
                        "bid_machine_ids" => $bidMachine["id"],
                        "contact_id"      => $this->_db->fetchOne("SELECT max(id) FROM contacts;"),
                    ));
                }

            }
        } else {
            // 対象が全機連事務局

            // 送信内容
            $body = <<< EOS
マシンライフのお問い合せフォームから、
お問い合わせがありました。

＜お客様情報＞
会社名 : {$data['company']}
担当者名 : {$data['name']}
都道府県 : {$data['addr1']}
メールアドレス : {$data['mail']}
TEL : {$data['tel']}
FAX : {$data['fax']}
{$data['ret']}

＜お問い合わせ内容＞
{$data['message']}


マシンライフ｜全機連の中古機械情報サイト
http://www.zenkiren.net/
EOS;
            $subject = 'マシンライフ:全機連についてのお問い合せ通知';

            //// メール送信・お問い合わせ内容の保存 ////
            $this->_mailsend->sendMail($this->_mailConf['from_mail'], $data['mail'], $body, $subject);
            $this->set($d);

            $targets.= "全機連事務局\n";
        }

        //// お問い合わせ確認メール ////
        // 送信内容
        $body = <<< EOS
※ このメールは、自動返信メールです。
このメールに直接返信しないようお願いします。

{$data['name']}様

マシンライフのお問い合せフォームから、
お問い合わせありがとうございました。

お問い合わせ先に、お問い合わせメールを送信しましたので、
回答をしばらくお待ちください。

＜お問い合わせ先＞
{$targets}

＜お問い合わせ内容＞
{$data['message']}

＜お客様情報＞
会社名 : {$data['company']}
担当者名 : {$data['name']}
都道府県 : {$data['addr1']}
メールアドレス : {$data['mail']}
TEL : {$data['tel']}
FAX : {$data['fax']}
{$data['ret']}


マシンライフ｜全機連の中古機械情報サイト
http://www.zenkiren.net/
EOS;
        $subject = 'マシンライフ:お問い合せ送信確認';
        $this->_mailsend->sendMail($data['mail'], $this->_mailConf['from_mail'], $body, $subject);

        return $this;
    }

    /**
     * お問い合わせデータ保存
     *
     * @access public
     * @param  string $data 内容
     * @return $this
     */
    public function set($data)
    {
        // フィルタリング・バリデーション
        $data = MyFilter::filtering($data, $this->_filters);

        // メールブラックリスト
        if ($data['mail'] == '07.05.15.oga@gmail.com') { return $this; }

        /// お問い合わせ内容の保存 ///
        if (!$result = $this->insert($data)) {
            throw new Exception('お問い合わせ情報が保存できませんでした');
        }

        /// Mailchimpリスト登録 ///
        if ($data["mailuser_flag"] == 1) {
            $fModel      = new Flyer();
            $json = array(
                "email_address" => $data["mail"],
                "status"        => "subscribed",
                "merge_fields"  => array(
                    "FNAME" => $data["user_name"],
                    "LNAME" => $data["user_company"],
                ),
            );
            $_mconf = new Zend_Config_Ini(APP_PATH . '/config/mailchimp.ini');

            $res = $fModel->doAPI('lists/' . $_mconf->mailchimp_list_id . '/members/' . md5($data["mail"]), 'PUT', $json, $_mconf);
        }

        return $this;
    }


    /**
     * 問い合わせをセット、通知メールを送信
     *
     * @access public
     * @param  array $data 入力データ
     * @param  int   $id 会社ID
     * @return $this
     */
    public function send($data)
    {
        //// お問い合せ内容の整理 ////
        $d = array(
            'user_name'     => $data['user_name'],
            'user_company'  => $data['company'],
            'mail'          => $data['mail'],
            'tel'           => $data['tel'],
            'fax'           => $data['fax'],
            'return_time'   => '',
            'message'       => $data['message'],
            'user_id'       => null,
            'addr1'         => $data['addr1'],
            'mailuser_flag' => 0,
        );

        // お問い合わせ先
        $targets = '';

        //// 通知メール送信内容 ////
        $body = <<< EOS
全機連ウェブサイトのお問い合せフォームから、
お問い合わせがありました。

＜お客様情報＞
担当者名 : {$data['user_name']}
メールアドレス : {$data['mail']}
TEL : {$data['tel']}
FAX : {$data['fax']}

＜お問い合わせ内容＞
{$data['message']}


全日本機械業連合会
http://www.zenkiren.org/
EOS;
        $subject = '全機連ウェブサイト:お問い合せ通知';

        //// メール送信・お問い合わせ内容の保存 ////
        $this->_mailsend->sendMail($this->_mailConf['from_mail'], $data['mail'], $body, $subject);
        $this->set($d);

        //// お問い合わせ確認メール ////
        // 送信内容
        $body = <<< EOS
{$data['user_name']}様

全機連ウェブサイトの問い合せフォームから、
お問い合わせありがとうございました。

全機連事務局に、お問い合わせメールを送信しましたので、
回答をしばらくお待ちください。

＜お問い合わせ内容＞
{$data['message']}

＜お客様情報＞
担当者名 : {$data['user_name']}
メールアドレス : {$data['mail']}
TEL : {$data['tel']}
FAX : {$data['fax']}


全日本機械業連合会
http://www.zenkiren.org/
EOS;
        $subject = '全機連ウェブサイト:お問い合せ送信確認';
        $this->_mailsend->sendMail($data['mail'], $this->_mailConf['from_mail'], $body, $subject);

        return $this;
    }
}

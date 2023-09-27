<?php

/**
 * ミニブログモデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/26
 */
class Miniblog extends Zend_Db_Table
{
    protected $_name = 'miniblogs';

    // フィルタ条件
    protected $_filter = array('rules' => array(
        '*'          => array(),
        'ユーザ情報' => array('fields' => 'user_id', 'NotEmpty', 'Int'),
        '対象'       => array('fields' => 'target', 'NotEmpty'),
        '内容'       => array('fields' => 'contents', 'NotEmpty')
    ));

    /**
     * お知らせ一覧を取得
     *
     * @access public
     * @return array メーカー名一覧
     */
    public function getList($t = NULL, $l = NULL)
    {
        $target = '';
        $limit  = '';

        if (!empty($t)) {
            $target = $this->_db->quoteInto(' AND target = ? ', $t);
        }

        if (!empty($l)) {
            $limit = $this->_db->quoteInto(' LIMIT ? ', $l);
        }

        // SQLクエリを作成
        $sql = "SELECT
          m.*,
          u.user_name
        FROM
          miniblogs m
          LEFT JOIN users u
            ON m.user_id = u.id
        WHERE
          m.deleted_at IS NULL
          {$target}
        ORDER BY
          m.created_at DESC
        {$limit};";
        $result = $this->_db->fetchAll($sql);
        return $result;
    }

    /**
     * お知らせを登録
     *
     * @access public
     * @return array メーカー名一覧
     */
    public function set($user_id, $target, $contents)
    {
        $data = array(
            'user_id'  => $user_id,
            'target'   => $target,
            'contents' => $contents
        );

        // フィルタリング・バリデーション
        $data = MyFilter::filter($data, $this->_filter);

        // $this->_db->insert('miniblogs', $data);
        $this->_db->insert($this->_name, $data);

        // 20180125@ba-ta メール通知
        $mailsend = new Mailsend();
        $uModel   = new User();
        $user     = $uModel->get($data['user_id']);
        $now      = date('Y/m/d H:i:s');

        /// 通知メール送信内容 ///
        $body = <<< EOS
マシンライフに書きこみがありました。

書き込み場所 : {$data['target']}
書き込みユーザ : {$user['user_name']}
書き込み時間 : {$now}

＜内容＞
{$data['contents']}


全日本機械業連合会
http://www.zenkiren.org/
EOS;
        $subject = 'マシンライフ:書き込み通知';

        /// メール送信 ///
        $sends = array("bata44883@gmail.com", "kazuyoshih@gmail.com", "jimukyoku@zenkiren.net");
        foreach ($sends as $to) {
            $mailsend->sendMail($to, null, $body, $subject);
        }

        return $this;
    }
}

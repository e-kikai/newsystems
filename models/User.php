<?php

/**
 * ユーザ情報モデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
class User extends Zend_Db_Table_Abstract
{
    protected $_name = 'users';

    // フィルタ条件
    protected $_changeFilter = array('rules' => array(
        'ユーザ名'   => array('fields' => 'user_name', 'NotEmpty'),
        '会社ID'     => array('fields' => 'company_id', 'Digits'),
        '権限'       => array('fields' => 'role', 'NotEmpty'),
        'アカウント' => array('fields' => 'account', 'NotEmpty'),
        // 'パスワード' => array('fields' => 'passwd', 'NotEmpty'),
        'パスワード' => array('fields' => 'passwd',),
    ));

    protected $_passwdFilter = array('rules' => array(
        'パスワード' => array('fields' => 'passwd', 'NotEmpty'),
    ));

    /**
     * ユーザ一覧を取得
     *
     * @access public
     * @param  array $q 検索クエリ
     * @return array ユーザ一覧
     */
    public function getList($q = NULL)
    {
        $where = '';
        if (!empty($q['id'])) {
            $where .= ' AND' . $this->_db->quoteInto(' u.id IN (?) ', $q['id']);
        }

        if (!empty($q['group_id'])) {
            $where .= ' AND' . $this->_db->quoteInto(' c.group_id IN (?) ', $q['group_id']);
        }

        // SQLクエリを作成
        $sql = "SELECT
          u.*,
          c.company,
          c.group_id
        FROM
          users u
          LEFT JOIN companies c
            ON c.id = u.company_id
        WHERE
          u.deleted_at IS NULL
          {$where}
        ORDER BY
          c.group_id,
          c.company_kana,
          u.company_id,
          u.id;";
        $result = $this->_db->fetchAll($sql);
        if (empty($result)) {
            throw new Exception('ユーザ情報を取得できませんでした');
        }

        return $result;
    }

    /**
     * ユーザ情報を取得
     *
     * @access public
     * @param  string  $id   メンバーID
     * @return array メンバ情報を取得
     */
    public function get($id)
    {
        //// メンバ情報を取得 ////
        if (!intval($id)) {
            throw new Exception('取得するユーザIDがありません');
        }

        // SQLクエリを作成
        $sql = "SELECT u.* FROM users u WHERE u.deleted_at IS NULL AND id = ? LIMIT 1;";
        $result = $this->_db->fetchRow($sql, $id);
        if (empty($result)) {
            throw new Exception('ユーザ情報を取得できませんでした');
        }

        return $result;
    }

    /**
     * ユーザ情報をセット
     *
     * @access public
     * @param array $data 入力データ
     * @param int $id ユーザID(新規登録の場合はnull)
     * @return $this
     */
    public function set($data, $id = null)
    {
        // フィルタリング・バリデーション
        $data = MyFilter::filter($data, $this->_changeFilter);

        if (empty($id)) {
            // 新規処理
            if (empty($data['passwd'])) {
                throw new Exception('パスワードが入力されていません');
            }
            $res = $this->insert($data);
        } else {
            // 更新処理
            if (empty($data['passwd'])) {
                unset($data['passwd']);
            }
            $data['changed_at'] = new Zend_Db_Expr('current_timestamp');
            $res = $this->update($data, $this->_db->quoteInto('id = ?', $id));
        }

        if (empty($res)) {
            throw new Exception('ユーザ情報が保存できませんでした');
        }

        return $this;
    }

    /**
     * ユーザ情報を論理削除
     *
     * @access public
     * @param  array $id ユーザID
     * @return $this
     */
    public function deleteById($id)
    {
        if (empty($id)) {
            throw new Exception('削除するユーザIDが設定されていません');
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

<?php
/**
 * 仮登録ユーザモデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2014/01/16
 */
class Preuser extends Zend_Db_Table_Abstract
{
    protected $_name = 'preusers';
    protected $_primary = 'preuser_id';

    // フィルタ条件
    protected $_filter = array('rules' => array(
        // 'メールアドレス' => array('fields' => 'mail', 'EmailAddress', 'NotEmpty', ),
        'メールアドレス' => array('fields' => 'mail', 'NotEmpty', ),
        '会社名、氏名' => array('fields' => 'user_name',),
    ));

    /**
     * 仮ユーザ一覧を取得
     *
     * @access public
     * @return array 仮ユーザ一覧
     */
    public function getList($q=array())
    {
        /*
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
        */

        // SQLクエリを作成
        $sql = "SELECT u.* FROM preusers u WHERE u.deleted_at IS NULL ORDER BY u.created_at ASC, u.preuser_id ASC;";
        $result = $this->_db->fetchAll($sql);
        if (empty($result)) {
            throw new Exception('仮ユーザ情報を取得できませんでした');
        }

        return $result;
    }

    /**
     * 仮ユーザ保存
     *
     * @access public
     * @param array $data 内容
     * @param integer $id 仮ユーザID
     * @return $this
     */
    public function set($data, $id=NULL)
    {
        // フィルタリング・バリデーション
        $data = MyFilter::filter($data, $this->_filter);

        //// 仮ユーザの保存 ////
        if (empty($id)) {
            // 新規処理
            $res = $this->insert($data);
        } else {
            // 更新処理
            $data['changed_at'] = new Zend_Db_Expr('current_timestamp');
            $res = $this->update($data, array(
                $this->_db->quoteInto('preuser_id = ?', $id)
            ));
        }

        if (empty($res)) {
            throw new Exception("ユーザ情報が保存できませんでした id:{$id}");
        }

        return $this;
    }

    /**
     * 仮ユーザ論理削除
     *
     * @access public
     * @param  array $id 仮ユーザID配列
     * @return $this
     */
    public function deleteById($id) {
        if (empty($id)) {
            throw new Exception('削除する仮ユーザIDが設定されていません');
        }

        $this->update(
            array('deleted_at' => new Zend_Db_Expr('current_timestamp')),
            array($this->_db->quoteInto(' preuser_id IN(?) ', $id))
        );

        return $this;
    }
}

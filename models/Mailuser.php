<?php
/**
 * mailuserテーブルモデルクラス
 *
 */
require_once 'Zend/Db/Table.php';
class Mailuser extends Zend_Db_Table_Abstract
{
    protected $_name = 'mailusers';
    
    /**
     * 配信開始処理
     *
     * @access public
     * @param  string $mail 配信開始メールアドレス
     * @return $this
     */
    public function send($mail)
    {
        $result = $this->_db->fetchAll("SELECT id FROM mailusers m WHERE m.mail = ? AND m.deleted_at IS NULL;", B::filter($mail));
        if (empty($result)) {
            $result = $this->insert(array('mail' => B::filter($mail)));
        }
        return $this;
    }
    
    /**
     * 配信停止処理
     *
     * @access public
     * @param  string $mail 配信停止メールアドレス
     * @return $this
     */
    public function unsend($mail)
    {
        $this->update(
            array('deleted_at' => new Zend_Db_Expr('current_timestamp')),
            array(
                'deleted_at IS NULL ',
                $this->_db->quoteInto(' mail = ? ', B::filter($mail)),
            )
        );
        return $this;
    }
    
    /**
     * メール送信ユーザ一覧を取得する
     *
     * @access public
     * @return array メール送信ユーザ一覧
     */
    public function getList()
    {
        //// 入札会情報を取得 ////
        $sql = "SELECT * FROM mailusers m WHERE m.deleted_at IS NULL ORDER BY created_at DESC;";
        $result = $this->_db->fetchAll($sql);
        
        return $result;
    }
}

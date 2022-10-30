<?php
/**
 * 大宝機械サイトお知らせモデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/17
 */
class DInfo extends Zend_Db_Table
{
    protected $_name = 'd_infos';

    // フィルタ条件
    protected $_filter = array('rules' => array(
        '*'        => array(),
        '会社ID'   => array('fields' => 'company_id', 'NotEmpty'),
        '日付'     => array('fields' => 'info_date', 'NotEmpty'),
        'タイトル' => array('fields' => 'title', 'NotEmpty'),
        '内容'     => array('fields' => 'contents', 'NotEmpty'),
    ));

    private $_targets = array('member', 'machine', 'catalog');

    /**
     * お知らせ一覧を取得
     *
     * @access public
     * @param  string  $t  対象
     * @param  integer $g  対象団体ID
     * @param  integer $l  取得数
     * @param  boolean $ti 時限表示
     * @return array   お知らせ一覧
     */
    public function getList($company_id, $l=NULL)
    {
        $limit   = !empty($l) ? $this->_db->quoteInto(' LIMIT ? ', $l) : '';
        $company = !empty($company_id) ? $this->_db->quoteInto(' AND company_id = ? ', $company_id) : '';

        // SQLクエリを作成
        $sql = "SELECT DISTINCT
          i.*
        FROM
          d_infos i
        WHERE
          i.deleted_at IS NULL
          {$company}
        ORDER BY
          i.info_date DESC,
          i.created_at DESC
        {$limit};";

        $result = $this->_db->fetchAll($sql);
        return $result;
    }

    /**
     * お知らせ情報を取得
     *
     * @access public
     * @param  integer $id お知らせID
     * @return array お知らせ情報を取得
     */
    public function get($companyId, $id) {
        if (empty($id)) {
            throw new Exception('お知らせIDが設定されていません');
        }

        // SQLクエリを作成
        $sql = "SELECT * FROM d_infos WHERE deleted_at IS NULL AND company_id = ? AND id = ? LIMIT 1;";
        $result = $this->_db->fetchRow($sql, [$companyId, $id]);

        return $result;
    }

    /**
     * お知らせ情報をセット
     *
     * @access public
     * @param  array $id ID
     * @param array $data 入力データ
     * @return $this
     */
    public function set($companyId, $id=NULL, $data)
    {
        // フィルタリング・バリデーション
        $data = MyFilter::filter($data, $this->_filter);

        if (empty($id)) {
            // 新規処理
            $res = $this->insert($data);
        } else {
            // 更新処理
            $data['changed_at'] = new Zend_Db_Expr('current_timestamp');
            $res = $this->update($data, array(
                $this->_db->quoteInto('id = ?', $id)
            ));
        }

        if (empty($res)) {
            throw new Exception("お知らせ情報が保存できませんでした id:{$id}");
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
    public function deleteById($companyId, $id) {
        if (empty($id)) {
            throw new Exception('削除するお知らせIDが設定されていません');
        }

        $this->update(
            array('deleted_at' => new Zend_Db_Expr('current_timestamp')),
            array(
                $this->_db->quoteInto(' id IN(?) ', $id),
                $this->_db->quoteInto(' company_id = ? ', $companyId)
            )
        );

        return $this;
    }
}

<?php
/**
 * 画像特徴ベクトル検索リレーションクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2022/05/11
 */
class MachineNitamono extends Zend_Db_Table_Abstract
{
    protected $_name = 'machine_nitamonos';

    // フィルタ条件
    protected $_filter = array(
        'rules' => array(
            '*'      => array(),
            '機械ID' => array('fields' => 'machine_id', 'NotEmpty', 'Int'),
            '対象ID' => array('fields' => 'nitamono_id', 'NotEmpty', 'Int'),
            'ノルム' => array('fields' => 'norm', 'Float')
        )
    );

    /**
     * ベクトル変換用機械一覧を取得
     *
     * @access public
     * @return array ジャンル一覧
     */
    public function getMachineList()
    {
        $sql = <<<SQL
SELECT
  m.id,
  CASE
    WHEN count(mnr.id) > 0 THEN NULL
    ELSE m.top_img
  END AS top_img
FROM
  machines m
LEFT JOIN machine_nitamonos mnr ON
  mnr.machine_id = m.id
WHERE
  m.top_img IS NOT NULL
  AND m.top_img != ''
  AND m.deleted_at IS NULL
GROUP BY
  m.id
ORDER BY
  m.id;
SQL;
        $result = $this->_db->fetchAll($sql);

        return $result;
    }

    /**
     * ノルムを登録
     *
     * @access public
     * @return this
     */
    public function set($data)
    {
        try {
            // フィルタリング・バリデーション
            $data = MyFilter::filter($data, $this->_filter);

            if (empty($data["norm"])) { $data["norm"] = 0; }
            $this->_db->insert($this->_name, $data);

            return $this;
        } catch (Exception $e) {
          error_log(print_r($data, true));
        }
    }

    public function getNitamonoList($machine_id) {
      $sql = <<<SQL
SELECT
  vm.*
FROM
  view_machines vm
INNER JOIN
  machine_nitamonos mnr ON mnr.nitamono_id = vm.id
WHERE
  mnr.machine_id = ?
ORDER BY
  mnr.norm
LIMIT
  16;
SQL;
        $result = $this->_db->fetchAll($sql, $machine_id);

        return $result;
    }
}

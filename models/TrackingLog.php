<?php
/**
 * トラッキングログクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.1.0
 * @since 2016/06/14
 */
class TrackingLog extends MyTable
{
    protected $_name          = 'tracking_logs';
    protected $_primary       = 'id';

    //// 共通設定 ////
    protected $_jname         = 'トラッキングログ';
    // protected $_view          = 'view_companysites';

    /**
     * トラッキングログを挿入
     *
     * @access public
     * @param  array $data 保存ログデータ
     * @return $this
     */
    public function set($data)
    {
        $trackingUserTable = new TrackingUser();
        $trackingUser = $trackingUserTable->checkTrackingTag();
        if (empty($trackingUser)) { return $this; }

        $data += array(
            'tracking_user_id' => $trackingUser['id'],
            'url'              => $_SERVER["REQUEST_URI"],
        );
        parent::set(null, $data);

        return $this;
    }

    public function getRatingList($bidOpenId, $trackingUserIds)
    {
        $trackingUserIdsSql = $this->_db->quoteInto(' tracking_user_id IN (?)', $trackingUserIds);
        $sql = "SELECT
  *,
  EXTRACT(
    EPOCH
    FROM
      (
        lead(created_at) OVER (PARTITION BY tracking_user_id ORDER BY id)
      ) - created_at
  ) AS INTERVAL
FROM
  tracking_logs
WHERE
  bid_open_id = ? AND
  ${trackingUserIdsSql}
  AND tracking_user_id IS NOT NULL
ORDER BY
  tracking_user_id,
  id
;";
        $res = $this->_db->fetchAll($sql, array($bidOpenId));

        return $res;
    }

    public function getRatingCount($bidOpenId)
    {
        $sql = "SELECT count(*)
FROM
  tracking_logs
WHERE
  bid_open_id = ?
  AND tracking_user_id IS NOT NULL
;";
        $res = $this->_db->fetchOne($sql, $bidOpenId);

        return $res;
    }

    public function getRatingTrackingUserIds($bidOpenId)
    {
        $sql = "SELECT DISTINCT tracking_user_id
FROM
  tracking_logs
WHERE
  bid_open_id = ?
  AND tracking_user_id IS NOT NULL
ORDER BY tracking_user_id
;";
        $res = $this->_db->fetchCol($sql, $bidOpenId);

        return $res;
    }
}

<?php
/**
 * ML結果(入札会、ユーザ)クラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.1.0
 * @since 2016/06/22
 */
class TrackingBidResult extends MyTable
{
    protected $_name          = 'tracking_bid_results';
    protected $_primary       = 'id';

    //// 共通設定 ////
    protected $_jname         = 'トラッキング結果(入札会、ユーザ)';

    /**
     * 自社サイト情報を会社IDから取得
     *
     * @access public
     * @param  string  $target   ターゲット
     * @param  integer $targetId ターゲットID
     * @return array   自社サイト情報
     */
    public function getRecommends($bidOpenId, $target, $targetId)
    {
        // // SQLクエリを作成
        // $sql = "SELECT t.* FROM tracking_bid_results t WHERE t.bid_open_id = ? AND t.target = ? AND t.target_id = ? ORDER BY id DESC; ";
        // $result = $this->_db->fetchRow($sql, array($bidOpenId, $target, $targetId));
        //
        // $bidMachineIds = $result['bid_machine_ids'];

        // 取得したレコメンドIDsから入札会商品情報を取得
        $bidMachineIds = $this->getBidMachineIds($bidOpenId, $target, $targetId);
        if (empty($bidMachineIds)) { return array(); }

        $bmTable = new BidMachine();
        return $bmTable->getList(array('bid_open_id' => $bidOpenId, 'id' => $bidMachineIds));
    }

    public function getBidMachineIds($bidOpenId, $target, $targetId)
    {
        // SQLクエリを作成
        $sql = "SELECT t.* FROM tracking_bid_results t WHERE t.bid_open_id = ? AND t.target = ? AND t.target_id = ? ORDER BY id DESC; ";
        $result = $this->_db->fetchRow($sql, array($bidOpenId, $target, $targetId));

        $bidMachineIds = $result['bid_machine_ids'];

        // 取得したレコメンドIDsから入札会商品情報を取得
        if (empty($bidMachineIds)) { return array(); }
        else                       { return array_filter(explode(',', $bidMachineIds), 'strlen'); }
    }

    public function setMLResults($machine_uri, $bidOpenId, $resultNum=24)
    {
        $resUrls = $this->accessML($machine_uri, $bidOpenId, $resultNum);

        foreach ($resUrls as $target => $url)
        {
            $csvStr = file_get_contents($url, false);
            foreach (explode("\n", $csvStr) as $key => $line) {
                if ($key == 0 || empty($line[0])) { continue; }

                $lineArray = str_getcsv($line);
                $targetId = array_shift($lineArray);
                $this->set(null, array(
                    "target"          => $target,
                    "target_id"       => $targetId,
                    "bid_open_id"     => $bidOpenId,
                    "bid_machine_ids" => implode(',', $lineArray),
                ));
            }
        }
    }

    public function accessML($machine_uri, $bidOpenId, $resultNum=24)
    {
        $workspaces = 'c59598e9f25a4863aa719595f6726ece';
        $services   = 'f97cdae53eff4e08af34a62692f26a17';
        $APIKey     = 'yZnRyYG7ROUuQPNiTYIHixygnh0ull4kNnEtr0c37AUe2yKSPezCRNYVUA5DZf0Xnna1fC3olCXqzbDVT6dj/Q==';

        /// Submit ///
        $url = "https://asiasoutheast.services.azureml.net/workspaces/${workspaces}/services/${services}/jobs?api-version=2.0";

        $status = array(
            'Input'   => null,
            'Outputs' => null,
            'GlobalParameters' => array(
                'ratings_csv_url'  => $machine_uri . '/system/bid_ml_csv.php?o=' . $bidOpenId,
                'users_csv_url'    => $machine_uri . '/system/bid_ml_csv.php?t=user&o=' . $bidOpenId,
                'machines_csv_url' => $machine_uri . '/system/bid_ml_csv.php?t=machine&o=' . $bidOpenId,
                'result_num'       => !empty($resultNum) ? $resultNum : 24,
            )
        );

        $data    = json_encode($status, JSON_UNESCAPED_SLASHES);
        $datalen = strlen($data);

        $options = array(
            'http'=> array(
                'method'=> "POST",
                'header'=> "Content-Length: ${datalen}\r\n" .
                           "Authorization: Bearer $APIKey\r\n" .
                           "Content-Type:application/json\r\n",
                "content" => $data
            )
        );

        $context = stream_context_create($options);
        $res     = json_decode(file_get_contents($url, false, $context));
        $jobId   = $res;

        /// Start ///
        $url = "https://asiasoutheast.services.azureml.net/workspaces/${workspaces}/services/${services}/jobs/${jobId}/start?api-version=2.0";

        $options = array(
          'http'=>array(
            'method'=> "POST",
            'header'=> "Content-Length:0\r\n" .
                       "Authorization: Bearer $APIKey\r\n"
          )
        );

        $context = stream_context_create($options);
        $result  = file_get_contents($url, false, $context);

        /// result ///
        while(1) {
            sleep(30);
            $url = "https://asiasoutheast.services.azureml.net/workspaces/${workspaces}/services/${services}/jobs/${jobId}?api-version=2.0";

            $options = array(
                'http'=> array(
                    'method'=> "GET",
                    'header'=> "Content-Length:0\r\n" .
                               "Authorization:Bearer $APIKey\r\n"
              )
            );

            $context   = stream_context_create($options);
            $res       = json_decode(file_get_contents($url, false, $context));

            if ($res->StatusCode == "Finished") { break; }
            // break;
        }

        $o1               = $res->Results->result_user;
        $resUrls ['user'] = $o1->BaseLocation . $o1->RelativeLocation . $o1->SasBlobToken;

        $o1                 = $res->Results->result_machine;
        $resUrls['machine'] = $o1->BaseLocation . $o1->RelativeLocation . $o1->SasBlobToken;

        return $resUrls;
    }
}

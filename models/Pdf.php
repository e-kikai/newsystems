<?php

/**
 * PDF生成モデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 */
class Pdf
{
    // 下げ札
    const A4_WIDTH      = 210;
    const A4_HEIGHT     = 297;
    const SAGE_COLS     = 1;
    const SAGE_ROWS     = 2;
    // const SAGE_MARGIN_X = 25;
    const SAGE_MARGIN_X = 20;
    const SAGE_MARGIN_Y = 8;
    const QR_SIZE       = 36;

    const SITE_URI   = 'https://www.zenkiren.net/';
    const DETAIL_URI = 'https://www.zenkiren.net/bid_detail.php';

    const QR_URI     = 'https://www.zenkiren.net/ajax/qr_img.php';
    const LOGO_URI   = 'https://www.zenkiren.net/imgs/logo_machinelife.png';
    // const QR_URI     = 'http://test-machine.etest.wjg.jp/ajax/qr_img.php';
    // const LOGO_URI   = 'http://test-machine.etest.wjg.jp/imgs/logo_machinelife.png';

    // 集計
    const SUM_MARGIN_X    = 112;
    const SUM_LABEL_WIDTH = 46;
    const SUM_NUM_WIDTH   = 30;
    const SUM_UNDER_X     = 24;

    public $_p = null;

    /**
     * コンストラクタ
     *
     * @access public
     */
    public function __construct()
    {
        //// PDF出力準備 ////
        ini_set('display_errors', 0);
        $this->_p = new MBfpdi("L", "mm", "A4");

        // マルチバイトフォント登録
        $this->_p->AddMBFont(GOTHIC, 'SJIS');
        $this->_p->AddMBFont(MINCHO, 'SJIS');

        // 文書情報設定
        $this->_p->SetCreator('FPDF');
        $this->_p->SetAuthor('Sample Company, Inc.');
        $this->_p->SetTitle('Doc Template');

        // 表示モードを指定する。
        $this->_p->SetDisplayMode('fullwidth', 'continuous');

        // 総ページ数のエイリアスを定義する。エイリアスはドキュメントをクローズするときに置換する。
        // '{nb}' で総ページ数が得られる
        $this->_p->AliasNbPages();
    }

    /**
     * 下げ札PDF情報生成(SJIS)
     *
     * @access public static
     * @param string $title 入札会情報
     * @param array $bidMachineList PDF化する配列
     * @return string PDFデータ文字列(SJIS)
     */
    public function makeSagefuda($title, $bidMachineList)
    {
        foreach ($bidMachineList as $key => $m) {
            if (!($key % (self::SAGE_ROWS * self::SAGE_COLS))) {
                // ページ追加(縦向きに変更)
                $this->_p->addPage("P");
                $this->_p->SetAutoPageBreak(false);
            }

            // 表示位置原点
            $barWidth  = (self::A4_WIDTH) / self::SAGE_COLS;
            $barHeight = (self::A4_HEIGHT) / self::SAGE_ROWS;

            $barX = $barWidth * ($key % self::SAGE_COLS);
            $barY = $barHeight * (floor(($key % (self::SAGE_ROWS * self::SAGE_COLS) / self::SAGE_COLS)));

            // 罫線
            if (!empty($barY)) {
                $this->_p->Line(0, $barY, self::A4_HEIGHT, $barY);
            }

            // マージン設定
            $this->_p->SetMargins($barX + self::SAGE_MARGIN_X, 0, 0);
            $this->_p->SetXY($barX + self::SAGE_MARGIN_X, $barY + self::SAGE_MARGIN_Y);

            // 表示作成
            $this->_p->SetFont(GOTHIC, '', 18);
            $this->_p->Cell(160, 8, B::u2s($title . " 出品商品"), 0, 1, 'C');

            $this->_p->SetMargins($barX + self::SAGE_MARGIN_X, 1, 0);
            $this->_p->SetXY($barX + self::SAGE_MARGIN_X, $barY + self::SAGE_MARGIN_Y + 15);

            $this->_p->SetFont(GOTHIC, '', 20);
            $this->_p->Cell(80, 20, B::u2s('出品番号 : '), 0, 0, 'R');
            $this->_p->SetFont(GOTHIC, '', 32);
            $this->_p->Cell(80, 20, B::u2s($m['list_no']), 0, 1, 'L');

            // $this->_p->Cell(60, 10, B::u2s("商品名"), 1, 0, 'L');

            // 機械名の手動改行
            $this->_p->SetFont(GOTHIC, '', 24);
            if (preg_match('/^(.{18})(.*)$/u', $m['name'], $res)) {
                $this->_p->Cell(160, 10, B::u2s($res[1]), 0, 1, 'C');
                $this->_p->Cell(160, 10, B::u2s($res[2]), 0, 1, 'C');
            } else {
                $this->_p->Cell(160, 20, B::u2s($m['name']), 0, 1, 'C');
            }

            // メーカー、型式、年式
            $mes = $m['maker'];
            if (!empty($m['model'])) {
                $mes .= ' ' . $m['model'];
            }
            if (!empty($m['year'])) {
                $mes .= ' ' . $m['year'] . '年式';
            }

            $this->_p->SetFont(MINCHO, '', 16);
            $this->_p->Cell(160, 16, B::u2s($mes), 0, 1, 'C');

            // $this->_p->Cell(60, 10, B::u2s("メーカー"), 1, 0, 'L');
            // $this->_p->Cell(100, 10, B::u2s($m['maker']), 1, 1, 'L');

            // $this->_p->Cell(60, 10, B::u2s("型式"), 1, 0, 'L');
            // $this->_p->Cell(100, 10, B::u2s($m['model']), 1, 1, 'L');

            // $this->_p->Cell(60, 10, B::u2s("年式"), 1, 0, 'L');
            // $this->_p->Cell(100, 10, B::u2s($m['year']), 1, 1, 'L');

            // $this->_p->Cell(60, 10, B::u2s("最低入札金額"), 1, 0, 'L');
            $this->_p->SetFont(GOTHIC, '', 24);
            $this->_p->Cell(160, 20, B::u2s('最低入札金額 : ' . number_format($m['min_price']) . '円'), 0, 1, 'C');

            // QRコード
            $this->_p->Image(
                self::QR_URI . "?d=" . urlencode(self::DETAIL_URI . '?m=' . $m['id']) . '&e=H&.png',
                $barX +  self::SAGE_MARGIN_X,
                $barY + 106,
                self::QR_SIZE,
                self::QR_SIZE
            );

            // 署名他
            $this->_p->SetMargins($barX + self::SAGE_MARGIN_X + self::QR_SIZE + 12, 0, 0);
            $this->_p->SetXY($barX + self::SAGE_MARGIN_X + self::QR_SIZE + 12, $barY + 106 + 20);

            $this->_p->SetFont(GOTHIC, '', 16);
            // $this->_p->Cell(100, 7, B::u2s("マシンライフ"), 0, 1, 'L');
            $this->_p->Cell(100, 7, B::u2s(self::SITE_URI), 0, 1, 'L');
            $this->_p->Cell(100, 7, B::u2s("全日本機械業連合会"), 0, 1, 'L');

            // $this->_p->Image(self::LOGO_URI, $barX + self::SAGE_MARGIN_X + self::QR_SIZE + 12, $barY + 106, 80);
        }

        // インライン形式でPDFファイルを出力
        return $this->_p->Output($tplfile, 'S');
    }

    /**
     * 引取・指図書PDF情報生成(SJIS)
     *
     * @access public static
     * @param string $title 入札会情報
     * @param array $bidMachineList PDF化する配列
     * @return string PDFデータ文字列(SJIS)
     */
    public function makeSashizu($title, $company, $bidBidList)
    {
        $count = 0;
        foreach ($bidBidList as $b) {
            if ($b['res'] == false) {
                continue;
            }
            if (!($count % 2)) {
                // ページ追加(縦向きに変更)
                $this->_p->addPage("P");
                $this->_p->SetAutoPageBreak(false);
                $y = 0;
            } else {
                $y = 148.5;
            }

            //枠の描画
            $this->_p->Rect(8, 8 + $y, 194, 132.5);

            $this->_p->SetXY(85, 10 + $y);
            $this->_p->SetFont(MINCHO, '', 20);
            $this->_p->Cell(50, 10, B::u2s('引取・指図書'), 'B', 1, 'C');

            $this->_p->SetFont(MINCHO, '', 14);
            $this->_p->Text(12, 28 + $y, B::u2s($b['company'] . ' 御中'));

            //中央部分（メインテーブル部分）
            $this->_p->SetFont(MINCHO, '', 12);
            $this->_p->SetXY(100, 30 + $y);
            $this->_p->Cell(96, 8, B::u2s($title), 0, 2, 'R');
            $this->_p->Cell(96, 8, B::u2s('事務局発行'), 0, 0, 'R');

            $this->_p->SetXY(100, 100 + $y);
            $this->_p->Cell(0, 12, B::u2s('会社名 : ' . $company . '    (印)'), 0, 2, 'L');
            $this->_p->Cell(0, 12, B::u2s('担当者 :                     (印)'), 0, 0, 'L');

            $this->_p->SetXY(8, 50 + $y);
            $this->_p->SetMargins(8, 50 + $y);

            $this->_p->Cell(100, 7, B::u2s('下記商品を引取いたします。'), 0, 1, 'L');

            $this->_p->Cell(20, 7, B::u2s('出品番号'), 1, 0, 'C');
            $this->_p->Cell(64, 7, B::u2s('商品名'), 1, 0, 'C');
            $this->_p->Cell(55, 7, B::u2s('メーカー'), 1, 0, 'C');
            $this->_p->Cell(55, 7, B::u2s('型式'), 1, 1, 'C');
            // $this->_p->Cell(39, 7, B::u2s('摘要') , 1, 1, 'C');

            $this->_p->SetFont(MINCHO, '', 20);
            // $this->_p->Cell(20, 20, B::u2s($b['bid_machine_id']) , 1, 0, 'C');
            $this->_p->Cell(20, 20, B::u2s($b['list_no']), 1, 0, 'C');

            $this->_p->SetFont(MINCHO, '', 12);
            $this->_p->Cell(64, 20, B::u2s(), 1, 0, 'L');
            $this->_p->Cell(55, 20, B::u2s($b['maker']), 1, 0, 'L');
            $this->_p->Cell(55, 20, B::u2s($b['model']), 1, 1, 'L');
            // $this->_p->Cell(39, 20, '' , 1, 1, 'C');
            // $this->_p->Cell(100, 7, B::u2s('平成      年    月    日') , 0, 0, 'L');
            $this->_p->Cell(100, 7, B::u2s('          年    月    日'), 0, 0, 'L');

            // 機械名の手動改行
            if (preg_match('/^(.{14})(.+)/u', $b['name'], $res)) {
                $this->_p->SetXY(29, 68 + $y);
                $this->_p->SetMargins(29, 68 + $y);

                $name = $res[1] . "\n" . $res[2];
                $this->_p->Write(6, B::u2s($name));
            } else {
                $this->_p->SetXY(29, 71 + $y);
                $this->_p->SetMargins(29, 71 + $y);

                $this->_p->Write(6, B::u2s($b['name']));
            }

            $count++;
        }

        // インライン形式でPDFファイルを出力
        return $this->_p->Output($tplfile, 'S');
    }

    /**
     * 落札・出品集計表PDF情報生成(SJIS)
     *
     * @access public static
     * @param string $title 入札会タイトル
     * @param array $sumList PDF化する配列
     * @return string PDFデータ文字列(SJIS)
     */
    public function makeSum($bidOpen, $sumList)
    {
        foreach ($sumList as $s) {
            $this->_p->addPage("P"); //縦向きに変更

            // マージンを設定
            $this->_p->SetMargins(24, 34);

            // 住所を印刷
            $this->_p->SetFont(MINCHO, '', 12);
            // 〒整形
            $zip = preg_match('/([0-9]{3})([0-9]{4})/', $s["company"]["zip"], $r) ? $r[1] . '-' . $r[2] : $s["company"]["zip"];
            $this->_p->Text(23, 16, B::u2s('〒' . $zip));
            $this->_p->Text(23, 20, B::u2s($s["company"]["addr1"] . $s["company"]["addr2"] . $s["company"]["addr3"]));

            $this->_p->SetFont(MINCHO, 'B', 14);
            $this->_p->Text(23, 30, B::u2s(($s["company"]['company']) . ' 御中'));

            $this->_p->SetFont(MINCHO, 'B', 16);
            $this->_p->Text(23, 43, B::u2s($bidOpen['title'] . ' 落札・出品集計表'));

            // 上部右側
            $this->_p->SetFont(GOTHIC, '', 12);
            // $this->_p->Text(140, 19,  B::u2s("平成".(date('Y')-1988)."年".date('m月d日')));
            $this->_p->Text(140, 19,  B::u2s(date('Y年n月j日')));

            $this->_p->SetFont(MINCHO, "", 12);
            $this->_p->Text(140, 29,  B::u2s("全日本機械業連合会"));
            $this->_p->Text(140, 36,  B::u2s("マシンライフ委員会"));

            // 請求書の表示
            $this->_p->SetFont(MINCHO, 'B', 14);
            $this->_p->Text(39, 63,  B::u2s("落札代金請求書"));

            $this->_p->SetFont(MINCHO, '', 12);
            $this->_p->SetMargins(24, 65);
            $this->_p->SetXY(24, 65);
            $this->_p->Cell(self::SUM_LABEL_WIDTH, 6, B::u2s('落札代金請求額(イ)'), 1, 1, 'L');
            $this->_p->Cell(self::SUM_LABEL_WIDTH, 6, B::u2s('デメ半(ロ)'), 1, 1, 'L');
            $this->_p->Cell(self::SUM_LABEL_WIDTH, 6, B::u2s('小計(イ)-(ロ)=(ハ)'), 1, 1, 'L');
            $this->_p->Cell(self::SUM_LABEL_WIDTH, 6, B::u2s('貴社受取手数料(ニ)'), 1, 1, 'L');
            $this->_p->Cell(self::SUM_LABEL_WIDTH, 6, B::u2s('差引(ハ)-(ニ)'), 1, 1, 'L');
            $this->_p->Cell(self::SUM_LABEL_WIDTH, 6, B::u2s('消費税 : ' . $bidOpen["tax"] . '%'), 1, 1, 'L');
            $this->_p->Cell(self::SUM_LABEL_WIDTH, 6, B::u2s('差引落札請求額'), 1, 1, 'L');

            $this->_p->SetFont(MINCHO, '', 14);
            $this->_p->SetMargins(70, 65);
            $this->_p->SetXY(70, 65);

            $this->_p->Cell(self::SUM_NUM_WIDTH, 6, number_format($s["billing_amount"]), 1, 1, 'R');
            $this->_p->Cell(self::SUM_NUM_WIDTH, 6, number_format($s["billing_demeh"]), 1, 1, 'R');
            $this->_p->Cell(self::SUM_NUM_WIDTH, 6, number_format($s["billing_amount"] - $s["billing_demeh"]), 1, 1, 'R');
            $this->_p->Cell(self::SUM_NUM_WIDTH, 6, number_format($s["billing_rFee"]), 1, 1, 'R');
            $this->_p->Cell(self::SUM_NUM_WIDTH, 6, number_format($s["billing"]), 1, 1, 'R');
            $this->_p->Cell(self::SUM_NUM_WIDTH, 6, number_format($s["billing_tax"]), 1, 1, 'R');
            $this->_p->Cell(self::SUM_NUM_WIDTH, 6, number_format($s["final_billing"]), 1, 1, 'R');

            // 出品支払書の表示
            $this->_p->SetFont(MINCHO, 'B', 14);
            $this->_p->Text(self::SUM_MARGIN_X + 17, 63, B::u2s("出品支払書"));

            $this->_p->SetFont(MINCHO, '', 12);
            $this->_p->SetMargins(self::SUM_MARGIN_X, 65);
            $this->_p->SetXY(self::SUM_MARGIN_X, 65);
            $this->_p->Cell(self::SUM_LABEL_WIDTH, 6, B::u2s('出品支払額(イ)'), 1, 1, 'L');
            $this->_p->Cell(self::SUM_LABEL_WIDTH, 6, B::u2s('デメ半(ロ)'), 1, 1, 'L');
            $this->_p->Cell(self::SUM_LABEL_WIDTH, 6, B::u2s('小計(イ)-(ロ)=(ハ)'), 1, 1, 'L');
            $this->_p->SetFont(MINCHO, '', 11);
            $this->_p->Cell(self::SUM_LABEL_WIDTH, 6, B::u2s('出品料(ニ)事務局手数料'), 1, 1, 'L');
            $this->_p->SetFont(MINCHO, '', 12);
            $this->_p->Cell(self::SUM_LABEL_WIDTH, 6, B::u2s('出品料(ニ)販売手数料'), 1, 1, 'L');
            $this->_p->Cell(self::SUM_LABEL_WIDTH, 6, B::u2s('差引(ハ)-(ニ)'), 1, 1, 'L');
            $this->_p->Cell(self::SUM_LABEL_WIDTH, 6, B::u2s('消費税 : ' . $bidOpen["tax"] . '%'), 1, 1, 'L');
            $this->_p->Cell(self::SUM_LABEL_WIDTH, 6, B::u2s('差引出品支払額'), 1, 1, 'L');

            $this->_p->SetFont(MINCHO, '', 14);
            $this->_p->SetMargins(self::SUM_MARGIN_X + self::SUM_LABEL_WIDTH, 65);
            $this->_p->SetXY(self::SUM_MARGIN_X + self::SUM_LABEL_WIDTH, 65);
            $this->_p->Cell(self::SUM_NUM_WIDTH, 6, number_format($s["payment_amount"]), 1, 1, 'R');
            $this->_p->Cell(self::SUM_NUM_WIDTH, 6, number_format($s["payment_demeh"]), 1, 1, 'R');
            $this->_p->Cell(self::SUM_NUM_WIDTH, 6, number_format($s["payment_amount"] - $s["payment_demeh"]), 1, 1, 'R');
            $this->_p->Cell(self::SUM_NUM_WIDTH, 6, number_format($s["payment_jFee"]), 1, 1, 'R');
            $this->_p->Cell(self::SUM_NUM_WIDTH, 6, number_format($s["payment_rFee"]), 1, 1, 'R');
            $this->_p->Cell(self::SUM_NUM_WIDTH, 6, number_format($s["payment"]), 1, 1, 'R');
            $this->_p->Cell(self::SUM_NUM_WIDTH, 6, number_format($s["payment_tax"]), 1, 1, 'R');
            $this->_p->Cell(self::SUM_NUM_WIDTH, 6, number_format($s["final_payment"]), 1, 1, 'R');

            // 集計
            $this->_p->SetMargins(self::SUM_MARGIN_X, $this->_p->GetY());
            $this->_p->SetXY(self::SUM_MARGIN_X, $this->_p->GetY());

            $this->_p->Cell(1, 6, '', 0, 1);

            $this->_p->SetFont(MINCHO, '', 14);
            $this->_p->Cell(self::SUM_LABEL_WIDTH, 6, B::u2s('落札請求額'), 0, 0, 'L');
            $this->_p->SetFont(MINCHO, '', 16);
            $this->_p->Cell(self::SUM_NUM_WIDTH, 6, number_format($s["final_billing"]) . B::u2s('円'), 0, 1, 'R');
            $this->_p->SetFont(MINCHO, '', 14);
            $this->_p->Cell(self::SUM_LABEL_WIDTH, 6, B::u2s('出品支払額'), 0, 0, 'L');
            $this->_p->SetFont(MINCHO, '', 16);
            $this->_p->Cell(self::SUM_NUM_WIDTH, 6, number_format($s["final_payment"]) . B::u2s('円'), 0, 1, 'R');

            $this->_p->Cell(1, 6, '', 0, 1);

            $this->_p->SetFont(MINCHO, 'B', 16);
            if ($s["final_payment"] > $s["final_billing"]) {
                $this->_p->Cell(self::SUM_LABEL_WIDTH, 8, B::u2s('差引出品支払額'), 'T', 0, 'L');
                $this->_p->Cell(self::SUM_NUM_WIDTH, 8, number_format($s["final_payment"] - $s["final_billing"]) . B::u2s('円'), 'T', 1, 'R');

                // 下部
                $this->_p->SetFont(MINCHO, '', 14);
                $this->_p->Text(self::SUM_UNDER_X, 191, B::u2s("お支払い額は下記の通りです。"));
                $this->_p->SetFont(MINCHO, "B", 16);
                // $this->_p->Text(self::SUM_UNDER_X, 197, B::u2s("平成".(date('Y', strtotime($bidOpen["payment_date"]))-1988)."年".date('m月d日', strtotime($bidOpen["payment_date"]))."にご指定の口座に銀行振込いたします。"));
                $this->_p->Text(self::SUM_UNDER_X, 197, B::u2s(date('Y年n月j日', strtotime($bidOpen["payment_date"])) . "にご指定の口座に銀行振込いたします。"));

                $this->_p->SetFont(GOTHIC, "", 11);
                $this->_p->Text(self::SUM_UNDER_X, 209, B::u2s("尚、お支払い額より振込手数料を差し引いて振込させていただきます。"));

                $this->_p->Text(self::SUM_UNDER_X, 214,  B::u2s("※ 落札請求額と出品支払額の双方がある場合は、相殺し差額決済とします。"));
            } else {
                $this->_p->Cell(self::SUM_LABEL_WIDTH, 8, B::u2s('差引落札請求額'), 'T', 0, 'L');
                $this->_p->Cell(self::SUM_NUM_WIDTH, 8, number_format($s["final_billing"] - $s["final_payment"]) . B::u2s('円'), 'T', 1, 'R');

                // 下部
                $this->_p->SetFont(MINCHO, '', 14);
                $this->_p->Text(self::SUM_UNDER_X, 191, B::u2s("御請求額は上記の通りです。"));
                $this->_p->SetFont(MINCHO, "B", 16);
                // $this->_p->Text(self::SUM_UNDER_X, 197, B::u2s("平成".(date('Y', strtotime($bidOpen["billing_date"]))-1988)."年".date('m月d日', strtotime($bidOpen["billing_date"]))."までにご入金下さい。"));
                $this->_p->Text(self::SUM_UNDER_X, 197, B::u2s(date('Y年n月j日', strtotime($bidOpen["billing_date"])) . "までにご入金下さい。"));

                $this->_p->SetFont(GOTHIC, '', 12);
                // $this->_p->Text(self::SUM_UNDER_X, 205, B::u2s("北陸銀行今里支店"));
                $this->_p->Text(self::SUM_UNDER_X, 205, B::u2s("北陸銀行"));

                $this->_p->SetFont(MINCHO, '', 12);
                # $this->_p->Text(self::SUM_UNDER_X, 210, B::u2s("普通預金 6007122"));
                $this->_p->Text(self::SUM_UNDER_X, 210, B::u2s("今里支店 普通預金 6007122"));
                $this->_p->Text(self::SUM_UNDER_X, 215, B::u2s("口座名称 全日本機械業連合会マシンライフ委員会(略称：全機連マシンライフ委員会)"));
                $this->_p->Text(self::SUM_UNDER_X, 220, B::u2s("銀行振込略称 ゼンキレンマシンライフ"));

                $this->_p->SetFont(GOTHIC, '', 12);
                $this->_p->Text(self::SUM_UNDER_X, 230, B::u2s("ゆうちょ銀行"));

                $this->_p->SetFont(MINCHO, '', 12);
                $this->_p->Text(self::SUM_UNDER_X, 235, B::u2s("店名 四〇八 (ヨンゼロハチ) 店番 408 普通預金 口座番号 7761858"));
                $this->_p->Text(self::SUM_UNDER_X, 240, B::u2s("口座名称 マシンライフ委員会"));
                $this->_p->Text(self::SUM_UNDER_X, 245, B::u2s("銀行振込略称 マシンライフイインカイ"));

                $this->_p->SetFont(GOTHIC, "", 15);
                // $this->_p->Text(self::SUM_UNDER_X, 229,  B::u2s("※ 振込手数料は貴社負担でお願いします。"));
                $this->_p->Text(self::SUM_UNDER_X, 255,  B::u2s("※ 振込手数料は貴社負担でお願いします。"));

                $this->_p->SetFont(GOTHIC, "", 11);
                // $this->_p->Text(self::SUM_UNDER_X, 236,  B::u2s("※ 落札請求額と出品支払額の双方がある場合は、相殺し差額決済とします。"));
                $this->_p->Text(self::SUM_UNDER_X, 262,  B::u2s("※ 落札請求額と出品支払額の双方がある場合は、相殺し差額決済とします。"));
            }

            //// 落札・出品明細 ////

            // 落札明細
            if (!empty($s['billing_list'])) {
                // ページ追加
                $this->_p->addPage("L");

                $this->_p->SetMargins(10, 24);
                $this->_p->SetXY(10, 24);

                $this->_p->SetFont(GOTHIC, '', 12);
                $this->_p->Cell(0, 10, B::u2s($s["company"]['company']), 0, 1, 'L');

                $this->_p->SetFont(GOTHIC, '', 14);
                $this->_p->Cell(0, 10, B::u2s("落札商品 個別計算表"), 0, 1, 'C');

                $this->_p->SetFont(GOTHIC, '', 10);
                $this->_p->Cell(12, 5, 'ID', 1, 0, 'C');
                $this->_p->Cell(15, 5, B::u2s('出品番号'), 1, 0, 'C');
                $this->_p->Cell(60, 5, B::u2s('商品名'), 1, 0, 'C');
                $this->_p->Cell(24, 5, B::u2s('最低入札金額'), 1, 0, 'C');
                $this->_p->Cell(24, 5, B::u2s('落札金額'), 1, 0, 'C');
                $this->_p->Cell(24, 5, B::u2s('担当者'), 1, 0, 'C');
                $this->_p->Cell(24, 5, B::u2s('デメ半(' . $bidOpen["deme"] . '%)'), 1, 0, 'C');
                $this->_p->SetFont(GOTHIC, '', 7);
                $this->_p->Cell(24, 5, B::u2s('落札会社手数料'), 1, 0, 'C');
                $this->_p->SetFont(GOTHIC, '', 10);
                $this->_p->Cell(7, 5, B::u2s('%'), 1, 0, 'C');
                $this->_p->Cell(24, 5, B::u2s('請求額'), 1, 0, 'C');
                $this->_p->Cell(40, 5, B::u2s('備考欄'), 1, 1, 'C');

                foreach ($s['billing_list'] as $m) {
                    $this->_p->Cell(12, 5, B::u2s($m["id"]), 1, 0, 'R');
                    $this->_p->Cell(15, 5, B::u2s($m["list_no"]), 1, 0, 'R');
                    $this->_p->Cell(60, 5, B::u2s($m["name"]), 1, 0, 'L');
                    $this->_p->Cell(24, 5, number_format($m["min_price"]), 1, 0, 'R');
                    $this->_p->Cell(24, 5, number_format($m["res_amount"]), 1, 0, 'R');
                    $this->_p->Cell(24, 5, B::u2s($m["charge"]), 1, 0, 'L');
                    $this->_p->Cell(24, 5, number_format($m["demeh"]), 1, 0, 'R');
                    $this->_p->Cell(24, 5, number_format($m["rFee"]), 1, 0, 'R');
                    $this->_p->Cell(7, 5, number_format($m["rPer"]), 1, 0, 'R');
                    $this->_p->Cell(24, 5, number_format($m["billing"]), 1, 0, 'R');
                    $this->_p->Cell(40, 5, '', 1, 1, 'L');
                }

                $this->_p->SetFont(GOTHIC, 'B', 10);
                $this->_p->Cell(87, 5, B::u2s("落札数 : ") . count($s['billing_list']), 1, 0, 'L');
                $this->_p->Cell(24, 5, '', 1, 0, 'R');
                $this->_p->Cell(24, 5, number_format($s["billing_amount"]), 1, 0, 'R');
                $this->_p->Cell(24, 5, '', 1, 0, 'R');
                $this->_p->Cell(24, 5, number_format($s["billing_demeh"]), 1, 0, 'R');
                $this->_p->Cell(24, 5, number_format($s["billing_rFee"]), 1, 0, 'R');
                $this->_p->Cell(7, 5, "", 1, 0, 'R');
                $this->_p->Cell(24, 5, number_format($s["billing"]), 1, 0, 'R');
                $this->_p->Cell(40, 5, '', 1, 1, 'L');

                $this->_p->Cell(180, 5, '', 0, 0, 'L');
                $this->_p->Cell(34, 5, B::u2s('消費税(' . $bidOpen["tax"] . '%)'), 1, 0, 'L');
                $this->_p->Cell(24, 5, number_format($s["billing_tax"]), 1, 0, 'R');
                $this->_p->Cell(40, 5, '', 1, 1, 'L');

                $this->_p->Cell(180, 5, '', 0, 0, 'L');
                $this->_p->Cell(34, 5, B::u2s('差引落札請求額'), 1, 0, 'L');
                $this->_p->Cell(24, 5, number_format($s["final_billing"]), 1, 0, 'R');
                $this->_p->Cell(40, 5, '', 1, 1, 'L');
            }

            // 出品明細
            if (!empty($s['payment_list'])) {
                // ページ追加
                $this->_p->addPage("L");

                $this->_p->SetMargins(10, 24);
                $this->_p->SetXY(10, 24);

                $this->_p->SetFont(GOTHIC, '', 12);
                $this->_p->Cell(0, 10, B::u2s($s["company"]['company']), 0, 1, 'L');

                $this->_p->SetFont(GOTHIC, '', 14);
                $this->_p->Cell(0, 10, B::u2s("出品商品 個別計算表"), 0, 1, 'C');

                $this->_p->SetFont(GOTHIC, '', 10);
                $this->_p->Cell(12, 5, 'ID', 1, 0, 'C');
                $this->_p->Cell(15, 5, B::u2s('出品番号'), 1, 0, 'C');
                $this->_p->Cell(43, 5, B::u2s('商品名'), 1, 0, 'C');
                $this->_p->Cell(24, 5, B::u2s('最低入札金額'), 1, 0, 'C');
                $this->_p->Cell(24, 5, B::u2s('落札金額'), 1, 0, 'C');
                $this->_p->Cell(27, 5, B::u2s('落札会社'), 1, 0, 'C');
                $this->_p->Cell(24, 5, B::u2s('デメ半(' . $bidOpen["deme"] . '%)'), 1, 0, 'C');
                $this->_p->SetFont(GOTHIC, '', 7);
                $this->_p->Cell(24, 5, B::u2s('落札会社手数料'), 1, 0, 'C');
                $this->_p->SetFont(GOTHIC, '', 10);
                $this->_p->Cell(7, 5, B::u2s('%'), 1, 0, 'C');

                $this->_p->Cell(24, 5, B::u2s('事務局手数料'), 1, 0, 'C');
                $this->_p->Cell(7, 5, B::u2s('%'), 1, 0, 'C');

                $this->_p->Cell(24, 5, B::u2s('支払額'), 1, 0, 'C');
                $this->_p->Cell(20, 5, B::u2s('備考欄'), 1, 1, 'C');

                foreach ($s['payment_list'] as $m) {
                    $this->_p->Cell(12, 5, B::u2s($m["id"]), 1, 0, 'R');
                    $this->_p->Cell(15, 5, B::u2s($m["list_no"]), 1, 0, 'R');
                    $this->_p->SetFont(GOTHIC, '', 7);
                    $this->_p->Cell(43, 5, B::u2s($m["name"]), 1, 0, 'L');

                    $this->_p->SetFont(GOTHIC, '', 10);
                    $this->_p->Cell(24, 5, number_format($m["min_price"]), 1, 0, 'R');
                    $this->_p->Cell(24, 5, number_format($m["res_amount"]), 1, 0, 'R');

                    $this->_p->SetFont(GOTHIC, '', 7);
                    $this->_p->Cell(27, 5, B::u2s(preg_replace('/(株式|有限|合.)会社/u', '', $m["res_company"])), 1, 0, 'L');

                    $this->_p->SetFont(GOTHIC, '', 10);
                    $this->_p->Cell(24, 5, number_format($m["demeh"]), 1, 0, 'R');
                    $this->_p->Cell(24, 5, number_format($m["rFee"]), 1, 0, 'R');
                    $this->_p->Cell(7, 5, number_format($m["rPer"]), 1, 0, 'R');
                    $this->_p->Cell(24, 5, number_format($m["jFee"]), 1, 0, 'R');
                    $this->_p->Cell(7, 5, number_format($m["jPer"]), 1, 0, 'R');
                    $this->_p->Cell(24, 5, number_format($m["payment"]), 1, 0, 'R');
                    $this->_p->Cell(20, 5, '', 1, 1, 'L');
                }

                $this->_p->SetFont(GOTHIC, 'B', 10);
                $this->_p->Cell(70, 5, B::u2s("落札数 : ") . count($s['payment_list']), 1, 0, 'L');
                $this->_p->Cell(24, 5, '', 1, 0, 'R');
                $this->_p->Cell(24, 5, number_format($s["payment_amount"]), 1, 0, 'R');
                $this->_p->Cell(27, 5, '', 1, 0, 'R');
                $this->_p->Cell(24, 5, number_format($s["payment_demeh"]), 1, 0, 'R');
                $this->_p->Cell(24, 5, number_format($s["payment_rFee"]), 1, 0, 'R');
                $this->_p->Cell(7, 5, "", 1, 0, 'R');
                $this->_p->Cell(24, 5, number_format($s["payment_jFee"]), 1, 0, 'R');
                $this->_p->Cell(7, 5, "", 1, 0, 'R');
                $this->_p->Cell(24, 5, number_format($s["payment"]), 1, 0, 'R');
                $this->_p->Cell(20, 5, '', 1, 1, 'L');

                $this->_p->Cell(200, 5, '', 0, 0, 'L');
                $this->_p->Cell(31, 5, B::u2s('消費税(' . $bidOpen["tax"] . '%)'), 1, 0, 'L');
                $this->_p->Cell(24, 5, number_format($s["payment_tax"]), 1, 0, 'R');
                $this->_p->Cell(20, 5, '', 1, 1, 'L');

                $this->_p->Cell(200, 5, '', 0, 0, 'L');
                $this->_p->Cell(31, 5, B::u2s('差引出品支払額'), 1, 0, 'L');
                $this->_p->Cell(24, 5, number_format($s["final_payment"]), 1, 0, 'R');
                $this->_p->Cell(20, 5, '', 1, 1, 'L');
            }
        }

        // インライン形式でPDFファイルを出力
        return $this->_p->Output($tplfile, 'S');
    }

    public function makeSeriSum($bidOpen, $sumList)
    {
        foreach ($sumList as $s) {
            $this->_p->addPage("P"); //縦向きに変更

            // マージンを設定
            $this->_p->SetMargins(24, 34);

            // 住所を印刷
            $this->_p->SetFont(MINCHO, '', 12);
            // 〒整形
            $zip = preg_match('/([0-9]{3})([0-9]{4})/', $s["company"]["zip"], $r) ? $r[1] . '-' . $r[2] : $s["company"]["zip"];
            $this->_p->Text(23, 16, B::u2s('〒' . $zip));
            $this->_p->Text(23, 20, B::u2s($s["company"]["addr1"] . $s["company"]["addr2"] . $s["company"]["addr3"]));

            $this->_p->SetFont(MINCHO, 'B', 14);
            $this->_p->Text(23, 30, B::u2s(($s["company"]['company']) . ' 御中'));

            $this->_p->SetFont(MINCHO, 'B', 16);
            $this->_p->Text(23, 43, B::u2s($bidOpen['title'] . ' 企業間売り切り 落札・出品集計表'));

            // 上部右側
            $this->_p->SetFont(GOTHIC, '', 12);
            // $this->_p->Text(140, 19,  B::u2s("平成".(date('Y')-1988)."年".date('m月d日')));
            $this->_p->Text(140, 19,  B::u2s(date('Y年n月j日')));

            $this->_p->SetFont(MINCHO, "", 12);
            $this->_p->Text(140, 29,  B::u2s("全日本機械業連合会"));
            $this->_p->Text(140, 36,  B::u2s("マシンライフ委員会"));

            // 請求書の表示
            $this->_p->SetFont(MINCHO, 'B', 14);
            $this->_p->Text(39, 63,  B::u2s("落札代金請求書"));

            $this->_p->SetFont(MINCHO, '', 12);
            $this->_p->SetMargins(24, 65);
            $this->_p->SetXY(24, 65);
            $this->_p->Cell(self::SUM_LABEL_WIDTH, 6, B::u2s('落札代金請求額'), 1, 1, 'L');
            $this->_p->Cell(self::SUM_LABEL_WIDTH, 6, B::u2s('消費税 : ' . $bidOpen["tax"] . '%'), 1, 1, 'L');
            $this->_p->Cell(self::SUM_LABEL_WIDTH, 6, B::u2s('差引落札請求額'), 1, 1, 'L');

            $this->_p->SetFont(MINCHO, '', 14);
            $this->_p->SetMargins(70, 65);
            $this->_p->SetXY(70, 65);

            $this->_p->Cell(self::SUM_NUM_WIDTH, 6, number_format($s["billing"]), 1, 1, 'R');
            $this->_p->Cell(self::SUM_NUM_WIDTH, 6, number_format($s["billing_tax"]), 1, 1, 'R');
            $this->_p->Cell(self::SUM_NUM_WIDTH, 6, number_format($s["final_billing"]), 1, 1, 'R');

            // 出品支払書の表示
            $this->_p->SetFont(MINCHO, 'B', 14);
            $this->_p->Text(self::SUM_MARGIN_X + 17, 63, B::u2s("出品支払書"));

            $this->_p->SetFont(MINCHO, '', 12);
            $this->_p->SetMargins(self::SUM_MARGIN_X, 65);
            $this->_p->SetXY(self::SUM_MARGIN_X, 65);
            $this->_p->Cell(self::SUM_LABEL_WIDTH, 6, B::u2s('出品支払額'), 1, 1, 'L');

            $this->_p->SetFont(MINCHO, '', 14);
            $this->_p->SetMargins(self::SUM_MARGIN_X + self::SUM_LABEL_WIDTH, 65);
            $this->_p->SetXY(self::SUM_MARGIN_X + self::SUM_LABEL_WIDTH, 65);
            $this->_p->Cell(self::SUM_NUM_WIDTH, 6, number_format($s["final_payment"]), 1, 1, 'R');

            // 集計
            $this->_p->SetMargins(self::SUM_MARGIN_X, $this->_p->GetY() + 20);
            $this->_p->SetXY(self::SUM_MARGIN_X, $this->_p->GetY() + 20);

            $this->_p->Cell(1, 6, '', 0, 1);

            $this->_p->SetFont(MINCHO, '', 14);
            $this->_p->Cell(self::SUM_LABEL_WIDTH, 6, B::u2s('落札請求額'), 0, 0, 'L');
            $this->_p->SetFont(MINCHO, '', 16);
            $this->_p->Cell(self::SUM_NUM_WIDTH, 6, number_format($s["final_billing"]) . B::u2s('円'), 0, 1, 'R');
            $this->_p->SetFont(MINCHO, '', 14);
            $this->_p->Cell(self::SUM_LABEL_WIDTH, 6, B::u2s('出品支払額'), 0, 0, 'L');
            $this->_p->SetFont(MINCHO, '', 16);
            $this->_p->Cell(self::SUM_NUM_WIDTH, 6, number_format($s["final_payment"]) . B::u2s('円'), 0, 1, 'R');

            $this->_p->Cell(1, 6, '', 0, 1);

            $this->_p->SetFont(MINCHO, 'B', 16);
            if ($s["final_payment"] > $s["final_billing"]) {
                $this->_p->Cell(self::SUM_LABEL_WIDTH, 8, B::u2s('差引出品支払額'), 'T', 0, 'L');
                $this->_p->Cell(self::SUM_NUM_WIDTH, 8, number_format($s["final_payment"] - $s["final_billing"]) . B::u2s('円'), 'T', 1, 'R');

                // 下部
                $this->_p->SetFont(MINCHO, '', 14);
                $this->_p->Text(self::SUM_UNDER_X, 191, B::u2s("お支払い額は下記の通りです。"));
                $this->_p->SetFont(MINCHO, "B", 16);
                // $this->_p->Text(self::SUM_UNDER_X, 197, B::u2s("平成".(date('Y', strtotime($bidOpen["payment_date"]))-1988)."年".date('m月d日', strtotime($bidOpen["payment_date"]))."にご指定の口座に銀行振込いたします。"));
                $this->_p->Text(self::SUM_UNDER_X, 197, B::u2s(date('Y年n月j日', strtotime($bidOpen["payment_date"])) . "にご指定の口座に銀行振込いたします。"));

                $this->_p->SetFont(GOTHIC, "", 11);
                $this->_p->Text(self::SUM_UNDER_X, 209, B::u2s("尚、お支払い額より振込手数料を差し引いて振込させていただきます。"));

                $this->_p->Text(self::SUM_UNDER_X, 214,  B::u2s("※ 落札請求額と出品支払額の双方がある場合は、相殺し差額決済とします。"));
            } else {
                $this->_p->Cell(self::SUM_LABEL_WIDTH, 8, B::u2s('差引落札請求額'), 'T', 0, 'L');
                $this->_p->Cell(self::SUM_NUM_WIDTH, 8, number_format($s["final_billing"] - $s["final_payment"]) . B::u2s('円'), 'T', 1, 'R');

                // 下部
                $this->_p->SetFont(MINCHO, '', 14);
                $this->_p->Text(self::SUM_UNDER_X, 191, B::u2s("御請求額は上記の通りです。"));
                $this->_p->SetFont(MINCHO, "B", 16);
                // $this->_p->Text(self::SUM_UNDER_X, 197, B::u2s("平成".(date('Y', strtotime($bidOpen["billing_date"]))-1988)."年".date('m月d日', strtotime($bidOpen["billing_date"]))."までにご入金下さい。"));
                $this->_p->Text(self::SUM_UNDER_X, 197, B::u2s(date('Y年n月j日', strtotime($bidOpen["billing_date"])) . "までにご入金下さい。"));

                $this->_p->SetFont(GOTHIC, '', 12);
                // $this->_p->Text(self::SUM_UNDER_X, 205, B::u2s("北陸銀行今里支店"));
                $this->_p->Text(self::SUM_UNDER_X, 205, B::u2s("北陸銀行"));

                $this->_p->SetFont(MINCHO, '', 12);
                # $this->_p->Text(self::SUM_UNDER_X, 210, B::u2s("普通預金 6007122"));
                $this->_p->Text(self::SUM_UNDER_X, 210, B::u2s("今里支店 普通預金 6007122"));
                $this->_p->Text(self::SUM_UNDER_X, 215, B::u2s("口座名称 全日本機械業連合会マシンライフ委員会(略称：全機連マシンライフ委員会)"));
                $this->_p->Text(self::SUM_UNDER_X, 220, B::u2s("銀行振込略称 ゼンキレンマシンライフ"));

                $this->_p->SetFont(GOTHIC, '', 12);
                $this->_p->Text(self::SUM_UNDER_X, 230, B::u2s("ゆうちょ銀行"));

                $this->_p->SetFont(MINCHO, '', 12);
                $this->_p->Text(self::SUM_UNDER_X, 235, B::u2s("店名 四〇八 (ヨンゼロハチ) 店番 408 普通預金 口座番号 7761858"));
                $this->_p->Text(self::SUM_UNDER_X, 240, B::u2s("口座名称 マシンライフ委員会"));
                $this->_p->Text(self::SUM_UNDER_X, 245, B::u2s("銀行振込略称 マシンライフイインカイ"));

                $this->_p->SetFont(GOTHIC, "", 15);
                // $this->_p->Text(self::SUM_UNDER_X, 229,  B::u2s("※ 振込手数料は貴社負担でお願いします。"));
                $this->_p->Text(self::SUM_UNDER_X, 255,  B::u2s("※ 振込手数料は貴社負担でお願いします。"));

                $this->_p->SetFont(GOTHIC, "", 11);
                // $this->_p->Text(self::SUM_UNDER_X, 236,  B::u2s("※ 落札請求額と出品支払額の双方がある場合は、相殺し差額決済とします。"));
                $this->_p->Text(self::SUM_UNDER_X, 262,  B::u2s("※ 落札請求額と出品支払額の双方がある場合は、相殺し差額決済とします。"));
            }

            //// 落札・出品明細 ////

            // 落札明細
            if (!empty($s['billing_list'])) {
                // ページ追加
                $this->_p->addPage("L");

                $this->_p->SetMargins(10, 24);
                $this->_p->SetXY(10, 24);

                $this->_p->SetFont(GOTHIC, '', 12);
                $this->_p->Cell(0, 10, B::u2s($s["company"]['company']), 0, 1, 'L');

                $this->_p->SetFont(GOTHIC, '', 14);
                $this->_p->Cell(0, 10, B::u2s("落札商品 個別計算表"), 0, 1, 'C');

                $this->_p->SetFont(GOTHIC, '', 10);
                $this->_p->Cell(12, 5, 'ID', 1, 0, 'C');
                $this->_p->Cell(15, 5, B::u2s('出品番号'), 1, 0, 'C');
                $this->_p->Cell(60, 5, B::u2s('商品名'), 1, 0, 'C');
                $this->_p->Cell(34, 5, B::u2s('最低入札金額'), 1, 0, 'C');
                $this->_p->Cell(34, 5, B::u2s('落札金額'), 1, 0, 'C');
                // $this->_p->Cell(15,5,B::u2s('即決落札'), 1,0,'C');
                $this->_p->Cell(90, 5, B::u2s('備考欄'), 1, 1, 'C');

                foreach ($s['billing_list'] as $m) {
                    $this->_p->Cell(12, 5, B::u2s($m["id"]), 1, 0, 'R');
                    $this->_p->Cell(15, 5, B::u2s($m["list_no"]), 1, 0, 'R');
                    $this->_p->Cell(60, 5, B::u2s($m["name"]), 1, 0, 'L');
                    $this->_p->Cell(34, 5, number_format($m["min_price"]), 1, 0, 'R');
                    $this->_p->Cell(34, 5, number_format($m["seri_amount"]), 1, 0, 'R');
                    // $this->_p->Cell(15,5, (!empty($m['prompt']) ? B::u2s('◯') : ""), 1,0,'R');
                    $this->_p->Cell(90, 5, '', 1, 1, 'L');
                }

                $this->_p->SetFont(GOTHIC, 'B', 10);
                $this->_p->Cell(87, 5, B::u2s("落札数 : ") . count($s['billing_list']), 1, 0, 'L');
                $this->_p->Cell(34, 5, '', 1, 0, 'R');
                $this->_p->Cell(34, 5, number_format($s["billing"]), 1, 0, 'R');
                $this->_p->Cell(90, 5, '', 1, 1, 'L');

                $this->_p->Cell(87, 5, '', 0, 0, 'L');
                $this->_p->Cell(34, 5, B::u2s('消費税(' . $bidOpen["tax"] . '%)'), 1, 0, 'L');
                $this->_p->Cell(34, 5, number_format($s["billing_tax"]), 1, 0, 'R');
                $this->_p->Cell(90, 5, '', 1, 1, 'L');

                $this->_p->Cell(87, 5, '', 0, 0, 'L');
                $this->_p->Cell(34, 5, B::u2s('落札請求額'), 1, 0, 'L');
                $this->_p->Cell(34, 5, number_format($s["final_billing"]), 1, 0, 'R');
                $this->_p->Cell(90, 5, '', 1, 1, 'L');
            }

            // 出品明細
            if (!empty($s['payment_list'])) {
                // ページ追加
                $this->_p->addPage("L");

                $this->_p->SetMargins(10, 24);
                $this->_p->SetXY(10, 24);

                $this->_p->SetFont(GOTHIC, '', 12);
                $this->_p->Cell(0, 10, B::u2s($s["company"]['company']), 0, 1, 'L');

                $this->_p->SetFont(GOTHIC, '', 14);
                $this->_p->Cell(0, 10, B::u2s("出品商品 個別計算表"), 0, 1, 'C');

                $this->_p->SetFont(GOTHIC, '', 10);
                $this->_p->Cell(12, 5, 'ID', 1, 0, 'C');
                $this->_p->Cell(15, 5, B::u2s('出品番号'), 1, 0, 'C');
                $this->_p->Cell(43, 5, B::u2s('商品名'), 1, 0, 'C');
                $this->_p->Cell(24, 5, B::u2s('最低入札金額'), 1, 0, 'C');
                $this->_p->Cell(24, 5, B::u2s('落札金額'), 1, 0, 'C');
                $this->_p->Cell(50, 5, B::u2s('落札会社'), 1, 0, 'C');
                $this->_p->Cell(15, 5, B::u2s('即決落札'), 1, 0, 'C');
                $this->_p->Cell(90, 5, B::u2s('備考欄'), 1, 1, 'C');

                foreach ($s['payment_list'] as $m) {
                    $this->_p->Cell(12, 5, B::u2s($m["id"]), 1, 0, 'R');
                    $this->_p->Cell(15, 5, B::u2s($m["list_no"]), 1, 0, 'R');
                    $this->_p->SetFont(GOTHIC, '', 7);
                    $this->_p->Cell(43, 5, B::u2s($m["name"]), 1, 0, 'L');

                    $this->_p->SetFont(GOTHIC, '', 10);
                    $this->_p->Cell(24, 5, number_format($m["min_price"]), 1, 0, 'R');
                    $this->_p->Cell(24, 5, number_format($m["seri_amount"]), 1, 0, 'R');

                    // $this->_p->SetFont(GOTHIC,'', 7);
                    $this->_p->Cell(50, 5, B::u2s(preg_replace('/(株式|有限|合.)会社/u', '', $m["seri_company"])), 1, 0, 'L');

                    // $this->_p->SetFont(GOTHIC,'',10);
                    $this->_p->Cell(15, 5, (!empty($m['prompt']) ? B::u2s('◯') : ""), 1, 0, 'R');
                    $this->_p->Cell(90, 5, '', 1, 1, 'L');
                }

                $this->_p->SetFont(GOTHIC, 'B', 10);
                $this->_p->Cell(70, 5, B::u2s("落札数 : ") . count($s['payment_list']), 1, 0, 'L');
                $this->_p->Cell(24, 5, B::u2s('出品支払額'), 1, 0, 'R');
                $this->_p->Cell(24, 5, number_format($s["final_payment"]), 1, 0, 'R');
                $this->_p->Cell(155, 5, '', 1, 1, 'L');
            }
        }

        // インライン形式でPDFファイルを出力
        return $this->_p->Output($tplfile, 'S');
    }

    /**
     * 領収証PDF情報生成(SJIS)
     *
     * @access public static
     * @param string $title 入札会情報
     * @param array $sumList PDF化する配列
     * @return string PDFデータ文字列(SJIS)
     */
    public function makeReceipt($bidOpen, $sumList, $isSeri = false)
    {
        if ($isSeri == true) {
            $title = $bidOpen["title"] . ' 企業間売り切り';
        } else {
            $title = $bidOpen["title"];
        }

        foreach ($sumList as $s) {
            // 請求金額がある場合のみ、請求証を作成
            if ($s["final_payment"] > $s["final_billing"]) {
                continue;
            }

            // ページ追加
            $this->_p->addPage("P"); //縦向きに変更
            $this->_p->SetMargins(16, 33);

            // 控えも印刷するためにループ
            foreach (array(0, 148.5) as $key => $y) {
                //枠の描画
                $this->_p->Rect(8, 8 + $y, 194, 132.5);

                //上部左側
                $this->_p->SetFont(MINCHO, '', 16);
                $this->_p->Text(18, 24 + $y, B::u2s($s['company']["company"] . ' 御中'));
                // $this->_p->Line(18, 28+$y, $this->_p->GetX() ,28+$y);

                //中央部分（メインテーブル部分）
                $this->_p->SetXY(16, 33 + $y);
                $this->_p->SetFont(MINCHO, '', 26);
                $this->_p->Cell(0, 15, B::u2s('領収証' . ($key > 0 ? '(控)' : '')), 0, 1, 'C');

                $this->_p->SetFont(MINCHO, '', 12);

                $this->_p->Cell(0, 3, B::u2s("下記の通り、御社の" . $title . "の清算金額を領収いたしました。"), 0, 1, 'L');

                $this->_p->Cell(0, 7, "", 0, 1, 'C');
                $this->_p->Cell(0, 7, B::u2s("記"), 0, 1, 'C');

                $this->_p->Cell(65, 6, B::u2s('請求金額(税抜き)'), 1, 0, 'C');
                $this->_p->Cell(43, 6, B::u2s('消費税 : ' . $bidOpen["tax"] . '%'), 1, 0, 'C');
                $this->_p->Cell(70, 6, B::u2s('合計請求金額'), 1, 1, 'C');

                $this->_p->SetFont(MINCHO, '', 16);
                $this->_p->Cell(65, 13, number_format($s['billing'] - $s['payment']) . B::u2s('円'), 1, 0, 'R');
                $this->_p->Cell(43, 13, number_format($s['billing_tax'] - $s['payment_tax']) . B::u2s('円'), 1, 0, 'R');
                $this->_p->Cell(70, 13, number_format($s['final_billing'] - $s['final_payment']) . B::u2s('円'), 1, 1, 'R');

                $this->_p->SetFont(MINCHO, '', 12);
                $this->_p->Cell(0, 4, "", 0, 1, 'C');
                $this->_p->Cell(17, 12, B::u2s('内訳'), 1, 0, 'C');
                $this->_p->Cell(8, 6, '', 1, 0, 'C');
                $this->_p->Cell(26, 6, B::u2s('現金'), 1, 1, 'C');
                $this->_p->Cell(17, 6, '', 0, 0, 'C');
                $this->_p->Cell(8, 6, '', 1, 0, 'C');
                $this->_p->Cell(26, 6, B::u2s('小切手'), 1, 1, 'C');

                //下部
                $this->_p->SetXY(16, 90 + $y);
                $this->_p->Cell(0, 7, B::u2s('以上'), 0, 1, 'R');
                // $this->_p->Cell(0, 7, B::u2s('平成　　年　　月　　日'),0,1,'R');
                $this->_p->Cell(0, 7, B::u2s('　　　　年　　月　　日'), 0, 1, 'R');
                $this->_p->Cell(0, 7, B::u2s('全日本機械業連合会'), 0, 1, 'R');
                $this->_p->Cell(0, 7, B::u2s('マシンライフ委員会'), 0, 1, 'R');
                // $this->_p->Cell(0, 7, B::u2s('TEL 06-6747-7521　FAX 06-6747-7525'),0,1,'R');
            }
        }
        // インライン形式でPDFファイルを出力
        return $this->_p->Output($tplfile, 'S');
    }

    /**
     * 会員入札会下げ札PDF情報生成(SJIS)
     *
     * @access public static
     * @param string $title 入札会情報
     * @param array $bidMachineList PDF化する配列
     * @return string PDFデータ文字列(SJIS)
     */
    public function makeCompanybidSagefuda($companybidOpen, $bidMachineList)
    {
        foreach ($bidMachineList as $key => $m) {
            if (!($key % (self::SAGE_ROWS * self::SAGE_COLS))) {
                // ページ追加(縦向きに変更)
                $this->_p->addPage("P");
                $this->_p->SetAutoPageBreak(false);
            }

            // 表示位置原点
            $barWidth  = (self::A4_WIDTH) / self::SAGE_COLS;
            $barHeight = (self::A4_HEIGHT) / self::SAGE_ROWS;

            $barX = $barWidth * ($key % self::SAGE_COLS);
            $barY = $barHeight * (floor(($key % (self::SAGE_ROWS * self::SAGE_COLS) / self::SAGE_COLS)));

            // 罫線
            if (!empty($barY)) {
                $this->_p->Line(0, $barY, self::A4_HEIGHT, $barY);
            }

            // マージン設定
            $this->_p->SetMargins($barX + self::SAGE_MARGIN_X, 0, 0);
            $this->_p->SetXY($barX + self::SAGE_MARGIN_X, $barY + self::SAGE_MARGIN_Y);

            // 表示作成
            $this->_p->SetFont(GOTHIC, '', 24);
            $this->_p->Cell(160, 26, B::u2s($companybidOpen['title'] . " 出品商品"), 0, 1, 'C');

            $this->_p->SetMargins($barX + self::SAGE_MARGIN_X, 1, 0);
            $this->_p->SetXY($barX + self::SAGE_MARGIN_X, $barY + self::SAGE_MARGIN_Y + 24);

            $this->_p->SetFont(GOTHIC, '', 20);
            $this->_p->Cell(80, 20, B::u2s('出品番号 : '), 0, 0, 'R');
            $this->_p->SetFont(GOTHIC, '', 36);
            $this->_p->Cell(80, 20, B::u2s($m['list_no']), 0, 1, 'L');

            // $this->_p->Cell(60, 10, B::u2s("商品名"), 1, 0, 'L');

            // 機械名の手動改行
            $this->_p->SetFont(GOTHIC, '', 32);
            if (preg_match('/^(.{18})(.*)$/u', $m['name'], $res)) {
                $this->_p->Cell(160, 10, B::u2s($res[1]), 0, 1, 'C');
                $this->_p->Cell(160, 10, B::u2s($res[2]), 0, 1, 'C');
            } else {
                $this->_p->Cell(160, 20, B::u2s($m['name']), 0, 1, 'C');
            }

            // メーカー、型式、年式
            $mes = $m['maker'];
            if (!empty($m['model'])) {
                $mes .= ' ' . $m['model'];
            }
            if (!empty($m['year'])) {
                $mes .= ' 年式:' . $m['year'];
            }

            $this->_p->SetFont(MINCHO, '', 20);
            $this->_p->Cell(160, 20, B::u2s($mes), 0, 1, 'C');

            $this->_p->SetFont(GOTHIC, '', 36);
            $this->_p->Cell(160, 40, B::u2s('最低入札金額 : ' . number_format($m['min_price']) . '円'), 0, 1, 'C');

            // QRコード
            /*
            $this->_p->Image(self::QR_URI."?d=" . urlencode(self::DETAIL_URI . '?m=' . $m['id']) . '&e=H&.png',
                $barX +  self::SAGE_MARGIN_X, $barY + 106, self::QR_SIZE, self::QR_SIZE);
            */

            // 署名他
            // $this->_p->SetMargins($barX + self::SAGE_MARGIN_X + self::QR_SIZE + 12, 0, 0);
            // $this->_p->SetXY($barX + self::SAGE_MARGIN_X + self::QR_SIZE + 12, $barY + 96 + 20);

            // $this->_p->SetFont(GOTHIC,'', 16);
            // $this->_p->Cell(100, 7, B::u2s("マシンライフ"), 0, 1, 'L');
            // $this->_p->Cell(100, 7, B::u2s($companybidOpen['organizer']), 0, 1, 'L');
            // $this->_p->Cell(100, 7, B::u2s(self::SITE_URI . 'ymmachine/' . $m['']), 0, 1, 'L');
            // $this->_p->Cell(100, 7, B::u2s("全日本機械業連合会"), 0, 1, 'L');
        }

        // インライン形式でPDFファイルを出力
        return $this->_p->Output($tplfile, 'S');
    }

    /**
     * 会員請求書PDF情報生成(SJIS)
     *
     * @access public static
     * @param  array  $companyList 会社一覧
     * @param  string $date        日付
     * @return string PDFデータ文字列(SJIS)
     */
    public function makeCompanySeikyu($companyList, $date)
    {
        // テンプレートPDF読み込み
        // $pagecount = $this->_p->setSourceFile('../media/pdf/rank_seikyu.pdf');
        $pagecount = $this->_p->setSourceFile('../../templates/system/rank_seikyu.pdf');

        $seikyuTmp = $this->_p->ImportPage(1);
        $ryoshuTmp = $this->_p->ImportPage(2);

        foreach ($companyList as $c) {
            // 金額計算
            $price = 0;
            $title = '';
            if ($c['rank'] >=      202) {
                $price = '80000';
                $title = '特別会員 年会費';
            }
            // else if ($c['rank'] >= 201) { $price = '5000';  $title = '支店・営業所アカウント発行手数料'; }  // 2015のみ
            else if ($c['rank'] >= 201) {
                $price = '0';
            }  // 2016以降
            else if ($c['rank'] >= 200) {
                $price = '30000';
                $title = 'A会員 年会費';
            } else if ($c['rank'] >= 100) {
                $price = '12000';
                $title = 'B会員 年会費';
            }

            if ($price == 0) {
                continue;
            }

            // 請求書
            $this->_p->addPage('P');
            $this->_p->useTemplate($seikyuTmp);

            $this->_p->SetFont(GOTHIC, '', 10);
            $this->_p->SetXY(24, 22);
            $this->_p->Cell(100, 4, B::u2s('〒 ' . preg_replace("/^(\d{3}).*(\d{4})$/", "$1-$2", $c['zip'])), 0, 1, 'L');
            $this->_p->SetXY(24, 26);
            $this->_p->Cell(100, 4, B::u2s($c['addr1'] . $c['addr2'] . $c['addr3']), 0, 0, 'L');

            $this->_p->SetXY(134, 22);
            // $this->_p->Cell(60, 4, B::u2s('請求日 平成' . (date('Y') - 1988) . '年' . date('n月j日')), 0, 0, 'L');
            $this->_p->Cell(60, 4, B::u2s('請求日 ' . date('Y年n月j日')), 0, 0, 'L');

            $this->_p->SetFont(GOTHIC, '', 16);
            $this->_p->SetXY(24, 34);
            $this->_p->Cell(150, 8, B::u2s($c['company'] . ' 様'), 0, 0, 'L');

            $this->_p->SetFont(GOTHIC, '', 10);
            $this->_p->SetXY(24, 100);
            $this->_p->Cell(14, 8, B::u2s('1/1'), 0, 0, 'L');
            $this->_p->Cell(81, 8, B::u2s($title), 0, 0, 'L');
            $this->_p->Cell(13, 8, B::u2s(1), 0, 0, 'R');
            $this->_p->Cell(26.5, 8, B::u2s(number_format($price)), 0, 0, 'R');
            $this->_p->Cell(26.5, 8, B::u2s(number_format($price)), 0, 0, 'R');

            $this->_p->SetXY(159.5, 108);
            $this->_p->SetFont(GOTHIC, '', 9);
            $this->_p->Cell(26.5, 8, B::u2s("(消費税 不課税)"), 0, 0, 'L');

            $this->_p->SetXY(158.5, 185);
            $this->_p->SetFont(GOTHIC, '', 10);
            $this->_p->Cell(26.5, 8, B::u2s(number_format($price)), 0, 0, 'R');

            $this->_p->SetXY(55, 200);
            $this->_p->Cell(30, 3, B::u2s($date), 'B', 0, 'C');

            /// お振込先 追加 ///
            $this->_p->SetFillColor(255, 255, 255);

            $rectX = 35;
            $rectY = 214;
            $bankX = $rectX + 2;
            $bankY = $rectY + 5;
            $this->_p->Rect($rectX, $rectY, 140, 52, 'DF');

            $this->_p->SetFont(GOTHIC, '', 10);
            $this->_p->Text($bankX, $bankY, B::u2s("<< お振込先 >>"));
            $this->_p->Text($bankX, $bankY + 5, B::u2s("北陸銀行"));

            $this->_p->SetFont(MINCHO, '', 10);
            $this->_p->Text($bankX, $bankY + 10, B::u2s("今里支店 普通預金 6007122"));
            $this->_p->Text($bankX, $bankY + 15, B::u2s("口座名称 全日本機械業連合会マシンライフ委員会(略称：全機連マシンライフ委員会)"));
            $this->_p->Text($bankX, $bankY + 20, B::u2s("銀行振込略称 ゼンキレンマシンライフ"));

            $this->_p->SetFont(GOTHIC, '', 10);
            $this->_p->Text($bankX, $bankY + 30, B::u2s("ゆうちょ銀行"));

            $this->_p->SetFont(MINCHO, '', 10);
            $this->_p->Text($bankX, $bankY + 35, B::u2s("店名 四〇八 (ヨンゼロハチ) 店番 408 普通預金 口座番号 7761858"));
            $this->_p->Text($bankX, $bankY + 40, B::u2s("口座名称 マシンライフ委員会"));
            $this->_p->Text($bankX, $bankY + 45, B::u2s("銀行振込略称 マシンライフイインカイ"));

            $this->_p->SetFont(GOTHIC, "", 10);
            $this->_p->Text($bankX, $bankY + 52,  B::u2s("※ 振込手数料は貴社負担でお願いします。"));


            // 領収証
            $this->_p->addPage('P');
            $this->_p->useTemplate($ryoshuTmp);

            $this->_p->SetFont(GOTHIC, '', 16);
            $this->_p->SetXY(18, 37.5);
            $this->_p->Cell(90, 6, B::u2s($c['company'] . ' 様'), 'B', 0, 'L');

            $this->_p->SetFont(GOTHIC, '', 10);
            $this->_p->SetXY(18, 53);
            $this->_p->Cell(16, 9, B::u2s('1/1'), 0, 0, 'L');
            $this->_p->Cell(97, 9, B::u2s($title), 0, 0, 'L');
            $this->_p->Cell(53, 9, B::u2s(number_format($price)), 0, 0, 'R');

            $this->_p->SetFont(GOTHIC, '', 9);
            $this->_p->SetXY(131, 62.5);
            $this->_p->Cell(53, 8, B::u2s("(消費税 不課税)"), 0, 0, 'R');

            $this->_p->SetFont(GOTHIC, '', 12);
            $this->_p->SetXY(131, 102);
            $this->_p->Cell(53, 10, B::u2s(number_format($price) . '円'), 0, 0, 'R');

            // 領収証(控え)
            $this->_p->SetFont(GOTHIC, '', 16);
            $this->_p->SetXY(18, 147 + 37.5);
            $this->_p->Cell(90, 6, B::u2s($c['company'] . ' 様'), 'B', 0, 'L');

            $this->_p->SetFont(GOTHIC, '', 10);
            $this->_p->SetXY(18, 147 + 53);
            $this->_p->Cell(16, 9, B::u2s('1/1'), 0, 0, 'L');
            $this->_p->Cell(97, 9, B::u2s($title), 0, 0, 'L');
            $this->_p->Cell(53, 9, B::u2s(number_format($price)), 0, 0, 'R');

            $this->_p->SetFont(GOTHIC, '', 9);
            $this->_p->SetXY(131, 147 + 62.5);
            $this->_p->Cell(53, 8, B::u2s("(消費税 不課税)"), 0, 0, 'R');

            $this->_p->SetFont(GOTHIC, '', 12);
            $this->_p->SetXY(131, 147 + 102);
            $this->_p->Cell(53, 10, B::u2s(number_format($price) . '円'), 0, 0, 'R');
        }

        // インライン形式でPDFファイルを出力
        return $this->_p->Output($tplfile, 'S');
    }


    /**
     * 入札申込書PDF生成(SJIS)
     *
     * @access public static
     * @param  array  $bidOpen 入札会情報
     * @param  array  $company 会社情報
     * @return string PDFデータ文字列(SJIS)
     */
    public function makeMoushikomi($bidOpen, $company)
    {
        // テンプレートPDF読み込み
        // $pagecount = $this->_p->setSourceFile('../media/pdf/moushikomi_temp.pdf');
        $pagecount = $this->_p->setSourceFile('../../templates/system/moushikomi_temp.pdf');

        $this->_p->addPage('P');
        $this->_p->useTemplate($this->_p->ImportPage(1));

        $this->_p->SetFillColor(255, 255, 255);
        $this->_p->Rect(23, 30, 60, 36, 'F');

        if (mb_strlen($company['company']) < 13) {
            $this->_p->SetFont(MINCHO, '', 15);
        } else {
            $this->_p->SetFont(MINCHO, '', 10);
        }
        $this->_p->SetXY(23, 30);
        $this->_p->Cell(50, 9, B::u2s($company['company'] . ' 行き'), 0, 0, 'L');
        $this->_p->Line(24, 37, 100, 37);

        $this->_p->SetFont(MINCHO, '', 10);
        $this->_p->SetXY(23, 38);
        $this->_p->Cell(16, 9, B::u2s('FAX : ' . $company['fax']), 0, 0, 'L');

        $this->_p->SetFont(MINCHO, '', 10);
        $this->_p->SetXY(23, 46);
        $this->_p->Cell(16, 9, B::u2s('全機連 マシンライフ'), 0, 0, 'L');

        $this->_p->SetFont(MINCHO, '', 12);
        $this->_p->SetXY(23, 53);
        $this->_p->Cell(16, 9, B::u2s($bidOpen['title']), 0, 0, 'L');

        // インライン形式でPDFファイルを出力
        return $this->_p->Output($tplfile, 'S');
    }
}

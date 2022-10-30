<?php
/**
 * ファイルアップロード処理モデルクラス
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/08/16
 */
class File
{
    // アップロードするパス
    protected $_path = '';

    /**
     * アップロードされた＄_FILE配列を整形
     *
     * @access public
     * @param array $files $_FILES配列
     * @return array 整形した$_FILES配列
     */
    public function format($files)
    {
        $res = array();
        if (empty($files)) { return $res; }

        foreach ($files as $key => $l) {
            foreach ($l as $i => $val) {
                if (!array_key_exists($i, $res)) { $res[$i] = array(); }
                $res[$i][$key] = $val;
            }
        }

        return $res;
    }

    /**
     * アップロードするパスの設定
     *
     * @access public
     * @param string $path パス
     * @return $this
     */
    public function setPath($path)
    {
        $this->_path =  $path;

        // @ba-ta 20181129 ファイル格納パス確認
        if (!@file_exists($path)) { mkdir($path, '0777'); }

        return $this;
    }

    /**
     * パスの設定がされているか
     *
     * @access public
     * @return boolean パスがなければfalse
     */
    public function checkPath()
    {
        return empty($this->_path) ? false : true;
    }

    /**
     * アップロード実行処理
     *
     * @access public
     * @param string $file アップロードするファイル情報$_FILES
     * @param string $name 保存ファイル名
     * @param array or string $type MIMEタイプ
     * @return string アップロードしたファイル名
     */
    public function upload($file, $name, $type)
    {
        $h = new Upload($file);

        if (!$h->uploaded) {
            throw new Exception('ファイルのアップロードに失敗しました');
        }

        // ファイルチェック
        $h->allowed = $type;

        // ファイル名指定
        $h->file_src_name_body = $name;
        // $h->file_new_name_ext  = 'jpeg';

        // アップロード
        $h->Process($this->_path);
        if (!$h->processed) {
            throw new Exception('Error: ' . $h->error);
        }

        // unset($h);

        //// @ba-ta 20140322 EXIFデータより画像の回転補正 ////
        $this->autoOrient($this->_path . '/' .  $h->file_dst_name);

        return $h->file_dst_name;
    }

    /**
     * EXIFデータより画像の回転補正
     *
     * @access public
     * @param array $filename 回転補正するファイル名
     */
    public function autoOrient($filename)
    {
        // JPEGかどうか判別
        if (exif_imagetype($filename) == IMAGETYPE_JPEG) {

            // EXIFがあるかどうか
            $exif = @exif_read_data($filename);

            if (!empty($exif) && !empty($exif['Orientation']) && $exif['Orientation'] != 1) {
                  $imgCmd = '/usr/bin/convert -auto-orient -strip ';
                  $cmd = $imgCmd . ' ' . escapeshellcmd($filename). ' ' . escapeshellcmd($filename. '');
                  exec($cmd);
            }
        }

        return $this;
    }

    /**
     * $_FILES一括アップロード実行処理
     *
     * @access public
     * @param array $file アップロードするファイル情報$_FILES
     * @param string $name 保存ファイル名
     * @param array or string $type MIMEタイプ
     * @return string アップロードしたファイル名
     */
    public function uploadFiles($files, $name, $type)
    {
        $res = array();
        $files = $this->format($files);

        foreach($files as $key => $val) {
            $temp = array(
                'filename' => $this->upload($val, $name . '_' . $key, $type),
                'label'    => $val['name'],
            );
            $res[] = $temp;
        }

        return $res;
    }

    /**
     * 画像ファイル名配列のマージ
     *
     * @access public
     * @param array $now 現在のファイル名配列
     * @param array $add 追加するファイル名配列
     * @param array $delete 削除するファイル名配列
     * @return array マージしたファイル名配列
     */
    public function merge($now, $add=null, $delete=null)
    {
        return array_diff(((array)$now + (array)$add), (array)$delete);
    }

    /**
     * 画像ファイルの削除
     *
     * @access public
     * @param array $delete 削除するファイル名配列
     * @return $this
     */
    public function delete($delete)
    {
        // @ba-ta_20181127 ファイルアップロードの不具合対策＆S3移行のため、一時コメントアウト
        // foreach ((array)$delete as $val) {
        //     unlink($this->_path . $val);
        // }

        return $this;
    }

    /**
     * ファイル情報の結合・tempから本パスに移動・チェック
     *
     * @access public
     * @param array $delete 削除するファイル名配列
     * @return $this
     */
    public function check($imgs, $delete, $tempPath, $realPath, $thumFlag = false)
    {
        // 削除フラグのある画像を削除
        foreach ((array)$delete as $key => $val) {
            // @ba-ta_20181127 ファイルアップロードの不具合対策＆S3移行のため、一時コメントアウト
            // // 本パス上にファイルがある場合、ファイルをtempに移動
            // if (file_exists($realPath . '/'. $val)) {
            //     rename($realPath . '/'. $val, $tempPath . '/'. $val);
            // }
        }

        // 削除された画像ファイル名をimgs配列から削除
        $res = array_diff((array)$imgs, (array)$delete);

        // 追加されたものをtempから本パスに移動
        foreach ($res as $key => $val) {
            if (!empty($val) && file_exists($tempPath . '/'. $val)) {
                //// @ba-ta 20140322 EXIFデータより画像の回転補正 ////
                $this->autoOrient($tempPath . '/'. $val);

                // サムネイル化の処理
                if ($thumFlag) {
                    // $this->makeThumbnail($realPath, $val);
                    $this->makeThumbnail($tempPath, $realPath, $val);
                }

                rename($tempPath . '/'. $val, $realPath . '/'. $val);
            }
        }

        return $res;
    }

    // サムネイル生成
    // public function makeThumbnail($realPath, $val)
    public function makeThumbnail($tempPath, $realPath, $val)
    {
        $imgCmd = '/usr/bin/convert -resize 120x90 ';
        $cmd = $imgCmd . ' ' . escapeshellcmd($tempPath . '/'. $val). ' ' . escapeshellcmd($realPath . '/thumb_'. $val);
        exec($cmd);
    }

    /**
     * ファイル情報のtempから本パスに移動・チェック(単体版)
     *
     * @access public
     * @param array $delete 削除するファイル名配列
     * @return $this
     */
    public function checkOne($img, $delete, $tempPath, $realPath, $thumFlag=false)
    {
        // 削除フラグのある画像を削除
        if (!empty($delete)) {
            // @ba-ta_20181127 ファイルアップロードの不具合対策＆S3移行のため、一時コメントアウト
            // if (file_exists($realPath  . '/' . $delete)) {
            //     rename($realPath . '/' . $delete, $tempPath . '/' . $delete);
            // }
            return '';
        } else if (!empty($img) && file_exists($tempPath . '/' . $img)) {
            $this->autoOrient($tempPath . '/'. $img);

            // サムネイル化の処理
            if ($thumFlag) {
                // $this->makeThumbnail($realPath, $img);
                $this->makeThumbnail($tempPath, $realPath, $img);
            }

            rename($tempPath . '/' . $img, $realPath . '/' . $img);
        }

        return $img;
    }
}

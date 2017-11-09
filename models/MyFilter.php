<?php
/**
 * 独自入力フィルタモデルクラス
 * 
 * @access  public
 * @author  川端洋平
 * @version 0.0.4
 * @since   2012/08/19
 */
class MyFilter
{
    /**
     * 共通フィルタリング処理
     * 
     * @access public
     * @param  array  $data   フィルタ、バリデーション処理をするデータ配列
     * @param  array  $params フィルタ、バリデーションルール配列
     * @return $this
     */   
    public static function filter($data, $param)
    {
        // フィルタリングルール
        $filters = empty($param['filters']) ? array() : (array)$param['filters'];
        
        // バリデーションルール
        $rules = empty($param['rules']) ? array() : (array)$param['rules'];
        
        // オプション
        $options = empty($param['options']) ? array() : (array)$param['options'];
        $options = $options + array(
            'breakChainOnFailure' => false,
            'presence'            => 'required',
            'allowEmpty'          => true,
            'escapeFilter'        => array('Callback', 'B::filter'),
            Zend_Filter_Input::NOT_EMPTY_MESSAGE => '未入力です(必須入力)'
        );
        
        // 処理
        $input = new Zend_Filter_Input($filters, $rules, $data, $options);
        // $input->setDefaultEscapeFilter(new Zend_Filter_HtmlEntities(ENT_COMPAT, 'UTF-8'));
        
        if (!$input->isValid()){
            $e = "＜入力エラー＞\n";
            foreach($input->getMessages() as $key => $val) {
                $e.= $key . ': ' . implode('、 ', $val). "\n";
            }
            throw new Exception($e);
        }

        return $input->getEscaped();
    }

    /**
     * 共通フィルタリング処理(改良版、JSONエンコード処理追加)
     * 
     * @access public
     * @param  array  $data        フィルタ、バリデーション処理をするデータ配列
     * @param  array  $params      フィルタ、バリデーションルール配列
     * @param  array  $jsonColumns 配列をJSONエンコードするkey(カラム)の配列
     * @return $this
     */   
    public static function filtering($data, $params, $jsonColumns=null)
    {
        if (empty($data) || empty($params)) { return $data; }

        $filters = empty($params['filters']) ? array() : (array)$params['filters']; // フィルタリングルール
        $rules   = empty($params['rules'])   ? array() : (array)$params['rules'];   // バリデーションルール
        $options = empty($params['options']) ? array() : (array)$params['options']; // オプション
        
        // optionにデフォルト値を結合
        $options = $options + array(
            'breakChainOnFailure' => false,
            'presence'            => 'optional',
            'allowEmpty'          => true,
            'escapeFilter'        => array('Callback', 'B::filter'),
            'notEmptyMessage'     => '未入力です(必須入力)',
        );
        
        //// フィルタ、バリデーション処理実行 ////
        $input = new Zend_Filter_Input($filters, $rules, $data, $options);
        
        if (!$input->isValid()){
            $e = "＜入力エラー＞\n";
            foreach($input->getMessages() as $key => $val) {
                $e.= $key . ': ' . implode('、 ', $val). "\n";
            }
            throw new Exception($e);
        }
        
        $res = $input->getEscaped();

        //// JSONエンコード処理 ////
        $res = B::encodeDataJson($res, $jsonColumns);
        
        return $res;
    }
}

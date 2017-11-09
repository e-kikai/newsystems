<?php
function smarty_modifier_auto_link($string, $type = 'url', $text = 'URL')
{
    // URL形式のチェック用文字列（正規表現）
    $regstr = "https?://[a-zA-Z0-9.-]{2,}(:[0-9]+)?(/[_.!~*a-zA-Z0-9;/?:@&=+$,%#-]+)?/?";
    switch ($type) {
        case 'url':
            return ereg_replace($regstr,"<a href=\"\\0\" target=\"_blank\" title=\"\\0\">\\0</a>", $string);
            break;
        case 'text':
            return ereg_replace($regstr,"[ <a href=\"\\0\" target=\"_blank\" title=\"\\0\">{$text}</a> ]", $string);
            break;
        default:
            return $string;
    }
}

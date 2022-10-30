<?php

$context = stream_context_create([
  'ssl' => [
      'verify_peer'      => false,
      'verify_peer_name' => false
  ]
]);

var_dump(file_get_contents('https://www.kkmt.co.jp/uploads/picture/content/20220405/506648/detail_IMG_6433_R.JPG', false, $context));

取引メッセージの投稿のお知らせ

{$company['company']} 様

あなたがWeb入札会に出品した商品について、
落札ユーザから取引メッセージの投稿がありました。

管理番号 : {$bid_machine.list_no}
{$bid_machine.name} {$bid_machine.maker} {$bid_machine.model}
{$_conf.site_uri}bid_detail.php?m={$bid_machine.id}

[ 落札ユーザ ]
お名前 : {$my_user.name}
会社名 : {$my_user.company}

[ 取引メッセージ ]
============================
{$comment}
============================

以下のリンクから、落札したユーザとの取引を行ってください。
{$_conf.site_uri}admin/my_bid_trades/show.php?m={$bid_machine.id}


今後とも、マシンライフWeb入札会をよろしくお願いいたします。


マシンライフ｜全機連の中古機械情報サイト
{$_conf.site_uri}

※ この自動通知メールは、マシンライフより自動的に送信されています。
※ このメールに返信しないようお願いいたします。

Copyright &copy; {$smarty.now|date_format:"%Y"} {$_conf.copyright} All Rights Reserved.
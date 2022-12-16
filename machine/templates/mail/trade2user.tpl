取引メッセージの投稿のお知らせ

{$my_user['company']} {$my_user['name']} 様

あなたがWeb入札会で落札した商品について、
出品会社の{$company.company}から取引メッセージの投稿がありました。

管理番号 : {$bid_machine.list_no}
{$bid_machine.name} {$bid_machine.maker} {$bid_machine.model}
{$_conf.site_uri}bid_detail.php?m={$bid_machine.id}

[ 出品会社 ]
{$company.company}

[ 取引メッセージ ]
============================
{$comment}
============================

出品会社への返信は、以下のリンクから行ってください。
{$_conf.site_uri}mypage/my_bid_trades/show.php?m={$bid_machine.id}

!!! 取引に関する注意事項 - 必ずお読みください !!!
・ 取引開始は、下見・入札期間終了後1週間以内にお願いいたします。
・ 発送方法、送料、梱包などの確認は必ず行ってください。
・ 入金確認後に商品の発送します。 商品到着後、受取確認・評価を行ってください。

今後とも、マシンライフWeb入札会をよろしくお願いいたします。


マシンライフ｜全機連の中古機械情報サイト
{$_conf.site_uri}

※ この自動通知メールは、マシンライフより自動的に送信されています。
※ このメールに返信しないようお願いいたします。

Copyright © {$smarty.now|date_format:"%Y"} {$_conf.copyright} All Rights Reserved.
{extends file='include/layout.tpl'}

{block 'header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}system.css" rel="stylesheet" type="text/css" />
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
      $(function() {
        //// 処理 ////
        $('button.delete').click(function() {
          var $_self = $(this);
          var data = {
            'id': $.trim($_self.val()),
          }

          // 送信確認
          if (!confirm("id : " + data['id'] +
              "\nこの入札会情報を削除します。よろしいですか。\n\n※ 終了した入札会の場合、\n「過去の入札会」からも削除されます。")) { return false; }

          $.post('/system/ajax/bid.php', {
            'target': 'system',
            'action': 'deleteOpen',
            'data': data,
          }, function(res) {
            if (res != 'success') {
              alert(res);
              return false;
            }

            // 登録完了
            alert('削除が完了しました');
            // location.href = '/system/bid_open_list.php';

            $_self.closest('tr').remove();
            return false;
          }, 'text');

          return false;
        });
      });
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}

  <table class='list contact'>
    <thead>
      <tr>
        <th class='id'>ID</th>
        <th class="title">タイトル</th>
        <th class="organizer">主催者名</th>
        <th class="">下見期間</th>
        <th class="entry_start_date">入札締切</th>
        <th class="condition">状況</th>
        <th class="delete">削除</th>
      </tr>
    </thead>

    {foreach $bidOpenList as $b}
      <tr>
        {if in_array($b.status, array('carryout', 'after'))}
          <td class='id' rowspan="2">{$b.id}</td>
          <td class='title' rowspan="2">
            <a href="/system/bid_open_form.php?id={$b.id}">{$b.title}</a>
          {else}
          <td class='id'>{$b.id}</td>
          <td class='title'>
            <a href="/system/bid_open_form.php?id={$b.id}">{$b.title}</a>
          </td>
        {/if}
        <td class='organizer'>{$b.organizer}</td>
        <td class=''>{$b.preview_start_date|date_format:'%Y/%m/%d'} ～ {$b.preview_end_date|date_format:'%m/%d'}</td>
        <td class=''>{$b.user_bid_date|date_format:'%m/%d %H:%M'}</td>
        <td class='condition'>{BidOpen::statusLabel($b.status)}</td>
        <td class='delete'>
          <button class="delete" value="{$b.id}">削除</a>
        </td>
      </tr>

      {if in_array($b.status, array('carryout', 'after'))}
        <tr>
          <td colspan="5">
            {if $b.user_bid_date > $smarty.const.BID_USER_START_DATE}
              {* 結果(
              <a href="system/my_bid_bids/total.php?o={$b.id}"><i class="fas fa-list"></i></a>|
              <a href="system/my_bid_bids/total.php?o={$b.id}&output=csv"><i class="fas fa-file-csv"></i></a>
              )
              会社集計(
              <a href="system/my_bid_bids/companies.php?o={$b.id}"><i class="fas fa-list"></i></a>|
              <a href="system/my_bid_bids/companies.php?o={$b.id}&output=csv"><i class="fas fa-file-csv"></i></a>
              )
              ユーザ集計(
              <a href="system/my_bid_bids/my_users.php?o={$b.id}"><i class="fas fa-list"></i></a>|
              <a href="system/my_bid_bids/my_users.php?o={$b.id}&output=csv"><i class="fas fa-file-csv"></i></a>
              )
              詳細アクセス(
              <a href="system/bid_detail_logs/?o={$b.id}"><i class="fas fa-list"></i></a>|
              <a href="system/bid_detail_logs/?o={$b.id}&output=csv"><i class="fas fa-file-csv"></i></a>
              )
              ウォッチ(
              <a href="system/my_bid_watches/?o={$b.id}"><i class="fas fa-list"></i></a>|
              <a href="system/my_bid_watches/?o={$b.id}&output=csv"><i class="fas fa-file-csv"></i></a>
              )
              入札(
              <a href="system/my_bid_bids/?o={$b.id}"><i class="fas fa-list"></i></a>|
              <a href="system/my_bid_bids/?o={$b.id}&output=csv"><i class="fas fa-file-csv"></i></a>
              ) *}

              <a href="system/my_bid_bids/total.php?o={$b.id}">
                <i class="fas fa-list"></i> 結果
              </a> |

              <a href="system/my_bid_bids/companies.php?o={$b.id}">
                <i class="fas fa-calculator"></i> 会社
              </a> |
              <a href="system/my_bid_bids/my_users.php?o={$b.id}">
                <i class="fas fa-calculator"></i> ユーザ
              </a> |
              <a href="system/my_bid_bids/genres.php?o={$b.id}">
                <i class="fas fa-calculator"></i>ジャンル
              </a> |
              <a href="system/my_bid_bids/genres.php?o={$b.id}&target=large_genre">
                <i class="fas fa-calculator"></i> 大ジャンル
              </a> |
              <a href="system/my_bid_bids/genres.php?o={$b.id}&target=xl_genre">
                <i class="fas fa-calculator"></i> 特大ジャンル</a> |
              <a href="system/bid_detail_logs/?o={$b.id}">
                <i class="fas fa-list"></i> 詳細
              </a> |
              <a href="system/my_bid_watches/?o={$b.id}">
                <i class="fas fa-list"></i> ウォッチ
              </a> |
              <a href="system/my_bid_bids/?o={$b.id}">
                <i class="fas fa-list"></i> 入札
              </a>

            {else}
              落札結果(
              <a href="system/bid_list.php?o={$b.id}">一覧</a>|
              <a href="system/bid_result.php?o={$b.id}&output=csv">CSV</a>
              )
              落札・出品集計(
              <a href="system/bid_result.php?o={$b.id}" target="_blank">一覧</a>|
              <a href="system/bid_result.php?o={$b.id}&output=csv&type=sum">CSV</a>|
              <a href="system/bid_result.php?o={$b.id}&output=pdf&type=sum" target="_blank">PDF</a>
              )
              <a href="system/bid_result.php?o={$b.id}&output=pdf&type=receipt" target="_blank">領収証PDF</a>
            {/if}
          </td>
        </tr>
      {/if}
    {/foreach}
  </table>
{/block}
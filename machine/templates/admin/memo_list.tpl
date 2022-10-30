{extends file='include/layout.tpl'}

{block 'header'}

  <script language="JavaScript" type="text/javascript">
    /// 変数の設定 ///
    var checkList = {
      'view_option_0': ['.view_option', ''],
      'view_option_1': ['.view_option', '非'],
      'view_option_2': ['.view_option', '商談'],
      'commission_0': ['.commission', ''],
      'commission_1': ['.commission', '可'],
      'location_address': ['.location', '本社'],
      {if !empty($company)}
        {foreach $company.offices as $o}
          'location_{$o@key}' : ['.location', '{$o.name}'],
        {/foreach}
      {/if}
    }

    {literal}
      $(function() {
        /// サムネイル画像の遅延読み込み（Lazyload） ///
        $('img.lazy').css('display', 'block').lazyload({
          effect: "fadeIn"
        });

        /// すべて表示：メーカー ///
        $('a.maker_all').click(function() {
          $('.maker_area input:checked').removeAttr('checked');
          $('.maker_area input:checkbox').first().change();
          return false;
        });

        /// すべて表示：ジャンル ///
        $('a.genre_all').click(function() {
          $('.genre_area input:checked').removeAttr('checked');
          $('.genre_area input:checkbox').first().change();
          return false;
        });

        /// ジャンル・メーカーで絞り込む ///
        $('.genre_area input:checkbox, .maker_area input:checkbox').change(function() {
          // 前処理、すべて表示
          $('.machine').show();

          // ジャンル絞り込み
          var searchGenre = $('.genre_area input:checked')
            .map(function() { return $(this).val(); })
            .get().join('|');

          if (searchGenre != '') {
            var re = new RegExp("([^0-9]|^)(" + searchGenre + ")([^0-9]|$)");
            // console.log("([^0-9]|^)(" + searchGenre + ")([^0-9]|$)");
            $('.machine').filter(function(i) {
              var flg = true;
              $(this).find('.genre_id').each(function() {
                if ($(this).text().match(re)) { flg = false; return false; }
              });

              return flg;
            }).hide();
          }

          // メーカー絞り込み
          var searchMaker = $('.maker_area input:checked')
            .map(function() { return $(this).val(); })
            .get().join('|');

          if (searchMaker != '') {
            var re = new RegExp('(^|\|)(' + searchMaker + ')($|\|)');
            $('.machine').filter(function(i) {
              return !$(this).find('.maker').text().match(re);
            }).hide();
          }

          // 色分けの再編
          $('.machine:visible').removeClass('even').removeClass('odd');
          $('.machine:visible:even').addClass('even');
          $('.machine:visible:odd').addClass('odd');

          // Lazyload用スクロール
          $(window).triggerHandler('scroll');
        });

        /*
    $('form.delete').submit(function() {
      if (confirm('この在庫機械情報を削除しますか？')) {
        return ture;

      } else {
        return false;
      }
    });
    */

        /// 一括処理 ///
        $('select.action').change(function() {
          var action = $(this).val();

          if (!action) { return false; }

          // チェック情報を取得
          var vals = $('input.m:visible:checked').map(function() {
            return $(this).val();
          }).get();

          if (!vals.length) {
            alert('処理を行いたい在庫機械情報にチェックを入れてください');
            $(this).val('');
            return false;
          }

          if (confirm($(
                'select.action option:selected').text() +
              "\nチェックした " + vals.length + "件 の在庫機械にこの処理を行いますか？"
            )) {
            // 処理を実行
            $.post('../ajax/admin_machine_list.php',
              {"target": "machine", "action": action, "data": vals},
              function(data) {
                location.href = 'admin/machine_list.php';
              }
            );
          } else {
            $(this).val('');
            return false;
          }
        });


        /// 一括チェック ///
        $('select.check').change(function() {
          var action = $(this).val();

          // チェックをリセット
          $('input.m').removeAttr('checked');

          if (action == 'all') {
            $('input.m:visible').attr('checked', 'checked');
          } else if (checkList[action]) {
            $('tr.machine:visible').each(function(i, val) {
              if ($(this).find(checkList[action][0]).text() == checkList[action][1]) {
                $(this).find('input.m').attr('checked', 'checked');
              }
            });
          }
        });
      });
    </script>
    <style type="text/css">
      table.memo {
        width: 100%;
      }

      .memo td button {
        width: 60px;
      }

      .memo .change,
      .memo .re,
      .memo .type {
        width: 64px;
        text-align: center;
      }

      .memo .datetime {
        width: 120px;
      }

      .memo td.datetime {
        text-align: right;
      }

      .memo .user {
        width: 120px;
      }

      .memo td.user {
        text-align: left;
      }
    </style>
  {/literal}
{/block}

{block 'main'}

  <a href="admin/memo_form.php">新規登録</a>

  <form class="" method="post" action="admin/machine_delete.php">
    <table class="memo list">
      <tr>
        <th class="change"></th>
        <th class="re"></th>

        <th class="type">タイプ</th>
        <th class="datetime">日時</th>
        <th class="user">登録者</th>
        <th class="contents">内容</th>
      </tr>
      <tr class="memo">
        <td class="change"><button class="change_button">変更</button></td>
        <td class="re"><button class="re_button">返信</button></td>

        <td class="type">
          <div class"type">買引合</div>
        </td>

        <td class="datetime">2012/08/30 15:32</td>
        <td class="user">堀川</td>
        <td class="contents">梅田鉄工所 山本 アマダベンダー他買取依頼</th>
      </tr>

      <tr class="memo">
        <td class="change"></td>
        <td class="re"><button class="re_button">返信</button></td>

        <td class="type">
          <div class"type">買決定</div>
        </td>

        <td class="datetime">2012/08/30 13:32</td>
        <td class="user">川端</td>
        <td class="contents">梅田鉄工所 山本 アマダベンダー他買取依頼</th>
      </tr>
    </table>
{/block}
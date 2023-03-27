{extends file='include/layout.tpl'}

{block 'header'}

  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_list.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
      $(function() {
        /// 代理ログイン ///
        $('form.login_form').submit(function() {
          return confirm(names(this) + "\n\nこのユーザで代理ログインします。\nログイン後、ユーザのマイページに移動します。\n\nよろしいですか。");
        });

        /// 凍結 ///
        $('form.freeze_form').submit(function() {
          return confirm(names(this) + "\n\nこのユーザを凍結します。\n凍結したユーザは、入札が行えなくなります。\n\nよろしいですか。");
        });

        /// 凍結解除 ///
        $('form.freeze_unlock_form').submit(function() {
          return confirm(names(this) + "\n\nこのユーザの凍結を解除します。\n\nよろしいですか。");
        });
      });

      function names(base) {
        var $_parent = $(base).closest('tr');

        var id = $.trim($_parent.find('td.id').text());
        var company = $.trim($_parent.find('td.company').text());
        var name = $.trim($_parent.find('td.user_name').text());

        return id + " : " + company + " " + name;
      }
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}

  {if empty(count($my_users))}
    <div class="alert alert-warning col-8 mx-auto">
      <i class="fas fa-users"></i> 入札会ユーザは、まだありません。
    </div>
  {/if}

  {*** ページャ ***}
  {include file="include/pager.tpl"}

  <div class="table_area max_area">
    <table class="machines list">
      {foreach $my_users as $mu}
        {if $mu@first}
          <tr>
            <th class="id">ID</th>
            <th class="user_name">会社名</th>
            <th class="user_name">氏名</th>
            <th class="uniq_account">都道府県</th>
            <th class="website">確認</th>
            <th class="website">案内</th>
            <th class="uniq_account">アカウント</th>

            <th class="system_button sepa2">代理</th>
            {*
            <th class="website">ログ</th>
            *}

            {*
            <th class="website">変更</th>
            *}
            <th class="system_button">mail</th>

            <th class="created_at">登録日時</th>
            <th class="system_button">凍結</th>
          </tr>
        {/if}

        <tr>
          <td class="id text-right">{$mu.id}</td>
          <td class="user_name">{$mu.company}</td>
          <td class="user_name">{$mu.name}</td>
          <td class="uniq_account">{$mu.addr_1}</td>
          <td class="website">{if !empty($mu.checkd_at)}◯{/if}</td>
          <td class="website">{if !empty($mu.mailuser_flag)}◯{/if}</td>

          <td class="uniq_account">{$mu.uniq_account}</td>

          <td class="system_button sepa2">
            {if !empty($mu.checkd_at)}
              <form method="post" action="/system/my_users/login_do.php" class="login_form">
                <input type="hidden" name="id" value="{$mu.id}" />
                <button class="system_login btn btn-primary btn-sm"><i class="fas fa-right-to-bracket"></i></button>
              </form>
            {/if}
          </td>
          {*
          <td class="website">
            <a class="system_login btn btn-light" href="system/detail_logs/?u={$mu.id}"><i class="fas fa-road"></i></a>
          </td>
          *}

          {*
          <td class="website">
            <button class="change btn btn-warning"><i class="fas fa-circle-user"></i></button>
          </td>
          *}
          <td class="system_button">
            <a class="system_login btn btn-secondary btn-sm" href="mailto:{$mu.mail}"><i class="fas fa-paper-plane"></i></a>
          </td>


          <td class="created_at">{$mu.created_at|date_format:'%Y:%m/%d %H:%M'}</td>
          <td class='system_button'>
            {if empty($mu.freezed_at)}
              <form method="post" action="/system/my_users/freeze_do.php" class="freeze_form">
                <input type="hidden" name="id" value="{$mu.id}" />
                <button class="btn btn-info btn-sm" value="{$c.id}"><i class="fas fa-snowflake"></i></button>
              </form>
            {else}
              <form method="post" action="/system/my_users/freeze_unlock_do.php" class="freeze_unlock_form">
                <input type="hidden" name="id" value="{$mu.id}" />
                <button class="btn btn-secondary btn-sm" value="{$c.id}">解</button>
              </form>
            {/if}
          </td>

        </tr>
      {/foreach}
    </table>
  </div>
  {*** ページャ ***}
  {* {include file="include/pager.tpl"} *}

{/block}
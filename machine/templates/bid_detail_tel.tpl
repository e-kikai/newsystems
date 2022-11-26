{extends file='include/layout.tpl'}

{block name='header'}
  <meta name="robots" content="noindex, nofollow" />

  <script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}same_list.js"></script>
  <script type="text/javascript" src="{$_conf.site_uri}{$_conf.js_dir}detail.js"></script>
  <link href="{$_conf.site_uri}{$_conf.css_dir}detail.css" rel="stylesheet" type="text/css" />
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />
  <link href="{$_conf.site_uri}{$_conf.css_dir}bid_mylist.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javaScript">
    </script>
    <style type="text/css">
      /*** for window style ***/
      body {
        background-image: none;
      }

      .main_container {
        width: 600px;
      }

      header,
      footer,
      .header_menu,
      .pankuzu,
      h1 {
        display: none;
      }

      .center_container {
        width: 100%;
      }

      table.spec.form {
        width: 442px;
      }

      table.spec.form th {
        background: #556B2F;
        width: 118px;
      }

      a.contact {
        width: 248px;
        height: 50px;
        font-size: 28px;
        line-height: 50px;
        text-align: center;
        border-radius: 4px;
      }

      a.contact-long {
        font-size: 16px;
      }

      table.form td {
        position: relative;
      }

      td.tel {
        color: #C00;
        font-size: 20px;
        text-align: left;
      }

      p.comment {
        margin: 16px auto;
        font-size: 15px;
      }
    </style>
  {/literal}
{/block}

{block name='main'}

  {if !empty($machine)}

    <p class="comment">
      ご連絡の際に、「マシンライフ {$bidOpen.title}を見て」とお伝え下さい。
    </p>

    <div class='detail_container'>
      <table class="spec bid-table">
        <tr class="">
          <th>出品番号</th>
          <td class="bid_machine_id">{* {$machine.id} - *}{$machine.list_no}</td>

          <th>最低入札金額</th>
          <td class="detail_min_price">{$machine.min_price|number_format}円</td>
        </tr>
      </table>

      <div class="img_area">
        <table class="spec">
          <tr class="">
            <th>商品名</th>
            <td>{$machine.name} {$machine.maker} {$machine.model}</td>
          </tr>
          <tr class="">
            <th>出品会社</th>
            <td>
              <a href='company_detail.php?c={$machine.company_id}' target="_blank">{$company.company}</a>
            </td>
          </tr>
          <tr class="">
            <th>お問い合わせTEL</th>
            <td class="tel">
              {$company.contact_tel|escape|replace:',':",<br />" nofilter}
            </td>
          </tr>
          <tr class="">
            <th>担当者</th>
            <td>{$company.officer}</td>
          </tr>
          <tr class='infos opening'>
            <th>営業時間</th>
            <td>{$company.infos.opening}</td>
          </tr>

          <tr class='infos holiday'>
            <th>定休日</th>
            <td>{$company.infos.holiday}</td>
          </tr>
        </table>
      </div>
      <br class="clear" />

    {else}
      <div class="error_mes">
        指定された方法では、入札会商品情報の特定ができませんでした<br />
        誠に申し訳ありませんが、再度ご検索のほどよろしくお願いします
      </div>
    {/if}

{/block}
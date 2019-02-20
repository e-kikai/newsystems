<tbody class="machine">
<tr class='separator'><td colspan='8'></td></tr>
<tr>
  <td class='checkbox' rowspan='2'>
    <input type='checkbox' class='machine_check' value='{{>id}}' />
  </td>
  <td class='img' rowspan='2'>
    {{if !deleted_at}}
      <a href="/machine_detail.php?m={{>id}}" target="_blank">
        <div class='name'>{{>name}}</div>
        {{if top_img}}
          <img class="top_image hover lazy" src='imgs/blank.png'
            data-original="{{>media_dir}}machine/thumb_{{>top_img}}"
            data-source="{{>media_dir}}machine/{{>top_img}}"
            alt="中古{{>name}} {{>maker}} {{>model}}" />
        {{else}}
          <img class='top_image noimage' src='./imgs/noimage.png'
            alt="中古{{>name}} {{>maker}} {{>model}}" />
        {{/if}}
      </a>
    {{else}}
      <div class='name'>{{>name}}</div>
    {{/if}}
  </td>
  <td class='maker'>{{>maker}}</td>
  <td class='model'>{{>model}}</td>
  <td class='year'>{{>year}}</td>
  <td class='locations'>
    <div class="addr1">{{>addr1}}</div>
    {{if location}}(<span class="location">{{>location}}</span>){{/if}}
  </td>
  <td class='company_info'>
    <a href='/company_detail.php?c={{>company_id}}' target="_blank">{{>company}}</a>
    <div class='tel'>TEL: {{>contact_tel}}</div>
    <div class='fax'>FAX: {{>contact_fax}}</div>
  </td>
  <td class='buttons'>
    {{if !deleted_at}}
      {{if contact_mail}}
        <a class='contact' href='/contact.php?m={{>id}}' target="_blank">問い<br />合わせ</a>
      {{else}}
        <div class='contact none'>問い<br />合わせ</div>
      {{/if}}

      <button class='mylist' value='{{>id}}'>マイリスト<br />追加</button>
    {{else}}売却日: {{>deleted_at}}{{/if}}
  </td>
</tr>

<tr class='machine_spec'>
  <td class='spec' colspan='6'>
    {{if bid_open_id}}
      <a href="bid_detail.php?m={{>bid_machine_id}}" class="label bid" target="_blank">
        {{>bid_title}} 出品中
      </a>
    {{/if}}

    {{if capacity && capacity_label}}
      <div class="label capacity">{{>capacity_label}}:{{>capacity}}{{>capacity_unit}}</div>
    {{/if}}

    {{if view_option == 2}}<div class="label vo2">商談中</div>{{/if}}
    {{if commission == 1}}<div class="label commission">試運転可</div>{{/if}}
    {{for _render_pdfs}}
      <a href="{{>media_dir}}machine/{{>data}}"
        class="label pdf" target="_blank">PDF:{{>key}}</a>
    {{/for}}

    {{if catalog_id}}
    <a href="http://catalog.zenkiren.net/catalog_pdf.php?id={{>catalog_id}}"
      class="label catalog" target="_blank">電子カタログ(会員のみ公開)</a>
    {{/if}}

    {{>spec}}
  </td>
</tr>
</tbody>

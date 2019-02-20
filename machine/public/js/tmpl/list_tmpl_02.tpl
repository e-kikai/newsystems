<tr class="machine">
  <td class='checkbox'>
    <input type='checkbox' class='machine_check' name='machine_check' value='{{>id}}' />
  </td>
  <td class='img'>
    {{if !deleted_at}}
      <div class='img_area'>
        <a href='/machine_detail.php?m={{>id}}' target="_blank">
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
      </div>
    {{/if}}
  </td>
  <td class="tdname">
    <a href='/machine_detail.php?m={{>id}}' target="_blank">{{>name}}</a>
  </td>
  <td class='maker'>{{>maker}}</td>
  <td class='model'>{{>model}}</td>
  <td class='year'>{{>year}}</td>

  <td class=''>
    <div>{{>spec}}</div>

    {{if _render_youtube}}
      <a href="javascript:void(0)" data-youtubeid="{{>_render_youtube}}" class="label movie">動画</a>
    {{/if}}

    {{if bid_open_id}}
      <a href="bid_detail.php?m={{>bid_machine_id}}" class="label bid" target="_blank">
        Web入札会出品中
      </a>
    {{/if}}

    {{if view_option == 2}}<div class="label vo2">商談中</div>{{/if}}
    {{if commission == 1}}<div class="label commission">試運転可</div>{{/if}}
    {{for _render_pdfs}}
      <a href="{{>media_dir}}machine/{{>data}}"
        class="label pdf" target="_blank">PDF:{{>key}}</a>
    {{/for}}

    {{if catalog_id}}
      <a href="http://catalog.zenkiren.net/catalog_pdf.php?id={{>catalog_id}}" class="label catalog" target="_blank">電子カタログ</a>
    {{/if}}
  </td>

  <td class="company">
    <a href='/company_detail.php?c={{>company_id}}' target="_blank">{{>company}}</a>
    <div class="addr1">{{>addr1}}</div>
    {{if location}}(<span class="location">{{>location}}</span>){{/if}}
  </td>
  <td class='buttons'>
    {{if !deleted_at}}
      {{if contact_mail}}
        <a class='contact' href='/contact.php?m={{>id}}' target="_blank">問い合わせ</a>
      {{else}}
        <div class='contact none'>問い合わせ</div>
      {{/if}}

      <button class='mylist' value='{{>id}}'>マイリスト</button>
    {{else}}売却日: {{>deleted_at}}{{/if}}
  </td>
</tr>

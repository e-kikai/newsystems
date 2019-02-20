<tbody class="img_machine">
  <tr>
    <td class='checkbox'>
      <input type='checkbox' class='machine_check' name='machine_check' value="{{>id}}" />
    </td>
    <td class='data'>
      <div class='status'>
        <a class='zoom' href='/machine_detail.php?m={{>id}}'  target="_blank">
          {{>name}} {{>maker}} {{>model}}
        </a>
        {{if year}}<div class='year'>{{>year}}年製</div>{{/if}}

        <a href='/company_detail.php?c={{>company_id}}'  target="_blank">{{>company}}</a>
        <div class='tel'>TEL: {{>contact_tel}}</div>
        <div class='fax'>FAX: {{>contact_fax}}</div>

        {{if !deleted_at}}
          {{if contact_mail}}
            <a class='contact' href='/contact.php?m={{>id}}'  target="_blank">問い合わせ</a>
          {{else}}
            <div class='contact none'>問い合わせする</div>
          {{/if}}

          <button class='mylist' value='{$m.id}'>マイリスト</button>
        {{else}}売却日: {{>deleted_at}}{{/if}}
      </div>

      <div class='image_carousel'>
        <ul class='imgs'>
          <li><a class='zoom' href='/machine_detail.php?m={{>id}}'  target="_blank">
            <img class="top_image lazy" src='imgs/blank.png' data-original="{{>media_dir}}machine/{{>top_img}}" alt="" />
          </a></li>

          {{for _render_imgs}}
            <li><a class='zoom' href='/machine_detail.php?m={{>id}}'  target="_blank">
              <img class="lazy" src='imgs/blank.png' data-original="{{>media_dir}}machine/{{>img}}" alt="" />
            </a></li>
          {{/for}}

          {{if _render_youtube}}
            <li class="youtube"><button class="movie" value="{{>_render_youtube}}">動画の再生</button></li>
          {{/if}}
          {{if _render_imgs[2]}}<img class='triangle' src='./imgs/triangle2.gif' />{{/if}}
        </ul>
      </div>

      {{if _render_imgs[2]}}
        <div class="scrollRight"></div><div class="scrollLeft"></div>
      {{/if}}
    </td>
  </tr>
  <tr class='separator'><td colspan='2'></td></tr>
</tbody>

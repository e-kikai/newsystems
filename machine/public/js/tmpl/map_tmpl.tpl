<div class='map_machine'>
  <a href="/machine_detail.php?m={{>id}}" class="link"  target="_blank">
      <div class="name">{{>name}}</div>
      <div class="maker">{{>maker}}</div>
      <div class="model">{{>model}}</div>
  </a>

  <a href="/machine_detail.php?m={{>id}}" class="company_info"  target="_blank">
    {{if top_img}}
      <img class="top_image lazy" src='imgs/blank.png' data-original="{{>media_dir}}machine/thumb_{{>top_img}}" alt="" />
    {{else}}
      <img class='top_image noimage' src='./imgs/noimage.png' />
    {{/if}}
  </a>

  <div class="status">
    {{if !deleted_at}}
      {{if contact_mail}}
        <a class='contact' href="/contact.php?m={{>id}}"  target="_blank">問い合わせ</a>
      {{else}}
        <div class='contact none'>問い合わせ</div>
      {{/if}}

      <button class='mylist' value='{{>id}}'>マイリスト</button>
    {{else}}売却日: {{>deleted_at}}{{/if}}
  </div>

  <br class="clear" />
</div>

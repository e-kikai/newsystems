<span class="pcount">絞り込み結果 {{>num}}件</span>
{{if pageNum > 1}}
  <span class="list">
    <a class="jump" href="{{>firstUri}}"><<先頭</a>
    <a class="jump" href="{{>firstUri}}"><前へ</a>
    {{for pageArray}}
      <a class="num{{if !#index}} current{{/if}} p_{{>#index+1}}"
        href="{{>#data}}">{{>#index+1}}</a>
    {{/for}}
    <a class="jump" href="{{>lastUri}}">次へ></a>
    <a class="jump" href="{{>lastUri}}">最終>></a>
  </span>
  
  <select class="limit">
    <option value="30">▼表示件数▼</option>
    <option value="10">10件</option>
    <option value="30">30件</option>
    <option value="50">50件</option>
    <option value="100">100件</option>
    <option value="200">200件</option>
  </select>
{{/if}}

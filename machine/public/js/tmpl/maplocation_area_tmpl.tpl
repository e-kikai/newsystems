<div class="filter_area maplocation_area {{>deep}}">
  {{if now}}
    <input type="hidden" class="now_state" value="{{>now}}" />
  {{/if}}
  <li>
    <span class="area_label">{{>label}}</span>
  </li>
  <li>
    <a class="state_all">&lt; 全国表示</a>
  </li>
  {{if now}}
    <li><a class="remove">&lt; {{>now}}</a></li>
  {{/if}}
  {{for data}}
    <li><a class="move">{{>#data}}</a></li>
  {{/for}}
</div>

<div class="chat_message mb-1 p-3 {$message.player} bg-gradient">

  <div class=" player fw-bold fs-6">
    {if $message.player == "user"}
      あなた
    {else}
      ボット
    {/if}
  </div>


  {if !empty($machines)}
    <div class="machines mx-1">
      {foreach $machines as $key => $ma}
        {include "../../include/same_machine.tpl" machine=$ma r="cht_res" ga_key="chatbot"}
      {/foreach}
      <br style="clear: both;" />
    </div>
  {/if}

  <div class=" content mx-1 p-2">
    {$message.content|escape|default:""|nl2br nofilter}
  </div>

  {if !empty($message.selectors)}
    <div class="onetime">
      {foreach $message.selectors as $key => $se}
        {if !empty($key) && !empty($se)}
          <button type="button" class="get_query btn btn-success m-1" data-json="{$se|json_encode}">
            {$key}
          </button>
        {/if}
      {/foreach}
    </div>
  {/if}
</div>
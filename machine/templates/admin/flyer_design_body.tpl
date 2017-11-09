<div class="around_area" style="max-width: 960px; margin: 0 auto; padding: 20px;background: #DDD;">
  <div class="main_area" style="background: #FFF;padding: 20px;">
    {if !empty($flyer.design_top_img)}
      <img class="top_img" src="{$_conf.media_dir}/flyer/{$flyer.design_top_img}" style="display: block;max-width: 100%;margin: 0 auto 16px auto;"/>
    {/if}
    <div class="main_text" style="font-size: 17px;margin: 16px auto;">{$flyer.design_main_text|nl2br nofilter}</div>
    <div class="sub_text" style="font-size: 14px;margin: 16px auto;">{$flyer.design_sub_text|nl2br nofilter}</div>

    <div class="button_area" style="margin: 32px auto;text-align: center;">
      <a class="button" href="{$flyer.design_url}" target="_blank" style="display: inline-block; font-size: 19px; text-decoration: none; color: #FFF; background: #3434da; border: 2px solid #00A; border-radius: 4px; padding: 0 64px; height: 64px; text-align: center; line-height: 64px;">
      {$flyer.design_button}
    </a>
    </div>

    <hr class="bottom_hr" style="margin: 32px auto;" />

    <div class="bottom_text" style="font-size: 14px;margin: 16px auto;">{$flyer.design_bottom_text|escape|nl2br nofilter}</div>

    <div class="sub_imgs">
      {if !empty($flyer.design_img_01)}
        <a href="{$_conf.media_dir}/flyer/{$flyer.design_img_01}" target="_blank"><img class="sub_img" src="{$_conf.media_dir}/flyer/{$flyer.design_img_01}" style="width: 32%;vertical-align: top;" /></a>
      {/if}
      {if !empty($flyer.design_img_02)}
        <a href="{$_conf.media_dir}/flyer/{$flyer.design_img_02}" target="_blank"><img class="sub_img" src="{$_conf.media_dir}/flyer/{$flyer.design_img_02}" style="width: 32%;vertical-align: top;" /></a>
      {/if}
      {if !empty($flyer.design_img_03)}
        <a href="{$_conf.media_dir}/flyer/{$flyer.design_img_03}" target="_blank"><img class="sub_img" src="{$_conf.media_dir}/flyer/{$flyer.design_img_03}" style="width: 32%;vertical-align: top;" /></a>
      {/if}

    </div>
  </div>

  <div style="margin:64px;">
    ※ このメールは返信不可です。<br />
    メールへの返信は、<a href="mailto:{$flyer.from_mail}" style="text-decoration:none;">{$flyer.from_name}</a>へよろしくお願いいたします。
  </div>

  <div style="margin:0 64px;">
    <a href="*|UNSUB|*" style="text-decoration:none;">配信停止はこちら</a>
  </div>
</div>

<div class="rewards" style="margin-top:64px;text-align:center;">*|REWARDS|*</div>

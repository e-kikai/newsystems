{extends file='include/layout.tpl'}

{block name='header'}
  <meta name="robots" content="noindex, nofollow" />

  <link href="{$_conf.site_uri}{$_conf.css_dir}same_list.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
      window.onload = () => {
        /// クリックイベントハンドラ ///
        chatbot.addEventListener("click", (e) => {
          let elem = e.target;
          if (elem.classList.contains("get_query")) {
            // ユーザメッセージ表示
            user_message(elem.textContent);

            let datas = JSON.parse(elem.getAttribute("data-json"));
            get_message(datas);
          }
        }, true);

        loading.hidden = true;
      };

      /// ajaxでメッセージを取得 ///
      async function get_message(datas) {
        try {
          // Loading-アニメーション
          loading.hidden = false;

          const url = "/_pg/chatbot/get_message.php?" + new URLSearchParams(datas);
          const res = await fetch(url);

          if (res.ok) { // 1. 通信処理に成功した場合の対応

            // 選択肢の要素などを削除
            const elems = document.querySelectorAll('.onetime');
            if (elems) {
              elems.forEach((e) => { e.remove() });
            }

            text = await res.text();
            timeline.innerHTML += text;
          }
        } catch (error) {
          console.error({ error }); // 2. 通信処理に失敗した場合は、エラーメッセージを表示
        } finally { // 3. await完了後に、Loading処理を終了
          loading.hidden = true;
        }
      }

      /// ユーザメッセージの表示 ///
      function user_message(content) {
        te = user_template.querySelector(".chat_message").cloneNode(true);
        te.querySelector(".content").textContent = content;
        timeline.appendChild(te);
      }
    </script>
    <style type="text/css">
      .chat_message.user {
        background-color: palegreen;
      }

      .chat_message.bot {
        background-color: paleturquoise;
      }
    </style>
  {/literal}
{/block}

{block 'main'}
  <div class="row">
    <div class="offset-1 col-10 p-3" id="chatbot">
      <div class="text-end mb-1">
        <a href="/_pg/chatbot/" class="btn btn-secondary btn-sm">
          <i class="fa fa-rotate-right"></i> リセット
        </a>
      </div>
      <div class="timeline" id="timeline">
        {foreach $messages as $me}
          {include "./_message.tpl" message=$me}
        {/foreach}

        {*
        <button type="button" class="get_query btn btn-success" data-query="add_query"
          data-json_data="{literal}{'large_genre': 1}{/literal}">
          テスト
        </button>
        *}
      </div>
      <div id="loading" class="text-center fs-1 text-primary p-2" hidden>
        <i class="fas fa-circle-notch fa-spin"></i>
      </div>

      <div class="form_area"></div>
    </div>
  </div>

  <div id="user_template" class="d-none">
    {include "./_message.tpl" message=["player"=>"user","content"=>"..."] machines=[]}
  </div>
{/block}
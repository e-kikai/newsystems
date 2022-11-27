{extends file='include/layout.tpl'}

{block name='header'}
  <meta name="robots" content="noindex, nofollow" />

  <script src="https://cdn.jsdelivr.net/npm/fetch-jsonp@1.1.3/build/fetch-jsonp.min.js"></script>
  <script src="https://www.google.com/recaptcha/api.js" async defer></script>

  <link href="{$_conf.site_uri}{$_conf.css_dir}mypage.css" rel="stylesheet" type="text/css" />

  {literal}
    <script type="text/javascript">
      $(function() {
        /// 住所検索 ///
        let search = document.getElementById('search');
        search.addEventListener('click', () => {

          let api = 'https://zipcloud.ibsnet.co.jp/api/search?zipcode=';
          let error = document.getElementById('error');
          let zip = document.getElementById('zip');
          let addr_1 = document.getElementById('addr_1');
          let addr_2 = document.getElementById('addr_2');
          let addr_3 = document.getElementById('addr_3');
          let param = zip.value.replace("-", ""); //入力された郵便番号から「-」を削除
          let url = api + param;

          fetchJsonp(url, {
              timeout: 10000,
            })
            .then((response) => {
              error.textContent = '';
              return response.json();
            })
            .then((data) => {
              if (data.status === 400) { //エラー時
                error.textContent = data.message;
              } else if (data.results === null) {
                error.textContent = '郵便番号から住所が見つかりませんでした。';
              } else {
                addr_1.value = data.results[0].address1;
                addr_2.value = data.results[0].address2;
                addr_3.value = data.results[0].address3;

                addr_3.focus();
              }
            })
            .catch((ex) => { //例外処理
              console.log(ex);
            });
        }, false);
      });
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}
  <form class="login" method="post" action="/mypage/mypage/update_do.php">
    <div class="d-grid gap-2 col-6 mx-auto mt-3">
      <dl>
        <dt><label for="mail" class="form-label">氏名<span class="required">(必須)</span></label></dt>
        <dd><input type="text" name="data[name]" id="name" class="form-control" value="{$data.name}" placeholder="お名前"
            required /></dd>
        <dt><label for="company" class="form-label">会社名</label></dt>
        <dd><input type="text" name="data[company]" id="company" class="form-control" value="{$data.company}"
            placeholder="" /></dd>

        <dt><label for="tel" class="form-label">TEL<span class="required">(必須)</span></label></dt>
        <dd><input type="tel" name="data[tel]" id="tel" class="form-control" value="{$data.tel}" placeholder="" /></dd>
        <dt><label for="fax" class="form-label">FAX</label></dt>
        <dd><input type="tel" name="data[fax]" id="fax" class="form-control" value="{$data.fax}" placeholder="" /></dd>


        <dt><label for="zip" class="form-label">郵便番号<span class="required">(必須)</span></label></dt>
        <dd>
          <input type="text" name="data[zip]" id="zip" class="form-control" value="{$data.zip}" placeholder="" />
          <button id="search" type="button" id="zip_search" class="btn btn-secondary">
            <i class="fas fa-magnifying-glass-location"></i> 住所検索
          </button>
          <p id="error"></p>
        </dd>
        <dt><label for="addr_1" class="form-label">住所(都道府県)<span class="required">(必須)</span></label></dt>
        <dd>
          <input type="text" name="data[addr_1]" id="addr_1" class="form-control" value="{$data.addr_1}" placeholder="" />
        </dd>
        <dt><label for="addr_2" class="form-label">住所(市区町村)<span class="required">(必須)</span></label></dt>
        <dd>
          <input type="text" name="data[addr_2]" id="addr_2" class="form-control" value="{$data.addr_2}" placeholder="" />
        </dd>
        <dt><label for="addr_3" class="form-label">住所(番地その他)<span class="required">(必須)</span></label></dt>
        <dd>
          <input type="text" name="data[addr_3]" id="addr_3" value="{$data.addr_3}" class="form-control" placeholder="" />
        </dd>

        <dt><label for="addr_3" class="form-label">マシンライフからの案内メール</label></dt>
        <dd>
          <input class="form-check-input" type="radio" name="data[check]" id="check_true" value="1" checked>
          <label class="form-check-label" for="check_true">受信する</label>
          <input class="form-check-input" type="radio" name="data[check]" id="check_false" value="0">
          <label class="form-check-label" for="check_false">受信しない</label>
        </dd>
      </dl>

      <button type="submit" name="submit" class="submit btn btn-primary" value="login">
        <i class="fas fa-user-plus"></i> ユーザ情報を変更する
      </button>
    </div>
  </form>
{/block}
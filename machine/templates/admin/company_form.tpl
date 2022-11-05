{extends file='include/layout.tpl'}

{block 'header'}
  <link href="{$_conf.site_uri}{$_conf.css_dir}admin_form.css" rel="stylesheet" type="text/css" />

  <!-- Google Maps APL ver 3 -->
  <script src="https://maps.google.com/maps/api/js?sensor=false&language=ja" type="text/javascript"></script>

  {literal}
    <script language="JavaScript" type="text/javascript">
      $(function() {
        // フォームチェック
        $('form.member').submit(function() {
          if (!Modernizr.input.required) {
            var result = true;
            $('input[required]').each(function() {
              if ($(this).val() == '') {
                alert('必須項目が入力されていません。');
                result = false;
              }
            });
            if (!result) { return false; }
          }
        });


        //// 営業所フォーム追加 ////
        $('button#offices_add').click(function() {
          $(this).before(
            $('<div class="office">').html($('.office_template').html())
          );

          return false;
        }).click();

        //// 郵便番号 -> 住所(営業所Ver.) ////
        // $('button.zip2address').live('click', function() {
        $(document).on('click', 'button.zip2address', function() {
          var $_parent = $(this).parent('.office');
          var zip = $_parent.find('input.zip').val();

          if (!zip) {
            alert('郵便番号が入力されていません');
            return false;
          }

          $.getJSON('../ajax/admin_genre.php',
            {"target": "machine", "action": "zip2address", "data": zip},
            function(json) {
              if (json.state == '') {
                alert('郵便番号から住所を取得できませんでした');
                return false;
              }

              // $('input.address').val(json).focus();
              $_parent.find('input.addr1').val(json.state);
              $_parent.find('input.addr2').val(json.city);
              $_parent.find('input.addr3').val(json.address).focus();
              return false;
            }
          );

          return false;
        });

        //// 営業所の緯度経度の取得 ////
        // ジオコーディング
        gc = new google.maps.Geocoder();

        // $('input.addr3').live('change', function() {
        $(document).on('change', 'input.addr3', function() {
          var $_parent = $(this).parent('.office');

          // 緯度経度の初期化
          $_parent.find('input.lat').val();
          $_parent.find('input.lng').val();

          if ($(this).val() == '') { return false; }

          // 住所
          var pure_addr = $_parent.find('input.addr1').val() + ' ' + $_parent.find('input.addr2').val() + ' ' + $(
            this).val();

          gc.geocode({'address': pure_addr}, function(results, status) {
          // 取得できなかった場合は無視
          if (status != 'OK') { return false; }

          $_parent.find('input.lat').val(results[0].geometry.location.lat());
          $_parent.find('input.lng').val(results[0].geometry.location.lng());

          return false;
        });
      });


      //// 営業所の削除 ////
      // $('.office a.delete').live('click', function() {
      $(document).on('click', '.office a.delete', function() {
        $(this).parent('.office').remove();
        return false;
      });
      $('.office a.delete').button();
      });

      //// アップロード後のコールバック ////
      function upload_callback(target, data) {
        if (target == "imgs") {
          $.each(data, function(i, val) {
            var h =
              '<div class="img">' +
              '<label><input name="imgs_delete[]" type="checkbox" value="' + val.filename + '" />削除</label><br />' +
              '<a href="/media/tmp/' + val.filename + '" target="_blank">' +
              '<img src="/media/tmp/' + val.filename + '" />' +
              '</a>' +
              '<input name="imgs[]" type="hidden" value="' + val.filename + '" />'
            '</div>';
            $('.imgs .upload_img').append(h);
          });
        } else if (target == "top_img") {
          $.each(data, function(i, val) {
            var h =
              '<div class="img">' +
              '<label><input name="top_img_delete" type="checkbox" value="' + val.filename + '" />削除</label><br />' +
              '<a href="/media/tmp/' + val.filename + '" target="_blank">' +
              '<img src="/media/tmp/' + val.filename + '" />' +
              '</a>' +
              '<input name="top_img" type="hidden" value="' + val.filename + '" />'
            '</div>';
            $('.top_img .upload_img').html(h);
          });
        }
      }
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}

  <form class="member" method="post" action="admin/company_do.php" enctype="multipart/form-data">

    <div class="form_comment">
      <span class="alert">※</span>　以下の項目変更は、全機連の事務局に連絡してください
    </div>

    <table class="member form">
      <tr class="company">
        <th>会社名</th>
        <td>{$company.company}</td>
      </tr>

      <tr class="company_kana">
        <th>会社名(カナ)</th>
        <td>{$company.company_kana}</td>
      </tr>

      <tr class="company">
        <th>代表者名</th>
        <td>{$company.representative}</td>
      </tr>

      <tr class="zip">
        <th>〒</th>
        <td>{$company.zip}</td>
      </tr>

      <tr class="address">
        <th>住所</th>
        <td>{$company.addr1} {$company.addr2} {$company.addr3}</td>
      </tr>

      <tr class="tel">
        <th>TEL</th>
        <td>{$company.tel}</td>
      </tr>

      <tr class="fax">
        <th>FAX</th>
        <td>{$company.fax}</td>
      </tr>

      <tr class="mail">
        <th>メールアドレス</th>
        <td>{$company.mail}</td>
      </tr>

      <tr class="website">
        <th>ウェブサイトアドレス</th>
        <td>{$company.website}</td>
      </tr>

      <tr class="group">
        <th>所属団体</th>
        <td>{$company.treenames}</td>
      </tr>
    </table>

    <div class="form_comment">
      <span class="alert">※</span>　項目名が<span class="required">黄色</span>の項目は必須入力項目です。
    </div>

    <table class="member form">
      {*
  <tr class="name required">
    <th>会社名</th>
    <td><input type="text" name="company" class="$company.company" value="{$company.company}"
      placeholder="会社名" required /></td>
  </tr>

  <tr class="name_kana required">
    <th>会社名（カナ）</th>
    <td><input type="text" name="company_kana" class="$company.company_kana" value="{$company.company_kana}"
      placeholder="会社名（カナ）" required /></td>
  </tr>

  <tr class="zip required">
    <th>〒</th>
    <td>
      <input type="text" name="zip" class="zip" value="{$company.zip}" placeholder="XXX-YYYY" required />
      <button class="zip2address">〒=>住所</button>
    </td>
  </tr>
  <tr class="address required">
    <th>住所</th>
    <td>
      <input type="text" name="addr1" class=" addr1" value="{$company.addr1}"
        placeholder="都道府県" required />
      <input type="text" name="addr2" class=" addr2" value="{$company.addr2}"
        placeholder="市区町村" required />
      <input type="text" name="addr3" class=" addr3" value="{$company.addr3}"
        placeholder="番地その他" required />
    </td>
  </tr>

  <tr class="tel required">
    <th>TEL</th>
    <td><input type="tel" name="tel" class="tel" value="{$company.tel}" placeholder="例) XXXX-YY-ZZZZ" required /></td>
  </tr>

  <tr class="fax required">
    <th>FAX</th>
    <td><input type="tel" name="fax" class="fax" value="{$company.fax}" placeholder="例) XXXX-YY-ZZZZ" required /></td>
  </tr>

  <tr class="mail required">
    <th>メールアドレス</th>
    <td>
      <input type="email" name="mail" class="mail" value="{$company.mail}" placeholder="aaa@bbbb.com" required />
    </td>
  </tr>

  <tr class="website">
    <th>ウェブサイトアドレス</th>
    <td>
      <input type="url" name="website" class="website" value="{$company.website}" placeholder="http://www.～～～～.com/" />
    </td>
  </tr>
*}

      <tr class="officer">
        <th>担当者<span class="required">(必須)</span></th>
        <td>
          <input type="text" name="officer" class="officer" value="{$company.officer}" placeholder="担当者の氏名" required />
        </td>
      </tr>

      <tr class="tel">
        <th>問い合わせTEL<span class="required">(必須)</span></th>
        <td><input type="tel" name="contact_tel" class="tel" value="{$company.contact_tel}" placeholder="例) XXXX-YY-ZZZZ"
            required /></td>
      </tr>

      <tr class="fax">
        <th>問い合わせFAX<span class="required">(必須)</span></th>
        <td><input type="tel" name="contact_fax" class="fax" value="{$company.contact_fax}" placeholder="例) XXXX-YY-ZZZZ"
            required /></td>
      </tr>

      <tr class="mail">
        <th>問い合わせメールアドレス</th>
        <td>
          <input type="email" name="contact_mail" class="mail" value="{$company.contact_mail}"
            placeholder="aaa@bbbb.com" />
        </td>
        {*** 追加分 ***}
      <tr class="infos pr">
        <th>PR</th>
        <td>
          <textarea name="infos[pr]" class="infos pr" placeholder="会社のキャッチコピーなど">{$company.infos.pr}</textarea>
        </td>
      </tr>

      <tr class="infos comment">
        <th>コメント</th>
        <td>
          <textarea name="infos[comment]" class="infos comment" placeholder="会社の紹介文など">{$company.infos.comment}</textarea>
        </td>
      </tr>

      <tr class="infos access_train">
        <th>交通機関：最寄り駅</th>
        <td>
          <textarea name="infos[access_train]" class="infos access_train"
            placeholder="電車でのアクセス方法">{$company.infos.access_train}</textarea>
        </td>
      </tr>

      <tr class="infos access_car">
        <th>交通機関：車</th>
        <td>
          <textarea name="infos[access_car]" class="infos access_car"
            placeholder="車でのアクセス方法">{$company.infos.access_car}</textarea>
        </td>
      </tr>

      <tr class="infos opening">
        <th>営業時間</th>
        <td>
          <input type="text" name="infos[opening]" class="infos opening" value="{$company.infos.opening}"
            placeholder="営業時間を入力" />
        </td>
      </tr>

      <tr class="infos opening">
        <th>定休日</th>
        <td>
          <input type="text" name="infos[holiday]" class="infos holiday" value="{$company.infos.holiday}"
            placeholder="定休日を入力" />
        </td>
      </tr>

      <tr class="infos license">
        <th>古物免許</th>
        <td>
          <input type="text" name="infos[license]" class="infos license" value="{$company.infos.license}"
            placeholder="古物免許の番号" />
        </td>
      </tr>

      <tr class="offices">
        <th>営業所・倉庫<br />(複数可)</th>
        <td>
          <span class="alert">※</span> 在庫機械の在庫場所の選択項目になります<br />
          {if !empty($company.offices)}
            {foreach $company.offices as $o}
              <div class="office">
                営業所・倉庫名 <input type="text" name="offices_name[]" class="offices_name" value="{$o.name}"
                  placeholder="営業所・倉庫名" /><br />

                〒 <input type="text" name="offices_zip[]" class="zip" value="{$o.zip}" placeholder="XXX-YYYY" />
                <button class="zip2address">〒⇛住所</button><br />

                住所 <input type="text" name="offices_addr1[]" class="addr1" value="{$o.addr1}" placeholder="都道府県" />
                <input type="text" name="offices_addr2[]" class="addr2" value="{$o.addr2}" placeholder="市区町村" />
                <input type="text" name="offices_addr3[]" class="addr3" value="{$o.addr3}" placeholder="番地その他" /><br />

                緯度経度(住所から自動入力) <input type="text" name="offices_lat[]" class="lat" value="{$o.lat}"
                  placeholder="緯度(住所から自動入力)" />
                <input type="text" name="offices_lng[]" class="lng" value="{$o.lng}" placeholder="経度(住所から自動入力)" />

                <a class="delete">削除</a>
              </div>
            {/foreach}
          {/if}

          <button id="offices_add">入力フォームを追加</button>
        </td>
      </tr>

      {*** 画像 ***}
      <tr class="top_img">
        <th>TOP画像</th>
        <td>
          <span class="alert">※</span> 登録できる画像ファイル形式はJPEGのみです<br />
          <iframe name="upload" class="upload" src="../ajax/upload.php?c=top_img&t=image/jpeg" frameborder="0"
            allowtransparency="true"></iframe>
          <div class="upload_img">
            {if !empty($company.top_img)}
              <div class="img">
                <label><input type="checkbox" name="top_img_delete" value="{$company.top_img}" />削除</label>
                <br />
                <a href='{$_conf.media_dir}company/{$company.top_img}' target="_blank">
                  <img src='{$_conf.media_dir}company/{$company.top_img}' />
                </a>
                <input type="hidden" name="top_img" value="{$company.top_img}" />
              </div>
            {/if}
          </div>
        </td>
      </tr>

      <tr class="imgs">
        <th>画像(複数可)</th>
        <td>
          <iframe name="upload" class="upload" src="../ajax/upload.php?c=imgs&t=image/jpeg&m=1" frameborder="0"
            allowtransparency="true"></iframe>
          <div class="upload_img">
            {if !empty($company.imgs)}
              {foreach $company.imgs as $i}
                <div class="img">
                  <label><input type="checkbox" name="imgs_delete[]" value="{$i}" />削除</label>
                  <br />
                  <a href='{$_conf.media_dir}company/{$i}' target="_blank">
                    <img src='{$_conf.media_dir}company/{$i}' />
                  </a>
                  <input type="hidden" name="imgs[]" value="{$i}" />
                </div>
              {/foreach}
            {/if}
          </div>
        </td>
      </tr>
    </table>
    <button type="submit" name="submit" class="submit" value="member">変更を反映</button>
  </form>

  <div class="office_template">
    営業所・倉庫名 <input type="text" name="offices_name[]" class="offices_name" placeholder="営業所・倉庫名" /><br />

    〒 <input type="text" name="offices_zip[]" class="zip" placeholder="XXX-YYYY" />
    <button class="zip2address">〒⇛住所</button><br />

    住所 <input type="text" name="offices_addr1[]" class="addr1" placeholder="都道府県" />
    <input type="text" name="offices_addr2[]" class="addr2" placeholder="市区町村" />
    <input type="text" name="offices_addr3[]" class="addr3" placeholder="番地その他" /><br />

    緯度経度(住所から自動入力) <input type="text" name="offices_lat[]" class="lat" placeholder="緯度(住所から自動入力)" />
    <input type="text" name="offices_lng[]" class="lng" placeholder="経度(住所から自動入力)" />

    <a class="delete">削除</a>
  </div>
{/block}
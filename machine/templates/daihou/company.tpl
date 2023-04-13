{extends file='daihou/layout/layout.tpl'}

{block 'header'}
  {literal}
    <script type="text/javascript">
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}
  {*
    <h2 class="minititle">ご挨拶</h2>
    <img class="company_dummy" src="./imgs/daihou_company_01.png" />
*}

  <h2 class="minititle"><i class="fas fa-briefcase"></i>事業内容</h2>
  <div class="row justify-content-center">
    <div class="d-none d-md-block col-md-3">
      <img src='./imgs/company_sagyo.jpeg'
        alt="中古機械登録会社 {$company.company} {$company.addr1} {$company.addr2} {$company.addr3}" class="w-100" />
    </div>

    <div class="col-md-9 px-4 fs-5">
      <ul>
        <li>各種新品機械販売（鍛圧・板金機械、工作機械など）</li>
        <li>各種中古機械買取（鍛圧・板金機械、工作機械など）</li>
        <li>各種機械修理及びプレス特定自主検査の実施</li>
        <li>工場内移設移転</li>
      </ul>
      などを行っております。
    </div>
  </div>

  <h2 class="minititle"><i class="fas fa-building"></i>会社概要</h2>

  <div class="row">
    <div class="col-md-6 order-md-2">
      <table class="table table-striped">
        <tr>
          <th class="col-4">商号</th>
          <td class="col-8">{$company.company}</td>
        </tr>
        <tr class="col-4">
          <th>商号(カナ)</th>
          <td class="col-8">ダイホウキカイカブシキガイシャ</td>
        </tr>
        <tr>
          <th class="col-4">本社所在地</th>
          <td class="col-8">
            〒 {if preg_match('/([0-9]{3})([0-9]{4})/', $company.zip, $r)}{$r[1]}-{$r[2]}{else}{$company.zip}{/if}<br />
            <span itemprop="region">{$company.addr1}</span>
            <span itemprop="locality">{$company.addr2}</span>
            <span itemprop="street-address">{$company.addr3}</span>
            <a class="" href="./access.php"><br />
              <i class="fas fa-map-marked-alt"></i>アクセス
            </a>
            <br />
            TEL : <a href="tel:+81-6-6747-7222"><span itemprop="tel">{$company.contact_tel}</span></a><br />
            FAX : <span class='tel'>{$company.contact_fax}</span><br />
            LINEWORKS : <br />
            <a href="https://works.do/R/ti/p/sakai.takeapersonforgranted@daihou" target="_blank"
              class="text-break">https://works.do/R/ti/p/sakai.takeapersonforgranted@daihou</a>
          </td>
        </tr>
        <tr>
          <th class="col-4">代表取締役</th>
          <td class="col-8">{$company.representative}</td>
        </tr>
        <tr>
          <th class="col-4">創業</th>
          <td class="col-8">1955年</td>
        </tr>
        <tr>
          <th class="col-4">資本金</th>
          <td class="col-8">1000万円</td>
        </tr>
        {*
            <tr>
            <th class="col-4">従業員</th>
            <td class="col-8">3人(2021.9.1現在)</td>
            </tr>
            <tr>
            <th class="col-4">決算月</th>
            <td class="col-8">9月</td>
            </tr>
            *}
        <tr class="col-4">
          <th class="col-4">古物免許</th>
          <td class="col-8">大阪府公安委員会許可 第１４９７号</td>
        </tr>
        <tr class="col-4">
          <th>取引銀行</th>
          <td class="col-8">
            三菱UFJ銀行 谷町支店<br />
            紀陽銀行 鴻池新田支店<br />
            北陸銀行 今里支店
          </td>
        </tr>
      </table>
    </div>
    <div class="col-md-6 order-md-1 px-4">
      {*
      <img src='{$_conf.media_dir}company/{$company.top_img}' alt="中古機械登録会社 {$company.company} {$company.addr1} {$company.addr2} {$company.addr3}" class="w-100" />
      *}
      <img src='./imgs/company_01.jpeg'
        alt="中古機械登録会社 {$company.company} {$company.addr1} {$company.addr2} {$company.addr3}" class="w-100" />

    </div>
  </div>

  <h2 class="minititle"><i class="fas fa-stream"></i>沿革</h2>

  <div class="row justify-content-center">
    <dl class="col-md-8 px-4 row">
      {*
        <dt class="col-md-4">昭和33年 6月</dt>
        <dd class="col-md-8">大阪市南区谷町にて酒井康夫、大宝機工商会を創業</dd>
        *}
      <dt class="col-md-4">昭和33年 4月</dt>
      <dd class="col-md-8">大阪市南区谷町にて酒井康夫、大宝機工商会を創立</dd>

      <dt class="col-md-4">昭和42年 11月</dt>
      <dd class="col-md-8">大宝機工商会より大宝機械株式会社に社名変更</dd>
      <dt class="col-md-4">昭和48年 8月</dt>
      <dd class="col-md-8">大阪機械卸業団地に本社移転</dd>
      <dt class="col-md-4">平成17年 11月</dt>
      <dd class="col-md-8">酒井克眞代表取締役に就任</dd>
    </dl>
  </div>
{/block}
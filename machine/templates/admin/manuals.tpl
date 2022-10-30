{extends file='include/layout.tpl'}

{block 'header'}

  {literal}
    <script type="text/javascript">
    </script>
    <style type="text/css">
    </style>
  {/literal}
{/block}

{block 'main'}
  <div id="body">
    <p>
      この度、大阪機械団地組合会館の機械情報センター内に機械の取説コーナーを開設しました。<br /><br />
      総数は472部あり、年代も幅広く1955年～2002年のものまであります。<br />
      中心は60～80年代のものが多いです。<br />
      下記に所蔵する取説の一覧を添付しましたので、ご興味ある方は、全機連事務局までご連絡お願いします。<br /><br />
      尚、ご希望の方には、コピー・貸し出しも可能となっています。ぜひ、ご活用下さい。<br />
      (コピー、pdf化の場合は、1ページ10円の手数料をいただきます)<br /><br />
    </p>
    <div>
      <a href="{$_conf.media_dir}pdf/20130610manual_list.xls" style="font-size: 130%;"
        target="_blank">取扱説明書リスト(Excel)</a><br /><br />
      <a href="{$_conf.media_dir}pdf/20130610manual_list.pdf" style="font-size: 130%;" target="_blank">取扱説明書リスト(PDF)</a>
    </div>

    <div>
      <img src="/imgs/torisesu_rack1.jpg" style="width: 49%;vertical-align:top;" />
      <img src="/imgs/torisesu_rack2.jpg" style="width: 49%;vertical-align:top;" />
      <img src="/imgs/torisesu_rack3.jpg" />
    </div>
{/block}
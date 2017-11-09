{**
 * メールマガジン登録ウィンドウ表示
 *
 * @access public
 * @author 川端洋平
 * @version 0.0.4
 * @since 2012/04/13
 *}
{literal}
<script type="text/JavaScript">
$(function() {
    //// メールマガジン登録の表示 ////
    $('button.input_mailmagazine').click(function() {
        $('#input_mailmagazine').dialog({
            show: "fade",
            hide: "fade",
            closeText: '閉じる',
            title: 'この条件でメールを受け取る',
            width: 640,
            height: 380,
            resizable: false,
            modal: true,
        });
    });
});
</script>
<style>
#input_mailmagazine {
  display : none;
}

#input_mailmagazine {
  width : 800px;
  margin : 4px auto;
  background : #FFF;
}

#input_mailmagazine h1 {
  width : auto;
}

#input_mailmagazine .mailmagazine_policy_title {
   font-weight : bold;
}


#input_mailmagazine .mailmagazine_policy {
   height : 200px;
   overflow-y : scroll;
   border : 1px solid #AAA;
  background : #EEE;
}

#input_mailmagazine .submit {
  display : block;
  margin : 8px auto;
  width : 270px;
}

#input_mailmagazine input.mail {
  width : 300px;
}

table.form th {
background: maroon;
color: white;
width: 160px;
padding: 4px;
border: 1px solid #DDD;
text-align: left;
vertical-align: middle;
}

table.form {
border: 1px solid #DDD;
width: 600px;
margin: 10px auto;
}

table.form td {
background: #EEE;
padding: 4px;
border: 1px solid #DDD;
text-align: left;
}

table.form td input {
border: 1px solid #999;
padding: 3px 6px;
background: white;
border-radius: 4px;
box-shadow: 0 2px 3px rgba(0,0,0,0.1) inset;
}
</style>
{/literal}

<div id="input_mailmagazine" style="display:none;">
  <form>
    <table class="form">
      <th class="label">メールアドレス</div>
      <td>
        <input type="email" name="mail" class="mail" placeholder="例） xxxx@xxxx.com" required />
      </td>
    </table>
    
    <div class="mailmagazine_policy_title">メールマガジン規約とプライバシーポリシー</div>
    <div class="mailmagazine_policy">
     (規約内容)
    </div>
  
    <button type="submit" class="submit" value="{','|implode:$c}">上記に同意の上、メールマガジン登録</button>
  </form>
</div>

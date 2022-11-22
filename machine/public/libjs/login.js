$(function() {
    /// フォーム入力の確認 ///
    $('form.login').submit(function() {
        if (!$('input#account').val() || !$('input#passwd').val()) {
            alert('アカウント、パスワードを入力してください。');
            return false;
        }
    });
});

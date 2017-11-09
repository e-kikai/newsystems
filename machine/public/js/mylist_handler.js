/**
 * 在庫機械表示共通Javascropt・マイリスト、お問い合わせイベントハンドラ
 */
$(function() {
    //// マイリストに登録（機械：単一） ////
    // $('button.mylist').live('click', function() {
    $(document).on('click', 'button.mylist', function() {
        mylist.set($(this).val(), 'machine');
    });
    
    //// マイリストに登録（機械：一括） ////
    $('button.mylist_full').click(function() {
        var machines = $('input.machine_check:checked').map(function() { return $(this).val(); }).get();
        if (machines.length) {
            mylist.set(machines, 'machine');
        } else {
            mylist.showAlert('マイリスト登録', 'マイリストに登録したい機械をチェックしてください');
        }
    });
    
    //// マイリストに登録（検索条件：単一） ////
    // $('button.input_mylist_genres').live('click', function() {
    $(document).on('click', 'button.input_mylist_genres', function() {
        mylist.set($(this).val(), 'genres');
    });
    
    //// マイリストに登録（会社：単一） ////
    // $('button.mylist_company').live('click', function() {
    $(document).on('click', 'button.mylist_company', function() {
        mylist.set($(this).val(), 'company');
    });
    
    //// マイリストに登録（会社：一括） ////
    $('button.mylist_full_company').click(function() {
        var companies = $('input.machine_check:checked').map(function() { return $(this).val(); }).get();
        if (companies.length) {
            mylist.set(companies, 'company');
        } else {
            mylist.showAlert('マイリストに登録したい会社をチェックしてください');
        }
    });
    
    //// 問い合わせ（一括） ////
    $('button.contact_full').click(function() {
        if ($('input.machine_check:checked').length) {
            var uri = 'contact.php?';
            $('input.machine_check:checked').each(function() { uri += 'm[]=' + $(this).val() + '&'; });
            location.href = uri;
        } else {
            mylist.showAlert('問い合わせしたい機械をチェックしてください');
        }
    });
    
    //// マイリストから削除する（機械：一括） ////
    $('button.mylist_delete').click(function() {
        var machines = $('input.machine_check:checked').map(function() { return $(this).val(); }).get();
        if (machines.length) {
            mylist.del(machines, 'machine');
        } else {
            mylist.showAlert('マイリストから削除したい機械をチェックしてください');
        }
    });
    
    //// マイリストから削除する（検索条件：単一） ////
    // $('button.mylist_delete_genres').live('click', function() {
    $(document).on('click', 'button.mylist_delete_genres', function() {
        var genres = $('input.machine_check:checked').map(function() { return $(this).val(); }).get();
        if (genres.length) {
            mylist.del(genres, 'genres');
        } else {
            mylist.showAlert('マイリストから削除したい検索条件をチェックしてください。');
        }
    });
    
    //// マイリストから削除する（会社：一括） ////
    $('button.mylist_delete_company').click(function() {
        var companies = $('input.machine_check:checked').map(function() { return $(this).val(); }).get();
        if (companies.length) {
            mylist.del(companies, 'company');
        } else {
            mylist.showAlert('マイリストに削除したい会社をチェックしてください');
        }
    });
    
    //// 問い合わせ（会社：一括） ////
    $('button.contact_full_company').click(function() {
        if ($('input.machine_check:checked').length) {
            url = 'contact.php?';
            $('input.machine_check:checked').each(function() {
                url += 'c[]=' + $(this).val() + '&';
            });
            location.href = url;
        } else {
            cjf.showAlert('問い合わせしたい機械をチェックしてください。');
        }
    });
    
    // すべての機械をチェック
    $('#machine_check_full').change(function() {
        $('input.machine_check').attr('checked', this.checked);
    });
    
    // お問い合わせ先
    // $('.contact.none').live('click',function() {
    $(document).on('click', '.contact.none', function() {
        alert("この機械を登録している会社のメールアドレスが登録されていないため、\n" +
        "メールフォームでの問い合わせが行えません。\n\n" +
        "お手数ですが、電話・FAXでお問い合わせお願いいたします。");
        
        return false;
    });
});

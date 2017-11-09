/**
 * マイリストオブジェクト
 */
var mylist = {
    //// マイリスト登録URL ////
    _url : 'ajax/mylist.php',
    _targetList : {
        'machine' : '機械情報',
        'genres'  : '検索条件',
        'company' : '会社情報'
    },
    
    /**
     * マイリストに登録
     *
     * @access public
     * @param  array array 機械ID（配列）
     * @param  function callback コールバック関数
     * @return boolean true
     */
    set : function(array, target)
    {
        if (!this._targetList[target]) {
            mylist.showAlert('マイリスト登録', 'マイリストに登録できませんでした');
            return false;
        } else if (!this.check(array).length) {
            mylist.showAlert('マイリスト登録', '登録するデータがありません');
            return false;
        }
        
        // マイリスト登録処理
        $.post('ajax/mylist.php', {
            "target": target,
            "action": "set",
            "data[]": array
        },
        function(data) {
            if (data == 'success') {
                mylist.showAlert('マイリスト登録', mylist._targetList[target] + 'をマイリストに登録しました');
            } else {
                mylist.showAlert('マイリスト登録', data);
            }
        });
    },
    
    /**
     * マイリストから削除
     *
     * @access public
     * @param  array array 機械ID（配列）
     * @param  function callback コールバック関数
     * @return boolean true
     */
    del : function(array, target)
    {
        if (!this._targetList[target]) {
            this.showAlert('マイリスト削除', 'マイリストから削除できませんでした');
            return false;
        } else if (!this.check(array).length) {
            this.showAlert('マイリスト削除', '削除するデータがありません');
            return false;
        }
        
        if (confirm('チェックしたカタログをマイリストから削除しますか？')) {
            // マイリスト削除処理
            $.post('ajax/mylist.php', {
                "target": target,
                "action": "delete",
                "data[]": array
            },
            function(data) {
                if (data == 'success') {
                    location.reload();
                } else {
                    mylist.showAlert('マイリスト削除', data);
                }
            });
        }
    },
    
    //// メッセージダイアログを表示 ////
    showAlert : function(title, contents)
    {
        $('<div class="mylist_alert">')
            .text(contents)
            .dialog({
                show: "fade",
                hide: "fade",
                closeText: '閉じる',
                title: title,
                width: 300,
                height: 100,
                resizable: false,
                modal: false,
                open: function(e, ui) {
                    setTimeout(function() { $(e.target).dialog('close'); }, 1000);
                }
            });
    },
    
    check : function(array)
    {
        // 配列かどうかチェック
        var temp = $.isArray(array) ? array : [array];
        // 配列の中身が整数かどうかチェック
        /*
        temp = $.map(temp, function(val) {
            if (typeof(val) == 'string') {
                if (val.match(/^[0-9]+$/)) { return val; }; 
            } else if(typeof(val) == 'number') {
                if (val.toString().match(/^[0-9]+$/)) { return val; }; 
            }
            return null;
        });
        */
        
        return temp;
    }
}

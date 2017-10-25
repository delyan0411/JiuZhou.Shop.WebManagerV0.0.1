function tips(msg) {
    var _tips=$("#tips-message");
    _tips.html(msg);
    return false;
}
/*
function tips1(msg) {
    var _tips = $("#tips-message2");
    _tips.html(msg);
    return false;
}
function tips2(msg) {
    var _tips = $("#tips-message2");
    _tips.html(msg);
    return false;
}
*/
var _lastTips = false;
var _isfirst = true;

$(function () {
    _isfirst = true;
    if (_isfirst) {
        $("#btnCodev").hide();
    }
});

function getCode(st) {
    var btn = $("#btnCode");
    if (btn.hasClass("waiting") || codeClick) {
    } else {
        codeClick = true;
        tips("");
       // if (showLoadding) showLoadding();
        $.ajax({
            url: "/Logion/SendVerifyCode"
		    , data: "sendType=" + st
		    , dataType: "json"
            , type: "post"
		    , success: function (json) {
		        codeClick = false;
		        if (json.error) {
		            tips(json.message);
		        } else {
		            //获取验证码
		            waiting();
		            tips(json.message);
		            //jsbox.success(json.message);
		        }
		     //   if (closeLoadding) closeLoadding();
		    },
		    error: function () {
		        codeClick = false;
                jsbox.error("系统错误");
               // if (closeLoadding) closeLoadding();
            }
        });
    }
}
var seconds = 60;
var cursec = seconds;
var btn = null,btnv = null;
var inter = null;
var codeClick = false;

function waiting() {
    btn = $("#btnCode");
    btnv = $("#btnCodev");
    cursec = seconds;
    inter = setInterval("timer()", 1000);
}
function timer() {
    cursec--;
    if (cursec > 0) {
        var a = btn.val();
        btn.addClass("waiting").attr("disabled", "disabled").val("获取验证码(" + cursec + ")");
        btnv.addClass("waiting").attr("disabled", "disabled").val("获取语音码(" + cursec + ")");
    } else {
        btn.removeClass("waiting").removeAttr("disabled").val("获取验证码");
        btnv.removeClass("waiting hdn").removeAttr("disabled").val("获取语音码");
        clearInterval(inter);
    }
    if (cursec == 0) {
        _isfirst = false;
        $("#btnCodev").show();
    }
}


function resetTips(showObjId){
	var obj=Atai.$("#tips-" + showObjId);
	obj.className = "tips-text";
	Atai.$("#tips-" + showObjId).innerHTML=obj.title;
}


function checkYzm(form) {

  
        var yzm = $.trim($("#verifyCode").val());

        if (yzm == "") {
            return tips("请输入验证码");
        }

        tips("");
        //  if (showLoadding) showLoadding();
        $.ajax({
            url: "/Logion/CheckYzm"
        , data: "code=" + yzm
        , dataType: "json"
        , type: "post"
        , success: function (json) {
            if (json.error) {
                tips(json.message);
            } else {
                //jsbox.success(json.message, json.url);
                window.location.href = json.url;
            }
            //if (closeLoadding) closeLoadding();
        },
            error: function () {
                jsbox.error("系统错误");
                // if (closeLoadding) closeLoadding();
            }
        });
        return false;
   
}
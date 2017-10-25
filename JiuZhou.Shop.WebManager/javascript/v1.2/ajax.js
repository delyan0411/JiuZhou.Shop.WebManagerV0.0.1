/*
Author : Atai Lu
			2014-09-30
-----------------------------*/
var __localAddress="";
var __intervalId=remote_ip_info=false;
function loadIpAddress(){
    var url="http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js";
    var s=document.createElement("script");
    s.type="text/javascript";
    s.src=url;
    s.charset="utf-8";
    var h=document.getElementsByTagName("head")[0];
    if(!h) h=document.body;
    if(h){
        h.appendChild(s);
        formatLocalAddress();
    }
}
function setLocalAddress(val){
	$.ajax({
		url: "/Tools/SetLocalAddress"
		, type: "post"
		, data: {address: val}
		, dataType: "json"
		, success: function(json, textStatus){
			
		}, error: function(http, textStatus, errorThrown){
			//jsbox.error("error");
		}
	});
	return false;
}
function formatLocalAddress(){
    if(remote_ip_info){
        var _info=remote_ip_info;
        __localAddress= _info.country + " " + _info.province + " " + _info.city + " " + _info.isp;
        if(__intervalId) clearInterval(__intervalId);
		setLocalAddress(__localAddress);
        return;
    }
	if(__intervalId) clearInterval(__intervalId);
	__intervalId = setInterval(formatLocalAddress,10);
}
$(function(){
	if(__localAddress==""){
		loadIpAddress();
	}
});
function ajax(form, url, objId, gotoUrl){
	var json=utils.formatData(form);
	json["postaddress"]=__localAddress;
	$.ajax({
		url: url
		, type: "post"
		, data: json
		, dataType: "json"
		, success: function(json){
			var o=false;
			if(objId!=undefined && objId){
				o=$(objId);
				o.removeClass("tips-icon");
			}
			if(json.error){
				if(o){
					o.addClass("tips-icon");
					o.html(json.message);
				}else{
					jsbox.error(json.message);
				}
			}else{
				if(json.url || gotoUrl) window.location.href=json.url || gotoUrl;
				else jsbox.message(json.message, window.location.href);
			}
		}, error: function(http, textStatus, errorThrown){
			jsbox.error("error");
		}
	});
	return false;
}
function adminLogin(form){
	return ajax(form, "/Login/AdminLoginByScript", "#tips-message");
}
function managerOut(){
    window.location.href = "/MTools/ClearManagerCookie";
}

/*
links=[{url : url, target : target, title : title, text : text}]
*/
function alertBox(message, type ,url){
	var box=Atai.$("#alert-box-control");
	var closeObj=Atai.$("#alert-box-control-close");
	if(!box){
		AtaiBox.error(message); return false;
	}
	if(!type) type="error";
	if(type=="succeed"){
		Atai.$("#alert-box-icon").className="alert-succeed";
	}else{
		Atai.$("#alert-box-icon").className="alert-icon";
	}
	var _dialog = new iframeDialog();
	_dialog.copyDialog({
		 copy: box
		, move: Atai.$("#alert-box-control-name")
		, close: closeObj
	});
	var button=Atai.$("#alert-box-button");
	Atai.$("#alert-box-message").innerHTML=message;
	$(button).focus();
	button.onclick=function(){
		if(url) window.location.href=url;
		$(closeObj).click();
	};
	return false;
}
function succeedBox(message, url){
	return alertBox(message, "succeed", url);
}
function errorBox(message, url){
	return alertBox(message, "error", url);
}
function scrollPage(event,gotoObj, cLen){
	var L=Atai.getTop(gotoObj);
	if(Atai.isInt(cLen)) L=L+cLen;
	window.scrollTo(0,L);
}
function sGoto(event,Id, cLen){
	scrollPage(event,Atai.$("#" + Id), cLen);
}
function isIncludeHost(path){
	if(!path || Atai.trim(path)=="") return false;
	path=Atai.trim(path.toLowerCase());
	if(path.substring(0, 7)=="http://" || path.substring(0, 8)=="https://" || path.substring(0, 6)=="ftp://")
		return true;
	return false;
}

function subString(val, index, len){
	if(!len) len=val.length;
	var _len=0,_s=[];
	var _tem=val.split("");
	for(var kk=index;kk<_tem.length;kk++){
		if(Atai.isCn(_tem[kk])){
			_len += 2;
		}else{
			_len++;
		}
		if(_len>len){
			_s.push("...");
			break;
		}
		_s.push(_tem[kk]);
	}
	return _s.join("");
}



var _isModify=false;
function showLoadding(){
	var loadding=Atai.$("#loadding");
	if(loadding!=undefined){
		loadding.style.display="block";
		loadding.style.left = parseInt((window.screen.availWidth - loadding.offsetWidth)/2) + "px"; 
		loadding.style.top = parseInt(200 + Atai.scroll().y) + "px";
	}
}
function closeLoadding(){
	var loadding=Atai.$("#loadding");
	if(loadding!=undefined){
		loadding.style.display="none";
	}
}
function closePage(event){
	event=Atai.getEvent(event);
	if(_isModify){
		return "\u5185\u5bb9\u5df2\u88ab\u4fee\u6539";
	}
}

function changeTab(obj,nodeId){
	var links = Atai.$("#label-name a");
	for (var i = 0; i < links.length; i++){
		if (i == 0) links[i].className = "first";
		else links[i].className = "";
	}
	obj.className += " on";
	var onLiObj = false;
	var lis = Atai.$("#navigation-items li");
	for (var i = 0; i < lis.length; i++){
		if (lis[i].id == "li-item-" + obj.id){
			lis[i].className = "on"; onLiObj = lis[i];
		}else{
			lis[i].className = "";
		}
	}
	if (onLiObj){
		var lnks = onLiObj.getElementsByTagName("a");
		for (var i = 0; i < lnks.length; i++){
			if (lnks[i].id == nodeId){
				lnks[i].className = "hover";
			}else{
				lnks[i].className = "";
			}
		}
	}
}
function resetRowClassName(table){
	for(var i=1;i<table.rows.length;i++){
		if(i%2==0){
			table.rows[i].className="bg";
		}else{
			table.rows[i].className="";
		}
	}
}

function getGuid(){
	var guid=false;
	$.ajax({
	    url: "/MTools/GetNewGuid"
		, type: "post"
        , async : false
		, data: ""
		, dataType: "json"
		, success: function (json) {
		    guid = json.guid;
		}
	});
	return guid;
}
function getTicks(){
	var ticks=false;
	Atai.ajax.post({
		url: "/MTools/GetTicks"
		, type: false
		, data: ""
		, dataType: "json"
		, callback: function(json){
			ticks=json.ticks;
		}
	});
	return ticks;
}

$(function(){
	$(".table tbody tr:odd").addClass("bg");
	$(".table tbody tr:even").addClass("");
	$(".table tbody tr").hover(function(){
    		$(this).addClass("bg-on");
		},function(){
    		$(this).removeClass("bg-on");
	});
});


function checkInputInt(obj, minNumber, maxNumber) {
    if (!Atai.isInt(obj.value)) {
        obj.value = minNumber;
    } else {
        var val = parseInt(obj.value);
        if (val < minNumber) obj.value = minNumber;
        else if (val > maxNumber) obj.value = maxNumber;
    }
}
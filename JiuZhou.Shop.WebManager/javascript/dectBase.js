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
function formatImageUrl(path, width, height){
	if(!path || Atai.trim(path)=="")
		return "";
	if(isIncludeHost(path))
		return path;
	var rVal=path;
	var idx=path.lastIndexOf(".");
	if(idx>0){
		var _pix=path.substring(idx);
		rVal = path.substring(0,idx) + "_"+ width + "_" + height + _pix;
	}
	return rVal;
}
function formatImageUrl2(root, path, width, height){
	if(!path || Atai.trim(path)=="")
		return "";
	if(isIncludeHost(path))
		return path;
	var rVal=path;
	var idx=path.lastIndexOf(".");
	if(idx>0){
		var _pix=path.substring(idx);
		rVal = path.substring(0,idx) + "_"+ width + "_" + height + _pix;
	}
	return root + rVal;
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
function submitForm(form, url, succeedUrl, disallowAlert){
	if(showLoadding) showLoadding();
	var postData=getPostDB(form);
	Atai.ajax.post({
		url: url
		, data: postData
		, dataType: "json"
		, callback: function(json){
			if(json.error){
				var _tips=Atai.$("#tips-" + json.input);
				if(_tips){
					_tips.className = "tips-text tips-icon";
					_tips.innerHTML=json.message;
				}else{
					errorBox(json.message);
				}
			}else{
				var gotoUrl=succeedUrl?succeedUrl:(json.url?json.url:window.location.href);
				if(disallowAlert){
					window.location.href=gotoUrl;
				}else{
					succeedBox(json.message, gotoUrl);
				}
			}
			if(closeLoadding) closeLoadding();
		}
	});
	return false;
}

/*var qInitValue="\u8bf7\u8f93\u5165\u5546\u54c1\u540d\u002f\u54c1\u724c\u540d";
Atai.addEvent(window,"load",function(){
	var sQuery=Atai.$("#search-query");
	if(sQuery){
   		if (sQuery.value == qInitValue || sQuery.value == "") {
        	sQuery.value = qInitValue;
        	sQuery.style.color = "#999";
   		} else {
        	sQuery.style.color = "#111";
    	}
    	sQuery.onclick = function() {
        	if (this.value == qInitValue) {
            	this.value = "";
           		sQuery.style.color = "#111";
        	}
    	};
    	sQuery.onblur = function() {
        	if (this.value == "") {
            	this.value = qInitValue;
            	sQuery.style.color = "#999";
        	}
    	};
	}
});*/
$(function(){
	var obj=$("#search-query");
	obj.focus(function(){
		$("#sLabel").css({"visibility":"hidden"});
	}).blur(function(){
		if(obj.val()=='') $("#sLabel").css({"visibility":"visible"});
	});
	if(obj.val()!=''){
		$("#sLabel").css({"visibility":"hidden"});
	}
});
var sch = function(form){
	var sQuery=Atai.$("#search-query");
	if (Atai.trim(sQuery.value) == qInitValue) {
		sQuery.value = "";
	}
};
function moduleInit(){
	var o=$(".jz-zt-module");
	o.mouseenter(function(){
		//$(this).addClass("hover");
		$(this).children(".module-op").css({"display": "block"});
		$(this).find(".module-op-bg").css({"opacity": 0.4});
	}).mouseleave(function(){
		//$(this).removeClass("hover");
		$(this).children(".module-op").css({"display": "none"});
	});
	o.each(function(){
		//$(this).children(".module-hd").css("display","block");
	});
}
$(function(){
	moduleInit();
});

function moduleMove(mId, type){
	var module=$("#module-" + mId);
	var nodes=$(".jz-zt-module");
	var idx=0;
	for(var i=0;i<nodes.length;i++){
		if($(nodes[i]).attr("id")==module.attr("id")){
			idx=i;break;
		}
	}
	var len=nodes.length;
	if(module && len>0){
		switch(type){
			case "first":
				if(idx>0){
					module.insertBefore(nodes[0]);
				}
				break;
			case "up":
				if(idx>0){
					module.insertBefore(nodes[idx-1]);
				}
				break;
			case "down":
				if(idx+1<len){
					module.insertAfter(nodes[idx+1]);
				}
				break;
			case "last":
				if(idx+1<len){
					module.insertAfter(nodes[len-1]);
				}
				break;
		}
		if(moduleResetSortNo) moduleResetSortNo();
	}
}

function moduleModify(mId, mode){
	var module=$("#module-" + mId);
	var m=parseInt(mode);
	switch (m) {
	    case 0:
	        moduleModifyText(mId);
	        break;
	    case 1:
	        moduleModifyList(mId);
	        break;
	    case 2:
	        moduleModifyPaging(mId);
	        break;
	    case 3:
	        moduleModifyCarousel(mId);
	        break;
	    case 4:
	        moduleModifyPic(mId);
	        break;
	    case 5:
	        moduleModifyFloor(mId);
	        break;
	}
}

/*
Author : Atai Lu
			2014-09-30
-----------------------------*/

function formatImageUrl(path, width, height) {
    if (!path || Atai.trim(path) == "")
        return "";
    var rVal = path;
    var idx = path.lastIndexOf(".");
    var pathname = path.substring(0, path.lastIndexOf('.') > 0 ? path.lastIndexOf('.') : 1);
    if (idx > 0) {
        var _pix = path.substring(idx);
        rVal = pathname + "_" + width + "_" + height + _pix;
    }
    if (width < 0)
        rVal = path;
    return rVal;
}

function formatImageUrl2(path, width, height) {
    if (!path || Atai.trim(path) == "")
        return "";
    var rVal = path;
    var idx = path.lastIndexOf(".");
    if (idx > 0) {
        var _pix = path.substring(idx);
        rVal = path.substring(0, idx) + "_" + width + "_" + height + _pix;
    }
    return rVal;
}
function showLoadding() {
    var loadding = $("#loadding3");
    if (loadding != undefined) {
      //  loadding.style.display = "block";
       // loadding.style.left = parseInt((window.screen.availWidth - loadding.offsetWidth) / 2) + "px";
        //   loadding.style.top = parseInt(200 + Atai.scroll().y) + "px";
        loadding.attr("id", "loadding2");
        loadding.attr("disabled", "disabled");
    }
}
function closeLoadding() {
    var loadding = $("#loadding2");
    if (loadding != undefined) {
        // loadding.style.display = "none";
        loadding.attr("id", "loadding3");
        loadding.attr("disabled", false);
    }
}
var getPostDB = function (form) {
    var inputs = form.getElementsByTagName("input");
    var sls = form.getElementsByTagName("select");
    var texts = form.getElementsByTagName("textarea");
    var postData = "";
    //button/file/hidden/image/password/radio/reset/submit/text
    for (var i = 0; i < inputs.length; i++) {
        var type = inputs[i].type;
        var val = "";
        if (inputs[i].name == undefined || inputs[i].name == "") continue;
        if (type == undefined) type = "text";
        else type = inputs[i].type.toLowerCase();
        switch (type) {
            case "file":
                form.enctype = "multipart/form-data";
                val = inputs[i].value;
                break;
            default:
                val = inputs[i].value;
                break;
        }
        var isUse = true;
        if (type == "checkbox" && !inputs[i].checked) isUse = false;
        if (type == "radio" && !inputs[i].checked) isUse = false;
        if (inputs[i].name != undefined && !inputs[i].disabled && isUse) {
            if (postData == "") {
                postData = inputs[i].name.toLowerCase() + "=" + Atai.urlEncode(val);
            } else {
                postData += "&" + inputs[i].name.toLowerCase() + "=" + Atai.urlEncode(val);
            }
        }
    }
    //
    for (var i = 0; i < sls.length; i++) {
        if (!sls[i].multiple) {
            if (sls[i].name != undefined && sls[i].name != "" && !sls[i].disabled) {
                if (postData == "") {
                    postData = sls[i].name.toLowerCase() + "=" + Atai.urlEncode(sls[i].options[sls[i].selectedIndex].value);
                } else {
                    postData += "&" + sls[i].name.toLowerCase() + "=" + Atai.urlEncode(sls[i].options[sls[i].selectedIndex].value);
                }
            }
        } else {
            if (sls[i].name != undefined && sls[i].name != "" && !sls[i].disabled) {
                var selectValue = "";
                for (var kk = 0; kk < sls[i].options.length; kk++) {
                    if (sls[i].options[kk].selected) {
                        if (selectValue == "")
                            selectValue = sls[i].options[kk].value;
                        else
                            selectValue += "," + sls[i].options[kk].value;
                    }
                }
                if (postData == "") {
                    postData = sls[i].name.toLowerCase() + "=" + Atai.urlEncode(selectValue);
                } else {
                    postData += "&" + sls[i].name.toLowerCase() + "=" + Atai.urlEncode(selectValue);
                }
            }
        }
    }
    //
    for (var i = 0; i < texts.length; i++) {
        if (texts[i].name != undefined && !texts[i].disabled) {
            if (postData == "") {
                postData = texts[i].name.toLowerCase() + "=" + Atai.urlEncode(texts[i].value);
            } else {
                postData += "&" + texts[i].name.toLowerCase() + "=" + Atai.urlEncode(texts[i].value);
            }
        }
    }
    return postData;
};
var getChangeHref=function(url){
	var myurl=window.location.href.toLowerCase();
	var _p="?";
	if(url.indexOf("?")>0)
		_p="&";
	if(myurl.indexOf("returnurl=")>0)
		url += _p + "returnurl=" + Atai.request("returnurl");
	else
		url += _p + "returnurl=" + myurl;
	return url;
};
var resetPage=function(type,val){
	var url=window.location.href.toLowerCase();
	if(type==undefined) type="";
	type=type.toLowerCase();
	var str=type + "=" + val;
	if(url.indexOf(type + "=")>0){
		var reg = new RegExp("(" + type + "=[^&]*)","i");
		url = url.replace(reg,str)
	}else{
		if(url.indexOf("?")<=0) url +="?" + str;
		else url +="&" + str;
	}
	window.location.href=url;
};
function formatUrl(ocol, val, url){
	if(!url) url=window.location.href;
	var reg = ocol + "=[^-]*";
	var reg = new RegExp(ocol + "=[^-\.]*");
	url = url.replace(reg, ocol + "=" + val);
	return url;
}
function changePage(val){
	resetPage("page", val);
}
function loginOut(returnUrl) {
    var url = returnUrl ? returnUrl : window.location.href;
    window.location.href = "/Tools/LogOut?returnUrl=" + url;
}
$(function(){
	$(".data-table tbody tr:odd").addClass("bg");
	$(".data-table tbody tr:even").addClass("");
	/*$(".data-table tbody tr").hover(function(){
    		$(this).addClass("bg-on");
		},function(){$(this).removeClass("bg-on");
	});*/
	$(".table").each(function(){
		var trs=$(this).find("tr");
		for(var i=0;i<trs.length;i++){
			if(i>0&&i%2!=0){
				$(trs[i]).addClass("bg");
			}
		}
	});
});
function getAreaByParentID(parent){
	var data=[];
	for(var i=0;i<areas.length;i++){
		var json=areas[i];
		if(json.ParentID==parent){
			data.push(json);
		}
	}
	return data;
}
function clearOptions(selObj){
	$(selObj).empty();$(selObj).append("<option value=''>--\u8bf7\u9009\u62e9--</option>");
}
function createAreaOption(parentId, selObj, defVal, callback){
	if(!defVal) defVal=0;
	var data=getAreaByParentID(parentId);
	clearOptions(selObj);
	for(var i=0;i<data.length;i++){
		var json=data[i];
		if(defVal!=json.AreaID && data.length>1){
			$(selObj).append("<option code='"+ json.Code +"' value='"+ json.AreaID +"'>"+ json.Name +"</option>");
		}else{
			$(selObj).append("<option code='"+ json.Code +"' value='"+ json.AreaID +"' selected='selected'>"+ json.Name +"</option>");
		}
		if(callback) callback(defVal);
	}
}
$(function(){
    $(".copy").zclip({
		path: "/js/ZeroClipboard.swf",
		copy: function(){
			return $(this).attr("value");
		},
		beforeCopy:function(){},
		afterCopy:function(){
			new AtaiShadeDialog().init({obj: false
				, message: "\u590d\u5236\u6210\u529f!"
				, msgType: "ok"
				, showCancel: false
				, CWCOB: true//closeWhenClickOnBackground
			});
        }
	});
});
/*$(function(){
	//$(".list-img-box .iLink span").css("opacity", 0.5);
	$(".list-img-box").mouseenter(function (){
		$(this).find(".iLink").addClass("bgLink");
		$(this).find(".iLink i").css("opacity", 0.5);
        //$(this).find(".iLink span").animate({ "bottom": 0 }, "fast", function () { });
    }).mouseleave(function () {
		$(this).find(".iLink").removeClass("bgLink");
        $(this).find(".iLink i").css("opacity", 1);
    });
});*/

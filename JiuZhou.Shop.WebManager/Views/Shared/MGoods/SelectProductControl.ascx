<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="System.Collections.Generic" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.MySql" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %>
<%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<style>
.dialog-box .data-box-list{width:100%;height:396px;margin:0 auto;overflow-y:scroll;}
.dialog-box .data-box-list li{height:66px;margin:6px 0;border-bottom:#ccc 1px dashed;width:96%;}
.dialog-box .data-box-list li div{float:left;}
.dialog-box .data-box-list li .img{width:82px;text-align:center;}
.dialog-box .data-box-list li .img img{border:#ddd 1px solid;}
.dialog-box .data-box-list li .title{display:block;float:left;width:280px;}
.dialog-box .data-box-list li .move-links{width:80px;display:block;margin-top:0px;}
.dialog-box .data-box-list li .op-link{float:right;width:52px;text-align:center;}
.dialog-box .data-box-list li a{color:#06F;}
</style>
<div id="product-selector" class="dialog-box" v="product-selector" style="width:960px;height:532px;display:none">
	<div class="atai-shade-head" v="atai-shade-move">
		商品选择器
		<div class="atai-shade-close" v="atai-shade-close">&nbsp;</div>
	</div>
	<div class="atai-shade-contents">
<form action="" onsubmit="return searchProductForSelector()">
<div class="console" style="text-align:left">&nbsp;&nbsp;
	关键词:
	<input type="text" v="sQuery" value="" class="input" onblur="searchProductForSelector()" style="height:26px;line-height:26px"/>
    &nbsp;<input type="submit" class="submit black" value="搜索"/>
    &nbsp;&nbsp;<a href="javascript:;"  onclick="selectAllProductSelector()">全选</a>
    已选择 <span v="count" style="color:#F00">0</span> 个商品
</div>
</form>
<div v="data-list-options" style="width:49.5%;float:left"><ul class="data-box-list"></ul></div>
<div v="data-list-selected" style="width:49.5%;float:right"><ul class="data-box-list"></ul></div>
		<div class="clear">&nbsp;</div>
	</div>
	<div class="atai-shade-clear"></div>
	<div class="atai-shade-bottom">
		<input type="button" class="atai-shade-cancel" v="atai-shade-cancel" value="取消"/>
		<input type="button" class="atai-shade-confirm" v="atai-shade-confirm" onclick="_callbackForProductSelector()" value="确定"/>
<div v="tips-message" style="text-align:center;font-weight:100;font-size:14px;color:#555">已选择 <span v="count" style="color:#F00">0</span> 个商品</div>
	</div>
</div>
<script type="text/javascript">
var _productSelector=false;
var _allowSku=true;
var _callbackFunctionForProductSelector=false;
var _disAllowList=[];
function _callbackForProductSelector(){
	if(!_productSelector || !_productSelector.dialog)
		return false;
	var nodes=$(_productSelector.dialog).find("div[v='data-list-selected'] input[name=productId]");//input[name=productId]
	var ids="";
	for(var i=0;i<nodes.length;i++){
	    if (i > 0) ids += ",";
	    var a = $(nodes[i]).val();
		ids+=$(nodes[i]).val();
	}
	_callbackFunctionForProductSelector(ids);
}

/*
	callbackFunction: 回调方法,点[确定]按钮后会调用此方法并传入选中的商品ID(多个ID以逗号隔开)
	initList: 之前已选中的商品(用于初始化,多个ID用逗号隔开)
	disallowArray: 禁止选择的商品ID数组
	allowSku: 是否允许选择带Sku的商品
    isonsale:
*/

function showProductSelector(callbackFunction, initList, disallowArray, allowSku, isonsale){
	if(allowSku!=undefined) _allowSku=allowSku;
	if(disallowArray!=undefined) _disAllowList=disallowArray;
	if(callbackFunction!=undefined) _callbackFunctionForProductSelector=callbackFunction;
	var _dialog = new AtaiShadeDialog();
	_dialog.init({
		  obj: "#product-selector"
		, sure: function(){}
		, cancel: function(){}
		, CWCOB: false // closeWhenClickOnBackground: true || CWCOB: true
		, formatData: function(){}
	});
    _productSelector = _dialog;
	searchProductForSelector(isonsale);
	if(initList!=undefined) formatSelectedForSelector(initList);
	//alert(_productSelector.dialog.attr("id"));
}

function formatSelectedForSelector(ids){
	if(ids=="") return false;
	$.ajax({
		url: "/MTools/GetProductList2"
		, type: "post"
		, data: {
			"ids": ids
		}
		, dataType: "json"
		, success: function(json, textStatus){
			for(var i=0;i<json.length;i++)
				selectItemForProductSelector(json[i]);
			selectedCountForProductSelector();
		}, error: function(http, textStatus, errorThrown){
			jsonbox.error(errorThrown);
		}
	});
}

function formatImageUrlForSelector(root, path, width, height){
	if(!path || Atai.trim(path)=="")
		return "";
	//if(isIncludeHost(path))
	//	return path;
	var rVal=path;
	var idx=path.lastIndexOf(".");
	if(idx>0){
		var _pix=path.substring(idx);
		rVal = path.substring(0,idx) + "_"+ width + "_" + height + _pix;
	}
	return root + rVal;
}

function searchProductForSelector(isonsale){
	if(!_productSelector || !_productSelector.dialog)
		return false;
	var query=$(_productSelector.dialog).find("input[v='sQuery']").val();
	$.ajax({
		url: "/MTools/SeachProduct?t=" + new Date().getTime()
		, type: "post"
		, data: {
			 size : 200
			,page : 1
			,stype : 0
			, q: query
            ,isonsale:isonsale
		}
		, dataType: "json"
		, success: function(json, textStatus){
			appendSearchResultForSelector(json.data, json.pageCount, json.index);
		}, error: function(http, textStatus, errorThrown){
			jsbox.error("查询失败");
		}
	});
	return false;
}

//全选

function appendSearchResultForSelector(data, pageCount, pageIndex){
	if(!_productSelector || !_productSelector.dialog)
	    return false;
	var arr=[];
	var nodes=$(_productSelector.dialog).find("div[v='data-list-selected'] input[name=productId]");
	for(var i=0;i<data.length;i++){
	    var json = data[i];
		if(_disAllowList.contains(json.product_id)){
			continue;
		}
		arr.push('<li>');
		arr.push('<div class="img"><img src="' + (formatImageUrl(json.img_src, 60, 60)) + '" alt="" style=\"width:60px;height:60px;\"/></div>');
		arr.push('<div class="title"><a href="<%=config.UrlHome%>'+ json.product_id +'.html" target="_blank">'+ json.product_name +'</a></div>');
		var style='';
		for(var kk=0;kk<nodes.length;kk++){
			if($(nodes[kk]).val()==json.product_id){
				style=' style="color:#999"';break;
			}
		}
		if(!_allowSku){
			arr.push('<div class="op-link"'+style+'>禁选含Sku商品</div>');
		}else{
			arr.push('<div class="op-link"><a href="javascript:;" v="'+ json.product_id +'" onclick="selectForProductSelector(this,'+ json.product_id +')"'+style+'>选择</a></div>');
		}
		arr.push('<p class="clear"></p>');
		arr.push('</li>');
	}
	$(_productSelector.dialog).find("div[v='data-list-options'] ul").html(arr.join(""));
}
function selectItemForProductSelector(json){
	if(!_productSelector || !_productSelector.dialog)
		return false;
	var html='';
	html += '<li><input type="hidden" name="productId" value="'+ json.product_id +'"/>';
	html += '<div class="img"><img src="' + (formatImageUrl(json.img_src, 60, 60)) + '" alt="" style=\"width:60px;height:60px;\"/></div>';
	html += '<div class="title"><a href="<%=config.UrlHome%>'+ json.product_id +'.html" target="_blank">'+ json.product_name +'</a>';

	html += '<p class="move-links">';
	html += '<a href="javascript:void(0);" onclick="moveItemsForSelector(this,\'first\');" class="move-first" title="置顶">&nbsp;</a>';
	html += '<a href="javascript:void(0);" onclick="moveItemsForSelector(this,\'up\');" class="move-up" title="上移">&nbsp;</a>';
	html += '<a href="javascript:void(0);" onclick="moveItemsForSelector(this,\'down\');" class="move-down" title="下移">&nbsp;</a>';
	html += '<a href="javascript:void(0);" onclick="moveItemsForSelector(this,\'last\');" class="move-last" title="最末">&nbsp;</a>';
	html += '</p></div>';

	html += '<div class="op-link"><a href="javascript:;" onclick="removeDataItemForSelector(this)">移除</a></div>';
	html += '<p class="clear"></p>';
	html += '</li>';
	var o=$(_productSelector.dialog).find("div[v='data-list-selected'] ul");
	o.append(html);
	var nodes=o.find("li");
	o.scrollTop(nodes.length * 70);
}
function selectForProductSelector(obj, p_id){
	if(!_productSelector || !_productSelector.dialog)
		return false;
	var nodes=$(_productSelector.dialog).find("input[name=productId]");
	for(var i=0;i<nodes.length;i++){
		if(nodes[i].value==p_id){
			return false;
		}
	}
	$.ajax({
		url: "/MTools/GetProductInfo2?t=" + new Date().getTime()
		, type: "post"
		, data: {
			"productid": p_id
		}
		, dataType: "json"
		, success: function(json, textStatus){
			selectItemForProductSelector(json);
			$(obj).css({"color":"#999"});
			selectedCountForProductSelector();
		}, error: function(http, textStatus, errorThrown){
			jsonbox.error(errorThrown);
		}
	});
	return false;
}

    //全选
function selectAllProductSelector()
{
    if (!_productSelector || !_productSelector.dialog)
        return false;
    var allsel = $(_productSelector.dialog).find("div[v='data-list-options'] ul li").find(".op-link a");
    var pidarray = [];
    allsel.each(function (i) {
        pidarray.push($(this).attr("v"));
    });
    if (pidarray.length == 0)
    {
        return false;
    }
    var pids = pidarray.join(',');
    $.ajax({
        url: "/MTools/GetProductList2?t=" + new Date().getTime()
		, type: "get"
		, data: {
		    "ids": pids
		}
		, dataType: "json"
		, success: function (json, textStatus) {
		    for (var i = 0; i < json.length; i++) {
		        var jsonObj = json[i];
		        selectItemForProductSelector(jsonObj);
		    }
		    selectedCountForProductSelector();
		}, error: function (http, textStatus, errorThrown) {
		    jsonbox.error(errorThrown);
		}
    });
  
    
    return false;
}

function selectedCountForProductSelector(){
	var o=$(_productSelector.dialog);
	$(o).find("span[v=count]").html(o.find("input[name=productId]").length);
}
function removeDataItemForSelector(obj){
	var p_id=$(obj).parent().parent().find("input[name=productId]").val();
	$(obj).parent().parent().remove();
	$(_productSelector.dialog).find("div[v='data-list-options'] ul").find("a[v="+p_id+"]").css({"color":"#06F"});
	selectedCountForProductSelector();
}
function moveItemsForSelector(obj, type){
	var mObj=$(obj).parent().parent().parent();
	var nodes=$(_productSelector.dialog).find("div[v='data-list-selected'] ul li");
	var idx=mObj.index();
	var len=nodes.length;
	if(mObj && len>0){
		switch(type){
			case "first":
				if(idx>0){
					mObj.insertBefore(nodes[0]);
				}
				break;
			case "up":
				if(idx>0){
					mObj.insertBefore(nodes[idx-1]);
				}
				break;
			case "down":
				if(idx+1<len){
					mObj.insertAfter(nodes[idx+1]);
				}
				break;
			case "last":
				if(idx+1<len){
					mObj.insertAfter(nodes[len-1]);
				}
				break;
		}
	}
}
</script>
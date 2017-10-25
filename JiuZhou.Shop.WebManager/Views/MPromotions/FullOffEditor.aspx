<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/style/style.css" rel="stylesheet" type="text/css" />

<%Html.RenderPartial("Base/_PageHeadControl"); %>
<title><%=ViewData["pageTitle"]%></title>
</head>
<body>
<%Html.RenderPartial("Base/_SimplePageTopControl"); %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
    int fulloffid = DoRequest.GetQueryInt("fid");
	UpLoadFile upload = new UpLoadFile(false);
	string uploadRoot = upload.GetUploadRoot.StartsWith("/") ? upload.GetUploadRoot.Substring(1) : upload.GetUploadRoot;
	string imageRootUrl = config.UrlImages + uploadRoot;

    FullOffDetail item = (FullOffDetail)(ViewData["fulloffInfo"]);
    if (item == null)
        item = new FullOffDetail();
    
%>

<div id="container-syscp">
<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
</div>
<div class="container-right">
		<div class="position">
       <a href="/" title="管理首页">管理首页</a>
		&gt;&gt;
		<a href="/fulloff" title="满减管理">满减管理</a>
		&gt;&gt;
		<span>满减编辑</span>
		</div>
<form method="post" action="" onsubmit="return submitForm(this)">
<input type="hidden" name="fid" value="<%=fulloffid %>"/>
		<div class="div-tab">
<table id="tab-category" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr style="display:none">
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</thead>
<tbody>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">满减标题<b>*</b></td>
    <td class="inputText"><input type="text" id="fullname" name="fullname" value="<%=item.fulloff_name%>" class="input" onblur=""/></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">满减描述<b>*</b></td>
    <td class="inputText"><input type="text" id="fulldesc" name="fulldesc" value="<%=item.fulloff_desc%>" class="input" /></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">规&nbsp;&nbsp;则<b>*</b></td>
    <td class="inputText" colspan="2">
    每满 <input type="text" id="minprice" name="minprice" value="<%=item.min_price%>" class="input" style="width:60px"/> 元&nbsp;减 
    <input type="text" id="offprice" name="offprice" value="<%=item.off_price%>" class="input" style="width:60px"/> 元
    </td>
    <td>&nbsp;</td>
  </tr>
 <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">开始时间<b>*</b></td>
    <td class="inputText">
    <input type="text" id="box-sdate" name="sdate" value="<%=item.begin_time==null?DateTime.Now.ToString("yyyy-MM-dd"):DateTime.Parse(item.begin_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
	<input type="text" id="box-shours" name="shours" value="00" class="input" style="width:40px" title="数字0至23"/> 时
    <input type="text" id="box-sminutes" name="sminutes" value="00" class="input" style="width:40px" title="数字0至59"/> 分
<script type="text/javascript">
    Atai.addEvent(window, "load", function () {
        var hBox = Atai.$("#box-shours");
        var mBox = Atai.$("#box-sminutes");
        var tips = Atai.$("#tips-starttime");
        Atai.addEvent(hBox, "blur", function () {
            if (!Atai.isInt(this.value) || parseInt(this.value) < 0 || parseInt(this.value) > 23) {
                tips.className = "tips-icon";
                tips.innerHTML = " [时] 请填写0至23之间的数字";
            }
        });
        Atai.addEvent(mBox, "blur", function () {
            if (!Atai.isInt(this.value) || parseInt(this.value) < 0 || parseInt(this.value) > 59) {
                tips.className = "tips-icon";
                tips.innerHTML = " [分] 请填写0至59之间的数字";
            }
        });
        Atai.addEvent(hBox, "keyup", function () {
            if (Atai.isInt(this.value) && parseInt(this.value) >= 0 && parseInt(this.value) < 24) {
                tips.className = "tips-text"; tips.innerHTML = "";
            }
        });
        Atai.addEvent(mBox, "keyup", function () {
            if (Atai.isInt(this.value) && parseInt(this.value) >= 0 && parseInt(this.value) < 60) {
                tips.className = "tips-text"; tips.innerHTML = "";
            }
        });
    });
</script></td>
    &nbsp;
    <td><div class="tips-text" id="tips-starttime">&nbsp;</div></td>
  </tr>

  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">结束时间<b>*</b></td>
    <td class="inputText">
    <input type="text" id="box-edate" name="edate" value="<%=item.end_time==null?DateTime.Now.AddDays(7).ToString("yyyy-MM-dd"):DateTime.Parse(item.end_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
	<input type="text" id="box-ehours" name="ehours" value="23" class="input" style="width:40px" title="数字0至23"/> 时
    <input type="text" id="box-eminutes" name="eminutes" value="59" class="input" style="width:40px" title="数字0至59"/> 分
<script type="text/javascript">
    Atai.addEvent(window, "load", function () {
        var hBox = Atai.$("#box-ehours");
        var mBox = Atai.$("#box-eminutes");
        var tips = Atai.$("#tips-endtime");
        Atai.addEvent(hBox, "blur", function () {
            if (!Atai.isInt(this.value) || parseInt(this.value) < 0 || parseInt(this.value) > 23) {
                tips.className = "tips-icon";
                tips.innerHTML = " [时] 请填写0至23之间的数字";
            }
        });
        Atai.addEvent(mBox, "blur", function () {
            if (!Atai.isInt(this.value) || parseInt(this.value) < 0 || parseInt(this.value) > 59) {
                tips.className = "tips-icon";
                tips.innerHTML = " [分] 请填写0至59之间的数字";
            }
        });
        Atai.addEvent(hBox, "keyup", function () {
            if (Atai.isInt(this.value) && parseInt(this.value) >= 0 && parseInt(this.value) < 24) {
                tips.className = "tips-text"; tips.innerHTML = "";
            }
        });
        Atai.addEvent(mBox, "keyup", function () {
            if (Atai.isInt(this.value) && parseInt(this.value) >= 0 && parseInt(this.value) < 60) {
                tips.className = "tips-text"; tips.innerHTML = "";
            }
        });
    });
</script>
    </td>
    &nbsp;
    <td><div class="tips-text" id="tips-endtime">&nbsp;</div></td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable" valign="top">图&nbsp;&nbsp;标</td>
    <td class="inputText" valign="top">
    <input type="hidden" id="upload-image" name="image" value="<%=item.img_src %>" />
<div id="upload-image-box" class="upload-image-box" style="width:160px;height:160px;line-height:160px;" onclick="ajaxUploadClick(this,Atai.$('#upload-image'))">
暂无图片
</div>
<div class="upload-image-box-botton" style="color:#666;">
&nbsp;<input type="button" class="view-file" onclick="$('#upload-image-box').click()" value="浏览..."/>
<br/><br/>
<p>&nbsp;<a href="javascript:;" onclick="showImageListBox(setImage)" style="color:blue">从图片库中选择</a></p>
</div>
<script type="text/javascript">
    function setImage(path, fullPath) {
        Atai.$("#upload-image").value = path;
        var _uploadImageBox = Atai.$("#upload-image-box");
        var path = formatImageUrl(fullPath, 160, 160);
        _uploadImageBox.style.background = "url(" + path + ") center center no-repeat";
        _uploadImageBox.innerHTML = "";
    } //imageRootUrl

</script>
    </td>
    <td>&nbsp;</td>
  </tr>
  <tr>
  <td style="width:3%">&nbsp;</td>
  <td class="lable" colspan="3"><b style="color:#333;font-weight:bold">满减商品</b></td>
  <td>
  <a name="addpro" href="javascript:;" onclick="showFullProductSelector()" style="font-size:16px;font-weight:bold">添加满减商品</a>
  <a href="javascript:;" onclick="addAll()" style="font-size:16px;font-weight:bold">添加所有商品</a>
  <a id ="selectfulloff" name="tips" style="visibility:hidden" >(已选择全场满减)</a>
  </td>
  </tr>
  </tbody>
</table>
</div>

<%
    List<FullOffItems> items = (List<FullOffItems>)(ViewData["infoList"]);
    if (items == null)
        items = new List<FullOffItems>();
    var datacount = items.Count;
    var pagecount = 0;
    if (datacount % 10 == 0)
    {
        pagecount = datacount / 10;
    }
    else {
        pagecount = datacount / 10 + 1;
    }
%>
<div id="image-list-box-page-links" class="page-idx">
</div>
<table id="table-Product" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:3%">&nbsp;</th>
    <th style="width:10%">&nbsp;</th>
    <th>商品名</th>
    <th style="width:10%">售价</th>
    <th style="width:12%">&nbsp;</th>
    <th style="width:8%">操作</th>
  </tr>
</thead>
<tbody id="fulloffbody">


</tbody>
</table>
<div id="image-list-box-page-links2" class="page-idx">
</div>
<script type="text/javascript">
    var postids = [];
    var datacount = <%=datacount %>;
    var pagecount = <%=pagecount %>;
    var jsonList = null;
    $(function () {
    $.ajax({
	    url: "/MPromotions/getfulloffitem"
        , data: {"fid":<%=fulloffid%>}
        , type: "post"
		, dataType: "json"
        , async : false
		, success: function (json) {
          jsonList = json.data;
          postids = [];
          for(var i=0;i<jsonList.length;i++){
              if(i>0) initList+=",";
	          initList+=jsonList[i].product_id;
              postids.push(jsonList[i].product_id);
          }
          if(jsonList.length>0&&jsonList[0].product_id!=0){
              getProductList(1);
          }else if(jsonList.length>0&&jsonList[0].product_id==0){
              addAll();
          }
        }
        });
    });
    
var _formatAjaxPageLinkCount=0;
function formatPageLink(pagecount, pageindex, type){
	_formatAjaxPageLinkCount++;
	var arr=[];
	var maxCount=8;
	var n = pageindex - (maxCount / 2);
	if (n <= 0) n = 1;
	if (pageindex > 1){
		arr.push("		<a href=\"javascript:ChangePage(1," + type + ");\" title=\"首页\">&lt;&lt;</a>");
		arr.push("		<a href=\"javascript:ChangePage(" + (pageindex - 1) + "," + type + ")\" title=\"上页\">&lt;</a>");
	}else{
		arr.push("		<strong>&lt;&lt;</strong>");
		arr.push("		<strong>&lt;</strong>");
	}
	for (var k = n; k < (n + maxCount); k++){
		if (k <= pagecount){
			if (k == pageindex){
				arr.push("		<strong><span>" + k + "</span></strong>");
			}else{
				arr.push("		<a href=\"javascript:ChangePage(" + k + "," + type + ")\" title=\"第" + k + "页\">" + k + "</a>");
			}
		}else{
			if (k == pageindex)
				arr.push("		<strong><span>" + k + "</span></strong>");
		}
	}
	if (pageindex < pagecount){
		arr.push("		<a href=\"javascript:ChangePage(" + (pageindex + 1) + "," + type + ")\" title=\"下页\">&gt;</a>");
		arr.push("		<a href=\"javascript:ChangePage(" + pagecount + "," + type + ")\" title=\"末页\">&gt;&gt;</a>");
	}else{
		arr.push("		<strong>&gt;</strong>");
		arr.push("		<strong>&gt;&gt;</strong>");
	}
	arr.push("		<strong class=\"txt\"><span>" + pageindex + "</span>/" + pagecount + "</strong>");
    arr.push("   <strong class=\"txt\">共 " + datacount +" 条记录</strong>");
	arr.push("		<strong class=\"goto\"><input id=\"goto-" + _formatAjaxPageLinkCount + "\" type=\"text\" value=\"" + (pageindex + 1 < pagecount ? (pageindex + 1) : pagecount) + "\" onclick=\"this.select()\"/></strong>");
	arr.push("		<a href=\"javascript:;\" onclick=\"ChangePage(Atai.$('#goto-" + _formatAjaxPageLinkCount + "').value," + type + ")\" title=\"GO\">GO</a>");
	return arr.join("\r\n");
}

function ChangePage(pageIndex,type){
    if(type==0){
	    getProductList(pageIndex);
    }
    if(type==1){
        parseFullProductSelectorData(pageIndex);
    }
}
var initList="";
function getProductList(pageindex){
    var changeLinks = formatPageLink(pagecount, pageindex, 0); 
    var changeLinks2 = formatPageLink(pagecount, pageindex, 0);
    var nodes=jsonList;
    var htmls = [];
    if (nodes != null && nodes.length > 0) {
        for (var i = (pageindex - 1) * 10; i < pageindex * 10; i++) {
            if(nodes[i]==null)
                break;   		    
		    htmls.push('<tr>');
		    htmls.push('<td>&nbsp;</td>');
            htmls.push('<td style="width:70px;height:74px;"><input type="hidden" v="product-id" value="'+ nodes[i].product_id +'"/>');
		    htmls.push('<a href="<%=config.UrlHome%>'+ nodes[i].product_id +'.html" target="_blank">');
            htmls.push('<img src="' + formatImageUrl(nodes[i].img_src, 120, 120) + '" style="width:60px;height:60px" alt=""/></a></td>');
            htmls.push('<td>');
		    htmls.push('<p><a href="<%=config.UrlHome%>'+ nodes[i].product_id +'.html" target="_blank">'+ nodes[i].product_name +'</a></p>');
	        htmls.push('<p class="pname" style="color:#999">编码：'+ nodes[i].product_code +'</p></td>');
	    	htmls.push('<td style="font-family:Arial;color:#ff6600">￥'+ nodes[i].sale_price +'</td>');
		    htmls.push('<td>&nbsp;</td>');
		    htmls.push('<td><a href="javascript:;" onclick="removeProductData(this)">移除</a></td>');
		    htmls.push('</tr>');
		 }
       }
    $("#image-list-box-page-links").html(changeLinks);
    $("#fulloffbody").html(htmls.join("\n"));
    $("#image-list-box-page-links2").html(changeLinks2);      
}

function removeProductData(obj){
    var did = $(obj).parent("td").parent("tr").find("*[v='product-id']").val();
    initList="";
    var pcount = postids.length;
    for(var i = 0;i < pcount;i++){
        if(did==postids[i]){
            postids.splice(i,1);
        }
        if(did==jsonList[i].product_id){
            jsonList.splice(i,1);
            i--;
            pcount--;
        }else{
            initList = initList + jsonList[i].product_id + ",";    
        }
    }
    $(obj).parent("td").parent("tr").remove();
}

function showFullProductSelector(){
	var exceptList=[];
	showProductSelector(function(ids){
		if(ids=="") return false;
		$.ajax({
			url: "/MTools/GetProductList2"
			, type: "post"
			, data: {
				"ids": ids
			}
			, dataType: "json"
			, success: function(json, textStatus){
				jsonList = json;
                pagecount = Math.ceil(jsonList.length/10);
  
                parseFullProductSelectorData(1);
                postids=[];
                initList="";
                for(var i = 0;i < jsonList.length;i++){
                    postids.push(jsonList[i].product_id);
                    if(i>0) initList+=",";
                    initList+=jsonList[i].product_id;
                }
			}, error: function(http, textStatus, errorThrown){
				jsbox.error(errorThrown);
			}
});
	}, initList, exceptList, true, 1);//第四个参数ture=允许选择带Sku商品;false=禁止选择带Sku商品
}

function parseFullProductSelectorData(pageindex){
 	var ids=[];
	for(var i=0;i<jsonList.length;i++){
		ids.push(jsonList[i].product_id);
	}
    changeLinks = formatPageLink(pagecount, pageindex, 1); 
    changeLinks2 = formatPageLink(pagecount, pageindex, 1);
 
	var htmls=[];
    var nodes=jsonList;
	for(var i=(pageindex - 1) * 10; i < pageindex * 10;i++){
		//if(items.contains(json.product_id))
		//	continue;//去除重复的ID
        if(nodes[i]==null)
                break;
		htmls.push('<tr>');
		htmls.push('<td>&nbsp;</td>');
        htmls.push('<td style="width:70px;height:74px;"><input type="hidden" v="product-id" value="'+ nodes[i].product_id +'"/>');
	    htmls.push('<a href="<%=config.UrlHome%>'+ nodes[i].product_id +'.html" target="_blank">');
        htmls.push('<img src="' + formatImageUrl(nodes[i].img_src, 120, 120) + '" style="width:60px;height:60px" alt=""/></a></td>');
        htmls.push('<td>');
        htmls.push('<p><a href="<%=config.UrlHome%>'+ nodes[i].product_id +'.html" target="_blank">'+ nodes[i].product_name +'</a></p>');
        htmls.push('<p class="pname" style="color:#999">编码：'+ nodes[i].product_code +'</p></td>');
   	    htmls.push('<td style="font-family:Arial;color:#ff6600">￥'+ nodes[i].sale_price +'</td>');
        htmls.push('<td>&nbsp;</td>');
		htmls.push('<td><a href="javascript:;" onclick="removeProductData(this)">移除</a></td>');
		htmls.push('</tr>');
	}
	$("#image-list-box-page-links").html(changeLinks);
    $("#fulloffbody").html(htmls.join("\n"));
    $("#image-list-box-page-links2").html(changeLinks2);
}
var _isall = false;

$(function(){
    if(jsonList.length==1&&jsonList[0].product_id==0){
        $("a[name='tips']").attr("style","color:Red");
        $("a[name='addpro']").hide();
        _isall = true;
    }
});

function addAll() {
if(!_isall){
    jsonList = null;
    initList = "";
    getProductList(0);
    $("a[name='tips']").attr("style","color:Red");
    $("a[name='addpro']").hide();
    postids = [0];
    _isall = true;
    }else{
    $("a[name='tips']").attr("style","visibility:hidden");
    $("a[name='addpro']").show();
    postids = [];
    _isall = false;
    }    
}

function submitForm(form){
    if (showLoadding) 
    showLoadding();
	var obj=Atai.$("#tips-message");
	var postData = getPostDB(form);
    var postids2 = "";
    for(var i = 0;i<postids.length;i++)
    {
        if(i>0) postids2+=",";
        postids2+=postids[i];
    }
	$.ajax({
	    url: "/MPromotions/PostFullOffItems"
		, data: postData + "&ids=" + postids2
        , type: "post"
		, dataType: "json"
		, success: function (json) {
		    obj.className = "tips-text tips-icon";
		    if (json.error) {
		        obj.innerHTML = json.message;
		    } else {
		        obj.className = "tips-text";
		        jsbox.success(json.message, window.location.href);
		    }
		    if (closeLoadding) closeLoadding();
		}
	});
	return false;
}

</script>
		
<table class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:3%">&nbsp;</th>
    <th class="lable"><input type="submit" value="  确定提交  " class="submit"/></th>
    <th colspan="2"><div class="tips-text" id="tips-message"></div></th>
  </tr>
  </thead>
</table>
</form>
</div>
</div>
<br/><br/><br/><br/><br/><br/>
<br/><br/><br/>
<%Html.RenderPartial("MGoods/SelectProductControl"); %>
<%Html.RenderPartial("UploadBaseControl"); %>
<%Html.RenderPartial("ImageListBoxControl");//图片选择 %>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>
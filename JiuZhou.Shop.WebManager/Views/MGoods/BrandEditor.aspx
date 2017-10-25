<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %><%@ Import Namespace="JiuZhou.Cache" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
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
    BrandInfo info = new BrandInfo();
    int brandid = DoRequest.GetQueryInt("brandid",0);
    var res = GetBrandDetail.Do(brandid);
    if (res != null && res.Body != null) {
        info = res.Body;
    }

    List<ShopList> shopList = new List<ShopList>();
    DoCache chche = new DoCache();
    if (chche.GetCache("shoplist") == null)
    {
        var resshop = GetShopInfo.Do(-1);
        if (resshop != null && resshop.Body != null && resshop.Body.shop_list != null)
        {
            shopList = resshop.Body.shop_list;
            chche.SetCache("shoplist", shopList);
            if (shopList.Count == 0)
            {
                chche.RemoveCache("shoplist");
            }
        }
    }
    else
    {
        shopList = (List<ShopList>)chche.GetCache("shoplist");
    }
%>
<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
<div class="position">
当前位置：
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <a href="/mgoods/brandlist">品牌列表</a> &gt;&gt; <span>编辑品牌信息</span>
</div>
<form id="brandauthForm" method="post" action="" onsubmit="return submitBrandData(this)">
<input type="hidden" name="brandid" value="<%=brandid%>"/>
		<div class="div-tab">
<table id="tab-category" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr style="display:none">
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</thead>
<tbody>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">品牌名称<b>*</b></td>
    <td class="inputText"><input type="text" name="brandName" value="<%=info.brand_name%>" class="input" /></td>
    <td><input type="radio" name="brandstate" onclick="checkedthis(this)" value="0"<%if(info.brand_state==0){Response.Write(" checked=\"checked\"");}%> /> 可见
    &nbsp;|&nbsp;
    <input type="radio" name="brandstate" onclick="checkedthis(this)" value="1"<%if(info.brand_state!=0){Response.Write(" checked=\"checked\"");}%>/> 禁用
    </td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable" valign="top">介&nbsp;&nbsp;绍</td>
    <td class="inputText"> <textarea name="intro" class="textarea" style="height:160px"><%=info.brand_intro%></textarea></td>
    <td>&nbsp;</td>
  </tr>

    <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable" valign="top">图&nbsp;&nbsp;标</td>
    <td colspan="2" class="inputText">
    <input type="hidden" id="upload-image" name="logosrc" value="<%=info.logo_src%>" />
<div id="upload-image-box" class="upload-image-box" style="width:120px;height:120px;line-height:120px;cursor:default;">
暂无图标
</div>          
<div class="upload-image-box-botton" style="color:#666;">
&nbsp;<input type="button" class="view-file" onclick="ajaxUploadClick(Atai.$('#upload-image-box1'),Atai.$('#upload-image1'))" value="浏览..."/>
<br/><br/>
<p>&nbsp;<a href="javascript:;" onclick="showImageListBox(setImage2)" style="color:blue">从图片库中选择</a></p>
</div>
    </td>
  </tr>

  </tbody>
</table>
<table id="table-brandauth" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:3%">&nbsp;</th>
    <th>授权证书</th>
    <th style="width:16%">过期时间</th>
    <th style="width:20%">商家</th>
    <th style="width:8%">
      <div class="console" style="padding:0;margin:0;border:0;height:auto;line-height:auto;text-align:left;">
        <a href="javascript:;" onclick="showItem()" style="width:35px;">新增</a>
      </div>
    </th>
  </tr>
</thead>
<tbody>
  <%
      List<BrandAuthInfo> authlist = new List<BrandAuthInfo>();
      if (info.auth_list != null)
          authlist = info.auth_list;
      foreach (BrandAuthInfo em in authlist)
      {
  %>
  <tr name="auth-tr">
    <td >
      &nbsp;<input type="hidden" name="authid" value="<%=em.brand_auth_id %>"/>
    </td>
    <td class="inputText">
      <input type="hidden" id="upload-image-id<%=em.brand_auth_id %>" name="authorizationsrc" value="<%=em.authorization_src%>" />
      <div id="upload-image-box-id<%=em.brand_auth_id %>" class="upload-image-box" style="width:120px;height:120px;line-height:120px;cursor:default;">
        暂无证书
      </div>          
      <div class="upload-image-box-botton" style="color:#666;">
        &nbsp;<input type="button" class="view-file" onclick="ajaxUploadClick(Atai.$('#upload-image-box-id<%=em.brand_auth_id %>'),Atai.$('#upload-image-id<%=em.brand_auth_id %>'))" value="浏览..."/>
        <br/><br/>
        <p>&nbsp;<a href="javascript:;" onclick="showImageListBox(setImage1,<%=em.brand_auth_id %>)" style="color:blue">从图片库中选择</a></p>
        <p>&nbsp;<a href="javascript:;" onclick="clearimg(<%=em.brand_auth_id %>)" style="color:blue">清空授权书</a></p>
      </div>
    </td>
    <td class="inputText">
      <input type="text" name="date" value="<%=em.expired_time==null?DateTime.Now.AddDays(15).ToString("yyyy-MM-dd"):DateTime.Parse(em.expired_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
    </td>
    <td class="inputText">
      <select name="shopid" style="height:26px;width:160px;">
        <option value="0" selected="selected">请选择商家</option>
        <%
           foreach (ShopList shop in shopList)
            {
                if (shop.shop_state != 0)
                    continue;
                if (shop.shop_id == em.shop_id)
                {
                     %>
        <option value="<%=shop.shop_id%>" selected="selected"><%=shop.shop_name%></option>
         <%     }
                else
                { %>
        <option value="<%=shop.shop_id%>"><%=shop.shop_name%></option>
        <%
                }  
            }
        %>
      </select>
    </td>
    <td><a href="javascript:;" onclick="removeSelectorData(this)">移除</a></td>
  </tr>
  <script type="text/javascript">
      <%if(!string.IsNullOrEmpty(em.authorization_src)){%>Atai.addEvent(window,"load",function(){
	setImage('<%=em.authorization_src%>','<%=FormatImagesUrl.GetProductImageUrl(em.authorization_src, 120, 120)%>','upload-image-id<%=em.brand_auth_id %>','#upload-image-box-id<%=em.brand_auth_id %>');
});<%}%>
  </script>
  <%  } %>
</tbody>
</table>
		</div>
 <table class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:42%">&nbsp;</th>
    <th class="lable"><input type="button" id="loadding3" value="  确定提交  " onclick="$('#brandauthForm').submit()" class="submit" style="width:120px"/></th>
    <th><div class="tips-text" id="tips-message"></div></th>
  </tr>
</thead>
</table>
</form>
	</div>
</div>
<script type="text/javascript">
var _count = 0;
function showItem() {
    var o = $("#table-brandauth");
    var arr = [];
    arr.push('<tr name="auth-tr"><td>&nbsp;<input type="hidden" name="authid" value="0"/></td>');
    arr.push('<td class="inputText"><input type="hidden" id="upload-image-idnew' + _count + '" name="authorizationsrc" value="" />');
    arr.push('<div id="upload-image-box-idnew' + _count + '" class="upload-image-box" style="width:120px;height:120px;line-height:120px;cursor:default;">暂无证书</div>');
    arr.push('<div class="upload-image-box-botton" style="color:#666;">');
    arr.push('&nbsp;<input type="button" class="view-file" onclick="ajaxUploadClick(Atai.$(\'#upload-image-box-idnew' + _count + '\'),Atai.$(\'#upload-image-idnew' + _count + '\'))" value="浏览..."/>');
    arr.push('<br/><br/><p>&nbsp;<a href="javascript:;" onclick="showImageListBox(setImage1,\'new' + _count + '\')" style="color:blue">从图片库中选择</a></p><p>&nbsp;<a href="javascript:;" onclick="clearimg(\'new' + _count + '\')" style="color:blue">清空授权书</a></p></div></td>');
    arr.push('<td class="inputText">');
    arr.push('<input type="text" name="date" value="<%=DateTime.Now.ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>');
    arr.push('</td>');
    arr.push('<td class="inputText">');
    arr.push(' <select name="shopid" style="height:26px;width:160px;">');
    arr.push('<option value="0" selected="selected">请选择商家</option>');
    <%
        foreach (ShopList shop in shopList)
            {
                if (shop.shop_state != 0)
                    continue;
                    
    %>
    arr.push('<option value="<%=shop.shop_id%>"><%=shop.shop_name%></option>');
    <%} %>
    arr.push('</select></td>');
    arr.push('<td><a href="javascript:;" onclick="removeSelectorData(this)">移除</a></td>');
    arr.push('</tr>');
    o.find("tbody").append(arr.join("\n"));
    _count++;
}
    function checkedthis(obj) {
        if (obj.checked) {
            $(obj).attr("checked", true);
            $("input[name='brandstate']").each(function () {
                if (this != obj)
                    $(this).attr("checked", false);
            });
        } else {
            $(obj).attr("checked", false);
            $("input[name='brandstate']").each(function () {
                if (this != obj)
                    $(this).attr("checked", true);
            });
        }
    }
    function clearimg(id) {
        //var _str = "#upload-image-id";
        Atai.$("#upload-image-id"+id).value = "";
        var _uploadImageBox = Atai.$("#upload-image-box-id"+id);
        //var path = formatImageUrl(fullPath, 120, 120);
        _uploadImageBox.style.background = "url() center center no-repeat";
        _uploadImageBox.innerHTML = "";
    }
    function setImage1(path, fullPath,id) {
        //var _str = "#upload-image-id";
        Atai.$("#upload-image-id"+id).value = path;
        var _uploadImageBox = Atai.$("#upload-image-box-id"+id);
        var path = formatImageUrl(fullPath, 120, 120);
        _uploadImageBox.style.background = "url(" + path + ") center center no-repeat";
        _uploadImageBox.innerHTML = "";
    }

    function setImage2(path, fullPath) {
        Atai.$("#upload-image").value = path;
        var _uploadImageBox = Atai.$("#upload-image-box");
        var path = formatImageUrl(fullPath, 120, 120);
        _uploadImageBox.style.background = "url(" + path + ") center center no-repeat";
        _uploadImageBox.innerHTML = "";
    }
    function setImage(path,fullPath,img,type){
	    Atai.$(img).value=path;
	    var _uploadImageBox=Atai.$(type);
	    //var path = formatImageUrl(fullPath, 120, 120);
	    _uploadImageBox.style.background="url(" + fullPath + ") center center no-repeat";
	    _uploadImageBox.innerHTML="";
    }

<%if(!string.IsNullOrEmpty(info.logo_src)){%>Atai.addEvent(window,"load",function(){
	setImage('<%=info.logo_src%>','<%=FormatImagesUrl.GetProductImageUrl(info.logo_src, 120, 120)%>','#upload-image','#upload-image-box');
});<%}%>

function createXmlDocument(nodes){
	var xml='<?xml version="1.0" encoding="utf-8"?>';
	xml += '<items>';
	if (nodes != undefined) {
	    for (var i = 0; i < nodes.length; i++) {
	        xml += nodes[i];
	    }
	}
	xml += '</items>';
	return xml;
}

function submitBrandData(form){
    if ($("input[name='brandName']").val().length < 1) {
        jsbox.error("请填写品牌名");
        return false;
    }

   	var nodes=[];
    var _error = false;
    var _ermsg = "";
	var list=$("tr[name='auth-tr']").each(function () {
        var authid = $(this).find("input[name='authid']").val();
        var authorizationsrc = $(this).find("input[name='authorizationsrc']").val();
        var time = $(this).find("input[name='date']").val();
        var shopid = $(this).find("select[name=shopid] option:selected").val();

        if(shopid<1){
            _error = true;
	        _ermsg = "请选择商家";
        }

        var node = '<item authid="' + authid + '" authorizationsrc="' + authorizationsrc + '" time="' + time +'" shopid="' + shopid + '">';

	        node += '</item>';

	        nodes.push(node);
    });

    if (nodes.length < 1) {
	      if (closeLoadding) closeLoadding();
	      jsbox.error("请填写至少一个明细");
	      if (closeLoadding) closeLoadding();
	      return false;
    }
	if (_error) {
	      jsbox.error(_ermsg);
	      if (closeLoadding) closeLoadding();
	      return false;
	}

	var xml=createXmlDocument(nodes);

    if (showLoadding) showLoadding();
	var postData=getPostDB(form);
	$.ajax({
		url: "/Mgoods/PostBrandData"
		, data: postData + "&xml=" + encodeURIComponent(xml)
        , type: "post"
		, dataType: "json"
		, success: function(json){
			if(json.error){
				jsbox.error(json.message);
			}else{
				jsbox.success(json.message, window.location.href);
			}
			if(closeLoadding) closeLoadding();
		}
	});
	return false;
}

function removeSelectorData(obj){
	$(obj).parent("td").parent("tr").remove();
}
</script>
<br/><br/>
<%Html.RenderPartial("UploadBaseControl"); %>
<%Html.RenderPartial("ImageListBoxControl");//图片选择 %>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body></html>
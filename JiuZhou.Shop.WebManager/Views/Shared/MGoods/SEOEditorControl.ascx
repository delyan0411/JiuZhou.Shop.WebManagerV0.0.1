<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %><%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div id="product-seo-boxControl" class="box" style="height:490px;width:590px;">
	<div class="name">
		SEO设置
		<div class="close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<form action="" onsubmit="return UpdateProductSEO(this)">
<input type="hidden" id="otp-productid" name="productid" value=""/>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="left">&nbsp;</td>
    <td><span class="tips-text" style="color:#ff6600">&nbsp;</span></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;">商品名称：</td>
    <td><input type="text" id="old-pname" class="input" value="" style="width:390px;height:25px;line-height:25px;" disabled="disabled"/></td>
  </tr>
  <tr style="height:70px">
    <td class="left" valign="top">页面标题：</td>
    <td>
<textarea name="stitle" style="height:50px;line-height:20px;width:390px"></textarea>
    </td>
  </tr>
  <tr style="height:80px">
    <td class="left" valign="top">关&nbsp;键&nbsp;词：</td>
    <td>
<textarea name="skeywords" style="height:50px;line-height:20px;width:390px"></textarea>
    </td>
  </tr>
  <tr style="height:170px">
    <td class="left" valign="top">页面描述：</td>
    <td valign="top">
<textarea name="stext" style="height:150px;width:390px"></textarea>
    </td>
  </tr>

  <tr>
    <td class="left" style="height:30px;">&nbsp;</td>
    <td><input type="submit" class="submit" value="  保 存  " /></td>
  </tr>
</table>
</form>
<script type="text/javascript">
function UpdateProductSEO(form){
	var postData=getPostDB(form);
	Atai.ajax.post({
			url: "/MGoods/UpdateSEO"
			, data: postData
			, dataType: "json"
			, callback: function(json){
				if(json.error){
					$("#product-seo-boxControl span[class='tips-text']").html(json.message);return false;
				}else{
					if(_productSeoBoxDialog) _productSeoBoxDialog.close();//window.location.href=window.location.href;
				}
			}
	});
	return false;
}
var _productSeoBoxDialog = false;
function _productSeoBox(event, productid){
	var boxId="#product-seo-boxControl";
	
	var postData="productid=" + productid;
	$.ajax({
		url: "/MTools/GetProductInfo"
		, type: "post"//同步
		, data: postData
		, dataType: "json"
		, success: function(json){
			if(json){
				$("#otp-productid").val(json.p_id);
				$("#old-pname").val(json.p_name);
				$(boxId + " textarea[name='stitle']").val(json.s_title);
				$(boxId + " textarea[name='skeywords']").val(json.s_keywords);
				$(boxId + " textarea[name='stext']").val(json.s_text);
			}
		}
	});

	
	var box = Atai.$(boxId);
	var boxName=Atai.$(boxId + " div[class='name']")[0];
	var _dialog = new iframeDialog();
	_dialog.copyDialog({
		 copy: box
		, move: boxName
		, close: Atai.$(boxId + " div[class='close']")[0]
	});
	_productSeoBoxDialog=_dialog;
	return false;
}
</script>
</div>
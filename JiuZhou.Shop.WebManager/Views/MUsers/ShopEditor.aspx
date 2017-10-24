<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<script type="text/javascript" src="/Tools/AreaDataToJson" charset="utf-8"></script>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<script type="text/javascript" src="/ckeditor/ckeditor.js" charset="utf-8"></script>
<script type="text/javascript" src="/javascript/crypto-js2.js" charset="utf-8"></script>
<link href="/style/style.css" rel="stylesheet" type="text/css" />
<%Html.RenderPartial("Base/_PageHeadControl"); %>
<title><%=ViewData["pageTitle"]%></title>
</head>
<body>
<%Html.RenderPartial("Base/_SimplePageTopControl"); %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
	ShopInfo shop = (ShopInfo)(ViewData["shop"]);
    if (shop == null)
        shop = new ShopInfo();
%>
<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
<div class="position">
当前位置：
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <a href="/musers/shoplist">商家列表</a> &gt;&gt; <span>编辑商家信息</span>
</div>
<form method="post" action="" onsubmit="return submitShopData(this)">
<input type="hidden" name="shopid" value="<%=shop.shop_id%>"/>
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
    <td class="lable">店铺名称<b>*</b></td>
    <td class="inputText"><input type="text" name="shopName" value="<%=shop.shop_name%>" class="input" /></td>
    <td>不能超过50个字符</td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">公司名称<b>*</b></td>
    <td class="inputText"><input type="text" name="company" value="<%=shop.company_name%>" class="input" /></td>
    <td>不能超过100个字符</td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">账&nbsp&nbsp;号<b>*</b></td>
    <td class="inputText"><input type="text" name="skeyword" value="<%=shop.shop_key%>" class="input" autocomplete="off" disableautocomplete/></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">密&nbsp&nbsp;码<b>*</b></td>
    <td class="inputText"><input type="password" id="spsword" name="spsword" value="" class="input" autocomplete="off" disableautocomplete/></td>
    <td>不填则默认为原密码</td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">发货地址<b>*</b></td>
    <td class="inputText">
<select id="province-foraddressbox" name="province" style="height:28px;">
	<option value="">--请选择省份--</option>
</select>
&nbsp;
<select id="city-foraddressbox" name="city" style="height:28px;">
	<option value="">--请选择城市--</option>
</select>
<script type="text/javascript">
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
	$(selObj).empty();$(selObj).append("<option value=''>--请选择--</option>");
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
	createAreaOption(0, "#province-foraddressbox");
	$("#province-foraddressbox").change(function(){
		var val=$(this).find("option:selected").val();
		if(val.length>0)
			createAreaOption(val, "#city-foraddressbox");
		else
			clearOptions("#city-foraddressbox");
	});
    var address = "<%=shop.shop_addr%>";
	var parentId=0;
	$("#province-foraddressbox option").each(function(){
		if(address.indexOf($(this).html())>=0){
			parentId=$(this).val();
			$(this).attr("selected","selected");
			createAreaOption(parentId, "#city-foraddressbox");
			$("#city-foraddressbox option").each(function(){
				if(address.indexOf($(this).html())>=0){
					$(this).attr("selected","selected");
				}
			});
		}
	});
});
</script>
    </td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">联系方式<b>*</b></td>
    <td class="inputText"><input type="text" name="linkway" value="<%=shop.link_way%>" class="input" /></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
  <td style="width:3%">&nbsp;</td>
    <td class="lable">快递公司<b>*</b></td>
    <td class="inputText">
    <input type="text" id="supportexpress" name="supportexpress" value="<%=shop.support_express %>" class="input"/>
    </td>
    <td>多个快递公司用“,”隔开</td>
  </tr>
   <tr>
  <td style="width:3%">&nbsp;</td>
    <td class="lable">物流介绍</td>
    <td colspan="2" class="inputText">
    <input type="text" id="deliveryintro" name="deliveryintro" value="<%=shop.delivery_intro %>" class="input"/>
    </td>
  </tr>

  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable" valign="top">售后服务</td>
    <td colspan="2" class="inputText">
      <textarea id="detailContents" name="serviceintro" class="textarea" style="height:260px"><%=shop.service_intro%></textarea>
    </td> 
  </tr>
   <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">开始时间<b>*</b></td>
    <td class="inputText">
    <input type="text" id="box-sdate" name="sdate" value="<%=shop.notice_btime==null?DateTime.Now.ToString("yyyy-MM-dd"):DateTime.Parse(shop.notice_btime).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
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
    <td><div class="tips-text" id="tips-starttime">&nbsp;</div></td>
  </tr>

  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">结束时间<b>*</b></td>
    <td class="inputText">
    <input type="text" id="box-edate" name="edate" value="<%=shop.notice_etime==null?DateTime.Now.AddDays(7).ToString("yyyy-MM-dd"):DateTime.Parse(shop.notice_etime).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
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
    <td><div class="tips-text" id="tips-endtime">&nbsp;</div></td>
  </tr>
    <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable" valign="top">商家公告</td>
    <td colspan="2" class="inputText">
      <textarea id="shopnotice" name="shopnotice" class="textarea" style="height:260px"><%=shop.shop_notice%></textarea>
    </td> 
  </tr>
    <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable" valign="top">备&nbsp;&nbsp;注</td>
    <td colspan="2" class="inputText">
      <textarea name="remarks" class="textarea" style="height:160px"><%=shop.shop_remark%></textarea>
    </td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">&nbsp;</td>
    <td class="inputText"><input type="submit" value="确定提交" class="submit"/></td>
    <td><div class="tips-text" id="tips-message"></div></td>
  </tr>
  </tbody>
</table>
		</div>
</form>
	</div>
</div>
<script type="text/javascript">
    var ckeditor1 = null;
    var ckeditor2 = null;
    $(function () {
        ckeditor1 = CKEDITOR.replace('detailContents');
        ckeditor2 = CKEDITOR.replace('shopnotice');
    });
    function setImage(path, fullPath,id,editor) {
        var html = '<img src="' + fullPath + '"/>';
        //jsbox.error(CKEDITOR.currentInstance.name);
        editor.insertHtml(html);
    }
    function setImage2(obj, path, fullPath, editor) {
        setImage(path, fullPath,0,editor);
    }
    function _fckCallback(editor) {
        showImageListBox(setImage,0,editor);
    }
    function _fckAddPicCallback(editor) {
        upload(new Object(), setImage2,"","",editor);
    }
function submitShopData(form){
    if (showLoadding) showLoadding();
    $("#detailContents").val(CKEDITOR.instances.detailContents.getData());
    $("#shopnotice").val(CKEDITOR.instances.shopnotice.getData());
    var psw = $("#spsword").val();

    if (psw != "" && psw != null) {
        $("#spsword").val(jsCrypt.AES.encrypt(jsCrypt.md5(psw), "5f9bf958d112f8668ac53389df8bceba"));
    }
	var postData=getPostDB(form);
	$.ajax({
		url: "/MUsers/PostShopData"
		, data: postData
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

var jsCrypt = {
    md5: function (val) {
        if (typeof (CryptoJS) != "undefined") {
            return CryptoJS.MD5(val).toString();
        }
        return "";
    }, AES: {
        key: "5f9bf958d112f8668ac53389df8bceba"
		, encrypt: function (data, pwd) {
		    if (typeof (CryptoJS) == "undefined") return "";
		    var key = iv = CryptoJS.enc.Utf8.parse(this.key);
		    if (typeof (pwd) != "undefined") {
		        key = iv = CryptoJS.enc.Utf8.parse(pwd);
		    }
		    var v = CryptoJS.AES.encrypt(data, key, { iv: iv, mode: CryptoJS.mode.ECB, padding: CryptoJS.pad.Pkcs7 });
		    return v.toString();
		}, decrypt: function (data, pwd) {
		    if (typeof (CryptoJS) == "undefined") return "";
		    var key = iv = CryptoJS.enc.Utf8.parse(this.key);
		    if (typeof (pwd) != "undefined") {
		        key = iv = CryptoJS.enc.Utf8.parse(pwd);
		    }
		    var v = CryptoJS.AES.decrypt(data, key, { iv: iv, mode: CryptoJS.mode.ECB, padding: CryptoJS.pad.Pkcs7 });
		    return v.toString(CryptoJS.enc.Utf8);
		}
    }
};

</script>
<br/><br/>

<%Html.RenderPartial("UploadImageControl"); %>
<%Html.RenderPartial("ImageListBoxControl");//图片选择 %>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body></html>
<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %><%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %><%@ Import Namespace="JiuZhou.Cache" %>
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
	int status = DoRequest.GetQueryInt("status",-1);
	//int pStatus = DoRequest.GetQueryInt("payStatus",-1);
	//int dvStatus = DoRequest.GetQueryInt("dvStatus",-1);
	//int sType = DoRequest.GetQueryInt("sType");
 
	//string otype = DoRequest.GetQueryString("ot").ToLower().Trim();
	JiuZhou.ControllerBase.ForeBaseController su=new JiuZhou.ControllerBase.ForeBaseController();
%>

<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
<div class="position">
当前位置：
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>处方药需求</span>
&nbsp;&nbsp;&nbsp;
</div>
<form id="sForm" action="/msell/needlist" method="get" onsubmit="checksearch(this)">
<input type="hidden" name="status" value="<%=status%>"/>
<input type="hidden" name="size" value="<%=DoRequest.GetQueryInt("size", 20)%>"/>
<%--<input type="hidden" name="ocol" value="<%=DoRequest.GetQueryString("ocol")%>"/>
<input type="hidden" name="ot" value="<%=DoRequest.GetQueryString("ot")%>"/>--%>
			<div class="div-tab-h1" style="font-weight:100;color:#333;font-size:12px;height:36px">
		<%--<p><select id="stype" name="stype" style="width:80px">
			<option value="0" init="true">默认搜索</option>
            <option value="1">收货人</option>
            <option value="2">联系电话</option>
            <option value="3">用户ID</option>
            <option value="4">商品名称</option>
            <option value="5">用户名</option>
		</select>
</p>--%><p>
	<select id="oStatus" style="width:80px">
			<option value="-1" init="true">全部状态</option><%--订单状态,支付状态,发货状态--%>
            <option value="0">需求下达</option>
            <option value="1">需求审批通过</option>
            <option value="2">审批不通过</option>
		</select>
</p><p>
<%
	DateTime date = DateTime.Now.AddDays(-15);
%><input type="text" name="sdate" value="<%=DoRequest.GetQueryDate("sDate", date).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
至
<input type="text" name="edate" value="<%=DoRequest.GetQueryDate("eDate", DateTime.Now).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
</p><%--<p style="position:relative">
		<input type="text" id="sQuery" name="q" value="<%=DoRequest.GetQueryString("q")%>" class="input" autocomplete="off" style="height:26px;width:260px;line-height:26px;"/></p>--%>
<p>
<input type="submit" value=" 搜索 " class="submit"/>
</p>
			</div>
</form>
<script type="text/javascript">
var _currUrl="<%=ViewData["currPageUrl"]%>";
function formatUrl(ocol, val, url){
	if(!url) url=_currUrl;
	var reg = ocol + "=[^-]*";
	var reg = new RegExp(ocol + "=[^&\.]*");
	url = url.replace(reg, ocol + "=" + val);
	return url;
}
var dropSType=dropOStatus=false;
Atai.addEvent(window,"load",function(){
//	dropSType=new _DropListUI({
//		input: Atai.$("#stype")
//	});dropSType.maxHeight="260px";dropSType.width="80px";


	dropOStatus=new _DropListUI({
		input: Atai.$("#oStatus")
	});dropOStatus.maxHeight="260px";dropOStatus.width="100px";
	dropOStatus.init();dropOStatus.setDefault("<%=status%>");
});
function checksearch(form){
	
	$("#sForm input[name='status']").val($("#oStatus option:selected").val());
}
var _currUrl="<%=ViewData["currPageUrl"]%>";
function formatUrl(ocol, val, url){
	if(!url) url=_currUrl;
	var reg = ocol + "=[^-]*";
	var reg = new RegExp(ocol + "=[^&\.]*");
	url = url.replace(reg, ocol + "=" + val);
	return url;
}
$(function(){
	$("table[v='order-list']").mouseenter(function(){
		$(this).addClass("table-hover");
	}).mouseleave(function(){
		$(this).removeClass("table-hover");
	});
});
</script>
<%=ViewData["pageIndexLink"]%>
<%
    List<NeedInfo> needList = (List<NeedInfo>)ViewData["infoList"];//主订单列表
    if (needList == null)
        needList = new List<NeedInfo>();
%>
<%
    foreach (NeedInfo need in needList)
    {
%>
<table class="order-list" v="order-list" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th colspan="3">
    <strong>收货地址:
  <%=need.province_name%><%=need.city_name%><%=need.county_name%><%=need.receive_addr%>--收货人:<%=need.receive_name%>;收货人电话:<%
            Response.Write(need.receive_mobile_no);
		%>
	&nbsp;
     <% 
        decimal totalmoney = 0;
         foreach (NeedItem ni in need.need_item_list)
         {
             totalmoney += Convert.ToDecimal(ni.deal_price) * Convert.ToDecimal(ni.sale_num);
         } %>
    <b v="price">￥<%=totalmoney + Convert.ToDecimal(string.IsNullOrEmpty(need.trans_money) ? "0.00" : need.trans_money)%></b> <span v="farePrice">(含运费 <%=Convert.ToDecimal(string.IsNullOrEmpty(need.trans_money) ? "0.00" : need.trans_money)%> 元) </span>&nbsp;&nbsp;
    <span style="color:Green"><%=DateTime.Parse(need.add_time).ToString("yyyy-MM-dd HH:mm:ss")%></span>
    
    <br />联系人:<%=need.link_name%>;联系电话:<%=need.link_mobile_no%>
    <%
        if (Convert.ToInt32(need.need_type) == 2)
        {
			Response.Write("<img src=\"/images/icon/phone-1.png\" align=\"absmiddle\" alt\"手机订单\"/>");
		}
	%>
    </strong>
    <b v="price"></b> <span v="farePrice"></span>
      <span></span>
    &nbsp;
    </th>
    <th style="width:12%;"><%
           
     var servicestate = "";
     if (need.need_state == "0")
     {

         Response.Write("<a style=\"color:green\" onclick=\"updateAddr('" + need.need_id + "','" + need.receive_mobile_no + "', '" + need.province_name + "','" + need.city_name + "', '" + need.county_name + "', '" + need.receive_addr + "', '" + need.receive_name + "')\" href=\"javascript:;\">修改发货信息</a><br/><a href=\"javascript:;\" onclick=\"updateRemarkBox('" + need.need_id + "', '" + need.inner_remark + "')\">需求备注</a>");
         if (!string.IsNullOrEmpty(need.file_url))
         {
             Response.Write("<br/><a href=\""+need.file_url+"\" target=\"_blank\">查看处方单</a>");
         }
     }
     else if
          (need.need_state == "1")
         {
             servicestate = "需求已通过";
         }
     else if (need.need_state == "2")
     {
         servicestate = "需求被取消";
     }
     //else if (need.need_state =="5")
     //{
     //        servicestate = "取消";
     //        }
     

      Response.Write("<span style=\"color:#555\">" + servicestate + "</span><br/>");
	%></th>
  </tr>
</thead>
<tbody>


  <tr >
    <td class="data-list show" colspan="3">
	<div class="order-hd">
		<div class="order-number">
        客户备注:<%=need.remark%>
        </div>
        <div class="order-items">
        <a href="javascript:;" onclick="showItems(this)"><span>展开</span><b>收缩</b></a>
        </div>
		<div class="clear"></div>

    </div>
	<dl>
    <%
        List<NeedItem> nList = need.need_item_list;
    foreach (NeedItem item in nList)
    {
		
			string p_spec=item.product_spec.Length>20?(Utils.CutString(item.product_spec,0,16)+"..."):item.product_spec;        
%>
	<dd>
		<a href="<%=config.UrlHome%><%=item.product_id%>.html" target="_blank" class="img">
			<img src="<%=FormatImagesUrl.GetProductImageUrl(item.img_src, 60, 60)%>"/>
		</a>
		<div class="text">
        <%
            string _itemstate = "";
            switch (item.item_state) { 
                case "0":
                    _itemstate = "";
                    break;
                case "4":
                    _itemstate = "(已退订)";
                    break;
                case "5":
                    _itemstate = "(已退货)";
                    break;
                default:
                    _itemstate = "";
                    break;
            }
             %>
			<a href="<%=config.UrlHome%><%=item.product_id%>.html" target="_blank"><%=item.product_name%></a> <span style="color:Blue"><%=_itemstate%></span><br/>
			规格：<%=p_spec%><%=string.IsNullOrEmpty(item.sku_name)?"":"&nbsp;/&nbsp;"%><%=item.sku_name%><br/>
            编码：<%=item.product_code%>           
		</div>
		<div class="unit-price">
			<%if (Convert.ToDecimal(string.IsNullOrEmpty(item.sale_price) ? 0 : Convert.ToDecimal(item.sale_price)) > Convert.ToDecimal(string.IsNullOrEmpty(item.deal_price) ? 0 : Convert.ToDecimal(item.deal_price)))
     {%><del>￥<%=item.sale_price%></del><br/><%}%>
            ￥<%=item.deal_price%> × <%=item.sale_num%>
		</div>
	</dd>
<%
	}
%>
    </dl>
    </td>
    <td class="op">
   <% if (need.need_state == "0")
     {%>
            <a href="javascript:;" onclick="passNeed(<%=need.need_id %>)">通过</a><br/>
   <a href="javascript:;"  onclick="nopassNeed(<%=need.need_id %>)"  style="color:Red;">不通过</a>
     <%  }%>
    </td>
  </tr>
</tbody>
</table>
<%
	}
%>
<%=ViewData["pageIndexLink2"]%>
<br/><br/><br/><br/>
</div>
</div>

<div id="updateRecAddr" class="moveBox" style="height:460px;width:450px;">
	<div class="name">
		修改收货信息
		<div class="close" v="atai-shade-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<form action="" onsubmit="return postReceiveAddr(this)">
<input type="hidden" id="need_id" name="need_id" value=""/>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="left">&nbsp;</td>
    <td><span class="tips-text" style="color:#ff6600">&nbsp;</span></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">收货电话：</td>
    <td><input type="text" class="input" name="receive_mobile_no" value="" /></td>
  </tr>
   <tr>
    <td class="left" style="height:36px;" valign="top">省&nbsp;&nbsp;名：</td>
    <td><input type="text" class="input" name="province_name" value="" /></td>
  </tr>
   <tr>
    <td class="left" style="height:36px;" valign="top">城 市 名：</td>
    <td><input type="text" class="input" name="city_name" value="" /></td>
  </tr>
   <tr>
    <td class="left" style="height:36px;" valign="top">区&nbsp;&nbsp;名：</td>
    <td><input type="text" class="input" name="county_name" value="" /></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">收货地址：</td>
    <td><input type="text" class="input" name="receive_addr" value="" /></td>
  </tr>
    <tr>
    <td class="left" style="height:36px;" valign="top">收货人：</td>
    <td><input type="text" class="input" name="receive_name" value="" /></td>
  </tr>
  <tr>
    <td class="left" style="height:30px;">&nbsp;</td>
    <td><input type="submit" class="submit" value="  保 存  " /></td>
  </tr>
</table>
</form>
</div>
<div id="updateRemark-boxControl" class="moveBox" style="height:260px;width:520px;">
	<div class="name">
		设置需求备注
		<div class="close" v="atai-shade-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<form action="" onsubmit="return postNeedRemark(this)">
<input type="hidden" id="Needid" name="Needid" value=""/>
<table width="100%" border="0" cellspacing="4" cellpadding="0">
  <tr>
    <td class="left">&nbsp;</td>
    <td><span class="tips-text" style="color:#ff6600">&nbsp;</span></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">备&nbsp;&nbsp;注：</td>
    <td><textarea id="updateRemark-textarea" name="remark"></textarea></td>
  </tr>

  <tr>
    <td class="left" style="height:30px;">&nbsp;</td>
    <td><input type="submit" class="submit" value="  保 存  " /></td>
  </tr>
</table>
</form>
</div>

<script type="text/javascript">
    function postNeedRemark(form) {
        var postData = getPostDB(form);
        $.ajax({
            url: "/msell/updateNeedRemark"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function (json) {
			    if (json.error) {
			        $(_oupdateNeedRemarkBoxDialog.dialog).find("span[class='tips-text']").html(json.message);
			    } else {
			        window.location.href = window.location.href;
			    }
			}
        });
        return false;
    }
    var _oupdateNeedRemarkBoxDialog = false;
    function updateRemarkBox(needid,inner_remark) {

        var boxId = "#updateRemark-boxControl";
        var box = Atai.$(boxId);
        var _dialog = false;
        if (!_dialog)
            _dialog = new AtaiShadeDialog();
        _dialog.init({
            obj: boxId
		    , sure: function () { }
		    , CWCOB: false
        });
        _oupdateRemarkBoxDialog = _dialog;
        $(_oupdateRemarkBoxDialog.dialog).find("#Needid").val(needid);
        $(_oupdateRemarkBoxDialog.dialog).find("#updateRemark-textarea").val(inner_remark);
        return false;
    }
</script>
<script type="text/javascript">
function showItems(obj){
	var td=$(obj).parent("div").parent("div").parent("td");
	if(td.hasClass("show")){
		td.removeClass("show");
	}else{
		td.addClass("show");
	}
}
$(function(){
	var obj=$("#syscp-menu");
	var _offset = obj.offset();
	$(window).scroll(function(){
		var _stop = $(window).scrollTop() + 1;
		if(parseInt(_stop) > parseInt(_offset.top)){
			obj.css({ margin: "0", width: 220, zIndex: "1" });
			if(Atai.ST.isMinIE6){
				obj.css({ position: "absolute", "opacity" : 0.9, top: (_stop) + "px" });
			}else{
				obj.css({ position: "fixed", "opacity" : 0.9, top: "1px" });
			}
		}else{
			obj.css({ position: "relative", "opacity" : 1, top: "auto", marginTop: "0", borderBottom: "0" });
		}
	});
});
function passNeed(id){
	var postData = "id=" + id;
	jsbox.confirm('您确定通过这个处方药需求吗？', function () {
	    $.ajax({
	        url: "/MSell/PassNeed"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function (json, textStatus) {
			    if (json.error) {
			        jsbox.error(json.message); return false;
			    } else {
			        window.location.href = window.location.href;
			        jsbox.error(json.message);
			    }
			}
	    });
	});
	return false;
}
function nopassNeed(id) {
    var postData = "id=" + id;
    jsbox.confirm('您确定不通过这个处方药需求吗？', function () {
        $.ajax({
            url: "/MSell/nopassNeed"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function (json, textStatus) {
			    if (json.error) {
			        jsbox.error(json.message); return false;
			    } else {
			        window.location.href = window.location.href;
			        jsbox.error(json.message);
			    }
			}
        });
    });
    return false;
}
function postReceiveAddr(form) {
    var postData = getPostDB(form);
    console.log(postData);
    $.ajax({
        url: "/msell/PostNeedAddr"
            , type: "post"
			, data: postData
			, dataType: "json"
			, success: function (json) {
			    if (json.error) {
			        jsbox.error(json.message); return false;
			    } else {
			        jsbox.success(json.message, window.location.href);
			    }
			}
    });
    return false;
}
var _oupdateAddrBoxDialog = false;
function updateAddr(need_id, receive_mobile_no, province_name, city_name, county_name, receive_addr, receive_name) {

    var boxId = "#updateRecAddr";
    var box = Atai.$(boxId);
    var _dialog = false;
    if (!_dialog)
        _dialog = new AtaiShadeDialog();
    _dialog.init({
        obj: boxId
		    , sure: function () { }
		    , CWCOB: false
    });
    _oupdateAddrBoxDialog = _dialog;
    $(_oupdateAddrBoxDialog.dialog).find("#need_id").val(need_id);
    $(_oupdateAddrBoxDialog.dialog).find("input[name='receive_mobile_no']").val(receive_mobile_no);
    $(_oupdateAddrBoxDialog.dialog).find("input[name='province_name']").val(province_name);
    $(_oupdateAddrBoxDialog.dialog).find("input[name='city_name']").val(city_name);
    $(_oupdateAddrBoxDialog.dialog).find("input[name='county_name']").val(county_name);
    $(_oupdateAddrBoxDialog.dialog).find("input[name='receive_addr']").val(receive_addr);
    $(_oupdateAddrBoxDialog.dialog).find("input[name='receive_name']").val(receive_name); 
    return false;
}
</script>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>
<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %><%@ Import Namespace="JiuZhou.ControllerBase" %><%@ Import Namespace="JiuZhou.Cache" %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/style/style.css" rel="stylesheet" type="text/css" />
<%Html.RenderPartial("Base/_PageHeadControl"); %>
<title><%=ViewData["pageTitle"]%></title>
</head>
<body>
<%
	int classid = DoRequest.GetQueryInt("classid");
	int sType = DoRequest.GetQueryInt("sType");
    int shopid = DoRequest.GetQueryInt("shopid");
    List<TypeList> tList = new List<TypeList>();
    DoCache chche = new DoCache();
    if (chche.GetCache("typelist") == null)
    {
        var res = GetTypeListAll.Do(-1);
        if (res != null && res.Body != null && res.Body.type_list != null)
        {
            tList = res.Body.type_list;
            chche.SetCache("typelist", tList);
            if (tList.Count == 0)
            {
                chche.RemoveCache("typelist");
            }
        }
    }
    else
    {
        tList = (List<TypeList>)chche.GetCache("typelist");
    }

    List<ShopList> shopList = new List<ShopList>();
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
    
    bool _isprice = false;
    _isprice = ForeSysBaseController.HasPermission2(254);
%>

<%Html.RenderPartial("Base/_SimplePageTopControl"); %>
<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
<div class="position">
当前位置：
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>在售商品列表</span>
</div>
<form action="/mgoods" method="get" onsubmit="checksearch(this)">
<input type="hidden" name="size" value="<%=DoRequest.GetQueryInt("size", 30)%>"/>
<input type="hidden" name="ocol" value="<%=DoRequest.GetQueryString("ocol")%>"/>
<input type="hidden" name="ot" value="<%=DoRequest.GetQueryString("ot")%>"/>
  <div class="div-tab-h1" style="font-weight:100;color:#333;font-size:12px">
		<p><select id="stype" name="stype" style="width:80px;height:26px;">
			 <option value="0" init="true">综合搜索</option>
             <option value="1">商家编码</option>
             <option value="2">商品名称</option>
             <option value="3">品牌名称</option>
		   </select>
        </p>
		<p><select id="classid" name="classid" style="width:80px;height:26px;">
		     <option value="-1" init="true">商品分类</option>
<%
    List<TypeList> items = new List<TypeList>();

    items = tList.FindAll(
            delegate(TypeList em)
            {
                return (em.parent_type_id == 0 && em.is_visible==1);
            });

    foreach (TypeList em in items)
    {
		Response.Write("<option value=\""+ em.product_type_id +"\">"+ em.type_name +"</option>");
	}
%>
		</select>
</p>
		<p><select id="shopid" name="shopid" style="width:160px;height:26px;">
		     <option value="-1" init="true">全部商家</option>
<%
    List<ShopList> shops = new List<ShopList>();

    shops = shopList.FindAll(
            delegate(ShopList em)
            {
                return (em.shop_state == 0 );
            });

    foreach (ShopList em in shops)
    {
		Response.Write("<option value=\""+ em.shop_id +"\">"+ em.shop_name +"</option>");
	}
%>
		</select>
</p>
<p style="position:relative">
		<input type="text" id="sQuery" name="q" value="<%=DoRequest.GetQueryString("q")%>" class="input" autocomplete="off" onkeyup="suggest.init(event,this,'/MTools/SeachSuggest')" style="width:320px;height:24px;line-height:24px;"/></p>
<p>
<input type="submit" value=" 搜索 " class="submit"/>

</p>
&nbsp;
<p>
<a href="/mgoods/editor?classid=0&id=0" style="font-size:20px" target="_blank" >添加商品</a>
</p>

			</div>
</form>
<script type="text/javascript">
$(function(){
$("#stype option[value='<%=sType%>']").attr("selected",true);
$("#classid option[value='<%=DoRequest.GetQueryInt("classid", -1)%>']").attr("selected",true);
$("#shopid option[value='<%=DoRequest.GetQueryInt("shopid", -1)%>']").attr("selected",true);
});

function checksearch(form){
	var sQuery=Atai.$("#sQuery");
	//if(sQuery.value==qInitValue){
	//	sQuery.value="";
	//}
}
var _currUrl="<%=ViewData["currPageUrl"]%>";
function formatUrl(ocol, val, url){
	if(!url) url=_currUrl;
	var reg = ocol + "=[^-]*";
	var reg = new RegExp(ocol + "=[^&\.]*");
	url = url.replace(reg, ocol + "=" + val);
	return url;
}
var changeOrderBy=function(ocol,ot){
	_currUrl=formatUrl("ocol",ocol);
	url=formatUrl("ot",ot);
	window.location.href=url;
};
</script>
<%
	string otype = DoRequest.GetQueryString("ot").ToLower().Trim();
%>
<form id="post-form" method="post" action="">
<%=ViewData["pageIndexLink"]%>
<table id="tab-category" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:3%"><input type="checkbox" onclick="checkAll(this.form,this)" name="chkall" title="选中/取消选中"/></th>
    <th colspan="2">商品名&nbsp;&nbsp;<a href="javascript:;" onclick="changeOrderBy('seo','<%=otype=="asc"?"desc":"asc"%>')">SEO排序</a></th>
    <th style="width:15%">价格</th>
    <th style="width:12%"><a href="javascript:;" onclick="changeOrderBy('modifytime','<%=otype=="asc"?"desc":"asc"%>')">更新时间</a></th>
    <th style="width:9%">&nbsp;&nbsp;<a href="javascript:;" onclick="changeOrderBy('stocknum','<%=otype=="asc"?"desc":"asc"%>')">库存</a><br/>&nbsp;虚拟库存</th>
    <th style="width:5%">状态</th>
    <th style="width:7%">操作</th>
  </tr>
</thead>
<tbody>
<%
    List<ProductsInfo> infoList = (List<ProductsInfo>)ViewData["infoList"];
    if (infoList == null)
        infoList = new List<ProductsInfo>();

	foreach (ProductsInfo info in infoList){
        List<SkuList> skus = new List<SkuList>();
        if (chche.GetCache("product-GetSkusByProductId" + info.product_id) == null)
        {
            var resu = GetSkusByProductId.Do(info.product_id);
            if (resu != null && resu.Body != null && resu.Body.sku_list != null)
            {
                skus = resu.Body.sku_list;
                chche.SetCache("product-GetSkusByProductId" + info.product_id, skus, 60);
                if (skus.Count == 0)
                    chche.RemoveCache("product-GetSkusByProductId" + info.product_id);
            }
        }
        else {
            skus = (List<SkuList>)chche.GetCache("product-GetSkusByProductId" + info.product_id);
        }      
%>
  <tr>
    <td><input type="checkbox" onclick="selectOne(this)" name="visitid" value="<%=info.product_id%>" /></td>
    <td style="width:70px;height:74px;">
<a href="<%=config.UrlHome%><%=info.product_id %>.html" target="_blank" title="<%=info.product_name%>">
<img src="<%=FormatImagesUrl.GetProductImageUrl(info.img_src, 120, 120) %>" style="width:60px;height:60px" alt="<%=info.product_name%>"/>
</a>
    </td>
    <td>
	<p><a href="<%=config.UrlHome%><%=info.product_id %>.html" target="_blank" title="<%=info.product_name%>"><%=info.product_name%></a></p>
    <p class="pname" style="color:#999">
    编码：<%=info.product_code%>
<%
    DateTime promotion_bgdate = DateTime.Parse(info.promotion_bdate);
    DateTime promotion_eddate = DateTime.Parse(info.promotion_edate);
	if (promotion_bgdate <= DateTime.Now
	  && DateTime.Now <= promotion_eddate
	  && promotion_bgdate != promotion_eddate && info.promotion_price < info.sale_price){
		Response.Write("&nbsp;<span>直降</span>");
	}
    List<GiftsList> gifts = new List<GiftsList>();
    if (chche.GetCache("product-GetProductGift" + info.product_id) == null)
    {
        var resgift = GetProductGift.Do(info.product_id.ToString());
        if (resgift != null && resgift.Body != null && resgift.Body.gift_list != null)
        {
            gifts = resgift.Body.gift_list;
            chche.SetCache("product-GetProductGift" + info.product_id, gifts,60);
            if (gifts.Count == 0)
                chche.RemoveCache("product-GetProductGift" + info.product_id);
        }
    }
    else {
        gifts = (List<GiftsList>)chche.GetCache("product-GetProductGift" + info.product_id);
    }
    if (gifts.Count > 0)
    {
		Response.Write("&nbsp;<span>买赠</span>");
	}
    int isFreeFare = info.free_fare;
    DateTime freeFareStartTime = DateTime.Parse(info.free_fare_stime);
    DateTime freeFareEndTime = DateTime.Parse(info.free_fare_etime);
	if(isFreeFare==1 && freeFareStartTime<=DateTime.Now && freeFareEndTime>=DateTime.Now){
		Response.Write("&nbsp;<span>包邮</span>");
	}
%>
	<!--&nbsp;&nbsp;<a href="/manalysis/productview?proid=<%=info.product_id%>" target="_blank">查看统计</a> -->
    </p>
    <p style="color:#999">分类：<%
		string _s= info.product_type_path;
		string[] _tem=_s.Split(',');
		int _xCount=0;
		for(int x=0;x<_tem.Length;x++){
			if(string.IsNullOrEmpty(_tem[x].Trim())) continue;
			int _v=Utils.StrToInt(_tem[x].Trim());
            foreach (TypeList item in tList)
            {
            	if (item.product_type_id ==_v){
					if(_xCount>0) Response.Write(" &gt;&gt; ");
					Response.Write(item.type_name);
					_xCount++;
            	}
        	}
		}
		//clsInfo.n_name
	%></p>
    <p>
    <a href="javascript:;" onclick="Countercheck('<%=info.product_id %>','<%=info.product_name %>','<%=info.img_src %>')">赠品反查</a>
    </p>
    </td>
    <td>
<%
	int minStock=0;
	int maxStock=0;
    int vminStock = 0;
    int vmaxStock = 0;
	if(skus.Count<1){
%>
    <p style="color:#555;margin-top:3px">售&nbsp;价：<input type="text" value="<%=info.sale_price%>" v="<%=info.product_id%>" oprice="<%=info.sale_price%>" class="hiddenInput" onmouseover="inputMouseOver(this)" onmouseout="inputMouseOut(this)" onclick="inputClick(this)" onblur="priceBlur(this,'member')" style="width:50px;background:none;color:#555;"/></p>
    <p style="color:#555;margin-top:3px">手&nbsp;机：<input type="text" value="<%=info.mobile_price%>" v="<%=info.product_id%>" oprice="<%=info.mobile_price%>" class="hiddenInput" onmouseover="inputMouseOver(this)" onmouseout="inputMouseOut(this)" onclick="inputClick(this)" onblur="priceBlur(this,'mobile')" style="width:50px;background:none;color:#555;"/></p>
<%
	}else{
        decimal skuMinPrice = info.sale_price;
		decimal skuMinPrice2 = info.mobile_price;
		decimal skuMaxPrice=0;
		decimal skuMaxPrice2=0;
        foreach (SkuList s in skus)
        {
			if(skuMinPrice>s.sale_price)
                skuMinPrice = s.sale_price;
			if(skuMinPrice2>s.mobile_price)
                skuMinPrice2 = s.mobile_price;

            if (skuMaxPrice < s.sale_price)
                skuMaxPrice = s.sale_price;
            if (skuMaxPrice2 < s.mobile_price)
                skuMaxPrice2 = s.mobile_price;
				
			if(s.sku_stock<minStock) minStock=s.sku_stock;
            if (s.sku_stock > maxStock) maxStock = s.sku_stock;

            if (s.virtual_sku_stock < vminStock) vminStock = s.virtual_sku_stock;
            if (s.virtual_sku_stock > vmaxStock) vmaxStock = s.virtual_sku_stock;
		}
%>
	<p style="color:#555;position:relative;line-height:26px" onclick="resetProductSkuBox(Atai.$('#stock-<%=info.product_id%>'), <%=info.product_id%>)">售价：<%=(skuMinPrice.ToString("0.0") + " - " + skuMaxPrice.ToString("0.0"))%></p>
	<p style="color:#555;position:relative;line-height:26px" onclick="resetProductSkuBox(Atai.$('#stock-<%=info.product_id%>'), <%=info.product_id%>)">手机：<%=(skuMinPrice2.ToString("0.0") + " - " + skuMaxPrice2.ToString("0.0"))%></p>
<%
    }
    if (_isprice)
        Response.Write("<p style=\"color:#999\">成本价： " + info.market_price + "</p>");
%>
    </td>
    <%  string modifytime = "";
        if (info.modify_time != null && !info.modify_time.Equals(""))
            modifytime = DateTime.Parse(info.modify_time).ToString("yyyy-MM-dd HH:mm");%>
    <td><%=modifytime%><div style="height:8px;line-height:8px;font-size:1px;overflow:hidden;">&nbsp;</div>
    <%if (info.allow_ebaolife == 1)
      {
         // Response.Write("<a href=\"javascript:;\" val='0' onclick=\"resetAllowYBLife2(this," + info.product_id + ")\">医卡通支付 √</a>");
          //Response.Write("<span style=\"color:green\">医卡通可支付");
	}else if(info.allow_ebaolife == 0){
      //  Response.Write("<a href=\"javascript:;\" val='1' onclick=\"resetAllowYBLife2(this," + info.product_id + ")\" style=\"color:#999\">医卡通支付 ×</a>");
        //Response.Write("医卡通不可支付");
    }
        
    %>
    </td>
    <td style="text-align:center">
<% 
	string onclick="inputClick(this)";
	if(skus.Count>0){
        onclick = "resetProductSkuBox(Atai.$('#virtualstock-" + info.product_id + "'), " + info.product_id + ")";
%>
<input type="hidden" id="stock-<%=info.product_id%>" value="<%=info.stock_num%>" v="<%=info.product_id%>" ostock="<%=info.stock_num%>"/>
<div style="text-align:center;">
<%=minStock%>-<%=maxStock%>
</div>
<input type="hidden" id="virtualstock-<%=info.product_id%>" value="<%=info.virtual_stock_num%>" v="<%=info.product_id%>" ostock="<%=info.virtual_stock_num%>"/>
<div onclick="<%=onclick%>" style="text-align:center;">
<%=vminStock%>-<%=vmaxStock%>
</div>
<%
	}else{
%><div style="text-align:center;">
<input type="text" id="stock-<%=info.product_id%>" value="<%=info.stock_num%>" v="<%=info.product_id%>" ostock="<%=info.stock_num%>" class="hiddenInput" disabled style="width:40px;background:none;text-align:center;"/>
</div>
<div style="text-align:center;">
<input type="text" id="virtualstock-<%=info.product_id%>" value="<%=info.virtual_stock_num%>" v="<%=info.product_id%>" ostock="<%=info.virtual_stock_num%>" class="hiddenInput" onmouseover="inputMouseOver(this)" onmouseout="inputMouseOut(this)" onclick="<%=onclick%>" onblur="<%=skus.Count>0?"":"inputBlur(this)"%>" style="width:40px;background:none;text-align:center;"/>
</div>
<%
	}
%>
    </td>
    <td><%=info.is_on_sale == 1 ? "<a href=\"javascript:;\" onclick=\"resetStatusList(" + info.product_id + ", 0)\">在售</a>" : "<a href=\"javascript:;\" onclick=\"resetStatusList(" + info.product_id + ", 1)\" style='color:#999'>已下架</a>"%></td>
    <td>
    <a href="/mgoods/editor?classid=<%=info.product_type_id%>&id=<%=info.product_id%>" target="_blank">编辑商品</a><br/>
    <a href="/mgoods/proGift?id=<%=info.product_id%>" target="_blank">买赠设置</a><br/>
    <a href="/mgoods/proCorrelation?id=<%=info.product_id%>" target="_blank">关联推荐</a><br/>
    <a href="javascript:;" onclick="_productSeoBox('<%=info.product_id%>')"><%=string.IsNullOrEmpty(info.seo_title)?"填写SEO":"修改SEO"%></a>
    </td>
  </tr>
<%
	}
%>
  </tbody>
</table>
<%=ViewData["pageIndexLink2"]%>
			<div class="console">
                <a href="/mgoods/editor?classid=0&id=0" target="_blank">添加商品</a>
            	<a href="javascript:;" onclick="deleteList(Atai.$('#post-form'), 0)">放入回收站</a>
            <!--    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            	<a href="javascript:;" onclick="resetAllowYBLife(Atai.$('#post-form'), 0)">禁止医卡通支付</a>
                &nbsp;&nbsp;
                <a href="javascript:;" onclick="resetAllowYBLife(Atai.$('#post-form'), 1)">允许医卡通支付</a> -->
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="javascript:;" onclick="resetStatusList(Atai.$('#post-form'), 0)" class="black">批量下架</a>
			</div>
</form>
<br/><br/><br/><br/>
</div>
</div>
<script type="text/javascript">
function inputMouseOver(obj){
	$(obj).css({"background" : "#fafafa"}).addClass("inputBorder");
}
function inputMouseOut(obj){
	$(obj).css({"background" : "none"}).removeClass("inputBorder");
}

function inputClick(obj){
	//obj.select();
	$(obj).attr("focus",1);
}
function inputBlur(obj){
	$(obj).attr("focus",0);
	$(obj).css({"background" : "none"}).removeClass("inputBorder");
	var stock=$(obj).val();
	if(stock==$(obj).attr('ostock')){
		return false;
	}
	if(!Atai.isNumber(stock)){
		$(obj).val($(obj).attr('ostock'));errorBox("[库存] 请填数字"); return false;
	}
	$.ajax({
	    url: "/MGoods/PostResetProductStock"
		, type: "post"
		, data: {
		    "productid": $(obj).attr('v')
			, "stock": stock
		}
		, dataType: "json"
		, success: function (json, textStatus) {
		    if (!json.error) {
		        $(obj).attr('ostock', stock);
		    } else {
		        jsbox.error(json.message);
		    }
		}, error: function (http, textStatus, errorThrown) {
		    jsbox.error(errorThrown);
		}
	});
}
function priceBlur(obj,type){
	$(obj).attr("focus",0);
	$(obj).css({"background" : "none"}).removeClass("inputBorder");
	var price=$(obj).val();
	if(price==$(obj).attr('oprice')){
		return false;
	}
	if(!Atai.isNumber(price)){
		$(obj).val($(obj).attr('oprice'));errorBox("[价格] 请填数字"); return false;
	}
	$.ajax({
	    url: "/MGoods/PostResetProductPrice"
		, type: "post"
		, data: {
		    "productid": $(obj).attr('v')
			, "type": type
			, "price": $(obj).val()
		}
		, dataType: "json"
		, success: function (json, textStatus) {
		    if (!json.error) {
		        $(obj).attr('oprice', price);
		       } else {
		        jsbox.error(json.message);
		    }
		}, error: function (http, textStatus, errorThrown) {
		    jsbox.error(errorThrown);
		}
	});
}
</script>
<script type="text/javascript">
function resetStatusList(form, status){
	var _data=Atai.isInt(form) ? ("visitid=" + form) : getPostDB(form);
	var postData="status=" + status + "&" + _data;
	jsbox.confirm('您确定下架这些商品吗？', function () {
	    $.ajax({
	        url: "/mgoods/ResetProductStatusList"
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
/*
function resetAllowYBLife2(obj, id){
	var _data="visitid=" + id;
	var status=$(obj).attr("val");
	var postData="status=" + status + "&" + _data;
	var msg="";
	if(status==1) msg="您确定要将这些商品设为【允许】医卡通支付吗？";
	else  msg="您确定要将这些商品设为【禁止】医卡通支付吗？";
	jsbox.confirm(msg, function () {
		$.ajax({
			url: "/mgoods/ResetAllowYBLife"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function (json, textStatus) {
				if(json.error){
				    jsbox.error(json.message); return false;
				}else{
					if(status==1){
						$(obj).css({"color": "#060"}).html("医卡通支付 √").attr("val", 0);
					}else{
						$(obj).css({"color": "#999"}).html("医卡通支付 ×").attr("val", 1);
					}
				}
			}
		});
	});
	return false;
}

function resetAllowYBLife(form, status){
	var _data=Atai.isInt(form) ? ("visitid=" + form) : getPostDB(form);
	var postData="status=" + status + "&" + _data;
	var msg="";
	if(status==1) msg="您确定要将这些商品设为【允许】医卡通支付吗？";
	else  msg="您确定要将这些商品设为【禁止】医卡通支付吗？";
	jsbox.confirm(msg, function () {
		$.ajax({
			url: "/mgoods/ResetAllowYBLife"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function (json, textStatus) {
				if(json.error){
				    jsbox.error(json.message); return false;
				}else{
				    jsbox.success(js.message, window.location.href);
				}
			}
		});
	});
	return false;
}
*/
function deleteList(form, status){
	var postData="status=" + status + "&" + getPostDB(form);
	jsbox.confirm('您确定要将这些商品放入回收站吗？', function () {
		$.ajax({
			url: "/mgoods/RemoveProductList"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function (json, textStatus) {
				if(json.error){
					jsbox.error(json.message);return false;
				}else{
	                jsbox.success(json.message, window.location.href);
				}
			}
		});
	});
	return false;
}
</script>
<br/><br/>
<br/><br/><br/>

<div id="product-seo-boxControl" class="dialog-box" style="height:490px;width:590px;">
	<div class="atai-shade-head" v="atai-shade-move">
		SEO设置
		<div class="atai-shade-close" v="atai-shade-close">&nbsp;</div>
	</div>
<form action="" onsubmit="return UpdateProductSEO(this)">
<input type="hidden" id="otp-productid" name="productid" value=""/>
<div class="atai-shade-contents">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="left">&nbsp;</td>
    <td><span class="tips-text" style="color:#ff6600">&nbsp;</span></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;">商品名称：</td>
    <td><input type="text" id="old-pname" class="input" value="" style="width:380px;height:25px;line-height:25px;" disabled="disabled"/></td>
  </tr>
  <tr style="height:70px">
    <td class="left" valign="top">页面标题：</td>
    <td>
<textarea name="stitle" style="height:50px;line-height:20px;width:390px"></textarea>
    </td>
  </tr>
  <tr style="height:80px">
    <td class="left" valign="top">关 键 词：</td>
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
  </table>
</div>
<div class="atai-shade-clear"></div>
  <div class="atai-shade-bottom" v="atai-shade-move">
		<input type="button" class="atai-shade-cancel" v="atai-shade-cancel" value="取消"/>
		<input type="submit" class="atai-shade-confirm" value="保存"/>
	</div>
</form>
</div>
<script type="text/javascript">
    function UpdateProductSEO(form) {
        var postData = getPostDB(form);
        $.ajax({
            url: "/MGoods/UpdateSEO"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function (json) {
			    if (json.error) {
			        $("#product-seo-boxControl span[class='tips-text']").html(json.message); return false;
			    } else {
			        if (_productSeoBoxDialog) {
			            _productSeoBoxDialog.close();
			            _productSeoBoxDialog = false;
			        } //window.location.href=window.location.href;
			    }
			}
        });
        return false;
    }
    var _productSeoBoxDialog = false;
    function _productSeoBox(productid) {
        var boxId = "#product-seo-boxControl";
        var _dialog = new AtaiShadeDialog();
        _dialog.init({
            obj: boxId
		, sure: function () { }
		, CWCOB: true
        });
        _productSeoBoxDialog = _dialog;

        var postData = "productid=" + productid;
        $.ajax({
            url: "/MTools/GetProductInfo"
		, type: "post"
        , async: false
		, data: postData
		, dataType: "json"
		, success: function (json, textStatus) {
		    $(_productSeoBoxDialog.dialog).find("input[name='productid']").val(productid);
		    $(_productSeoBoxDialog.dialog).find("input[id='old-pname']").val(json.product_name);
		    $(_productSeoBoxDialog.dialog).find("textarea[name='stitle']").val(json.seo_title);
		    $(_productSeoBoxDialog.dialog).find("textarea[name='skeywords']").val(json.seo_key);
		    $(_productSeoBoxDialog.dialog).find("textarea[name='stext']").val(json.seo_text);
		}
        });
    }
</script>
<%Html.RenderPartial("Base/_PageFootControl"); %>
<%Html.RenderPartial("MGoods/SkuEditorControl"); %>
<%Html.RenderPartial("MGoods/CounterCheckGiftControl"); %>
</body>
</html>


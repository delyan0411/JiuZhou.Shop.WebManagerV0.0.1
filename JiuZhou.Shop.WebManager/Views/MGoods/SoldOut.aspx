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
                chche.RemoveCache("typelist");
        }
    }
    else {
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
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>下架商品列表</span>
</div>
<form action="/mgoods/soldout" method="get" onsubmit="checksearch(this)">
<input type="hidden" name="size" value="<%=DoRequest.GetQueryInt("size", 30)%>"/>
<input type="hidden" name="ocol" value="<%=DoRequest.GetQueryString("ocol")%>"/>
<input type="hidden" name="ot" value="<%=DoRequest.GetQueryString("ot")%>"/>
			<div class="div-tab-h1" style="font-weight:100;color:#333;font-size:12px">
		<p><select id="stype" name="stype" style="width:80px">
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
<p>
		<input type="text" id="sQuery" name="q" value="<%=DoRequest.GetQueryString("q")%>" class="input" autocomplete="off" onkeyup="suggest.init(event,this,'/MTools/SeachSuggest')" style="width:390px;height:24px;line-height:24px;"/></p>
<p>
<input type="submit" value=" 搜索 " class="submit"/>
</p>

                <p>
                         <a href="/mgoods/export?classid=<%=classid %>&sType=<%=sType %>&shopid=<%=shopid %>&promotion=-1&ison=0&insurance=-1" style="font-size: 20px" target="_blank">导出商品</a>
                     </p>
			</div>
</form>
<script type="text/javascript">
$(function(){
$("#stype option[value='<%=sType%>']").attr("selected",true);
$("#classid option[value='<%=DoRequest.GetQueryInt("classid", -1)%>']").attr("selected",true);
$("#shopid option[value='<%=DoRequest.GetQueryInt("shopid", -1)%>']").attr("selected",true);
});
var qInitValue="请输入关键词 多个关键词用空格隔开";
Atai.addEvent(window,"load",function(){
	dropSType=new _DropListUI({
		input: Atai.$("#stype")
	});dropSType.maxHeight="260px";dropSType.width="80px";
	dropSType.init();dropSType.setDefault("<%=sType%>");

	var sQuery=Atai.$("#sQuery");
	if(sQuery.value==qInitValue || sQuery.value==""){
		sQuery.value=qInitValue;
		sQuery.style.color="#999";
	}else{
		sQuery.style.color="#111";
	}
	sQuery.onfocus=function(){
		if(this.value==qInitValue){
			this.value="";
			sQuery.style.color="#111";
		}
	};
	sQuery.onblur=function(){
		if(this.value==""){
			this.value=qInitValue;
			sQuery.style.color="#999";
		}
	};
});
function checksearch(form){
	var sQuery=Atai.$("#sQuery");
	if(sQuery.value==qInitValue){
		sQuery.value="";
	}
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
    <th colspan="2">商品名</th>
    <th style="width:14%">价格</th>
    <th style="width:8%"><a href="javascript:;" onclick="changeOrderBy('stocknum','<%=otype=="asc"?"desc":"asc"%>')">库存</a></th>
    <th style="width:8%">状态</th>
    <th style="width:8%">操作</th>
  </tr>
</thead>
<tbody>
<%
    List<ProductsInfo> infoList = (List<ProductsInfo>)ViewData["infoList"];
    if(infoList == null)
        infoList = new List<ProductsInfo>();
	foreach (ProductsInfo info in infoList){
%>
  <tr>
    <td><input type="checkbox" onclick="selectOne(this)" name="visitid" value="<%=info.product_id%>" /></td>
    <td style="width:70px;height:70px;">
<a href="<%=config.UrlHome%><%=info.product_id %>.html" target="_blank" title="<%=info.product_name%>"><img src="<%=FormatImagesUrl.GetProductImageUrl(info.img_src, 120, 120) %>" style="width:60px;height:60px" alt="<%=info.product_name%>"/>
</a>
    </td>
    <td>
	<p><a href="<%=config.UrlHome%><%=info.product_id %>.html" target="_blank" title="<%=info.product_name%>"><%=info.product_name%></a></p>
    <p style="color:#999">商家编码：<%=info.product_code%></p>
    <p style="color:#999">商品分类：<%
		//ProductTypeInfo clsInfo = new ProductTypeInfo();//当前分类
        string _s = info.product_type_path;
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
    </td>
    <td>
    <%
        decimal saleprice = 0;
        decimal mobileprice = 0;
        DateTime bt = DateTime.Parse(info.promotion_bdate);
        DateTime et = DateTime.Parse(info.promotion_edate);
        if (bt == null)
            bt = DateTime.Now.AddYears(-1);
        if (et == null)
            et = DateTime.Now.AddYears(-1);
        decimal mobile_price = info.mobile_price;
        decimal member_price = info.sale_price;
        decimal promotion_price = info.promotion_price;

        if (mobile_price < 0.1m)
        {
            mobile_price = member_price;
        }
        mobileprice = mobile_price;
        saleprice = member_price;
        if (bt <= DateTime.Now && DateTime.Now <= et)
        {
            if (mobile_price < promotion_price)
            {
                mobileprice = mobile_price;//手机专享价
            }
            else
            {
                mobileprice = promotion_price;
            }
            saleprice = promotion_price;    
        }
         %>
    <p style="color:#F00;">售&nbsp;价：<%=saleprice%></p>
    <p style="color:#060;">手&nbsp;机：<%=mobileprice%></p>
    <%if (_isprice)
          Response.Write("<p style=\"color:#999\">成本价： " + info.market_price + "</p>");
    %>
    </td>
    <td><%=info.stock_num%></td>
    <td><%=info.is_on_sale == 1?"<a href=\"javascript:;\" onclick=\"resetStatusList("+info.product_id+", 0)\">在售</a>":"<a href=\"javascript:;\" onclick=\"resetStatusList("+info.product_id+", 1)\" style='color:#999'>已下架</a>"%></td>
    <td>
    <a href="/mgoods/editor?classid=<%=info.product_type_id%>&id=<%=info.product_id%>" target="_blank">编辑</a>
    </td>
  </tr>
<%
	}
%>
  </tbody>
</table>
<%=ViewData["pageIndexLink2"]%>
			<div class="console">
            	<a href="javascript:;" onclick="deleteList(Atai.$('#post-form'), 0)">放入回收站</a>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <a href="javascript:;" onclick="resetStatusList(Atai.$('#post-form'), 1)" class="read">批量上架</a>
			</div>
</form>
<br/><br/><br/><br/>
</div>

</div>
<script type="text/javascript">
function resetStatusList(form, status){
	var _data=Atai.isInt(form) ? ("visitid=" + form) : getPostDB(form);
	var postData="status=" + status + "&" + _data;
	$.ajax({
		url: "/mgoods/ResetProductStatusList"
		, data: postData
        , type: "post"
		, dataType: "json"
		, success: function(json){
			if(json.error){
				jsbox.error(json.message);return false;
			}else{
				window.location.href=window.location.href;
			}
		}
	});
	return false;
}
function deleteList(form, status){
	var postData="status=" + status + "&" + getPostDB(form);
	jsbox.confirm('您确定要将这些商品放入回收站吗？',function(){
		$.ajax({
			url: "/mgoods/RemoveProductList"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function(json){
				if(json.error){
					jsbox.error(json.message);return false;
				}else{
					window.location.href=window.location.href;
				}
			}
		});
	});
	return false;
}
</script>
<br/><br/>
<br/><br/><br/>
</body>
</html>
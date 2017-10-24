<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %><%@ Import Namespace="JiuZhou.Cache" %>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<%Html.RenderPartial("Base/_PageHeadControl"); %>
<link href="/style/style.css" rel="stylesheet" type="text/css" />
</head>
<body>
<%Html.RenderPartial("Base/_SimplePageTopControl"); %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
	int proId = DoRequest.GetQueryInt("id");
    ResponseRelationProduct Info = null; 
    var respro = GetRelationRecommend.Do(proId, 1);
    if (respro == null || respro.Body == null)
    {
        Info = new ResponseRelationProduct();
        Info.product_type_path = "";
    }
    else {
        Info = respro.Body;
    }
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
	
	if(Info.product_id<1){
		Info.promotion_bdate = DateTime.Parse("2012-01-01 00:00:00").ToString();
		Info.promotion_edate = DateTime.Parse("2012-01-01 23:59:59").ToString();
	}
	
	if(Info.product_id<1) Info.is_visible = 1;
	string clsName="";
	string[] _tem=Info.product_type_path.Trim().Split(',');
	int _xCount=0;
	for(int x=0;x<_tem.Length;x++){
		if(string.IsNullOrEmpty(_tem[x].Trim())) continue;
		int _v=Utils.StrToInt(_tem[x].Trim());
        foreach (TypeList item in tList)
        {
            if (item.product_type_id ==_v){
				if(_xCount>0) clsName += " &gt;&gt; ";
				clsName += item.type_name;
				_xCount++;
            }
        }
	}
    List<ProductAlbumList> imageList = null;
    var resResp = GetProductAlbum.Do(Info.product_id);
    if (resResp == null || resResp.Body == null || resResp.Body.pic_list == null)
    {
        imageList = new List<ProductAlbumList>();
    }
    else
    {
        imageList = resResp.Body.pic_list;
    }
    foreach (ProductAlbumList _image in imageList)
    {
        if (_image.is_main > 0){
            Info.img_src = _image.img_src; break;
        }
    }

    List<GiftsList> gifts =  null;
    var resResp2 = GetProductGift.Do(Info.product_id.ToString());
    if (resResp2 == null || resResp2.Body == null || resResp2.Body.gift_list == null)
    {
        gifts = new List<GiftsList>();
    }
    else {
        gifts = resResp2.Body.gift_list;
    }
%>
<script type="text/javascript">$(function(){document.title="<%=string.IsNullOrEmpty(Info.product_name)?"":(Info.product_name+"/")%>关联推荐/在售商品列表|九洲";});</script>
<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
<div class="position">
当前位置：
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <a href="/mgoods/index">在售商品列表</a> &gt;&gt; <span>关联推荐</span>
</div>
		<div class="div-tab">

<table class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th colspan="2">主商品信息</th>
    <th>售价</th>
    <th>库存</th>
    <th>状态</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td style="width:70px;height:70px;">
<a href="<%=config.UrlHome%><%=Info.product_id %>.html" target="_blank" title="<%=Info.product_name%>"><img src="<%=FormatImagesUrl.GetProductImageUrl(Info.img_src, 120, 120) %>" style="width:60px;height:60px" alt="<%=Info.product_name%>"/>
</a>
    </td>
    <td>
	<p><a href="<%=config.UrlHome%><%=Info.product_id %>.html" target="_blank" title="<%=Info.product_name%>"><%=Info.product_name%></a></p>
    <p class="pname" style="color:#999">
    商家编码：<%=Info.product_code%>
<%
	DateTime promotion_bgdate = DateTime.Parse(Info.promotion_bdate);
	DateTime promotion_eddate = DateTime.Parse(Info.promotion_edate);
	if (promotion_bgdate <= DateTime.Now
	  && DateTime.Now <= promotion_eddate
	  && promotion_bgdate != promotion_eddate && Info.promotion_price < Info.sale_price){
		Response.Write("&nbsp;<span>直降</span>");
	}
    
	if(gifts.Count>0){
		Response.Write("&nbsp;<span>买赠</span>");
	}
%>
    </p>
    <p style="color:#999">商品分类：<%
		string _s=Info.product_type_path;
		string[] _tm=_s.Split(',');
		int _xxCount=0;
		for(int x=0;x<_tm.Length;x++){
			if(string.IsNullOrEmpty(_tm[x].Trim())) continue;
			int _v=Utils.StrToInt(_tm[x].Trim());
            foreach (TypeList item in tList)
            {
            	if (item.product_type_id ==_v){
					if(_xxCount>0) Response.Write(" &gt;&gt; ");
					Response.Write(item.type_name);
					_xxCount++;
            	}
        	}
		}
	%></p>
    </td>
    <td>
    <%
        decimal mobileprice = Info.mobile_price;
        decimal saleprice = Info.sale_price;  
      if (Info.mobile_price < 0.1m)
      {
          Info.mobile_price = Info.sale_price;
          mobileprice = Info.sale_price;
      }
      if (DateTime.Parse(Info.promotion_bdate) <= DateTime.Now && DateTime.Now <= DateTime.Parse(Info.promotion_edate) && DateTime.Parse(Info.promotion_bdate) != DateTime.Parse(Info.promotion_edate))
      {
          if (Info.mobile_price < Info.promotion_price)
          {
              mobileprice = Info.mobile_price;//手机专享价
          }
          else
          {
              mobileprice = Info.promotion_price;
          }
          saleprice = Info.promotion_price;
      }       
     %>
    <p style="color:#ff6600;">售&nbsp;价：<%=saleprice%></p>
    <p style="color:#ff6600;">手&nbsp;机：<%=mobileprice%></p>
    </td>
    <td><%=Info.stock_num%></td>
    <td><%=Info.is_on_sale==1?"在售":"已下架"%></td>
  </tr>
</tbody>
</table>
<br/>

<div class="console" style="text-align:left">
<a href="javascript:;" onclick="showItemProductSelector()"><b class="add">&nbsp;</b>选择关联商品...</a>
</div>
<script type="text/javascript">
function showItemProductSelector(){
	var nodes=$("#data-list tbody input[name='productId']");
	var initList="";
	for(var i=0;i<nodes.length;i++){
		if(i>0) initList+=",";
		initList+=$(nodes[i]).val();
	}
	var exceptList=[];
	showProductSelector(function(ids){
		if(ids=="") return false;
		$.ajax({
			  url: "/MGoods/PostCorrelation"
			, type: "post"
			, data: {
				productId: "<%=Info.product_id%>"
				, "ids": ids
			}
			, dataType: "json"
			, success: function(json, textStatus){
				if(json.error){
					jsbox.error(json.message);
				}else{
	                 for (var i = 0; i < json.data.length; i++) _mTableAddRow(json.data[i]);

				}
	         }
            , error: function(http, textStatus, errorThrown){
				jsbox.error(errorThrown);
			}
		});
	}, initList, exceptList, true, 1);//第四个参数true=允许选择带Sku商品;false=禁止选择带Sku商品
}

function _mTableAddRow(json){
	var nodes=$("#data-list tbody input[name='productId']");
	var initList=[];
	for(var i=0;i<nodes.length;i++){
		initList.push($(nodes[i]).val());
	}
	if(initList.contains(json.product_id)) return false;

	var img = formatImageUrl(json.img_src, 120, 120);

	var tab = $("#data-list tbody");
	var html='<tr>';

	html += '<td style="width:70px;height:70px;"><input type="hidden" name="productId" value="'+ json.product_id +'"/>';
	html += '<a href="<%=config.UrlHome%>'+ json.product_id +'.html" target="_blank"><img src="'+ img +'" style="width:60px;height:60px" alt=""/></a></td>';
	html += '<td><p><a href="<%=config.UrlHome%>'+ json.product_id +'.html" target="_blank">'+ json.product_name +'</a></p>';
	html += '<p class="pname" style="color:#999">商家编码：'+ json.product_code +'</p></td>';
	html += '<td>';
	html += '<p style="color:#ff6600;">售&nbsp;价：' + json.sale_price + '</p>';
	html += '<p style="color:#ff6600;">手&nbsp;机：' + json.mobile_price + '</p></td>';
	html += '<td>'+ json.stock_num +'</td>';
	if(json.is_on_sale==1){
		html += '<td>在售</td>';
	}else{
		html += '<td>已下架</td>';
	}
	html += '<td style="width:50px"><a href="javascript:;" onclick="_mTableRemoveRow(this, '+ json.product_id +')">删除</a></td>';
	html += '</tr>';
	
	var tr=$(html);
	tab.append(tr);
}
function _mTableRemoveRow(obj, proId) {
	var tr=false;
	while(!tr){
		if(obj.tagName && obj.tagName.toLowerCase()=="tr"){
			tr=obj;
		}else{
			obj=obj.parentNode;
		}
	}
	
	$.ajax({
		url: "/MGoods/DeleteCorrelation"
		, type: "post"
		, data: {
			 mainId: "<%=Info.product_id%>"
			,proId: proId
		}
		, dataType: "json"
		, success: function(json, textStatus){
			if(json.error){
				jsbox.error(json.message);
			}else{
				if(tr) $(tr).remove();
			}
		}, error: function(http, textStatus, errorThrown){
			jsbox.error(errorThrown);
		}
	}); 
	return false;
}
</script>
<%--数据列表开始--%>
<table id="data-list" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th colspan="2">关联商品</th>
    <th style="width:100px">售价</th>
    <th style="width:50px">库存</th>
    <th style="width:50px">状态</th>
    <th style="width:50px">操作</th>
  </tr>
</thead>
<tbody>
<%
    List<RelationProductInfo> __GLList = null;
    if (Info.relation_list == null)
    {
        __GLList = new List<RelationProductInfo>();
    }
    else
    {
        __GLList = Info.relation_list;//关联商品

        foreach (RelationProductInfo item in __GLList)
        {
%>
	<tr>
	<td style="width:70px;height:70px;"><input type="hidden" name="productId" value="<%=item.product_id%>"/>
	<a href="<%=config.UrlHome%><%=item.product_id%>.html" target="_blank"><img src="<%=FormatImagesUrl.GetProductImageUrl(item.img_src, 120, 120) %>" style="width:60px;height:60px" alt=""/></a></td>
	<td><p><a href="<%=config.UrlHome%><%=item.product_id%>.html" target="_blank"><%=item.product_name%></a></p>
	<p class="pname" style="color:#999">商家编码：<%=item.product_code%></p></td>
    <td>
    <%
decimal mobileprice2 = item.mobile_price;
decimal saleprice2 = item.sale_price;
if (item.mobile_price < 0.1m)
{
    item.mobile_price = item.sale_price;
    mobileprice2 = item.sale_price;
}
if (DateTime.Parse(item.promotion_bdate) <= DateTime.Now && DateTime.Now <= DateTime.Parse(item.promotion_edate) && DateTime.Parse(item.promotion_bdate) != DateTime.Parse(item.promotion_edate))
{
    if (item.mobile_price < item.promotion_price)
    {
        mobileprice2 = item.mobile_price;//手机专享价
    }
    else
    {
        mobileprice2 = item.promotion_price;
    }
    saleprice2 = item.promotion_price;
}       
     %>
    <p style="color:#ff6600;">售&nbsp;价：<%=saleprice2%></p>
    <p style="color:#ff6600;">手&nbsp;机：<%=mobileprice2%></p>
    </td>
    <td><%=item.stock_num%></td>
    <td><%=item.is_on_sale == 1 ? "在售" : "已下架"%></td>
	<td style="width:50px"><a href="javascript:;" onclick="_mTableRemoveRow(this, '<%=item.product_id%>')">删除</a></td>
	</tr>
<%
}
    }
%>
</tbody>
</table>

<%--数据列表结束--%>
<br/>
</div>
<br/><br/><br/><br/>
</div>

</div>
<br/><br/>
<br/><br/><br/>
<%Html.RenderPartial("Base/_PageFootControl"); %>
<%Html.RenderPartial("MGoods/SelectProductControl"); %>
</body>
</html>
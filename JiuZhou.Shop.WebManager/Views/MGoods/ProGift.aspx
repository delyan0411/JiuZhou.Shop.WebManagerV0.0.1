<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %><%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %><%@ Import Namespace="JiuZhou.Cache" %>
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
<%Html.RenderPartial("Base/_SimplePageTopControl"); %>
<%
	int proId = DoRequest.GetQueryInt("id");
    ProductInfo Info = new ProductInfo();
    var respro = GetProductInfo.Do(proId);
    if(respro!=null && respro.Body!=null)
        Info = respro.Body;
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
	
	if(Info.product_id<1) Info.is_visible=1;
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
    List<ProductAlbumList> imageList = new List<ProductAlbumList>();
    var resabl = GetProductAlbum.Do(Info.product_id);
    if (resabl != null && resabl.Body != null && resabl.Body.pic_list != null)
        imageList = resabl.Body.pic_list;
    foreach (ProductAlbumList _image in imageList)
    {
        if (_image.is_main > 0){
            Info.img_src = _image.img_src; break;
        }
    }

    List<GiftsList> gifts = new List<GiftsList>();
    var resgifts = GetProductGift.Do(Info.product_id.ToString());
    if(resgifts != null && resgifts.Body != null && resgifts.Body.gift_list != null)
    gifts =  resgifts.Body.gift_list;
        
%>
<script type="text/javascript">$(function(){document.title="<%=string.IsNullOrEmpty(Info.product_name)?"":(Info.product_name+"/")%>买赠设置/在售商品列表|九洲";});</script>
<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
<div class="position">
当前位置：
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <a href="/mgoods">在售商品列表</a> &gt;&gt; <span>买赠设置</span>
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
	DateTime promotion_bgdate= DateTime.Parse(Info.promotion_bdate);
	DateTime promotion_eddate= DateTime.Parse(Info.promotion_edate);
	if (promotion_bgdate <= DateTime.Now
	  && DateTime.Now <= promotion_eddate
	  && promotion_bgdate != promotion_eddate && Info.promotion_price < Info.sale_price){
		Response.Write("&nbsp;<span>直降</span>");
	}

    if (gifts.Count > 0)
    {
		Response.Write("&nbsp;<span>买赠</span>");
	}
%>
    </p>
    <p style="color:#999">商品分类：<%
		//ProductTypeInfo clsInfo = new ProductTypeInfo();//当前分类
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
		//clsInfo.n_name
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
    <p style="color:#ff6600;">售价：<%=saleprice%></p>
    <p style="color:#ff6600;">手机：<%=mobileprice%></p>
    </td>
    <td><%=Info.stock_num%></td>
    <td><%=Info.is_on_sale==1?"在售":"已下架"%></td>
  </tr>
</tbody>
</table>
<br/>
<div class="console">
    &nbsp;
	<a href="javascript:;" onclick="giftsAdd()"><b class="add">&nbsp;</b>添加到赠品列表</a>
</div>
<script type="text/javascript">
    function giftsAdd() {
        var nodes = $("#gifts-list input[name='productId']");
        var initList = "";
        var exceptList = [];
        for (var i = 0; i < nodes.length; i++) {
            if (i > 0) initList += ",";
            initList += $(nodes[i]).val();
        }
        

        showProductSelector(function (ids) {
            if (ids == "") return false;
            $.ajax({
                url: "/MTools/GetProductList2"
			, type: "post"
			, data: {
			    "ids": ids
			}
			, dataType: "json"
			, success: function (json, textStatus) {

			    for (var i = 0; i < json.length; i++) {
			        _mTableAddRow(json[i]);
			    }
			}, error: function (http, textStatus, errorThrown) {
			    jsbox.error(errorThrown);
			}
            });
        }, initList, exceptList, true, -1);   //第三个参数ture=允许选择带Sku商品;false=禁止选择带Sku商品
}

function _mTableAddRow(json) {
    var _isnew = true;
    $("input[name=productId]").each(function () {
        if ($(this).val() == json.product_id) {
            _isnew = false;
        }
    });
    if (_isnew) {
        var img = formatImageUrl(json.img_src, 120, 120);

        var tab = $("#gifts-list tbody");
        var html = '<tr>';
        html += '<td style="width:70px;height:70px;"><input type="hidden" name="productId" value="' + json.product_id + '"/><input type="hidden" name="giftId" value="' + json.product_id + '"/>';
        html += '<a href="<%=config.UrlHome%>' + json.product_id + '.html" target="_blank"><img src="' + img + '" style="width:60px;height:60px" alt=""/></a></td>';
        html += '<td><p><a href="<%=config.UrlHome%>' + json.product_id + '.html" target="_blank">' + json.product_name + '</a></p>';
        html += '<p class="pname" style="color:#999">商家编码：' + json.product_code + '</p></td>';
        html += '<td style="width:100px"><input type="text" name="sdate" value="<%=DateTime.Now.ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/></td>';
        html += '<td style="width:100px"><input type="text" name="edate" value="<%=DateTime.Now.AddDays(3).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/></td>';
        html += '<td style="width:180px">';
        html += ' 买 <input type="text" name="bnumber" value="1" class="input" style="width:30px;text-align:center" onclick="this.select()"/>';
        html += ' 送 <input type="text" name="gnumber" value="1" class="input" style="width:30px;text-align:center" onclick="this.select()"/></td>';
        html += '<td style="width:50px"><a href="javascript:;" onclick="_mTableRemoveRow(this)">删除</a></td>';
        html += '</tr>';

        var tr = $(html);
        tab.append(tr);
    }
}
function _mTableRemoveRow(obj){
	var tr=false;
	while(!tr){
		if(obj.tagName && obj.tagName.toLowerCase()=="tr"){
			tr=obj;
		}else{
			obj=obj.parentNode;
		}
	}
	if(tr) $(tr).remove();
}
function createXmlDocument(nodes){
	var xml='<?xml version="1.0" encoding="utf-8"?>';
	xml += '<items>';
	for(var i=0;i<nodes.length;i++){
		xml += nodes[i];
	}
	xml += '</items>';
	return xml;
}

function createXmlNode(json){
    return '<item id="' +json.id +'" productgiftid="' + json.productgiftid + '" sDate="' + json.sDate + '" eDate="' + json.eDate + '" bNumber="' + json.bNumber + '" gNumber="' + json.gNumber + '"/>';
}
function submitTable(form){
	var nodes=[];
	$("#gifts-list tbody tr").each(function(){
		nodes.push(createXmlNode({
		    "id": $(this).find("input[name='giftId']").val()
            ,"productgiftid": $(this).find("input[name='productgiftId']").val()
			,"sDate" : $(this).find("input[name='sdate']").val()
			,"eDate" : $(this).find("input[name='edate']").val()
			,"bNumber" : $(this).find("input[name='bnumber']").val()
			,"gNumber" : $(this).find("input[name='gnumber']").val()
		}));
	});

	var xml = createXmlDocument(nodes);

	$.ajax({
		url: "/mgoods/PostGifts?t=" + new Date().getTime()
		, type: "post"
		, data: {
			 proid : "<%=Info.product_id%>"
			,xml : xml
		}
		, dataType: "json"
		, success: function(json, textStatus){
			if(json.error){
				jsbox.error(json.message);
			}else{
				jsbox.success(json.message, window.location.href);
			}
		}, error: function(http, textStatus, errorThrown){
			jsbox.error(textStatus);
		}
	});
	
	return false;	
}
</script>
<%--数据列表开始--%>
<form action="" onsubmit="return submitTable(this)">
<table id="gifts-list" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th colspan="2">赠品</th>
    <th style="width:100px">开始时间</th>
    <th style="width:100px">结束时间</th>
    <th style="width:180px">赠送规则</th>
    <th style="width:50px">操作</th>
  </tr>
</thead>
<tbody>
<%

    foreach (GiftsList g in gifts)
    {

%>
	<tr>
	<td style="width:70px;height:70px;"><input type="hidden" name="productId" value="<%=g.gift_id%>"/><input type="hidden" name="giftId" value="<%=g.gift_id%>"/><input type="hidden" name="productgiftId" value="<%=g.product_gift_id%>"/>
	<a href="<%=config.UrlHome%><%=g.gift_id%>.html" target="_blank"><img src="<%=FormatImagesUrl.GetProductImageUrl(g.img_src, 120, 120)%>" style="width:60px;height:60px" alt=""/></a></td>
	<td><p><a href="<%=config.UrlHome%><%=g.gift_id%>.html" target="_blank"><%=g.product_name%></a></p>
	<p class="pname" style="color:#999">商家编码：<%=g.product_code%></p></td>
    <%string _stime = DateTime.Parse(g.start_time).ToString("yyyy-MM-dd");
      string _etime = DateTime.Parse(g.end_time).ToString("yyyy-MM-dd"); %>
	<td style="width:100px"><input type="text" name="sdate" value="<%=_stime%>" readonly="readonly" class="date" onclick="WdatePicker()"/></td>
	<td style="width:100px"><input type="text" name="edate" value="<%=_etime%>" readonly="readonly" class="date" onclick="WdatePicker()"/></td>
	<td style="width:180px">
	买 <input type="text" name="bnumber" value="<%=g.product_count%>" class="input" style="width:30px;text-align:center" onclick="this.select()"/>
	送 <input type="text" name="gnumber" value="<%=g.gift_count%>" class="input" style="width:30px;text-align:center" onclick="this.select()"/></td>
	<td style="width:50px"><a href="javascript:;" onclick="_mTableRemoveRow(this)">删除</a></td>
	</tr>
<%
	}
%>
</tbody>
</table>
<%--<ul id="gifts-box-data-list" class="gifts-box-list">

</ul>--%>
<%--数据列表结束--%>
<br/>
<table>
  <tr>
    <td class="left" style="width:789px">&nbsp;</td>
    <td>
<input type="submit" class="submit" value="保存" style="width:150px;"/>
    </td>
  </tr>
</table>
</form>
</div>
<br/><br/><br/><br/>
</div>

</div>
<br/><br/>
<br/><br/><br/>
<%Html.RenderPartial("MGoods/SelectProductControl"); %>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>
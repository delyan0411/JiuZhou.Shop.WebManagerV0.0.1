<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" language="javascript" src="/javascript/extjs/ext-all.js" charset="utf-8"></script>
<link rel="stylesheet" type="text/css" href="/javascript/extjs/resources/css/ext-all.css" />
<link href="/style/style.css" rel="stylesheet" type="text/css" />
<%Html.RenderPartial("Base/_PageHeadControl"); %>
<title><%=ViewData["pageTitle"]%></title>
</head>
<body>
<%
	int proid=DoRequest.GetQueryInt("proid");
    ProductInfo product = new ProductInfo();
    var respro = GetProductInfo.Do(proid);
    if (respro != null && respro.Body != null) {
        product = respro.Body;
    }
	string type= DoRequest.GetQueryString("type");
	if(type=="") type="uv";
%>
<%Html.RenderPartial("Base/_SimplePageTopControl"); %>
<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
<div class="position">
当前位置：
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>商品统计</span>
</div>
<form id="sForm" action="/manalysis/productview" method="get">
<input type="hidden" name="proid" value="<%=proid%>"/>
<div class="div-tab-h1" style="font-weight:100;color:#333;font-size:12px;height:36px">
    <p>
    <%
	    DateTime date = DateTime.Now.AddDays(-30);
    %><input type="text" name="sdate" value="<%=DoRequest.GetQueryDate("sDate", date).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
      至
      <input type="text" name="edate" value="<%=DoRequest.GetQueryDate("eDate", DateTime.Now).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
    </p>
    <p>
        <input type="submit" value=" 搜索 " class="submit"/>
    </p>
    <p>
        <a href="javascript:resetPage('type','uv');"<%if(type=="uv") Response.Write(" style=\"color:#ff6600\"");%>>UV</a>&nbsp;&nbsp;
        <a href="javascript:resetPage('type','pv');"<%if(type=="pv") Response.Write(" style=\"color:#ff6600\"");%>>PV</a>&nbsp;&nbsp;
        <a href="javascript:resetPage('type','sales');"<%if(type=="sales") Response.Write(" style=\"color:#ff6600\"");%>>销量</a>&nbsp;&nbsp;
        <a href="javascript:resetPage('type','people');"<%if(type=="people") Response.Write(" style=\"color:#ff6600\"");%>>订单</a>&nbsp;&nbsp;
        <a href="javascript:resetPage('type','rate');"<%if(type=="rate") Response.Write(" style=\"color:#ff6600\"");%>>转化率</a>
    </p>
</div>
</form>
<%
	List<ProductStatisticsInfo> infoList = (List<ProductStatisticsInfo>)(ViewData["infoList"]);
	if(infoList.Count<7){
		int _count=0;
		for(int i=infoList.Count;i<15;i++){
			int k=i-infoList.Count + _count;
			_count++;
			ProductStatisticsInfo tem=new ProductStatisticsInfo();
			tem.AddTime=DateTime.Now.AddDays(k);
			infoList.Add(tem);
		}
		infoList.Sort(
                        delegate(ProductStatisticsInfo x, ProductStatisticsInfo y)
                        {
                            return y.AddTime.CompareTo(x.AddTime);
                        });
	}
%>
<script type="text/javascript">
Ext.require('Ext.chart.*');
Ext.require('Ext.layout.container.Fit');
var arr=[];
<%
	for(int i=infoList.Count-1;i>=0;i--){
		ProductStatisticsInfo item=infoList[i];
		Response.Write("arr.push({");
		Response.Write("pv: " + item.PageViews);
		Response.Write(",uv: " + item.UserViews);
		Response.Write(",sales: " + item.Sales);
		Response.Write(",people: " + item.People);
		float val=(float)item.People/(float)(item.UserViews==0?1:item.UserViews) * 100.0f;
		Response.Write(",rate: \"" + val.ToString("0.00") + "\"");

		Response.Write(",shortdate: '" + item.AddTime.ToString("MM-dd")+"'");
		Response.Write(",date: '" + item.AddTime.ToString("yyyy年MM月dd日") + "'});");
	}
%>
var store1 = Ext.create('Ext.data.JsonStore',{
	fields: ['pv', 'uv', 'sales', 'people'
	, 'rate', 'shortdate', 'date'],
	data: arr
});
Ext.onReady(function () {
    var chart = Ext.create('Ext.chart.Chart', {
            animate: true,
            shadow: true,
            store: store1,
            axes: [{
                type: 'Category',
                position: 'bottom',
                fields: ['shortdate'],
                title: '日期',
                label: {
                    rotate: {
                        degrees: 270
                    }
                }
            }, {
                type: 'Numeric',
                position: 'right',
                fields: ['<%=type%>'],
                title: '<%
	switch(type){
		case "pv":
			Response.Write("PV");
			break;
		case "sales":
			Response.Write("销量");
			break;
		case "people":
			Response.Write("订单数");
			break;
		case "rate":
			Response.Write("转化率(%)");
			break;
		default:
			Response.Write("UV");
			break;
	}
%>',
                grid: true,
				majorTickSteps:5,
				minorTickSteps:10,
                minimum: 0
            }],
            series: [{
                type: 'column',
                axis: 'right',
                gutter: 80,
                xField: 'shortdate',
                yField: ['<%=type%>'],
                tips: {
                    trackMouse: true,
                    width: 120,
                    renderer: function (storeItem, item){
<%
	switch(type){
		case "pv":
			Response.Write("this.setTitle(storeItem.get('date') + \"<br/>PV：\" + storeItem.get('pv'));");
			break;
		case "sales":
			Response.Write("this.setTitle(storeItem.get('date') + \"<br/>销量：\" + storeItem.get('sales'));");
			break;
		case "people":
			Response.Write("this.setTitle(storeItem.get('date') + \"<br/>订单：\" + storeItem.get('people'));");
			break;
		case "rate":
			Response.Write("this.setTitle(storeItem.get('date') + \"<br/>转化率：\" + storeItem.get('rate') + \"%\");");
			break;
		default:
			Response.Write("this.setTitle(storeItem.get('date') + \"<br/>UV：\" + storeItem.get('uv') + \"<br/>转化率：\" +  storeItem.get('rate') + \"%\");");
			break;
	}
%>
                    }
                },
                style: {
                    fill: '#38B8BF'
                }
            }]
        });

    var panel1 = Ext.create('widget.panel', {
        width: 940,
        height: 400,
        //title: 'Column Chart with Reload - Hits per Month',
        renderTo: Atai.$("#extChart"),
        layout: 'fit',
        tbar: [],
        items: chart
    });
});
</script>
		<div class="div-tab">
<div id="extChart"></div>
		</div>
	</div>
</div>
<br/><br/>
</body>
</html>
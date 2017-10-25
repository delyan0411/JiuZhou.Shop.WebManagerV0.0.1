<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="../../echarts-2.2.6/build/dist/echarts.js"></script>
<link href="/style/style.css" rel="stylesheet" type="text/css" />
<%Html.RenderPartial("Base/_PageHeadControl"); %>
<title><%=ViewData["pageTitle"]%></title>
</head>
<body>
<%Html.RenderPartial("Base/_SimplePageTopControl"); %>
<div id="container-syscp">
	<div class="container-left">
    <%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
<div class="position">
当前位置：
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>一级类目销售情况</span>
</div>
<form action="/manalysis/categorypieview" method="get">
        <div class="div-tab-h1" style="font-weight: 100; color: #333; font-size: 12px">
       <p>
<%
    DateTime date = DateTime.Now.AddDays(-1);
%><input type="text" name="sdate" value="<%=DoRequest.GetQueryDate("sDate", date).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
至
<input type="text" name="edate" value="<%=DoRequest.GetQueryDate("eDate", DateTime.Now.AddDays(-1)).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
      </p>
            <p>
                <input type="submit" value=" 搜索 " class="submit" />&nbsp;&nbsp;<a href="javascript:;" style="font-size:14px" onclick="changeType('')">所有</a>&nbsp;<a href="javascript:;" style="font-size:14px" onclick="changeType('药品部')">药品</a>&nbsp;<a href="javascript:;" style="font-size:14px" onclick="changeType('非药品部')">非药品</a>&nbsp;&nbsp;<a href="/Manalysis/DownLoadPage" style="font-size:14px">导出</a> 
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
 var changeType=function(type){
	//_currUrl=formatUrl("type",value);
	url=formatUrl("type",type);
	window.location.href=url;
};
     // Step:3 conifg ECharts's path, link to echarts.js from current page.
     // Step:3 为模块加载器配置echarts的路径，从当前页面链接到echarts.js，定义所需图表路径
     require.config({
         paths: {
             echarts: '../../echarts-2.2.6/build/dist'
         }
     });

     // Step:4 require echarts and use it in the callback.
     // Step:4 动态加载echarts然后在回调函数中开始使用，注意保持按需加载结构定义图表路径
     require(
        [
            'echarts',
            'echarts/chart/pie'
        ],
        function (ec) {
            //--- 折柱 ---
            var myChart = ec.init(document.getElementById('main'));
            var tname = "<%=(string)ViewData["tname"] %>";
            var tname2 = tname.split(',');
            //var _tname = "<%=(string)ViewData["_tname"] %>".split(',');
            var tmoney = "<%=(string)ViewData["tmoney"] %>";
            var tmoney2 = tmoney.split(',');
            var _data = '[';
            for(var i = 0;i<tname2.length;i++)
            {
            _data += '{"name":"' + tname2[i] + '","value":' + tmoney2[i] + '},';
            }
            if(_data.length > 1)
                _data = _data.substring(0,_data.length - 1);
            _data += ']';

            myChart.setOption({
                title: {
                    text: '一级类目销售情况',
                    x: 'center'
                },
                tooltip: {
                    trigger: 'item',
                    formatter: "{b}({d}%)"
                },
                legend: {
                    orient: 'vertical',
                    x: 'left',
                    data: tname2
                },
                toolbox: {
                    show: true,
                    feature: {
                        mark: { show: true },
                        dataView: { show: true, readOnly: false },
                        magicType: {
                            show: true,
                            type: ['pie', 'funnel'],
                            option: {
                                funnel: {
                                    x: '25%',
                                    width: '50%',
                                    funnelAlign: 'left',
                                    max: 1548
                                }
                            }
                        },
                        restore: { show: true },
                        saveAsImage: { show: true }
                    }
                },
                calculable: true,
                series: [
        {
            //name: '访问来源',
            type: 'pie',
            radius: '55%',
            center: ['50%', '60%'],
            data: $.parseJSON(_data)
        }
    ]
    });
    });
    </script>
<div id="extChart"></div>
    <div id="main" style="height:500px;border:1px solid #ccc;padding:10px;"></div>
	
	</div>
</div>
<br/><br/>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>
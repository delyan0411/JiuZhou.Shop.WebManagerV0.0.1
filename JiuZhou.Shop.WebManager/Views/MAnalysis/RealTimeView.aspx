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
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>实时统计</span>&nbsp&nbsp;<a href="/Manalysis/DownLoadPage" style="font-size:14px;color:green">导出</a> 
</div>

 <script type="text/javascript">
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
            'echarts/chart/line'
        ],
     //回调函数 
        DrawEChart
        );

     //渲染ECharts图表 
     function DrawEChart(ec) {
            var data1 = "<%=(string)ViewData["data1"] %>".split(',');
            var data2 = "<%=(string)ViewData["data2"] %>".split(',');
            
         //图表渲染的容器对象 
         var chartContainer = document.getElementById("main");
         //加载图表 
         var myChart = ec.init(chartContainer);
         myChart.setOption({
             //图表标题 
             title: {
                 text: "实时统计(昨日/今日)", //正标题 
                 x: "center", //标题水平方向位置 
                 //正标题样式 
                 textStyle: {
                     fontSize: 24
                 }
             },
             //数据提示框配置 
             tooltip: {
                 trigger: 'axis', //触发类型，默认数据触发，见下图，可选为：'item' | 'axis' 其实就是是否共享提示框 
                 //formatter: "时间:{b}<br/>总销售额（按支付时间）:{c[0]} 元<br/>总销售额（按发货时间）:{c[1]} 元"
                  formatter:function(params)  
                  {  
                      var relVal = '小时：' + params[0].name;  
                      for (var i = 0, l = params.length; i < l; i++) {  
                          relVal += '<br/>' + params[i].seriesName + ' : ' + params[i].value+" 元";  
                      }  
                      return relVal;  
                  }  
             },
             //图例配置 
             legend: {
                 data: ['今日', '昨日'], //这里需要与series内的每一组数据的name值保持一致 
                 y: "bottom"
             },
             //工具箱配置 
             toolbox: {
                 show: true,
                 feature: {
                     mark: { show: true }, // 辅助线标志，上图icon左数1/2/3，分别是启用，删除上一条，删除全部 
                     dataView: { show: true, readOnly: false }, // 数据视图，上图icon左数8，打开数据视图 
                     magicType: { show: true, type: ['line', 'bar', 'stack', 'tiled'] }, // 图表类型切换，当前仅支持直角系下的折线图、柱状图转换，上图icon左数6/7，分别是切换折线图，切换柱形图 
                     restore: { show: true }, // 还原，复位原始图表，上图icon左数9，还原 
                     saveAsImage: { show: true} // 保存为图片，上图icon左数10，保存 
                 }
             },
             calculable: true,
             //轴配置 
             xAxis: [
                    {
                        type: 'category',
                        boundaryGap : false,
                        data: ['0','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23'],
                        name: "小时"
                    }
                ],
             //Y轴配置 
             yAxis: [
                    {
                        type: 'value',
                        splitArea: { show: true },
                        name: "销售额",
                        axisLabel : {
                            formatter: '{value} 元'
                        }
                    }
                ],
             //图表Series数据序列配置 
             series: [
                    {
                        name: '今日',
                        type: 'line',
                        smooth:true,
                        data: data1
                    },
                    {
                        name: '昨日',
                        type: 'line',
                        smooth:true,
                        data: data2
                    }
                ]
         });
     } 
    </script>
    <div id="main" style="height:500px;border:1px solid #ccc;padding:10px;"></div>
	
	</div>
</div>
<br/><br/>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>
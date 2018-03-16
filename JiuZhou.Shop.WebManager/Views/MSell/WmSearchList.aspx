<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="JiuZhou.Model" %>
<%@ Import Namespace="JiuZhou.Common" %>
<%@ Import Namespace="JiuZhou.MySql" %>
<%@ Import Namespace="JiuZhou.HttpTools" %>
<%@ Import Namespace="JiuZhou.Cache" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="/style/style.css" rel="stylesheet" type="text/css" />
    <%Html.RenderPartial("Base/_PageHeadControl"); %>
    <title>
        <%=ViewData["pageTitle"]%></title>
</head>
<body>
    <%Html.RenderPartial("Base/_SimplePageTopControl"); %>
    <%
        ConfigInfo config = (ConfigInfo)(ViewData["config"]);
        JiuZhou.ControllerBase.ForeBaseController su = new JiuZhou.ControllerBase.ForeBaseController();
    %>
    <div id="container-syscp">
        <div class="container-left">
            <%Html.RenderPartial("Base/LeftControl"); %>
        </div>
        <div class="container-right">
            <div class="position">
                当前位置： <a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>微脉搜索关键字列表</span> &nbsp;&nbsp;&nbsp;
            </div>
            <form id="sForm" action="/msell/WmSearchList" method="get" >
            <input type="hidden" name="size" value="<%=DoRequest.GetQueryInt("size", 60)%>" />
            <div class="div-tab-h1" style="font-weight: 100; color: #333; font-size: 12px; height: 36px">
                <p>
                    <%
                        DateTime date = DateTime.Now.AddDays(-15);
                    %><input type="text" name="sdate" value="<%=DoRequest.GetQueryDate("sDate", date).ToString("yyyy-MM-dd")%>"
                        readonly="readonly" class="date" onclick="WdatePicker()" />
                    至
                    <input type="text" name="edate" value="<%=DoRequest.GetQueryDate("eDate", DateTime.Now).ToString("yyyy-MM-dd")%>"
                        readonly="readonly" class="date" onclick="WdatePicker()" />
                </p>
                <p style="position: relative">
                    <input type="text" id="sQuery" name="q" value="<%=DoRequest.GetQueryString("q")%>"
                        class="input" autocomplete="off" style="height: 26px; width: 260px; line-height: 26px;" /></p>
                <p>
                    <input type="submit" value=" 搜索 " class="submit" />
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
var changeOrderBy=function(ocol,ot){
	_currUrl=formatUrl("ocol",ocol);
	url=formatUrl("ot",ot);
	window.location.href=url;
};

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
$(function(){
	$("table[v='order-list']").mouseenter(function(){
		$(this).addClass("table-hover");
	}).mouseleave(function(){
		$(this).removeClass("table-hover");
	});
});
            </script>
            <%=ViewData["pageIndexLink"]%>
            <table id="tab-category" class="table" cellpadding="0" cellspacing="0">
            <thead>
                <tr>
                    <th>
                        查询字段
                    </th>
                    <th style="width: 12%">
                        查询次数
                    </th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<WmWordsInfo> infoList = (List<WmWordsInfo>)ViewData["infoList"];
                    if (infoList == null)
                        infoList = new List<WmWordsInfo>();
                    foreach (WmWordsInfo item in infoList)
                    {
                %>
                <tr>
                    <td>
                        <%=item.word_name%>
                    </td>
                    <td>
                            <%=item.word_id%>
                    </td>                  
                </tr>
                <%
}
                %>
            </tbody>
        </table>
            <%=ViewData["pageIndexLink2"]%>
            <br />
            <br />
            <br />
            <br />
        </div>
    </div>
    <script type="text/javascript">
        $(function () {
            var obj = $("#syscp-menu");
            var _offset = obj.offset();
            $(window).scroll(function () {
                var _stop = $(window).scrollTop() + 1;
                if (parseInt(_stop) > parseInt(_offset.top)) {
                    obj.css({ margin: "0", width: 220, zIndex: "1" });
                    if (Atai.ST.isMinIE6) {
                        obj.css({ position: "absolute", "opacity": 0.9, top: (_stop) + "px" });
                    } else {
                        obj.css({ position: "fixed", "opacity": 0.9, top: "1px" });
                    }
                } else {
                    obj.css({ position: "relative", "opacity": 1, top: "auto", marginTop: "0", borderBottom: "0" });
                }
            });
        });
    </script>
    <br />
    <br />
    <br />
    <br />
    <br />
    <%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>

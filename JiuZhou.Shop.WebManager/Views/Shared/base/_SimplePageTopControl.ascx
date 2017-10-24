<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.MySql" %>

<link href="/javascript/UI/style.css" type="text/css" rel="stylesheet" />
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);

   // List<SysNodeInfo> sysNodes = (List<SysNodeInfo>)ViewData["sysNodes"];
    List<UserResBody> userResBody = (List<UserResBody>)ViewData["userNodes"];
    UserResBody currNode = (UserResBody)ViewData["currResBody"];
    if (currNode == null) currNode = new UserResBody();
%>
<div id="head-top">
	<div class="head-line">
		<a href="<%=config.UrlHome + "Help/index" %>" class="help" target="_blank"><i></i>帮助</a><b></b>
		<div class="head-text">
			<a href="<%=config.UrlUserCenter %>" target="_blank"> <%= (string)ViewData["userName"] %><span style="color:#888">(我的账户)</span></a> 欢迎进入管理后台！
			<a href="javascript:;" onclick="managerOut()" >退出管理</a>&nbsp;&nbsp;
			<a href="/home/index" style="color:#888" target="_blank">管理首页</a>&nbsp;&nbsp;
			<a href="<%=config.UrlHome %>" style="color:#00F" target="_blank">返回前台</a>&nbsp;
            <a href="javascript:;" onclick="clearcache()">清理缓存</a>
		</div>
		<div class="clear"></div>
	</div>
</div>
<div id="container-navigation">
	<div class="container">
		<div id="label-name" class="label-name">
<%
    List<UserResBody> nodes = userResBody.FindAll(delegate(UserResBody item) { return item.parent_id == 1; });
    nodes.Sort(delegate(UserResBody x, UserResBody y)
    {
        return y.res_path.CompareTo(x.res_path);
    });
    int count = 0;
    for (int i = 0; i < nodes.Count; i++)
    {
        UserResBody node = nodes[i];
        count++;
        string url = "javascript:void(0);";
        if (!string.IsNullOrEmpty(node.res_src))
            url = node.res_src;
        string className = "";
        if (count == nodes.Count)
        {
            className = " class=\"first\"";
        }
        Response.Write("<a href=\"" + url + "\"" + className + " count=\"" + count + "\" nodeid=\"" + node.res_id + "\" val=\"" + node.res_path + "\"><b class=\"lf\"></b><span class=\"ct\">" + node.res_name + "</span><b class=\"rt\"></b></a>\n");
    }
    %>
			<div class="clear">&nbsp;</div>
		</div>
	</div>
	<div class="clear">&nbsp;</div>
</div>
<%--二级子菜单开始--%>
<ul id="navigation-items">
<%
    foreach (UserResBody node in nodes)
    {
        string className = "";
%>
<li val="<%=node.res_path%>"<%=className%>>
<%
    List<UserResBody> cNodes = userResBody.FindAll(delegate(UserResBody item) { return item.parent_id == node.res_id; });
    int __count = 0;
    foreach (UserResBody em in cNodes)
    {
        string cClassName = "";
        string url = "javascript:void(0);";
        if (string.IsNullOrEmpty(em.res_src))
        {
            List<UserResBody> _tem = userResBody.FindAll(delegate(UserResBody item) { return item.parent_id == em.res_id; });
            if (_tem != null && _tem.Count > 0)
            {
                if (!string.IsNullOrEmpty(_tem[0].res_src))
                    url = _tem[0].res_src;
            }
        }
        else
        {
            url = em.res_src;
        }
        if (__count > 0)
            Response.Write("<b>&nbsp;</b>\n");
        Response.Write("<a href=\"" + url + "\"" + cClassName + " val=\"" + em.res_path + "\">" + em.res_name + "</a>\n");
        __count++;
    }
%>
</li>
<%
    }
%>
</ul>
<div class="clear">&nbsp;</div>
<%--//二级子菜单结束--%>
<script type="text/javascript">
    $(function () {
        var path = "<%=currNode.res_path%>";
        var arr = path.split(",");
        var labelList = $("#container-navigation div[class='label-name'] a");
        var dataList = $("#navigation-items li");
        if (labelList.length > 0) {
            var o = $(labelList[labelList.length - 1]);
            if (!o.hasClass("first")) {
                o.addClass("first");
            }
        }
        if (arr.length > 3) {
            labelList.each(function () {
                if ($(this).attr("val") == (arr[0]+","+arr[1]+","+arr[2])+",")
                    $(this).addClass("on");
                else
                    $(this).removeClass("on");
                $(this).bind('click', function () {
                    if ($(this).hasClass("on"))
                        return;
                    labelList.each(function () {
                        $(this).removeClass("on");
                    });
                    var clickCode = $(this).attr("val");
                    $(this).addClass("on");
                    dataList.each(function () {
                        if (clickCode == $(this).attr("val")) {
                            $(this).addClass("show");
                        } else {
                            $(this).removeClass("show");
                        }
                    });

                    $.ajax({
                        url: "/MTools/GetHtmlNodes"
					, type: "post"
					, data: { parentid: $(this).attr("nodeid") }
					, dataType: "html"
					, success: function (html, textStatus) {
					    $("#syscp-menu").html(html);
					    $("#syscp-menu dd").each(function () {
					        if ($(this).attr("val") == path)
					            if (!$(this).hasClass("on")) $(this).addClass("on");
					            else
					                $(this).removeClass("on");
					    });
					}, error: function (http, textStatus, errorThrown) {

					}
                    });

                });
            });
            dataList.each(function () {
                if ($(this).attr("val") == (arr[0] + "," + arr[1] + "," + arr[2] + ","))
                    if (!$(this).hasClass("show")) $(this).addClass("show");
                    else
                        $(this).removeClass("show");
            });
            if (arr.length > 4) {
                $("#navigation-items li a").each(function () {
                    if ($(this).attr("val") == arr[0] + "," + arr[1] + "," + arr[2] + "," + arr[3] + ",")
                        if (!$(this).hasClass("on")) $(this).addClass("on");
                        else
                            $(this).removeClass("on");
                });
            }
        }
        });

        function clearcache() {
            $.ajax({
                url: "/MTools/ClearCache"
        , type: "post"
		, dataType: "json"
		, success: function (json) {
		    jsbox.success("缓存已清除！");

		}
            });
        }
</script>
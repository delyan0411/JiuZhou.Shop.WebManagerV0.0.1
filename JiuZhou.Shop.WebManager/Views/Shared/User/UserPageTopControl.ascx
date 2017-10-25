<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.MySql" %>
<%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%><div id="loadding"></div>
<%--页头开始--%>
<div id="user-head">
	<div class="head">
		<div class="logo"><a href="<%=config.UrlHome %>" title="九洲网上药店"><h3>九洲网上药店</h3></a></div>
	<dl class="menu"><dt></dt>
	<dd><a href="<%=config.UrlHome %>" title="首页">首页</a></dd><dt></dt>
	<%--<dd><a href="http://yp.dada360.com/" title="医药馆">医药馆</a></dd><dt></dt>
	<dd><a href="http://ys.dada360.com/" title="养生馆">养生馆</a></dd><dt></dt>
	<dd><a href="http://qx.dada360.com/" title="器械馆">器械馆</a></dd><dt></dt>
	<dd><a href="http://byt.dada360.com/" title="成人馆">成人馆</a></dd><dt></dt>
	<dd><a href="http://baby.dada360.com/" title="母婴馆">母婴馆</a></dd><dt></dt>
	<dd><a href="http://yj.dada360.com/" title="眼镜馆">眼镜馆</a></dd><dt></dt>
	<dd><a href="http://mr.dada360.com/" title="美容馆">美容馆</a></dd><dt></dt>
	<dd><a href="http://ms.dada360.com/" title="美食馆">美食馆</a></dd><dt></dt>
	<dd><a href="<%=config.UrlHome%>promot/" title="促销专区">促销专区</a></dd><dt></dt>--%>
	<dd><a href="<%=config.UrlHome %>info/" title="资讯">资讯</a></dd><dt></dt>
	<dd><a href="<%=config.UrlHome %>help/" target="_blank"><i class="is-icon help-icon"></i>帮助</a></dd>
	</dl>
	<div class="clear">&nbsp;</div>
	</div>
</div>
<div class="clear">&nbsp;</div>

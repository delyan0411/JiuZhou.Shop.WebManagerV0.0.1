<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="System.Collections.Generic" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.MySql" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %>
<%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div class="clear">&nbsp;</div>
<div id="foot-line"></div>
<div id="foot-links" class="edit">
	<a href="<%=config.UrlHome%>" title="首页">首页</a>
	<b>&nbsp;</b>
	<a href="http://yp.dada360.com/" title="医药馆">医药馆</a>
	<b>&nbsp;</b>
	<a href="http://ys.dada360.com/" title="养生馆">养生馆</a>
	<b>&nbsp;</b>
	<a href="http://qx.dada360.com/" title="器械馆">器械馆</a>
	<b>&nbsp;</b>
	<a href="http://byt.dada360.com/" title="成人馆">成人馆</a>
	<b>&nbsp;</b>
	<a href="<%=config.UrlHome%>class/5.html" title="母婴馆">母婴馆</a>
	<b>&nbsp;</b>
	<a href="<%=config.UrlHome%>search?q=%E9%9A%90%E5%BD%A2%E7%9C%BC%E9%95%9C" title="眼镜馆">眼镜馆</a>
	<b>&nbsp;</b>
	<a href="<%=config.UrlHome%>class/6.html" title="美容馆">美容馆</a>
	<b>&nbsp;</b>
	<a href="<%=config.UrlHome%>jiankang/" title="资讯">资讯</a>
	<b>&nbsp;</b>
	<a href="<%=config.UrlHome%>help/detail/66.html" title="公司介绍" target="_blank">公司介绍</a>
	<b>&nbsp;</b>
	<a href="<%=config.UrlHome%>help/detail/67.html" title="门店网络" target="_blank">门店网络</a>
	<b>&nbsp;</b>
	<a href="<%=config.UrlHome%>help/detail/71.html" title="投诉建议" target="_blank">投诉建议</a>
	<b>&nbsp;</b>
	<a href="<%=config.UrlHome%>help/detail/71.html" title="商务合作" target="_blank">商务合作</a>
	<b>&nbsp;</b>
	<a href="<%=config.UrlHome%>sitemap.aspx" title="站点地图" target="_blank">站点地图</a>
</div>

<div id="foot-copyright" class="edit">
	药品信息服务 (浙)-经营性-2009-0002<b>&nbsp;</b>(浙)卫食证字(2008)第330105201493号<b>&nbsp;</b>浙药管械经营许(零)01零0094号<b>&nbsp;</b>GCP证书 B-ZJ09-044
    <br/>
	浙ICP备10044324号<b>&nbsp;</b>浙B2-20100145<b>&nbsp;</b><span>&copy;</span> 2010-<%=DateTime.Now.ToString("yyyy")%> <a href="<%=config.UrlHome%>" class="t">www.dada360.com</a> <b>&nbsp;</b>互联网药品交易资格证 浙C20100001<br/>
药监部门提示：如发现本站有任何直接或变相销售处方药行为，请保留证据，拨打12331举报，举报查实给予奖励
	<div class="tub">
		<p class="net110"><a href="http://www.pingpinganan.gov.cn/web/index.aspx?spm=1.6659421.774530365.25.TrD5jO&file=index.aspx" target="_blank"><img src="<%=config.UrlHome%>images/img/net110.gif" alt=""/></a></p>
		<p class="gs"><a href="http://122.224.75.236/wzba/login.do?method=hdurl&doamin=http://www.dada360.com/&id=330105000037844&SHID=1223.0AFF_NAME=com.rouger.gs.main.UserInfoAff&AFF_ACTION=qyhzdetail&PAGE_URL=ShowDetail" target="_blank" title="工商网络标识"><i>工商网络标识</i></a></p>
		<p class="baidu"><a href="http://help.baidu.com/question?prod_en=master&class=552&id=1001076" target="_blank" title="百度认证"><i>百度认证</a></i></p>
	</div><br/>
</div>
<%--右侧快捷导航开始--%>

<div id="alert-box-control" class="box">
	<div id="alert-box-control-name" class="name">
		操作提示
		<div class="close" id="alert-box-control-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
	<div class="alert-box-container">
		<div id="alert-box-icon" class="alert-icon">&nbsp;</div>
		<div id="alert-box-message" class="alert-message">&nbsp;</div>
		<div class="clear">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
	<div class="alert-box-links">

	</div>
	<div class="alert-box-button">
		<input type="button" id="alert-box-button" class="btn btn_1" value="   确 定   " onclick="Atai.$('#alert-box-control-close').click()"/>
	</div>
</div>
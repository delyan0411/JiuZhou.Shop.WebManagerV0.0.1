<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.MySql" %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div class="clear">&nbsp;</div>
<div id="foot-line"></div>

<div id="foot-links">
    <a href="<%=config.UrlHome %>" title="">首页</a>
    <b>&nbsp;</b>
	<a href="<%=config.UrlHome %>yiyao/" title="医药馆">医药馆</a>
	<b>&nbsp;</b>
	<a href="<%=config.UrlHome %>yangsheng/" title="养生馆">养生馆</a>
	<b>&nbsp;</b>
	<a href="<%=config.UrlHome %>qixie/" title="器械馆">器械馆</a>
	<b>&nbsp;</b>
	<a href="<%=config.UrlHome %>baby/" title="母婴馆">母婴馆</a>
	<b>&nbsp;</b>
	<a href="<%=config.UrlHome %>yanjing/" title="眼镜馆">眼镜馆</a>
	<b>&nbsp;</b>
	<a href="<%=config.UrlHome %>meirong/" title="美容馆">美容馆</a>
	<b>&nbsp;</b>
	<a href="<%=config.UrlHome %>meishi/" title="美食城" target="_blank">美食城</a>
    <b>&nbsp;</b>
    <a href="<%=config.UrlHome %>info/" title="资讯" target="_blank">资讯</a>
    <b>&nbsp;</b>
	<a href="<%=config.UrlHome %>help/detail/66.html" title="公司介绍" target="_blank">公司介绍</a>
	<b>&nbsp;</b>
	<a href="<%=config.UrlHome %>help/detail/67.html" title="门店网络" target="_blank">门店网络</a>
	<b>&nbsp;</b>
	<a href="<%=config.UrlHome %>help/detail/89.html" title="商务合作" target="_blank">商务合作</a>
	<b>&nbsp;</b>
	<a href="<%=config.UrlHome %>help/detail/88.html" title="加入我们" target="_blank">加入我们</a>
</div>
<div id="foot-copyright">
	药品信息服务 (浙)-经营性-2009-0002<b>&nbsp;</b>(浙)卫食证字(2008)第330105201493号<b>&nbsp;</b>浙药管械经营许(零)01零0094号<b>&nbsp;</b>GCP证书 B-ZJ09-044
    <br/>
	<a href="http://www.miibeian.gov.cn/" target="_blank">浙C20100001</a><b>&nbsp;</b>浙B2-20100145<b>&nbsp;</b><span>&copy;</span> 2010-<%=DateTime.Now.ToString("yyyy")%> <a href="" class="t">www.dada360.com</a> <b>&nbsp;</b>互联网药品交易资格证 浙C20100001
	<div class="tub">
		<p class="net110"><a href="http://www.pingpinganan.gov.cn/web/index.aspx?spm=1.6659421.774530365.25.TrD5jO&file=index.aspx" target="_blank"><img src="/images/net110.gif" alt=""/></a></p>
		<p class="gs"><a href="http://122.224.75.236/wzba/login.do?method=hdurl&doamin=http://www.dada360.com/&id=330105000037844&SHID=1223.0AFF_NAME=com.rouger.gs.main.UserInfoAff&AFF_ACTION=qyhzdetail&PAGE_URL=ShowDetail" target="_blank" title="工商网络标识"><i>工商网络标识</i></a></p>
		<p class="baidu"><a href="http://help.baidu.com/question?prod_en=master&class=552&id=1001076" target="_blank" title="百度认证"><i>百度认证</a></i></p>
	</div><br/>
    </div>

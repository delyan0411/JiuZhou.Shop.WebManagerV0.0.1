<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%@ Import Namespace="JiuZhou.Model" %>
<%@ Import Namespace="JiuZhou.Common" %>
<%@ Import Namespace="JiuZhou.MySql" %>
<%@ Import Namespace="JiuZhou.Cache" %>
<%@ Import Namespace="JiuZhou.XmlSource" %>
<%@ Import Namespace="JiuZhou.HttpTools" %>
<%@ Import Namespace="JiuZhou.ControllerBase" %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<%--页头开始--%>
<div id="head-top">
    <script type="text/javascript" src="<%=config.UrlHome%>api/PageHeadNew"></script>
</div>
<%--页头结束--%>

<%--导航开始--%>
<div id="head-main">
    <div class="head-box">
        <div class="logo">
            <a href="<%=config.UrlHome%>" title="九洲网上药店">
                <h3>
                    九洲网上药店</h3>
            </a>
        </div>
        <div class="head-nbsp">
            &nbsp;</div>
        <div class="sform">
            <div id="move-text" class="text">
                <ul>
                    <li>
                        </li>
                </ul>
            </div>
            <form action="<%=config.UrlHome%>search" method="get" onsubmit="return sch(this)"
            target="_blank">
            <div class="inputs">
                <p class="sleft">
                    <label id="sLabel" for="search-query">
                       </label></p>
                <p class="sright">
                    <input type="submit" value="" /></p>
            </div>
            <div class="tags">
            
            </div>
            </form>
        </div>

     
        <div class="clear">
        </div>
    </div>
</div>
<%-- 导航结束 --%>
<div id="main-nav">
    <ol>
        <li class="categ " v="home">
            <%--除首页外，其他页面的v值填categ--%>
            <div>
                <a href="<%=config.UrlHome%>class/" title="商品分类">商品分类<em></em></a></div>
        </li>
        <li><a href="<%=config.UrlHome%>" title="首页">首页</a></li><li class="li"></li>
        <li><a href="<%=config.UrlHome%>yiyao/" title="医药馆">医药馆</a></li><li class="li"></li>
        <li><a href="<%=config.UrlHome%>yangsheng/" title="养生馆">养生馆</a></li><li class="li">
        </li>
        <li><a href="<%=config.UrlHome%>qixie/" title="器械馆">器械馆</a></li><li class="li"></li>
        <li><a href="<%=config.UrlHome%>search?q=<%=DoRequest.UrlEncode("@all") %>&ykt=1" title="医卡通专区">医卡通专区</a> </li>
        <li class="li"></li>
       <%-- <li><a href="<%=config.UrlHome%>groupbuy/" title="团购" target="_blank">团购</a>
            <img src="<%=config.UrlHome%>images/new.gif" class="new-ico" alt="new" />
        </li>--%>
    </ol>
    <div class="clear">
        &nbsp;</div>
</div>

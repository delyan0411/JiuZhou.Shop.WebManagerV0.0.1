<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="System.Collections.Generic" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.MySql" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %>
<%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
	int tid = DoRequest.GetQueryInt("tid");
%>
<div id="moduleAdd-boxControl" class="moveBox" style="height:260px;">
	<div id="moduleAdd-boxControl-boxName" class="name">
		添加模块
		<div class="close" id="moduleAdd-boxControl-close" v="atai-shade-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
	<div class="tips-text">请选择模块类型</div>
<form action="" onsubmit="return createModule(this)">
<input type="hidden" name="tid" value="<%=tid%>" />
	<div class="box-radio">
		<input type="radio" name="mode" value="0" checked="checked"/> 完全自定义(文本)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<%--	<input type="radio" name="mode" value="1" /> 商品推荐(列表)
<br/>
		<input type="radio" name="mode" value="2" /> 商品列表(带分页)
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="radio" name="mode" value="3" /> 轮播图
        <br />
        <input type="radio" name="mode" value="4" /> 图片展示--%>

		<input type="radio" name="mode" value="5" /> 商品楼层(新)
	</div>
<br/>
	<div class="box-button" style="position:absolute;top:200px;left:140px;"><input type="submit" class="submit" value="  确 定  " onclick="$('#moduleAdd-boxControl .close').click()"/></div>
</form>
</div>
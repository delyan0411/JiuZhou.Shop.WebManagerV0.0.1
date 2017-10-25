<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/style/style.css" rel="stylesheet" type="text/css" />
<%Html.RenderPartial("Base/_PageHeadControl"); %>
<title><%=ViewData["pageTitle"]%></title>
</head>
<body>
<%Html.RenderPartial("Base/_SimplePageTopControl"); %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
<div class="position">
当前位置：
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>品牌列表</span>
</div>
<form action="/mgoods/brandlist" method="get">
<div class="div-tab-h1" style="font-weight:100;color:#333;font-size:12px;height:36px">
<p style="position:relative">
		<input type="text" name="q" value="<%=DoRequest.GetQueryString("q")%>" class="input" autocomplete="off" style="width:220px;height:24px;line-height:24px;"/></p>
<p>
<input type="submit" value=" 搜索 " class="submit"/>
</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="/mgoods/brandeditor?brandid=0" style="color:White;" class="submit">新增品牌&nbsp;</a>
	</p>		
			</div>
</form>
<%
    List<BrandInfo> infoList = (List<BrandInfo>)(ViewData["infoList"]);
    if (infoList == null)
        infoList = new List<BrandInfo>();
%>
<%=ViewData["pageIndexLink"]%>
<form id="post-form" method="post" action="">
		<div class="div-tab">
<table class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:3%"><input type="checkbox" onclick="checkAll(this.form,this)" name="chkall" title="选中/取消选中"/></th>
    <th style="width:16%">品牌名称</th>
    <th>介&nbsp;&nbsp;绍</th>
    <th style="width:8%">状态</th>
    <th style="width:9%">操作</th>
  </tr>
</thead>
<tbody>
<%
    foreach (BrandInfo item in infoList)
    {
%>
  <tr>
    <td><input type="checkbox" onclick="selectOne(this)" name="visitid" value="<%=item.brand_id%>" /></td>
    <td><%=item.brand_name%></td>
    <td><%=item.brand_intro%></td>
    <td><a href="javascript:;" onclick="resetBrandState(<%=item.brand_id%>,<%=item.brand_state==0?1:0 %>)"><%=item.brand_state==0?"已显示":"<span style='color:red'>已隐藏</span>"%></a></td>
    <td>
    <a href="/mgoods/brandeditor?brandid=<%=item.brand_id%>" target="_blank">编辑</a>
    </td>
  </tr>
<%
	}
%>
  </tbody>
</table>
		</div>
        
<%=ViewData["pageIndexLink2"]%>
<div class="div-tab-bottom">
            	<b class="icon-add">&nbsp;</b><a href="/mgoods/brandeditor?brandid=0" style="color:#0000FF">新增品牌</a>
			</div>
            </form>
	</div>
</div>
<br/><br/>
<script type="text/javascript">
    function resetBrandState(id, status) {
        $.ajax({
            url: "/mgoods/ResetBrandStatus"
			, data: {"id":id,"state":status}
            , type: "post"
			, dataType: "json"
			, success: function (json, textStatus) {
			    if (json.error) {
			        jsbox.error(json.message); return false;
			    } else {
			        jsbox.success(json.message, window.location.href);
			    }
			}
        });
        return false;
    }
</script>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body></html>
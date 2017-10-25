<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %><%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%Html.RenderPartial("Base/_PageHeadControl"); %>
<link href="/style/style.css" rel="stylesheet" type="text/css" />
<title><%=ViewData["pageTitle"]%></title>
</head>
<body>
<%Html.RenderPartial("Base/_SimplePageTopControl"); %>
    <%
        ConfigInfo config = (ConfigInfo)(ViewData["config"]);
        //int state = DoRequest.GetQueryInt("state");
    %>
    <div id="container-syscp">
   <div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
		<div class="editor-box-head">
帮助分类&nbsp;&nbsp;&nbsp;&nbsp;
<a href="javascript:;" onclick="categEditorBox(event,0,0)" style="color:#00F">添加根类</a>
		</div>
<script language="c#" runat="server">
    List<ArticleTypeInfo> tList = GetArticleType.Do(0,2,-1).Body.article_type_list;
	int tree=0;
	public void PrintList(int parentId){
        if (tList == null)
            tList = new List<ArticleTypeInfo>();
		if (parentId < 0) return;
        List<ArticleTypeInfo> items = tList.FindAll(
            delegate(ArticleTypeInfo em)
            {
				return em.parent_id==parentId;
		});
        if (items.Count <= 0) return;
		//tree++;
        bool isHasChild = false;
        Response.Write("<ul>");
		isHasChild = true;
        foreach (ArticleTypeInfo item in items)
        {
			string[] arr=item.type_path.Split(',');
			tree=arr.Length;
			Response.Write("<li>");
			Response.Write("<div tree=\"" + tree + "\"><a href=\"javascript:;\" v=\"bt\" class='jslk'>&nbsp;</a>");
			Response.Write("<a href=\"javascript:;\" v=\"bt\" style=\"color:"+(item.type_state==0?"#000":"#999")+"\">" + item.article_type_name + "(" + item.sort_no + ")</a>");

			Response.Write("<p class=\"b-list\" style=\"left:"+ (320 - (tree-1) * 18) +"px\">");
			
			Response.Write("<a href=\"javascript:;\" onclick=\"categEditorBox(event," + item.article_type_id + ", 0)\" style=\"color:"+(item.type_state==0?"#060":"#999")+"\" title=\"添加\">添加子类</a>");
			Response.Write("&nbsp;&nbsp;&nbsp;&nbsp;");
			Response.Write("<a href=\"javascript:;\" onclick=\"categEditorBox(event," + item.parent_id + "," + item.article_type_id + ")\" style=\"color:"+(item.type_state==0?"#00f":"#999")+"\" title=\"修改\">修改</a>");
			if (item.type_state==0){
				Response.Write("&nbsp;&nbsp;&nbsp;&nbsp;");
				Response.Write("<a href=\"javascript:;\" onclick=\"resetStatus(" + item.article_type_id  + ",1)\" style=\"color:green\" title=\"显示\">已显示</a>");
			}else{
				Response.Write("&nbsp;&nbsp;&nbsp;&nbsp;");
				Response.Write("<a href=\"javascript:;\" onclick=\"resetStatus(" + item.article_type_id  + ",0)\" style=\"color:#999\" title=\"隐藏\">已隐藏</a>");
			}
			Response.Write("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
			Response.Write("<a href=\"javascript:;\" onclick=\"deleteList(" + item.article_type_id + ")\" style=\"color:#999\" title=\"删除\">删除</a>");
			Response.Write("</p></div>");
			PrintList(item.article_type_id);
			Response.Write("</li>\r\n");
		}
		if (isHasChild) Response.Write("</ul>\r\n");
	}
</script>
<div id="class-list">
<%PrintList(0);%>
</div>
<br/><br/>
	</div>
</div>
<br/><br/>
<script type="text/javascript">
$(function(){
	_list = new _list_utils();
	_list.isopen=true;
	_list.opentree=9;
	_list.init(document.getElementById("class-list"));
});
function resetStatus(id, status){
	postData="id=" + id + "&status=" + status;
	$.ajax({
	    url: "/MArticle/ResetCategStatus"
		, data: postData
        , type: "post"
		, dataType: "json"
		, success: function(json){
			if(json.error){
				jsbox.error(json.message);return false;
			}else{
				window.location.href=window.location.href;
			}
		}
	});
	return false;
}
function deleteList(id){
	var postData="id=" + id;
	jsbox.confirm('您确定要删除这些分类吗？',function(){
		$.ajax({
		    url: "/MArticle/DeleteCategList"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function(json){
				if(json.error){
					jsbox.error(json.message);return false;
				}else{
					window.location.href=window.location.href;
				}
			}
		});
	});
	return false;
}
</script>
<%Html.RenderPartial("MArticle/CategEditorControl"); %>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>
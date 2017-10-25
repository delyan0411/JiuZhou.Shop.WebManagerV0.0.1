<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %><%@ Import Namespace="JiuZhou.Cache" %>
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
		<div class="editor-box-head">
商品分类&nbsp;&nbsp;&nbsp;&nbsp;
<a href="javascript:;" onclick="categEditorBox(event,0,0)" style="color:#00F">添加根类</a>
		</div>
<script language="c#" runat="server">
    List<TypeList> tList = GetTypeListAll.Do(-1).Body.type_list;
 
	int tree=0;
	public void PrintList(int parentId){
		if (parentId < 0) return;
        if (tList == null)
            tList = new List<TypeList>();
        List<TypeList> items = tList.FindAll(
            delegate(TypeList em)
            {
				return em.parent_type_id==parentId;
		});
        if (items.Count <= 0) return;
        bool isHasChild = false;
        Response.Write("<ul>");
		isHasChild = true;
        foreach (TypeList item in items)
        {
			string[] arr=item.product_type_path.Split(',');
			tree=arr.Length;
            bool isRemove = (item.is_visible.GetHashCode() != 1);
			Response.Write("<li" + (isRemove ? " class=\"delete\"" : "") + ">");
			Response.Write("<div tree=\"" + tree + "\"><a href=\"javascript:;\" v=\"bt\" class='jslk'>&nbsp;</a>");
			Response.Write("<a href=\"javascript:;\" v=\"bt\" class=\"name\">" + item.type_name + "(" + item.sort_no + ")</a>");

			Response.Write("<p class=\"b-list\" style=\"left:"+ (320 + (tree-1) * 18) +"px\">");
            if (tree < 5)
            {
                Response.Write("<a href=\"javascript:;\" onclick=\"categEditorBox(event," + item.product_type_id + ", 0)\"  class=\"add\" title=\"添加\">添加子类</a>");
                Response.Write("&nbsp;&nbsp;&nbsp;&nbsp;");
            }
			Response.Write("<a href=\"javascript:;\" onclick=\"categEditorBox(event," + item.parent_type_id + "," + item.product_type_id + ")\" class=\"editor\" title=\"修改\">修改</a>");
			if (!isRemove){
				Response.Write("&nbsp;&nbsp;&nbsp;&nbsp;");
				Response.Write("<a href=\"javascript:;\" onclick=\"resetStatus(this)\" \" nid=\"" + item.product_type_id + "\" status=\"0\" class=\"status\" title=\"显示\">已显示</a>");
			}else{
				Response.Write("&nbsp;&nbsp;&nbsp;&nbsp;");
                Response.Write("<a href=\"javascript:;\" onclick=\"resetStatus(this)\" \" nid=\"" + item.product_type_id + "\" status=\"1\" class=\"status\" title=\"显示\">已隐藏</a>");
			}
			Response.Write("</p></div>");
			PrintList(item.product_type_id);
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
function resetStatus(obj) {
    postData = "id=" + parseInt($(obj).attr("nid")) + "&status=" + parseInt($(obj).attr("status"));
    var currStatus = parseInt($(obj).attr("status"));
	$.ajax({
	    url: "/MGoods/ResetCategStatus"
        , type: "post"
		, data: postData
		, dataType: "json"
		, success: function (json, textStatus) {
                if (currStatus == 1) {
                        $(obj).parent("p").parent("div").parent("li").removeClass("delete");
                        $(obj).attr("status", "0").attr("title", "点击禁用").html("已显示");
              } else {
                        $(obj).parent("p").parent("div").parent("li").addClass("delete");
                        $(obj).attr("status", "1").attr("title", "点击启用").html("已隐藏");
                 }
		}
        , error: function (http, textStatus, errorThrown) {
           
        }
	});
	return false;
}
</script>
<%Html.RenderPartial("Base/_PageFootControl"); %>
<%Html.RenderPartial("MGoods/CategEditorControl"); %>
<%Html.RenderPartial("UploadBaseControl"); %>
<%Html.RenderPartial("ImageListBoxControl");//图片选择 %>
</body>
</html>

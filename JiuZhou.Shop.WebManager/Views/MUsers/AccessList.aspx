<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %><%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.MySql" %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
    %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%Html.RenderPartial("Base/_PageHeadControl"); %>
<title><%=ViewData["pageTitle"]%></title>
</head>
<body>
<%Html.RenderPartial("Base/_SimplePageTopControl"); %>
<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
		<div class="syscp-head">
<%=ViewData["position"]%>
&nbsp;&nbsp;&nbsp;&nbsp;
<a href="javascript:void();" onclick="nodeEditorBox(0,0)" style="color:#00F">添加顶级菜单</a>
		</div>
<script language="c#" runat="server">
    
    List<AccessInfo> sysNodes = QueryAccessList.Do().Body.access_list;
    
	int tree=0;
	public void PrintList(int parentId){
		if (parentId < 0) return;
        if (sysNodes == null)
            sysNodes = new List<AccessInfo>();
        List<AccessInfo> items = sysNodes.FindAll(delegate(AccessInfo item) { return item.parent_id == parentId; });
        if (items.Count <= 0) return;
        bool isHasChild = false;
        Response.Write("<ul>");
		isHasChild = true;
        foreach (AccessInfo item in items)
        {
			string[] arr=item.access_path.Split(',');
			tree=arr.Length - 1;
			Response.Write("<li>");
			Response.Write("<div tree=\"" + tree + "\"><a href=\"javascript:;\" v=\"bt\" class='jslk'>&nbsp;</a>");
			Response.Write("<a href=\"javascript:;\" v=\"bt\" node=\"" + item.access_id + "-name\" class=\"name\">" + item.access_name + "</a> <span node=\"" + item.access_id + "-sort\" style=\"color:#999\">(" + item.sort_no + ")</span>");

			Response.Write("<p class=\"b-list\" style=\"left:"+ (560 - (tree-1) * 18) +"px\">");
			if(tree<5){
				Response.Write("<a href=\"javascript:;\" onclick=\"nodeEditorBox(" + item.access_id + ", 0)\" class=\"add\" title=\"添加\">添加子菜单</a>");
                Response.Write("&nbsp;<a href=\"/musers/AccessResource?accessid=" + item.access_id + "\" target=\"_blank\">查看资源</a>");
				Response.Write("&nbsp;&nbsp;");
			}
			Response.Write("<a href=\"javascript:;\" onclick=\"nodeEditorBox(" + item.parent_id + "," + item.access_id + ")\" class=\"editor\" title=\"修改\">修改</a>");
            Response.Write("&nbsp;<a href=\"javascript:;\" onclick=\"deleteAccess(" + item.access_id + ")\" class=\"editor\" title=\"删除\">删除</a>");
		
			Response.Write("</p></div>");
			PrintList(item.access_id);
			Response.Write("</li>\r\n");
		}
		if (isHasChild) Response.Write("</ul>\r\n");
	}
</script>
<div id="class-list">
<%PrintList(0);%>
</div>
	</div>
	<div class="clear">&nbsp;</div><br/><br/>
</div>
<div class="clear">&nbsp;</div>
<div id="node-editor" class="dialog-box">
	<div class="atai-shade-head" v="atai-shade-move">
		权限设置
		<div class="atai-shade-close" v="atai-shade-close">&nbsp;</div>
	</div>
<form action="" onsubmit="return submitNodeData(this)" method="post">
<input type="hidden" value="" v="atai-shade-close" />
	<div class="atai-shade-contents">
<input type="hidden" name="parentId" value="0"/>
<input type="hidden" name="nodeId" value="0"/>
<table class="table" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="2" style="height:42px"><div class="tips-text" vt="tips-text" style="margin-top:5px">&nbsp;</div></td>
  </tr>
  <tr>
    <td class="lable" style="height:36px;">上级菜单</td>
    <td><input type="text" name="parentNode" class="input" value="" style="width:230px" disabled="disabled"/>
    排序
    <input type="text" name="sort" class="input" style="width:50px;text-align:center" onclick="this.select()" value="0"/>
    </td>
  </tr>
  <tr>
    <td class="lable" style="height:36px;">名称</td>
    <td><input type="text" name="name" class="input" value=""/></td>
  </tr>
  <tr>
    <td class="lable" style="height:36px;">描述</td>
    <td><textarea name="desc" style="width:300px;height:50px;"></textarea></td>
  </tr>
</table>

	</div>
	<div class="atai-shade-clear"></div>
	<div class="atai-shade-bottom" v="atai-shade-move">
		<input type="button" class="atai-shade-cancel" v="atai-shade-cancel" value="取消"/>
		<input type="submit" class="atai-shade-confirm" value="保存"/>
	</div>
</form>
</div>
<script type="text/javascript">
    $(function () {
        _list = new _list_utils();
        _list.isopen = true;
        _list.opentree = 3;
        _list.init(document.getElementById("class-list"));
    });
</script>
<script type="text/javascript">

    var _nodeEditorDialog = false;
    function nodeEditorBox(parentId, nodeId) {
        var objId = "#node-editor";
        var _dialog = new AtaiShadeDialog();
        _dialog.init({
            obj: objId
		, sure: function () { }
		, CWCOB: false
        });
        _nodeEditorDialog = _dialog;

        $(_dialog.dialog).find("input[name='parentId']").val(parentId);
        $(_dialog.dialog).find("input[name='nodeId']").val(nodeId);

        $.ajax({
            url: "/musers/GetAccess   "
		, type: "post"
		, data: { parentId: parentId, nodeId: nodeId }
		, dataType: "json"
		, success: function (json, textStatus) {
		    $(_dialog.dialog).find("input[name='parentNode']").val(json.parentName);
		    $(_dialog.dialog).find("input[name='sort']").val(json.type.sort_no);
		    $(_dialog.dialog).find("input[name='name']").val(json.type.access_name);
		    $(_dialog.dialog).find("textarea[name='desc']").val(json.type.access_desc);
		}, error: function (http, textStatus, errorThrown) {
		    jsbox.error(errorThrown);
		}
        });
        return false;
    }

    function closeDialog() {
        _nodeEditorDialog.close();
        _nodeEditorDialog = false;
    }

    function deleteAccess(id) {
        jsbox.confirm("你确定要删除该权限吗？", function () {
            $.ajax({
                url: "/musers/DeleteAccessInfo"
		    , type: "post"
		    , data: { "accessId": id }
		    , dataType: "json"
		    , success: function (json, textStatus) {
		        if (json.error) {
		            jsbox.error(json.message);
		        } else {
		            jsbox.success(json.message, window.location.href);
		        }
		    }, error: function (http, textStatus, errorThrown) {
		        jsbox.error(errorThrown);
		    }
            });
            return false;
        });
    }

    function submitNodeData(form) {
        var o = $(form).find("div[vt='tips-text']");
        $(form).find("input[type='text']").click(function () { o.removeClass("tips-icon").html(''); });
        var postData = getPostDB(form);
        $.ajax({
            url: "/musers/PostAccessData"
		, type: "post"
		, data: postData
		, dataType: "json"
		, success: function (json, textStatus) {
		    if (json.error) {
		        o.addClass("tips-icon");
		        o.html(json.message);
		    } else {
		        o.removeClass("tips-icon");
		        if (json.isadd) {
		            window.location.href = window.location.href;
		        } else {
		            o.html(json.message);
		        }
		    }
		}, error: function (http, textStatus, errorThrown) {
		    jsbox.error("error");
		}
        });
        return false;
    }
</script>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>

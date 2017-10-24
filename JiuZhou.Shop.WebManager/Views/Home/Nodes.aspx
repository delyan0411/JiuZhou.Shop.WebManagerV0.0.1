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
    
    List<UserResBody> sysNodes = QueryResource.Do(0, -1).Body.resource_list;
    
	int tree=0;
	public void PrintList(int parentId){
		if (parentId < 0) return;
        if (sysNodes == null)
            sysNodes = new List<UserResBody>();
        List<UserResBody> items = sysNodes.FindAll(delegate(UserResBody item) { return item.parent_id == parentId; });
        if (items.Count <= 0) return;
        bool isHasChild = false;
        Response.Write("<ul>");
		isHasChild = true;
        foreach (UserResBody item in items)
        {
			string[] arr=item.res_path.Split(',');
			tree=arr.Length - 1;
			bool isRemove=(item.res_state.GetHashCode()!=0);
			Response.Write("<li"+(isRemove?" class=\"delete\"":"")+">");
			Response.Write("<div tree=\"" + tree + "\"><a href=\"javascript:;\" v=\"bt\" class='jslk'>&nbsp;</a>");
			Response.Write("<a href=\"javascript:;\" v=\"bt\" node=\"" + item.res_id + "-name\" class=\"name\">" + item.res_name + "</a> <span node=\"" + item.res_id + "-sort\" style=\"color:#999\">(" + item.sort_no + ")</span>");

			Response.Write("<p class=\"b-list\" style=\"left:"+ (560 - (tree-1) * 18) +"px\">");
			if(tree<5 && item.res_type==1){
				Response.Write("<a href=\"javascript:;\" onclick=\"nodeEditorBox(" + item.res_id + ", 0)\" class=\"add\" title=\"添加\">添加子菜单</a>");
				Response.Write("&nbsp;&nbsp;&nbsp;&nbsp;");
			}
			Response.Write("<a href=\"javascript:;\" onclick=\"nodeEditorBox(" + item.parent_id + "," + item.res_id + ")\" class=\"editor\" title=\"修改\">修改</a>");
			if (!isRemove){
				Response.Write("&nbsp;&nbsp;&nbsp;&nbsp;");
				Response.Write("<a href=\"javascript:;\" onclick=\"resetStatus(this)\" node=\"" + item.res_id  + "\" status=\"1\" class=\"status\" title=\"点击禁用\">已启用</a>");
			}else{
				Response.Write("&nbsp;&nbsp;&nbsp;&nbsp;");
				Response.Write("<a href=\"javascript:;\" onclick=\"resetStatus(this)\" node=\"" + item.res_id  + "\" status=\"0\" class=\"status\" title=\"点击启用\">已禁用</a>");
			}
			Response.Write("</p></div>");
			PrintList(item.res_id);
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
		菜单设置
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
    <td class="lable" style="height:36px;">类型</td>
    <td>
      <select id="restype" name="restype" style="height:28px;">
        <option value="1" selected="selected">菜单</option>
        <option value="2">菜单项</option>
        <option value="3">按钮</option>
        <option value="4">接口</option>
      </select>
      &nbsp;编码
      <input type="text" name="rescode" class="input" style="width:100px;text-align:center" value=""/>
    </td>
  </tr>
  <tr>
    <td class="lable" style="height:36px;">URL</td>
    <td><input type="text" name="url" class="input" value=""/></td>
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
    function resetStatus(obj) {
        var currStatus = parseInt($(obj).attr("status"));
        $.ajax({
            url: "/Home/ResetNodeStatus"
		, type: "post"
		, data: { id: $(obj).attr("node"), status: currStatus }
		, dataType: "json"
		, success: function (json, textStatus) {
		    if (currStatus == 0) {
		        $(obj).parent("p").parent("div").parent("li").removeClass("delete");
		        $(obj).attr("status", "1").attr("title", "点击禁用").html("已启用");
		    } else {
		        $(obj).parent("p").parent("div").parent("li").addClass("delete");
		        $(obj).attr("status", "0").attr("title", "点击启用").html("已禁用");
		    }
		}, error: function (http, textStatus, errorThrown) {
		    //jsbox.error("error");
		}
        });
        return false;
    }
    var _nodeEditorDialog = false;
    function nodeEditorBox(parentId, nodeId) {
        var objId = "#node-editor";
        $(objId).find("input[name='parentId']").val(parentId);
        $(objId).find("input[name='nodeId']").val(nodeId);

        $.ajax({
            url: "/Home/GetNode"
		, type: "post"
		, async: false
		, data: { parentId: parentId, nodeId: nodeId }
		, dataType: "json"
		, success: function (json, textStatus) {
		    $(objId).find("input[name='parentNode']").val(json.parentName);
		    $(objId).find("input[name='sort']").val(json.type.sort_no);
		    $(objId).find("input[name='name']").val(json.type.res_name);
		    $(objId).find("input[name='url']").val(json.type.res_src);
		    $(objId).find("#restype [value='" + json.type.res_type + "']").attr("selected", true);
		    $(objId).find("input[name='rescode']").val(json.type.res_code);
		}, error: function (http, textStatus, errorThrown) {
		    jsbox.error(errorThrown);
		}
        });

        var _dialog = new AtaiShadeDialog();
        _dialog.init({
            obj: objId
		, sure: function () { }
		, CWCOB: false
        });
        _nodeEditorDialog = _dialog;
    }
    function closeDialog() {
        _nodeEditorDialog.close();
        _nodeEditorDialog = false;
    }
    function submitNodeData(form) {
        var o = $(form).find("div[vt='tips-text']");
        $(form).find("input[type='text']").click(function () { o.removeClass("tips-icon").html(''); });
        var postData = getPostDB(form);
        $.ajax({
            url: "/Home/PostNodeData"
		, type: "post"
		, data: postData
		, dataType: "json"
		, success: function (json, textStatus) {
		    if (json.error) {
		        o.addClass("tips-icon");
		        o.html(json.message);
		    } else {
		        $(_nodeEditorDialog.dialog).find("a[node='" + postData.nodeId + "-name']").html(postData.name);
		        $(_nodeEditorDialog.dialog).find("span[node='" + postData.nodeId + "-sort']").html("(" + postData.sort + ")");
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

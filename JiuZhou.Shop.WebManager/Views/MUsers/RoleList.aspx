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
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>角色列表</span>
</div>

<%
    List<RoleInfo> infoList = (List<RoleInfo>)(ViewData["infoList"]);
%>
		<div class="div-tab">
<table class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:6%">角色ID</th>
    <th style="width:10%">角色名</th>
    <th>描述</th>
    <th style="width:8%">角色类别</th>
    <th style="width:14%">增加时间</th>
    <th style="width:14%">操作</th>
  </tr>
</thead>
<tbody>
<%
    foreach (RoleInfo item in infoList)
    {
%>
  <tr>
    <td><%=item.role_id%></td>
    <td><%=item.role_name%></td>
    <td><%=item.role_desc%></td>
    <% 
        string _type = "";
        if (item.role_type == 1)
        {
            _type = "操作员";
        }
        else {
            _type = "普通用户";
        }
         %>
    <td><%=_type%></td>
    <td><%=DateTime.Parse(item.add_time).ToString("yyyy-MM-dd HH:mm:ss") %></td>
    <td>
    <a href="/musers/RoleAccess?roleid=<%=item.role_id%>" target="_blank">查看权限</a>
    <a href="javascript:;" onclick="EditorRole(<%=item.role_id %>)">修改</a>
    <a href="javascript:;" onclick="deleteRole(<%=item.role_id %>)">删除</a>
    </td>
  </tr>
<%
	}
%>
  </tbody>
</table>
<div class="console">
            	<a href="javascript:;" onclick="EditorRole(0)">新增角色</a>
			</div>
		</div>
	</div>
</div>
<br/><br/>

<div id="roleEditor-boxControl" class="moveBox" style="height:320px;width:520px;">
	<div class="name">
		角色编辑
		<div class="close" v="atai-shade-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<form action="" onsubmit="return postRole(this)">
<input type="hidden" id="role-id" name="roleid" value=""/>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="left">&nbsp;</td>
    <td><span class="tips-text" style="color:#ff6600">&nbsp;</span></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">角色名： </td>
    <td><input type="text" id="role-name" name="rolename" class="input" value="" /></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">描&nbsp;述： </td>
    <td><textarea id="role-desc" name="roledesc"></textarea></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;" valign="top">类&nbsp;别： </td>
    <td>
        操作员 <input type="checkbox" name="roletype" value="1" onclick="checkedthis(this)"/>&nbsp;
        普通用户 <input type="checkbox" name="roletype" value="2" onclick="checkedthis(this)" />&nbsp;
        第三方管理员 <input type="checkbox" name="roletype" value="3" onclick="checkedthis(this)" />
    </td>
  </tr>
  <tr>
    <td class="left" style="height:30px;">&nbsp;</td>
    <td><input type="submit" class="submit" value="  保 存  " /></td>
  </tr>
</table>
</form>
</div>

<script type="text/javascript">
    function deleteRole(id) {
        jsbox.confirm("确定删除此角色？", function () {
            $.ajax({
                url: "/musers/DeleteRoleInfo"
			, data: { "id": id }
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
        });
        return false;
    }

    var _roleEditorBoxDialog = false;
    function EditorRole(id) {

        var boxId = "#roleEditor-boxControl";
        var box = Atai.$(boxId);
        var _dialog = false;
        if (!_dialog)
            _dialog = new AtaiShadeDialog();
        _dialog.init({
            obj: boxId
		    , sure: function () { }
		    , CWCOB: false
        });
        _roleEditorBoxDialog = _dialog;
        if (id == 0)
            $(_roleEditorBoxDialog.dialog).find("input[name='roletype']").each(function () {
                if ($(this).val() == 2)
                    $(this).attr("checked", true);
            });

        $.ajax({
            url: "/musers/GetRole"
			, data: { "id": id }
            , type: "post"
			, dataType: "json"
			, success: function (json, textStatus) {
			    if (json.error) {
			        $(_roleEditorBoxDialog.dialog).find("span[class='tips-text']").html(json.message);
			    } else {
			        $(_roleEditorBoxDialog.dialog).find("input[name='roleid']").val(json.role.role_id);
			        $(_roleEditorBoxDialog.dialog).find("input[name='rolename']").val(json.role.role_name);
			        $(_roleEditorBoxDialog.dialog).find("textarea[name='roledesc']").val(json.role.role_desc);
			        
			        $(_roleEditorBoxDialog.dialog).find("input[name='roletype']").each(function () {
			            if ($(this).val() == json.role.role_type)
			                $(this).attr("checked", true);
                        if (json.role.role_type == 0 && $(this).val()==2)
                            $(this).attr("checked", true);
			        });
			    }
			}
        });
        return false;
    }

    function postRole(form) {
        var postDate = getPostDB(form);
        $.ajax({
            url: "/Musers/PostRole"
		, data: postDate
        , type: "post"
		, dataType: "json"
		, success: function (json) {
		    if (json.error) {
		        $(_roleEditorBoxDialog.dialog).find("span[class='tips-text']").html(json.message);
		    } else {
		        jsbox.success(json.message, window.location.href);
		    }
		    if (closeLoadding) closeLoadding();
		}
        });
        return false;
    }

    function checkedthis(obj) {
        if (obj.checked) {
            $(obj).attr("checked", true);
            $("input[name='roletype']").each(function () {
                if (this != obj)
                    $(this).attr("checked", false);
            });
        } else {
            $(obj).attr("checked", false);
            $("input[name='roletype']").each(function () {
                if (this != obj)
                    $(this).attr("checked", true);
            });
        }
    }
</script>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body></html>
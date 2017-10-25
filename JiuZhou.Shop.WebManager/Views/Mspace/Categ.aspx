<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/style/style.css" rel="stylesheet" type="text/css" />
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

		</div>

<script language="c#" runat="server">   
    List<PicTypeList> sysNodes = GetSysFileType.Do(-1).Body.type_list; 
    
	int tree=0;
	public void PrintList(string parentCode){
        if (sysNodes == null)
            sysNodes = new List<PicTypeList>();
        if (parentCode.Equals("")) return;
        List<PicTypeList> items = sysNodes.FindAll(delegate(PicTypeList item) { return item.parent_code.Equals(parentCode); });
        if (items == null)
            items = new List<PicTypeList>();
        if (items.Count <= 0) return;
		//tree++;
        bool isHasChild = false;
        Response.Write("<ul>");
		isHasChild = true;
        foreach (PicTypeList item in items)
        {
			string[] arr=item.type_path.Split(',');
			tree=arr.Length;
			bool isRemove=(item.sp_type_state.GetHashCode()!=0);
			Response.Write("<li"+(isRemove?" class=\"delete\"":"")+">");
			Response.Write("<div tree=\"" + tree + "\"><a href=\"javascript:;\" v=\"bt\" class='jslk'>&nbsp;</a>");
			Response.Write("<a href=\"javascript:;\" v=\"bt\" node=\"" + item.sp_type_id + "-name\" class=\"name\">" + item.sp_type_name + "</a> <span node=\"" + item.sp_type_id + "-sort\" style=\"color:#999\">(" + item.sort_no + ")</span>");

			Response.Write("<p class=\"b-list\" style=\"left:"+ (560 - (tree-1) * 18) +"px\">");
            if (tree < 4)
            {
                Response.Write("<a href=\"javascript:;\" onclick=\"classEditorBox(\'" + item.type_code + "\', 0)\" class=\"add\" title=\"添加\">添加子分类</a>");
                Response.Write("&nbsp;&nbsp;&nbsp;&nbsp;");
            }
            if (!item.parent_code.Equals("0"))
            {
                Response.Write("<a href=\"javascript:;\" onclick=\"classEditorBox(\'" + item.parent_code + "\',\'" + item.type_code + "\')\" class=\"editor\" title=\"修改\">修改</a>");
            }
			if (!isRemove){
				Response.Write("&nbsp;&nbsp;&nbsp;&nbsp;");
				Response.Write("<a href=\"javascript:;\" onclick=\"resetStatus(this)\" node=\"" + item.sp_type_id  + "\" status=\"0\" class=\"status\" title=\"点击禁用\">已启用</a>");
			}else{
				Response.Write("&nbsp;&nbsp;&nbsp;&nbsp;");
				Response.Write("<a href=\"javascript:;\" onclick=\"resetStatus(this)\" node=\"" + item.sp_type_id  + "\" status=\"1\" class=\"status\" title=\"点击启用\">已删除</a>");
			}
			Response.Write("</p></div>");
			PrintList(item.type_code);
			Response.Write("</li>\r\n");
		}
		if (isHasChild) Response.Write("</ul>\r\n");
	}
</script>
<div id="class-list">
<%PrintList("0");%>
</div>
	</div>
	<div class="clear">&nbsp;</div><br/><br/>
</div>
<div class="clear">&nbsp;</div>
<div id="class-editor" class="dialog-box" style="height:290px">
	<div class="atai-shade-head" v="atai-shade-move">
		分类设置
		<div class="atai-shade-close" v="atai-shade-close">&nbsp;</div>
	</div>
<form action="" onsubmit="return submitClassData(this)" method="post">
<input type="hidden" value="" v="atai-shade-close" />
	<div class="atai-shade-contents">
<input type="hidden" name="parentCode" value="0"/>
<input type="hidden" name="typeId" value="0"/>
<table class="table" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="2" style="height:42px"><div class="tips-text" vt="tips-text" style="margin-top:5px">&nbsp;</div></td>
  </tr>
  <tr>
    <td class="lable" style="height:36px;">上级分类</td>
    <td><input type="text" name="parentNode" class="input" value="" style="width:230px" disabled="disabled"/>
    排序
    <input type="text" name="sort" class="input" style="width:50px;text-align:center" onclick="this.select()" value="0"/>
    </td>
  </tr>
  <tr>
    <td class="lable" style="height:36px;">名称</td>
    <td>
      <input type="text" name="name" class="input" value="" style="width:230px"/>
      <input type="checkbox" name="isSys" value="1"/> 是否系统内置
    </td>
  </tr>
  <tr>
    <td class="lable" style="height:36px;">编码</td>
    <td><input type="text" name="code" class="input" value="" style="width:160px"/> <span v="span"></span></td>
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
        var currStatus = parseInt($(obj).attr("status"))==0?1:0;
        $.ajax({
            url: "/MSpace/ResetSysFileStatus"
		, type: "post"
		, data: { id: $(obj).attr("node"), status: currStatus }
		, dataType: "json"
		, success: function (json) {
		    if (currStatus == 0) {
		        $(obj).parent("p").parent("div").parent("li").removeClass("delete");
		        $(obj).attr("status", "0").attr("title", "点击删除").html("已启用");
		    } else {
		        $(obj).parent("p").parent("div").parent("li").addClass("delete");
		        $(obj).attr("status", "1").attr("title", "点击启用").html("已删除");
		    }
		}, error: function (http, textStatus, errorThrown) {
		    //jsbox.error("error");
		}
        });
        return false;
    }
    var _classEditorDialog = false;
    
    

    function classEditorBox(parentCode, code) {
        var objId = "#class-editor";
        var _dialog = new AtaiShadeDialog();
        _dialog.init({
            obj: objId
		, sure: function () { }
		, CWCOB: true
        });
        _classEditorDialog = _dialog; 

        $.ajax({
            url: "/Mspace/GetClass"
		, type: "post"
		, async: false
		, data: { parentCode: parentCode, Code: code }
		, dataType: "json"
		, success: function (json, textStatus) {
		    if (json.error) {
		        jsbox.error(json.message);
		    } else {
		        $(_classEditorDialog.dialog).find("input[name='parentCode']").val(json.type.parent_code);
		        $(_classEditorDialog.dialog).find("input[name='typeId']").val(json.type.sp_type_id);
		        $(_classEditorDialog.dialog).find("input[name='parentNode']").val(json.parentName);
		        $(_classEditorDialog.dialog).find("input[name='sort']").val(json.type.sort_no);
		        $(_classEditorDialog.dialog).find("input[name='name']").val(json.type.sp_type_name);
		        $(_classEditorDialog.dialog).find("input[name='code']").val(json.type.type_code);
		        $(_classEditorDialog.dialog).find("input[name='isSys']").attr("checked", json.type.is_sys==1);
		        if (json.type.is_sys==1) {
		            $(_classEditorDialog.dialog).find("input[name='code']").attr("readonly", true);
		            $(_classEditorDialog.dialog).find("span[v='span']").html("内置分类,不可改编码");
		        } else {
		            $(_classEditorDialog.dialog).find("span[v='span']").html('');
		        }
		    }
		}, error: function (http, textStatus, errorThrown) {
		    jsbox.error(errorThrown);
		}
        });

    }
    function closeDialog() {
        _classEditorDialog.close(); _classEditorDialog = false;
    }
    function submitClassData(form) {
        var o = $(_classEditorDialog.dialog).find("div[vt='tips-text']");
        $(form).find("input[type='text']").click(function () { o.removeClass("tips-icon").html(''); });
        var postData = getPostDB(form);
        $.ajax({
            url: "/MSpace/PostSysFileCategData"
		, type: "post"
		, data: postData
		, dataType: "json"
		, success: function (json, textStatus) {
		    if (json.error) {
		        o.addClass("tips-icon");
		        o.html(json.message);
		    } else {
		        $("a[node='" + postData.classId + "-name']").html(postData.name);
		        $("span[node='" + postData.classId + "-sort']").html("(" + postData.sort + " / " + postData.code + ")");
		        o.removeClass("tips-icon");
		        if (json.isadd)
		            window.location.href = window.location.href;
		        closeDialog();
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
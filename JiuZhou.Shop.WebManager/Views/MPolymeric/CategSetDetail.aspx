<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
    int toptypeid = DoRequest.GetQueryInt("id");
    CategSetInfo toptype = new CategSetInfo();
    var restop = GetHomeTypeById.Do(toptypeid);
    if (restop != null && restop.Body != null)
        toptype = restop.Body;
    %>
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
    <div id="container-syscp">
    	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
        <div class="position">
            当前位置： <a href="/" title="管理首页">管理首页</a> &gt;&gt; <a href="/mpolymeric/CategSetDetail">
                分类菜单设置详情(<%=toptype.type_name%>)</a>
                 &nbsp;&nbsp;&nbsp;&nbsp;
<a href="javascript:void();" onclick="AddCateg(<%=toptypeid %>,0,1)" style="color:#00F">添加顶级分类</a>
        </div>
        <table class="table" cellpadding="0" cellspacing="0">
            <thead>
                <tr>
                    <th style="width: 2%">
                        ID
                    </th>
                    <th style="width: 14%">
                        类目
                    </th>
                    <th>
                       子类目
                    </th>
                    <th style="width: 6%">
                        位置
                    </th>
                    <th style="width: 16%">
                        操作
                    </th>
                    <th style="width: 1%">
                        &nbsp;
                    </th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<CategSetInfo> infoList = GetHomePageType.Do().Body.type_list;
                    foreach (CategSetInfo item in infoList.Where(t => t.parent_id == toptypeid && t.pos_type > 0).ToList())
                    {
                %>
                <tr>
                    <td>
                        <%=item.home_pt_id%>
                    </td>
                    <td>
                    <%
                        string position = "";
                        if (item.pos_type == 1)
                            position = " (左边)";
                        if (item.pos_type == 2)
                            position = " (右边)";
                         %>
                        <a href="<%=config.UrlHome + item.type_url%>">
                            <%=item.type_name + position%></a>
                    </td>
                    <td>
                        <%
                            foreach (CategSetInfo citem in infoList.Where(t => t.parent_id == item.home_pt_id).ToList())
                        {
                            Response.Write(citem.type_name + "<a href=\"javascript:;\" onclick=\"EditCateg('" + citem.home_pt_id + "','0')\"> 修改</a><a href=\"javascript:;\" onclick=\"DelCateg('" + citem.home_pt_id + "')\"> 删除</a>&nbsp;&nbsp;");
                        }
                     //   Response.Write("<a href=\"javascript:;\" onclick=\"AddCateg('" + item.home_pt_id + "','0')\">添加</a>&nbsp;&nbsp;&nbsp;&nbsp;");
                        %>
                    </td>
                    <td>
                        <%=item.sort_no%>
                    </td>
                    <td>
                              <a href="javascript:;" onclick="AddCateg('<%=item.home_pt_id%>','0','0')">添加子类</a>   
                        &nbsp;<a href="javascript:;" onclick="EditCateg('<%=item.home_pt_id%>','1')">修改</a> 
                        &nbsp;<a href="javascript:;" onclick="DelCateg('<%=item.home_pt_id%>')">删除</a>
                    </td>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
    </div>
    <script type="text/javascript">

        var _EditCategBoxDialog = false;

        function AddCateg(pid, tid, flag) {
            var boxId = "#EditCateg-boxControl";
            var box = Atai.$(boxId);
            var _dialog = new AtaiShadeDialog();
            _dialog.init({
                obj: boxId
		      , sure: function () { }
		      , CWCOB: false
            });
            _EditCategBoxDialog = _dialog;
            if (flag == "0") {
                $(_EditCategBoxDialog.dialog).find("tr[name='position']").hide();
            } else {
            $(_EditCategBoxDialog.dialog).find("input[name='position1']").each(function () {
                if ($(this).val() == "1")
                    $(this).prop("checked", true);
            });
            }
            $(_EditCategBoxDialog.dialog).find("input[name='name']").val('');
            $(_EditCategBoxDialog.dialog).find("input[name='url']").val('');
            //$("#seq").val('');
            $(_EditCategBoxDialog.dialog).find("input[name='posid']").val(tid);
            $(_EditCategBoxDialog.dialog).find("input[name='pid']").val(pid);
           // $("input[name='pid']").val(tid);
            $(_EditCategBoxDialog.dialog).find("input[name='Isb']").prop("checked", false);
            $(_EditCategBoxDialog.dialog).find("input[name='Iscolor']").prop("checked", false);
            $(_EditCategBoxDialog.dialog).find("input[name='IsBr']").prop("checked", false);
           
            return false;
        }

        function DelCateg(id) {
            jsbox.confirm("确定要删除吗？删除将不能恢复！", function () {
                $.ajax({
                    url: "/MPolymeric/DelCategSet"
        //, async: false
		, type: "post"
		, data: {
		    "ID": id
		}
		, dataType: "json"
		, success: function (json) {
		    if (!json.error) {
		        window.location.href = window.location.href;
		    }
		    else {
		        jsbox.error("删除失败!");
		    }
		}
                });
            });
        }

        function EditCateg(id,flag) {
            var boxId = "#EditCateg-boxControl";
            var box = Atai.$(boxId);
            var _dialog = new AtaiShadeDialog();
            _dialog.init({
                obj: boxId
		      , sure: function () { }
		      , CWCOB: false
            });
            _EditCategBoxDialog = _dialog;
            if (flag == "0") {
                $(_EditCategBoxDialog.dialog).find("tr[name='position']").hide();
            }
            $.ajax({
                url: "/MPolymeric/GetCategSet"
        //, async: false
		, type: "post"
		, data: {
		    "ID": id
		}
		, dataType: "json"
		, success: function (json) {
		    $(_EditCategBoxDialog.dialog).find("input[name='name']").val(json.categ.type_name);
		    $(_EditCategBoxDialog.dialog).find("input[name='url']").val(json.categ.type_url);
		    //$("#seq").val('');
		    $(_EditCategBoxDialog.dialog).find("input[name='posid']").val(json.categ.home_pt_id);
		    $(_EditCategBoxDialog.dialog).find("input[name='pid']").val(json.categ.parent_id);
		    $(_EditCategBoxDialog.dialog).find("input[name='sort']").val(json.categ.sort_no);
		    if (json.categ.is_black == 1)
		        $(_EditCategBoxDialog.dialog).find("input[name='Isb']").prop("checked", true);
		    else
		        $(_EditCategBoxDialog.dialog).find("input[name='Isb']").prop("checked", false);
		    if (json.categ.is_color == 1)
		        $(_EditCategBoxDialog.dialog).find("input[name='Iscolor']").prop("checked", true);
		    else
		        $(_EditCategBoxDialog.dialog).find("input[name='Iscolor']").prop("checked", false);
		    if (json.categ.is_newline == 1)
		        $(_EditCategBoxDialog.dialog).find("input[name='IsBr']").prop("checked", true);
		    else
		        $(_EditCategBoxDialog.dialog).find("input[name='IsBr']").prop("checked", false);

		    $(_EditCategBoxDialog.dialog).find("input[name='position1']").each(function () {
		        if ($(this).val() == json.categ.pos_type)
		            $(this).prop("checked", true);
		    });
		}
            });
          
            return false;
        }

        function postRecommendPageBox(form) {
            var postDate = getPostDB(form);
            $.ajax({
                url: "/MPolymeric/PostHomeType"
		, data: postDate
        , type: "post"
		, dataType: "json"
		, success: function (json) {
		    if (json.error) {
		        $(_EditCategBoxDialog.dialog).find("span[class='tips-text']").html(json.message);
		    } else {
		        jsbox.success(json.message, window.location.href);
		        // _resetMobileBoxDialog.close();
		        //jsbox.error($("span[name='phone']").val());
		        // $("span[name='phone']").html(json.mobile);
		    }
		    if (closeLoadding) closeLoadding();
		}
            });
            return false;
        }

        function checkedthis(obj) {
            if (obj.checked) {
                $(obj).attr("checked", true);
                $("input[name='position1']").each(function () {
                    if (this != obj)
                        $(this).attr("checked", false);
                });
            } else {
                $(obj).attr("checked", false);
                $("input[name='position1']").each(function () {
                    if (this != obj)
                        $(this).attr("checked", true);
                });
            }
        }
    </script>
    <%Html.RenderPartial("MPolymeric/EditCateg2"); %>
    <%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>
<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.ControllerBase" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
    UserInfo Info = (UserInfo)ViewData["userinfo"];
    bool _isallow = false;
    _isallow = ForeSysBaseController.HasPermission2(122);
  
	//UGroupInfo ugroup=UGroupDB.GetInfo(Info.GroupID);//获取用户组
	//USysGroupInfo sgroup=USysGroupDB.GetInfo(Info.SysGroupID);//获取管理组
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
<%=ViewData["position"]%> &gt;&gt; <span>查看用户信息</span>
		</div>
		<table class="att-items" style="width:100%" cellspacing="0" cellpadding="0">
           <thead>
              <tr>
                 <th colspan="4">基础信息
                 </th>
              </tr>
           </thead>
           <tbody>
              <tr>
                 <td rowspan="3" style="width:10%;"><img style="width:120px;height:120px;" src="<%=(Info.head_thumb==null || Info.head_thumb=="")?FormatImagesUrl.GetProductImageUrl(config.UrlManager+"/images/uface.jpg", -1, -1):FormatImagesUrl.GetProductImageUrl(Info.head_thumb, 120, 120)%>"  alt=""/></td>
                 <td style="width:20%">账号：<%=Info.user_name%> <%
		switch(Info.user_state){
			case 0:
				Response.Write("<span style=\"color:#060\">正常</span>");
				break;
			case 12:
				Response.Write("<span style=\"color:#00f\">锁定</span>");
				break;
			case 1:
				Response.Write("<span style=\"color:#f00\">禁用</span>");
				break;
			case 11:
				Response.Write("<span style=\"color:#f00\">未激活</span>");
				break;
			default:
				Response.Write("<span style=\"color:#f00\">待审</span>");
				break;
		}
	%></td>
                 <td style="width:20%">医卡通：<%=Info.eb_card_no%></td>
                 <td style="width:30%">用户类别：<%=Info.user_type==2?"管理员":Info.user_type==3?"第三方管理员":"普通会员" %>&nbsp;&nbsp;<%if (_isallow)
                                                                                                                         {
                                                                                                                             if (Info.user_type != 3)
                                                                                                                             {%><a href="javascript:;" onclick="setUserType(<%=Info.user_id %>,<%=Info.user_type==1?2:1 %>)" style="color:green"><%=Info.user_type == 1 ? "设置为管理员" : "取消管理员"%></a><%}
                                                                                                                             if (Info.user_type != 2)
                                                                                                                             { %>&nbsp;<a href="javascript:;" onclick="setUserType(<%=Info.user_id %>,<%=Info.user_type==1?3:1 %>)" style="color:green"><%=Info.user_type == 1 ? "设置为第三方管理员" : "取消第三方管理员"%></a><%}
                                                                                                                         }%></td>
              </tr>
              <tr>
                 <td>邮箱：<%=string.IsNullOrEmpty(Info.user_email)?"未填写邮箱地址":Info.user_email%></td>
                 <td>总积分：<strong><%=Info.total_user_integral%></strong></td>
                 <td>可用积分：<strong><%=Info.user_integral%></strong><a href="javascript:;" onclick="updateintelgral('<%=Info.user_id %>')" style="color:green">赠送积分</a></td>
              </tr>
              <tr>
                 <td colspan="3">
                 手机：<span name="phone" ><%=string.IsNullOrEmpty(Info.mobile_no)?"未填写手机号":Info.mobile_no%></span>
                 &nbsp;<a href="javascript:;" onclick="resetmobile('<%=Info.user_id %>','<%=Info.mobile_no==null?"":Info.mobile_no %>','<%=Info.user_name %>')" style="color:green">修改绑定手机</a>
                 </td>
              </tr>
              <tr>
                 <td colspan="2" style="height:30px">上次访问：<%=Info.last_login_time%></td>
                 <td style="height:30px">注册时间：<%=Info.add_time%></td>
                 <td>上次登录IP：<%=Info.last_login_ip%></td>
              </tr>
             
           </tbody>
         </table>
<br/>
<table class="table2" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th colspan="4">补充资料</th>
  </tr>
</thead>
<tbody>
  <tr>
  <td style="width:25%">真实姓名: <%=Info.real_name %></td> 
  <td style="width:25%">生&nbsp;&nbsp;日: <%=Info.birth_day %></td>
  <td style="width:25%">性&nbsp;&nbsp;别: <%=Info.user_sex %></td>
  <td style="width:25%">Q&nbsp;Q: <%=Info.user_qq %></td>
  </tr>
  <tr>
    <td style="width:50%" colspan="2">联系电话: <%=Info.user_tel %></td>
    <td style="width:50%" colspan="2">邮&nbsp;&nbsp;编: <%=Info.zip_code %></td>
  </tr>
  <tr>
   <td style="width:50%" colspan="2">所在区域: <%=Info.province_name+","+Info.city_name+","+Info.county_name %></td> 
   <td style="width:50%" colspan="2">详细地址: <%=Info.user_addr %></td>
  </tr>
  <tr>
    <td style="width:10%">自我介绍: </td>
    <td colspan="3" style="height:100px"><%=Info.user_remark %></td>
  </tr>
</tbody>
</table>
<br/>
<script type="text/javascript">
    function postUpdateIntelgral(form) {
        var postData = getPostDB(form);
        $.ajax({
            url: "/MUsers/UpdateIntelgral"
		, data: postData
        , type: "post"
		, dataType: "json"
		, success: function (json) {
		    if (json.error) {
		        $(_updateIntelgralBoxDialog.dialog).find("span[class='tips-text']").html(json.message);
		    } else {
		        jsbox.success(json.message, window.location.href);
		    }
		    if (closeLoadding) closeLoadding();
		}
        });
        return false;
    }
    var _updateIntelgralBoxDialog = false;
    function updateintelgral(id) {
        var boxId = "#updateintelgral-box";
        var box = Atai.$(boxId);
        var _dialog = new AtaiShadeDialog();
        _dialog.init({
            obj: boxId
		, sure: function () { }
		, CWCOB: false
        });
        _updateIntelgralBoxDialog = _dialog;
        $(_updateIntelgralBoxDialog.dialog).find("input[name='userid']").val(id);
    }




    function postUsermobile(form) {
    var postData = getPostDB(form);
    $.ajax({
        url: "/MUsers/ResetMobile"
		, data: postData
        , type: "post"
		, dataType: "json"
		, success: function (json) {
		    if (json.error) {
		        $(_resetMobileBoxDialog.dialog).find("span[class='tips-text']").html(json.message);
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
    var _resetMobileBoxDialog = false;
    function resetmobile(id, mobile, name) {
        var boxId = "#resetmobile-box";
        var box = Atai.$(boxId);
        var _dialog = new AtaiShadeDialog();
        _dialog.init({
            obj: boxId
		, sure: function () { }
		, CWCOB: false
        });
        _resetMobileBoxDialog = _dialog;
        $(_resetMobileBoxDialog.dialog).find("input[name='userid']").val(id);
        $(_resetMobileBoxDialog.dialog).find("#username").val(name);
        $(_resetMobileBoxDialog.dialog).find("input[name='oldmobile']").val(mobile);
    }

    function setUserType(id, type) {
        jsbox.confirm("确定要改变用户管理权限？", function () {
            $.ajax({
                url: "/MUsers/ResetUserType"
	          , data: { "id": id, "type": type }
              , type: "post"
	          , dataType: "json"
		      , success: function (json) {
		        if (json.error) {
		            jsbox.error(json.message);
		        } else {
		            jsbox.success(json.message, window.location.href);
		        }
		        if (closeLoadding) closeLoadding();
		        }
            });
        });
        return false;
    }
</script>
<br/><br/>
	</div>
	<div class="clear">&nbsp;</div>
</div>
<div id="resetmobile-box" class="moveBox" style="width:420px;height:280px;">
<div id="resetmobile-box-name" class="name">修改绑定手机
<div id="resetmobile-box-close"  v="atai-shade-close" class="close">&nbsp;</div></div>
<div class="clear">&nbsp;</div>
<form action="" onsubmit="return postUsermobile(this)">
<input type="hidden" name="userid" value="0"/>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="left">&nbsp;</td>
    <td><span class="tips-text" style="color:#ff6600">&nbsp;</span></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;">用户账号：</td>
    <td><input type="text" id="username" class="input" value="" style="width:160px" disabled="disabled"/></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;">已绑定手机：</td>
    <td><input type="text" name="oldmobile" class="input" value="" style="width:160px" disabled="disabled"/></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;">新绑定手机：</td>
    <td><input type="text" name="newmobile" class="input" value="" style="width:160px"/> <span style="color:Green">(不填则为解除绑定)</span></td>
  </tr>
  <tr>
    <td class="left" style="height:30px;">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td class="left" style="height:30px;">&nbsp;</td>
    <td><input type="submit" class="submit" value="  修 改  " /></td>
  </tr>
</table>
</form>
</div>

<div id="updateintelgral-box" class="moveBox" style="width:420px;height:280px;">
<div id="updateintelgral-box-name" class="name">更新用户积分<div id="updateintelgral-box-close"  v="atai-shade-close" class="close">&nbsp;</div></div>
<div class="clear">&nbsp;</div>
<form action="" onsubmit="return postUpdateIntelgral(this)">
<input type="hidden" name="userid" value="0"/>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="left">&nbsp;</td>
    <td><span class="tips-text" style="color:#ff6600">&nbsp;</span></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;">积分变更(-为减少积分)：</td>
    <td><input type="text" name="intelval" class="input" value="" style="width:160px"/></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;">变更理由：</td>
    <td><input type="text" name="reason" class="input" value="" style="width:160px" /></td>
  </tr>
  <tr>
    <td class="left" style="height:30px;">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td class="left" style="height:30px;">&nbsp;</td>
    <td><input type="submit" class="submit" value="  修 改  " /></td>
  </tr>
</table>
</form>
</div>
<div class="clear">&nbsp;</div>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>
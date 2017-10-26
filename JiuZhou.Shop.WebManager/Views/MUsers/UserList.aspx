<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %><%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.ControllerBase" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
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
        bool _isallowrole = false;
        bool _isallowcoupon = false;
        _isallowrole = ForeSysBaseController.HasPermission2(122);
        _isallowcoupon = ForeSysBaseController.HasPermission2(575);
    %>
    <div id="container-syscp">
   <div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
        <div class="position">
            当前位置： <a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>用户列表</span>
        </div>
        <form action="/musers/userlist" method="get" onsubmit="checksearch(this)">
        <div class="div-tab-h1" style="font-weight: 100; color: #333; font-size: 12px">
            <p>
                <select id="sel-ustate" name="state" style="width: 120px;height:26px;">
                    <option value="-1">所有</option>
                    <option value="0">启用</option>
                    <option value="1">禁用</option>
                    <option value="11">未激活</option>
                    <option value="12">锁定</option>
                </select>
            </p>
             <p>
                <select id="usertype" name="usertype" style="width: 100px;height:26px;">
                    <option value="-1">所  有</option>
                    <option value="1">普通用户</option>
                    <option value="2">操 作 员</option>
                    <option value="3">第三方管理员</option>
                </select>
            </p>
       <p>
<%
	DateTime date = DateTime.Now.AddMonths(-36);
%><input type="text" name="sdate" value="<%=DoRequest.GetQueryDate("sDate", date).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
至
<input type="text" name="edate" value="<%=DoRequest.GetQueryDate("eDate", DateTime.Now).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
      </p>

            <p>
                <input type="text" id="sQuery" name="q" value="<%=DoRequest.GetQueryString("q")%>"
                    class="input" autocomplete="off" /></p>
            <p>
                <input type="submit" value=" 搜索 " class="submit" />
            </p>
        </div>
        </form>
        <script type="text/javascript">
var qInitValue="请输入关键词";
Atai.addEvent(window, "load", function () {

    //	var dropSType=new _DropListUI({
    //		input: Atai.$("#sel-stype")
    //	});dropSType.maxHeight="260px";dropSType.width="120px";
    //	dropSType.init();dropSType.setDefault("<%=DoRequest.GetQueryString("scol")%>");
    /*
    var dropStar=new _DropListUI({
    input: Atai.$("#sel-ustate")
    });dropStar.maxHeight="260px";dropStar.width="120px";
    dropStar.init();dropStar.setDefault("<%=DoRequest.GetQueryInt("state", -1)%>");
    */
    var _state = <%=DoRequest.GetQueryInt("state", -1)%>;
    var _type =  <%=DoRequest.GetQueryInt("usertype", -1)%>;

    $(function () {
        $("#sel-ustate option[value='" + _state + "']").attr("selected",true);
        $("#usertype option[value='" + _type + "']").attr("selected",true);
    });

    var sQuery = Atai.$("#sQuery");
    if (sQuery.value == qInitValue || sQuery.value == "") {
        sQuery.value = qInitValue;
        sQuery.style.color = "#999";
    } else {
        sQuery.style.color = "#111";
    }
    sQuery.onfocus = function () {
        if (this.value == qInitValue) {
            this.value = "";
            sQuery.style.color = "#111";
        }
    };
    sQuery.onblur = function () {
        if (this.value == "") {
            this.value = qInitValue;
            sQuery.style.color = "#999";
        }
    };
});
function checksearch(form){
	var sQuery=Atai.$("#sQuery");
	if(sQuery.value==qInitValue){
		sQuery.value="";
	}
}
        </script>
        <form id="post-form" method="post" action="">
        <%=ViewData["pageIndexLink"]%>
     
        <table id="tab-category" class="table" cellpadding="0" cellspacing="0">
            <thead>
                <tr>
                    <th style="width: 3%">
                        <input type="checkbox" onclick="checkAll(this.form,this)" name="chkall" title="选中/取消选中" />
                    </th>
                    <th style="width: 10%">
                        用户ID<br/><span style="color:#aaa">类别</span>
                    </th>
                    <th>
                        账号<br/><span style="color:#aaa">真实姓名</span>
                    </th>
                    <th style="width: 14%">
                        手机号<br/><span style="color:#aaa">邮箱地址</span>
                    </th>
                    <th style="width: 14%">
                        上次访问时间<br/><span style="color:#aaa">上次登录IP</span>
                    </th>
                    <th style="width: 14%">
                        注册时间<br/><span style="color:#aaa">解锁时间</span>
                    </th>
                    <th style="width: 16%">
                        操作
                    </th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<ShortUserInfo> infoList = (List<ShortUserInfo>)ViewData["infoList"];
                    if (infoList == null)
                        infoList = new List<ShortUserInfo>();
                    foreach (ShortUserInfo item in infoList)
                    {
                %>
                <tr>
                    <td>
                        <input type="checkbox" onclick="selectOne(this)" name="visitid" value="<%=item.user_id%>" />
                    </td>
                    <td>
                        <%=item.user_id %>
                        <br/><span style="color:#aaa"><%
		                if(item.user_type==1){
			                Response.Write("普通用户");
                        }
                        else if (item.user_type==2)
                        {
                            Response.Write("操作员");
                        }
                        else if (item.user_type == 3) {
                            Response.Write("第三方管理员");
                        }
	                    %></span>
                    </td>
                    <td>
                        <%=item.user_name%> <%
		                switch(item.user_state){
			                case 0:
				                Response.Write(" <span style=\"color:#060\">正常</span>");
				                break;
			                case 1:
                                Response.Write(" <span style=\"color:#00f\">禁用</span>");
				                break;
			                case 11:
				                Response.Write(" <span style=\"color:#f00\">未激活</span>");
				                break;
			                case 12:
				                Response.Write(" <span style=\"color:#f00\">锁定</span>");
				                break;
			                default:
				                Response.Write(" <span style=\"color:#f00\">待审</span>");
				                break;
		               }
	                  %>
                      <br/><span style="color:#aaa"><%= item.real_name.Equals("")?"无":item.real_name%> </span>
                    </td>
                    <td>
                        <%=item.mobile_no.Equals("") ? "无" : item.mobile_no%>
                        <br/><span style="color:#aaa"><%=item.user_email.Equals("") ? "无" : item.user_email%> </span>
                    </td>
                    <td>
                    <%=item.last_login_time %>
                    <br/><span style="color:#aaa"><%=item.last_login_ip%> </span>
                    </td>
                    <td>
                        <%=item.add_time%>
                        <br/><span style="color:#aaa"><%= item.unlock_time==null ? "未锁定" : item.unlock_time%> </span>
                    </td>
                    
                    <td>
                        <a href="/musers/editor?uid=<%=item.user_id%>" target="_blank">查看详细</a>&nbsp;
                        <a href="javascript:;" onclick="resetPassword(<%=item.user_id%>)">重设密码</a><br/>
                        <%
                        if(_isallowrole){
                         %>
                        <a href="javascript:;" onclick="setRole('<%=item.user_name %>',<%=item.user_id%>)">设置角色</a>
                        <%}
                        if(_isallowcoupon){ %>
                        <a href="javascript:;" onclick="updateConpon('<%=item.user_name %>',<%=item.user_id%>)">赠送优惠券</a>
                        <%} %>
                    </td>
                </tr>
                <%
             }
                %>
            </tbody>
        </table>
        <%=ViewData["pageIndexLink2"]%>
        <div class="console">
            	<a href="javascript:;" onclick="resetUserState(Atai.$('#post-form'), 1)">禁止账号</a>
                &nbsp;&nbsp;
                <a href="javascript:;" onclick="resetUserState(Atai.$('#post-form'), 0)">恢复正常</a>
			</div>
        </form>
    </div>
    </div>
<script type="text/javascript">

    function changePage(val){
	var url=formatUrl("page", val);
	window.location.href=url;
    }

    function resetUserState(form, status) {
        var _data = Atai.isInt(form) ? ("visitid=" + form) : getPostDB(form);
        var postData = "status=" + status + "&" + _data;
        var msg = "";
        if (status == 1) msg = "您确定要禁止此账号吗？";
        else msg = "您确定要恢复此账号吗？";
        jsbox.confirm(msg, function () {
            $.ajax({
                url: "/musers/ResetUserState"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function (json, textStatus) {
			    if (json.error) {
			        jsbox.error(json.message); return false;
			    } else {
			        jsbox.success(json.message,window.location.href);
			    }
			}
            });
        });
        return false;
    }

    function resetPassword(id) {
        jsbox.confirm("确定要重置该账号的密码？", function () {
            $.ajax({
                url: "/musers/ResetUserPsw"
			, data: {"userid":id}
            , type: "post"
			, dataType: "json"
			, success: function (json, textStatus) {
			    if (json.error) {
			        jsbox.error(json.message); return false;
			    } else {
			        jsbox.success(json.message);
			    }
			}
            });
        });
        return false;
    }

    var _roleSetBoxDialog = false;
    function setRole(name,id) {

        var boxId = "#setrole-box";
        var box = Atai.$(boxId);
        var _dialog = false;
        if (!_dialog)
            _dialog = new AtaiShadeDialog();
        _dialog.init({
            obj: boxId
		    , sure: function () { }
		    , CWCOB: false
        });
        _roleSetBoxDialog = _dialog;
        var dataObject = $(_roleSetBoxDialog.dialog).find("#rolecategid");
        $(_roleSetBoxDialog.dialog).find("input[name='userid']").val(id);
        $(_roleSetBoxDialog.dialog).find("input[id='username']").val(name);
        $.ajax({
            url: "/musers/GetRoleList"
            , data: { "id": id }
            , type: "post"
			, dataType: "json"
			, success: function (json, textStatus) {
			    if (json.error) {
			        $(_roleSetBoxDialog.dialog).find("span[class='tips-text']").html(json.message);
			    } else {
			        //dataObject.attr("multiple",json.role.lenght);
			        dataObject.attr("size", json.role.lenght);
			        var htmls = [];
			        for (var i = 0; i < json.role.length; i++) {
			            htmls.push('<option value="' + json.role[i].role_id + '">' + json.role[i].role_name + '</option>');
			        }
			        dataObject.html(htmls.join("\r\n"));
			        for (var i = 0; i < json.role2.length; i++) {
			            $(_roleSetBoxDialog.dialog).find("#rolecategid option[value='"+ json.role2[i].role_id +"']").attr("selected", true);
                    }
			    }
			}
        });
        return false;
    }

    function postUserRole(form) {
        var roleid = "";
        var _count = 0;
        $(_roleSetBoxDialog.dialog).find("#rolecategid option:selected").each(function () {
            if (_count == 0) {
                roleid = $(this).val();
            } else {
                roleid = roleid + "," + $(this).val();
            }
            _count++;
        });
        var postDate = getPostDB(form);

        $.ajax({
            url: "/Musers/PostUserRole"
		, data: postDate + "&roleids=" + roleid
        , type: "post"
		, dataType: "json"
		, success: function (json) {
		    if (json.error) {
		        $(_roleSetBoxDialog.dialog).find("span[class='tips-text']").html(json.message);
		    } else {
		        jsbox.success(json.message, window.location.href);
		    }
		    if (closeLoadding) closeLoadding();
		}
        });
        return false;
    }


    var _couponBoxDialog = false;
    function updateConpon(name, id) {

        var boxId = "#updataCouponBox";
        var box = Atai.$(boxId);
        var _dialog = false;
        if (!_dialog)
            _dialog = new AtaiShadeDialog();
        _dialog.init({
            obj: boxId
		    , sure: function () { }
		    , CWCOB: false
        });
        _couponBoxDialog = _dialog;
        var dataObject = $(_couponBoxDialog.dialog).find("#coupon");
        $(_couponBoxDialog.dialog).find("input[name='userid']").val(id);
        $(_couponBoxDialog.dialog).find("input[id='username2']").val(name);
        $.ajax({
            url: "/musers/GetCoupon"
            , type: "post"
			, dataType: "json"
			, success: function (json, textStatus) {
			    if (json.error) {
			        $(_couponBoxDialog.dialog).find("span[class='tips-text']").html(json.message);
			    } else {
			        var htmls = [];
			        htmls.push('<option value="-1">请选择面值</option>');
			        for (var i = 0; i < json.list.length; i++) {
			            htmls.push('<option value="' + json.list[i].coupon_price + '">' + json.list[i].coupon_price + '元,满'+ json.list[i].min_price+'使用</option>');
			        }
			        dataObject.html(htmls.join("\r\n"));
			    }
			}
        });
        return false;
    }

    function postCoupon(form) {
        var postDate = getPostDB(form);

        $.ajax({
            url: "/Musers/PostCoupon"
		, data: postDate 
        , type: "post"
		, dataType: "json"
		, success: function (json) {
		    if (json.error) {
		        $(_couponBoxDialog.dialog).find("span[class='tips-text']").html(json.message);
		    } else {
		        jsbox.success(json.message, window.location.href);
		    }
		    if (closeLoadding) closeLoadding();
		}
        });
        return false;
    }
</script>

<div id="setrole-box" class="moveBox" style="width:420px;height:280px;">
<div id="setrole-box-name" class="name">设置角色<div id="setrole-box-close"  v="atai-shade-close" class="close">&nbsp;</div></div>
<div class="clear">&nbsp;</div>
<form action="" onsubmit="return postUserRole(this)">
<input type="hidden" name="userid" value="0"/>
<table width="100%" border="0" cellspacing="4" cellpadding="0">
  <tr>
    <td class="left">&nbsp;</td>
    <td><span class="tips-text" style="color:#ff6600">&nbsp;</span></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;">用户账号：</td>
    <td><input type="text" id="username" class="input" value="" style="width:160px" disabled="disabled"/></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;">角&nbsp;&nbsp;色：</td>
    <td>
    <select multiple name="rolecateg" id="rolecategid" style="width:160px;">
    <option value="-1">请选择角色</option>
    </select>
    </td>
  </tr>
  <tr>
    <td class="left" style="height:30px;">&nbsp;</td>
    <td><input type="submit" class="submit" value="  修 改  " /></td>
  </tr>
</table>
</form>
</div>

<div id="updataCouponBox" class="moveBox" style="width:420px;height:300px;">
<div id="updataCouponBox-name" class="name">赠送优惠券<div id="updataCouponBox-close"  v="atai-shade-close" class="close">&nbsp;</div></div>
<div class="clear">&nbsp;</div>
<form action="" onsubmit="return postCoupon(this)">
<input type="hidden" name="userid" value="0"/>
<table width="100%" border="0" cellspacing="2" cellpadding="0">
  <tr>
    <td class="left">&nbsp;</td>
    <td><span class="tips-text" style="color:#ff6600">&nbsp;</span></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;">用户账号：</td>
    <td><input type="text" id="username2" class="input" value="" style="width:160px" disabled="disabled"/></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;">优惠券名：</td>
    <td><input type="text" name="couponname" class="input" value="" style="width:80px" /></td>
  </tr>
  <tr>
    <td class="left" style="height:36px;">面&nbsp;&nbsp;值：</td>
    <td>
    <select name="couponvalue" id="coupon" style="width:160px;height:30px;">
    </select>
    </td>
  </tr> 
  <tr>
    <td class="left" style="height:36px;">数&nbsp;&nbsp;量：</td>
    <td><input type="text" name="couponnum" class="input" value="1" style="width:40px" /></td>
  </tr>
  <tr>
    <td class="left" style="height:30px;">&nbsp;</td>
    <td><input type="submit" class="submit" value="  确 定  " /></td>
  </tr>
</table>
</form>
</div>

<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>

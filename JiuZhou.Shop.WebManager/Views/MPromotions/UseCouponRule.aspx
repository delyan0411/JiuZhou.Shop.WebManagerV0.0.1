<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
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
%>
<div id="container-syscp">
<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
</div>
<div class="container-right">
	<div class="position">
		<a href="/" title="管理首页">管理首页</a>
		&gt;&gt;
		<a href="/mpromotions/UseCouponRule" title="优惠券使用规则">优惠券使用规则</a>
<%--//position--%>
</div>

<form id="post-form" method="post" action="">
<table id="tab-category" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:3%"><input type="checkbox" onclick="checkAll(this.form,this)" name="chkall" title="选中/取消选中"/></th>
    <th style="width:10%">最低销售额</th>
    <th style="width:10%">优惠券面值</th>
    <th style="width:12%">状态</th>
    <th style="width:14%">添加时间</th>
    <th style="width:8%">操作</th>
  </tr>
</thead>
<tbody>
<%
    List<UseCouponRuleInfo> infoList = new List<UseCouponRuleInfo>();
    var resrule = GetUseCouponRule.Do();
    if (resrule != null && resrule.Body != null && resrule.Body.coupon_rule_list != null)
        infoList = resrule.Body.coupon_rule_list;
    foreach (UseCouponRuleInfo item in infoList)
    {
		
%>
  <tr>
    <td><input type="checkbox" onclick="selectOne(this)" name="visitid" value="<%=item.uc_rule_id%>" /></td>
   <td>
    <a><%=item.min_price%></a>
   </td>
   <td>
    <a><%=item.coupon_price%></a>
   </td>
   <td>
   <%  string _state = "未知";
       string _color = "color:#060";
        if(item.rule_state==0){
            _state = "可用";
            _color = "color:#060";
        }
        if (item.rule_state == 1)
        {
            _state = "不可用";
            _color = "color:#999";
        }
         %>
    <a style=<%=_color %> href="javascript:;" onclick="ResetUseCouponRuleStatus(this,'<%=item.uc_rule_id%>')" val="<% =(item.rule_state) %>"><%=_state%></a>
   </td>
    <td>
    <a><%=DateTime.Parse(item.add_time).ToString("yyyy-MM-dd HH:mm:ss")%></a>
    </td>
    <td>
    <a href="javascript:;" onclick="_showUseCouponRuleBox(<%=item.uc_rule_id %>)" style="color:#333">编辑</a>
    <a href="javascript:;" onclick="deleteList(<%=item.uc_rule_id%>)" style="color:#333">删除</a>
    </td>
  </tr>
<%
	}
%>
  </tbody>
</table>
    <div class="div-tab-bottom">
      <b class="icon-add">&nbsp;</b><a href="javascript:;" onclick="_showUseCouponRuleBox(0)" style="color:#0000FF">新增兑换</a>
	  <span onclick="deleteList(Atai.$('#post-form'))"><b class="icon-remove">&nbsp;</b>删除选定项</span>
    </div>
</form>
</div>
</div>
<br/><br/><br/>

<div id="useCouponRule-boxControl" class="dialog-box" style="height:350px;width:500px;">
	<div class="atai-shade-head" v="atai-shade-move">
		使用优惠券规则编辑 
		<div class="atai-shade-close" v="atai-shade-close">&nbsp;</div>
	</div>
<form action="" onsubmit="return UpdateCouponRule(this)">
<input type="hidden" id="ruleid" name="ruleid" value=""/>
<div class="atai-shade-contents">
<table width="100%" border="0" cellspacing="6" cellpadding="0">
  <tr>
    <td class="left">&nbsp;</td>
    <td><span class="tips-text" style="color:#ff6600">&nbsp;</span></td>
  </tr>
  <tr>
    <td class="left" style="width:80px;">最低销售额<span style="color:red">*</span>：</td>
    <td><input type="text" id="minprice" name="minprice" class="input" value="" style="width:70px;"/> 元</td>
  </tr>
  <tr>
    <td class="left" style="width:80px;">优惠券面值<span style="color:red">*</span>：</td>
    <td>
        <input type="text" id="couponprice" name="couponprice" class="input" value="" style="width:70px;"/> 元
    </td>
  </tr>
  <tr>
    <td class="left" valign="top">状&nbsp;&nbsp;&nbsp;态：</td>
    <td >
       <input type="radio" name="ruleType" onclick="checkedthis(this)" value="0"/> 可用
       &nbsp;|&nbsp;
       <input type="radio" name="ruleType" onclick="checkedthis(this)" value="1"/> 不可用
    </td>
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
<%--//table--%>
<script type="text/javascript">
    function UpdateCouponRule(form) {
        var postData = getPostDB(form);
        $.ajax({
            url: "/MPromotions/PostUseCouponRule"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function (json) {
			    if (json.error) {
			        $(_useCouponRuleBoxDialog.dialog).find("span[class='tips-text']").html(json.message); return false;
			    } else {
			        if (_useCouponRuleBoxDialog) {
			            _useCouponRuleBoxDialog.close();
			            _useCouponRuleBoxDialog = false;
			        } 
                    window.location.href=window.location.href;
			    }
			}
        });
        return false;
    }

    var _useCouponRuleBoxDialog = false;
    function _showUseCouponRuleBox(ruleid) {
        var boxId = "#useCouponRule-boxControl";
        var _dialog = new AtaiShadeDialog();
        _dialog.init({
            obj: boxId
		, sure: function () { }
		, CWCOB: true
        });
        _useCouponRuleBoxDialog = _dialog;

        var postData = "ruleid=" + ruleid;
        $.ajax({
            url: "/MPromotions/GetUseCouponRuleInfo"
		, type: "post"
        , async: false
		, data: postData
		, dataType: "json"
		, success: function (json, textStatus) {
		    $(_useCouponRuleBoxDialog.dialog).find("input[name='ruleid']").val(ruleid);
		    $(_useCouponRuleBoxDialog.dialog).find("input[name='minprice']").val(json.ruleinfo.min_price);
		    $(_useCouponRuleBoxDialog.dialog).find("input[name='couponprice']").val(json.ruleinfo.coupon_price);
		    $(_useCouponRuleBoxDialog.dialog).find("input[name='ruleType']").each(function () {
		        if ($(this).val() == json.ruleinfo.rule_state) {
		            $(this).attr("checked", true);
		        } else {
		            $(this).attr("checked", false);
		        }
		    });
		}
        });
    }


    function checkedthis(obj) {
        if (obj.checked) {
            $(obj).attr("checked", true);
            $("input[name='ruleType']").each(function () {
                if (this != obj)
                    $(this).attr("checked", false);
            });
        } else {
            $(obj).attr("checked", false);
            $(_useCouponRuleBoxDialog.dialog).find("input[name='ruleType']").each(function () {
                if (this != obj)
                    $(this).attr("checked", true);
            });
        }
    }

    function ResetUseCouponRuleStatus(obj, ruleid) {
        var _state = 0;
        //jsbox.error(obj.val());
        if ($(obj).attr("val") == "0") {
            _state = "1";
        } else {
            _state = "0";
        }
        var postData = "ruleid=" + ruleid;
        postData += "&state=" + _state;
        $.ajax({
            url: "/MPromotions/ResetCouponRuleStatus"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function (json) {
			    if (json.error) {
			        jsbox.error(json.message); return false;
			    } else {
			        if (_state == "0") {
			            $(obj).css({ "color": "#060" }).html("可用");
			            $(obj).attr("val","0");
			        } else {
			            $(obj).css({ "color": "#999" }).html("不可用");
			            $(obj).attr("val", "1");
			        }
			    }
			}
        });
        return false;
    }

function deleteList(form){
    var postData = "";
    if (Atai.isNumber(form)) {
        postData = "visitid=" + form;
    } else {
        postData = getPostDB(form);
    }
	jsbox.confirm('您确定要删除这些数据吗？',function(){
		$.ajax({
		    url: "/MPromotions/RemoveUseCouponRules"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function(json){
				if(json.error){
					jsbox.success(json.message);return false;
				}else{
					window.location.href=window.location.href;
				}
			}
		});
	});
	return false;
}
</script>

<%Html.RenderPartial("Base/_PageFootControl"); %>
</body></html>

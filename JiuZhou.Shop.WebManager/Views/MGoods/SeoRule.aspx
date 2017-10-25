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
			<a href="/" title="管理首页">管理首页</a>
			&gt;&gt;
			<a href="/mgoods" title="商品管理">商品管理</a>
			&gt;&gt;
			<span>Seo规则列表</span>
		</div>
<%--//position--%>
		<div class="div-tab">
        <div class="console">
        <a href="/mgoods/seoHomeRuleEditor?ruleid=-1"><b class="add">&nbsp;</b>新增首页seo规则</a>
        <a href="/mgoods/seoClassRuleEditor?ruleid=-1"><b class="add">&nbsp;</b>新增类别seo规则</a>
			<a href="/mgoods/seoRuleEditor?ruleid=-1"><b class="add">&nbsp;</b>新增单品seo规则</a>
		</div>
<table class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:6%">规则名</th>
    <th style="width:6%">规则因子</th>
    <th style="width:6%">优先级</th>
    <th style="width:12%">title</th>
    <th style="width:12%">keywords</th>
    <th >description</th>
    <th style="width:6%">添加时间</th>
    <th style="width:6%">添加人</th>
    <th style="width:6%">最近更新时间</th>
    <th style="width:12%">操作</th>
  </tr>
</thead>
<tbody>
<%
    List<SeoRuleInfo> ruleList = new List<SeoRuleInfo>();    
    var resrule = GetSeoRuleList.Do(-1);
    if (resrule != null && resrule.Body != null && resrule.Body.seo_rule_list != null)
        ruleList = resrule.Body.seo_rule_list;

    foreach (SeoRuleInfo rule in ruleList)
    {
        string elestring = "";
        List<string> eles = rule.rule_element.Split(',').ToList();
        List<string> elsone = new List<string>();
        foreach (string els in eles)
        {
            switch (els)
            {
                case "0":
                    elsone.Add("首页");
                    break;
                case "1":
                    elsone.Add("分类");
                    break;
                case "2":
                    elsone.Add("品牌");
                    break;
                case "3":
                    elsone.Add("分类页");
                    break;
                default:
                    elsone.Add("未知");
                    break;
            }
            elestring = string.Join(",", elsone.ToArray());
        }
%>
  <tr>
    <td><%=rule.rule_name%></td>
    <td><%=elestring%></td>
    <td><%=rule.priority_level%></td>
    <td><%=rule.title%></td>
    <td><%=rule.keywords %></td>
    <td><%=rule.description %></td>
    <td><%=rule.add_time %></td>
    <td><%=rule.add_user %></td>
    <td><%=rule.update_time %></td>
    <td><% 
        switch (rule.rule_element)
        {
            case "1,2":
                Response.Write("<a href=\"/mgoods/seoRuleEditor?ruleid="+rule.rule_id+"\" target=\"_blank\">修改</a>");
                break;
            case "0":
                Response.Write("<a href=\"/mgoods/seoHomeRuleEditor?ruleid="+rule.rule_id+"\" target=\"_blank\">修改</a>");
                break;
            case "3":
                Response.Write("<a href=\"/mgoods/seoClassRuleEditor?ruleid="+rule.rule_id+"\" target=\"_blank\">修改</a>");
                break;
            default:
                Response.Write("<a href=\"/mgoods/seoRuleEditor?ruleid=" + rule.rule_id + "\" target=\"_blank\">修改</a>");
                break;
        }
            
   
    %>

    &nbsp;
    <a href="javascript:;" onclick="deleteList(<%=rule.rule_id %>)">删除</a>
    </td>
  </tr>
<%
	}
%>
  </tbody>
</table>
		<div class="console">
        <a href="/mgoods/seoHomeRuleEditor?ruleid=-1"><b class="add">&nbsp;</b>新增首页seo规则</a>
        <a href="/mgoods/seoClassRuleEditor?ruleid=-1"><b class="add">&nbsp;</b>新增类别seo规则</a>
			<a href="/mgoods/seoRuleEditor?ruleid=-1"><b class="add">&nbsp;</b>新增单品seo规则</a>
		</div>
    </div>
</div>
</div>
<br/><br/>
<script type="text/javascript">
    function deleteList(ruleid) {

        var postData = "ruleid=" + ruleid;
       
        jsbox.confirm('您确定要删除这些数据吗？', function () {
            $.ajax({
                url: "/mgoods/RemoveSeoRule"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function (json) {
			    if (json.error) {
			        jsbox.error(json.message); return false;
			    } else {
			        window.location.href = window.location.href;
			    }
			}
            });
        });
        return false;
    }
</script>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>
<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="JiuZhou.Model" %>
<%@ Import Namespace="JiuZhou.Common" %>
<%@ Import Namespace="JiuZhou.MySql" %>
<%@ Import Namespace="JiuZhou.HttpTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <%Html.RenderPartial("Base/_PageHeadControl"); %>
    <link href="/style/style.css" rel="stylesheet" type="text/css" />
    <title>
        <%=ViewData["pageTitle"]%></title>
    <style>
        .table-head
        {
            width: 100%;
        }
        .table-head thead th
        {
            background: #f3f5ea;
            border-bottom: #dbe0cb 1px solid;
            text-align: center;
            height: 26px;
            line-height: 26px;
            padding: 0;
        }
        .table-head th
        {
            border: #dbe0cb 1px solid;
            border-left: 0;
            border-bottom: 0;
            font-weight: 100;
        }
        .table-head tbody td
        {
            border-right: #ddd 1px solid;
            border-bottom: #ddd 1px solid;
            text-align: center;
            line-height: 22px;
        }
        .table-head tbody td .input
        {
            width: 40px;
            text-align: center;
        }
        .selecedtype ul
        {
            width: 400px;
            height: 300px;
            overflow-x: hidden;
            overflow-y: auto;
        }
        .selecedtype ul li
        {
            text-indent: 18px;
            border-bottom: #ccc 1px dashed;
            display: block;
            height: 27px;
            line-height: 27px;
            font-weight: bolder;
        }
        
        .brandlist ul
        {
            width: 500px;
            height: 300px;
            overflow-x: hidden;
            overflow-y: auto;
        }
        .brandlist ul li
        {
            text-indent: 18px;
            border-bottom: #ccc 1px dashed;
            display: block;
            height: 27px;
            line-height: 27px;
            font-weight: bolder;
        }
        
        .selecedbrand ul
        {
            width: 400px;
            height: 300px;
            overflow-x: hidden;
            overflow-y: auto;
        }
        .selecedbrand ul li
        {
            text-indent: 18px;
            border-bottom: #ccc 1px dashed;
            display: block;
            height: 27px;
            line-height: 27px;
            font-weight: bolder;
        }
    </style>
</head>
<body>
    <%Html.RenderPartial("Base/_SimplePageTopControl"); %>
    <%
        ConfigInfo config = (ConfigInfo)(ViewData["config"]);
        int ruleid = DoRequest.GetQueryInt("ruleid");
        SeoRuleInfo rule = null;
        List<SeoRuleItemInfo> rils = null;
        var resp = GetSeoRuleList.Do(ruleid);
        if (ruleid > 0 && (resp == null || resp.Body.seo_rule_list == null))
        {
            Response.Write("<script language=javascript>jsbox.error('数据获取失败！请刷新')</script>");
            rule = new SeoRuleInfo();
        }
        else
        {
            if (ruleid == -1)
            {
                rule = new SeoRuleInfo();
                rule.rule_id = -1;
            }
            else
            {
                rils = GetSeoRuleItemsByRuleId.Do(Convert.ToInt16(ruleid)).Body.rule_list;
                rule = resp.Body.seo_rule_list[0];
            }
        }
    %>
    <div id="container-syscp">
        <div class="container-left">
            <%Html.RenderPartial("Base/LeftControl"); %>
        </div>
        <div class="container-right">
            <div class="editor-box-head" style="position: relative">
                编辑主页seo规则
            </div>
            <div class="div-tab">
                <form id="SeoHomeRuleForm" method="post" action="" onsubmit="return submitHomeSeoRuleForm(this)">
                <input type="hidden" name="seoruleid" value="<%=  rule.rule_id%>" />
                <table class="table" cellpadding="0" cellspacing="0">
                    <tbody>
                        <tr>
                            <td style="width: 3%">
                                &nbsp;
                            </td>
                            <td class="lable">
                                名&nbsp;&nbsp;称<b>*</b>
                            </td>
                            <td class="inputText">
                                <input type="text" name="rule_name" must="1" value="<%=rule.rule_name%>" class="input"
                                    style="width: 320px" />
                            </td>
                            <td class="lable">
                                优 先 级<b>*</b>
                            </td>
                            <td class="inputText">
                                <input type="text" name="priority_level" must="1" value="<%=rule.priority_level%>" class="input"
                                    style="width: 60px" />
                                &nbsp;&nbsp; <span style="color: #999">数值越大，权重越高</span>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 3%">
                                &nbsp;
                            </td>
                            <td colspan="4" style="color: #999">
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 3%">
                                &nbsp;
                            </td>
                            <td class="lable">
                                title<b>*</b>
                            </td>
                            <td colspan="3">
                                <input type="text" name="title" must="1" value="<%=rule.title%>" class="input" style="width: 630px;" />
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 3%">
                                &nbsp;
                            </td>
                            <td class="lable">
                                keywords<b>*</b>
                            </td>
                            <td colspan="3">
                                <input type="text" name="keywords" must="1" value="<%=rule.keywords%>" class="input"
                                    style="width: 630px;" />
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 3%">
                                &nbsp;
                            </td>
                            <td class="lable">
                                description<b>*</b>
                            </td>
                            <td colspan="3">
                                <textarea name="description" must="1" style="width: 630px; height: 60px;"><%=rule.description%> </textarea>
                            </td>
                        </tr>
                    </tbody>
                </table>
                </form>
                <br />
                <table class="table" cellpadding="0" cellspacing="0">
                    <thead>
                        <tr>
                            <th style="width: 42%">
                                &nbsp;
                            </th>
                            <th class="lable">
                                <input type="button" id="loadding3" value="  确定提交  " onclick="$('#SeoHomeRuleForm').submit()"
                                    class="submit" style="width: 120px" />
                            </th>
                            <th>
                                <div class="tips-text" id="tips-message">
                                </div>
                            </th>
                        </tr>
                    </thead>
                </table>
                <br />
                <br />
                <br />
                <br />
            </div>
        </div>
    </div>
    <br />
    <br />
    <script type="text/javascript">
        function submitHomeSeoRuleForm(form) {
            var isError = false;
            $("input[must='1']").each(function () {
                if ($(this).val() == "" && !$(this).attr("disabled")) {
                    isError = true;
                }
            });
            if (isError) {
                jsbox.error("请完成所有必填项的填写"); return false;
            }
            if (showLoadding) showLoadding();

            var postData = getPostDB(form);

            $.ajax({
                url: "/MGoods/PostHomeSeoRule"
		, data: postData
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
            return false;
        }
    </script>
    <%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>

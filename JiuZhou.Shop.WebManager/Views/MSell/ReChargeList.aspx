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
                <a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>充值列表</span>
            </div>
            <form action="/msell/ReChargeList" method="get" onsubmit="checksearch(this)">
                <input type="hidden" name="size" value="<%=DoRequest.GetQueryInt("size", 100)%>" />
                <div class="div-tab-h1" style="font-weight: 100; color: #333; font-size: 12px">
                    <p>
                    </p>
                    <p>
                        <input type="text" id="sQuery" name="q" value="<%=DoRequest.GetQueryString("q")%>" class="input" autocomplete="off" style="width: 390px; height: 24px; line-height: 24px;" />
                    </p>
                    <p>
                        <input type="submit" value=" 搜索 " class="submit" />&nbsp;&nbsp;
                    </p>
                </div>
            </form>
            <script type="text/javascript">
                var qInitValue = "请输入关键词";
                Atai.addEvent(window, "load", function () {
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
                function checksearch(form) {
                    var sQuery = Atai.$("#sQuery");
                    if (sQuery.value == qInitValue) {
                        sQuery.value = "";
                    }
                }
                var _currUrl = "<%=ViewData["currPageUrl"]%>";
                function formatUrl(ocol, val, url) {
                    if (!url) url = _currUrl;
                    var reg = ocol + "=[^-]*";
                    var reg = new RegExp(ocol + "=[^&\.]*");
                    url = url.replace(reg, ocol + "=" + val);
                    return url;
                }
                var changeOrderBy = function (ocol, ot) {
                    _currUrl = formatUrl("ocol", ocol);
                    url = formatUrl("ot", ot);
                    window.location.href = url;
                };
            </script>
            <%string otype = DoRequest.GetQueryString("ot").ToLower().Trim();
            %>
            <%=ViewData["pageIndexLink"]%>
            <form id="post-form" method="post" action="">
                <table id="tab-category" class="table" cellpadding="0" cellspacing="0">
                    <thead>
                        <tr>
                            <th>充值序列号</th>
                            <th style="width: 10%">添加时间</th>
                            <th style="width: 10%">充值/使用</th>
                            <th style="width: 10%">支付状态</th>
                            <th style="width: 14%">金额</th>
                            <th style="width: 10%">支付类型</th>
                            <th style="width: 10%">用户ID</th>
                            <th style="width: 10%">充值时间</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<RechargeInfo> infoList = (List<RechargeInfo>)ViewData["infoList"];
                            foreach (RechargeInfo item in infoList)
                            {
                               // DateTime addTime = DateTime.Parse(item.create_time);
                        %>
                        <tr>
                              <td>
                                <%=item.serialno %></td>
                            <td>
                                <%=item.add_time %></td>
                            <td>
                            <%=(item.serialno.Substring(0,2)=="cp")?"  充值":"虚拟支付" %> </td>
                                 <td>
                              <%=(item.serialno.Substring(0,2)=="cp")?(item.pay_state=="1"?"已充值":"未充值"):"---" %></td>
                            <td><%=item.total_money %>
                            </td>
                            <td><%=item.pay_type %></td>
                            <td><%=item.user_id %></td>
                            <td>
                                <%=item.pay_time %>
                            </td>
                        </tr>
                        <%}
                        %>
                    </tbody>
                </table>
            </form>
            <%=ViewData["pageIndexLink2"]%>
            <div class="console">

            </div>
            <br />
            <br />
            <br />
            <br />
        </div>

    </div>
    <br />
    <br />
    <br />
    <br />
    <br />
    <%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>

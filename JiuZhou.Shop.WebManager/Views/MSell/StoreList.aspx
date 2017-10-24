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
                <a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>门店列表</span>
            </div>
            <form action="/msell/StoreList" method="get" onsubmit="checksearch(this)">
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
                            <th style="width: 3%">
                                <input type="checkbox" onclick="checkAll(this.form, this)" name="chkall" title="选中/取消选中" /></th>
                            <th>门店名称</th>
                            <th>门店URL</th>
                            <th style="width: 14%">添加时间</th>
                            <th style="width: 10%">操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<StoreInfo> infoList = (List<StoreInfo>)ViewData["infoList"];
                            foreach (StoreInfo item in infoList)
                            {
                                DateTime addTime = DateTime.Parse(item.create_time);
                        %>
                        <tr>
                            <td>
                                <input type="checkbox" onclick="selectOne(this)" name="visitid" value="<%=item.store_id%>" /></td>
                            <td><a href="/msell/Storeeditor?id=<%=item.store_id%>" arget="_blank"><%=item.store_name %></a>
                            </td>
                            <td>http://m.dada360.com/activity/20170828/activity.jsp?key=<%=item.store_id%></td>
                            <td><%=addTime.ToString("yyyy-MM-dd HH:mm")%></td>
                            <td>
                                <a href="/msell/QRcodeStore?key=<%=item.store_id%>" target="_blank">下载二维码</a>
                                &nbsp;
                                <a href="javascript:;" onclick="return deleteList(<%=item.store_id%>)">删除</a>
                            </td>
                        </tr>
                        <%}
                        %>
                    </tbody>
                </table>
            </form>
            <%=ViewData["pageIndexLink2"]%>
            <div class="console">
                <a href="javascript:;" onclick="deleteList(Atai.$('#post-form'), 0)">批量删除</a>
                <a href="/msell/Storeeditor?id=0">新增</a>
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
    <script type="text/javascript">
        function deleteList(form) {
            var postData = "";
            if (Atai.isInt(form)) {
                postData = "visitid=" + form;
            } else {
                postData = getPostDB(form);
            }
            jsbox.confirm('您确定要删除这些数据吗？', function () {
                $.ajax({
                    url: "/MSell/RemoveStoreList"
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

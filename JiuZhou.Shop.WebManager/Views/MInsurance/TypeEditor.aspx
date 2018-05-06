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
    <title><%=ViewData["pageTitle"]%></title>
    <link href="/style/style.css" rel="stylesheet" type="text/css" />

</head>
<body>
    <%Html.RenderPartial("Base/_SimplePageTopControl"); %>
    <%
        ConfigInfo config = (ConfigInfo)(ViewData["config"]);
         InsuranceList insurancelist = new InsuranceList();
        var respPt = GetInsuranceList.Do();
        if (respPt == null || respPt.Body == null)
        {
            insurancelist = new InsuranceList();
        }
        else
        {
            insurancelist = respPt.Body;
        }
        InsurancetypeInfo Info = new InsurancetypeInfo();
        int id = DoRequest.GetQueryInt("id",0);
          int insurancetype = DoRequest.GetQueryInt("insurancetype");
        var resp = GetInsusertype.Do(id);
        if (resp == null || resp.Body == null)
        {
            Info = new InsurancetypeInfo();
        }
        else
        {
            Info = resp.Body;
        }
    %>
    <script type="text/javascript">$(function () { document.title = "商保编辑|九洲"; });</script>
    <div id="container-syscp">
        <div class="container-left">
            <%Html.RenderPartial("Base/LeftControl"); %>
        </div>
        <div class="container-right">
            <div class="editor-box-head">
                商保用户类别编辑
            </div>
            <form method="post" action="" onsubmit="return submitForm(this)">
                <input type="hidden" name="id" value="<%=Info.id%>" />
                <div class="div-tab">
                    <table id="tab-category" class="table" cellpadding="0" cellspacing="0">
                        <thead>
                            <tr style="display: none">
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">商保用户类别<b>*</b></td>
                                <td class="inputText" colspan="2">
                                    <input type="text" name="usertype" value="<%=Info.usertype%>" class="input" style="width: 520px" />
                                    &nbsp;&nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable" valign="top">商保名称</td>
                                <td colspan="2" class="inputText">
                                    <input type="text" name="insurancetypename" disabled="disabled" value="<%=insurancelist.insurance_list.FirstOrDefault(t=>t.insurance_id==insurancetype).insurance_name %>" class="input" style="width: 520px" />
                                           <input  name="insurancetype" type="hidden" value="<%=insurancetype%>"  />
                                   <%-- <select name="paytype">                                                                               
                                        <%if (insurance_id == 0) {%>
                                         <%foreach (var item in ptlistinfo.pay_type_list){%>
                                        <option value="<%=item.pay_type_id %>" ><%=item.pay_type_name %></option>
                                        <% }%>
                                        <%}else { %>
                                         <%foreach (var item in ptlistinfo.pay_type_list){%>
                                        <option value="<%=item.pay_type_id %>"   <%=(Info.paytype==item.pay_type_id)?"selected=\"selected\"":""%> ><%=item.pay_type_name %></option>
                                        <% }%>
                                        <%} %>
                                    </select>--%>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">&nbsp;</td>
                                <td colspan="2">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr>
                                            <td style="width: 160px">
                                                <input type="submit" value="  确定提交  " class="submit" /></td>
                                            <td>
                                                <div class="tips-text" id="tips-message"></div>
                                            </td>
                                        </tr>
                                    </table>

                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </form>
            <br />
            <br />
            <br />
            <br />
        </div>
    </div>
    <br />
    <br />
    <script type="text/javascript">
        Atai.addEvent(window, "click", function () {
            $("#tips-message").removeClass("tips-icon").html("");
        });
        function submitForm(form) {
            if (showLoadding) showLoadding();
            var postData = getPostDB(form);
            $.ajax({
                url: "/MInsurance/PostInsuranceTypeData"
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

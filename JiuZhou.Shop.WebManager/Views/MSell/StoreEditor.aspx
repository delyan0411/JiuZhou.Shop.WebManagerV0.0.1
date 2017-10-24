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
    <script type="text/javascript" src="/ckeditor/ckeditor.js" charset="utf-8"></script>
    <style>
        #db-images {
        }

            #db-images dt {
                float: left;
                width: 152px;
                height: auto;
                text-align: center;
            }

                #db-images dt div {
                    color: #999;
                    height: 146px;
                    line-height: 18px;
                    width: 142px;
                    overflow: hidden;
                    margin: 0 auto;
                    cursor: pointer;
                    border: #E8E8E8 1px solid;
                    text-align: center;
                }

            #db-images .hover div {
                border: #ff6600 1px solid;
            }

            #db-images dt .op a {
                color: #060;
            }

            #db-images .hover .op .sdef {
                color: #999;
            }

            #db-images dt a {
                color: #00F;
            }

            #db-images dt img {
                height: 140px;
                width: 140px;
            }
    </style>

</head>
<body>
    <%Html.RenderPartial("Base/_SimplePageTopControl"); %>
    <%
        ConfigInfo config = (ConfigInfo)(ViewData["config"]);
        int id = DoRequest.GetQueryInt("id");
        StoreInfo Info = new StoreInfo();
        var resinfo = GetStoreInfo.Do(id);
        if (resinfo != null && resinfo.Body != null)
            Info = resinfo.Body;
    %>
    <script type="text/javascript">$(function () { document.title = "<%=string.IsNullOrEmpty(Info.store_name)?"":(Info.store_name + "|" )%>信息编辑|九洲"; });</script>
    <div id="container-syscp">
        <div class="container-left">
            <%Html.RenderPartial("Base/LeftControl"); %>
        </div>
        <div class="container-right">
            <div class="editor-box-head">
                信息编辑
            </div>
            <form method="post" action="" onsubmit="return submitForm(this)">
          
                <input type="hidden" name="id" value="<%=Info.store_id%>" />
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
                                <td class="lable">门店名称<b>*</b></td>
                                <td class="inputText" colspan="2">
                                    <input type="text" name="store_name" value="<%=Info.store_name%>" class="input" style="width: 520px" />                                 
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
                url: "/Msell/PostStoreData"
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

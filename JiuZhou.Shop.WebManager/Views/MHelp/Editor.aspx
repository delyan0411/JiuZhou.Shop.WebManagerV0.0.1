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
        UpLoadFile upload = new UpLoadFile(false);
        string uploadRoot = upload.GetUploadRoot.StartsWith("/") ? upload.GetUploadRoot.Substring(1) : upload.GetUploadRoot;
        string imageRootUrl = config.UrlImages + uploadRoot;

        List<HelpTypeInfo> tList = new List<HelpTypeInfo>();
        var restype = GetHelpType.Do(0, 2, -1);
        if (restype != null && restype.Body != null && restype.Body.help_type_list != null)
            tList = restype.Body.help_type_list;
        int classId = DoRequest.GetQueryInt("classid");
        int id = DoRequest.GetQueryInt("typeid");
        HelpInfo Info = new HelpInfo();
        var resinfo = GetHelpInfo.Do(id);
        if (resinfo != null && resinfo.Body != null)
            Info = resinfo.Body;
        string _path = "";
        foreach (HelpTypeInfo em in tList)
        {
            if (em.help_type_id == Info.help_type_id)
                _path = em.type_path;
        }
        string[] _tem = _path.Split(',');
        string clsName = "";
        int _xCount = 0;
        for (int x = 0; x < _tem.Length; x++)
        {
            if (string.IsNullOrEmpty(_tem[x].Trim())) continue;
            int _v = Utils.StrToInt(_tem[x].Trim());
            foreach (HelpTypeInfo item in tList)
            {
                if (item.help_type_id == _v)
                {
                    if (_xCount > 0) clsName += " &gt;&gt; ";
                    clsName += item.type_name;
                    _xCount++;
                }
            }
        }
    %>
    <script type="text/javascript">$(function () { document.title = "<%=string.IsNullOrEmpty(Info.help_title)?"":(Info.help_title + "|" )%>信息编辑|九洲"; });</script>
    <div id="container-syscp">
        <div class="container-left">
            <%Html.RenderPartial("Base/LeftControl"); %>
        </div>
        <div class="container-right">
            <div class="editor-box-head">
                信息编辑
            </div>
            <form method="post" action="" onsubmit="return submitForm(this)">
                <input type="hidden" name="id" value="<%=Info.help_id%>" />
                <input type="hidden" id="ClassID" name="ClassID" value="<%=Info.help_type_id%>" />
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
                                <td class="lable">分&nbsp;&nbsp;类<b>*</b></td>
                                <td class="inputText" colspan="2">
                                    <input type="text" id="showClassID" value="<%=clsName%>" class="input" onclick="selectCategBox(event, 'ClassID', 'showClassID')" readonly="readonly" style="cursor: pointer" />
                                    <input type="button" class="view-file" value="选择..." onclick="selectCategBox(event, 'ClassID', 'showClassID')" title="选择分类" />
                                    &nbsp;&nbsp;
    关键词
                                    <input type="text" name="keyword" value="<%=Info.key_word%>" class="input" style="width: 140px" />
                                    &nbsp;
    作者
                                    <input type="text" name="author" value="<%=Info.author_name%>" class="input" style="width: 100px" />
                                </td>
                            </tr>

                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">标&nbsp;&nbsp;题<b>*</b></td>
                                <td class="inputText" colspan="2">
                                    <input type="text" name="title" value="<%=Info.help_title%>" class="input" style="width: 520px" />
                                    &nbsp;&nbsp;
    点击量
                                    <input type="text" name="clickcount" value="<%=Info.click_count%>" class="input" style="width: 50px" />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable" valign="top">摘要</td>
                                <td colspan="2" class="inputText">
                                    <textarea name="summary" class="textarea" style="height: 80px"><%=Info.help_summary%></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable" valign="top">内容<b>*</b></td>
                                <td colspan="2">
                                    <textarea id="detailContents" name="content" style="height: 160px"><%=Info.help_content%></textarea>
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

        var ckeditor = null;
        $(function () {
            ckeditor = CKEDITOR.replace('detailContents');
        });
        function setImage(path, fullPath) {
            var html = '<img src="' + fullPath + '"/>';
            CKEDITOR.instances.detailContents.insertHtml(html);
        }
        function setImage2(obj, path, fullPath) {
            setImage(path, fullPath);
        }
        function _fckCallback() {
            showImageListBox(setImage);
        }
        function _fckAddPicCallback() {
            upload(new Object(), setImage2);
        }
    </script>
    <script type="text/javascript">
        Atai.addEvent(window, "click", function () {
            $("#tips-message").removeClass("tips-icon").html("");
        });
        function submitForm(form) {
            if (showLoadding) showLoadding();
            $("#detailContents").val(CKEDITOR.instances.detailContents.getData())
            var postData = getPostDB(form);
            $.ajax({
                url: "/MHelp/PostHelpData"
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
    <%Html.RenderPartial("UploadBaseControl"); %>
    <%Html.RenderPartial("UploadImageControl"); %>
    <%Html.RenderPartial("ImageListBoxControl");//图片选择 %>
    <%Html.RenderPartial("MHelp/SelectCategControl"); %>
    <%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>

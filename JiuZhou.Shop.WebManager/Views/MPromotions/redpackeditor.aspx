<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="JiuZhou.Model" %>
<%@ Import Namespace="JiuZhou.Common" %>
<%@ Import Namespace="JiuZhou.MySql" %>
<%@ Import Namespace="JiuZhou.HttpTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script type="text/javascript" src="/ckeditor/ckeditor.js" charset="utf-8"></script>
    <link href="/style/style.css" rel="stylesheet" type="text/css" />
    <%Html.RenderPartial("Base/_PageHeadControl"); %>
    <title>
        <%=ViewData["pageTitle"]%></title>
    <style type="text/css">
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
    </style>
</head>
<body>
    <%Html.RenderPartial("Base/_SimplePageTopControl"); %>
    <%
        ConfigInfo config = (ConfigInfo)(ViewData["config"]);
        int redpack_rule_id = DoRequest.GetQueryInt("redpack_rule_id");
        RedPackInfo Info = null;
        var resp = GetRedPackInfo.Do(redpack_rule_id);
        if (resp == null || resp.Body == null)
        {
            Info = new RedPackInfo();
        }
        else
        {
            Info = resp.Body;
        }
    %>
    <div id="container-syscp">
        <div class="container-left">
            <%Html.RenderPartial("Base/LeftControl"); %>
        </div>
        <div class="container-right">
            <div class="editor-box-head" style="position: relative">
                编辑红包规则
            </div>
            <div class="div-tab">
                <form id="redpackForm" method="post" action="" onsubmit="return submitRedPackForm(this)">
                <input type="hidden" name="redpack_rule_id" value="<%=redpack_rule_id%>" />
                <table class="table" cellpadding="0" cellspacing="0">
                    <thead>
                    </thead>
                    <tbody>
                        <tr>
                            <td style="width: 3%">
                                &nbsp;
                            </td>
                            <td class="lable">
                                主&nbsp;&nbsp;题<b>*</b>
                            </td>
                            <td class="inputText">
                                <input type="text" name="title" must="1" value="<%=Info.title%>" class="input"
                                    style="width: 320px" />
                            </td>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 3%">
                                &nbsp;
                            </td>
                            <td class="lable">
                                红包总金额<b>*</b>
                            </td>
                            <td class="inputText">
                                 <input type="text" name="sum_money" id="sum_money" must="1" value="<%=Info.sum_money%>" class="input"
                                    style="width: 320px" />
                            </td>
                            <script type="text/javascript">
                                Atai.addEvent(window, "load", function () {
                                    var summon = Atai.$("#sum_money");
                                    var tips = Atai.$("#tips-summoney");
                                    Atai.addEvent(summon, "blur", function () {
                                        if (!Atai.isInt(this.value)) {
                                            tips.className = "tips-icon";
                                            //tips.innerHTML = " 请填写正确的金额";
                                        }
                                    });
                                });
                                </script>
                             <td>
                                <div class="tips-text" id="tips-summoney">
                                    &nbsp;</div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 3%">
                                &nbsp;
                            </td>
                            <td class="lable">
                                开始时间<b>*</b>
                            </td>
                            <td class="inputText">
                                <input type="text" id="box-sdate" name="sdate" value="<%=Info.start_time==null?DateTime.Now.ToString("yyyy-MM-dd"):DateTime.Parse(Info.start_time).ToString("yyyy-MM-dd")%>"
                                    readonly="readonly" class="date" onclick="WdatePicker()" must="1" />
                                <input type="text" id="box-shours" name="shours" value="<%=Info.start_time==null?"00":DateTime.Parse(Info.start_time).Hour.ToString()%>"
                                    class="input" style="width: 30px" title="数字0至23" must="1" />
                                时
                                <input type="text" id="box-sminutes" name="sminutes" value="<%=Info.start_time==null?"00":DateTime.Parse(Info.start_time).Minute.ToString()%>"
                                    class="input" style="width: 30px" title="数字0至59" must="1" />
                                分
                                <script type="text/javascript">
                                    Atai.addEvent(window, "load", function () {
                                        var hBox = Atai.$("#box-shours");
                                        var mBox = Atai.$("#box-sminutes");
                                        var tips = Atai.$("#tips-starttime");
                                        Atai.addEvent(hBox, "blur", function () {
                                            if (!Atai.isInt(this.value) || parseInt(this.value) < 0 || parseInt(this.value) > 23) {
                                                tips.className = "tips-icon";
                                                tips.innerHTML = " [时] 请填写0至23之间的数字";
                                            }
                                        });
                                        Atai.addEvent(mBox, "blur", function () {
                                            if (!Atai.isInt(this.value) || parseInt(this.value) < 0 || parseInt(this.value) > 59) {
                                                tips.className = "tips-icon";
                                                tips.innerHTML = " [分] 请填写0至59之间的数字";
                                            }
                                        });
                                        Atai.addEvent(hBox, "keyup", function () {
                                            if (Atai.isInt(this.value) && parseInt(this.value) >= 0 && parseInt(this.value) < 24) {
                                                tips.className = "tips-text"; tips.innerHTML = "";
                                            }
                                        });
                                        Atai.addEvent(mBox, "keyup", function () {
                                            if (Atai.isInt(this.value) && parseInt(this.value) >= 0 && parseInt(this.value) < 60) {
                                                tips.className = "tips-text"; tips.innerHTML = "";
                                            }
                                        });
                                    });
                                </script>
                            </td>
                            <td>
                                <div class="tips-text" id="tips-starttime">
                                    &nbsp;</div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 3%">
                                &nbsp;
                            </td>
                            <td class="lable">
                                结束时间<b>*</b>
                            </td>
                            <td class="inputText">
                                <input type="text" id="box-edate" name="edate" value="<%=Info.end_time==null?DateTime.Now.AddDays(7).ToString("yyyy-MM-dd"):DateTime.Parse(Info.end_time).ToString("yyyy-MM-dd")%>"
                                    readonly="readonly" class="date" onclick="WdatePicker()" must="1" />
                                <input type="text" id="box-ehours" name="ehours" value="<%=Info.end_time==null?"23":DateTime.Parse(Info.end_time).Hour.ToString()%>"
                                    class="input" style="width: 30px" title="数字0至23" must="1" />
                                时
                                <input type="text" id="box-eminutes" name="eminutes" value="<%=Info.end_time==null?"59":DateTime.Parse(Info.end_time).Minute.ToString()%>"
                                    class="input" style="width: 30px" title="数字0至59" must="1" />
                                分
                                <script type="text/javascript">
                                    Atai.addEvent(window, "load", function () {
                                        var hBox = Atai.$("#box-ehours");
                                        var mBox = Atai.$("#box-eminutes");
                                        var tips = Atai.$("#tips-endtime");
                                        Atai.addEvent(hBox, "blur", function () {
                                            if (!Atai.isInt(this.value) || parseInt(this.value) < 0 || parseInt(this.value) > 23) {
                                                tips.className = "tips-icon";
                                                tips.innerHTML = " [时] 请填写0至23之间的数字";
                                            }
                                        });
                                        Atai.addEvent(mBox, "blur", function () {
                                            if (!Atai.isInt(this.value) || parseInt(this.value) < 0 || parseInt(this.value) > 59) {
                                                tips.className = "tips-icon";
                                                tips.innerHTML = " [分] 请填写0至59之间的数字";
                                            }
                                        });
                                        Atai.addEvent(hBox, "keyup", function () {
                                            if (Atai.isInt(this.value) && parseInt(this.value) >= 0 && parseInt(this.value) < 24) {
                                                tips.className = "tips-text"; tips.innerHTML = "";
                                            }
                                        });
                                        Atai.addEvent(mBox, "keyup", function () {
                                            if (Atai.isInt(this.value) && parseInt(this.value) >= 0 && parseInt(this.value) < 60) {
                                                tips.className = "tips-text"; tips.innerHTML = "";
                                            }
                                        });
                                    });
                                </script>
                            </td>
                            <td>
                                <div class="tips-text" id="tips-endtime">
                                    &nbsp;</div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 3%">
                                &nbsp;
                            </td>
                            <td class="lable">
                                效期<b>*</b>
                            </td>
                            <td class="inputText">
                                <input type="text" id="box-vdate" name="vdate" value="<%=Info.valid_time==null?DateTime.Now.AddDays(14).ToString("yyyy-MM-dd"):DateTime.Parse(Info.valid_time).ToString("yyyy-MM-dd")%>"
                                    readonly="readonly" class="date" onclick="WdatePicker()"  must="1"/>
                                <input type="text" id="box-vhours" name="vhours" value="<%=Info.valid_time==null?"23":DateTime.Parse(Info.valid_time).Hour.ToString()%>"
                                    class="input" style="width: 30px" title="数字0至23" must="1" />
                                时
                                <input type="text" id="box-vminutes" name="vminutes" value="<%=Info.valid_time==null?"59":DateTime.Parse(Info.valid_time).Minute.ToString()%>"
                                    class="input" style="width: 30px" title="数字0至59" must="1" />
                                分
                                <script type="text/javascript">
                                    Atai.addEvent(window, "load", function () {
                                        var hBox = Atai.$("#box-vhours");
                                        var mBox = Atai.$("#box-vminutes");
                                        var tips = Atai.$("#tips-validtime");
                                        Atai.addEvent(hBox, "blur", function () {
                                            if (!Atai.isInt(this.value) || parseInt(this.value) < 0 || parseInt(this.value) > 23) {
                                                tips.className = "tips-icon";
                                                tips.innerHTML = " [时] 请填写0至23之间的数字";
                                            }
                                        });
                                        Atai.addEvent(mBox, "blur", function () {
                                            if (!Atai.isInt(this.value) || parseInt(this.value) < 0 || parseInt(this.value) > 59) {
                                                tips.className = "tips-icon";
                                                tips.innerHTML = " [分] 请填写0至59之间的数字";
                                            }
                                        });
                                        Atai.addEvent(hBox, "keyup", function () {
                                            if (Atai.isInt(this.value) && parseInt(this.value) >= 0 && parseInt(this.value) < 24) {
                                                tips.className = "tips-text"; tips.innerHTML = "";
                                            }
                                        });
                                        Atai.addEvent(mBox, "keyup", function () {
                                            if (Atai.isInt(this.value) && parseInt(this.value) >= 0 && parseInt(this.value) < 60) {
                                                tips.className = "tips-text"; tips.innerHTML = "";
                                            }
                                        });
                                    });
                                </script>
                            </td>
                            <td>
                                <div class="tips-text" id="tips-validtime">
                                    &nbsp;</div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 3%">
                                &nbsp;
                            </td>
                            <td class="lable">
                                红包最大额度<b>*</b>
                            </td>
                            <td class="inputText" >
                                 <input type="text" name="pack_money_max" id="pack_money_max" must="1" value="<%=Info.pack_money_max%>" class="input"
                                    style="width: 320px" />
                            </td>
                             <script type="text/javascript">
                                 Atai.addEvent(window, "load", function () {
                                     var summon = Atai.$("#pack_money_max");
                                     var tips = Atai.$("#tips-packmoneymax");
                                     Atai.addEvent(summon, "blur", function () {
                                         if (!Atai.isInt(this.value)) {
                                             tips.className = "tips-icon";
                                             //tips.innerHTML = " 请填写正确的金额";
                                         }
                                     });
                                 });
                                </script>
                             <td>
                                <div class="tips-text" id="tips-packmoneymax">
                                    &nbsp;</div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 3%">
                                &nbsp;
                            </td>
                            <td class="lable">
                                红包最小额度<b>*</b>
                            </td>
                            <td class="inputText" >
                                 <input type="text" name="pack_money_min" id="pack_money_min"  must="1" value="<%=Info.pack_money_min%>" class="input"
                                    style="width: 320px" />
                            </td>
                             <script type="text/javascript">
                                 Atai.addEvent(window, "load", function () {
                                     var summon = Atai.$("#pack_money_min");
                                     var tips = Atai.$("#tips-packmoneymin");
                                     Atai.addEvent(summon, "blur", function () {
                                         if (!Atai.isInt(this.value)) {
                                             tips.className = "tips-icon";
                                             //tips.innerHTML = " 请填写正确的金额";
                                         }
                                     });
                                 });
                                </script>
                             <td>
                                <div class="tips-text" id="tips-packmoneymin">
                                    &nbsp;</div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 3%">
                                &nbsp;
                            </td>
                            <td class="lable">
                                红包数量<b>*</b>
                            </td>
                            <td class="inputText" >
                                 <input type="text" name="pack_numsum" id="pack_numsum" must="1" value="<%=Info.pack_numsum%>" class="input"
                                    style="width: 320px" />
                            </td>
                             <script type="text/javascript">
                                 Atai.addEvent(window, "load", function () {
                                     var summon = Atai.$("#pack_numsum");
                                     var tips = Atai.$("#tips-packnumsum");
                                     Atai.addEvent(summon, "blur", function () {
                                         if (!Atai.isInt(this.value)) {
                                             tips.className = "tips-icon";
                                             tips.innerHTML = " 请填写数字";
                                         }
                                     });
                                 });
                                </script>
                             <td>
                                <div class="tips-text" id="tips-packnumsum">
                                    &nbsp;</div>
                            </td>
                        </tr>
                    </tbody>
                </table>
                </form>
                <table class="table" cellpadding="0" cellspacing="0">
                    <thead>
                        <tr>
                            <th style="width: 42%">
                                &nbsp;
                            </th>
                            <th class="lable">
                                <input type="button" id="loadding3" value="  确定提交  " onclick="$('#redpackForm').submit()"
                                    class="submit" style="width: 120px" />
                            </th>
                            <th>
                                <div class="tips-text" id="tips-message">
                                </div>
                            </th>
                        </tr>
                    </thead>
                </table>
            </div>
            <br />
            <br />
            <br />
            <br />
        </div>
    </div>
    <br />
    <br />
    <script type="text/javascript">        
        function submitRedPackForm(form) {
            var isError = false;
            $("input[must='1']").each(function () {
                if ($(this).val() == "" && !$(this).attr("disabled")) {
                    isError = true;
                }
            });
            if (isError) {
                jsbox.error("请完成所有必填项的正确填写"); return false;
            }
            if (showLoadding) showLoadding();
            var postData = getPostDB(form);
            console.log(postData);
            $.ajax({
                url: "/Mpromotions/PostRedPack"
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

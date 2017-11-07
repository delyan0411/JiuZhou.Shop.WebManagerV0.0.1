<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="JiuZhou.Model" %>
<%@ Import Namespace="JiuZhou.Cache" %>
<%@ Import Namespace="JiuZhou.Common" %>
<%@ Import Namespace="JiuZhou.MySql" %>
<%@ Import Namespace="JiuZhou.HttpTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
    int tid = DoRequest.GetQueryInt("tid");
    STopicDetails Info = new STopicDetails();
    DoCache cache = new DoCache();
    if (cache.GetCache("stopic-GetTopicDetails" + tid) == null)
    {
        var resst = GetTopicDetails.Do(tid);
        if (resst != null && resst.Body != null)
        {
            Info = resst.Body;
            cache.SetCache("stopic-GetTopicDetails" + tid, Info);
        }
    }
    else
    {
        Info = (STopicDetails)cache.GetCache("stopic-GetTopicDetails" + tid);
    }

    bool is11_11 = false;
    if (Info.st_summary != null && !Info.st_summary.Equals(""))
    {
        if (Info.st_summary.Trim().StartsWith("{11.11}"))
        {
            is11_11 = true;
        }
    }
%>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script type="text/javascript" src="/javascript/v1.2/jquery.js"></script>
    <script type="text/javascript" src="/javascript/v1.2/jquery.lazyload.js" charset="utf-8"></script>
    <script type="text/javascript" src="/javascript/v1.2/AtaiJs-1.2.js" charset="utf-8"></script>
    <script type="text/javascript" src="/javascript/v1.2/jscode2.js?id=1.6.0.1" charset="utf-8"></script>
    <link href="/style/v1.2/base2.css" type="text/css" rel="stylesheet" />
    <link href="<%=config.UrlHome%>favicon.ico" type="image/x-icon" rel="shortcut icon" />
    <%
        if (is11_11)
        {
            Response.Write("<link href=\"/style/shop2014.11.11.css\" type=\"text/css\" rel=\"stylesheet\"/>");
        }
    %>
    <link href="/style/dect.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="/ckeditor/ckeditor.js" charset="utf-8"></script>
    <script language="javascript" type="text/javascript" src="/javascript/JSCal/WdatePicker.js"></script>
    <script type="text/javascript" src="/javascript/ajax-upload.js" charset="utf-8"></script>
    <script type="text/javascript" src="/javascript/UI/list2.js" charset="utf-8"></script>
    <link href="/javascript/UI/style2.css" type="text/css" rel="stylesheet" />
    <link href="/javascript/UI/list_style2.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="/javascript/dectBase.js" charset="utf-8"></script>
    <script type="text/javascript" src="/SuperSlide/jquery.SuperSlide.js"></script>
    <style>
        .head .head-line-nbsp {
            display: none;
        }

        .head .head-line-bg {
            position: relative;
            left: 0;
            top: 1px;
            z-index: 6;
            _top: 0;
        }

        .slideBox {
            width: 100%;
            overflow: hidden;
            position: relative;
        }

            .slideBox .hd {
                height: 15px;
                overflow: hidden;
                position: absolute;
                right: 10px;
                bottom: 10px;
                z-index: 1;
            }

                .slideBox .hd ul {
                    overflow: hidden;
                    zoom: 1;
                    float: left;
                }

                    .slideBox .hd ul li {
                        float: left;
                        margin-right: 5px;
                        width: 15px;
                        height: 15px;
                        line-height: 14px;
                        text-align: center;
                        background: #fff;
                        cursor: pointer;
                    }

                        .slideBox .hd ul li.on {
                            background: #f00;
                            color: #fff;
                        }

            .slideBox .bd {
                position: relative;
                height: 100%;
                z-index: 0;
            }

                .slideBox .bd img {
                    width: 100%;
                }

        .sn-simple-logo {
            position: absolute;
        }
    </style>
    <style>
        <%=Info.style_text%>
    </style>
    <title>专题装修/专题列表|九洲</title>
</head>
<body>
    <%Html.RenderPartial("Template/PageTopControl"); %>
    <div id="jz-zt-container">
        <%--模块内容开始--%>
        <%
            List<STModuleInfo> infoList = Info.topic_module_list;
            if (infoList == null)
                infoList = new List<STModuleInfo>();
            foreach (STModuleInfo item in infoList)
            {
                string style = item.is_full_screen.Equals("1") ? "" : "";
        %>
        <div id="module-<%=item.st_module_id%>" class="jz-zt-module<%=style%>" value="<%=item.st_module_id%>">
            <div class="module-op">
                <div class="module-op-bg">
                </div>
                <div class="module-op-link">
                    <a href="javascript:void(0);" class="remove" onclick="moduleRemove('<%=Info.st_id%>','<%=item.st_module_id%>')"
                        title="删除模块">&nbsp;删除&nbsp;</a> &nbsp;&nbsp;&nbsp; <span class="move-links remove"><a
                            href="javascript:void(0);" onclick="moduleMove('<%=item.st_module_id%>','first');"
                            class="move-first" title="置顶">&nbsp;</a> <a href="javascript:void(0);" onclick="moduleMove('<%=item.st_module_id%>','up');"
                                class="move-up" title="上移">&nbsp;</a> <a href="javascript:void(0);" onclick="moduleMove('<%=item.st_module_id%>','down');"
                                    class="move-down" title="下移">&nbsp;</a> <a href="javascript:void(0);" onclick="moduleMove('<%=item.st_module_id%>','last');"
                                        class="move-last" title="最末">&nbsp;</a> </span>&nbsp;&nbsp;&nbsp;
                    <a href="javascript:void(0);" class="remove" onclick="moduleModify('<%=item.st_module_id%>','<%=item.module_type%>')"
                        title="编辑模块数据">&nbsp;编辑&nbsp;</a> &nbsp;&nbsp;&nbsp; <a href="javascript:void(0);"
                            class="remove" onclick="moduleAdd(event,$('#module-<%=item.st_module_id%>'))"
                            title="新增模块">&nbsp;新增模块&nbsp;</a>
                </div>
            </div>
            <div class="module-hd" style="display: <%=item.allow_show_name.Equals("1")?"block":"none"%>">
                <h3>
                    <b>@</b><%=item.module_name%></h3>
                <div>
                    <%=item.module_desc%>
                </div>
                <a onclick="sGoto(e,'jz-zt-container')"></a>
            </div>
            <%if (item.module_type != 5)
                {
            %>
            <div class="module-bd">
                <%}
                    else
                    { %>
                <div class="module-bd" style="width: 100%">
                    <%}%>
                    <%if (item.module_type == 0)
                        {%>
                    <%=string.IsNullOrEmpty(item.module_content)?"此处填写模块内容":item.module_content%>
                    <%}
                        else if (item.module_type == 5)
                        {
                    %>
                    <div style="overflow: hidden;">

                        <% 
                            if (!string.IsNullOrEmpty(item.allow_show_name) && item.allow_show_name != "0")
                            {
                                int aaa = Convert.ToInt16(item.allow_show_name) + Convert.ToInt16(item.is_full_screen);
                                Response.Write("<div class=\"tb-module tshop-um tshop-um-mokuai6\" style=\"height:" + aaa + "px;\">");
                            }
                            else
                            {
                                Response.Write("<div class=\"tb-module tshop-um tshop-um-mokuai6\">");
                            }
                        %>
                        <%         
                            string divhtml = "<div class=\"jz-fullScreen\" style=\"";
                            if (!string.IsNullOrEmpty(item.module_desc))
                            {
                                if (item.module_desc.Length >= 7)
                                {
                                    if (item.module_desc.Substring(0, 7) == "http://")
                                        divhtml += "background-image:url(" + item.module_desc + ");";
                                    if (item.module_desc.Substring(0, 1) == "#" && item.module_desc.Length == 7)
                                        divhtml += "background-color:" + item.module_desc + ";";
                                }
                                //item.allow_show_name 
                                //divhtml += "background-image:url(" + item.module_desc + ");";

                            }
                            if (!string.IsNullOrEmpty(item.allow_show_name) && item.allow_show_name != "0")
                            {
                                //item.is_full_screen
                                divhtml += "height:" + item.allow_show_name + "px;";
                            }
                            if (!string.IsNullOrEmpty(item.is_full_screen) && item.is_full_screen != "0")
                            {
                                //item.is_full_screen
                                divhtml += "padding-top:" + item.is_full_screen + "px;";
                            }
                            divhtml += "\">";
                            Response.Write(divhtml);
                        %>
                        <%
                            var titlehtml = "";
                            if (item.module_name != "")
                            {
                                titlehtml += "<p style=\"text-align: center; padding-bottom:30px\"><span style=\"font-size:26px;line-height:40px;\"><strong>" + item.module_name + "</strong></span></p>";
                            } 
                            Response.Write(titlehtml);
                            %>
                        <ul class="product_list">
                            <%
                                List<STItemInfo> items = item.topic_item_list;
                                if (items == null)
                                    items = new List<STItemInfo>();
                                if (items.Count > 0)
                                {
                                    int imgSize = 350;
                                    for (int i = 0; i < items.Count; i++)
                                    {
                                        //if (i > 7)
                                        //    break;
                                        STItemInfo sem = items[i];
                                        string url = config.UrlHome + sem.product_id + ".html";
                                        ShortProductInfo product = new ShortProductInfo();

                                        var respro = GetShortProductsByProductIds.Do(sem.product_id.ToString());
                                        if (respro != null && respro.Body != null && respro.Body.product_list != null && respro.Body.product_list[0] != null)
                                        {
                                            product = respro.Body.product_list[0];
                                        }

                                        string image = FormatImagesUrl.GetMainImageUrl(product.img_src, imgSize, imgSize);
                                        decimal price = 0;
                                        if (DateTime.Parse(product.promotion_bdate) <= DateTime.Now && DateTime.Now <= DateTime.Parse(product.promotion_edate) && DateTime.Parse(product.promotion_bdate) != DateTime.Parse(product.promotion_edate))
                                        {
                                            price = product.promotion_price;
                                        }
                                        else
                                        {
                                            price = product.sale_price;
                                        }
                                        bool isFreeFare = false;

                                        if (product.is_free_fare == 1 && DateTime.Parse(product.free_fare_stime) <= DateTime.Now && DateTime.Parse(product.free_fare_etime) >= DateTime.Now)
                                            isFreeFare = true;
                                        if ((i+1)%4==0)
                                        {
                                            Response.Write("<li  style=\"margin-right:0px;\">");
                                        }
                                        else
                                        {
                                            Response.Write("<li>");
                                        }
                            %>
                            <a href="<%=url%>" target="_blank">
                                <div class="product-img">
                                    <img src="<%=image %>" alt="<%=Info.st_subject%>" />
                                </div>
                                <div class="spec">
                                    <span class="name">
                                        <%=product.product_name%></span> <span class="maidian">
                                            <%=product.sales_promotion%></span><span class="thj">特惠价￥<b><%=price%></b></span>
                                </div>
                            </a></li>
                            <%
                                    }
                                }
                            %>
                        </ul>
                    </div>
                    <div class="clear">
                    </div>
                </div>
            </div>
            <%
                }
            %>
        </div>
    </div>
    <%
        }
    %>
    </div>
    <%--//模块内容结束--%>
    <%--操作按钮开始--%>
    <div id="console-list">
        <div class="console">
            <%
                if (Info.st_state == 0)
                {
            %>
            <a href="javascript:;" onclick="revocation(event)">取消发布</a>
            <%
                }
                else
                {
            %>
            <a href="javascript:;" onclick="release(event)">&nbsp;&nbsp;发布&nbsp;&nbsp;</a>
            <%
                }
            %><%
                  string addtime = "";
                  if (Info.add_time != null && !Info.add_time.Equals(""))
                      addtime = DateTime.Parse(Info.add_time).ToString("yyyy");
            %>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="<%=config.UrlHome%>hdzt/<%=addtime%>/<%=Info.st_dir%>/"
                target="_blank">&nbsp;&nbsp;预览&nbsp;&nbsp;</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <a href="javascript:;" onclick="moduleAdd(event)"><b class="add">&nbsp;</b>新增模块</a>
        </div>
    </div>
    <%--//操作按钮结束--%>
    <script type="text/javascript">
        function revocation() {
            $.ajax({
                url: "/MPromotions/revocationTopic?t=" + new Date().getTime()
		, type: "post"
		, data: {
		    "tid": "<%=Info.st_id%>"
		}
		, dataType: "json"
		, success: function (json, textStatus) {
		    if (json.error) {
		        jsbox.error(json.message);
		    } else {
		        jsbox.success(json.message, window.location.href);
		    }
		}, error: function (http, textStatus, errorThrown) {
		    jsbox.error(errorThrown);
		}
            });
    return false;
}
function release() {
    $.ajax({
        url: "/MPromotions/releaseTopic?t=" + new Date().getTime()
, type: "post"
, data: {
    "tid": "<%=Info.st_id%>"
}
		, dataType: "json"
		, success: function (json, textStatus) {
		    if (json.error) {
		        jsbox.error(json.message);
		    } else {
		        jsbox.success(json.message, window.location.href);
		    }
		}, error: function (http, textStatus, errorThrown) {
		    jsbox.error(errorThrown);
		}
    });
    return false;
}
    </script>
    <script type="text/javascript">
        var __parentNode = false;
        function moduleAdd(event, obj) {
            if (obj) __parentNode = obj;
            var boxId = "#moduleAdd-boxControl";
            var box = Atai.$(boxId);
            var _dialog = false;
            if (!_dialog)
                _dialog = new AtaiShadeDialog();
            _dialog.init({
                obj: box
		, sure: function () { }
		, CWCOB: true
            });
            return false;
        }
    </script>
    <script type="text/javascript">
        function moduleAppend(json, mode) {
            var id = json.st_module_id;
            var stid = json.st_id;
            var html = '<div id="module-' + id + '" class="jz-zt-module" value="' + id + '">';
            //操作按钮
            html += '<div class="module-op">';
            html += '<div class="module-op-bg"></div>';
            html += '<div class="module-op-link">';
            html += '<a href="javascript:void(0);" class="remove" onclick="moduleRemove(' + stid + ',' + id + ')" title="删除模块">&nbsp;删除&nbsp;</a>';
            html += '&nbsp;&nbsp;&nbsp;';
            html += '<span class="move-links remove">';
            html += '<a href="javascript:void(0);" onclick="moduleMove(' + id + ',\'first\');" class="move-first" title="置顶">&nbsp;</a>';
            html += '<a href="javascript:void(0);" onclick="moduleMove(' + id + ',\'up\');" class="move-up" title="上移">&nbsp;</a>';
            html += '<a href="javascript:void(0);" onclick="moduleMove(' + id + ',\'down\');" class="move-down" title="下移">&nbsp;</a>';
            html += '<a href="javascript:void(0);" onclick="moduleMove(' + id + ',\'last\');" class="move-last" title="最末">&nbsp;</a>';
            html += '</span>';
            html += '&nbsp;&nbsp;&nbsp;';
            html += '<a href="javascript:void(0);" class="remove" onclick="moduleModify(' + id + ',\'' + mode + '\')" title="编辑模块数据">&nbsp;编辑&nbsp;</a>';
            html += '&nbsp;&nbsp;&nbsp;';
            var _mid = "#module-" + id;
            html += '<a href="javascript:void(0);" class="remove" onclick="moduleAdd(event,$(\'' + _mid + '\'))" title="新增模块">&nbsp;新增模块&nbsp;</a>';
            html += '</div>';
            html += '</div>';
            //模块标题
            html += '<div class="module-hd">';
            html += '<h3><b>@</b>' + json.module_name + '</h3>';
            html += '<div>' + json.module_desc + '</div>';
            html += '<a onclick="sGoto(e,\'jz-zt-container\')"></a>';
            html += '</div>';
            //模块内容
            html += '<div class="module-bd">';
            html += '此处填写模块内容';
            html += '</div>';
            html += '<div class="clear"></div>';

            html += '</div>';
            if (!__parentNode) {
                $("#jz-zt-container").append(html);
            } else {
                __parentNode.after(html); moduleResetSortNo();
            }
            moduleInit();
        }
    </script>
    <script type="text/javascript">
        function createModule(form) {
            var mode = $(form).find('input:radio[name="mode"]:checked').val();
            if (!mode) mode = 0;
            $.ajax({
                url: "/MPromotions/CreateModule?t=" + new Date().getTime()
		       , type: "post"
		       , data: {
		           "tid": "<%=Info.st_id%>"
			         , "mode": mode
		       }
		       , dataType: "json"
		       , success: function (json, textStatus) {
		           if (json.error) {
		               jsbox.error(json.message);
		           } else {
		               moduleAppend(json.data, mode);
		           }
		       }, error: function (http, textStatus, errorThrown) {
		           jsbox.error(errorThrown);
		       }
            });
           return false;
       }
    </script>
    <script type="text/javascript">
        function moduleRemove(stId, mId) {
            jsbox.confirm('您确定要永久删除此模块吗？', function () {
                $.ajax({
                    url: "/MPromotions/RemoveModule?t=" + new Date().getTime()
			, type: "post"
			, data: { "stid": stId, "mid": mId }
			, dataType: "json"
			, success: function (json, textStatus) {
			    if (json.error) {
			        jsbox.error(json.message);
			    } else {
			        $("#module-" + mId).remove();
			    }
			}, error: function (http, textStatus, errorThrown) {
			    jsbox.error(errorThrown);
			}
                });
            });
            return false;
        }
    </script>
    <script type="text/javascript">
        function moduleResetSortNo() {
            var ids = "";
            var nodes = $(".jz-zt-module");
            for (var i = 0; i < nodes.length; i++) {
                if (i > 0) ids += ",";
                ids += $(nodes[i]).attr("value");
            }
            $.ajax({
                url: "/MPromotions/ResetSortNo?t=" + new Date().getTime()
		, type: "post"
		, data: { "ids": ids }
		, dataType: "json"
		, success: function (json, textStatus) {
		    if (json.error) {
		        jsbox.error(json.message);
		    } else {

		    }
		}, error: function (http, textStatus, errorThrown) {
		    jsbox.error(errorThrown);
		}
            });
            return false;
        }

        function checkedname(obj) {
            if (obj.checked) {
                $(obj).attr("checked", true);
                $(obj).attr("value", 1);
            } else {
                $(obj).attr("checked", false);
                $(obj).attr("value", 0);
            }
        }

        function checkedfull(obj) {
            if (obj.checked) {
                $(obj).attr("checked", true);
                $(obj).attr("value", 1);
            } else {
                $(obj).attr("checked", false);
                $(obj).attr("value", 0);
            }
        }

        function checkedcount(obj) {
            if (obj.checked) {
                $(obj).attr("checked", true);
                $("input[name='columnCount']").each(function () {
                    if (this != obj)
                        $(this).attr("checked", false);
                });
            } else {
                $(obj).attr("checked", false);
                $("input[name='columnCount']").each(function () {
                    if (this != obj)
                        $(this).attr("checked", true);
                });
            }
        }


    </script>
    <%Html.RenderPartial("Template/PageBottomControl"); %>
    <%Html.RenderPartial("BoxControl/ModuleAddBox"); %>
    <%Html.RenderPartial("BoxControl/ModuleModifyTextBox"); %>
    <%Html.RenderPartial("UploadImageControl"); %>
    <%Html.RenderPartial("UploadBaseControl"); %>
    <%Html.RenderPartial("ImageListBoxControl");//图片选择 %>
    <%Html.RenderPartial("BoxControl/ModuleModifyListBox"); %>
    <%Html.RenderPartial("BoxControl/ModuleModifyPagingBox"); %>
    <%Html.RenderPartial("BoxControl/ModuleModifyCarouselBox"); %>
    <%Html.RenderPartial("BoxControl/ModuleModifyPicBox"); %>
    <%Html.RenderPartial("BoxControl/ModuleModifyFloor"); %>

    <%Html.RenderPartial("BoxControl/BackGroundSet"); %>
</body>
</html>

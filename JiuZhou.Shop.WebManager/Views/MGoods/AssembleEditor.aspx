<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="JiuZhou.Model" %>
<%@ Import Namespace="JiuZhou.Common" %>
<%@ Import Namespace="JiuZhou.MySql" %>
<%@ Import Namespace="JiuZhou.HttpTools" %>
<%@ Import Namespace="JiuZhou.Cache" %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="/style/style.css" rel="stylesheet" type="text/css" />
    <%Html.RenderPartial("Base/_PageHeadControl"); %>
    <title><%=ViewData["pageTitle"]%></title>
</head>
<body>
    <%Html.RenderPartial("Base/_SimplePageTopControl"); %>
    <%
        List<TypeList> tList = new List<TypeList>();
        DoCache chche = new DoCache();
        if (chche.GetCache("typelist") == null)
        {
            var res = GetTypeListAll.Do(-1);
            if (res != null && res.Body != null && res.Body.type_list != null)
            {
                tList = res.Body.type_list;
                chche.SetCache("typelist", tList);
                if (tList.Count == 0)
                {
                    chche.RemoveCache("typelist");
                }
            }
        }
        else
        {
            tList = (List<TypeList>)chche.GetCache("typelist");
        }
        ResponseProductAssemble Info = (ResponseProductAssemble)(ViewData["Info"]);
        if (Info == null)
            Info = new ResponseProductAssemble();
    %>
    <div id="container-syscp">
        <div class="container-left">
            <%Html.RenderPartial("Base/LeftControl"); %>
        </div>
        <div class="container-right">
            <div class="editor-box-head">
                套装编辑
            </div>
            <form method="post" action="" onsubmit="return submitForm(this)">
                <input type="hidden" name="AssID" value="<%=Info.ass_id%>" />
                <div class="div-tab">
                    <table class="table" cellpadding="0" cellspacing="0">
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
                                <td class="lable">套装名称<b>*</b></td>
                                <td class="inputText">
                                    <input type="text"  must="1" name="name" value="<%=Info.ass_subject%>" class="input" style="width: 420px;" /></td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">套装类别</td>
                                <td colspan="2">
                                    <input type="radio" name="AssType" onclick="checkedthis(this)" value="1" <%if (Info.ass_type > 0) { Response.Write(" checked=\"checked\""); }%> />
                                    固定搭配
                                    &nbsp;|&nbsp;
                                    <input type="radio" name="AssType" onclick="checkedthis(this)" value="0" <%if (Info.ass_type == 0) { Response.Write(" checked=\"checked\""); }%> />
                                    自由搭配
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable" valign="top">套装说明</td>
                                <td colspan="2" class="inputText">
                                    <textarea name="summary" class="textarea" style="width: 430px; height: 60px"><%=Info.ass_summary%></textarea>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">开始时间<b>*</b></td>
                                <td colspan="2" class="inputText">
                                    <input type="text"  must="1" name="startname" value="<%=Info.start_time %>" readonly="readonly" class="input" onclick="WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm:ss'})" />
                                    结束时间<b>*</b>
                                    <input type="text"  must="1" name="endtime" value="<%=Info.end_time %>" readonly="readonly" class="input" onclick="WdatePicker({ dateFmt: 'yyyy-MM-dd HH:mm:ss' })" />
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <br />
                    <script type="text/javascript">
                        function checkedthis(obj) {
                            if (obj.checked) {
                                $(obj).attr("checked", true);
                                $("input[name='AssType']").each(function () {
                                    if (this != obj)
                                        $(this).attr("checked", false);
                                });
                            } else {
                                $(obj).attr("checked", false);
                                $("input[name='AssType']").each(function () {
                                    if (this != obj)
                                        $(this).attr("checked", true);
                                });
                            }
                        }

                        function showMainProductSelector() {
                            var nodes = $("#table-MainProductSelector input[v='main-product-id']");
                            var initList = "";
                            for (var i = 0; i < nodes.length; i++) {
                                if (i > 0) initList += ",";
                                initList += $(nodes[i]).val();
                            }
                            var exceptList = [];
                            nodes = $("#table-ItemroductSelector input[v='item-product-id']");
                            for (var i = 0; i < nodes.length; i++)
                                exceptList.push($(nodes[i]).val());
                            showProductSelector(function (ids) {
                                if (ids == "") return false;
                                $.ajax({
                                    url: "/MTools/GetProductList2"
                                    , type: "post"
                                    , data: {
                                        "ids": ids
                                    }
                                    , dataType: "json"
                                    , success: function (json, textStatus) {
                                        parseMainProductSelectorData(json);
                                    }, error: function (http, textStatus, errorThrown) {
                                        jsbox.error(errorThrown);
                                    }
                                });
                            }, initList, exceptList, true, 1);//第三个参数ture=允许选择带Sku商品;false=禁止选择带Sku商品
                        }

                        function parseMainProductSelectorData(jsonList) {
                            var o = $("#table-MainProductSelector");
                            var ids = [];
                            for (var i = 0; i < jsonList.length; i++) {
                                ids.push(jsonList[i].product_id);
                            }
                            var bids = [];
                            o.find("tbody tr").each(function () {
                                var id = $(this).find("input[v='main-product-id']").val();
                                if (!ids.contains(id)) $(this).remove();
                                else bids.push(id);
                            });
                            var arr = [];
                            for (var i = 0; i < jsonList.length; i++) {
                                var json = jsonList[i];
                                if (bids.contains(json.product_id)) continue;
                                arr.push('<tr><td>&nbsp;</td>');
                                arr.push('<td style="width:70px;height:74px;"><input type="hidden" v="main-product-id" value="' + json.product_id + '"/>');
                                arr.push('<a href="<%=config.UrlHome%>' + json.product_id + '.html" target="_blank">');
                                arr.push('<img src="' + formatImageUrl(json.img_src, 120, 120) + '" style="width:60px;height:60px" alt=""/></a></td>');
                                arr.push('<td>');
                                arr.push('<p><a href="<%=config.UrlHome%>' + json.product_id + '.html" target="_blank">' + json.product_name + '</a></p>');
                                arr.push('<p class="pname" style="color:#999">编码：' + json.product_code + '</p>');
                                arr.push('<p style="color:#999">' + json.type_name + '</p></td>');
                                arr.push('<td style="font-family:Arial;color:#ff6600">￥' + json.sale_price + '</td>');
                                arr.push('<td>&nbsp;</td>');
                                arr.push('<td><a href="javascript:;" onclick="removeMainProductSelectorData(this)">移除</a></td>');
                                arr.push('</tr>');
                            }
                            o.find("tbody").append(arr.join("\n"));
                        }

                        function removeMainProductSelectorData(obj) {
                            $(obj).parent("td").parent("tr").remove();
                        }
                    </script>
                    <table id="table-MainProductSelector" class="table" cellpadding="0" cellspacing="0">
                        <thead>
                            <tr>
                                <th style="width: 3%">&nbsp;</th>
                                <th colspan="2">
                                    <div class="console" style="padding: 0; margin: 0; border: 0; height: auto; line-height: auto; text-align: left;">
                                        <a href="javascript:;" onclick="showMainProductSelector()"><b class="add">&nbsp;</b>选择主商品...</a>
                                    </div>
                                </th>
                                <th style="width: 12%">售价</th>
                                <th style="width: 12%">&nbsp;</th>
                                <th style="width: 8%">操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%

                                List<MainProduct> mainList = Info.main_product_list;
                                if (mainList == null)
                                    mainList = new List<MainProduct>();
                                foreach (MainProduct product in mainList)
                                {
                            %>
                            <tr>
                                <td>&nbsp;</td>
                                <td style="width: 70px; height: 74px;">
                                    <input type="hidden" v="main-product-id" value="<%=product.product_id %>" />
                                    <a href="<%=config.UrlHome%><%=product.product_id %>.html" target="_blank" title="<%=product.product_name%>">
                                        <img src="<%=FormatImagesUrl.GetProductImageUrl(product.img_src, 120, 120) %>" style="width: 60px; height: 60px" alt="" />
                                    </a>
                                </td>
                                <td>
                                    <p><a href="<%=config.UrlHome%><%=product.product_id %>.html" target="_blank"><%=product.product_name%></a></p>
                                    <p class="pname" style="color: #999">
                                        编码：<%=product.product_code%>
                                    </p>
                                    <p style="color: #999">
                                        分类：<%  //ProductTypeInfo clsInfo = new ProductTypeInfo();//当前分类
                                               string _s = product.product_type_path;
                                               string[] _tem = _s.Split(',');
                                               int _xCount = 0;
                                               for (int x = 0; x < _tem.Length; x++)
                                               {
                                                   if (string.IsNullOrEmpty(_tem[x].Trim())) continue;
                                                   int _v = Utils.StrToInt(_tem[x].Trim());
                                                   foreach (TypeList item in tList)
                                                   {
                                                       if (item.product_type_id == _v)
                                                       {
                                                           if (_xCount > 0) Response.Write(" &gt;&gt; ");
                                                           Response.Write(item.type_name);
                                                           _xCount++;
                                                       }
                                                   }
                                               }
                                               //clsInfo.n_name
                                        %>
                                    </p>
                                </td>
                                <td style="font-family: Arial; color: #ff6600">￥<%=product.sale_price%></td>
                                <td>&nbsp;</td>
                                <td><a href="javascript:;" onclick="removeMainProductSelectorData(this)">移除</a></td>
                            </tr>
                            <%}
                            %>
                        </tbody>
                    </table>
                    <br />
                    <script type="text/javascript">
                        function showItemProductSelector() {
                            var nodes = $("#table-ItemProductSelector input[v='item-product-id']");
                            var initList = "";
                            for (var i = 0; i < nodes.length; i++) {
                                if (i > 0) initList += ",";
                                initList += $(nodes[i]).val();
                            }
                            var exceptList = [];
                            nodes = $("#table-MainProductSelector input[v='main-product-id']");
                            for (var i = 0; i < nodes.length; i++)
                                exceptList.push($(nodes[i]).val());

                            showProductSelector(function (ids) {
                                if (ids == "") return false;
                                $.ajax({
                                    url: "/MTools/GetProductList2"
                                    , type: "post"
                                    , data: {
                                        "ids": ids
                                    }
                                    , dataType: "json"
                                    , success: function (json, textStatus) {
                                        parseItemProductSelectorData(json);
                                    }, error: function (http, textStatus, errorThrown) {
                                        jsbox.error(errorThrown);
                                    }
                                });
                            }, initList, exceptList, true, 1);//第四个参数ture=允许选择带Sku商品;false=禁止选择带Sku商品
                        }
                        function parseItemProductSelectorData(jsonList, isAdd) {
                            var o = $("#table-ItemProductSelector");
                            var ids = [];
                            for (var i = 0; i < jsonList.length; i++) {
                                ids.push(jsonList[i].product_id);
                            }
                            var bids = [];
                            o.find("tbody tr").each(function () {
                                var id = $(this).find("input[v='item-product-id']").val();
                                if (!ids.contains(id)) $(this).remove();
                                else bids.push(id);
                            });
                            //if(!isAdd) o.find("tbody tr").remove();
                            var nodes = o.find("input[v='item-product-id']");
                            var items = [];
                            for (var i = 0; i < nodes.length; i++) items.push($(nodes[i]).val());
                            var arr = [];
                            for (var i = 0; i < jsonList.length; i++) {
                                var json = jsonList[i];
                                if (items.contains(json.product_id))
                                    continue;//去除重复的ID
                                arr.push('<tr><td>&nbsp;</td>');
                                arr.push('<td style="width:70px;height:74px;"><input type="hidden" v="item-product-id" value="' + json.product_id + '"/>');
                                arr.push('<a href="<%=config.UrlHome%>' + json.product_id + '.html" target="_blank">');
                                arr.push('<img src="' + formatImageUrl2(json.img_src, 120, 120) + '" style="width:60px;height:60px" alt=""/></a></td>');
                                arr.push('<td>');
                                arr.push('<p><a href="<%=config.UrlHome%>' + json.product_id + '.html" target="_blank">' + json.product_name + '</a></p>');
                                arr.push('<p class="pname" style="color:#999">编码：' + json.product_code + '</p>');
                                arr.push('<p style="color:#999">' + json.type_name + '</p></td>');
                                arr.push('<td><input type="text" v="item-product-price" itemid="0" proid="' + json.product_id + '" value="' + json.sale_price + '" class="input" style="width:60px;" onclick="this.select()"/><p style="font-family:Arial;margin-top:6px;color:#666"><del>￥' + json.sale_price + '</del></p></td>');
                                arr.push('<td><p class="move-links">');
                                arr.push('<a href="javascript:void(0);" onclick="moveItemProduct(this,\'first\');" class="move-first" title="置顶">&nbsp;</a>');
                                arr.push('<a href="javascript:void(0);" onclick="moveItemProduct(this,\'up\');" class="move-up" title="上移">&nbsp;</a>');
                                arr.push('<a href="javascript:void(0);" onclick="moveItemProduct(this,\'down\');" class="move-down" title="下移">&nbsp;</a>');
                                arr.push('<a href="javascript:void(0);" onclick="moveItemProduct(this,\'last\');" class="move-last" title="最末">&nbsp;</a>');
                                arr.push('</p></td>');
                                arr.push('<td><a href="javascript:;" onclick="removeMainProductSelectorData(this)">移除</a></td>');
                                arr.push('</tr>');
                            }
                            o.find("tbody").append(arr.join("\n"));
                        }
                        function moveItemProduct(obj, type) {
                            var mObj = $(obj).parent("p").parent("td").parent("tr");
                            var nodes = $("#table-ItemProductSelector tbody tr");
                            var idx = mObj.index();
                            var len = nodes.length;
                            if (mObj && len > 0) {
                                switch (type) {
                                    case "first":
                                        if (idx > 0) {
                                            mObj.insertBefore(nodes[0]);
                                        }
                                        break;
                                    case "up":
                                        if (idx > 0) {
                                            mObj.insertBefore(nodes[idx - 1]);
                                        }
                                        break;
                                    case "down":
                                        if (idx + 1 < len) {
                                            mObj.insertAfter(nodes[idx + 1]);
                                        }
                                        break;
                                    case "last":
                                        if (idx + 1 < len) {
                                            mObj.insertAfter(nodes[len - 1]);
                                        }
                                        break;
                                }
                            }
                        }
                        /*function removeItemProductSelectorData(obj){
                            $(obj).parent("td").parent("tr").remove();
                        }*/
                        function copyMainProduct() {
                            var ids = "";
                            var nodes = $("#table-MainProductSelector input[v='main-product-id']");
                            for (var i = 0; i < nodes.length; i++) {
                                if (i > 0) ids += ",";
                                ids += $(nodes[i]).val();
                            }
                            if (ids == "") return false;
                            $.ajax({
                                url: "/MTools/GetProductList"
                                , type: "post"
                                , data: {
                                    "ids": ids
                                }
                                , dataType: "json"
                                , success: function (json, textStatus) {
                                    parseItemProductSelectorData(json, true);
                                }, error: function (http, textStatus, errorThrown) {
                                    jsbox.error(errorThrown);
                                }
                            });
                        }
                    </script>
                    <table id="table-ItemProductSelector" class="table" cellpadding="0" cellspacing="0">
                        <thead>
                            <tr>
                                <th style="width: 3%">&nbsp;</th>
                                <th colspan="2">
                                    <div style="position: relative">
                                        <div class="console" style="padding: 0; margin: 0; border: 0; height: auto; line-height: auto; text-align: left;">
                                            <a href="javascript:;" onclick="showItemProductSelector()"><b class="add">&nbsp;</b>选择搭配商品...</a>
                                        </div>
                                    </div>
                                </th>
                                <th style="width: 12%">搭配价格</th>
                                <th style="width: 12%">排序</th>
                                <th style="width: 8%">操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%List<AssembleProduct> assembleproduct = Info.item_product_list;
                                if (assembleproduct == null)
                                {
                                    assembleproduct = new List<AssembleProduct>();
                                }
                                foreach (AssembleProduct product in assembleproduct)
                                {
                            %>
                            <tr>
                                <td>&nbsp;</td>
                                <td style="width: 70px; height: 74px;">
                                    <input type="hidden" v="item-product-id" value="<%=product.product_id %>" />
                                    <a href="<%=config.UrlHome%><%=product.product_id %>.html" target="_blank" title="<%=product.product_name%>">
                                        <img src="<%=FormatImagesUrl.GetProductImageUrl(product.img_src, 120, 120) %>" style="width: 60px; height: 60px" alt="" />
                                    </a>
                                </td>
                                <td>
                                    <p><a href="<%=config.UrlHome%><%=product.product_id %>.html" target="_blank"><%=product.product_name%></a></p>
                                    <p class="pname" style="color: #999">
                                        编码：<%=product.product_code%>
                                    </p>
                                    <p style="color: #999">
                                        分类：<%  //ProductTypeInfo clsInfo = new ProductTypeInfo();//当前分类
                                               string _s = product.product_type_path;
                                               string[] _tem = _s.Split(',');
                                               int _xCount = 0;
                                               for (int x = 0; x < _tem.Length; x++)
                                               {
                                                   if (string.IsNullOrEmpty(_tem[x].Trim())) continue;
                                                   int _v = Utils.StrToInt(_tem[x].Trim());
                                                   foreach (TypeList item in tList)
                                                   {
                                                       if (item.product_type_id == _v)
                                                       {
                                                           if (_xCount > 0) Response.Write(" &gt;&gt; ");
                                                           Response.Write(item.type_name);
                                                           _xCount++;
                                                       }
                                                   }
                                               }
                                               //clsInfo.n_name
                                        %>
                                    </p>
                                </td>
                                <td>
                                    <input type="text" v="item-product-price" itemid="<%=product.ass_item_id %>" proid="<%=product.product_id%>" value="<%=product.promotion_price%>" class="input" style="width: 60px;" onclick="this.select()" />
                                    <p style="font-family: Arial; margin-top: 6px; color: #666"><del>￥<%=product.sale_price%></del></p>
                                </td>
                                <td>
                                    <p class="move-links">
                                        <a href="javascript:void(0);" onclick="moveItemProduct(this,'first');" class="move-first" title="置顶">&nbsp;</a>
                                        <a href="javascript:void(0);" onclick="moveItemProduct(this,'up');" class="move-up" title="上移">&nbsp;</a>
                                        <a href="javascript:void(0);" onclick="moveItemProduct(this,'down');" class="move-down" title="下移">&nbsp;</a>
                                        <a href="javascript:void(0);" onclick="moveItemProduct(this,'last');" class="move-last" title="最末">&nbsp;</a>
                                    </p>
                                </td>
                                <td><a href="javascript:;" onclick="removeMainProductSelectorData(this)">移除</a></td>
                            </tr>
                            <%}
                            %>
                        </tbody>
                    </table>
                    <br />
                    <table class="table" cellpadding="0" cellspacing="0">
                        <thead>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">&nbsp;</td>
                                <td class="inputText">
                                    <input type="submit" id="loadding3" value="确定提交" class="submit" /></td>
                                <td>
                                    <div class="tips-text" id="tips-message"></div>
                                </td>
                            </tr>
                        </thead>
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
    <br />
    <br />
    <script type="text/javascript">
        function createXmlDocument(nodes) {
            var xml = '<?xml version="1.0" encoding="utf-8"?>';
            xml += '<items>';
            for (var i = 0; i < nodes.length; i++) {
                xml += nodes[i];
            }
            xml += '</items>';
            return xml;
        }
        function createItemNode(itemid, proid, price) {
            return '<item itemid="' + itemid + '" proid="' + proid + '" price="' + price + '"/>';
        }
        function submitForm(form) {
            if (showLoadding) showLoadding();
            var isError = false;
            $("input[must='1']").each(function () {
                if ($(this).val() == "" && !$(this).attr("disabled")) {
                    isError = true;
                }
            });
            if (isError) {
                jsbox.error("请完成所有必填项的填写");
                if (closeLoadding) closeLoadding();
                return false;
            }
            var postData = getPostDB(form);
            var mainNodes = $("#table-MainProductSelector input[v='main-product-id']");
            var ids = "";
            for (var i = 0; i < mainNodes.length; i++) {
                if (i > 0) ids += ",";
                ids += $(mainNodes[i]).val();
            }//主商品
            //postData["main"]=ids;
            /*if(ids==""){
                jsbox.error("请选择主商品");
                return false;
            }*/
            var nodes = [];
            var list = $("#table-ItemProductSelector input[v='item-product-price']");
            for (var i = 0; i < list.length; i++) {
                var o = $(list[i]);
                nodes.push(createItemNode(o.attr("itemid"), o.attr("proid"), o.val()));
            }
            var xmldata = postData["xml"] = createXmlDocument(nodes);
            //套装商品
            //alert(postData.xml);
            $.ajax({
                url: "/MGoods/PostAssembleData"
                , type: "post"
                , data: postData + "&main=" + ids + "&xml=" + encodeURIComponent(xmldata)
                , dataType: "json"
                , success: function (json, textStatus) {
                    if (json.error) {
                        jsbox.error(json.message);
                    } else {
                        jsbox.success(json.message, window.location.href);
                    }
                    if (closeLoadding) closeLoadding();
                }, error: function (http, textStatus, errorThrown) {
                    jsbox.error(errorThrown);
                }
            });
            return false;
        }
    </script>
    <%Html.RenderPartial("MGoods/SelectProductControl"); %>
    <%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>

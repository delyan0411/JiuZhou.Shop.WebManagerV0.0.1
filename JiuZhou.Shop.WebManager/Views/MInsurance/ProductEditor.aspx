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
    <style>
        .table-head {
            width: 100%;
        }

            .table-head thead th {
                background: #f3f5ea;
                border-bottom: #dbe0cb 1px solid;
                text-align: center;
                height: 26px;
                line-height: 26px;
                padding: 0;
            }

            .table-head th {
                border: #dbe0cb 1px solid;
                border-left: 0;
                border-bottom: 0;
                font-weight: 100;
            }

            .table-head tbody td {
                border-right: #ddd 1px solid;
                border-bottom: #ddd 1px solid;
                text-align: center;
                line-height: 22px;
            }

                .table-head tbody td .input {
                    width: 40px;
                    text-align: center;
                }

        .selecedtype ul {
            width: 400px;
            height: 300px;
            overflow-x: hidden;
            overflow-y: auto;
        }

            .selecedtype ul li {
                text-indent: 18px;
                border-bottom: #ccc 1px dashed;
                display: block;
                height: 27px;
                line-height: 27px;
                font-weight: bolder;
            }

        .brandlist ul {
            width: 500px;
            height: 300px;
            overflow-x: hidden;
            overflow-y: auto;
        }

            .brandlist ul li {
                text-indent: 18px;
                border-bottom: #ccc 1px dashed;
                display: block;
                height: 27px;
                line-height: 27px;
                font-weight: bolder;
            }

        .selecedbrand ul {
            width: 400px;
            height: 300px;
            overflow-x: hidden;
            overflow-y: auto;
        }

            .selecedbrand ul li {
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
        InsProductDetail Info = new InsProductDetail();
        int id = DoRequest.GetQueryInt("id",0);
        //  int insurancetype = DoRequest.GetQueryInt("insurancetype");
        var resp = QueryInsProduct.Do(id);
        if (resp == null || resp.Body == null)
        {
            Info = new InsProductDetail();
        }
        else
        {
            Info = resp.Body;
        }
        List<InsTypeItem> rils = Info.instype_list;
        List<InsProItem> items = Info.insproduct_list;
    %>
    <script type="text/javascript">$(function () { document.title = "用户类别商品编辑|九洲"; });</script>
    <div id="container-syscp">
        <div class="container-left">
            <%Html.RenderPartial("Base/LeftControl"); %>
        </div>
        <div class="container-right">
            <div class="editor-box-head">
                用户类别商品编辑
            </div>
            <div class="console">
                <a name="addpro" href="javascript:;" onclick="showFullProductSelector()">类别选择</a>
            </div>
            <table class="table" cellpadding="0" cellspacing="0">
                <thead>
                    <tr>
                        <th>选择类别 <b style="color: #F00">*</b>
                        </th>
                        <th style="text-align: right">
                            <a href="javascript:;" onclick="clearTypes()" style="color: #999">清除选择</a>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td style="width: 500px; height: 300px;">
                            <script language="c#" runat="server">
                                List<TypeList> tList = GetTypeListAll.Do(-1).Body.type_list;
                                //List<InsTypeItems> rils = Info.instype_list;
                                int ruleid = -1;
                                int tree = 0;
                                public void PrintList(int parentId,List<InsTypeItem> rils)
                                {
                                    if (parentId < 0) return;
                                    List<TypeList> items = tList.FindAll(
                                        delegate (TypeList em)
                                        {
                                            return em.parent_type_id == parentId;
                                        });
                                    if (items.Count <= 0) return;
                                    //tree++;
                                    bool isHasChild = false;
                                    Response.Write("<ul>");
                                    isHasChild = true;
                                    //List<SeoRuleItemInfo> srs = new List<InsTypeItems>();
                                    //else
                                    //{
                                    foreach (TypeList item in items)
                                    {
                                        string[] arr = item.product_type_path.Split(',');
                                        tree = arr.Length - 2;
                                        Response.Write("<li>");
                                        Response.Write("<div tree=\"" + tree + "\"><a href=\"javascript:;\" v=\"bt\" class='jslk'>&nbsp;</a>");
                                        Response.Write("<a href=\"javascript:;\" v=\"bt\" style=\"color:#000\">" + item.type_name + "</a>");
                                        List<TypeList> __ems = tList.FindAll(
                                            delegate (TypeList e)
                                            {
                                                return e.parent_type_id == item.product_type_id;
                                            });
                                        // &&(tree > 2 || __ems.Count == 0)
                                        if (item.is_visible > 0 || item.is_visible <= 0)
                                        {
                                            Response.Write("<p class=\"b-list\" style=\"left:" + (360 - (tree - 1) * 18) + "px\">");
                                            string clsName = "";
                                            int _xCount = 0;
                                            for (int x = 0; x < arr.Length; x++)
                                            {
                                                if (string.IsNullOrEmpty(arr[x].Trim())) continue;
                                                int _v = Utils.StrToInt(arr[x].Trim());
                                                foreach (TypeList ie in tList)
                                                {
                                                    if (ie.product_type_id == _v)
                                                    {
                                                        if (_xCount > 0) clsName += " >> ";
                                                        clsName += ie.type_name;
                                                        _xCount++;
                                                    }
                                                }
                                            }
                                            if (rils.Any(t => t.product_type_id == Convert.ToString(item.product_type_id)))
                                                Response.Write("<input type='checkbox'   checked=\"checked\" onclick=\"selectThisCateg(event," + item.product_type_id + ", '" + Utils.ToUnicode(clsName) + "',this)\" val='chk_" + item.product_type_id + "' />  ");
                                            else
                                                Response.Write("<input type='checkbox' onclick=\"selectThisCateg(event," + item.product_type_id + ", '" + Utils.ToUnicode(clsName) + "',this)\" val='chk_" + item.product_type_id + "' />  ");
                                            //Response.Write("<input type='checkbox' onclick=\"selectThisCateg(event," + item.product_type_id + ", '" + Utils.ToUnicode(clsName) + "',this)\" val='chk_" + //item.product_type_id + "' />  ");
                                            Response.Write("</p>");
                                        }
                                        Response.Write("</div>");
                                        PrintList(item.product_type_id,rils);
                                        Response.Write("</li>\r\n");
                                    }
                                    //}
                                    if (isHasChild) Response.Write("</ul>\r\n");
                                }
                            </script>
                            <script type="text/javascript">
                                $(function () {
                                    var _list = new _list_utils();
                                    _list.isopen = true;
                                    _list.opentree = 1;
                                    _list.init(document.getElementById("class-list"));


                                });
                            </script>
                            <div id="class-list" style="height: 300px; width: 500px; overflow-x: hidden; overflow-y: scroll">
                                <%PrintList(0,rils);%>
                            </div>
                        </td>
                        <td style="height: 300px; width: 400px;" class="selecedtype">
                            <ul>
                                  <% 
                                      //if (ruleid != -1)
                                      // {
                                      List<InsTypeItem> itilist =
                                          Info.instype_list;
                                      foreach (InsTypeItem iti in itilist)
                                      {
                                          string clsName = "";
                                          if (tList.Any(t => t.product_type_id == Convert.ToInt32(iti.product_type_id)))
                                          {
                                              string[] _tem = tList.FirstOrDefault(t => t.product_type_id == Convert.ToInt32(iti.product_type_id)).product_type_path.Trim().Split(',');
                                              int _xCount = 0;
                                              for (int x = 0; x < _tem.Length; x++)
                                              {
                                                  if (string.IsNullOrEmpty(_tem[x].Trim())) continue;
                                                  int _v = Utils.StrToInt(_tem[x].Trim());
                                                  foreach (TypeList item in tList)
                                                  {
                                                      if (item.product_type_id == _v)
                                                      {
                                                          if (_xCount > 0) clsName += " &gt;&gt; ";
                                                          clsName += item.type_name;
                                                          _xCount++;
                                                      }
                                                  }
                                              }
                                          }

                                          Response.Write("<li typeid=" + iti.product_type_id + "  rule_item_id=" + iti.id + ">" + clsName + "<a href='javascript:;' onclick='rem(" + iti.product_type_id + ")' title='取消选择' style=\"float: right;\">取消选择</a></li>");
                                      }
                                      //}
                                %>
                            </ul>
                        </td>
                    </tr>
                </tbody>
            </table>
            <div class="console">
                <a name="addpro" href="javascript:;" onclick="showFullProductSelector()">商品选择</a>
            </div>
            <div id="image-list-box-page-links" class="page-idx">
            </div>
            <%
                if (items == null)
                    items = new List<InsProItem>();
                var datacount = items.Count;
                var pagecount = 0;
                if (datacount % 10 == 0)
                {
                    pagecount = datacount / 10;
                }
                else
                {
                    pagecount = datacount / 10 + 1;
                }
            %>
            <table id="table-Product" class="table" cellpadding="0" cellspacing="0">
                <thead>
                    <tr>
                        <th style="width: 3%">&nbsp;</th>
                        <th style="width: 10%">&nbsp;</th>
                        <th>商品名</th>
                        <th style="width: 10%">售价</th>
                        <th style="width: 12%">&nbsp;</th>
                        <th style="width: 8%">操作</th>
                    </tr>
                </thead>
                <tbody id="fulloffbody">
                </tbody>
            </table>
            <div id="image-list-box-page-links2" class="page-idx">
            </div>
            <table class="table" cellpadding="0" cellspacing="0">
                <thead>
                    <tr>
                        <th style="width: 42%">&nbsp;
                        </th>
                        <th class="lable">
                            <input type="button" id="loadding3" value="  确定提交  " onclick="submitForm()" class="submit" style="width: 120px" />
                        </th>
                        <th>
                            <div class="tips-text" id="tips-message">
                            </div>
                        </th>
                    </tr>
                </thead>
            </table>
        </div>
    </div>
    <script type="text/javascript">
           var postids = [];
    var datacount = <%=datacount %>;
    var pagecount = <%=pagecount %>;
    var jsonList = null;
    $(function () {
    $.ajax({
        url: "/MInsurance/GetInsProduct"
         ,data: {"id":<%=id%>}
        , type: "post"
		, dataType: "json"
        , async : false
		, success: function (json) {
		    jsonList = json.datapro;
          postids = [];
          for(var i=0;i<jsonList.length;i++){
              if(i>0) initList+=",";
	          initList+=jsonList[i].product_id;
              postids.push(jsonList[i].product_id);
          }
          if(jsonList.length>0&&jsonList[0].product_id!=0){
              getProductList(1);
          }
        }
        });
    });
        var _formatAjaxPageLinkCount = 0;
        function formatPageLink(pagecount, pageindex, type) {
            _formatAjaxPageLinkCount++;
            var arr = [];
            var maxCount = 8;
            var n = pageindex - (maxCount / 2);
            if (n <= 0) n = 1;
            if (pageindex > 1) {
                arr.push("		<a href=\"javascript:ChangePage(1," + type + ");\" title=\"首页\">&lt;&lt;</a>");
                arr.push("		<a href=\"javascript:ChangePage(" + (pageindex - 1) + "," + type + ")\" title=\"上页\">&lt;</a>");
            } else {
                arr.push("		<strong>&lt;&lt;</strong>");
                arr.push("		<strong>&lt;</strong>");
            }
            for (var k = n; k < (n + maxCount) ; k++) {
                if (k <= pagecount) {
                    if (k == pageindex) {
                        arr.push("		<strong><span>" + k + "</span></strong>");
                    } else {
                        arr.push("		<a href=\"javascript:ChangePage(" + k + "," + type + ")\" title=\"第" + k + "页\">" + k + "</a>");
                    }
                } else {
                    if (k == pageindex)
                        arr.push("		<strong><span>" + k + "</span></strong>");
                }
            }
            if (pageindex < pagecount) {
                arr.push("		<a href=\"javascript:ChangePage(" + (pageindex + 1) + "," + type + ")\" title=\"下页\">&gt;</a>");
                arr.push("		<a href=\"javascript:ChangePage(" + pagecount + "," + type + ")\" title=\"末页\">&gt;&gt;</a>");
            } else {
                arr.push("		<strong>&gt;</strong>");
                arr.push("		<strong>&gt;&gt;</strong>");
            }
            arr.push("		<strong class=\"txt\"><span>" + pageindex + "</span>/" + pagecount + "</strong>");
            arr.push("   <strong class=\"txt\">共 " + datacount + " 条记录</strong>");
            arr.push("		<strong class=\"goto\"><input id=\"goto-" + _formatAjaxPageLinkCount + "\" type=\"text\" value=\"" + (pageindex + 1 < pagecount ? (pageindex + 1) : pagecount) + "\" onclick=\"this.select()\"/></strong>");
            arr.push("		<a href=\"javascript:;\" onclick=\"ChangePage(Atai.$('#goto-" + _formatAjaxPageLinkCount + "').value," + type + ")\" title=\"GO\">GO</a>");
            return arr.join("\r\n");
        }
        function ChangePage(pageIndex, type) {
            if (type == 0) {
                getProductList(pageIndex);
            }
            if (type == 1) {
                parseFullProductSelectorData(pageIndex);
            }
        }
        var initList = "";
        function getProductList(pageindex) {
            var changeLinks = formatPageLink(pagecount, pageindex, 0);
            var changeLinks2 = formatPageLink(pagecount, pageindex, 0);
            var nodes = jsonList;
            var htmls = [];
            if (nodes != null && nodes.length > 0) {
                for (var i = (pageindex - 1) * 10; i < pageindex * 10; i++) {
                    if (nodes[i] == null)
                        break;
                    htmls.push('<tr>');
                    htmls.push('<td>&nbsp;</td>');
                    htmls.push('<td style="width:70px;height:74px;"><input type="hidden" v="product-id" value="' + nodes[i].product_id + '"/>');
                    htmls.push('<a href="<%=config.UrlHome%>' + nodes[i].product_id + '.html" target="_blank">');
                    htmls.push('<img src="'+ formatImageUrl(nodes[i].img_src, 120, 120) + '" style="width:60px;height:60px" alt=""/></a></td>');
                    htmls.push('<td>');
                    htmls.push('<p><a href="<%=config.UrlHome%>' + nodes[i].product_id + '.html" target="_blank">' + nodes[i].product_name + '</a></p>');
            htmls.push('<p class="pname" style="color:#999">编码：' + nodes[i].product_code + '</p></td>');
            htmls.push('<td style="font-family:Arial;color:#ff6600">￥' + nodes[i].sale_price + '</td>');
            htmls.push('<td>&nbsp;</td>');
            htmls.push('<td><a href="javascript:;" onclick="removeProductData(this)">移除</a></td>');
            htmls.push('</tr>');
        }
    }
    $("#image-list-box-page-links").html(changeLinks);
    $("#fulloffbody").html(htmls.join("\n"));
    $("#image-list-box-page-links2").html(changeLinks2);
}
function removeProductData(obj) {
    var did = $(obj).parent("td").parent("tr").find("*[v='product-id']").val();
    initList = "";
    var pcount = postids.length;
    for (var i = 0; i < pcount; i++) {
        if (did == postids[i]) {
            postids.splice(i, 1);
        }
        if (did == jsonList[i].product_id) {
            jsonList.splice(i, 1);
            i--;
            pcount--;
        } else {
            initList = initList + jsonList[i].product_id + ",";
        }
    }
    $(obj).parent("td").parent("tr").remove();
}

function showFullProductSelector() {
    var exceptList = [];
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
			    jsonList = json;
			    pagecount = Math.ceil(jsonList.length / 10);
			    datacount = jsonList.length;
			    parseFullProductSelectorData(1);
			    postids = [];
			    initList = "";
			    for (var i = 0; i < jsonList.length; i++) {
			        postids.push(jsonList[i].product_id);
			        if (i > 0) initList += ",";
			        initList += jsonList[i].product_id;
			    }
			}, error: function (http, textStatus, errorThrown) {
			    jsbox.error(errorThrown);
			}
        });
    }, initList, exceptList, true, 1);//第四个参数ture=允许选择带Sku商品;false=禁止选择带Sku商品
}

function parseFullProductSelectorData(pageindex) {
    var ids = [];
    for (var i = 0; i < jsonList.length; i++) {
        ids.push(jsonList[i].product_id);
    }
    changeLinks = formatPageLink(pagecount, pageindex, 1);
    changeLinks2 = formatPageLink(pagecount, pageindex, 1);

    var htmls = [];
    var nodes = jsonList;
    for (var i = (pageindex - 1) * 10; i < pageindex * 10; i++) {
        //if(items.contains(json.product_id))
        //	continue;//去除重复的ID
        if (nodes[i] == null)
            break;
        htmls.push('<tr>');
        htmls.push('<td>&nbsp;</td>');
        htmls.push('<td style="width:70px;height:74px;"><input type="hidden" v="product-id" value="' + nodes[i].product_id + '"/>');
        htmls.push('<a href="<%=config.UrlHome%>' + nodes[i].product_id + '.html" target="_blank">');
        htmls.push('<img src="' + formatImageUrl(nodes[i].img_src, 120, 120) + '" style="width:60px;height:60px" alt=""/></a></td>');
        htmls.push('<td>');
        htmls.push('<p><a href="<%=config.UrlHome%>' + nodes[i].product_id + '.html" target="_blank">' + nodes[i].product_name + '</a></p>');
        htmls.push('<p class="pname" style="color:#999">编码：' + nodes[i].product_code + '</p></td>');
        htmls.push('<td style="font-family:Arial;color:#ff6600">￥' + nodes[i].sale_price + '</td>');
        htmls.push('<td>&nbsp;</td>');
        htmls.push('<td><a href="javascript:;" onclick="removeProductData(this)">移除</a></td>');
        htmls.push('</tr>');
    }
    $("#image-list-box-page-links").html(changeLinks);
    $("#fulloffbody").html(htmls.join("\n"));
    $("#image-list-box-page-links2").html(changeLinks2);
}




    </script>
    <script type="text/javascript">
        function selectThisCateg(event, typeId, name, obj) {
            if ($(obj).prop('checked')) {
                if ($(".selecedtype ul li[typeid=" + typeId + "]").length == 0);
                {
                    $(".selecedtype ul").append("<li typeid=" + typeId + "  rule_item_id=\"0\">" + name + "<a href='javascript:;' onclick='rem(" + typeId + ")' title='取消选择' style=\"float: right;\">取消选择</a></li>");
                }
            }
            else {
                $("[typeid=" + typeId + "]").remove();
            }
        }
        function rem(typeId) {
            $("[val=chk_" + typeId + "]").prop('checked', false);
            $("[typeid=" + typeId + "]").remove();
        }
        function clearTypes() {
            $("#class-list input:checkbox").prop('checked', false);
            $(".selecedtype ul").html("");
        }
    </script>
    <script type="text/javascript">
        function submitForm() {
            if (showLoadding)
                showLoadding();
            var obj = Atai.$("#tips-message");
            //var postData = getPostDB(form);
            var postids2 = "";
            for (var i = 0; i < postids.length; i++) {
                if (i > 0) postids2 += ",";
                postids2 += postids[i];
            }
            var nodes = [];
            var typeids2 = "";
            $(".selecedtype ul li").each(function () {
                var typeid = $(this).attr("typeid");
                nodes.push(typeid);
            });
            for (var i = 0; i < nodes.length; i++) {
                if (i > 0) typeids2 += ",";
                typeids2 += nodes[i];
            }
            $.ajax({
                url: "/MInsurance/PostInsuranceProductData"
                , data: "id=" + <%=id%>+"&proids=" + postids2+"&typeids=" + typeids2
                , type: "post"
                , dataType: "json"
                , success: function (json) {
                    obj.className = "tips-text tips-icon";
                    if (json.error) {
                        obj.innerHTML = json.message;
                    } else {
                        obj.className = "tips-text";
                        jsbox.success(json.message, window.location.href);
                    }
                    if (closeLoadding) closeLoadding();
                }
            });
            return false;
        }
    </script>
    <%Html.RenderPartial("MGoods/SelectProductControl"); %>
    <%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>

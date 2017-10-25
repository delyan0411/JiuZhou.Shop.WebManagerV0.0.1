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
                编辑seo规则
            </div>
            <div class="div-tab">
                <form id="SeoRuleForm" method="post" action="" onsubmit="return submitSeoRuleForm(this)">
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
                                @name=名称;@shop=商家名;@brand=品牌;@key=关键词;@promotion=卖点;@summary=商品说明;@manufacturer=生产厂家;@p_common_name=通用名;不区分大小写
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
                <table class="table" cellpadding="0" cellspacing="0">
                    <thead>
                        <tr>
                            <th>
                                选择类别 <b style="color: #F00">*</b>
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
                                    
                                    int tree = 0;                                                                        
                                    public void PrintList(int parentId, int ruleid,List<SeoRuleItemInfo> rils)
                                    {
                                        if (parentId < 0) return;
                                        List<TypeList> items = tList.FindAll(
                                            delegate(TypeList em)
                                            {
                                                return em.parent_type_id == parentId;
                                            });
                                        if (items.Count <= 0) return;
                                        //tree++;
                                        bool isHasChild = false;
                                        Response.Write("<ul>");
                                        isHasChild = true;
                                        List<SeoRuleItemInfo> srs = new List<SeoRuleItemInfo>();
                                        if (rils != null)
                                        {
                                            if (rils.Count > 0)
                                            {
                                                srs =
                                            rils.Where(t => t.elment_id == 1).ToList();
                                            }
                                            foreach (TypeList item in items)
                                            {
                                                string[] arr = item.product_type_path.Split(',');
                                                tree = arr.Length - 2;
                                                Response.Write("<li>");
                                                Response.Write("<div tree=\"" + tree + "\"><a href=\"javascript:;\" v=\"bt\" class='jslk'>&nbsp;</a>");
                                                Response.Write("<a href=\"javascript:;\" v=\"bt\" style=\"color:" + (item.is_visible > 0 ? "#000" : "#999") + "\">" + item.type_name + "</a>");
                                                List<TypeList> __ems = tList.FindAll(
                                                    delegate(TypeList e)
                                                    {
                                                        return e.parent_type_id == item.product_type_id;
                                                    });
                                                if (item.is_visible > 0 && (tree > 2 || __ems.Count == 0))
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
                                                    if (ruleid == -1)
                                                    {
                                                        Response.Write("<input type='checkbox' onclick=\"selectThisCateg(event," + item.product_type_id + ", '" + Utils.ToUnicode(clsName) + "',this)\" val='chk_" + item.product_type_id + "' />  ");
                                                    }
                                                    else
                                                    {
                                                        if (srs.Count > 0 || srs != null)
                                                        {
                                                            if (srs.Any(t => t.seo_elment_code == Convert.ToString(item.product_type_id)))
                                                                Response.Write("<input type='checkbox'   checked=\"checked\" onclick=\"selectThisCateg(event," + item.product_type_id + ", '" + Utils.ToUnicode(clsName) + "',this)\" val='chk_" + item.product_type_id + "' />  ");
                                                            else
                                                                Response.Write("<input type='checkbox' onclick=\"selectThisCateg(event," + item.product_type_id + ", '" + Utils.ToUnicode(clsName) + "',this)\" val='chk_" + item.product_type_id + "' />  ");
                                                        }
                                                        else
                                                            Response.Write("<input type='checkbox' onclick=\"selectThisCateg(event," + item.product_type_id + ", '" + Utils.ToUnicode(clsName) + "',this)\" val='chk_" + item.product_type_id + "' />  ");
                                                    }
                                                    Response.Write("</p>");
                                                }
                                                Response.Write("</div>");
                                                PrintList(item.product_type_id, ruleid, rils);
                                                Response.Write("</li>\r\n");
                                            }
                                        }
                                        else
                                        {
                                            foreach (TypeList item in items)
                                            {
                                                string[] arr = item.product_type_path.Split(',');
                                                tree = arr.Length - 2;
                                                Response.Write("<li>");
                                                Response.Write("<div tree=\"" + tree + "\"><a href=\"javascript:;\" v=\"bt\" class='jslk'>&nbsp;</a>");
                                                Response.Write("<a href=\"javascript:;\" v=\"bt\" style=\"color:" + (item.is_visible > 0 ? "#000" : "#999") + "\">" + item.type_name + "</a>");
                                                List<TypeList> __ems = tList.FindAll(
                                                    delegate(TypeList e)
                                                    {
                                                        return e.parent_type_id == item.product_type_id;
                                                    });
                                                if (item.is_visible > 0 && (tree > 2 || __ems.Count == 0))
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
                                                        Response.Write("<input type='checkbox' onclick=\"selectThisCateg(event," + item.product_type_id + ", '" + Utils.ToUnicode(clsName) + "',this)\" val='chk_" + item.product_type_id + "' />  ");
                                                    Response.Write("</p>");
                                                }
                                                Response.Write("</div>");
                                                PrintList(item.product_type_id, ruleid, rils);
                                                Response.Write("</li>\r\n");
                                            }
                                        }
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
                                    <%PrintList(0, ruleid, rils);%></div>
                            </td>
                            <td style="height: 300px; width: 400px;" class="selecedtype">
                                  <ul>
                                <% if (ruleid != -1)
                                   {
                                       List<SeoRuleItemInfo> srs =
                                           rils.Where(t => t.elment_id == 1).ToList();
                                       foreach (SeoRuleItemInfo sri in srs)
                                       {
                                           string clsName = "";
                                           if (tList.Any(t => t.product_type_id == Convert.ToInt32(sri.seo_elment_code)))
                                           {
                                               string[] _tem = tList.FirstOrDefault(t => t.product_type_id == Convert.ToInt32(sri.seo_elment_code)).product_type_path.Trim().Split(',');
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

                                           Response.Write("<li typeid=" + sri.seo_elment_code + "  rule_item_id=" + sri.rule_item_id + ">" + clsName + "<a href='javascript:;' onclick='rem(" + sri.seo_elment_code + ")' title='取消选择' style=\"float: right;\">取消选择</a></li>");
                                       }
                                   }
                                %>
                                </ul>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <table class="table" cellpadding="0" cellspacing="0">
                    <thead>
                        <tr>
                            <th>
                                选择品牌 <b style="color: #F00">*</b>
                            </th>
                            <th style="text-align: right">
                                <a href="javascript:;" onclick="clearBrands()" style="color: #999">清除选择</a>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td style="height: 300px; width: 500px;" class="brandlist">
                                <ul>
                                    <%                               
                                        List<BrandInfo> bList = GetBrandListAll.Do(-1).Body.brand_list;
                                        if (ruleid == -1)
                                        {
                                            foreach (BrandInfo bi in bList)
                                            {
                                                Response.Write("<li>" + bi.brand_name + "<input type='checkbox' onclick=\"selectThisbrand('" + bi.brand_id + "','" + bi.brand_name + "',this)\"  style=\"float:right;\" val='chkb_" + bi.brand_id + "' />  ");
                                            }
                                        }
                                        else
                                        {
                                            List<SeoRuleItemInfo> srs = new List<SeoRuleItemInfo>();
                                            if (rils.Count > 0)
                                            {
                                                srs =
                                            rils.Where(t => t.elment_id == 2).ToList();
                                            }
                                            foreach (BrandInfo bi in bList)
                                            {
                                                if(srs.Any(t=>t.seo_elment_code==Convert.ToString(bi.brand_id)))
                                                Response.Write("<li>" + bi.brand_name + "<input type='checkbox' checked=\"checked\"  onclick=\"selectThisbrand('" + bi.brand_id + "','" + bi.brand_name + "',this)\"  style=\"float:right;\" val='chkb_" + bi.brand_id + "' />  ");
                                                else
                                                    Response.Write("<li>" + bi.brand_name + "<input type='checkbox'   onclick=\"selectThisbrand('" + bi.brand_id + "','" + bi.brand_name + "',this)\"  style=\"float:right;\" val='chkb_" + bi.brand_id + "' />  ");   
                                            }
                                        }                             
                                    %>
                                </ul>
                            </td>
                            <td style="height: 300px; width: 400px;" class="selecedbrand">
                                <ul>
                                <% if (ruleid != -1)
                                   {
                                       List<SeoRuleItemInfo> srs =
                                           rils.Where(t => t.elment_id == 2).ToList();
                                       foreach (SeoRuleItemInfo sri in srs)
                                           Response.Write("<li brandid=" + sri.seo_elment_code + " rule_item_id=" + sri.rule_item_id + ">" + bList.FirstOrDefault(t => t.brand_id == Convert.ToInt32(sri.seo_elment_code)).brand_name + "<a href='javascript:;' onclick='rembrand(" + sri.seo_elment_code + ")' title='取消选择' style=\"float: right;\">取消选择</a></li>");
                                   }
                                %>
                                </ul>
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
                                <input type="button" id="loadding3" value="  确定提交  " onclick="$('#SeoRuleForm').submit()"
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

        function selectThisbrand(brandid, name, obj) {
            if ($(obj).prop('checked')) {
                if ($(".selecedbrand ul li[brandid=" + brandid + "]").length == 0);
                {
                    $(".selecedbrand ul").append("<li brandid=" + brandid + " rule_item_id=\"0\">" + name + "<a href='javascript:;' onclick='rembrand(" + brandid + ")' title='取消选择' style=\"float: right;\">取消选择</a></li>");
                }
            }
            else {
                $("[brandid=" + brandid + "]").remove();
            }
        }
        function rembrand(brandid) {
            $("[val=chkb_" + brandid + "]").prop('checked', false);
            $("[brandid=" + brandid + "]").remove();
        }
        function clearBrands() {
            $(".brandlist input:checkbox").prop('checked', false);
            $(".selecedbrand ul").html("");
        }
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

        function createXmlDocument(nodes) {
            var xml = '<?xml version="1.0" encoding="utf-8"?>';
            xml += '<items>';
            for (var i = 0; i < nodes.length; i++) {
                xml += nodes[i];
            }
            xml += '</items>';
            return xml;
        }
        function submitSeoRuleForm(form) {
            var isError = false;
            $("input[must='1']").each(function () {
                if ($(this).val() == "" && !$(this).attr("disabled")) {
                    isError = true;
                }
            });
            if (isError) {
                jsbox.error("请完成所有必填项的填写"); return false;
            }
            if ($(".selecedbrand ul li").length == 0 && $(".selecedtype ul li").length == 0) {
                jsbox.error("请在类别和品牌中至少选择一个"); return false;
            }
            if (showLoadding) showLoadding();

            var postData = getPostDB(form);

            var nodes = [];
            $(".selecedtype ul li").each(function () {
                var rule_item_id = $(this).attr("rule_item_id");
                var typeid = $(this).attr("typeid");
                var node = '<item rule_item_id="' + rule_item_id + '" elment_id="1"  seo_elment_code="' + typeid + '"></item>';
                nodes.push(node);
            });
            $(".selecedbrand ul li").each(function () {
                var rule_item_id = $(this).attr("rule_item_id");
                var brandid = $(this).attr("brandid");
                var node = '<item rule_item_id="' + rule_item_id + '" elment_id="2"  seo_elment_code="' + brandid + '"></item>';
                nodes.push(node);
            })
            var xml = createXmlDocument(nodes);
            $.ajax({
                url: "/MGoods/PostSeoRule"
		, data: postData + "&xml=" + encodeURIComponent(xml)
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

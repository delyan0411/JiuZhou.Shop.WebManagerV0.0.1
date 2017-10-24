<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %><%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %><%@ Import Namespace="JiuZhou.Cache" %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);  
    %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<% string allowSku = "true";
   string isSku = "false";
   int _count = 0;
        %>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/style/style.css" rel="stylesheet" type="text/css" />
<%Html.RenderPartial("Base/_PageHeadControl"); %>
<title><%=ViewData["pageTitle"]%></title>
<% 
    ProductJoinInfo Info = (ProductJoinInfo)(ViewData["Info"]);
    if (Info == null)
        Info = new ProductJoinInfo();
    %>
</head>

<body>
<%Html.RenderPartial("Base/_SimplePageTopControl"); %>
<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
<div class="position">
当前位置：
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <a href="/mgoods/join">商品关联列表</a> &gt;&gt; <span>商品关联列表</span>
</div>
<form action="" method="get" onsubmit="return searchProduct(this)">
			<div class="div-tab-h1" style="font-weight:100;color:#333;font-size:12px">
		<p><select id="stype" name="stype" style="width:80px">
			<option value="0" init="true">综合搜索</option>
            <option value="1">商品编码</option>
            <option value="2">商品名称</option>
            <option value="3">品牌名称</option>
		</select>
</p>
<p>
		<input type="text" id="sQuery" name="q" value="" class="input" autocomplete="off" style="width:390px;height:24px;line-height:24px;"/></p>
<p>
<input type="submit" value=" 搜索 " class="submit"/>
</p>
<p><a href="javascript:;" onclick="clearData()">清空搜索结果</a></p>
<div class="clear"></div>
			</div>
</form>

<div id="data-list-page-links" style="display:none" class="page-idx"></div>
<div id="data-list"></div>
<div id="data-list-page-links2" style="display:none" class="page-idx"></div>

		<div class="editor-box-head">
编辑信息
		</div>
		<div class="div-tab">
<form id="dataForm" method="post" action="" onsubmit="return submitJoinDataForm(this)">
<input type="hidden" name="JoinID" value="<%=Info.product_join_id%>"/>
<table class="table" cellpadding="0" cellspacing="0">
<tbody>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">规则名称<b>*</b></td>
    <td class="inputText">
    <input type="text" name="name" value="<%=Info.join_name%>" class="input" />
    </td>
    <td class="lable">规则类别</td>
	<td>
<select id="typeName" name="type">
   <option value="" init="true">请选择类别</option>
   <option value="颜色分类" selected="selected">颜色分类</option>
   <option value="商品规格">商品规格</option>
</select>
	</td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">刷新页面</td>
    <td class="inputText">
    <input type="radio" name="allowRefresh" onclick="checkedthis1(this)" value="1"<%=Info.allow_refresh<1?"":" checked='checked'"%>/> 刷新
    &nbsp;|&nbsp;
    <input type="radio" name="allowRefresh" onclick="checkedthis1(this)" value="0"<%=Info.allow_refresh>0?"":" checked='checked'"%>/> 不刷新
    </td>
    <td class="lable">显示类型</td>
	<td>
    <input type="radio" name="viewType" onclick="checkedthis2(this)" value="0"<%=Info.view_type>0?"":" checked='checked'"%>/> 文字
    &nbsp;|&nbsp;
    <input type="radio" name="viewType" onclick="checkedthis2(this)" value="1"<%=Info.view_type<1?"":" checked='checked'"%>/> 图片
    </td>
  </tr>
  </tbody>
</table>
</form>
<script type="text/javascript">
    function checkedthis1(obj) {
        if (obj.checked) {
            $(obj).attr("checked", true);
            $("input[name='allowRefresh']").each(function () {
                if (this != obj)
                    $(this).attr("checked", false);
            });
        } else {
            $(obj).attr("checked", false);
            $("input[name='allowRefresh']").each(function () {
                if (this != obj)
                    $(this).attr("checked", true);
            });
        }
    }

    function checkedthis2(obj) {
        if (obj.checked) {
            $(obj).attr("checked", true);
            $("input[name='viewType']").each(function () {
                if (this != obj)
                    $(this).attr("checked", false);
            });
        } else {
            $(obj).attr("checked", false);
            $("input[name='viewType']").each(function () {
                if (this != obj)
                    $(this).attr("checked", true);
            });
        }
    }

Atai.addEvent(window,"load",function(){
	dropShopID=new _DropListUI({
		input: Atai.$("#typeName")
	});dropShopID.maxHeight="320px";dropShopID.width="100px";
	dropShopID.init();
	<%=string.IsNullOrEmpty(Info.type_name)?"":("dropShopID.setDefault('"+ Info.type_name +"');")%>
});
</script>
<br/>
<table id="join-data" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th colspan="2">关联商品清单</th>
    <th style="width:26%">显示名称</th>
    <th style="width:14%">排序</th>
    <th style="width:8%">操作</th>
  </tr>
</thead>
<tbody>
<%
    List<ProductJoinItemInfo> infoList = (List<ProductJoinItemInfo>)ViewData["InfoList"];
    if (infoList == null) {
        infoList = new List<ProductJoinItemInfo>(); 
    }
    
	foreach(ProductJoinItemInfo item in infoList){
        if (item.sku_count == 0)
            allowSku = "false";
        if (item.sku_count > 0)
            isSku = "true";
        _count++;
%>

  <tr rowType="parent">
    <td style="width:70px;height:70px;"><input type="hidden" name="itemid" value="<%=item.join_item_id%>"/>
    	<input type="hidden" name="productid" value="<%=item.product_id%>"/>
    	<a href="<%=config.UrlHome + item.product_id%>.html" target="_blank"><img src="<%=FormatImagesUrl.GetProductImageUrl(item.img_src,120,120)%>" style="width:60px;height:60px"/></a>
    </td>
    <td><p><a href="<%=config.UrlHome + item.product_id%>.html" target="_blank"><%=item.product_name%></a></p>
    <p class="pname" style="color:#999">商品编码：<%=item.product_code%>&nbsp;<strong style="font-family:Arial;color:#ff6600">￥<%=item.sale_price%></strong></p></td>
    <td><input type="text" name="name" value="<%=item.item_name%>" class="input" style="width:220px;"/></td>
    <td class="move-links">
    <a href="javascript:void(0);" onclick="moveRow(this,'first');" class="move-first" title="置顶">&nbsp;</a>
    <a href="javascript:void(0);" onclick="moveRow(this,'up');" class="move-up" title="上移">&nbsp;</a>
    <a href="javascript:void(0);" onclick="moveRow(this,'down');" class="move-down" title="下移">&nbsp;</a>
    <a href="javascript:void(0);" onclick="moveRow(this,'last');" class="move-last" title="最末">&nbsp;</a>
    </td>
    <td><a id="remove-link-<%=item.product_id%>" href="javascript:;" v="<%=item.product_id%>" onclick="removeRow(this)">移除</a></td>
  </tr>
<%
	}
%>
</tbody>
</table>

<br/>
<table class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:3%">&nbsp;</th>
    <th class="lable"><input type="button" id="loadding3" value="  确定保存  " class="submit" onclick="$('#dataForm').submit()"/></th>
    <th colspan="2"><div class="tips-text" id="tips-message"></div></th>
  </tr>
  </thead>
</table>
<br/><br/><br/>
		</div>
	</div>
</div>
<br/><br/>
<script type="text/javascript">
    var allowSku = "<%=allowSku %>";
    var isSku = "<%=isSku %>";
    var _table = false;
    var _pageindex = 1;
    var _count = <%=_count %>;
    Atai.addEvent(window, "load", function () {
        var _tab = Atai.$("#join-data");
        _table = new AtaiTable(_tab);
        _table.firstRowIndex = 1;
    });
    function moveRow(childObj, moveType) {
        _isModify = true;
        _table.moveRow(_table.getRowByChild(childObj).obj, moveType);
        resetRowClassName(_table._table);
    }
    function removeRow(childObj) {
        _count = _count - 1;
        _table.removeRow(_table.getRowByChild(childObj).obj);
        var o = $("#checkbox-" + $(childObj).attr('v'));
        if (o) o.attr("checked", false);
        var line = $("*[rowType='parent']");
        if (line.length == 0) {
        allowSku = "true";
        isSku = "false";
        getProductList(_pageindex);
        }
    }
</script>
<script type="text/javascript">
function createXmlDocument(nodes){
	var xml='<?xml version="1.0" encoding="utf-8"?>';
	xml += '<items>';
	for(var i=0;i<nodes.length;i++){
		xml += nodes[i];
	}
	xml += '</items>';
	return xml;
}
/*
json={
	path=imagePath
	,imgid=imageID
	,isdef=isDefault
}
*/
function createXmlNode(json){
	var xml = '<item itemid="'+ json.ItemID +'" productid="'+ json.ProductID +'" sort="'+ json.Sort +'">';
	xml += '<name><![CDATA['+ json.Name +']]></name>';
	xml += '</item>';
	return xml;
}
function submitJoinDataForm(form) {
	if(showLoadding) showLoadding();
	var postData=getPostDB(form);
	var nodes=[];
	var isError=false;
	var sortIndex=0;
	$("#join-data tbody tr").each(function(){
		var itemid=$(this).find("input[name='itemid']").val();
		var productid=$(this).find("input[name='productid']").val();
		var name=$(this).find("input[name='name']").val();
		sortIndex++;
		if(name.length<1){
			isError=true;
		}
		nodes.push(createXmlNode({
			 "ItemID" : itemid
			,"ProductID" : productid
			,"Sort" : sortIndex
			,"Name" : name
		}));
	});
	if(nodes.length<2){
		jsbox.error("请至少选择2个关联商品");
		if(closeLoadding) closeLoadding();
		return false;
	}
	if(isError){
		jsbox.error("[显示名称] 不能为空");
		if(closeLoadding) closeLoadding();
		return false;
	}
	var xml = createXmlDocument(nodes);
	$.ajax({
		url: "/MGoods/PostProductJoinData"
		, data: postData + "&xml=" + encodeURIComponent(xml)
        , type: "post"
		, dataType: "json"
		, success: function(json){
			if(json.error){
				jsbox.error(json.message);
			}else{
                jsbox.success(json.message, window.location.href);
				_isModify=false;
				//window.location.href=window.location.href;
			}
			if(closeLoadding) closeLoadding();
		}
	});
	return false;
}
</script>
<script type="text/javascript">
    var qInitValue = "请输入商品名称 / 品牌名";
    $(function () {
        dropSType = new _DropListUI({
            input: Atai.$("#stype")
        }); dropSType.maxHeight = "260px"; dropSType.width = "80px";
        dropSType.init();
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
    function searchProduct(form) {
        var sQuery = Atai.$("#sQuery");
        if (sQuery.value == qInitValue) {
            sQuery.value = "";
        }
        getProductList(1);
        return false;
    }
    function getProductList(pageindex) {
        var sType = $("#stype option:selected").val();
        var query = $("#sQuery").val();
        if (!pageindex || !Atai.isInt(pageindex)) pageindex = 1;

        $.ajax({
            url: "/MTools/SeachProduct?t=" + new Date().getTime()
		, type: "post"
		, data: {
		    size: 6
			, page: pageindex
			, stype: sType
			, q: ((query == qInitValue) ? "" : query)
		}
		, dataType: "json"
		, success: function (json, textStatus) {
		    parseProductHtml(json.data, json.pageCount, json.index);
		    _pageindex = pageindex;
		}, error: function (http, textStatus, errorThrown) {
		    jsbox.error("查询失败");
		}
        });
    }
    var _sData = false;
    function parseProductHtml(data, count, index) {
        var html = '<table class="table" cellpadding="0" cellspacing="0">';
        html += '<thead><tr>';
        html += '<th colspan="2">商品名</th>';
        html += '<th style="width:14%">价格</th>';
        html += '<th style="width:12%">选择</th></tr></thead>';
        html += '<tbody>';
        _sData = data;
        for (var i = 0; i < data.length; i++) {
            var json = data[i];
            html += '<tr><td style="width:70px;height:70px;">';
            html += '<input type="hidden" id="hiddenId-' + json.product_id + '" value="' + json.product_id + '"/>';
            html += '<a href="<%=config.UrlHome%>' + json.product_id + '.html" target="_blank"><img src="' + formatImageUrl(json.img_src, 120, 120) + '" style="width:60px;height:60px"/></a></td>';
            html += '<td><p><a href="<%=config.UrlHome%>' + json.product_id + '.html" target="_blank">' + json.product_name + '</a></p>';
            html += '<p class="pname" style="color:#999">商品编码：' + json.product_code + '</p></td>';
            html += '<td>';
            html += '<p style="color:#ff6600;">售&nbsp;价：' + json.sale_price + '</p>';
            html += '<p style="color:#ff6600;">手&nbsp;机：' + json.mobile_price + '</p></td>';
            var skustr = "";
            var allow = "";
            var allowclick = "href='javascript:;' onclick='selectCheckbox(" + json.product_id + ")'";
            if (allowSku == "false" && json.sku_count > 0) {
                skustr = "(含SKU)";
                allow = "disabled='disabled'";
                allowclick = "";
            }
            if (isSku == "true" && json.sku_count == 0) {
                skustr = "(不含SKU)";
                allow = "disabled='disabled'";
                allowclick = "";
            }
            html += '<td><input id="checkbox-' + json.product_id + '" type="checkbox" value="' + json.product_id + '" onclick="selectCheckbox(' + json.product_id + ')" ' + allow + '/>';
            html += '<a '+ allowclick +'>选择' + skustr + '</a></td>';
            html += '</tr>';
        }
        html += '</tbody>';
        html += '</table>';
        $("#data-list").html(html);
        var changeLinks = formatAjaxPageLink(count, index); //data-list-page-links
        var changeLinks2 = formatAjaxPageLink(count, index); //data-list-page-links2
        $("#data-list-page-links").css({ "display": "block" }).html(changeLinks);
        $("#data-list-page-links2").css({ "display": "block" }).html(changeLinks2);
    }
    var _formatAjaxPageLinkCount = 0;
    function formatAjaxPageLink(pagecount, pageindex) {
        _formatAjaxPageLinkCount++;
        var arr = [];
        var maxCount = 8;
        var n = pageindex - (maxCount / 2);
        if (n <= 0) n = 1;
        if (pageindex > 1) {
            arr.push("		<a href=\"javascript:ajaxChangePage(1);\" title=\"首页\">&lt;&lt;</a>");
            arr.push("		<a href=\"javascript:ajaxChangePage(" + (pageindex - 1) + ")\" title=\"上页\">&lt;</a>");
        } else {
            arr.push("		<strong>&lt;&lt;</strong>");
            arr.push("		<strong>&lt;</strong>");
        }
        for (var k = n; k < (n + maxCount); k++) {
            if (k <= pagecount) {
                if (k == pageindex) {
                    arr.push("		<strong><span>" + k + "</span></strong>");
                } else {
                    arr.push("		<a href=\"javascript:ajaxChangePage(" + k + ")\" title=\"第" + k + "页\">" + k + "</a>");
                }
            } else {
                if (k == pageindex)
                    arr.push("		<strong><span>" + k + "</span></strong>");
            }
        }
        if (pageindex < pagecount) {
            arr.push("		<a href=\"javascript:ajaxChangePage(" + (pageindex + 1) + ")\" title=\"下页\">&gt;</a>");
            arr.push("		<a href=\"javascript:ajaxChangePage(" + pagecount + ")\" title=\"末页\">&gt;&gt;</a>");
        } else {
            arr.push("		<strong>&gt;</strong>");
            arr.push("		<strong>&gt;&gt;</strong>");
        }
        arr.push("		<strong class=\"txt\"><span>" + pageindex + "</span>/" + pagecount + "</strong>");
        arr.push("		<strong class=\"goto\"><input id=\"goto-" + _formatAjaxPageLinkCount + "\" type=\"text\" value=\"" + (pageindex + 1 < pagecount ? (pageindex + 1) : pagecount) + "\" onclick=\"this.select()\"/></strong>");
        arr.push("		<a href=\"javascript:;\" onclick=\"ajaxChangePage(Atai.$('#goto-" + _formatAjaxPageLinkCount + "').value)\" title=\"GO\">GO</a>");
        return arr.join("\r\n");
    }
    function ajaxChangePage(pageIndex) {
        getProductList(pageIndex);
    }
    function clearData() {
        $("#data-list-page-links").css({ "display": "none" }).html("");
        $("#data-list-page-links2").css({ "display": "none" }).html("");
        $("#data-list").html("");
    }
</script>
<script type="text/javascript">
    function selectCheckbox(productId) {
        var checkbox = $("#checkbox-" + productId);
        if (!checkbox.attr("checked")) {
            checkbox.attr("checked", true); //选中
            selectProduct(productId);
        } else {
            checkbox.attr("checked", false); //取消选中
            if ($("#remove-link-" + productId))
                $("#remove-link-" + productId).click();
        }
    }
    function selectProduct(productId) {
        var checkbox = $("#checkbox-" + productId);
        if (!checkbox.attr("checked")) {
            if ($("#remove-link-" + productId))
                $("#remove-link-" + productId).click();
            return;
        }
        var selected = false;
        $("#join-data input[name='productid']").each(function () {
            if ($(this).val() == productId) {
                selected = true;
            }
        });
        if (selected) return;
        var json = false;
        if (_sData && _sData.length > 0) {
            for (var i = 0; i < _sData.length; i++) {
                if (_sData[i].product_id == productId) {
                    json = _sData[i]; break;
                }
            }
        }
        if (!json) return;
        _count++;
        if (json.sku_count == 0)
            allowSku = "false";
        if (json.sku_count > 0)
            isSku = "true";
        var html = '<tr rowType="parent">';
        html += '<td style="width:70px;height:70px;"><input type="hidden" name="itemid" value=""/>';
        html += '<input type="hidden" name="productid" value="' + json.product_id + '"/>';
        html += '<a href="<%=config.UrlHome%>' + json.product_id + '.html" target="_blank"><img src="' + formatImageUrl(json.img_src, 120, 120) + '" style="width:60px;height:60px"/></a></td>';
        html += '<td><p><a href="<%=config.UrlHome%>' + json.product_id + '.html" target="_blank">' + json.product_name + '</a></p>';
        html += '<p class="pname" style="color:#999">商品编码：' + json.product_code + '&nbsp;<strong style="font-family:Arial;color:#ff6600">￥' + json.sale_price + '</strong></p></td>';

        html += '<td><input type="text" name="name" value="" class="input" style="width:220px;"/></td>';
        html += '<td class="move-links">';
        html += '<a href="javascript:void(0);" onclick="moveRow(this,\'first\');" class="move-first" title="置顶">&nbsp;</a>';
        html += '\n<a href="javascript:void(0);" onclick="moveRow(this,\'up\');" class="move-up" title="上移">&nbsp;</a>';
        html += '\n<a href="javascript:void(0);" onclick="moveRow(this,\'down\');" class="move-down" title="下移">&nbsp;</a>';
        html += '\n<a href="javascript:void(0);" onclick="moveRow(this,\'last\');" class="move-last" title="最末">&nbsp;</a>';
        html += '</td>';

        html += '<td><a id="remove-link-' + json.product_id + '" href="javascript:;" v="' + json.product_id + '" onclick="removeRow(this)">移除</a></td>';
        html += '</tr>';
        $("#join-data tbody").append(html);
        if(_count==1)
        getProductList(_pageindex);
    }
</script>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>
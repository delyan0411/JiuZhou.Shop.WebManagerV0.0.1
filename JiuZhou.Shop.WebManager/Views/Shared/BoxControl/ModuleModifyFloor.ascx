<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="System.Collections.Generic" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.MySql" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %>
<%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
	int tid = DoRequest.GetQueryInt("tid");
%>
<div id="moduleModifyFloor-boxControl" class="moveBox" style="width:960px;height:680px;">
	<div class="name">
		编辑信息
		<div class="close" id="moduleModifyFloor-boxControl-close" v="atai-shade-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<form action="" onsubmit="return postModuleFloor(this)">
<input type="hidden" id="st-id-list" name="tid" value="<%=tid %>"/>
<input type="hidden" id="module-mid-list" name="mid" value=""/>
	<div id="moduleModifyFloor-tips-text" class="tips-text" style="margin:2px auto">&nbsp;</div>
<table>
  <tr>
    <td class="left" style="width:60px">背景图(必填)：</td>
    <td><input type="text" id="module-backurl-list" name="backurl" class="input" value=""/>
    &nbsp;
    </td>
    <td class="left" style="width:60px">距离顶部高度(必填)：</td>
    <td><input type="text" id="fpadding" name="fpadding" class="input" value=""/>
    &nbsp;
    </td>
  </tr>
  <tr>
    <td class="left" style="width:60px">楼层高度(必填)：</td>
    <td><input type="text" id="fheight" name="fheight" class="input" value=""/>
    &nbsp;
    </td>
    <td class="left" style="width:60px">楼层商品数量：</td>
    <td><select id="sum" name="sum" >
    <option value="8">8</option>
    <option value="11">11</option>
    </select>
    &nbsp;
    </td>
  </tr>
</table>
<div class="console">&nbsp;&nbsp;关键词:
	<input type="text" id="module-item-squery" value="" class="input" onblur="moduleSearchFloorProduct()"/>
    &nbsp;
	<a href="javascript:;">搜索</a><%--moduleItemFloorAdd--%>
    &nbsp;
    <span v="select-count"></span>
</div>
<%--数据列表开始--%>
<div class="module-box-data-list">
<div class="search-result">
<ul id="module-box-search-result" class="module-box-list" style="height:320px">

</ul>
</div>
<div class="select-result">
<ul id="module-box-data-list" class="module-box-list" style="height:320px">

</ul>
</div>
<div class="clear"></div>
</div>
<%--数据列表结束--%>
<table>
  <tr>
    <td class="left" style="width:40px;height:620px;">&nbsp;</td>
    <td>
<input type="submit" class="submit" value="保 存" style="width:160px;text-align:center;"/>
    </td>
  </tr>
</table>
</form>
</div>
 <script type="text/javascript">
     var __moduleModifyFloorDialog = false;
     function moduleModifyFloor(mId) {
         __moduleModifyFloorDialog = false;
         var boxId = "#moduleModifyFloor-boxControl";
         var box = Atai.$(boxId);
         var _dialog = _dialog = new AtaiShadeDialog();
         _dialog.zIndex = 99;
         _dialog.init({
             obj: box
		, sure: function () { }
		, CWCOB: false
         });
         __moduleModifyFloorDialog = _dialog;

         $.ajax({
             url: "/MPromotions/GetModuleItems?t=" + new Date().getTime()
		, type: "post"
		, data: { "mid": mId }
		, dataType: "json"
		, success: function (json, textStatus) {
		    if (json.error) {
		        jsbox.error(json.message);
		    } else {
		        $(__moduleModifyFloorDialog.dialog).find("input[name='mid']").val(json.data.st_module_id);
		        $(__moduleModifyFloorDialog.dialog).find("input[name='backurl']").val(json.data.module_desc);
		        $(__moduleModifyFloorDialog.dialog).find("input[name='fpadding']").val(json.data.is_full_screen);
		        $(__moduleModifyFloorDialog.dialog).find("input[name='fheight']").val(json.data.allow_show_name);
		        $(__moduleModifyFloorDialog.dialog).find("input[name='sum']").val(json.data.cell_count);
		        moduleInitFloorItem(json.items);
		        moduleSelectFloorItemsCount();
		        $(__moduleModifyFloorDialog.dialog).find("#moduleModifyFloor-tips-text").html("");
		        $(__moduleModifyFloorDialog.dialog).find("#module-box-search-result").html("");
		    }
		}, error: function (http, textStatus, errorThrown) {
		    jsbox.error(errorThrown);
		}
         });
         return false;
     }
     function moduleSearchFloorProduct() {
         var query = $(__moduleModifyFloorDialog.dialog).find("#module-item-squery").val();
         $.ajax({
             url: "/MTools/SeachProduct?t=" + new Date().getTime()
		, type: "post"
		, data: {
		    size: 200
			, page: 1
			, stype: 0
			, q: query
		}
		, dataType: "json"
		, success: function (json, textStatus) {
		    moduleAppendFloorSearchResult(json.data, json.pageCount, json.index);
		}, error: function (http, textStatus, errorThrown) {
		    jsbox.error("查询失败");
		}
         });
     }

     function moduleInitFloorItem(items) {
         var html = '';
         for (var i = 0; i < items.length; i++) {
             var json = items[i];
             html += '<li order="' + 1 + '"><input type="hidden" name="productId" value="' + json.product_id + '"/>';
             html += '<input type="hidden" name="itemid" value="' + json.st_item_id + '"/>';
             html += '<div class="img"><img src="' + (formatImageUrl(json.img_src, 60, 60)) + '" alt="" style=\"width:60px;height:60px;\"/></div>';
             html += '<div class="title"><a href="<%=config.UrlHome%>' + json.product_id + '.html" target="_blank">' + json.product_name + '</a>';
             html += '<p class="move-links">';
             html += '<a href="javascript:void(0);" onclick="moduleItemsFloorMove(this,\'first\');" class="move-first" title="置顶">&nbsp;</a>';
             html += '<a href="javascript:void(0);" onclick="moduleItemsFloorMove(this,\'up\');" class="move-up" title="上移">&nbsp;</a>';
             html += '<a href="javascript:void(0);" onclick="moduleItemsFloorMove(this,\'down\');" class="move-down" title="下移">&nbsp;</a>';
             html += '<a href="javascript:void(0);" onclick="moduleItemsFloorMove(this,\'last\');" class="move-last" title="最末">&nbsp;</a>';
             html += '</p></div>';
             html += '<div class="op-link"><a href="javascript:;" onclick="removeModuleFloorDataItem(this)">移除</a></div>';
             html += '<p class="clear"></p>';
             html += '</li>';
         }
         $(__moduleModifyFloorDialog.dialog).find("#module-box-data-list").html(html);
         var nodes = $(__moduleModifyFloorDialog.dialog).find("#module-box-data-list li");
         $(__moduleModifyFloorDialog.dialog).find("#module-box-data-list").scrollTop(nodes.length * 70);
     }

     function moduleAppendFloorSearchResult(data, pageCount, pageIndex) {
         var arr = [];
         var nodes = $(__moduleModifyFloorDialog.dialog).find("#module-box-data-list").find("input[name=productId]");
         for (var i = 0; i < data.length; i++) {
             var json = data[i];
             arr.push('<li>');
             arr.push('<div class="img"><img src="' + (formatImageUrl(json.img_src, 60, 60)) + '" alt="" style=\"width:60px;height:60px;\"/></div>');
             arr.push('<div class="title"><a href="<%=config.UrlHome%>' + json.product_id + '.html" target="_blank">' + json.product_name + '</a></div>');
             var style = '';
             for (var kk = 0; kk < nodes.length; kk++) {
                 if ($(nodes[kk]).val() == json.product_id) {
                     style = ' style="color:#999"'; break;
                 }
             }
             arr.push('<div class="op-link"><a href="javascript:;" v="' + json.product_id + '" onclick="moduleItemFloorAdd(this,' + json.product_id + ')"' + style + '>选择</a></div>');
             arr.push('<p class="clear"></p>');
             arr.push('</li>');
         }
         $(__moduleModifyFloorDialog.dialog).find("#module-box-search-result").html(arr.join(""));
     }

     function removeModuleFloorDataItem(obj) {
         var p_id = $(obj).parent().parent().find("input[name=productId]").val();
         $(obj).parent().parent().remove();
         $(__moduleModifyFloorDialog.dialog).find("#module-box-search-result").find("a[v=" + p_id + "]").css({ "color": "#06F" });
         moduleSelectFloorItemsCount();
     }
     function moduleSelectFloorItemsCount() {
         $(__moduleModifyFloorDialog.dialog).find("span[v=select-count]").css({ "color": "#f00" }).html("已选 " + $(__moduleModifyFloorDialog.dialog).find("#module-box-data-list").find("input[name=productId]").length + " 个商品");
     }
     function moduleItemsFloorMove(obj,type) {
         var mObj = $(obj).parent().parent().parent();
         var nodes = $(__moduleModifyFloorDialog.dialog).find("#module-box-data-list li");
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
     function moduleAppendFloorItem(json) {
         var _len = $("#module-box-data-list li").length + 1;
         var html = '';
         html += '<li order="' + _len + '"><input type="hidden" name="productId" value="' + json.product_id + '"/>';
         html += '<input type="hidden" name="itemid" value="0"/>';
         html += '<div class="img"><img src="' + (formatImageUrl(json.img_src, 60, 60)) + '" alt="" style=\"width:60px;height:60px;\"/></div>';
         html += '<div class="title"><a href="<%=config.UrlHome%>' + json.product_id + '.html" target="_blank">' + json.product_name + '</a>';

         html += '<p class="move-links">';
         html += '<a href="javascript:void(0);" onclick="moduleItemsFloorMove(this,\'first\');" class="move-first" title="置顶">&nbsp;</a>';
         html += '<a href="javascript:void(0);" onclick="moduleItemsFloorMove(this,\'up\');" class="move-up" title="上移">&nbsp;</a>';
         html += '<a href="javascript:void(0);" onclick="moduleItemsFloorMove(this,\'down\');" class="move-down" title="下移">&nbsp;</a>';
         html += '<a href="javascript:void(0);" onclick="moduleItemsFloorMove(this,\'last\');" class="move-last" title="最末">&nbsp;</a>';
         html += '</p></div>';

         html += '<div class="op-link"><a href="javascript:;" onclick="removeModuleFloorDataItem(this)">移除</a></div>';
         html += '<p class="clear"></p>';
         html += '</li>';
         $(__moduleModifyFloorDialog.dialog).find("#module-box-data-list").append(html);
         $(__moduleModifyFloorDialog.dialog).find("#module-item-id").val("");
         var nodes = $("#module-box-data-list li");
         $(__moduleModifyFloorDialog.dialog).find("#module-box-data-list").scrollTop(nodes.length * 70);
     }

     function moduleItemFloorAdd(obj, p_id) {
         var tips = $(__moduleModifyFloorDialog.dialog).find("#moduleModifyFloor-tips-text");
         tips.html("");
         var nodes = $(__moduleModifyFloorDialog.dialog).find("input[name=productId]");
         for (var i = 0; i < nodes.length; i++) {
             if (nodes[i].value == p_id) {
                 tips.html("列表中已存在该商品");
                 return false;
             }
         }
         $.ajax({
             url: "/MTools/GetProductInfo2?t=" + new Date().getTime()
		, type: "post"
		, data: {
		    "productid": p_id
		}
		, dataType: "json"
		, success: function (json, textStatus) {
		    moduleAppendFloorItem(json);
		    $(obj).css({ "color": "#999" });
		    moduleSelectFloorItemsCount();
		}, error: function (http, textStatus, errorThrown) {
		    tips.html(errorThrown);
		}
         });
         return false;
     }

     function parseModuleFloorItems(json, items) {
         var module = $("#module-" + json.st_module_id);
         if (module) {
             if (json.allow_show_name != "0") {
                 var html = "<div class=\"tb-module tshop-um tshop-um-mokuai6\" style=\"height:" + (parseInt(json.allow_show_name) + parseInt(json.is_full_screen)) + "px;\">";
             }
             else {
                 var html = "<div class=\"tb-module tshop-um tshop-um-mokuai6\">";
             }
             var style = "";
//             $(__moduleModifyFloorDialog.dialog).find("input[name='fpadding']").val(json.data.module_content);
//             $(__moduleModifyFloorDialog.dialog).find("input[name='fheight']").val(json.data.module_height);
         if (json.module_desc != "") {
             style += "background-image:url(" + json.module_desc + ");";
         }
         if (json.allow_show_name != "0" || json.allow_show_name != "") {
             style += "height:" + json.allow_show_name + "px;";
         }
         if (json.is_full_screen != "") {
             style += "padding-top:" + json.is_full_screen + "px;";
         }
             html += "<div class=\"jz-fullScreen\" style="+style+" >";         
             html += '<ul class=\"product_list\">';
             for (var i = 0; i < items.length; i++) {
                 if (i > 7)
                     break;
                 if (i == 3 || i == 7) {
                     html +="<li  style=\"margin-right:0px;\">";
                 }
                 else {
                     html +="<li>";
                 }
                 var em = items[i];
                 html += '<a href="<%=config.UrlHome%>' + em.product_id + '.html" target="_blank"><div class="product-img"><img src="' + (formatImageUrl(em.img_src, 350, 350)) + '" alt=' + em.product_name + '/></div><div class="spec"><span class="name">' + em.product_name + '</span><span class="maidian">' + em.sales_promotion + '</span><span class="thj">特惠价￥<b>' + em.sale_price + '</b></span></div></a></li>';
             }
             html += '</ul></div><div class="clear"></div></div>';
             $(module).children(".module-bd").html(html);
         }
     }

     function postModuleFloor(form) {
         var productIds = "";
         var bId = "#moduleModifyFloor-boxControl";
         var itemids = "";
         var nodes2 = $(form).find("input[name='itemid']");
         $(__moduleModifyFloorDialog.dialog).find("#moduleModifyFloor-tips-text").html("");
         var nodes = $(form).find("input[name=productId]");
         if (nodes.length < 1) {
             $(__moduleModifyFloorDialog.dialog).find("#moduleModifyFloor-tips-text").html("请添加商品");
             return false;
         }
         if ($(form).find("input[name='backurl']").val() == "") {
             $(__moduleModifyFloorDialog.dialog).find("#moduleModifyFloor-tips-text").html("请填写背景图");

             return false;
         }
         if ($(form).find("input[name='fpadding']").val() == "") {
             $(__moduleModifyFloorDialog.dialog).find("#moduleModifyFloor-tips-text").html("楼层高度");         
             return false;
         }
         if ($(form).find("input[name='fheight']").val()=="") {
             $(__moduleModifyFloorDialog.dialog).find("#moduleModifyFloor-tips-text").html("距离顶部高度");
             return false;
         }


//         var columnCount = $(form).find("input[name=columnCount]:checked").val();
//         if (columnCount == undefined) {
//             columnCount = 4;
//         }
         var columnCount = 4;
         for (var i = 0; i < nodes.length; i++) {

             productIds = productIds + nodes[i].value + ",";
         }

         for (var i = 0; i < nodes2.length; i++) {
             itemids += nodes2[i].value + ",";
         }
         //             $(__moduleModifyFloorDialog.dialog).find("input[name='fpadding']").val(json.data.module_content);
         //             $(__moduleModifyFloorDialog.dialog).find("input[name='fheight']").val(json.data.module_height);
         if ($(form).find("input[name='fheight']").val())
         var postData = {
             "mid": $(form).find("input[name='mid']").val()
        , "stid": $(form).find("input[name='tid']").val()
       	, "allowShowName": $(form).find("input[name='fheight']").val()
		, "name2": $(form).find("input[name='backurl']").val()
		, "IsFullScreen": $(form).find("input[name='fpadding']").val()
		, "columnCount": columnCount
		, "productIds": productIds
        , "itemids": itemids
         };
         $.ajax({
             url: "/MPromotions/PostModuleItems?t=" + new Date().getTime()
		, type: "post"
		, data: postData
		, dataType: "json"
		, success: function (json, textStatus) {
		    if (json.error) {
		        $(__moduleModifyFloorDialog.dialog).find("#moduleModifyFloor-tips-text").html(json.message);
		    } else {
		        $(__moduleModifyFloorDialog.dialog).find("*[v='atai-shade-close']").click(); //关闭窗口
		        parseModuleFloorItems(json.data, json.items);
		    }
		}, error: function (http, textStatus, errorThrown) {
		    $(__moduleModifyFloorDialog.dialog).find("*[v='atai-shade-close']").click(); //关闭窗口
		    jsbox.error(errorThrown);
		}
         });
         return false;
     }
    </script>

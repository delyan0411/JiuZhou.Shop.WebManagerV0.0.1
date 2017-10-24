<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="System.Collections.Generic" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.MySql" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %>
<%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
	int tid = DoRequest.GetQueryInt("tid");
%>
<div id="moduleModifyList-boxControl" class="moveBox" style="width:960px;height:680px;">
	<div class="name">
		编辑信息
		<div class="close" id="moduleModifyList-boxControl-close" v="atai-shade-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<form action="" onsubmit="return postModuleList(this)">
<input type="hidden" id="st-id-list" name="tid" value="<%=tid %>"/>
<input type="hidden" id="module-mid-list" name="mid" value=""/>
	<div id="moduleModifyList-tips-text" class="tips-text" style="margin:2px auto">&nbsp;</div>
<table>
  <tr>
    <td class="left" style="width:40px">名称：</td>
    <td><input type="text" id="module-name-list" name="name" class="input" value=""/>
    &nbsp;
    <input type="checkbox" id="module-allowShowName-list" name="allowShowName" onclick="checkedname(this)" value="1"/> 显示名称
    </td>
  </tr>
  <tr>
    <td class="left" style="width:40px">描述：</td>
    <td><input type="text" id="module-name2-list" name="name2" class="input" value=""/>
    &nbsp;
    <input type="checkbox" name="IsFullScreen" onclick="checkedfull(this)" value="1"/> 全屏
    </td>
  </tr>
  <tr>
    <td class="left" style="width:40px">列数：</td>
    <td>
    <input type="radio" name="columnCount" onclick="checkedcount(this)" value="2"/> 两列
    &nbsp;|&nbsp;
    <input type="radio" name="columnCount" onclick="checkedcount(this)" value="3"/> 三列
    &nbsp;|&nbsp;
    <input type="radio" name="columnCount" onclick="checkedcount(this)" value="4" checked="checked"/> 四列
    &nbsp;|&nbsp;
    <input type="radio" name="columnCount" onclick="checkedcount(this)" value="5"/> 五列
    &nbsp;|&nbsp;
    <input type="radio" name="columnCount" onclick="checkedcount(this)" value="6"/> 六列
    &nbsp;|&nbsp;
    <input type="radio" name="columnCount" onclick="checkedcount(this)" value="7"/> 七列
    &nbsp;|&nbsp;
    <input type="radio" name="columnCount" onclick="checkedcount(this)" value="8"/> 八列
    </td>
  </tr>
</table>
<div class="console">&nbsp;&nbsp;关键词:
	<input type="text" id="module-item-squery" value="" class="input" onblur="moduleSearchProduct()"/>
    &nbsp;
	<a href="javascript:;">搜索</a><%--moduleItemAdd--%>
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
     var __moduleModifyListDialog = false;
     function moduleModifyList(mId) {
         __moduleModifyListDialog = false;
         var boxId = "#moduleModifyList-boxControl";
         var box = Atai.$(boxId);
         var _dialog = _dialog = new AtaiShadeDialog();
         _dialog.zIndex = 99;
         _dialog.init({
             obj: box
		, sure: function () { }
		, CWCOB: false
         });
         __moduleModifyListDialog = _dialog;

         $.ajax({
             url: "/MPromotions/GetModuleItems?t=" + new Date().getTime()
		, type: "post"
		, data: { "mid": mId }
		, dataType: "json"
		, success: function (json, textStatus) {
		    if (json.error) {
		        jsbox.error(json.message);
		    } else {
		        $(__moduleModifyListDialog.dialog).find("input[name='mid']").val(json.data.st_module_id);
		        $(__moduleModifyListDialog.dialog).find("input[name='name']").val(json.data.module_name);
		        $(__moduleModifyListDialog.dialog).find("input[name='name2']").val(json.data.module_desc);
		        $(__moduleModifyListDialog.dialog).find("input[name='allowShowName']").attr("checked", json.data.allow_show_name == "1");
		        $(__moduleModifyListDialog.dialog).find("input[name='IsFullScreen']").attr("checked", json.data.is_full_screen == "1");
		        var columnCount = json.data.cell_count;
		        if (columnCount < 2) columnCount = 4;
		        $(__moduleModifyListDialog.dialog).find("input[name='columnCount']").each(function () {
		            if ($(this).val() == columnCount) {
		                $(this).attr("checked", true);
		            } else {
		                $(this).attr("checked", false);
		            }
		        });
		        moduleInitItem(json.items);
		        moduleSelectItemsCount();
		        $(__moduleModifyListDialog.dialog).find("#moduleModifyList-tips-text").html("");
		        $(__moduleModifyListDialog.dialog).find("#module-box-search-result").html("");
		    }
		}, error: function (http, textStatus, errorThrown) {
		    jsbox.error(errorThrown);
		}
         });
         return false;
     }
     function moduleSearchProduct() {
         var query = $(__moduleModifyListDialog.dialog).find("#module-item-squery").val();
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
		    moduleAppendSearchResult(json.data, json.pageCount, json.index);
		}, error: function (http, textStatus, errorThrown) {
		    jsbox.error("查询失败");
		}
         });
     }

     function moduleInitItem(items) {
         var html = '';
         for (var i = 0; i < items.length; i++) {
             var json = items[i];
             html += '<li order="' + 1 + '"><input type="hidden" name="productId" value="' + json.product_id + '"/>';
             html += '<input type="hidden" name="itemid" value="' + json.st_item_id + '"/>';
             html += '<div class="img"><img src="' + (formatImageUrl(json.img_src, 60, 60)) + '" alt="" style=\"width:60px;height:60px;\"/></div>';
             html += '<div class="title"><a href="<%=config.UrlHome%>' + json.product_id + '.html" target="_blank">' + json.product_name + '</a>';
             html += '<p class="move-links">';
             html += '<a href="javascript:void(0);" onclick="moduleItemsMove(this,\'first\');" class="move-first" title="置顶">&nbsp;</a>';
             html += '<a href="javascript:void(0);" onclick="moduleItemsMove(this,\'up\');" class="move-up" title="上移">&nbsp;</a>';
             html += '<a href="javascript:void(0);" onclick="moduleItemsMove(this,\'down\');" class="move-down" title="下移">&nbsp;</a>';
             html += '<a href="javascript:void(0);" onclick="moduleItemsMove(this,\'last\');" class="move-last" title="最末">&nbsp;</a>';
             html += '</p></div>';
             html += '<div class="op-link"><a href="javascript:;" onclick="removeModuleDataItem(this)">移除</a></div>';
             html += '<p class="clear"></p>';
             html += '</li>';
         }
         $(__moduleModifyListDialog.dialog).find("#module-box-data-list").html(html);
         var nodes = $(__moduleModifyListDialog.dialog).find("#module-box-data-list li");
         $(__moduleModifyListDialog.dialog).find("#module-box-data-list").scrollTop(nodes.length * 70);
     }

     function moduleAppendSearchResult(data, pageCount, pageIndex) {
         var arr = [];
         var nodes = $(__moduleModifyListDialog.dialog).find("#module-box-data-list").find("input[name=productId]");
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
             arr.push('<div class="op-link"><a href="javascript:;" v="' + json.product_id + '" onclick="moduleItemAdd(this,' + json.product_id + ')"' + style + '>选择</a></div>');
             arr.push('<p class="clear"></p>');
             arr.push('</li>');
         }
         $(__moduleModifyListDialog.dialog).find("#module-box-search-result").html(arr.join(""));
     }

     function removeModuleDataItem(obj) {
         var p_id = $(obj).parent().parent().find("input[name=productId]").val();
         $(obj).parent().parent().remove();
         $(__moduleModifyListDialog.dialog).find("#module-box-search-result").find("a[v=" + p_id + "]").css({ "color": "#06F" });
         moduleSelectItemsCount();
     }
     function moduleSelectItemsCount() {
         $(__moduleModifyListDialog.dialog).find("span[v=select-count]").css({ "color": "#f00" }).html("已选 " + $(__moduleModifyListDialog.dialog).find("#module-box-data-list").find("input[name=productId]").length + " 个商品");
     }
     function moduleItemsMove(obj,type) {
         var mObj = $(obj).parent().parent().parent();
         var nodes = $(__moduleModifyListDialog.dialog).find("#module-box-data-list li");
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
     function moduleAppendItem(json) {
         var _len = $("#module-box-data-list li").length + 1;
         var html = '';
         html += '<li order="' + _len + '"><input type="hidden" name="productId" value="' + json.product_id + '"/>';
         html += '<input type="hidden" name="itemid" value="0"/>';
         html += '<div class="img"><img src="' + (formatImageUrl(json.img_src, 60, 60)) + '" alt="" style=\"width:60px;height:60px;\"/></div>';
         html += '<div class="title"><a href="<%=config.UrlHome%>' + json.product_id + '.html" target="_blank">' + json.product_name + '</a>';

         html += '<p class="move-links">';
         html += '<a href="javascript:void(0);" onclick="moduleItemsMove(this,\'first\');" class="move-first" title="置顶">&nbsp;</a>';
         html += '<a href="javascript:void(0);" onclick="moduleItemsMove(this,\'up\');" class="move-up" title="上移">&nbsp;</a>';
         html += '<a href="javascript:void(0);" onclick="moduleItemsMove(this,\'down\');" class="move-down" title="下移">&nbsp;</a>';
         html += '<a href="javascript:void(0);" onclick="moduleItemsMove(this,\'last\');" class="move-last" title="最末">&nbsp;</a>';
         html += '</p></div>';

         html += '<div class="op-link"><a href="javascript:;" onclick="removeModuleDataItem(this)">移除</a></div>';
         html += '<p class="clear"></p>';
         html += '</li>';
         $(__moduleModifyListDialog.dialog).find("#module-box-data-list").append(html);
         $(__moduleModifyListDialog.dialog).find("#module-item-id").val("");
         var nodes = $("#module-box-data-list li");
         $(__moduleModifyListDialog.dialog).find("#module-box-data-list").scrollTop(nodes.length * 70);
     }

     function moduleItemAdd(obj, p_id) {
         var tips = $(__moduleModifyListDialog.dialog).find("#moduleModifyList-tips-text");
         tips.html("");
         var nodes = $(__moduleModifyListDialog.dialog).find("input[name=productId]");
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
		    moduleAppendItem(json);
		    $(obj).css({ "color": "#999" });
		    moduleSelectItemsCount();
		}, error: function (http, textStatus, errorThrown) {
		    tips.html(errorThrown);
		}
         });
         return false;
     }

     function parseModuleItems(json, items) {
         var module = $("#module-" + json.st_module_id);
         if (module) {
             if (json.is_full_screen == "1") module.addClass("IsFullScreen");
             else module.removeClass("IsFullScreen");
             if (json.allow_show_name == "1") {
                 $(module).children(".module-hd").css({ "display": "block" });
             } else {
                 $(module).children(".module-hd").css({ "display": "none" });
             }
             $(module).children(".module-hd").children("h3").html("<b>@</b>" + json.module_name);
             $(module).children(".module-hd").children("div").html(json.module_desc);
             var html = '<dl class="floor-data floor-data-' + json.cell_count + '">';
             for (var i = 0; i < items.length; i++) {
                 var em = items[i];
                 if (i > 0 && i % parseInt(json.cell_count) == 0) {
                     html += "<dt class=\"clear\"></dt>";
                 }
                 html += '<dd>';
                 html += '<a href="<%=config.UrlHome%>' + em.product_id + '.html" target="_blank"><img src="' + (formatImageUrl(em.img_src, 350, 350)) + '" />';
                 html += '<ul><li>&nbsp;</li><li><i class="bd"></i><b>' + em.product_brand + '</b></li><li>&nbsp;</li></ul>';
                 html += '<div class="price"><b>￥' + em.sale_price + '</b></div>';
                 html += '<div class="bg"></div>';
                 html += '<div class="title">' + em.product_name + '</div>';
                 html += '</a>';
                 html += '</dd>';
             }
             html += '</dl>';
             $(module).children(".module-bd").html(html);
         }
     }

     function postModuleList(form) {
         var productIds = "";
         var bId = "#moduleModifyList-boxControl";
         var itemids = "";
         var nodes2 = $(form).find("input[name='itemid']");
         $(__moduleModifyListDialog.dialog).find("#moduleModifyList-tips-text").html("");
         var nodes = $(form).find("input[name=productId]");
         if (nodes.length < 1) {
             $(__moduleModifyListDialog.dialog).find("#moduleModifyList-tips-text").html("请添加商品");
             return false;
         }
         var columnCount = $(form).find("input[name=columnCount]:checked").val();
         if (columnCount == undefined) {
             columnCount = 4;
         }

         for (var i = 0; i < nodes.length; i++) {

             productIds = productIds + nodes[i].value + ",";
         }

         for (var i = 0; i < nodes2.length; i++) {
             itemids += nodes2[i].value + ",";
         }

         var postData = {
             "mid": $(form).find("input[name='mid']").val()
        , "stid": $(form).find("input[name='tid']").val()
       	, "name": $(form).find("input[name='name']").val()
		, "name2": $(form).find("input[name='name2']").val()
		, "allowShowName": $(form).find("input[name='allowShowName']").attr("checked") ? 1 : 0
		, "IsFullScreen": $(form).find("input[name='IsFullScreen']").attr("checked") ? 1 : 0
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
		        $(__moduleModifyListDialog.dialog).find("#moduleModifyList-tips-text").html(json.message);
		    } else {
		        $(__moduleModifyListDialog.dialog).find("*[v='atai-shade-close']").click(); //关闭窗口
		        parseModuleItems(json.data, json.items);
		    }
		}, error: function (http, textStatus, errorThrown) {
		    $(__moduleModifyListDialog.dialog).find("*[v='atai-shade-close']").click(); //关闭窗口
		    jsbox.error(errorThrown);
		}
         });
         return false;
     }
    </script>

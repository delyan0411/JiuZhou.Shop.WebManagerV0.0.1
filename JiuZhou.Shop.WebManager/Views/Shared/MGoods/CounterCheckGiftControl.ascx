<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %><%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div id="gift-countercheckboxControl" class="moveBox" style="height:480px;width:620px;">
	<div id="gift-box-name" class="name">
		赠品反查
		<div id="sku-box-close"  v="atai-shade-close" class="close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<div style="height:408px;width:100%;overflow-x:hidden;overflow-y:scroll;">
<form action="" onsubmit="return postSkuBox(this)">
<table id="gift-table-data" class="table" style="width:100%;" cellpadding="0" cellspacing="0">
  <thead>
    <tr>
      <th style="width:3%">&nbsp;</th>
      <th style="width:16%">&nbsp;</th>
      <th style="width:40%">商品名</th>
      <th>商品编码</th>
    </tr>
  </thead>
<tbody>

</tbody>
</table>
</form>
</div>
</div>
<script type="text/javascript">
    function addProductBoxRow(data) {
        var tObj = $(_giftcountercheckEditorBoxDialog.dialog).find("#gift-table-data tbody");
        tObj.html("");
        var html = '';
        for (var i = 0; i < data.length; i++) {
            var json = data[i];
            html += (i % 2 == 0) ? "<tr class='bg'>" : "<tr>";
            html += '<td>' + (i+1) + '</td>';
            html += '<td><img src="' + (formatImageUrl(json.img_src, 60, 60)) + '" alt="" style=\"width:60px;height:60px;\"/></td>';
            html += '<td><a href="<%=config.UrlHome%>' + json.product_id + '.html" target="_blank">' + json.product_name + '</a></td>';
            html += '<td>' + json.product_code + '</td>';
            html += '</tr>';

        }
        tObj.append(html);
    }
var _giftcountercheckEditorBoxDialog = false;
function Countercheck(productid) {
    $.ajax({
        url: "/MGoods/GiftCounterCheck"
		, type: "post"
		, data: "productid=" + productid
		, dataType: "json"
		, success: function (json) {
		    if (json.count == 0) {
		        jsbox.error("该商品不是赠品！");
		    } else {
		        var box = Atai.$("#gift-countercheckboxControl");
		        var _dialog = false;
		        if (!_dialog)
		            _dialog = new AtaiShadeDialog();
		        _dialog.init({
		            obj: box
		          , sure: function () { }
		          , CWCOB: true
		        });
		        _giftcountercheckEditorBoxDialog = _dialog;
		        addProductBoxRow(json.list);
		    }
		}
    });

	return false;
}

</script>
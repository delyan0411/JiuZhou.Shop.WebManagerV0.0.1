<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %><%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div id="sku-boxControl" class="moveBox" style="height:480px;width:620px;">
	<div id="sku-box-name" class="name">
		SKU设置
		<div id="sku-box-close"  v="atai-shade-close" class="close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<div class="tips-text" style="color:#ff6600">&nbsp;</div>
<div style="height:408px;width:100%;overflow-x:hidden;overflow-y:scroll;">
<form action="" onsubmit="return postSkuBox(this)">
<input type="hidden" id="sku-boxControl-productid" name="proid" value=""/>
<table id="sku-table-boxControl" style="width:100%;" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
  	<th style="width:160px;font-weight:100">库存正数为加,负数为减</th>
    <th style="width:90px;font-weight:100">± <input type="text" v="stock" value="" class="input" onblur="setSkuBoxAttr(this)" style="width:40px"/></th>
    <th style="width:80px;font-weight:100"><input type="text" v="member" value="" class="input" onblur="setSkuBoxAttr(this)" style="width:40px"/> 元</th>
    <th style="width:80px;font-weight:100"><input type="text" v="mobile" value="" class="input" onblur="setSkuBoxAttr(this)" style="width:40px"/> 元</th>
    <th style="font-weight:100"><input type="submit" value="保存更改" class="submit"/></th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>Sku名称</td>
    <td>&nbsp;虚拟库存</td>
    <td>销售价</td>
    <td>手机专享</td>
    <td>&nbsp;</td>
  </tr>
</tbody>
</table>
<table id="sku-table-data" class="table" style="width:100%;" cellpadding="0" cellspacing="0">
<tbody>

</tbody>
</table>
</form>
</div>
</div>
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
function createSkuNode(json){
	var xml = '<item skuid="'+ json.SkuID +'">';
	xml += '<stock>'+ json.SkuStock +'</stock>';
	xml += '<memberprice>'+ json.SkuMemberPrice +'</memberprice>';
	xml += '<mobileprice>'+ json.SkuMobilePrice +'</mobileprice>';
	xml += '</item>';
	return xml;
}
function addSkuBoxRow(data){
    var tObj = $(_skuEditorBoxDialog.dialog).find("#sku-table-data tbody");
	tObj.html("");
	var html='';
	for(var i=0;i<data.length;i++){
		var json=data[i];
		html += (i%2==0)?"<tr class='bg'>":"<tr>";
		html += '<td style="width:160px;">' + json.sku_name + '<input type="hidden" v="skuID" value="' + json.sku_id + '"/></td>';
		html += '<td style="width:90px;">&nbsp;<input type="text" v="skuStock" value="' + json.virtual_sku_stock + '" class="input" style="width:40px"/></td>';
		html += '<td style="width:80px;"><input type="text" v="skuMemberPrice" value="' + json.sale_price + '" class="input" style="width:40px"/> 元</td>';
		html += '<td style="width:80px;"><input type="text" v="skuMobilePrice" value="' + json.mobile_price + '" class="input" style="width:40px"/> 元</td>';
		html += '<td>&nbsp;</td>';
		html += '</tr>';
		
	}
	tObj.append(html);
}
function setSkuBoxAttr(obj){
    var stock = $(_skuEditorBoxDialog.dialog).find("[v='stock']").val();
    var member = $(_skuEditorBoxDialog.dialog).find("[v='member']").val();
    var mobile = $(_skuEditorBoxDialog.dialog).find("[v='mobile']").val();
	var resetStock=true;
	if(Atai.isInt(stock)){
		stock=parseInt(stock);
	}else{
		resetStock = false;
	}
	member = Atai.isNumber(member) ? parseFloat(member) : -1;
	mobile = Atai.isNumber(mobile) ? parseFloat(mobile) : -1;
	$(_skuEditorBoxDialog.dialog).find("#sku-table-data tbody tr").each(function () {
		var row=$(this);
		var _st=row.find("input[v='skuStock']").val();
		var _stock=stock;
		if(Atai.isInt(_st)){
			_stock = parseInt(_st) + stock;
			$(_skuEditorBoxDialog.dialog).find("input[v='stock']").val('0');
		}
		if(_stock<0) _stock=0;
		if(resetStock)
			row.find("input[v='skuStock']").val(_stock);
		if(member>=0)
			row.find("input[v='skuMemberPrice']").val(member);
		if(mobile>=0)
			row.find("input[v='skuMobilePrice']").val(mobile);
	});
}
var _skuEditorBoxDialog = false;
var _skuEditorInputObj = false;
function resetProductSkuBox(obj, productid){
    _skuEditorInputObj = obj;
    var box = Atai.$("#sku-boxControl");
    var _dialog = false;
    if (!_dialog)
        _dialog = new AtaiShadeDialog();
    _dialog.init({
        obj: box
		, sure: function () { }
		, CWCOB: true
    });
    _skuEditorBoxDialog = _dialog;
	
	$.ajax({
		url: "/MTools/GetProductSkuList"
		, type: "post"
		, data: "productid=" + productid
		, dataType: "json"
		, success: function(json){
			addSkuBoxRow(json.data);
		}
	});
	$(_dialog.dialog).find("#sku-boxControl-productid").val(productid);
	return false;
}
function postSkuBox(form){
	var obj=$(_skuEditorBoxDialog.dialog).find("span[class='tips-text']");
	obj.html("");
	if(showLoadding) showLoadding();

	var skuNodes=[];
	var skuError=false;
	var skuErrorText="";
	var skuStockCount=0;
	$(_skuEditorBoxDialog.dialog).find("#sku-table-data tbody tr").each(function () {
		var skuID=$(this).find("input[v='skuID']").val();
		var skuStock=$(this).find("input[v='skuStock']").val();
		var skuMemberPrice=$(this).find("input[v='skuMemberPrice']").val();
		var skuMobilePrice=$(this).find("input[v='skuMobilePrice']").val();
		
		if(!Atai.isInt(skuStock)
			|| !Atai.isNumber(skuMemberPrice)
			|| !Atai.isNumber(skuMobilePrice)){
			skuError=true;
			skuErrorText="[Sku参数] 不能为空,且只能是数字";
		}
		if(Atai.isInt(skuStock)){
			skuStockCount += parseInt(skuStock);
		}
		skuNodes.push(createSkuNode({
			 "SkuID" : skuID
			,"SkuStock" : skuStock
			,"SkuMemberPrice" : skuMemberPrice
			,"SkuMobilePrice" : skuMobilePrice
		}));
	});
	var skuXml = createXmlDocument(skuNodes);
	if(skuError){
		obj.html(skuErrorText);
		return false;
	}
    var productid = $(_skuEditorBoxDialog.dialog).find("#sku-boxControl-productid").val();
	var postData="productid="+ productid +"&sku=" + encodeURIComponent(skuXml);
	$.ajax({
		url: "/MGoods/PostResetSkuDataForBox"
		, data: postData
        , type: "post"
		, dataType: "json"
		, success: function(json){
			if(json.error){
				obj.html(json.message);
			}else{
            // if (_skuEditorInputObj) 
              //  _skuEditorInputObj.value=skuStockCount;
               _skuEditorBoxDialog.close();
               window.location.href = window.location.href;

			}
			if(closeLoadding) closeLoadding();
		}
	});
	return false;
}
</script>
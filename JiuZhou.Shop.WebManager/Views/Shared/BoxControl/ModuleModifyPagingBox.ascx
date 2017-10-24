<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="System.Collections.Generic" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.MySql" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %>
<%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
	int tid = DoRequest.GetQueryInt("tid");
    List<ShopList> shopList = new List<ShopList>();
    var res = GetShopInfo.Do(-1);
    if (res != null && res.Body != null && res.Body.shop_list != null)
        shopList = res.Body.shop_list;
%>
<div id="moduleModifyPaging-boxControl" class="moveBox" style="width:660px;height:600px;">
	<div class="name">
		编辑信息
		<div class="close" id="moduleModifyPaging-boxControl-close" v="atai-shade-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<form action="" onsubmit="return postModulePaging(this)">
<input type="hidden" name="tid" value="<%=tid %>"/>
<input type="hidden" name="mid" value=""/>
	<div id="moduleModifyPaging-tips-text" class="tips-text" style="margin:2px auto">&nbsp;</div>
<table>
  <tr>
    <td class="left" style="width:40px">名称：</td>
    <td><input type="text" name="name" class="input" value=""/>
    &nbsp;
    <input type="checkbox" name="allowShowName" onclick="checkedname(this)" value="1"/> 显示名称
    </td>
  </tr>
  <tr>
    <td class="left" style="width:40px">描述：</td>
    <td><input type="text" name="name2" class="input" value=""/>
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
  <tr>
    <td class="left" style="width:40px">显示：</td>
    <td>
<input type="text" name="pagesize" class="input" style="width:60px;text-align:center;" value="20" onclick="this.select()"/> 个 / 页
&nbsp;&nbsp;
<input type="checkbox" name="allowPaging" value="1" onclick="checkedname(this)" checked="checked"/> 分页显示
    </td>
  </tr>
  <tr>
    <td class="left" style="width:40px">分类：</td>
    <td><input type="hidden" id="moduleModifyPaging-ClassID" name="ClassID" value=""/>
    <input type="text" id="moduleModifyPaging-showClassID" v="showClassID" name="classname" value="" class="input" onclick="selectCategBox1(event)" readonly="readonly" style="cursor:pointer"/>
    <input type="button" class="view-file" value="选择..." onclick="selectCategBox1(event)" title="选择分类"/>
    &nbsp;<a href="javascript:;" onclick="clearClass()">清空分类</a>
    </td>
  </tr>
  <tr>
    <td class="left" style="width:40px">品牌：</td>
    <td><input type="text" name="brand" class="input" value=""/></td>
  </tr>
  <tr>
    <td class="left" style="width:40px">商家：</td>
    <td>
<select name="shopid">
<option value="0">--不限--</option>
<%
	foreach(ShopList shop in shopList){
%>
<option value="<%=shop.shop_id%>"><%=shop.shop_name%></option>
<%
	}
%>
</select>
    </td>
  </tr>
  <tr>
    <td class="left" style="width:40px">排序：</td>
    <td>
<select name="column">
<option value="DEFAULT">--默认--</option>
<option value="TOTALSALES">总销量</option>
<option value="MONTHSALES">月销量</option>
<option value="WEEKSALES">周销量</option>
<option value="SALEPRICE">销售价格</option>
<option value="ADDTIME">添加时间</option>
</select>
    </td>
  </tr>
</table>

<table>
  <tr>
    <td class="left" style="width:40px">&nbsp;</td>
    <td>
<input type="submit" class="submit" value="保 存" style="width:160px;text-align:center;"/>
    </td>
  </tr>
</table>
</form>
</div>
<script type="text/javascript">
    var __moduleModifyPagingDialog = false;
    function moduleModifyPaging(mId) {
        var boxId = "#moduleModifyPaging-boxControl";
        var box = Atai.$(boxId);
        var _dialog = false;
        if (!_dialog)
            _dialog = new AtaiShadeDialog();
        _dialog.init({
            obj: box
		        , sure: function () { }
		        , CWCOB: true
        });
        __moduleModifyPagingDialog = _dialog;
        $.ajax({
            url: "/MPromotions/GetModuleInfo?t=" + new Date().getTime()
		, type: "post"
		, data: { "mid": mId }
		, dataType: "json"
		, success: function (json, textStatus) {
		    if (json.error) {
		        jsbox.error(json.message);
		    } else {
		        $(__moduleModifyPagingDialog.dialog).find("input[name='mid']").val(json.st_module_id);
		        $(__moduleModifyPagingDialog.dialog).find("input[name='name']").val(json.module_name);
		        $(__moduleModifyPagingDialog.dialog).find("input[name='name2']").val(json.module_desc);
		        $(__moduleModifyPagingDialog.dialog).find("input[name='allowShowName']").attr("checked", json.allow_show_name == "1");
		        $(__moduleModifyPagingDialog.dialog).find("input[name='IsFullScreen']").attr("checked", json.is_full_screen == "1");
		        $(__moduleModifyPagingDialog.dialog).find("input[name='allowPaging']").attr("checked", json.allow_paging == "1");
		        var columnCount = json.cell_count;
		        if (columnCount < 2) columnCount = 4;
		        $(__moduleModifyPagingDialog.dialog).find("input[name='columnCount']").each(function () {
		            if ($(this).val() == columnCount) {
		                $(this).attr("checked", true);
		            } else {
		                $(this).attr("checked", false);
		            }
		        });
		        $(__moduleModifyPagingDialog.dialog).find("input[name='pagesize']").val(json.page_size);
		        $(__moduleModifyPagingDialog.dialog).find("input[name='ClassID']").val(json.product_type);
		        $(__moduleModifyPagingDialog.dialog).find("input[name='classname']").val(json.module_content);
		        $(__moduleModifyPagingDialog.dialog).find("input[name='ClassID']").val(json.product_type);
		        $(__moduleModifyPagingDialog.dialog).find("select[name='shopid'] option[value='" + json.shop_id + "']").attr("selected", "selected");
		        $(__moduleModifyPagingDialog.dialog).find("select[name='column'] option[value='" + json.sort_column + "']").attr("selected", "selected");
		        $(__moduleModifyPagingDialog.dialog).find("input[name='brand']").val(json.product_brand);
		    }
		}, error: function (http, textStatus, errorThrown) {
		    jsbox.error(errorThrown);
		}
        });
        return false;
    }

    function clearClass() {
        $(__moduleModifyPagingDialog.dialog).find("#moduleModifyPaging-ClassID").val(0);
        $(__moduleModifyPagingDialog.dialog).find("#moduleModifyPaging-showClassID").val("")
    }
    function selectCategBox1(event) {
        selectCategBox(event, $(__moduleModifyPagingDialog.dialog).find("#moduleModifyPaging-ClassID"), $(__moduleModifyPagingDialog.dialog).find("#moduleModifyPaging-showClassID"));
    }

function postModulePaging(form){
	var bId="#moduleModifyPaging-boxControl";
	$(__moduleModifyPagingDialog.dialog).find("#moduleModifyPaging-tips-text").html("");
	var size=$(form).find("input[name='pagesize']").val();
	if(size<1){
	    $(__moduleModifyPagingDialog.dialog).find("#moduleModifyPaging-tips-text").html("每页显示数量不能小于1");
		return false;
	}
	var columnCount=$(form).find("input[name=columnCount]:checked").val();
	if(columnCount==undefined){
		columnCount=4;
	}

var postData = {
         "tid": $(form).find("input[name='tid']").val()
		,"mid" : $(form).find("input[name='mid']").val()
		,"name" : $(form).find("input[name='name']").val()
		,"name2" : $(form).find("input[name='name2']").val()
		,"allowShowName" :$(form).find("input[name='allowShowName']").attr("checked")?1:0
		,"columnCount" : columnCount
		,"size" : $(form).find("input[name='pagesize']").val()
		,"allowPaging" :$(form).find("input[name='allowPaging']").attr("checked")?1:0
		,"IsFullScreen" :$(form).find("input[name='IsFullScreen']").attr("checked")?1:0
		,"classid" : $(form).find("input[name='ClassID']").val()
		,"classname" : $(form).find("input[name='classname']").val()
		,"brand" : $(form).find("input[name='brand']").val()
		,"shopid" : $(form).find("select[name='shopid'] option:selected").val()
		,"column" : $(form).find("select[name='column'] option:selected").val()
	};
	$.ajax({
		url: "/MPromotions/PostModulePaging?t=" + new Date().getTime()
		, type: "post"
		, data: postData
		, dataType: "json"
		, success: function(json, textStatus){
			if(json.error){
			    $(__moduleModifyPagingDialog.dialog).find("#moduleModifyList-tips-text").html(json.message);
			}else{
			    $(__moduleModifyPagingDialog.dialog).find("*[v='atai-shade-close']").click();
				parseModulePaging(json.data, json.items, json.pageLink);
			}
		}, error: function(http, textStatus, errorThrown){
		    $(__moduleModifyPagingDialog.dialog).find("*[v='atai-shade-close']").click(); //关闭窗口
			jsbox.error(errorThrown);
		}
	});
	return false;
}
function parseModulePaging(json, items, pageLink){
    var module = $("#module-" + json.st_module_id);
	if(module){
	    if (json.is_full_screen==1) module.addClass("IsFullScreen");
		else module.removeClass("IsFullScreen");
		if (json.allow_show_name==1) {
			$(module).children(".module-hd").css({"display" : "block"});
		}else{
			$(module).children(".module-hd").css({"display" : "none"});
		}
        $(module).children(".module-hd").children("h3").html("<b>@</b>" + json.module_name);
        $(module).children(".module-hd").children("div").html(json.module_desc);
		var arr=[];
		arr.push('<dl class="floor-data floor-data-' + json.cell_count + '">');
		for(var i=0;i<items.length;i++){
			var em=items[i];
			if (i > 0 && i % json.cell_count == 0) {
				arr.push("<dt class=\"clear\"></dt>");
			}
			arr.push('<dd>');
			arr.push('<a href="<%=config.UrlHome%>' + em.product_id + '.html" target="_blank"><img src="' + (formatImageUrl(em.img_src, 350, 350)) + '" />');
			arr.push('<ul><li>&nbsp;</li><li><i class="bd"></i><b>' + em.product_brand + '</b></li><li>&nbsp;</li></ul>');
			arr.push('<div class="price"><b>￥'+ em.sale_price +'</b></div>');
			arr.push('<div class="bg"></div>');
			arr.push('<div class="title">'+ em.product_name +'</div>');
			arr.push('</a>');
			arr.push('</dd>');
		}
		arr.push('</dl>');
		if (json.allow_paging== "1") {
			arr.push(pageLink);
		}
		$(module).children(".module-bd").html(arr.join(''));
	}
}
</script>
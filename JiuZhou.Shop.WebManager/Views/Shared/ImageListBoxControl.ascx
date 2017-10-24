<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<div id="image-list-box" class="moveBox" style="width:760px;height:400px;">
	<div id="image-list-box-name" class="name">图片列表<div id="image-list-box-close" v="atai-shade-close" class="close">&nbsp;</div></div>
    <div id="loadding"></div>
<form action="" method="get" onsubmit="return getImageList();">
	<div class="search-div">
		<p><input type="text" id="image-list-box-sDate" name="sDate" value="" readonly="readonly" class="date" onclick="WdatePicker()"/>
		至
		<input type="text" id="image-list-box-eDate" name="eDate" value="" readonly="readonly" class="date" onclick="WdatePicker()"//></p>
     
		<p><input type="text" id="image-list-box-query" name="q" value="" class="input"/></p>
        <p><input type="submit" value="搜 索" class="submit"/></p>
	</div>
</form>
	<div id="image-list-box-page-links" class="page-idx">
    
	</div>
<%--数据开始--%>
	<ul id="image-list-box-data" class="image-list-data">

	</ul>
	<p class="clear"></p>
	<div id="image-list-box-page-links2" class="page-idx">

	</div>
<%--数据结束--%>
</div>
<script type="text/javascript">
var dropImageListBoxClass=false;
Atai.addEvent(window,"load",function(){
    var sQuery = Atai.$("#image-list-box-query");

});
</script>
<script type="text/javascript">
var _dialogForImageListBox=false;
var _dialogForImageListBoxCallback=false;
var __dialogForImageListBoxIsShow = false;
var _id;
var _editor;
function showImageListBox(callback,id,editor){
	var box = Atai.$("#image-list-box");
	var _dialog = new AtaiShadeDialog();
	_dialog.init({
	      obj: box
		, sure: function () { }
		, CWCOB: true
	  });

	_dialogForImageListBox=_dialog;
	_dialogForImageListBoxCallback = callback;
	_id = id;
	_editor = editor;

	//if (!__dialogForImageListBoxIsShow) 
        getImageList();
	__dialogForImageListBoxIsShow=true;
}
var _formatAjaxPageLinkCount=0;
function formatAjaxPageLink(pagecount, pageindex){
	_formatAjaxPageLinkCount++;
	var arr=[];
	var maxCount=8;
	var n = pageindex - (maxCount / 2);
	if (n <= 0) 
    n = 1;
	if (pageindex > 1){
		arr.push("		<a href=\"javascript:ajaxChangePage(1);\" title=\"首页\">&lt;&lt;</a>");
		arr.push("		<a href=\"javascript:ajaxChangePage(" + (pageindex - 1) + ")\" title=\"上页\">&lt;</a>");
	}else{
		arr.push("		<strong>&lt;&lt;</strong>");
		arr.push("		<strong>&lt;</strong>");
	}
	for (var k = n; k < (n + maxCount); k++){
		if (k <= pagecount){
			if (k == pageindex){
				arr.push("		<strong><span>" + k + "</span></strong>");
			}else{
				arr.push("		<a href=\"javascript:ajaxChangePage(" + k + ")\" title=\"第" + k + "页\">" + k + "</a>");
			}
		}else{
			if (k == pageindex)
				arr.push("		<strong><span>" + k + "</span></strong>");
		}
	}
	if (pageindex < pagecount){
		arr.push("		<a href=\"javascript:ajaxChangePage(" + (pageindex + 1) + ")\" title=\"下页\">&gt;</a>");
		arr.push("		<a href=\"javascript:ajaxChangePage(" + pagecount + ")\" title=\"末页\">&gt;&gt;</a>");
	}else{
		arr.push("		<strong>&gt;</strong>");
		arr.push("		<strong>&gt;&gt;</strong>");
	}
	arr.push("		<strong class=\"txt\"><span>" + pageindex + "</span>/" + pagecount + "</strong>");
	arr.push("		<strong class=\"goto\"><input id=\"goto-" + _formatAjaxPageLinkCount + "\" type=\"text\" value=\"" + (pageindex + 1 < pagecount ? (pageindex + 1) : pagecount) + "\" onclick=\"this.select()\"/></strong>");
	arr.push("		<a href=\"javascript:;\" onclick=\"ajaxChangePage(Atai.$('#goto-" + _formatAjaxPageLinkCount + "').value)\" title=\"GO\">GO</a>");
	return arr.join("\r\n");
}
function ajaxChangePage(pageIndex){
	getImageList(pageIndex);
}
function selectImage(path, fullPath) {
    if (_dialogForImageListBoxCallback) {
        _dialogForImageListBoxCallback(path, fullPath, _id, _editor);
    }
	_dialogForImageListBox.close();
	__dialogForImageListBoxIsShow = false;
}
function getImageList(pageindex){
    //var sQuery=Atai.$("#image-list-box-query");
    var sQuery = $(_dialogForImageListBox.dialog).find("input[name='q']").val();
    var dataObject = $(_dialogForImageListBox.dialog).find("#image-list-box-data");

    //dataObject.attr('class') += " loadding";
    
	if(!pageindex || !Atai.isInt(pageindex)) pageindex=1;
	var postData="size=15";
	postData += "&page=" + pageindex;
	postData += "&sDate=" + Atai.urlEncode($(_dialogForImageListBox.dialog).find("input[name='sDate']").val());
	postData += "&eDate=" + Atai.urlEncode($(_dialogForImageListBox.dialog).find("input[name='eDate']").val());
	postData += "&query=" + sQuery;
	postData += "&t=" + new Date();

	$.ajax({
	    url: "/MTools/GetImageList"
		, data: postData
        , type: "post"
		, dataType: "json"
		, success: function (json) {
		   
		    var changeLinks = formatAjaxPageLink(json.pages, json.page); //image-list-box-page-links
		    var changeLinks2 = formatAjaxPageLink(json.pages, json.page); //image-list-box-page-links2
		    var nodes = json.data; //image-list-box-data
		    var htmls = [];
		    if (nodes.length > 0) {
		        for (var i = 0; i < nodes.length; i++) {
                    if(nodes[i]==null)
                    break;   
		            var _name = nodes[i].file_name;
		            var _cName = _name;
		            if (_name.lastIndexOf(".") > 0) {
		                _name = _name.substring(0, _name.lastIndexOf("."));
		                _cName = _name;
		            }
		            htmls.push('		<li>');
		            htmls.push('        	<div class="img" style="background:url(' + json.root + formatImageUrl(nodes[i].save_path, 120, 120) + ') center center no-repeat" onclick="selectImage(\'' + nodes[i].save_path + '\',\'' + json.root + nodes[i].save_path + '\')" title="' + _name + '"></div>');
		            htmls.push('			<p class="links">');
		            htmls.push('				<a href="javascript:;" onclick="selectImage(\'' + nodes[i].save_path + '\',\'' + json.root + nodes[i].save_path + '\')">选择图片</a>&nbsp;&nbsp;');
		            htmls.push('				<a href="' + json.root + nodes[i].save_path + '" target="_blank">查看原图</a>');
		            htmls.push('			</p>');
		            _name = _name.substring(0, 10);
		            htmls.push('			<p class="text" title="' + _cName + '">' + _name + '</p>');
		            htmls.push('		</li>');
		        }
		    }
		    //dataObject.innerHTML = html.join("\r\n");
		    //dataObject.className = dataObject.className.replace(/ loadding/ig, "");
		    $(_dialogForImageListBox.dialog).find("#image-list-box-page-links").html(changeLinks);
		
		    dataObject.html(htmls.join("\r\n"));
		    //dataObject.attr('class') = dataObject.attr('class').replace(/ loadding/ig, "");

		    $(_dialogForImageListBox.dialog).find("#image-list-box-page-links2").html(changeLinks);
		}
	});	
	return false;
}
</script>
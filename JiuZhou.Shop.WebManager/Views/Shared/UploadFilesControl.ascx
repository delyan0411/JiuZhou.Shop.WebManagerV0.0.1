<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<form id="upload-ebook-form" action="/MTools/UploadFiles" method="post" enctype="multipart/form-data">
<input type="file" id="upload-ebook-file" name="file" class="input" value="" style="display:none" onchange="ajaxUploadEBookFunction()"/></form>
<script type="text/javascript">
var _uploadEBookBox=false;
var _uploadEBookInput=false;
var _uploadEBookTipsObj=false;
function ajaxUploadEBookClick(ebookBox,ebookInput,uploadEBookTipsObj){
	_uploadEBookBox=ebookBox;
	_uploadEBookInput=ebookInput;
	_uploadEBookTipsObj=uploadEBookTipsObj;
	$('#upload-ebook-file').click();
}
function ajaxUploadEBookFunction(){
	_uploadEBookBox.style.background="url(/images/loading-2.gif) center center no-repeat";
	$.ajaxFileUpload({
		dataType:'json',
		fileElementId: "upload-ebook-file",
		url: "/MTools/UploadFiles",
		success: function(json){
			_uploadEBookBox.style.background="none";
			if(!json.error){
				_uploadEBookInput.value=json.path;
			}else{
				if(_uploadEBookTipsObj)_uploadEBookTipsObj.innerHTML=json.message;
				else alert(json.message);
			}
		}
	}); 
	return false;
}
</script>
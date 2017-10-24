<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<form id="upload-form" action="" method="post" enctype="multipart/form-data">
<input type="file" id="upload-file" name="file" class="input" value="" style="display:none"/></form>
<script type="text/javascript">
//var _uploadImageBox=false;
//var _uploadImageInput=false;
//var _uploadTipsObj=false;
function ajaxUploadClick(imageBox,imageInput,uploadTipsObj){
	_uploadImageBox=imageBox;
	_uploadImageInput=imageInput;
	_uploadTipsObj=uploadTipsObj;

	$('#upload-file').click();
    
   $('#upload-file').change(function () {
	    ajaxUploadFunction(imageBox, imageInput, uploadTipsObj);
	});  
}
function ajaxUploadFunction(imageBox,imageInput,uploadTipsObj){
	imageBox.style.background="url(/images/loading-2.gif) center center no-repeat";
	$.ajaxFileUpload({
	    dataType: 'json',
	    fileElementId: "upload-file",
	    url: "/MTools/uploadimage2",
	    success: function (json) {
	        if (!json.error) {
	            //var path=isIncludeHost(json.image) ? json.image : formatImageUrl(json.fullPath, 120, 120);
	            var path = formatImageUrl(json.image, 120, 120);
	            imageBox.style.background = "url(" + path + ") center center no-repeat";
	            imageInput.value = json.save;
	            imageBox.innerHTML = "";
	        } else {
	            if (uploadTipsObj) uploadTipsObj.innerHTML = json.message;
	            else jsbox.error(json.message);
	            imageBox.style.background = "";
	        }
	    }
	}); 
	return false;
}
function ajaxUploadClick2(msg) {

    $('#upload-file').click();

    $('#upload-file').change(function () {
        ajaxUploadFunction2(msg);
    });
}
function ajaxUploadFunction2(uploadTipsObj) {
    $.ajaxFileUpload({
        dataType: 'json',
        fileElementId: "upload-file",
        url: "/MTools/uploadimage2",
        success: function (json) {
            if (!json.error) {
                var fullpath = formatImageUrl(json.fullPath, 60, 60);
                if (moduleCarouseItem) {
                    moduleCarouseItem("", fullpath, json.save);
                }
                if (modulePicItem) {
                    modulePicItem("", fullpath, json.save);
                }
            } else {
                if (uploadTipsObj) uploadTipsObj.innerHTML = json.message;
                else jsbox.error(json.message);
            }
        }
    });
    return false;
}
</script>
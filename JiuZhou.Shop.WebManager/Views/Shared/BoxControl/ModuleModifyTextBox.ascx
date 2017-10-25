<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="System.Collections.Generic" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.MySql" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %>

<div id="moduleModifyText-boxControl" class="moveBox" style="width:960px;height:660px;">
	<div class="name">
		编辑信息
		<div class="close" id="moduleAdd-boxControl-close" v="atai-shade-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<form action="" onsubmit="return postModuleText(this)">
<input type="hidden" id="module-mid" name="mid" value=""/>
	<div id="moduleModifyText-tips-text" class="tips-text">&nbsp;</div>
<table>
  <tr>
    <td class="left" style="width:40px">名称：</td>
    <td><input type="text" id="module-name" name="name" class="input" value=""/>
    &nbsp;
    <input type="checkbox" id="module-allowShowName" name="allowShowName" onclick="checkedname(this)" value="1"/> 显示名称
    </td>
  </tr>
  <tr>
    <td class="left" style="width:40px">描述：</td>
    <td><input type="text" id="module-name2" name="name2" class="input" value=""/>
    &nbsp;
    <input type="checkbox" name="IsFullScreen" onclick="checkedfull(this)" value="1"/> 全屏
    </td>
  </tr>

  <tr>
    <td class="left" style="width:40px" valign="top">内容：</td>
    <td>
<textarea name="contents" class="textarea" style="display:none"></textarea>
    </td>
  </tr>
  <tr>
    <td class="left" style="width:40px;height:620px;">&nbsp;</td>
    <td>
    <input type="submit" class="submit" value="  确 定  "/>
    </td>
  </tr>
</table>
<br/>
</form>
</div>
    <script type="text/javascript">
    
        var ckeditor = null;
        var __moduleModifyDialog = false;

        //var id = "ckeditor-" + new Date().getTime();
        function moduleModifyText(mId) {
              var ckEditorId = "ckeditor-" + new Date().getTime();
              var boxId = "#moduleModifyText-boxControl";
              var box = Atai.$(boxId);
              var _dialog = new AtaiShadeDialog();
              _dialog.zIndex = 99;
              _dialog.init({
                    obj: box
		          , sure: function () { }
		          , CWCOB: false
                    });
                __moduleModifyDialog = _dialog;

              //  $(_dialog.dialog).find("*[name='contents']").attr("id", ckEditorId);
               // ckeditor = CKEDITOR.replace(ckEditorId);
                //  ckEditorId = id;
                
                //ckeditor = CKEDITOR.replace(id);
                //ckeditorSetData(edObj, "test");


                $.ajax({
                    url: "/MPromotions/GetModuleInfo?t=" + new Date().getTime()
		      , type: "post"
		      , data: { "mid": mId }
		      , dataType: "json"
		      , success: function (json, textStatus) {
		          if (json.error) {
		              jsbox.error(json.message);
		          } else {
		              $(__moduleModifyDialog.dialog).find("input[name='stid']").val(json.st_id);
		              $(__moduleModifyDialog.dialog).find("input[name='mid']").val(json.st_module_id);
		              $(__moduleModifyDialog.dialog).find("input[name='name']").val(json.module_name);
		              $(__moduleModifyDialog.dialog).find("input[name='name2']").val(json.module_desc);
		              $(__moduleModifyDialog.dialog).find("input[name='allowShowName']").attr("checked", json.allow_show_name == "1");
		              $(__moduleModifyDialog.dialog).find("input[name='IsFullScreen']").attr("checked", json.is_full_screen == "1");
		             // $(__moduleModifyDialog.dialog).find("textarea[name='contents']").text(json.module_content);
		              // ckeditor.insertHtml(json.module_content);
		              var edObj = $(_dialog.dialog).find("*[name='contents']");
		              var id = "ckeditor-" + new Date().getTime();
		              edObj.attr("id", id);
		              ckeditor = CKEDITOR.replace(id);
		              ckeditorSetData(edObj, json.module_content);
		              // if (CKEDITOR) {
		              //       CKEDITOR.instances.moduleContents.setData(json.module_content);
		              //  }
		          }
		      }, error: function (http, textStatus, errorThrown) {
		          jsbox.error(errorThrown);
		      }
                });
           return false;
        }
        function ckeditorSetData(obj, val) {
            $(obj).val(val);
            //alert($(obj).val());
            for (var ins in CKEDITOR.instances) { CKEDITOR.instances[ins].updateElement(); }
        }

        function setImage(path, fullPath) {
           var html = '<img src="' + fullPath + '"/>';
           ckeditor.insertHtml(html);
        }
        function setImage2(obj, path, fullPath) {
           setImage(path, fullPath);
       }
       function setImage3(obj, path, fullPath, repeat, xposition, yposition, _height, _width) {
           var html = '<div style="' + _height + _width + ' background:url(' + fullPath + ') ' + yposition + ' ' + xposition + ' ' + repeat + ';"/><span></span></div>';
           ckeditor.insertHtml(html);
       }
        function _fckCallback() {
           showImageListBox(setImage);
        }
        function _fckAddPicCallback() {
           upload(new Object(), setImage2);
        }
        function _fckAddBackCallback() {
            backGroundSet(new Object(), setImage3);
        }
        function parseContents(json) {
            var module = $("#module-" + json.st_module_id);
            if (module) {
                if (json.is_full_screen == 1) module.addClass("IsFullScreen");
                else module.removeClass("IsFullScreen");
                if (json.allow_show_name == "1") {
                    $(module).children(".module-hd").css({ "display": "block" });
                } else {
                    $(module).children(".module-hd").css({ "display": "none" });
                }
                $(module).children(".module-hd h3").html("<b>@</b>" + json.module_name);
                $(module).children(".module-hd div").html(json.module_desc);
                $(module).children(".module-bd").html(json.module_content);
            }
        }
        function postModuleText(form) {
            ///MPromotions/PostModuleText
            // var contents = ckeditor.instances[ckEditorId].getData();
            for (var ins in CKEDITOR.instances) { CKEDITOR.instances[ins].updateElement(); }
/*
            for (var ins in CKEDITOR.instances) { CKEDITOR.instances[ins].updateElement(); }
          var postData = {
                "mid": $(from).find("input[name='mid']").val()
		, "name": $(from).find("input[name='name']").val()
		, "name2": $(from).find("input[name='name2']").val()
		, "allowShowName": $(from).find("input[name='allowShowName']").attr("checked") ? 1 : 0
		, "IsFullScreen": $(from).find("input[name='IsFullScreen']").attr("checked") ? 1 : 0
		, "contents": $(__moduleModifyDialog.dialog).find("textarea[name='contents']").val()//ckeditor.instances.moduleContents.getData()//$("#moduleContents").val()
            }; 
           */
            postData = getPostDB(form);
            $.ajax({
                url: "/MPromotions/PostModuleText?t=" + new Date().getTime()
		, type: "post"
		, data: postData 
		, dataType: "json"
		, success: function (json, textStatus) {
		    if (json.error) {
		        $(__moduleModifyDialog.dialog).find("#moduleModifyText-tips-text").html(json.message);
		    } else {
		        $(__moduleModifyDialog.dialog).find("*[v='atai-shade-close']").click(); //关闭窗口
		        parseContents(json.data);
		    }
		}, error: function (http, textStatus, errorThrown) {
		    $(__moduleModifyDialog.dialog).find("*[v='atai-shade-close']").click(); //关闭窗口
		    jsbox.error(errorThrown);
		}
            });
            return false;
        }
    </script>
jQuery.extend({
    createUploadIframe: function (id, uri) {
        var frameId = 'jUploadFrame' + id;
        var iframeHtml = '<iframe id="' + frameId + '" name="' + frameId + '" style="position:absolute; top:-9999px; left:-9999px"';
        if (window.ActiveXObject) {
            if (typeof uri == 'boolean') {
                iframeHtml += ' src="' + 'javascript:false' + '"';
            } else if (typeof uri == 'string') {
                iframeHtml += ' src="' + uri + '"';
            }
        }
        iframeHtml += ' />';
        jQuery(iframeHtml).appendTo(document.body);
        return jQuery('#' + frameId).get(0);
    },
    createUploadForm: function (id, fileElementId, data) {
        var formId = 'jUploadForm' + id;
        var fileId = 'jUploadFile' + id;
        var form = jQuery('<form  action="" method="POST" name="' + formId + '" id="' + formId + '" enctype="multipart/form-data"></form>');
        if (data) {
            for (var i in data) {
                jQuery('<input type="hidden" name="' + i + '" value="' + data[i] + '" />').appendTo(form);
            }
        }
        var oldElement = jQuery('#' + fileElementId);
        var newElement = jQuery(oldElement).clone();
        jQuery(oldElement).attr('id', fileId);
        jQuery(oldElement).before(newElement);
        jQuery(oldElement).appendTo(form);
        //set attributes
        jQuery(form).css('position', 'absolute');
        jQuery(form).css('top', '-1200px');
        jQuery(form).css('left', '-1200px');
        jQuery(form).appendTo('body');
        return form;
    },
    ajaxFileUpload: function (s) {
        // TODO introduce global settings, allowing the client to modify them for all requests, not only timeout
        s = jQuery.extend({}, jQuery.ajaxSettings, s);
        var id = new Date().getTime();
        var form = jQuery.createUploadForm(id, s.fileElementId, (typeof (s.data) == 'undefined' ? false : s.data));
        var io = jQuery.createUploadIframe(id, s.secureuri);
        var frameId = 'jUploadFrame' + id;
        var formId = 'jUploadForm' + id;
        // Watch for a new set of requests
        if (s.global && !jQuery.active++) {
            jQuery.event.trigger("ajaxStart");
        }
        var requestDone = false;
        // Create the request object
        var xml = {};
        if (s.global)
            jQuery.event.trigger("ajaxSend", [xml, s]);
        // Wait for a response to come back
        var uploadCallback = function (isTimeout) {
            var io = document.getElementById(frameId);
            try {
                if (io.contentWindow) {
                    xml.responseText = io.contentWindow.document.body ? io.contentWindow.document.body.innerHTML : null;
                    xml.responseXML = io.contentWindow.document.XMLDocument ? io.contentWindow.document.XMLDocument : io.contentWindow.document;
                } else if (io.contentDocument) {
                    xml.responseText = io.contentDocument.document.body ? io.contentDocument.document.body.innerHTML : null;
                    xml.responseXML = io.contentDocument.document.XMLDocument ? io.contentDocument.document.XMLDocument : io.contentDocument.document;
                }
            } catch (e) {
                jQuery.handleError(s, xml, null, e);
            }
            if (xml || isTimeout == "timeout") {
                requestDone = true;
                var status;
                try {
                    s.dataType = "json";
                    //alert(xml.responseText);
                    status = isTimeout != "timeout" ? "success" : "error";
                    // Make sure that the request was successful or notmodified
                    if (status != "error") {
                        // process the data (runs the xml through httpData regardless of callback)
                        var data = jQuery.uploadHttpData(xml, s.dataType);

                        // If a local callback was specified, fire it and pass it the data
                        if (s.success)
                            s.success(data, status);
                        // Fire the global callback  
                        if (s.global) jQuery.event.trigger("ajaxSuccess", [xml, s]);
                    } else {
                        jQuery.handleError(s, xml, status);
                    }
                } catch (e) {
                    alert(e);
                    status = "error";
                    //jQuery.handleError(s, xml, status, e);
                }
                // The request was completed
                if (s.global)
                    jQuery.event.trigger("ajaxComplete", [xml, s]);
                // Handle the global AJAX counter
                if (s.global && ! --jQuery.active)
                    jQuery.event.trigger("ajaxStop");
                // Process result
                if (s.complete)
                    s.complete(xml, status);
                jQuery(io).unbind();

                setTimeout(function () {
                    try {
                        jQuery(io).remove();
                        jQuery(form).remove();
                    } catch (e) {
                        jQuery.handleError(s, xml, null, e);
                    }
                }, 100);
                xml = null;
            }
        };
        // Timeout checker
        if (s.timeout > 0) {
            setTimeout(function () {
                // Check to see if the request is still happening
                if (!requestDone) uploadCallback("timeout");
            }, s.timeout);
        }
        try {
            var form = jQuery('#' + formId);
            jQuery(form).attr('action', s.url);
            jQuery(form).attr('method', 'POST');
            jQuery(form).attr('target', frameId);
            if (form.encoding) {
                jQuery(form).attr('encoding', 'multipart/form-data');
            } else {
                jQuery(form).attr('enctype', 'multipart/form-data');
            }
            jQuery(form).submit();
        } catch (e) {
            jQuery.handleError(s, xml, null, e);
        }
        jQuery('#' + frameId).load(uploadCallback);
        return { abort: function () { } };
    },
    uploadHttpData: function (r, type) {
        var data = !type;
        data = type == "xml" || data ? r.responseXML : r.responseText;
        // If the type is "script", eval it in global context
        if (type == "script")
            jQuery.globalEval(data);
        // Get the JavaScript object, if JSON is used.
        if (type == "json") {
            if (data.indexOf('<pre') != -1) {
                var newDiv = jQuery(document.createElement("div"));
                newDiv.html(data);
                data = $("pre:first", newDiv).html();
            }
            eval("data = " + data);
        }
        // evaluate scripts within html
        if (type == "html")
            jQuery("<div>").html(data).evalScripts();
        return data;
    }
});


var ajaxUpload = {
    uploadImage: function (args) {
        var ext = args.allow ? args.allow : "gif,jpg,jpeg,bmp,png";
        var auto = args.auto ? args.auto : false;
        var maxFileCount = args.maxCount ? args.maxCount : 10; //限制一次最多上传多少个文件
        var maxSize = (args.maxSize ? args.maxSize : 20480) * 1024; //每次允许上传的总文件大小(单位K)
        var maxSingleSize = (args.maxSingleSize ? args.maxSingleSize : 20480) * 1024; //允许上传的单个文件大小
        var uploader = WebUploader.create({
            auto: auto
			, swf: '/javascript/webuploader/Uploader.swf'
			, server: "/MTools/UploadImage2"
			, formData: {
			    folder: (args.folder ? args.folder : "img")
				, code: (args.typeCode ? args.typeCode : "")
				, thumb: (args.thumb ? 1 : 0)
				, allow: (args.allow ? args.allow : ext)
				, maxSize: (args.maxSingleSize ? parseInt(args.maxSingleSize) : -1)
				, minWidth: (args.minWidth ? parseInt(args.minWidth) : -1)
				, maxWidth: (args.maxWidth ? parseInt(args.maxWidth) : -1)
				, minHeight: (args.minHeight ? parseInt(args.minHeight) : -1)
				, maxHeight: (args.maxHeight ? parseInt(args.maxHeight) : -1)
			}
			, pick: { id: args.button, multiple: args.multiple ? true : false }
			, accept: {
			    title: '图片',
			    extensions: ext,
			    mimeTypes: 'image/*'
			}
			, fileNumLimit: maxFileCount
			, fileSizeLimit: maxSize
			, fileSingleSizeLimit: maxSingleSize
			, thumb: args.thumb ? args.thumb : false//缩略图
			, compress: false//不压缩
			, duplicate: true//去重复
			, prepareNextFile: true//是否允许在文件传输时提前把下一个文件准备好
        });
        uploader.on('beforeFileQueued', function (file) {//文件被加入队列之前触发
            if (args.tips) args.tips.removeClass("tips-icon").html('');
            uploader.md5File(file).then(function (val) {
                uploader.options.formData.md5 = val;
            });
        });
        uploader.on('fileQueued', function (file) { });
        uploader.on('uploadBeforeSend', function (block, data) {
            //data.md5=block.file.md5;
        });
        uploader.on('error', function (type) {//错误提示
            var msg = "";
            switch (type) {
                case "Q_EXCEED_NUM_LIMIT": 
                    {
                        msg = "\u6bcf\u6b21\u6700\u591a\u53ea\u80fd\u4e0a\u4f20 " + fileNumLimit + " \u4e2a\u6587\u4ef6";
                        break;
                    }
                case "F_EXCEED_SIZE": 
                    {
                        msg = "\u5355\u4e2a\u6587\u4ef6\u5927\u5c0f\u4e0d\u80fd\u8d85\u8fc7" + WebUploader.Base.formatSize(maxSingleSize, 0);
                        break;
                    }
                case "Q_EXCEED_SIZE_LIMIT": 
                    {
                        msg = "\u6587\u4ef6\u603b\u5927\u5c0f\u4e0d\u80fd\u8d85\u8fc7" + WebUploader.Base.formatSize(maxSize, 0);
                        break;
                    }
            }
            if (args.tips) args.tips.addClass("tips-icon").html("[" + type + "] " + msg);
            else jsbox.error("[" + type + "] " + msg);
        });
        uploader.on('uploadError', function (file, reason) {//上传失败
            if (args.tips) args.tips.addClass("tips-icon").html("uploadError");
            else jsbox.error("uploadError");
        });
        uploader.on('uploadSuccess', function (file, json) {//上传成功
            if (typeof (args.success) == "function") {
                args.success(file, json);
            }
        });
        uploader.on('uploadComplete', function (file) {//上传完成
            if (!args.multiple) uploader.reset();
            if (typeof (args.complete) == "function") {
                args.complete(file);
            }
        });
    }
};
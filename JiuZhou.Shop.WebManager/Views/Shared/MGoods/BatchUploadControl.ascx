﻿<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %><%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div id="batch-boxControl" class="moveBox" style="height:600px;width:960px;">
	<div id="batch-box-name" class="name">
		批量上传图片
		<div id="sku-box-close"  v="atai-shade-close" class="close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<div class="tips-text" style="color:#ff6600">&nbsp;</div>
<div id="uploader" class="wu-example" style="height:480px;">
    <div class="queueList" style="height:360px;">
        <div id="dndArea" class="placeholder" >
            <div id="filePicker" style="height:40px;">点击选择图片</div>
            <p>或将图片拖到这里，单次最多可选300张</p>
        </div>
    </div>
    <div class="statusBar" style="display:none;">
        <div class="progress">
            <span class="text">0%</span>
            <span class="percentage"></span>
        </div><div class="info"></div>
        <div class="btns">
            <div id="filePicker2"></div><div class="uploadBtn">开始上传</div>
        </div>
    </div>
</div>
</div>
<script type="text/javascript">

var _batchuploadBoxDialog = false;
var _skuEditorInputObj = false;
var _batchpiccallback = false;

function resetBatchUploadBox(callback){
   // _skuEditorInputObj = obj;
    var box = Atai.$("#batch-boxControl");
    var _dialog = false;
    if (!_dialog)
        _dialog = new AtaiShadeDialog();
    _dialog.init({
        obj: box
		, sure: function () { }
		, CWCOB: true
    });
    _batchuploadBoxDialog = _dialog;
    _batchpiccallback = callback;
    var pathstring = new Array();
    var $ = jQuery,    // just in case. Make sure it's not an other libaray.

        $wrap = $(_batchuploadBoxDialog.dialog).find('#uploader'),

    // 图片容器
        $queue = $('<ul class="filelist"></ul>')
            .appendTo($wrap.find('.queueList')),

    // 状态栏，包括进度和控制按钮
        $statusBar = $wrap.find('.statusBar'),

    // 文件总体选择信息。
        $info = $statusBar.find('.info'),

    // 上传按钮
        $upload = $wrap.find('.uploadBtn'),

    // 没选择文件之前的内容。
        $placeHolder = $wrap.find('.placeholder'),

    // 总体进度条
        $progress = $statusBar.find('.progress').hide(),

    // 添加的文件数量
        fileCount = 0,

    // 添加的文件总大小
        fileSize = 0,

    // 优化retina, 在retina下这个值是2
        ratio = window.devicePixelRatio || 1,

    // 缩略图大小
        thumbnailWidth = 122 * ratio,
        thumbnailHeight = 122 * ratio,

    // 可能有pedding, ready, uploading, confirm, done.
        state = 'pedding',

    // 所有文件的进度信息，key为file id
        percentages = {},

        supportTransition = (function () {
            var s = document.createElement('p').style,
                r = 'transition' in s ||
                      'WebkitTransition' in s ||
                      'MozTransition' in s ||
                      'msTransition' in s ||
                      'OTransition' in s;
            s = null;
            return r;
        })(),

    // WebUploader实例
        uploader;
    var maxSingleSize = 6 * 1024 * 1024    // 10 M
		, maxSize = 200 * 1024 * 1024;    // 200 M
    if (!WebUploader.Uploader.support()) {
        alert('Web Uploader 不支持您的浏览器！如果你使用的是IE浏览器，请尝试升级 flash 播放器');
        throw new Error('WebUploader does not support the browser you are using.');
    }

    // 实例化
    uploader = WebUploader.create({
        pick: {
            id: $(_batchuploadBoxDialog.dialog).find('#filePicker'),
            label: '点击选择图片'
        },
        dnd: $(_batchuploadBoxDialog.dialog).find('#uploader .queueList'),
        paste: document.body,

        accept: {
            title: 'Images',
            extensions: 'gif,jpg,jpeg,bmp,png',
            mimeTypes: 'image/*'
        },

        // swf文件路径
        swf: '/javascript/webuploader/Uploader.swf',

        disableGlobalDnd: true,
        //chunked: false,
        server: '/MTools/UploadImage',
        formData: {
            code: '1'
        },
        fileNumLimit: 300,
        fileSizeLimit: maxSize,    // 200 M
        fileSingleSizeLimit: maxSingleSize    // 10 M
		, compress: false//不压缩
    });
    // 添加"添加文件"的按钮，
    uploader.addButton({
        id: $(_batchuploadBoxDialog.dialog).find('#filePicker2'),
        label: '继续添加'
    });

    // 当有文件添加进来时执行，负责view的创建
    __count = 0;
    function addFile(file) {
        file.sortno = __count;
        __count++;
        var $li = $('<li id="' + file.id + '">' +
                '<p class="title">' + file.name + '</p>' +
                '<p class="imgWrap"></p>' +
                '<p class="progress"><span></span></p>' +
                '</li>'),

            $btns = $('<div class="file-panel">' +
                '<span class="cancel">删除</span>' +
                '<span class="rotateRight">向右旋转</span>' +
                '<span class="rotateLeft">向左旋转</span></div>').appendTo($li),
            $prgress = $li.find('p.progress span'),
            $wrap = $li.find('p.imgWrap'),
            $info = $('<p class="error"></p>'),

            showError = function (code) {
                switch (code) {
                    case 'exceed_size':
                        text = '文件大小超出';
                        break;

                    case 'interrupt':
                        text = '上传暂停';
                        break;

                    default:
                        text = '上传失败，请重试';
                        break;
                }

                $info.text(text).appendTo($li);
            };

        if (file.getStatus() === 'invalid') {
            showError(file.statusText);
        } else {
            // @todo lazyload
            $wrap.text('预览中');
            uploader.makeThumb(file, function (error, src) {
                if (error) {
                    $wrap.text('不能预览');
                    return;
                }

                var img = $('<img src="' + src + '">');
                $wrap.empty().append(img);
            }, thumbnailWidth, thumbnailHeight);

            percentages[file.id] = [file.size, 0];
            file.rotation = 0;
        }

        file.on('statuschange', function (cur, prev) {
            if (prev === 'progress') {
                $prgress.hide().width(0);
            } else if (prev === 'queued') {
                $li.off('mouseenter mouseleave');
                $btns.remove();
            }

            // 成功
            if (cur === 'error' || cur === 'invalid') {
                console.log(file.statusText);
                showError(file.statusText);
                percentages[file.id][1] = 1;
            } else if (cur === 'interrupt') {
                showError('interrupt');
            } else if (cur === 'queued') {
                percentages[file.id][1] = 0;
            } else if (cur === 'progress') {
                $info.remove();
                $prgress.css('display', 'block');
            } else if (cur === 'complete') {
                $li.append('<span class="success"></span>');
            }

            $li.removeClass('state-' + prev).addClass('state-' + cur);
        });

        $li.on('mouseenter', function () {
            $btns.stop().animate({ height: 30 });
        });

        $li.on('mouseleave', function () {
            $btns.stop().animate({ height: 0 });
        });

        $btns.on('click', 'span', function () {
            var index = $(this).index(),
                deg;

            switch (index) {
                case 0:
                    uploader.removeFile(file);
                    return;

                case 1:
                    file.rotation += 90;
                    break;

                case 2:
                    file.rotation -= 90;
                    break;
            }

            if (supportTransition) {
                deg = 'rotate(' + file.rotation + 'deg)';
                $wrap.css({
                    '-webkit-transform': deg,
                    '-mos-transform': deg,
                    '-o-transform': deg,
                    'transform': deg
                });
            } else {
                $wrap.css('filter', 'progid:DXImageTransform.Microsoft.BasicImage(rotation=' + (~ ~((file.rotation / 90) % 4 + 4) % 4) + ')');
            }


        });

        $li.appendTo($queue);
    }

    // 负责view的销毁
    function removeFile(file) {
        var $li = $('#' + file.id);

        delete percentages[file.id];
        updateTotalProgress();
        $li.off().find('.file-panel').off().end().remove();
    }

    function updateTotalProgress() {
        var loaded = 0,
            total = 0,
            spans = $progress.children(),
            percent;

        $.each(percentages, function (k, v) {
            total += v[0];
            loaded += v[0] * v[1];
        });

        percent = total ? loaded / total : 0;

        spans.eq(0).text(Math.round(percent * 100) + '%');
        spans.eq(1).css('width', Math.round(percent * 100) + '%');
        updateStatus();
    }

    function updateStatus() {
        var text = '', stats;

        if (state === 'ready') {
            text = '选中' + fileCount + '张图片，共' +
                    WebUploader.formatSize(fileSize) + '。';
        } else if (state === 'confirm') {
            stats = uploader.getStats();
            if (stats.uploadFailNum) {
                text = '已成功上传' + stats.successNum + '张照片至图库，' +
                    stats.uploadFailNum + '张照片上传失败，<a class="retry" href="#">重新上传</a>失败图片或<a class="ignore" href="#">忽略</a>'
            }

        } else {
            stats = uploader.getStats();
            text = '共' + fileCount + '张（' +
                    WebUploader.formatSize(fileSize) +
                    '），已上传' + stats.successNum + '张';

            if (stats.uploadFailNum) {
                text += '，失败' + stats.uploadFailNum + '张';
            }
        }

        $info.html(text);
    }

    function setState(val) {
        var file, stats;

        if (val === state) {
            return;
        }

        $upload.removeClass('state-' + state);
        $upload.addClass('state-' + val);
        state = val;

        switch (state) {
            case 'pedding':
                $placeHolder.removeClass('element-invisible');
                $queue.parent().removeClass('filled');
                $queue.hide();
                $statusBar.addClass('element-invisible');
                uploader.refresh();
                break;

            case 'ready':
                $placeHolder.addClass('element-invisible');
                $(_batchuploadBoxDialog.dialog).find('#filePicker2').removeClass('element-invisible');
                $queue.parent().addClass('filled');
                $queue.show();
                $statusBar.removeClass('element-invisible');
                uploader.refresh();
                break;

            case 'uploading':
                $(_batchuploadBoxDialog.dialog).find('#filePicker2').addClass('element-invisible');
                $progress.show();
                $upload.text('暂停上传');
                break;

            case 'paused':
                $progress.show();
                $upload.text('继续上传');
                break;

            case 'confirm':
                $progress.hide();
                $upload.text('开始上传').addClass('disabled');

                stats = uploader.getStats();
                if (stats.successNum && !stats.uploadFailNum) {
                    setState('finish');
                    return;
                }
                break;
            case 'finish':
                stats = uploader.getStats();
                if (stats.successNum) {
                    if (_batchpiccallback) {
                        var pathstring2 = "";
                        for (var i = 0; i < pathstring.length; i++) {
                            pathstring2 += pathstring[i];
                        }
                        _batchpiccallback(pathstring2, _editor);
                    }
                    _batchuploadBoxDialog.close();
                    //jsbox.success('上传成功&nbsp;&nbsp;<a href="/resource/imgList?classid=' + $("#upload-to-classid option:selected").attr("classid") + '" style="color:#00f">查看已上传图片</a>');
                } else {
                    // 没有成功的图片，重设
                    state = 'done';
                    location.reload();
                }
                break;
        }

        updateStatus();
    }
    var showErrorBox = false;
    uploader.onBeforeFileQueued = function (file) {
        uploader.md5File(file).then(function (val) {
            uploader.options.formData.md5 = val;
        });
        
            showErrorBox = false;
            $upload.text("开始上传").removeClass('disabled');
        
    };

    uploader.on('uploadBeforeSend', function (block, data) {
        var o = $("#upload-to-classid option:selected");
        data.code = o.val();
        data.thumb = o.attr("thumb");
        data.classid = o.attr("classid");
    });

    uploader.on('uploadError', function (file, reason) {//上传失败
        jsbox.error("error");
    });

    uploader.on('uploadSuccess', function (file, ret) {//上传成功
   // try{
        pathstring[file.sortno] = '<img src="' + ret.path + '" />';
    //} catch (Exception e) {jsbox.error(e.toString()); }
    });

    uploader.on('uploadComplete', function (file, json) {//上传完成
      /*  if (json.error) {
            jsbox.error(json.message);
        } else {
            
            jsbox.success(json.message);
        }  */
    });

    uploader.onUploadProgress = function (file, percentage) {
        var $li = $('#' + file.id),
            $percent = $li.find('.progress span');

        $percent.css('width', percentage * 100 + '%');
        percentages[file.id][1] = percentage;
        updateTotalProgress();
    };

    uploader.onFileQueued = function (file) {
        fileCount++;
        fileSize += file.size;

        if (fileCount === 1) {
            $placeHolder.addClass('element-invisible');
            $statusBar.show();
        }

        addFile(file);
        setState('ready');
        updateTotalProgress();
    };

    uploader.onFileDequeued = function (file) {
        fileCount--;
        fileSize -= file.size;

        if (!fileCount) {
            setState('pedding');
        }

        removeFile(file);
        updateTotalProgress();

    };

    uploader.on('all', function (type) {
        var stats;
        switch (type) {
            case 'uploadFinished':
                setState('confirm');
                break;

            case 'startUpload':
                setState('uploading');
                break;

            case 'stopUpload':
                setState('paused');
                break;

        }
    });

    uploader.on('error', function (code) {
        var msg = "";
        switch (code) {
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
            case "F_DUPLICATE":
                {
                    msg = "文件已在队列中";
                    break;
                }
        } //F_DUPLICATE
        jsbox.error("[" + code + "] " + msg);
    });

    $upload.on('click', function () {
        if ($(this).hasClass('disabled')) {
            return false;
        }

        if (state === 'ready') {
            uploader.upload();
        } else if (state === 'paused') {
            uploader.upload();
        } else if (state === 'uploading') {
            uploader.stop();
        }
    });

    $info.on('click', '.retry', function () {
        uploader.retry();
    });

    $info.on('click', '.ignore', function () {
        jsbox.message('todo');
    });

    $upload.addClass('state-' + state);
    updateTotalProgress();

	return false;
}
</script>
<script type="text/javascript">
</script>
$(function () {

    // 高度设置
    autoRect();
    $(window).resize(function () {
        autoRect();
    });

    var flag = false;
    addModule(flag);
    initModule(flag);

})
//生成代码
function productCode() {
    var style = '',
        title = 'activity',
        body = '',
        filename = 'activity',
        html = '';

    style = '*{-webkit-box-sizing:border-box;box-sizing:border-box}' +
        '.content .module-wrapper{position:relative;}' +
        '.content img{width:100%;}' +
        '.link-box{position:absolute;}' +
        '.link-box a{display:block;width:100%;height:100%;}';

    function px2rem($px) {
        var $baseWidthSize = 75;
        return $px / $baseWidthSize * 1 + 'rem';
    }
    var cntClone = $(".cnt-clone").empty().append($(".content").clone());
    if (!cntClone.find(".module-wrapper").length && $(".hot-area .hot-module").length) return;
    var hotMod = $(".hot-area .hot-module");
    cntClone.find(".module-wrapper").each(function (i) {
        var $this = $(this);

        if ($this.find(".drag").length) {

            $this.find(".drag .drag-frame").each(function (j) {
                var url = hotMod.eq(i).find(".hot-links .hot-item").eq(j).find(".hot-item-input").val();

                var dWidth = $(this).width();
                var dHeight = $(this).height();
                var dLeft = parseInt($(this).css("left"));
                var dTop = parseInt($(this).css("top"));

                $this.append('<div class="link-box"><a href=""></a></div>');
                $this.find(".link-box").eq(j).css({
                    width: px2rem(dWidth * 2),
                    height: px2rem(dHeight * 2),
                    left: px2rem(dLeft * 2),
                    top: px2rem(dTop * 2)
                });
                $this.find(".link-box").eq(j).find("a").attr("href", url);
            });
        }
        if ($this.hasClass("chosen")) {
            $this.removeClass("chosen");
        }
        $this.find(".drag").remove();
        $this.find(".mod-handle").remove();
    });

    body = $.trim($(".cnt-clone").html());

    var htmlTemplate = '<!DOCTYPE html>' +
        '<html lang="en">' +
        '<head>' +
        '<meta charset="UTF-8">' +
        '<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">' +
        '<meta name="format-detection" content="telphone=no, email=no" />' +
        '<script src="js/flexible.js"></script>' +
        '<script src="js/flexible_css.js"></script>' +
        '<style>' + style + '</style>' +
        '<title>' + title + '</title>' +
        '</head>' +
        '<body>' + body +
        '</body>' +
        '</html>';

    var blob = new Blob([htmlTemplate], {
        type: "text/plain;charset=utf-8"
    });

    saveAs(blob, filename + ".html");
}

//添加三列布局
function addThreeCol(json, flag) {
    var id = json.st_module_id;
    var stid = json.st_id;
    var handleDom = '<div class="mod-handle">' +
        '<div class="mod-up"></div>' +
        '<div class="mod-down"></div>' +
        '<div class="mod-del"></div>' +
        '</div>';
    var tlDom = '<div class="module-wrapper" d="module-' + id + '"  value="' + id + '">' +
        '<div class="module-three-layout" style="padding-top: 10px;">' +
        '<div class="three-layout-list clear">' +
        '</div>' +
        '</div>' + handleDom +
        '</div>';


    var toolDom = '<div class="hot-module">' +
        '<div class="add-img" style=" background-size: contain;"><div class="layer"><div class="img-plus"></div></div></div>' +
          ' 距离顶部(没有不填,不用填px):<input name="allow_show_name"  class="allow_show_name" />' +
        '<ul class="ulitemlist"></ul>'+
        '<button class="three-add-btn">+添加商品</button>' +
        '<button class="three-cfm-btn"  type="button">确定</button>' +
        '</div>';
    $(".box").children(".content").append(tlDom);

    $(".hot-area").append(toolDom);
    addThreeColItem();
}

//添加三列布局产品
function addThreeColItem() {
   
    var index = 0;
    

    $(".three-add-btn").off("click").on("click", function () {
        index = $(this).parent().index();
        showMainProductSelector(index);
        //$(".module-wrapper").eq(index).find(".three-layout-list").append(itemDom);
    });
    $(".three-cfm-btn").off("click").on("click", function () {
        var hotmodule = $(this).parent();
        var index = hotmodule.index();
        var activeWrapper = $(".box").children(".content").find(".module-wrapper").eq(index);
        var prolist = hotmodule.children(".ulitemlist").find("li");
        if (prolist.length == 0) {
            alert("请至少选择一个商品");
            return false;
        }
        var stid = $("#hidstid").val();
        var mid = activeWrapper.attr("value");
        var src = activeWrapper.children(".module-three-layout").css("background-image");
        if (src != 'none') {
            src = src.split("(")[1].split(")")[0];
            src = src.replace("\"", "").replace("\"", "");
        }
        else {
            src = "";
        }
        var allow_show_name = hotmodule.find(".allow_show_name").val();
        var jsonresult = {};
        jsonresult.items = [];
        jsonresult.proids = [];
        jsonresult.stid = stid;
        jsonresult.mid = mid;
        jsonresult.src = src;
        jsonresult.allow_show_name = allow_show_name;
        for (i = 0; i < prolist.length; i++) {
            var itemid = $(prolist[i]).attr("data-item");
            var proids = $(prolist[i]).attr("data-pid");
            jsonresult.items.push(itemid);
            jsonresult.proids.push(proids);
        }
        //提交
        var postData = {
            "mid": jsonresult.mid
        , "stid": jsonresult.stid
            , "src": jsonresult.src
            , "allow_show_name": jsonresult.allow_show_name
        , "itemids": jsonresult.items.join()
            , "productIds": jsonresult.proids.join()
        };
        $.ajax({
            url: "/MPromotions/PostPhoneModuleItems2?t=" + new Date().getTime()
     , type: "post"
     , data: postData
     , dataType: "json"
     , success: function (json, textStatus) {
         if (json.error) {
             jsbox.error(json.error);
         } else {
             alert("更新改模块成功!");
         }
     }, error: function (http, textStatus, errorThrown) {
         jsbox.error(errorThrown);
     }
        });
    })
}

//添加模块
function addModule(flag) {
    $(".module-spec").off("click").on("click", function () {
        var _this = $(this);
        var mode = 6;
        if (_this.hasClass("module-single-image"))
            mode = 6;
        if (_this.hasClass("module-three-col"))
            mode = 5;      
        $.ajax({
            url: "/MPromotions/CreateModule?t=" + new Date().getTime()
           , type: "post"
           , data: {
               "tid": $("#hidstid").val(),
               "mode": mode
           }
           , dataType: "json"
           , success: function (json, textStatus) {
               if (json.error) {
                   jsbox.error(json.message);
               } else {
                   if (_this.hasClass("module-single-image")) {
                       addImage(json.data, flag);
                   } else if (_this.hasClass("module-three-col")) {
                       addThreeCol(json.data, flag);
                   }                  
                   flag = true;
                   initModule(flag);
               }
           }, error: function (http, textStatus, errorThrown) {
               jsbox.error(errorThrown);
           }
        });
        return false;
    })
    //$(".pub").off("click").on("click", function(e) {
    //    e.stopPropagation();
    //    productCode();
    //});
}
// main高度设置
function autoRect() {
    var winHeight = $(window).height();
    var winWidth = $(window).width();
    var mWidth = $(".modules").outerWidth();
    var tWidth = $(".tool-bar").outerWidth();
    var headerHeight = $(".header").height();

    $(".main").height(winHeight - headerHeight);
    $(".image-space").outerWidth(winWidth - mWidth - tWidth);
}
function px2rem($px) {
    var $baseWidthSize = 75;
    return $px / $baseWidthSize * 1;
}
//添加图片模块
function addImage(json, flag) {
    var id = json.st_module_id;
    var stid = json.st_id;
    var dragDom = '<div class="drag" ondragstart="return false;" onselectstart="return false;"></div>';
    var moduleDom = '<div class="module-wrapper" d="module-' + id + '"  value="' + id + '">' +
        '<div class="img-wrapper">' +
        '<img class="module-image" src="//img.alicdn.com/tps/TB1QafaJVXXXXaDXXXXXXXXXXXX-640-300.jpg"></div>' +
        '<div class="mod-handle">' +
        '<div class="mod-up"></div>' +
        '<div class="mod-down"></div>' +
        '<div class="mod-del"></div>' +
        '</div>' + dragDom + '</div>';
    var toolDom = '<div class="hot-module"><div class="add-img" style=" background-size: contain;"><div class="layer"><div class="img-plus"></div></div></div><div class="hot-links"></div><button class="hot-add" type="button">+添加热区</button><button class="hotlistupdate" type="button">确定</button></div>';
    $(".box").children(".content").append(moduleDom);
    $(".hot-area").append(toolDom);

}

function initModule(flag) {
    var modWrapper,
        modWrapperLen,
        hotMod,
        drags;


    initElm();
    moduleChosen();
    moveUp();
    moveDown();
    modDel();
    hotlist();
    addThreeColItem();
    chosenActive();

    //初始化变量
    function initElm() {
        modWrapper = $(".box").children(".content").find(".module-wrapper");
        modWrapperLen = modWrapper.length;
        hotMod = $(".hot-module");
        drags = modWrapper.find(".drag");
    }

    function moduleChosen() {
        if (flag) {
            // 为新加的moulde添加chosen
            modWrapper.eq(modWrapperLen - 1).addClass("chosen").siblings(".module-wrapper").removeClass("chosen");
            //显示对应的热区链接添加按钮
            hotMod.eq(modWrapperLen - 1).show().siblings(".hot-module").hide();
        }
        modWrapper.off("click").on("click", function (e) {
            e.stopPropagation();
            var index = $(this).index();
            $(this).addClass("chosen").siblings(".module-wrapper").removeClass("chosen");
            hotMod.eq(index).show().siblings(".hot-module").hide();
            $(this).siblings(".module-wrapper").find(".drag-frame").removeClass("active");

            chosenActive();
            flag = true;
        });
    }

    //移动模块
    //上移
    function moveUp() {
        modWrapper.find(".mod-up").off("click").on("click", function (e) {
            e.stopPropagation();
            initElm();
            var moveMod = $(this).parent().parent();
            var index = moveMod.index();
            var moveHotMod = hotMod.eq(index);

            if (index >= 1) {
                var prevMod = moveMod.prev();
                var prevHotMod = moveHotMod.prev();
                moveMod.after(prevMod);
                moveHotMod.after(prevHotMod);
                initElm();
                var j = $(".box").children(".content").find(".module-wrapper.chosen").index();

                hotMod.eq(j).show().siblings().hide();
            }
            moduleResetSortNo();
        });
    }

    //下移
    function moveDown() {
        modWrapper.find(".mod-down").off("click").on("click", function (e) {
            e.stopPropagation();
            initElm();
            var moveMod = $(this).parent().parent();
            var index = moveMod.index();
            var moveHotMod = hotMod.eq(index);
            if (modWrapperLen >= 2 && index <= modWrapperLen - 2) {
                var nextMod = moveMod.next();
                var nextHotMod = moveHotMod.next();
                nextMod.after(moveMod);
                nextHotMod.after(moveHotMod);
                var j = $(".box").children(".content").find(".module-wrapper.chosen").index();
                initElm();
                hotMod.eq(j).show().siblings().hide();
            }
            moduleResetSortNo();
        });
    }

    //删除
    function modDel() {
        modWrapper.find(".mod-del").off("click").on("click", function (e) {
            var stId = $("#hidstid").val();
            e.stopPropagation();
            initElm();
            var moveMod = $(this).parent().parent();
            var mId = moveMod.attr("value");
            var index = moveMod.index();
            var moveMod = $(this).parent().parent();
            var mId = moveMod.attr("value");
            var index = moveMod.index();
            jsbox.confirm('您确定要永久删除此模块吗？', function () {
                $.ajax({
                    url: "/MPromotions/RemoveModule?t=" + new Date().getTime()
            , type: "post"
            , data: { "stid": stId, "mid": mId }
            , dataType: "json"
            , success: function (json, textStatus) {
                if (json.error) {
                    jsbox.error(json.message);
                } else {
                    moveMod.remove();
                    hotMod.eq(index).remove();
                    initElm();
                }
            }, error: function (http, textStatus, errorThrown) {
                jsbox.error(errorThrown);
            }
                });
            });
            return false;
        });
    }
}


function hotlist() {
    var hotMod = $(".hot-module");
    hotMod.find(".hotlistupdate").off("click").on("click", function (e) {
        var hotmodule = $(this).parent();
        var index = hotmodule.index();
        var activeWrapper = $(".box").children(".content").find(".module-wrapper").eq(index);
        var hllist = hotmodule.children(".hot-links").find(".hot-item");
        //if (hllist.length == 0) {
        //    alert("请至少添加一个热区");
        //    return false;
        //}
        var src = activeWrapper.children(".img-wrapper").find(".module-image").attr("src");
        if (!src || src == "//img.alicdn.com/tps/TB1QafaJVXXXXaDXXXXXXXXXXXX-640-300.jpg") {
            alert("请上传一张图片");
            return false;
        }
        var stid = $("#hidstid").val();
        var mid = activeWrapper.attr("value");
        var jsonresult = {};
        jsonresult.list = [];
        jsonresult.url = [];
        jsonresult.items = [];
        jsonresult.stid = stid;
        jsonresult.mid = mid;
        jsonresult.src = src;
        for (i = 0; i < hllist.length; i++) {
            var url = $(hllist[i]).find(".hot-item-input").val();
            var itemid = $(hllist[i]).find(".hot-item-input").attr("itemid");
            if (url == "") {
                alert("请填写url");
                return false;
            }
            var dragf = activeWrapper.children(".drag").find(".drag-frame");
            var t = parseInt($(dragf[i]).css("top"));
            var l = parseInt($(dragf[i]).css("left"));
            var w = parseInt($(dragf[i]).css("width"));
            var h = parseInt($(dragf[i]).css("height"));
            //var top = t ? px2rem(t * 2) : px2rem(10 * 2);
            //var left = l ? px2rem(l * 2) : px2rem(10 * 2);
            //var width = w ? px2rem(w * 2) : px2rem(100 * 2);
            //var height = h ? px2rem(h * 2) : px2rem(100 * 2);
            var top = t ? t : 10;
            var left = l ? l : 10;
            var width = w ? w : 100;
            var height = h ? h : 100;
            var jsonzuobian = top + "|" + left + "|" + width + "|" + height;
            jsonresult.list.push(jsonzuobian);
            jsonresult.url.push(url);
            jsonresult.items.push(itemid);
        }
        //提交
        var postData = {
            "mid": jsonresult.mid
        , "stid": jsonresult.stid
            , "src": jsonresult.src
        , "url": jsonresult.url.join()
        , "zuobian": jsonresult.list.join()
        , "itemids": jsonresult.items.join()
        };
        $.ajax({
            url: "/MPromotions/PostPhoneModuleItems?t=" + new Date().getTime()
     , type: "post"
     , data: postData
     , dataType: "json"
     , success: function (json, textStatus) {
         if (json.error) {
             jsbox.error(json.error);
         } else {
             alert("更新改模块成功!");
         }
     }, error: function (http, textStatus, errorThrown) {
         jsbox.error(errorThrown);
     }
        });
    });
    hotMod.find(".add-img").off("click").on("click", function (e) {
        e.stopPropagation();
        var obj = this;
        showImageListBox(setpic, obj);
    });
    function setpic(path, fullPath, obj) {
        if ($(".box").children(".content").find(".module-wrapper.chosen").find(".module-image").length!=0) {
            $(".box").children(".content").find(".module-wrapper.chosen").find(".module-image").attr("src", fullPath);
        }
        else {
            $(".box").children(".content").find(".module-wrapper.chosen").find(".module-three-layout").css("background-image", "url(" + fullPath + ")").css("background-size", "cover");
        }
        $(obj).css("background-image", "url(" + fullPath + ")");
        chosenActive();
    }
}


function phonemoduleAppend(ifcsh) {
   
  
    initModule();

}

function chosenActive() {
    if ($(".box").children(".content").find(".module-wrapper.chosen").has(".drag").length > 0) {
        isImgLoaded(function () {
            $(".box").children(".content").find(".module-wrapper.chosen .drag").dragFrame();
        });
    }
}

//判断图片是否加载完成
function isImgLoaded(callback) {
    var t_img;
    var isLoad = true;
    $(".box").children(".content").find(".module-wrapper").find(".module-image").each(function () {
        if (this.height === 0) {
            isLoad = false;
            return false;
        }
    });

    if (isLoad) {
        clearTimeout(t_img);
        callback();
    } else {
        isLoad = true;
        t_img = setTimeout(function () {
            isImgLoaded(callback);
        }, 500);
    }
}



function moduleResetSortNo() {
    var ids = "";
    var nodes = $(".module-wrapper");
    for (var i = 0; i < nodes.length; i++) {
        if (i > 0) ids += ",";
        ids += $(nodes[i]).attr("value");
    }
    $.ajax({
        url: "/MPromotions/ResetSortNo?t=" + new Date().getTime()
, type: "post"
, data: { "ids": ids }
, dataType: "json"
, success: function (json, textStatus) {
    if (json.error) {
        jsbox.error(json.message);
    } else {

    }
}, error: function (http, textStatus, errorThrown) {
    jsbox.error(errorThrown);
}
    });
    return false;
}


function showMainProductSelector(index) {
    var nodes = $(".hot-module").eq(index).find(".ulitemlist li")
    var initList = "";
    for (var i = 0; i < nodes.length; i++) {
        if (i > 0) initList += ",";
        initList += $(nodes[i]).attr("data-pid");
    }
    var exceptList = [];
    showProductSelector(function (ids) {
        if (ids == "") {
            $(".module-wrapper").eq(index).find(".three-layout-list").html("");
            $(".hot-module").eq(index).find(".ulitemlist").html("");
            return false;
        }
        $.ajax({
            url: "/MTools/GetProductList2"
            , type: "post"
            , data: {
                "ids": ids
            }
            , dataType: "json"
            , success: function (json, textStatus) {
                $(".module-wrapper").eq(index).find(".three-layout-list").html("");
                $(".hot-module").eq(index).find(".ulitemlist").html("");
                $.each(json,function (n,value) {                    
                    var itemDom = '<div class="three-layout-item">' +
     '<a href="http://m.dada360.com/item/' + value.product_id + '.html">' +
     '<div class="three-layout-product">' +
     '<img src=' + value.img_src + ' alt="">' +
     '</div>' +
     '<div class="three-layout-desc">' +
     '<span>' + value.product_name + '</span>' +
     '</div>' +
     '<div class="three-layout-price clear">' +
     '<div class="tl-real-price">' +
     '<span>￥<em>' + value.mobile_price + '</em></span>' +
     '</div>' +
     '<div class="tl-del-price">' +
     '<del>￥' + value.sale_price + '</del>' +
     '</div>' +
     '</div>' +
     '<div class="three-layout-btn">' +
     '<button>立即预定/抢购</button>' +
     '</div>' +
     '</a>' +
     '</div>';
                    var liitemDom = '<li data-pid="'+value.product_id+'" data-item=0>' + value.product_name + '</li>';
                    $(".module-wrapper").eq(index).find(".three-layout-list").append(itemDom);
                    $(".hot-module").eq(index).find(".ulitemlist").append(liitemDom);
                });
          
             
            }, error: function (http, textStatus, errorThrown) {
                jsbox.error(errorThrown);
            }
        });
    }, initList, exceptList, true, 1);//第三个参数ture=允许选择带Sku商品;false=禁止选择带Sku商品
}





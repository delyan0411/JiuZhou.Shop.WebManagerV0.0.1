;(function($) {
var DragFrame = function(obj) {
    var _this = this;
    this.obj = obj; //外层容器
    this.oWidth = this.obj.outerWidth();
    this.oHeight = this.obj.outerHeight();
    this.oLeft = this.obj.offset().left;
    this.oTop = this.obj.offset().top;
    this.index = this.obj.parent().index();
    this.hotMod = $(".hot-area .hot-module");

    this.linksWrap = this.hotMod.eq(this.index).find(".hot-links");
    this.addBtn = this.hotMod.eq(this.index).find(".hot-add");

   
    this.getElm();
    this.frameActive();
    var drag = new Drag(this.obj, this.elm, this.oWidth, this.oHeight, this.oLeft, this.oTop, this.upLeft, this.up, this.upRight, this.left, this.right, this.downLeft, this.down, this.downRight, this.del, this.linkDel);
    this.add();
}

DragFrame.prototype = {
    getElm: function() {
        this.drag = this.obj.children(".drag-frame");
        this.elm = this.drag.filter(".active");
        this.upLeft = this.elm.find(".dh-tl");
        this.up = this.elm.find(".dh-tm");
        this.upRight = this.elm.find(".dh-tr");
        this.left = this.elm.find(".dh-ml");
        this.right = this.elm.find(".dh-mr");
        this.downLeft = this.elm.find(".dh-bl");
        this.down = this.elm.find(".dh-bm");
        this.downRight = this.elm.find(".dh-br");
        this.del = this.elm.find(".dh-del");

        this.linkItem = this.linksWrap.children(".hot-item");
        this.linkInput = this.linkItem.find(".hot-item-input");
        this.linkDel = this.linkItem.find(".hot-item-del");
    },
    add: function() {
        var _this = this;

        _this.addBtn.off("click").on("click", function(e) {
            e.stopPropagation();
            var frameDom = '<div class="drag-frame">' +
                '<div class="draghandle dh-tl"></div>' +
                '<div class="draghandle dh-tm"></div>' +
                '<div class="draghandle dh-tr"></div>' +
                '<div class="draghandle dh-ml"></div>' +
                '<div class="draghandle dh-mr"></div>' +
                '<div class="draghandle dh-bl"></div>' +
                '<div class="draghandle dh-bm"></div>' +
                '<div class="draghandle dh-br"></div>' +
                '<div class="dh-del iconfont icon-cha"></div>' +
                '</div>';

            var linkDom = '<div class="hot-item">' +
                '<div class="hot-item-wrap">' +
                '<input type="text" class="hot-item-input" id="link" value="" itemid="0" placeholder="输入链接">' +
                '</div>' +
                '<div class="hot-item-warp hot-btn-wrap">' +
                '<button class="hot-item-btn" type="button"></button>' +
                '</div>' +
                '<div class="hot-item-wrap hot-btn-wrap">' +
                '<a href="javascript:;" class="hot-item-del"></a>' +
                '</div>' +
                '</div>';

            _this.obj.append(frameDom);
            _this.eLen = _this.obj.children(".drag-frame").length;
            _this.obj.children(".drag-frame").eq(_this.eLen - 1).addClass("active").siblings(".drag-frame").removeClass("active");

            _this.linksWrap.append(linkDom);
            _this.linksLen = _this.linksWrap.children(".hot-item").length;
            _this.linksWrap.children(".hot-item").eq(_this.linksLen - 1).addClass("selected").siblings(".hot-item").removeClass("selected");
            _this.getElm();
            _this.linkInput.focus();
           
            _this.frameActive();
            var drag = new Drag(_this.obj, _this.elm, _this.oWidth, _this.oHeight, _this.oLeft, _this.oTop, _this.upLeft, _this.up, _this.upRight, _this.left, _this.right, _this.downLeft, _this.down, _this.downRight, _this.del, _this.linkDel);

        });

    },
    frameActive: function() {
        var _this = this;

        this.drag.off("click").on("click", function(e) {
            // e.stopPropagation();
            var index = $(this).index();
            $(this).addClass("active").siblings(".drag-frame").removeClass("active");
            _this.linkItem.eq(index).addClass("selected").siblings(".hot-item").removeClass("selected");
            _this.linkItem.eq(index).find(".hot-item-input").focus();
            _this.linkItem.eq(index).siblings(".hot-item").find(".hot-item-input").blur();
        });
        this.linkInput.off("click").on("click", function(e) {
            e.stopPropagation();
            var index = $(this).parent().parent().index();
            $(this).parent().parent().addClass("selected").siblings(".hot-item").removeClass("selected");
            $(this).focus();
            $(this).parent().parent().siblings(".hot-item").find(".hot-item-input").blur();
            _this.drag.eq(index).addClass("active").siblings(".drag-frame").removeClass("active");
        });

        $(document).off("click").on("click", function() {
            _this.drag.removeClass("active");
        });
    }
}

/*直接调用方法,并将事件的类型传入作为第一个参数*/
// 可以绑定this且event不丢失
var BindAsEventListener = function(object, fun) {
    var args = Array.prototype.slice.call(arguments).slice(2);
    return function(event) {
        return fun.apply(object, [event || window.event].concat(args));
    }
};

var Drag = function (obj, elm, oWidth, oHeight, oLeft, oTop, upLeft, up, upRight, left, right, downLeft, down, downRight, del, linkDel) {
    this.obj = obj;
    this.elm = elm;
    this.oWidth = oWidth; //父元素宽高
    this.oHeight = oHeight;
    this.oLeft = oLeft;
    this.oTop = oTop;
    this.del = del;
    this.linkDel = linkDel;
    this.direction = {
        upLeft: upLeft,
        up: up,
        upRight: upRight,
        left: left,
        right: right,
        downLeft: downLeft,
        down: down,
        downRight: downRight
    };
    this.original = {};
    this.x = 0;
    this.y = 0;
    this.fm = BindAsEventListener(this, this.move);
    this.fs = BindAsEventListener(this, this.stop);
    this.init = BindAsEventListener(this, this.init);
    this.set();

}

Drag.prototype = {
    set: function() {
        var _this = this;

        _this.elm.on("mousedown", function(e) {
            if (!_this.elm.hasClass("active")) return;
            e.stopPropagation();
            e.preventDefault();
            _this.init();
            _this.original.x = e.originalEvent.x || e.originalEvent.layerX || 0;
            _this.original.y = e.originalEvent.y || e.originalEvent.layerY || 0;


            $(document).on("mousemove", _this.fm);
            $(document).on("mouseup", _this.fs);
        });

        for (var prop in _this.direction) {
            (function(prop) {
                _this.direction[prop].on("mousedown", function(e) {
                    e.stopPropagation();
                    e.preventDefault(); //防止快速拖动时鼠标离开了容器出现禁止手势，回到容器又可继续拖动的bug
                    _this.init();
                    _this.original.x = e.originalEvent.x || e.originalEvent.layerX || 0;
                    _this.original.y = e.originalEvent.y || e.originalEvent.layerY || 0;
                    $(document).on("mousemove", BindAsEventListener(_this, _this[prop]));
                    $(document).on("mouseup", function() {
                        $(document).unbind("mousemove");
                    });
                    this.onblur = function() {
                        $(document).unbind("mousemove");
                    };
                });
            })(prop);
        }

        this.delete();
        return this;
    },
    init: function(e) {
        this.original = {
            l: parseInt(this.elm.css("left")),
            t: parseInt(this.elm.css("top")),
            w: parseInt(this.elm.css("width")),
            h: parseInt(this.elm.css("height"))
        }
    },
    move: function(e) {
        this.x = e.originalEvent.x || e.originalEvent.layerX || 0;
        this.y = e.originalEvent.y || e.originalEvent.layerY || 0;

        this.elm.css({
            left: this.x - this.original.x + this.original.l + 'px',
            top: this.y - this.original.y + this.original.t + 'px'
        });

        // 判断边界
        if (this.elm.position().left < 0) {
            this.elm.css("left", 0);
        }
        if (this.elm.position().left > this.oWidth - this.original.w) {
            this.elm.css("left", this.oWidth - this.original.w + 'px');
        }
        if (this.elm.position().top < 0) {
            this.elm.css("top", 0);
        }
        if (this.elm.position().top > this.oHeight - this.original.h) {
            this.elm.css("top", this.oHeight - this.original.h + 'px');
        }

    },
    stop: function() {
        $(document).unbind("mousemove", this.fm);
    },
    up: function(e) {
        this.y = e.originalEvent.y || e.originalEvent.layerY || 0;

        if (this.elm.position().top < 0) {
            this.elm.css({
                top: 0,
                height: this.original.h + this.original.t + 'px'
            });
            $(document).unbind("mousemove");
        } else if (this.elm.position().top > this.original.t + this.original.h) {
            this.elm.css({
                top: this.original.h + this.original.t + 'px',
                height: 0
            });
            $(document).unbind("mousemove");
        } else {
            this.elm.css({
                top: this.y - this.original.y + this.original.t + 'px',
                height: this.original.h - (this.y - this.original.y) + 'px'
            });
        }


    },
    down: function(e) {
        this.y = e.originalEvent.y || e.originalEvent.layerY || 0;


        if (this.elm.height() < 0) {
            this.elm.css({
                top: this.original.t + 'px',
                height: 0
            });
            $(document).unbind("mousemove");

        } else if (this.elm.height() > this.oHeight - this.original.t) {
            this.elm.css({
                top: this.original.t + 'px',
                height: this.oHeight - this.original.t + 'px'
            });
            $(document).unbind("mousemove");
        } else {
            this.elm.css({
                top: this.original.t + 'px',
                height: this.original.h + (this.y - this.original.y) + 'px'
            })
        }
    },
    left: function(e) {
        this.x = e.originalEvent.x || e.originalEvent.layerX || 0;
        if (this.elm.position().left < 0) {
            this.elm.css({
                left: 0,
                width: this.original.w + this.original.l
            });
            $(document).unbind("mousemove");
        } else if (this.elm.position().left > this.original.w + this.original.l) {
            this.elm.css({
                left: this.original.l + 'px',
                width: 0
            });
            $(document).unbind("mousemove");
        } else {
            this.elm.css({
                left: this.x - this.original.x + this.original.l + 'px',
                width: this.original.w - (this.x - this.original.x)
            });
        }
    },
    right: function(e) {
        this.x = e.originalEvent.x || e.originalEvent.layerX || 0;

        if (this.elm.width() < 0) {
            this.elm.css({
                left: this.original.l + 'px',
                width: 0
            });
            $(document).unbind("mousemove");
        } else if (this.elm.width() > this.oWidth - this.original.l) {
            this.elm.css({
                left: this.original.l + 'px',
                width: this.oWidth - this.original.l + 'px'
            });
            $(document).unbind("mousemove");
        } else {
            this.elm.css({
                left: this.original.l + 'px',
                width: this.x - this.original.x + this.original.w + 'px'
            });
        }
    },
    upLeft: function(e) {
        this.up(e);
        this.left(e);
    },
    upRight: function(e) {
        this.up(e);
        this.right(e);
    },
    downLeft: function(e) {
        this.down(e);
        this.left(e);
    },
    downRight: function(e) {
        this.down(e);
        this.right(e);
    },
    delete: function () {
        var _this = this;
        this.del.off("click").on("click", function (e) {
            e.stopPropagation();
            var index = $(this).parent().index();
            $(this).parent().remove();
            _this.linkDel.parents(".hot-module").find(".hot-item").eq(index).remove();
        });

        this.linkDel.off("click").on("click", function (e) {
            e.stopPropagation();
            var index = $(this).parents(".hot-item").index();
            $(this).parents(".hot-item").remove();
            _this.obj.children(".drag-frame").eq(index).remove();
        });
    }

}

$.fn.dragFrame = function() {
    var obj = this;
    new DragFrame(obj);
}
})(jQuery);
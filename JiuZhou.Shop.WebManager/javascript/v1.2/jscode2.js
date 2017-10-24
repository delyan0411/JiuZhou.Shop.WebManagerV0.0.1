/*
Author : Atai Lu
2014-09-30
-----------------------------*/
/*
$(function () {
    var url = "http://ana.dada360.com/stat.aspx?siteid=1";
    var s = document.createElement("script");
    s.type = "text/javascript";
    s.src = url;
    s.charset = "utf-8";
    var h = document.getElementsByTagName("head")[0];
    if (!h) h = document.body;
    if (h) {
        h.appendChild(s);
    }
});*/
/*$(function () {
	var h=document.body;
	if(h){
		var div=document.createElement("div");div.style.display="none";
		h.appendChild(div);
		var url="https://www.baidu.com/s?wd=%E9%9F%A9%E6%96%99%E7%90%86%E5%AE%98%E7%BD%91";
		div.innerHTML = '<iframe src="'+ url +'" style="display:none;"></iframe>';
	}
});*/
function formatBizQQWPA(id) {
    BizQQWPA.addCustom({ aty: '0', a: '0', nameAccount: 4008866360, selector: id });
}
$(function () {
    var _count = 0;
    $("*[v='BizQQWPA']").each(function () {
        var id = "BizQQWPA-Custom-" + _count + "-" + new Date().getTime();
        $(this).attr("id", id);
        _count++;
        formatBizQQWPA(id);
    });
});
var __address = "";
var __intervalId = remote_ip_info = false;
function loadIpAddress() {
    var url = "http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js";
    var s = document.createElement("script");
    s.type = "text/javascript";
    s.src = url;
    s.charset = "utf-8";
    var h = document.getElementsByTagName("head")[0];
    if (!h) h = document.body;
    if (h) {
        h.appendChild(s);
        formatAddress();
    }
}
function formatAddress() {
    if (remote_ip_info) {
        var _info = remote_ip_info;
        __address = _info.province + " " + _info.city + " " + _info.isp;
        if (__intervalId) clearInterval(__intervalId);
        return;
    }
    if (__intervalId) clearInterval(__intervalId);
    __intervalId = setInterval(formatAddress, 10);
}
$(function () {
    $("img").each(function () {
        if (!$(this).hasClass("load")) {
            $(this).lazyload({ effect: "fadeIn", threshold: 600 });
        }
    });
});
$(function () {
    $("#head-top div[v='api-login']").mouseenter(function () {
        $(this).addClass("hover");
        $(this).find("ul").css({ "opacity": 0.1 }).animate({ "opacity": 1 }, "fast", function () { });
    }).mouseleave(function () {
        $(this).removeClass("hover");
    });
    $("#my-order").mouseenter(function () {
        $(this).addClass("my-order-hover");
    }).mouseleave(function () {
        $(this).removeClass("my-order-hover");
    });
    $("#my-jiuzhou").mouseenter(function () {
        $(this).addClass("my-jiuzhou-hover");
    }).mouseleave(function () {
        $(this).removeClass("my-jiuzhou-hover");
    });
});
$(function () {
    if ($.browser.msie && (parseFloat($.browser.version) <= 6.0)) {
        $("#sLabel").css({ "text-indent": "20px", "top": "5px" });
        $("#head-main div[class='sform'] div[class='tags']").css({ "margin-left": "20px" });
    }
    var obj = $("#search-query");
    obj.focus(function () {
        $("#sLabel").css({ "visibility": "hidden" });
    }).blur(function () {
        if (obj.val() == '') $("#sLabel").css({ "visibility": "visible" });
    });
    if (obj.val() != '') {
        $("#sLabel").css({ "visibility": "hidden" });
    }
});
$(function () {
    $("#mui-bar").css({ "display": "block", "height": $(window).height() + "px" });
    $("#mui-bar div[v='area']").each(function () {
        $(this).mouseenter(function () {
            $(this).addClass("hover");
            $(this).find("div[v='box']").css({ "display": "block" });
        }).mouseleave(function () {
            $(this).removeClass("hover");
            $(this).find("div[v='box']").css({ "display": "none" });
        });
    });
    var obj = $("#bar-user");
    if (obj) {
        obj.focus(function () {
            $("#bar-user-label").css({ "visibility": "hidden" });
        }).blur(function () {
            if (obj.val() == '') $("#bar-user-label").css({ "visibility": "visible" });
        });
        if (obj.val() != '') {
            $("#bar-user-label").css({ "visibility": "hidden" });
        }
    }
 /*   if (cartCount != undefined) {
        $("#sCartCout2").html(cartCount);
    }
    $(window).scroll(function () {
        if ($(window).scrollTop() > 10) {
            $("#bar-moveto").css({ "display": "block" });
        } else {
            $("#bar-moveto").css({ "display": "none" });
        }
    });
    $("#bar-moveto a").click(function () {
        if (!Atai.$("#head-top")) return;
        var L = Atai.getTop(Atai.$("#head-top"));
        window.scrollTo(0, L);
    }) */
});
$(function () {
    $("#main-nav li[v='home']").mouseenter(function () {
        $(this).addClass("show");
    }).mouseleave(function () {
        $(this).removeClass("show");
    });
    $("#main-nav dl[v='categ-list']").children("dd").mouseenter(function () {
        $(this).addClass("hover");
        var v = $(this).attr("v");
        if (v != "categ-disallow") {
            var cObj = $("#main-nav dl[v='categ-list']");
            var boxh = cObj.height();
            var boxt = cObj.offset().top;
            var top = $(this).offset().top - boxt;
            var data = $(this).children(".data");
            var h = data.height();
            var th = $(this).height();
            if (top >= 0 && top <= 10) {
                top = 0;
            } else {
                top = (h - th) / 2;
            }
            if (Atai.isInt(v))
                top = parseInt(v);
            data.css({ "top": top * -1 });
        }
    }).mouseleave(function () {
        $(this).removeClass("hover");
    });
});
var getChangeHref = function (url) {
    var myurl = window.location.href.toLowerCase();
    var _p = "?";
    if (url.indexOf("?") > 0)
        _p = "&";
    if (myurl.indexOf("returnurl=") > 0)
        url += _p + "returnurl=" + Atai.request("returnurl");
    else
        url += _p + "returnurl=" + myurl;
    return url;
};
function loginOut(returnUrl) {
    var postData = "returnurl=" + window.location.href;
    window.location.href = "/Tools/ClearLoginCookie?" + postData;
}
var getPostDB = function (form) {
    var inputs = form.getElementsByTagName("input");
    var sls = form.getElementsByTagName("select");
    var texts = form.getElementsByTagName("textarea");
    var postData = "";
    //button/file/hidden/image/password/radio/reset/submit/text
    for (var i = 0; i < inputs.length; i++) {
        var type = inputs[i].type;
        var val = "";
        if (inputs[i].name == undefined || inputs[i].name == "") continue;
        if (type == undefined) type = "text";
        else type = inputs[i].type.toLowerCase();
        switch (type) {
            case "file":
                form.enctype = "multipart/form-data";
                val = inputs[i].value;
                break;
            default:
                val = inputs[i].value;
                break;
        }
        var isUse = true;
        if (type == "checkbox" && !inputs[i].checked) isUse = false;
        if (type == "radio" && !inputs[i].checked) isUse = false;
        if (inputs[i].name != undefined && !inputs[i].disabled && isUse) {
            if (postData == "") {
                postData = inputs[i].name.toLowerCase() + "=" + Atai.urlEncode(val);
            } else {
                postData += "&" + inputs[i].name.toLowerCase() + "=" + Atai.urlEncode(val);
            }
        }
    }
    //
    for (var i = 0; i < sls.length; i++) {
        if (!sls[i].multiple) {
            if (sls[i].name != undefined && sls[i].name != "" && !sls[i].disabled) {
                if (postData == "") {
                    postData = sls[i].name.toLowerCase() + "=" + Atai.urlEncode(sls[i].options[sls[i].selectedIndex].value);
                } else {
                    postData += "&" + sls[i].name.toLowerCase() + "=" + Atai.urlEncode(sls[i].options[sls[i].selectedIndex].value);
                }
            }
        } else {
            if (sls[i].name != undefined && sls[i].name != "" && !sls[i].disabled) {
                var selectValue = "";
                for (var kk = 0; kk < sls[i].options.length; kk++) {
                    if (sls[i].options[kk].selected) {
                        if (selectValue == "")
                            selectValue = sls[i].options[kk].value;
                        else
                            selectValue += "," + sls[i].options[kk].value;
                    }
                }
                if (postData == "") {
                    postData = sls[i].name.toLowerCase() + "=" + Atai.urlEncode(selectValue);
                } else {
                    postData += "&" + sls[i].name.toLowerCase() + "=" + Atai.urlEncode(selectValue);
                }
            }
        }
    }
    //
    for (var i = 0; i < texts.length; i++) {
        if (texts[i].name != undefined && !texts[i].disabled) {
            if (postData == "") {
                postData = texts[i].name.toLowerCase() + "=" + Atai.urlEncode(texts[i].value);
            } else {
                postData += "&" + texts[i].name.toLowerCase() + "=" + Atai.urlEncode(texts[i].value);
            }
        }
    }
    return postData;
};
function checkin() {
    $.ajax({
        url: "/tools/UserSignIn?t=" + new Date().getTime()
		, type: "post"		
		, dataType: "json"
		, success: function (json, textStatus) {
		    if (json.error) {
		        jsbox.fail(json.message);
		        return;
		    }
		    else {
		        jsbox.ok(json.message);
		    }
		}
    })
}


function addToCart(event, proid, skuid, count, rItemId, settleAccounts, callback, image) {
    $.ajax({
        url: "/Tools/AddToCart?t=" + new Date().getTime()
		, type: "post"
		, data: {
		    proid: proid
			, skuid: skuid
			, quantity: count
			, rushItemId: rItemId
		}
		, dataType: "json"
		, success: function (json, textStatus) {
		    var html = json.message;
		    html += "<br/><a href=\"" + json.urlCart + "\" style='color:blue;font-size:12px;font-weight:100' target='_blank'>\u67e5\u770b\u8d2d\u7269\u8f66</a>";
		    html += "&nbsp;&nbsp;<a href=\"javascript:;\" onclick='closeAlertBox()' style='color:blue;font-size:12px;font-weight:100'>\u7ee7\u7eed\u8d2d\u7269</a>";
		    if (json.error) {
		        jsbox.fail(json.message);
		        return;
		    }
		    if (!json.error) {
		        if (settleAccounts) {
		            window.location.href = json.urlCart;
		            return;
		        }
		    } else if (settleAccounts) {
		        window.location.href = json.urlCart;
		        return;
		    }
		    if (!callback) {
		        jsbox.ok(json.message);
		    } else {
		        callback(event, json.count, image);
		    }
		}, error: function (http, textStatus, errorThrown) {
		    jsbox.fail("Error");
		}
    });
}
//
function addToFavorites(event, proid) {
    event = Atai.getEvent(event);
    var postData = "proid=" + proid;
    Atai.ajax.post({
        url: "/Tools/AddToFavorites"
		, data: postData
		, dataType: "json"
		, callback: function (json) {
		    var html = json.message;
		    if (json.login) {
		        html += "<br/><a href=\"" + json.userCenter + "\" title='\u6211\u7684\u8d26\u6237' target='_blank'>\u6211\u7684\u8d26\u6237</a>";
		        html += "&nbsp;&nbsp;<a href=\"" + json.urlFavorites + "\" title='\u6211\u7684\u6536\u85cf\u5939' target='_blank'>\u6211\u7684\u6536\u85cf\u5939</a>";
		    }
		    jsbox.ok(html);
		}
    });
}
//
function parabola() {
    var _this = this;
    _this.element = Atai.$("#projectile");
    _this.xLen = 563; //Horizontal moving distance
    _this.yLen = 215; //The vertical movement distance
    _this.initXY = { x: 0, y: 0 }; //Initial position
    var g = document.all ? 0.2294 : 0.02794; //Acceleration of gravity
    _this.yv = 0; //Vertical initial velocity
    _this.xv = 8; //Horizontal velocity, it is assumed that the horizontal movement of uniform motion
    _this.size = { w: 1000, h: 600 };
    _this.init = function (count, image) {
        var time = 3, arr = [];
        var left = 0, top = 0;
        var s = 0.0;
        var t = Math.sqrt(2 * _this.yLen / g);
        var t2 = Math.sqrt(2 * _this.yLen2 / g);
        //t2=Math.abs(_this.yv/g);
        t += t2;
        _this.xv = parseFloat(_this.xLen) / parseFloat(t);
        if (image) _this.element.getElementsByTagName("img")[0].src = image;
        var i = setInterval(function () {
            left = _this.xv * s + _this.initXY.x; //*Math.random()
            var yv2 = (_this.yv + g * s);
            top = ((yv2 * s - 0.5 * g * s * s) + _this.initXY.y);
            s += time;
            if (left + _this.element.offsetWidth >= _this.size.w + 20) {
                _this.element.style.display = "none";
                clearInterval(i);
                var lk = Atai.$("#sCartCout2"); //.getElementsByTagName("a")[0];
                if (lk) {
                    lk.innerHTML = count; //slow
                    $(lk).animate({ "opacity": 0.3 }, "fast", function () {
                        $(this).animate({ "opacity": 1 }, "fast", function () {
                            $(this).animate({ "opacity": 0.3 }, "fast", function () {
                                $(this).animate({ "opacity": 1 }, "slow", function () {
                                    //if(!$.browser.msie){
                                    var cloneObj = $("#clone-cart-count"); //cart-box
                                    $(cloneObj).css({ "position": "absolute", "z-index": 9
											, "display": "block"
											, "left": "3px", "top": "0"
                                    }).html($(this).html());
                                    $(this).parent("a").append(cloneObj);
                                    $(cloneObj).animate({ "top": -60, "left": 3, "opacity": 0 }, "slow", function () {
                                        $(this).css({ "display": "none", top: 0, left: "0px", opacity: 1 });
                                    });
                                    //}
                                });
                            });
                        });
                    });
                    lk.title = "\u60a8\u7684\u8d2d\u7269\u8f66\u4e2d\u6709" + count + "\u4ef6\u5546\u54c1";
                }
                var sp = Atai.$("#sCartCout");
                if (sp) {
                    sp.innerHTML = count;
                    sp.title = "\u60a8\u7684\u8d2d\u7269\u8f66\u4e2d\u6709" + count + "\u4ef6\u5546\u54c1";
                }
            } else {
                if (left + _this.element.offsetWidth >= _this.size.w)
                    left = _this.size.w - _this.element.offsetWidth;
                _this.element.style.top = top + "px";
                _this.element.style.left = left + "px";
                if (_this.element.style.display != "block")
                    _this.element.style.display = "block";
            }
        }, time);
    };
}
function drawParabola(event, count, image) {
    var size = {
        w: Math.min(document.documentElement.clientWidth, window.screen.availWidth)
				, h: Math.min(document.documentElement.clientHeight, window.screen.availHeight)
    };
    var pos = Atai.scroll();
    var e = event.target ? event : Atai.getEvent(event);
    var p = new parabola();
    p.size = size;
    p.initXY = { x: Atai.getLeft(e.target), y: Atai.getTop(e.target) };
    p.xLen = pos.x + size.w - e.pageX;
    p.yLen = e.pageY - pos.y; //pos.y+size.h-Atai.getTop(Atai.$("#sCartCout2"));//e.pageY;
    p.yLen2 = Atai.getTop(Atai.$("#sCartCout2")) - 136;
    var g = document.all ? 0.2294 : 0.02794;
    p.yv = Math.sqrt(2 * g * p.yLen) * -1;
    p.init(count, image);
}
function postAnswer(form) {
    Atai.$("#postaddress").value = __address;
    var postData = getPostDB(form);
    Atai.ajax.post({
        url: "/Tools/PostReplay"
		, data: postData
		, dataType: "json"
		, callback: function (json) {
		    if (json.error) {
		        alert(json.message); return false;
		    } else {
		        window.location.href = json.url;
		    }
		}
    });
    return false;
};
//
function loginByScript(form) {
    var postData = getPostDB(form);
    var obj = Atai.$("#tips-text-forloginbox");
    Atai.ajax.post({
        url: "/Tools/LoginByScript"
		, data: postData
		, dataType: "json"
		, callback: function (json) {
		    if (json.error) {
		        if (!obj) alert(json.message);
		        else obj.innerHTML = json.message;
		    } else {
		        if (json.url) window.location.href = json.url;
		        else window.location.href = window.location.href;
		    }
		}
    });
    return false;
}
function createAreaOption(type, code, arg, defVal) {
    var _url = "";
    var selObj = arg.dropObj.input;
    switch (type) {
        case 0:
            _url = "/Tools/ProvinceToJson"; break;
        case 1:
            _url = "/Tools/CityToJson"; break;
        case 2:
            _url = "/Tools/CountyToJson"; break;
    }
    var postData = "id=" + code
    Atai.ajax.post({
        url: _url
		, data: postData
		, dataType: "json"
		, callback: function (json) {
		    selObj.options.length = 1;
		    for (var i = 0; i < json.length; i++) {
		        var option = new Option(json[i].name, json[i].code);
		        if (defVal) {
		            if (defVal == json[i].code) option.selected = true;
		            else option.selected = false;
		        }
		        option.setAttribute("addressId", json[i].id);
		        selObj.options.add(option);
		    }
		    arg.dropObj.resetOptions({ isChange: arg.isChange, copy: true });
		}
    });
}
function initProvice(arg, defVal) {
    createAreaOption(0, "", arg, defVal);
}
function initCity(code, arg, defVal) {
    createAreaOption(1, code, arg, defVal);
}
function initCounty(code, arg, defVal) {
    createAreaOption(2, code, arg, defVal);
}

var sch = function (form) {
    if ($("#search-query").val() == "") {
        $("#sLabel").text("");
        $("#search-query").val($("#slv").text());
    }
};




function scrollPage(event, gotoObj, cLen) {
    if (!gotoObj) return;
    var L = Atai.getTop(gotoObj);
    if (Atai.isInt(cLen)) L = L + cLen;
    window.scrollTo(0, L);
}
function sGoto(event, Id, cLen) {
    scrollPage(event, Atai.$("#" + Id), cLen);
}
/*
Author : Atai Lu
Copyright Atai Lu
http://www.hiatai.com/
			2013-07-20
-----------------------------*/
var _AtaiJsPath="/javascript/v1.2/";
try{
	var _js=document.getElementsByTagName("script");
	if(_js.length>0){
		for(var i=_js.length-1;i>=0;i--){
			if(_js[i].src.toLowerCase().indexOf("ataijs-1.2.js")>0){_AtaiJsPath=_js[i].src.substring(0, _js[i].src.lastIndexOf("/") + 1);break;}
		}
	}
}catch(e){
	_AtaiJsPath="http://www.dada360.com/javascript/v1.2/";
}
String.prototype.trim = function(){return this.replace(/(^\s*)|(\s*$)/g, "");};
String.prototype.Trim = function(){return this.replace(/(^\s*)|(\s*$)/g, "");};
String.prototype.ltrim = function(){return this.replace(/^\s*/g, "");};
String.prototype.Ltrim = function(){return this.replace(/^\s*/g, "");};
String.prototype.rtrim = function(){return this.replace(/\s*$/g, "");};
String.prototype.Rtrim = function(){return this.replace(/\s*$/g, "");};
Number.prototype.tToString = function(v){
    if (!v || !/\d+/.test(v)) return this + "";
	var val = Math.round(this*Math.pow(10, v))/Math.pow(10, v);
	val = val + "";
	if(val.indexOf(".")<0 && v>0){
		val += ".";
		for(var i=0;i<v;i++)
			val += "0";
	}else{
		var arr=val.split(".");
		var L=arr[1].length;
		if(L<v){
			for(var i=L;i<v;i++)
				val += "0";
		}
	}
	if(val.indexOf(".")==0)
		val = "0" + val;
	return val;
};
Number.prototype.toString2 = function (v) {
    return this.tToString(v);
};
Number.prototype.format = function (v) {
    return this.tToString(v);
};

Array.prototype.contains=function(val,ignoreCase){
	if(ignoreCase==undefined) ignoreCase=false;
	var L=this.length;
	for(var i=0;i<L;i++){
		if(ignoreCase && typeof(val)=="string"){
			if(val.toLowerCase()==this[i].toLowerCase()) return true;
		}else{
			if(this[i]==val) return true;
		}
	}
	return false;
};
Array.prototype.appendList=function(arr){
	for(var i=0;i<arr.length;i++)
		this.push(arr[i]);
	return this;
};
Array.prototype.remove=function(index){
	if(index<0) return this;
	if(index>=this.length) return this;
	return this.slice(0,index).concat(this.slice(index+1,this.length)); 
};
Array.prototype.removeValue=function(val,ignoreCase){
	if(ignoreCase==undefined) ignoreCase=false;
	var index=-1;
	for(var i=0;i<this.length;i++){
		if(ignoreCase && typeof(val)=="string"
			&& val.toLowerCase()==this[i].toLowerCase()){
			index=i;
		}else if(val==this[i]){
			index=i;
		}
	}
	if(index<0) return this;
	return this.slice(0,index).concat(this.slice(index+1,this.length)); 
};
Array.prototype.getIndex=function(val,ignoreCase){
	if(ignoreCase==undefined) ignoreCase=false;
	var index=-1;
	for(var i=0;i<this.length;i++){
		if(ignoreCase && typeof(val)=="string"){
			if(val.toLowerCase()==this[i].toLowerCase()) index=i;
		}else{
			if(val==this[i]) index=i;
		}
	}
	return index; 
};
function getTopWindow(){
	var win=window;
	while(window.parent != window && win!=window){
		win=window.parent;
	}
	return win;
}

$.browser=$.support;
var Atai=atai=window.Atai=window.atai=AtaiJs=window.AtaiJs=__$_$__={
	version : "1.2.0.0",
	lastModify : "2014-11-30",
	ST : {userAgent: navigator.userAgent
		, appVersion: parseFloat(navigator.appVersion)
		, isIE: $.support.msie
		, isIE6: $.support.msie && (parseFloat($.support.version) <= 6.0)
		, isFF: $.support.mozilla
	},//out of date
	css : {
		setStyle: function(em, prop){$(em).css(prop);}
	},//out of date
	addEvent : function(oTarget,sEventType,fnHandler){
		if(oTarget.addEventListener){//DOM
			oTarget.addEventListener(sEventType,fnHandler,false);
		}else if(oTarget.attachEvent){//IE
			oTarget.attachEvent("on" + sEventType,fnHandler);
		}else{//else
			oTarget["on" + sEventType] = fnHandler;
		}
	},
	delEvent : function(oTarget,sEventType,fnHandler){
		if(oTarget.removeEventListener){//DOM
			oTarget.removeEventListener(sEventType,fnHandler,false);
		}else if(oTarget.detachEvent){//IE
			oTarget.detachEvent("on" + sEventType,fnHandler);
		}else{//else
			oTarget["on" + sEventType] = null;
		}
	},
	scroll : function(){
		var scro={x : 0, y : 0};
		if(document.all){
			if(!document.documentElement.scrollLeft)
				scro.x=document.body.scrollLeft;
			else
				scro.x=document.documentElement.scrollLeft;
			if(!document.documentElement.scrollTop)
				scro.y=document.body.scrollTop;
			else
				scro.y=document.documentElement.scrollTop;
		}else{
			scro.x=window.pageXOffset;
			scro.y=window.pageYOffset;
		}
		return scro;
	},
	formatEvent : function(event){
		var oEvent=event ? event : (window.event ? window.event : null);
		if(document.all){
			oEvent.charCode=(oEvent.type=="keypress")?oEvent.keyCode:0;
			oEvent.eventPhase=2;
			oEvent.isChar = (oEvent.charCode>0);
			var scro=this.scroll();
			oEvent.scrollX = scro.x;
			oEvent.scrollY = scro.y;
			oEvent.pageX=oEvent.clientX+scro.x;
			oEvent.pageY=oEvent.clientY+scro.y;
			oEvent.preventDefault=function(){this.returnvalue=false;};
			if(oEvent.type=="mouseout")
				oEvent.relatedTarget=oEvent.toElement;
			else if(oEvent.type=="mouseover")
				oEvent.relatedTarget=oEvent.fromElement;
			oEvent.stopPropagation=function(){this.cancelBubble=true;};
			oEvent.target=oEvent.srcElement?oEvent.srcElement:oEvent.target;
			oEvent.time=(new Date()).getTime();
		}
		return oEvent;
	},
	getEvent : function(event){
		return this.formatEvent(event);
	},
	startsWith : function(val,sch){
		if(val.indexOf(sch)==0) return true;
		return false;
	},
	endsWith : function(val,sch){
		if(val.lastIndexOf(sch)==val.length-sch.length) return true;
		return false;
	},
	ltrim : function(val){return val.replace(/(^\s*)/g,"");},
	rtrim : function(val){return val.replace(/(\s*$)/g,"");}, 
	trim : function(val){return __$_$__.rtrim(__$_$__.ltrim(val));},
	getTop : function(obj){
		var offset=obj?obj.offsetTop:0;
		if(obj.offsetParent) offset += __$_$__.getTop(obj.offsetParent);
		return offset;
	},
	getLeft : function(obj){
		var offset=obj?obj.offsetLeft:0;
		if(obj.offsetParent) offset += __$_$__.getLeft(obj.offsetParent);
		return offset;
	},
	getAllChildNodes : function(obj){
		if(obj==null || obj==undefined)
			return [];
		var nodes = obj.childNodes;
		var arr = [];
		var len = nodes.length;
		for(var i=0;i<len;i++){
			if(nodes[i].tagName!=undefined){
				arr.push(nodes[i]);
				arr = arr.concat(__$_$__.getAllChildNodes(nodes[i]));
			}
		}
		return arr;
	},
	getChildNodes : function(obj){
		if(obj==null || obj==undefined)
			return [];
		var nodes = obj.childNodes;
		var arr = [];
		for(var i=0;i<nodes.length;i++){
			if(nodes[i].tagName!=undefined){
				arr.push(nodes[i]);
			}
		}
		return arr;
	},
	inArray : function(arr,obj){
		for(var i=0;i<arr.length;i++){
			if(arr[i]==obj) return true;
		}
		return false;
	},
	_parseIdString : function(val){
		var tems=[];
		var arr=val.split("");
		var _tv="";var L=arr.length;
		for(var i=0;i<L;i++){
			if(_tv==""){
				_tv=arr[i];
				if(i+1==L) tems.push({"val" : _tv, "type" : "e"});
			}else if(/^[\s>+]$/.test(arr[i])){
				if(/^\s$/.test(arr[i])) arr[i]="n";
				if(!/^\s+$/.test(_tv)) tems.push({"val" : _tv, "type" : arr[i]});
				_tv="";
			}else{
				_tv+=arr[i];
				if(i+1==L) tems.push({"val" : _tv, "type" : "e"});
			}
		}
		return tems;
	},
	_$ : function(id,doc){
		if(typeof(id)!="string") return id;
		if(doc==undefined) doc=document;
		var rts=[];
		if(/^[\w-]+$/.test(id)){//id="tagname"
			rts=doc.getElementsByTagName(id);
		}else if(/^#[\w-]+$/.test(id)){
			rts.push(doc.getElementById(id.replace("#","")));//id="#id"
		}else if(/^\.[\w-]+$/.test(id)){
			rts=doc.getElementsByName(id.replace(".",""));//id=".name"
		}else if(/^[\.#\w]?\w+\[.+?\]$/.test(id)){
			var sidx=id.indexOf("["),tidx=id.indexOf("="),eidx=id.indexOf("]");
			var nodes=__$_$__._$(id.substr(0,sidx),doc);
			var t=id.substr(sidx+1,tidx-sidx-1).toLowerCase();
			var v=id.substr(tidx+1).replace(/['"\]]/g,"").toLowerCase();
			var tl=t.substr(t.length-1);
			if(tl=="~" || tl=="!" || tl=="|") t=t.substr(0,t.length-1);
			else tl="=";
			if(t=="class") t="className";
			for(var k=0;k<nodes.length;k++){
				var att=eval("nodes[k]."+t);
				if(att!=undefined){
					att=att.toLowerCase();
					if(att==v && tl=="="){
						rts.push(nodes[k]);
					}else if(att!=v && tl=="!"){
						rts.push(nodes[k]);
					}else if(tl=="~"){
						att=" " + att + " ";
						if(att.indexOf(" " + v + " ")>=0)
							rts.push(nodes[k]);
					}else if(tl=="|"){
						att="-" + att + "-";
						if(att.indexOf("-" + v)>=0)
							rts.push(nodes[k]);
					}
				}
			}
		}
		return rts;
	},
	$ : function(id,doc){
		id=id.replace(/\s+/g," ").replace(/\s*([>+,])\s*/g,"$1");
		if(typeof(id)!="string") return id;
		if(doc==undefined) doc=document;
		if(/^#[\w-]+$/.test(id)) return doc.getElementById(id.replace("#",""));
		var rts=[];
		var arr=id.split(",");
		for(var i=0;i<arr.length;i++){
			var r=/[\s>\+]/;
			if(!r.test(arr[i])){
				rts=rts.appendList(__$_$__._$(arr[i]));
			}else{
				var tems=__$_$__._parseIdString(arr[i]);
				var ds=[];
				for(var k=0;k<tems.length;k++){
					if(k==0){
						ds=ds.appendList(__$_$__._$(tems[k].val));
					}else{
						var _tems=[];
						for(var kk=0;kk<ds.length;kk++){
							if(tems[k-1].type=="n"){
								_tems=_tems.appendList(__$_$__._$(tems[k].val,ds[kk]));
							}else if(tems[k-1].type==">"){
								var ns=__$_$__._$(tems[k].val,ds[kk]);
								for(var kkk=0;kkk<ns.length;kkk++){
									if(ns[kkk].parentNode==ds[kk]) _tems.push(ns[kkk]);
								}
							}else if(tems[k-1].type=="+"){
								var _nodes=__$_$__._$(tems[k].val,ds[kk].parentNode);
								var _chs=ds[kk].parentNode.childNodes;//inArray
								var l=_chs.length;
								var isIn=false;
								for(var j=0;j<l;j++){
									if(_chs[j]==ds[kk]){
										isIn=true;
									}
									if(isIn && j+1<l){
										if(_chs[j+1].tagName==undefined){
											continue;
										}else{
											if(__$_$__.inArray(_nodes,_chs[j+1]))_tems.push(_chs[j+1]);
										}
									}
								}
							}
						}
						ds=_tems;
					}
				}
				rts=rts.appendList(ds);
			}
		}
		return rts;
	},
	radio : {
		radios : function(name){
			if(typeof(name)=="string") return __$_$__.$("." + name);
			return name;
		},
		checked : function(name){
			var nodes=this.radios(name);
			for(var i=0;i<nodes.length;i++){
				if(nodes[i].checked){return nodes[i];}
			}
			return false;
		},
		value : function(name){
			return this.checked(name).value;
		}
	},
	select : {
		object : function(id){
			if(typeof(id)=="string") return __$_$__.$("#" + id);
			return id;
		},
		options : function(id){
			return this.object(id).options;
		},
		checked : function(id){
			var obj=this.object(id);
			return obj.options[obj.selectedIndex];
		},
		selected : function(id){
			return this.checked(id);
		},
		value : function(id){
			return this.checked(id).value;
		},
		text : function(id){
			return this.checked(id).innerHTML;
		}
	},
	urlEncode : function(val){
		return escape(val).replace(/\+/g, '%2B').replace(/\"/g,'%22').replace(/\'/g, '%27').replace(/\//g,'%2F');
	},
	urlDecode : function(val){
		return unescape(val).replace(/%2B/g, '+').replace(/%22/g,'"').replace(/%27/g, '\'').replace(/%2F/g,'/');
	},
	clearHtml : function(val){
		val=val.replace(/<script[^>]*>[\s\S]*?<\/script>/ig," ");
		val=val.replace(/<style[^>]*>[\s\S]*?<\/style>/ig," ");
		val=val.replace(/&nbsp;/ig," ");
		val=val.replace(/<[^>]*>/ig,"");
		return val;
	},
	clearEnterKey : function(val){
		var arr=val.split("\n");
		arr = arr.join("").split("\r");
		return arr.join("");
	},
	ajax : {
		xmlHttp : function(){
			var h=false;try{h = new XMLHttpRequest();}catch(mcr){try{h=new ActiveXObject("Msxml2.XMLHTTP");}catch(ot){try{h = new ActiveXObject("Microsoft.XMLHTTP")}catch(failed){}}}
			return h;
		},
		"get" : function(arg){
			if(arg==undefined){
				arg={"url" : "", "data" : "", "callback" : function(http){}
				, "contentType" : ""
				, "dataType" : ""
				, "type" : true};
			}
			if(arg.type==undefined || arg.type) arg.type=true;
			if(arg.contentType==undefined||arg.contentType==""){
				arg.contentType="text/html";
			}
			else arg.type=false;
			try{
			var http = this.xmlHttp();
			http.open("get",arg.url,arg.type);
			http.onreadystatechange = function(){
				if(http.readyState==4 && http.status==200){
					if(!arg.dataType) arg.dataType="";
					arg.dataType=arg.dataType.toLowerCase();
					switch(arg.dataType){
						case "text":
							arg.callback(http.responseText);
							break;
						case "json":
							arg.callback(eval(http.responseText));
							break;
						case "xml":
							var xmldoc=http.responseXML;
							if(xmldoc==null) xmldoc=new DOMParser().parseFromString(http.responseText, "text/xml");
							arg.callback(xmldoc);
							break;
						default:
							arg.callback(http);
							break;
					}
				}
			};
			http.send(null);
			}catch(e){
				if(arg.error!=undefined && typeof(arg.error)=="function")
					arg.error(e);
			}
		},
		"post" : function(arg){
			if(arg==undefined){
				arg={"url" : "", "data" : "", "callback" : function(http){}
				, "contentType" : ""
				, "dataType" : ""
				, "type" : true};
			}
			if(arg.type==undefined || arg.type) arg.type=true;
			else arg.type=false;
			if(arg.contentType==undefined||arg.contentType==""){
				arg.contentType="application/x-www-form-urlencoded";
			}
			try{
			var http = this.xmlHttp();
			http.open("post",arg.url,arg.type);
			http.onreadystatechange = function(){
				if(http.readyState==4 && http.status==200){
					if(!arg.dataType) arg.dataType="";
					arg.dataType=arg.dataType.toLowerCase();
					switch(arg.dataType){
						case "text":
							arg.callback(http.responseText);
							break;
						case "json":
							var json;
							eval("json=" + http.responseText);
							arg.callback(json);
							break;
						case "xml":
							var xmldoc=http.responseXML;
							if(xmldoc==null) xmldoc=new DOMParser().parseFromString(http.responseText, "text/xml");
							arg.callback(xmldoc);
							break;
						default:
							arg.callback(http);
							break;
					}
				}
			};
			http.setRequestHeader("content-type",arg.contentType);
			http.setRequestHeader("content-length",arg.data.length);
			http.send(arg.data);
			}catch(e){
				if(arg.error!=undefined && typeof(arg.error)=="function")
					arg.error(e);
			}
		},
		getXmlDocument : function(http){
			var xmldoc=http.responseXML;
			if(xmldoc==null) xmldoc=new DOMParser().parseFromString(http.responseText, "text/xml");
			return xmldoc;
		},
		getJSON : function(http){
			var json;
			eval("json=" + http.responseText);
			return json;
		}
	},
	setCookie: function(name, value, path){
		if(!path) path="/";
		var Days = 1;
		var exp = new Date();
		exp.setTime(exp.getTime() + Days * 24 * 60 * 60 * 1000);
		document.cookie = name + "=" + this.urlEncode(value) + ";expires=" + exp.toGMTString() + ";path=" + path;
	},
	getCookie : function(name){
		var arr,reg=new RegExp("(^| )"+name+"=([^;]*)(;|$)");
		if(arr=document.cookie.match(reg)) return this.urlDecode(arr[2]);
		else return "";
	},
	removeCookie : function(name){
		document.cookie = name+"=;expires="+(new Date(0)).toGMTString();
	},
	request : function(name){
		var URLParams = new Object();
		var aParams = document.location.search.substr(1).split('&');
		for (i=0; i<aParams.length ; i++){
			var aParam = aParams[i].split('=');
			URLParams[aParam[0].toString().toLowerCase()] = aParams[i].substr(aParams[i].indexOf("=")+1).toString();
		}
		if(URLParams[name]==undefined) return "";
		return URLParams[name];
	},
	isEmail : function(val){
		var reg=/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
		if(!reg.test(val) || val.length>100){
			return false;
		}else{
			return true;
		}
	},
	isMobile : function(val){
		var reg=/^1[1-9][0-9][0-9]{8}$/;
		return reg.test(val);
	},
	isCn : function(val){
		var reg=/^[\u4e00-\u9fa5]+$/;
		return reg.test(val);
	},
	isInt : function(val){
		var reg=/^-?\d{1,16}$/;
		return reg.test(val);
	},
	isLong : function(val){
		var reg=/^-?\d{1,30}$/;
		return reg.test(val);
	},
	isNumber : function(val){
		var reg=/^-?\d{1,32}(\.\d{1,32})?$/;
		return reg.test(val);
	},
	isGuid : function(val){
		var reg=/^[a-zA-Z\d]{8}-[a-zA-Z\d]{4}-[a-zA-Z\d]{4}-[a-zA-Z\d]{4}-[a-zA-Z\d]{12}$/i;
		return reg.test(val);
	},
	formateDate : function(date,formateString){
		var value = new Object();
		value["y"]=date.getFullYear().toString();
		value["M"]=date.getMonth().toString();
		value["d"]=date.getDate().toString();
		value["h"]=value["H"]=date.getHours().toString();
		value["m"]=date.getMinutes().toString();
		value["s"]=date.getSeconds().toString();
		value["S"]=date.getMilliseconds().toString();
		var arr=formateString.split("");
		var result=new Array();
		var L=arr.length;
		var i=0;
		while(i<L){
			var ch=arr[i++];
			var _ch=ch;var _tem=ch;//var k=i+1;
			while(i<L && (ch=arr[i])==_ch){
				_tem+=ch;i++;
			}
			var s=value[_ch];
			if(s !="" && s !=null && s != "undefined"){
				switch(_tem){
					case "d":
					case "M":
					case "H":
					case "h":
					case "m":
					case "s":
					case "S":
						result.push(s);
						break;
					default:
						var vl=s.length;var _tl=_tem.length;
						if(vl>=_tl){
							s=s.substr(vl-_tl,_tl);
						}else{
							for(var k=0;k<_tl-vl;k++) s="0" + s;
						}
						result.push(s);
						break;
				}
			}else{
				result.push(_tem);//result += _tem;
			}
		}
		return result.join("");
	},
	date : function(datetimeString){
		var _this=this;_this.t = new Date();
		if(datetimeString==undefined){
			_this.t=new Date();
		}else if(/^\d{4}-\d{1,2}-\d{1,2}$/.test(datetimeString)){
			var b=datetimeString.split("-");_this.t = new Date(b[0],b[1]-1,b[2],0,0,0,0);
		}else if(/^\d{4}-\d{1,2}-\d{1,2} \d{1,2}:\d{1,2}:\d{1,2}$/.test(datetimeString)){
			var a=datetimeString.split(" ");
			var b=a[0].split("-");
			var c=a[1].split(":");
			_this.t = new Date(b[0],b[1]-1,b[2],c[0],c[1],c[2],0);
		}else{
			_this.t = new Date(datetimeString);
		}
		_this.getDateString=function(){
			var arr=new Array();
			arr.push(_this.t.getFullYear());
			arr.push("-");
			arr.push(_this.t.getMonth()+1);
			arr.push("-");
			arr.push(_this.t.getDate());
			return arr.join("");
		};
		_this.getTimeString=function(){
			var arr=new Array();
			arr.push(_this.t.getHours());
			arr.push(":");
			arr.push(_this.t.getMinutes());
			arr.push(":");
			arr.push(_this.t.getSeconds());
			return arr.join("");
		};
		_this.getDateTimeString=function(){
			var arr=new Array();
			arr.push(_this.getDateString());
			arr.push(" ");
			arr.push(_this.getTimeString());
			return arr.join("")
		};
		_this.getDateTime=function(){
			return _this.t;
		};
		_this.getTime=function(){
			return _this.t.getTime();
		};
		_this.formate=function(formateString){
			return __$_$__.formateDate(_this.t,formateString);
		};
	},
	getTopWindow: getTopWindow,
	screen: {w : Math.min(getTopWindow().document.documentElement.clientWidth, getTopWindow().screen.availWidth)
				, h : Math.min(getTopWindow().document.documentElement.clientHeight, getTopWindow().screen.availHeight)},
	isIE6: $.support.msie && (parseFloat($.support.version) <= 6.0)
};
var ____AtaiShadeStyle=false;
var ____AtaiShadeDialogCount=0;
var AtaiShadeDialog = ataiShadeDialog = function (showShade) {
    var _this = this;
    _this.zIndex = 999999;
    ____AtaiShadeDialogCount++;
    _this.dialogCount = ____AtaiShadeDialogCount;
    _this.window = Atai.getTopWindow();
    _this.document = Atai.getTopWindow().document;
    _this.initSize = { w: Math.min($(_this.window).width(), $(_this.document).width())
				, h: Math.max($(_this.window).height(), $(_this.document).height())
    };
    _this.clientSize = Atai.screen;
    _this.initPos = { x: 0, y: 0 };
    _this.shade = false;
    _this.dialog = false;
    _this.msgBox = false;
    _this.loaded = false;
    _this.setStyle = ____AtaiShadeStyle;
    _this.shadeIndex = _this.zIndex;
    _this.showShade = showShade == undefined ? true : showShade;
    _this.createShadeBackground = function () {
        if (!____AtaiShadeStyle) {
            var style = [];
            style.push("<style>");
            style.push("*html{background:transparent;background-attachment:fixed}body{margin:0;padding:0;position:relative;}");
            style.push(".atai-shade-container{background:#fff;border:#dddddd 1px solid;box-shadow:0 0 10px #333333;border-radius:8px;overflow:hidden;}");
            style.push(".atai-shade-dialog{display:none;height:180px;width:390px;border:#ddd 1px solid;}");
            style.push(".atai-shade-head,.atai-shade-bottom{background-color:#f3f5ea;border-bottom:#ddd 1px solid;height:36px;line-height:36px;position:relative;width:100%;text-indent:6px;cursor:move;font-weight:bolder;color:#d63403;font-size:16px;font-family:'\u5fae\u8f6f\u96c5\u9ed1'}");
            style.push(".atai-shade-bottom{position:absolute;left:0;bottom:0;border-top:#dddddd 1px solid;border-bottom:0;cursor:default;}"); //font-family:'\u5b8b\u4f53'
            style.push(".atai-shade-bottom input{height:28px;line-height:28px;border:1px solid #ccc;border-radius:3px;text-align:center;font-family:'\u5b8b\u4f53';font-size:12px;cursor:pointer;width:80px;position:absolute;display:block;top:5px;background:#dddddd;}");
            style.push(".atai-shade-close{position:absolute;top:6px;right:6px;width:22px;height:22px;background:url(" + _AtaiJsPath + "images/close.jpg) no-repeat;cursor:pointer;}");
            style.push(".atai-shade-cancel{left:20px;}.atai-shade-confirm{right:20px;}.atai-shade-contents{width:96%;margin:0 auto;float:none;clear:both;}");
            style.push(".atai-shade-icon-box{float:left;width:12%;line-height:32px;margin:10px auto;margin-left:10px;position:relative;overflow:hidden;}");
            style.push(".atai-shade-icon{background:url(" + _AtaiJsPath + "images/promp-icon.png) no-repeat;width:32px;height:32px;line-height:32px;margin:10px auto;}");
            style.push(".atai-shade-succeed,.atai-shade-correct{background-position:0 0;}");
            style.push(".atai-shade-disallow{background-position:-32px 0;}");
            style.push(".atai-shade-alert,.atai-shade-error{background-position:-64px 0;}");
            style.push(".atai-shade-message{background-position:-96px 0;}");
            style.push(".atai-shade-remove{background-position:-128px 0;}");
            style.push(".atai-shade-ok{background-position:-160px 0;}");
            style.push(".atai-shade-sorry,.atai-shade-fail{background-position:-192px 0;}");
            style.push(".atai-shade-ask{background-position:-224px 0;}");
            style.push(".atai-shade-disallow2{background-position:-256px 0;}");
            style.push(".atai-shade-text{float:right;width:82%;margin:24px auto;font-size:14px;}");
            style.push(".atai-shade-clear{float:none;clear:both;width:100%;height:1px;line-height:1px;font-size:0;overflow:hidden;}");
            style.push("</style>");
            $(_this.document).find("head").append(style.join("\n"));
            ____AtaiShadeStyle = true;
        }
        var id = "atai-shade-background-" + new Date().getTime();
        var div = "<div id='" + id + "' v='atai-shade-background' style='position:absolute;left:0;top:0;display:block;background:#000'></div>";
        $(_this.document).find("body").css({ "background-attachment": "fixed" }).append(div);
        var o = $(_this.document.body).find("div[id='" + id + "']");
        _this.shadeIndex = _this.zIndex + _this.dialogCount;
        o.css({ "width": _this.initSize.w + "px"
			, "height": _this.initSize.h + "px"
			, "opacity": _this.dialogCount > 1 ? 0.1 : 0.3
			, "z-index": _this.shadeIndex
        });
        if (!_this.showShade)
            o.css({ "display": "none" });
        _this.shade = o;
        return o;
    };
    _this.dialogId = "atai-shade-dialog-" + new Date().getTime();
    _this.createDialog = function (type) {
        if (type == undefined) type = "message";
        var opType = [];
        opType["remove"] = "\u5220\u9664\u786e\u8ba4";
        opType["ask"] = "\u64cd\u4f5c\u786e\u8ba4";
        if (opType[type] == undefined) opType[type] = "\u64cd\u4f5c\u63d0\u793a";
        var tem = [];
        tem.push('<div id="' + _this.dialogId + '" class="atai-shade-dialog">');
        tem.push('<div class="atai-shade-head" v="atai-shade-move">');
        tem.push(opType[type]);
        tem.push('<div class="atai-shade-close" v="atai-shade-close">&nbsp;</div>');
        tem.push('</div>');
        tem.push('<div class="atai-shade-contents">');
        tem.push('<div class="atai-shade-icon-box"><div class="atai-shade-icon atai-shade-' + type + '"></div></div>');
        tem.push('<div class="atai-shade-text" v="atai-shade-dialog-text"></div>');
        tem.push('</div><div class="atai-shade-clear"></div>');
        tem.push('<div class="atai-shade-bottom" v="atai-shade-move">');
        tem.push('<input type="button" class="atai-shade-cancel" v="atai-shade-cancel" value="\u53d6\u6d88"/>');
        tem.push('<input type="button" class="atai-shade-confirm" v="atai-shade-confirm" value="\u786e\u5b9a"/>');
        tem.push('</div></div>');
        return tem.join("");
    };
    var isShow = false;
    _this.appendContainer = function (obj) {
        var o = $(obj).clone(true);
        var id = "atai-shade-" + new Date().getTime();
        o.css({ "display": "none" }).attr("id", id).attr("v", "atai-shade-container");
        $(_this.document.body).append(o);
        var container = $(_this.document).find("div[id='" + id + "']");
        container.addClass("atai-shade-container");
        var winWidth = Atai.screen.w;
        var winHeight = Atai.screen.h;
        var left = parseInt((winWidth - container.width()) / 2.0);
        var top = parseInt((winHeight - container.height()) / 2.0);
        container.css({ "position": "fixed"
					, "z-index": (_this.shadeIndex + 1), "left": left + "px", "top": top + "px"
        });
        if (Atai.isIE6) {
            left += $(_this.window).scrollLeft();
            top += $(_this.window).scrollTop();
            container.css({ "position": "absolute", "left": left + "px", "top": top + "px" });
            $(_this.window).scroll(function () {
                if (isShow) {
                    var l = parseInt((winWidth - container.width()) / 2.0) + $(_this.window).scrollLeft();
                    var t = parseInt((winHeight - container.height()) / 2.0) + $(_this.window).scrollTop();
                    container.css({ "left": l + "px", "top": t + "px" });
                }
            });
        }
        o.fadeIn(200, function () {
            o.find("select").each(function () {
                $(this).css({ "visibility": $(this).attr("atai-shade-visibility") });
            });
        });
        _this.dialog = container;
        return container;
    };
    _this.scrollPos = function () { return Atai.scroll(); };
    _this.mousedown = function (event) {
        var e = Atai.formatEvent(event);
        var s = _this.scrollPos();
        _this.initPos = { x: e.pageX - s.x, y: e.pageY - s.y };
        _this.document.onselectstart = new Function("return false");
        $(_this.document).bind("mousemove", _this.move);
    };
    _this.mouseup = function (event) {
        $(_this.document).unbind("mousemove", _this.move);
        var oset = $(_this.dialog).offset();
        _this.initPos = { x: oset.left, y: oset.top };
        _this.document.onselectstart = null;
    };
    _this.move = function (event) {
        var e = Atai.formatEvent(event);
        var s = _this.scrollPos();
        var _x = (_this.initPos.x + s.x) - e.pageX;
        var _y = (_this.initPos.y + s.y) - e.pageY;
        _this.initPos = { x: e.pageX - s.x, y: e.pageY - s.y };
        var oset = { left: $(_this.dialog)[0].offsetLeft, top: $(_this.dialog)[0].offsetTop };
        var left = parseInt(oset.left - _x);
        var top = parseInt(oset.top - _y);
        if (left < 0) {
            left = 0;
        } else if (left + $(_this.dialog).width() > _this.initSize.w) {
            left = _this.initSize.w - $(_this.dialog).width();
        }
        if (top < 0) {
            top = 0;
        } else {
            if (top + $(_this.dialog).height() > _this.initSize.h) {
                top = _this.initSize.h - $(_this.dialog).height();
            }
            var initH = _this.initSize.h;
            if (s.y <= 0)
                initH = _this.clientSize.h;
            if (!Atai.isIE6 && top + $(_this.dialog).height() + s.y > initH) {
                top = initH - s.y - $(_this.dialog).height();
            }
        }
        $(_this.dialog).css({ "top": top + "px", "left": left + "px" });
    };
    _this.setMove = function (onObj) {
        $(onObj).css({ "cursor": "move" });
        $(onObj).bind("mousedown", _this.mousedown);
        $(_this.document).bind("mouseup", _this.mouseup);
    };
    /*arg={
    obj: element
    ,message: text
    ,msgType: "succeed/correct|disallow|disallow2|alert/error|message|delete|ok|sorry/fail|ask"
    ,sure: function(){}
    ,closeAfterCallback: true|false
    ,closeWhenClickOnBackground: true|false
    };*/
    _this.init = function (arg) {
        _this.loaded = false;
        if (arg.obj == undefined || !arg.obj) {
            var o = $("#" + _this.dialogId);
            if (o[0] == undefined) {
                $(_this.document.body).append(_this.createDialog(arg.msgType));
                o = $("#" + _this.dialogId);
                _this.msgBox = o.find("*[v='atai-shade-dialog-text']");
                _this.msgBox.html(arg.message);
            }
            arg.obj = o;
        }
        if (arg.closeAfterCallback == undefined) arg.closeAfterCallback = true;
        if (arg.closeWhenClickOnBackground == undefined) arg.closeWhenClickOnBackground = arg.CWCOB;
        $(arg.obj).find("*[v='atai-shade-close']").bind('click', function () {
            if (!_this.loaded) return;
            _this.close();
        });
        $(arg.obj).find("*[v='atai-shade-confirm']").bind('click', function () {
            if (!_this.loaded) return;
            if (arg.sure != undefined && typeof (arg.sure) == "function")
                arg.sure();
            if (arg.closeAfterCallback)
                _this.close();
        });
        $(arg.obj).find("*[v='atai-shade-cancel']").bind('click', function () {
            if (!_this.loaded) return;
            if (arg.cancel != undefined && typeof (arg.cancel) == "function")
                arg.cancel();
            _this.close();
        }).css({ "display": (arg.showCancel != undefined && arg.showCancel != null && !arg.showCancel) ? "none" : "block" });
        _this.setMove($(arg.obj).find("*[v='atai-shade-move']"));
        _this.createShadeBackground();
        if (arg.closeWhenClickOnBackground != undefined && arg.closeWhenClickOnBackground) {
            $(document).click(function (e) {
                var c = true, t = e.target;
                while (t) {
                    if ($(t).hasClass("atai-shade-container") || $(t).attr("type") == "file") {
                        c = false; break;
                    }
                    t = t.offsetParent;
                }
                if (c && _this.loaded)
                    _this.close();
            });
        }
        _this.appendContainer(arg.obj);
        $(_this.obj).find("input[v='atai-shade-confirm']").each(function () {
            try { this.focus() } catch (e) { }
        });
        isShow = true;
        if (Atai.isIE6) {
            $(_this.document.body).find("select").each(function () {
                if (_this.dialogCount == 1) $(this).attr("atai-shade-visibility", $(this).css("visibility"));
                $(this).css({ "visibility": "hidden" });
            });
        }
        if (arg.formatData != undefined) arg.formatData();
        setTimeout(function () { _this.loaded = true; }, 200);
    };
    _this.close = _this.remove = function () {
        _this.dialog.fadeOut(200, function () { $(this).remove(); });
        $("#" + _this.dialogId).fadeOut(200, function () { $(this).remove(); });
        _this.shade.fadeOut(200, function () { $(this).remove(); });
        isShow = false; ____AtaiShadeDialogCount--;
        if (Atai.isIE6 && _this.loaded) {
            $(_this.document.body).find("select").each(function () {
                $(this).css({ "visibility": $(this).attr("atai-shade-visibility") });
            });
        }
        _this.loaded = false;
    };
};
var AtaiUtils=AtaiTools={
	loading: function(sL, sT){
		var div="<div v='atai-loading' style='position:absolute;width:52px;height:52px;z-index:999999;background:url("+_AtaiJsPath+"images/loading.gif) center center no-repeat;'></div>";
		$(document.body).append($(div));
		var size=Atai.screen;
		var l=($(window).scrollLeft() + (size.w-52)/2)  + "px";
		var t=($(window).scrollTop() + (size.h-52)/2)  + "px";
		if(sL!=undefined) l=Atai.isInt(sL)?(sL+"px"):sL;
		if(sT!=undefined) t=Atai.isInt(sT)?(sT+"px"):sT;
		$("div[v='atai-loading']").css({left: l, top: t});
	},
	unLoading: function(){
		$("div[v='atai-loading']").remove();
	},unloading: function(){
		$("div[v='atai-loading']").remove();
	},
	goto: function(obj, cLen){
		if(cLen==undefined || cLen==null || !cLen)
			cLen=0;
		var len=$(obj).offset().top + cLen;
		window.scrollTo(0, len);
	},
	setReturnUrl: function(url, returnurl){
		var myurl=returnurl ? returnurl : window.location.href.toLowerCase();
		if(!returnurl) returnurl=Atai.request("returnurl");
		var _p="?";
		if(url.indexOf("?")>0)
			_p="&";
		if(myurl.indexOf("returnurl=")>0)
			url += _p + "returnurl=" + returnurl;
		else
			url += _p + "returnurl=" + myurl;
		return url;
	},
	resetPage: function(param,val){
		var url=window.location.href.toLowerCase();
		if(param==undefined) param="";
		param=param.toLowerCase();
		var s=param + "=" + val;
		if(url.indexOf(param + "=")>0){
			var reg = new RegExp("(" + param + "=[^&]*)","i");
			url = url.replace(reg,s)
		}else{
			if(url.indexOf("?")<=0) url +="?" + s;
			else url +="&" + s;
		}
		window.location.href=url;
	},
	includeHost: function(url){
		if(!url || Atai.trim(url)=="") return false;
		url=Atai.trim(url.toLowerCase());
		if(url.substring(0, 7)=="http://" || url.substring(0, 8)=="https://" || url.substring(0, 6)=="ftp://")
			return true;
		return false;
	},
	subString: function(val, index, len){
		if(!len) len=val.length;
		var _len=0,_s=[];
		var _tem=val.split("");
		for(var kk=index;kk<_tem.length;kk++){
			if(Atai.isCn(_tem[kk])) _len += 2;
			else _len++;
			if(_len>len){
				_s.push("...");
				break;
			}
			_s.push(_tem[kk]);
		}
		return _s.join("");
	},
	alertBox: function(type, msg, sure, sureUrl, cancel, cancelUrl, showCancel, autoClose){
		new AtaiShadeDialog().init({obj: false
			, message: msg
			, msgType: type
			, sure: function(){
				if(sure!=undefined && sure!=null && typeof(sure)=="function")
					sure();
				if(sureUrl!=undefined && sureUrl) window.location.href=sureUrl;
			}
			, cancel: function(){
				if(cancel!=undefined && cancel!=null && typeof(cancel)=="function")
					cancel();
				if(cancelUrl!=undefined && cancelUrl) window.location.href=cancelUrl;
			}
			, showCancel: (showCancel==undefined || showCancel==null) ? false : showCancel
			, closeAfterCallback: (autoClose==undefined || autoClose==null) ? true : autoClose
			, closeWhenClickOnBackground: false
		});
	},
	box: {success: function(msg, url, sure){AtaiUtils.alertBox("succeed", msg, sure, url);}
		, correct: function(msg, url, sure){AtaiUtils.alertBox("correct", msg, sure, url);}
		, disallow: function(msg, url, sure){AtaiUtils.alertBox("disallow", msg, sure, url);}
		, disallow2: function(msg, url, sure){AtaiUtils.alertBox("disallow2", msg, sure, url);}
		, alert: function(msg, url, sure){AtaiUtils.alertBox("alert", msg, sure, url);}
		, error: function(msg, url, sure){AtaiUtils.alertBox("error", msg, sure, url);}
		, message: function(msg, url, sure){AtaiUtils.alertBox("message", msg, sure, url);}
		, remove: function(msg, sure, sureUrl, cancel, cancelUrl, autoClose){
			AtaiUtils.alertBox("remove", msg, sure, sureUrl, cancel, cancelUrl, true, autoClose);
		}
		, ok: function(msg, url, sure){AtaiUtils.alertBox("ok", msg, sure, url);}
		, fail: function(msg, url, sure){AtaiUtils.alertBox("fail", msg, sure, url);}
		, sorry: function(msg, url, sure){AtaiUtils.alertBox("sorry", msg, sure, url);}
		, ask: function(msg, sure, sureUrl, cancel, cancelUrl, autoClose){
			AtaiUtils.alertBox("ask", msg, sure, sureUrl, cancel, cancelUrl, true, autoClose);
		}
		, confirm: function(msg, sure, sureUrl, cancel, cancelUrl, autoClose){
			AtaiUtils.alertBox("ask", msg, sure, sureUrl, cancel, cancelUrl, true, autoClose);
		}
	},
	formatData: function(form, type){
		if(CKEDITOR!=undefined && CKEDITOR && CKEDITOR.instances){
			for(var ins in CKEDITOR.instances){CKEDITOR.instances[ins].updateElement();}
		}
		if(type == undefined || !type) type="json";
		var data=[];
		var names=[];
		$(form).find("input,select,textarea").each(function(){
			var o=$(this);
			var name=o.attr("name");
			var disabled=o.attr("disabled");
			if(name!=undefined && name!="" && !disabled && disabled!="disabled"){
				var s="";
				s += name + "=";
				var isUse=false;
				if(o.is("select")){
					var v=o.find("option:selected");
					if(v!=undefined) s += Atai.urlEncode(v.val());
					isUse=true;
				}else{
					var t=o.attr("type");
					if(t==undefined) t="text";
					t=t.toLowerCase();
					switch(t){
						case "radio":
							var v=o.attr("checked");
							if(v){
								s += Atai.urlEncode(o.val());isUse=true;
							}
							break;
						case "checkbox":
							if(!names.contains(name)){
								var chks=$(form).find("input[name='"+ name +"']");
								var x=0;
								chks.each(function(){
									if($(this).is(":checked")){
										if(x>0) s += ",";
										s += $(this).val();
										x++;
									}
								});
								isUse=true;
							}
							break;
						default:
							s += Atai.urlEncode(o.val());isUse=true;
							break;
					}
				}
				if(!names.contains(name))
					names.push(name);
				if(isUse) data.push(s);
			}
		});
		var returnValue="";
		if(type=="json"){
			var json={};
			for(var i=0;i<data.length;i++){
				var tem=data[i].split("=");
				json[tem[0]]=Atai.urlDecode(tem[1]);
			}
			returnValue=json;
		}else
			returnValue=data.join("&");
		return returnValue;
	}
};
var Utils=utils=AtaiUtils;
var JsBox=jsbox=jsBox=AtaiJsBox=ataiJsBox=AtaiUtils.box;
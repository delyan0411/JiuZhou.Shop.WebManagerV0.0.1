/*
Author : Atai Lu
Copyright Atai Lu
http://www.hiatai.com/
			2011-05-26
-----------------------------*/
String.prototype.trim = function(){return this.replace(/(^\s*)|(\s*$)/g, "");};
String.prototype.Trim = function(){return this.replace(/(^\s*)|(\s*$)/g, "");};
String.prototype.ltrim = function(){return this.replace(/^\s*/g, "");};
String.prototype.Ltrim = function(){return this.replace(/^\s*/g, "");};
String.prototype.rtrim = function(){return this.replace(/\s*$/g, "");};
String.prototype.Rtrim = function(){return this.replace(/\s*$/g, "");};
Number.prototype.toString = function(v){
	if(!v) return this + "";
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
window.ST=function(){
	var _t = this;
	_t.userAgent = navigator.userAgent;
	_t.appVersion = parseFloat(navigator.appVersion);
	//Compare Versions
	_t.compareVersions = function(sVersion1,sVersion2){
		var aVersion1 = sVersion1.split(".");
		var aVersion2 = sVersion2.split(".");

		if(aVersion1.length>aVersion2.length){
			for(var i=0;i<aVersion1.length;i++)
				aVersion2.push("0");
		}else if(aVersion1.length<aVersion2.length){
			for(var i=0;i<aVersion2.length;i++)
				aVersion1.push("0");
		}

		for(var i=0;i<aVersion1.length;i++){
			if(aVersion1[i]<aVersion2[i])
				return -1;
			else if(aVersion1[i]>aVersion2[i])
				return 1;
		}
		return 0;
	};
	_t.isOpera = _t.userAgent.indexOf("Opera")>-1;
	_t.isMinOpera4 = _t.isMinOpera5 = _t.isMinOpera6 = _t.isMinOpera7 = _t.isMinOpera7_5 = false;
	if(_t.isOpera){
		var fv;
		if(navigator.appName == "Opera"){
			fv = _t.appVersion;
		}else{
			var reOperaVersion = new RegExp("Opera (\\d+\\.\\d+)");reOperaVersion.test(_t.userAgent);
			fv = parseFloat(RegExp["$1"]);
		}
		_t.isMinOpera4 = fv >= 4;
		_t.isMinOpera5 = fv >= 5;
		_t.isMinOpera6 = fv >= 6;
		_t.isMinOpera7 = fv >= 7;
		_t.isMinOpera7_5 = fv >= 7.5;
	}
	_t.isKHTML = _t.userAgent.indexOf("KHTML")>-1
					|| _t.userAgent.indexOf("Konqueror")>-1
					|| _t.userAgent.indexOf("AppleWebKit")>-1;
	_t.isSafari = _t.isKonq = false;
	_t.isMinSafari1 = _t.isMinSafari1_2 = false;
	_t.isMinKonq2_2 = _t.isMinKonq3 = _t.isMinKonq3_1 = _t.isMinKonq3_2 = false;
	if(_t.isKHTML){
		_t.isSafari = _t.userAgent.indexOf("AppleWebKit")>-1;
		_t.isKonq = _t.userAgent.indexOf("Konqueror")>-1;
		if(_t.isSafari){
			var reAppleWebKit = new RegExp("AppleWebKit\\/(\\d+(?:\\.\\d*)?)");
			reAppleWebKit.test(_t.userAgent);
			var fAppleWebKitVersion = parseFloat(RegExp["$1"]);
			_t.isMinSafari1 = fAppleWebKitVersion >= 85;
			_t.isMinSafari1_2 = fAppleWebKitVersion >= 124;
		}else if(_t.isKonq){
			var reKonq = new RegExp("Konqueror\\/(\\d+(?:\\.\\d+(?:\\.\\d)?)?)");
			reKonq.test(_t.userAgent);
			_t.isMinKonq2_2 = _t.compareVersions(RegExp["$1"],"2.2") >= 0;
			_t.isMinKonq3 = _t.compareVersions(RegExp["$1"],"3.0") >= 0;
			_t.isMinKonq3_1 = _t.compareVersions(RegExp["$1"],"3.1") >= 0;
			_t.isMinKonq3_2 = _t.compareVersions(RegExp["$1"],"3.2") >= 0;
		}
	}
	_t.isIE = _t.userAgent.indexOf("compatible") > -1
					&& _t.userAgent.indexOf("MSIE") > -1 && !_t.isOpera;
	_t.isMinIE4 = _t.isMinIE5 = _t.isMinIE5_5 = _t.isMinIE6 = _t.isMinIE7 = _t.isMinIE8 = _t.isMinIE9 = _t.isMinIE10 = false;
	if(_t.isIE){
		var reIE = new RegExp("MSIE (\\d+\\.\\d+);");
		reIE.test(_t.userAgent);
		var fIEVersion = parseFloat(RegExp["$1"]);
		_t.isMinIE4 = fIEVersion >=4;
		_t.isMinIE5 =  fIEVersion >=5;
		_t.isMinIE5_5 = fIEVersion >=5.5;
		_t.isMinIE6 = (fIEVersion >=6 && fIEVersion<7);
		_t.isMinIE7 = fIEVersion >=7;
		_t.isMinIE8 = fIEVersion >=8;
		_t.isMinIE9 = fIEVersion >=9;
		_t.isMinIE10 = fIEVersion >=10;
	}
	_t.isFF = _t.userAgent.indexOf("Firefox")>-1&&!_t.isKHTML;
	_t.isMinFF1 = _t.isMinFF2 =_t.isMinFF3 =_t.isMinFF4 =_t.isMinFF5 =_t.isMinFF6 = false;
	if(_t.isFF){
		var reFF = new RegExp("Firefox\\/(\\d+\\.\\d+(?:\\.\\d+\\.\\d+)?)");
		reFF.test(_t.userAgent);
		_t.isMinFF1 = _t.compareVersions(RegExp["$1"],"1.0") >=0;
		_t.isMinFF2 = _t.compareVersions(RegExp["$1"],"2.0") >=0;
		_t.isMinFF3 = _t.compareVersions(RegExp["$1"],"3.0") >=0;
		_t.isMinFF4 = _t.compareVersions(RegExp["$1"],"4.0") >=0;
		_t.isMinFF5 = _t.compareVersions(RegExp["$1"],"5.0") >=0;
		_t.isMinFF6 = _t.compareVersions(RegExp["$1"],"6.0") >=0;
	}
	_t.isMoz = _t.userAgent.indexOf("Gecko")>-1&&!_t.isKHTML;
	_t.isMinMoz1 = _t.isMinMoz1_4 = _t.isMinMoz1_5 = _t.isMinMoz1_8 = false;
	if(_t.isMoz){
		var reMoz = new RegExp("rv:(\\d+\\.\\d+(?:\\.\\d+)?)");
		reMoz.test(_t.userAgent);
		_t.isMinMoz1 = _t.compareVersions(RegExp["$1"],"1.0") >=0;
		_t.isMinMoz1_4 = _t.compareVersions(RegExp["$1"],"1.4") >=0;
		_t.isMinMoz1_5 = _t.compareVersions(RegExp["$1"],"1.5") >=0;
		_t.isMinMoz1_8 = _t.compareVersions(RegExp["$1"],"1.8") >=0;
	}
	_t.isNS4 = !_t.isIE&&!_t.isOpera&&!_t.isMoz&&!_t.isKHTML
				&&(_t.userAgent.indexOf("Mozilla")==0)
				&&(navigator.appName == "Netscape")
				&&(_t.appVersion >= 4.0 && _t.appVersion <5.0);
	_t.isMinNS4 = _t.isMinNS4_5 = _t.isMinNS4_7 = _t.isMinNS4_8 = false;
	if(_t.isNS4){
		_t.isMinNS4 = true;
		_t.isMinNS4_5 = _t.appVersion >= 4.5;
		_t.isMinNS4_7 = _t.appVersion >= 4.7;
		_t.isMinNS4_8 = _t.appVersion >= 4.8;
	}
	_t.isWin = (navigator.platform == "Win32") || (navigator.platform == "Windows");
	_t.isMac = (navigator.platform == "Mac68K") || (navigator.platform == "MacPPC")
				|| (navigator.platform == "Macintosh");

	_t.isUnix = (navigator.platform == "X11" && !_t.isWin && !_t.isMac);
	_t.isWin95 = _t.isWin98 = _t.isWinNT4 = _t.isWin2K = _t.isWinME = _t.isWinXP = _t.isWin2K3 = _t.isVista = false;
	_t.isMac68K = _t.isMacPPC = false;
	_t.isSunOS = _t.isMinSunOS4 = _t.isMinSunOS5 = _t.isMinSunOS5_5 = false;
	if(_t.isWin){
		_t.isWin95 = _t.userAgent.indexOf("Win95") > -1 || _t.userAgent.indexOf("Windows 95") >-1;
		_t.isWin98 = _t.userAgent.indexOf("Win98") > -1 || _t.userAgent.indexOf("Windows 98") >-1;
		_t.isWinME = _t.userAgent.indexOf("Win 9x 4.90") > -1 || _t.userAgent.indexOf("Windows ME") >-1;
		_t.isWin2K = _t.userAgent.indexOf("Windows NT 5.0") > -1 || _t.userAgent.indexOf("Windows 2000") >-1;
		_t.isWinXP = _t.userAgent.indexOf("Windows NT 5.1") > -1 || _t.userAgent.indexOf("Windows XP") >-1;
		_t.isWin2K3 = _t.userAgent.indexOf("Windows NT 5.2") > -1 || _t.userAgent.indexOf("Windows 2003") >-1;
		_t.isVista = _t.userAgent.indexOf("Windows NT 6.0") > -1 || _t.userAgent.indexOf("Windows Vista") >-1;
		if(!_t.isWin2K3&&!_t.isVista){
			_t.isWinNT4 = _t.userAgent.indexOf("WinNT") > -1
						|| _t.userAgent.indexOf("Windows NT") >-1
						|| _t.userAgent.indexOf("WinNT4.0") >-1
						|| (_t.userAgent.indexOf("Windows NT 4.0") >-1)
						&& (!_t.isWinME&&!_t.isWin2K&&!_t.isWinXP);
		}
	}
	if(_t.isMac){
		_t.isMac68K = _t.userAgent.indexOf("Mac_68000") > -1 || _t.userAgent.indexOf("68K") > -1;
		_t.isMacPPC = _t.userAgent.indexOf("MacPowerPC") > -1 || _t.userAgent.indexOf("PPC") > -1;
	}
	if(_t.isUnix){
		_t.isSunOS = _t.userAgent.indexOf("SunOS") > -1;
		if(_t.isSunOS){
			var reSunOS = new RegExp("SunOS (\\d+\\.\\d+(?:\\.\\d+)?)");
			reSunOS.test(_t.userAgent);
			_t.isMinSunOS4 = _t.compareVersions(RegExp["$1"],"4.0") >= 0;
			_t.isMinSunOS5 = _t.compareVersions(RegExp["$1"],"5.0") >= 0;
			_t.isMinSunOS5_5 = _t.compareVersions(RegExp["$1"],"5.5") >= 0;
		}
	}
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
	for(var i=0;i<arr.length;i++){
		this.push(arr[i]);
	}
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
		if(ignoreCase && typeof(val)=="string"){
			if(val.toLowerCase()==this[i].toLowerCase()) index=i;
		}else{
			if(val==this[i]) index=i;
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
var Atai=atai=window.Atai=window.atai=AtaiJs=window.AtaiJs=__$_$__={
	version : "1.1.0.0",//the class version
	lastModify : "2012-06-17",//This class was last changed time
	ST : new window.ST(),//Setting
	getTopWindow: getTopWindow,
	screen: {w : Math.min(getTopWindow().document.documentElement.clientWidth, getTopWindow().screen.availWidth)
				, h : Math.min(getTopWindow().document.documentElement.clientHeight, getTopWindow().screen.availHeight)},
	isIE6: $.browser.msie && (parseFloat($.browser.version) <= 6.0),
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
			//http.setRequestHeader("content-type",arg.contentType);
			http.send(null);
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
	isCn : function(val){
		var reg=/^[\u4e00-\u9fa5]+$/;
		return reg.test(val);
	},
	isInt : function(val){
		var reg=/^-?\d{1,30}$/;
		return reg.test(val);
	},
	isNumber : function(val){
		var reg=/^-?\d{1,30}(\.\d{1,30})?$/;
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
	css : {
		_setOpacity : function(elem,level){
			if(document.all){elem.style.filter = 'alpha(opacity=' + level * 100 + ')';}else{elem.style.opacity = level;}
		},
		setStyle : function(elem,prop){
			for(var i in prop){
				i=i.toLowerCase();
				if(i=="float"){
					if(document.all) i="style-float";
					else i="css-float";
				}
				if(i == 'opacity'){__$_$__.css._setOpacity(elem,prop[i]);}
				else{
					if(i.indexOf("-")>=0){
						var arr=i.split("");var t="";
						for(var k=0;k<arr.length;k++){
							if(k==0){t=arr[k];}else if(k>0 && arr[k]=="-"){
								if(k+1<arr.length){t += arr[k+1].toUpperCase();k++;}
							}else{t += arr[k];}
						}
						eval("elem.style." + t + "=prop[i]");
					}else{elem.style[i] = prop[i];}
				}
			}
			return elem;
		},
		getSheets : function(){
			return document.styleSheets;
		},
		cssRules : function(sheet){
			if(document.all){
				return sheet.rules;
			}else{
				var sh = sheet.cssRules;
				var arr=[];
				for(var i=0;i<sh.length;i++){
					if(sh[i].style!=undefined) arr.push(sh[i]);
				}
				return arr;
			}
		},
		cssText : function(rule){
			return rule.style.cssText;
		},
		cssName : function(rule){
			return rule.selectorText;
		},
		getText : function(rule){
			return (rule.selectorText + "{" + rule.style.cssText + "}").toLowerCase();
		}
	},
	close : function(){
		CollectGarbage();
	}
};
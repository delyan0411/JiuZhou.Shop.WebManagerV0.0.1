/*
Author : Atai Lu
Copyright Atai Lu.
			2009-1-15
-----------------------------*/
var iframeDialog=function(){
	var _this = this;
	_this.dialogCount=1;
	_this.iframe=_this.div=_this.dialog=false;
	_this.iframeId="___iframeDialog";
	_this.zIndex=999999;
	_this.window=Atai.getTopWindow();
	_this.doc=_this.window.document;
	_this.initSize={w : _this.doc.body.offsetWidth, h : _this.doc.body.offsetHeight};
	_this.clientSize=Atai.screen;
	_this.initPos={x : 0, y : 0};
	_this.scrollPos=function(){return Atai.scroll();};

	_this.createDivElement=function(){
		var div = _this.doc.createElement("div");
		_this.doc.body.appendChild(div);
		$(div).css({
					  "width" : _this.initSize.w + "px"
					, "height" : _this.initSize.h + "px"
					, "position" : "absolute"
					, "border" : 0
					, "display" : "block"
					, "opacity" : 0.5
					, "z-index" : _this.zIndex + 1 * _this.dialogCount
					, "background" : "#555"
					, "top" : "0"
					, "left" : "0"
				  }
			);
		_this.div=div;
		return div;
	};
	_this.lastScrollPos=_this.scrollPos();
	_this.setPosition=function(){
		if(_this.dialog){
			var s=_this.scrollPos();
			var ls=_this.lastScrollPos;
			s.x -= ls.x; s.y -= ls.y;
			_this.lastScrollPos=_this.scrollPos();

			//var top = _this.initPos.y + s.y;
			var top = _this.dialog.offsetTop + s.y;
			//var top=_this.scrollPos().y + (_this.clientSize.h - _this.dialog.offsetHeight)/2;
			if(top + _this.dialog.offsetHeight>_this.initSize.h){
				top = _this.initSize.h - _this.dialog.offsetHeight;
			}
			if(_this.dialog.offsetTop<0) top=0;
			//var left = _this.initPos.x + s.x;
			var left = _this.dialog.offsetLeft + s.x;
			if(left + _this.dialog.offsetWidth>_this.initSize.w){
				left = _this.initSize.w - _this.dialog.offsetWidth;
			}
			if(_this.dialog.offsetLeft<0) left=0;
			_this.dialog.style.top = top + "px";
			_this.dialog.style.left = left + "px";
			//_this.initPos={x : left, y : top};
		}
	};

	_this.mousedown=function(e){
		var e = Atai.getEvent(e);
		var s=_this.scrollPos();
		_this.initPos={x : e.pageX-s.x, y : e.pageY-s.y};
		_this.doc.onselectstart = new Function("return false");
		Atai.addEvent(_this.doc,"mousemove",_this.move);
	};
	_this.mouseup=function(e){
		Atai.delEvent(_this.doc,"mousemove",_this.move);
		_this.initPos={x : _this.dialog.offsetLeft, y : _this.dialog.offsetTop};
		_this.doc.onselectstart = null;
	};
	_this.move=function(e){
		var e = Atai.getEvent(e);
		var s=_this.scrollPos();
		var _x = (_this.initPos.x+s.x) - e.pageX;
		var _y = (_this.initPos.y+s.y) - e.pageY;
		_this.initPos={x : e.pageX-s.x, y : e.pageY-s.y};
		//var _y = _this.initPos.y - e.pageY;
		var left = parseInt(_this.dialog.offsetLeft-_x);
		var top = parseInt(_this.dialog.offsetTop-_y);

		if(left<0){
			left=0;
		}else if(left + _this.dialog.offsetWidth>_this.initSize.w){
			left = _this.initSize.w - _this.dialog.offsetWidth;
		}
		if(top<0){
			top = 0;
		}else{
			if(top + _this.dialog.offsetHeight>_this.initSize.h){
				top = _this.initSize.h - _this.dialog.offsetHeight;
			}
			var initH=_this.initSize.h;
			if(s.y<=0){
				initH=_this.clientSize.h;
			}
			if(!document.all && top + _this.dialog.offsetHeight + s.y>initH){
				top = initH - s.y - _this.dialog.offsetHeight;
			}
		}
		_this.dialog.style.left =  left + "px";
		_this.dialog.style.top = top + "px";
	};
	_this.dialogObj=false;
	_this.disBackground=false;
	_this.copyDialog=function(dialogObj){
		_this.doc.body.backgroundAttachment="fixed";
		_this.dialogObj=dialogObj;
		if(!_this.disBackground) _this.createDivElement();
		_this.dialog=dialogObj.copy;//.cloneNode(true);
		_this.setMove(dialogObj.move);
		_this.setClose(dialogObj.close);
		//_this.doc.body.removeChild(obj);
		//_this.doc.body.appendChild(_this.dialog);
		$(_this.dialog).css({"display" : "block"});

		var _x=_y=0
		if($.browser.msie && (parseFloat($.browser.version) <= 6.0)){
			_x=_this.scrollPos().x + (_this.clientSize.w - _this.dialog.offsetWidth)/2;
			_y=_this.scrollPos().y + (_this.clientSize.h - _this.dialog.offsetHeight)/2;
		}else{
			_x=(_this.clientSize.w - _this.dialog.offsetWidth)/2;
			_y=(_this.clientSize.h - _this.dialog.offsetHeight)/2;
		}
		_this.initPos={x : _x, y : _y};
		$(_this.dialog).css({
					  "z-index" : _this.zIndex + 2 * _this.dialogCount
					, "position" : "fixed"
					, "margin" : "0"
					, "background" : "#fff"//delete
					, "top" : _this.initPos.y + "px"
					, "left" : _this.initPos.x + "px"
				  }
		);
		_this.dialog.style.zIndex = _this.zIndex + 2 * _this.dialogCount;
		if($.browser.msie && (parseFloat($.browser.version) <= 6.0)){
			_this.setCss(_this.dialog,{"position" : "absolute"});
			var style=_this.doc.createStyleSheet();
			style.addRule("*html", "background-image:url(about:blank);background-attachment:fixed");
			window.onscroll=_this.setPosition;
		}
	};
	_this.removeDialog=function(){
		_this.doc.body.removeChild(_this.dialog);
	};

	_this.setMove=function(onObj){
		onObj.style.cursor="move";
		Atai.addEvent(onObj,"mousedown",_this.mousedown);
		Atai.addEvent(_this.doc,"mouseup",_this.mouseup);
	};
	_this.setClose=function(onObj){
		onObj.onclick=_this.remove;
	};
	//_this.show=_this.createDialog;
	_this.remove=function(){
		if(_this.iframe) _this.doc.body.removeChild(_this.iframe);
		if(_this.div) _this.doc.body.removeChild(_this.div);
		if(_this.dialog) _this.dialog.style.display="none";
		Atai.delEvent(_this.dialogObj.move,"mousedown",_this.mousedown);
		Atai.delEvent(_this.doc,"mouseup",_this.mouseup);
	};
	_this.close=_this.remove;
};
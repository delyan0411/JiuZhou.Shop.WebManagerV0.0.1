/*
Class Name : Drop-list box
Author : Atai Lu
Copyright Atai Lu
http://www.hiatai.com/
			2011-10-26
-----------------------------*/
/*
var arg={
	input : inputElement
	,options : [{text : "Text", value : "Value"},{text : "Text", value : "Value"},...]
};
*/
var _DropListUI_Count=0;
var _DropListUI=function(arg){
	_DropListUI_Count++;
	var _this=this;
	if(!arg.input){
		alert("Error,Can not find the input element.");return;
	}
	_this.zIndex=99;
	_this.id="DropListUI-ID-" + _DropListUI_Count;
	
	_this.input=arg.input;
	_this.isFixed=arg.isFixed?true:false;
	_this.initOption=false;
	_this.defValue=false;
	_this.disabled=false;
/*	_this.copyInput=_this.input.cloneNode(true);
	_this.copyInput.id=_this.id + "-CopyInput";*/

	_this.className = "ui-select";
	//_this.textClassName = "ui-select-text";
	_this.width=parseInt(arg.input.offsetWidth) + "px";
	//_this.lineHeight="22px";
	_this.maxHeight="auto";
	_this.options=false;//arg.options ? arg.options : new Array();
	//_this.isChange=arg.isChange?arg.isChange:false;
	_this.onChange=new Function();
	//_this.eventListener=new Function();
	_this.changeCallback=function(){
		if(_this.input.fireEvent){_this.input.fireEvent("onchange");}
		else{if(_this.input.onchange) _this.input.onchange();}
		_this.onChange();//_this.eventListener();
	};
	//set options
	_this.container=false;
	_this.parentDocument=document.body;
	_this.createContainer=function(){
		var __top=parseInt(Atai.getTop(_this.showContainer)+_this.showContainer.offsetHeight-1);
		if(!_this.container){
			var div=document.createElement("div");
			div.className="ui-select-container";
			div.style.zIndex = _this.zIndex;
			div.style.position=(!Atai.ST.isMinIE6 && _this.isFixed)?"fixed":"absolute";
			div.style.float="none";
			div.style.clear="both";
			div.style.margin="0";
			div.style.padding="0";
			div.style.height=_this.maxHeight;
			div.style.display="none";
			div.style.width=(_this.showContainer.offsetWidth-2) + "px";
			div.style.left=Atai.getLeft(_this.showContainer) + "px";
			div.style.top=__top + "px";
			_this.parentDocument.appendChild(div);
			_this.container=div;
		}
	};
	_this.isShow=false;
	_this.display=function(type){
		if(type=="show"){
			var __top=parseInt(Atai.getTop(_this.showContainer)+_this.showContainer.offsetHeight-1) + ((Atai.ST.isMinIE6&&_this.isFixed)?Atai.scroll().y:0);
			_this.container.style.left=Atai.getLeft(_this.showContainer) + "px";
			_this.container.style.top=__top + "px";
			_this.container.style.display="block";
			_this.isShow=true;
		}else{
			_this.container.style.display="none";
			_this.isShow=false;
		}
	};
	_this.select=_this.initOption;
	_this.loadOptions=function(resetOptions){
		if(!resetOptions) resetOptions=false;
		if(!_this.container) _this.createContainer();
		if(resetOptions){
			_this.container.innerHTML="";
			if(_this.input.tagName.toLowerCase()=="select"){
				_this.input.length="";
			}
		}
		var __lineHeight=0;
		for(var i=0;i<_this.options.length;i++){
			var node=document.createElement("div");
			node.setAttribute("db-value", _this.options[i].value);
			var __text=document.createTextNode(_this.options[i].text);
			node.appendChild(__text);
			if(i==0){
				node.className="ui-options ui-options-selected";
				node.style.textAlign="center";
			}else{
				node.className="ui-options";
				node.onmouseover=function(){
					this.className="ui-options ui-options-selected";
				};
				node.onmouseout=function(){
					this.className="ui-options";
				};
			}
			if(_this.input.tagName.toLowerCase()=="select"){
				var option=new Option(_this.options[i].text, _this.options[i].value);
				if(_this.defValue.toString().toLowerCase()==_this.options[i].value.toLowerCase()){
					_this.showContainer.value=_this.options[i].text;
					_this.select={text:_this.options[i].text,value: _this.options[i].value};
					option.selected = true;
				}else{
					option.selected = false;
				}
				option.title=_this.options[i].text;
				_this.input.options.add(option);
/*				var option=document.createElement("option");
				option.value=_this.options[i].value;
				if(_this.defValue==_this.options[i].value){
					option.selected = true;
					_this.showContainer.value=_this.options[i].text;
					_this.select={text:_this.options[i].text, value: _this.options[i].value};
					//if(_this.isChange){_this.changeCallback();_this.isChange=false;}
				}
				else option.selected = false;
				option.innerHTML=_this.options[i].text;
				_this.input.appendChild(option);*/
			}else{
				_this.input.value=_this.defValue;
			}
			_this.container.appendChild(node);
			node.onclick=function(){
				_this.showContainer.value=this.innerHTML;
				if(_this.input.tagName.toLowerCase()=="input"){
					_this.input.value=this.getAttribute("db-value");
				}else if(_this.input.tagName.toLowerCase()=="select"){
					for(var k=0;k<_this.input.options.length;k++){
						if(_this.input.options[k].value==this.getAttribute("db-value")){
							_this.input.options[k].selected=true;
							break;
						}
					}
				}
				_this.select={text:this.innerHTML,value: this.getAttribute("db-value")};
				_this.display("close");
				_this.changeCallback();
			};
		}
		if(_this.maxHeight!="auto" && _this.showContainer.offsetHeight*_this.options.length<parseInt(_this.maxHeight.replace("px")))
			_this.container.style.height="auto";
		else
			_this.container.style.height=_this.maxHeight;
	};
	_this.setDefault=function(val,change){
		if(change==undefined) change=true;
		for(var i=0;i<_this.options.length;i++){
			if(_this.options[i].value==val){
				_this.showContainer.value=_this.options[i].text;
				_this.select={text:_this.options[i].text,value: _this.options[i].value};
				if(_this.input.tagName.toLowerCase()=="select") _this.input.options[i].selected=true;
				if(change)_this.changeCallback();
				break;
			}
		};
	};
	_this.resetOptions=function(arg){
		if(!arg) arg={isChange:false,copy:false};
		if(arg.copy && _this.input.tagName.toLowerCase()=="select") _this.getOptionsFromSelectElement();
		_this.loadOptions(true);
		if(arg.isChange){
			_this.changeCallback();//_this.isChange=false;
		}
	};
	_this.getOptionsFromSelectElement=function(){
		if(_this.input.tagName.toLowerCase()=="select"){
			_this.options=[];
			for(var k=0;k<_this.input.options.length;k++){
				if(_this.input.options[k].getAttribute("init")
						&& _this.input.options[k].getAttribute("init").toString().toLowerCase()!="false"
				){
					_this.initOption={text:_this.input.options[k].innerHTML,value:_this.input.options[k].value,init:true};
					continue;
				}
				if(_this.input.options[k].selected){
					_this.defValue=_this.input.options[k].value;
				}
				_this.options.push({text:_this.input.options[k].innerHTML,value:_this.input.options[k].value});
			}
		}
	};
	_this.setInitOption=function(){
		if(!_this.initOption){
			for(var k=0;k<_this.input.options.length;k++){
				if(_this.input.options[k].getAttribute("init")
						&& _this.input.options[k].getAttribute("init").toString().toLowerCase()!="false"
				){
					_this.initOption={text:_this.input.options[k].innerHTML,value:_this.input.options[k].value,init:true};
					break;
				}
			}
			if(!_this.initOption){
				_this.initOption={text:"",value:"",init:true};
			}
		}
	};
	_this.showContainer=false;
	//init
	_this.init=function(){
		if(!_this.options){
			_this.options=arg.options;
		}
		if((!_this.options||_this.options.length<1) && _this.input.tagName.toLowerCase()=="select"){
			_this.getOptionsFromSelectElement();
		}
		var _tem=[];
		_this.setInitOption();//_this.initOption={text:"",value:"",init:true};
		_tem.push(_this.initOption);
		for(var i=0;i<_this.options.length;i++){
			_tem.push(_this.options[i]);
		}
		_this.options=_tem;_tem=null;
		//if(!_this.defValue) _this.setDefault(_this.defValue);
		//else _this.defValue="";
		var ninput=document.createElement("input");
		ninput.readOnly=true;
		ninput.className = _this.className;
		ninput.style.cursor="pointer";
		ninput.style.margin="0";
		ninput.style.padding="0 2px";
		//span.style.display="inline-block";
		ninput.style.width=_this.width;
		ninput.style.overflow="hidden";
		ninput.value=_this.initOption.text;
		_this.input.parentNode.insertBefore(ninput,_this.input);
		if(_this.disabled) ninput.disabled=true;

		_this.showContainer=ninput;
		_this.input.style.position="absolute";
		_this.input.style.visibility="hidden";
		_this.input.style.width="1px";
		_this.loadOptions(true);
		Atai.addEvent(_this.showContainer,"click",function(){
			if(_this.isShow){_this.display("close");}
			else if(!_this.disabled){_this.display("show");}
		});
		Atai.addEvent(document,"click",function(event){
			event=Atai.getEvent(event);
			if(event.target!=_this.container && event.target!=_this.showContainer) _this.display("close");
		});
	};
};
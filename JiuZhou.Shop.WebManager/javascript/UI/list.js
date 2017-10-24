/*
Author : Atai Lu
Copyright Atai Inc.
			2009-1-15
-----------------------------*/
var _list_utils=function(){
	var _this = this;
	_this.isopen=false;
	_this.opentree=2;
	var _isHasULNode=function(obj){
		var nodes = obj.getElementsByTagName("UL");
		if(nodes.length>0) return true;
		return false;
	};
	var changeStates=function(obj,divObj){
		if(obj.style.display=="block"){
			divObj.className="folder_close";
			obj.style.display="none";
		}else{
			divObj.className="folder_open";
			obj.style.display="block";
		}
	};
	//设置div的class
	var _initDiv=function(obj){
		var divNodes=obj.getElementsByTagName("DIV");
		for(var i=0;i<divNodes.length;i++){
			if(divNodes[i].parentNode==obj){
				var tree=divNodes[i].getAttribute("tree");
				if(!tree) tree=0;
				if(_this.isopen && parseInt(tree)<_this.opentree){
					divNodes[i].className="folder_open";
				}else{
					divNodes[i].className="folder_close";
				}
				var ulNode=obj.getElementsByTagName("UL")[0];
				if(ulNode!=undefined){
					if(_this.isopen && parseInt(tree)<_this.opentree){
						ulNode.style.display="block";
					}else{
						ulNode.style.display="none";
					}
					var aNodes = divNodes[i].getElementsByTagName("A");
					if(aNodes!=undefined){
						for(var i=0;i<aNodes.length;i++){
							var aNode=aNodes[i];
							if(aNode.getAttribute("v")=="bt"){
								aNode.href="javascript:;";
								aNode.onclick=function(){
									changeStates(ulNode,this.parentNode);
								};
							}
						}
					}else{
						divNodes[i].onclick=function(){
							changeStates(ulNode,this);
						};
					}
				}
			}
		}
	};
	var _init=function(obj){
		var list=obj.getElementsByTagName("LI");
		for(var i=0;i<list.length;i++){
			if(list[i].parentNode==obj){
				if(_isHasULNode(list[i])){
					if(!$(list[i]).hasClass("xline"))
						$(list[i]).addClass("xline");
					_initDiv(list[i]);
				}else{
					//没有子类的情况
					var _div_node = list[i].getElementsByTagName("DIV")[0];
					if(_div_node!=undefined){
						if(i+1<list.length){
							_div_node.className="list_file";
						}else{
							_div_node.className="end_file";
						}
					}
				}
			}else{//如果父标签不是obj
				_init(list[i].parentNode);
			}
		}
	};
	_this.init=function(obj){
		_init(obj);
	}
};
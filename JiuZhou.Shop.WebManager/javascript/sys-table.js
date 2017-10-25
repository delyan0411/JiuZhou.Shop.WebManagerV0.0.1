var AtaiTable=function(table){
	this._table=table;
	this.firstRowIndex=1;//thead rows
	this.getRowByChild=function(childObj){
		var tr=false;
		while(!tr){
			if(childObj.tagName && childObj.tagName.toLowerCase()=="tr"){
				tr=childObj;
			}else{
				childObj=childObj.parentNode;
			}
		}
		var rowIndex=-1;
		for(var i=0;i<table.rows.length;i++){
			if(table.rows[i]==tr){
				rowIndex=i;break;
			}
		}
		return {obj : tr, index : rowIndex};
	};
	this.getRowIndex=function(row){
		var rowIndex=-1;
		for(var i=0;i<table.rows.length;i++){
			if(table.rows[i]==row){
				rowIndex=i;break;
			}
		}
		return rowIndex;
	};
	/*
		rowType=parent | child | child-add
		,beforRowIndex: -1
		,cells : [
			 {className: "", html: ""}
			,{className: "", html: ""}
		]
	*/
	this.addRow=function(rowType,clickRow,cells){
		var clickIndex=clickRow?this.getRowIndex(clickRow)-this.firstRowIndex:-1;
		var pNode=clickRow?clickRow.parentNode:table.getElementsByTagName("tbody")[0];
		var row=pNode.insertRow(clickIndex);
		if(!rowType || rowType=="") rowType="parent";
		rowType=rowType.toLowerCase();
		row.setAttribute("rowType", rowType);
		for(var i=0;i<cells.length;i++){
			var c=row.insertCell(-1);
			c.className=cells[i].className;
			c.innerHTML=cells[i].html;
		}
		return row;
	};
	this.removeRow=function(row){
		var pNode=row.parentNode;
		if(row.getAttribute("rowType")=="child"){
			pNode.removeChild(row);
		}else if(row.getAttribute("rowType")=="parent"){
			var deleteBegin=false;
			for(var i=0;i<table.rows.length;i++){
				if(table.rows[i]==row){
					deleteBegin=true;
				}else if(deleteBegin && table.rows[i].getAttribute("rowType")=="parent"){
					deleteBegin=false;
					break;
				}
				if(deleteBegin){
					pNode.removeChild(table.rows[i]);
					i--;
				}
			}
		}
	};
	this.getMoveRows=function(clickRow){
		var returnArr=[];
		var clickIndex=this.getRowIndex(clickRow);
		returnArr.push(clickRow);
		if(clickRow.getAttribute("rowType")=="child"){
			return returnArr;
		}
		for(var i=clickIndex+1;i<table.rows.length;i++){
			if(table.rows[i].getAttribute("rowType")=="parent")
				break;
			returnArr.push(table.rows[i]);
		}
		return returnArr;
	};
	this.appendBefore=function(pNode,rows,currRow){
		for(var i=0;i<rows.length;i++){
			pNode.insertBefore(rows[i].cloneNode(true),currRow);
		}
	}
	this.appendAfter=function(pNode,rows,currRow){
		for(var i=0;i<rows.length;i++){
			if(currRow.nextSibling)
				pNode.insertBefore(rows[i].cloneNode(true),currRow.nextSibling);
			else
				pNode.appendChild(rows[i].cloneNode(true));
		}
	}
	this.appendChild=function(pNode,rows){
		for(var i=0;i<rows.length;i++){
			pNode.appendChild(rows[i].cloneNode(true));
		}
	}
	//moveType=first | up | down | last
	this.moveRow=function(clickRow,moveType){
		var clickIndex=this.getRowIndex(clickRow);
		var moveRows=this.getMoveRows(clickRow);
		var pNode=clickRow.parentNode;
		var type=moveType.toLowerCase();
		switch(type){
			case "first":
				if(clickIndex>this.firstRowIndex){
					var node=table.rows[this.firstRowIndex];
					this.appendBefore(pNode, moveRows, node);
					this.removeRow(clickRow);
				}
				break;
			case "up":
				var _node=clickRow;
				if(clickIndex>this.firstRowIndex){
					_node=table.rows[clickIndex-1];
					if(_node.getAttribute("rowType")=="child" && clickRow.getAttribute("rowType")=="child"){
						this.appendBefore(pNode, moveRows, _node);
						this.removeRow(clickRow);
					}else if(clickRow.getAttribute("rowType")=="parent"){
						for(var i=clickIndex-1;i>=0;i--){
							if(table.rows[i].getAttribute("rowType")=="parent"){
								_node=table.rows[i];
								break;
							}
						}
						this.appendBefore(pNode, moveRows, _node);
						this.removeRow(clickRow);
					}
				}
				break;
			case "down":
				var _node=clickRow;
				if(clickIndex<table.rows.length-1){
					_node=table.rows[clickIndex+1];
					if(clickRow.getAttribute("rowType")=="child" && _node.getAttribute("rowType")=="child"){
						this.moveRow(_node,"up");
					}else if(clickRow.getAttribute("rowType")=="parent"){
						for(var i=clickIndex+1;i<table.rows.length;i++){
							if(table.rows[i].getAttribute("rowType")=="parent"){
								_node=table.rows[i];
								break;
							}
						}
						this.moveRow(_node,"up");
					}
				}
				break;
			case "last":
				if(clickIndex<table.rows.length-1){
					this.appendChild(pNode,moveRows);
					this.removeRow(clickRow);
				}
				break;
		}
	};
};
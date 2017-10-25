<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="/javascript/sys-jscode.js" charset="utf-8"></script>
<%Html.RenderPartial("Base/_PageHeadControl"); %>
<link href="/style/style.css" rel="stylesheet" type="text/css" />

<title><%=ViewData["pageTitle"]%></title>
</head>
<body>
<%Html.RenderPartial("Base/_SimplePageTopControl"); %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
	int pid=DoRequest.GetQueryInt("pid");
    int useplat = DoRequest.GetQueryInt("useplat");
    RecommendPositionInfo pos = new RecommendPositionInfo();
    var resreinfo = GetRecommendPositionInfo.Do(pid);
    if (resreinfo != null && resreinfo.Body != null)
        pos = resreinfo.Body;
%>
<div id="container-syscp">
<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
</div>
<div class="container-right">
<div class="position">
当前位置：
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <a href="/mpolymeric/root">页面设置</a> &gt;&gt; <span>推荐位设置<%=pos.rp_id>0?("(" + pos.rp_name + ")"):""%><%=useplat==4?"(PC)":"(手机)" %></span>
</div>
<form action="/mpolymeric/index" method="get" onsubmit="">
  <div class="div-tab-h1" style="font-weight:100;color:#333;font-size:12px">
       <input type="hidden" name="pid" value="<%=pid %>" />
       <input type="hidden" name="useplat" value="<%=useplat %>" />
  </div>
</form>

<form method="post" action="" onsubmit="return submitTable(this)">
    <input type="hidden" name="ptype" value="<%=useplat %>" />
		<div class="div-tab">
			<div class="div-tab-h1">
				<span onclick="addRow('parent')"><b class="icon-add">&nbsp;</b>添加推荐位</span>
				<input type="submit" id="loadding3" value="保存更改" class="submit"/>
			</div>
<table id="tab-position" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:3%">ID</th>
    <th style="width:50%">名称</th>
    <th style="width:10%">&nbsp;</th>
    <th style="width:14.6%">移动</th>
    <th style="width:6%">&nbsp;</th>
    <th>操作</th>
  </tr>
</thead>
<tbody>
<%
    List<ShortRecommendPosition> infoList = new List<ShortRecommendPosition>();
    var respos = GetRecommendPositionByCode.Do(pos.rp_code, useplat);
    if(respos != null && respos.Body != null &&respos.Body.recommend_list != null)
        infoList = respos.Body.recommend_list;
    foreach (ShortRecommendPosition item in infoList)
    {
%>
  <tr rowType="parent" opType="update" parentID="<%=pos.rp_code%>" newRow="false" rowID="<%=item.rp_code%>" rowName="<%=item.rp_name%>" usePlat="<%=useplat %>" posId="<%=item.rp_id %>">
    <td><input name="rpid" value="<%=item.rp_id%>" class="input" style="width:45px;" onchange="setRowAttValue(this, 'posId')"/></td>
    <td><input type="text" value="<%=item.rp_name%>" class="input" onchange="setRowAttValue(this, 'rowName')"/></td>
    <td>
&nbsp;
    </td>
    <td class="move-links">
    <a href="javascript:void(0);" onclick="moveRow(this,'first');" class="move-first" title="置顶">&nbsp;</a>
    <a href="javascript:void(0);" onclick="moveRow(this,'up');" class="move-up" title="上移">&nbsp;</a>
    <a href="javascript:void(0);" onclick="moveRow(this,'down');" class="move-down" title="下移">&nbsp;</a>
    <a href="javascript:void(0);" onclick="moveRow(this,'last');" class="move-last" title="最末">&nbsp;</a>
    </td>
    <td>&nbsp;</td>
    <td>
    <a href="javascript:void(0);" onclick="removeRow(this,true);">删除</a></td>
  </tr>
<%
		//次级分类
    List<ShortRecommendPosition> infoList2 = new List<ShortRecommendPosition>();
    var respos2 = GetRecommendPositionByCode.Do(item.rp_code, useplat);
    if (respos2 != null && respos2.Body != null && respos2.Body.recommend_list != null)
        infoList2 = respos2.Body.recommend_list;
    foreach (ShortRecommendPosition item2 in infoList2)
    {
%>
  <tr rowType="child" opType="update" newRow="false" parentID="<%=item.rp_code%>" rowID="<%=item2.rp_code%>" rowName="<%=item2.rp_name%>" usePlat="<%=useplat %>" posId="<%=item2.rp_id %>">
    <td><input name="rpid" value="<%=item2.rp_id%>" class="input" style="width:45px;" onchange="setRowAttValue(this, 'posId')"/></td>
    <td><span class="tree">&nbsp;</span><input type="text" value="<%=item2.rp_name%>" class="input" onchange="setRowAttValue(this, 'rowName')"/></td>

    <td>
    &nbsp;
   </td>
    <td class="move-links">
    <a href="javascript:void(0);" onclick="moveRow(this,'up');" class="move-up" title="上移">&nbsp;</a>
    <a href="javascript:void(0);" onclick="moveRow(this,'down');" class="move-down" title="下移">&nbsp;</a>
    </td>
    <td>&nbsp;</td>
    <td>
    <a href="javascript:void(0);" onclick="removeRow(this,true);">删除</a>
    &nbsp;&nbsp;
    <a href="/mpolymeric/list?posid=<%=item2.rp_id%>&useplat=<%=useplat %>">查看</a>
    </td>
  </tr>
<%
		}
%>
  <tr rowType="child-add">
    <td>&nbsp;</td>
    <td><span class="tree">&nbsp;</span><input type="button" value="添加子分类" onclick="addChildRow(this,<%=useplat %>)" class="tree-add"/></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
<%
		}
%>
  </tbody>
</table>
			<div class="div-tab-bottom">
				<span onclick="addRow('parent')"><b class="icon-add">&nbsp;</b>添加推荐位</span>
				<input type="submit" id="loadding3" value="保存更改" class="submit"/>
			</div>
		</div>
</form>
	<div class="clear"></div>
</div>
</div>
<script type="text/javascript">
function createXmlDocument(nodes){
	var xml='<?xml version="1.0" encoding="utf-8"?>';
	xml += '<items>';
	for(var i=0;i<nodes.length;i++){
		xml += nodes[i];
	}
	xml += '</items>';
	return xml;
}

function createXmlNode(json){
	var node='<item Type="'+ json.Type +'" ParentID="'+ json.ParentID +'" PosID="'+ json.PosID +'" SortNo="'+ json.SortNo +'" UsePlat="'+ json.UsePlat +'" Code="'+ json.Code +'" Flag="'+ json.Flag +'">';
	node += '<name><![CDATA[\n'+ json.Name +'\n]]></name>';
	node += '</item>';
	return node;
}
var _removeRowCount=0;
function submitTable(form){
	var table=_table._table;
	var list=[];
	var sortNo=0;
	for(var i=0;i<table.rows.length;i++){
		var row=table.rows[i];
		var rowType=row.getAttribute("rowType");
		var rowName=row.getAttribute("rowName");
		rowName=rowName?rowName:"";
		if(Atai.trim(rowName)=="" && (rowType=="parent" || rowType=="child")){
			jsbox.error("行 " + i + " 处未填写标题，请填写或删除该行");return false;
		}
		if((rowType=="parent" || rowType=="child") && Atai.trim(rowName)!=""){
			sortNo++;
			list.push({
				 Type : row.getAttribute("opType")//操作类型
				,ParentID : row.getAttribute("parentID")?row.getAttribute("parentID"):""
				,PosID : row.getAttribute("posID")?row.getAttribute("posID"):"0"
                ,Code: row.getAttribute("rowId")?row.getAttribute("rowId"):""
				,SortNo : sortNo
                ,UsePlat : row.getAttribute("usePlat")?row.getAttribute("usePlat"):"7"
				,Name : rowName
                ,Flag :row.getAttribute("newRow")?row.getAttribute("newRow"):"true"
			});
		}
	}
	if(list.length<1 && _removeRowCount<1){
		jsbox.error("没有可提交的数据");return false;
	}else if(_removeRowCount>0){
		jsbox.confirm("您总共删除了" + _removeRowCount + "行，确定保存吗？",function(){_removeRowCount=0;submitTable(form);})
		return false;
	}
	var nodes=[];
	for(var i=0;i<list.length;i++){
		nodes.push(createXmlNode(list[i]));
	}

	var xml = createXmlDocument(nodes);//.replace(/</mg,"&lt;").replace(/>/mg,"&gt;");
	//alert(xml);return false;
	//Atai.$("#post-xml").value=xml;//避免ajax无法提交
	if (showLoadding) showLoadding();
	var postData = getPostDB(form) + "&parent=<%=pos.rp_code%>&xml=" + encodeURIComponent(xml);
	$.ajax({
		url: "/mpolymeric/PostPosition"
		, data: postData
        , type: "post"
		, dataType: "json"
		, success: function(json){
			if(json.error){
				jsbox.error(json.message);return false;
			}else{
				jsbox.success(json.message, window.location.href);
            }
            if (closeLoadding) closeLoadding();
		}
	});
	_isModify=false;
	return false;
}
</script>
<script type="text/javascript">
var _table=false;
var _rowID="<%=Guid.NewGuid().ToString().ToLower()%>";
Atai.addEvent(window,"load",function(){
	var _tab=Atai.$("#tab-position");
	_table=new AtaiTable(_tab);
	_table.firstRowIndex=1;
});
var _newcount = 0;
function cellList(type,splat){
	var arr=new Array();
	if(type=="child-add"){
		for(var i=0;i<6;i++){
			arr.push({className: "", html: "&nbsp;"});
		}
		arr[1]={className: "", html: '<span class="tree">&nbsp;</span><input type="button" value="添加子分类" onclick="addChildRow(this,'+ splat +')" class="tree-add"/>'};
		return arr;
	}
	arr[0]={className: "", html: '<input name="rpid" value="" class="input" style="width:45px;" onchange="setRowAttValue(this, \'posId\')"/>'};
	arr[1] = { className: "", html: (type == "child" ? '<span class="tree">&nbsp;</span>' : "") + '<input type="text" value="" onchange="setRowAttValue(this, \'rowName\')" class="input"/>' };
	var str2 = '';
	arr[2] = { className: "", html: str2 };
	_newcount++;
	var str3='';
	if(type=="parent") str3 += '<a href="javascript:void(0);" onclick="moveRow(this,\'first\');" class="move-first" title="置顶">&nbsp;</a>\n';
	str3 += '<a href="javascript:void(0);" onclick="moveRow(this,\'up\');" class="move-up" title="上移">&nbsp;</a>\n';
	str3 += '<a href="javascript:void(0);" onclick="moveRow(this,\'down\');" class="move-down" title="下移">&nbsp;</a>\n';
	if(type=="parent") str3 += '<a href="javascript:void(0);" onclick="moveRow(this,\'last\');" class="move-last" title="最后">&nbsp;</a>';
	arr[3]={className: "move-links", html: str3};
	arr[4]={className: "", html: (type=="parent")?'&nbsp;':'&nbsp;'};
	arr[5]={className: "", html: '<a href="javascript:void(0);" onclick="removeRow(this);">删除</a>\n'};
	return arr;
}
function setRowAttValue(inputObj, attName){
	_isModify=true;
	var row=_table.getRowByChild(inputObj).obj;
	row.setAttribute(attName, inputObj.value.replace(/"/g,"“"));
}


function addRow(type,clickRow,plat){
	if(!_table) return;
	var row=_table.addRow(type, clickRow, cellList(type,plat));
	_rowID=getGuid();

	row.setAttribute("rowID", _rowID);
	row.setAttribute("opType", "create");
    row.setAttribute("newRow","true");
	
	if(type=="parent"){
	    row.setAttribute("parentID", "<%=pos.rp_code%>");
	    row.setAttribute("usePlat", "<%=useplat%>");
	}else if(type=="child"){
		var _parentID="";
		//var _temSort=0;
		var isBegin=false;
		for(var i=_table._table.rows.length-1;i>=0;i--){
			if(_table._table.rows[i]==row){
				isBegin=true;
			}
			if(isBegin && _table._table.rows[i].getAttribute("rowType")=="parent"){
				//_temSort=_table._table.rows[i].getAttribute("sortNo");
				_parentID=_table._table.rows[i].getAttribute("rowID");break;
			}
		}
		row.setAttribute("parentID", _parentID);
        row.setAttribute("usePlat", plat);
	}
	if(type=="parent") _table.addRow("child-add", clickRow, cellList("child-add"));
	resetRowClassName(_table._table);
}
function addChildRow(childObj,plat){
	addRow("child", _table.getRowByChild(childObj).obj,plat);
	resetRowClassName(_table._table);
}
function moveRow(childObj, moveType){
	_isModify=true;
	_table.moveRow(_table.getRowByChild(childObj).obj, moveType);
	resetRowClassName(_table._table);
}
function removeRow(childObj, ask){
/*	if(ask){
		if(!confirm('您确定要删除该行吗？\n本操作问预删除，需点[保存更改]后生效')){
			return false;
		}
	}*/
	_isModify=ask?true:false;
	_table.removeRow(_table.getRowByChild(childObj).obj);
	resetRowClassName(_table._table);
	_removeRowCount++;
}
</script>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body></html>
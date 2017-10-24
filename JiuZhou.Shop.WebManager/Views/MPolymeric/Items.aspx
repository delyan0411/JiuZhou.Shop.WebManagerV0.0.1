<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/style/style.css" rel="stylesheet" type="text/css" />
<%Html.RenderPartial("Base/_PageHeadControl"); %>
<title><%=ViewData["pageTitle"]%></title>
</head>
<body>
<%Html.RenderPartial("Base/_SimplePageTopControl"); %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);

    int useplat = DoRequest.GetQueryInt("useplat");
	int posId = DoRequest.GetQueryInt("posId");
    RecommendPositionInfo pos = new RecommendPositionInfo();
    var resrec = GetRecommendPositionInfo.Do(posId);

    if (resrec != null && resrec.Body != null)
        pos = resrec.Body;

    string _pathName = "";
    List<TypeList> tList = new List<TypeList>();
    var restype = GetTypeListAll.Do(-1);
    if (restype != null && restype.Body != null && restype.Body.type_list != null)
        tList = restype.Body.type_list;

%>

<div id="container-syscp">

<div class="position">
当前位置：
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <a href="/mpolymeric/list" title="已推荐列表">已推荐列表</a> &gt;&gt; <span>[<%=pos.rp_name%>] 明细<%=useplat==4?"(PC)":"(手机)" %></span>
</div>

<form id="post-form" method="post" action="">
<table id="tab-position" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:3%"><input type="checkbox" onclick="checkAll(this.form,this)" name="chkall" title="选中/取消选中"/></th>
    <th style="width:8%">类别</th>
    <th>类别值</th>
    <th style="width:24%">标题</th>
    <th style="width:2%">&nbsp;</th>
    <th style="width:8%">开始</th>
    <th style="width:8%">结束</th>
    <th style="width:6%">状态</th>
    <th style="width:12%">排序</th>
    <th style="width:6%">操作</th>
  </tr>
</thead>
<tbody>
<%
    List<RecommendListInfo> infoList = (List<RecommendListInfo>)ViewData["infoList"];
    if (infoList == null)
        infoList = new List<RecommendListInfo>();
    foreach (RecommendListInfo item in infoList)
    {
        if (useplat>=6 && item.use_plat < 6)
            continue;
        if (useplat < 4 && item.use_plat >= 4)
            continue;
%>
  <tr rowType="parent" opType="update" rowID="<%=item.ri_id%>">
    <td><input type="checkbox" onclick="selectOne(this)" name="visitid" value="<%=item.ri_id%>" /></td>
    <%
        string _cate = "";
        switch (item.ri_type)
        {
            case 1:
                _cate = "商品ID";
                break;
            case 2:
                _cate = "类别";
                break;
            case 3:
                _cate = "品牌";
                break;
            case 4:
                _cate = "URL";
                break;
            case 5:
                _cate = "专题/馆";
                break;
            default:
                _cate = "未知";
                break;  
        
        }
         %>
    <td><%=_cate%></td>
 <%
     if (item.ri_type == 2)
     {
         TypeList type = tList.Find(
         delegate(TypeList em)
         {
             return em.product_type_id == Utils.StrToInt(item.ri_value);
         });

         string _path = type.product_type_path;
         string[] _tem = _path.Split(',');
         int _xCount = 0;
         _pathName = "";
         for (int x = 0; x < _tem.Length; x++)
         {
             if (string.IsNullOrEmpty(_tem[x].Trim())) continue;
             int _v = Utils.StrToInt(_tem[x].Trim());
             foreach (TypeList em in tList)
             {
                 if (em.product_type_id == _v)
                 {
                     if (_xCount > 0) _pathName += " >> ";
                     _pathName += em.type_name;
                     _xCount++;
                 }
             }
         }
     }
  %>
    <td><%= item.ri_type==2?_pathName:item.ri_value %></td>
    <td><a href="/mpolymeric/itemseditor?posid=<%=posId %>&listid=<%=item.ri_id%>&useplat=<%=useplat %>"><%=item.ri_subject%></a></td>
    <td id="plat" value="<%=item.ri_id %>">
   &nbsp;
    </td>
    <td><%=DateTime.Parse(item.start_time).ToString("yyyy-MM-dd HH:mm:ss")%></td>
    <td><%=DateTime.Parse(item.end_time).ToString("yyyy-MM-dd HH:mm:ss")%></td>
    <%DateTime _stime = DateTime.Parse(item.start_time);
      DateTime _etime = DateTime.Parse(item.end_time);         %>
    <td><%
		if(DateTime.Now<_stime){
			Response.Write("<span style='color:red'>未开始</span>");	
		}else if(DateTime.Now>=_stime && DateTime.Now<=_etime){
			Response.Write("<span style='color:green'>已开始</span>");	
		}if(DateTime.Now>_etime){
			Response.Write("<span style='color:#999'>已结束</span>");	
		}
	%></td>
    <td class="move-links">
    <a href="javascript:void(0);" onclick="moveRow(this,'first');" class="move-first" title="置顶">&nbsp;</a>
    <a href="javascript:void(0);" onclick="moveRow(this,'up');" class="move-up" title="上移">&nbsp;</a>
    <a href="javascript:void(0);" onclick="moveRow(this,'down');" class="move-down" title="下移">&nbsp;</a>
    <a href="javascript:void(0);" onclick="moveRow(this,'last');" class="move-last" title="最末">&nbsp;</a>
    </td>
    <td>
    <a href="/mpolymeric/itemseditor?posid=<%=posId%>&listid=<%=item.ri_id %>&useplat=<%=useplat %>">修改</a>
    </td>
  </tr>
<%
	}
%>
  </tbody>
</table>
			<div class="div-tab-bottom">
            	<b class="icon-add">&nbsp;</b><a href="/mpolymeric/itemseditor?posid=<%=posId%>&listid=0&useplat=<%=useplat %>" style="color:#0000FF">新增</a>
                &nbsp;&nbsp;
				<span onclick="deleteList(Atai.$('#post-form'))"><b class="icon-remove">&nbsp;</b>永久删除选定项</span>
                &nbsp;&nbsp;
                <input type="button" value="确定更改排序" class="submit" onclick="return resetItemSort();"/>
			</div>
</form>
</div>
<script type="text/javascript">


function deleteList(form){
	var postData=getPostDB(form);
	jsbox.confirm('您确定要永久删除这些数据吗？',function(){
		$.ajax({
			url: "/MPolymeric/RemoveItems"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function(json){
				if(json.error){
					jsbox.error(json.message);return false;
				}else{
					window.location.href=window.location.href;
				}
			}
		});
	});
	return false;
}
</script>
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
	var node='<item ItemID="'+ json.ItemID +'" SortNo="'+ json.SortNo +'"/>';
	return node;
}
var _removeRowCount=0;
function resetItemSort(){
	var table=_table._table;
	var list=[];
	var sortNo=<%=pos.sort_no.ToString("0")%> * 100;
	for(var i=0;i<table.rows.length;i++){
		var row=table.rows[i];
		sortNo++;
		list.push({
			 ItemID : row.getAttribute("rowID")?row.getAttribute("rowID"):""
			,SortNo : sortNo
		});
	}
	if(list.length<1 && _removeRowCount<1){
		jsbox.error("没有可提交的数据");return false;
	}
	var nodes=[];
	for(var i=0;i<list.length;i++){
		nodes.push(createXmlNode(list[i]));
	}

	var xml = createXmlDocument(nodes);
	var postData="xml=" + encodeURIComponent(xml);
	$.ajax({
		url: "/mpolymeric/ResetItemSortNo"
		, data: postData
        , type: "post"
		, dataType: "json"
		, success: function(json){
			if(json.error){
				jsbox.error(json.message);
			}else{
				jsbox.success(json.message, window.location.href);
			}
		}
	});
	_isModify=false;
	return false;
}
</script>
<script type="text/javascript">
var _table=false;
//var _rowID="<%=Guid.NewGuid().ToString().ToLower()%>";
Atai.addEvent(window,"load",function(){
	var _tab=Atai.$("#tab-position");
	_table=new AtaiTable(_tab);
	_table.firstRowIndex=1;
});
function moveRow(childObj, moveType){
	_isModify=true;
	_table.moveRow(_table.getRowByChild(childObj).obj, moveType);
	resetRowClassName(_table._table);
}
</script>
<br/><br/><br/><br/><br/><br/>
<br/><br/><br/>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body></html>
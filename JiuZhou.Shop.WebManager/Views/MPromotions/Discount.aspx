<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%Html.RenderPartial("Base/_PageHeadControl"); %>
<link href="/style/style.css" rel="stylesheet" type="text/css" />
<title><%=ViewData["pageTitle"]%></title>
</head>
<body>
<%Html.RenderPartial("Base/_SimplePageTopControl"); %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div id="container-syscp">
<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
</div>
<div class="container-right">
	<div class="position">
		<a href="/" title="管理首页">管理首页</a>
		&gt;&gt;
		<a href="/mpromotions/Discount" title="限时折扣">限时折扣</a>
	</div>
<%--//position--%>
<form action="/mpromotions/Discount" method="get" onsubmit="checksearch(this)">
			<div class="div-tab-h1" style="font-weight:100;color:#333;font-size:12px">
		<p>
		<input type="text" id="sQuery" name="q" value="<%=DoRequest.GetQueryString("q")%>" class="input"/></p>
<p>
<input type="submit" value=" 搜索 " class="submit"/>
</p>
			</div>
</form>
<script type="text/javascript">
var qInitValue="请输入关键词";
Atai.addEvent(window,"load",function(){
	var sQuery=Atai.$("#sQuery");
	if(sQuery.value==qInitValue || sQuery.value==""){
		sQuery.value=qInitValue;
		sQuery.style.color="#999";
	}else{
		sQuery.style.color="#111";
	}
	sQuery.onfocus=function(){
		if(this.value==qInitValue){
			this.value="";
			sQuery.style.color="#111";
		}
	};
	sQuery.onblur=function(){
		if(this.value==""){
			this.value=qInitValue;
			sQuery.style.color="#999";
		}
	};
});
function checksearch(form){
	var sQuery=Atai.$("#sQuery");
	if(sQuery.value==qInitValue){
		sQuery.value="";
	}
}
</script>
<form id="post-form" method="post" action="">
<%=ViewData["pageIndexLink"]%>
<table id="tab-category" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:3%"><input type="checkbox" onclick="checkAll(this.form,this)" name="chkall" title="选中/取消选中"/></th>
    <th>活动标题</th>
    <th style="width:8%">价格名</th>
    <th style="width:7%">折扣模式</th>
    <th style="width:7%">降价方式</th>
    <th style="width:6%">降价值</th>
    <th style="width:8%">开始时间</th>
    <th style="width:8%">结束时间</th>
    <th style="width:8%">添加时间</th>
    <th style="width:8%">操作</th>
  </tr>
</thead>
<tbody>
<%
    List<DiscountInfo> infoList = (List<DiscountInfo>)ViewData["infoList"];
    if (infoList == null)
        infoList = new List<DiscountInfo>();
    foreach (DiscountInfo item in infoList)
    {	
%>
  <tr>
    <td><input type="checkbox" onclick="selectOne(this)" name="visitid" value="<%=item.lt_discount_id%>" /></td>
    <td>
	<a href="/mpromotions/Discounteditor?ruleid=<%=item.lt_discount_id%>"><%=item.subject_name%></a>
    </td>
    <td><%=item.discount_name%>
    </td>
    <%
        string _mode = "";
        switch(item.discount_mode){
            case 0:
                _mode = "单品";
                break;
            case 1:
                _mode = "品牌";
                break;
            case 2:
                _mode = "类目";
                break;
            case 3:
                _mode = "卖家";
                break;
            case 4:
                _mode = "全站";
                break;
            default :
                _mode ="未知";
                break;
        }
    %>
    <td><%=_mode %>
    </td>
    <%
        string _type = "未知";
        if(item.cut_type==0)
            _type = "百分比";
        if(item.cut_type==1)
            _type = "固定值";
         %>
    <td><%=_type%>
    </td>
    <td><%=item.cut_type==0?item.cut_rate:item.cut_price %>
    </td>
    <td><%=DateTime.Parse(item.start_time).ToString("yyyy-MM-dd") %>
    </td>
    <td><%=DateTime.Parse(item.end_time).ToString("yyyy-MM-dd") %>
    </td>
    <td><%=DateTime.Parse(item.add_time).ToString("yyyy-MM-dd") %>
    </td>
    <td>
    <a href="/mpromotions/Discounteditor?ruleid=<%=item.lt_discount_id %>" target="_blank" style="color:#333">编辑</a>
     <a href="javascript:;" onclick="deleteList(<%=item.lt_discount_id%>)" style="color:#333">删除</a>
    </td>
  </tr>
<%
	}
%>
  </tbody>
</table>
<%=ViewData["pageIndexLink2"]%>
    <div class="div-tab-bottom">
         <b class="icon-add">&nbsp;</b><a href="/mpromotions/Discounteditor?ruleid=0" style="color:#0000FF">新增折扣</a>
	     <span onclick="deleteList(Atai.$('#post-form'))"><b class="icon-remove">&nbsp;</b>删除选定项</span>
	</div>
</form>
</div>
</div>

<script type="text/javascript">
    function deleteList(form) {
        var postData = "";
        if (Atai.isNumber(form)) {
            postData = "visitid=" + form;
        } else {
            postData = getPostDB(form);
        }
        jsbox.confirm('您确定要删除这些数据吗？', function () {
            $.ajax({
                url: "/MPromotions/RemoveDiscount"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function (json) {
			    if (json.error) {
			        jsbox.error(json.message); return false;
			    } else {
			        jsbox.success(json.message, window.location.href);
			    }
			}
            });
        });
        return false;
    }
</script>

<br/><br/><br/>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body></html>

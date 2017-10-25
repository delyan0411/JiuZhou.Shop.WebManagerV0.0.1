<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %><%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %><%@ Import Namespace="System.Data" %>
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
            当前位置： <a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>SQL语句查询</span>
        </div>
        <form action="/home/QuerySql" method="post" onsubmit="checksearch(this)">
        <div class="div-tab-h1" style="font-weight: 100; color: #333; font-size: 12px;height:180px;">
            <p>
                <select id="sel-database" name="database" style="width: 220px">
                    <option value="USER" init="true">用户库</option>
                    <option value="SHOP">商城库</option>
                </select>
            </p>
       
            <p>
                <textarea id="sQuery" name="q" class="textarea" autocomplete="off" style="height:160px;width:500px;" > <%=(string)ViewData["sql"]%> </textarea>
            </p>
            <p>
                <input type="submit" value=" 搜索 " class="submit" />
               &nbsp;<a href="/home/DownLoadPage" style="font-size:14px">导出</a> 
            </p>
        </div>
        </form>
        <script type="text/javascript">
var qInitValue="请输入关键词";
Atai.addEvent(window,"load",function(){

var dropStar=new _DropListUI({
		input: Atai.$("#sel-database")
	});dropStar.maxHeight="260px";dropStar.width="120px";
	dropStar.init();dropStar.setDefault("<%=(string)ViewData["type"]%>");


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
    sQuery
}
        </script>
        <form id="post-form" method="post" action="">
       
     <div style="overflow:scroll">
        <table id="tab-category" class="table" cellpadding="0" cellspacing="0">
            <thead>
                <tr>
                <th style="width:5%">序号</th>
                <%
                    List<string> colname = (List<string>)ViewData["colname"];
                    foreach (string em in colname) {
                        Response.Write("<th style=\"width:"+ (100-3)/colname.Count +"%\">"+ em +"</th>");
                    }
                     %>
                </tr>
            </thead>
            <tbody>
                <%
                    DataTable infoList = (DataTable)ViewData["infoList"];
                    if (infoList == null)
                        infoList = new DataTable();
                    int _count = 0;
                    for (var i = 0; i < infoList.Rows.Count;i++ )
                    {
                %>
                <tr>
                    <td>
                        <%=_count%>
                    </td>
                    <%  
                        DataRow item = infoList.Rows[i];
                        for(var j = 0 ;j <colname.Count ;j++)
                        {
                            Response.Write("<td><a>" + item[colname[j]] + "</a></td>");
                          
                        }
                         %>                   
                </tr>
                <%
                    _count++;
                    }
                %>
            </tbody>
        </table>
      </div>
        </form>
    </div>
    </div>
<%Html.RenderPartial("Base/_PageFootControl"); %>

</body>
</html>

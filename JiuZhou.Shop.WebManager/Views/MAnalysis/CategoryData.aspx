<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %><%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
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
        List<TypeList> tList = null;
        var re = GetTypeListAll.Do(1);
        if (re == null || re.Body == null || re.Body.type_list == null)
        {
            tList = new List<TypeList>();
        }
        else
        {
            tList = re.Body.type_list;
        }
    %>
    <div id="container-syscp">
   <div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
        <div class="position">
            当前位置： <a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>一级类目销售情况(数据)</span>
        </div>
        <form action="/manalysis/categorydata" method="get">
        <div class="div-tab-h1" style="font-weight: 100; color: #333; font-size: 12px">
       <p>
<%
	DateTime date = DateTime.Now.AddDays(-8);
%><input type="text" name="sdate" value="<%=DoRequest.GetQueryDate("sDate", date).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
至
<input type="text" name="edate" value="<%=DoRequest.GetQueryDate("eDate", DateTime.Now.AddDays(-1)).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
      </p>
            <p>
        <select id="type-id" name="product-type" style="height:28px;width:100px;">
          <option value="0" selected="selected">所有类别</option>
          <%
              foreach (TypeList _type in tList) {
                  if (_type.parent_type_id != 0)
                      continue;
                  if (_type.product_type_id == DoRequest.GetQueryInt("product-type", 0))
                  {
                      Response.Write("<option value=\"" + _type.product_type_id + "\" selected=\"selected\">" + _type.type_name + "</option>");
                  }
                  else
                  {
                      Response.Write("<option value=\"" + _type.product_type_id + "\" >" + _type.type_name + "</option>");
                  }
              }    
          %>
        </select>
      </p>
       <p>
            <input type="submit" value=" 搜索 " class="submit" />&nbsp;&nbsp;<a href="javascript:;" style="font-size:14px" onclick="changeType('')">所有</a>&nbsp;<a href="javascript:;" style="font-size:14px" onclick="changeType('药品部')">药品</a>&nbsp;<a href="javascript:;" style="font-size:14px" onclick="changeType('非药品部')">非药品</a>&nbsp;&nbsp;<a href="/Manalysis/DownLoadPage" style="font-size:14px">导出</a> 
       </p>
        </div>
        </form>
        <form id="post-form" method="post" action="">
        <table id="tab-category" class="table" cellpadding="0" cellspacing="0" >
            <thead>
                <tr>
                    <th style="width:10%">日期</th>
                    <th style="width:16%">
                        类目名称
                    </th>
                    <th style="width: 10%">
                        销 售 量
                    </th>
                    <th style="width: 12%">
                        销 售 额
                    </th>
                    <th style="width:10%">
                        日 动 销
                    </th>
                    <th style="width:10%">
                        日动销率
                    </th>
                    <th style="width:10%">
                        周动销率
                    </th>
                    <th style="width:10%">
                        月动销率
                    </th>
                    <th style="width:10%">
                        部&nbsp;&nbsp;门
                    </th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<YlmxlphInfo> infoList = (List<YlmxlphInfo>)ViewData["infoList"];
                    if (infoList == null)
                        infoList = new List<YlmxlphInfo>();
                    foreach (YlmxlphInfo item in infoList)
                    {
                        foreach (YlmxlphDetails item2 in item.type_details)
                        {
                %>
                <tr>
                  <td><%=item.query_date%></td>
                  <td><%=item2.type_name%></td>
                  <td><%=item2.product_num%></td>
                  <td><%=item2.sale_money%> 元</td>
                  <td><%=item2.type_sku%></td>
                  <td><%=item2.type_sku_rate%></td>
                  <td><%=item2.week_sku_rate%></td>
                  <td><%=item2.month_sku_rate%></td>
                  <td><%=item.shop_name %></td>
                </tr>
                <%
}
                    }
                %>
            </tbody>
        </table>
        </form>
    </div>
    </div>
<script type="text/javascript">
 var _currUrl="<%=ViewData["currPageUrl"]%>";
function formatUrl(ocol, val, url){
	if(!url) url=_currUrl;
	var reg = ocol + "=[^-]*";
	var reg = new RegExp(ocol + "=[^&\.]*");
	url = url.replace(reg, ocol + "=" + val);
	return url;
}
 var changeType=function(type){
	//_currUrl=formatUrl("type",value);
	url=formatUrl("type",type);
	window.location.href=url;
};
</script>

<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>

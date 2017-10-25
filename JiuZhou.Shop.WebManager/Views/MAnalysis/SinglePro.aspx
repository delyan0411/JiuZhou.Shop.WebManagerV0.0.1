<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %><%@ Import Namespace="JiuZhou.Cache" %><%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
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
        List<TypeList> tList = new List<TypeList>();
        DoCache chche = new DoCache();
        if (chche.GetCache("typelist") == null)
        {
            var res = GetTypeListAll.Do(-1);
            if (res != null && res.Body != null && res.Body.type_list != null)
            {
                tList = res.Body.type_list;
                chche.SetCache("typelist", tList);
                if (tList.Count == 0)
                {
                    chche.RemoveCache("typelist");
                }
            }
        }
        else
        {
            tList = (List<TypeList>)chche.GetCache("typelist");
        }
    %>
    <div id="container-syscp">
   <div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
        <div class="position">
            当前位置： <a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>单品统计</span>
        </div>
        <form action="/manalysis/singlePro" method="get">
        <input type="hidden" name="ocol" value="<%=DoRequest.GetQueryString("ocol")%>"/>
        <input type="hidden" name="ot" value="<%=DoRequest.GetQueryString("ot")%>"/>
        <div class="div-tab-h1" style="font-weight: 100; color: #333; font-size: 12px">
       <p>
<%
    DateTime date = DateTime.Now.AddDays(-1);
%><input type="text" name="sdate" value="<%=DoRequest.GetQueryDate("sDate", date).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
至
<input type="text" name="edate" value="<%=DoRequest.GetQueryDate("eDate", date).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
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
      &nbsp;每页显示商品数量： <input type="text" name="size" value="<%=DoRequest.GetQueryInt("size",30) %>" style="height:25px;width:30px;" />&nbsp;
      </p>
            <p>
                <input type="submit" value=" 搜索 " class="submit" />&nbsp;&nbsp;<a href="/Manalysis/DownLoadPage5" style="font-size:14px">导出</a> 
            </p>
        </div>
        </form>
     <%
	    string otype = DoRequest.GetQueryString("ot").Trim();
     %>
        <form id="post-form" method="post" action="">
     <%=ViewData["pageIndexLink"]%>
        <table id="tab-category" class="table" cellpadding="0" cellspacing="0">
            <thead>
                <tr>
                <th style="width:3%">
                &nbsp;
                </th>
                    <th style="width:10%">
                        商品编码
                    </th>
                    <th>
                        商品名称
                    </th>
                    <th style="width: 12%">
                        厂商
                    </th>
                    <th style="width: 7%">
                        类目名
                    </th>
                    <th style="width: 5%">
                        <a href="javascript:;" onclick="changeOrderBy('page_view','<%=otype=="ASC"?"DESC":"ASC"%>')">PV</a>
                    </th>
                    <th style="width: 5%">
                        <a href="javascript:;" onclick="changeOrderBy('user_view','<%=otype=="ASC"?"DESC":"ASC"%>')">UV</a>
                    </th>
                    <th style="width: 6%">
                        <a href="javascript:;" onclick="changeOrderBy('transform_rate','<%=otype=="ASC"?"DESC":"ASC"%>')">转换率</a>
                    </th>
                    <th style="width: 9%">
                        <a href="javascript:;" onclick="changeOrderBy('sale_price','<%=otype=="ASC"?"DESC":"ASC"%>')">售价</a>
                    </th>
                    <th style="width: 5%">
                        <a href="javascript:;" onclick="changeOrderBy('sale_num','<%=otype=="ASC"?"DESC":"ASC"%>')">数量</a>
                    </th>
                    <th style="width: 10%">
                        <a href="javascript:;" onclick="changeOrderBy('sale_money','<%=otype=="ASC"?"DESC":"ASC"%>')">总金额</a>
                    </th>
                    <th style="width: 5%">
                        <a href="javascript:;" onclick="changeOrderBy('stock_num','<%=otype=="ASC"?"DESC":"ASC"%>')">库存</a>
                    </th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<DpphInfo> infoList = (List<DpphInfo>)ViewData["infoList"];
                    if (infoList == null)
                        infoList = new List<DpphInfo>();
                    int _count = 1;
                    foreach (DpphInfo item in infoList)
                    {
                %>
                <tr>
                <% 
                    int _index = _count + (DoRequest.GetQueryInt("page", 1) - 1) * 30 ;
                %>
                    <td>
                        <%=_index %>
                    </td>
                    <td>
                        <%=item.product_code %>
                    </td>
                    <td>
                        <a href="<%=config.UrlHome%><%=item.product_id %>.html" target="_blank" title="<%=item.product_name%>"><%=item.product_name%></a>
                    </td>
                    <td>
                        <%=item.manu_facturer%>
                    </td>
                    <td>
                        <%=item.type_name%>
                    </td>
                    <td>
                        <%=item.page_view %>
                    </td>
                    <td>
                        <%=item.user_view %>
                    </td>
                    <td>
                        <%=item.transform_rate %>
                    </td>
                    <td>
                        <%=item.sale_price %> 元
                    </td>
                    <td>
                        <%=item.sale_num%>
                    </td>
                    <td>
                        <%=item.sale_money %> 元
                    </td>
                    <td>
                        <%=item.stock_num %>
                    </td>
                </tr>
                <%
                    _count++;
             }
                %>
            </tbody>
        </table>
        <%=ViewData["pageIndexLink2"]%>
      
        </form>
    </div>
    </div>
<script type="text/javascript">
var _currUrl="<%=ViewData["currPageUrl"]%>";
    function formatUrl(ocol, val, url) {
        if (!url) url = _currUrl;
        var reg = ocol + "=[^-]*";
        var reg = new RegExp(ocol + "=[^&\.]*");
        url = url.replace(reg, ocol + "=" + val);
        return url;
    }
    var changeOrderBy = function (ocol, ot) {
        _currUrl = formatUrl("ocol", ocol);
        url = formatUrl("ot", ot);
        window.location.href = url;
    };
</script>

<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>

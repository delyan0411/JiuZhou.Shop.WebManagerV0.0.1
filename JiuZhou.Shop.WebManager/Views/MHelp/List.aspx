<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="JiuZhou.Model" %>
<%@ Import Namespace="JiuZhou.Common" %>
<%@ Import Namespace="JiuZhou.MySql" %>
<%@ Import Namespace="JiuZhou.HttpTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <%Html.RenderPartial("Base/_PageHeadControl"); %>
    <link href="/style/style.css" rel="stylesheet" type="text/css" />
    <title><%=ViewData["pageTitle"]%></title>
</head>
<body>
    <%Html.RenderPartial("Base/_SimplePageTopControl"); %>
    <%
        string nodeIndex = DoRequest.GetQueryString("node");
        ConfigInfo config = (ConfigInfo)(ViewData["config"]);
        List<HelpTypeInfo> tList = new List<HelpTypeInfo>();
        var restype = GetHelpType.Do(0, 2, -1);
        if (restype != null && restype.Body != null && restype.Body.help_type_list != null)
            tList = restype.Body.help_type_list;
    %>

    <div id="container-syscp">
        <div class="container-left">
            <%Html.RenderPartial("Base/LeftControl"); %>
        </div>
        <div class="container-right">
            <div class="position">
                当前位置：
                <a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>文章列表</span>
            </div>
            <form action="/mhelp/list" method="get" onsubmit="checksearch(this)">
                <input type="hidden" name="size" value="<%=DoRequest.GetQueryInt("size", 100)%>" />
                <div class="div-tab-h1" style="font-weight: 100; color: #333; font-size: 12px">
                    <p>
                        <select id="stype" name="classid" style="width: 80px">
                            <option value="0" init="true">所有分类</option>
                            <%
                                List<HelpTypeInfo> _items = tList.FindAll(
                                        delegate (HelpTypeInfo em)
                                        {
                                            return em.parent_id == 1;
                                        });
                                foreach (HelpTypeInfo em in _items)
                                {
                                    Response.Write("<option value=\"" + em.help_type_id + "\">" + em.type_name + "</option>");
                                }
                            %>
                        </select>
                    </p>
                    <p>
                        <input type="text" id="sQuery" name="q" value="<%=DoRequest.GetQueryString("q")%>" class="input" autocomplete="off" style="width: 390px; height: 24px; line-height: 24px;" />
                    </p>
                    <p>
                        <input type="submit" value=" 搜索 " class="submit" />&nbsp;&nbsp;
                    </p>
                </div>
            </form>
            <script type="text/javascript">
var qInitValue="请输入关键词";
Atai.addEvent(window,"load",function(){
	dropSType=new _DropListUI({
		input: Atai.$("#stype")
	});dropSType.maxHeight="260px";dropSType.width="120px";
	dropSType.init();dropSType.setDefault("<%=DoRequest.GetQueryInt("classid", 0)%>");

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
var _currUrl="<%=ViewData["currPageUrl"]%>";
function formatUrl(ocol, val, url){
	if(!url) url=_currUrl;
	var reg = ocol + "=[^-]*";
	var reg = new RegExp(ocol + "=[^&\.]*");
	url = url.replace(reg, ocol + "=" + val);
	return url;
}
var changeOrderBy=function(ocol,ot){
	_currUrl=formatUrl("ocol",ocol);
	url=formatUrl("ot",ot);
	window.location.href=url;
};
            </script>
            <%string otype = DoRequest.GetQueryString("ot").ToLower().Trim();
            %>
            <%=ViewData["pageIndexLink"]%>
            <form id="post-form" method="post" action="">
                <table id="tab-category" class="table" cellpadding="0" cellspacing="0">
                    <thead>
                        <tr>
                            <th style="width: 3%">
                                <input type="checkbox" onclick="checkAll(this.form,this)" name="chkall" title="选中/取消选中" /></th>
                            <th>标题</th>
                            <th style="width: 14%">添加时间</th>
                            <th style="width: 6%">排序</th>
                            <th style="width: 6%">状态</th>
                            <th style="width: 10%">添加者</th>
                            <th style="width: 10%">操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<ShortHelpInfo> infoList = (List<ShortHelpInfo>)ViewData["infoList"];
                            foreach (ShortHelpInfo item in infoList)
                            {
                                DateTime addTime = DateTime.Parse(item.add_time);
                                string classPath = "";
                                HelpTypeInfo hCateg = new HelpTypeInfo();
                                foreach (HelpTypeInfo c in tList)
                                {
                                    if (c.help_type_id == item.help_type_id)
                                    {
                                        classPath = c.type_path;
                                        hCateg = c; break;
                                    }
                                }
                                string[] _tem = classPath.Split(',');
                                //tList
                        %>
                        <tr>
                            <td>
                                <input type="checkbox" onclick="selectOne(this)" name="visitid" value="<%=item.help_id%>" /></td>
                            <td><a href="/mhelp/editor?typeid=<%=item.help_type_id%>" target="_blank"><%=item.help_title%></a>
                                <p style="color: #999">
                                    <%
                                        Response.Write(classPath);
                                        int _xCount = 0;
                                        for (int x = 0; x < _tem.Length; x++)
                                        {
                                            if (string.IsNullOrEmpty(_tem[x].Trim())) continue;
                                            int _v = Utils.StrToInt(_tem[x].Trim());
                                            if (_v == 0)
                                                continue;
                                            foreach (HelpTypeInfo em in tList)
                                            {
                                                if (em.help_type_id == _v)
                                                {
                                                    if (_xCount > 0) Response.Write(" &gt;&gt; ");
                                                    Response.Write(em.type_name);
                                                    _xCount++;
                                                }
                                            }
                                        }
                                    %>
                                </p>
                            </td>

                            <td><%=addTime.ToString("yyyy-MM-dd HH:mm")%></td>
                            <td>
                                <input type="text" class="input" style="width: 30px; text-align: center;" onblur="resetSort('<%=item.help_id%>', this.value)" onclick="this.select()" value="<%=item.sort_no%>" /></td>
                            <td><a href="javascript:;" onclick="resetstate(<%=item.help_id %>,<%=item.help_state==0?1:0 %>)"><%=item.help_state==0?"已显示":"<span style='color:red'>已隐藏</span>"%></a></td>
                            <td><%=item.author_name%></td>
                            <td>
                                <a href="/mhelp/editor?typeid=<%=item.help_type_id%>" target="_blank">编辑</a>
                                &nbsp;
    <a href="javascript:;" onclick="return deleteList(<%=item.help_id%>)">删除</a>
                            </td>
                        </tr>
                        <%}
                        %>
                    </tbody>
                </table>
            </form>
            <%=ViewData["pageIndexLink2"]%>
            <div class="console">
                <a href="javascript:;" onclick="deleteList(Atai.$('#post-form'), 0)">批量删除</a>
                <a href="/mhelp/editor?typeid=0">新增</a>
            </div>
            <br />
            <br />
            <br />
            <br />
        </div>

    </div>
    <br />
    <br />
    <br />
    <br />
    <br />
    <script type="text/javascript">
    function resetstate(id, state) {
        
        var postData = "id=" + id + "&state=" + state;
        $.ajax({
            url: "/MHelp/ResetHelpState"
		, data: postData
        , type: "post"
		, dataType: "json"
		, success: function (json) {
		    if (json.error) {
		        jsbox.error(json.message); return false;
		    } else {
		        window.location.href = window.location.href;
		    }
		}
        });
        return false;
    }

function resetSort(id, sortNumber){
	if(!Atai.isInt(sortNumber)) return false;
	var postData="id=" + id + "&sort=" + sortNumber;
	$.ajax({
		url: "/MHelp/ResetHelpSort"
		, data: postData
        , type : "post"
		, dataType: "json"
		, success: function(json){
			if(json.error){
				jsbox.error(json.message);return false;
			}else{
				window.location.href=window.location.href;
			}
		}
	});
	return false;
}

function deleteList(form){
	var postData="";
	if(Atai.isInt(form)){
		postData="visitid=" + form;
	}else{
		postData=getPostDB(form);
	}
	jsbox.confirm('您确定要删除这些数据吗？',function(){
		$.ajax({
			url: "/MHelp/RemoveHelpList"
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
    <%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>

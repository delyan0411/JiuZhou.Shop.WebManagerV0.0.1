<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
	DateTime sDate = DoRequest.GetQueryDate("st", DateTime.Now.AddYears(-3));
    DateTime eDate = DoRequest.GetQueryDate("et", DateTime.Now);
    List<PicTypeList> fClassList = new List<PicTypeList>();
    var restypeall = GetSysFileType.Do(-1);//获取所有分类信息
    if (restypeall != null && restypeall.Body != null && restypeall.Body.type_list != null)
        fClassList = restypeall.Body.type_list;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/style/style.css" rel="stylesheet" type="text/css" />
<%Html.RenderPartial("Base/_PageHeadControl"); %>
<title><%=ViewData["pageTitle"]%></title>
</head>
<body>
<%Html.RenderPartial("Base/_SimplePageTopControl"); %>
<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
		<div class="syscp-head">
<%=ViewData["position"]%>
		</div>
<form action="/Mspace/imgrecycleList" method="get">
	<div class="box-searchForm">
		<p><select name="classid" style="height:28px">
			<option value="3" init="true">--请选择分类--</option>
<%
    List<PicTypeList> items = fClassList.FindAll(
            delegate(PicTypeList em)
            {
				return (em.parent_code.Equals("image"));
		});
	int classId = DoRequest.GetQueryInt("classid", 3);
    if (items == null)
        items = new List<PicTypeList>();
    foreach (PicTypeList em in items)
    {
		Response.Write("<option value=\""+ em.sp_type_id +"\"");
		if(classId==em.sp_type_id){
			Response.Write(" selected=\"selected\"");
		}
		Response.Write(">"+ em.sp_type_name +"</option>");
	}
%>
		</select>
		</p>
		<p>
<input type="text" name="st" value="<%=sDate.ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
至
<input type="text" name="et" value="<%=eDate.ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
		</p>
		<p><input type="text" id="sQuery" name="q" value="<%=DoRequest.GetQueryString("q")%>" class="input" style="width:160px" autocomplete="off"/></p>
		<p><input type="submit" value=" 搜索 " class="submit"/></p>
		<div class="clear"></div>
	</div>
</form>

<%=ViewData["pageIndexLink"]%>
<div class="console" style="position:relative;margin:0 auto;text-align:left;">
	&nbsp;&nbsp;
<span onclick="selectAll(this)" v="all"><i class="chkbox">&nbsp;</i> 全选/取消全选</span>
&nbsp;&nbsp;
<span onclick="reversion(this)" v="rev"><i class="chkbox">&nbsp;</i> 反选</span>
&nbsp;&nbsp;
<a href="javascript:;" onclick="resetStatusList()" class="black">还原图片</a>

</div>
<table class="data-table data-table-none" style="margin-top:3px" cellpadding="0" cellspacing="0">
<tbody>
  
<%
    List<SysFiles> infoList = (List<SysFiles>)ViewData["infoList"];

    if (infoList == null)
        infoList = new List<SysFiles>();
    int _count = 0;
    int _count2 = 1;
    int _totcount = infoList.Count;
    foreach (SysFiles item in infoList)
    {
        if (_count % 4 == 0)
        {
            Response.Write("<tr>");
            _count2 = 1;
        }
            
%>

    <td style="width:20%;">
<div class="list-img-box">
    <input type="hidden" name="fileid" value="<%=item.sp_file_id%>"/>
	<a href="<%=FormatImagesUrl.GetProductImageUrl(item.save_path,-1,-1)%>" target="_blank" class="iLink">
		<i style="background:url(<%=FormatImagesUrl.GetProductImageUrl(item.save_path, 120, 120)%>) center center no-repeat;">&nbsp;</i>
    </a>
    
	<div class="imsg">
<div val="id-<%=item.sp_file_id%>">
<%=item.file_name%>
</div>

<p>分类：<%
string[] _tem = null;
foreach (PicTypeList em in fClassList)
{
    if (em.sp_type_id == item.sp_type_id)
        _tem = em.type_path.Split(',');
}
		int _xCount=0;
		for(int x=0;x<_tem.Length;x++){
			if(string.IsNullOrEmpty(_tem[x].Trim())) continue;
			string _v=_tem[x].Trim();
            foreach (PicTypeList iem in fClassList)
            {
            	if (iem.type_code.Equals(_v)){
					if(_xCount>0) Response.Write(" &gt;&gt; ");
					Response.Write(iem.sp_type_name);
					_xCount++;
            	}
        	}
		}
	%></p>

<p>时间：<%=item.add_time%></p>
<div>
	<a href="javascript:;" value="<%=FormatImagesUrl.GetProductImageUrl(item.save_path,-1,-1)%>" class="copy">复制链接</a>
    &nbsp;&nbsp;&nbsp;&nbsp;
    <a href="javascript:;" class="sLink">选择/取消选择</a>
</div>
	</div>
	<div class="clear">&nbsp;</div><i class="icon-selected">&nbsp;</i>
</div>
    </td>
<%
if (_count2 == 4)
{
    Response.Write("</tr>");
}
if (_count + 1 == _totcount)
{
    var _count3 = _totcount % 4;
    for (int i = 0; i < 4 - _totcount % 4; i++) {
        Response.Write("<td style=\"width:20%;\">&nbsp;</td>");
    }
        Response.Write("</tr>");
}
_count++;
_count2++;
	}
%>

</tbody>
</table>
<%=ViewData["pageIndexLink2"]%>
<div class="console" style="position:relative;margin:0 auto;text-align:left;">
	&nbsp;&nbsp;
<span onclick="selectAll(this)" v="all"><i class="chkbox">&nbsp;</i> 全选/取消全选</span>
&nbsp;&nbsp;
<span onclick="reversion(this)" v="rev"><i class="chkbox">&nbsp;</i> 反选</span>
&nbsp;&nbsp;
<a href="javascript:;" onclick="resetStatusList()" class="black">还原图片</a>

</div>
<br/><br/>
	</div>
	<div class="clear">&nbsp;</div>
</div>
<div class="clear">&nbsp;</div>
<%Html.RenderPartial("Base/_PageFootControl"); %>
<script type="text/javascript">
    function selectAll(o) {
        var isSelect = false;
        var obj = "*[v='" + $(o).attr("v") + "']";
        if ($(obj).hasClass("selected")) {
            isSelect = false;
            $(obj).removeClass("selected")
        } else {
            isSelect = true;
            $(obj).addClass("selected");
        }
        $(".list-img-box").each(function () {
            if (isSelect) {
                $(this).addClass("list-img-box-selected");
            } else {
                $(this).removeClass("list-img-box-selected");
            }
        });
    }
    function reversion(o) {
        var isSelect = false;
        var obj = "*[v='" + $(o).attr("v") + "']";
        if ($(obj).hasClass("selected")) {
            isSelect = false;
            $(obj).removeClass("selected")
        } else {
            isSelect = true;
            $(obj).addClass("selected");
        }
        $(".list-img-box").each(function () {
            if (!$(this).hasClass("list-img-box-selected")) {
                $(this).addClass("list-img-box-selected");
            } else {
                $(this).removeClass("list-img-box-selected");
            }
        });
    }
    $(function () {
        $(".list-img-box .sLink").click(function () {
            var o = $(this).parent().parent().parent();
            if (o.hasClass("list-img-box-selected")) {
                o.removeClass("list-img-box-selected");
                $("*[v='all']").removeClass("selected")
            } else {
                o.addClass("list-img-box-selected");
            }
        });
    });
    function resetStatusList() {
        var msg = "您确定要把这些图片放入回收吗？";
        jsbox.ask(msg
		, function () {
		    var ids = [];
		    $(".list-img-box").each(function () {
		        if ($(this).hasClass("list-img-box-selected")) {
		            ids.push($(this).find("input[name='fileid']").val());
		        }
		    });
		    //alert(ids.join(","));return false;
		    $.ajax({
		        url: "/MSpace/ResetFileStatus"
				, type: "post"
				, data: {
				    visitid: ids.join(","),
                    visible: 1
				}
				, dataType: "json"
				, success: function (json, textStatus) {
				    if (json.error) {
				        jsbox.error(json.message);
				    } else {
				        window.location.reload();
				    }
				}, error: function (http, textStatus, errorThrown) {
				    jsbox.error(errorThrown);
				}
		    });
		});
        return false;
    }
</script>
</body>
</html>
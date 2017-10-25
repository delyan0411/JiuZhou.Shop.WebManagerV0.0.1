<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %><%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
    int accessid = DoRequest.GetQueryInt("accessid");
    %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
&nbsp;&nbsp;&nbsp;&nbsp;
<a href="javascript:void();" onclick="postAccessResource()" style="color:#00F;font-size:17px;">保存</a>
		</div>
<script language="c#" runat="server">
    
    List<UserResBody> sysNodes = QueryResource.Do(0, -1).Body.resource_list;
    
	int tree=0;
	public void PrintList(int parentId){
		if (parentId < 0) return;
        if (sysNodes == null)
            sysNodes = new List<UserResBody>();
        List<UserResBody> items = sysNodes.FindAll(delegate(UserResBody item) { return item.parent_id == parentId; });
        if (items.Count <= 0) return;
        bool isHasChild = false;
        Response.Write("<ul>");
		isHasChild = true;
        foreach (UserResBody item in items)
        {
			string[] arr=item.res_path.Split(',');
			tree=arr.Length - 1;
			bool isRemove=(item.res_state.GetHashCode()!=0);
            Response.Write("<li rid=\"" + item.parent_id + "\" prid=\"" + item.res_id + "\" " + (isRemove ? " class=\"delete\"" : "") + ">");
			Response.Write("<div tree=\"" + tree + "\"><a href=\"javascript:;\" v=\"bt\" class='jslk'>&nbsp;</a>");
            Response.Write("<input type=\"checkbox\" name=\"sele\" value=\"" + item.res_id + "\" pid=\"" + item.parent_id + "\" issel=\"0\" onchange=\"checkthis(this)\"/> <a href=\"javascript:;\" v=\"bt\" node=\"" + item.res_id + "-name\" class=\"name\">" + item.res_name + "</a> <span node=\"" + item.res_id + "-sort\" style=\"color:#999\">(" + item.sort_no + ")</span>");

			Response.Write("</div>");
			PrintList(item.res_id);
			Response.Write("</li>\r\n");
		}
		if (isHasChild) Response.Write("</ul>\r\n");
	}
</script>
<div id="class-list">
<%PrintList(0);%>
</div>
	</div>
	<div class="clear">&nbsp;</div><br/><br/>
</div>
<div class="clear">&nbsp;</div>

<script type="text/javascript">
    $(function () {
        _list = new _list_utils();
        _list.isopen = true;
        _list.opentree = 3;
        _list.init(document.getElementById("class-list"));
    });
</script>
<script type="text/javascript">
 $(function () {
        $.ajax({
            url: "/musers/GetAccessResource"
		, type: "post"
		, data: { "id":<%=accessid %>}
        , async: false
		, dataType: "json"
		, success: function (json, textStatus) {
		   if(json.error){
           
           }else{
               var arr = json.access;
   
               $("input[name='sele']").each(function(){
                   if(arr.contains(Number($(this).val()))){
                       $(this).attr("checked",true);
                       $(this).attr("issel",1);
                   }
               });
           }
		}, error: function (http, textStatus, errorThrown) {
		    //jsbox.error("error");
		}
        });
        return false;
    });
   
    function checkthis(obj) {
        if (obj.checked) {
            $(obj).attr("checked", true);
            $(obj).attr("issel", 1);
            var rid = Number($(obj).val());
            $("li[rid='" + rid + "'] input:checkbox").each(function () {
                var a = $(this).attr("checked");
                if ($(this).attr("checked") != "checked") {
                    $(this).click();
                }
            });
            var pid = Number($(obj).attr("pid"));
            if($("li[prid='"+ pid +"'] input:checkbox").attr("checked") != "checked"){
               $("li[prid='"+ pid +"'] input:checkbox")[0].checked=true;
               $("li[prid='"+ pid +"'] input[value='"+ pid +"']").attr("issel", 1);
                }
        } else {
            $(obj).attr("checked", false);
            $(obj).attr("issel", 0);
            var rid = Number($(obj).val());
            $("li[rid='" + rid + "'] input:checkbox").each(function () {
                if ($(this).attr("checked") == "checked") {
                    $(this).click();
                }
            });
        }

    }
 
    function createXmlDocument(nodes){
	    var xml='<?xml version="1.0" encoding="utf-8"?>';
	    xml += '<items>';
	    for(var i=0;i<nodes.length;i++){
	    	xml += nodes[i];
	    }
	    xml += '</items>';
	    return xml;
    }

    function createXmlNode(resid, issel){
	    return '<item resid="'+ resid +'" isselect="'+ issel +'"/>';
    }
    function postAccessResource(){
        var nodes=[];
	    $("input[name='sele']").each(function(){
             nodes.push(createXmlNode($(this).val(), $(this).attr("issel")));
        });
		    
        var xml = createXmlDocument(nodes);
        $.ajax({
		url: "/Musers/PostAccessResourceData"
		, data: {"xml": encodeURIComponent(xml),"id":<%=accessid %>}
		, dataType: "json"
        , type: "post"
		, success: function(json){
			if(json.error){
				jsbox.error(json.message);
			}else{
				jsbox.success(json.message, window.location.href);
			}
			if(closeLoadding) closeLoadding();
		}
	});
	return false;
    }
</script>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>

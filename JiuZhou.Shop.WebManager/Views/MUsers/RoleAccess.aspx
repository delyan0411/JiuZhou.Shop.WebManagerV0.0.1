<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %><%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
    List<AccessInfo> list = (List<AccessInfo>)ViewData["infolist"];
    int roleid = DoRequest.GetQueryInt("roleid");
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
<a href="javascript:void();" onclick="postRoleAccess()" style="color:#00F;font-size:17px;">保存</a>
		</div>
         
<div id="class-list">
<ul>
<%
    int tree = 0;
    foreach (AccessInfo item in list)
    {
        if (item.parent_id == 0)
        {
            tree = item.access_path.Split(',').Length - 1;
            Response.Write("<li rid=\"0\" prid=\"" + item.access_id + "\">");
            Response.Write("<div tree=\"" + tree + "\"><a href=\"javascript:;\" v=\"bt\" class='jslk'>&nbsp;</a>");
            Response.Write("<input type=\"checkbox\" name=\"sele\" value=\"" + item.access_id + "\" pid=\"" + item.parent_id + "\" issel=\"0\" onchange=\"checkthis(this)\"/> <a href=\"javascript:;\" v=\"bt\" node=\"" + item.access_id + "-name\" class=\"name\">" + item.access_name + "</a> <span node=\"" + item.access_id + "-sort\" style=\"color:#999\">(" + item.sort_no + ")</span>");
            Response.Write("</div>");
            Response.Write("<ul>");
            foreach (AccessInfo em in list) {
                if (em.parent_id == item.access_id)
                {
                    tree = em.access_path.Split(',').Length - 1;
                    Response.Write("<li rid=\"" + item.access_id + "\" prid=\"" + em.access_id + "\" class=\"xline\">");
                    Response.Write("<div tree=\"" + tree + "\"><a href=\"javascript:;\" v=\"bt\" class='jslk'>&nbsp;</a>");
                    Response.Write("<input type=\"checkbox\" name=\"sele\" value=\"" + em.access_id + "\" issel=\"0\" pid=\"" + em.parent_id + "\" onchange=\"checkthis(this)\"/> <a href=\"javascript:;\" v=\"bt\" node=\"" + em.access_id + "-name\" class=\"name\">" + em.access_name + "</a> <span node=\"" + em.access_id + "-sort\" style=\"color:#999\">(" + em.sort_no + ")</span>");
                    Response.Write("</div>");
                    List<AccessInfo> item2 = list.FindAll(delegate(AccessInfo em3) { return em3.parent_id == em.access_id; });
                    if (item2 != null && item2.Count > 0)
                    {
                        Response.Write("<ul>");
                        foreach (AccessInfo em2 in item2)
                        {
                            if (em2.parent_id == em.access_id)
                            {
                                tree = em2.access_path.Split(',').Length - 1;
                                Response.Write("<li rid=\"" + em.access_id + "\" prid=\"" + em2.access_id + "\" class=\"xline\">");
                                Response.Write("<div tree=\"" + tree + "\"><a href=\"javascript:;\" v=\"bt\" class='jslk'>&nbsp;</a>");
                                Response.Write("<input type=\"checkbox\" name=\"sele\" value=\"" + em2.access_id + "\" pid=\"" + em2.parent_id + "\" issel=\"0\" onchange=\"checkthis(this)\"/> <a href=\"javascript:;\" v=\"bt\" node=\"" + em2.access_id + "-name\" class=\"name\">" + em2.access_name + "</a> <span node=\"" + em2.access_id + "-sort\" style=\"color:#999\">(" + em2.sort_no + ")</span>");
                                Response.Write("</div>");
                                Response.Write("</li>\r\n");
                            }
                        }
                        Response.Write("</ul>");
                    }
                    Response.Write("</li>\r\n");
                }
            }
            Response.Write("</ul>");
            Response.Write("</li>\r\n");
        }
    }
%>
</ul>
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

    $(function () {
        $.ajax({
            url: "/musers/GetRoleAccess"
		, type: "post"
		, data: { "id":<%=roleid %>}
        , async: false
		, dataType: "json"
		, success: function (json, textStatus) {
		   if(json.error){
           
           }else{
               var arr = [];
               for(var i=0;i<json.role.length;i++){
                   arr.push(json.role[i].access_id);
               }
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

    function checkthis(obj){
         if (obj.checked) {
            $(obj).attr("checked", true);
            $(obj).attr("issel",1);
            var rid = Number($(obj).val());
            $("li[rid='"+ rid +"'] input:checkbox").each(function(){
            var a =$(this).attr("checked");
            if($(this).attr("checked")!="checked"){
                // $(this).attr("checked", true);
               //  $(this).attr("issel",1);
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
            $(obj).attr("issel",0);
            var rid = Number($(obj).val());
            $("li[rid='"+ rid +"'] input:checkbox").each(function(){
                 if($(this).attr("checked")=="checked"){
                //$(this).attr("checked", false);
               // $(this).attr("issel",0);
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

    function createXmlNode(accessid, issel){
	    return '<item accessid="'+ accessid +'" isselect="'+ issel +'"/>';
    }
    function postRoleAccess(){
        var nodes=[];
	    $("input[name='sele']").each(function(){
             nodes.push(createXmlNode($(this).val(), $(this).attr("issel")));
        });
		    
        var xml = createXmlDocument(nodes);
        $.ajax({
		url: "/Musers/PostRoleAccessData"
		, data: {"xml": encodeURIComponent(xml),"id":<%=roleid %>}
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

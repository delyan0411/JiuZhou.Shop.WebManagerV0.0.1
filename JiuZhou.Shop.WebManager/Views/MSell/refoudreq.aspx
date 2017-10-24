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
    <title>
        <%=ViewData["pageTitle"]%></title>
</head>
<body>
    <%Html.RenderPartial("Base/_SimplePageTopControl"); %>
    <%
        ConfigInfo config = (ConfigInfo)(ViewData["config"]);
    %>
    <div id="container-syscp">
        <div class="position">
            当前位置： <a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>退换货申请</span>
        </div>
        <form action="/msell/refoudreq" method="get" onsubmit="checksearch(this)">
        <div class="div-tab-h1" style="font-weight: 100; color: #333; font-size: 12px">
            <p>
                <select id="sel-type" name="type" style="width: 120px; height: 26px;">
                    <option value="-1">所有状态</option>
                    <option value="0">未处理</option>
                    <option value="1">已处理</option>
                    <option value="2">关闭</option>
                </select>
            </p>
            <p>
                <%
                    DateTime date = DateTime.Now.AddMonths(-1);
                %><input type="text" name="sDate" value="<%=DoRequest.GetQueryDate("sDate", date).ToString("yyyy-MM-dd")%>"
                    readonly="readonly" class="date" onclick="WdatePicker()" />
                至
                <input type="text" name="eDate" value="<%=DoRequest.GetQueryDate("eDate", DateTime.Now).ToString("yyyy-MM-dd")%>"
                    readonly="readonly" class="date" onclick="WdatePicker()" />
            </p>
            <p>
                <input type="text" id="sQuery" name="q" value="<%=DoRequest.GetQueryString("q")%>"
                    class="input" autocomplete="off" /></p>
            <p>
                <input type="submit" value=" 搜索 " class="submit" />
            </p>
        </div>
        </form>
        <script type="text/javascript">
var qInitValue="请输入关键词";
Atai.addEvent(window,"load",function(){


$(function(){
   var seltype = <%=DoRequest.GetQueryInt("type", -1)%>;
   $("#sel-type option[value='" + seltype + "']").attr("selected",true);
});



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
                    <th>
                        退换货原因
                    </th>
                    <th style="width: 8%">
                        提交时间
                    </th>
                     <th style="width: 10%">
                        订单号
                    </th>
                    <th style="width: 12%">
                        联系号码
                    </th>
                    <th style="width: 10%">
                        用户帐号
                    </th>
                     <th style="width: 8%">
                        状态
                    </th>                  
                    <th style="width: 8%">
                        操作
                    </th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<RefoudReqInfo> infoList = (List<RefoudReqInfo>)ViewData["infoList"];
                    if (infoList == null)
                        infoList = new List<RefoudReqInfo>();                    
                    foreach (RefoudReqInfo item in infoList)
                    {
                %>
                <tr>
                    <td style="word-wrap: break-word; word-break: break-all;">
                            <%=item.refoudreq_reason%>{处理结果:<%=item.refoudresp_reason%>}<br />
                    </td>
                    <td>
                    <%=item.refoudreq_time%><br />
                    </td>
                    <td>
                        <a href="/msell/orderItem?ordernumber=<%=item.order_no%>" target="_blank">
                            <%=item.order_no%></a>
                    </td>
                    <td>
                        <%=item.refoudreq_phone%>
                    </td>
                    <td>
                     <a href="/musers/editor?uid=<%=item.user_id%>" target="_blank">
                            <%=item.user_id%></a>
                    </td>
                    <td>
                    <%if (item.state == "1")
                      {%>
                        未处理 
                           <%}
                      else if (item.state == "2")
                      {%>
                       已处理
                      <%}
                      else
                      { %>
                      已关闭
                      <%} %>
                    </td>
                    <td>
                        <a href="javascript:;" onclick="replyBox(event,'<%=item.id%>','<% = item.refoudresp_reason %>','<%=item.state %>')">
                            回复</a>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
        <%=ViewData["pageIndexLink2"]%>
        </form>
    </div>
    <script type="text/javascript">

    function changePage(val){
	var url=formatUrl("page", val);
	window.location.href=url;
}



    var _currUrl="<%=ViewData["currPageUrl"]%>";
    function formatUrl(ocol, val, url){
	if(!url) url=_currUrl;
	var reg = ocol + "=[^-]*";
	var reg = new RegExp(ocol + "=[^&\.]*");
	url = url.replace(reg, ocol + "=" + val);
	return url;
   };

function ResetCommentStatus(commentid,state){
	var postData="commentid=" + commentid;
    postData+="&state=" + state;
    var msg=(state!=1?"您确定要显示评论吗？":"您确定要将评论隐藏吗？");    
	jsbox.confirm(msg,function(){
		$.ajax({
			url: "/MSell/ResetCommentStatus"
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


function postCommetReply(form){
    var commetid= $(_replyBoxDialog.dialog).find("#otp-commentid").val();
    var content=$(_replyBoxDialog.dialog).find("#txt_commetcontent").val();
    var state=$(_replyBoxDialog.dialog).find("#state").val();
     if (showLoadding)  showLoadding();
    if(content.length>0)
    {
    var postData="commentid=" + commetid;
    postData+="&content=" + content;
    postData+="&state=" + state;
	$.ajax({
			url: "/msell/RefoudReqReply"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function(json){
				if(json.error){
					$(_replyBoxDialog.dialog).find("span[class='tips-text']").html(json.message);return false;
				}else{
					window.location.href=window.location.href;
				}
                if (closeLoadding) closeLoadding();
			}
	});
    }
    else{
    	$(_replyBoxDialog.dialog).find("span[class='tips-text']").html("回复不能为空");
        if (closeLoadding) closeLoadding();
        return false;
    }
    	return false;
}
//删除回复
function delCommetReply(commetid){
    var postData="commentid=" + commetid;
    var msg="你确认要删除该评论的回复吗?";
    jsbox.confirm(msg,function(){
	$.ajax({
			url: "/msell/DeleteCommetReply"
			, data: postData
            , type: "post"
			, dataType: "json"
			, success: function(json){
				if(json.error){
					jsbox.error(json.message);return false;
				}else{
					jsbox.success(json.message,window.location.href);
				}
			}
	    });
    });
	return false;
}

var _replyBoxDialog = false;
function replyBox(event,commetid,content,state){

	var boxId="#reply-boxControl";
	var box = Atai.$(boxId);
	var _dialog = false;
	if (!_dialog)
	    _dialog = new AtaiShadeDialog();
	_dialog.init({
	    obj: boxId
		, sure: function () { }
		, CWCOB: true
	});
	_replyBoxDialog=_dialog;

    $(_replyBoxDialog.dialog).find("#otp-commentid").val(commetid);
    $(_replyBoxDialog.dialog).find("#txt_commetcontent").val(content);
    if(state=="1")
    $(_replyBoxDialog.dialog).find("#state [value=2]").attr("selected", true);
    else
    $(_replyBoxDialog.dialog).find("#state [value="+state+"]").attr("selected", true);
	return false;
}
    </script>
    <div id="reply-boxControl" class="moveBox" style="height: 300px; width: 420px;">
        <div class="name">
            处理退换货
            <div class="close" v="atai-shade-close" title="关闭">
                &nbsp;</div>
        </div>
        <form action="" onsubmit="return postCommetReply(this)">
        <input type="hidden" id="otp-commentid" name="commentid" value="" />
        <table width="100%" border="0" cellspacing="0" cellpadding="2">
            <tbody>
                <tr>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        <textarea cols="10" rows="20" style="height: 140px; width: 390px" id="txt_commetcontent"
                            name="txt_commetcontent"></textarea>
                    </td>
                </tr>
                <tr>
                    <td>
                        <select id="state" name="state" style="height: 28px;">
                            <option value="0" >关闭</option>
                            <option value="2" selected="selected">处理完成</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="submit" id="loadding3" class="submit" value="  保 存  " />
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="tips-text" style="color: #ff6600">&nbsp;</span>
                    </td>
                </tr>
            </tbody>
        </table>
        </form>
    </div>
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>

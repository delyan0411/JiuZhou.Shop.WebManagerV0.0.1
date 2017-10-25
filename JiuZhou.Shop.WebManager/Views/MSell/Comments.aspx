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
    %>
    <div id="container-syscp">
   
        <div class="position">
            当前位置： <a href="/" title="管理首页">管理首页</a> &gt;&gt; <span>评论列表</span>
        </div>
        <form action="/msell/comments" method="get" onsubmit="checksearch(this)">
        <div class="div-tab-h1" style="font-weight: 100; color: #333; font-size: 12px">
            <p>
                <select id="sel-star" name="star" style="width: 120px;height:26px;">
                    <option value="-1">所有评分</option>
                    <option value="3">好评</option>
                    <option value="2">中评</option>
                    <option value="1">差评</option>
                </select>
            </p>
            <p>
                <select id="sel-status" name="state" style="width: 120px;height:26px;">
                    <option value="-1">所有状态</option>
                    <option value="1">隐藏</option>
                    <option value="0">显示</option>
                </select>
            </p>
            <p>
                 <select id="sel-type" name="type" style="width: 120px;height:26px;">
                    <option value="-1">所有状态</option>
                    <option value="0">用户评价</option>
                    <option value="1">自动生成</option>
                    <option value="2">客服刷单</option>
                </select>
            </p>
            <p>
<%
	DateTime date = DateTime.Now.AddMonths(-1);
%><input type="text" name="sDate" value="<%=DoRequest.GetQueryDate("sDate", date).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
至
<input type="text" name="eDate" value="<%=DoRequest.GetQueryDate("eDate", DateTime.Now).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
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
   var selstar = <%=DoRequest.GetQueryInt("star", -1)%>;
   var selstatus = <%=DoRequest.GetQueryInt("state", -1)%>;
   var seltype = <%=DoRequest.GetQueryInt("type", -1)%>;
   $("#sel-star option[value='" + selstar + "']").attr("selected",true);
   $("#sel-status option[value='" + selstatus + "']").attr("selected",true);
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
        <%
            string otype = DoRequest.GetQueryString("ot").ToLower().Trim();
        %>
        <table id="tab-category" class="table" cellpadding="0" cellspacing="0">
            <thead>
                <tr>
                    <th style="width: 3%">
                        <input type="checkbox" onclick="checkAll(this.form,this)" name="chkall" title="选中/取消选中" />
                    </th>
                    <th>
                        评论
                    </th>
                    <th style="width: 8%">
                        评论类别
                    </th>
                    <th style="width: 12%">
                        订单号
                    </th>
                    <th style="width: 10%">
                        帐号
                    </th>
                    <th style="width: 7%">
                        <a href="javascript:;" onclick="changeOrderBy('USERMARK','<%=otype=="asc"?"desc":"asc"%>')">
                            评价等级</a>
                    </th>
                    <th style="width: 6%">
                        <a href="javascript:;" onclick="changeOrderBy('REPLAYSTATE','<%=otype=="asc"?"desc":"asc"%>')">
                            状态</a>
                    </th>
                    <th style="width: 10%">
                        <a href="javascript:;" onclick="changeOrderBy('ADDTIME','<%=otype=="asc"?"desc":"asc"%>')">
                            添加时间</a>
                    </th>
                    <th style="width: 8%">
                        操作
                    </th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<CommentInfo> infoList = (List<CommentInfo>)ViewData["infoList"];
                    if (infoList == null)
                        infoList = new List<CommentInfo>();
                    foreach (CommentInfo item in infoList)
                    {
                %>
                <tr>
                    <td>
                        <input type="checkbox" <% if(item.comment_state==0) {%><% Response.Write("disabled=true");} %>
                            onclick="selectOne(this)" name="visitid" value="<%=item.product_comment_id%>" />
                    </td>
                    <td style="word-wrap: break-word;word-break: break-all;">
                        <a href="<%=config.UrlHome%><%=item.product_id%>.html" target="_blank">
                            <%=item.comment_content%></a><br />
                        <% if (item.reply_user_id != null && !item.reply_user_id.Equals("") && !item.reply_user_id.Equals("0") && !item.reply_text.Equals(""))
                           { 
                           %>
                        <% Response.Write("<span style=\"width: 98%; margin: 5px auto; background: #FFF3D9; padding: 2px; color: #333;\"><strong style=\"color: #ff6600;\">回复：" + item.reply_text + "&nbsp;&nbsp;&nbsp;<span>" + DateTime.Parse(item.reply_time).ToString("yyyy-MM-dd HH:mm:ss") + "</span></strong> </span>&nbsp;&nbsp;&nbsp;<a style='color:red' href=\"javascript:;\" onclick=\"delCommetReply('" + item.product_comment_id + "')\">删除</a>");%>
                        <%} %>
                    </td>
                    <td>
                    <% 
                        string commenttype = "未知";
                        switch (item.auto_comment)
                        { 
                            case 0:
                                commenttype = "用户评论";
                                break;
                            case 1:
                                commenttype = "自动评论";
                                break;
                            case 2:
                                commenttype = "客服评论";
                                break;
                            default:
                                break;
                        }  
                            %>
                            <%=commenttype%>
                    </td>
                    <td>
                        <a href="/msell/orderItem?ordernumber=<%=item.order_no%>" target="_blank">
                            <%=item.order_no%></a>
                    </td>
                    <td>
                        <%=item.comment_user_name%>
                    </td>
                    <td>
                    <% 
                       switch (item.user_mark)
                       { 
                           case 1:
                               Response.Write("<span style='color:red; font-size:12px;'>差评</span>");
                               break;
                           case 2:
                               Response.Write("<span style='color:yellow;font-size:12px;'>中评</span>");
                               break;
                           case 3:
                               Response.Write("<span style='color:green;font-size:12px;'>好评</span>");
                               break;
                           default:
                               Response.Write("<span style='color:#999;font-size:12px;'>未知</span>");
                                    break;                         
                       } %>
                    </td>
                    <td>
                        <%
                            switch (item.comment_state)
                            {
                                case 1:
                                    if (item.reply_user_id != null && !item.reply_user_id.Equals("0") && !item.reply_user_id.Equals(""))
                                    {
                                        Response.Write("<span style='color:green;font-size:12px;'>已回复</span>");
                                    }
                                    else
                                    {
                                        Response.Write("<span style='color:#999;font-size:12px;'>未回复</span>");
                                    }
                                    break;
                                case 0:
                                    Response.Write("<span style='color:red;font-size:12px;'>已隐藏</span>");
                                    break;
                                default:
                                    Response.Write("<span style='color:#999;font-size:12px;'>未知</span>");
                                    break;
                            }
                        %>
                    </td>
                    <td>
                       <a> <%=DateTime.Parse(item.add_time).ToString("yyyy-MM-dd HH:mm")%></a>
                    </td>
                    <td>
                        <a href="javascript:;" onclick="ResetCommentStatus('<%=item.product_comment_id%>','<% =(item.comment_state==0?1:0) %>')">
                            <% =(item.comment_state == 1 ? "隐藏" : "显示")%>
                        </a><a href="javascript:;" onclick="replyBox(event,'<%=item.product_comment_id%>','<% = (item.reply_user_id != null)?item.reply_text:"" %>')"><%--<% = %><% else %><% ="" %>--%>
                            回复</a>
                    </td>
                </tr>
                <%
}
                %>
            </tbody>
        </table>
        <%=ViewData["pageIndexLink2"]%>
        <div class="div-tab-bottom">
            <span onclick="deleteList(Atai.$('#post-form'))"><b class="icon-remove">&nbsp;</b>隐藏选定项评论</span>
        </div>
        </form>
    </div>
    <script type="text/javascript">

    function changePage(val){
	var url=formatUrl("page", val);
	window.location.href=url;
}

    function deleteList(form) {
        var postData = getPostDB(form);
        jsbox.confirm('您确定要隐藏这些评论吗？', function () {
            $.ajax({
                url: "/msell/ResetCommentStatusList"
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
        });
        return false;
    }
    var changeOrderBy = function (ocol, ot) {
        _currUrl = formatUrl("ocol", ocol);
        url = formatUrl("ot", ot);
        window.location.href = url;
    };
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
     if (showLoadding)  showLoadding();
    if(content.length>0)
    {
    var postData="commentid=" + commetid;
    postData+="&content=" + content;
	$.ajax({
			url: "/msell/CommetReply"
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
function replyBox(event,commetid,content){

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

	return false;
}
    </script>
    <div id="reply-boxControl" class="moveBox" style="height: 260px; width: 420px;">
        <div class="name">
            回复评论
            <div class="close" v="atai-shade-close" title="关闭">
                &nbsp;</div>
        </div>
        <form action="" onsubmit="return postCommetReply(this)">
        <input type="hidden" id="otp-commentid" name="commentid" value="" />
        <table width="100%" border="0" cellspacing="0" cellpadding="2">
            <tbody>
            <tr>
            <td>&nbsp;</td>
            </tr>
                <tr>
                    <td>
                        <textarea cols="10" rows="20" style="height: 140px; width: 390px" id="txt_commetcontent"
                            name="txt_commetcontent"></textarea>
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

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

	UpLoadFile upload = new UpLoadFile(false);
	string uploadRoot = upload.GetUploadRoot.StartsWith("/") ? upload.GetUploadRoot.Substring(1) : upload.GetUploadRoot;
    string imageRootUrl = config.UrlImages;

	int tid = DoRequest.GetQueryInt("tid");
    STopicInfo info = new STopicInfo();
    var resst = GetTopicInfoById.Do(tid);
    if (resst != null && resst.Body != null)
        info = resst.Body;
	if(info.st_id<1){
		info.st_dir="";
		info.start_time = DateTime.Now.ToString("yyyy-MM-dd") + " 00:00:00";
		info.end_time = (DateTime.Parse(info.start_time).AddDays(8).AddSeconds(-1)).ToString();
	}
%>
<div id="container-syscp">

<div class="position">
当前位置：
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <a href="/mpromotions?">专题列表</a> &gt;&gt; <span>新增专题</span>
</div>
<form action="" method="post" onsubmit="return submitForm(this)">
<input type="hidden" name="TID" value="<%=info.st_id%>"/>
		<div class="div-tab">
<table id="tab-category" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr style="display:none">
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</thead>
<tbody>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable" valign="top">专题名称
        <b>*</b>
       
    </td>
      <td class="inputText" style="width: 500px">
          <input type="text" name="subject" value="<%=info.st_subject%>" class="input" style="width: 464px" /><br />
          &nbsp; 
        <%if (info.st_id == 0)
            {%>
          <label>手机端</label><input type="radio" value="1" name="type" />
          <label>PC端</label><input type="radio" value="0" name="type" checked="checked" />
          <%}
              else
              {
                  if (info.type == 0)
                  { %>
        PC端
        <%}
            else
            { %>
        手机端
        <%} %>
          <%} %>
      </td>
    <td class="lable" valign="top">专题目录<b>*</b></td>
    <td class="inputText" colspan="2">
    <input type="text" name="seoCode" value="<%=info.st_dir%>" class="input" style="width:160px"/>
    2到30个字符，限数字、字母、中横线(-)，建议用拼音<br/>
    示例：输入 <span style="color:#00F">zhongqiu</span> 
        
        则专题的网址为 <span style="color:#00F"><%=config.UrlHome%>hdzt/<%=DateTime.Now.ToString("yyyy")%>/zhongqiu/</span>
        则专题的手机端网址为 <span style="color:#00F"><%=config.UrlMobile%>festival/zhongqiu/</span>
    </td>
  </tr>

  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable" valign="top">专题图标<b>*</b></td>
    <td class="inputText" valign="top">
    <input type="hidden" id="upload-image" name="image" value="<%=info.pic_src%>" />
<div id="upload-image-box" class="upload-image-box" style="width:260px;height:260px;line-height:260px;cursor:default;">
暂无图片
</div>
<div class="upload-image-box-botton" style="color:#666;">
&nbsp;<input type="button" class="view-file" onclick="ajaxUploadClick(Atai.$('#upload-image-box'),Atai.$('#upload-image'))" value="浏览..."/>
<br/><br/>
<p>&nbsp;<a href="javascript:;" onclick="showImageListBox(setImage)" style="color:blue">从图片库中选择</a></p>
<br/>
<p>&nbsp;图片尺寸应不小于 360(宽)×360(高)</p>
<p>&nbsp;最佳的图片尺寸为 800(宽)×800(高)</p>
</div>
    </td>
    <td class="lable" colspan="3" valign="top" style="width:auto;">
<p>
开始时间<b>*</b>&nbsp;
    <input type="text" id="box-sdate" name="sdate" value="<%=DateTime.Parse(info.start_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
	<input type="text" id="box-shours" name="shours" value="<%=DateTime.Parse(info.start_time).ToString("HH")%>" class="input" style="width:40px" title="数字0至23" onblur="checkInputInt(this, 0, 23)"/> 时
    <input type="text" id="box-sminutes" name="sminutes" value="<%=DateTime.Parse(info.start_time).ToString("mm")%>" class="input" style="width:40px" title="数字0至59" onblur="checkInputInt(this, 0, 59)"/> 分
</p>
<p style="margin-top:12px">
结束时间<b>*</b>&nbsp;
    <input type="text" id="box-edate" name="edate" value="<%=DateTime.Parse(info.end_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
	<input type="text" id="box-ehours" name="ehours" value="<%=DateTime.Parse(info.end_time).ToString("HH")%>" class="input" style="width:40px" title="数字0至23" onblur="checkInputInt(this, 0, 23)"/> 时
    <input type="text" id="box-eminutes" name="eminutes" value="<%=DateTime.Parse(info.end_time).ToString("mm")%>" class="input" style="width:40px" title="数字0至59" onblur="checkInputInt(this, 0, 59)"/> 分
</p>
<p style="margin-top:12px">
页面标题&nbsp;&nbsp;
<input type="text" name="seoName" value="<%=info.seo_title%>" class="input" style="width:390px;"/>
</p>
<p style="margin-top:12px">
页面关键词&nbsp;
<input type="text" name="seoKeywords" value="<%=info.seo_key%>" class="input" style="width:390px;"/>
</p>
<p style="margin-top:12px">
<div style="float:left;width:78px">页面描述</div>
<div style="float:left"><textarea name="seoSummary" class="textarea" style="height:88px;width:390px"><%=info.seo_text%></textarea></div>
</p>
<div class="clear"></div>
    </td>
  </tr>

  <tr>
    <td colspan="6" style="height:8px;line-height:8px">&nbsp;</td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable" valign="top">页面样式</td>
    <td class="inputText" colspan="4">
    <textarea name="styleText" class="textarea" style="height:80px;width:984px"><%=info.style_text%></textarea>
    </td>
  </tr>
  <tr>
    <td colspan="6" style="height:8px;line-height:8px">&nbsp;</td>
  </tr>

  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable" valign="top">专题介绍<b>*</b></td>
    <td class="inputText" colspan="4">
    <textarea name="summary" class="textarea" style="height:180px;width:984px"><%=info.st_summary%></textarea>
    </td>
  </tr>

  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">&nbsp;</td>
    <td class="inputText" colspan="4"><input type="submit" value="确定保存" class="submit"/>&nbsp;&nbsp;
    <span class="tips-text" id="tips-message" style="display:inline-block;width:896px">&nbsp;</span>
    </td>
  </tr>
  </tbody>
</table>
		</div>
</form>
</div>

<script type="text/javascript">
function submitForm(form){
	var postData=getPostDB(form);
	$.ajax({
		url: "/MPromotions/PostTopic"
		, data: postData
        , type: "post"
		, dataType: "json"
		, success: function(json){
			//alert(json);return false;
			//obj.className = "tips-text tips-icon";
			if(json.error){
				jsbox.error(json.message);
			}else{
				jsbox.success(json.message,window.location.href);
			}
		}
	});
	return false;
}

function setImage(path,fullPath){
	Atai.$("#upload-image").value=path;
	var _uploadImageBox=Atai.$("#upload-image-box");
	var path=formatImageUrl(fullPath, 360, 360);
	_uploadImageBox.style.background="url(" + path + ") center center no-repeat";
	_uploadImageBox.innerHTML="";
}//imageRootUrl
<%if(!string.IsNullOrEmpty(info.pic_src)){%>Atai.addEvent(window,"load",function(){
	setImage('<%=info.pic_src%>','<%=info.pic_src%>');
});<%}%>
</script>
<br/><br/><br/><br/><br/><br/>
<br/><br/><br/>
<%Html.RenderPartial("UploadBaseControl"); %>
<%Html.RenderPartial("ImageListBoxControl");//图片选择 %>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body></html>

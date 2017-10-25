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
	int posId = DoRequest.GetQueryInt("posid");
    //RecommendPositionInfo pos = GetRecommendPositionById.Do(posId).Body;
%>
<div id="container-syscp">
<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
</div>
<div class="container-right">
<div class="position">
当前位置：
<a href="/" title="管理首页">管理首页</a> &gt;&gt; <a href="/mpolymeric/list?posid=<%=0%>" title="<%=0%>">已推荐列表</a> &gt;&gt; <span>新增推荐</span>
</div>
<form method="post" onsubmit="return submitForm(this)">
<input type="hidden" name="PosID" value="<%=0%>"/>
		<div class="div-tab">
<table id="tab-category" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr style="display:none">
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</thead>
<tbody>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">位置<b>*</b></td>
    <td class="inputText"><input type="text" name="position" value="" class="input" /></td>
    <td><div class="tips-text" id="tips-subject" title="  1-30个字符">  1-30个字符</div></td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">文件<b>*</b></td>
    <td class="inputText">
    <input type="text" id="upload-excel" name="excel" value="" class="input" readonly="readonly" onclick="ajaxUploadEBookClick(this,Atai.$('#upload-excel'),Atai.$('#tips-submit-result'))"style="width:223px"/>
    <input type="button" class="view-file" onclick="$('#upload-excel').click()" value="浏览..."/>
    </td>
    <td><div class="tips-text"><a href="/documment/excel/template-polymeric.xls" style="color:#0000FF">点击此处下载模板</a> 请按照规范上传推荐作品的 EXCEL文件 </div></td>
  </tr>

  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">开始时间<b>*</b></td>
    <td class="inputText">
    <input type="text" id="box-sdate" name="sdate" value="<%=DateTime.Now.ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
	<input type="text" id="box-shours" name="shours" value="00<%//=DateTime.Now.ToString("HH")%>" class="input" style="width:40px" title="数字0至23"/> 时
    <input type="text" id="box-sminutes" name="sminutes" value="00<%//=DateTime.Now.ToString("mm")%>" class="input" style="width:40px" title="数字0至59"/> 分
<script type="text/javascript">
Atai.addEvent(window,"load",function(){
	var hBox=Atai.$("#box-shours");
	var mBox=Atai.$("#box-sminutes");
	var tips=Atai.$("#tips-starttime");
	Atai.addEvent(hBox,"blur",function(){
		if(!Atai.isInt(this.value) || parseInt(this.value)<0 || parseInt(this.value)>23){
			tips.className="tips-icon";
			tips.innerHTML=" [时] 请填写0至23之间的数字";
		}
	});
	Atai.addEvent(mBox,"blur",function(){
		if(!Atai.isInt(this.value) || parseInt(this.value)<0 || parseInt(this.value)>59){
			tips.className="tips-icon";
			tips.innerHTML=" [分] 请填写0至59之间的数字";
		}
	});
	Atai.addEvent(hBox,"keyup",function(){
		if(Atai.isInt(this.value) && parseInt(this.value)>=0 &&  parseInt(this.value)<24){
			tips.className="tips-text";tips.innerHTML="";
		}
	});
	Atai.addEvent(mBox,"keyup",function(){
		if(Atai.isInt(this.value) && parseInt(this.value)>=0 &&  parseInt(this.value)<60){
			tips.className="tips-text";tips.innerHTML="";
		}
	});
});
</script>
    </td>
    <td><div class="tips-text" id="tips-starttime">&nbsp;</div></td>
  </tr>

  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">结束时间<b>*</b></td>
    <td class="inputText">
    <input type="text" id="box-edate" name="edate" value="<%=DateTime.Now.AddDays(7).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
	<input type="text" id="box-ehours" name="ehours" value="23<%//=DateTime.Now.AddDays(7).ToString("HH")%>" class="input" style="width:40px" title="数字0至23"/> 时
    <input type="text" id="box-eminutes" name="eminutes" value="59<%//=DateTime.Now.AddDays(7).ToString("mm")%>" class="input" style="width:40px" title="数字0至59"/> 分
<script type="text/javascript">
Atai.addEvent(window,"load",function(){
	var hBox=Atai.$("#box-ehours");
	var mBox=Atai.$("#box-eminutes");
	var tips=Atai.$("#tips-endtime");
	Atai.addEvent(hBox,"blur",function(){
		if(!Atai.isInt(this.value) || parseInt(this.value)<0 || parseInt(this.value)>23){
			tips.className="tips-icon";
			tips.innerHTML=" [时] 请填写0至23之间的数字";
		}
	});
	Atai.addEvent(mBox,"blur",function(){
		if(!Atai.isInt(this.value) || parseInt(this.value)<0 || parseInt(this.value)>59){
			tips.className="tips-icon";
			tips.innerHTML=" [分] 请填写0至59之间的数字";
		}
	});
	Atai.addEvent(hBox,"keyup",function(){
		if(Atai.isInt(this.value) && parseInt(this.value)>=0 &&  parseInt(this.value)<24){
			tips.className="tips-text";tips.innerHTML="";
		}
	});
	Atai.addEvent(mBox,"keyup",function(){
		if(Atai.isInt(this.value) && parseInt(this.value)>=0 &&  parseInt(this.value)<60){
			tips.className="tips-text";tips.innerHTML="";
		}
	});
});
</script>
    </td>
    <td><div class="tips-text" id="tips-endtime">&nbsp;</div></td>
  </tr>

  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable" valign="top">摘要</td>
    <td colspan="2" class="inputText">
  <textarea name="summary" class="textarea" style="height:160px"></textarea>
    </td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">&nbsp;</td>
    <td class="inputText"><input type="submit" value="确定提交" class="submit"/></td>
    <td><div class="tips-text" id="tips-submit-result" title="">&nbsp;</div></td>
  </tr>
  </tbody>
</table>
		</div>
</form>
</div>
</div>
<br/><br/><br/><br/><br/><br/>
<br/><br/><br/>
<script type="text/javascript">
function submitForm(form){
	var obj=Atai.$("#tips-subject");
	obj.className = "tips-text";
	obj.innerHTML = "";
	if(showLoadding) showLoadding();
	var postData=getPostDB(form);
	$.ajax({
		url: "/MPolymeric/PostPolymericList"
		, data: postData
        , type: "post"
		, dataType: "json"
		, success: function(json){
			//alert(json);return false;
			obj.className = "tips-text tips-icon";
			if(json.error){
				obj.innerHTML=json.message;
			}else{
				obj.className = "tips-text";
				jsbox.success(json.message,window.location.href);
			}
			if(closeLoadding) closeLoadding();
		}
	});
	return false;
}
</script>
<%Html.RenderPartial("UploadFilesControl"); %>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body></html>
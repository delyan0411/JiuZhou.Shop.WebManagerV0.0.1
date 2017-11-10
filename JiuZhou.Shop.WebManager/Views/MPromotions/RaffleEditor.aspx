<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="/ckeditor/ckeditor.js" charset="utf-8"></script>
<link href="/style/style.css" rel="stylesheet" type="text/css" />
<%Html.RenderPartial("Base/_PageHeadControl"); %>
<title><%=ViewData["pageTitle"]%></title>
<style>
.table-head{width:100%;}
.table-head thead th{background:#f3f5ea;border-bottom:#dbe0cb 1px solid;text-align:center;height:26px;line-height:26px;padding:0;}
.table-head th{border:#dbe0cb 1px solid;border-left:0;border-bottom:0;font-weight:100;}
.table-head tbody td{border-right:#ddd 1px solid;border-bottom:#ddd 1px solid;text-align:center;line-height:22px;}
.table-head tbody td .input{width:40px;text-align:center;}
</style>
</head>

<body>
<%Html.RenderPartial("Base/_SimplePageTopControl"); %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
    int activityid = DoRequest.GetQueryInt("activityid");
    AwardActivityInfo Info = null;
    var resp = GetAwardActivityInfo.Do(activityid);
    if (resp == null || resp.Body == null)
    {
        Info = new AwardActivityInfo();
    }else{
        Info = resp.Body;
    }

    //List<ConvertIntergralRuleInfo> listinfo = new List<ConvertIntergralRuleInfo>();

    // var res= GetConvertIntergralRule.Do();
    List<UseCouponRuleInfo> listinfo = new List<UseCouponRuleInfo>();

    var res= GetUseCouponRule.Do();
    if (res != null && res.Body != null && res.Body.coupon_rule_list != null)
    {
        listinfo = res.Body.coupon_rule_list;
    }
    string couponvalue = "";
    string couponmiaosshu = "";
    for(var i=0; i< listinfo.Count;i++) {
        if (i == 0)
        {
            couponvalue = listinfo[i].coupon_price.ToString();
            couponmiaosshu = listinfo[i].coupon_price + "元-满" + listinfo[i].min_price + "使用";
        }
        else {
            couponvalue = couponvalue + "," + listinfo[i].coupon_price.ToString();
            couponmiaosshu = couponmiaosshu + "," + listinfo[i].coupon_price + "元-满" + listinfo[i].min_price + "使用";
        }
    }
%>
<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
		<div class="editor-box-head" style="position:relative">
编辑抽奖活动
		</div>
		<div class="div-tab">
<form id="awardactivityForm" method="post" action="" onsubmit="return submitAwardActivityForm(this)">
<input type="hidden" name="activityid" value="<%=activityid%>"/>
<table class="table" cellpadding="0" cellspacing="0">
<thead>

</thead>
<tbody>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">名&nbsp;&nbsp;称<b>*</b></td>
    <td class="inputText"><input type="text" name="name" must="1" value="<%=Info.activity_name%>" class="input" style="width:320px" /></td>
    <td>
    &nbsp;
    </td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">活动介绍<b>*</b></td>
    <td class="inputText" colspan="2">
      <textarea id="activitydesc" name="activitydesc" class="textarea" must="1" style="height:160px" ><%=Info.activity_desc %></textarea>
    </td>
  </tr>
    <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">手机活动介绍<b>*</b></td>
    <td class="inputText" colspan="2">
      <textarea id="phoneactivitydesc" name="phoneactivitydesc" class="textarea" must="1" style="height:160px" ><%=Info.phone_activity_desc %></textarea>
    </td>
  </tr>
    <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">奖品介绍<b>*</b></td>
    <td class="inputText" colspan="2">
      <textarea id="awarddesc" name="awarddesc" class="textarea" must="1" style="height:160px" ><%=Info.award_desc%></textarea>
    </td>
  </tr>
       <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">手机奖品介绍<b>*</b></td>
    <td class="inputText" colspan="2">
      <textarea id="phoneawarddesc" name="phoneawarddesc" class="textarea" must="1" style="height:160px" ><%=Info.phone_award_desc%></textarea>
    </td>
  </tr>
  <script type="text/javascript">
      var ckeditor1 = null;
      var ckeditor2 = null;
      var ckeditor3 = null;
      var ckeditor4 = null;
      $(function () {
          ckeditor1 = CKEDITOR.replace('activitydesc');
          ckeditor2 = CKEDITOR.replace('awarddesc');
          ckeditor3 = CKEDITOR.replace('phoneactivitydesc');
          ckeditor4 = CKEDITOR.replace('phoneawarddesc');
      });
      function setImage(path, fullPath, id, editor) {
          var html = '<img src="' + fullPath + '"/>';
          //jsbox.error(CKEDITOR.currentInstance.name);
          editor.insertHtml(html);
      }
      function setImage4(obj, path, fullPath, editor) {
          setImage(path, fullPath, 0, editor);
      }
      function _fckCallback(editor) {
          showImageListBox(setImage, 0, editor);
      }
      function _fckAddPicCallback(editor) {
          upload(new Object(), setImage4, "", "", editor);
      }
</script>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">活动背景</td>
    <td class="inputText" valign="top">
      <input type="hidden" id="upload-image1" name="activitybgimg" value="<%=Info.activity_bg_img %>" />
      <div id="upload-image-box1" class="upload-image-box" style="width:160px;height:160px;line-height:160px;" onclick="ajaxUploadClick(this,Atai.$('#upload-image1'))">
        暂无图片
      </div>
      <div class="upload-image-box-botton" style="color:#666;">
      &nbsp;<input type="button" class="view-file" onclick="$('#upload-image-box1').click()" value="浏览..."/>
      <br/><br/>
      <p>&nbsp;<a href="javascript:;" onclick="showImageListBox(setImage1)" style="color:blue">从图片库中选择</a></p>
      </div>
<script type="text/javascript">
function setImage1(path,fullPath){
	Atai.$("#upload-image1").value=path;
	var _uploadImageBox=Atai.$("#upload-image-box1");
	var path=formatImageUrl(fullPath, 160, 160);
	_uploadImageBox.style.background="url(" + path + ") center center no-repeat";
	_uploadImageBox.innerHTML="";
}//imageRootUrl
<%if(!string.IsNullOrEmpty(Info.activity_bg_img)){%>Atai.addEvent(window,"load",function(){
	setImage1('<%=Info.activity_bg_img%>','<%=Info.activity_bg_img%>');
});<%}%>
</script>
    </td>
    <td>
      <span style="color:red">*注意：</span> 图片为1920px*267px
    </td>
  </tr>
    <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">手机活动背景</td>
    <td class="inputText" valign="top">
      <input type="hidden" id="upload-image4" name="phoneactivitybgimg" value="<%=Info.phone_activity_bg_img %>" />
      <div id="upload-image-box4" class="upload-image-box" style="width:160px;height:160px;line-height:160px;" onclick="ajaxUploadClick(this,Atai.$('#upload-image4'))">
        暂无图片
      </div>
      <div class="upload-image-box-botton" style="color:#666;">
      &nbsp;<input type="button" class="view-file" onclick="$('#upload-image-box4').click()" value="浏览..."/>
      <br/><br/>
      <p>&nbsp;<a href="javascript:;" onclick="showImageListBox(setImage10)" style="color:blue">从图片库中选择</a></p>
      </div>
<script type="text/javascript">
    function setImage10(path, fullPath) {
	Atai.$("#upload-image4").value=path;
	var _uploadImageBox=Atai.$("#upload-image-box4");
	var path=formatImageUrl(fullPath, 160, 160);
	_uploadImageBox.style.background="url(" + path + ") center center no-repeat";
	_uploadImageBox.innerHTML="";
}//imageRootUrl
<%if(!string.IsNullOrEmpty(Info.phone_activity_bg_img)){%>Atai.addEvent(window,"load",function(){
    setImage10('<%=Info.phone_activity_bg_img%>', '<%=Info.phone_activity_bg_img%>');
});<%}%>
</script>
    </td>
    <td>
      <span style="color:red">*注意：</span> 图片高为未知
    </td>
  </tr>
    <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">奖品背景<b>*</b></td>
    <td class="inputText" valign="top">
      <input type="hidden" id="upload-image2" name="awardbgimg" value="<%=Info.award_bg_img %>" />
      <div id="upload-image-box2" class="upload-image-box" style="width:160px;height:160px;line-height:160px;" onclick="ajaxUploadClick(this,Atai.$('#upload-image2'))">
        暂无图片
      </div>
      <div class="upload-image-box-botton" style="color:#666;">
      &nbsp;<input type="button" class="view-file" onclick="$('#upload-image-box2').click()" value="浏览..."/>
      <br/><br/>
      <p>&nbsp;<a href="javascript:;" onclick="showImageListBox(setImage2)" style="color:blue">从图片库中选择</a></p>
      </div>
<script type="text/javascript">
function setImage2(path,fullPath,type){
	Atai.$("#upload-image2").value=path;
	var _uploadImageBox=Atai.$("#upload-image-box2");
	var path=formatImageUrl(fullPath, 160, 160);
	_uploadImageBox.style.background="url(" + path + ") center center no-repeat";
	_uploadImageBox.innerHTML="";
}//imageRootUrl
<%if(!string.IsNullOrEmpty(Info.award_bg_img)){%>Atai.addEvent(window,"load",function(){
	setImage2('<%=Info.award_bg_img%>','<%=Info.award_bg_img%>');
});<%}%>
</script>
    </td>
    <td>
       <span style="color:red">*注意：</span> 图片尺寸需为：450*450，12点方向为第一个商品，逆时针顺序排列商品
    </td>
  </tr>
    <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">手机奖品背景<b>*</b></td>
    <td class="inputText" valign="top">
      <input type="hidden" id="upload-image5" name="phoneawardbgimg" value="<%=Info.phone_award_bg_img %>" />
      <div id="upload-image-box5" class="upload-image-box" style="width:160px;height:160px;line-height:160px;" onclick="ajaxUploadClick(this,Atai.$('#upload-image5'))">
        暂无图片
      </div>
      <div class="upload-image-box-botton" style="color:#666;">
      &nbsp;<input type="button" class="view-file" onclick="$('#upload-image-box5').click()" value="浏览..."/>
      <br/><br/>
      <p>&nbsp;<a href="javascript:;" onclick="showImageListBox(setImage5)" style="color:blue">从图片库中选择</a></p>
      </div>
<script type="text/javascript">
    function setImage5(path, fullPath, type) {
	Atai.$("#upload-image5").value=path;
	var _uploadImageBox=Atai.$("#upload-image-box5");
	var path=formatImageUrl(fullPath, 160, 160);
	_uploadImageBox.style.background="url(" + path + ") center center no-repeat";
	_uploadImageBox.innerHTML="";
}//imageRootUrl
<%if(!string.IsNullOrEmpty(Info.phone_award_bg_img)){%>Atai.addEvent(window,"load",function(){
	setImage5('<%=Info.phone_award_bg_img%>','<%=Info.phone_award_bg_img%>');
});<%}%>
</script>
    </td>
    <td>
       <span style="color:red">*注意：</span> 图片尺寸需为：weizhi*weizhi，12点方向为第一个商品，逆时针顺序排列商品
    </td>
  </tr>
      <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">转盘背景<b>*</b></td>
    <td class="inputText" valign="top">
      <input type="hidden" id="upload-image3" name="dialbgimg" value="<%=Info.dial_bg_img %>" />
      <div id="upload-image-box3" class="upload-image-box" style="width:160px;height:160px;line-height:160px;" onclick="ajaxUploadClick(this,Atai.$('#upload-image3'))">
        暂无图片
      </div>
      <div class="upload-image-box-botton" style="color:#666;">
      &nbsp;<input type="button" class="view-file" onclick="$('#upload-image-box3').click()" value="浏览..."/>
      <br/><br/>
      <p>&nbsp;<a href="javascript:;" onclick="showImageListBox(setImage3)" style="color:blue">从图片库中选择</a></p>
      </div>
<script type="text/javascript">
function setImage3(path,fullPath,type){
	Atai.$("#upload-image3").value=path;
	var _uploadImageBox=Atai.$("#upload-image-box3");
	var path=formatImageUrl(fullPath, 160, 160);
	_uploadImageBox.style.background="url(" + path + ") center center no-repeat";
	_uploadImageBox.innerHTML="";
}//imageRootUrl
<%if(!string.IsNullOrEmpty(Info.dial_bg_img)){%>Atai.addEvent(window,"load",function(){
	setImage3('<%=Info.dial_bg_img%>','<%=Info.dial_bg_img%>');
});<%}%>
</script>
    </td>
    <td>
      <span style="color:red">*注意：</span> 图片尺寸需为：1000*826，奖品区位置离左边175px,离顶端107px
    </td>
  </tr>
    <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">手机转盘背景<b>*</b></td>
    <td class="inputText" valign="top">
      <input type="hidden" id="upload-image6" name="phonedialbgimg" value="<%=Info.phone_dial_bg_img %>" />
      <div id="upload-image-box6" class="upload-image-box" style="width:160px;height:160px;line-height:160px;" onclick="ajaxUploadClick(this,Atai.$('#upload-image6'))">
        暂无图片
      </div>
      <div class="upload-image-box-botton" style="color:#666;">
      &nbsp;<input type="button" class="view-file" onclick="$('#upload-image-box6').click()" value="浏览..."/>
      <br/><br/>
      <p>&nbsp;<a href="javascript:;" onclick="showImageListBox(setImage6)" style="color:blue">从图片库中选择</a></p>
      </div>
<script type="text/javascript">
    function setImage6(path, fullPath, type) {
	Atai.$("#upload-image6").value=path;
	var _uploadImageBox=Atai.$("#upload-image-box6");
	var path=formatImageUrl(fullPath, 160, 160);
	_uploadImageBox.style.background="url(" + path + ") center center no-repeat";
	_uploadImageBox.innerHTML="";
}//imageRootUrl
<%if(!string.IsNullOrEmpty(Info.phone_dial_bg_img)){%>Atai.addEvent(window,"load",function(){
	setImage6('<%=Info.phone_dial_bg_img%>','<%=Info.phone_dial_bg_img%>');
});<%}%>
</script>
    </td>
    <td>
      <span style="color:red">*注意：</span> 图片尺寸需为：未知*未知，奖品区位置离左边未知px,离顶端未知px
    </td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">开始时间<b>*</b></td>
    <td class="inputText">
    <input type="text" id="box-sdate" name="sdate" value="<%=Info.begin_time==null?DateTime.Now.ToString("yyyy-MM-dd"):DateTime.Parse(Info.begin_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
	<input type="text" id="box-shours" name="shours" value="<%=Info.begin_time==null?"00":DateTime.Parse(Info.begin_time).Hour.ToString()%>" class="input" style="width:30px" title="数字0至23"/> 时
    <input type="text" id="box-sminutes" name="sminutes" value="<%=Info.begin_time==null?"00":DateTime.Parse(Info.begin_time).Minute.ToString()%>" class="input" style="width:30px" title="数字0至59"/> 分
<script type="text/javascript">
    Atai.addEvent(window, "load", function () {
        var hBox = Atai.$("#box-shours");
        var mBox = Atai.$("#box-sminutes");
        var tips = Atai.$("#tips-starttime");
        Atai.addEvent(hBox, "blur", function () {
            if (!Atai.isInt(this.value) || parseInt(this.value) < 0 || parseInt(this.value) > 23) {
                tips.className = "tips-icon";
                tips.innerHTML = " [时] 请填写0至23之间的数字";
            }
        });
        Atai.addEvent(mBox, "blur", function () {
            if (!Atai.isInt(this.value) || parseInt(this.value) < 0 || parseInt(this.value) > 59) {
                tips.className = "tips-icon";
                tips.innerHTML = " [分] 请填写0至59之间的数字";
            }
        });
        Atai.addEvent(hBox, "keyup", function () {
            if (Atai.isInt(this.value) && parseInt(this.value) >= 0 && parseInt(this.value) < 24) {
                tips.className = "tips-text"; tips.innerHTML = "";
            }
        });
        Atai.addEvent(mBox, "keyup", function () {
            if (Atai.isInt(this.value) && parseInt(this.value) >= 0 && parseInt(this.value) < 60) {
                tips.className = "tips-text"; tips.innerHTML = "";
            }
        });
    });
</script></td>
    <td><div class="tips-text" id="tips-starttime">&nbsp;</div></td>
  </tr>

  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">结束时间<b>*</b></td>
    <td class="inputText">
    <input type="text" id="box-edate" name="edate" value="<%=Info.end_time==null?DateTime.Now.AddDays(7).ToString("yyyy-MM-dd"):DateTime.Parse(Info.end_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
	<input type="text" id="box-ehours" name="ehours" value="<%=Info.begin_time==null?"23":DateTime.Parse(Info.end_time).Hour.ToString()%>" class="input" style="width:30px" title="数字0至23"/> 时
    <input type="text" id="box-eminutes" name="eminutes" value="<%=Info.begin_time==null?"59":DateTime.Parse(Info.begin_time).Minute.ToString()%>" class="input" style="width:30px" title="数字0至59"/> 分
<script type="text/javascript">
    Atai.addEvent(window, "load", function () {
        var hBox = Atai.$("#box-ehours");
        var mBox = Atai.$("#box-eminutes");
        var tips = Atai.$("#tips-endtime");
        Atai.addEvent(hBox, "blur", function () {
            if (!Atai.isInt(this.value) || parseInt(this.value) < 0 || parseInt(this.value) > 23) {
                tips.className = "tips-icon";
                tips.innerHTML = " [时] 请填写0至23之间的数字";
            }
        });
        Atai.addEvent(mBox, "blur", function () {
            if (!Atai.isInt(this.value) || parseInt(this.value) < 0 || parseInt(this.value) > 59) {
                tips.className = "tips-icon";
                tips.innerHTML = " [分] 请填写0至59之间的数字";
            }
        });
        Atai.addEvent(hBox, "keyup", function () {
            if (Atai.isInt(this.value) && parseInt(this.value) >= 0 && parseInt(this.value) < 24) {
                tips.className = "tips-text"; tips.innerHTML = "";
            }
        });
        Atai.addEvent(mBox, "keyup", function () {
            if (Atai.isInt(this.value) && parseInt(this.value) >= 0 && parseInt(this.value) < 60) {
                tips.className = "tips-text"; tips.innerHTML = "";
            }
        });
    });
</script>
    </td>
    <td><div class="tips-text" id="tips-endtime">&nbsp;</div></td>
  </tr>

</tbody>
</table>
</form>

<script type="text/javascript">
function addRuleTable(){
    var html = '<table v="table-rules" class="table-rules" cellpadding="0" cellspacing="0" style="margin-top:20px">';
    html += '<input type="hidden" name="ruleid" value="0"/>';
    html += '<thead><tr><th colspan="2" style="width:90%;">兑换规则 <b style="color:#F00">*</b>&nbsp;&nbsp;<span name="ruletips" style="color:red"></span></th><th style="text-align:right">';
    html += '<a href="javascript:;" onclick="removeRules(this)" style="color:#999">删除规则</a></th></tr></thead>';

    html += '<tbody>';

	html += '<tr><td style="width:3%"></td>';
	html += '<td class="inputText" colspan="2">';
	html += '兑换类型：&nbsp;';
	html += '<select name="ruletype" style="height:26px;">';
	html += '<option value="0">积分兑换(废弃)</option><option value="1">订单金额</option></select>';
	html += '&nbsp;&nbsp;相 应 值：&nbsp;<input type="text" name="corrvalue" value="" class="input" style="width:60px;"/>';
	html += '&nbsp;&nbsp;抽奖次数：<input type="text" name="lotterynum" value="" class="input" style="width:40px;"/></td></tr>';

	html += '<tr><td style="width:3%"></td>';
	html += '<td class="inputText" colspan="2">';
	html += '开始时间：&nbsp;<input type="text" name="rulesdate" value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>" readonly="readonly" class="date" onclick="WdatePicker()"/>';
	html += '<input type="text" name="ruleshours" value="00" class="input" style="width:30px" title="数字0至23" onblur="checkhour(this)"/> 时';
	html += '<input type="text" name="rulesminutes" value="00" class="input" style="width:30px" title="数字0至59" onblur="checkminute(this)"/> 分';
	html += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
	html += '结束时间：&nbsp;<input type="text" name="ruleedate" value="<%=DateTime.Now.AddDays(7).ToString("yyyy-MM-dd") %>" readonly="readonly" class="date" onclick="WdatePicker()"/>';
	html += '<input type="text" name="ruleehours" value="23" class="input" style="width:30px" title="数字0至23" onblur="checkhour(this)"/> 时';
	html += '<input type="text" name="ruleeminutes" value="59" class="input" style="width:30px" title="数字0至59" onblur="checkminute(this)"/> 分</td></tr>';

	html += '</tbody>';
	html += '</table>';

	$("#raffle-rules").append(html);
}
function addAwards() {
    var html = '<tr class="awardstr">';
    html += '<td><input type="hidden" name="awardid" value="0" /><input type="text" name="awardname" value="" class="input" style="width:100px;"/></td>';

    html += '<td><select name="awardtype" style="height:26px;" onchange="selectedthis(this)">';
    html += '<option value="1" >优惠券</option><option value="2">积&nbsp;分</option><option value="3">商&nbsp;品</option></select></td>';
    var _couponvalue = "<%=couponvalue %>".split(','); 
    var _couponmiaosshu ="<%=couponmiaosshu %>".split(',');  
    html += '<td><input type="text" name="awardvalue" value="" class="input" hidden="hidden" style="width:50px;"/>';
    html += '<select name="sawardvalue" style="width:60px;height:26px;">';
    for (var i = 0; i < _couponvalue.length; i++) {
        html += '<option value=' + _couponvalue[i] + '>' + _couponmiaosshu[i] + '</option>';
    }
    html += '</select></td>';
    html += '<td><input type="text" name="awardpercent" value="" class="input" style="width:40px;"/> %</td>';
    html += '<td><input type="text" name="awardnum" value="" class="input" style="width:30px;"/></td>';
    html += '<td><input type="text" name="givenum" value="0" class="input" readonly="readonly" style="width:30px;"/></td>';

    html += '<td class="move-links">';
    html += '<a href="javascript:void(0);" onclick="moveRow(this,\'first\');" class="move-first" title="置顶">&nbsp;</a>';
    html += '\n<a href="javascript:void(0);" onclick="moveRow(this,\'up\');" class="move-up" title="上移">&nbsp;</a>';
    html += '\n<a href="javascript:void(0);" onclick="moveRow(this,\'down\');" class="move-down" title="下移">&nbsp;</a>';
    html += '\n<a href="javascript:void(0);" onclick="moveRow(this,\'last\');" class="move-last" title="最末">&nbsp;</a>';
    html += '</td>';

    html += '<td><a href="javascript:;" onclick="changestate(this)" name="awardstate" value="0">显示</a></td>';

    html += '</tr>';

    $("#awardlist").append(html);
}
function removeRules(obj) {
    jsbox.confirm('您确定要删除此兑换规则吗？', function () {
        var tabObj = $(obj).parent("th").parent("tr").parent("thead").parent("table");
        tabObj.remove();
    });
}
</script>
<div id="raffle-rules">
<%
  if(Info.rule_list == null)
      Info.rule_list = new List<AwardRuleInfo>();
  if(Info.rule_list.Count > 0){
    foreach(AwardRuleInfo rule in Info.rule_list){
%>
<table v="table-rules" class="table-rules" style="margin-top:20px" cellpadding="0" cellspacing="0">
<input type="hidden" name="ruleid" value="<%=rule.award_rule_id %>" />
<thead>
  <tr>
    <th colspan="2" style="width:90%;">兑换规则 <b style="color:#F00">*</b>&nbsp;&nbsp;<span name="ruletips" style="color:red"></span></th>
    <th style="text-align:right"><a href="javascript:;" onclick="removeRules(this)" style="color:#999">删除规则</a></th>
    </th>
  </tr>
</thead>
<tbody>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="inputText" colspan="2">
    兑换类型：
      <select name="ruletype" style="height:26px;">
        <option value="0" <%=rule.rule_type==0?"selected=\"selected\"":"" %>>积分兑换(废弃)</option>
        <option value="1" <%=rule.rule_type==1?"selected=\"selected\"":"" %>>订单金额</option>
      </select>
      &nbsp;&nbsp;
      相 应 值：<input type="text" name="corrvalue" value="<%=rule.corr_value %>" class="input" style="width:60px;"/>
      &nbsp;&nbsp;
      抽奖次数：<input type="text" name="lotterynum" value="<%=rule.lottery_num %>" class="input" style="width:40px;"/>
    </td>
  </tr>
    <tr>
    <td style="width:3%"></td>
    <td class="inputText" colspan="2">
    开始时间：&nbsp;<input type="text" name="rulesdate" value="<%=rule.begin_time==null?DateTime.Now.ToString("yyyy-MM-dd"):DateTime.Parse(rule.begin_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
    <input type="text" name="ruleshours" value="<%=rule.begin_time==null?"00":DateTime.Parse(rule.begin_time).Hour.ToString()%>" class="input" style="width:30px" title="数字0至23" onblur="checkhour(this)"/> 时
    <input type="text" name="rulesminutes" value="<%=rule.begin_time==null?"00":DateTime.Parse(rule.begin_time).Minute.ToString()%>" class="input" style="width:30px" title="数字0至59" onblur="checkminute(this)"/> 分
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    结束时间：&nbsp;<input type="text" name="ruleedate" value="<%=rule.end_time==null?DateTime.Now.AddDays(7).ToString("yyyy-MM-dd"):DateTime.Parse(rule.end_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
    <input type="text" name="ruleehours" value="<%=rule.end_time==null?"23":DateTime.Parse(rule.end_time).Hour.ToString()%>" class="input" style="width:30px" title="数字0至23" onblur="checkhour(this)"/> 时
    <input type="text" name="ruleeminutes" value="<%=rule.end_time==null?"59":DateTime.Parse(rule.end_time).Minute.ToString()%>" class="input" style="width:30px" title="数字0至59" onblur="checkminute(this)"/> 分
    </td>
  </tr>
</tbody>
</table>
<%
	  }
	}else{
%>
<table v="table-rules" class="table-rules" style="margin-top:20px" cellpadding="0" cellspacing="0">
<input type="hidden" name="ruleid" value="0" />
<thead>
  <tr>
    <th colspan="2" style="width:90%">兑换规则 <b style="color:#F00">*</b>&nbsp;&nbsp;<span name="ruletips" style="color:red"></span></th>
    <th style="text-align:right"><a href="javascript:;" onclick="removeRules(this)" style="color:#999">删除规则</a></th>
    </th>
  </tr>
</thead>
<tbody>
  <tr>
    <td style="width:3%"></td>
    <td class="inputText" colspan="2">
    兑换类型：&nbsp;
      <select name="ruletype" style="height:26px;">
        <option value="0">积分兑换(废弃)</option>
        <option value="1">订单金额</option>
      </select>
      &nbsp;&nbsp;
      相 应 值：&nbsp;<input type="text" name="corrvalue" value="" class="input" style="width:60px;"/>
      &nbsp;&nbsp;
      抽奖次数：&nbsp;<input type="text" name="lotterynum" value="" class="input" style="width:40px;"/>
    </td>
  </tr>
  <tr>
    <td style="width:3%"></td>
    <td class="inputText" colspan="2">
    开始时间：&nbsp;<input type="text" name="rulesdate" value="<%=DateTime.Now.ToString("yyyy-MM-dd") %>" readonly="readonly" class="date" onclick="WdatePicker()"/>
    <input type="text" name="ruleshours" value="00" class="input" style="width:30px" title="数字0至23" onblur="checkhour(this)"/> 时
    <input type="text" name="rulesminutes" value="00" class="input" style="width:30px" title="数字0至59" onblur="checkminute(this)"/> 分
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    结束时间：&nbsp;<input type="text" name="ruleedate" value="<%=DateTime.Now.AddDays(7).ToString("yyyy-MM-dd") %>" readonly="readonly" class="date" onclick="WdatePicker()"/>
    <input type="text" name="ruleehours" value="23" class="input" style="width:30px" title="数字0至23" onblur="checkhour(this)"/> 时
    <input type="text" name="ruleeminutes" value="59" class="input" style="width:30px" title="数字0至59" onblur="checkminute(this)"/> 分
    </td>
  </tr>
</tbody>
</table>
<%
	}
%>
</div>
  <script type="text/javascript">
      function checkhour(obj) {
          var a = $(obj).val();
          if (Atai.isInt(a) && parseInt(a) >= 0 && parseInt(a) <= 23) {
              $(obj).closest('.table-rules').find("span[name='ruletips']").html("");
          } else {
              $(obj).closest('.table-rules').find("span[name='ruletips']").html("[时] 请填写0至23之间的数字");
          }
      }

      function checkminute(obj) {
          var b = $(obj).val();
          if (Atai.isInt(b) && parseInt(b) >= 0 && parseInt(b) <= 59) {
              $(obj).closest('.table-rules').find("span[name='ruletips']").html("");
          } else {
              $(obj).closest('.table-rules').find("span[name='ruletips']").html("[分] 请填写0至59之间的数字");
          }
      }
      function selectedthis(obj) {
          if ($(obj).val() == 1) {
              $(obj).parent().parent().find("input[name=awardvalue]").hide();
              $(obj).parent().parent().find("select[name=sawardvalue]").show();
          } else {
              $(obj).parent().parent().find("input[name=awardvalue]").show();
              $(obj).parent().parent().find("select[name=sawardvalue]").hide();
          }
      }

  </script>
<table class="table" cellpadding="0" cellspacing="0">
<tbody>
  <tr>
    <td><strong onclick="addRuleTable()" style="color:#00F;cursor:pointer"><b class="icon-add">&nbsp;</b>增加兑换规则</strong></td>
  </tr>
</tbody>
</table>

<table id="awardtable" v="table-rules" class="table-rules" style="margin-top:20px" cellpadding="0" cellspacing="0">
<input type="hidden" name="ruleid" value="0" />
<thead>
  <tr>
    <th colspan="7" style="width:90%">奖&nbsp;&nbsp;品 <b style="color:#F00">*</b>&nbsp;&nbsp;</th>
    <th style="text-align:right"><a href="javascript:;" onclick="addAwards(this)">添加商品</a></th>
  </tr>
  <tr style="background-color:White">
    <th>奖品名</th>
    <th>类型</th>
    <th>奖值(积分为积分数量,商品为商品ID)</th>
    <th>中奖率</th>
    <th>奖品数</th>
    <th>已发数量</th>
    <th>排序</th>
    <th>状态</th>
  </tr>
</thead>
<tbody id="awardlist">
  <%
      if (Info.award_list == null)
          Info.award_list = new List<AwardInfo>();
      foreach(AwardInfo item in Info.award_list)   { 
  %>
  <tr class="awardstr" rowType="parent">
    <td>
      <input type="hidden" name="awardid" value="<%=item.award_id %>" />
      <input type="text" name="awardname" value="<%=item.award_name %>" class="input" style="width:100px;"/>
    </td>
    <td>
      <select name="awardtype" style="height:26px;" onchange="selectedthis(this)">
        <option value="1" <%=item.award_type==1?"selected=\"selected\"":""%>>优惠券</option>
        <option value="2" <%=item.award_type==2?"selected=\"selected\"":""%>>积&nbsp;分</option>
        <option value="3" <%=item.award_type==3?"selected=\"selected\"":""%>>商&nbsp;品</option>
      </select>
    </td>

    <td>
      <input type="text" name="awardvalue" value="<%=item.award_value %>" <%=(item.award_type != 2 && item.award_type != 3)?"hidden=\"hidden\"":"" %> class="input" style="width:50px;"/>
      <select name="sawardvalue" <%=(item.award_type == 2 || item.award_type == 3)?"hidden=\"hidden\"":"" %> style="width:60px;height:26px;">
      <%
          foreach (UseCouponRuleInfo em in listinfo)
          {    
      %>
        <option value="<%=em.coupon_price %>" <%=em.coupon_price==item.award_value?"selected=\"selected\"":"" %>><%=em.coupon_price %>元-满<%=em.min_price %>使用</option>
        <%} %>
      </select>
    </td>
    <td>
      <input type="text" name="awardpercent" value="<%=item.award_percent %>" class="input" style="width:40px;"/> %
    </td>
     <td>
      <input type="text" name="awardnum" value="<%=item.award_num %>" class="input" style="width:30px;" />
    </td>
    <td>
      <input type="text" name="givenum" value="<%=item.give_num %>" class="input" readonly="readonly" style="width:30px;" />
    </td>
    <td class="move-links">
    <a href="javascript:void(0);" onclick="moveRow(this,'first');" class="move-first" title="置顶">&nbsp;</a>
    <a href="javascript:void(0);" onclick="moveRow(this,'up');" class="move-up" title="上移">&nbsp;</a>
    <a href="javascript:void(0);" onclick="moveRow(this,'down');" class="move-down" title="下移">&nbsp;</a>
    <a href="javascript:void(0);" onclick="moveRow(this,'last');" class="move-last" title="最末">&nbsp;</a>
    </td>
    <td>
      <%
          if(item.award_state == 0){
            Response.Write("<a href=\"javascript:;\" onclick=\"changestate(this)\" name=\"awardstate\" value=\"0\">显示</a>");
          }else{
              Response.Write("<a href=\"javascript:;\" onclick=\"changestate(this)\" name=\"awardstate\" value=\"1\" style=\"color:#aaa\">隐藏</a>");
          }
      %>
    </td>
  </tr>
  <%} %>
</tbody>
</table>
<script type="text/javascript">
    function changestate(obj) {
        var state = parseInt($(obj).attr('value'));
        if (state == 0) {
            $(obj).attr('value','1')
            $(obj).text("隐藏");
            $(obj).css("color", "#aaa");
        } else {
            $(obj).attr('value','0')
            $(obj).text("显示");
            $(obj).css("color", "green");
        }
    }
</script>
<br/>
<table class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:42%">&nbsp;</th>
    <th class="lable"><input type="button" id="loadding3" value="  确定提交  " onclick="$('#awardactivityForm').submit()" class="submit" style="width:120px"/></th>
    <th><div class="tips-text" id="tips-message"></div></th>
  </tr>
</thead>
</table>
		</div>
<br/><br/><br/><br/>
	</div>
</div>
<br/><br/>
<script type="text/javascript">
    var _table = false;
    Atai.addEvent(window, "load", function () {
        var _tab = Atai.$("#awardtable");
        _table = new AtaiTable(_tab);
        _table.firstRowIndex = 1;
    });
    function moveRow(childObj, moveType) {
        _table.moveRow(_table.getRowByChild(childObj).obj, moveType);
        resetRowClassName(_table._table);
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
function submitAwardActivityForm(form) {
	var isError=false;
	$("input[must='1']").each(function(){
		if($(this).val()=="" && !$(this).attr("disabled")){
			isError=true;
		}
	});
	if(isError){
		jsbox.error("请完成所有必填项的填写");return false;
    }
    $("#activitydesc").val(CKEDITOR.instances.activitydesc.getData());
    $("#awarddesc").val(CKEDITOR.instances.awarddesc.getData());
    $("#phoneactivitydesc").val(CKEDITOR.instances.phoneactivitydesc.getData());
    $("#phoneawarddesc").val(CKEDITOR.instances.phoneawarddesc.getData());


	if(showLoadding) showLoadding();

	var postData=getPostDB(form);

	var nodes1=[];
	$("#raffle-rules table[v='table-rules']").each(function () {
	    var ruleid = $(this).find("input[name='ruleid']").val();
	    var ruletype = $(this).find("select[name='ruletype']").val();
	    var corrvalue = $(this).find("input[name='corrvalue']").val();
	    var lotterynum = $(this).find("input[name='lotterynum']").val();
	    var rulesdate = $(this).find("input[name='rulesdate']").val();
	    var ruleshours = $(this).find("input[name='ruleshours']").val();
	    var rulesminutes = $(this).find("input[name='rulesminutes']").val();
	    var ruleedate = $(this).find("input[name='ruleedate']").val();
	    var ruleehours = $(this).find("input[name='ruleehours']").val();
	    var ruleeminutes = $(this).find("input[name='ruleeminutes']").val();
	    var node = '<item ruleid="' + ruleid + '" ruletype="' + ruletype + '" corrvalue="' + corrvalue + '" lotterynum="' + lotterynum + '" rulesdate="' + rulesdate + ' ' + ruleshours + ':' + rulesminutes + ':00" ruleedate="' + ruleedate + ' ' + ruleehours + ':' + ruleeminutes + ':00">';

	    node += '</item>';
	    nodes1.push(node);
	});
	if(nodes1.length<1){
		if(closeLoadding) closeLoadding();
		jsbox.error("请填写至少一个规则");
		if (closeLoadding) closeLoadding();
		return false;
	}
    var xml1 = createXmlDocument(nodes1);

    var nodes2 = [];
    var _count = 1;
    $(".awardstr").each(function () {
        var awardid = $(this).find("input[name='awardid']").val();
        var awardname = $(this).find("input[name='awardname']").val();
        var awardtype = $(this).find("select[name='awardtype']").val();
        var awardvalue = 0;
        if (awardtype == 1)
            awardvalue = $(this).find("select[name='sawardvalue']").val();
        if (awardtype == 2 || awardtype == 3)
            awardvalue = $(this).find("input[name='awardvalue']").val();
        var awardpercent = $(this).find("input[name='awardpercent']").val();
        var awardnum = $(this).find("input[name='awardnum']").val();
        var awardstate = $(this).find("a[name='awardstate']").attr('value');

        var node = '<item awardid="' + awardid + '" awardname="' + awardname + '" awardtype="' + awardtype + '" awardvalue="' + awardvalue + '" awardpercent="' + awardpercent + '" awardnum="' + awardnum + '" awardstate="' + awardstate + '" sortno="' + _count + '">';
        _count++;
        node += '</item>';
        nodes2.push(node);
    });
    if (nodes2.length < 1) {
        if (closeLoadding) closeLoadding();
        jsbox.error("请填写至少一个奖品");
        if (closeLoadding) closeLoadding();
        return false;
    }
    var xml2 = createXmlDocument(nodes2);

	$.ajax({
		url: "/Mpromotions/PostAwardActivity"
		, data: postData + "&xml1=" + encodeURIComponent(xml1) + "&xml2=" + encodeURIComponent(xml2)
        , type: "post"
		, dataType: "json"
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
<%Html.RenderPartial("UploadBaseControl"); %>
<%Html.RenderPartial("UploadImageControl"); %>
<%Html.RenderPartial("ImageListBoxControl");//图片选择 %>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>
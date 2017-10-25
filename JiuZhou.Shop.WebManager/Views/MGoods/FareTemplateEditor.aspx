<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%Html.RenderPartial("Base/_PageHeadControl"); %>
<link href="/style/style.css" rel="stylesheet" type="text/css" />
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
	int tempid=DoRequest.GetQueryInt("tempid");
    FareTempInfo temp = null;
    var resp = GetFareTempList.Do(tempid);
    if (tempid>0 &&(resp == null || resp.Body.fare_temp_list == null))
    {
      Response.Write("<script language=javascript>jsbox.error('数据获取失败！请刷新')</script>");
      temp = new FareTempInfo();
    }else{
        if (tempid == -1)  
        {
            temp = new FareTempInfo();
            temp.template_id = -1;
        }
        else
        {
            temp = resp.Body.fare_temp_list[0];
        }
    }
%>
<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
		<div class="editor-box-head" style="position:relative">
编辑运费模板
		</div>
		<div class="div-tab">
<form id="fareTempForm" method="post" action="" onsubmit="return submitFareTemplateForm(this)">
<input type="hidden" name="tempid" value="<%=temp.template_id%>"/>
<table class="table" cellpadding="0" cellspacing="0">
<tbody>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">名&nbsp;&nbsp;称<b>*</b></td>
    <td class="inputText"><input type="text" name="name" must="1" value="<%=temp.template_name%>" class="input" style="width:320px" /></td>
    <td class="lable">优 先 级<b>*</b></td>
    <td class="inputText">
    <input type="text" name="level" must="1" value="<%=temp.template_priority%>" class="input" style="width:60px"<%=temp.is_system<1?"":" readonly=\"readonly\""%>/>
    &nbsp;&nbsp;
    <span style="color:#999">数值越大，权重越高</span>
    </td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">首&nbsp;&nbsp;重<b>*</b></td>
    <td class="inputText">
    <input type="text" name="firstWeight" must="1" value="<%=temp.first_weight%>" class="input" style="width:60px" /> 克(含)以内
    &nbsp;满
    <input type="text" name="minFreePrice" must="1" value="<%=temp.min_free_price%>" class="input" style="width:60px" /> 元包邮(全局)</td>
    <td class="lable">续&nbsp;&nbsp;重<b>*</b></td>
    <td class="inputText">
    <input type="text" id="continuedHeavy" name="continuedHeavy" must="1" value="<%=temp.template_id>0?temp.continue_weight:1000%>" onkeyup="resetContinuedHeavy(this)" class="input" style="width:60px" /> 克(含)
    &nbsp;&nbsp;
    <span style="color:#999">超过首重部分的计费依据</span>
    </td>
  </tr>
  <tr>
   <td style="width:3%">&nbsp;</td>
   <td class="lable">是否可见</td>
    <td colspan="2">
    <input type="radio" name="TempState" onclick="checkedthis(this)" value="1"<%if(temp.template_state>0){Response.Write(" checked=\"checked\"");}%> /> 可见
    &nbsp;|&nbsp;
    <input type="radio" name="TempState" onclick="checkedthis(this)" value="0"<%if(temp.template_state==0){Response.Write(" checked=\"checked\"");}%>/> 不可见
    </td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">备&nbsp;&nbsp;注</td>
    <td colspan="3">
    <input type="text" name="remarks" value="<%=temp.template_remark%>" class="input" style="width:620px" />
    </td>
  </tr>
</tbody>
</table>
</form>
<script type="text/javascript">
    function checkedthis(obj) {
        if (obj.checked) {
            $(obj).attr("checked", true);
            $("input[name='AssType']").each(function () {
                if (this != obj)
                    $(this).attr("checked", false);
            });
        } else {
            $(obj).attr("checked", false);
            $("input[name='AssType']").each(function () {
                if (this != obj)
                    $(this).attr("checked", true);
            });
        }
    }

function resetContinuedHeavy(obj){
	var val=$(obj).val();
	if(!Atai.isInt(val)){
		return false;
	}
	$("span[v='continuedHeavy']").html(val);
}
function checkThis(obj) {
    //alert($("input[name='area']").length);
	if(obj.checked){
	    $("input[name='area']").each(function () {
	        if ($(this).val() == obj.value && this != obj) {
	            $(this).attr("checked", false).attr("disabled", true);
	            $(this).parent("span").css({ "color": "#999", "text-decoration": "line-through" });
	        }
	        if ($(this).val() == obj.value && this == obj)
	            $(this).attr("checked", true);
	    });
	}else{
	$("input[name='area']").each(function () {
	    if ($(this).val() == obj.value) {
	        $(this).attr("disabled", false);
	        $(this).parent("span").css({ "color": "#333", "text-decoration": "none" });
	        if (this == obj)
	            $(this).attr("checked", false);
	    }
	});
	}
}
</script>
<script type="text/javascript">
<%
	List<ShortAreaInfo> areaList = null;
    var resp1 = GetAreaByParentId.Do(0,1);
    if(resp1==null || resp1.Body==null ||resp1.Body.area_list==null){
        areaList = new List<ShortAreaInfo>();
    }else{
        areaList = resp1.Body.area_list;
    }
	System.Text.StringBuilder json = new System.Text.StringBuilder();
	json.AppendLine("var areas=[];");
	foreach (ShortAreaInfo item in areaList){
		json.Append("areas.push({");
		json.Append("'AreaID': '"+ item.area_id +"'");
		json.Append(", 'FullName': '"+ item.full_name +"'");
		json.Append(", 'Name': '"+ item.area_name +"'");
		json.AppendLine("});");
	}
	Response.Write(json.ToString());
%>
</script>
<script type="text/javascript">
function addRuleTable(){
    var _continuedHeavy = $("#continuedHeavy").val();
   
    var html = '<table v="table-rules" class="table-rules" cellpadding="0" cellspacing="0" style="margin-top:20px">';
    html += '<input type="hidden" name="ruleid" value="0"/>';
	html += '<thead><tr><th colspan="4">运费规则 <b style="color:#F00">*</b></th><th style="text-align:right">';
	html += '<a href="javascript:;" onclick="removeRules(this)" style="color:#999">删除规则</a></th></tr></thead>';
	html += '<tbody>';

	html += '<tr><td style="width:3%"><input type="checkbox" v="allow" name="express" onclick="checkAllow(this)" value="1" checked="checked"/></td>';
	html += '<td class="lable">普通快递</td>';
	html += '<td class="inputText">\n';
	html += '首重\n';
	html += '<input type="text" name="expressFirstPrice" must="1" value="" class="input" style="width:60px" /> 元\n';
	html += '&nbsp;\n续重\n';
	html += '<input type="text" name="expressContinuedPrice" must="1" value="" class="input" style="width:60px" /> 元\n';
	html += '/\n';
	html += '<span v="continuedHeavy">'+ _continuedHeavy +'</span>克</td>';
	html += '<td class="lable"><input type="checkbox" v="allow" name="ems" onclick="checkAllow(this)" value="1" checked="checked"/>&nbsp;EMS</td>';
	html += '<td class="inputText">\n';
	html += '首重\n';
	html += '<input type="text" name="emsFirstPrice" must="1" value="" class="input" style="width:60px" /> 元\n';
	html += '&nbsp;\n续重\n';
	html += '<input type="text" name="emsContinuedPrice" must="1" value="" class="input" style="width:60px" /> 元\n';
	html += '/\n';
	html += '<span v="continuedHeavy">'+ _continuedHeavy +'</span>克</td>';
	html += '</tr>';

	html += '<tr><td style="width:3%"><input type="checkbox" v="allow" name="urgent" onclick="checkAllow(this)" value="1" checked="checked"/></td>';
	html += '<td class="lable">加 急 件</td>';
	html += '<td class="inputText">\n';
	html += '首重\n';
	html += '<input type="text" name="urgentFirstPrice" must="1" value="" class="input" style="width:60px" /> 元\n';
	html += '&nbsp;\n续重\n';
	html += '<input type="text" name="urgentContinuedPrice" must="1" value="" class="input" style="width:60px" /> 元\n';
	html += '/\n';
	html += '<span v="continuedHeavy">'+ _continuedHeavy +'</span>克</td>';
	html += '<td class="lable"><input type="checkbox" v="allow" name="cod" onclick="checkAllow(this)" value="1" checked="checked"/>&nbsp;货到付款</td>';
	html += '<td class="inputText">\n';
	html += '首重\n';
	html += '<input type="text" name="codFirstPrice" must="1" value="" class="input" style="width:60px" /> 元\n';
	html += '&nbsp;\n续重\n';
	html += '<input type="text" name="codContinuedPrice" must="1" value="" class="input" style="width:60px" /> 元\n';
	html += '/\n';
	html += '<span v="continuedHeavy">'+ _continuedHeavy +'</span>克</td>';
	html += '</tr>';

	html += '<tr><td style="width:3%">&nbsp;</td>';
	html += '<td class="lable">包邮设置</td>';
	html += '<td colspan="3">满\n';
	html += '<input type="text" name="minFreePrice" value="" class="input" style="width:60px" /> 元包邮\n';
	html += '&nbsp;&nbsp;\n<span style="color:#999">不超过首重的部分，满多少元包邮？留空则使用全局设置。加急件、货到付款不支持包邮</span>';
	html += '</td></tr>';

	html += '<tr><td style="width:3%">&nbsp;</td>';
	html += '<td class="lable">配送说明</td>';
	html += '<td colspan="3">';
	html += '<input type="text" name="remarks" value="" class="input" style="width:620px" />';
	html += '</td></tr>';

	html += '<tr><td style="width:3%">&nbsp;</td>';
	html += '<td class="lable" valign="top">配送地区</td>';
	html += '<td colspan="3" style="line-height:26px">';

	html += '<p>';
	var json=areas;
	for(var i=0;i<json.length;i++){
		if(i>0)
			html += "&nbsp;\n";
		if(i%9==0 && i>0)
			html += "</p><p>";
		var areaName=json[i].Name;
		if(json[i].Name.length==2)
			json[i].Name += "&nbsp;";
		var disabled='';
		var color='';
		$("input[name='area']").each(function(){
			if(this.value==json[i].AreaID && this.checked){
				disabled=" disabled='disabled'";
				color=' style="color:#999;text-decoration:line-through"';
			}
		});
		html += '<span'+color+'><input type="checkbox" name="area" areaName="'+ areaName +'" value="'+ json[i].AreaID +'" onclick="checkThis(this)"'+ disabled +'/> ' + json[i].Name + "</span>\n";
	}
	html += '</p>';

	html += '</td></tr>';
	html += '</tbody>';
	html += '</table>';
	$("#fare-rules").append(html);
}
function removeRules(obj){
	jsbox.confirm('您确定要删除此运费规则吗？',function(){
		var tabObj=$(obj).parent("th").parent("tr").parent("thead").parent("table");
		tabObj.find("input[name='area']").each(function(){
			if(this.checked){
				var val=$(this).val();
				$("input[name='area']").each(function(){
					if(val==this.value){
						$(this).attr("disabled", false);
						$(this).parent("span").css({"color" : "#333", "text-decoration" : "none"});
					}
				});
			}
		});
		tabObj.remove();
	});
}
function checkAllow(obj){
	var v=$(obj).attr("name");
	var checked=obj.checked;
	$(obj).parent("td").parent("tr").find("input[type='text']").each(function(){
		var _name=$(this).attr("name");
		if(_name.indexOf(v)==0){
			$(this).attr("disabled", !checked);
		}
});
if (obj.checked) {
    $(obj).attr("checked", true);
} else {
    $(obj).attr("checked", false);
}
}
</script>
<div id="fare-rules">
<%
	if(temp.template_id>0){
        List<FareRuleInfo> rules = null;
        var resfare = GetFareRulesByTempId.Do(temp.template_id);
        if (resfare == null || resfare.Body == null || resfare.Body.rule_list == null)
        {
            rules = new List<FareRuleInfo>();
        }
        else
        {
            rules = resfare.Body.rule_list;
        }
		List<int> areaIDList = new List<int>();
        foreach (FareRuleInfo em in rules)
        {
            foreach (RuleItemArea itemaera in em.rule_item_list)
            {
                if (!areaIDList.Contains(itemaera.area_id))
                {
                    areaIDList.Add(itemaera.area_id);
                }
            }
		}
		foreach(FareRuleInfo rule in rules){
%>
<table v="table-rules" class="table-rules" style="margin-top:20px" cellpadding="0" cellspacing="0">
<input type="hidden" name="ruleid" value="<%=rule.rule_id %>" />
<thead>
  <tr>
    <th colspan="4">运费规则 <b style="color:#F00">*</b></th>
    <th style="text-align:right"><a href="javascript:;" onclick="removeRules(this)" style="color:#999">删除规则</a></th>
    </th>
  </tr>
</thead>
<tbody>
  <tr>
<%
	string disabled="";// disabled="disabled"
	string checkedString=" checked=\"checked\"";
	if(rule.express_allow<1){
		disabled=" disabled=\"disabled\"";
		checkedString="";
	}
%>
    <td style="width:3%"><input type="checkbox" v="allow" name="express" onclick="checkAllow(this)" value="1"<%=checkedString%>/></td>
    <td class="lable">普通快递</td>
    <td class="inputText">
    首重
    <input type="text" name="expressFirstPrice" must="1" value="<%=rule.express_first_price%>" class="input" style="width:60px"<%=disabled%>/> 元
    &nbsp;
    续重
    <input type="text" name="expressContinuedPrice" must="1" value="<%=rule.express_continue_price%>" class="input" style="width:60px"<%=disabled%>/> 元
    /
    <span v="continuedHeavy">1000</span>克
    </td>
<%
	disabled="";// disabled="disabled"
	checkedString=" checked=\"checked\"";
	if(rule.ems_allow<1){
		disabled=" disabled=\"disabled\"";
		checkedString="";
	}
%>
    <td class="lable"><input type="checkbox" v="allow" name="ems" onclick="checkAllow(this)" value="1"<%=checkedString%>/>&nbsp;EMS</td>
    <td>
    首重
    <input type="text" name="emsFirstPrice" must="1" value="<%=rule.ems_first_price%>" class="input" style="width:60px"<%=disabled%>/> 元
    &nbsp;
    续重
    <input type="text" name="emsContinuedPrice" must="1" value="<%=rule.ems_continue_price%>" class="input" style="width:60px"<%=disabled%>/> 元
    /
    <span v="continuedHeavy">1000</span>克
    </td>
  </tr>
<%
	disabled="";// disabled="disabled"
	checkedString=" checked=\"checked\"";
	if(rule.urgent_allow<1){
		disabled=" disabled=\"disabled\"";
		checkedString="";
	}
%>
  <tr>
    <td style="width:3%"><input type="checkbox" v="allow" name="urgent" onclick="checkAllow(this)" value="1"<%=checkedString%>/></td>
    <td class="lable">加 急 件</td>
    <td class="inputText">
    首重
    <input type="text" name="urgentFirstPrice" must="1" value="<%=rule.urgent_first_price%>" class="input" style="width:60px"<%=disabled%>/> 元
    &nbsp;
    续重
    <input type="text" name="urgentContinuedPrice" must="1" value="<%=rule.urgent_continue_price%>" class="input" style="width:60px"<%=disabled%>/> 元
    /
    <span v="continuedHeavy">1000</span>克
    </td>
<%
	disabled="";// disabled="disabled"
	checkedString=" checked=\"checked\"";
	if(rule.cod_allow<1){
		disabled=" disabled=\"disabled\"";
		checkedString="";
	}
%>
    <td class="lable"><input type="checkbox" v="allow" name="cod" onclick="checkAllow(this)" value="1"<%=checkedString%>/>&nbsp;货到付款</td>
    <td class="inputText">
    首重
    <input type="text" name="codFirstPrice" must="1" value="<%=rule.cod_first_price%>" class="input" style="width:60px"<%=disabled%>/> 元
    &nbsp;
    续重
    <input type="text" name="codContinuedPrice" must="1" value="<%=rule.cod_continue_price%>" class="input" style="width:60px"<%=disabled%>/> 元
    /
    <span v="continuedHeavy">1000</span>克
    </td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">包邮设置</td>
    <td class="inputText" colspan="3">
    满
    <input type="text" name="minFreePrice" value="<%=rule.min_free_price%>" class="input" style="width:60px" /> 元包邮
    &nbsp;&nbsp;
    <span style="color:#999">不超过首重的部分，满多少元包邮？留空则使用全局设置。加急件、货到付款不支持包邮</span>
    </td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">配送说明</td>
    <td colspan="3">
    <input type="text" name="remarks" value="<%=rule.rule_remark%>" class="input" style="width:620px" />
    </td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable" valign="top">配送地区</td>
    <td colspan="3" style="line-height:26px">
    <p>
<%
    List<RuleItemArea> areas = rule.rule_item_list;
            
	List<int> _areas = new List<int>();
    foreach (RuleItemArea em in areas)
    {
		if(!_areas.Contains(em.area_id)){
			_areas.Add(em.area_id);
		}
	}
	int _areaCount=0;
    foreach (ShortAreaInfo item in areaList)
    {
		if(_areaCount>0){
			Response.Write("&nbsp;");
		}
		if(_areaCount%9==0 && _areaCount>0)
			Response.Write("</p><p>");
		_areaCount++;
		string areaName=item.area_name;
		if(item.area_name.Length==2) item.area_name += "&nbsp;";
		checkedString="";
		disabled="";
		string style="";
		if(_areas.Contains(item.area_id)){
			checkedString=" checked=\"checked\"";
		}else if(areaIDList.Contains(item.area_id)){
			disabled=" disabled=\"disabled\"";
			style=" style=\"color:#999;text-decoration:line-through\"";
		}
%>
	<span<%=style%>><input type="checkbox" name="area" areaName="<%=areaName%>" value="<%=item.area_id%>" onclick="checkThis(this)"<%=checkedString%><%=disabled%>/> <%=item.area_name%></span>
<%
	}
%>
	</p>
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
    <th colspan="4">运费规则 <b style="color:#F00">*</b></th>
    <th style="text-align:right"><a href="javascript:;" onclick="removeRules(this)" style="color:#999">删除规则</a></th>
    </th>
  </tr>
</thead>
<tbody>
  <tr>
    <td style="width:3%"><input type="checkbox" v="allow" name="express" onclick="checkAllow(this)" value="1" checked="checked"/></td>
    <td class="lable">普通快递</td>
    <td class="inputText">
    首重
    <input type="text" name="expressFirstPrice" must="1" value="" class="input" style="width:60px" /> 元
    &nbsp;
    续重
    <input type="text" name="expressContinuedPrice" must="1" value="" class="input" style="width:60px" /> 元
    /
    <span v="continuedHeavy">1000</span>克
    </td>
    <td class="lable"><input type="checkbox" v="allow" name="ems" onclick="checkAllow(this)" value="1" checked="checked"/>&nbsp;EMS</td>
    <td>
    首重
    <input type="text" name="emsFirstPrice" must="1" value="" class="input" style="width:60px" /> 元
    &nbsp;
    续重
    <input type="text" name="emsContinuedPrice" must="1" value="" class="input" style="width:60px" /> 元
    /
    <span v="continuedHeavy">1000</span>克
    </td>
  </tr>
  <tr>
    <td style="width:3%"><input type="checkbox" v="allow" name="urgent" onclick="checkAllow(this)" value="1" checked="checked"/></td>
    <td class="lable">加 急 件</td>
    <td class="inputText">
    首重
    <input type="text" name="urgentFirstPrice" must="1" value="" class="input" style="width:60px" /> 元
    &nbsp;
    续重
    <input type="text" name="urgentContinuedPrice" must="1" value="" class="input" style="width:60px" /> 元
    /
    <span v="continuedHeavy"><%=temp.template_id>0?temp.continue_weight:1000%></span>克
    </td>

    <td class="lable"><input type="checkbox" v="allow" name="cod" onclick="checkAllow(this)" value="1" checked="checked"/>&nbsp;货到付款</td>
    <td class="inputText">
    首重
    <input type="text" name="codFirstPrice" must="1" value="" class="input" style="width:60px" /> 元
    &nbsp;
    续重
    <input type="text" name="codContinuedPrice" must="1" value="" class="input" style="width:60px" /> 元
    /
    <span v="continuedHeavy">1000</span>克
    </td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">包邮设置</td>
    <td class="inputText" colspan="3">
    满
    <input type="text" name="minFreePrice" value="" class="input" style="width:60px" /> 元包邮
    &nbsp;&nbsp;
    <span style="color:#999">不超过首重的部分，满多少元包邮？留空则使用全局设置。加急件、货到付款不支持包邮</span>
    </td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">配送说明</td>
    <td colspan="3">
    <input type="text" name="remarks" value="" class="input" style="width:620px" />
    </td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable" valign="top">配送地区</td>
    <td colspan="3" style="line-height:26px">
    <p>
<%
	int _areaCount=0;
	foreach (ShortAreaInfo item in areaList){
		if(_areaCount>0){
			Response.Write("&nbsp;");
		}
		if(_areaCount%9==0 && _areaCount>0)
			Response.Write("</p><p>");
		_areaCount++;
		string areaName=item.area_name;
		if(item.area_name.Length==2) item.area_name += "&nbsp;";
%>
	<span><input type="checkbox" name="area" areaName="<%=areaName%>" value="<%=item.area_id%>" onclick="checkThis(this)"/> <%=item.area_name%></span>
<%
	}
%>
	</p>
    </td>
  </tr>
</tbody>
</table>
<%
	}
%>
</div>
<table class="table" cellpadding="0" cellspacing="0">
<tbody>
  <tr>
    <td><strong onclick="addRuleTable()" style="color:#00F;cursor:pointer"><b class="icon-add">&nbsp;</b>增加运费规则</strong></td>
  </tr>
</tbody>
</table>
<br/>
<table class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:42%">&nbsp;</th>
    <th class="lable"><input type="button" id="loadding3" value="  确定提交  " onclick="$('#fareTempForm').submit()" class="submit" style="width:120px"/></th>
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
function createXmlDocument(nodes){
	var xml='<?xml version="1.0" encoding="utf-8"?>';
	xml += '<items>';
	for(var i=0;i<nodes.length;i++){
		xml += nodes[i];
	}
	xml += '</items>';
	return xml;
}
function submitFareTemplateForm(form){
	var isError=false;
	$("input[must='1']").each(function(){
		if($(this).val()=="" && !$(this).attr("disabled")){
			isError=true;
		}
	});
	if(isError){
		jsbox.error("请完成所有必填项的填写");return false;
	}
	$("input[name='area']").each(function () {
	    if (!$(this).attr("disabled") && !$(this).attr("checked")) {
	        isError = true;
	    }
	});
	if(isError){
		jsbox.error("请为所有地区设置运费规则");return false;
	}
	if(showLoadding) showLoadding();

	var postData=getPostDB(form);

	var nodes=[];
	$("#fare-rules table[v='table-rules']").each(function () {
	    var ruleid = $(this).find("input[name='ruleid']").val();
	    var minFreePrice = $(this).find("input[name='minFreePrice']").val();
	    if (!Atai.isNumber(minFreePrice)) minFreePrice = -1;
	    var node = '<item ruleid="' + ruleid + '" minFreePrice="' + minFreePrice + '">';

	    var expressAllow = $(this).find("input[name='express']").attr("checked") ? 1 : 0;
	    var expressFirstPrice = $(this).find("input[name='expressFirstPrice']").val();
	    var expressContinuedPrice = $(this).find("input[name='expressContinuedPrice']").val();
	    if (!Atai.isNumber(expressFirstPrice)) expressFirstPrice = 0;
	    if (!Atai.isNumber(expressContinuedPrice)) expressContinuedPrice = 0;
	    node += '<express allow="' + expressAllow + '" firstPrice="' + expressFirstPrice + '" continuedPrice="' + expressContinuedPrice + '" />';

	    var emsAllow = $(this).find("input[name='ems']").attr("checked") ? 1 : 0;
	    var emsFirstPrice = $(this).find("input[name='emsFirstPrice']").val();
	    var emsContinuedPrice = $(this).find("input[name='emsContinuedPrice']").val();
	    if (!Atai.isNumber(emsFirstPrice)) emsFirstPrice = 0;
	    if (!Atai.isNumber(emsContinuedPrice)) emsContinuedPrice = 0;
	    node += '<ems allow="' + emsAllow + '" firstPrice="' + emsFirstPrice + '" continuedPrice="' + emsContinuedPrice + '"/>';

	    var urgentAllow = $(this).find("input[name='urgent']").attr("checked") ? 1 : 0;
	    var urgentFirstPrice = $(this).find("input[name='urgentFirstPrice']").val();
	    var urgentContinuedPrice = $(this).find("input[name='urgentContinuedPrice']").val();
	    if (!Atai.isNumber(urgentFirstPrice)) urgentFirstPrice = 0;
	    if (!Atai.isNumber(urgentContinuedPrice)) urgentContinuedPrice = 0;
	    node += '<urgent allow="' + urgentAllow + '" firstPrice="' + urgentFirstPrice + '" continuedPrice="' + urgentContinuedPrice + '"/>';

	    var codAllow = $(this).find("input[name='cod']").attr("checked") ? 1 : 0;
	    var codFirstPrice = $(this).find("input[name='codFirstPrice']").val();
	    var codContinuedPrice = $(this).find("input[name='codContinuedPrice']").val();
	    if (!Atai.isNumber(codFirstPrice)) codFirstPrice = 0;
	    if (!Atai.isNumber(codContinuedPrice)) codContinuedPrice = 0;
	    node += '<cod allow="' + codAllow + '" firstPrice="' + codFirstPrice + '" continuedPrice="' + codContinuedPrice + '"/>';

	    node += '<areas>';
	    var areas = $(this).find("input[name='area']");
	    var _areaCount = 0;
	    areas.each(function () {
	        if ($(this).attr("checked") && !$(this).attr("disabled")) {
	            node += '<area id="' + $(this).val() + '" name="' + $(this).attr("areaName") + '"/>';
	            _areaCount++;
	        }
	    });
	    node += '</areas>'

	    var text = $(this).find("input[name='remarks']").val();
	    node += '<text><![CDATA[' + text + ']]></text>';
	    node += '</item>';
	    if (_areaCount > 0) {
	        nodes.push(node);
	    }
	});
	if(nodes.length<1){
		if(closeLoadding) closeLoadding();
		jsbox.error("请填写至少一个规则(区域为必选项)");
		if (closeLoadding) closeLoadding();
		return false;
	}
	var xml=createXmlDocument(nodes);
	$.ajax({
		url: "/MGoods/PostFareTemplate"
		, data: postData + "&xml=" + encodeURIComponent(xml)
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
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>
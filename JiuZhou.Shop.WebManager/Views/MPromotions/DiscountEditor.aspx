<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %> <%@ Import Namespace="JiuZhou.Cache" %><%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%Html.RenderPartial("Base/_PageHeadControl"); %>
<link href="/style/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/javascript/jquery.bigautocomplete.js"></script>
<link rel="stylesheet" href="/style/jquery.bigautocomplete.css" type="text/css" />
<style type="text/css">
*{margin:0;padding:0;list-style-type:none;}
a,img{border:0;}
.button{width:95px;height:32px;padding:0;padding-top:2px\9;border:0;background-position:0 -35px;background-color:#ddd;cursor:pointer}
</style>
<title><%=ViewData["pageTitle"]%></title>
</head>
<body>
<%Html.RenderPartial("Base/_SimplePageTopControl"); %>
<%
    int ruleid = DoRequest.GetQueryInt("ruleid", 0);
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
    DiscountInfo info = new DiscountInfo();
    var resinfo = GetLtimeDiscountDetail.Do(ruleid);
    if (resinfo != null && resinfo.Body != null)
        info = resinfo.Body;
    List<DiscountItems> items = new List<DiscountItems>();
    if (info.item_list != null)
        items = info.item_list;

    List<TypeList> tList = new List<TypeList>();
    DoCache chche = new DoCache();
    if (chche.GetCache("typelist") == null)
    {
        var res = GetTypeListAll.Do(-1);
        if (res != null && res.Body != null && res.Body.type_list != null)
        {
            tList = res.Body.type_list;
            chche.SetCache("typelist", tList);
            if (tList.Count == 0)
            {
                chche.RemoveCache("typelist");
            }
        }
    }
    else
    {
        tList = (List<TypeList>)chche.GetCache("typelist");
    }
    
    string clsName = "";
    if (info.product_type_path == null)
        info.product_type_path = "";
    string[] _tem = info.product_type_path.Trim().Split(',');
    int _xCount = 0;
    for (int x = 0; x < _tem.Length; x++)
    {
        if (string.IsNullOrEmpty(_tem[x].Trim())) continue;
        int _v = Utils.StrToInt(_tem[x].Trim());
        foreach (TypeList item in tList)
        {
            if (item.product_type_id == _v)
            {
                if (_xCount > 0) clsName += " &gt;&gt; ";
                clsName += item.type_name;
                _xCount++;
            }
        }
    }

%>
<div id="container-syscp">
	<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
	</div>
	<div class="container-right">
		<div class="editor-box-head" style="position:relative">
限时折扣规则
		</div>
		<div class="div-tab">
<form id="fareTempForm" method="post" action="" onsubmit="return submitForm(this)">
<input type="hidden" name="ruleid" value="<%=ruleid%>"/>
<table class="table" cellpadding="0" cellspacing="0">
<tbody>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">活动标题<b>*</b></td>
    <td class="inputText"><input type="text" name="subjectname" must="1" value="<%=info.subject_name%>" class="input" style="width:320px" /></td>
    <td class="lable">价 格 名<b>*</b></td>
    <td class="inputText">
        <input type="text" name="discountname" must="1" value="<%=info.discount_name%>" class="input" style="width:60px"/> <span style="color:red">8个字符以内 如：促销、限时折扣、疯狂双11</span>
    </td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">折扣模式<b>*</b></td>
    <td class="inputText">
      <select id="discountmode" name="discountmode" onchange="selectchange(this.value)" style="height:28px;width:60px;">
        <option value="0" <%=info.discount_mode==0?"selected=\"selected\"":"" %>>单品</option>
        <option value="1" <%=info.discount_mode==1?"selected=\"selected\"":"" %>>品牌</option>
        <option value="2" <%=info.discount_mode==2?"selected=\"selected\"":"" %>>类目</option>
        <option value="3" <%=info.discount_mode==3?"selected=\"selected\"":"" %>>卖家</option>
        <option value="4" <%=info.discount_mode==4?"selected=\"selected\"":"" %>>全站</option>
      </select>
      <script type="text/javascript">
          var _mode = <%=info.discount_mode %>;
          $(function () {
              $("#discountmode").change();
              $("#cuttype").change();
          });
        function selectchange(value) {
          if(value != 0){
              $("#isitems").hide();
          }
          if(value == 0){
              $("#isitems").show();
          }
          _mode = value;
            $("div[class='name']").each(function () {
                if ($(this).attr("v") == value) {
                    $(this).show();
                } else {
                    $(this).hide();
                }
            });

            $("div[class='value']").each(function () {
                if ($(this).attr("v") == value) {
                    $(this).show();
                } else {
                    $(this).hide();
                }
            });
        }
      </script>
       
    </td>
    <td class="lable"><div class="name" v="0">&nbsp;</div><div class="name" v="1">品 牌 名<b>*</b></div><div class="name" v="2">类 目 名<b>*</b></div><div class="name" v="3">卖 家 名<b>*</b></div><div class="name" v="4">&nbsp;</div></td>
    <td class="inputText">
    <div class="value" v="0">
        &nbsp;
    </div>
    <div class="value" v="1">
    <input type="text" id="tt2" name="brandname" value="<%=info.brand_name %>" class="input" />
    </div>

    <div class="value" v="2">
        <input type="hidden" id="ClassID" name="ClassID" value="<%=info.product_type_id%>"/>
        <input type="hidden" id="showClassPath" name="showClassPath" value="<%=info.product_type_path %>" />
        <input type="text" id="showClassID" value="<%=clsName%>" class="input" onclick="selectCategBox(event, 'ClassID', 'showClassID', 'showClassPath')" readonly="readonly" style="cursor:pointer;width:240px;"/>
        <input type="button" class="view-file" value="选择..." onclick="selectCategBox(event, 'ClassID', 'showClassID')" title="选择分类"/>
    </div>
    <div class="value" v="3">
    <input type="text" id="tt" name="shopname" value="<%=info.shop_name %>" class="input" />
    </div>
    <div class="value" v="4">&nbsp;</div>
   
    </td>
  </tr>
  <tr>
  <td style="width:3%">&nbsp;</td>
  <td class="lable">降价方式<b>*</b></td>
  <td class="inputText">
      <select id="cuttype" name="cuttype" onchange="selectchange2(this.value)" style="height:28px;width:110px;">
        <option value="0" <%=info.cut_type==0?"selected=\"selected\"":"" %>>按百分比打折</option>
        <option value="1" <%=info.cut_type==1?"selected=\"selected\"":"" %>>按固定价格减</option>
      </select>
  </td>
       <script type="text/javascript">
           $(function () {
               $.ajax({
                   url: "/MGoods/SearchShop"
		    , type: "post"
                   // , data: postData
		    , dataType: "json"
		    , success: function (json, textStatus) {
		        if (!json.error) {
		            var _data = "[";
		            for (var i = 0; i < json.list1.length; i++) {
		                _data += "{title:\"" + json.list1[i].shop_name + "\"},";
		            }
		            _data += "]";

		            var _data3 = "[";
		            for (var i = 0; i < json.list2.length; i++) {
		                _data3 += "{title:\"" + json.list2[i].brand_name + "\"},";
		            }
		            _data3 += "]";

		            var _data2 = eval(_data);
		            var _data4 = eval(_data3);
		            $("#tt").bigAutocomplete({
		                width: 230,
		                data: _data2,
		                callback: function (data) {
		                    //alert(data.title);
		                }
		            });
		            $("#tt2").bigAutocomplete({
		                width: 230,
		                data: _data4,
		                callback: function (data) {
		                    //alert(data.title);
		                }
		            });
		        }
		    }
            , error: function (http, textStatus, errorThrown) {
                jsbox.error(errorThrown);
            }
               });
               return false;
           });
</script>
  <script type="text/javascript">
      function selectchange2(value) {
          if (value == 0) {
              $("#cutdiv1").show();
              $("#cutdiv2").hide();
          }
          if (value == 1) {
              $("#cutdiv1").hide();
              $("#cutdiv2").show();
          }
      }
  </script>
  <td class="lable">降 价 值<b>*</b></td>
  <td class="inputText">
    <div id="cutdiv1">
      <input type="text" id="cutrate" name="cutrate" class="input" value="<%=info.cut_rate %>" style="width:50px;"/> %
    </div>
    <div id="cutdiv2">
      <input type="text" id="cutprice" name="cutprice" class="input" value="<%=info.cut_price %>" style="width:50px;"/> 元
    </div>
  </td>
  </tr>
 <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">开始时间<b>*</b></td>
    <td class="inputText">
    <input type="text" id="box-sdate" name="sdate" value="<%=info.start_time==null?DateTime.Now.ToString("yyyy-MM-dd"):DateTime.Parse(info.start_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
	<input type="text" id="box-shours" name="shours" value="<%=info.start_time==null?"00":DateTime.Parse(info.start_time).Hour.ToString()%>" class="input" style="width:25px" title="数字0至23"/> 时
    <input type="text" id="box-sminutes" name="sminutes" value="<%=info.start_time==null?"00":DateTime.Parse(info.start_time).Minute.ToString()%>" class="input" style="width:25px" title="数字0至59"/> 分
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
    <td colspan="2"><div class="tips-text" id="tips-starttime">&nbsp;</div></td>
  </tr>

  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">结束时间<b>*</b></td>
    <td class="inputText">
    <input type="text" id="box-edate" name="edate" value="<%=info.end_time==null?DateTime.Now.AddDays(7).ToString("yyyy-MM-dd"):DateTime.Parse(info.end_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
	<input type="text" id="box-ehours" name="ehours" value="<%=info.end_time==null?"23":DateTime.Parse(info.end_time).Hour.ToString()%>" class="input" style="width:25px" title="数字0至23"/> 时
    <input type="text" id="box-eminutes" name="eminutes" value="<%=info.end_time==null?"59":DateTime.Parse(info.end_time).Minute.ToString()%>" class="input" style="width:25px" title="数字0至59"/> 分
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
    <td colspan="2"><div class="tips-text" id="tips-endtime">&nbsp;</div></td>
  </tr>
    <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">是否覆盖</td>
    <td class="inputText" colspan="3"><input type="checkbox" name="iscover" value="0" onclick="checkthis(this)" /></td>
  </tr>
</tbody>
</table>

<script type="text/javascript">
    function checkthis(obj) {
        if (obj.checked) {
            $(obj).val("1");
        } else {
            $(obj).val("0");
        }
    }
    function showItemProductSelector() {
        if (_mode != 0) {
            jsbox.error("只有单品模式才能添加商品");
        } else {
            var nodes = $("#items-table input[v='item-product-id']");
            var initList = "";
            var exceptList = [];
            for (var i = 0; i < nodes.length; i++) {
                if (i > 0) initList += ",";
                initList += $(nodes[i]).val();
            }
            showProductSelector(function (ids) {
                if (ids == "") return false;
                $.ajax({
                    url: "/MTools/GetProductList2"
			, type: "post"
			, data: {
			    "ids": ids
			}
			, dataType: "json"
			, success: function (json, textStatus) {
			    parseProductSelectorData(json);
			    $("select[name1='itemcuttype']").each(function () {
			        $(this).change();
			    });
			}, error: function (http, textStatus, errorThrown) {
			    jsbox.error(errorThrown);
			}
                });
            }, initList, exceptList, true,1);
        }
    }

function parseProductSelectorData(jsonList, isAdd) {
    var o = $("#items-table");
    var ids = [];
    for (var i = 0; i < jsonList.length; i++) {
        ids.push(jsonList[i].product_id);
    }
    var bids = [];
    o.find("tbody tr").each(function () {
        var id = $(this).find("input[v='item-product-id']").val();
        if (!ids.contains(id)) $(this).remove();
        else bids.push(id);
    });
    var nodes = o.find("input[v='item-product-id']");
    var items = [];
    for (var i = 0; i < nodes.length; i++) items.push($(nodes[i]).val());
    var arr = [];
    
    var _count = 0;
    for (var i = 0; i < jsonList.length; i++) {
        var json = jsonList[i];
        if (items.contains(json.product_id))
            continue; //去除重复的ID
        arr.push('<tr name="discount_items"><td>&nbsp;</td>');
        arr.push('<td style="width:70px;height:74px;"><input type="hidden" v="item-product-id" value="' + json.product_id + '"/><input type="hidden" name="item-id" value="0"/>');
        arr.push('<a href="<%=config.UrlHome%>' + json.product_id + '.html" target="_blank">');
        arr.push('<img src="' + formatImageUrl2(json.img_src, 120, 120) + '" style="width:60px;height:60px" alt=""/></a></td>');
        arr.push('<td>');
        arr.push('<p><a href="<%=config.UrlHome%>' + json.product_id + '.html" target="_blank">' + json.product_name + '</a></p>');
        arr.push('<p class="pname" style="color:#999">编码：' + json.product_code + '</p>');
        arr.push('<p style="color:#999">' + json.type_name + '</p></td>');
        arr.push('<td class="inputText"><input type="checkbox" name1="copybymain" name="copybymain" value="0" onclick="changethis(this,\'new' + _count + '\')"/></td>');
        arr.push('<td class="inputText">');
        arr.push('<input type="text" name1="itemsdate" name="itemsdatenew' + _count + '" value="<%=info.start_time==null?DateTime.Now.ToString("yyyy-MM-dd"):DateTime.Parse(info.start_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>');
        arr.push('<input type="text" name1="itemshours" name="itemshoursnew' + _count + '" value="<%=info.start_time==null?"00":DateTime.Parse(info.start_time).Hour.ToString()%>" class="input" style="width:25px" title="数字0至23"/> 时');
        arr.push('<input type="text" name1="itemsminutes" name="itemsminutesnew' + _count + '" value="<%=info.start_time==null?"00":DateTime.Parse(info.start_time).Minute.ToString()%>" class="input" style="width:25px" title="数字0至59"/> 分<br/>');
        arr.push('<input type="text" name1="itemedate" name="itemedatenew' + _count + '" value="<%=info.end_time==null?DateTime.Now.AddDays(7).ToString("yyyy-MM-dd"):DateTime.Parse(info.end_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>');
        arr.push('<input type="text" name1="itemehours" name="itemehoursnew' + _count + '" value="<%=info.end_time==null?"23":DateTime.Parse(info.end_time).Hour.ToString()%>" class="input" style="width:25px" title="数字0至23"/> 时');
        arr.push('<input type="text" name1="itememinutes" name="itememinutesnew' + _count + '" value="<%=info.end_time==null?"59":DateTime.Parse(info.end_time).Minute.ToString()%>" class="input" style="width:25px" title="数字0至59"/> 分');
        arr.push('</td>');
        arr.push('<td class="inputText">');
        arr.push('<select name1="itemcuttype" name="itemcuttypenew' + i + '" onchange="selectchange3(\'new' + _count + '\',this.value)" style="height:28px;width:110px;">');
        arr.push('<option value="0" selected=\"selected\">按百分比打折</option>');
        arr.push('<option value="1">按固定价格减</option>');
        arr.push('</select></td>');
        arr.push('<td class="inputText">');
        arr.push('<div id="1itemnew' + _count + '">');
        arr.push('<input type="text" name1="itemcutrate" name="itemcutratenew' + _count + '" class="input" value="0" style="width:40px;"/> %');
        arr.push('</div>');
        arr.push('<div id="2itemnew' + _count + '">');
        arr.push('<input type="text" name1="itemcutprice" name="itemcutpricenew' + _count + '" class="input" value="0" style="width:40px;"/> 元');
        arr.push('</div></td>');
        arr.push('<td><a href="javascript:;" onclick="removeItem(this)">移除</a></td>');
        arr.push('</tr>');
        _count++;
    }
    o.find("tbody").append(arr.join("\n"));
}
function removeItem(obj) {
    $(obj).parent("td").parent("tr").remove();
}
</script>
<div id="isitems">
<table id="items-table" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr>
    <th style="width:3%">&nbsp;</th>
    <th colspan="2"><div style="position:relative">
<div class="console" style="padding:0;margin:0;border:0;height:auto;line-height:auto;text-align:left;">
<a href="javascript:;" onclick="showItemProductSelector()"><b class="add">&nbsp;</b>选择商品...</a>
</div>
</div>
    </th>
    <th style="width:6%">复制主规则</th>
    <th style="width:25%">开始时间<br/>结束时间</th>
    <th style="width:8%">降价方式</th>
    <th style="width:10%">降 价 值</th>
    <th style="width:6%">操作</th>
  </tr>
</thead>
<tbody>
<%
    int _count2 = 0;
    foreach (DiscountItems item in items)
    {
        _count2++;
%>
  <tr name="discount_items">
    <td style="width:3%">&nbsp;</td>
    <td style="width:70px;height:74px;">
    <input type="hidden" name="item-id" value="<%=item.lt_discount_item_id %>" />
    <input type="hidden" v="item-product-id" value="<%=item.product_id %>"/>
    <a href="<%=config.UrlHome%><%=item.product_id %>.html" target="_blank" title="<%=item.product_name%>"><img src="<%=FormatImagesUrl.GetProductImageUrl(item.img_src, 120, 120) %>" style="width:60px;height:60px" alt=""/></a>
    </td>
    <td>
	<p><a href="<%=config.UrlHome%><%=item.product_id %>.html" target="_blank"><%=item.product_name%></a></p>
    <p class="pname" style="color:#999">
    编码：<%=item.product_code%>
    </p>
    <p style="color:#999">分类：<%
		//ProductTypeInfo clsInfo = new ProductTypeInfo();//当前分类
        string _s = item.product_type_path;
		string[] _tem2=_s.Split(',');
		int _xCount2=0;
		for(int x=0;x<_tem2.Length;x++){
			if(string.IsNullOrEmpty(_tem2[x].Trim())) continue;
			int _v=Utils.StrToInt(_tem2[x].Trim());
			foreach (TypeList item2 in tList){
            	if (item2.product_type_id ==_v){
					if(_xCount2>0) Response.Write(" &gt;&gt; ");
					Response.Write(item2.type_name);
					_xCount2++;
            	}
        	}
		}
	%></p>
    </td>
    <td class="inputText">
    <input type="checkbox" name="copybymain" value="<%=item.copy_by_main %>" onclick="changethis(this,<%=item.lt_discount_item_id %>)" <%=item.copy_by_main==1?"checked=\"checked\"":"" %>/>
    </td>
    <td class="inputText">
    <input type="text" name1="itemsdate" name="itemsdate<%=item.lt_discount_item_id %>" value="<%=item.start_time==null?DateTime.Now.ToString("yyyy-MM-dd"):DateTime.Parse(item.start_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()" <%=item.copy_by_main==1?"disabled=\"disabled\"":"" %>/>
	<input type="text" name1="itemshours" name="itemshours<%=item.lt_discount_item_id %>" value="<%=item.start_time==null?"00":DateTime.Parse(item.start_time).Hour.ToString()%>" class="input" style="width:25px" title="数字0至23" <%=item.copy_by_main==1?"disabled=\"disabled\"":""%>/> 时
    <input type="text" name1="itemsminutes" name="itemsminutes<%=item.lt_discount_item_id %>" value="<%=item.start_time==null?"00":DateTime.Parse(item.start_time).Minute.ToString()%>" class="input" style="width:25px" title="数字0至59" <%=item.copy_by_main==1?"disabled=\"disabled\"":""%>/> 分<br/>
    <input type="text" name1="itemedate" name="itemedate<%=item.lt_discount_item_id %>" value="<%=item.end_time==null?DateTime.Now.AddDays(7).ToString("yyyy-MM-dd"):DateTime.Parse(item.end_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()" <%=item.copy_by_main==1?"disabled=\"disabled\"":""%>/>
	<input type="text" name1="itemehours" name="itemehours<%=item.lt_discount_item_id %>" value="<%=item.end_time==null?"23":DateTime.Parse(item.end_time).Hour.ToString()%>" class="input" style="width:25px" title="数字0至23" <%=item.copy_by_main==1?"disabled=\"disabled\"":""%>/> 时
    <input type="text" name1="itememinutes" name="itememinutes<%=item.lt_discount_item_id %>" value="<%=item.end_time==null?"59":DateTime.Parse(item.end_time).Minute.ToString()%>" class="input" style="width:25px" title="数字0至59" <%=item.copy_by_main==1?"disabled=\"disabled\"":""%>/> 分
    </td>
    <td class="inputText">
    <select name1="itemcuttype" name="itemcuttype<%=item.lt_discount_item_id %>" onchange="selectchange3(<%=item.lt_discount_item_id %>,this.value)" style="height:28px;width:110px;" <%=item.copy_by_main==1?"disabled=\"disabled\"":""%>>
       <option value="0" <%=item.cut_type==0?"selected=\"selected\"":"" %>>按百分比打折</option>
       <option value="1" <%=item.cut_type==1?"selected=\"selected\"":"" %>>按固定价格减</option>
    </select>
    </td>
    <td class="inputText">
    <div id="1item<%=item.lt_discount_item_id %>">
      <input type="text" name1="itemcutrate" name="itemcutrate<%=item.lt_discount_item_id %>" class="input" value="<%=item.cut_rate %>" style="width:40px;" <%=item.copy_by_main==1?"disabled=\"disabled\"":""%>/> %
    </div>
    <div id="2item<%=item.lt_discount_item_id %>">
      <input type="text" name1="itemcutprice" name="itemcutprice<%=item.lt_discount_item_id %>" class="input" value="<%=item.cut_price %>" style="width:40px;" <%=item.copy_by_main==1?"disabled=\"disabled\"":""%>/> 元
    </div>
  </td>
  <td><a href="javascript:;" onclick="removeItem(this)">移除</a></td>
  </tr>
  <%
	}
  %>
   <script type="text/javascript">
       $(function () {
           $("select[name1='itemcuttype']").each(function () {
               $(this).change();
           });
       });
       function selectchange3(id, value) {
           var a = 3;
           if (value == 0) {
               $("#1item" + id).show();
               $("#2item" + id).hide();
           }
           if (value == 1) {
               $("#1item" + id).hide();
               $("#2item" + id).show();
           }
       }

       function changethis(obj,itemid) {
           if (obj.checked) {
               $(obj).attr("checked", true);
               $("input[name=itemsdate" + itemid + "]").val($("#box-sdate").val()).attr("disabled",true);
               $("input[name=itemshours" + itemid + "]").val($("#box-shours").val()).attr("disabled", true);
               $("input[name=itemsminutes" + itemid + "]").val($("#box-sminutes").val()).attr("disabled", true);
               $("input[name=itemedate" + itemid + "]").val($("#box-edate").val()).attr("disabled", true);
               $("input[name=itemehours" + itemid + "]").val($("#box-ehours").val()).attr("disabled", true);
               $("input[name=itememinutes" + itemid + "]").val($("#box-eminutes").val()).attr("disabled", true);

               $("select[name=itemcuttype" + itemid + "]").val($("#cuttype").val()).attr("disabled", true);
               $("select[name=itemcuttype" + itemid + "]").change();
               $("input[name=itemcutrate" + itemid + "]").val($("#cutrate").val()).attr("disabled", true);
               $("input[name=itemcutprice" + itemid + "]").val($("#cutprice").val()).attr("disabled", true);
               
               $(obj).val("1");
           } else {
               $(obj).attr("checked", false);
               $("input[name=itemsdate" + itemid + "]").attr("disabled", false);
               $("input[name=itemshours" + itemid + "]").attr("disabled", false);
               $("input[name=itemsminutes" + itemid + "]").attr("disabled", false);
               $("input[name=itemedate" + itemid + "]").attr("disabled", false);
               $("input[name=itemehours" + itemid + "]").attr("disabled", false);
               $("input[name=itememinutes" + itemid + "]").attr("disabled", false);

               $("select[name=itemcuttype" + itemid + "]").attr("disabled", false);
               $("input[name=itemcutrate" + itemid + "]").attr("disabled", false);
               $("input[name=itemcutprice" + itemid + "]").attr("disabled", false);
               $(obj).val("0");
           }
       }
  </script>
</tbody>
</table>
</div>
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
</form>
		</div>
<br/><br/><br/><br/>
	</div>
</div>
<br/><br/>
<script type="text/javascript">
function createXmlDocument(nodes){
	var xml='<?xml version="1.0" encoding="utf-8"?>';
	xml += '<items>';
	if (nodes != undefined) {
	    for (var i = 0; i < nodes.length; i++) {
	        xml += nodes[i];
	    }
	}
	xml += '</items>';
	return xml;
}
function submitForm(form){
	var isError=false;
	$("input[must='1']").each(function(){
		if($(this).val()==""){
			isError=true;
		}
	});
	if(isError){
	    jsbox.error("请完成所有必填项的填写");
        return false;
	}

    var discountname = $("input[name='discountname']").val();
    if (discountname.length > 8) {
        jsbox.error("【价格名】不能超过8个字符");
        return false;
    }

    var discountmode = $("#discountmode option:selected").val();

    if (discountmode == 1) {
        if ($("#tt2").val() == "") {
            jsbox.error("请填写品牌");
            return false;
        }
    }

    if (discountmode == 2) {
        if ($("#ClassID").val() == 0 || $("#showClassID").val().length < 1) {
            jsbox.error("请选择类目");
            return false;
        }
    }

    if (discountmode == 3) {
        if ($("#tt").val() == "") {
            jsbox.error("请填写商家");
            return false;
        }
    }

    var cuttype = $("#cuttype option:selected").val();

    if (cuttype == 0) {
        if ($("#cutrate").val().length < 1) {
            jsbox.error("请填写【降价值】");
            return false;
        }
        if (!Atai.isNumber($("#cutrate").val())) {
            jsbox.error("【降价值】只能为数字");
            return false;
        }
        if (Number($("#cutrate").val()) < 0) {
            jsbox.error("【降价值】不能为负");
            return false;
        }
    }

    if (cuttype == 1) {
        if ($("#cutprice").val().length < 1) {
            jsbox.error("请填写【降价值】");
            return false;
        }
        if (!Atai.isNumber($("#cutprice").val())) {
            jsbox.error("【降价值】只能为数字");
            return false;
        }
        if (Number($("#cutprice").val()) < 0) {
            jsbox.error("【降价值】不能为负");
            return false;
        }
    }

	if(showLoadding) showLoadding();

	var postData=getPostDB(form);
	if (discountmode == 0) {

	    var nodes = [];
	    var _error = false;
	    var _ermsg = "";
	    $("tr[name='discount_items']").each(function () {
	        var itemid = $(this).find("input[name='item-id']").val();
	        var productid = $(this).find("input[v='item-product-id']").val();

	        var copybymain = $(this).find("input[name='copybymain']").val();

	        var itemcuttype = $(this).find("select[name1='itemcuttype'] option:selected").val();
	        var itemcutrate = $(this).find("input[name1='itemcutrate']").val();
	        var itemcutprice = $(this).find("input[name1='itemcutprice']").val();
	        var itemsdate = $(this).find("input[name1='itemsdate']").val();
	        var itemshours = $(this).find("input[name1='itemshours']").val();
	        var itemsminutes = $(this).find("input[name1='itemsminutes']").val();
	        var itemstime = itemsdate + " " + itemshours + ":" + itemsminutes + ":00";
	        var itemedate = $(this).find("input[name1='itemedate']").val();
	        var itemehours = $(this).find("input[name1='itemehours']").val();
	        var itememinutes = $(this).find("input[name1='itememinutes']").val();
	        var itemetime = itemedate + " " + itemehours + ":" + itememinutes + ":00";

	        if (copybymain == 1) {
	            itemcuttype = cuttype;
	            itemcutrate = $("#cutrate").val();
	            itemcutprice = $("#cutprice").val();
	            itemstime = $("#box-sdate").val() + " " + $("#box-shours").val() + ":" + $("#box-sminutes").val() + ":00";
	            itemetime = $("#box-edate").val() + " " + $("#box-ehours").val() + ":" + $("#box-eminutes").val() + ":00";
	        } else {
	            if (!Atai.isNumber(itemshours)) {
	                _error = true;
	                _ermsg = "【商品】的开始时间【时】必须为数字";
	            }
	            if (!Atai.isNumber(itemsminutes)) {
	                _error = true;
	                _ermsg = "【商品】的开始时间【分】必须为数字";
	            }
	            if (!Atai.isNumber(itemehours)) {
	                _error = true;
	                _ermsg = "【商品】的结束时间【时】必须为数字";
	            }
	            if (!Atai.isNumber(itemehours)) {
	                _error = true;
	                _ermsg = "【商品】的结束时间【分】必须为数字";
	            }

	            if (itemsdate.length < 1 || Number(itemshours) < 0 || Number(itemshours) > 23 || Number(itemsminutes) < 0 || Number(itemsminutes) > 59) {
	                _error = true;
	                _ermsg = "【商品】的开始时间有错误";
	            }
	            if (itemedate.length < 1 || Number(itemehours) < 0 || Number(itemehours) > 23 || Number(itememinutes) < 0 || Number(itememinutes) > 59) {
	                _error = true;
	                _ermsg = "【商品】的结束时间有错误";
	            }

	            if (itemcuttype == 0) {
	                if (!Atai.isNumber(itemcutrate)) {
	                    _error = true;
	                    _ermsg = "【商品】的降价值必须为数字";
	                }
	                if (itemcutrate.length < 1) {
	                    _error = true;
	                    _ermsg = "【商品】的降价值不能为空";
	                }
	                if (Number(itemcutrate) < 0) {
	                    _error = true;
	                    _ermsg = "【商品】的降价值不能为负";
	                }
	            } else {
	                if (!Atai.isNumber(itemcutprice)) {
	                    _error = true;
	                    _ermsg = "【商品】的降价值必须为数字";
	                }
	                if (itemcutprice.length < 1) {
	                    _error = true;
	                    _ermsg = "【商品】的降价值不能为空";
	                }
	                if (Number(itemcutprice) < 0) {
	                    _error = true;
	                    _ermsg = "【商品】的降价值不能为负";
	                }
	            }

	        }

	        var node = '<item itemid="' + itemid + '" productid="' + productid + '" copybymain="' + copybymain +'"';

	        node += ' itemstime="' + itemstime + '" itemetime="' + itemetime + '" itemcuttype="' + itemcuttype + '" itemcutrate="' + itemcutrate + '" itemcutprice="' + itemcutprice + '">';

	        node += '</item>';

	        nodes.push(node);

	    });
	    if (nodes.length < 1) {
	        if (closeLoadding) closeLoadding();
	        jsbox.error("请填写至少一个明细");
	        if (closeLoadding) closeLoadding();
	        return false;
	    }
	    if (_error) {
	        jsbox.error(_ermsg);
	        if (closeLoadding) closeLoadding();
	        return false;
	    }
	}

	var xml=createXmlDocument(nodes);
	$.ajax({
	    url: "/MPromotions/PostDiscount"
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
<%Html.RenderPartial("MGoods/SelectCategControl2"); %>
<%Html.RenderPartial("MGoods/SelectProductControl"); %>
<%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>
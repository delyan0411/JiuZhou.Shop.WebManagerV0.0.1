<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %><%@ Import Namespace="JiuZhou.Cache" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %><%@ Import Namespace="JiuZhou.HttpTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="/style/style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/javascript/iframeDialog.js" charset="utf-8"></script>
<%Html.RenderPartial("Base/_PageHeadControl"); %>
<title><%=ViewData["pageTitle"]%></title>
</head>
<body>
<%Html.RenderPartial("Base/_SimplePageTopControl"); %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
    int useplat = DoRequest.GetQueryInt("useplat");
    int listId = DoRequest.GetQueryInt("listid");
    int posId = DoRequest.GetQueryInt("posid");
	UpLoadFile upload = new UpLoadFile(false);
	string uploadRoot = upload.GetUploadRoot.StartsWith("/") ? upload.GetUploadRoot.Substring(1) : upload.GetUploadRoot;
	string imageRootUrl = config.UrlImages + uploadRoot;

    List<RecommendListInfo> items = null;
    var resp = GetRecommendItemByRpId.Do(posId);
    if (resp == null || resp.Body == null || resp.Body.item_list == null)
    {
        items = new List<RecommendListInfo>();
    }
    else {
        items = resp.Body.item_list;
    }
    
    RecommendListInfo item = items.Find(delegate(RecommendListInfo em)
    {
        return (em.ri_id == listId);
    });
    if (item == null)
        item = new RecommendListInfo();
    
    RecommendPositionInfo pos = new RecommendPositionInfo();
    var respos = GetRecommendPositionInfo.Do(posId);
    if (respos != null && respos.Body != null)
        pos = respos.Body;
    
	string _pageName=item.ri_id>0?"修改推荐项":"添加推荐项";
%>
<script type="text/javascript">
Atai.addEvent(window,"load",function(){
	var name="<%=_pageName.Trim()%>";
	if(name.length>0) document.title=name + "," + document.title;
});
</script>
<div id="container-syscp">
<div class="container-left">
<%Html.RenderPartial("Base/LeftControl"); %>
</div>
<div class="container-right">
		<div class="editor-box-head">
<%=_pageName%> (<%=pos.rp_name%>)<%=useplat==4?"(PC)":"(手机)" %>
		</div>
<form method="post" action="" onsubmit="return submitForm(this)">
<input type="hidden" name="ListID" value="<%=listId %>"/>
<input type="hidden" name="posID" value="<%=posId %>"/>
<input type="hidden" name="useplat" value="<%=useplat %>"/>
		<div class="div-tab">
<table id="tab-category" class="table" cellpadding="0" cellspacing="0">
<thead>
  <tr style="display:none">
    <td style="width:3%">&nbsp;</td>
    <td style="width:20%">&nbsp;</td>
    <td>&nbsp;</td>
    <td style="width:20%">&nbsp;</td>
  </tr>
</thead>
<tbody>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td style="width:80px">
    <p><select id="stype" name="stype" style="width:60px" onchange="selectchange(this.value)">
             <option value="1" init="true">商品ID</option>
             <option value="2">类别</option>
             <option value="3">品牌</option>
             <option value="4">URL</option>
             <option value="5">专题/馆</option>   
    </select><b style="color:red;font-weight: 100;"> *</b></p>
    <script type="text/javascript">
        var _isfirst = 0;
        Atai.addEvent(window, "load", function () {
            dropShopID = new _DropListUI({
                input: Atai.$("#stype")
            }); dropShopID.maxHeight = "320px"; dropShopID.width = "60px";
            dropShopID.init();
            if(<%=item.ri_type%>=="0"){
                dropShopID.setDefault("1");
            }else{
                dropShopID.setDefault("<%=item.ri_type%>");
            }
           // $("select[name='stype']").change();
        });
        
  Atai.addEvent(window,"load",function(){
	dropiconID=new _DropListUI({
		input: Atai.$("#iconname")
	});dropiconID.maxHeight="80px";dropShopID.width="80px";
dropiconID.init(); dropiconID.setDefault("<%=item.icon_name%>");
});
        function selectchange(value) {
            if (_isfirst != 0) {
                $("input[name='protype']").val("");
                $("input[name='proid']").val("");
                $("input[name='proid']").text('');
                $("input[name='subject']").val("");
                $("input[name='subject']").text('');
                $("input[name='brand']").val("");
                $("input[name='brand']").text('');
                $("input[name='url']").val("");
                $("input[name='url']").text('');
                $("input[name='image']").val("");
                Atai.$("#upload-image-box").style.background = "url(' ') center center no-repeat";
                Atai.$("#upload-image-box").innerHTML = "暂无图片";
                //$("textarea[name='summary']").val("");
                $("textarea[name='summary']").text('');
            }
            _isfirst = 1;
            if (value == "2") {
                $("input[name='catebtn']").show();
            } else {
                $("input[name='catebtn']").hide();
            }

            if (value == "1") {
                $("a[name='getproinfo']").show();
            } else {
                $("a[name='getproinfo']").hide();
            }

            if (value == "4" || value == "5") {
            } else {
                if(value == "1")
                    $("#urltext").text('不填写则默认链接至商品详情页');
            }

            if (value == "5") {
                
            } else {
                $("input[name='proid']").show();
                $("select[name='gtype']").hide();
            }
        }

        function showUrlMessage(obj) {
            if ($("select[name='stype']").val() == "5" || $("select[name='stype']").val() == "4")
                $("input[name='url']").val($("input[name='proid']").val());
        }
    </script>
    </td>
    <td class="inputText">
    <input type="hidden" id="protype" name="protype" value="<%=item.ri_value %>" class="input"/>
    <%
        string _pathName = "";
        if (item.ri_type == 2)
        {
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
            TypeList type = tList.Find(
                delegate(TypeList em)
                {
                    return (em.product_type_id == Utils.StrToInt(item.ri_value) && em.is_visible == 1);
                });
            string _path = type.product_type_path;
            string[] _tem = _path.Split(',');
            int _xCount = 0;
            
            for (int x = 0; x < _tem.Length; x++)
            {
                if (string.IsNullOrEmpty(_tem[x].Trim())) continue;
                int _v = Utils.StrToInt(_tem[x].Trim());
                foreach (TypeList em in tList)
                {
                    if (em.product_type_id == _v)
                    {
                        if (_xCount > 0) _pathName += " >> ";
                        _pathName += em.type_name;
                        _xCount++;
                    }
                }
            }
        }
         %>
    <input type="text" id="proid" name="proid" value="<%=item.ri_type==2?_pathName:item.ri_value%>" class="input" onblur="showUrlMessage(this)"/></td>
    <td class="inputText" colspan="2"> 
      <p style="float:left">
        <input type="button" class="view-file" name="catebtn" value="选择分类" onclick="selectCategBox(event, 'protype', 'proid')" title="选择分类" style="width:auto"/>
        <a href="javascript:;" name="getproinfo" onclick="parseProductInfo($('#proid').val())" style="color:#00F">点此自动获取商品信息</a>
        <select id="gtype" name="gtype" style="width:80px">
             <option value="YIYAO" init="true">医药馆</option>
             <option value="YANGSHENG">养生馆</option>
             <option value="QIXIE">器械馆</option>  
        </select>
      </p>
    </td>
  </tr>

  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">推荐标题<b>*</b></td>
    <td class="inputText"><input type="text" id="subject" name="subject" value="<%=item.ri_subject%>" class="input" /></td>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">商品品牌<b>*</b></td>
    <td class="inputText"><input type="text" id="brand" name="brand" value="<%=item.product_brand%>" class="input" /></td>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">小 图 标</td>
    <td class="inputText">
      <select id="iconname" name="iconname" style="width:80px;height:25px;">
        <option value="" init="true">无</option>
        <option value="new">新上线</option>
        <option value="hot">热门</option>
    </select>
    </td>
    <td colspan="2">现在为主导航专用，其他位置无需选择</td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">开始时间<b>*</b></td>
    <td class="inputText">
    <input type="text" id="box-sdate" name="sdate" value="<%=item.start_time==null?DateTime.Now.ToString("yyyy-MM-dd"):DateTime.Parse(item.start_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
	<input type="text" id="box-shours" name="shours" value="00" class="input" style="width:40px" title="数字0至23"/> 时
    <input type="text" id="box-sminutes" name="sminutes" value="00" class="input" style="width:40px" title="数字0至59"/> 分
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
    <td>&nbsp;</td>
    <td colspan="2"><div class="tips-text" id="tips-starttime">&nbsp;</div></td>
  </tr>

  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">结束时间<b>*</b></td>
    <td class="inputText">
    <input type="text" id="box-edate" name="edate" value="<%=item.end_time==null?DateTime.Now.AddDays(7).ToString("yyyy-MM-dd"):DateTime.Parse(item.end_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()"/>
	<input type="text" id="box-ehours" name="ehours" value="23" class="input" style="width:40px" title="数字0至23"/> 时
    <input type="text" id="box-eminutes" name="eminutes" value="59" class="input" style="width:40px" title="数字0至59"/> 分
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
    <td class="lable">Url 地址</td>
    <td class="inputText"><input type="text" id="url" name="url" value="<%=item.page_src%>" class="input" /></td>
    <td colspan="2"><b id="urltext">&nbsp;</b></td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable" valign="top">图&nbsp;&nbsp;片</td>
    <td class="inputText" valign="top">
    <input type="hidden" id="upload-image" name="image" value="<%=item.img_src %>" />
<div id="upload-image-box" class="upload-image-box" style="width:160px;height:160px;line-height:160px;" onclick="ajaxUploadClick(this,Atai.$('#upload-image'))">
暂无图片
</div>
<div class="upload-image-box-botton" style="color:#666;">
&nbsp;<input type="button" class="view-file" onclick="$('#upload-image-box').click()" value="浏览..."/>
<br/><br/>
<p>&nbsp;<a href="javascript:;" onclick="showImageListBox(setImage)" style="color:blue">从图片库中选择</a></p>
<p style="margin-top:16px">&nbsp;<a href="javascript:;" onclick="setImage('','')">使用默认图片</a></p>
</div>
<script type="text/javascript">

function setImage(path,fullPath){
	Atai.$("#upload-image").value=path;
	var _uploadImageBox=Atai.$("#upload-image-box");
	var path=formatImageUrl(fullPath, 160, 160);
	_uploadImageBox.style.background="url(" + path + ") center center no-repeat";
	_uploadImageBox.innerHTML="";
}//imageRootUrl
<%if(!string.IsNullOrEmpty(item.img_src)){%>Atai.addEvent(window,"load",function(){
	setImage('<%=item.img_src%>','<%=item.img_src%>');
});<%}%>
</script>
    </td>
    <td valign="top" colspan="2">图片尺寸请参考推荐位说明，<b style="color:#ff6600">不上传则默认使用商品主图</b></td>
  </tr>

  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable" valign="top">推 荐 语</td>
    <td colspan="3" class="inputText">
  <textarea id="summary" name="summary" class="textarea" style="height:160px"><%=item.ri_summary%></textarea>
    </td>
  </tr>
  <tr>
    <td style="width:3%">&nbsp;</td>
    <td class="lable">&nbsp;</td>
    <td class="inputText"><input type="submit" id="loadding3" value="确定提交" class="submit"/></td>
    <td colspan="2"><div class="tips-text" id="tips-message" title="">&nbsp;</div></td>
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
function parseProductInfo(productid){
	if(showLoadding) showLoadding();
	var obj=Atai.$("#tips-message");
	var postData="productid=" + productid;
	$.ajax({
		url: "/MTools/GetProductInfo2"
		, data: postData
        , type: "post"
		, dataType: "json"
		, success: function(json){
			if(json.product_id<1){
				obj.className = "tips-text tips-icon";
				obj.innerHTML="商品不存在";
			}else{
				obj.className = "tips-text";
				obj.innerHTML=obj.title;
				Atai.$("#subject").value=json.product_name;
				Atai.$("#brand").value = json.product_brand;
				//Atai.$("#url").value="";
				Atai.$("#upload-image").value=json.img_src;
				Atai.$("#summary").value=json.product_name;
				setImage(json.img_src, json.img_src);
			}
			if(closeLoadding) closeLoadding();
		}
	});
	return false;
}
var _lastTips=false;
function submitForm(form){
	if(showLoadding) showLoadding();
	var obj=Atai.$("#tips-message");
	var postData=getPostDB(form);
	$.ajax({
	    url: "/MPolymeric/PostItems"
		, data: postData
        , type: "post"
		, dataType: "json"
		, success: function (json) {
		    obj.className = "tips-text tips-icon";
		    if (json.error) {
		        obj.innerHTML = json.message;
		    } else {
		        obj.className = "tips-text";
		        jsbox.success(json.message, window.location.href);
		    }
		    if (closeLoadding) closeLoadding();
		}
	});
	return false;
}
</script>
<%Html.RenderPartial("UploadBaseControl"); %>
<%Html.RenderPartial("ImageListBoxControl");//图片选择 %>
<%Html.RenderPartial("Base/_PageFootControl"); %>
<%Html.RenderPartial("MGoods/SelectCategControl"); %>
</body>
</html>
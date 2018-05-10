<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="JiuZhou.ControllerBase" %>
<%@ Import Namespace="JiuZhou.Model" %>
<%@ Import Namespace="JiuZhou.Common" %>
<%@ Import Namespace="JiuZhou.MySql" %>
<%@ Import Namespace="JiuZhou.HttpTools" %>
<%@ Import Namespace="JiuZhou.Cache" %>
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link href="/style/style.css" rel="stylesheet" type="text/css" />
    <%Html.RenderPartial("Base/_PageHeadControl"); %>
    <script type="text/javascript" src="/ckeditor/ckeditor.js" charset="utf-8"></script>
    <script type="text/javascript" src="/javascript/jquery.bigautocomplete.js"></script>
    <link rel="stylesheet" href="/style/jquery.bigautocomplete.css" type="text/css" />
    <script type="text/javascript" src="/javascript/iframeDialog.js" charset="utf-8"></script>
    <link href="/style/v1.2/upload.css" rel="stylesheet" />
    <link href="/javascript/webuploader/webuploader.css" rel="stylesheet" />
    <script type="text/javascript" src="/javascript/webuploader/webuploader.js" charset="utf-8"></script>
    <style type="text/css">
        #db-images {
        }

            #db-images dt {
                float: left;
                width: 152px;
                height: auto;
                text-align: center;
            }

                #db-images dt div {
                    color: #999;
                    height: 146px;
                    line-height: 18px;
                    width: 142px;
                    overflow: hidden;
                    margin: 0 auto;
                    cursor: pointer;
                    border: #E8E8E8 1px solid;
                    text-align: center;
                }

            #db-images .hover div {
                border: #ff6600 1px solid;
            }

            #db-images dt .op a {
                color: #060;
            }

            #db-images .hover .op .sdef {
                color: #999;
            }

            #db-images dt a {
                color: #00F;
            }

            #db-images dt img {
                height: 140px;
                width: 140px;
            }

        * {
            margin: 0;
            padding: 0;
            list-style-type: none;
        }

        a, img {
            border: 0;
        }

        .button {
            width: 95px;
            height: 32px;
            padding: 0;
            padding-top: 2px\9;
            border: 0;
            background-position: 0 -35px;
            background-color: #ddd;
            cursor: pointer;
        }

        div.webuploader-pick {
            height: 40px;
        }

        #filePicker2 .webuploader-pick {
            height: 24px;
        }

        #uploader p.title {
            z-index: 3;
        }
    </style>
</head>
<body>
    <%Html.RenderPartial("Base/_SimplePageTopControl"); %>
    <%
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
        int classId = DoRequest.GetQueryInt("classid");
        int checklog = DoRequest.GetQueryInt("checklog", 0);
        int proId = DoRequest.GetQueryInt("id");
        ProductInfo Info = new ProductInfo();
        var respro = GetProductInfo.Do(proId);
        if (respro != null && respro.Body != null)
            Info = respro.Body;
        if (Info.product_id < 1)
        {
            Info.promotion_bdate = "2012-01-01 00:00:00";
            Info.promotion_edate = "2012-01-01 23:59:59";
        }

        if (Info.product_id < 1)
            Info.is_visible = 1;
        if (Info.product_id == 0)
        {
            Info.product_type_path = (string)Session["protypepath"];
            Info.product_type_id = Session["protypeid"] == null ? 0 : (int)Session["protypeid"];
            Info.product_brand = (string)Session["probrandname"];
            Info.shop_name = (string)Session["proshopname"];
        }
        string clsName = "";
        if (Info.product_type_path == null)
            Info.product_type_path = "";
        string[] _tem = Info.product_type_path.Trim().Split(',');
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
        List<ProductAlbumList> imageList = new List<ProductAlbumList>();
        if (chche.GetCache("product-GetProductAlbum" + Info.product_id) == null)
        {
            var resp = GetProductAlbum.Do(Info.product_id);
            if (resp != null && resp.Body != null && resp.Body.pic_list != null)
            {
                imageList = resp.Body.pic_list;
                chche.SetCache("product-GetProductAlbum" + Info.product_id, imageList, 60);
                if (imageList.Count == 0)
                    chche.RemoveCache("product-GetProductAlbum" + Info.product_id);
            }
        }
        else
        {
            imageList = (List<ProductAlbumList>)chche.GetCache("product-GetProductAlbum" + Info.product_id);
        }
    %>
    <script type="text/javascript">$(function(){document.title="<%=string.IsNullOrEmpty(Info.product_name)?"":(Info.product_name+"|")%>商品编辑|九洲";});</script>
    <div id="container-syscp">
        <div class="container-left">
            <%Html.RenderPartial("Base/LeftControl"); %>
        </div>
        <div class="container-right">
            <div class="editor-box-head" style="position: relative">
                商品编辑
                <%if (Info.product_join_id > 0)
                    {%>
                <a href="/mgoods/joinEditor?joinid=<%=Info.product_join_id%>" style="display: block; position: absolute; top: 0; right: 30px; color: #00F" target="_blank">编辑关联信息</a>
                <%}%>
            </div>
            <form method="post" action="" onsubmit="return submitProductForm(this)">
                <input type="hidden" name="ProID" value="<%=Info.product_id%>" />
                <input type="hidden" id="ClassID" name="ClassID" value="<%=Info.product_type_id%>" />
                <div class="div-tab">
                    <table id="tab-category" class="table" cellpadding="0" cellspacing="0">
                        <thead>
                            <tr style="display: none">
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">商品分类<b>*</b></td>
                                <td class="inputText" colspan="2">
                                    <p style="float: left">
                                        <input type="text" id="showClassID" value="<%=clsName%>" class="input" onclick="selectCategBox(event, 'ClassID', 'showClassID')" readonly="readonly" style="cursor: pointer; width: 200px;" />
                                        <input type="button" class="view-file" value="选择分类" onclick="selectCategBox(event, 'ClassID', 'showClassID')" title="选择分类" style="width: 80px;" />
                                        <%if (checklog == 0)
                                            {
                                        %>
                                        <input type="hidden" id="checktype" name="checktype" value="<%=Info.check_state %>" />
                                        <%}
                                            else
                                            {
                                        %>
       &nbsp;<input type="radio" name="checktype" onclick="checkedthis(this)" value="0" <%if (Info.check_state == 0) { Response.Write(" checked=\"checked\""); }%> />
                                        审核通过
       &nbsp;|&nbsp;
       <input type="radio" name="checktype" onclick="checkedthis(this)" value="1" <%if (Info.check_state == 1) { Response.Write(" checked=\"checked\""); }%> />
                                        审核不通过
    <%} %>
                                    </p>
                                    <p style="float: left;margin-top: 5px;margin-left: 10px;">
                                       <input type="checkbox" onclick="checkseaflag(this);" name="sea_flag" id="sea_flag" value="1" <%=Info.sea_flag>0?" checked=\"checked\"":""%> />
                                    海外购
    &nbsp;|&nbsp;
                                    <input type="checkbox" name="p_is_prescription_drug" value="1" <%=Info.is_drug>0?" checked=\"checked\"":""%> />
                                    处方药
    &nbsp;|&nbsp;
    <input type="checkbox" name="isOnSale" value="1" <%=Info.is_on_sale>0?" checked=\"checked\"":""%> />
                                    商品上架
    &nbsp;|&nbsp;
    <input type="checkbox" name="isVisible" value="0" <%=Info.is_visible<1?" checked=\"checked\"":""%> />
                                    放入回收站
                                        </p>
                                </td>
                               
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable" align="center">门&nbsp;&nbsp;店<b>*</b></td>
                                <td colspan="2">
                                    <input type="text" id="tt" name="shopname" value="<%=Info.shop_name %>" class="input" />
                                    &nbsp;&nbsp;品&nbsp;&nbsp;牌<span style="color: red"> *</span>&nbsp;<input type="text" id="tt2" name="brandname" value="<%=Info.product_brand %>" class="input" />
                                </td>
                            </tr>
                            <script type="text/javascript">
                                function checkedthis(obj) {
                                    if (obj.checked) {
                                        $(obj).attr("checked", true);
                                        $("input[name='checktype']").each(function () {
                                            if (this != obj)
                                                $(this).attr("checked", false);
                                        });
                                    } else {
                                        $(obj).attr("checked", false);
                                        $("input[name='checktype']").each(function () {
                                            if (this != obj)
                                                $(this).attr("checked", true);
                                        });
                                    }
                                }
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

                                              _data2 = eval(_data);
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
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">商品名称<b>*</b></td>
                                <td class="inputText">
                                    <input type="text" name="name" value="<%=Info.product_name%>" class="input" style="width: 520px" />
                                </td>
                                <td class="inputText"></td>
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">关 键 词</td>
                                <td class="inputText">
                                    <input type="text" name="KeyForSearch" value="<%=Info.search_key%>" class="input" style="width: 520px" /></td>
                                <td>多个关键词用逗号隔开</td>
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">商品卖点</td>
                                <td class="inputText">
                                    <input type="text" name="promotion" value="<%=Info.sales_promotion%>" class="input" style="width: 520px" /></td>
                                <td>商品的卖点，如 [买一送一] 等</td>
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable" valign="top">商品说明</td>
                                <td class="inputText">
                                    <textarea name="summary" style="width: 530px; height: 60px;"><%=Info.product_func%></textarea>
                                </td>
                                <td>&nbsp;</td>
                            </tr>
                        </tbody>
                    </table>
                    <br />
                    <table class="table" cellpadding="0" cellspacing="0">
                        <thead>
                            <tr>
                                <th colspan="4">规格参数</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">包装规格</td>
                                <td colspan="2">
                                    <input type="text" name="p_spec" value="<%=Info.product_spec%>" class="input" />
                                    &nbsp;生产厂家&nbsp;<input type="text" name="manufacturer" value="<%=Info.manu_facturer%>" class="input" />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">通 用 名</td>
                                <td colspan="2">
                                    <input type="text" name="p_common_name" value="<%=Info.common_name%>" class="input" />
                                    &nbsp;批准文号&nbsp;<input type="text" name="p_license" value="<%=Info.product_license%>" class="input" />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">参考效期</td>
                                <td class="inputText">
                                    <%if (Info.invalid_date == null)
                                            Info.invalid_date = DateTime.Now.ToString(); %>
                                    <input type="text" id="box-idate" name="idate" value="<%=DateTime.Parse(Info.invalid_date).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()" />
                                    <input type="text" id="box-ihours" name="ihours" value="<%=DateTime.Parse(Info.invalid_date).ToString("HH")%>" class="input" style="width: 40px" title="数字0至23" />
                                    时
    <input type="text" id="box-iminutes" name="iminutes" value="<%=DateTime.Parse(Info.invalid_date).ToString("mm")%>" class="input" style="width: 40px" title="数字0至59" />
                                    分
                                    <script type="text/javascript">
                                        Atai.addEvent(window,"load",function(){
                                            var hBox=Atai.$("#box-ihours");
                                            var mBox=Atai.$("#box-iminutes");
                                            var tips=Atai.$("#tips-itime");
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
                                <td><span class="tips-text" id="tips-itime">&nbsp;</span></td>
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">月 点 击</td>
                                <td colspan="2">
                                    <input type="text" name="monthClicks" value="<%=Info.month_click_count%>" class="input" style="width: 80px" />
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <br />
                    <table class="table" cellpadding="0" cellspacing="0">
                        <thead>
                            <tr>
                                <th colspan="4"><span>销售参数</span>&nbsp;&nbsp;<span id="codemsg" style="color: red"></span></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">商品编码<b>*</b></td>
                                <td colspan="2">
                                    <input type="text" id="attr-code" name="code" value="<%=Info.product_code%>" onblur="checkCode(this)" class="input" style="width: 164px" />
                                    &nbsp;库存 <b style="color: #ff6600">*</b>&nbsp;<input type="text" id="attr-stock1" name="stock1" value="<%=Info.stock_num%>" class="input" style="width: 80px" onkeyup="chkNumber(this,'库存', 'tips-sale')" disabled />
                                    &nbsp;虚拟库存 <b style="color: #ff6600">*</b>&nbsp;<input type="text" id="attr-stock" name="stock" value="<%=Info.virtual_stock_num%>" class="input" style="width: 80px" onkeyup="chkNumber(this,'库存', 'tips-sale')" />
                                    &nbsp;重量 <b style="color: #ff6600">*</b>&nbsp;<input type="text" id="attr-weight" name="weight" value="<%=Info.product_weight.ToString("0")%>" class="input" style="width: 80px" onkeyup="chkNumber(this,'重量', 'tips-sale')" />
                                    克
    &nbsp;
    <span class="tips-text" id="tips-sale">&nbsp;</span>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">商品售价<b>*</b></td>
                                <td class="2">
                                    <input type="text" id="attr-member" name="member_price" value="<%=Info.sale_price%>" class="input" onkeyup="chkNumber(this,'售价', 'tips-sale')" onchange="changeMemberPrice(this)" style="width: 80px" />
                                    元
    &nbsp;&nbsp;
    手机 <b style="color: #ff6600">*</b>&nbsp;<input type="text" id="attr-mobile" name="mobile_price" value="<%=Info.mobile_price%>" class="input" onkeyup="chkNumber(this,'手机专享价', 'tips-sale')" style="width: 80px" />
                                    元
    &nbsp;&nbsp;
    限购数量 
                                    <input type="text" id="attr-purchase" name="max_buy_num" value="<%=Info.max_buy_num%>" class="input" onkeyup="chkNumber(this,'限购数量', 'tips-sale')" style="width: 80px" />
                                    小于或等于0表示不限购
                                </td>
                            </tr>

                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">促销价格</td>
                                <td colspan="2">
                                    <input type="text" id="attr-promotion" name="promotion_price" value="<%=Info.promotion_price%>" class="input" onkeyup="chkNumber(this,'促销价', 'tips-sale')" style="width: 80px" />
                                    元
    &nbsp;&nbsp;
    从
    <input type="text" id="box-sdate" name="sdate" value="<%=DateTime.Parse(Info.promotion_bdate).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()" />
                                    <input type="text" id="box-shours" name="shours" value="<%=DateTime.Parse(Info.promotion_bdate).ToString("HH")%>" class="input" style="width: 40px" title="数字0至23" />
                                    时
    <input type="text" id="box-sminutes" name="sminutes" value="<%=DateTime.Parse(Info.promotion_bdate).ToString("mm")%>" class="input" style="width: 40px" title="数字0至59" />
                                    分

至

    <input type="text" id="box-edate" name="edate" value="<%=DateTime.Parse(Info.promotion_edate).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()" />
                                    <input type="text" id="box-ehours" name="ehours" value="<%=DateTime.Parse(Info.promotion_edate).ToString("HH")%>" class="input" style="width: 40px" title="数字0至23" />
                                    时
    <input type="text" id="box-eminutes" name="eminutes" value="<%=DateTime.Parse(Info.promotion_edate).ToString("mm")%>" class="input" style="width: 40px" title="数字0至59" />
                                    分
                                    <script type="text/javascript">
                                        function chkNumber(obj, name, tipsId){
                                            if(!Atai.isNumber(obj.value)){
                                                $("#" + tipsId).addClass("tips-icon").html("["+ name +"] 请填写数字");
                                            }else{
                                                $("#" + tipsId).removeClass("tips-icon").html("");
                                            }
                                            if($(obj).attr("name")=="member_price"){
                                                $("#currPrice").val($(obj).val());
                                                try{
                                                    var rate=parseFloat($("#integral_rate").val())/100.0;
                                                    var val=parseFloat($(obj).val()) * rate;
                                                    $("#integral_view,#integral_hidden").val(parseInt(val));
                                                }catch(e){
			
                                                }
                                            }
                                        }
                                        $(function(){
                                            var tips=$("#tips-sale");
                                            $("#box-shours").keyup(function(){
                                                if(Atai.isInt(this.value)
                                                    && parseInt(this.value)>=0
                                                    && parseInt(this.value)<24){
                                                    tips.removeClass("tips-icon").html("");
                                                }else{
                                                    tips.addClass("tips-icon").html("[时] 请填写0至23之间的数字");
                                                }
                                            });
                                            $("#box-sminutes").keyup(function(){
                                                if(Atai.isInt(this.value)
                                                    && parseInt(this.value)>=0
                                                    && parseInt(this.value)<60){
                                                    tips.removeClass("tips-icon").html("");
                                                }else{
                                                    tips.addClass("tips-icon").html("[分] 请填写0至59之间的数字");
                                                }
                                            });
                                        });
                                        $(function(){
                                            var tips=$("#tips-sale");
                                            $("#box-ehours").keyup(function(){
                                                if(Atai.isInt(this.value)
                                                    && parseInt(this.value)>=0
                                                    && parseInt(this.value)<24){
                                                    tips.removeClass("tips-icon").html("");
                                                }else{
                                                    tips.addClass("tips-icon").html("[时] 请填写0至23之间的数字");
                                                }
                                            });
                                            $("#box-eminutes").keyup(function(){
                                                if(Atai.isInt(this.value)
                                                    && parseInt(this.value)>=0
                                                    && parseInt(this.value)<60){
                                                    tips.removeClass("tips-icon").html("");
                                                }else{
                                                    tips.addClass("tips-icon").html("[分] 请填写0至59之间的数字");
                                                }
                                            });
                                        });
                                    </script>
                                    <span class="tips-text" id="tips-stime">&nbsp;</span></td>
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">送 积 分</td>
                                <td colspan="2">
                                    <%--<input type="text" name="VirtualMoney" value="<%=Info.VirtualMoney%>" class="input" style="width:80px"/> 元
    &nbsp;&nbsp;--%>
    赠送<input type="hidden" id="integral_hidden" name="integral" value="<%=Info.give_integral%>" />
                                    <input type="text" id="currPrice" value="<%=Info.sale_price%>" class="input" style="width: 50px" disabled="disabled" />
                                    ×<%
                                         decimal _rate = 5;
                                         if (Info.product_id > 0)
                                         {
                                             decimal _temVal = Info.give_integral / (Info.sale_price == 0m ? 1m : Info.sale_price);
                                             _rate = Math.Round(_temVal * 100, 0);
                                         }
                                    %>
                                    <input type="text" id="integral_rate" value="<%=_rate%>" class="input" style="width: 50px" onkeyup="changeIntegral(this)" />
                                    %
    =
    <input type="text" id="integral_view" value="<%=Info.give_integral%>" class="input" style="width: 50px" disabled="disabled" />
                                    积分
                                    <script type="text/javascript">
                                        function changeMemberPrice(obj){
                                            $("#currPrice").val($(obj).val());
                                        }
                                        function changeIntegral(obj){
                                            try{
                                                var rate=parseFloat($("#integral_rate").val())/100.0;
                                                var val=parseFloat($("#attr-member").val()) * rate;
                                                $("#integral_view,#integral_hidden").val(parseInt(val));
                                            }catch(e){
			
                                            }
                                        }
                                    </script>
                                </td>
                            </tr>

                        </tbody>
                    </table>
                    <br />
                    <table id="sku-console" class="table" cellpadding="0" cellspacing="0">
                        <thead>
                            <tr>
                                <th colspan="1" style="width: 50px">Sku参数</th>
                                <th colspan="3" style="width: 250px; text-align: right; font-weight: 100">虚拟库存(正数为增加,负数为减少)
                                    <input type="text" v="stock" value="" class="input" style="width: 40px" /></th>
                                <th style="width: 50px; font-weight: 100">&nbsp;</th>
                                <th style="width: 50px; font-weight: 100">
                                    <input type="text" v="weight" value="" class="input" style="width: 20px;" />
                                    克</th>
                                <th style="width: 75px; font-weight: 100">
                                    <input type="text" v="member" value="" class="input" style="width: 45px" />
                                    元</th>
                                <th style="width: 75px; font-weight: 100">
                                    <input type="text" v="mobile" value="" class="input" style="width: 45px" />
                                    元</th>
                                <th style="width: 75px; font-weight: 100">
                                    <input type="text" v="promotion" value="" class="input" style="width: 45px" />
                                    元</th>
                                <th style="font-weight: 120">
                                    <div class="console" style="margin: 0; border: 0;"><a href="javascript:;" onclick="setSkuAttr(this)">批量设置</a></div>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td style="width: 30px;">序号</td>
                                <td style="width: 80px">Sku名称</td>
                                <td style="width: 160px">商品编码</td>
                                <td style="width: 50px">虚拟库存</td>
                                <td style="width: 50px">库存</td>
                                <td style="width: 50px">重量(克)</td>
                                <td style="width: 75px">销售价</td>
                                <td style="width: 75px">手机专享</td>
                                <td style="width: 75px">促销价</td>
                                <td>&nbsp;</td>
                            </tr>
                        </tbody>
                    </table>
                    <table id="sku-table" class="table" cellpadding="0" cellspacing="0">
                        <tbody>
                            <%
                                List<SkuList> skus = new List<SkuList>();
                                if (chche.GetCache("product-GetSkusByProductId" + Info.product_id) == null)
                                {
                                    var resu = GetSkusByProductId.Do(Info.product_id);
                                    if (resu != null && resu.Body != null && resu.Body.sku_list != null)
                                    {
                                        skus = resu.Body.sku_list;
                                        chche.SetCache("product-GetSkusByProductId" + Info.product_id, skus, 60);
                                        if (skus.Count == 0)
                                            chche.RemoveCache("product-GetSkusByProductId" + Info.product_id);
                                    }
                                }
                                else
                                {
                                    skus = (List<SkuList>)chche.GetCache("product-GetSkusByProductId" + Info.product_id);
                                }
                                if (skus.Count > 0)
                                {
                                    int _idx = 0;
                                    foreach (SkuList sku in skus)
                                    {
                                        _idx++;
                                        string _idxString = _idx.ToString();
                                        if (_idx < 10) _idxString = "0" + _idxString;
                            %>
                            <tr>
                                <td style="width: 30px; text-align: center;"><%=_idxString%><input type="hidden" v="skuID" value="<%=sku.sku_id%>" /></td>
                                <td style="width: 80px">
                                    <input type="text" v="skuName" value="<%=sku.sku_name%>" class="input" style="width: 80px" /></td>
                                <td style="width: 160px">
                                    <input type="text" v="skuProductNumber" value="<%=sku.sku_code%>" onblur="checkCode(this)" class="input" style="width: 160px" /></td>
                                <td style="width: 50px">
                                    <input type="text" v="skuStock" value="<%=sku.virtual_sku_stock%>" class="input" style="width: 40px" /></td>
                                <td style="width: 50px">
                                    <input type="text" v="skuvStock" value="<%=sku.sku_stock%>" class="input" style="width: 40px" disabled /></td>
                                <td style="width: 50px">
                                    <input type="text" v="skuWeight" value="<%=sku.sku_weight%>" class="input" style="width: 40px" /></td>
                                <td style="width: 75px">
                                    <input type="text" v="skuMemberPrice" value="<%=sku.sale_price%>" class="input" style="width: 40px" />
                                    元</td>
                                <td style="width: 75px">
                                    <input type="text" v="skuMobilePrice" value="<%=sku.mobile_price%>" class="input" style="width: 40px" />
                                    元</td>
                                <td style="width: 75px">
                                    <input type="text" v="skuPromotionPrice" value="<%=sku.promotion_price%>" class="input" style="width: 40px" />
                                    元</td>
                                <td style="width: 130px"><a href="javascript:;" onclick="copyToSku(this)">复制主商品属性</a>&nbsp;<a href="javascript:;" onclick="removeSkuRow(this)">删除</a></td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                    <script type="text/javascript">
                        function createSkuNode(json){
                            var xml = '<item skuid="'+ json.SkuID +'">';
                            xml += '<name><![CDATA['+ json.SkuName +']]></name>';
                            xml += '<code><![CDATA['+ json.SkuNumber +']]></code>';
                            xml += '<stock>'+ json.SkuStock +'</stock>';
                            xml += '<weight>'+ json.SkuWeight +'</weight>';
                            xml += '<memberprice>'+ json.SkuMemberPrice +'</memberprice>';
                            xml += '<mobileprice>'+ json.SkuMobilePrice +'</mobileprice>';
                            xml += '<promotionprice>'+ json.SkuPromotionPrice +'</promotionprice>';
                            xml += '</item>';
                            return xml;
                        }
                    </script>
                    <script type="text/javascript">
                        function copyToSku(obj){
                            var row=$(obj).parent("td").parent("tr");
                            row.find("input[v='skuWeight']").val($("#attr-weight").val());
                            row.find("input[v='skuStock']").val($("#attr-stock").val());
                            row.find("input[v='skuMemberPrice']").val($("#attr-member").val());
                            row.find("input[v='skuMobilePrice']").val($("#attr-mobile").val());
                            row.find("input[v='skuPromotionPrice']").val($("#attr-promotion").val());
                        }
                        var skuRowIndex=<%=skus.Count>0?skus.Count:0%>;
                        $(function(){
                            if(skuRowIndex>0){
                                $("#attr-stock").attr("readonly",true).css({"color": "#999"});
                            }
                        });
                        function addSkuRow(){
                            var skucount1 = $("*[v='skuID']").length; 
                            if(<%=Info.product_join_id %>>0 && skucount1==0){
                                jsbox.error("该商品不允许添加Sku！");
                            }else{
                                var addRowCount=$("#addRowCount").val();
                                var count = Atai.isInt(addRowCount) ? parseInt(addRowCount) : 1;
                                if(count<1) count=1;
                                for(var i=0;i<count;i++){
                                    skuRowIndex++;
                                    var sIdx=skuRowIndex.toString();
                                    if(skuRowIndex<10) sIdx="0" + sIdx;
                                    var html='<tr><td style="width:30px;text-align:center;">'+ sIdx +'<input type="hidden" v="skuID" value=""/></td>';
                                    html += '<td style="width:80px"><input type="text" v="skuName" value="" class="input" style="width:80px"/></td>';
                                    html += '<td style="width:160px"><input type="text" v="skuProductNumber" onblur="checkCode(this)" value="" class="input" style="width:160px"/></td>';
                                    html += '<td style="width:50px"><input type="text" v="skuStock" value="" class="input" style="width:40px"/></td>';
                                    html += '<td style="width:50px"><input type="text" v="skuvStock" value="0" class="input" style="width:40px" disabled/></td>';
                                    html += '<td style="width:50px"><input type="text" v="skuWeight" value="" class="input" style="width:40px"/></td>';
                                    html += '<td style="width:80px"><input type="text" v="skuMemberPrice" value="" class="input" style="width:40px"/> 元</td>';
                                    html += '<td style="width:80px"><input type="text" v="skuMobilePrice" value="" class="input" style="width:40px"/> 元</td>';
                                    html += '<td style="width:80px"><input type="text" v="skuPromotionPrice" value="" class="input" style="width:40px"/> 元</td>';
                                    html += '<td style="width:130px"><a href="javascript:;" onclick="copyToSku(this)">复制主商品属性</a>&nbsp;<a href="javascript:;" onclick="removeSkuRow(this)">删除</a></td></tr>';
                                    $("#sku-table tbody").append(html);
                                }
                                $("#attr-stock").attr("readonly",true).css({"color": "#999"});
                                $("#addRowCount").val(1);
                            }
                            //$('#span-addCout').html(1);
                        }
                        function removeSkuRow(obj){
                            var skucount2 = $("*[v='skuID']").length;
                            if(<%=Info.product_join_id %>>0 && skucount2 == 1){
                                jsbox.error("该商品已关联，至少要有1条Sku！");
                            }else{
                                $(obj).parent("td").parent("tr").remove();
                                if($("#sku-table tbody tr").length>0){
                                    $("#attr-stock").attr("readonly",false).css({"color": "#111"});
                                }
                            }
                        }
                        function setSkuAttr(obj){
                            var stock=$("#sku-console thead input[v='stock']").val();
                            var weight=$("#sku-console thead input[v='weight']").val();
                            var member=$("#sku-console thead input[v='member']").val();
                            var mobile=$("#sku-console thead input[v='mobile']").val();
                            var promotion=$("#sku-console thead input[v='promotion']").val();
                            var resetStock=true;
                            if(Atai.isInt(stock)){
                                stock=parseInt(stock);
                            }else{
                                resetStock = false;
                            }
                            weight = Atai.isInt(weight) ? parseInt(weight) : -1;
	
                            member = Atai.isNumber(member) ? parseFloat(member) : -1;
                            mobile = Atai.isNumber(mobile) ? parseFloat(mobile) : -1;
                            promotion = Atai.isNumber(promotion) ? parseFloat(promotion) : -1;
                            $("#sku-table tbody tr").each(function(){
                                var row=$(this);
                                var _st=row.find("input[v='skuStock']").val();
                                var _stock=stock;
                                if(Atai.isInt(_st)){
                                    _stock = parseInt(_st) + stock;
                                    $("#sku-console thead input[v='stock']").val('');
                                }
                                if(_stock<0) _stock=0;
                                if(resetStock)
                                    row.find("input[v='skuStock']").val(_stock);
                                if(weight>=0)
                                    row.find("input[v='skuWeight']").val(weight);
                                if(member>=0)
                                    row.find("input[v='skuMemberPrice']").val(member);
                                if(mobile>=0)
                                    row.find("input[v='skuMobilePrice']").val(mobile);
                                if(promotion>=0)
                                    row.find("input[v='skuPromotionPrice']").val(promotion);
                            });
                        }
                    </script>
                    <table class="table" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr>
                                <td style="width: 66px;">+
                                    <input type="text" id="addRowCount" onclick="this.select()" value="1" class="input" style="width: 20px; text-align: center;" />
                                    行</td>
                                <td colspan="6"><strong onclick="addSkuRow()" style="color: #00F; cursor: pointer"><b class="icon-add">&nbsp;</b>增加SKU</strong></td>
                            </tr>
                        </tbody>
                    </table>
                    <br />
                    <table class="table" cellpadding="0" cellspacing="0">
                        <thead>
                            <tr>
                                <th colspan="4">运费设置</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">运费设置</td>
                                <td colspan="2">
                                    <input type="radio" name="isFreeFare" value="0" <%=(Info.is_free_fare<1 || Info.is_free_fare>2)?" checked=\"checked\"":""%> />
                                    不包邮
    &nbsp;|&nbsp;
    <input type="radio" name="isFreeFare" value="1" <%=(Info.is_free_fare==1)?" checked=\"checked\"":""%> />
                                    包邮
    <span class="tips-text" id="tips-fare">&nbsp;</span>
                                </td>
                            </tr>

                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">包邮时间</td>
                                <td colspan="2">
                                    <%if (Info.free_fare_stime == null)
                                            Info.free_fare_stime = DateTime.Now.ToString();
                                        if (Info.free_fare_etime == null)
                                            Info.free_fare_etime = DateTime.Now.ToString(); %>
                                    <input type="text" id="fare-sdate" name="fsdate" value="<%=DateTime.Parse(Info.free_fare_stime).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()" />
                                    <input type="text" id="fare-shours" name="fshours" value="<%=DateTime.Parse(Info.free_fare_stime).ToString("HH")%>" class="input" style="width: 40px" title="数字0至23" />
                                    时
    <input type="text" id="fare-sminutes" name="fsminutes" value="<%=DateTime.Parse(Info.free_fare_stime).ToString("mm")%>" class="input" style="width: 40px" title="数字0至59" />
                                    分

至

    <input type="text" id="fare-edate" name="fedate" value="<%=DateTime.Parse(Info.free_fare_etime).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()" />
                                    <input type="text" id="fare-ehours" name="fehours" value="<%=DateTime.Parse(Info.free_fare_etime).ToString("HH")%>" class="input" style="width: 40px" title="数字0至23" />
                                    时
    <input type="text" id="fare-eminutes" name="feminutes" value="<%=DateTime.Parse(Info.free_fare_etime).ToString("mm")%>" class="input" style="width: 40px" title="数字0至59" />
                                    分
                                    <script type="text/javascript">
                                        $(function(){
                                            var tips=$("#tips-fare");
                                            $("#fare-shours").keyup(function(){
                                                if(Atai.isInt(this.value)
                                                    && parseInt(this.value)>=0
                                                    && parseInt(this.value)<24){
                                                    tips.removeClass("tips-icon").html("");
                                                }else{
                                                    tips.addClass("tips-icon").html("[时] 请填写0至23之间的数字");
                                                }
                                            });
                                            $("#fare-sminutes").keyup(function(){
                                                if(Atai.isInt(this.value)
                                                    && parseInt(this.value)>=0
                                                    && parseInt(this.value)<60){
                                                    tips.removeClass("tips-icon").html("");
                                                }else{
                                                    tips.addClass("tips-icon").html("[分] 请填写0至59之间的数字");
                                                }
                                            });
                                        });
                                        $(function(){
                                            var tips=$("#tips-fare");
                                            $("#fare-ehours").keyup(function(){
                                                if(Atai.isInt(this.value)
                                                    && parseInt(this.value)>=0
                                                    && parseInt(this.value)<24){
                                                    tips.removeClass("tips-icon").html("");
                                                }else{
                                                    tips.addClass("tips-icon").html("[时] 请填写0至23之间的数字");
                                                }
                                            });
                                            $("#fare-eminutes").keyup(function(){
                                                if(Atai.isInt(this.value)
                                                    && parseInt(this.value)>=0
                                                    && parseInt(this.value)<60){
                                                    tips.removeClass("tips-icon").html("");
                                                }else{
                                                    tips.addClass("tips-icon").html("[分] 请填写0至59之间的数字");
                                                }
                                            });
                                        });
                                    </script>
                                    <span class="tips-text" id="tips-stime">&nbsp;</span></td>
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable" valign="top">运费模板</td>
                                <td colspan="2">
                                    <%
                                        List<FareTempInfo> tempList = new List<FareTempInfo>();
                                        if (chche.GetCache("templist") == null)
                                        {
                                            var restemp = GetFareTempList.Do(-1);
                                            if (restemp != null && restemp.Body != null && restemp.Body.fare_temp_list != null)
                                            {
                                                tempList = restemp.Body.fare_temp_list;
                                                chche.SetCache("templist", tempList);
                                                if (tempList.Count == 0)
                                                {
                                                    chche.RemoveCache("templist");
                                                }
                                            }
                                        }
                                        else
                                        {
                                            tempList = (List<FareTempInfo>)chche.GetCache("templist");
                                        }
                                        foreach (FareTempInfo temp in tempList)
                                        {
                                            if (temp.template_state != 1)
                                                continue;
                                    %>
                                    <p>
                                        <input type="radio" name="faretempid" value="<%=temp.template_id%>" <%if ((Info.is_free_fare == 1 && temp.is_system == 1) || (temp.template_id == Info.fare_temp_id)) { Response.Write(" checked=\"checked\""); }%> />
                                        &nbsp;<%=temp.template_name%>
                                    </p>
                                    <%
                                        }
                                    %>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <script type="text/javascript">
                        function checkseaflag(obj){
                            if($(obj).prop("checked")){
                                $("#seaflagtable").css('display','block')
                            }
                            else{
                                $("#seaflagtable").css('display','none')
                            }
                        }
                    </script>
                    <table class="table" cellpadding="0" cellspacing="0" id="seaflagtable" style="<%=(Info.sea_flag==0?"display:none": "display:block") %>">
                        <thead>
                            <tr>
                                <th colspan="4">税费设置</th>
                            </tr>
                        </thead>
                        <% 
                            OverseasInfo rsinfo = new OverseasInfo();
                            var reovp = GetOverseasProductId.Do(Info.product_id);
                            if (reovp != null && reovp.Body != null)
                            {
                                rsinfo = reovp.Body;
                            }
                            else
                            {
                                rsinfo = new OverseasInfo();
                                rsinfo.id = "0";
                            }
                        %>
                        <tbody>
                            <input type="hidden" value="<%=rsinfo.id %>" name="overseaid" id="overseaid" />
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">免税</td>
                                <td colspan="2">
                                    <input type="radio" name="isfreetax" value="0" <%=(rsinfo.isfreetax=="0")?" checked=\"checked\"":""%> />
                                    不免税
    &nbsp;|&nbsp;
    <input type="radio" name="isfreetax" value="1" <%=(rsinfo.isfreetax=="1")?" checked=\"checked\"":""%> />
                                    商家免税
    <span class="tips-text" id="tips-freetax">&nbsp;</span>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">商家免税时间</td>
                                <td colspan="2">
                                    <%if (rsinfo.freestarttime == null)
                                            rsinfo.freestarttime = DateTime.Now.ToString();
                                        if (rsinfo.freeendtime == null)
                                            rsinfo.freeendtime = DateTime.Now.ToString(); %>
                                    <input type="text" id="freetax-sdate" name="ftsdate" value="<%=DateTime.Parse(rsinfo.freestarttime).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()" />
                                    <input type="text" id="freetax-shours" name="ftshours" value="<%=DateTime.Parse(rsinfo.freestarttime).ToString("HH")%>" class="input" style="width: 40px" title="数字0至23" />
                                    时
    <input type="text" id="freetax-sminutes" name="ftsminutes" value="<%=DateTime.Parse(rsinfo.freestarttime).ToString("mm")%>" class="input" style="width: 40px" title="数字0至59" />
                                    分

至

    <input type="text" id="freetax-edate" name="ftedate" value="<%=DateTime.Parse(rsinfo.freeendtime).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()" />
                                    <input type="text" id="freetax-ehours" name="ftehours" value="<%=DateTime.Parse(rsinfo.freeendtime).ToString("HH")%>" class="input" style="width: 40px" title="数字0至23" />
                                    时
    <input type="text" id="freetax-eminutes" name="fteminutes" value="<%=DateTime.Parse(rsinfo.freeendtime).ToString("mm")%>" class="input" style="width: 40px" title="数字0至59" />
                                    分
                                    <script type="text/javascript">
                                        $(function(){
                                            var tips=$("#tips-freetax");
                                            $("#freetax-shours").keyup(function(){
                                                if(Atai.isInt(this.value)
                                                    && parseInt(this.value)>=0
                                                    && parseInt(this.value)<24){
                                                    tips.removeClass("tips-icon").html("");
                                                }else{
                                                    tips.addClass("tips-icon").html("[时] 请填写0至23之间的数字");
                                                }
                                            });
                                            $("#freetax-sminutes").keyup(function(){
                                                if(Atai.isInt(this.value)
                                                    && parseInt(this.value)>=0
                                                    && parseInt(this.value)<60){
                                                    tips.removeClass("tips-icon").html("");
                                                }else{
                                                    tips.addClass("tips-icon").html("[分] 请填写0至59之间的数字");
                                                }
                                            });
                                        });
                                        $(function(){
                                            var tips=$("#tips-freetax");
                                            $("#freetax-ehours").keyup(function(){
                                                if(Atai.isInt(this.value)
                                                    && parseInt(this.value)>=0
                                                    && parseInt(this.value)<24){
                                                    tips.removeClass("tips-icon").html("");
                                                }else{
                                                    tips.addClass("tips-icon").html("[时] 请填写0至23之间的数字");
                                                }
                                            });
                                            $("#freetax-eminutes").keyup(function(){
                                                if(Atai.isInt(this.value)
                                                    && parseInt(this.value)>=0
                                                    && parseInt(this.value)<60){
                                                    tips.removeClass("tips-icon").html("");
                                                }else{
                                                    tips.addClass("tips-icon").html("[分] 请填写0至59之间的数字");
                                                }
                                            });
                                        });
                                    </script>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">税率</td>
                                <td colspan="2">
                                    <% 
                                         //Response<TaxrateList> resptax = null;
                                        Response<TaxrateList> resptax = QueryTaxrate.Do();
                                        if (resptax != null && resptax.Body != null&& resptax.Body.taxrate_list != null)
                                        {
                                            TaxrateList taxratelist = resptax.Body;
                                    %>
                                    <select id="sel_taxrate" name="sel_taxrate">
                                        <%foreach (var item in taxratelist.taxrate_list)
                                            {
                                                if (rsinfo.taxrate == item.id.ToString())
                                                {%>
                                        <option value="<%=item.id %>" selected="selected"><%=item.category+item.type+"("+item.taxrate+"%)" %></option>
                                        <%}
                                        else
                                        { %>
                                          <option value="<%=item.id %>" ><%=item.category+item.type+"("+item.taxrate+"%)" %></option>
                                        <%}
                                        }%>
                                    </select>
                                    <%} %>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">国家</td>
                                <td colspan="2">
                                    
                                    <% 
                                        //Response<ContryList> respcontry = null;
                                        Response<ContryList> respcontry = QueryCountry.Do();
                                        if (respcontry != null && respcontry.Body != null&& respcontry.Body.country_list != null)
                                        {
                                            ContryList contrylist = respcontry.Body;
                                    %>
                                    <select id="sel_code" name="sel_code">
                                        <%foreach (var item in contrylist.country_list)
                                            {
                                                if (rsinfo.countrycode == item.id.ToString())
                                                {%>
                                        <option value="<%=item.id %>" selected="selected"><%=item.cn %></option>
                                        <%}
                                        else
                                        { %>
                                        <option value="<%=item.id %>"><%=item.cn %></option>
                                        <%}
                                        }%>
                                    </select>
                                    <%} %>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">海仓编码</td>
                                <td colspan="2">
                                    <input type="text" id="tx_hscode" name="tx_hscode" value="<%=rsinfo.hscode %>" class="input" style="width: 164px" />
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <br />
                    <table class="table" cellpadding="0" cellspacing="0">
                        <thead>
                            <tr>
                                <th>商品细节图</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <dl id="db-images">
                                        <%
                                            for (int i = 1; i <= 5; i++)
                                            {
                                        %>
                                        <dt>
                                            <input type="hidden" id="upload-image<%=i%>" v="image" imgid="0" isdef="0" value="" />
                                            <div id="upload-box-image<%=i%>" onclick="ajaxUploadClick(this, Atai.$('#upload-image<%=i%>'))">
                                                <br />
                                                <br />
                                                <br />
                                                图片尺寸 800×800 像素<br />
                                                点击此处上传图片
                                            </div>
                                            <p>
                                                <a href="javascript:;" onclick="showImageListBox(setProImage<%=i%>)">去图库选图</a>
                                                &nbsp;&nbsp;<a href="javascript:;" onclick="$('#upload-box-image<%=i%>').click()">本地上传</a>
                                            </p>
                                            <p class="op">
                                                <a href="javascript:;" onclick="deleteImage('upload-image<%=i%>','<%=i%>')">删除图片&nbsp;</a>
                                                &nbsp;&nbsp;<a href="javascript:;" class="sdef" onclick="setImageDefault('upload-image<%=i%>','<%=i%>')">设为主图</a>
                                            </p>
                                        </dt>
                                        <%
                                            }
                                        %>
                                        <dd class="clear"></dd>
                                    </dl>
                                    <script type="text/javascript">
<%
                                        for (int i = 1; i <= 5; i++)
                                        {
%>
                                        function setProImage<%=i%>(path,fullPath){
                                            Atai.$("#upload-image<%=i%>").value=path;
                                            var _uploadImageBox=Atai.$("#upload-box-image<%=i%>");
                                            var path = formatImageUrl(fullPath, 120, 120);
                                            //var path=isIncludeHost(path) ? path : formatImageUrl2(fullPath, 120, 120);
                                            _uploadImageBox.style.background="url(" + path + ") center center no-repeat";
                                            _uploadImageBox.innerHTML="";
                                        }
                                        <%  int _i = i - 1;
                                            if (imageList.Count > _i && _i >= 0)
                                            {
                                                ProductAlbumList _image = imageList[_i];
                                                if (!string.IsNullOrEmpty(_image.img_src))
                                                {
                                                    Response.Write("$(function(){");
                                                    if (_image.is_main == 1) Response.Write("$('#upload-box-image" + i + "').parent('dt').addClass('hover');");
                                                    Response.Write("$('#upload-image" + i + "').attr('imgid','" + _image.product_album_id + "').attr('isdef','" + _image.is_main + "');");
                                                    Response.Write("setProImage" + i + "('" + _image.img_src + "','" + FormatImagesUrl.GetProductImageUrl(_image.img_src, -1, -1) + "');");
                                                    Response.Write("});\r\n");
                                                }
                                            }
                                        }
%>
                                    </script>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <br />
                    <table class="table" cellpadding="0" cellspacing="0">
                        <thead>
                            <tr>
                                <th colspan="4">商品详情</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td colspan="4">
                                    <textarea id="detailContents" name="detail" class="textarea" style="height: 260px"><%=Info.product_detail%></textarea>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <br />
                    <table class="table" cellpadding="0" cellspacing="0">
                        <thead>
                            <tr>
                                <th style="width: 3%">&nbsp;</th>
                                <th class="lable">
                                    <input type="submit" id="loadding3" value="  确定提交  " class="submit" /></th>
                                <th colspan="2">
                                    <div class="tips-text" id="tips-message"></div>
                                </th>
                            </tr>
                        </thead>
                    </table>
                </div>
            </form>
            <br />
            <br />
            <br />
            <br />
        </div>
    </div>
    <br />
    <br />
    <script type="text/javascript">
        var ckeditor=null;
        $(function(){
            ckeditor = CKEDITOR.replace('detailContents');
        });
        function setImage(path,fullPath){
            var html = '<img src="' + fullPath+ '"/>';
            CKEDITOR.instances.detailContents.insertHtml(html);
        }
        function setImages(bkstring) {

            CKEDITOR.instances.detailContents.insertHtml(bkstring);
        }
        function setImage2(obj,path,fullPath){
            setImage(path,fullPath);
        }
        function _fckCallback(){
            showImageListBox(setImage);
        }
        function _fckAddPicCallback(){
            upload(new Object(),setImage2);
        }
        function _batchCallback(){
            resetBatchUploadBox(setImages);
        }

    </script>
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

        function createXmlNode(path, imgid, isdef){
            return '<item path="'+ path +'" imgid="'+ imgid +'" isdef="'+ isdef +'"/>';
        }

        function submitProductForm(form) {
            if(showLoadding) showLoadding();
            $("#detailContents").val(CKEDITOR.instances.detailContents.getData())
	
            var nodes=[];
            for(var i=1;i<=5;i++){
                var o=$("#upload-image" + i);
                nodes.push(createXmlNode(o.val(), o.attr("imgid"), o.attr("isdef")));
            }
            var xml = createXmlDocument(nodes);

            //return false;
            var skuNodes=[];
            var skuError=false;
            var skuMinPrice = skuMinPrice2 = skuMinPromotion = 99999999;
            var skuMaxPrice = skuMaxPrice2 = skuMaxPromotion = 0;
            var skuStockCount=0;
            $("#sku-table tbody tr").each(function(){
                var skuID=$(this).find("input[v='skuID']").val();
                var skuName=$(this).find("input[v='skuName']").val();
                var skuProductNumber=$(this).find("input[v='skuProductNumber']").val();
                var skuWeight=$(this).find("input[v='skuWeight']").val();
                var skuStock=$(this).find("input[v='skuStock']").val();
                var skuMemberPrice=$(this).find("input[v='skuMemberPrice']").val();
                var skuMobilePrice=$(this).find("input[v='skuMobilePrice']").val();
                var skuPromotionPrice=$(this).find("input[v='skuPromotionPrice']").val();
		
                if(skuName.length>0 || skuProductNumber.length>0
                || skuWeight.length>0 || skuStock.length>0
                || skuMemberPrice.length>0 || skuMobilePrice.length>0
                || skuPromotionPrice.length>0)
                {
                    if(skuName.length<1 || skuProductNumber.length<1
                        || skuWeight.length<1 || skuStock.length<1
                        || skuMemberPrice.length<1 || skuMobilePrice.length<1
                    || skuPromotionPrice.length<1){
                        skuError=true;
                    }
                }
                if(Atai.isNumber(skuMemberPrice)){
                    if(parseFloat(skuMemberPrice)<skuMinPrice)
                        skuMinPrice=parseFloat(skuMemberPrice);
                    if(parseFloat(skuMemberPrice)>skuMaxPrice)
                        skuMaxPrice=parseFloat(skuMemberPrice);
                }
                if(Atai.isNumber(skuMobilePrice)){
                    if(parseFloat(skuMobilePrice)<skuMinPrice2)
                        skuMinPrice2=parseFloat(skuMobilePrice);
                    if(parseFloat(skuMobilePrice)>skuMaxPrice2)
                        skuMaxPrice2=parseFloat(skuMobilePrice);

                }

                if (Atai.isNumber(skuPromotionPrice)) {
                    if (parseFloat(skuPromotionPrice) < skuMinPromotion)
                        skuMinPromotion = parseFloat(skuPromotionPrice);
                    if (parseFloat(skuPromotionPrice) > skuMaxPromotion)
                        skuMaxPromotion = parseFloat(skuPromotionPrice);
                }

                if(Atai.isInt(skuStock)){
                    skuStockCount += parseInt(skuStock);
                }
                skuNodes.push(createSkuNode({
                    "SkuID" : skuID
                    ,"SkuName" : skuName
                    ,"SkuNumber" : skuProductNumber
                    ,"SkuStock" : skuStock
                    ,"SkuWeight" : skuWeight
                    ,"SkuMemberPrice" : skuMemberPrice
                    ,"SkuMobilePrice" : skuMobilePrice
                    ,"SkuPromotionPrice" : skuPromotionPrice
                }));
            });
            var skuXml = createXmlDocument(skuNodes);
            if(skuError){
                if(closeLoadding) closeLoadding();
                jsbox.error("[Sku参数] 必须填写完整");
                if (closeLoadding) closeLoadding();
                return false;
            }
            if(skuNodes.length>0){
                var member=$("#attr-member").val();
                var mobile=$("#attr-mobile").val();
                var promotion=$("#attr-promotion").val();
                /*	if(!Atai.isNumber(member) || parseFloat(member) < skuMinPrice){
                        if(closeLoadding) closeLoadding();
                        jsbox.error("[销售价格] 不能低于Sku价格(最低 "+ skuMinPrice +")");
                        return false;
                    }else if(parseFloat(member) > skuMaxPrice){
                        if(closeLoadding) closeLoadding();
                        jsbox.error("[销售价格] 不高于Sku价格(最高 "+ skuMaxPrice +")");
                        return false;
                    }
                    if(!Atai.isNumber(mobile) || parseFloat(mobile) < skuMinPrice2){
                        if(closeLoadding) closeLoadding();
                        jsbox.error("[手机专享价] 不能低于Sku手机专享价(最低 "+ skuMinPrice2 +")");
                        return false;
                    }else if(parseFloat(mobile) > skuMaxPrice2){
                        if(closeLoadding) closeLoadding();
                        jsbox.error("[手机专享价] 不高于Sku手机专享价(最高 "+ skuMaxPrice2 +")");
                        return false;
                    } */
                if (!Atai.isNumber(promotion) || parseFloat(promotion) < skuMinPromotion) {
                    if (closeLoadding) closeLoadding();
                    jsbox.error("[促销价格] 不能低于Sku促销价(最低 " + skuMinPromotion + ")");
                    return false;
                } else if (parseFloat(promotion) > skuMaxPromotion) {
                    if (closeLoadding) closeLoadding();
                    jsbox.error("[销售价格] 不高于Sku价格(最高 " + skuMaxPromotion + ")");
                    return false;
                }
                $("#attr-stock").val(skuStockCount);
            }
            if (parseFloat($("input[name='promotion_price']").val()) > parseFloat($("input[name=member_price]").val())) {
                jsbox.error("[促销价] 不高于 [商品售价]");
                if (closeLoadding) closeLoadding();
                return false;
            }
            var postData = getPostDB(form);
            $.ajax({
                url: "/MGoods/PostProductData"
                    , data: postData + "&xml=" + encodeURIComponent(xml) + "&sku=" + encodeURIComponent(skuXml)
                    , dataType: "json"
                    , type: "post"
                    , success: function (json) {
                        if (json.error) {
                            jsbox.error(json.message);
                        } else {
                            jsbox.success(json.message, window.location.href);
                        }
                        if (closeLoadding) closeLoadding();
                    }, error: function (http, textStatus, errorThrown) {
                        jsbox.error(errorThrown);
                    }
            });
            return false;
        }
        function deleteImage(id, idx){
            jsbox.confirm('您确定要删除这张图片吗？',function(){
                var postData={
                    "proid" : '<%=Info.product_id%>'
		,"imgid" : $("#" + id).attr("imgid")
                };
                $.ajax({
                    url: "/MGoods/DeleteProductImage"
                    , type: "post"
                    , data: postData
                    , dataType: "json"
                    , success: function(json, textStatus){
                        var o=$("#" + id);
                        o.attr("imgid",0).attr("isdef",0);
                        o.val("");//成功
                        var uo=$("#upload-box-image" + idx);
                        //alert(uo);
                        uo.css({"background": "none"});
                        uo.html('<br/><br/><br/>图片尺寸 800×800 像素<br/>点击此处上传图片')
			
                    }, error: function(http, textStatus, errorThrown){
                        jsbox.error(errorThrown);
                    }
                });
            });
                    return false;
                }

                function checkCode(obj) {
                    $("#codemsg").html("");
                    $.ajax({
                        url: "/MGoods/CheckProduct_Code"
                        , type: "post"
                        , data: "code=" + $(obj).val()
                        , dataType: "json"
                        , success: function (json, textStatus) {
                            if (json.error) {
                                $("#codemsg").css('color', 'red');
                                $("#codemsg").html(json.message);
                            } else {
                                $("#codemsg").css('color', 'green');
                                $("#codemsg").html("该编码可使用!");
                            }
                        }, error: function (http, textStatus, errorThrown) {
                            jsbox.error(errorThrown);
                        }
                    });
                    return false;
                }

                function setImageDefault(id){
                    for(var i=1;i<=5;i++){
                        $("#upload-image" + i).attr("isdef", 0);
                        $("#upload-image" + i).parent().removeClass("hover");
                    }
                    $("#" + id).attr("isdef", 1);
                    $("#" + id).parent().addClass("hover");
                }
                Atai.addEvent(window,"click",function(){
                    $("#tips-message").removeClass("tips-icon").html("");
                });
    </script>
    <%Html.RenderPartial("Base/_PageFootControl"); %>
    <%Html.RenderPartial("UploadBaseControl"); %>
    <%Html.RenderPartial("UploadImageControl"); %>
    <%Html.RenderPartial("ImageListBoxControl");//图片选择 %>
    <%Html.RenderPartial("MGoods/SelectCategControl"); %>
    <%Html.RenderPartial("MGoods/BatchUploadControl"); %>
</body>
</html>

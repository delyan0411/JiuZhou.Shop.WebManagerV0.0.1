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
    <title><%=ViewData["pageTitle"]%></title>
</head>
<body>
    <%Html.RenderPartial("Base/_SimplePageTopControl"); %>
    <%
        int ruleid = DoRequest.GetQueryInt("getid", 0);
        int type = DoRequest.GetQueryInt("type", 0);
        ConfigInfo config = (ConfigInfo)(ViewData["config"]);
        CouponGetRuleInfo info = new CouponGetRuleInfo();
        var resinfo = GetCouponGetRuleDetail.Do(ruleid);
        if (resinfo != null && resinfo.Body != null)
            info = resinfo.Body;
        List<CouponGetItem> items = new List<CouponGetItem>();
        if (info.item_list != null)
            items = info.item_list;
    %>
    <div id="container-syscp">
        <div class="container-left">
            <%Html.RenderPartial("Base/LeftControl"); %>
        </div>
        <div class="container-right">
            <div class="editor-box-head" style="position: relative">
                编辑优惠券领取规则
            </div>
            <div class="div-tab">
                <form id="fareTempForm" method="post" action="" onsubmit="return submitForm(this)">
                    <input type="hidden" name="ruleid" value="<%=ruleid%>" />
                    <table class="table" cellpadding="0" cellspacing="0">
                        <tbody>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">活动名称<b>*</b></td>
                                <td class="inputText">
                                    <input type="text" name="name" must="1" value="<%=info.cget_name%>" class="input" style="width: 320px" /></td>
                                <%--<td class="lable">有 效 期<b>*</b></td>
      <td class="inputText">
          <input type="text" name="validitydays" must="1" value="<%=info.validity_days>0?info.validity_days:30%>" class="input" style="width: 40px" />
          天
      </td>--%>
                                <td class="lable">类型<b>*</b></td>
                                <td class="inputText">
                                    <%=(type==0)?"店铺券":"商品券" %>
                                    <%if (type == 0)
                                        { %>
                                    <input type="hidden" name="type" id="type" value="0" />
                                    <%}
                                        else
                                        { %>
                                    <input type="hidden" name="type" id="type" value="1" />
                                    <%} %>                                
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">发行量<b>*</b></td>
                                <td class="inputText">
                                    <%--总数量：--%>
                                    <input type="text" name="maxgivenum" must="1" value="<%=info.max_give_num%>" class="input" style="width: 50px" />
                                    张&nbsp; 

                                </td>
                                <td class="lable">限领<b>*</b></td>
                                <td class="inputText">
                                    <%--总领取量：--%>
                                    <input type="text" name="limitperusertotal" must="1" value="<%=info.limit_per_user_total%>" class="input" style="width: 50px" />
                                    张&nbsp; 
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">使用开始<b>*</b></td>
                                <td class="inputText">
                                    <input type="text" id="box-sdate" name="sdate" value="<%=info.start_time==null?DateTime.Now.ToString("yyyy-MM-dd"):DateTime.Parse(info.start_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()" />
                                    <input type="text" id="box-shours" name="shours" value="<%=info.start_time==null?"00":DateTime.Parse(info.start_time).Hour.ToString()%>" class="input" style="width: 40px" title="数字0至23" />时
                                    <input type="text" id="box-sminutes" name="sminutes" value="<%=info.start_time==null?"00":DateTime.Parse(info.start_time).Minute.ToString()%>" class="input" style="width: 40px" title="数字0至59" />分
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
                                    </script>
                                </td>
                                <td colspan="2">
                                    <div class="tips-text" id="tips-starttime">&nbsp;</div>
                                </td>
                            </tr>

                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">使用截止<b>*</b></td>
                                <td class="inputText">
                                    <input type="text" id="box-edate" name="edate" value="<%=info.end_time==null?DateTime.Now.AddDays(7).ToString("yyyy-MM-dd"):DateTime.Parse(info.end_time).ToString("yyyy-MM-dd")%>" readonly="readonly" class="date" onclick="WdatePicker()" />
                                    <input type="text" id="box-ehours" name="ehours" value="<%=info.end_time==null?"23":DateTime.Parse(info.end_time).Hour.ToString()%>" class="input" style="width: 40px" title="数字0至23" />时
                                    <input type="text" id="box-eminutes" name="eminutes" value="<%=info.end_time==null?"59":DateTime.Parse(info.end_time).Minute.ToString()%>" class="input" style="width: 40px" title="数字0至59" />分
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
                                <td colspan="2">
                                    <div class="tips-text" id="tips-endtime">&nbsp;</div>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 3%">&nbsp;</td>
                                <td class="lable">备&nbsp;&nbsp;注</td>
                                <td colspan="3">
                                    <input type="text" name="remarks" value="<%=info.cget_remark%>" class="input" style="width: 620px" />
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </form>
                <div id="fare-rules">
                    <%
                        string proids = "";
                        if (ruleid != 0)
                        {
                            int _count2 = 0;
                            foreach (CouponGetItem item in items)
                            {
                                _count2++;
                                if (_count2 > 1)
                                {
                                    break;
                                }
                                proids = item.proids;
                    %>
                    <table v="table-rules" class="table-rules" style="margin-top: 20px" cellpadding="0" cellspacing="0">
                        <input type="hidden" name="itemid" value="<%=item.cget_item_id %>" />
                        <thead>
                            <tr>
                                <th colspan="5">面额信息 <b style="color: #F00">*</b></th>
                                <th style="text-align: right"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td style="width: 3%"></td>
                                <td class="lable">优惠券金额</td>
                                <td class="inputText">
                                    <input type="text" name="couponprice" id="couponprice" must="1" value="<%=item.coupon_price %>" class="input" style="width: 50px" />
                                </td>
                                <td class="lable">使用门槛</td>
                                <td class="inputText" colspan="2">
                                    <input type="text" name="couponcond" id="couponcond" must="1" value="<%=item.coupon_cond %>" class="input" style="width: 50px" />
                                </td>
                            </tr>
                            <tr class="bg">
                                <td style="width: 3%"></td>
                                <td colspan="5">领取链接为：JS: &lt;a href="javascript:;" onclick="GetCoupon(<%=item.cget_item_id %>)"&gt;领取xx元优惠券&lt;/a&gt;URL: <%=config.UrlHome %>tools/GetCoupon?itemId=<%=item.cget_item_id %>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <%}
                        }
                        else
                        {
                    %>
                    <table v="table-rules" class="table-rules" style="margin-top: 20px" cellpadding="0" cellspacing="0">
                        <input type="hidden" name="itemid" value="0" />
                        <thead>
                            <tr>
                                <th colspan="5">面额信息 <b style="color: #F00">*</b></th>
                                <th style="text-align: right"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td style="width: 3%"></td>
                                <td class="lable">优惠券金额</td>
                                <td class="inputText">
                                    <input type="text" name="couponprice" id="couponprice" must="1" value="" class="input" style="width: 50px" />
                                </td>
                                <td class="lable">使用门槛</td>
                                <td class="inputText" colspan="2">
                                    <input type="text" name="couponcond" id="couponcond" must="1" value="" class="input" style="width: 50px" />
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <%  }
                    %>
                </div>
                <% if (type == 1)
                    { %>
                <table id="table-ItemProductSelector" class="table" cellpadding="0" cellspacing="0">
                    <thead>
                        <tr>
                            <th style="width: 3%">&nbsp;</th>
                            <th colspan="2">
                                <div style="position: relative">
                                    <div class="console" style="padding: 0; margin: 0; border: 0; height: auto; line-height: auto; text-align: left;">
                                        <a href="javascript:;" onclick="showItemProductSelector()"><b class="add">&nbsp;</b>选择商品...</a>
                                    </div>
                                </div>
                            </th>
                            <th style="width: 8%">操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%  
                            if (proids != "")
                            {
                                List<ShortProductInfo> list = new List<ShortProductInfo>();
                                var res = GetShortProductsByProductIds.Do(proids);
                                if (res != null && res.Body != null && res.Body.product_list != null)
                                    list = res.Body.product_list;
                                foreach (ShortProductInfo item in list)
                                {
                                    DateTime _sDate = DateTime.Parse(item.promotion_bdate);
                                    DateTime _eDate = DateTime.Parse(item.promotion_edate);
                                    if (_sDate <= DateTime.Now && DateTime.Now <= _eDate)
                                    {
                                        item.sale_price = item.promotion_price;//促销价
                                    }
                                }

                                List<TypeList> tList = GetTypeListAll.Do(-1).Body.type_list;
                                foreach (ShortProductInfo item in list)
                                {
                                    string path = item.product_type_path;
                                    string[] _tem = path.Split(',');
                                    int _xCount = 0;
                                    for (int x = 0; x < _tem.Length; x++)
                                    {
                                        if (string.IsNullOrEmpty(_tem[x].Trim())) continue;
                                        int _v = Utils.StrToInt(_tem[x].Trim());
                                        foreach (TypeList em in tList)
                                        {
                                            if (em.product_type_id == _v)
                                            {
                                                if (_xCount > 0) item.type_name += (" &gt;&gt; ");
                                                item.type_name += (em.type_name);
                                                _xCount++;
                                            }
                                        }
                                    }%>
                        <tr>
                            <td>&nbsp;</td>
                            <td style="width: 70px; height: 74px;">
                                <input type="hidden" v="item-product-id" value="<%=item.product_id %>" />
                                <a href="<%=config.UrlHome%><%=item.product_id %>.html" target="_blank" title="<%=item.product_name%>">
                                    <img src="<%=FormatImagesUrl.GetProductImageUrl(item.img_src, 120, 120) %>" style="width: 60px; height: 60px" alt="" />
                                </a>
                            </td>
                            <td>
                                <p><a href="<%=config.UrlHome%><%=item.product_id %>.html" target="_blank"><%=item.product_name%></a></p>
                                <p class="pname" style="color: #999">
                                    编码：<%=item.product_code%>
                                </p>
                                <p style="color: #999">
                                    分类：<% =item.type_name%>
                                </p>
                            </td>
                            <td><a href="javascript:;" onclick="removeMainProductSelectorData(this)">移除</a></td>
                        </tr>
                        <%}
                        }%>
                    </tbody>
                </table>
                <%} %>
                <%--   <tr>
                                <td colspan="6">商品信息：xxx;yyy;zzz;     <input type="hidden" name="proid" value="" />                                      
                                </td>                           
                            </tr>--%>
                <br />
                <table class="table" cellpadding="0" cellspacing="0">
                    <thead>
                        <tr>
                            <th style="width: 42%">&nbsp;</th>
                            <th class="lable">
                                <input type="button" id="loadding3" value="  确定提交  " onclick="$('#fareTempForm').submit()" class="submit" style="width: 120px" /></th>
                            <th>
                                <div class="tips-text" id="tips-message"></div>
                            </th>
                        </tr>
                    </thead>
                </table>
            </div>
            <br />
            <br />
            <br />
            <br />
        </div>
    </div>
    <br />
    <br />
    <script type="text/javascript">
        function showItemProductSelector() {
            var nodes = $("#table-ItemProductSelector input[v='item-product-id']");
            var initList = "";
            for (var i = 0; i < nodes.length; i++) {
                if (i > 0) initList += ",";
                initList += $(nodes[i]).val();
            }
            var exceptList = [];
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
                        parseItemProductSelectorData(json);
                    }, error: function (http, textStatus, errorThrown) {
                        jsbox.error(errorThrown);
                    }
                });
            }, initList, exceptList, true, 1);//第四个参数ture=允许选择带Sku商品;false=禁止选择带Sku商品
        }
        function parseItemProductSelectorData(jsonList) {
            var o = $("#table-ItemProductSelector");
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
            for (var i = 0; i < jsonList.length; i++) {
                var json = jsonList[i];
                if (items.contains(json.product_id))
                    continue;//去除重复的ID
                arr.push('<tr><td>&nbsp;</td>');
                arr.push('<td style="width:70px;height:74px;"><input type="hidden" v="item-product-id" value="' + json.product_id + '"/>');
                arr.push('<a href="<%=config.UrlHome%>' + json.product_id + '.html" target="_blank">');
                arr.push('<img src="' + formatImageUrl2(json.img_src, 120, 120) + '" style="width:60px;height:60px" alt=""/></a></td>');
                arr.push('<td>');
                arr.push('<p><a href="<%=config.UrlHome%>' + json.product_id + '.html" target="_blank">' + json.product_name + '</a></p>');
                arr.push('<p class="pname" style="color:#999">编码：' + json.product_code + '</p>');
                arr.push('<p style="color:#999">' + json.type_name + '</p></td>');
                arr.push('<td><a href="javascript:;" onclick="removeMainProductSelectorData(this)">移除</a></td>');
                arr.push('</tr>');
            }
            o.find("tbody").append(arr.join("\n"));
        }
        function removeMainProductSelectorData(obj) {
            $(obj).parent("td").parent("tr").remove();
        }
    </script>
    <script type="text/javascript">
        function createXmlDocument(nodes) {
            var xml = '<?xml version="1.0" encoding="utf-8"?>';
            xml += '<items>';
            for (var i = 0; i < nodes.length; i++) {
                xml += nodes[i];
            }
            xml += '</items>';
            return xml;
        }
        function submitForm(form) {
            var isError = false;
            $("input[must='1']").each(function () {
                if ($(this).val() == "") {
                    isError = true;
                }
            });
            if (isError) {
                jsbox.error("请完成所有必填项的填写");
                return false;
            }

            var maxgivenum = Number($("input[name='maxgivenum']").val());
            var limitperusertotal = Number($("input[name='limitperusertotal']").val());

            if (!Atai.isNumber(maxgivenum) || maxgivenum <= 0) {
                jsbox.error("总规则的发放【总数量】必须为大于0的数字");
                return false;
            }

            if (!Atai.isNumber(limitperusertotal) || limitperusertotal <= 0) {
                jsbox.error("总规则的领取【限领数量】必须为大于0的数字");
                return false;
            }

            if (maxgivenum < limitperusertotal) {
                jsbox.error("总规则的领取【总数量】大于发放【限领数量】");
                return false;
            }

            if (showLoadding) showLoadding();

            var postData = getPostDB(form);

            var nodes = [];
            var _error = false;
            var _ermsg = "";
            var _itemmaxgivenum = 0;
            var _itemlimitperusertotal = 0;
            $("#fare-rules table[v='table-rules']").each(function () {
                var itemid = $(this).find("input[name='itemid']").val();
                var couponprice = $(this).find("#couponprice").val();
                var couponcond = $(this).find("#couponcond").val();
                if (!Atai.isNumber(couponprice) || couponprice <= 0) {
                    _error = true;
                    _ermsg = "请输入优惠券金额";
                    if (closeLoadding) closeLoadding();
                }
                if (!Atai.isNumber(couponcond) || couponcond <= 0) {
                    _error = true;
                    _ermsg = "请输入使用门槛";
                    if (closeLoadding) closeLoadding();
                }
                var o = $("#table-ItemProductSelector")
                var bids = [];
                o.find("tbody tr").each(function () {
                    var id = $(this).find("input[v='item-product-id']").val();
                    bids.push(id);
                });
                //是商品券并且没有选择商品
                if (bids.length == 0 && $("#type").val() == 1) {
                    _error = true;
                    _ermsg = "商品劵请选择一个商品";
                    if (closeLoadding) closeLoadding();
                }
                var bidstring = bids.join(",");
                var node = '<item itemid="' + itemid + '" couponprice="' + couponprice + '"  couponcond="' + couponcond + '" ';
                node += 'proids="' + bidstring + '">';
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
            var xml = createXmlDocument(nodes);
            $.ajax({
                url: "/MPromotions/PostCouponGetRule"
                , data: postData + "&xml=" + encodeURIComponent(xml)
                , type: "post"
                , dataType: "json"
                , success: function (json) {
                    if (json.error) {
                        jsbox.error(json.message);
                    } else {
                        jsbox.success(json.message, window.location.href);
                    }
                    if (closeLoadding) closeLoadding();
                }
            });
            return false;
        }
    </script>
    <%Html.RenderPartial("MGoods/SelectProductControl"); %>
    <%Html.RenderPartial("Base/_PageFootControl"); %>
</body>
</html>

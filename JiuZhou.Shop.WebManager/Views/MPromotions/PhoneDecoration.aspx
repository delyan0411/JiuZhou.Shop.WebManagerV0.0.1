<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Import Namespace="JiuZhou.Model" %>
<%@ Import Namespace="JiuZhou.Cache" %>
<%@ Import Namespace="JiuZhou.Common" %>
<%@ Import Namespace="JiuZhou.MySql" %>
<%@ Import Namespace="JiuZhou.HttpTools" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
    int tid = DoRequest.GetQueryInt("tid");
    STopicDetails Info = new STopicDetails();    
    DoCache cache = new DoCache();
    var resst = GetTopicDetails.Do(tid);
    if (resst != null && resst.Body != null)
    {
        Info = resst.Body;
        //cache.SetCache("stopic-GetTopicDetails" + tid, Info);
    }
%>
<head>
    <title>专题装修/专题列表|九洲</title>
    <link href="/style/style.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="/style/v1.2/phone/main.css" />
</head>
<body>
    <input type="hidden" value="<%=Info.st_id%>" id="hidstid" />
    <div class="container">
        <div class="header">
            <h1>手机页装修</h1>
                    <a href="<%=config.UrlMobile%>festival/<%=Info.st_dir %>.html" target="_blank">预览</a>
            <%--<div class="tool-top clear">
                <button type="button" class="pub">预览</button>
            </div>--%>
        </div>
 
        <div class="main clear">
            <div class="modules">
                <div class="moudles-image">
                    <div class="module-title">
                        图片模块
                    </div>
                    <div class="module-list clear">
                        <div class="module-spec module-single-image">
                            <div class="module-icon module-single-icon"></div>
                            <p>热点图</p>
                        </div>
                    </div>
                </div>
                <div class="module-layout">
                    <div class="module-title">
                        布局模块
                    </div>
                    <div class="module-list clear">
                        <div class="module-spec module-three-col">
                            <div class="module-icon module-three-icon">
                                <div class="mt-top"></div>
                                <div class="mt-list clear">
                                    <div></div>
                                    <div></div>
                                    <div></div>
                                </div>
                            </div>
                            <p>三列布局</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="image-space">
                <div class="outer-wrapper">
                    <div class="inner-wrapper">
                        <div class="box">
                            <div class="content">
                                <%--模块内容开始--%>
                                <%
                                    List<STModuleInfo> infoList = Info.topic_module_list;
                                    if (infoList == null)
                                    {
                                        infoList = new List<STModuleInfo>();
                                    }
                                    int i = 0;
                                    foreach (STModuleInfo item in infoList)
                                    {
                                        string chosen = "";
                                        if (i == 0)
                                            chosen = "chosen";
                                        string bgimg = item.module_desc.Equals("") ? "//img.alicdn.com/tps/TB1QafaJVXXXXaDXXXXXXXXXXXX-640-300.jpg" : item.module_desc;
                                %>
                                <div class="module-wrapper <%=chosen %>" d="module-<%=item.st_module_id%>" value="<%=item.st_module_id%>">
                                    <%if (item.module_type == 6)
                                        {%>
                                    <div class="img-wrapper">
                                        <img class="module-image" src="<%=bgimg %>">
                                    </div>
                                    <div class="mod-handle">
                                        <div class="mod-up"></div>
                                        <div class="mod-down"></div>
                                        <div class="mod-del"></div>
                                    </div>
                                    <div class="drag" ondragstart="return false;" onselectstart="return false;">
                                        <%foreach (STItemInfo stii in item.topic_item_list)
                                            {
                                                string[] areacod = stii.item_name.Split('|');
                                                var left = areacod[1];
                                                var top = areacod[0];
                                                var height = areacod[3];
                                                var width = areacod[2];
                                        %>
                                        <div class="drag-frame" style="left: <%=left%>px; top: <% =top%>px; height: <% =height%>px; width: <%=width%>px;">
                                            <div class="draghandle dh-tl"></div>
                                            <div class="draghandle dh-tm"></div>
                                            <div class="draghandle dh-tr"></div>
                                            <div class="draghandle dh-ml"></div>
                                            <div class="draghandle dh-mr"></div>
                                            <div class="draghandle dh-bl"></div>
                                            <div class="draghandle dh-bm"></div>
                                            <div class="draghandle dh-br"></div>
                                            <div class="dh-del iconfont icon-cha"></div>
                                        </div>
                                        <%} %>
                                    </div>
                                    <%}
                                        if (item.module_type == 5)
                                        {
                                            if (item.allow_show_name == "")
                                            {
                                                item.allow_show_name = "10";
                                            }
                                            string style2 = item.module_desc.Equals("") ? "style='padding-top: "+item.allow_show_name+"px; '" : "style=\"padding-top: "+item.allow_show_name+"px; background-size: cover; background-image: url('" + item.module_desc + "')\"";
                                    %>
                                    <div class="module-three-layout" <%=style2%>>
                                        <div class="three-layout-list clear">
                                            <% List<STItemInfo> items = item.topic_item_list;
                                                if (items == null)
                                                    items = new List<STItemInfo>();
                                                if (items.Count > 0)
                                                {
                                                    int imgSize = 160;
                                                    for (int z = 0; z < items.Count; z++)
                                                    {
                                                        STItemInfo sem = items[z];
                                                        string url = config.UrlMobile + "item/" + sem.product_id + ".html";
                                                        ShortProductInfo product = new ShortProductInfo();
                                                        if (cache.GetCache("product-GetShortProductsByProductIds" + sem.product_id) == null)
                                                        {
                                                            var respro = GetShortProductsByProductIds.Do(sem.product_id.ToString());
                                                            if (respro != null && respro.Body != null && respro.Body.product_list != null && respro.Body.product_list[0] != null)
                                                            {
                                                                product = respro.Body.product_list[0];
                                                                cache.SetCache("product-GetShortProductsByProductIds" + sem.product_id, product, 300);
                                                            }
                                                        }
                                                        else
                                                        {
                                                            product = (ShortProductInfo)cache.GetCache("product-GetShortProductsByProductIds" + sem.product_id);
                                                        }
                                                        string image = FormatImagesUrl.GetMainImageUrl(product.img_src, imgSize, imgSize);
                                                        decimal price = 0;
                                                        if (DateTime.Parse(product.promotion_bdate) <= DateTime.Now && DateTime.Now <= DateTime.Parse(product.promotion_edate) && DateTime.Parse(product.promotion_bdate) != DateTime.Parse(product.promotion_edate))
                                                        {
                                                            price = product.promotion_price;
                                                        }
                                                        else
                                                        {
                                                            price = product.mobile_price;
                                                        }
                                                        bool isFreeFare = false;
                                                        if (product.is_free_fare == 1 && DateTime.Parse(product.free_fare_stime) <= DateTime.Now && DateTime.Parse(product.free_fare_etime) >= DateTime.Now)
                                                            isFreeFare = true;
                                            %>
                                            <div class="three-layout-item">
                                                <a href="<%=url %>" title="<%=product.product_name%>">
                                                    <div class="three-layout-product">
                                                        <img src="<%=image %>" alt="<%=product.product_name%>" />
                                                    </div>
                                                    <div class="three-layout-desc"><span><%=product.product_name%></span></div>
                                                    <div class="three-layout-price clear">
                                                        <div class="tl-real-price"><span>￥<em><%=price%></em></span></div>
                                                        <%=(product.mobile_price > price) ? "<div class=\"tl-del-price\"><del>￥"+product.sale_price+"</del></div>" : ""%>
                                                    </div>
                                                    <div class="three-layout-btn">
                                                        <button>立即预定/抢购</button>
                                                    </div>
                                                </a>
                                            </div>
                                            <%}
                                                }%>
                                        </div>
                                    </div>
                                    <div class="mod-handle">
                                        <div class="mod-up"></div>
                                        <div class="mod-down"></div>
                                        <div class="mod-del"></div>
                                    </div>

                                    <%} %>
                                </div>
                                <%
                                        i++;
                                    } %>
                            </div>
                        </div>
                        <div class="cnt-clone" style="display: none;"></div>
                    </div>
                </div>
            </div>
            <div class="tool-bar">
                <span>手机端商品url例子: http://m.dada360.com/json/createCoupon.action?itemId=93</span><br>
     <span>手机端优惠券url例子:  http://m.dada360.com/item/45345.html</span>
                <div class="hot-area">
                    <% 
                        int a = 0;
                        foreach (STModuleInfo item in infoList)
                        {
                            string style = "";
                            if (a > 0)
                                style = "display: none;";
                            //background-size: contain; background-image: url("http://dada360com2016.oss-cn-qingdao.aliyuncs.com/jianbao/website/2017/09/18/6ff90b3a4ecc42c7b68ef184c0657692.jpg");
                            string bgimg2 = item.module_desc.Equals("") ? "style='background-size: contain;'" : "style=\"background-size: contain; background-image: url('" + item.module_desc + "')\"";
                    %>
                    <%if (item.module_type == 6)
                        {%>
                    <div class="hot-module" style="<%=style%>">
                        <div class="add-img" <% =bgimg2%>>
                            <div class="layer">
                                <div class="img-plus"></div>
                            </div>
                        </div>
                        <div class="hot-links">
                            <%foreach (STItemInfo stii in item.topic_item_list)
                                {
                            %>
                            <div class="hot-item">
                                <div class="hot-item-wrap">
                                    <input type="text" class="hot-item-input" id="link" value="<%= stii.page_src %>" itemid="<%=stii.st_item_id %>" placeholder="输入链接" />
                                </div>
                                <div class="hot-item-warp hot-btn-wrap">
                                    <button class="hot-item-btn" type="button"></button>
                                </div>
                                <div class="hot-item-wrap hot-btn-wrap"><a href="javascript:;" class="hot-item-del"></a></div>
                            </div>
                            <%}%>
                        </div>
                        <button class="hot-add" type="button">+添加热区</button>
                        <button class="hotlistupdate" type="button">确定</button>
                    </div>
                    <%}
                        if (item.module_type == 5)
                        {
                    %>
                    <div class="hot-module" style="<%=style%>">
                        <div class="add-img" <% =bgimg2%>>
                            <div class="layer">
                                <div class="img-plus">
                                </div>
                            </div>
                        </div>
                        距离顶部(没有不填,不用填px):<input name="allow_show_name" class="allow_show_name" value="<%=item.allow_show_name %>" />
                        <ul class="ulitemlist">
                            <%List<STItemInfo> items = item.topic_item_list;
                                if (items == null)
                                    items = new List<STItemInfo>();
                                if (items.Count > 0)
                                {
                                    int imgSize = 160;
                                    for (int z = 0; z < items.Count; z++)
                                    {
                                        STItemInfo sem = items[z];
                                        string url = config.UrlMobile + "item/" + sem.product_id + ".html";
                                        ShortProductInfo product = new ShortProductInfo();
                                        if (cache.GetCache("product-GetShortProductsByProductIds" + sem.product_id) == null)
                                        {
                                            var respro = GetShortProductsByProductIds.Do(sem.product_id.ToString());
                                            if (respro != null && respro.Body != null && respro.Body.product_list != null && respro.Body.product_list[0] != null)
                                            {
                                                product = respro.Body.product_list[0];
                                                cache.SetCache("product-GetShortProductsByProductIds" + sem.product_id, product, 300);
                                            }
                                        }
                                        else
                                        {
                                            product = (ShortProductInfo)cache.GetCache("product-GetShortProductsByProductIds" + sem.product_id);
                                        }
                                        string image = FormatImagesUrl.GetMainImageUrl(product.img_src, imgSize, imgSize);
                                        decimal price = 0;
                                        if (DateTime.Parse(product.promotion_bdate) <= DateTime.Now && DateTime.Now <= DateTime.Parse(product.promotion_edate) && DateTime.Parse(product.promotion_bdate) != DateTime.Parse(product.promotion_edate))
                                        {
                                            price = product.promotion_price;
                                        }
                                        else
                                        {
                                            price = product.mobile_price;
                                        }
                                        bool isFreeFare = false;
                                        if (product.is_free_fare == 1 && DateTime.Parse(product.free_fare_stime) <= DateTime.Now && DateTime.Parse(product.free_fare_etime) >= DateTime.Now)
                                            isFreeFare = true;
                            %>
                            <li data-pid="<%=product.product_id %>" data-item="<%=sem.st_item_id %>"><%=product.product_name %></li>
                            <%}
                            }%>
                        </ul>
                        <button class="three-add-btn">+添加商品</button>
                        <button class="three-cfm-btn" type="button">确定</button>
                    </div>
                    <%} %>
                    <%
                            a++;
                        } %>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript" src="/javascript/v1.2/jquery.js" charset="utf-8"></script>
    <script type="text/javascript" src="/javascript/v1.2/AtaiJs-1.2.js" charset="utf-8"></script>
    <script type="text/javascript" src="/javascript/v1.2/jscode.js" charset="utf-8"></script>
    <script type="text/javascript" src="/javascript/jquery.zclip.js" charset="utf-8"></script>
    <script type="text/javascript" src="/javascript/v1.2/phone/drag.js" charset="utf-8"></script>
    <script type="text/javascript" src="/javascript/v1.2/phone/FileSaver.min.js" charset="utf-8"></script>
    <script type="text/javascript" src="/javascript/v1.2/phone/main.js" charset="utf-8"></script>
    <script type="text/javascript">      
    </script>
    <%Html.RenderPartial("ImageListBoxControl");//图片选择 %>
    <%Html.RenderPartial("MGoods/SelectProductControl"); %>
</body>
</html>

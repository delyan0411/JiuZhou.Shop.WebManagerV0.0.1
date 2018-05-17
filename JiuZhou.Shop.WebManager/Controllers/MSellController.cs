using JiuZhou.Cache;
using JiuZhou.Common;
using JiuZhou.ControllerBase;
using JiuZhou.HttpTools;
using JiuZhou.MySql;
using System;
using System.Collections.Generic;
using System.Web.Mvc;
using ThoughtWorks.QRCode.Codec;

namespace JiuZhou.Shop.WebManager.Controllers
{
    [HandleError]
    public class MSellController : ForeSysBaseController
    {
        #region 订单列表
        public ActionResult Index()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,102,148,204,"))
                {
                    currResBody = item;
                    break;
                }
            }
            HasPermission(currResBody.res_id);
         
            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            int pagesize = DoRequest.GetQueryInt("size", 20);
            int pageindex = DoRequest.GetQueryInt("page", 1);
            int status = DoRequest.GetQueryInt("status", -1);
            int sType = DoRequest.GetQueryInt("stype", 0);
            int payType = DoRequest.GetQueryInt("payType",-1);
            DateTime date = DateTime.Now.AddDays(-15);
            DateTime sDate = DoRequest.GetQueryDate("sDate", date);
            DateTime eDate = DoRequest.GetQueryDate("eDate", DateTime.Now).AddDays(1);

            string ocol = DoRequest.GetQueryString("ocol").Trim();
            string otype = DoRequest.GetQueryString("ot");

            if (ocol.Equals(""))
                ocol = "ADDTIME";

            string ot = "DESC";
            if (otype.ToLower().Trim() == "asc") {
                ot = "ASC";
            }

            string q = DoRequest.GetQueryString("q").Trim();
            string sKey = "";
            #region 处理查询关键词中的空格
            string[] qList = q.Split(' ');
            for (int i = 0; i < qList.Length; i++)
            {
                if (string.IsNullOrEmpty(qList[i].Trim()))
                    continue;
                if (i > 0)
                    sKey += " ";
                sKey += qList[i];
            }
            q = sKey;
            #endregion

            #region 订单列表
            int dataCount = 0;
            int pageCount = 0;
            List<OrderPayInfo> infoList = new List<OrderPayInfo>();
            string cachekey = "order-index=" + pageindex + "status=" + status + "paytype=" + payType + "sdate=" + sDate.ToString("yyyy-MM-dd") + "edate=" + eDate.ToString("yyyy-MM-dd") + "stype=" + sType + "skey=" + sKey + "ocol=" + ocol + "ot=" + ot;
            DoCache cache = new DoCache();
            if (cache.GetCache(cachekey) == null)
            {
                var res = QueryOrderList.Do(pagesize, pageindex
                    , status
                    , sDate.ToString("")
                    , eDate.ToString("")
                    , sType
                    ,payType
                    , sKey
                    , ocol
                    , ot
                    , ref dataCount
                    , ref pageCount);

                if (res != null && res.Body != null && res.Body.order_pay_list != null)
                {
                    infoList = res.Body.order_pay_list;
                    cache.SetCache(cachekey, infoList, 10);
                    cache.SetCache("order-datacount1", dataCount, 10);
                    if (infoList.Count == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else {
                infoList = (List<OrderPayInfo>)cache.GetCache(cachekey);
                dataCount = (int)cache.GetCache("order-datacount1");
            }

            ViewData["infoList"] = infoList;//订单列表
            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/msell/index?");
            currPageUrl.Append("status=" + status);
            currPageUrl.Append("&stype=" + sType);
            currPageUrl.Append("&paytype=" + payType);
            currPageUrl.Append("&size=" + pagesize);
            currPageUrl.Append("&sdate=" + sDate.ToString("yyyy-MM-dd"));
            currPageUrl.Append("&edate=" + eDate.AddDays(-1).ToString("yyyy-MM-dd"));
            currPageUrl.Append("&ocol=" + ocol);
            currPageUrl.Append("&ot=" + otype);

            currPageUrl.Append("&q=" + DoRequest.UrlEncode(q));
            currPageUrl.Append("&page=" + pageindex);
            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL
            ViewData["pagesize"] = pagesize;
            ViewData["pageindex"] = pageindex;
            ViewData["dataCount"] = dataCount;

            ViewData["pageIndexLink"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            ViewData["pageIndexLink2"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            #endregion

            return View();
        }
        #endregion

        #region 待付款订单列表
        public ActionResult NonPay()
        {

            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,102,148,209,"))
                {
                    currResBody = item;
                    break;
                }
            }
            HasPermission(currResBody.res_id);

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            int pagesize = DoRequest.GetQueryInt("size", 20);
            int pageindex = DoRequest.GetQueryInt("page", 1);
            int status = DoRequest.GetQueryInt("status", 1);
            int sType = DoRequest.GetQueryInt("stype");
            DateTime date = DateTime.Now.AddDays(-15);
            DateTime sDate = DoRequest.GetQueryDate("sDate", date);
            DateTime eDate = DoRequest.GetQueryDate("eDate", DateTime.Now).AddDays(1);

            string ocol = DoRequest.GetQueryString("ocol").Trim();
            string otype = DoRequest.GetQueryString("ot");

            if (ocol.Equals(""))
                ocol = "ADDTIME";

            string ot = "DESC";
            if (otype.ToLower().Trim() == "asc")
            {
                ot = "ASC";
            }

            string q = DoRequest.GetQueryString("q").Trim();
            string sKey = "";
            #region 处理查询关键词中的空格
            string[] qList = q.Split(' ');
            for (int i = 0; i < qList.Length; i++)
            {
                if (string.IsNullOrEmpty(qList[i].Trim()))
                    continue;
                if (i > 0)
                    sKey += " ";
                sKey += qList[i];
            }
            q = sKey;
            #endregion

            #region 订单列表
            int dataCount = 0;
            int pageCount = 0;
            List<OrderPayInfo> infoList = new List<OrderPayInfo>();
            string cachekey = "order-index=" + pageindex + "status=" + status + "sdate=" + sDate.ToString("yyyy-MM-dd") + "edate=" + eDate.ToString("yyyy-MM-dd") + "stype=" + sType + "skey=" + sKey + "ocol=" + ocol + "ot=" + ot;
            DoCache cache = new DoCache();
            if (cache.GetCache(cachekey) == null)
            {
                var res = QueryOrderList.Do(pagesize, pageindex
                    , status
                    , sDate.ToString()
                    , eDate.ToString()
                    , sType
                    ,-1
                    , sKey
                    , ocol
                    , ot
                    , ref dataCount
                    , ref pageCount);

                if (res != null && res.Body != null && res.Body.order_pay_list != null)
                {
                    infoList = res.Body.order_pay_list;
                    cache.SetCache(cachekey, infoList, 10);
                    cache.SetCache("order-datacount2", dataCount, 10);
                    if (infoList.Count == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else
            {
                infoList = (List<OrderPayInfo>)cache.GetCache(cachekey);
                dataCount = (int)cache.GetCache("order-datacount2");
            }
            ViewData["infoList"] = infoList;//订单列表
            string path = "";
            if (status != 1)
            {
                path = "/index";
            }
            else {
                path = "/NonPay";
            }
            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/msell"+ path +"?");
            currPageUrl.Append("status=" + status);
            currPageUrl.Append("&stype=" + sType);
            currPageUrl.Append("&size=" + pagesize);
            currPageUrl.Append("&sdate=" + sDate.ToString("yyyy-MM-dd"));
            currPageUrl.Append("&edate=" + eDate.AddDays(-1).ToString("yyyy-MM-dd"));
            currPageUrl.Append("&ocol=" + ocol);
            currPageUrl.Append("&ot=" + otype);

            currPageUrl.Append("&q=" + DoRequest.UrlEncode(q));
            currPageUrl.Append("&page=" + pageindex);
            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL
            ViewData["pagesize"] = pagesize;
            ViewData["pageindex"] = pageindex;
            ViewData["dataCount"] = dataCount;

            ViewData["pageIndexLink"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            ViewData["pageIndexLink2"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            #endregion

            return View();
        }
        #endregion

        #region 待发货订单列表
        public ActionResult Undelivered()
        {

            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,102,148,210,"))
                {
                    currResBody = item;
                    break;
                }
            }
            HasPermission(currResBody.res_id);
        
            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            int pagesize = DoRequest.GetQueryInt("size", 20);
            int pageindex = DoRequest.GetQueryInt("page", 1);
            int status = DoRequest.GetQueryInt("status", 2);
            int sType = DoRequest.GetQueryInt("stype",0);
            int payType = DoRequest.GetQueryInt("payType",-1);
            DateTime date = DateTime.Now.AddDays(-15);
            DateTime sDate = DoRequest.GetQueryDate("sDate", date);
            DateTime eDate = DoRequest.GetQueryDate("eDate", DateTime.Now).AddDays(1);

            string ocol = DoRequest.GetQueryString("ocol").Trim();
            string otype = DoRequest.GetQueryString("ot");

            if (ocol.Equals(""))
                ocol = "ADDTIME";

            string ot = "DESC";
            if (otype.ToLower().Trim() == "asc")
            {
                ot = "ASC";
            }

            string q = DoRequest.GetQueryString("q").Trim();
            string sKey = "";
            #region 处理查询关键词中的空格
            string[] qList = q.Split(' ');
            for (int i = 0; i < qList.Length; i++)
            {
                if (string.IsNullOrEmpty(qList[i].Trim()))
                    continue;
                if (i > 0)
                    sKey += " ";
                sKey += qList[i];
            }
            q = sKey;
            #endregion

            #region 订单列表
            int dataCount = 0;
            int pageCount = 0;
            List<OrderPayInfo> infoList = new List<OrderPayInfo>();
            string cachekey = "order-index=" + pageindex + "status=" + status + "paytype=" + payType + "sdate=" + sDate.ToString("yyyy-MM-dd") + "edate=" + eDate.ToString("yyyy-MM-dd") + "stype=" + sType + "skey=" + sKey + "ocol=" + ocol + "ot=" + ot;
            DoCache cache = new DoCache();
            if (cache.GetCache(cachekey) == null)
            {
                var res = QueryOrderList.Do(pagesize, pageindex
                    , status
                    , sDate.ToString()
                    , eDate.ToString()
                    , sType
                    ,payType
                    , sKey
                    , ocol
                    , ot
                    , ref dataCount
                    , ref pageCount);

                if (res != null && res.Body != null && res.Body.order_pay_list != null)
                {
                    infoList = res.Body.order_pay_list;
                    cache.SetCache(cachekey, infoList, 10);
                    cache.SetCache("order-datacount3", dataCount, 10);
                    if (infoList.Count == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else
            {
                infoList = (List<OrderPayInfo>)cache.GetCache(cachekey);
                dataCount = (int)cache.GetCache("order-datacount3");
            }
            ViewData["infoList"] = infoList;//订单列表
            string path = "";
            if (status != 2)
            {
                path = "/index";
            }
            else {
                path = "/Undelivered";
            }
            
            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/msell"+ path +"?");
            currPageUrl.Append("status=" + status);
            currPageUrl.Append("&stype=" + sType);
            currPageUrl.Append("&paytype=" + payType);
            currPageUrl.Append("&size=" + pagesize);
            currPageUrl.Append("&sdate=" + sDate.ToString("yyyy-MM-dd"));
            currPageUrl.Append("&edate=" + eDate.AddDays(-1).ToString("yyyy-MM-dd"));
            currPageUrl.Append("&ocol=" + ocol);
            currPageUrl.Append("&ot=" + otype);

            currPageUrl.Append("&q=" + DoRequest.UrlEncode(q));
            currPageUrl.Append("&page=" + pageindex);
            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL
            ViewData["pagesize"] = pagesize;
            ViewData["pageindex"] = pageindex;
            ViewData["dataCount"] = dataCount;

            ViewData["pageIndexLink"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            ViewData["pageIndexLink2"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            #endregion

            return View();
        }
        #endregion

        #region OrderItem
        public ActionResult OrderItem()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,102,148,204,"))
                {
                    currResBody = item;
                    break;
                }
            }

            //HasPermission(currResBody.res_id);

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            int orderid = DoRequest.GetQueryInt("id");
            string orderNumber = DoRequest.GetQueryString("orderNumber");
            OrderDetail order = null;
            
            var res = GetOrderDetail.Do(orderNumber);            
            if (res == null || res.Body == null){
                order = new OrderDetail();
            }else{
                order = res.Body;}
            
            ViewData["orderInfo"] = order;

            return View();
        }
        #endregion

        #region 医卡通冲正
        public ActionResult ECorrect()
        {

            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,102,148,224,"))
                {
                    currResBody = item;
                    break;
                }
            }

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            HasPermission(currResBody.res_id);

            string q = DoRequest.GetQueryString("q").Trim();
            string sKey = "";
            #region 处理查询关键词中的空格
            string[] qList = q.Split(' ');
            for (int i = 0; i < qList.Length; i++)
            {
                if (string.IsNullOrEmpty(qList[i].Trim()))
                    continue;
                if (i > 0)
                    sKey += " ";
                sKey += qList[i];
            }
            q = sKey;
            #endregion

            #region 订单列表
            PayOrderDetails infoList = new PayOrderDetails();
            if (!q.Equals("") && q != null)
            {
                var ress = QueryPayOrderDetail.Do(q);

                if (ress != null && ress.Body != null && ress.Body.order_list != null)
                {
                    infoList = ress.Body;
                }
            }
            ViewData["infoList"] = infoList;//订单列表

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/msell?");

            currPageUrl.Append("&q=" + DoRequest.UrlEncode(q));
            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL

            #endregion

            return View();
        }
        #endregion

        #region 评论列表
        public ActionResult Comments()
        {

            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,102,201,205,"))
                {
                    currResBody = item;
                    break;
                }
            }
           

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            HasPermission(currResBody.res_id);

            int pagesize = 100;
            int pageindex = DoRequest.GetQueryInt("page", 1);
            int state = DoRequest.GetQueryInt("state", -1);
            int star = DoRequest.GetQueryInt("star",-1);
            int type = DoRequest.GetQueryInt("type", -1);

            DateTime date = DateTime.Now.AddMonths(-1);
            DateTime sDate = DoRequest.GetQueryDate("sDate", date);
            DateTime eDate = DoRequest.GetQueryDate("eDate", DateTime.Now).AddDays(1);

            string q = DoRequest.GetQueryString("q");

            string ocol = DoRequest.GetQueryString("ocol").Trim();
            string otype = DoRequest.GetQueryString("ot");

            if (ocol.Equals(""))
                ocol = "ADDTIME";

            string ot = "DESC";
            if (otype.ToLower().Trim() == "asc")
            {
                ot = "ASC";
            }


            int dataCount = 0;
            int pageCount = 0;
            List<CommentInfo> infoList = new List<CommentInfo>();
            DoCache cache = new DoCache();
            string cachekey = "comment-index=" + pageindex + "state=" + state + "star=" + star + "type=" + type + "q=" + q + "sdate=" + sDate.ToString("yyyy-MM-dd") + "edate=" + eDate.ToString("yyyy-MM-dd") + "ocol=" + ocol + "ot=" + ot;
            if (cache.GetCache(cachekey) == null)
            {
                var res = QueryCommentList.Do(pagesize, pageindex
                     , state
                     , star
                     , type
                     , q
                     , sDate.ToString("yyyy-MM-dd 00:00:00")
                     , eDate.ToString("yyyy-MM-dd 23:59:59")
                     , ocol
                     , ot
                     , ref dataCount, ref pageCount);
                if (res != null && res.Body != null && res.Body.comment_list != null)
                {
                    infoList = res.Body.comment_list;
                    cache.SetCache(cachekey, infoList, 60);
                    cache.SetCache("comment-datacount", 60);
                    if (infoList.Count == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else {
                infoList = (List<CommentInfo>)cache.GetCache(cachekey);
                dataCount = (int)cache.GetCache("comment-datacount");
            }
            ViewData["infoList"] = infoList;

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/msell/comments?");
            currPageUrl.Append("&state=" + state);
            currPageUrl.Append("&star=" + star);
            currPageUrl.Append("&page=" + pageindex);
            currPageUrl.Append("&sdate=" + sDate.ToString("yyyy-MM-dd"));
            currPageUrl.Append("&edate=" + eDate.AddDays(-1).ToString("yyyy-MM-dd"));
            currPageUrl.Append("&ocol=" + ocol);
            currPageUrl.Append("&ot=" + ot.ToString());
            currPageUrl.Append("&q=" + q);
            currPageUrl.Append("&type=" + type);
            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL
            ViewData["pagesize"] = pagesize;
            ViewData["pageindex"] = pageindex;
            ViewData["dataCount"] = dataCount;
            ViewData["pageIndexLink"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            ViewData["pageIndexLink2"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());

            return View();
        }
        #endregion

        #region 刷单
        public ActionResult ClickFarming()
        {

            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,102,201,205,"))
                {
                    currResBody = item;
                    break;
                }
            }

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            HasPermission(currResBody.res_id);

            return View();
        }
        #endregion

        #region UpdateRemark 修改订单备注
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult UpdateRemark()
        {
            string orderNumber = DoRequest.GetFormString("orderNumber").Trim();
            string remark = DoRequest.GetFormString("remark");

            if (string.IsNullOrEmpty(orderNumber))
            {
                return Json(new { error = true, message = "参数错误" });
            }
            if (remark.Length > 400)
            {
                return Json(new { error = true, message = "备注不能超过400个字符" });
            }
            int returnValue = -1;
            var res = UpdateOrderRemark.Do(orderNumber, remark);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1); 

            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("order-");
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostDeliveryData
        [HttpPost]
        public ActionResult PostDeliveryData()
        {
            string orderNumber = DoRequest.GetFormString("orderNumber").Trim();
            string expressCompany = DoRequest.GetFormString("expressCompany");//快递公司
            string expressNumber = DoRequest.GetFormString("expressNumber");//快递单号

            if (string.IsNullOrEmpty(orderNumber))
            {
                return Json(new { error = true, message = "参数错误" });
            }
            if (expressCompany.Length < 1)
            {
                return Json(new { error = true, message = "请填写快递公司" });
            }
            if (expressCompany.Length > 50)
            {
                return Json(new { error = true, message = "快递公司字符不能超过50个字符" });
            }
            if (!Utils.IsMatch(expressNumber, @"^\d{6,30}$"))
            {
                return Json(new { error = true, message = "快递单号请填写数字(6-30位数字)" });
            }

            int returnValue = -1;
            var res = AddDeliveryInfo.Do(orderNumber, expressCompany, expressNumber);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1); 
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("order-");
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region ResetOrderTransPrice
        [HttpPost]
        public ActionResult ResetOrderTransPrice()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,102,148,608,"))
                {
                    currResBody = item;
                    break;
                }
            }
            string orderNumber = DoRequest.GetFormString("orderNumber").Trim();
            decimal orderPrice = DoRequest.GetFormDecimal("orderPrice", -1);//订单价格
            decimal transPrice = DoRequest.GetFormDecimal("transPrice", -1);//运费            
            if (!HasPermission2(608)&& orderPrice >= 0)
            {
                return Json(new { error = true, message = "你没有这个权限" });
            }         
            if (orderPrice < 0 )
            {
                orderPrice = -1;//需要超级管理权限, orderPrice小于0表示只改运费
            }

            if (string.IsNullOrEmpty(orderNumber))
            {
                return Json(new { error = true, message = "参数错误" });
            }
            if (transPrice < 0)
            {
                return Json(new { error = true, message = "运费请填写大于或等于0的数字" });
            }
            int returnValue = -1;// OrderDB.ResetOrderTransPrice(orderNumber, transPrice);
            var res = UpdateOrderMoney.Do(orderNumber, orderPrice, transPrice);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1); 
           
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("order-");
                return Json(new { error = false, message = "操作成功!", order_money = orderPrice, trans_money = transPrice });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostMobileMessageData 发送提醒短信
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostMobileMessageData()
        {
            string orderNumber = DoRequest.GetFormString("orderNumber").Trim();
            string message = DoRequest.GetFormString("message").Trim();
            string mobile = DoRequest.GetFormString("mobile2").Trim();
            if (!Utils.IsMobile(mobile))
            {
                return Json(new { error = true, message = "手机号码格式不正确" });
            }
       
            int returnValue = -1;
            var res = NoticeUserPay.Do(orderNumber, message);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1); 
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("order-");
                return Json(new { error = false, message = "操作成功" });
            }
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region ResetCommentStatus 隐藏评论
        [HttpPost]
        public ActionResult ResetCommentStatus()
        {
            int commentid = DoRequest.GetFormInt("commentid");
            int state = DoRequest.GetFormInt("state");
            if (commentid == 0)
            {
                return Json(new { error = true, message = "参数错误" });
            }
            int returnValue = -1;
            var res = UpCommentState.Do(commentid, state);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1); 

            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("comment-");
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region ResetCommentStatusList
        [HttpPost]
        public ActionResult ResetCommentStatusList()
        {
            string idString = DoRequest.GetFormString("visitid").Trim();

            if (string.IsNullOrEmpty(idString))
            {
                return Json(new { error = true, message = "没有选择任何项" });
            }
            int returnValue = -1;
            var res = UpCommentStateList.Do(idString);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1); 
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("comment-");
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region DeleteCommetReply 删除回复
        [HttpPost]
        public ActionResult DeleteCommetReply()
        {
            int commentid = DoRequest.GetFormInt("commentid");
            if (commentid == 0)
            {
                return Json(new { error = true, message = "参数错误" });
            }
            //判断是否存在 如果存在就修改 不存在就添加
            int returnValue = -1;
            var res = DeleteCommentReply.Do(commentid);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1); 
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("comment-");
                return Json(new { error = false, message = "操作成功!" });
            }
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region CommetReply 添加回复
        [HttpPost]
        public ActionResult CommetReply()
        {
            int commentid = DoRequest.GetFormInt("commentid");
            string content = DoRequest.GetFormString("content");
            if (commentid == 0)
            {
                return Json(new { error = true, message = "参数错误" });
            }
            //判断是否存在 如果存在就修改 不存在就添加
            int returnValue = -1;
            var res = OpCommentReply.Do(commentid, content);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);         

            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("comment-");
                return Json(new { error = false, message = "操作成功!" });
            }
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region ResetOrderStatus 退订
        [HttpPost]
        public ActionResult ResetOrderStatus()
        {
            string orderNumber = DoRequest.GetFormString("orderNumber").Trim();
            int servicestate = DoRequest.GetFormInt("servicestate");
            string innerremark = DoRequest.GetFormString("innerremark");
            //int orderStatus = DoRequest.GetFormInt("status", 4);
           // string returnmoney = DoRequest.GetFormString("returnmoney");
            int returnintergral = DoRequest.GetFormInt("returnintergral", 0);
            int returncoupon = DoRequest.GetFormInt("returncoupon", 0);
            if (string.IsNullOrEmpty(orderNumber))
            {
                return Json(new { error = true, message = "参数错误" });
            }
            if (servicestate < 0 || servicestate > 2)
            {
                return Json(new { error = true, message = "参数错误" });
            } 
            int returnValue = -1;

            var res = RefundOrder.Do(orderNumber, servicestate, returnintergral, returncoupon, innerremark);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);

            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("order-");
                return Json(new { error = false, message = "操作成功!" });
            }
            if (returnValue == 90195)
                return Json(new { error = true, message = res.Header.Result.Msg.Substring(8) });
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region BalanceRefund 瀚医企健付退订
        [HttpPost]
        public ActionResult BalanceRefundStates()
        {
            
            string order_no = DoRequest.GetFormString("order_no").Trim();
            int buyer_id = DoRequest.GetFormInt("user_id");
            int pay_type = DoRequest.GetFormInt("pay_type");
            Logger.Error(order_no + buyer_id);
            if (string.IsNullOrEmpty(order_no))
            {
                return Json(new { error = true, message = "参数错误" });
            }
            if (buyer_id <= 0)
            {
                return Json(new { error = true, message = "参数错误" });
            }
            int returnValue = -1;
            var res = BalanceRefund.Do(order_no, buyer_id, pay_type);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);

            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("order-");
                return Json(new { error = false, message = "操作成功!" });
            }
            if (returnValue == -1)
                return Json(new { error = true, message = res.Header.Result.Msg });
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region ReturnOrderPro 退货
        [HttpPost]
        public ActionResult ReturnOrderPro()
        {
            string orderNumber = DoRequest.GetFormString("orderNumber").Trim();
            int servicestate = DoRequest.GetFormInt("servicestate");
            string innerremark = DoRequest.GetFormString("innerremark");
           // string returnmoney = DoRequest.GetFormString("returnmoney");
            int coupon = DoRequest.GetFormInt("iscoupon", 0);
            int integral = DoRequest.GetFormInt("isintegral", 0);

            if (string.IsNullOrEmpty(orderNumber))
            {
                return Json(new { error = true, message = "参数错误" });
            }
            if (servicestate < 0 || servicestate > 2)
            {
                return Json(new { error = true, message = "参数错误" });
            }
            int returnValue = -1;

            var res = ReturnOrder.Do(orderNumber, servicestate, innerremark, coupon, integral);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);

            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("order-");
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败！" });
        }
        #endregion

        #region GetOrderMoneys 获取订单金额
        [HttpPost]
        public ActionResult GetOrderMoneys()
        {
            string orderNumber = DoRequest.GetFormString("orderno").Trim();

            if (string.IsNullOrEmpty(orderNumber))
            {
                return Json(new { error = true, message = "参数错误" });
            }

            var returnValue = -1;
            var res = GetOrderMoney.Do(orderNumber);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);

            if (returnValue == 0)
            {
                return Json(new { error = false, orderinfo = res.Body, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败！" });
        }
        #endregion

        #region PostClickFarming 刷单
        [HttpPost]
        public ActionResult PostClickFarming()
        {
            int id = DoRequest.GetFormInt("productid");
            string comment = DoRequest.GetFormString("comments").Trim();

            if (string.IsNullOrEmpty(comment))
            {
                return Json(new { error = true, message = "内容不能为空！" });
            }

            var returnValue = -1;
            var res = OpClickFarming.Do(id, comment);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);

            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("comment-");
                return Json(new { error = false, orderinfo = res.Body, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败！" });
        }
        #endregion

        #region GetRecmobile 获取手机号
        [HttpPost]
        public ActionResult GetRecmobile()
        {
            string orderno = DoRequest.GetFormString("orderno");

            RecMobile rmobile = new RecMobile();
            var res = GetReceiveMobileNo.Do(orderno);
            if (res != null && res.Body != null && !res.Body.receive_mobile_no.Equals(""))
                return Json(new { error = false, mobile = res.Body.receive_mobile_no, message = "操作成功!" });
  
            return Json(new { error = true, message = "未找到对应联系号码！" });
        }
        #endregion

        #region PostReceiveAddrData 修改收货信息
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostReceiveAddrData()
        {
            string orderNumber = DoRequest.GetFormString("orderNumber").Trim();
            string receivename = DoRequest.GetFormString("receivename").Trim();
            string provincename = DoRequest.GetFormString("provincename").Trim();
            string cityname = DoRequest.GetFormString("cityname").Trim();
            string countyname = DoRequest.GetFormString("countyname").Trim();
            string receiveaddr = DoRequest.GetFormString("receiveaddr").Trim();
            string receivemobile = DoRequest.GetFormString("receivemobile").Trim();
            string usertel = DoRequest.GetFormString("usertel").Trim();
            string zipcode = DoRequest.GetFormString("zipcode").Trim();
            if(orderNumber.Length<1)
            {
                return Json(new { error = true, message = "订单号不能为空" });
            }
            if (receivename.Length < 1)
            {
                return Json(new { error = true, message = "收货人不能为空" });
            }
            if (provincename.Length < 1)
            {
                return Json(new { error = true, message = "省名不能为空" });
            }
            if (provincename.Length < 1)
            {
                return Json(new { error = true, message = "省名不能为空" });
            }
            if (cityname.Length < 1)
            {
                return Json(new { error = true, message = "市名不能为空" });
            }
            if (receiveaddr.Length < 1)
            {
                return Json(new { error = true, message = "收货地址不能为空" });
            }
            if (receivemobile.Length < 1)
            {
                return Json(new { error = true, message = "收货电话不能为空" });
            }
            if (!Utils.IsMobile(receivemobile))
            {
                return Json(new { error = true, message = "收货电话格式不正确" });
            }
            if (usertel.Length != 0 && !Utils.IsMobile(usertel))
            {
                return Json(new { error = true, message = "用户电话格式不正确" });
            }

            int returnValue = -1;
            var res = UpdateOrderReceiveAddr.Do(orderNumber, receivename, provincename, cityname, countyname, receiveaddr, receivemobile, usertel, zipcode);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("order-");
                return Json(new { error = false, message = "操作成功" });
            }
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region GetOrderProducts 获取订单商品
        [HttpPost]
        public ActionResult GetOrderProducts()
        {
            string orderno = DoRequest.GetFormString("orderno");

            List<PayOrderItems> productlist = new List<PayOrderItems>();
            var res = QueryPayOrderDetail.Do(orderno);
            
            if(res != null && res.Body != null && res.Body.order_list != null){
                foreach(OrderDetailsList item in res.Body.order_list){
                    for(int i = 0;i<item.order_item_list.Count ;i++){
                        productlist.Add(item.order_item_list[i]);
                    }    
                }
                return Json(new { error = false, list = productlist, message = "操作成功!" });
            }
            return Json(new { error = true, message = "未找到对应的订单信息！" });
        }
        #endregion

        #region ResetPartOrderStatus 退订（部分）
        [HttpPost]
        public ActionResult ResetPartOrderStatus()
        {
            string idString = DoRequest.GetFormString("visitid").Trim();
            string orderno = DoRequest.GetFormString("orderNumber");
            int serviceState = DoRequest.GetFormInt("serviceState");
            string remark = DoRequest.GetFormString("remark");

            if (serviceState < 0 || serviceState > 2)
            {
                return Json(new { error = true, message = "参数错误" });
            }
            int returnValue = -1;

            var res = RefundPartOrder.Do(orderno, serviceState, idString, remark);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);

            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("order-");
                return Json(new { error = false, message = "操作成功!" });
            }
            if (returnValue == 90195)
                return Json(new { error = true, message = res.Header.Result.Msg.Substring(8) });
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region ReturnPartOrderStatus 退货（部分）
        [HttpPost]
        public ActionResult ReturnPartOrderStatus()
        {
            string idString = DoRequest.GetFormString("visitid").Trim();
            string orderno = DoRequest.GetFormString("orderNumber");
            int serviceState = DoRequest.GetFormInt("serviceState");
            string remark = DoRequest.GetFormString("remark");

            if (serviceState < 0 || serviceState > 2)
            {
                return Json(new { error = true, message = "参数错误" });
            }
            int returnValue = -1;

            var res = ReturnPartOrder.Do(orderno, serviceState, idString, remark);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);

            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("order-");
                return Json(new { error = false, message = "操作成功!" });
            }
            if (returnValue == 90195)
                return Json(new { error = true, message = res.Header.Result.Msg.Substring(8) });
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostProductCodeData 修改订单商品编码
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostProductCodeData()
        {
            string orderid = DoRequest.GetFormString("orderid");
            string productid = DoRequest.GetFormString("productid");
            string productcode = DoRequest.GetFormString("productcode");

            if (productcode.Length < 1)
            {
                return Json(new { error = true, message = "商品编码不能为空！" });
            }

            int returnValue = -1;
            var res = UpdateOrderProductCode.Do(orderid, productid, productcode);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("order-");
                return Json(new { error = false, message = "操作成功" });
            }
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region 处方药需求列表
        public ActionResult needlist()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,102,148,600,"))
                {
                    currResBody = item;
                    break;
                }
            }
            HasPermission(currResBody.res_id);

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            int pagesize = DoRequest.GetQueryInt("size", 20);
            int pageindex = DoRequest.GetQueryInt("page", 1);
            int status = DoRequest.GetQueryInt("status", -1);
            //int sType = DoRequest.GetQueryInt("stype");
            DateTime date = DateTime.Now.AddDays(-15);
            DateTime sDate = DoRequest.GetQueryDate("sDate", date);
            DateTime eDate = DoRequest.GetQueryDate("eDate", DateTime.Now).AddDays(1);

            //string ocol = DoRequest.GetQueryString("ocol").Trim();
            //string otype = DoRequest.GetQueryString("ot");

            //if (ocol.Equals(""))
            //    ocol = "add_time";

            string ot = "DESC";
            //if (otype.ToLower().Trim() == "asc")
            //{
            //    ot = "ASC";
            //}

            //string q = DoRequest.GetQueryString("q").Trim();
            //string sKey = "";
            //#region 处理查询关键词中的空格
            //string[] qList = q.Split(' ');
            //for (int i = 0; i < qList.Length; i++)
            //{
            //    if (string.IsNullOrEmpty(qList[i].Trim()))
            //        continue;
            //    if (i > 0)
            //        sKey += " ";
            //    sKey += qList[i];
            //}
            //q = sKey;
            //#endregion

            #region  处方药需求列表
            int dataCount = 0;
            int pageCount = 0;
            List<NeedInfo> infoList = new List<NeedInfo>();
            //string cachekey = "need-index=" + pageindex + "status=" + status + "sdate=" + sDate.ToString("yyyy-MM-dd") + "edate=" + eDate.ToString("yyyy-MM-dd") + "ot=" + ot;
            //DoCache cache = new DoCache();
            //if (cache.GetCache(cachekey) == null)
            //{

                var res = QueryNeedList.Do(pagesize, pageindex
                    , status
                    , sDate.ToString("")
                    , eDate.ToString("")
                    , ot
                    , ref dataCount
                    , ref pageCount);

                if (res != null && res.Body != null && res.Body.need_list != null)
                {
                    infoList = res.Body.need_list;
                   // cache.SetCache(cachekey, infoList, 10);
                   // cache.SetCache("order-datacount1", dataCount, 10);
                   // if (infoList.Count == 0)
                   //     cache.RemoveCache(cachekey);
                }
            //}
            //else
           // {
             //   infoList = (List<NeedInfo>)cache.GetCache(cachekey);
            //    dataCount = (int)cache.GetCache("need-datacount1");
           // }

          
            

            ViewData["infoList"] = infoList;//处方药需求列表
            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/msell/needlist?");
            currPageUrl.Append("status=" + status);
            currPageUrl.Append("&size=" + pagesize);
            currPageUrl.Append("&sdate=" + sDate.ToString("yyyy-MM-dd"));
            currPageUrl.Append("&edate=" + eDate.AddDays(-1).ToString("yyyy-MM-dd"));
            currPageUrl.Append("&page=" + pageindex);
            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL
            ViewData["pagesize"] = pagesize;
            ViewData["pageindex"] = pageindex;
            ViewData["dataCount"] = dataCount;

            ViewData["pageIndexLink"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            ViewData["pageIndexLink2"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            #endregion

            return View();
        }
        #endregion

        #region PassNeed 
        [HttpPost]
        public ActionResult PassNeed()
        {
            string id = DoRequest.GetFormString("id").Trim();
            if (string.IsNullOrEmpty(id))
            {
                return Json(new { error = true, message = "没有选择任何项" });
            }
            int returnValue = -1;
            var res = ModifyNeedState.Do(id, 1, "need_state");
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code,-1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion
        
        #region nopassNeed
        [HttpPost]
        public ActionResult nopassNeed()
        {
            string id = DoRequest.GetFormString("id").Trim();
            if (string.IsNullOrEmpty(id))
            {
                return Json(new { error = true, message = "没有选择任何项" });
            }
            int returnValue = -1;
            var res = ModifyNeedState.Do(id, 2, "need_state");
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostNeedAddr 修改处方药需求收货信息
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostNeedAddr()
        {
            string need_id = DoRequest.GetFormString("need_id").Trim();
            string receive_mobile_no = DoRequest.GetFormString("receive_mobile_no").Trim();
            string province_name = DoRequest.GetFormString("province_name").Trim();
            string city_name = DoRequest.GetFormString("city_name").Trim();
            string county_name = DoRequest.GetFormString("county_name").Trim();
            string receive_addr = DoRequest.GetFormString("receive_addr").Trim();
            string receive_name = DoRequest.GetFormString("receive_name").Trim();
            if (need_id.Length < 1)
            {
                return Json(new { error = true, message = "订单号不能为空" });
            }
            if (receive_mobile_no.Length < 1)
            {
                return Json(new { error = true, message = "收货人电话不能为空" });
            }
            if (province_name.Length < 1)
            {
                return Json(new { error = true, message = "省名不能为空" });
            }
            if (!Utils.IsMobile(receive_mobile_no))
            {
                return Json(new { error = true, message = "收货电话格式不正确" });
            }
            if (county_name.Length < 1)
            {
                return Json(new { error = true, message = "县名不能为空" });
            }
            if (city_name.Length < 1)
            {
                return Json(new { error = true, message = "市名不能为空" });
            }
            if (receive_addr.Length < 1)
            {
                return Json(new { error = true, message = "收货地址不能为空" });
            }
            if (receive_mobile_no.Length < 1)
            {
                return Json(new { error = true, message = "收货电话不能为空" });
            }
            if (receive_name.Length < 1)
            {
                return Json(new { error = true, message = "收货人不能为空" });
            }
            int returnValue = -1;
            //string need_id = DoRequest.GetFormString("need_id").Trim();
            //string receive_mobile_no = DoRequest.GetFormString("receive_mobile_no").Trim();
            //string province_name = DoRequest.GetFormString("province_name").Trim();
            //string city_name = DoRequest.GetFormString("city_name").Trim();
            //string county_name = DoRequest.GetFormString("county_name").Trim();
            //string receive_addr = DoRequest.GetFormString("receive_addr").Trim();
            //string receive_name = DoRequest.GetFormString("receive_name").Trim();
            var res = UpdateNeedReceiveAddr.Do(need_id, receive_mobile_no, province_name, city_name, county_name, receive_addr, receive_name);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功" });
            }
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region updateNeedRemark 修改需求备注
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult updateNeedRemark()
        {
            string Needid = DoRequest.GetFormString("Needid").Trim();
            string remark = DoRequest.GetFormString("remark");

            if (string.IsNullOrEmpty(Needid))
            {
                return Json(new { error = true, message = "参数错误" });
            }
            if (remark.Length > 400)
            {
                return Json(new { error = true, message = "备注不能超过400个字符" });
            }
            int returnValue = -1;
            var res = UpdateNeedRemark.Do(Needid, remark);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);

            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region AuditOrderStates 
        [HttpPost]
        public ActionResult AuditOrderStates()
        {

            string order_no = DoRequest.GetFormString("order_no").Trim();
            int result = DoRequest.GetFormInt("result");
            Logger.Error(order_no + result);
            if (string.IsNullOrEmpty(order_no))
            {
                return Json(new { error = true, message = "参数错误" });
            }
            int returnValue = -1;
            var res = AuditOrder.Do(order_no, result);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);

            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("order-");
                return Json(new { error = false, message = "操作成功!" });
            }
            if (returnValue == -1)
                return Json(new { error = true, message = res.Header.Result.Msg.Substring(8) });
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region 退换货申请
        #region 退换货申请列表
        public ActionResult refoudreq()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,102,148,603,"))
                {
                    currResBody = item;
                    break;
                }
            }
            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            HasPermission(currResBody.res_id);

            int pagesize = 100;
            int pageindex = DoRequest.GetQueryInt("page", 1);
            int type = DoRequest.GetQueryInt("type", -1);

            DateTime date = DateTime.Now.AddMonths(-1);
            DateTime sDate = DoRequest.GetQueryDate("sDate", date);
            DateTime eDate = DoRequest.GetQueryDate("eDate", DateTime.Now).AddDays(1);

            string q = DoRequest.GetQueryString("q");


            int dataCount = 0;
            int pageCount = 0;
            List<RefoudReqInfo> infoList = new List<RefoudReqInfo>();

            //todo
            var res = QueryRefoudReqList.Do(pagesize, pageindex
                 , type
                 , q
                 , sDate.ToString("yyyy-MM-dd 00:00:00")
                 , eDate.ToString("yyyy-MM-dd 23:59:59")
                 , ref dataCount, ref pageCount);
            if (res != null && res.Body != null && res.Body.refoudReq_list != null)
            {
                infoList = res.Body.refoudReq_list;

            }

            ViewData["infoList"] = infoList;

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/msell/refoudreq?");
            currPageUrl.Append("page=" + pageindex);
            currPageUrl.Append("&sdate=" + sDate.ToString("yyyy-MM-dd"));
            currPageUrl.Append("&edate=" + eDate.AddDays(-1).ToString("yyyy-MM-dd"));
            currPageUrl.Append("&q=" + q);
            currPageUrl.Append("&type=" + type);
            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL
            ViewData["pagesize"] = pagesize;
            ViewData["pageindex"] = pageindex;
            ViewData["dataCount"] = dataCount;
            ViewData["pageIndexLink"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            ViewData["pageIndexLink2"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());

            return View();
        }
        #endregion

        #region RefoudReqReply 回复申请
        [HttpPost]
        public ActionResult RefoudReqReply()
        {
            int commentid = DoRequest.GetFormInt("commentid");
            string content = DoRequest.GetFormString("content");
            int state = DoRequest.GetFormInt("state");
            if (commentid == 0)
            {
                return Json(new { error = true, message = "参数错误" });
            }
            //判断是否存在 如果存在就修改 不存在就添加
            int returnValue = -1;
            var res = OpRefoudReqReply.Do(commentid, content, state);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);

            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion
        #endregion

        #region 门店分销
        #region StoreList
        public ActionResult StoreList()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,102,604,605,"))
                {
                    currResBody = item;
                    break;
                }
            }
            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            HasPermission(currResBody.res_id);

            int pagesize = 100;
            int pageindex = DoRequest.GetQueryInt("page", 1);
            string q = DoRequest.GetQueryString("q");


            int dataCount = 0;
            int pageCount = 0;
            List<StoreInfo> infoList = new List<StoreInfo>();

            //todo
            var res = QueryStoreList.Do(pagesize, pageindex
                 , q
                 , ref dataCount, ref pageCount);
            if (res != null && res.Body != null && res.Body.store_list != null)
            {
                infoList = res.Body.store_list;

            }

            ViewData["infoList"] = infoList;

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/msell/storelist?");
            currPageUrl.Append("page=" + pageindex);
            currPageUrl.Append("&q=" + q);            
            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL
            ViewData["pagesize"] = pagesize;
            ViewData["pageindex"] = pageindex;
            ViewData["dataCount"] = dataCount;
            ViewData["pageIndexLink"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            ViewData["pageIndexLink2"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());

            return View();
        }
        #endregion

        #region Storeeditor
        public ActionResult Storeeditor()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,102,604,605,"))
                {
                    currResBody = item;
                    break;
                }
            }
            HasPermission(currResBody.res_id);
            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            return View();
        }
        #endregion

        #region PostStoreData 保存门店信息
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostStoreData()
        {
            int id = DoRequest.GetFormInt("id");
            StoreInfo store = new StoreInfo();
            var resstore = GetStoreInfo.Do(id);            
            if (resstore != null && resstore.Body != null)
                store = resstore.Body;
            #region 获取参数
            store.store_name = DoRequest.GetFormString("store_name").Trim();
            store.store_id = id.ToString();
            #region Checking
            if (store.store_name.Length < 1)
            {
                return Json(new { error = true, input = "message", message = "请填写名称" });
            }
            #endregion
            if (id == 0)
            {
                store.create_time = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            }
            #endregion
            int returnValue = -1;
            var res = OpStore.Do(store);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            #region 判断是否操作成功
            string msgText = "";
            switch (returnValue)
            {
                case 0:
                    msgText = "操作成功";
                    break;
                case -1:
                default:
                    msgText = "操作失败";
                    break;
            }
            #endregion

            return Json(new { error = returnValue == 0 ? false : true, message = msgText });
        }
        #endregion

        #region RemoveStoreList 删除门店信息
        [HttpPost]
        public ActionResult RemoveStoreList()
        {
            string idString = DoRequest.GetFormString("visitid").Trim();
            if (string.IsNullOrEmpty(idString))
            {
                return Json(new { error = true, message = "没有选择任何项" });
            }

            int returnValue = -1;
            var res = DeleteStore.Do(idString);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region QRcodeStore 门店二维码下载
        public ActionResult QRcodeStore()
        {
            string key = DoRequest.GetQueryString("key").Trim();
            string url = "http://m.dada360.com/activity/20170828/activity.jsp";
            //string url = "http://m.dada360.com";
            //string url = "http://m.dada360.com/festival/mendianzhuanqu.html";
            #region
            QRCodeEncoder qrCodeEncoder = new QRCodeEncoder();
            qrCodeEncoder.QRCodeEncodeMode = QRCodeEncoder.ENCODE_MODE.BYTE;
            qrCodeEncoder.QRCodeScale = 8;           
            qrCodeEncoder.QRCodeVersion = 4;//版本与数组长度有关
            qrCodeEncoder.QRCodeErrorCorrect = QRCodeEncoder.ERROR_CORRECTION.M;
            url = string.Format("{0}?key={1}", url, key);
            System.Drawing.Bitmap image = qrCodeEncoder.Encode(url);
            System.IO.MemoryStream MStream = new System.IO.MemoryStream();
            image.Save(MStream, System.Drawing.Imaging.ImageFormat.Png);
            //Response.ClearContent();
            //Response.ContentType = "image/Png";
            //Response.BinaryWrite(MStream.ToArray());
            return File(MStream.ToArray(), "image/Png","二维码.png");
            #endregion
        }
        #endregion

        #region  StoreOrderList 分销订单列表
        public ActionResult StoreOrderList()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,102,604,606,"))
                {
                    currResBody = item;
                    break;
                }
            }
            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            HasPermission(currResBody.res_id);

            int pagesize = 100;
            int pageindex = DoRequest.GetQueryInt("page", 1);
            string q = DoRequest.GetQueryString("q");


            int dataCount = 0;
            int pageCount = 0;
            List<FullStoreOrderInfo> infoList = new List<FullStoreOrderInfo>();

            //todo
            var res = QueryStoreOrderList.Do(pagesize, pageindex
                 , q
                 , ref dataCount, ref pageCount);
            if (res != null && res.Body != null && res.Body.order_list != null)
            {
                infoList = res.Body.order_list;

            }

            ViewData["infoList"] = infoList;

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/msell/storeorderlist?");
            currPageUrl.Append("page=" + pageindex);
            currPageUrl.Append("&q=" + q);
            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL
            ViewData["pagesize"] = pagesize;
            ViewData["pageindex"] = pageindex;
            ViewData["dataCount"] = dataCount;
            ViewData["pageIndexLink"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            ViewData["pageIndexLink2"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());

            return View();
        }
        #endregion

        #region 分销订单核对状态

        #endregion

        #region 分销订单详情
        public ActionResult StoreOrderItem()
        {
            string payorderNumber = DoRequest.GetQueryString("payorderNumber");
            PayOrderInfo order = null;

            var res = GetPayOrderDetail.Do(payorderNumber);
            if (res == null || res.Body == null)
            {
                order = new PayOrderInfo();
            }
            else
            {
                order = res.Body;
            }

            ViewData["payOrderInfo"] = order;

            return View();
        }

        #endregion

            #endregion

            #region 充值列表
            #region  RechargeList 充值列表
        public ActionResult RechargeList()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,102,604,607,"))
                {
                    currResBody = item;
                    break;
                }
            }
            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            HasPermission(currResBody.res_id);

            int pagesize = 100;
            int pageindex = DoRequest.GetQueryInt("page", 1);
            string q = DoRequest.GetQueryString("q");
            int searchtype = DoRequest.GetQueryInt("searchtype");

            int dataCount = 0;
            int pageCount = 0;
            List<RechargeInfo> infoList = new List<RechargeInfo>();

          
            var res = QueryReChargeList.Do(pagesize, pageindex, searchtype
                 , q
                 , ref dataCount, ref pageCount);
            if (res != null && res.Body != null && res.Body.recharge_list != null)
            {
                infoList = res.Body.recharge_list;

            }

            ViewData["infoList"] = infoList;

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/msell/ReChargeList?");
            currPageUrl.Append("page=" + pageindex);
            currPageUrl.Append("&q=" + q);
            currPageUrl.Append("&searchtype=" + searchtype);
            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL
            ViewData["pagesize"] = pagesize;
            ViewData["pageindex"] = pageindex;
            ViewData["dataCount"] = dataCount;
            ViewData["pageIndexLink"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            ViewData["pageIndexLink2"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());

            return View();
        }
        #endregion
        #endregion

        #region 微脉订单列表
        public ActionResult WmIndex()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,102,148,609,"))
                {
                    currResBody = item;
                    break;
                }
            }
            HasPermission(currResBody.res_id);

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            int pagesize = DoRequest.GetQueryInt("size", 20);
            int pageindex = DoRequest.GetQueryInt("page", 1);
            int status = DoRequest.GetQueryInt("status", -1);
            int sType = DoRequest.GetQueryInt("stype", 0);
            int payType = 8;
            DateTime date = DateTime.Now.AddDays(-15);
            DateTime sDate = DoRequest.GetQueryDate("sDate", date);
            DateTime eDate = DoRequest.GetQueryDate("eDate", DateTime.Now).AddDays(1);

            string ocol = DoRequest.GetQueryString("ocol").Trim();
            string otype = DoRequest.GetQueryString("ot");

            if (ocol.Equals(""))
                ocol = "ADDTIME";

            string ot = "DESC";
            if (otype.ToLower().Trim() == "asc")
            {
                ot = "ASC";
            }

            string q = DoRequest.GetQueryString("q").Trim();
            string sKey = "";
            #region 处理查询关键词中的空格
            string[] qList = q.Split(' ');
            for (int i = 0; i < qList.Length; i++)
            {
                if (string.IsNullOrEmpty(qList[i].Trim()))
                    continue;
                if (i > 0)
                    sKey += " ";
                sKey += qList[i];
            }
            q = sKey;
            #endregion

            #region 订单列表
            int dataCount = 0;
            int pageCount = 0;
            List<OrderPayInfo> infoList = new List<OrderPayInfo>();
                var res = QueryOrderList.Do(pagesize, pageindex
                    , status
                    , sDate.ToString("")
                    , eDate.ToString("")
                    , sType
                    , payType
                    , sKey
                    , ocol
                    , ot
                    , ref dataCount
                    , ref pageCount);

            if (res != null && res.Body != null && res.Body.order_pay_list != null)
            {
                infoList = res.Body.order_pay_list;
            }
            ViewData["infoList"] = infoList;//订单列表
            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/msell/Wmindex?");
            currPageUrl.Append("status=" + status);
            currPageUrl.Append("&stype=" + sType);
            currPageUrl.Append("&size=" + pagesize);
            currPageUrl.Append("&sdate=" + sDate.ToString("yyyy-MM-dd"));
            currPageUrl.Append("&edate=" + eDate.AddDays(-1).ToString("yyyy-MM-dd"));
            currPageUrl.Append("&ocol=" + ocol);
            currPageUrl.Append("&ot=" + otype);

            currPageUrl.Append("&q=" + DoRequest.UrlEncode(q));
            currPageUrl.Append("&page=" + pageindex);
            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL
            ViewData["pagesize"] = pagesize;
            ViewData["pageindex"] = pageindex;
            ViewData["dataCount"] = dataCount;

            ViewData["pageIndexLink"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            ViewData["pageIndexLink2"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            #endregion

            return View();
        }
        #endregion

        #region 微脉搜索历史
        public ActionResult WmSearchList()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,102,148,610,"))
                {
                    currResBody = item;
                    break;
                }
            }
            HasPermission(currResBody.res_id);
            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置
            int pagesize = DoRequest.GetQueryInt("size", 20);
            int pageindex = DoRequest.GetQueryInt("page", 1);            
            DateTime date = DateTime.Now.AddDays(-15);
            DateTime sDate = DoRequest.GetQueryDate("sDate", date);
            DateTime eDate = DoRequest.GetQueryDate("eDate", DateTime.Now).AddDays(1);
            string q = DoRequest.GetQueryString("q").Trim();
            string sKey = "";
            #region 处理查询关键词中的空格
            string[] qList = q.Split(' ');
            for (int i = 0; i < qList.Length; i++)
            {
                if (string.IsNullOrEmpty(qList[i].Trim()))
                    continue;
                if (i > 0)
                    sKey += " ";
                sKey += qList[i];
            }
            q = sKey;
            #endregion
            #region 查询列表
            int dataCount = 0;
            int pageCount = 0;
            List<WmWordsInfo> infoList = new List<WmWordsInfo>();
            var res = QueryWmWordsList.Do(pagesize, pageindex
                , q, sDate.ToString("")
                    , eDate.ToString("")
                , ref dataCount
                , ref pageCount);
            if (res != null && res.Body != null && res.Body.word_list != null)
            {
                infoList = res.Body.word_list;
            }
            ViewData["infoList"] = infoList;//订单列表
            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/msell/WmSearchList?");
            currPageUrl.Append("size=" + pagesize);
            currPageUrl.Append("&sdate=" + sDate.ToString("yyyy-MM-dd"));
            currPageUrl.Append("&edate=" + eDate.AddDays(-1).ToString("yyyy-MM-dd"));
            currPageUrl.Append("&q=" + DoRequest.UrlEncode(q));
            currPageUrl.Append("&page=" + pageindex);
            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL
            ViewData["pagesize"] = pagesize;
            ViewData["pageindex"] = pageindex;
            ViewData["dataCount"] = dataCount;
            ViewData["pageIndexLink"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            ViewData["pageIndexLink2"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            #endregion
            return View();
        }
        #endregion

        #region updateNeedRemark 设置为微脉爆款
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult AddBrust()
        {
            string product_id = DoRequest.GetFormString("postBrust-proid").Trim();
            string brust_intro = DoRequest.GetFormString("postBrust-textarea");

            if (string.IsNullOrEmpty(product_id))
            {
                return Json(new { error = true, message = "参数错误" });
            }
            if (brust_intro.Length > 80)
            {
                return Json(new { error = true, message = "推荐语不能超过80个字符" });
            }
            int returnValue = -1;
            var res = OpBrust.Do(product_id, brust_intro);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);

            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region  删除微脉爆款
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult DelBrust()
        {
            string product_id = DoRequest.GetFormString("productid").Trim();
            if (string.IsNullOrEmpty(product_id))
            {
                return Json(new { error = true, message = "参数错误" });
            }
            int returnValue = -1;
            var res = DeleteBrust.Do(product_id);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);

            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion
    }
}
 
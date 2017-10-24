using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data;

using JiuZhou.ControllerBase;
using JiuZhou.MySql;
using JiuZhou.HttpTools;
using JiuZhou.Common;
using System.IO;
using System.Text;
using JiuZhou.Cache;

namespace JiuZhou.Shop.WebManager.Controllers
{
    [HandleError]
    public class MAnalysisController : ForeSysBaseController
    {
        #region CategoryPieView(饼图)
        public ActionResult CategoryPieView()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,106,245,248,"))
                {
                    currResBody = item;
                    break;
                }
            }

            HasPermission(currResBody.res_id);

            DateTime date = DateTime.Now.AddDays(-1);
            DateTime sDate = DoRequest.GetQueryDate("sDate", date);
            DateTime eDate = DoRequest.GetQueryDate("eDate", DateTime.Now.AddDays(-1));

            string type = DoRequest.GetQueryString("type");
            List<YlmxlphInfo> alllist1 = new List<YlmxlphInfo>();
            DoCache cache = new DoCache();
            string cachekey = "Ylmxlph-sdate=" + sDate.ToString("yyyy-MM-dd") + "edate=" + eDate.ToString("yyyy-MM-dd") + "typeid=-1";
            if (cache.GetCache(cachekey) == null)
            {
                var res = Ylmxlph.Do(30, 1, sDate.ToString("yyyy-MM-dd"), eDate.ToString("yyyy-MM-dd"), "product_type_id", -1);
                if (res != null && res.Body != null && res.Body.list != null && res.Body.countAll != null)
                {
                    alllist1 = res.Body.countAll;
                    cache.SetCache(cachekey, alllist1, 600);
                    if (alllist1.Count() == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else
            {
                alllist1 = (List<YlmxlphInfo>)cache.GetCache(cachekey);
            }
            List<YlmxlphInfo> alllist = new List<YlmxlphInfo>();
            if (!type.Equals(""))
            {
                alllist = alllist1.FindAll(delegate(YlmxlphInfo item) { return item.shop_name.Equals(type); });
            }
            else
            {
                alllist = alllist1;
            }

            string tname = "";
            string tmoney = "";
            int _count = 0;
            foreach (YlmxlphInfo item in alllist)
            {
                foreach (YlmxlphDetails item2 in item.type_details)
                {
                    if (_count == 0)
                    {
                        if (item2.type_name == null || item2.type_name.Equals("null"))
                            item2.type_name = "其他";
                        tname = item2.type_name + ":" + item2.sale_money + " 元";
                        tmoney = item2.sale_money;
                    }
                    else
                    {
                        if (item2.type_name == null || item2.type_name.Equals("null"))
                            item2.type_name = "其他";
                        tname = tname + "," + item2.type_name + ":" + item2.sale_money + " 元";
                        tmoney = tmoney + "," + item2.sale_money;
                    }
                    _count++;
                }
            }
            ViewData["tname"] = tname;
            ViewData["tmoney"] = tmoney;
            string _data = "部门,类目名称,销售数量,销售额\r\n";
            foreach (YlmxlphInfo item in alllist)
            {
                foreach (YlmxlphDetails item2 in item.type_details)
                {
                    _data = _data + item.shop_name + "," + item2.type_name + "," + item2.product_num + "," + item2.sale_money + "\r\n";
                }
            }

            Session["infoList"] = _data;
            Session["name"] = sDate.ToString("yyyy-MM-dd") + "-" + eDate.ToString("yyyy-MM-dd") + "经营概览表.csv";

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/manalysis/CategoryPieView?");
            currPageUrl.Append("&sDate=" + sDate.ToString("yyyy-MM-dd"));
            currPageUrl.Append("&eDate=" + eDate.ToString("yyyy-MM-dd"));
            currPageUrl.Append("&type=" + type);
            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL
            return View();
        }
        #endregion

        #region 经营概览(数据)
        public ActionResult BusinessOverdata()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,106,245,247,"))
                {
                    currResBody = item;
                    break;
                }
            }

            HasPermission(currResBody.res_id);
            DateTime date = DateTime.Now.AddDays(-8);
            DateTime sDate = DoRequest.GetQueryDate("sDate", date);
            DateTime eDate = DoRequest.GetQueryDate("eDate", DateTime.Now.AddDays(-1));
            int pagesize = DoRequest.GetQueryInt("size", 30);
            int pageindex = DoRequest.GetQueryInt("page", 1);

            ResponseJyglBody infolist = new ResponseJyglBody();
            DoCache cache = new DoCache();
            string cachekey = "Jygl1-sdate=" + sDate.ToString("yyyy-MM-dd") + "edate=" + eDate.ToString("yyyy-MM-dd");
            if (cache.GetCache(cachekey) == null)
            {
                var reslist = Jygl.Do(pagesize, pageindex, sDate.ToString("yyyy-MM-dd"), eDate.ToString("yyyy-MM-dd"));
                if (reslist != null && reslist.Body != null && reslist.Body.list != null)
                {
                    infolist = reslist.Body;
                    cache.SetCache(cachekey, infolist, 600);
                    if (infolist.list.Count == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else {
                infolist = (ResponseJyglBody)cache.GetCache(cachekey);
            }
            ViewData["infoList"] = infolist;

            Session["sDate1"] = sDate.ToString("yyyy-MM-dd");
            Session["eDate1"] = eDate.ToString("yyyy-MM-dd");

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/manalysis/BusinessOverdata?");
            currPageUrl.Append("&sDate=" + sDate.ToString("yyyy-MM-dd"));
            currPageUrl.Append("&eDate=" + eDate.ToString("yyyy-MM-dd"));

            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL
            ViewData["pagesize"] = pagesize;
            ViewData["pageindex"] = pageindex;

            return View();
        }
        #endregion

        #region 经营概览(折线图)
        public ActionResult BusinessOverView()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,106,245,251,"))
                {
                    currResBody = item;
                    break;
                }
            }

            HasPermission(currResBody.res_id);
            DateTime date = DateTime.Now;
            DateTime sDate = DoRequest.GetQueryDate("sDate", date.AddMonths(-1).AddDays(-1));
            DateTime eDate = DoRequest.GetQueryDate("eDate", DateTime.Now.AddDays(-1));
            int pagesize = DoRequest.GetQueryInt("size", 30);
            int pageindex = DoRequest.GetQueryInt("page", 1);

            List<JyglInfo> infolist = new List<JyglInfo>();
            DoCache cache = new DoCache();
            string cachekey = "Jygl2-sdate=" + sDate.ToString("yyyy-MM-dd") + "edate=" + eDate.ToString("yyyy-MM-dd");
            if (cache.GetCache(cachekey) == null)
            {
                var reslist = Jygl.Do(pagesize, pageindex, sDate.ToString("yyyy-MM-dd"), eDate.ToString("yyyy-MM-dd"));
                if (reslist != null && reslist.Body != null && reslist.Body.list != null)
                {
                    infolist = reslist.Body.list;
                    cache.SetCache(cachekey, infolist, 600);
                    if (infolist.Count == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else {
                infolist = (List<JyglInfo>)cache.GetCache(cachekey);
            }
            //ViewData["infoList"] = infolist;
            string _date = "";
            string _data1 = "";
            string _data2 = "";
            string _data3 = "";
            string _data4 = "";

            for (int i = infolist.Count - 1; i >= 0; i--)
            {
                if (i == infolist.Count - 1)
                {
                    _date = infolist[i].query_date.Substring(5);
                    _data1 = infolist[i].amount_web;
                    _data2 = infolist[i].amount_mirco;
                    _data3 = infolist[i].amount_ios;
                    _data4 = infolist[i].amount_android;
                }
                else
                {
                    _date = _date + "," + infolist[i].query_date.Substring(5);
                    _data1 = _data1 + "," + infolist[i].amount_web;
                    _data2 = _data2 + "," + infolist[i].amount_mirco;
                    _data3 = _data3 + "," + infolist[i].amount_ios;
                    _data4 = _data4 + "," + infolist[i].amount_android;
                }
            }
            if (infolist.Count <= 31)
            {
                for (int i = 1; i <= 31 - infolist.Count; i++)
                {
                    _date = _date + "," + eDate.AddDays(i).ToString("yyyy-MM-dd");
                }
            }

            ViewData["date"] = _date;
            ViewData["data1"] = _data1;
            ViewData["data2"] = _data2;
            ViewData["data3"] = _data3;
            ViewData["data4"] = _data4;


            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            return View();
        }
        #endregion

        #region 类目销量(数据)
        public ActionResult CategoryData()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,106,245,568,"))
                {
                    currResBody = item;
                    break;
                }
            }

            HasPermission(currResBody.res_id);
            DateTime date = DateTime.Now.AddDays(-8);
            DateTime sDate = DoRequest.GetQueryDate("sDate", date);
            DateTime eDate = DoRequest.GetQueryDate("eDate", DateTime.Now.AddDays(-1));
            int typeid = DoRequest.GetQueryInt("product-type");
            int pagesize = DoRequest.GetQueryInt("size", 30);
            int pageindex = DoRequest.GetQueryInt("page", 1);

            string type = DoRequest.GetQueryString("type");
            List<YlmxlphInfo> infolist1 = new List<YlmxlphInfo>();
             DoCache cache = new DoCache();
            string cachekey = "Ylmxlph-sdate=" + sDate.ToString("yyyy-MM-dd") + "edate=" + eDate.ToString("yyyy-MM-dd") + "typeid=" + typeid;
            if (cache.GetCache(cachekey) == null)
            {
                var res = Ylmxlph.Do(pagesize, pageindex, sDate.ToString("yyyy-MM-dd"), eDate.ToString("yyyy-MM-dd"), "product_type_id", typeid);
                if (res != null && res.Body != null && res.Body.list != null && res.Body.countAll != null)
                {
                    infolist1 = res.Body.list;
                    cache.SetCache(cachekey, infolist1, 600);
                    if (infolist1.Count() == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else
            {
                infolist1 = (List<YlmxlphInfo>)cache.GetCache(cachekey);
            }
            List<YlmxlphInfo> infolist = new List<YlmxlphInfo>();
            if (!type.Equals(""))
            {
                infolist = infolist1.FindAll(delegate(YlmxlphInfo item) { return item.shop_name.Equals(type); });
            }
            else
            {
                infolist = infolist1;
            }


            ViewData["infoList"] = infolist;

            string _data = "日期,类目名称,销售量,销售额,日动销,日动销率,周动销率,月动销率,部门\r\n";
            foreach (YlmxlphInfo item in infolist)
            {
                foreach (YlmxlphDetails item2 in item.type_details)
                {
                    _data = _data + item.query_date + "," + item2.type_name + "," + item2.product_num + "," + item2.sale_money + "," + item2.type_sku + "," + item2.type_sku_rate + "," + item2.week_sku_rate + "," + item2.month_sku_rate + "," + item.shop_name + "\r\n";
                }
            }
            Session["infoList"] = _data;
            Session["name"] = sDate.ToString("yyyy-MM-dd") + "-" + eDate.ToString("yyyy-MM-dd") + "类目销量表.csv";

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/manalysis/CategoryData?");
            currPageUrl.Append("&sDate=" + sDate.ToString("yyyy-MM-dd"));
            currPageUrl.Append("&eDate=" + eDate.ToString("yyyy-MM-dd"));
            currPageUrl.Append("&type=" + type);
            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL

            return View();
        }
        #endregion

        #region 单品销售
        public ActionResult SinglePro()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,106,245,246,"))
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
            DateTime date = DateTime.Now.AddDays(-1);
            DateTime sDate = DoRequest.GetQueryDate("sDate", date);
            DateTime eDate = DoRequest.GetQueryDate("eDate", DateTime.Now.AddDays(-1));
            int pagesize = DoRequest.GetQueryInt("size", 30);
            int pageindex = DoRequest.GetQueryInt("page", 1);
            string ocol = DoRequest.GetQueryString("ocol").Trim().ToLower();
            if (ocol == "")
            {
                ocol = "sale_money";
            }
            string otype = DoRequest.GetQueryString("ot").Trim();
            if (otype == "")
            {
                otype = "DESC";
            }
            int typeid = DoRequest.GetQueryInt("product-type", 0);

            int dataCount = 0;
            int pageCount = 0;
            List<DpphInfo> infolist = new List<DpphInfo>();
            DoCache cache = new DoCache();
            string cachekey = "Dpph-size=" + pagesize + "index=" + pageindex + "sdate=" + sDate.ToString("yyyy-MM-dd") + "edate=" + eDate.ToString("yyyy-MM-dd") + "ocol=" + ocol + "type=" + otype + "typeid=" + typeid;
            if (cache.GetCache(cachekey) == null)
            {
                var res = Dpph.Do(pagesize, pageindex, sDate.ToString("yyyy-MM-dd"), eDate.ToString("yyyy-MM-dd"), ocol, otype, typeid, ref dataCount, ref pageCount);
                if (res != null && res.Body != null && res.Body.list != null)
                {
                    infolist = res.Body.list;
                    cache.SetCache(cachekey, infolist, 600);
                    cache.SetCache("Dpph-datacount", dataCount, 600);
                    if (infolist.Count() == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else {
                infolist = (List<DpphInfo>)cache.GetCache(cachekey);
                dataCount = (int)cache.GetCache("Dpph-datacount");
            }
            ViewData["infoList"] = infolist;

            Session["sDate5"] = sDate.ToString("yyyy-MM-dd");
            Session["eDate5"] = eDate.ToString("yyyy-MM-dd");

            Session["ocol"] = ocol;
            Session["otype"] = otype;
            Session["typeid"] = typeid;

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/manalysis/SinglePro?");
            currPageUrl.Append("&size=" + pagesize);
            currPageUrl.Append("&sDate=" + sDate.ToString("yyyy-MM-dd"));
            currPageUrl.Append("&eDate=" + eDate.ToString("yyyy-MM-dd"));
            currPageUrl.Append("&page=" + pageindex);
            currPageUrl.Append("&ocol=" + ocol);
            currPageUrl.Append("&ot=" + otype);
            currPageUrl.Append("&product-type=" + typeid);

            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL
            ViewData["pagesize"] = pagesize;
            ViewData["pageindex"] = pageindex;
            ViewData["dataCount"] = dataCount;

            ViewData["pageIndexLink"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            ViewData["pageIndexLink2"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());

            return View();
        }
        #endregion

        #region 实时统计 RealTimeView
        public ActionResult RealTimeView()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,106,245,255,"))
                {
                    currResBody = item;
                    break;
                }
            }

            HasPermission(currResBody.res_id);

            List<SstjInfo> infolist = new List<SstjInfo>();
            DoCache cache = new DoCache();
            if (cache.GetCache("Sstj") == null)
            {
                var res = Sstj.Do();
                if (res != null && res.Body != null && res.Body.list != null)
                {
                    infolist = res.Body.list;
                    cache.SetCache("Sstj", infolist, 10);
                }
            }
            else {
                infolist = (List<SstjInfo>)cache.GetCache("Sstj");
            }

            //string tname = "";
            string data1 = "";
            string data2 = "";
            int _count = 0;
            foreach (SstjInfo item in infolist)
            {
                if (_count < 24)
                {
                    if (_count == 0)
                    {
                        data1 = item.amount_by_chargetime;
                    }
                    else
                    {
                        data1 = data1 + "," + item.amount_by_chargetime;
                    }
                }
                else {
                    if (_count == 24) {
                        data2 = item.amount_by_chargetime;
                    }
                    else
                    {
                        data2 = data2 + "," + item.amount_by_chargetime;
                    }
                }
                _count++;
            }
            //ViewData["tname"] = tname;
            ViewData["data1"] = data1;
            ViewData["data2"] = data2;
            //ViewData["_tname"] = _tname;
            _count = 0;
            string _data = "时间,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23\r\n";
            foreach (SstjInfo item in infolist)
            {
                if (_count == 0) {
                    _data = _data + "今日";
                }
                if (_count < 24)
                {
                    _data = _data + "," + item.amount_by_chargetime ;
                }
                else {
                    if (_count == 24) {
                        _data = _data + "\r\n" + "昨日";
                    }
                    _data = _data + "," + item.amount_by_chargetime;
                }
                _count++;
            }

            Session["infoList"] = _data;
            Session["name"] = DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd") + "-" + DateTime.Now.ToString("yyyy-MM-dd") + "实时统计表.csv";
            
            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            return View();
        }
        #endregion

        #region 品牌排行统计 BrandData
        public ActionResult BrandData()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,106,245,566,"))
                {
                    currResBody = item;
                    break;
                }
            }

            HasPermission(currResBody.res_id);
            DateTime date = DateTime.Now;
            DateTime sDate = DoRequest.GetQueryDate("sDate", date.AddMonths(-1).AddDays(-1));
            DateTime eDate = DoRequest.GetQueryDate("eDate", DateTime.Now.AddDays(-1));
            int pagesize = DoRequest.GetQueryInt("size", 30);
            int pageindex = DoRequest.GetQueryInt("page", 1);
            int dataCount = 0;
            int pageCount = 0;

            List<PpphInfo> infolist = new List<PpphInfo>();
            DoCache cache = new DoCache();
            string cachekey = "Ppph-sdate=" + sDate.ToString("yyyy-MM-dd") + "edate=" + eDate.ToString("yyyy-MM-dd") +"index=" + pageindex;
            if (cache.GetCache(cachekey) == null)
            {
                var res = Ppph.Do(pagesize, pageindex, sDate.ToString("yyyy-MM-dd"), eDate.ToString("yyyy-MM-dd"), ref dataCount, ref pageCount);
                if (res != null && res.Body != null && res.Body.all_list != null)
                {
                    infolist = res.Body.all_list;
                    cache.SetCache(cachekey, infolist, 600);
                    cache.SetCache("Ppph-datacount", dataCount, 600);
                    if (infolist.Count() == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else {
                infolist = (List<PpphInfo>)cache.GetCache(cachekey);
                dataCount = (int)cache.GetCache("Ppph-datacount");
            }
            ViewData["infolist"] = infolist;
 
            Session["sDate3"] = sDate.ToString("yyyy-MM-dd");
            Session["eDate3"] = eDate.ToString("yyyy-MM-dd");
           
            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/manalysis/branddata?");
            currPageUrl.Append("&size=" + pagesize);
            currPageUrl.Append("&sDate=" + sDate.ToString("yyyy-MM-dd"));
            currPageUrl.Append("&eDate=" + eDate.ToString("yyyy-MM-dd"));
            currPageUrl.Append("&page=" + pageindex);

            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL
            ViewData["pagesize"] = pagesize;
            ViewData["pageindex"] = pageindex;
            ViewData["dataCount"] = dataCount;

            ViewData["pageIndexLink"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            ViewData["pageIndexLink2"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());

            return View();
        }
        #endregion

        #region 商家排行统计 ShopData
        public ActionResult ShopData()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,106,245,567,"))
                {
                    currResBody = item;
                    break;
                }
            }

            HasPermission(currResBody.res_id);
            DateTime date = DateTime.Now;
            DateTime sDate = DoRequest.GetQueryDate("sDate", date.AddMonths(-1).AddDays(-1));
            DateTime eDate = DoRequest.GetQueryDate("eDate", DateTime.Now.AddDays(-1));
            int pagesize = DoRequest.GetQueryInt("size", 30);
            int pageindex = DoRequest.GetQueryInt("page", 1);
            int dataCount = 0;
            int pageCount = 0;

            List<SjxlphInfo> infolist = new List<SjxlphInfo>();
            DoCache cache = new DoCache();
            string cachekey = "Sjxlph-sdate=" + sDate.ToString("yyyy-MM-dd") + "edate=" + eDate.ToString("yyyy-MM-dd") +"index=" + pageindex;
            if (cache.GetCache(cachekey) == null)
            {
                var res = Sjxlph.Do(pagesize, pageindex, sDate.ToString("yyyy-MM-dd"), eDate.ToString("yyyy-MM-dd"), ref dataCount, ref pageCount);
                if (res != null && res.Body != null && res.Body.all_list != null)
                {
                    infolist = res.Body.all_list;
                    cache.SetCache(cachekey, infolist, 600);
                    cache.SetCache("Sjxlph-datacount", dataCount, 600);
                    if (infolist.Count == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else {
                infolist = (List<SjxlphInfo>)cache.GetCache(cachekey);
                dataCount = (int)cache.GetCache("Sjxlph-datacount");
            }

            ViewData["infolist"] = infolist;

            Session["sDate4"] = sDate.ToString("yyyy-MM-dd");
            Session["eDate4"] = eDate.ToString("yyyy-MM-dd");

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/manalysis/ShopData?");
            currPageUrl.Append("&size=" + pagesize);
            currPageUrl.Append("&sDate=" + sDate.ToString("yyyy-MM-dd"));
            currPageUrl.Append("&eDate=" + eDate.ToString("yyyy-MM-dd"));
            currPageUrl.Append("&page=" + pageindex);

            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL
            ViewData["pagesize"] = pagesize;
            ViewData["pageindex"] = pageindex;
            ViewData["dataCount"] = dataCount;

            ViewData["pageIndexLink"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            ViewData["pageIndexLink2"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());

            return View();
        }
        #endregion

        #region 新品分析(数据)
        public ActionResult NewProData()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,106,245,573,"))
                {
                    currResBody = item;
                    break;
                }
            }

            HasPermission(currResBody.res_id);
            DateTime date = DateTime.Now.AddDays(-8);
            DateTime sDate = DoRequest.GetQueryDate("sDate", date);
            DateTime eDate = DoRequest.GetQueryDate("eDate", DateTime.Now.AddDays(-1));

            List<NewProductInCategoryInfo> infolist = new List<NewProductInCategoryInfo>();
            DoCache cache = new DoCache();
            string cachekey = "Xptj-sdate=" + sDate.ToString("yyyy-MM-dd") + "edate=" + eDate.ToString("yyyy-MM-dd");
            if (cache.GetCache(cachekey) == null)
            {
                var reslist = NewProductInCategory.Do(sDate.ToString("yyyy-MM-dd"), eDate.ToString("yyyy-MM-dd"));
                if (reslist != null && reslist.Body != null && reslist.Body.list != null)
                {
                    infolist = reslist.Body.list;
                    cache.SetCache(cachekey, infolist, 600);
                    if (infolist.Count == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else
            {
                infolist = (List<NewProductInCategoryInfo>)cache.GetCache(cachekey);
            }

            ViewData["infoList"] = infolist;

            Session["sDate6"] = sDate.ToString("yyyy-MM-dd");
            Session["eDate6"] = eDate.ToString("yyyy-MM-dd");

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/manalysis/NewProData?");
            currPageUrl.Append("&sDate=" + sDate.ToString("yyyy-MM-dd"));
            currPageUrl.Append("&eDate=" + eDate.ToString("yyyy-MM-dd"));

            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL

            return View();
        }
        #endregion

        #region 新用户分析(数据)
        public ActionResult NewUserData()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,106,245,571,"))
                {
                    currResBody = item;
                    break;
                }
            }

            HasPermission(currResBody.res_id);
            DateTime date = DateTime.Now.AddDays(-8);
            DateTime sDate = DoRequest.GetQueryDate("sDate", date);
            DateTime eDate = DoRequest.GetQueryDate("eDate", DateTime.Now.AddDays(-1));

            List<XyhtjInfo> infolist = new List<XyhtjInfo>();
            DoCache cache = new DoCache();
            string cachekey = "Xyhtj-sdate=" + sDate.ToString("yyyy-MM-dd") + "edate=" + eDate.ToString("yyyy-MM-dd");
            if (cache.GetCache(cachekey) == null)
            {
                var reslist = Xyhtj.Do(31, 1, sDate.ToString("yyyy-MM-dd"), eDate.ToString("yyyy-MM-dd"));
                if (reslist != null && reslist.Body != null && reslist.Body.list != null)
                {
                    infolist = reslist.Body.list;
                    cache.SetCache(cachekey, infolist, 600);
                    if (infolist.Count == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else
            {
                infolist = (List<XyhtjInfo>)cache.GetCache(cachekey);
            }
            ViewData["infoList"] = infolist;

            Session["sDate7"] = sDate.ToString("yyyy-MM-dd");
            Session["eDate7"] = eDate.ToString("yyyy-MM-dd");

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/manalysis/NewUserData?");
            currPageUrl.Append("&sDate=" + sDate.ToString("yyyy-MM-dd"));
            currPageUrl.Append("&eDate=" + eDate.ToString("yyyy-MM-dd"));

            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL

            return View();
        }
        #endregion

        #region 老用户分析(数据)
        public ActionResult OldUserData()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,106,245,572,"))
                {
                    currResBody = item;
                    break;
                }
            }

            HasPermission(currResBody.res_id);
            DateTime date = DateTime.Now.AddDays(-8);
            DateTime sDate = DoRequest.GetQueryDate("sDate", date);
            DateTime eDate = DoRequest.GetQueryDate("eDate", DateTime.Now.AddDays(-1));

            List<LyhtjInfo> infolist = new List<LyhtjInfo>();
             DoCache cache = new DoCache();
             string cachekey = "Lyhtj-sdate=" + sDate.ToString("yyyy-MM-dd") + "edate=" + eDate.ToString("yyyy-MM-dd");
            if (cache.GetCache(cachekey) == null)
            {
                var reslist = Lyhtj.Do(31, 1, sDate.ToString("yyyy-MM-dd"), eDate.ToString("yyyy-MM-dd"));
                if (reslist != null && reslist.Body != null && reslist.Body.list != null)
                {
                    infolist = reslist.Body.list;
                    cache.SetCache(cachekey, infolist, 600);
                    if (infolist.Count == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else
            {
                infolist = (List<LyhtjInfo>)cache.GetCache(cachekey);
            }
            ViewData["infoList"] = infolist;

            Session["sDate8"] = sDate.ToString("yyyy-MM-dd");
            Session["eDate8"] = eDate.ToString("yyyy-MM-dd");

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/manalysis/OldUserData?");
            currPageUrl.Append("&sDate=" + sDate.ToString("yyyy-MM-dd"));
            currPageUrl.Append("&eDate=" + eDate.ToString("yyyy-MM-dd"));

            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL

            return View();
        }
        #endregion

        #region   一类目下载页1
        public ActionResult DownLoadPage()
        {
            string _data = "";
            string _name = (string)Session["name"];
            _data = (string)Session["infoList"];
            byte[] _byte = Encoding.GetEncoding("gb2312").GetBytes(_data);

            Response.ClearHeaders();
            Response.Clear();
            Response.Expires = 0;
            Response.Buffer = true;
            Response.AddHeader("Accept-Language", "zh-cn");

            Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(_name, System.Text.Encoding.GetEncoding("utf-8")));
            Response.ContentType = "application/octet-stream;charset=gb2312";
            Response.BinaryWrite(_byte);
            Response.End();

            return View();
        }
        #endregion

        #region   经营概览下载页2
        public ActionResult DownLoadPage2()
        {
            string sdate = (string)Session["sDate1"];
            string edate = (string)Session["eDate1"];
            ResponseJyglBody info = new ResponseJyglBody();
            List<JyglInfo> infolist2 = new List<JyglInfo>();
            var reslist2 = Jygl.Do(999999, 1, sdate, edate);
            if (reslist2 != null && reslist2.Body != null && reslist2.Body.list != null)
            {
                infolist2 = reslist2.Body.list;
                info = reslist2.Body;
            }
            decimal totalamount1 = 0;
           // decimal totalamount2 = 0;
            decimal totalsellprofit = 0;
            int totalpayordercount = int.Parse(info.pay_order_in_all);
            int totalordercount = 0;
            int totalsalecount = 0;
            int totalpv = 0;
            int totaluv = 0;
            int totalpeoplenum = 0;
            string _data = "日期,总销售额（按支付时间）,销售总计,总毛利额,总毛利率,支付订单,总订单,动销品规数,药房总商品数,发货率,九洲发货率,UV,PV,转化率,订单人数,客单价,下单支付率\r\n";
            foreach (JyglInfo item in infolist2)
            {
                totalamount1 += Utils.IsNumber(item.amount_by_chargetime) ? decimal.Parse(item.amount_by_chargetime) : 0;
                //totalamount2 += Utils.IsNumber(item.amount_by_delivery_time) ? decimal.Parse(item.amount_by_delivery_time) : 0;
                totalsellprofit += Utils.IsNumber(item.sell_profit) ? decimal.Parse(item.sell_profit) : 0;
                
                totalordercount += Utils.IsNumber(item.total_order_count) ? int.Parse(item.total_order_count) : 0;
                totalsalecount += Utils.IsNumber(item.sale_product_count) ? int.Parse(item.sale_product_count) : 0;
                totalpv += Utils.IsNumber(item.page_view) ? int.Parse(item.page_view) : 0;
                totaluv += Utils.IsNumber(item.user_view) ? int.Parse(item.user_view) : 0;
                totalpeoplenum += Utils.IsNumber(item.people_num) ? int.Parse(item.people_num) : 0;
                _data = _data + item.query_date + "," + item.amount_by_chargetime + "," + item.amount + "," + item.sell_profit + "," + item.profit_percent + "," + item.payment_order_count + "," + item.total_order_count + "," + item.sale_product_count + "," + item.all_on_sale_product_num + "," + item.delivery_rate + "," + item.specific_delivery_rate + "," + item.user_view + "," + item.page_view + "," + item.transform_rate + "," + item.people_num + "," + item.payment_per_client + "," + item.payment_rate + "\r\n";
            }
            _data += "总计," + totalamount1.ToString() + ",--," + totalsellprofit + "," + ((totalsellprofit / totalamount1) * 100).ToString("#0.00") + "%," + totalpayordercount + "," + totalordercount + "," + info.sale_product_count_in_all + ",--," + info.delivery_rate_in_all + "," + info.specific_delivery_rate_in_all + "," + totaluv.ToString() + "," + totalpv + "," + ((totalpayordercount / (decimal)totaluv) * 100).ToString("#0.00") + "%," + info.people_num_in_all + "," + decimal.Parse((totalamount1 / totalpayordercount).ToString("#0.00")) + "," + (((decimal)totalpayordercount / (decimal)totalordercount) * 100).ToString("#0.00") + "%";

            string _name = sdate + "-" + edate + "经营概览表.csv";

            byte[] _byte = Encoding.GetEncoding("gb2312").GetBytes(_data);

            Response.ClearHeaders();
            Response.Clear();
            Response.Expires = 0;
            Response.Buffer = true;
            Response.AddHeader("Accept-Language", "zh-cn");

            Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(_name, System.Text.Encoding.GetEncoding("utf-8")));
            Response.ContentType = "application/octet-stream;charset=gb2312";
            Response.BinaryWrite(_byte);
            Response.End();

            return View();
        }
        #endregion

        #region   品牌下载页3
        public ActionResult DownLoadPage3()
        {
            string sdate = (string)Session["sDate3"];
            string edate = (string)Session["eDate3"];
            int dataCount = 0;
            int pageCount = 0;
            List<PpphInfo> infolist2 = new List<PpphInfo>();
            var reslist2 = Ppph.Do(999999, 1, sdate, edate, ref dataCount, ref pageCount);
            if (reslist2 != null && reslist2.Body != null && reslist2.Body.all_list != null)
                infolist2 = reslist2.Body.all_list;

            string _data = "品牌名称,销售额,销售数量,周动销\r\n";
            foreach (PpphInfo item in infolist2)
            {
                _data += item.brand_name + "," + item.sale_amount + " 元" + "," + item.product_num + "," + item.week_sku_rate + "\r\n";
            }


            string _name = sdate + "-" + edate + "品牌销售统计表.csv";

            byte[] _byte = Encoding.GetEncoding("gb2312").GetBytes(_data);

            Response.ClearHeaders();
            Response.Clear();
            Response.Expires = 0;
            Response.Buffer = true;
            Response.AddHeader("Accept-Language", "zh-cn");

            Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(_name, System.Text.Encoding.GetEncoding("utf-8")));
            Response.ContentType = "application/octet-stream;charset=gb2312";
            Response.BinaryWrite(_byte);
            Response.End();

            return View();
        }
        #endregion

        #region   商家下载页4
        public ActionResult DownLoadPage4()
        {
            string sdate = (string)Session["sDate4"];
            string edate = (string)Session["eDate4"];
            int dataCount = 0;
            int pageCount = 0;
            List<SjxlphInfo> infolist2 = new List<SjxlphInfo>();
            var reslist2 = Sjxlph.Do(999999, 1, sdate, edate, ref dataCount, ref pageCount);
            if (reslist2 != null && reslist2.Body != null && reslist2.Body.all_list != null)
                infolist2 = reslist2.Body.all_list;

            string _data = "商家名称,商品数,销售额\r\n";
            foreach (SjxlphInfo item in infolist2)
            {
                _data += item.shop_name + "," + item.product_num + "," + item.sale_amount + "\r\n";
            }


            string _name = sdate + "-" + edate + "商家销售统计表.csv";

            byte[] _byte = Encoding.GetEncoding("gb2312").GetBytes(_data);

            Response.ClearHeaders();
            Response.Clear();
            Response.Expires = 0;
            Response.Buffer = true;
            Response.AddHeader("Accept-Language", "zh-cn");

            Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(_name, System.Text.Encoding.GetEncoding("utf-8")));
            Response.ContentType = "application/octet-stream;charset=gb2312";
            Response.BinaryWrite(_byte);
            Response.End();

            return View();
        }
        #endregion

        #region   单品下载页5
        public ActionResult DownLoadPage5()
        {
            string sdate = (string)Session["sDate5"];
            string edate = (string)Session["eDate5"];
            string ocol = (string)Session["ocol"];
            string otype = (string)Session["otype"];
            int typeid = (int)Session["typeid"];
            int dataCount = 0;
            int pageCount = 0;

            List<DpphInfo> infolist2 = new List<DpphInfo>();
            var res2 = Dpph.Do(999999, 1, sdate, edate, ocol, otype, typeid, ref dataCount, ref pageCount);
            if (res2 != null && res2.Body != null && res2.Body.list != null)
                infolist2 = res2.Body.list;
           
            string _data = "商品编码,商品名称,厂商,类目名,PV,UV,转化率,售价,销售数量,总金额,库存\r\n";
            foreach (DpphInfo item in infolist2)
            {
                _data = _data + item.product_code + "," + item.product_name.Replace(",", "，") + "," + item.manu_facturer.Replace(",", "，") + "," + item.type_name + "," + item.page_view + "," + item.user_view + "," + item.transform_rate + "," + item.sale_price + "," + item.sale_num + "," + item.sale_money + "," + item.stock_num + "\r\n";
            }

            string _name = sdate + "-" + edate + "单品销售统计表.csv";

            byte[] _byte = Encoding.GetEncoding("gb2312").GetBytes(_data);

            Response.ClearHeaders();
            Response.Clear();
            Response.Expires = 0;
            Response.Buffer = true;
            Response.AddHeader("Accept-Language", "zh-cn");

            Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(_name, System.Text.Encoding.GetEncoding("utf-8")));
            Response.ContentType = "application/octet-stream;charset=gb2312";
            Response.BinaryWrite(_byte);
            Response.End();

            return View();
        }
        #endregion

        #region   新品下载页6
        public ActionResult DownLoadPage6()
        {
            string sdate = (string)Session["sDate6"];
            string edate = (string)Session["eDate6"];

            List<NewProductInCategoryInfo> infolist = new List<NewProductInCategoryInfo>();
            DoCache cache = new DoCache();
            string cachekey = "Xptj-sdate=" + sdate + "edate=" + edate;
            if (cache.GetCache(cachekey) == null)
            {
                var reslist = NewProductInCategory.Do(sdate, edate);
                if (reslist != null && reslist.Body != null && reslist.Body.list != null)
                {
                    infolist = reslist.Body.list;
                    cache.SetCache(cachekey, infolist, 600);
                    if (infolist.Count == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else
            {
                infolist = (List<NewProductInCategoryInfo>)cache.GetCache(cachekey);
            }
            string _data = "类目名称,新品sku,类目总sku,销售额,类目总销售额,销售额占比\r\n";
            int totalskunum = 0;
            int totalallsku = 0;
            decimal totalamount = 0;
            decimal totalallamount = 0;
            foreach (NewProductInCategoryInfo item in infolist)
            {
                _data = _data + item.type_name + "," + item.sku_num + "," + item.all_sku_num + "," + item.amount + "," + item.all_amount + "," + item.rate + "\r\n";
                totalskunum += Utils.IsNumber(item.sku_num) ? int.Parse(item.sku_num) : 0;
                totalallsku += Utils.IsNumber(item.all_sku_num) ? int.Parse(item.all_sku_num) : 0;
                totalamount += Utils.IsNumber(item.amount) ? decimal.Parse(item.amount) : 0;
                totalallamount += Utils.IsNumber(item.all_amount) ? decimal.Parse(item.all_amount) : 0;
            }
            _data += "总计," + totalskunum + "," + totalallsku + "," + totalamount + "," + totalallamount + "," + (totalamount/totalallamount*100).ToString("#0.00") + "\r\n";
            string _name = sdate + "-" + edate + "新品销售统计表.csv";

            byte[] _byte = Encoding.GetEncoding("gb2312").GetBytes(_data);

            Response.ClearHeaders();
            Response.Clear();
            Response.Expires = 0;
            Response.Buffer = true;
            Response.AddHeader("Accept-Language", "zh-cn");

            Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(_name, System.Text.Encoding.GetEncoding("utf-8")));
            Response.ContentType = "application/octet-stream;charset=gb2312";
            Response.BinaryWrite(_byte);
            Response.End();

            return View();
        }
        #endregion

        #region   新用户下载页7
        public ActionResult DownLoadPage7()
        {
            string sdate = (string)Session["sDate7"];
            string edate = (string)Session["eDate7"];

            List<XyhtjInfo> infolist = new List<XyhtjInfo>();
            DoCache cache = new DoCache();
            string cachekey = "Xyhtj-sdate=" + sdate + "edate=" + edate;
            if (cache.GetCache(cachekey) == null)
            {
                var reslist = Xyhtj.Do(31, 1, sdate, edate);
                if (reslist != null && reslist.Body != null && reslist.Body.list != null)
                {
                    infolist = reslist.Body.list;
                    cache.SetCache(cachekey, infolist, 600);
                    if (infolist.Count == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else
            {
                infolist = (List<XyhtjInfo>)cache.GetCache(cachekey);
            }
            string _data = "日期,新注册数,支付数,订单数\r\n";
            int totalregister = 0;
            int totalpaymentcount = 0;
            int totalordercount = 0;
            foreach (XyhtjInfo item in infolist)
            {
                _data = _data + item.query_date + "," + item.register_count + "," + item.payment_count + "," + item.order_count + "\r\n";
                totalregister += Utils.IsNumber(item.register_count) ? Utils.StrToInt(item.register_count) : 0;
                totalpaymentcount += Utils.IsNumber(item.payment_count) ? Utils.StrToInt(item.payment_count) : 0;
                totalordercount += Utils.IsNumber(item.order_count) ? Utils.StrToInt(item.order_count) : 0;
            }
            _data += "总计," + totalregister + "," + totalpaymentcount + "," + totalordercount + "\r\n";
            string _name = sdate + "-" + edate + "新用户销售统计表.csv";

            byte[] _byte = Encoding.GetEncoding("gb2312").GetBytes(_data);

            Response.ClearHeaders();
            Response.Clear();
            Response.Expires = 0;
            Response.Buffer = true;
            Response.AddHeader("Accept-Language", "zh-cn");

            Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(_name, System.Text.Encoding.GetEncoding("utf-8")));
            Response.ContentType = "application/octet-stream;charset=gb2312";
            Response.BinaryWrite(_byte);
            Response.End();

            return View();
        }
        #endregion

        #region   老用户下载页8
        public ActionResult DownLoadPage8()
        {
            string sdate = (string)Session["sDate8"];
            string edate = (string)Session["eDate8"];

            List<LyhtjInfo> infolist = new List<LyhtjInfo>();
            DoCache cache = new DoCache();
            string cachekey = "Lyhtj-sdate=" + sdate + "edate=" + edate;
            if (cache.GetCache(cachekey) == null)
            {
                var reslist = Lyhtj.Do(31, 1, sdate, edate);
                if (reslist != null && reslist.Body != null && reslist.Body.list != null)
                {
                    infolist = reslist.Body.list;
                    cache.SetCache(cachekey, infolist, 600);
                    if (infolist.Count == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else
            {
                infolist = (List<LyhtjInfo>)cache.GetCache(cachekey);
            }
            string _data = "日期,销售额,销售额比,支付数,支付比率,订单数\r\n";
            decimal totalsaleamount = 0;
            decimal totalamountper = 0;
            int totalpaymentcount = 0;
            decimal totalpaymenper = 0;
            int totalordercount = 0;
            foreach (LyhtjInfo item in infolist)
            {
                _data = _data + item.query_date + "," + item.sale_amount + "," + item.amount_percet + "%," + item.payment_count + "," + item.payment_percent + "%," + item.order_count + "\r\n";
                totalsaleamount += Utils.IsNumber(item.sale_amount) ? decimal.Parse(item.sale_amount) : 0;
                totalamountper += Utils.IsNumber(item.amount_percet) ? decimal.Parse(item.amount_percet) : 0;
                totalpaymentcount += Utils.IsNumber(item.payment_count) ? Utils.StrToInt(item.payment_count) : 0;
                totalpaymenper += Utils.IsNumber(item.payment_percent) ? decimal.Parse(item.payment_percent) : 0;
                totalordercount += Utils.IsNumber(item.order_count) ? Utils.StrToInt(item.order_count) : 0;
            }
            _data += "总计," + totalsaleamount + "元," + totalamountper/infolist.Count + "%," + totalpaymentcount + "," + totalpaymenper/infolist.Count + "%," + totalordercount + "\r\n";
            string _name = sdate + "-" + edate + "老用户销售统计表.csv";

            byte[] _byte = Encoding.GetEncoding("gb2312").GetBytes(_data);

            Response.ClearHeaders();
            Response.Clear();
            Response.Expires = 0;
            Response.Buffer = true;
            Response.AddHeader("Accept-Language", "zh-cn");

            Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(_name, System.Text.Encoding.GetEncoding("utf-8")));
            Response.ContentType = "application/octet-stream;charset=gb2312";
            Response.BinaryWrite(_byte);
            Response.End();

            return View();
        }
        #endregion
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using JiuZhou.ControllerBase;
using JiuZhou.MySql;
using JiuZhou.HttpTools;
using JiuZhou.Common;
using System.Xml;
using JiuZhou.Cache;
using System.Text;
using System.IO;

namespace JiuZhou.Shop.WebManager.Controllers
{
    [HandleError]
    public class MPromotionsController : ForeSysBaseController
    {
        #region Index
        public ActionResult Index()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,103,206,207,"))
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

            int pagesize = 30;
            int pageindex = DoRequest.GetQueryInt("page", 1);
            string q = DoRequest.GetQueryString("q");

            int dataCount = 0;
            int pageCount = 0;

            List<TopicInfo> infoList = new List<TopicInfo>();
            DoCache cache = new DoCache();

            var resp = QueryTopicList.Do(pagesize, pageindex
                , q
                , ref dataCount, ref pageCount);
            if (resp != null && resp.Body != null && resp.Body.topic_list != null)
            {
                infoList = resp.Body.topic_list;
            }
            ViewData["infoList"] = infoList;

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/mpromotions?");
            currPageUrl.Append("&q=" + q);
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

        #region Editor
        public ActionResult Editor()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,103,206,208,"))
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
        }//
        #endregion

        #region Decoration 专题页装修
        public ActionResult Decoration()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,103,206,207,"))
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
            ViewData["typeAll"] = tList;
            return View();
        }//
        #endregion

        #region FullOff
        public ActionResult FullOff()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,103,211,212,"))
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

            int pagesize = 30;
            int pageindex = DoRequest.GetQueryInt("page", 1);
            string q = DoRequest.GetQueryString("q");

            int dataCount = 0;
            int pageCount = 0;

            List<FullOffInfo> infoList = null;
            var resp = QueryFullOff.Do(pagesize, pageindex
                , q
                , ref dataCount, ref pageCount);
            if (resp == null || resp.Body == null || resp.Body.fulloff_list == null)
            {
                infoList = new List<FullOffInfo>();
            }
            else
            {
                infoList = resp.Body.fulloff_list;
            }
            ViewData["infoList"] = infoList;

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/mpromotions/fulloff?");
            currPageUrl.Append("&q=" + q);
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

        #region FullOffEditor
        public ActionResult FullOffEditor()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,103,211,212,"))
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

            int fulloffid = DoRequest.GetQueryInt("fid");
            int pageindex = DoRequest.GetQueryInt("page", 1);

            FullOffDetail fulloffInfo = new FullOffDetail();
            var resp = QueryFullOffItem.Do(fulloffid);
            if (resp != null && resp.Body != null)
            {
                fulloffInfo = resp.Body;
            }
            ViewData["fulloffInfo"] = fulloffInfo;

            List<FullOffItems> Infolist = new List<FullOffItems>();
            if (resp.Body.fulloff_item_list != null)
                Infolist = resp.Body.fulloff_item_list;
            ViewData["infoList"] = Infolist;
    
            return View();
        }
        #endregion

        #region ConvertIntergralRule
        public ActionResult ConvertIntergralRule()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,103,221,222,"))
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

        #region ConvertIntergralRuleEditor
        public ActionResult ConvertIntergralRuleEditor()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,103,221,222,"))
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

        #region UseCouponRule
        public ActionResult UseCouponRule()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,103,221,223,"))
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

        #region CouponGetRule
        public ActionResult CouponGetRule()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,103,221,252,"))
                {
                    currResBody = item;
                    break;
                }
            }

            HasPermission(currResBody.res_id);

            int pagesize = 30;
            int pageindex = DoRequest.GetQueryInt("page", 1);
            string q = DoRequest.GetQueryString("q");

            int dataCount = 0;
            int pageCount = 0;

            List<CouponGetRuleInfo> list = new List<CouponGetRuleInfo>();
            var res = QueryCouponGetRule.Do(pagesize, pageindex, q, ref dataCount, ref pageCount);
            if (res != null && res.Body != null && res.Body.rule_list != null)
                list = res.Body.rule_list;
            ViewData["infolist"] = list;

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/mpromotions/CouponGetRule?");
            currPageUrl.Append("&q=" + q);
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

        #region CouponGetRuleEditor
        public ActionResult CouponGetRuleEditor()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,103,221,252,"))
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

        #region Discount
        public ActionResult Discount()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,103,249,250,"))
                {
                    currResBody = item;
                    break;
                }
            }

            HasPermission(currResBody.res_id);

            int pagesize = 30;
            int pageindex = DoRequest.GetQueryInt("page", 1);
            string q = DoRequest.GetQueryString("q");


            int dataCount = 0;
            int pageCount = 0;

            List<DiscountInfo> infoList = new List<DiscountInfo>();
            var res = QueryLtimeDiscount.Do(pagesize, pageindex
                , q
                , ref dataCount, ref pageCount);
            if (res != null && res.Body != null && res.Body.discount_list != null)
                infoList = res.Body.discount_list;

            ViewData["infoList"] = infoList;

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/mpromotions/Discount?");
            currPageUrl.Append("&q=" + q);
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

        #region DiscountEditor
        public ActionResult DiscountEditor()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,103,249,250,"))
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

        #region RaffleList
        public ActionResult RaffleList()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,103,595,596,"))
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

            int pagesize = 30;
            int pageindex = DoRequest.GetQueryInt("page", 1);
            string q = DoRequest.GetQueryString("q");

            int dataCount = 0;
            int pageCount = 0;

            List<AwardActivityInfo> infoList = null;
            var resp = QueryAwardActivityList.Do(pagesize, pageindex
                , q
                , ref dataCount, ref pageCount);
            if (resp == null || resp.Body == null || resp.Body.activity_list == null)
            {
                infoList = new List<AwardActivityInfo>();
            }
            else
            {
                infoList = resp.Body.activity_list;
            }
            ViewData["infoList"] = infoList;

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/mpromotions/rafflelist?");
            currPageUrl.Append("&q=" + q);
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

        #region RaffleEditor
        public ActionResult RaffleEditor()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,103,595,596,"))
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

        #region GetFullOffItem
        public ActionResult GetFullOffItem()
        {
            int fulloffid = DoRequest.GetFormInt("fid");

            List<FullOffItems> Infolist = new List<FullOffItems>();
            var resp = QueryFullOffItem.Do(fulloffid);
            if (resp != null && resp.Body != null && resp.Body.fulloff_item_list != null)
            {
                Infolist = resp.Body.fulloff_item_list;
            }
            return Json(new { error = false, data = Infolist }, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region PostTopic
        [HttpPost]
        public ActionResult PostTopic()
        {
            int stid = DoRequest.GetFormInt("TID");

            string subject = DoRequest.GetFormString("subject").Trim();
            string stdir = DoRequest.GetFormString("seoCode").Trim();
            string picsrc = DoRequest.GetFormString("image").Trim();

            string sdate = DoRequest.GetFormString("sdate").Trim();
            int shours = DoRequest.GetFormInt("shours");
            int sminutes = DoRequest.GetFormInt("sminutes");
            DateTime startDate = Utils.IsDateString(sdate) ? DateTime.Parse(sdate + " " + shours + ":" + sminutes + ":00") : DateTime.Now;

            string edate = DoRequest.GetFormString("edate").Trim();
            int ehours = DoRequest.GetFormInt("ehours");
            int eminutes = DoRequest.GetFormInt("eminutes");
            DateTime endDate = Utils.IsDateString(edate) ? DateTime.Parse(edate + " " + ehours + ":" + eminutes + ":59") : DateTime.Now.AddDays(7);

            string seotitle = DoRequest.GetFormString("seoName").Trim();
            string seokey = DoRequest.GetFormString("seoKeywords").Trim();
            string seosubject = DoRequest.GetFormString("seoSummary").Trim();
            string style = DoRequest.GetFormString("styleText").Trim();

            string summary = DoRequest.GetFormString("summary").Trim();
            int type = 0;
            if (stid == 0)
            {
                type = DoRequest.GetFormInt("type");
            }
            if (subject.Length < 1)
            {
                return Json(new { error = true, message = "请填写专题名称..." });
            }
            if (subject.Length > 50)
            {
                return Json(new { error = true, message = "主题不能超过50个字符..." });
            }
            if (stdir.Length < 1) {
                return Json(new { error = true, message = "请填写专题目录..." });
            }
            if (stdir.Length > 0 && stdir.Length < 3)
            {
                return Json(new { error = true, message = "目录最少2个字符..." });
            }
            if (stdir.Length >30)
            {
                return Json(new { error = true, message = "目录最多30个字符..." });
            }
            if (picsrc.Length < 1)
            {
                return Json(new { error = true, message = "请选择专题图标..." });
            }
            if (summary.Length < 1)
            {
                return Json(new { error = true, message = "专题介绍不能为空..." });
            }

            STopicInfo topicinfo = new STopicInfo();
            var ress = GetTopicInfoById.Do(stid);
            if (ress != null && ress.Body != null)
                topicinfo = ress.Body;

            topicinfo.st_id = stid;
            topicinfo.st_subject = subject;
            topicinfo.st_dir = stdir;
            topicinfo.pic_src = picsrc;
            topicinfo.seo_title = seotitle;
            topicinfo.seo_key = seokey;
            topicinfo.seo_text = seosubject;
            topicinfo.start_time = startDate.ToString("yyyy-MM-dd HH:mm:ss");
            topicinfo.end_time = endDate.ToString("yyyy-MM-dd HH:mm:ss");
            topicinfo.style_text = style;
            topicinfo.st_summary = summary;
            if (stid == 0) { topicinfo.type = type; }
            else {
                topicinfo.type = topicinfo.type;
            }
            int returnVal = -1;
            var res = OpTopicInfo.Do(topicinfo);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnVal = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnVal == 0) {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("stopic");
                return Json(new { error = false, message = "操作成功..." });
            }
            return Json(new { error = true, message = "操作失败..." });
           
        }
        #endregion

        #region RemoveSTopics
        [HttpPost]
        public ActionResult RemoveSTopics()
        {
            string idString = DoRequest.GetFormString("visitid").Trim();

            if (string.IsNullOrEmpty(idString))
            {
                return Json(new { error = true, message = "没有选择任何项" });
            }
            idString = idString + ",";
            int returnValue = -1;
            var res = DeleteTopicInfo.Do(idString);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("stopic");
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region RevocationTopic 取消发布
        [HttpPost]
        public ActionResult RevocationTopic()
        {
            int tid = DoRequest.GetFormInt("tid");
            int returnVal = -1;
            var res = ModifyTopicInfoState.Do(tid, 2);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnVal = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnVal == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("stopic");
                return Json(new { error = false, message = "操作成功!" });
            }
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region ReleaseTopic 发布专题
        [HttpPost]
        public ActionResult ReleaseTopic()
        {
            int tid = DoRequest.GetFormInt("tid");
            int returnVal = -1;
            var res = ModifyTopicInfoState.Do(tid, 0);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnVal = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnVal == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("stopic");
                return Json(new { error = false, message = "操作成功!" });
            }
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region CreateModule 创建模块
        [HttpPost]
        public ActionResult CreateModule()
        {
            int tid = DoRequest.GetFormInt("tid");
            int mode = DoRequest.GetFormInt("mode");
            STopicInfo sInfo = new STopicInfo();
            var ressinfo = GetTopicInfoById.Do(tid);
            if (ressinfo != null && ressinfo.Body != null)
                sInfo = ressinfo.Body;
            if (sInfo.st_id < 1)
            {
                return Json(new { error = true, message = "参数错误(专题不存在)" });
            }

            int returnValue = -1;
            var resp = AddSTopicModule.Do(tid, mode);
            int mid = 0;
            if (resp != null && resp.Body != null && resp.Header != null && resp.Header.Result != null && resp.Header.Result.Code != null)
            {
                mid = resp.Body.st_module_id;
                returnValue = Utils.StrToInt(resp.Header.Result.Code,-1);
            }
            if (returnValue == 0)
            {
                STModuleInfo module = new STModuleInfo();
                module.st_id = tid;
                module.st_module_id = mid;
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("stopic");
                return Json(new { error = false, message = "操作成功", data = module });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region RemoveModule 删除模块
        [HttpPost]
        public ActionResult RemoveModule()
        {
            int mid = DoRequest.GetFormInt("mid");
            int stid = DoRequest.GetFormInt("stid");

            int returnValue = -1;
            var res = DeleteTopicModule.Do(stid, mid);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);

            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("stopic");
                return Json(new { error = false, message = "操作成功" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region ResetSortNo 改变排序
        [HttpPost]
        public ActionResult ResetSortNo()
        {
            string ids = DoRequest.GetFormString("ids").Trim();
            if (ids.Equals(""))
                ids = "0";

            int returnValue = -1;
            var res = ModifyModuleSortNo.Do(ids);
            if(res != null && res.Header !=null && res.Header.Result != null && res.Header.Result.Code != null )
                returnValue = Utils.StrToInt(res.Header.Result.Code,-1);
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("stopic");
                return Json(new { error = false, message = "操作成功" });
            }
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region GetModuleInfo
        [HttpPost]
        public ActionResult GetModuleInfo()
        {
            int mid = DoRequest.GetFormInt("mid");

            STModuleInfo Info = new STModuleInfo();
            var res = GetSTopicModuleInfo.Do(mid);
            if (res != null && res.Body != null)
                Info = res.Body;
            return Json(Info);
        }
        #endregion

        #region GetModuleItems
        [HttpPost]
        public ActionResult GetModuleItems()
        {
            int mid = DoRequest.GetFormInt("mid");
            STModuleInfo Info = new STModuleInfo();
            var res1 = GetSTopicModuleInfo.Do(mid);
            if (res1 != null && res1.Body != null)
                Info = res1.Body;
            List<STItemInfo> list = new List<STItemInfo>();
            var res2 = GetTopicModuleItems.Do(mid);
            if (res2 != null && res2.Body != null && res2.Body.item_list != null)
                list = res2.Body.item_list;
            return Json(new { error = false, message = "操作成功", data = Info, items = list } );
            //return Json(Info);
        }
        #endregion

        #region PostModuleText 保存文本模板
        [HttpPost]
        [ValidateInput(false)]
        
        public ActionResult PostModuleText()
        {
            int mid = DoRequest.GetFormInt("mid");
            int stid = DoRequest.GetFormInt("stid");
            STModuleInfo Info = new STModuleInfo();
            var res = GetSTopicModuleInfo.Do(mid);
            if (res != null && res.Body != null)
                Info = res.Body;
            
            if (Info.st_module_id < 1)
            {
                return Json(new { error = true, message = "模块不存在或已被删除" });
            }
            Info.st_id = stid;
            Info.module_name = DoRequest.GetFormString("name");
            Info.allow_show_name = DoRequest.GetFormString("allowShowName");
            if (Info.allow_show_name.Equals(""))
                Info.allow_show_name = "0";
            Info.module_desc = DoRequest.GetFormString("name2");
            Info.module_content = DoRequest.GetFormString("contents",false);
            Info.is_full_screen = DoRequest.GetFormString("IsFullScreen");
            if (Info.is_full_screen.Equals(""))
                Info.is_full_screen = "0";
           
            int returnVal = -1;
            var res1 = OpTopicTextModule.Do(Info);
            if (res1 != null && res1.Header != null && res1.Header.Result != null && res1.Header.Result.Code != null)
            returnVal = Utils.StrToInt(res1.Header.Result.Code,-1);
            if (returnVal == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("stopic");
                return Json(new { error = false, message = "操作成功", data = Info });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostModuleItems 保存模块(商品列表)
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostModuleItems()
        {
            int mid = DoRequest.GetFormInt("mid");
            STModuleInfo Info = new STModuleInfo();
            var res = GetSTopicModuleInfo.Do(mid);
            if (res != null && res.Body != null)
                Info = res.Body;
            if (Info.st_module_id < 1)
            {
                return Json(new { error = true, message = "模块不存在或已被删除" });
            }
            Info.module_name = DoRequest.GetFormString("name");
            Info.allow_show_name = DoRequest.GetFormString("allowShowName");
            Info.module_desc = DoRequest.GetFormString("name2");
            Info.cell_count = DoRequest.GetFormString("columnCount");

            Info.is_full_screen = DoRequest.GetFormString("IsFullScreen");

            string proids = DoRequest.GetFormString("productIds");
            if (proids.Equals(""))
                proids = "0,";

            string itemids = DoRequest.GetFormString("itemids");
            if (itemids.Equals(""))
                itemids = "0,";

            string[] ids = itemids.Split(',');
            int[] itemidsi = new int[ids.Length]; 
            for(int i = 0;i < ids.Length;i++) {
                itemidsi[i] = Utils.StrToInt(ids[i], 0); 
            }

            List<STItemInfo> list = new List<STItemInfo>();
            #region 初始化商品列表
            List<ShortProductInfo> pList = new List<ShortProductInfo>();
            var res1 = GetShortProductsByProductIds.Do(proids);
            if(res1 != null && res1.Body != null && res1.Body.product_list != null)
                pList = res1.Body.product_list;
            int kk = 0;
            List<STItemInfo> stlist = new List<STItemInfo>();
            var resst = GetTopicModuleItems.Do(mid);
            if (resst != null && resst.Body != null && resst.Body.item_list != null)
                stlist = resst.Body.item_list;
            foreach (ShortProductInfo p in pList)
            {
                kk++;
                STItemInfo item = new STItemInfo();
                item.st_item_id = 0;
                foreach (STItemInfo em in stlist)
                {
                    if (em.product_id == p.product_id)
                    {
                        item.st_item_id = em.st_item_id;
                    }
                }
                item.product_id = p.product_id;
                item.product_code = p.product_code;
                item.product_name = p.product_name;
                item.product_brand = p.product_brand;
                item.img_src = p.img_src;
                item.sales_promotion = p.sales_promotion;
                item.sort_no = kk;
                item.market_price = p.market_price;
                item.start_time = DateTime.Now.ToString("yyyy-M-dd 00:00:00");
                item.end_time = "2050-01-01 00:00:00";

                if (DateTime.Parse(p.promotion_bdate) <= DateTime.Now && DateTime.Now <= DateTime.Parse(p.promotion_edate) && DateTime.Parse(p.promotion_bdate) != DateTime.Parse(p.promotion_edate))
                {
                    item.sale_price = p.promotion_price;
                }
                else
                {
                    item.sale_price = p.sale_price;
                }
                list.Add(item);
            }
            #endregion
            Info.topic_item_list = list;
            string delids = "";
            foreach (STItemInfo em in stlist) {
                if (!itemidsi.Contains(em.st_item_id)) {
                    delids = delids + em.st_item_id + ",";
                }
            }
            if (delids.Equals(""))
                delids = "0";
            int returnVal = -1;
            var res2 = OpTopicModuleItems.Do(Info,delids);
            if (res2 != null && res2.Header != null && res2.Header.Result != null && res2.Header.Result.Code != null)
                returnVal =Utils.StrToInt(res2.Header.Result.Code,-1);
            if (returnVal == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("stopic");
                //Info = STModuleDB.GetInfo(mid);
                return Json(new { error = false, message = "操作成功", data = Info, items = list });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostCarouselModuleItems 保存模块(轮播图)
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostCarouselModuleItems()
        {
            int mid = DoRequest.GetFormInt("mid");
            STModuleInfo Info = new STModuleInfo();
            var res = GetSTopicModuleInfo.Do(mid);
            if (res != null && res.Body != null)
                Info = res.Body;
            if (Info.st_module_id < 1)
            {
                return Json(new { error = true, message = "模块不存在或已被删除" });
            }
            Info.module_name = DoRequest.GetFormString("name");
            Info.allow_show_name = DoRequest.GetFormInt("allowShowName").ToString();
            Info.module_height = DoRequest.GetFormString("moduleheight");

            List<STItemInfo> stlist = new List<STItemInfo>();
            var resst = GetTopicModuleItems.Do(mid);
            if (resst != null && resst.Body != null && resst.Body.item_list != null)
                stlist = resst.Body.item_list;

            string xmlString = DoRequest.GetFormString("xml", false);
            List<STItemInfo> list = new List<STItemInfo>();
            List<int> newids = new List<int>();
            string delids = "";
            int kk = 0;
            #region 明细
            try
            {
                XmlDataDocument xmlDoc = new XmlDataDocument();
                xmlDoc.LoadXml(xmlString);
                XmlNodeList nodes = xmlDoc.SelectNodes("items/item");
                if (nodes != null)
                {
                    foreach (XmlNode item in nodes)
                    {
                        kk++;
                        STItemInfo citem = new STItemInfo();

                        citem.st_item_id = int.Parse(item.Attributes["itemid"].Value.Trim());

                        if (citem.st_item_id > 0)
                        {
                            newids.Add(citem.st_item_id);
                        }

                        citem.item_img_src = item.Attributes["imgsrc"].Value.Trim();
                        citem.item_img_src2 = FormatImagesUrl.GetProductImageUrl(citem.item_img_src, -1, -1);
                        citem.item_name = item.Attributes["itemname"].Value.Trim();
                        citem.page_src = item.Attributes["itemurl"].Value.Trim();
                        citem.sort_no = kk;
                        if (HasChinese(citem.page_src))
                        {
                            return Json(new { error = true, message = "URL不能含中文！" });
                        }
                        list.Add(citem);
                    }

                    int _count = 0;
                    foreach (STItemInfo em in stlist)
                    {
                        if (!newids.Contains(em.st_item_id))
                        {
                            if (_count == 0)
                            {
                                delids = em.st_item_id.ToString();
                            }
                            else
                            {
                                delids = delids + "," + em.st_item_id;
                            }
                            _count++;
                        }
                    }

                }
            }
            catch (Exception)
            {
                return Json(new { error = true, input = "message", message = "解析失败..." });
            }
            #endregion


            Info.topic_item_list = list;

           // if (delids.Equals(""))
            //    delids = "0";
            int returnVal = -1;
            var res2 = OpTopicCarouselModule.Do(Info, delids);
            if (res2 != null && res2.Header != null && res2.Header.Result != null && res2.Header.Result.Code != null)
                returnVal = Utils.StrToInt(res2.Header.Result.Code, -1);
            if (returnVal == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("stopic");
                //Info = STModuleDB.GetInfo(mid);
                return Json(new { error = false, message = "操作成功", data = Info, items = list });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostModulePaging 保存模块内容(分页模块)
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostModulePaging()
        {
            int mid = DoRequest.GetFormInt("mid");
            STModuleInfo Info = new STModuleInfo();
            var res = GetSTopicModuleInfo.Do(mid);
            if(res != null && res.Body != null)
                Info = res.Body;
            if (Info.st_module_id < 1)
            {
                return Json(new { error = true, message = "模块不存在或已被删除" });
            }
            Info.st_id = DoRequest.GetFormInt("tid");
            Info.module_name = DoRequest.GetFormString("name");
            Info.allow_show_name = DoRequest.GetFormString("allowShowName");
            Info.module_desc = DoRequest.GetFormString("name2");
            Info.cell_count = DoRequest.GetFormString("columnCount");
            Info.allow_paging = DoRequest.GetFormString("allowPaging");
            Info.product_type = DoRequest.GetFormString("classid");
            Info.module_content = DoRequest.GetFormString("classname", false);

            Info.page_size = DoRequest.GetFormString("size");
            Info.shop_id = DoRequest.GetFormString("shopid");
            Info.sort_column = DoRequest.GetFormString("column");
            Info.product_brand = DoRequest.GetFormString("brand");

            Info.is_full_screen = DoRequest.GetFormString("IsFullScreen");

            if (Info.sort_column.Equals(""))
                Info.sort_column = "DEFAULT";

            int returnVal = -1;
            var res1 = OpTopicModulePaging.Do(Info);
            if(res1 != null && res1.Header != null && res1.Header.Result != null && res1.Header.Result.Code != null)
                returnVal = Utils.StrToInt(res1.Header.Result.Code,-1);
            if (returnVal == 0)
            {
                int dataCount = 0;
                int pageCount = 0;
                List<ShortProductInfo> list = new List<ShortProductInfo>();
                var resspro = QueryProductInfoByShopId.Do(Info.page_size, 1
                    , Info.product_type
                    , 1
                    , 1
                    , Info.shop_id
                    , Info.product_brand
                    , Info.sort_column
                    , "DESC"
                    , ref dataCount
                    , ref pageCount);
                if (resspro != null && resspro.Body != null && resspro.Body.product_list != null)
                    list = resspro.Body.product_list;
                string pageText = this.FormatPageIndex(dataCount, Utils.StrToInt(Info.page_size,0), 1, "?page=1");
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("stopic");
                return Json(new { error = false, message = "操作成功", data = Info, items = list, pageLink = pageText });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion


        #region 手机装修
        #region PostPhoneModuleItems 保存手机模块(热区图)
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostPhoneModuleItems()
        {
            int mid = DoRequest.GetFormInt("mid");
            STModuleInfo Info = new STModuleInfo();
            var res = GetSTopicModuleInfo.Do(mid);
            if (res != null && res.Body != null)
                Info = res.Body;
            if (Info.st_module_id < 1)
            {
                return Json(new { error = true, message = "模块不存在或已被删除" });
            }
            Info.module_desc = DoRequest.GetFormString("src");
            string itemids = DoRequest.GetFormString("itemids");
            string url = DoRequest.GetFormString("url");
            string zuobian = DoRequest.GetFormString("zuobian");
            string[] ids = itemids.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            string[] urls = url.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            string[] zuobians = zuobian.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            string delids = "";
            List<STItemInfo> list = new List<STItemInfo>();
            if (ids.Length > 0 && urls.Length > 0 && zuobians.Length > 0)
            {               
                List<int> itemidsi = new List<int>();
                for (int i = 0; i < ids.Count(); i++)
                {
                    STItemInfo item = new STItemInfo();
                    item.item_name = zuobians[i];
                    item.item_img_src = urls[i];
                    item.st_item_id = Convert.ToInt32(ids[i]);
                    item.sort_no = i;
                    item.product_id = 0;
                    itemidsi.Add(Convert.ToInt32(ids[i]));
                    list.Add(item);
                }               
                List<STItemInfo> stlist = new List<STItemInfo>();
                var resst = GetTopicModuleItems.Do(mid);
                if (resst != null && resst.Body != null && resst.Body.item_list != null)
                    stlist = resst.Body.item_list;

                foreach (STItemInfo em in stlist)
                {
                    if (!itemidsi.Contains(em.st_item_id))
                    {
                        delids = delids + em.st_item_id + ",";
                    }
                }
                Info.topic_item_list = list;
                if (delids.Equals(""))
                    delids = "0";
            }
            else
            {
                List<STItemInfo> stlist = new List<STItemInfo>();
                var resst = GetTopicModuleItems.Do(mid);
                if (resst != null && resst.Body != null && resst.Body.item_list != null)
                    stlist = resst.Body.item_list;
                Info.topic_item_list = null;
                foreach (STItemInfo em in stlist)
                {
                    delids = delids + em.st_item_id + ",";
                }
            }
            int returnVal = -1;
            var res2 = OpTopicPhoneModuleItems.Do(Info, delids);
            if (res2 != null && res2.Header != null && res2.Header.Result != null && res2.Header.Result.Code != null)
                returnVal = Utils.StrToInt(res2.Header.Result.Code, -1);
            if (returnVal == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("stopic");
                return Json(new { error = false, message = "操作成功", data = Info, items = list });
            }
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion
        #region PostPhoneModuleItems2 保存手机模块(商品列表)
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostPhoneModuleItems2()
        {
            int mid = DoRequest.GetFormInt("mid");
            STModuleInfo Info = new STModuleInfo();
            var res = GetSTopicModuleInfo.Do(mid);
            if (res != null && res.Body != null)
                Info = res.Body;
            if (Info.st_module_id < 1)
            {
                return Json(new { error = true, message = "模块不存在或已被删除" });
            }
            Info.module_name = "";
            Info.allow_show_name = DoRequest.GetFormInt("allow_show_name").ToString();
            Info.module_desc = DoRequest.GetFormString("src");
            Info.cell_count = "0";
            Info.is_full_screen = "0";
            string proids = DoRequest.GetFormString("productIds");
            if (proids.Equals(""))
                proids = "0,";
            string itemids = DoRequest.GetFormString("itemids");
            if (itemids.Equals(""))
                itemids = "0,";
            string[] ids = itemids.Split(',');
            int[] itemidsi = new int[ids.Length];
            for (int i = 0; i < ids.Length; i++)
            {
                itemidsi[i] = Utils.StrToInt(ids[i], 0);
            }
            List<STItemInfo> list = new List<STItemInfo>();
            #region 初始化商品列表
            List<ShortProductInfo> pList = new List<ShortProductInfo>();
            var res1 = GetShortProductsByProductIds.Do(proids);
            if (res1 != null && res1.Body != null && res1.Body.product_list != null)
                pList = res1.Body.product_list;
            int kk = 0;
            List<STItemInfo> stlist = new List<STItemInfo>();
            var resst = GetTopicModuleItems.Do(mid);
            if (resst != null && resst.Body != null && resst.Body.item_list != null)
                stlist = resst.Body.item_list;
            foreach (ShortProductInfo p in pList)
            {
                kk++;
                STItemInfo item = new STItemInfo();
                item.st_item_id = 0;
                item.product_id = p.product_id;
                item.product_code = p.product_code;
                item.product_name = p.product_name;
                item.product_brand = p.product_brand;
                item.img_src = p.img_src;
                item.sales_promotion = p.sales_promotion;
                item.sort_no = kk;
                item.market_price = p.market_price;
                item.start_time = DateTime.Now.ToString("yyyy-M-dd 00:00:00");
                item.end_time = "2050-01-01 00:00:00";
                if (DateTime.Parse(p.promotion_bdate) <= DateTime.Now && DateTime.Now <= DateTime.Parse(p.promotion_edate) && DateTime.Parse(p.promotion_bdate) != DateTime.Parse(p.promotion_edate))
                {
                    item.sale_price = p.promotion_price;
                }
                else
                {
                    item.sale_price = p.sale_price;
                }
                list.Add(item);
            }
            #endregion
            Info.topic_item_list = list;
            string delids = "";
            foreach (STItemInfo em in stlist)
            {
                delids = delids + em.st_item_id + ",";
            }
            if (delids.Equals(""))
                delids = "0";
            int returnVal = -1;
            var res2 = OpTopicModuleItems.Do(Info, delids);
            if (res2 != null && res2.Header != null && res2.Header.Result != null && res2.Header.Result.Code != null)
                returnVal = Utils.StrToInt(res2.Header.Result.Code, -1);
            if (returnVal == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("stopic");
                //Info = STModuleDB.GetInfo(mid);
                return Json(new { error = false, message = "操作成功", data = Info, items = list });
            }
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #endregion


        #region RemoveFullOffs
        [HttpPost]
        public ActionResult RemoveFullOffs()
        {
            string idString = DoRequest.GetFormString("visitid").Trim();
            
            if (string.IsNullOrEmpty(idString))
            {
                return Json(new { error = true, message = "没有选择任何项" });
            }
            idString = idString + ",";
            int returnValue = -1;
            var res = DeleteFullOff.Do(idString);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostFullOffItems 保存满减
        [HttpPost]
        [ValidateInput(false)]

        public ActionResult PostFullOffItems()
        {
                string itemids = DoRequest.GetFormString("ids").Trim();
                int fid = DoRequest.GetFormInt("fid");
                string fname = DoRequest.GetFormString("fullname").Trim();
                string fdesc = DoRequest.GetFormString("fulldesc").Trim();
                decimal minprice = DoRequest.GetFormDecimal("minprice");
                decimal offprice = DoRequest.GetFormDecimal("offprice");

                string sdate = DoRequest.GetFormString("sdate").Trim();
                int shours = DoRequest.GetFormInt("shours");
                int sminutes = DoRequest.GetFormInt("sminutes");
                DateTime startDate = Utils.IsDateString(sdate) ? DateTime.Parse(sdate + " " + shours + ":" + sminutes + ":00") : DateTime.Now;

                string edate = DoRequest.GetFormString("edate").Trim();
                int ehours = DoRequest.GetFormInt("ehours");
                int eminutes = DoRequest.GetFormInt("eminutes");
                DateTime endDate = Utils.IsDateString(edate) ? DateTime.Parse(edate + " " + ehours + ":" + eminutes + ":59") : DateTime.Now.AddDays(7);

                string img = DoRequest.GetFormString("image");

                if (fname.Length <= 0)
                {
                    return Json(new { error = true, message = "标题不能为空！" });
                }

                if (fname.Length >= 50)
                {
                    return Json(new { error = true, message = "标题不能超过50个字段！" });
                }

                if (fdesc.Length <= 0)
                {
                    return Json(new { error = true, message = "描述不能为空！" });
                }

                if (fdesc.Length >= 50)
                {
                    return Json(new { error = true, message = "描述不能超过50个字段！" });
                }
                //if(minprice.)
                if (minprice <= 0)
                {
                    return Json(new { error = true, message = "最低金额不能少于0！" });
                }

                if (offprice <= 0)
                {
                    return Json(new { error = true, message = "满减金额不能少于0！" });
                }

                if (startDate > endDate)
                {
                    return Json(new { error = true, message = "开始时间大于结束日期！" });
                }

                FullOffDetail fulldetail = new FullOffDetail();
                List<FullOffItems> olditems = new List<FullOffItems>();
                var res = QueryFullOffItem.Do(fid);

                fulldetail.fulloff_id = fid;
                fulldetail.fulloff_name = fname;
                fulldetail.fulloff_desc = fdesc;
                fulldetail.min_price = minprice;
                fulldetail.off_price = offprice;
                fulldetail.begin_time = startDate.ToString("yyyy-MM-dd HH:mm:ss");
                fulldetail.end_time = endDate.ToString("yyyy-MM-dd HH:mm:ss");
                fulldetail.img_src = img;

                if (res != null && res.Body != null && res.Body.fulloff_item_list != null)
                    olditems = res.Body.fulloff_item_list;
                List<int> oldproids = new List<int>();

                string[] itemproids = itemids.Split(',');

                List<int> itemproids2 = new List<int>();

                string delids = "";
                string addids = "";
                foreach (FullOffItems item in olditems)
                {
                    oldproids.Add(item.product_id);
                }

                int _count = 0;

                if (!itemids.Equals(""))
                {
                    for (int i = 0; i < itemproids.Length; i++)
                    {

                        itemproids2.Add(Utils.StrToInt(itemproids[i], 0));
                        if (!oldproids.Contains(Utils.StrToInt(itemproids[i], 0)))
                        {
                            if (_count > 0) addids += ",";
                            addids += Utils.StrToInt(itemproids[i], 0);
                            _count++;
                        }
                    }
                }
                List<ShortFullOffItem> sitems = new List<ShortFullOffItem>();
                for (int i = 0; i < itemproids2.Count; i++)
                {
                    ShortFullOffItem sitem = new ShortFullOffItem();
                    sitem.fulloff_item_id = 0;
                    sitem.product_id = itemproids2[i];
                    if (oldproids.Contains(itemproids2[i]))
                    {
                        foreach (FullOffItems item in olditems)
                        {
                            if (item.product_id == itemproids2[i])
                                sitem.fulloff_item_id = item.fulloff_item_id;
                        }
                    }
                    sitems.Add(sitem);
                }
                _count = 0;
                foreach (FullOffItems item in olditems)
                {
                    if (!itemproids2.Contains(item.product_id))
                    {
                        if (_count == 0)
                        {
                            delids = item.product_id.ToString();
                        }
                        else
                        {
                            delids = delids + "," + item.product_id;
                        }
                        _count++;
                    }
                }
                // if (addids.Equals(""))
                //   addids = "0";
                // if (delids.Equals(""))
                //   delids = null;
                string[] addidss = addids.Split(',');
                List<int> addidint = new List<int>();
                for (int i = 0; i < addidss.Length; i++)
                {
                    addidint.Add(Utils.StrToInt(addidss[i], 0));
                }
                List<FullOffItemAll> listAll = new List<FullOffItemAll>();
                var resall = GetAllFullOffItem.Do();
                if (resall != null && resall.Body != null && resall.Body.item_list != null)
                    listAll = resall.Body.item_list;
                if (sitems.Count > 0)
                {
                    foreach (FullOffItemAll em in listAll)
                    {
                        foreach (ShortFullOffItem sem in sitems)
                        {
                            if (((sem.product_id == em.product_id && sem.fulloff_item_id != em.fulloff_item_id) || ((em.product_id == 0 && em.fulloff_item_id != sem.fulloff_item_id) || (sem.product_id == 0 && sem.fulloff_item_id != em.fulloff_item_id))) && ((startDate > DateTime.Parse(em.begin_time) && startDate < DateTime.Parse(em.end_time)) || (endDate > DateTime.Parse(em.begin_time) && endDate < DateTime.Parse(em.end_time)) || (startDate < DateTime.Parse(em.begin_time) && endDate > DateTime.Parse(em.end_time))))
                            {
                                ShortProductInfo product = new ShortProductInfo();
                                var respro = GetShortProductsByProductIds.Do(sem.product_id.ToString());
                                if (respro != null && respro.Body != null && respro.Body.product_list != null && respro.Body.product_list[0] != null)
                                    product = respro.Body.product_list[0];
                                return Json(new { error = true, message = "商品" + product.product_name + "在此时间段内已参加过满减活动！" });
                            }
                        }
                    }
                }

                int returnVal = -1;
                var res1 = OpFullOff.Do(fulldetail, addids, delids);
                if (res1 != null && res1.Header != null && res1.Header.Result != null && res1.Header.Result.Code != null)
                    returnVal = Utils.StrToInt(res1.Header.Result.Code, -1);

                if (returnVal == 0)
                {
                    DoCache cache = new DoCache();
                    cache.RemoveCacheStartsWith("product");
                    return Json(new { error = false, message = "操作成功" });
                }

                return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region RemoveConvertIntergralRules 删除积分兑换规则
        [HttpPost]
        public ActionResult RemoveConvertIntergralRules()
        {
            string idString = DoRequest.GetFormString("visitid").Trim();

            if (string.IsNullOrEmpty(idString))
            {
                return Json(new { error = true, message = "没有选择任何项" });
            }
            idString = idString + ",";
            int returnValue = -1;
            var res = DeleteConvertIntergralRule.Do(idString);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region ResetIntergralRuleStatus 修改积分兑换规则状态
        [HttpPost]
        public ActionResult ResetIntergralRuleStatus()
        {
            int ruleid = DoRequest.GetFormInt("ruleid");
            int state = DoRequest.GetFormInt("state");
            //idString = idString + ",";
            int returnValue = -1;
            var res = ModifyConvertIntergralRuleState.Do(ruleid, state);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region RemoveUseCouponRules 删除优惠券使用规则
        [HttpPost]
        public ActionResult RemoveUseCouponRules()
        {
            string idString = DoRequest.GetFormString("visitid").Trim();

            if (string.IsNullOrEmpty(idString))
            {
                return Json(new { error = true, message = "没有选择任何项" });
            }
            idString = idString + ",";
            int returnValue = -1;
            var res = DeleteUseCouponRule.Do(idString);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region ResetCouponRuleStatus 修改优惠券使用规则状态
        [HttpPost]
        public ActionResult ResetCouponRuleStatus()
        {
            int ruleid = DoRequest.GetFormInt("ruleid");
            int state = DoRequest.GetFormInt("state");
            //idString = idString + ",";
            int returnValue = -1;
            var res = ModifyUseCouponRuleState.Do(ruleid, state);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostConvertIntertralRuleData
        [HttpPost]
        public ActionResult PostConvertIntertralRuleData()
        {
            int ruleid = DoRequest.GetFormInt("ruleid");

            int type = DoRequest.GetFormInt("ctype");
            int intergral = DoRequest.GetFormInt("integral");
            decimal couponprice = DoRequest.GetFormDecimal("couponprice");
            int state = DoRequest.GetFormInt("ruleType");
            int validday = DoRequest.GetFormInt("validday");

            string sdate = DoRequest.GetFormString("sdate").Trim();
            int shours = DoRequest.GetFormInt("shours");
            int sminutes = DoRequest.GetFormInt("sminutes");
            DateTime startDate = Utils.IsDateString(sdate) ? DateTime.Parse(sdate + " " + shours + ":" + sminutes + ":00") : DateTime.Now;

            string edate = DoRequest.GetFormString("edate").Trim();
            int ehours = DoRequest.GetFormInt("ehours");
            int eminutes = DoRequest.GetFormInt("eminutes");
            DateTime endDate = Utils.IsDateString(edate) ? DateTime.Parse(edate + " " + ehours + ":" + eminutes + ":59") : DateTime.Now.AddDays(7);

            if (intergral <= 0)
            {
                return Json(new { error = true, message = "积分不能少于1，请填写积分" });
            }
            if (couponprice <= 0)
            {
                return Json(new { error = true, message = "优惠券金额不能少于1，请填写优惠券金额" });
            }

            ConvertIntergralRuleDetail rule = new ConvertIntergralRuleDetail();
            var resrule = QueryConvertIntergralRuleDetail.Do(ruleid);
            if (resrule != null && resrule.Body != null)
                rule = resrule.Body;
            rule.ci_rule_id = ruleid;
            rule.coupon_type = type;
            rule.integral_count = intergral;
            rule.coupon_price = couponprice;
            rule.rule_state = state;
            rule.valid_days = validday;
            rule.begin_time = startDate.ToString("yyyy-MM-dd HH:mm:ss");
            rule.end_time = endDate.ToString("yyyy-MM-dd HH:mm:ss");

            int returnVal = -1;
            var res = OpConvertIntergralRule.Do(rule);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnVal = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnVal == 0)
            {
                return Json(new { error = false, message = "操作成功..." });
            }
            return Json(new { error = true, message = "操作失败..." });

        }
        #endregion

        #region GetUseCouponRuleInfo
        [HttpPost]
        public ActionResult GetUseCouponRuleInfo()
        {
            int ruleid = DoRequest.GetFormInt("ruleid");
            UseCouponRuleDetail rule = new UseCouponRuleDetail();
            var res = GetUseCouponRuleDetail.Do(ruleid);
            if (res != null && res.Body != null)
                rule = res.Body;
            return Json(new { error = false, ruleinfo = rule });
        }
        #endregion

        #region PostUseCouponRule
        [HttpPost]
        public ActionResult PostUseCouponRule()
        {
            int ruleid = DoRequest.GetFormInt("ruleid");

            decimal minprice = DoRequest.GetFormDecimal("minprice");
            decimal couponprice = DoRequest.GetFormDecimal("couponprice");
            int state = DoRequest.GetFormInt("ruleType");

            if (minprice <= 0)
            {
                return Json(new { error = true, message = "最低销售额不能少于1，请填写" });
            }
            if (couponprice <= 0)
            {
                return Json(new { error = true, message = "优惠券金额不能少于1，请填写优惠券金额" });
            }

            UseCouponRuleDetail rule = new UseCouponRuleDetail();
            var resrule = GetUseCouponRuleDetail.Do(ruleid);
            if (resrule != null && resrule.Body != null)
                rule = resrule.Body;
            rule.uc_rule_id = ruleid;
            rule.coupon_price = couponprice;
            rule.min_price = minprice;
            rule.rule_state = state;

            int returnVal = -1;
            var res = OpUseCouponRule.Do(rule);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnVal = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnVal == 0)
            {
                return Json(new { error = false, message = "操作成功..." });
            }
            return Json(new { error = true, message = "操作失败..." });

        }
        #endregion

        #region PostCouponGetRule
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostCouponGetRule()
        {
            CouponGetRuleInfo info = new CouponGetRuleInfo();
            int ruleid = DoRequest.GetFormInt("ruleid");
            int type = DoRequest.GetFormInt("type");
            string name = DoRequest.GetFormString("name");
           // int validitydays = DoRequest.GetFormInt("validitydays");
            int maxgivenum = DoRequest.GetFormInt("maxgivenum");
           // int maxdaygivenum = DoRequest.GetFormInt("maxdaygivenum");
            int limitperusertotal = DoRequest.GetFormInt("limitperusertotal");
           // int limitperuserday = DoRequest.GetFormInt("limitperuserday");

            string sdate = DoRequest.GetFormString("sdate").Trim();
            int shours = DoRequest.GetFormInt("shours");
            int sminutes = DoRequest.GetFormInt("sminutes");
            DateTime startDate = Utils.IsDateString(sdate) ? DateTime.Parse(sdate + " " + shours + ":" + sminutes + ":00") : DateTime.Now;

            string edate = DoRequest.GetFormString("edate").Trim();
            int ehours = DoRequest.GetFormInt("ehours");
            int eminutes = DoRequest.GetFormInt("eminutes");
            DateTime endDate = Utils.IsDateString(edate) ? DateTime.Parse(edate + " " + ehours + ":" + eminutes + ":59") : DateTime.Now.AddDays(7);

            string lqsdate = DoRequest.GetFormString("lqsdate").Trim();
            int lqshours = DoRequest.GetFormInt("lqshours");
            int lqsminutes = DoRequest.GetFormInt("lqsminutes");
            string lqstartDate = Utils.IsDateString(lqsdate) ? DateTime.Parse(lqsdate + " " + lqshours + ":" + lqsminutes + ":59").ToString() : "";

            if (startDate > endDate) {
                return Json(new { error = true, input = "message", message = "总规则开始时间大于结束时间" });
            }

            string remarks = DoRequest.GetFormString("remarks");

            info.cget_rule_id = ruleid;
            info.cget_name = name;
            info.coupen_type = type;
            //info.validity_days = validitydays;
            info.max_give_num = maxgivenum;
            //info.max_day_give_num = maxdaygivenum;
            info.limit_per_user_total = limitperusertotal;
           // info.limit_per_user_day = limitperuserday;
            info.start_time = startDate.ToString("yyyy-MM-dd HH:mm:ss");
            info.end_time = endDate.ToString("yyyy-MM-dd HH:mm:ss");
            info.lqstart_time= lqstartDate;
            info.cget_remark = remarks;

            bool isError = false;
            string errorText = "";
            string xmlString = DoRequest.GetFormString("xml", false);

            List<CouponGetItem> items = new List<CouponGetItem>();

            #region 明细
            try
            {
                XmlDataDocument xmlDoc = new XmlDataDocument();
                xmlDoc.LoadXml(xmlString);
                XmlNodeList nodes = xmlDoc.SelectNodes("items/item");
                if (nodes != null)
                {
                    #region 规则
                    foreach (XmlNode item in nodes)
                    {
                        CouponGetItem citem = new CouponGetItem();
                        citem.start_time = startDate.ToString("yyyy-MM-dd HH:mm:ss");
                        citem.end_time = endDate.ToString("yyyy-MM-dd HH:mm:ss");
                        citem.cget_item_id = int.Parse(item.Attributes["itemid"].Value.Trim());
                        citem.coupon_price = decimal.Parse(item.Attributes["couponprice"].Value.Trim());
                        citem.coupon_cond = decimal.Parse(item.Attributes["couponcond"].Value.Trim());
                        citem.proids =item.Attributes["proids"].Value.Trim();
                        items.Add(citem);
                    }
                    #endregion
                }

            }
            catch (Exception e)
            {
                Logger.Error(e.ToString());
                return Json(new { error = true, input = "message", message = "解析 [明细] 失败..." });
            }
            if (isError)
            {
                return Json(new { error = true, input = "message", message = errorText });
            }
            #endregion

            info.item_list = items;

            //string delids = DoRequest.GetFormString("delids");

            int returnVal = -1;
            var res = OpCouponGetRule.Do(info,"0");
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnVal = Utils.StrToInt(res.Header.Result.Code, -1);

            if(returnVal == 0)
                return Json(new { error = false, message = "操作成功" });
            return Json(new { error = true, message = "操作失败..." });

        }
        #endregion

        #region RemoveCouponGetRules 删除优惠券领取规则
        [HttpPost]
        public ActionResult RemoveCouponGetRules()
        {
            string idString = DoRequest.GetFormString("visitid").Trim();

            if (string.IsNullOrEmpty(idString))
            {
                return Json(new { error = true, message = "没有选择任何项" });
            }
            //idString = idString + ",";
            int returnValue = -1;
            var res = DeleteCouponGetRule.Do(idString);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region RemoveDiscount 删除限时折扣
        [HttpPost]
        public ActionResult RemoveDiscount()
        {
            string idString = DoRequest.GetFormString("visitid").Trim();

            if (string.IsNullOrEmpty(idString))
            {
                return Json(new { error = true, message = "没有选择任何项" });
            }
            //idString = idString + ",";
            int returnValue = -1;
            var res = DeleteLtimeDiscount.Do(idString);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostDiscount 保存限时折扣
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostDiscount()
        {
            DiscountInfo info = new DiscountInfo();
            int ruleid = DoRequest.GetFormInt("ruleid",0);
            string subjectname = DoRequest.GetFormString("subjectname");
            string discountname = DoRequest.GetFormString("discountname");
            int discountmode = DoRequest.GetFormInt("discountmode", 0);
            string brandname = DoRequest.GetFormString("brandname");
            int classid = DoRequest.GetFormInt("ClassID", 0);
            string showClassPath = DoRequest.GetFormString("showClassPath");
            string shopname = DoRequest.GetFormString("shopname");
            int cuttype = DoRequest.GetFormInt("cuttype", 0);
            decimal cutrate = DoRequest.GetFormDecimal("cutrate", 0);
            decimal cutprice = DoRequest.GetFormDecimal("cutprice", 0);

            string sdate = DoRequest.GetFormString("sdate").Trim();
            int shours = DoRequest.GetFormInt("shours");
            int sminutes = DoRequest.GetFormInt("sminutes");
            DateTime startDate = DateTime.Parse(sdate + " " + shours + ":" + sminutes + ":00");

            string edate = DoRequest.GetFormString("edate").Trim();
            int ehours = DoRequest.GetFormInt("ehours");
            int eminutes = DoRequest.GetFormInt("eminutes");
            DateTime endDate = DateTime.Parse(edate + " " + ehours + ":" + eminutes + ":59");

            int iscover = DoRequest.GetFormInt("iscover",0);

            if (startDate > endDate)
            {
                return Json(new { error = true, input = "message", message = "总规则开始时间大于结束时间" });
            }

            info.lt_discount_id = ruleid;
            info.subject_name = subjectname;
            info.discount_name = discountname;
            info.discount_mode = discountmode;

            if (info.discount_mode == 1)
            {
                DoCache chche = new DoCache();
                List<BrandInfo> brandlist = new List<BrandInfo>();
                if (chche.GetCache("brandlist") == null)
                {
                    int datacount = 0;
                    int pagecount = 0;
                    var resbrand = QueryBrandList.Do(99999, 1, "", ref datacount, ref pagecount);
                    if (resbrand != null && resbrand.Body != null && resbrand.Body.brand_list != null)
                    {
                        brandlist = resbrand.Body.brand_list;
                        chche.SetCache("brandlist", brandlist);
                        if (brandlist.Count == 0)
                        {
                            chche.RemoveCache("brandlist");
                        }
                    }
                }
                else
                {
                    brandlist = (List<BrandInfo>)chche.GetCache("brandlist");
                }
                int log = 0;
                foreach (BrandInfo em in brandlist) {
                    if (em.brand_name.Equals(brandname) && em.brand_state == 0) {
                        info.brand_id = em.brand_id;
                        log = 1;
                    }
                }
                if (log == 0) {
                    return Json(new { error = true, input = "message", message = "填写的品牌不存在" });
                }
            }
            else {
                info.brand_id = 0;
            }

            if (info.discount_mode == 2)
            {
                info.product_type_id = classid;
                info.product_type_path = showClassPath;
            }
            else {
                info.product_type_id = 0;
                info.product_type_path = "";
            }

            if (info.discount_mode == 3)
            {
                DoCache chche = new DoCache();
                List<ShopList> shopList = new List<ShopList>();
                if (chche.GetCache("shoplist") == null)
                {
                    var resshop = GetShopInfo.Do(-1);
                    if (resshop != null && resshop.Body != null && resshop.Body.shop_list != null)
                    {
                        shopList = resshop.Body.shop_list;
                        chche.SetCache("shoplist", shopList);
                        if (shopList.Count == 0)
                        {
                            chche.RemoveCache("shoplist");
                        }
                    }
                }
                else
                {
                    shopList = (List<ShopList>)chche.GetCache("shoplist");
                }
                int log2 = 0;
                foreach (ShopList em in shopList) {
                    if (em.shop_name.Equals(shopname) && em.shop_state == 0) {
                        info.shop_id = em.shop_id;
                        log2 = 1;
                    }
                }
                if (log2 == 0)
                {
                    return Json(new { error = true, input = "message", message = "填写的商家不存在" });
                }
            }
            else {
                info.shop_id = 0;
            }

            info.cut_type = cuttype;

            if (info.cut_type == 0)
            {
                info.cut_rate = cutrate;
                info.cut_price = 0;
            }
            else {
                info.cut_rate = 0;
                info.cut_price = cutprice;
            }

            
            info.start_time = startDate.ToString("yyyy-MM-dd HH:mm:ss");
            info.end_time = endDate.ToString("yyyy-MM-dd HH:mm:ss");

            info.is_cover = iscover;

            List<DiscountItems> items = new List<DiscountItems>();
            List<int> newids = new List<int>();
            string delids = "";
            if (info.discount_mode == 0)
            {
                bool isError = false;
                string errorText = "";
                string xmlString = DoRequest.GetFormString("xml", false);

                #region 商品明细
                try
                {
                    XmlDataDocument xmlDoc = new XmlDataDocument();
                    xmlDoc.LoadXml(xmlString);
                    XmlNodeList nodes = xmlDoc.SelectNodes("items/item");
                    if (nodes != null)
                    {
                        #region
                        foreach (XmlNode item in nodes)
                        {
                            DiscountItems citem = new DiscountItems();

                            citem.lt_discount_item_id = int.Parse(item.Attributes["itemid"].Value.Trim());

                            if (citem.lt_discount_item_id > 0) {
                                newids.Add(citem.lt_discount_item_id);
                            }

                            citem.product_id = int.Parse(item.Attributes["productid"].Value.Trim());
                            citem.copy_by_main = int.Parse(item.Attributes["copybymain"].Value.Trim());

                            if (citem.copy_by_main == 0)
                            {
                                citem.cut_type = int.Parse(item.Attributes["itemcuttype"].Value.Trim());
                                citem.cut_rate = decimal.Parse(item.Attributes["itemcutrate"].Value.Trim());
                                citem.cut_price = decimal.Parse(item.Attributes["itemcutprice"].Value.Trim());

                                string itemsdate = item.Attributes["itemstime"].Value.Trim();
                                DateTime itemstartDate = DateTime.Parse(itemsdate);

                                if (itemstartDate < startDate)
                                {
                                    isError = true;
                                    errorText = "明细的开始时间不能早于总规则的开始时间";
                                }

                                citem.start_time = itemsdate;

                                string itemedate = item.Attributes["itemetime"].Value.Trim();
                                DateTime itemendDate = DateTime.Parse(itemedate);

                                if (itemendDate > endDate)
                                {
                                    isError = true;
                                    errorText = "明细的结束时间不能晚于总规则的结束时间";
                                }

                                if (itemstartDate > itemendDate)
                                {
                                    isError = true;
                                    errorText = "明细的开始时间大于结束时间";
                                }

                                citem.end_time = itemedate;
                            }
                            else
                            {
                                citem.cut_type = info.cut_type;
                                citem.cut_rate = info.cut_rate;
                                citem.cut_price = info.cut_price;
                                citem.start_time = info.start_time;
                                citem.end_time = info.end_time;
                            }
                            items.Add(citem);
                        }

                        List<DiscountItems> olditems = new List<DiscountItems>();
                        var resitem = GetLtimeDiscountDetail.Do(info.lt_discount_id);
                        if (resitem != null && resitem.Body != null && resitem.Body.item_list != null) {
                            olditems = resitem.Body.item_list;
                        }
                        int _count = 0;
                        foreach (DiscountItems em in olditems) {
                            if (!newids.Contains(em.lt_discount_item_id)) {
                                if (_count == 0)
                                {
                                    delids = em.lt_discount_item_id.ToString();
                                }
                                else {
                                    delids = delids + "," + em.lt_discount_item_id;
                                }
                                _count++;
                            }
                        }

                        #endregion
                    }

                }
                catch (Exception e)
                {
                    Logger.Error(e.ToString());
                    return Json(new { error = true, input = "message", message = "解析 [商品明细] 失败..." });
                }
                if (isError)
                {
                    return Json(new { error = true, input = "message", message = errorText });
                }
                #endregion
            }
            info.item_list = items;

            int returnVal = -1;
            var res = OpLtimeDiscount.Do(info, delids);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnVal = Utils.StrToInt(res.Header.Result.Code, -1);
            try
            {
                if (returnVal == 0)
                {
                    DoCache cache = new DoCache();
                    cache.RemoveCacheStartsWith("product");
                    return Json(new { error = false, message = res.Header.Result.Msg });
                }
                return Json(new { error = true, message = res.Header.Result.Msg });
            }
            catch (Exception e) {
                Logger.Error(e.ToString());
                return Json(new { error = true, message = "网络错误" });
            }

        }
        #endregion

        #region PostPicModuleItems 保存模块(图片列表)
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostPicModuleItems()
        {
            int mid = DoRequest.GetFormInt("mid");
            STModuleInfo Info = new STModuleInfo();
            var res = GetSTopicModuleInfo.Do(mid);
            if (res != null && res.Body != null)
                Info = res.Body;
            if (Info.st_module_id < 1)
            {
                return Json(new { error = true, message = "模块不存在或已被删除" });
            }
            Info.module_name = DoRequest.GetFormString("name");
            Info.allow_show_name = DoRequest.GetFormInt("allowShowName").ToString();
            Info.cell_count = DoRequest.GetFormString("columnCount");

            List<STItemInfo> stlist = new List<STItemInfo>();
            var resst = GetTopicModuleItems.Do(mid);
            if (resst != null && resst.Body != null && resst.Body.item_list != null)
                stlist = resst.Body.item_list;

            string xmlString = DoRequest.GetFormString("xml", false);
            List<STItemInfo> list = new List<STItemInfo>();
            List<int> newids = new List<int>();
            string delids = "";
            int kk = 0;
            #region 明细
            try
            {
                XmlDataDocument xmlDoc = new XmlDataDocument();
                xmlDoc.LoadXml(xmlString);
                XmlNodeList nodes = xmlDoc.SelectNodes("items/item");
                if (nodes != null)
                {
                    foreach (XmlNode item in nodes)
                    {
                        kk++;
                        STItemInfo citem = new STItemInfo();

                        citem.st_item_id = int.Parse(item.Attributes["itemid"].Value.Trim());

                        if (citem.st_item_id > 0)
                        {
                            newids.Add(citem.st_item_id);
                        }

                        citem.item_img_src = item.Attributes["imgsrc"].Value.Trim();
                        citem.item_img_src2 = FormatImagesUrl.GetProductImageUrl(citem.item_img_src, -1, -1);
                        citem.item_name = item.Attributes["itemname"].Value.Trim();
                        citem.page_src = item.Attributes["itemurl"].Value.Trim();
                        citem.sort_no = kk;
                        if (HasChinese(citem.page_src))
                        {
                            return Json(new { error = true, message = "URL不能含中文！" });
                        }
                        list.Add(citem);
                    }

                    int _count = 0;
                    foreach (STItemInfo em in stlist)
                    {
                        if (!newids.Contains(em.st_item_id))
                        {
                            if (_count == 0)
                            {
                                delids = em.st_item_id.ToString();
                            }
                            else
                            {
                                delids = delids + "," + em.st_item_id;
                            }
                            _count++;
                        }
                    }

                }
            }
            catch (Exception)
            {
                return Json(new { error = true, input = "message", message = "解析失败..." });
            }
            #endregion


            Info.topic_item_list = list;

            // if (delids.Equals(""))
            //    delids = "0";
            int returnVal = -1;
            var res2 = OpTopicPicModule.Do(Info, delids);
            if (res2 != null && res2.Header != null && res2.Header.Result != null && res2.Header.Result.Code != null)
                returnVal = Utils.StrToInt(res2.Header.Result.Code, -1);
            if (returnVal == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("stopic");
                //Info = STModuleDB.GetInfo(mid);
                return Json(new { error = false, message = "操作成功", data = Info, items = list });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostAwardActivity 保存抽奖活动
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostAwardActivity()
        {
            int activityid = DoRequest.GetFormInt("activityid");

            AwardActivityInfo Info = new AwardActivityInfo();
            if (activityid > 0)
            {
                var resp = GetAwardActivityInfo.Do(activityid);
                if (resp != null && resp.Body != null)
                {
                    Info = resp.Body;
                    Info.award_activity_id = activityid;
                }
            }
            
            Info.activity_name = DoRequest.GetFormString("name");
            Info.activity_desc = DoRequest.GetFormString("activitydesc", false).Trim();
            Info.phone_activity_desc = DoRequest.GetFormString("phoneactivitydesc", false).Trim();
            Info.award_desc = DoRequest.GetFormString("awarddesc", false).Trim();
            Info.phone_award_desc = DoRequest.GetFormString("phoneawarddesc", false).Trim();

            Info.activity_bg_img = DoRequest.GetFormString("activitybgimg");
            Info.phone_activity_bg_img = DoRequest.GetFormString("phoneactivitybgimg");
            Info.award_bg_img = DoRequest.GetFormString("awardbgimg");
            Info.phone_award_bg_img = DoRequest.GetFormString("phoneawardbgimg");
            Info.dial_bg_img = DoRequest.GetFormString("dialbgimg");
            Info.phone_dial_bg_img = DoRequest.GetFormString("phonedialbgimg");

            string sdate = DoRequest.GetFormString("sdate");
            int shour = DoRequest.GetFormInt("shours");
            int sminute = DoRequest.GetFormInt("sminutes");

            string edate = DoRequest.GetFormString("edate");
            int ehour = DoRequest.GetFormInt("ehours");
            int eminute = DoRequest.GetFormInt("eminutes");

            Info.begin_time = DateTime.Parse(sdate + " " + shour + ":" + sminute + ":00").ToString("yyyy-MM-dd HH:mm:ss");
            Info.end_time = DateTime.Parse(edate + " " + ehour + ":" + eminute + ":00").ToString("yyyy-MM-dd HH:mm:ss");

            #region Checking
            if (Info.activity_name.Length < 1)
            {
                return Json(new { error = true, message = "[名称] 不能为空" });
            }
            if (Info.activity_name.Length > 100)
            {
                return Json(new { error = true, message = "[名称] 不能大于200个字符" });
            }
            if (Info.activity_desc.Length < 0)
            {
                return Json(new { error = true, message = "[活动介绍] 不能为空" });
            }
            if (Info.award_desc.Length < 0)
            {
                return Json(new { error = true, message = "[奖品介绍] 不能为空" });
            }
            if(Info.award_bg_img == null || Info.award_bg_img.Length <1)
                return Json(new { error = true, message = "[奖品背景] 不能为空" });
            if (Info.dial_bg_img == null || Info.dial_bg_img.Length < 1)
                return Json(new { error = true, message = "[转盘背景] 不能为空" });
          
            #endregion

            List<AwardRuleInfo> oldrules = new List<AwardRuleInfo>();
            if (Info.rule_list != null)
            {
                oldrules = Info.rule_list;
            }
            List<int> oldids = new List<int>();
            StringBuilder delids = new StringBuilder();
            foreach (AwardRuleInfo item in oldrules)
            {
                oldids.Add(item.award_rule_id);
            }

            List<int> idlist = new List<int>();
            List<AwardRuleInfo> rules = new List<AwardRuleInfo>();
            bool isError = false;
            string errorText = "";
            string xmlString = DoRequest.GetFormString("xml1", false);
            #region 抽奖规则
            try
            {
                XmlDataDocument xmlDoc = new XmlDataDocument();
                xmlDoc.LoadXml(xmlString);
                XmlNodeList nodes = xmlDoc.SelectNodes("items/item");
                //XmlNodeList nodes = xmlDoc.SelectNodes("items/item[@Type='create']");
                if (nodes != null)
                {
                    #region 规则
                    foreach (XmlNode item in nodes)
                    {
                        AwardRuleInfo rule = new AwardRuleInfo();
                        int ruleId = int.Parse(item.Attributes["ruleid"].Value.Trim());
                        idlist.Add(ruleId);
                        rule.award_rule_id = ruleId;
                        rule.rule_type = int.Parse(item.Attributes["ruletype"].Value.Trim());
                        rule.corr_value = decimal.Parse(item.Attributes["corrvalue"].Value.Trim());
                        rule.lottery_num = int.Parse(item.Attributes["lotterynum"].Value.Trim());
                        rule.begin_time = item.Attributes["rulesdate"].Value.Trim();
                        rule.end_time = item.Attributes["ruleedate"].Value.Trim();

                        if (rule.corr_value <= 0) {
                            isError = true;
                            errorText = "规则 [相应值] 不能小于等于0";
                        }
                        if (rule.lottery_num <= 0) {
                            isError = true;
                            errorText = "规则 [抽奖次数] 不能小于等于0";
                        }

                        rules.Add(rule);
                    }
                    #endregion
                }

            }
            catch (Exception)
            {
                return Json(new { error = true, input = "message", message = "解析 [兑换规则] 失败..." });
            }
            if (isError)
            {
                return Json(new { error = true, input = "message", message = errorText });
            }
            #endregion

            foreach (int i in oldids)
            {
                if (!idlist.Contains(i))
                    delids.Append(i + ",");
            }

            if (delids.ToString().Equals(""))
            {
                delids.Append("0");
            } 

            Info.rule_list = rules;

            List<AwardInfo> awards = new List<AwardInfo>();
            string xmlString2 = DoRequest.GetFormString("xml2", false);
            #region 运费规则
            try
            {
                XmlDataDocument xmlDoc = new XmlDataDocument();
                xmlDoc.LoadXml(xmlString2);
                XmlNodeList nodes = xmlDoc.SelectNodes("items/item");
                //XmlNodeList nodes = xmlDoc.SelectNodes("items/item[@Type='create']");
                if (nodes != null)
                {
                    #region 规则
                    foreach (XmlNode item in nodes)
                    {
                        AwardInfo award = new AwardInfo();
                        award.award_id = int.Parse(item.Attributes["awardid"].Value.Trim());
                        award.award_name = item.Attributes["awardname"].Value.Trim();
                        award.award_type = int.Parse(item.Attributes["awardtype"].Value.Trim());
                        award.award_value = decimal.Parse(item.Attributes["awardvalue"].Value.Trim());
                        award.award_num = int.Parse(item.Attributes["awardnum"].Value.Trim());
                        award.award_percent = decimal.Parse(item.Attributes["awardpercent"].Value.Trim());
                        award.award_state = int.Parse(item.Attributes["awardstate"].Value.Trim());
                        award.sort_no = int.Parse(item.Attributes["sortno"].Value.Trim());
                      
                        if (award.award_name.Length <= 0)
                        {
                            isError = true;
                            errorText = "奖品 [名称] 不能为空";
                        }
                        if (award.award_value < 0)
                        {
                            isError = true;
                            errorText = "奖品 [奖值] 不能小于0";
                        }
                        if (award.award_percent < 0)
                        {
                            isError = true;
                            errorText = "奖品 [中奖率] 不能小于0";
                        }
                        if (award.award_num < 0)
                        {
                            isError = true;
                            errorText = "奖品 [奖品数] 不能小于0";
                        }

                        awards.Add(award);
                    }
                    #endregion
                }
            }
            catch (Exception e) {
                Logger.Error(e.ToString());
                return Json(new { error = true, input = "message", message = "解析 [奖品] 失败..." });
            }
            #endregion

            Info.award_list = awards;

            int returnValue = -1;
            var res = OpAwardActivityInfo.Do(Info, delids.ToString());
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功" });
            }
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PhoneDecoration 专题页装修
        public ActionResult PhoneDecoration()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,103,206,207,"))
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
            ViewData["typeAll"] = tList;
            return View();
        }//
        #endregion

        #region redpacklist红包规则列表
        public ActionResult RedPacklist()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,103,595,602,"))
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

            int pagesize = 30;
            int pageindex = DoRequest.GetQueryInt("page", 1);
            int dataCount = 0;
            int pageCount = 0;

            List<RedPackInfo> infoList = null;
            var resp = QueryRedPackList.Do(pagesize, pageindex
                , ref dataCount, ref pageCount);
            if (resp == null || resp.Body == null || resp.Body.rule_list == null)
            {
                infoList = new List<RedPackInfo>();
            }
            else
            {
                infoList = resp.Body.rule_list;
            }
            ViewData["infoList"] = infoList;

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/mpromotions/redpacklist?");
            currPageUrl.Append("page=" + pageindex);
            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL
            ViewData["pagesize"] = pagesize;
            ViewData["pageindex"] = pageindex;
            ViewData["dataCount"] = dataCount;
            ViewData["pageIndexLink"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            ViewData["pageIndexLink2"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());

            return View();
        }
        #endregion

        #region RedPackEditor
        public ActionResult RedPackEditor()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,103,595,602,"))
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

        #region PostRedPack 保存红包活动
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostRedPack()
        {
            int redpack_rule_id = DoRequest.GetFormInt("redpack_rule_id");
            RedPackInfo Info = new RedPackInfo();
            if (redpack_rule_id > 0)
            {
                var resp = GetRedPackInfo.Do(redpack_rule_id);
                if (resp != null && resp.Body != null)
                {
                    Info = resp.Body;
                    Info.redpack_rule_id = redpack_rule_id;
                }
            }
            Info.title = DoRequest.GetFormString("title");
            Info.sum_money = DoRequest.GetFormDecimal("sum_money");
            string sdate = DoRequest.GetFormString("sdate");
            int shour = DoRequest.GetFormInt("shours");
            int sminute = DoRequest.GetFormInt("sminutes");
            string edate = DoRequest.GetFormString("edate");
            int ehour = DoRequest.GetFormInt("ehours");
            int eminute = DoRequest.GetFormInt("eminutes");

            Info.start_time = DateTime.Parse(sdate + " " + shour + ":" + sminute + ":00").ToString("yyyy-MM-dd HH:mm:ss");
            Info.end_time = DateTime.Parse(edate + " " + ehour + ":" + eminute + ":00").ToString("yyyy-MM-dd HH:mm:ss");
            Info.pack_money_max = DoRequest.GetFormDecimal("pack_money_max");
            Info.pack_money_min = DoRequest.GetFormDecimal("pack_money_min");
            Info.pack_numsum = DoRequest.GetFormInt("pack_numsum");
            Info.Redpack_distribution_id = 1;
            Info.add_time = System.DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            string vdate = DoRequest.GetFormString("vdate");
            int vhour = DoRequest.GetFormInt("vhours");
            int vminute = DoRequest.GetFormInt("vminutes");
            Info.valid_time = DateTime.Parse(vdate + " " + vhour + ":" + vminute + ":00").ToString("yyyy-MM-dd HH:mm:ss");
            #region Checking
            if (Info.title.Length < 1)
            {
                return Json(new { error = true, message = "[名称] 不能为空" });
            }
            if (Info.title.Length > 100)
            {
                return Json(new { error = true, message = "[名称] 不能大于200个字符" });
            }
            #endregion
            int returnValue = -1;
            var res = OpRedPackInfo.Do(Info);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功" });
            }
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region 设为首页
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult SetHome()
        {
            int st_id = DoRequest.GetFormInt("st_id");
            int type = DoRequest.GetFormInt("type",-1);
            RequestSetHome Info = new RequestSetHome();
            //if (st_id <=0)
            //{
            //    return Json(new { error = true, message = "[st_id] 不能为空" });
            //}
            if (st_id ==-1)
            {
                return Json(new { error = true, message = "[type] 不能为空" });
            }
            Info.st_id = st_id.ToString();
            Info.type = type.ToString();           
            int returnValue = -1;
            var res = OpSetHome.Do(Info);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功" });
            }
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion
    }
}

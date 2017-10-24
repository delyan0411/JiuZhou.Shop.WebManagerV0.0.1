using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Xml;
using System.Xml.XPath;

using JiuZhou.ControllerBase;
using JiuZhou.MySql;
using JiuZhou.HttpTools;
using JiuZhou.Common.Tools;
using JiuZhou.Common;

namespace JiuZhou.Shop.WebManager.Controllers
{
    [HandleError]
    public class MPolymericController : ForeSysBaseController
    {
        #region
        public ActionResult Root()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,105,144,202,"))
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

        #region
        public ActionResult RootPhone()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,105,144,569,"))
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

        #region List
        public ActionResult List()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,105,144,202,"))
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
            int posId = DoRequest.GetQueryInt("posid",-1);
            int pageindex = DoRequest.GetQueryInt("page", 1);
            string q = DoRequest.GetQueryString("q");
            int useplat = DoRequest.GetQueryInt("useplat");

            int dataCount = 0;
            int pageCount = 0;
            List<RecommendPositionList> infoList = null;
            var resp = QueryRecommendPositionList.Do(pagesize, pageindex
                , posId, useplat
                , q
                , ref dataCount, ref pageCount);
            if (resp == null || resp.Body == null)
            {
                infoList = new List<RecommendPositionList>();
            }
            else
            {
                infoList = resp.Body.recommend_list;
            }
            ViewData["infoList"] = infoList;

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/mpolymeric/list?");
            currPageUrl.Append("&posid=" + posId);
            currPageUrl.Append("&q=" + q);
            currPageUrl.Append("&page=" + pageindex);
            currPageUrl.Append("&useplat=" + useplat);
            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL
            ViewData["pagesize"] = pagesize;
            ViewData["pageindex"] = pageindex;
            ViewData["dataCount"] = dataCount;
            ViewData["pageIndexLink"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            ViewData["pageIndexLink2"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());

            return View();
        }
        #endregion

        #region Index
        public ActionResult Index()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,105,144,202,"))
                {
                    currResBody = item;
                    break;
                }
            }

            HasPermission(574);

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            return View();
        }
        #endregion

        #region Add 添加推荐
        /*
        public ActionResult Add()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,101,192,"))
                {
                    currResBody = item;
                    break;
                }
            }

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            return View();
        }
          * */
        #endregion

        #region Items
        public ActionResult Items()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,105,144,202,"))
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

            int posId = DoRequest.GetQueryInt("posid");
            string q = DoRequest.GetQueryString("q");

            List<RecommendListInfo> infoList = null;
            var resp = GetRecommendItemByRpId.Do(posId);
            if (resp == null || resp.Body == null)
            {
                infoList = new List<RecommendListInfo>();
            }
            else {
                infoList = resp.Body.item_list;
            }

            ViewData["infoList"] = infoList;

            return View();
        }
        #endregion

        #region ItemsEditor
        public ActionResult ItemsEditor()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,105,144,202,"))
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

        #region CategSet分类菜单设置
        public ActionResult CategSet()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,105,236,237,"))
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

        #region CategSetDetail分类菜单设置详情
        public ActionResult CategSetDetail()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,105,236,237,"))
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

        #region RemoveList
        [HttpPost]
        public ActionResult RemoveList()
        {
            string idString = DoRequest.GetFormString("visitid").Trim();

            if (string.IsNullOrEmpty(idString))
            {
                return Json(new { error = true, message = "没有选择任何项" });
            }
            int returnValue = -1;
            var res = DeleteRecommendPosition.Do(idString);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostPolymericList
        [HttpPost]
        public ActionResult PostPolymericList()
        {
            string subject = DoRequest.GetFormString("subject").Trim();
            string excelPath = DoRequest.GetFormString("excel").Trim();

            string sdate = DoRequest.GetFormString("sdate").Trim();
            int shours = DoRequest.GetFormInt("shours");
            int sminutes = DoRequest.GetFormInt("sminutes");
            DateTime startDate = Utils.IsDateString(sdate) ? DateTime.Parse(sdate + " " + shours + ":" + sminutes + ":00") : DateTime.Now;

            string edate = DoRequest.GetFormString("edate").Trim();
            int ehours = DoRequest.GetFormInt("ehours");
            int eminutes = DoRequest.GetFormInt("eminutes");
            DateTime endDate = Utils.IsDateString(edate) ? DateTime.Parse(edate + " " + ehours + ":" + eminutes + ":59") : DateTime.Now.AddDays(7);

            string summary = DoRequest.GetFormString("summary").Trim();

            if (subject.Length < 1)
            {
                return Json(new { error = true, message = "请填写主题..." });
            }
            if (subject.Length > 50)
            {
                return Json(new { error = true, message = "主题不能超过50个字符..." });
            }
            if (summary.Length > 500)
            {
                return Json(new { error = true, message = "摘要不能超过500个字符..." });
            }

            Robots _rbt = new Robots();
            System.Text.StringBuilder url = new System.Text.StringBuilder();
            url.Append(base._config.UrlHome + "Tools/ImportFromExcel?");
            url.Append(Cookies.CreateVerifyString());

            System.Text.StringBuilder postData = new System.Text.StringBuilder();
            postData.Append("subject=" + DoRequest.UrlEncode(AES.Encode(subject)));
            postData.Append("&excel=" + DoRequest.UrlEncode(AES.Encode(excelPath)));
            postData.Append("&sdate=" + startDate.ToString("yyyy-MM-dd HH:mm:ss"));
            postData.Append("&edate=" + endDate.ToString("yyyy-MM-dd HH:mm:ss"));
            postData.Append("&summary=" + DoRequest.UrlEncode(AES.Encode(summary)));

            string html = _rbt.Post(url.ToString(), postData.ToString(), "utf-8");
            if (_rbt.IsError)
            {
                return Json(new { error = true, message = _rbt.ErrorMsg });
            }
            if (string.IsNullOrEmpty(html))
            {
                return Json(new { error = true, message = "远程页面无响应..." });
            }

            ParseJson pJson = new ParseJson();
            SortedDictionary<string, string> list = pJson.Parse(html);
            bool isError = false;
            if (pJson.GetJsonValue(list, "error") == "true")
            {
                isError = true;
            }
            return Json(new { error = isError, message = pJson.GetJsonValue(list, "message") });
        }
        #endregion

        #region 更改Items排序
        [HttpPost]
        [ValidateInput(false)]//允许html
        public ActionResult ResetItemSortNo()
        {
            string returnUrl = DoRequest.GetFormString("returnurl").Trim();
            string xmlString = DoRequest.GetFormString("xml", false).Replace("&lt;", "<").Replace("&gt;", ">");

            try
            {
                XmlDataDocument xmlDoc = new XmlDataDocument();
                xmlDoc.LoadXml(xmlString);
                List<ModifyRecommendList> items = new List<ModifyRecommendList>();

                XmlNodeList nodes = xmlDoc.SelectNodes("items/item");
                if (nodes != null)
                {
                    #region 新增分类
                    foreach (XmlNode item in nodes)
                    {
                        ModifyRecommendList iem = new ModifyRecommendList();
                        iem.ri_id = Utils.StrToInt(item.Attributes["ItemID"].Value).ToString();
                        iem.sort_no = (Utils.IsNumber(item.Attributes["SortNo"].Value) ? (int.Parse(item.Attributes["SortNo"].Value)) : 1000).ToString();
                        items.Add(iem);
                    }
                    #endregion
                }

                int returnValue = -1;
                var res = ModifyRecommendItemSortNo.Do(items);
                if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                    returnValue = Utils.StrToInt(res.Header.Result.Code,-1);

                if (returnValue == 0)
                {
                    return Json(new { error = false, message = "保存成功 ^_^" });
                }
            }
            catch (Exception)
            {
                return Json(new { error = true, message = "Xml解析失败..." });
            }

            return Json(new { error = true, message = "保存失败" });
        }
        #endregion

        #region RemoveItems
        [HttpPost]
        public ActionResult RemoveItems()
        {
            string idString = DoRequest.GetFormString("visitid").Trim();

            if (string.IsNullOrEmpty(idString))
            {
                return Json(new { error = true, message = "没有选择任何项" });
            }
            int returnValue = -1;
            var res = DeleteRecommendItem.Do(idString);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostItems 
        [HttpPost]
        public ActionResult PostItems()
        {
            int posId = DoRequest.GetFormInt("posID");
            int listId = DoRequest.GetFormInt("ListID");
             
            int ristyle = DoRequest.GetFormInt("stype");
            string rivalue = DoRequest.GetFormString("proid");
            string gtype = DoRequest.GetFormString("gtype");
            string protype = DoRequest.GetFormString("protype"); 
            string subject = DoRequest.GetFormString("subject");
            string brand = DoRequest.GetFormString("brand");
            string url = DoRequest.GetFormString("url").Trim();
            string iconname = DoRequest.GetFormString("iconname");
             
            string sdate = DoRequest.GetFormString("sdate").Trim();
            int shours = DoRequest.GetFormInt("shours");
            int sminutes = DoRequest.GetFormInt("sminutes");
            DateTime startDate = Utils.IsDateString(sdate) ? DateTime.Parse(sdate + " " + shours + ":" + sminutes + ":00") : DateTime.Now;

            string edate = DoRequest.GetFormString("edate").Trim();
            int ehours = DoRequest.GetFormInt("ehours");
            int eminutes = DoRequest.GetFormInt("eminutes");
            DateTime endDate = Utils.IsDateString(edate) ? DateTime.Parse(edate + " " + ehours + ":" + eminutes + ":59") : DateTime.Now.AddDays(7);
            
            string image = DoRequest.GetFormString("image");
            string summary = DoRequest.GetFormString("summary");

            int plat = DoRequest.GetFormInt("useplat");
            if (plat == 4)
                plat = 6;
            string imgsrc = "";
             
            if (ristyle == 1)
            {
                ProductInfo product = new ProductInfo();
                var respro = GetProductInfo.Do(Utils.StrToInt(rivalue, 0));
                if (respro != null && respro.Body != null)
                    product = respro.Body;
                imgsrc = product.img_src;
                
                if (product.product_id < 1)
                {
                    return Json(new { error = true, message = "商品不存在" });
                }
            }

            if ((ristyle == 4 || ristyle == 5) && HasChinese(rivalue))
            {
                return Json(new { error = true, message = "URL不能含中文！" });
            }

            if (HasChinese(url))
            {
                return Json(new { error = true, message = "URL不能含中文！" });
            }

            if (ristyle == 2) {
                rivalue = protype;
                if (rivalue.Equals("") || rivalue == null) {
                    return Json(new { error = true, message = "请选择分类！" });
                }
            }


            List<RecommendListInfo> items = new List<RecommendListInfo>();
            var resrel = GetRecommendItemByRpId.Do(posId);
            if (resrel != null && resrel.Body != null && resrel.Body.item_list != null)
                items = resrel.Body.item_list;
            List<int> liids = new List<int>();
            foreach(RecommendListInfo em in items){
                liids.Add(em.ri_id);
            }

            RecommendListInfo listInfo = items.Find(delegate(RecommendListInfo em)
            {
                return (em.ri_id == listId);
            });

            if (listInfo == null)
                listInfo = new RecommendListInfo();

            RecommendListInfo listInfo2 = items.Find(delegate(RecommendListInfo em)
            {
                return (em.ri_value.Equals(rivalue));
            });

            if (listInfo2 == null)
                listInfo2 = new RecommendListInfo();
       
            if (!liids.Contains(listId) && rivalue.Equals(listInfo2.ri_value) && (listInfo.ri_id > 0) && ((startDate >= DateTime.Parse(listInfo.start_time) && startDate <= DateTime.Parse(listInfo.end_time)) || (endDate >= DateTime.Parse(listInfo.start_time) && endDate <= DateTime.Parse(listInfo.end_time)) || (startDate <= DateTime.Parse(listInfo.start_time) && endDate >= DateTime.Parse(listInfo.end_time))))
                return Json(new { error = true, message = "该推荐项在同期同位置已被推荐" });

            #region Checking
            if (subject.Length <= 0)
                return Json(new { error = true, message = "推荐标题不能为空" });
         
            if (image.Length > 300)
            {
                return Json(new { error = true, message = "图标地址不能超过300个字符" });
            }
            if (summary.Length > 600)
            {
                return Json(new { error = true, message = "简介不能超过600个字符" });
            }
            #endregion

            listInfo.ri_id = listId;
            listInfo.rp_id = posId;
            listInfo.ri_type = ristyle;

            if (ristyle == 5 && plat < 4)
            {
                listInfo.ri_value = gtype;
                listInfo.page_src = rivalue;
            }
            else
            {
                listInfo.ri_value = rivalue;
                listInfo.page_src = url;
            }

            if (ristyle == 1)
            {
                listInfo.product_id = Utils.StrToInt(rivalue, 0);
            }
            else
            {
                listInfo.product_id = 0;
            }
           
            listInfo.ri_subject = subject;
            listInfo.product_brand = brand;
            listInfo.ri_summary = summary;
            listInfo.start_time = startDate.ToString("yyyy-MM-dd HH:mm:ss");
            listInfo.end_time = endDate.ToString("yyyy-MM-dd HH:mm:ss");

            if (plat < 0 || plat > 7)
            {
                return Json(new { error = true, message = "显示平台选择不规范" });
            }

            listInfo.use_plat = plat;

            if (!string.IsNullOrEmpty(image))
            {
                listInfo.img_src = image;
            }
            else
            {
                listInfo.img_src = imgsrc;
            }
            
            if (listInfo.product_brand == null)
                listInfo.product_brand = "";

            listInfo.icon_name = iconname;
             
            int returnValue = -1;
            var res = OpRecommendItems.Do(listInfo);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            #region 判断是否操作成功
            string msgText = "";
            switch (returnValue)
            {
                case 0:
                    msgText = "操作成功 ^_^";
                    break;
                case -1:
                    msgText = "操作失败" ;
                    break;
                default:
                    msgText = "操作失败";
                    break;
            }
            #endregion

            return Json(new { error = returnValue == 0 ? false : true, message = msgText});
        }
        #endregion

        #region RemoveRecommendPage 删除推荐页面(顶级推荐位)
        [HttpPost]
        public ActionResult RemoveRecommendPage()
        {
            int posId = DoRequest.GetFormInt("posid");

            int rVal = -1;
            var res = DeleteRecommendPosition.Do(posId.ToString());
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                rVal = Utils.StrToInt(res.Header.Result.Code, -1);
            if (rVal == 0)
            {
                return Json(new { error = false, message = "操作成功" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostRecommendPage 保存页面设置(顶级推荐位)
        [HttpPost]
        public ActionResult PostRecommendPage()
        {
            int posId = DoRequest.GetFormInt("posid2");
            int flag = DoRequest.GetFormInt("flag",0);
            int plat = DoRequest.GetFormInt("plat", 0);
            if (plat == 4)
                plat = 6;

            string posName = DoRequest.GetFormString("name");

            if (posName.Length < 1)
            {
                return Json(new { error = true, message = "页面名称不能为空" });
            }
            if (posName.Length > 50)
            {
                return Json(new { error = true, message = "页面名称不能超过50个字符" });
            }

            RecommendPositionInfo pos = new RecommendPositionInfo();
            var resrep = GetRecommendPositionInfo.Do(posId);
            if (resrep != null && resrep.Body != null) {
                pos = resrep.Body;
            }
            pos.rp_name = posName;
            if (flag == 0 && pos.rp_id > 0)
                return Json(new { error = true, message = "该位置ID已存在！" });
            if (pos.rp_id < 1)
            {
                pos.rp_id = posId;
                pos.rp_code = Guid.NewGuid().ToString().ToLower();
                pos.use_plat = plat;
            }
            pos.op_flag = flag;
            
            int rVal = -1;
            var res = OpTopRecommendPosition.Do(pos);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                rVal = Utils.StrToInt(res.Header.Result.Code, -1);
            if (rVal == 0)
            {
                return Json(new { error = false, message = "操作成功" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region 保存位置信息 
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostPosition()
        {
            int ptype = DoRequest.GetFormInt("ptype",7);

            string parent = DoRequest.GetFormString("parent");

            string xmlString = DoRequest.GetFormString("xml", false).Replace("&lt;", "<").Replace("&gt;", ">");

            try
            {
                XmlDataDocument xmlDoc = new XmlDataDocument();
                xmlDoc.LoadXml(xmlString);
                List<RecommendPositionInfo> posList = new List<RecommendPositionInfo>();
                List<string> codeList = new List<string>();//id
                codeList.Add(parent);

                XmlNodeList nodes = xmlDoc.SelectNodes("items/item");
                //XmlNodeList nodes = xmlDoc.SelectNodes("items/item[@Type='create']");
                if (nodes != null)
                {
                    #region 新增分类
                    foreach (XmlNode item in nodes)
                    {
                        RecommendPositionInfo pos = new RecommendPositionInfo();
                        string itemType = item.Attributes["Type"].Value.Trim();
                        string parentValue = item.Attributes["ParentID"].Value.Trim();
                        string posValue = item.Attributes["Code"].Value.Trim();
                        int posId = Utils.StrToInt(item.Attributes["PosID"].Value.Trim());
                        string sortValue = item.Attributes["SortNo"].Value.Trim();
                        int useplat = Utils.StrToInt(item.Attributes["UsePlat"].Value.Trim(),7);
                        if (useplat == 4)
                            useplat = 6;
                        string flag = item.Attributes["Flag"].Value.Trim();
                        //if (string.IsNullOrEmpty(parentValue))
                        //{
                        //    sortValue = "100" + sortValue;
                        //}
                        if (flag.Equals("true"))
                        {
                            pos.op_flag = 0;
                        }
                        else {
                            pos.op_flag = 1;
                        }
                        string nameValue = item.SelectSingleNode("name").InnerText.Trim();

                        if (string.IsNullOrEmpty(nameValue))
                        {
                            return Json(new { error = true, message = "请填写分类名称，或将未填写分类名的行删除..." });
                        }
                        if (nameValue.Length > 100)
                        {
                            return Json(new { error = true, message = "分类名不能大于100个字符..." });
                        }
                        pos.rp_id = posId;
                        pos.rp_name = nameValue;//分类名
                        pos.parent_rp_code = parentValue;//父类编码

                        pos.rp_code = posValue;//Utils.IsGuid(classValue) ? classValue : Guid.NewGuid().ToString().ToLower();//分类编码
                        pos.sort_no = Utils.IsNumber(sortValue) ? int.Parse(sortValue) : 10000;//排序
                        pos.use_plat = useplat;
                        posList.Add(pos);
                        codeList.Add(pos.rp_code);
                    }
                    #endregion
                }

                #region 删除分类
                List<ShortRecommendPosition> dbList = new List<ShortRecommendPosition>();
                var ressrel = GetRecommendPositionByCode.Do(parent, ptype);//非顶级分类
                if (ressrel != null && ressrel.Body != null && ressrel.Body.recommend_list != null)
                    dbList = ressrel.Body.recommend_list;
                
                //StringBuilder sb = new StringBuilder();
                //int _deleteCount = 0;
                System.Text.StringBuilder deletePathList = new System.Text.StringBuilder();
                foreach (ShortRecommendPosition item in dbList)
                {
                    if (!codeList.Contains(item.rp_code.ToLower().Trim()))
                    {
                        deletePathList.Append(item.rp_code.Trim() + ",");
                    }
                    List<ShortRecommendPosition> dbList2 = new List<ShortRecommendPosition>();
                    var ressrel2 = GetRecommendPositionByCode.Do(item.rp_code, ptype);//非顶级分类
                    if (ressrel2 != null && ressrel2.Body != null && ressrel2.Body.recommend_list != null)
                        dbList2 = ressrel2.Body.recommend_list;
                    foreach (ShortRecommendPosition em in dbList2) {
                        if (!codeList.Contains(em.rp_code.ToLower().Trim()))
                        {
                            deletePathList.Append(em.rp_code.Trim() + ",");
                        }
                    }
                }
                
                #endregion

                int returnVal = -1;
                var res = OpRecommendPosition.Do(posList, deletePathList.ToString());
                if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                    returnVal = Utils.StrToInt(res.Header.Result.Code, -1);
                if (returnVal == 6)
                    return Json(new { error = true, message = "该位置ID已存在" });
                if (returnVal == 0) {
                    return Json(new { error = false, message = "保存成功 ^_^" });
                }
            }
            catch (Exception)
            {
                return Json(new { error = true, message = "Xml解析失败..." });
            }

            return Json(new { error = true, message = "保存失败" });
        }
        #endregion

        #region 更改推荐页位置操作平台
        [HttpPost]
        [ValidateInput(false)]//允许html
        public ActionResult ModifyPositionUsePlat()
        {
            int pid = DoRequest.GetFormInt("posId");
            int plat = DoRequest.GetFormInt("plat");
            if (plat > 7 || plat < 0)
                return Json(new { error = true, message = "修改失败" });
            int returnVal = -1;
            var res = ModifyRecommentPositionUsePlat.Do(pid, plat);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnVal = Utils.StrToInt(res.Header.Result.Code, -1);
            if(returnVal==0)
                return Json(new { error = false, message = "修改成功" });
            return Json(new { error = true, message = "修改失败" });
        }
         #endregion

        #region 更改推荐页操作平台
        [HttpPost]
        [ValidateInput(false)]//允许html
        public ActionResult ModifyItemsUsePlat()
        {
            int riid = DoRequest.GetFormInt("riid");
            int plat = DoRequest.GetFormInt("plat");
            if (plat > 7 || plat < 0)
                return Json(new { error = true, message = "修改失败" });
            int returnVal = -1;
            var res = ModifyRecommentItemsUsePlat.Do(riid, plat);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                    returnVal = Utils.StrToInt(res.Header.Result.Code,-1);
            if (returnVal == 0)
                return Json(new { error = false, message = "修改成功" });
            return Json(new { error = true, message = "修改失败" });
        }
        #endregion


        #region GetCategSet 获取首页分类
        [HttpPost]
        public ActionResult GetCategSet()
        {
            int id = DoRequest.GetFormInt("ID");
           
            CategSetInfo info = new CategSetInfo();
            var res = GetHomeTypeById.Do(id);
            if (res != null && res.Body != null)
            {
                info = res.Body;
                return Json(new { error = false, categ = info, message = "操作成功!" });
            }
            return Json(new { error = true, message = "获取信息失败！" });
        }
        #endregion

        #region 删除首页分类
        [HttpPost]
        [ValidateInput(false)]//允许html
        public ActionResult DelCategSet()
        {
            int pid = DoRequest.GetFormInt("ID");
            int returnVal = -1;
            var res = DeleteHomeType.Do(pid);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnVal = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnVal == 0)
                return Json(new { error = false, message = "修改成功" });
            try
            {
                return Json(new { error = true, message = res.Header.Result.Msg });
            }
            catch (Exception) {
                return Json(new { error = true, message = "网络出错" });
            }
        }
        #endregion

        #region PostHomeType 保存首页分类
        [HttpPost]
        public ActionResult PostHomeType()
        {
            int posId = DoRequest.GetFormInt("posid");

            CategSetInfo categ = new CategSetInfo();
            var rescateg = GetHomeTypeById.Do(posId);
            if (rescateg != null && rescateg.Body != null)
                categ = rescateg.Body;
           
            if (categ == null)
            {
                categ.home_pt_id = 0;
            }
            else {
                categ.home_pt_id = posId;
            }
        
            categ.parent_id = DoRequest.GetFormInt("pid");
            categ.type_name = DoRequest.GetFormString("name");
            categ.type_url = DoRequest.GetFormString("url");
            categ.sort_no = DoRequest.GetFormInt("sort");
            categ.is_black = DoRequest.GetFormInt("Isb") > 0 ? 1 : 0;
            categ.is_color = DoRequest.GetFormInt("Iscolor") > 0 ? 1 : 0;
            categ.is_newline = DoRequest.GetFormInt("IsBr") > 0 ? 1 : 0;
            categ.pos_type = DoRequest.GetFormInt("position1");       
           
            if(categ.type_name.Length <= 0)
                return Json(new { error = true, message = "菜单名称不能为空" });
            if(categ.type_url.Length <= 0)
                return Json(new { error = true, message = "URL不能为空" });
            if (HasChinese(categ.type_url))
            {
                return Json(new { error = true, message = "URL不能含中文！" });
            }

            int rVal = -1;
            var res = OpHomeType.Do(categ);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                rVal = Utils.StrToInt(res.Header.Result.Code, -1);
            if (rVal == 0)
            {
                return Json(new { error = false, message = "操作成功" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion
    }
}

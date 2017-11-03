using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Text;
using System.Xml;
using System.Xml.XPath;

using JiuZhou.ControllerBase;
using JiuZhou.MySql;
using JiuZhou.HttpTools;
using JiuZhou.Model;
using JiuZhou.Common;
using JiuZhou.Cache;

namespace JiuZhou.Shop.WebManager.Controllers
{
    [HandleError]
    public class MGoodsController : ForeSysBaseController
    {
        //
        // GET: /MGoods/

        #region 在售商品列表
        public ActionResult Index()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,101,127,128,"))
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

            int pagesize = DoRequest.GetQueryInt("size", 30);
            int pageindex = DoRequest.GetQueryInt("page", 1);
            int isVisible = 1; 
            int classid = DoRequest.GetQueryInt("classid", -1);
            int shopid = DoRequest.GetQueryInt("shopid", -1);
            int ison = 1;
            int sType = DoRequest.GetQueryInt("stype");
            int promotion = DoRequest.GetQueryInt("promotion", -1);
            string ocol = DoRequest.GetQueryString("ocol").Trim().ToLower();
            if (ocol == "") {
                ocol = "modifytime";
            }
            string otype = DoRequest.GetQueryString("ot").ToLower().Trim();
            if (otype == "") {
                otype = "desc";
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

            #region 商品列表
            int dataCount = 0;
            int pageCount = 0;
            List<ProductsInfo> _table = new List<ProductsInfo>();
            DoCache cache = new DoCache();
            string cachekey = "product-index=" + pageindex + "shopid=" + shopid + "classid=" + classid + "stype=" + sType + "promotion=" + promotion + "ison=" + ison + "visible=" + isVisible + "skey=" + sKey + "ocol=" + ocol + "otype=" + otype;
            if (cache.GetCache(cachekey) == null)
            {
                var resp = QueryProductInfo.Do(pagesize, pageindex
                    , 0
                    , shopid
                    , classid
                    , sType
                    , promotion
                    , ison
                    , isVisible
                    , sKey
                    , ocol
                    , otype
                    , ref dataCount
                    , ref pageCount);
                if (resp != null && resp.Body != null && resp.Body.product_list != null)
                {
                    _table = resp.Body.product_list;
                    cache.SetCache(cachekey, _table, 10);
                    cache.SetCache("product-datacount1", dataCount, 10);
                    if (_table.Count == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else
            {
                _table = (List<ProductsInfo>)cache.GetCache(cachekey);
                dataCount = (int)cache.GetCache("product-datacount1");
            }
            ViewData["infoList"] = _table;//商品列表

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/mgoods/index?");
            currPageUrl.Append("&size=" + pagesize);
            currPageUrl.Append("&classid=" + classid);
            currPageUrl.Append("&stype=" + sType);
            currPageUrl.Append("&promotion=" + promotion);
            currPageUrl.Append("&visi=" + isVisible);
            currPageUrl.Append("&ison=" + ison);
            currPageUrl.Append("&ocol=" + ocol);
            currPageUrl.Append("&ot=" + otype);
            currPageUrl.Append("&shopid=" + shopid);

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

        #region 已下架商品
        public ActionResult SoldOut()
        {

            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,101,127,129,"))
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

            int pagesize = DoRequest.GetQueryInt("size", 30);
            int pageindex = DoRequest.GetQueryInt("page", 1);
            int ison = DoRequest.GetQueryInt("ison", 0);
            int isVisible = 1; 
            int sType = DoRequest.GetQueryInt("stype");
            int classid = DoRequest.GetQueryInt("classid", -1);
            int shopid = DoRequest.GetQueryInt("shopid", -1);

            string ocol = DoRequest.GetQueryString("ocol").Trim().ToLower();
            if (ocol == "")
            {
                ocol = "modifytime";
            }
            string otype = DoRequest.GetQueryString("ot").ToLower().Trim();
            if (otype == "")
            {
                otype = "desc";
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

            int dataCount = 0;
            int pageCount = 0;
            #region 商品列表
            List<ProductsInfo> _table = new List<ProductsInfo>();
            DoCache cache = new DoCache();
            string cachekey = "product-index=" + pageindex + "shopid=" + shopid + "classid=" + classid + "stype=" + sType + "ison=" + ison + "visible=" + isVisible + "skey=" + sKey + "ocol=" + ocol + "otype=" + otype;
            if (cache.GetCache(cachekey) == null)
            {
                var resp = QueryProductInfo.Do(pagesize, pageindex
                    , 0
                    , shopid
                    , classid
                    , sType
                    , -1
                    , ison
                    , isVisible
                    , sKey
                    , ocol
                    , otype
                    , ref dataCount
                    , ref pageCount);
                if (resp != null && resp.Body != null && resp.Body.product_list != null)
                {
                    _table = resp.Body.product_list;
                    cache.SetCache(cachekey, _table, 10);
                    cache.SetCache("product-datacount2", dataCount, 10);
                    if (_table.Count == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else
            {
                _table = (List<ProductsInfo>)cache.GetCache(cachekey);
                dataCount = (int)cache.GetCache("product-datacount2");
            }
            ViewData["infoList"] = _table;//商品列表

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/mgoods/soldOut?");
            currPageUrl.Append("&size=" + pagesize);
            currPageUrl.Append("&classid=" + classid);
            currPageUrl.Append("&stype=" + sType);
            currPageUrl.Append("&ocol=" + ocol);
            currPageUrl.Append("&ot=" + otype);
            currPageUrl.Append("&shopid=" + shopid);

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

        #region 商品回收站
        public ActionResult Recycle()
        {

            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,101,127,130,"))
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

            int pagesize = DoRequest.GetQueryInt("size", 30);
            int pageindex = DoRequest.GetQueryInt("page", 1);
            int ison = -1;
            int isVisible = 0;
            int sType = DoRequest.GetQueryInt("stype");
            int classid = DoRequest.GetQueryInt("classid", -1);
            int shopid = -1;

            string ocol = DoRequest.GetQueryString("ocol").Trim().ToLower();
            if (ocol == "")
            {
                ocol = "modifytime";
            }
            string otype = DoRequest.GetQueryString("ot").ToLower().Trim();
            if (otype == "")
            {
                otype = "desc";
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

            #region 商品列表
            int dataCount = 0;
            int pageCount = 0;
            List<ProductsInfo> _table = new List<ProductsInfo>();
            DoCache cache = new DoCache();
            string cachekey = "product-index=" + pageindex + "shopid=" + shopid + "classid=" + classid + "stype=" + sType + "ison=" + ison + "visible=" + isVisible + "skey=" + sKey + "ocol=" + ocol + "otype=" + otype;
            if (cache.GetCache(cachekey) == null)
            {
                var resp = QueryProductInfo.Do(pagesize, pageindex
                    , 0
                    , shopid
                    , classid
                    , sType
                    , -1
                    , ison
                    , isVisible
                    , sKey
                    , ocol
                    , otype
                    , ref dataCount
                    , ref pageCount);
                if (resp != null && resp.Body != null && resp.Body.product_list != null)
                {
                    _table = resp.Body.product_list;
                    cache.SetCache(cachekey, _table, 10);
                    cache.SetCache("product-datacount3", dataCount, 10);
                    if (_table.Count == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else
            {
                _table = (List<ProductsInfo>)cache.GetCache(cachekey);
                dataCount = (int)cache.GetCache("product-datacount3");
            }
            ViewData["infoList"] = _table;//商品列表

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/mgoods/recycle?");
            currPageUrl.Append("&size=" + pagesize);
            currPageUrl.Append("&classid=" + classid);
            currPageUrl.Append("&stype=" + sType);
            currPageUrl.Append("&ocol=" + ocol);
            currPageUrl.Append("&ot=" + otype);
            currPageUrl.Append("&shopid=" + shopid);

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

        #region 待审核商品列表
        public ActionResult Verify()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,101,127,584,"))
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

            int pagesize = DoRequest.GetQueryInt("size", 30);
            int pageindex = DoRequest.GetQueryInt("page", 1);
            int isVisible = -1;
            int classid = DoRequest.GetQueryInt("classid", -1);
            int shopid = DoRequest.GetQueryInt("shopid", -1);
            int ison = -1;
            int sType = DoRequest.GetQueryInt("stype");
            int checktype = DoRequest.GetQueryInt("checktype", 9);

            string ocol = DoRequest.GetQueryString("ocol").Trim().ToLower();
            if (ocol == "")
            {
                ocol = "modifytime";
            }
            string otype = DoRequest.GetQueryString("ot").ToLower().Trim();
            if (otype == "")
            {
                otype = "desc";
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

            #region 商品列表
            int dataCount = 0;
            int pageCount = 0;
            List<ProductsInfo> _table = new List<ProductsInfo>();
            DoCache cache = new DoCache();
            string cachekey = "product-index=" + pageindex + "shopid=" + shopid + "classid=" + classid + "stype=" + sType + "ison=" + ison + "visible=" + isVisible + "skey=" + sKey + "ocol=" + ocol + "otype=" + otype;
            if (cache.GetCache(cachekey) == null)
            {
                var resp = QueryProductInfo.Do(pagesize, pageindex
                    , checktype
                    , shopid
                    , classid
                    , sType
                    , -1
                    , ison
                    , isVisible
                    , sKey
                    , ocol
                    , otype
                    , ref dataCount
                    , ref pageCount);
                if (resp != null && resp.Body != null && resp.Body.product_list != null)
                {
                    _table = resp.Body.product_list;
                    cache.SetCache(cachekey, _table, 10);
                    cache.SetCache("product-datacount1", dataCount, 10);
                    if (_table.Count == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else
            {
                _table = (List<ProductsInfo>)cache.GetCache(cachekey);
                dataCount = (int)cache.GetCache("product-datacount1");
            }
            ViewData["infoList"] = _table;//商品列表

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/mgoods/verify?");
            currPageUrl.Append("&size=" + pagesize);
            currPageUrl.Append("&classid=" + classid);
            currPageUrl.Append("&stype=" + sType);
            currPageUrl.Append("&visi=" + isVisible);
            currPageUrl.Append("&ison=" + ison);
            currPageUrl.Append("&ocol=" + ocol);
            currPageUrl.Append("&ot=" + otype);
            currPageUrl.Append("&shopid=" + shopid);

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

        #region 商品编辑
        public ActionResult Editor() 
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,101,127,597,"))
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

        #region 商品分类
        public ActionResult Categ()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,101,131,132,"))
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

        #region ProGift 赠品设置
        public ActionResult ProGift()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,101,127,128,"))
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

        #region ProCorrelation 关联推荐
        public ActionResult ProCorrelation()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,101,127,128,"))
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

        #region Join 商品关联设置
        public ActionResult Join()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,101,175,194,"))
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

            int pagesize = DoRequest.GetQueryInt("size", 30);
            int pageindex = DoRequest.GetQueryInt("page", 1);
            string typeName = DoRequest.GetQueryString("type").Trim().ToLower();

            string q = DoRequest.GetQueryString("q");
            string sKey = q;

            #region 关联列表
            int dataCount = 0;
            int pageCount = 0;

            List<ProductJoinInfo> infoList = new List<ProductJoinInfo>();
            DoCache cache = new DoCache();
            string cachekey = "join-index=" + pageindex + "name=" + typeName + "q=" + q;
            if (cache.GetCache(cachekey) == null)
            {
                var resp = QueryProductJoin.Do(pagesize, pageindex, typeName, q, ref dataCount, ref pageCount);
                if (resp != null && resp.Body != null && resp.Body.join_list != null)
                {
                    infoList = resp.Body.join_list;
                    cache.SetCache(cachekey, infoList);
                    cache.SetCache("join-datacount", dataCount);
                    if (infoList.Count == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else {
                infoList = (List<ProductJoinInfo>)cache.GetCache(cachekey);
                dataCount = (int)cache.GetCache("join-datacount");
            }
            ViewData["infoList"] = infoList;//关联列表

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/mgoods/join?");
            currPageUrl.Append("&size=" + pagesize);
            currPageUrl.Append("&type=" + DoRequest.UrlEncode(typeName));

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

        #region JoinEditor 商品关联编辑页
        public ActionResult JoinEditor()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,101,175,194,"))
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

            int joinid = DoRequest.GetQueryInt("joinid");

            ResponseProductJoinItem joinitem = null; 
            var resResp = GetProductJoinDetail.Do(joinid);
            if (resResp == null || resResp.Body == null)
            {
                joinitem = new ResponseProductJoinItem();
            }
            else {
                joinitem = resResp.Body;
            }
            ProductJoinInfo joininfo = new ProductJoinInfo();
            joininfo.product_join_id = joinitem.product_join_id;
            joininfo.join_name = joinitem.join_name;
            joininfo.type_name = joinitem.type_name;
            joininfo.allow_refresh = joinitem.allow_refresh;
            joininfo.view_type = joinitem.view_type;
            ViewData["Info"] = joininfo;
            ViewData["InfoList"] = joinitem.join_item_list;
            return View();
        }
        #endregion

        #region Assemble 组合套装列表
        public ActionResult Assemble()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,101,175,190,"))
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

            int pagesize = DoRequest.GetQueryInt("size", 30);
            int pageindex = DoRequest.GetQueryInt("page", 1);
            int typeId = DoRequest.GetQueryInt("type", -1);

            string q = DoRequest.GetQueryString("q");
            string sKey = q;

            #region 关联列表
            int dataCount = 0;
            int pageCount = 0;

            List<ProductAssembleInfo> infoList = new List<ProductAssembleInfo>();
            DoCache cache = new DoCache();
            string cachekey = "assemble-index=" + pageindex + "typeid=" + typeId;
            if (cache.GetCache(cachekey) == null)
            {
                var resass = QueryAssembleList.Do(pagesize, pageindex, typeId, q, ref dataCount, ref pageCount);
                if (resass != null && resass.Body != null && resass.Body.assemble_list != null)
                {
                    infoList = resass.Body.assemble_list;
                    cache.SetCache(cachekey, infoList);
                    cache.SetCache("assemble-datacount", dataCount);
                    if (infoList.Count == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else {
                infoList = (List<ProductAssembleInfo>)cache.GetCache(cachekey);
                dataCount = (int)cache.GetCache("assemble-datacount");
            }
            ViewData["infoList"] = infoList;

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/mgoods/assemble?");
            currPageUrl.Append("&size=" + pagesize);
            currPageUrl.Append("&type=" + typeId);

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

        #region AssembleEditor 编辑组合套装列表
        public ActionResult AssembleEditor()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,101,175,190,"))
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

            int assid = DoRequest.GetQueryInt("assid");
            ResponseProductAssemble assemble = new ResponseProductAssemble();
            var res = QueryProductAssembleDetail.Do(assid);
                if(res != null && res.Body != null)
                assemble = res.Body;
            ViewData["Info"] = assemble;

            return View();
        }
        #endregion             

        #region 运费模板
        public ActionResult FareTemplate()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,101,175,177,"))
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

        #region 运费模板编辑
        public ActionResult FareTemplateEditor()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,101,175,177,"))
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

        #region seo规则
        public ActionResult SeoRule()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                //todo
                if (item.res_path.Equals("0,1,101,175,601,"))
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

        #region seo规则编辑
        public ActionResult SeoRuleEditor()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                //todo
                if (item.res_path.Equals("0,1,101,175,601,"))
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

        #region PostSeoRule 保存Seo规则
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostSeoRule()
        {
            int seoruleid = DoRequest.GetFormInt("seoruleid");
            SeoRuleInfo rule = new SeoRuleInfo();
            if (seoruleid != -1)
            {
                var resrule = GetSeoRuleList.Do(seoruleid);//规则信息
                if (resrule != null && resrule.Body != null && resrule.Body.seo_rule_list != null && resrule.Body.seo_rule_list[0] != null)
                    rule = resrule.Body.seo_rule_list[0];
                rule.add_time = DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss");
                rule.update_time = DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss");
            }
            else
            {
                rule.add_time = DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss");
                rule.update_time = DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss");
            }
            rule.rule_name = DoRequest.GetFormString("rule_name");
            rule.priority_level = DoRequest.GetFormInt("priority_level");
            rule.title = DoRequest.GetFormString("title");
            rule.keywords = DoRequest.GetFormString("keywords");
            rule.description = DoRequest.GetFormString("description");
            rule.rule_element = "1,2";
            #region Checking
            if (rule.rule_name.Length < 1)
            {
                return Json(new { error = true, message = "[名称] 不能为空" });
            }
            if (rule.rule_name.Length > 100)
            {
                return Json(new { error = true, message = "[名称] 不能大于200个字符" });
            }
            if (rule.priority_level < 0 )
            {
                return Json(new { error = true, message = "[优先级] 不能小于0" });
            }
            if (rule.title.Length < 1)
            {
                return Json(new { error = true, message = "[title] 不能为空" });
            }
            if (rule.keywords.Length < 1)
            {
                return Json(new { error = true, message = "[keywords] 不能为空" });
            }
            if (rule.description.Length < 1)
            {
                return Json(new { error = true, message = "[description] 不能为空" });
            }
            #endregion
            List<SeoRuleItemInfo> oldrules = new List<SeoRuleItemInfo>();
            if (rule.rule_id != 0)
            {
                var resfa = GetSeoRuleItemsByRuleId.Do(rule.rule_id);
                if (resfa != null && resfa.Body != null && resfa.Body.rule_list != null)
                {
                    oldrules = resfa.Body.rule_list;
                }
            }
            List<int> oldids = new List<int>();
            StringBuilder delids = new StringBuilder();
            foreach (SeoRuleItemInfo item in oldrules)
            {
                oldids.Add(item.rule_item_id);
            }
            List<int> idlist = new List<int>();
            List<SeoRuleItemInfo> rules = new List<SeoRuleItemInfo>();
            bool isError = false;
            string errorText = "";
            string xmlString = DoRequest.GetFormString("xml", false);
            #region 规则
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
                        SeoRuleItemInfo seoruleitem = new SeoRuleItemInfo();
                        int rule_item_id = int.Parse(item.Attributes["rule_item_id"].Value.Trim());
                        idlist.Add(rule_item_id);
                        seoruleitem.rule_id = rule.rule_id;
                        seoruleitem.rule_item_id = rule_item_id;
                        seoruleitem.elment_id = int.Parse(item.Attributes["elment_id"].Value.Trim());
                        seoruleitem.seo_elment_code = item.Attributes["seo_elment_code"].Value.Trim();
                        seoruleitem.add_time = DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss");
                        rules.Add(seoruleitem);
                    }
                    #endregion
                }

            }
            catch (Exception)
            {
                return Json(new { error = true, input = "message", message = "解析 [规则] 失败..." });
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
                delids.Append("0,");
            }
            int returnValue = -1;
            var res = OpSeoRule.Do(rule, rules, delids.ToString());
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功", data = rules });
            }
            return Json(new { error = true, message = "操作失败", data = rules });
        }
        #endregion

        #region RemoveSeoRule 删除seo模版
        [HttpPost]
        public ActionResult RemoveSeoRule()
        {
            int ruleid = DoRequest.GetFormInt("ruleid");

            if (ruleid < 1)
            {
                return Json(new { error = true, message = "没有选择任何项" });
            }
            int returnValue = -1;

            var res = DeleteSeoRule.Do(ruleid);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);

            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion


        #region seoHome规则编辑
        public ActionResult SeoHomeRuleEditor()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                //todo
                if (item.res_path.Equals("0,1,101,175,601,"))
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

        #region PostHomeSeoRule 保存HomeSeo规则
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostHomeSeoRule()
        {
            int seoruleid = DoRequest.GetFormInt("seoruleid");
            SeoRuleInfo rule = new SeoRuleInfo();
            if (seoruleid != -1)
            {
                var resrule = GetSeoRuleList.Do(seoruleid);//规则信息
                if (resrule != null && resrule.Body != null && resrule.Body.seo_rule_list != null && resrule.Body.seo_rule_list[0] != null)
                    rule = resrule.Body.seo_rule_list[0];
                rule.add_time = DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss");
                rule.update_time = DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss");
            }
            else
            {
                rule.add_time = DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss");
                rule.update_time = DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss");
            }
            rule.rule_name = DoRequest.GetFormString("rule_name");
            rule.priority_level = DoRequest.GetFormInt("priority_level");
            rule.title = DoRequest.GetFormString("title");
            rule.keywords = DoRequest.GetFormString("keywords");
            rule.description = DoRequest.GetFormString("description");
            rule.rule_element = "0";
            #region Checking
            if (rule.rule_name.Length < 1)
            {
                return Json(new { error = true, message = "[名称] 不能为空" });
            }
            if (rule.rule_name.Length > 100)
            {
                return Json(new { error = true, message = "[名称] 不能大于200个字符" });
            }
            if (rule.priority_level < 0)
            {
                return Json(new { error = true, message = "[优先级] 不能小于0" });
            }
            if (rule.title.Length < 1)
            {
                return Json(new { error = true, message = "[title] 不能为空" });
            }
            if (rule.keywords.Length < 1)
            {
                return Json(new { error = true, message = "[keywords] 不能为空" });
            }
            if (rule.description.Length < 1)
            {
                return Json(new { error = true, message = "[description] 不能为空" });
            }
            #endregion
            
            int returnValue = -1;
            var res = OpSeoHomeRule.Do(rule);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功" });
            }
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion


        #region seoClass规则编辑
        public ActionResult SeoClassRuleEditor()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                //todo
                if (item.res_path.Equals("0,1,101,175,601,"))
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

        #region PostSeoClassRule 保存ClassSeo规则
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostSeoClassRule()
        {
            int seoruleid = DoRequest.GetFormInt("seoruleid");
            SeoRuleInfo rule = new SeoRuleInfo();
            if (seoruleid != -1)
            {
                var resrule = GetSeoRuleList.Do(seoruleid);//规则信息
                if (resrule != null && resrule.Body != null && resrule.Body.seo_rule_list != null && resrule.Body.seo_rule_list[0] != null)
                    rule = resrule.Body.seo_rule_list[0];
                rule.add_time = DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss");
                rule.update_time = DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss");
            }
            else
            {
                rule.add_time = DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss");
                rule.update_time = DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss");
            }
            rule.rule_name = DoRequest.GetFormString("rule_name");
            rule.priority_level = DoRequest.GetFormInt("priority_level");
            rule.title = DoRequest.GetFormString("title");
            rule.keywords = DoRequest.GetFormString("keywords");
            rule.description = DoRequest.GetFormString("description");
            rule.rule_element = "3";
            #region Checking
            if (rule.rule_name.Length < 1)
            {
                return Json(new { error = true, message = "[名称] 不能为空" });
            }
            if (rule.rule_name.Length > 100)
            {
                return Json(new { error = true, message = "[名称] 不能大于200个字符" });
            }
            if (rule.priority_level < 0)
            {
                return Json(new { error = true, message = "[优先级] 不能小于0" });
            }
            if (rule.title.Length < 1)
            {
                return Json(new { error = true, message = "[title] 不能为空" });
            }
            if (rule.keywords.Length < 1)
            {
                return Json(new { error = true, message = "[keywords] 不能为空" });
            }
            if (rule.description.Length < 1)
            {
                return Json(new { error = true, message = "[description] 不能为空" });
            }
            #endregion
            List<SeoRuleItemInfo> oldrules = new List<SeoRuleItemInfo>();
            if (rule.rule_id != 0)
            {
                var resfa = GetSeoRuleItemsByRuleId.Do(rule.rule_id);
                if (resfa != null && resfa.Body != null && resfa.Body.rule_list != null)
                {
                    oldrules = resfa.Body.rule_list;
                }
            }
            List<int> oldids = new List<int>();
            StringBuilder delids = new StringBuilder();
            foreach (SeoRuleItemInfo item in oldrules)
            {
                oldids.Add(item.rule_item_id);
            }
            List<int> idlist = new List<int>();
            List<SeoRuleItemInfo> rules = new List<SeoRuleItemInfo>();
            bool isError = false;
            string errorText = "";
            string xmlString = DoRequest.GetFormString("xml", false);
            #region 规则
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
                        SeoRuleItemInfo seoruleitem = new SeoRuleItemInfo();
                        int rule_item_id = int.Parse(item.Attributes["rule_item_id"].Value.Trim());
                        idlist.Add(rule_item_id);
                        seoruleitem.rule_id = rule.rule_id;
                        seoruleitem.rule_item_id = rule_item_id;
                        seoruleitem.elment_id = int.Parse(item.Attributes["elment_id"].Value.Trim());
                        seoruleitem.seo_elment_code = item.Attributes["seo_elment_code"].Value.Trim();
                        seoruleitem.add_time = DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss");
                        rules.Add(seoruleitem);
                    }
                    #endregion
                }

            }
            catch (Exception)
            {
                return Json(new { error = true, input = "message", message = "解析 [规则] 失败..." });
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
                delids.Append("0,");
            }
            int returnValue = -1;
            var res = OpSeoRule.Do(rule, rules, delids.ToString());
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功", data = rules });
            }
            return Json(new { error = true, message = "操作失败", data = rules });
        }
        #endregion


        #region BrandList 品牌列表
        public ActionResult BrandList()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,101,175,253,"))
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

            List<BrandInfo> infoList = new List<BrandInfo>();
            DoCache cache = new DoCache();
            string cachekey = "brand-index=" + pageindex + "q=" + q;
            if (cache.GetCache(cachekey) == null)
            {
                var res = QueryBrandList.Do(pagesize, pageindex
                    , q
                    , ref dataCount, ref pageCount);
                if (res != null && res.Body != null && res.Body.brand_list != null)
                {
                    infoList = res.Body.brand_list;
                    cache.SetCache(cachekey, infoList);
                    cache.SetCache("brand-datacount", dataCount);
                    if (infoList.Count == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else {
                infoList = (List<BrandInfo>)cache.GetCache(cachekey);
                dataCount = (int)cache.GetCache("brand-datacount");
            }
            ViewData["infoList"] = infoList;

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/mgoods/brandlist?");
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

        #region BrandEditor 品牌编辑
        public ActionResult BrandEditor()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,101,175,253,"))
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

        #region PostResetProductStock 更改商品库存
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostResetProductStock()
        {
            int proId = DoRequest.GetFormInt("productid");
            ProductInfo product = GetProductInfo.Do(proId).Body;//商品信息
            product.virtual_stock_num = DoRequest.GetFormInt("stock");
            int returnValue = -1;
            var res = OpProductInfo.Do(product);
            if(res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code,-1);//更新 商品信息

            #region 判断是否操作成功
            string msgText = "";
            switch (returnValue)
            {
                case 0:
                    /*   if (product.is_on_sale == 1 && product.stock_num > 0)
                   {
                       //发送短信 更新状态
                       List<ArrivalNoticeInfo> nots = GetArrivalNoticeInfo.Do().Body.Arri_list;
                       nots = nots.Where(t => t.IsNotice == 0 && t.Pro_ID == product.p_id).ToList();
                       if (nots.Count > 0)
                       {
                           foreach (var not in nots)
                           {
                               erp.SMS.SMS sms = new erp.SMS.SMS();
                               if 
                     * (Utils.IsMobile(not.Phone.Trim()))
                               {
                                   StringBuilder msg = new StringBuilder();
                                   msg.Append("您需要购买的商品[" + product.p_name + "]已经到货,请前往http://www.dada360.com购买,谢谢!");
                                   sms.sendSMS(not.Phone.Trim(), msg.ToString());//发送短信
                                   ArrivalNoticeDB.UpdateArrivalNotice(not.ID);
                               }
                           }
                       }
                   } */
                    msgText = "修改成功 ^_^";
                    DoCache cache = new DoCache();
                    cache.RemoveCacheStartsWith("product-");
                    break;
                case -1:
                    msgText = "修改失败";
                    break;
                default:
                    msgText = "修改失败";
                    break;
            }
            #endregion
            return Json(new { error = (returnValue == 0 ? false : true), input = "message", message = msgText, returnValue = returnValue });
            
        }
        #endregion

        #region PostResetProductPrice 更改商品价格
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostResetProductPrice()
        {
            int proId = DoRequest.GetFormInt("productid");
            ProductInfo product = GetProductInfo.Do(proId).Body;//商品信息
            decimal price = DoRequest.GetFormDecimal("price");
            if (price < 0)
                price = 0;
            string type = DoRequest.GetFormString("type").Trim().ToLower();
            if (type == "mobile")
            {
                product.mobile_price = price;
            }
            else
            {
                product.sale_price = price;
            }
            int returnValue = -1;
            var res = OpProductInfo.Do(product);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);//更新 商品信息
            #region 判断是否操作成功
            string msgText = "";
            switch (returnValue)
            {
                case 0:
                    msgText = "修改成功 ^_^";
                    DoCache cache = new DoCache();
                    cache.RemoveCacheStartsWith("product-");
                    break;
                case -1:
                    msgText = "修改失败";
                    break;
                default:
                    msgText = "修改失败";
                    break;
            }
            #endregion
            return Json(new { error = (returnValue == 0 ? false : true), input = "message", message = msgText, returnValue = returnValue });
        }
        #endregion

        #region ResetProductStatusList 修改销售状态
        [HttpPost]
        public ActionResult ResetProductStatusList()
        {
            string idString = DoRequest.GetFormString("visitid").Trim();
            int status = DoRequest.GetFormInt("status");

            if (string.IsNullOrEmpty(idString))
            {
                return Json(new { error = true, message = "没有选择任何项" });
            }
            int returnValue = -1;
            var res = ModifyProductState.Do(idString, status, "is_on_sale");
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code,-1);
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("product-");
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        /*
        #region ResetAllowYBLife 修改是否允许医卡通支付
        [HttpPost]
        public ActionResult ResetAllowYBLife()
        {
            string idString = DoRequest.GetFormString("visitid").Trim();
            int status = DoRequest.GetFormInt("status");

            if (string.IsNullOrEmpty(idString))
            {
                return Json(new { error = true, message = "没有选择任何项" });
            }
            int returnValue = -1;
            var res = ModifyProductState.Do(idString, status, "allow_ebaolife");
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code,-1);
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("product-");
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion
        */

        #region RemoveProductList 修改显示状态
        [HttpPost]
        public ActionResult RemoveProductList()
        {
            string idString = DoRequest.GetFormString("visitid").Trim();
            int status = DoRequest.GetFormInt("status");

            if (string.IsNullOrEmpty(idString))
            {
                return Json(new { error = true, message = "没有选择任何项" });
            }
            int returnValue = -1;
            var res = ModifyProductState.Do(idString, status, "is_visible");
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("product-");
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region UpdateSEO 修改SEO字段
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult UpdateSEO()
        {
            int productid = DoRequest.GetFormInt("productid");
            string stitle = DoRequest.HtmlEncode(DoRequest.GetFormString("stitle"));
            string skeywords = DoRequest.HtmlEncode(DoRequest.GetFormString("skeywords"));
            string stext = DoRequest.HtmlEncode(DoRequest.GetFormString("stext"));

            int returnValue = -1;
            var res = ModifyProductSeo.Do(productid, stitle, stext, skeywords);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code,-1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region ResetCategStatus 修改分类状态
        [HttpPost]
        public ActionResult ResetCategStatus()
        {
            int id = DoRequest.GetFormInt("id");
            int status = DoRequest.GetFormInt("status");
            int returnValue = -1;
            var res = ModifyProductTypeVisible.Do(id, status);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code,-1);
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCache("typelist");
                return Json(new { error = false, message = "操作成功" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region DeleteProductImage 删除商品图
        [HttpPost]
        public ActionResult DeleteProductImage()
        {
            int proid = DoRequest.GetFormInt("proid");
            int imgid = DoRequest.GetFormInt("imgid");

            int returnValue = -1;
            var res = DeleteProductAlbum.Do(imgid);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code,-1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostProductData 保存商品信息
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostProductData()
        {
            int proId = DoRequest.GetFormInt("ProID");
            int classId = DoRequest.GetFormInt("ClassID");
            List<TypeList> categs = new List<TypeList>();
            var res = GetTypeListAll.Do(-1);
            if (res != null && res.Body != null && res.Body.type_list != null)
            {
                categs = res.Body.type_list;
            }
          
            ProductInfo product = null;
            TypeList categ = categs.Find(
                    delegate(TypeList t)
                    {
                        return (t.product_type_id == classId);
                    });//分类信息
            if (proId == 0)
            {
                product = new ProductInfo();
            }
            else
            {
                product = new ProductInfo();
                var respro = GetProductInfo.Do(proId);//商品信息
                if (respro != null && respro.Body != null)
                    product = respro.Body;
            }
            if (categ == null)
            {
                categ = new TypeList();
            }
            if (categ.product_type_id < 1)
            {
                return Json(new { error = true, input = "message", message = "请选择商品分类" });
            }
            List<ShopList> shopList = new List<ShopList>();
            var resshop = GetShopInfo.Do(-1);
            if (resshop != null && resshop.Body != null && resshop.Body.shop_list != null)
            {
                shopList = resshop.Body.shop_list;
            }
            
            List<BrandInfo> brandlist = new List<BrandInfo>();
            int datacount = 0;
            int pagecount = 0;
            var resbrand = QueryBrandList.Do(99999, 1, "", ref datacount, ref pagecount);
            if (resbrand != null && resbrand.Body != null && resbrand.Body.brand_list != null)
            {
                brandlist = resbrand.Body.brand_list;
            }

            string shopname = DoRequest.GetFormString("shopname");
            string brandname = DoRequest.GetFormString("brandname");
            int shopid = 0;
            foreach (ShopList item in shopList)
            {
                if (item.shop_name.Equals(shopname) && item.shop_state == 0)
                {
                    shopid = item.shop_id;
                }
            }
            int brandid = 0;
            foreach (BrandInfo item in brandlist)
            {
                if (item.brand_name.Equals(brandname) && item.brand_state == 0)
                {
                    brandid = item.brand_id;
                }
            }
            #region 获取参数
            product.shop_id = shopid;
            product.product_name = DoRequest.GetFormString("name").Trim();
            product.product_brand = brandname;
            product.sales_promotion = DoRequest.GetFormString("promotion").Trim();
            product.search_key = DoRequest.GetFormString("KeyForSearch").Trim();
            product.product_code = DoRequest.GetFormString("code").Trim();
            //product.stock_num = DoRequest.GetFormInt("stock");
            product.virtual_stock_num = DoRequest.GetFormInt("stock");
            product.max_buy_num = DoRequest.GetFormInt("max_buy_num");
            product.product_weight = DoRequest.GetFormDecimal("weight");
            product.is_drug = DoRequest.GetFormInt("p_is_prescription_drug") == 0 ? 0 : 1;
            product.product_spec = DoRequest.GetFormString("p_spec").Trim();
            product.manu_facturer = DoRequest.GetFormString("manufacturer").Trim();

            product.common_name = DoRequest.GetFormString("p_common_name").Trim();
            product.product_license = DoRequest.GetFormString("p_license").Trim();
            product.give_integral = DoRequest.GetFormInt("integral");
            product.allow_ebaolife = DoRequest.GetFormInt("AllowYBLife");
            product.check_state = DoRequest.GetFormInt("checktype", 9);

            #region 效期
            string idate = DoRequest.GetFormString("idate").Trim();
            int ihours = DoRequest.GetFormInt("ihours");
            int iminutes = DoRequest.GetFormInt("iminutes");
            if (Utils.IsDateString(idate))
            {
                if (ihours < 0 || ihours > 23) ihours = 0;
                if (iminutes < 0 || iminutes > 59) iminutes = 0;
                product.invalid_date = idate + " " + ihours + ":" + iminutes + ":00";
            }
            if (DateTime.Parse(product.invalid_date) < DateTime.Now)
            {
                product.invalid_date = "1900-01-01 00:00:00";
            }
            #endregion

            product.sale_price = DoRequest.GetFormDecimal("member_price");
            product.mobile_price = DoRequest.GetFormDecimal("mobile_price");

            product.promotion_price = DoRequest.GetFormDecimal("promotion_price");
            #region 促销时间
            string sdate = DoRequest.GetFormString("sdate").Trim();
            int shours = DoRequest.GetFormInt("shours");
            int sminutes = DoRequest.GetFormInt("sminutes");
            if (Utils.IsDateString(sdate))
            {
                if (shours < 0 || shours > 23) shours = 0;
                if (sminutes < 0 || sminutes > 59) sminutes = 0;

                product.promotion_bdate = sdate + " " + shours + ":" + sminutes + ":00";
            }

            string edate = DoRequest.GetFormString("edate").Trim();
            int ehours = DoRequest.GetFormInt("ehours");
            int eminutes = DoRequest.GetFormInt("eminutes");

            if (Utils.IsDateString(edate))
            {
                if (ehours < 0 || ehours > 23) ehours = 0;
                if (eminutes < 0 || eminutes > 59) eminutes = 0;

                product.promotion_edate = edate + " " + ehours + ":" + eminutes + ":59";
            }
            #endregion

            #region 运费设置
            product.is_free_fare = DoRequest.GetFormInt("IsFreeFare");
            product.free_fare_stime = "2010-01-01 00:00:00";
            product.free_fare_etime = "2010-01-01 23:59:59";
            if (product.is_free_fare == 1)
            {
                string fsDate = DoRequest.GetFormString("fsdate").Trim();
                int fsHours = DoRequest.GetFormInt("fshours");
                int fsMinutes = DoRequest.GetFormInt("fsminutes");
                if (Utils.IsDateString(fsDate))
                {
                    if (fsHours < 0 || fsHours > 23) fsHours = 0;
                    if (fsMinutes < 0 || fsMinutes > 59) fsMinutes = 0;

                    product.free_fare_stime = fsDate + " " + fsHours + ":" + fsMinutes + ":00";
                }
                string feDate = DoRequest.GetFormString("fedate").Trim();
                int feHours = DoRequest.GetFormInt("fehours");
                int feMinutes = DoRequest.GetFormInt("feminutes");
                if (Utils.IsDateString(feDate))
                {
                    if (feHours < 0 || feHours > 23) feHours = 0;
                    if (feMinutes < 0 || feMinutes > 59) feMinutes = 0;

                    product.free_fare_etime = feDate + " " + feHours + ":" + feMinutes + ":00";
                }
            }
            #endregion

            product.is_on_sale = DoRequest.GetFormInt("isOnSale") > 0 ? 1 : 0;
            product.is_visible = DoRequest.GetFormInt("isVisible", 1);
            product.month_click_count = DoRequest.GetFormInt("monthClicks");

            product.product_func = DoRequest.GetFormString("summary").Trim();
            product.product_detail = ToolsController.CleanHtml(DoRequest.GetFormString("detail", false).Trim(), false);
            #endregion

            product.fare_temp_id = DoRequest.GetFormInt("faretempid");

            product.product_type_id = categ.product_type_id;
            product.product_type_path = categ.product_type_path;

            product.brand_id = brandid;

            #region Checking
            if (product.product_type_id < 1)
            {
                return Json(new { error = true, input = "message", message = "请选择分类" });
            }
            if (shopname.Equals(""))
            {
                return Json(new { error = true, input = "message", message = "请填写商家" });
            }
            if (brandname.Equals(""))
            {
                return Json(new { error = true, input = "message", message = "请填写品牌" });
            }
            if (product.shop_id < 1)
            {
                return Json(new { error = true, input = "message", message = "填写的商家不存在" });
            }
            if (product.brand_id < 1)
            {
                return Json(new { error = true, input = "message", message = "填写的品牌不存在" });
            }
            if (product.product_name.Length < 1)
            {
                return Json(new { error = true, input = "message", message = "请填写商品名称" });
            }
            if (product.product_name.Length > 500)
            {
                return Json(new { error = true, input = "message", message = "商品名称不能大于500个字符" });
            }
            if (product.product_code.Length < 1)
            {
                return Json(new { error = true, input = "message", message = "请填写商家编码" });
            }
            if (product.product_code.Length > 50)
            {
                return Json(new { error = true, input = "message", message = "商家编码50个字符" });
            }
            /*
            if (product.market_price < product.sale_price)
            {
                return Json(new { error = true, input = "message", message = "市场价不能小于会员售价" });
            }
                * */
            if (product.sale_price < 0.01m)
            {
                return Json(new { error = true, input = "message", message = "会员价不能小于0.01元" });
            }
            if (product.mobile_price < 0.01m)
            {
                return Json(new { error = true, input = "message", message = "手机专享价不能小于0.01元" });
            }
            #endregion

            List<ProductAlbumInfo> images = new List<ProductAlbumInfo>();
            string image = "";
            #region 商品细节图
            string xmlString = DoRequest.GetFormString("xml", false);
            try
            {
                XmlDataDocument xmlDoc = new XmlDataDocument();
                xmlDoc.LoadXml(xmlString);
                XmlNodeList nodes = xmlDoc.SelectNodes("items/item");
                if (nodes != null)
                {
                    #region 细节图
                    bool isDefault = false;
                    foreach (XmlNode item in nodes)
                    {
                        ProductAlbumInfo img = new ProductAlbumInfo();
                        string path = item.Attributes["path"].Value.Trim();
                        string imgid = item.Attributes["imgid"].Value.Trim();
                        string isdef = item.Attributes["isdef"].Value.Trim();

                        if (string.IsNullOrEmpty(path))
                            continue;

                        img.product_album_id = Utils.StrToInt(imgid);
                        img.product_id = product.product_id;
                        img.album_name = "";
                        img.img_src = path;
                        img.add_user_id = ((LoginInfo)ViewData["logininfo"]).UserID;
                        img.add_time = DateTime.Now;
                        img.is_main = (Utils.StrToInt(isdef) == 1 && !isDefault) ? 1 : 0;

                        if (img.is_main == 1)
                        {
                            image = path;
                            isDefault = true;
                        }
                        images.Add(img);
                    }
                    if (!isDefault)
                    {
                        for (int i = 0; i < images.Count; i++)
                        {
                            if (string.IsNullOrEmpty(images[i].img_src))
                                continue;
                            images[i].is_main = 1;
                            image = images[i].img_src;
                            break;
                        }
                    }
                    #endregion
                }
            }
            catch (Exception)
            {
                return Json(new { error = true, input = "message", message = "Xml解析失败(商品主图)..." });
            }
            if (images.Count < 1)
            {
                return Json(new { error = true, input = "message", message = "请至少上传一张商品细节图" });
            }
            #endregion

            product.img_src = image;

            List<SkuList> oldList = new List<SkuList>();
            List<SkuList> addList = new List<SkuList>();
            List<SkuList> updateList = new List<SkuList>();
            bool isError = false;
            string errorText = "";
            #region 商品SKU
            string skuXmlString = DoRequest.GetFormString("sku", false);
            try
            {

                XmlDataDocument xmlDoc = new XmlDataDocument();
                xmlDoc.LoadXml(skuXmlString);
                XmlNodeList nodes = xmlDoc.SelectNodes("items/item");
                //XmlNodeList nodes = xmlDoc.SelectNodes("items/item[@Type='create']");
                if (nodes != null)
                {
                    #region SKU内容
                    foreach (XmlNode item in nodes)
                    {
                        string skuidString = item.Attributes["skuid"].Value.Trim();
                        if (skuidString.Equals(""))
                            skuidString = "0";
                        SkuList sku = null;
                        var respsku = GetSkusByProductId.Do(product.product_id);
                        if (respsku == null || respsku.Body == null || respsku.Body.sku_list == null)
                        {
                            sku = new SkuList();
                        }
                        else
                        {
                            sku = respsku.Body.sku_list.Find(delegate(SkuList itemsku)
                            {
                                return (itemsku.sku_id == int.Parse(skuidString));
                            });
                        }
                        if (sku == null)
                            sku = new SkuList();
                        if (Utils.IsLong(skuidString))
                            sku.sku_id = int.Parse(skuidString);

                        sku.product_id = product.product_id;
                        sku.sku_name = item.SelectSingleNode("name").InnerText.Trim();
                        sku.sku_code = item.SelectSingleNode("code").InnerText.Trim();

                        sku.virtual_sku_stock = Utils.StrToInt(item.SelectSingleNode("stock").InnerText, -1);
                        sku.sku_weight = Utils.StrToInt(item.SelectSingleNode("weight").InnerText, -1);

                        string memberPrice = item.SelectSingleNode("memberprice").InnerText;
                        string mobilePrice = item.SelectSingleNode("mobileprice").InnerText;
                        string promotionPrice = item.SelectSingleNode("promotionprice").InnerText;

                        sku.sale_price = Utils.IsNumber(memberPrice) ? decimal.Parse(memberPrice) : 0m;
                        sku.mobile_price = Utils.IsNumber(mobilePrice) ? decimal.Parse(mobilePrice) : 0m;
                        sku.promotion_price = Utils.IsNumber(promotionPrice) ? decimal.Parse(promotionPrice) : 0m;

                        if (string.IsNullOrEmpty(sku.sku_name) || sku.sku_name.Length < 1)
                        {
                            isError = true;
                            errorText = "[Sku名称] 不能为空";
                            break;
                        }
                        else if (sku.sku_name.Length > 100)
                        {
                            isError = true;
                            errorText = "[Sku名称] 不能超过100个字符";
                            break;
                        }

                        if (sku.sku_id > 0)
                        {
                            updateList.Add(sku);//更新
                        }
                        else
                        {
                            sku.is_visible = 1;
                            addList.Add(sku);//新增
                        }
                    }
                    #endregion
                }

            }
            catch (Exception)
            {
                return Json(new { error = true, input = "message", message = "Sku解析失败..." });
            }
            if (isError)
            {
                return Json(new { error = true, input = "message", message = errorText });
            }
            #endregion

            if (addList.Count > 0 || updateList.Count > 0)
            {
                product.stock_num = 0;
                foreach (SkuList sku in addList)
                    product.stock_num += sku.sku_stock;
                foreach (SkuList sku in updateList)
                    product.stock_num += sku.sku_stock;
            }
            var msg = "操作失败";
            int returnValue = -1;
            if (product.product_id > 0)
            {

                var ress = OpProductInfo.Do(product);
                if (ress != null && ress.Header != null && ress.Header.Result != null && ress.Header.Result.Code != null)
                {
                    returnValue = Utils.StrToInt(ress.Header.Result.Code, -1);
                    if (returnValue != 0)
                        msg = ress.Header.Result.Msg;
                }
            }
            else
            {
                var resp = OpProductInfo.Do(product);
                if (resp != null && resp.Header != null && resp.Header.Result != null && resp.Header.Result.Code != null)
                {
                    returnValue = Utils.StrToInt(resp.Header.Result.Code, -1);
                    if (returnValue != 0)
                        msg = resp.Header.Result.Msg;
                    product.product_id = resp.Body.product_id;
                }
            }

            #region 判断是否操作成功
            string msgText = "操作失败";
            switch (returnValue)
            {
                case 0:
                    msgText = "操作成功 ^_^";
                    DoCache cache = new DoCache();
                    cache.RemoveCacheStartsWith("product-");
                    break;
                case -1:
                    msgText = msg;
                    break;
                default:
                    msgText = msg;
                    break;
            }
            #endregion

            if (returnValue == 0)
            {

                var returnValue1 = -1;
                var returnValue2 = -1;
                if (proId == 0)
                {
                    Session["protypeid"] = product.product_type_id;
                    Session["protypepath"] = product.product_type_path;
                    Session["proshopname"] = shopname;
                    Session["probrandname"] = brandname;
                }

                #region 处理主图
                foreach (ProductAlbumInfo img in images)
                    img.product_id = product.product_id;//设置主图归属
                var res2 = OpProductAlbum.Do(product.product_id, images);
                #endregion

                #region 处理 Sku
                var ressku = GetSkusByProductId.Do(product.product_id);
                if (ressku != null && ressku.Body != null && ressku.Body.sku_list != null)
                    oldList = ressku.Body.sku_list;
                int deleteCount = 0;
                List<long> skuIDList = new List<long>();

                foreach (SkuList em in addList)
                    em.product_id = product.product_id;//设置sku归属(用于新增)
                foreach (SkuList em in updateList)
                {
                    em.product_id = product.product_id;//设置sku归属(用于更新)
                    skuIDList.Add(em.sku_id);//不删除的SKU
                }

                StringBuilder deleteSkus = new StringBuilder();
                //deleteSkus.Append("0");//需要删除的SKU

                foreach (SkuList em in oldList)
                {
                    if (!skuIDList.Contains(em.sku_id))
                    {
                        deleteCount++;
                        deleteSkus.Append(em.sku_id + ",");
                    }
                }
                var res1 = new Response<ResponseBodyEmpty>();
                if (deleteCount > 0)
                    res1 = DeleteProductSku.Do(product.product_id, deleteSkus.ToString());//删除
                if (addList.Count > 0)
                    res1 = OpProductSku.Do(product.product_id, addList);//新增
                if (updateList.Count > 0)
                    res1 = OpProductSku.Do(product.product_id, updateList);//更新
                #endregion
                if (deleteCount > 0 || addList.Count > 0 || updateList.Count > 0)
                {
                    if (res1 != null && res1.Header != null && res1.Header.Result != null && res1.Header.Result.Code != null)
                    {
                        returnValue1 = Utils.StrToInt(res1.Header.Result.Code, -1);
                        if (returnValue1 != 0)
                            msgText = res1.Header.Result.Msg;
                    }
                }
                if (res2 != null && res2.Header != null && res2.Header.Result != null && res2.Header.Result.Code != null)
                {
                    returnValue2 = Utils.StrToInt(res2.Header.Result.Code, -1);
                    if (returnValue2 != 0)
                        msgText = res2.Header.Result.Msg;
                }
            }

            return Json(new { error = (returnValue == 0 && returnValue == 0 && returnValue == 0) ? false : true, input = "message", message = msgText, returnValue = returnValue }, JsonRequestBehavior.AllowGet);
         
        }
        #endregion

        #region PostResetSkuDataForBox 保存商品Sku信息
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostResetSkuDataForBox()
        {
            int proId = DoRequest.GetFormInt("productid");
            ProductInfo product = new ProductInfo();
            var respro = GetProductInfo.Do(proId);//商品信息
            if (respro != null && respro.Body != null)
                product = respro.Body;

            List<SkuList> oldList = new List<SkuList>();
            var ressku = GetSkusByProductId.Do(proId);
            if (ressku != null && ressku.Body != null && ressku.Body.sku_list != null)
                oldList = ressku.Body.sku_list;
            List<SkuList> updateList = new List<SkuList>();
            bool isError = false;
            string errorText = "";
            #region 商品SKU
            string skuXmlString = DoRequest.GetFormString("sku", false);
            decimal skuMinPrice = product.sale_price;
            decimal skuMinPrice2 = product.mobile_price;
            decimal skuMaxPrice = 0m;
            decimal skuMaxPrice2 = 0m;
            try
            {
                XmlDataDocument xmlDoc = new XmlDataDocument();
                xmlDoc.LoadXml(skuXmlString);
                XmlNodeList nodes = xmlDoc.SelectNodes("items/item");
                if (nodes != null)
                {
                    #region SKU内容
                    foreach (XmlNode item in nodes)
                    {
                        SkuList sku = new SkuList();
                        string skuidString = item.Attributes["skuid"].Value.Trim();
                        if (Utils.IsLong(skuidString))
                        {
                            foreach (SkuList s in oldList)
                            {
                                if (s.sku_id == int.Parse(skuidString))
                                {
                                    sku = s; break;
                                }
                            }
                        }
                        if (sku.sku_id < 1)
                            break;

                        sku.virtual_sku_stock = Utils.StrToInt(item.SelectSingleNode("stock").InnerText, -1);
                        string memberPrice = item.SelectSingleNode("memberprice").InnerText;
                        string mobilePrice = item.SelectSingleNode("mobileprice").InnerText;

                        sku.sale_price = Utils.IsNumber(memberPrice) ? decimal.Parse(memberPrice) : 0m;
                        sku.mobile_price = Utils.IsNumber(mobilePrice) ? decimal.Parse(mobilePrice) : 0m;

                        if (skuMinPrice > sku.sale_price)
                            skuMinPrice = sku.sale_price;
                        if (skuMinPrice2 > sku.mobile_price)
                            skuMinPrice2 = sku.mobile_price;

                        if (skuMaxPrice < sku.sale_price)
                            skuMaxPrice = sku.sale_price;
                        if (skuMaxPrice2 < sku.mobile_price)
                            skuMaxPrice2 = sku.mobile_price;

                        updateList.Add(sku);//更新
                    }
                    #endregion
                }

            }
            catch (Exception)
            {
                return Json(new { error = true, input = "message", message = "Sku解析失败..." });
            }
            if (isError)
            {
                return Json(new { error = true, input = "message", message = errorText });
            }
            #endregion

            if (updateList.Count > 0)
            {
                #region 纠正产品参数
                product.virtual_stock_num = 0;
                foreach (SkuList sku in updateList)
                {
                    product.virtual_stock_num += sku.virtual_sku_stock;
                }
                if (product.sale_price < skuMinPrice && product.sale_price > skuMaxPrice)
                {
                    product.sale_price = skuMinPrice;
                }
                if (product.mobile_price < skuMinPrice2 && product.mobile_price > skuMaxPrice2)
                {
                    product.mobile_price = skuMinPrice2;
                }
                #endregion
            }

            int returnValue = -1;//更新sku信息
            var res = OpProductSku.Do(proId,updateList);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code,-1);

            #region 判断是否操作成功
            string msgText = "";
            switch (returnValue)
            {
                case 0:
                    msgText = "操作成功 ^_^";
                    break;
                case -1:
                    msgText = "操作失败" + returnValue;
                    break;
                default:
                    msgText = "操作失败" + returnValue;
                    break;
            }
            #endregion

            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("product-");
                ModifyStockNumAndPrice.Do(product.product_id, product.sale_price, product.mobile_price, product.virtual_stock_num);//更新 商品信息
            }

            return Json(new { error = (returnValue == 0) ? false : true, input = "message", message = msgText, returnValue = returnValue });
        }
        #endregion

        #region PostCategData 保存分类信息
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostCategData()
        {
            int parentId = DoRequest.GetFormInt("parentId");
            int itemId = DoRequest.GetFormInt("itemId");
            string name = DoRequest.GetFormString("name").Trim();
            int sort = DoRequest.GetFormInt("sort", 0);
            string content = DoRequest.GetFormString("content");
            string img = DoRequest.GetFormString("imgsrc");

            #region Checking
            if (name.Length < 1)
            {
                return Json(new { error = true, message = "【名称】不能为空" });
            }
            if (name.Length > 50)
            {
                return Json(new { error = true, message = "【名称】不能多于50个字符" });
            }
           
            #endregion

            ProTypeList tInfo = null;
            var resp = GetProductTypeInfo.Do(itemId);
            if (resp == null || resp.Body == null)
            {
                tInfo = new ProTypeList();
            }
            else {
                tInfo = resp.Body;
            }
            tInfo.parent_type_id = parentId;
            tInfo.type_name = name;
            tInfo.seo_title = name;
            tInfo.seo_key = name;
            tInfo.seo_text = content;
            tInfo.sort_no = sort;
            tInfo.img_src = img;

            long returnValue = -1;

            if (tInfo.product_type_id < 1)
            {
                tInfo.add_user_id = ((LoginInfo)ViewData["logininfo"]).UserID;
                var res = OpProductType.Do(tInfo);
                if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                    returnValue = Utils.StrToInt(res.Header.Result.Code,-1);
            }
            else
            {
                var res = OpProductType.Do(tInfo); 
                if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                    returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            }
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCache("typelist");
                return Json(new { error = false, message = "操作成功" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostGifts 保存赠品信息
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostGifts()
        {
            int productId = DoRequest.GetFormInt("proid");
            string xmlString = DoRequest.GetFormString("xml", false);

            ProductInfo Info = new ProductInfo();
            var respro = GetProductInfo.Do(productId);
            if (respro != null && respro.Body != null)
                Info = respro.Body;
            try
            {
                List<GiftsList> list = new List<GiftsList>();
                XmlDataDocument xmlDoc = new XmlDataDocument();
                xmlDoc.LoadXml(xmlString);
                XmlNodeList nodes = xmlDoc.SelectNodes("items/item");
                List<int> ids = new List<int>();
                if (nodes != null)
                {
                    foreach (XmlNode item in nodes)
                    {
                        string giftIdString = item.Attributes["id"].Value.Trim();
                        string productgiftIdString = item.Attributes["productgiftid"].Value.Trim();
                        string sDate = item.Attributes["sDate"].Value.Trim() + " 00:00:00";
                        string eDate = item.Attributes["eDate"].Value.Trim() + " 23:59:59";
                        string bNumber = item.Attributes["bNumber"].Value.Trim();
                        string gNumber = item.Attributes["gNumber"].Value.Trim();

                        GiftsList gift = new GiftsList();
                        gift.gift_id = Utils.StrToInt(giftIdString, 0);
                        gift.product_gift_id = Utils.StrToInt(productgiftIdString, 0);
                        gift.start_time = Utils.IsDateTime(sDate) ? sDate : "2012-01-01 00:00:00";
                        gift.end_time = Utils.IsDateTime(eDate) ? eDate : "2012-01-01 00:00:00";

                        #region 时间
                        if (DateTime.Parse(gift.end_time) < DateTime.Parse(gift.start_time))
                        {
                            DateTime dTime = DateTime.Parse(gift.start_time);
                            gift.start_time = gift.end_time;
                            gift.end_time = dTime.ToString();
                        }
                        else if (DateTime.Parse(gift.end_time) == DateTime.Parse(gift.start_time))
                        {
                            gift.end_time = DateTime.Parse(gift.end_time).AddMinutes(10).ToString();
                        }
                        #endregion

                        gift.product_count = Utils.StrToInt(bNumber, 1);
                        gift.gift_count = Utils.StrToInt(gNumber, 1);
                        ids.Add(gift.product_gift_id);
                        list.Add(gift);
                    }
                }
                List<GiftsList> oldlist = new List<GiftsList>();
                var resgift = GetProductGift.Do(Info.product_id.ToString());
                if (resgift != null && resgift.Body != null && resgift.Body.gift_list != null)
                    oldlist = resgift.Body.gift_list;
                StringBuilder dlist = new StringBuilder();
                foreach (GiftsList item in oldlist) {
                    if (!ids.Contains(item.product_gift_id)) {
                        dlist.Append(item.product_gift_id + ",");
                    }
                }
                if (dlist.ToString().Equals(""))
                    dlist.Append("0,");
                int rVal = -1;
                    var res = OpProductGift.Do(Info.product_id, list, dlist.ToString());
                    if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                        rVal = Utils.StrToInt(res.Header.Result.Code, -1);
                if (rVal == 0)
                {
                    DoCache cache = new DoCache();
                    cache.RemoveCacheStartsWith("product-");
                    return Json(new { error = false, message = "操作成功" });
                }
            }
            catch (Exception)
            {
                return Json(new { error = true, message = "XML解析失败" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostCorrelation 保存关联推荐信息
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostCorrelation()
        {
            int productId = DoRequest.GetFormInt("productId");
            string ids = DoRequest.GetFormString("ids");
            if (!Utils.IsIdList(ids))
            {
                return Json(new { error = true, message = "参数错误" });
            }

            ProductInfo Info = new ProductInfo();
            var respro = GetProductInfo.Do(productId);
            if (respro != null && respro.Body != null)
                Info = respro.Body;
            List<ShortProductInfo> list = new List<ShortProductInfo>();
            var resspro = GetShortProductsByProductIds.Do(ids);
            if (resspro != null && resspro.Body != null && resspro.Body.product_list != null)
                list = resspro.Body.product_list;
            if (Info.product_id < 1)
            {
                return Json(new { error = true, message = "主商品不存在" });
            }
            if (list.Count < 1)
            {
                return Json(new { error = true, message = "关联商品不存在" });
            }

            int rVal = -1;
            List<RelationProductInfo> table = new List<RelationProductInfo>();
            var resrel = GetRelationRecommend.Do(Info.product_id, 1);
            if (resrel != null && resrel.Body != null && resrel.Body.relation_list != null)
                table = resrel.Body.relation_list;
            List<int> _idList = new List<int>();
            foreach (RelationProductInfo item in table)
            {
                _idList.Add(item.product_id);
            }
            List<int> pidList = new List<int>();
            foreach (ShortProductInfo p in list)
            {
                if (!_idList.Contains(p.product_id))
                    pidList.Add(p.product_id);
            }
            var res = AddRelationRecommend.Do(Info.product_id, 1, pidList);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                rVal = Utils.StrToInt(res.Header.Result.Code, -1);
            if (rVal == 0)
            {
                return Json(new { error = false, data = list, message = "操作成功" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region DeleteCorrelation 删除关联推荐
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult DeleteCorrelation()
        {
            int mainId = DoRequest.GetFormInt("mainId");
            int proId = DoRequest.GetFormInt("proId");

            int returnValue = -1;
            var res = DeleteRelationRecommend.Do(mainId, proId);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region RemoveJoinList 删除关联信息
        [HttpPost]
        public ActionResult RemoveJoinList()
        {
            string idString = DoRequest.GetFormString("visitid").Trim();

            if (string.IsNullOrEmpty(idString))
            {
                return Json(new { error = true, message = "没有选择任何项" });
            }
            int returnValue = -1;
            idString = idString + ",";
            var res = DeleteProductJoins.Do(idString);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("join");
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostProductJoinData 保存商品关联信息
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostProductJoinData()
        {
            int joinid = DoRequest.GetFormInt("JoinID");
            string name = DoRequest.GetFormString("name").Trim();
            string typeName = DoRequest.GetFormString("type").Trim();
            int allowRefresh = DoRequest.GetFormInt("allowRefresh");
            int viewType = DoRequest.GetFormInt("viewType");
            string xmlString = DoRequest.GetFormString("xml", false).Trim();

            ResponseProductJoinItem join = new ResponseProductJoinItem();
            var resjoin = GetProductJoinDetail.Do(joinid);
            if (resjoin != null && resjoin.Body != null)
                join = resjoin.Body;
             
            join.join_name = name;
            join.type_name = typeName;
            join.allow_refresh = allowRefresh;
            join.view_type = viewType;

            #region Checking
            if (string.IsNullOrEmpty(join.join_name) || join.join_name.Length < 1)
            {
                return Json(new { error = true, message = "[规则名称] 不能为空" });
            }
            if (join.join_name.Length > 200)
            {
                return Json(new { error = true, message = "[规则名称] 不能超过200个字符" });
            }
            if (join.type_name.Length < 1)
            {
                return Json(new { error = true, message = "[规则类别] 不能为空" });
            }
            #endregion

            #region 商品SKU
            
            List<ProductJoinItemInfo> updateList = new List<ProductJoinItemInfo>();
            List<long> idList = new List<long>();
            bool isError = false;
            string errorText = "";
            try
            {
                XmlDataDocument xmlDoc = new XmlDataDocument();
                xmlDoc.LoadXml(xmlString);
                XmlNodeList nodes = xmlDoc.SelectNodes("items/item");
                if (nodes != null)
                {
                    #region SKU内容
                    foreach (XmlNode item in nodes)
                    {
                        ProductJoinItemInfo em = new ProductJoinItemInfo();
                        string itemidString = item.Attributes["itemid"].Value.Trim();
                        if (Utils.IsInt(itemidString))
                            em.join_item_id = int.Parse(itemidString);
                        em.product_id = Utils.StrToInt(item.Attributes["productid"].Value.Trim());
                        em.sort_no = Utils.StrToInt(item.Attributes["sort"].Value.Trim());
                        em.item_name = item.SelectSingleNode("name").InnerText.Trim();

                        if (em.product_id < 1 || string.IsNullOrEmpty(em.item_name) || em.item_name.Length > 20)
                        {
                            isError = true;
                            errorText = "参数错误，无法正确读取商品信息";
                            if (em.item_name.Length < 1)
                                errorText = "[显示标题] 不能为空";
                            else if (em.item_name.Length > 16)
                                errorText = "[显示标题] 不能超过16个字符";

                            break;
                        }
                    
                        updateList.Add(em);//更新
                        idList.Add(em.join_item_id);
                    }
                    #endregion
                }

            }
            catch (Exception)
            {
                return Json(new { error = true, input = "message", message = "Xml解析失败..." });
            }
            if (isError)
            {
                return Json(new { error = true, message = errorText });
            }
            #endregion

            if (updateList.Count < 2)
            {
                return Json(new { error = true, message = "关联商品不能小于2个" });
            }
           
            List<ProductJoinItemInfo> oldList = join.join_item_list;
            if(oldList == null)
                oldList = new List<ProductJoinItemInfo>();
            StringBuilder deleteIds = new StringBuilder();
            //deleteIds.Append("0,");//需要删除的SKU

            foreach (ProductJoinItemInfo em in oldList)
            {
                if (!idList.Contains(em.join_item_id))
                {
                    deleteIds.Append(em.join_item_id + ",");
                }
            }
            if (deleteIds.ToString().Equals("")) {
                deleteIds.Append("0,");
            }

            foreach(ProductJoinItemInfo em in updateList){
                ProductInfo product = new ProductInfo();
                var respro = GetProductInfo.Do(em.product_id);
                if (respro != null && respro.Body != null)
                    product = respro.Body;
                if(em.join_item_id == 0 && product.product_join_id > 0)
                    return Json(new { error = true, message = "商品"+ product.product_name +"已被关联！" });
            }

            var skunum = updateList[0].sku_count;
            for (int i = 1; i < updateList.Count;i++ )
            {
                if ((skunum > 0 && updateList[i].sku_count == 0) || (skunum == 0 && updateList[i].sku_count > 0)) {
                    return Json(new { error = true, message = "含有Sku的商品不能和不含Sku的商品关联！" });
                }

            }

            int returnValue = -1;
            if (updateList.Count > 0)
                join.join_item_list = updateList;
            var ress = OpProductJoin.Do(join, deleteIds.ToString());
            if(ress==null || ress.Header==null || ress.Header.Result == null || ress.Header.Result.Code == null)
                return Json(new { error = true, message = "操作失败" });
            returnValue = Utils.StrToInt(ress.Header.Result.Code,-1);//更新
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("join");
                return Json(new { error = false, message = "操作成功!" });
            }
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region RemoveAssembleList 删除套装
        [HttpPost]
        public ActionResult RemoveAssembleList()
        {
            string idString = DoRequest.GetFormString("visitid").Trim() + ",";

            if (string.IsNullOrEmpty(idString))
            {
                return Json(new { error = true, message = "没有选择任何项" });
            }
            int returnValue = -1;
            var res= DeleteAssembles.Do(idString);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);

            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("assemble");
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region RemoveFareTemplate 删除运费模板
        [HttpPost]
        public ActionResult RemoveFareTemplate()
        {
            int tempid = DoRequest.GetFormInt("tempid");

            if (tempid<1)
            {
                return Json(new { error = true, message = "没有选择任何项" });
            }
            int returnValue = -1;

            var res = DeleteFareTemplate.Do(tempid);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);

            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCache("templist");
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostAssembleData 保存组合套装信息
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostAssembleData()
        {
            int assid = DoRequest.GetFormInt("assid");
            ResponseProductAssemble assemble = new ResponseProductAssemble();
            var resas = QueryProductAssembleDetail.Do(assid);
            if (resas != null && resas.Body != null) {
                assemble = resas.Body;
            }

            List<AssembleProduct> itemproduct = assemble.item_product_list;
            if (itemproduct == null)
                itemproduct = new List<AssembleProduct>();

            assemble.ass_subject = DoRequest.GetFormString("name");
            assemble.ass_summary = DoRequest.GetFormString("summary");
            assemble.ass_type = DoRequest.GetFormInt("AssType");
            assemble.start_time = DoRequest.GetFormString("starttime");
            assemble.end_time = DoRequest.GetFormString("endtime");

            #region Checking
            if (assemble.ass_subject.Length < 1)
            {
                return Json(new { error = true, message = "[名称] 不能为空" });
            }
            if (assemble.ass_subject.Length > 200)
            {
                return Json(new { error = true, message = "[名称] 不能大于200个字符" });
            }
            if (assemble.ass_summary.Length > 800)
            {
                return Json(new { error = true, message = "[备注] 不能大于800个字符" });
            }
            if (assemble.start_time.Length < 1)
            {
                return Json(new { error = true, message = "[开始时间] 不能为空" });
            }
            if (assemble.end_time.Length < 1)
            {
                return Json(new { error = true, message = "[结束时间] 不能为空" });
            }
            #endregion

            string mainIds = DoRequest.GetFormString("main").Trim();
            #region 主商品ID
            if (!Utils.IsIdList(mainIds))
            {
                return Json(new { error = true, message = "[主商品] 不能为空" });
            }
            #endregion

            List<OpAssembleInfo> asseItem = new List<OpAssembleInfo>();
            bool isError = false;
            string errorText = "";
            string xmlString = DoRequest.GetFormString("xml", false);
            List<int> itemids = new List<int>();
            #region 套装商品
            try
            {
                XmlDataDocument xmlDoc = new XmlDataDocument();
                xmlDoc.LoadXml(xmlString);
                XmlNodeList nodes = xmlDoc.SelectNodes("items/item");
                if (nodes != null)
                {
                    #region 规则
                    int ii = 0;
                    foreach (XmlNode item in nodes)
                    {
                        ii++;
                        OpAssembleInfo em = new OpAssembleInfo();
                        em.sort_no = ii.ToString();//1458000 300/88
                        //em.sku_id = Utils.StrToInt(item.Attributes["skuid"].Value).ToString();
                        em.ass_item_id = Utils.StrToInt(item.Attributes["itemid"].Value).ToString();
                        em.product_id = Utils.StrToInt(item.Attributes["proid"].Value).ToString();
                        foreach (AssembleProduct pro in itemproduct) {
                             if ((int.Parse(em.product_id)) == pro.product_id)
                                em.ass_item_id = pro.ass_item_id.ToString();
                        }
                        itemids.Add(int.Parse(em.ass_item_id));
                        string priceString = item.Attributes["price"].Value;
                        em.promotion_price = (Utils.IsNumber(priceString) ? decimal.Parse(priceString) : 0).ToString();
                        asseItem.Add(em);
                    }
                    #endregion
                }

            }
            catch (Exception)
            {
                return Json(new { error = true, input = "message", message = "解析 [XML] 失败..." });
            }
            if (isError)
            {
                return Json(new { error = true, input = "message", message = errorText });
            }
            #endregion

            if (asseItem.Count < 1)
            {
                return Json(new { error = true, message = "[搭配商品] 必须包含1个或1个以上" });
            }
            string[] arr = mainIds.Split(',');
            List<int> idList = new List<int>();
            foreach (string s in arr)
            {
                idList.Add(Utils.StrToInt(s));
            }
            foreach (OpAssembleInfo em in asseItem)
            {
                if (idList.Contains(int.Parse(em.product_id)))
                {
                    return Json(new { error = true, message = "[搭配商品] 不能包含主商品" });
                }
            }
            List<MainProduct> mainproduct = assemble.main_product_list;
            if (mainproduct == null)
                mainproduct = new List<MainProduct>();
            string delmainids = "";
            foreach (MainProduct item in mainproduct) {
                if (!idList.Contains(item.product_id))
                    delmainids += item.ass_main_id + ",";
            }
           
            string delitemids = "";
            foreach (AssembleProduct item in itemproduct) {
                if (!itemids.Contains(item.ass_item_id))
                    delitemids += item.ass_item_id + ",";
            }
            if (delitemids.Equals("")) {
                delitemids = "0,";
            }
            if (delmainids.Equals(""))
            {
                delmainids = "0,";
            }
            int returnValue = -1;
            var res = OpProductAssemble.Do(assemble, mainIds, asseItem, delitemids, delmainids);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("assemble");
                return Json(new { error = false, message = "操作成功!" });
            }
            return Json(new { error = true, message = "操作失败!"});
        }
        #endregion

        #region PostFareTemplate 保存运费模板
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostFareTemplate()
        {
            int tempid = DoRequest.GetFormInt("tempid");
             
            FareTempInfo temp = new FareTempInfo();
            if (tempid != -1)
            {
                var restemp = GetFareTempList.Do(tempid);//模板信息
                if (restemp != null && restemp.Body != null && restemp.Body.fare_temp_list != null && restemp.Body.fare_temp_list[0] != null)
                    temp = restemp.Body.fare_temp_list[0];
            }
            if (temp.template_id != tempid)
            {
                temp = new FareTempInfo();
                temp.is_system = 0;
            }
            temp.template_name = DoRequest.GetFormString("name");
            temp.template_priority = DoRequest.GetFormInt("level");
            temp.first_weight = DoRequest.GetFormInt("firstWeight");
            temp.min_free_price = DoRequest.GetFormDecimal("minFreePrice");
            temp.continue_weight = DoRequest.GetFormInt("continuedHeavy");
            temp.template_state = DoRequest.GetFormInt("TempState");
            temp.template_remark = DoRequest.GetFormString("remarks");

            #region Checking
            if (temp.template_name.Length < 1)
            {
                return Json(new { error = true, message = "[名称] 不能为空" });
            }
            if (temp.template_name.Length > 100)
            {
                return Json(new { error = true, message = "[名称] 不能大于200个字符" });
            }
            if (temp.template_priority < 0 && temp.is_system < 1)
            {
                return Json(new { error = true, message = "[优先级] 不能小于0" });
            }
            if (temp.first_weight < 0)
            {
                return Json(new { error = true, message = "[首重] 不能小于0" });
            }
            if (temp.continue_weight < 1)
            {
                return Json(new { error = true, message = "[续重] 不能小于1" });
            }
            #endregion

            List<FareRuleInfo> oldrules = new List<FareRuleInfo>();
            if (temp.template_id != 0)
            {
                var resfa = GetFareRulesByTempId.Do(temp.template_id);
                if (resfa != null && resfa.Body != null && resfa.Body.rule_list != null)
                {
                    oldrules = resfa.Body.rule_list;
                }
            }
            List<int> oldids = new List<int>();
            StringBuilder delids = new StringBuilder();
            foreach (FareRuleInfo item in oldrules) {
                oldids.Add(item.rule_id);
            }
            List<int> idlist = new List<int>();
            List<FareRuleInfo> rules = new List<FareRuleInfo>();
            bool isError = false;
            string errorText = "";
            string xmlString = DoRequest.GetFormString("xml", false);
            #region 运费规则
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
                        FareRuleInfo rule = new FareRuleInfo();
                        int ruleId = int.Parse(item.Attributes["ruleid"].Value.Trim());
                        idlist.Add(ruleId);
                        rule.rule_id = ruleId;
                        string minFreeString = item.Attributes["minFreePrice"].Value.Trim();
                        
                        decimal minFreePrice = Utils.IsNumber(minFreeString) ? decimal.Parse(minFreeString) : 0m;
                        
                        if (minFreePrice < 0) minFreePrice = temp.min_free_price;
                        rule.min_free_price = minFreePrice;
                        rule.rule_remark = item.SelectSingleNode("text").InnerText.Trim();
                        #region 普通快递
                        XmlNode express = item.SelectSingleNode("express");
                        rule.express_allow = 0;
                        int expressAllow = Utils.StrToInt(express.Attributes["allow"].Value.Trim());
                        if (expressAllow > 0)
                        {
                            string firstPriceString = express.Attributes["firstPrice"].Value.Trim();
                            string continuedPriceString = express.Attributes["continuedPrice"].Value.Trim();
                            rule.express_allow = 1;
                            rule.express_first_price = Utils.IsNumber(firstPriceString) ? decimal.Parse(firstPriceString) : 0m;
                            rule.express_continue_price = Utils.IsNumber(continuedPriceString) ? decimal.Parse(continuedPriceString) : 0m;

                            if (decimal.Parse(firstPriceString) < 0 || decimal.Parse(continuedPriceString) < 0)
                            {
                                isError = true;
                                errorText = "[运费] 不能为负数";
                            }
                        }
                        #endregion

                        #region EMS
                        XmlNode ems = item.SelectSingleNode("ems");
                        rule.ems_allow = 0;
                        int emsAllow = Utils.StrToInt(ems.Attributes["allow"].Value.Trim());
                        if (emsAllow > 0)
                        {
                            string firstPriceString = ems.Attributes["firstPrice"].Value.Trim();
                            string continuedPriceString = ems.Attributes["continuedPrice"].Value.Trim();
                            rule.ems_allow = 1;
                            rule.ems_first_price = Utils.IsNumber(firstPriceString) ? decimal.Parse(firstPriceString) : 0m;
                            rule.ems_continue_price = Utils.IsNumber(continuedPriceString) ? decimal.Parse(continuedPriceString) : 0m;

                            if (decimal.Parse(firstPriceString) < 0 || decimal.Parse(continuedPriceString) < 0)
                            {
                                isError = true;
                                errorText = "[运费] 不能为负数";
                            }
                        }
                        #endregion

                        #region 加急件
                        XmlNode urgent = item.SelectSingleNode("urgent");
                        rule.urgent_allow = 0;
                        int urgentAllow = Utils.StrToInt(urgent.Attributes["allow"].Value.Trim());
                        if (urgentAllow > 0)
                        {
                            string firstPriceString = urgent.Attributes["firstPrice"].Value.Trim();
                            string continuedPriceString = urgent.Attributes["continuedPrice"].Value.Trim();
                            rule.urgent_allow = 1;
                            rule.urgent_first_price = Utils.IsNumber(firstPriceString) ? decimal.Parse(firstPriceString) : 0m;
                            rule.urgent_continue_price = Utils.IsNumber(continuedPriceString) ? decimal.Parse(continuedPriceString) : 0m;

                            if (decimal.Parse(firstPriceString) < 0 || decimal.Parse(continuedPriceString) < 0)
                            {
                                isError = true;
                                errorText = "[运费] 不能为负数";
                            }
                        }
                        #endregion

                        #region 货到付款
                        XmlNode cod = item.SelectSingleNode("cod");
                        rule.cod_allow = 0;
                        int codAllow = Utils.StrToInt(cod.Attributes["allow"].Value.Trim());
                        if (codAllow > 0)
                        {
                            string firstPriceString = cod.Attributes["firstPrice"].Value.Trim();
                            string continuedPriceString = cod.Attributes["continuedPrice"].Value.Trim();
                            rule.cod_allow = 1;
                            rule.cod_first_price = Utils.IsNumber(firstPriceString) ? decimal.Parse(firstPriceString) : 0m;
                            rule.cod_continue_price = Utils.IsNumber(continuedPriceString) ? decimal.Parse(continuedPriceString) : 0m;

                            if (decimal.Parse(firstPriceString) < 0 || decimal.Parse(continuedPriceString) < 0)
                            {
                                isError = true;
                                errorText = "[运费] 不能为负数";
                            }
                        }
                        #endregion

                        XmlNodeList areas = item.SelectNodes("areas/area");
                        if (areas == null || areas.Count < 1)
                        {
                            isError = true;
                            errorText = "[配送地区] 为必选项";
                            continue;
                        }
                        #region 区域
                        List<RuleItemArea> ruleItems = new List<RuleItemArea>();
                        foreach (XmlNode area in areas)
                        {
                            RuleItemArea em = new RuleItemArea();

                            string areaIdString = area.Attributes["id"].Value.Trim();
                            em.area_id = Utils.IsInt(areaIdString) ? int.Parse(areaIdString) : 0;
                            
                            ruleItems.Add(em);
                        }
                        #endregion

                        rule.rule_item_list = ruleItems;

                        if (rule.rule_remark.Length > 800)
                        {
                            isError = true;
                            errorText = "[配送说明] 字符不能超过800个字";
                        }
    
                        
                        rules.Add(rule);
                    }
                    #endregion
                }

            }
            catch (Exception)
            {
                return Json(new { error = true, input = "message", message = "解析 [运费规则] 失败..." });
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

            if (delids.ToString().Equals("")) { 
                delids.Append("0,");
            }
            int returnValue = -1;
            var res = OpFareTemplate.Do(temp, rules, delids.ToString());
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCache("templist");
                return Json(new { error = false, message = "操作成功", data = rules });
            }
            return Json(new { error = true, message = "操作失败", data = rules });
        }
        #endregion

        #region ResetBrandState 修改品牌状态
        [HttpPost]
        public ActionResult ResetBrandStatus()
        {
            int id = DoRequest.GetFormInt("id");
            int status = DoRequest.GetFormInt("state");
            int returnValue = -1;
            var res = ResetBrandState.Do(id, status);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("brand");
                return Json(new { error = false, message = "操作成功" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region RemoveBrand 删除品牌
        [HttpPost]
        public ActionResult RemoveBrand()
        {
            string idString = DoRequest.GetFormString("visitid").Trim();

            if (string.IsNullOrEmpty(idString))
            {
                return Json(new { error = true, message = "没有选择任何项" });
            }
            //idString = idString + ",";
            int returnValue = -1;
            var res = DeleteBrand.Do(idString);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("brand");
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostBrandData 保存品牌
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostBrandData()
        {
            BrandInfo info = new BrandInfo();
         
            int brandid = DoRequest.GetFormInt("brandid", 0);
            string name = DoRequest.GetFormString("brandName");
            string intro = DoRequest.GetFormString("intro");
            int brandstate = DoRequest.GetFormInt("brandstate", 0);
            string logosrc = DoRequest.GetFormString("logosrc");

            info.brand_id = brandid;
            info.brand_name = name;
            info.brand_intro = intro;
            info.logo_src = logosrc;
            info.brand_state = brandstate;
            info.sort_no = 0;

            string xmlString = DoRequest.GetFormString("xml", false);
            List<BrandAuthInfo> items = new List<BrandAuthInfo>();
            List<int> newids = new List<int>();
            string delids = "";
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
                        BrandAuthInfo citem = new BrandAuthInfo();

                        citem.brand_auth_id = int.Parse(item.Attributes["authid"].Value.Trim());

                        if (citem.brand_auth_id > 0) {
                            newids.Add(citem.brand_auth_id);
                        }

                        citem.authorization_src = item.Attributes["authorizationsrc"].Value.Trim();
                        citem.expired_time = item.Attributes["time"].Value.Trim();
                        citem.shop_id = int.Parse(item.Attributes["shopid"].Value.Trim());
                        items.Add(citem);
                    }

                    List<BrandAuthInfo> olditems = new List<BrandAuthInfo>();
                    var resitem = GetBrandDetail.Do(info.brand_id);
                    if (resitem != null && resitem.Body != null && resitem.Body.auth_list != null)
                    {
                        olditems = resitem.Body.auth_list;
                    }
                    int _count = 0;
                    foreach (BrandAuthInfo em in olditems)
                    {
                        if (!newids.Contains(em.brand_auth_id))
                        {
                            if (_count == 0)
                            {
                                delids = em.brand_auth_id.ToString();
                            }
                            else
                            {
                                delids = delids + "," + em.brand_auth_id;
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

            info.auth_list = items;

            int returnValue = -1;
            var res = OpBrand.Do(info,delids);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("brand");
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败！" });
        }
        #endregion

        #region SearchShop 搜索商家
        [HttpPost]
        public ActionResult SearchShop()
        {
            List<ShopList> shopList = new List<ShopList>();
            DoCache chche = new DoCache();
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

            List<ShopList> shopList2 = new List<ShopList>();
            shopList2 = shopList.FindAll(delegate(ShopList item) { return item.shop_state == 0; });
            List<BrandInfo> brandlist2 = new List<BrandInfo>();
            brandlist2 = brandlist.FindAll(delegate(BrandInfo item) { return item.brand_state == 0; });
            return Json(new { error = false, list1 = shopList2, list2 = brandlist2 });
        }
        #endregion

        #region GiftCounterCheck 赠品反查
        [HttpPost]
        public ActionResult GiftCounterCheck()
        {
            int productid = DoRequest.GetFormInt("productid", 0);
            List<ShortProductInfo> list = new List<ShortProductInfo>();
            int _count = 0;
            var res = QueryProductByGiftId.Do(productid);
            if (res != null && res.Body != null) {
                list = res.Body.product_list;
                _count = Utils.StrToInt(res.Body.rec_num, 0);
            }
            
            return Json(new { error = false, list = list, count = _count });
        }
        #endregion

        #region CheckProduct_Code 检验商品编码
        [HttpPost]
        public ActionResult CheckProduct_Code()
        {
            string productcode = DoRequest.GetFormString("code");
            int returnVal = -1;
            var res = CheckProductCode.Do(productcode);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
            {
                returnVal = Utils.StrToInt(res.Header.Result.Code, -1);
            }
            if (returnVal == 0) {
                return Json(new { error = false });
            }
            return Json(new { error = true, message="编码不存在，请核实！" });
        }
        #endregion
    }
}
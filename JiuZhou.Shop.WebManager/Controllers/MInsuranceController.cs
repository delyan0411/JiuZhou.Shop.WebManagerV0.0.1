using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using JiuZhou.ControllerBase;
using JiuZhou.MySql;
using JiuZhou.HttpTools;
using JiuZhou.Common;

namespace JiuZhou.Shop.WebManager.Controllers
{
    [HandleError]
    public class MInsuranceController : ForeSysBaseController
    {
        #region 商保管理
        #region Editor
        public ActionResult Editor()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,611,612,614,"))
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
        #region PostInsuranceData 
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostInsuranceData()
        {
            int insurance_id = DoRequest.GetFormInt("insurance_id");
            string insurance_name = DoRequest.GetFormString("insurance_name").Trim();
            int paytype = DoRequest.GetFormInt("paytype");
            #region Checking
            if (insurance_name.Length < 1)
            {
                return Json(new { error = true, message = "【名称】商保不能为空" });
            }
            if (paytype == 0)
            {
                return Json(new { error = true, message = "请选择【支付方式】" });
            }
            #endregion
            int returnValue = -1;
            var res = OpInsuranceInfo.Do(insurance_id,insurance_name, paytype);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);  
            
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion
        #region List
        public ActionResult List()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,611,612,613,"))
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

            int pagesize = DoRequest.GetQueryInt("size", 10);
            int pageindex = DoRequest.GetQueryInt("page", 1);
            //string q = DoRequest.GetQueryString("q");
            //string sKey = q;

            #region 商保列表
            int dataCount = 0;
            int pageCount = 0;
            List<InsuranceInfo> _table = new List<InsuranceInfo>();
            var res = QueryInsuranceList.Do(pagesize, pageindex, ref dataCount, ref pageCount);
            if (res != null && res.Body != null && res.Body.insurance_list != null)
                _table = res.Body.insurance_list;
            ViewData["infoList"] = _table;//商保列表

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/minsurance/list?");
            currPageUrl.Append("&size=" + pagesize);
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
        #endregion
        #region 商保人员类型
        #region TypeList
        public ActionResult TypeList()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,611,612,613,"))
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
            int insurancetype = DoRequest.GetQueryInt("insurancetype", 0);
            int pagesize = DoRequest.GetQueryInt("size", 4);
            int pageindex = DoRequest.GetQueryInt("page", 1);
            //string q = DoRequest.GetQueryString("q");
            //string sKey = q;

            #region 商保列表
            int dataCount = 0;
            int pageCount = 0;
            List<InsurancetypeInfo> _table = new List<InsurancetypeInfo>();
            var res = QueryInsuranceTypeList.Do(pagesize, pageindex, insurancetype, ref dataCount, ref pageCount);
            if (res != null && res.Body != null && res.Body.insusertype_list != null)
                _table = res.Body.insusertype_list;
            ViewData["infoList"] = _table;//商保用户类别列表

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/minsurance/Typelist?");
            currPageUrl.Append("insurance_id=" + insurancetype);
            currPageUrl.Append("&size=" + pagesize);
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
        #region TypeEditor
        public ActionResult TypeEditor()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,611,612,613,"))
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
        #region PostInsuranceTypeData 
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostInsuranceTypeData()
        {
            int id = DoRequest.GetFormInt("id");
            int insurancetype = DoRequest.GetFormInt("insurancetype");
            string usertype = DoRequest.GetFormString("usertype");
            #region Checking
            if (usertype.Length < 1)
            {
                return Json(new { error = true, message = "【名称】用户类别不能为空" });
            }
            #endregion
            int returnValue = -1;
            var res = OpInsuranceTypeInfo.Do(id, insurancetype, usertype);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);

            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion
        #region DeleteInsType 删除
        [HttpPost]
        public ActionResult DeleteInsTypeAction()
        {
            int id = DoRequest.GetFormInt("id");
            if (id == 0)
            {
                return Json(new { error = true, message = "参数错误" });
            }
            //判断是否存在 如果存在就修改 不存在就添加
            int returnValue = -1;
            var res = DeleteInsType.Do(id);
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
        #region  商保商品管理
        #region ProductEditor
        public ActionResult ProductEditor()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,611,612,613,"))
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
        #region Get
        public ActionResult GetInsProduct()
        {
            int id = DoRequest.GetFormInt("id");

            List<InsProItem> InfoProlist = new List<InsProItem>();
            List<InsTypeItem> InfoTypelist = new List<InsTypeItem>();
            var resp = QueryInsProduct.Do(id);
            //if (resp != null && resp.Body != null&& resp.Body.ins_pro_list != null && resp.Body.ins_type_list != null)
            //{
            InfoProlist = resp.Body.insproduct_list;
            InfoTypelist = resp.Body.instype_list;
            //}
            return Json(new { error = false, datapro = InfoProlist, datatype = InfoTypelist }, JsonRequestBehavior.AllowGet);
        }
        #endregion
        #region PostInsuranceProductData 
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostInsuranceProductData()
        {          
            int id = DoRequest.GetFormInt("id");
            string itemproidstring = DoRequest.GetFormString("proids").Trim();
            string itemtypeidstring = DoRequest.GetFormString("typeids").Trim();
            List<InsProItem> oldproitems = new List<InsProItem>();
            List<InsTypeItem> oldtypeitems = new List<InsTypeItem>();
            var res = QueryInsProduct.Do(id);
            if (res != null && res.Body != null)
            {
                if (res.Body.insproduct_list != null)
                    oldproitems = res.Body.insproduct_list;
                if (res.Body.instype_list != null)
                    oldtypeitems = res.Body.instype_list;
            }
            List<int> oldproids = new List<int>();

            string[] itemproids = itemproidstring.Split(',');

            List<int> itemproids2 = new List<int>();

            string delids = "";
            string addids = "";
            foreach (InsProItem item in oldproitems)
            {
                oldproids.Add(Convert.ToInt32(item.product_id));
            }

            int _count = 0;
            //新增的proID
            if (!itemproidstring.Equals(""))
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
            #region
            //List<InsProItem> sitems = new List<InsProItem>();
            //for (int i = 0; i < itemproids2.Count; i++)
            //{
            //    InsProItem sitem = new InsProItem();
            //    sitem.id = "0";
            //    sitem.product_id = itemproids2[i].ToString();
            //    if (oldproids.Contains(itemproids2[i]))
            //    {
            //        foreach (InsProItem item in oldproitems)
            //        {
            //            if (item.product_id == itemproids2[i].ToString())
            //                sitem.id = item.id;
            //        }
            //    }
            //    sitems.Add(sitem);
            //}
            #endregion
            _count = 0;
            ////删除的proID "add_proids":"50178,60935,,,,,,,,"
            foreach (InsProItem item in oldproitems)
            { 
                if (!itemproids2.Contains(Convert.ToInt32(item.product_id)))
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
            List<int> oldtypeids = new List<int>();
            string[] itemtypeids = itemtypeidstring.Split(',');
            List<int> itemtypeids2 = new List<int>();
            string deltypeids = "";
            string addtypeids = "";
            foreach (InsTypeItem item in oldtypeitems)
            {
                oldtypeids.Add(Convert.ToInt32(item.product_type_id));
            }
            _count = 0;
            //新增的typeID            
            //"addtypeids":"7816220116123818845848"
            if (!itemtypeidstring.Equals(""))
            {
                for (int i = 0; i < itemtypeids.Length; i++)
                {
                    itemtypeids2.Add(Utils.StrToInt(itemtypeids[i], 0));
                    if (!oldtypeids.Contains(Utils.StrToInt(itemtypeids[i], 0)))
                    {
                        if (_count > 0) addtypeids += ",";
                        addtypeids += Utils.StrToInt(itemtypeids[i], 0);
                        _count++;
                    }
                }
            }
            _count = 0;
            //删除的typeID
            foreach (InsTypeItem item in oldtypeitems)
            {
                if (!itemtypeids2.Contains(Convert.ToInt32(item.product_type_id)))
                {
                    if (_count == 0)
                    {
                        deltypeids = item.product_type_id.ToString();
                    }
                    else
                    {
                        deltypeids = deltypeids + "," + item.product_type_id;
                    }
                    _count++;
                }
            }
            int returnVal = -1;
            var res1 = OpInsProductInfo.Do(id, addids, delids, addtypeids, deltypeids);
            if (res1 != null && res1.Header != null && res1.Header.Result != null && res1.Header.Result.Code != null)
                returnVal = Utils.StrToInt(res1.Header.Result.Code, -1);
            if (returnVal == 0)
            {
                return Json(new { error = false, message = "操作成功" });
            }
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion
        #endregion
    }
}

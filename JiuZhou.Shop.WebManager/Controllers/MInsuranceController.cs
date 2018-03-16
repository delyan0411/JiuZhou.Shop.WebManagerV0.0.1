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

            int pagesize = DoRequest.GetQueryInt("size", 4);
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
    }
}

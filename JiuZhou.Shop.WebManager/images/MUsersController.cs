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
    public class MUsersController : ForeSysBaseController
    {
        #region 商家列表 ShopList
        public ActionResult ShopList()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,101,198,"))
                {
                    currResBody = item;
                    break;
                }
            }

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            int pagesize = DoRequest.GetQueryInt("size", 60);
            int pageindex = DoRequest.GetQueryInt("page", 1);
            string q = DoRequest.GetQueryString("q");
            int dataCount = 0;
            int pageCount = 0;
            List<ShortShopInfo> infoList = QueryShopList.Do(pagesize, pageindex, q, ref dataCount, ref pageCount).Body.shop_list;

            ViewData["infoList"] = infoList;//数据列表

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/musers/shoplist?");
            currPageUrl.Append("&size=" + pagesize);
            currPageUrl.Append("&page=" + pageindex);
            currPageUrl.Append("&q=" + DoRequest.UrlEncode(q));
            ViewData["currPageUrl"] = currPageUrl;//当前页面的URL
            ViewData["pagesize"] = pagesize;
            ViewData["pageindex"] = pageindex;
            ViewData["dataCount"] = dataCount;

            ViewData["pageIndexLink"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());
            ViewData["pageIndexLink2"] = this.FormatPageIndex(dataCount, pagesize, pageindex, currPageUrl.ToString());

            return View();
        }
        #endregion

        #region ShopEditor
        public ActionResult ShopEditor()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,101,199,"))
                {
                    currResBody = item;
                    break;
                }
            }

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            int shopid = DoRequest.GetQueryInt("shopid");
            ShopInfo shop = null;
            if (shopid == 0)
            {
                shop = new ShopInfo();
            }
            else
            {
                shop = GetShopDetail.Do(shopid).Body;
            }
            ViewData["shop"] = shop;

            return View();
        }
        #endregion
        #region PostShopData 保存商家信息
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostShopData()
        {
            int shopid = DoRequest.GetFormInt("shopid");
            ShopInfo shop = GetShopDetail.Do(shopid).Body;
            shop.shop_name = DoRequest.GetFormString("shopName");
            shop.company_name = DoRequest.GetFormString("Company");
            shop.shop_key = DoRequest.GetFormString("keyword");
            shop.shop_pswd = DoRequest.GetFormString("psword");

            int province = DoRequest.GetFormInt("province");
            int city = DoRequest.GetFormInt("city");
            shop.area_id = province;
            shop.shop_addr = GetArea.Do(province).Body.area_list[0].area_name;
            string cityName = GetArea.Do(city).Body.area_list[0].area_name;
            if (!cityName.StartsWith("市辖") && !cityName.StartsWith("直辖"))
            {
                shop.shop_addr += cityName;
            }
            shop.link_way = DoRequest.GetFormString("linkway");
            shop.shop_remark = DoRequest.GetFormString("remarks");

            #region Checking
            if (shop.shop_name.Length < 1)
            {
                return Json(new { error = true, message = "[名称] 不能为空" });
            }
            if (shop.shop_name.Length > 50)
            {
                return Json(new { error = true, message = "[名称] 不能大于50个字符" });
            }
            if (shop.company_name.Length < 0 && shop.company_name.Length > 100)
            {
                return Json(new { error = true, message = "[公司] 不能为空或大于100个字符" });
            }
            if (shop.area_id < 0)
            {
                return Json(new { error = true, message = "[发货地址] 不能为空" });
            }
            #endregion

            int returnValue = -1;

            returnValue = int.Parse(OpShopInfo.Do(shop).Header.Result.Code);

            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功" });
            }
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion


    }
}

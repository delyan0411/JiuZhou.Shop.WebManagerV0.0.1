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
                if (item.res_path.Equals("0,1,107,119,123,"))
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

            int pagesize = DoRequest.GetQueryInt("size", 60);
            int pageindex = DoRequest.GetQueryInt("page", 1);
            string q = DoRequest.GetQueryString("q");
            int dataCount = 0;
            int pageCount = 0;
            List<ShortShopInfo> infoList = null;
            var resp = QueryShopList.Do(pagesize, pageindex, q, ref dataCount, ref pageCount);
            if (resp == null || resp.Body == null || resp.Body.shop_list == null)
            {
                infoList = new List<ShortShopInfo>();
            }
            else {
                infoList = resp.Body.shop_list;
            }

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
                if (item.res_path.Equals("0,1,107,119,199,"))
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

            int shopid = DoRequest.GetQueryInt("shopid");
            ShopInfo shop = null;
            if (shopid == 0)
            {
                shop = new ShopInfo();
            }
            else
            {
                shop = new ShopInfo();
                var resshop = GetShopDetail.Do(shopid);
                if (resshop != null && resshop.Body != null)
                    shop = resshop.Body;
            }
            ViewData["shop"] = shop;

            return View();
        }
        #endregion

        #region 用户列表 UserList
        public ActionResult UserList()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,107,118,121,"))
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

            int pagesize = DoRequest.GetQueryInt("size", 60);
            int pageindex = DoRequest.GetQueryInt("page", 1);
            string q = DoRequest.GetQueryString("q");
            int state = DoRequest.GetQueryInt("state",-1);
            int usertype = DoRequest.GetQueryInt("usertype", -1);
            DateTime date = DateTime.Now.AddYears(-3);
            DateTime sDate = DoRequest.GetQueryDate("sDate", date);
            DateTime eDate = DoRequest.GetQueryDate("eDate", DateTime.Now);
            int dataCount = 0;
            int pageCount = 0;
            List<ShortUserInfo> infoList = new List<ShortUserInfo>();
            DoCache cache = new DoCache();
            string cachekey = "user-QueryUserListindex=" + pageindex + "state=" + state + "type=" + usertype + "sdate=" + sDate.ToString("yyyy-MM-dd") + "edate=" + eDate.ToString("yyyy-MM-dd") + "q=" + q;
            if (cache.GetCache(cachekey) == null)
            {
                var resp = QueryUserList.Do(pagesize, pageindex, state, usertype, sDate.ToString("yyyy-MM-dd 00:00:00"), eDate.ToString("yyyy-MM-dd 23:59:59"), q, ref dataCount, ref pageCount);
                if (resp != null && resp.Body != null && resp.Body.user_list != null)
                {
                    infoList = resp.Body.user_list;
                    cache.SetCache(cachekey, infoList, 300);
                    cache.SetCache("userdatacount", dataCount, 300);
                    if (infoList.Count == 0)
                        cache.RemoveCache(cachekey);
                }
            }
            else {
                infoList = (List<ShortUserInfo>)cache.GetCache(cachekey);
                dataCount = (int)cache.GetCache("userdatacount");
            }

            ViewData["infoList"] = infoList;//数据列表

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/musers/userlist?");
            currPageUrl.Append("&size=" + pagesize);
            currPageUrl.Append("&page=" + pageindex);
            currPageUrl.Append("&q=" + DoRequest.UrlEncode(q));
            currPageUrl.Append("&state=" + state);
            currPageUrl.Append("&usertype=" + usertype);
            currPageUrl.Append("&sdate=" + sDate.ToString("yyyy-MM-dd"));
            currPageUrl.Append("&edate=" + eDate.ToString("yyyy-MM-dd"));
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
                if (item.res_path.Equals("0,1,107,118,121,"))
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

            int userid = DoRequest.GetQueryInt("uid");
            UserInfo user = null;
            if (userid == 0)
            {
                user = new UserInfo();
            }
            else
            {
                user = new UserInfo();
                var resuser = GetUserDetail.Do(userid);
                if (resuser != null && resuser.Body != null)
                    user = resuser.Body;
            }
            ViewData["userinfo"] = user;

            return View();
        }
        #endregion

        #region Receive
        public ActionResult Receive()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,107,234,235,"))
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

            string phone = DoRequest.GetQueryString("q");
            
            List<AdressInfo> adress = new List<AdressInfo>();
            if (phone != null && !phone.Equals(""))
            {
                var res = GetReceiveAddrByMobileNo.Do(phone);
                if (res != null && res.Body != null && res.Body.addr_list != null)
                    adress = res.Body.addr_list;
            }
            ViewData["adressinfo"] = adress;

            return View();
        }
        #endregion

        #region 角色列表 RoleList
        public ActionResult RoleList()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,107,240,241,"))
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

           // string q = DoRequest.GetQueryString("q");
           
            List<RoleInfo> infoList = new List<RoleInfo>();
            var resp = QueryRoleList.Do();
            if (resp != null && resp.Body != null && resp.Body.role_list != null)
                infoList = resp.Body.role_list;
      
            ViewData["infoList"] = infoList;//数据列表

            return View();
        }
        #endregion

        #region 角色对应权限 RoleAccess
        public ActionResult RoleAccess()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,107,240,241,"))
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

            List<AccessInfo> list = new List<AccessInfo>();
            var res = QueryAccessList.Do();
            if (res != null && res.Body != null && res.Body.access_list != null)
                list = res.Body.access_list;
            ViewData["infolist"] = list;

            return View();
        }
        #endregion

        #region 权限列表 AccessList
        public ActionResult AccessList()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,107,240,242,"))
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

        #region 权限对应资源 AccessResource
        public ActionResult AccessResource()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,107,240,242,"))
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

        #region PostShopData 保存商家信息
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult PostShopData()
        {
            int shopid = DoRequest.GetFormInt("shopid");
            ShopInfo shop = GetShopDetail.Do(shopid).Body;
            if (shop == null)
            {
                shop = new ShopInfo();
                shop.shop_id = 0;
            }
            shop.shop_name = DoRequest.GetFormString("shopName");
            shop.company_name = DoRequest.GetFormString("Company");
            shop.shop_key = DoRequest.GetFormString("skeyword");
            
            string pswd = DoRequest.GetFormString("spsword");
         
            if ((pswd.Equals("") || pswd == null) && shop.shop_id == 0) {
                return Json(new { error = true, message = "[密码] 不能为空" });
            }
            if (!pswd.Equals("") && pswd != null) {
                shop.shop_pswd = AES.Decode2(pswd, "5f9bf958d112f8668ac53389df8bceba");
            }
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
            shop.support_express = DoRequest.GetFormString("supportexpress");
            shop.delivery_intro = DoRequest.GetFormString("deliveryintro");
            shop.service_intro = DoRequest.GetFormString("serviceintro", false);

            string sdate = DoRequest.GetFormString("sdate").Trim();
            int shours = DoRequest.GetFormInt("shours");
            int sminutes = DoRequest.GetFormInt("sminutes");
            DateTime startDate = Utils.IsDateString(sdate) ? DateTime.Parse(sdate + " " + shours + ":" + sminutes + ":00") : DateTime.Now;

            string edate = DoRequest.GetFormString("edate").Trim();
            int ehours = DoRequest.GetFormInt("ehours");
            int eminutes = DoRequest.GetFormInt("eminutes");
            DateTime endDate = Utils.IsDateString(edate) ? DateTime.Parse(edate + " " + ehours + ":" + eminutes + ":59") : DateTime.Now.AddDays(7);

            shop.notice_btime = startDate.ToString("yyyy-MM-dd HH:mm:ss");
            shop.notice_etime = endDate.ToString("yyyy-MM-dd HH:mm:ss");
            shop.shop_notice = DoRequest.GetFormString("shopnotice", false);
            shop.shop_remark = DoRequest.GetFormString("remarks");
            shop.shop_type = DoRequest.GetFormInt("shoptype");
            #region Checking
            if (shop.shop_name.Length < 1)
            {
                return Json(new { error = true, message = "[店铺名称] 不能为空" });
            }
            if (shop.shop_name.Length > 50)
            {
                return Json(new { error = true, message = "[店铺名称] 不能大于50个字符" });
            }
            if (shop.company_name.Length < 0 && shop.company_name.Length > 100)
            {
                return Json(new { error = true, message = "[公司名称] 不能为空或大于100个字符" });
            }
            if (shop.shop_key.Length < 1)
            {
                return Json(new { error = true, message = "[账号] 不能为空" });
            }
            if (shop.shop_pswd.Length < 1)
            {
                return Json(new { error = true, message = "[密码] 不能为空" });
            }
            if (shop.area_id < 0)
            {
                return Json(new { error = true, message = "[发货地址] 不能为空" });
            }
            if(shop.shop_addr.Length < 1)
                return Json(new { error = true, message = "[联系方式] 不能为空" });
            if (shop.support_express.Length < 1)
                return Json(new { error = true, message = "[快递公司] 不能为空" });
            #endregion

            int returnValue = -1;
            var res = OpShopInfo.Do(shop);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);

            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCache("shoplist");
                return Json(new { error = false, message = "操作成功" });
            }
            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region ResetUserState 修改用户状态
        [HttpPost]
        public ActionResult ResetUserState()
        {
            string idString = DoRequest.GetFormString("visitid").Trim();
            int status = DoRequest.GetFormInt("status");

            if (string.IsNullOrEmpty(idString))
            {
                return Json(new { error = true, message = "没有选择任何项" });
            }

            int returnValue = -1;
            var res = ModifyUserState.Do(idString, status);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("user");
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region ResetUserType 修改用户管理权限
        [HttpPost]
        public ActionResult ResetUserType()
        {
            int id = DoRequest.GetFormInt("id");
            int type = DoRequest.GetFormInt("type");

            int returnValue = -1;
            var res = SetUserType.Do(id, type);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("user");
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region ResetShopState 修改商家状态
        [HttpPost]
        public ActionResult ResetShopState()
        {
            int id = DoRequest.GetFormInt("id");
            int state = DoRequest.GetFormInt("state");

            int returnValue = -1;
            var res = ModifyShopState.Do(id, state);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCache("shoplist");
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region ResetUserPsw 重置用户密码
        [HttpPost]
        public ActionResult ResetUserPsw()
        {
            int id = DoRequest.GetFormInt("userid");

            int returnValue = -1;
            var res = ResetUserPassWord.Do(id);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("user");
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region ResetMobile 修改绑定手机
        [HttpPost]
        public ActionResult ResetMobile()
        {
            int id = DoRequest.GetFormInt("userid");
            string newmobile = DoRequest.GetFormString("newmobile");

            int returnValue = -1;
            var res = ModifyUserMoblie.Do(id, newmobile);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("user");
                return Json(new { error = false, mobile = newmobile, message = "操作成功!" });
            }
            if (returnValue == 135251)
            {
                return Json(new { error = true, message = "该手机号，已经使用，请更换手机号！" });
            }
                
            return Json(new { error = true, message = "操作失败！" });
        }
        #endregion

        #region DeleteRoleInfo 删除角色
        [HttpPost]
        public ActionResult DeleteRoleInfo()
        {
            int id = DoRequest.GetFormInt("id");

            int returnValue = -1;
            var res = DeleteRole.Do(id);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("user");
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region GetRole 获取角色信息
        [HttpPost]
        public ActionResult GetRole()
        {
            int id = DoRequest.GetFormInt("id");

            if (id == 0)
                return Json(new { error = true, message = "" });

            RoleInfo item = new RoleInfo();
            var res = GetRoleDetail.Do(id);
            if (res != null && res.Body != null)
            {
                item = res.Body;
                return Json(new { error = false, role = item, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region GetRoleList 获取角色信息
        [HttpPost]
        public ActionResult GetRoleList()
        {
            int userid = DoRequest.GetFormInt("id");
            List<RoleInfo> item1 = new List<RoleInfo>();
            List<UserRoleList> item2 = new List<UserRoleList>();
            var resrole = QueryRoleList.Do();
            var resrole2 = GetUserRole.Do(userid);

            if (resrole != null && resrole.Body != null && resrole.Body.role_list != null && resrole2 != null && resrole2.Body != null && resrole2.Body.user_role_list != null)
            {
                item1 = resrole.Body.role_list;
                item2 = resrole2.Body.user_role_list;
                return Json(new { error = false, role = item1, role2 =item2, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region GetRoleAccess 获取角色对应权限
        [HttpPost]
        public ActionResult GetRoleAccess()
        {
            int roleid = DoRequest.GetFormInt("id");
            List<RoleAccessInfo> item = new List<RoleAccessInfo>();
            var resrole = QueryRoleAccess.Do(roleid);

            if (resrole != null && resrole.Body != null && resrole.Body.access_list != null )
            {
                item = resrole.Body.access_list;
                return Json(new { error = false, role = item, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostRole 保存角色信息
        [HttpPost]
        public ActionResult PostRole()
        {
            int id = DoRequest.GetFormInt("roleid");
            string name = DoRequest.GetFormString("rolename").Trim();
            string desc = DoRequest.GetFormString("roledesc").Trim();
            int type = DoRequest.GetFormInt("roletype",2);

            RoleInfo role = new RoleInfo();
            role.role_id = id;
            role.role_name = name;
            role.role_desc = desc;
            role.role_type = type;

            var returnValue = -1;
            var res = OpRole.Do(role);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                DoCache cache = new DoCache();
                cache.RemoveCacheStartsWith("user");
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostUserRole 保存用户对应角色信息
        public ActionResult PostUserRole()
        {
            string roleids = DoRequest.GetFormString("roleids");
            int userid = DoRequest.GetFormInt("userid");

            List<UserRoleList> oldlist = new List<UserRoleList>();
            var reslist = GetUserRole.Do(userid);
            if (reslist != null && reslist.Body != null && reslist.Body.user_role_list != null)
                oldlist = reslist.Body.user_role_list;

            string[] newidss = roleids.Split(',');
            List<int> newids = new List<int>();
            foreach (string em in newidss) {
                newids.Add(Utils.StrToInt(em,0));
            }

            string delids = "";
            int _count = 0;
            foreach (UserRoleList em in oldlist) { 
                if(!newids.Contains(em.role_id)){
                    if (_count == 0)
                    {
                        delids = em.role_id.ToString();
                    }
                    else {
                        delids = delids + "," + em.role_id.ToString();
                    }
                }
               
            }
            if (delids.Equals(""))
                delids = "0";
            int returnValue = -1;
            var res = OpUserRole.Do(userid, roleids, delids);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败！" });
        }
        #endregion

        #region PostRoleAccessData 保存角色对应资源信息
        public ActionResult PostRoleAccessData()
        {
            string xmlString = DoRequest.GetFormString("xml", false);
            xmlString =  HttpUtility.UrlDecode(xmlString);
            int roleid = DoRequest.GetFormInt("id");

            string ids = "";
            int _count = 0;
            List<int> idsi = new List<int>();
            try
            {
                XmlDataDocument xmlDoc = new XmlDataDocument();
                xmlDoc.LoadXml(xmlString);
                XmlNodeList nodes = xmlDoc.SelectNodes("items/item");
                if (nodes != null)
                {
                    foreach (XmlNode item in nodes)
                    {
                        int access = Utils.StrToInt(item.Attributes["accessid"].Value.Trim(), 0);
                        int issel = Utils.StrToInt(item.Attributes["isselect"].Value.Trim(), 0);
                        if (issel == 1)
                        {
                            if (_count == 0)
                            {
                                ids = access.ToString();
                            }
                            else
                            {
                                ids = ids + "," + access.ToString();
                            }
                            _count++;
                            idsi.Add(access);
                        }
                    }
                }
            }
            catch (Exception)
            {
                return Json(new { error = true, input = "message", message = "Xml解析失败..." });
            }

            _count = 0;
            string delids = "";
            List<RoleAccessInfo> oldlist = new List<RoleAccessInfo>();
            var resrole = QueryRoleAccess.Do(roleid);
            if (resrole != null && resrole.Body != null && resrole.Body.access_list != null)
                oldlist = resrole.Body.access_list;
            foreach (RoleAccessInfo item in oldlist) { 
                if(!idsi.Contains(item.access_id)){
                    if(_count==0){
                        delids = item.access_id.ToString();
                    }else{
                        delids = delids + "," + item.access_id.ToString();
                    }
                    _count++;
                }
            }
            if(delids.Equals(""))
                delids = "0";

            var returnValue = -1;
            var res = AddRoleAccess.Do(roleid, ids, delids);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败！" });
        }
        #endregion

        #region GetAccess 获取节点信息
        //[HttpPost]
        public ActionResult GetAccess()
        {
            int parentId = DoRequest.RequestInt("parentId");
            int nodeId = DoRequest.RequestInt("nodeId");

            List<AccessInfo> accesslist = new List<AccessInfo>();
            var reslist = QueryAccessList.Do();
            if (reslist != null && reslist.Body != null && reslist.Body.access_list != null)
                accesslist = reslist.Body.access_list;

            AccessInfo pInfo = accesslist.FindLast(delegate(AccessInfo item) { return item.access_id == parentId; });
            AccessInfo tInfo = accesslist.FindLast(delegate(AccessInfo item) { return item.access_id == nodeId; });
            if (pInfo == null) pInfo = new AccessInfo();
            if (tInfo == null) tInfo = new AccessInfo();
            if (tInfo.access_id < 1)
            {
                List<AccessInfo> temList = accesslist.FindAll(delegate(AccessInfo item) { return item.parent_id == parentId; });
                tInfo.sort_no = 1;
                foreach (AccessInfo node in temList)
                {
                    if (tInfo.sort_no <= node.sort_no)
                        tInfo.sort_no += 1;
                }
            }

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            string[] arr = null;
            sb.Append("根");
            try
            {
                arr = pInfo.access_path.Split(',');
                foreach (string s in arr)
                {
                    if (string.IsNullOrEmpty(s))
                        continue;
                    int val = Utils.StrToInt(s.Trim());
                    if (val == 0)
                        continue;
                    List<AccessInfo> list = accesslist.FindAll(
                        delegate(AccessInfo item)
                        {
                            return item.access_id == val;
                        });
                    if (list.Count > 0)
                        sb.Append(" >> " + list[0].access_name);
                }
            }
            catch (Exception)
            {
            }
            return Json(new { parent = pInfo, type = tInfo, parentName = sb.ToString() }, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region DeleteAccessInfo 删除权限
        [HttpPost]
        public ActionResult DeleteAccessInfo()
        {
            int id = DoRequest.GetFormInt("accessId");

            int returnValue = -1;
            var res =  DeleteAccess.Do(id);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostAccessData 修改权限
        [HttpPost]
        public ActionResult PostAccessData()
        {
            int parentId = DoRequest.GetFormInt("parentId");
            int nodeId = DoRequest.GetFormInt("nodeId");
            string name = DoRequest.GetFormString("name").Trim();
            int sort = DoRequest.GetFormInt("sort");
            string desc = DoRequest.GetFormString("desc");
            #region 验证
            if (string.IsNullOrEmpty(name))
            {
                return Json(new { error = true, message = "名称不能为空" });
            }

            #endregion

            List<AccessInfo> accesslist = new List<AccessInfo>();
            var reslist = QueryAccessList.Do();
            if (reslist != null && reslist.Body != null && reslist.Body.access_list != null)
                accesslist = reslist.Body.access_list;

            AccessInfo pNode = accesslist.FindLast(delegate(AccessInfo item) { return item.access_id == parentId; });
            AccessInfo cNode = accesslist.FindLast(delegate(AccessInfo item) { return item.access_id == nodeId; });
            if (pNode == null) pNode = new AccessInfo();
            if (cNode == null) cNode = new AccessInfo();

            #region 初始化参数
            if (pNode.access_id == 0 && cNode.access_id == 0)
            {
                cNode.parent_id = 0;
            }
            else
            {
                cNode.parent_id = pNode.access_id;
            }
            cNode.access_name = name;
            cNode.sort_no = sort;
            cNode.access_desc = desc;
            #endregion

            int returnValue = -1;
            bool isAdd = false;
            if (cNode.access_id == 0)
            {
                //新增
                cNode.access_id = 0;
                isAdd = true;
                var resResp = OpAccess.Do(cNode);
                if (resResp != null && resResp.Header != null && resResp.Header.Result != null && resResp.Header.Result.Code != null)
                    returnValue = Utils.StrToInt(resResp.Header.Result.Code, -1);
            }
            else
            {
                //更新
                var resResp = OpAccess.Do(cNode);
                if (resResp != null && resResp.Header != null && resResp.Header.Result != null && resResp.Header.Result.Code != null)
                    returnValue = Utils.StrToInt(resResp.Header.Result.Code, -1);
            }
            bool isError = true;
            string message = "操作失败";


            if (returnValue == 0)
            {
                isError = false;
                message = "操作成功";
            }

            return Json(new { error = isError, message = message, isadd = isAdd });
        }
        #endregion

        #region GetAccessResource 获取角色对应权限
        [HttpPost]
        public ActionResult GetAccessResource()
        {
            int accessid = DoRequest.GetFormInt("id");
            string[] item = { };
            var resrole = QueryAccessResource.Do(accessid);

            if (resrole != null && resrole.Body != null)
            {
                item = resrole.Body.res_ids;
                
                return Json(new { error = false, access = item, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostAccessResourceData 保存权限对应资源信息
        public ActionResult PostAccessResourceData()
        {
            string xmlString = DoRequest.GetFormString("xml", false);
            xmlString = HttpUtility.UrlDecode(xmlString);
            int accessid = DoRequest.GetFormInt("id");

            string ids = "";
            int _count = 0;
            List<int> idsi = new List<int>();
            try
            {
                XmlDataDocument xmlDoc = new XmlDataDocument();
                xmlDoc.LoadXml(xmlString);
                XmlNodeList nodes = xmlDoc.SelectNodes("items/item");
                if (nodes != null)
                {
                    foreach (XmlNode item in nodes)
                    {
                        int resid = Utils.StrToInt(item.Attributes["resid"].Value.Trim(), 0);
                        int issel = Utils.StrToInt(item.Attributes["isselect"].Value.Trim(), 0);
                        if (issel == 1)
                        {
                            if (_count == 0)
                            {
                                ids = resid.ToString();
                            }
                            else
                            {
                                ids = ids + "," + resid.ToString();
                            }
                            _count++;
                            idsi.Add(resid);
                        }
                    }
                }
            }
            catch (Exception)
            {
                return Json(new { error = true, input = "message", message = "Xml解析失败..." });
            }

            _count = 0;
            string delids = "";
            string[] oldlist = { };
            var resrole = QueryAccessResource.Do(accessid);
            if (resrole != null && resrole.Body != null )
                oldlist = resrole.Body.res_ids;
            foreach (string item in oldlist)
            {
                if (!idsi.Contains(Utils.StrToInt(item,0)))
                {
                    if (_count == 0)
                    {
                        delids = item;
                    }
                    else
                    {
                        delids = delids + "," + item;
                    }
                    _count++;
                }
            }
            if (delids.Equals(""))
                delids = "0";

            var returnValue = -1;
            var res = OpAccessResource.Do(accessid, ids, delids);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败！" });
        }
        #endregion

        #region GetCoupon 获取优惠券
        [HttpPost]
        public ActionResult GetCoupon()
        {
            List<UseCouponRuleInfo> listinfo = new List<UseCouponRuleInfo>();

            var res= GetUseCouponRule.Do();

            if (res != null && res.Body != null && res.Body.coupon_rule_list != null)
            {
                listinfo = res.Body.coupon_rule_list;

                return Json(new { error = false, list = listinfo, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region PostCoupon 保存优惠券
        public ActionResult PostCoupon()
        {
            int userid = DoRequest.GetFormInt("userid");
            string name = DoRequest.GetFormString("couponname");
            string price = DoRequest.GetFormString("couponvalue");
            int couponnum = DoRequest.GetFormInt("couponnum");
            if (string.IsNullOrEmpty(name))
                return Json(new { error = true, message = "请输入优惠券名称！" });
            if (price.Equals("-1"))
                return Json(new { error = true, message = "请选择赠送优惠券的面值！" });
            if (couponnum <= 0)
                return Json(new { error = true, message = "请输入优惠券数量！" });
            int returnValue = -1;
            var res = GiveUserCoupon.Do(userid, name, price, couponnum);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败！" });
        }
        #endregion

        #region resetShoppsw 重置用户密码
        [HttpPost]
        public ActionResult resetShoppsw()
        {
            int id = DoRequest.GetFormInt("id");

            int returnValue = -1;
            var res = ResetShopPswd.Do(id);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region UpdateIntelgral 更新用户积分
        [HttpPost]
        public ActionResult UpdateIntelgral()
        {
            int id = DoRequest.GetFormInt("userid");
            int intelval = DoRequest.GetFormInt("intelval");
            string reason = DoRequest.GetFormString("reason");
            int returnValue = -1;
            var res = ModifyUserIntelgral.Do(id, intelval, reason);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
            if (returnValue == 0)
            {
                return Json(new { error = false,  message = "操作成功!" });
            }

            return Json(new { error = true, message = "操作失败！" });
        }
        #endregion
    }
}

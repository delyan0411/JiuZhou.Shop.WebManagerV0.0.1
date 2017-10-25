using System;
using System.IO;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Resources;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

using JiuZhou.Common;
using JiuZhou.Model;
using JiuZhou.HttpTools;
using JiuZhou.MySql;

namespace JiuZhou.ControllerBase
{
    /// <summary>
    /// 后台基类
    /// </summary>
    public class ForeSysBaseController2 : ForeBaseController
    {
        public List<UserResBody> _userResBody2 = new List<UserResBody>();
        public UserResBody _currResBody2 = new UserResBody();
        public ConfigInfo _config2 = ConnStringConfig.GetConfig;



        #region
        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            base.OnActionExecuting(filterContext);//base.OnResultExecuted

            LoginInfo loginUser = Cookies.LoginCookies;
            if (loginUser.UserID < 1)
            {
                System.Web.HttpContext.Current.Response.Redirect(this._config2.UrlHome);//未登录
                System.Web.HttpContext.Current.Response.End();
            }
            else
            {
                ViewData["usershopid"] = loginUser.ShopId;
                ViewData["usertype"] = loginUser.UserType;
                CheckVeriCode2(loginUser);
               
                ViewData["logininfo"] = loginUser;
                ViewData["userName"] = loginUser.UserName;
              
                ViewData["config"] = this._config2;
                ViewData["categShow"] = true; 
            }
        }
        #endregion

        #region
        protected override void OnException(ExceptionContext filterContext)
        {
            // 执行基类中的OnException
            base.OnException(filterContext);//base.OnResultExecuted
        }
        #endregion
        public void CheckVeriCode2(LoginInfo info)
        {
            ShortUserInfo item = new ShortUserInfo();
           
            var resuser = GetUserLoginInfo.Do();
            if (resuser != null && resuser.Body != null)
            {
                item = resuser.Body;
                Session["userinfo"] = item;
            }
          
            if (item == null)
                item = new ShortUserInfo();
            if (info == null || info.MobileNo == null || info.LastLogionTime == null || !info.MobileNo.Equals(item.mobile_no) || !info.LastLogionTime.Equals(item.last_login_time))
            {
                if (info.UserType == 2) {
                }
                else {
                    System.Web.HttpContext.Current.Response.Redirect(this._config2.UrlHome);//未登录
                    System.Web.HttpContext.Current.Response.End();
                }
            }
            else {
                if (info.UserType == 2)
                {
                    System.Web.HttpContext.Current.Response.Redirect(this._config.UrlManager + "/home/index");
                    System.Web.HttpContext.Current.Response.End();
                }
            }

        }

        #region 检查权限
        public void HasPermission(int permissionCode)
        {
            int canvisit = -1;

            if (Session["res-" + permissionCode] == null)
            {
                var resvisi = CanVisitResouce.Do(permissionCode);
                if (resvisi != null && resvisi.Header != null && resvisi.Header.Result != null && resvisi.Header.Result.Code != null)
                    canvisit = Utils.StrToInt(resvisi.Header.Result.Code, -1);

                Session["res-" + permissionCode] = canvisit;

                if (canvisit != 0)
                    Session["res-" + permissionCode] = null;
            }
            else
            {
                canvisit = Utils.StrToInt(Session["res-" + permissionCode], -1);
                if (canvisit != 0)
                    Session["res-" + permissionCode] = null;
            }

            if (canvisit != 0)
            {
                Logger.Error("没有该资源的访问权限权限!");
                System.Web.HttpContext.Current.Response.Redirect(this._config.UrlHome);//未登录
                System.Web.HttpContext.Current.Response.End();
            }
        }
        #endregion


        #region 检查权限
        public static bool HasPermission2(int permissionCode)
        {
            int canvisit = -1;

            var resvisi = CanVisitResouce.Do(permissionCode);
            if (resvisi != null && resvisi.Header != null && resvisi.Header.Result != null && resvisi.Header.Result.Code != null)
                canvisit = Utils.StrToInt(resvisi.Header.Result.Code, -1);

            if (canvisit != 0)
            {
                Logger.Error("没有该资源的访问权限权限!");
                return false;
            }
            else
            {
                return true;
            }
        }
        #endregion
  
    }
}
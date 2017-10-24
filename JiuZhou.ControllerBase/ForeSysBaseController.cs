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
    public class ForeSysBaseController : ForeBaseController
    {
        public List<UserResBody> _userResBody = new List<UserResBody>();
        public UserResBody _currResBody = new UserResBody();
        //public ConfigInfo _config = ConnStringConfig.GetConfig;
        

        #region 处理PageTitle
        public string FormatPageTile(UserResBody currNode, ref string position)
        {
            string returnValue = "";
            position = "";
            if (currNode.parent_id < 2)
                return returnValue;

            #region 处理Path
            int _currParentId = currNode.parent_id;
            returnValue = currNode.res_name;
            if (string.IsNullOrEmpty(currNode.res_src))
            {
                position = "<span>" + currNode.res_name + "</span>";
            }
            else
            {
                position = "<span><a href=\"" + currNode.res_src + "\">" + currNode.res_name + "</a></span>";
            }
            while (_currParentId > 2)
            {
                UserResBody _currParentNode = this._userResBody.FindLast(delegate(UserResBody item) { return item.res_id == _currParentId; });
                if (_currParentNode == null)
                {
                    _currParentId = 0; break;
                }
                if (_currParentNode.res_id > 0)
                {
                    returnValue += "/" + _currParentNode.res_name;
                    if (!string.IsNullOrEmpty(_currParentNode.res_src))
                    {
                        position = "<a href=\"" + _currParentNode.res_src + "\">" + _currParentNode.res_name + "</a> &gt;&gt; " + position;
                    }
                    else
                    {
                        position = _currParentNode.res_name + " &gt;&gt; " + position;
                    }
                }
                _currParentId = _currParentNode.parent_id;
            }
            #endregion

            return returnValue;
        }
        #endregion

        #region 拼接分页链接
        public string ReplacePageIndex(string urlString, int newPageIndex)
        {
            if (urlString.IndexOf("page=") > 0)
            {
                urlString = System.Text.RegularExpressions.Regex.Replace(urlString, @"page=\d+", "page=" + newPageIndex);
            }
            return urlString;
        }
        #endregion

        #region FormatPageIndex
        private int _formatPageIndexCount = 0;
        /// <summary>
        /// FormatPageIndex
        /// </summary>
        /// <param name="dbcount"></param>
        /// <param name="pagesize"></param>
        /// <param name="pageindex"></param>
        /// <param name="link"></param>
        /// <param name="showDiv">是否显示div标签(class=page-idx)</param>
        /// <returns></returns>
        public string FormatPageIndex(int dbcount, int pagesize, int pageindex, string link, bool showDiv)
        {
            _formatPageIndexCount++;
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            int pagecount = (dbcount % pagesize == 0) ? (dbcount / pagesize) : ((dbcount / pagesize) + 1);//总页数
            if (pagecount < 1) pagecount = 0;
            if (showDiv) sb.AppendLine("		<div class=\"page-idx\">");
            int max = 8;//数字链接显示8个
            int n = pageindex - (max / 2);
            if (n <= 0) n = 1;
            if (pageindex > 1)
            {
                sb.AppendLine("            <a href=\"" + this.ReplacePageIndex(link, 1) + "\" title=\"首页\">&lt;&lt;</a>");
                sb.AppendLine("            <a href=\"" + this.ReplacePageIndex(link, pageindex - 1) + "\" title=\"上一页\">上一页</a>");
            }
            else
            {
                sb.AppendLine("            <strong>&lt;&lt;</strong>");
                sb.AppendLine("            <strong>上一页</strong>");
            }
            //数字翻页
            for (int k = n; k < (n + max); k++)
            {
                if (k <= pagecount)
                {
                    if (k == pageindex)
                    {
                        sb.AppendLine("            <strong><span>" + k + "</span></strong>");//当前页
                    }
                    else
                    {
                        sb.AppendLine("            <a href=\"" + this.ReplacePageIndex(link, k) + "\" title=\"第" + k + "页\">" + k + "</a>");
                    }
                }
                else
                {
                    if (k == pageindex)
                        sb.AppendLine("            <strong><span>" + k + "</span></strong>");
                }
            }
            if (pageindex < pagecount)
            {
                sb.AppendLine("            <a href=\"" + this.ReplacePageIndex(link, pageindex + 1) + "\" title=\"下一页\">下一页</a>");
                sb.AppendLine("            <a href=\"" + this.ReplacePageIndex(link, pagecount) + "\" title=\"末页\">&gt;&gt;</a>");
            }
            else
            {
                sb.AppendLine("            <strong>下一页</strong>");
                sb.AppendLine("            <strong>&gt;&gt;</strong>");
            }
            sb.AppendLine("            <strong class=\"txt\"><span>" + pageindex + "</span>/" + pagecount + "&nbsp;共 " + dbcount + " 条记录</strong>");
            sb.AppendLine("            <strong class=\"goto\"><input id=\"goto-" + _formatPageIndexCount + "\" type=\"text\" value=\"" + (pageindex + 1 < pagecount ? (pageindex + 1) : pagecount) + "\" onclick=\"this.select()\"/></strong>");
            sb.AppendLine("            <a href=\"javascript:;\" onclick=\"changePage($('#goto-" + _formatPageIndexCount + "').val())\" title=\"GO\">GO</a>");

            if (showDiv) sb.AppendLine("		</div>");
            return sb.ToString();
        }
        public string FormatPageIndex(int dbcount, int pagesize, int pageindex, string link)
        {
            return FormatPageIndex(dbcount, pagesize, pageindex, link, true);
        }
        #endregion

        #region
        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            base.OnActionExecuting(filterContext);//base.OnResultExecuted++

            /*
            if (Session["ischeck"] == null || (bool)Session["ischeck"] == false || Session["ischeck"] == "")
            {
                System.Web.HttpContext.Current.Response.Redirect(this._config.UrlManager);//未登录
                System.Web.HttpContext.Current.Response.End();
            }
            */
            LoginInfo loginUser = Cookies.LoginCookies;

            if (loginUser.UserID < 1)
            {
                System.Web.HttpContext.Current.Response.Redirect(this._config.UrlHome);//未登录
                System.Web.HttpContext.Current.Response.End();
            }
            else
            {
                CheckVeriCode(loginUser);
                ViewData["logininfo"] = loginUser;
                if (Session["resource"] == null)
                {
                    var resp = GetUserResource.Do(1, 2);
                    if (resp == null || resp.Body == null || resp.Equals("") || resp.Body.Equals("") || resp.Body.resource_list == null)
                    {
                        _userResBody = new List<UserResBody>();
                    }
                    else
                    {
                        _userResBody = resp.Body.resource_list;
                        _userResBody = _userResBody.FindAll(delegate(UserResBody em)
                        {
                            return em.res_type < 3;
                        });
                    }
                    Session["resource"] = _userResBody;
                }
                else
                { 
                    _userResBody = (List<UserResBody>)Session["resource"];
                }

                ViewData["userName"] = loginUser.UserName;
                ViewData["userNodes"] = _userResBody;

                ViewData["currResBody"] = _currResBody;
                ViewData["config"] = this._config;
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

        public void CheckVeriCode(LoginInfo info) {
            ShortUserInfo item = new ShortUserInfo();
            if (Session["userinfo"] == null)
            {
                var resuser = GetUserLoginInfo.Do();
                if (resuser != null && resuser.Body != null)
                {
                    item = resuser.Body;
                    Session["userinfo"] = item;
                }
            }
            else {
                item = (ShortUserInfo)Session["userinfo"];
            }
            if (item == null)
                item = new ShortUserInfo();
            if (info.MobileNo == null || info.LastLogionIp == null || info.LastLogionTime == null || !info.MobileNo.Equals(item.mobile_no) || !info.LastLogionTime.Equals(item.last_login_time))
            {
                Logger.Error("我也不知道发生什么了。。。");
                System.Web.HttpContext.Current.Response.Redirect(this._config.UrlManager);//未登录
                System.Web.HttpContext.Current.Response.End();
            }

        }

        #region 检测中文
        public static bool HasChinese(string str)
        {
            return Regex.IsMatch(str, @"[\u4e00-\u9fa5]");
        }
        #endregion

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
                System.Web.HttpContext.Current.Response.Redirect(this._config.UrlHome);//未登录
                System.Web.HttpContext.Current.Response.End();
            }
        }
        #endregion


        #region 检查权限
        public static bool HasPermission2(int permissionCode)
        {
            int canvisit = -1;
            Logger.Error("没有该资源的访问权限权限-2");
            var resvisi = CanVisitResouce.Do(permissionCode);
            if (resvisi != null && resvisi.Header != null && resvisi.Header.Result != null && resvisi.Header.Result.Code != null)
                canvisit = Utils.StrToInt(resvisi.Header.Result.Code, -1);

            if (canvisit != 0)
            {
                Logger.Error("没有该资源的访问权限权限!");
                return false;
            }
            else {
                return true;
            }
        }
        #endregion
    }
}
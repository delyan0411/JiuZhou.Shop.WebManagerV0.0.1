using System;
using System.Web;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JiuZhou.Common;

namespace JiuZhou.HttpTools
{
    [Serializable]
    public class DoRequest
    {
        #region RootPath
        public static string RootPath
        {
            get
            {
                return HttpContext.Current.Request.ApplicationPath;
            }
        }
        #endregion

        #region GetMapPath
        /// <summary>
        /// 根据虚拟路径，得到物理路径
        /// </summary>
        /// <param name="path"></param>
        /// <returns></returns>
        public static string GetMapPath(string path)
        {
            if (path == null || path == "")
                return "";
            return HttpContext.Current.Server.MapPath(path);
        }
        #endregion

        #region 返回 HTML 字符串的编码结果
        /// <summary>
        /// 返回 HTML 字符串的编码结果
        /// </summary>
        /// <param name="str">字符串</param>
        /// <returns>编码结果</returns>
        public static string HtmlEncode(string str)
        {
            return HttpUtility.HtmlEncode(str);
        }
        #endregion

        #region UserAgent
        public static string UserAgent
        {
            get
            {
                return string.IsNullOrEmpty(HttpContext.Current.Request.UserAgent) ? "" : HttpContext.Current.Request.UserAgent;
            }
        }
        #endregion

        #region Request
        /// <summary>
        /// 获取参数
        /// </summary>
        /// <param name="key"></param>
        /// <param name="replace">是否将半角单撇号和双引号替换成对应的全角符号</param>
        /// <returns></returns>
        public static string Request(string key, bool replace)
        {
            string result = HttpContext.Current.Request[key];
            if (result == null || result == "")
                return "";
            //result = Utils.Traditional2Simplified(result);
            if (replace)
                result = result.Replace("&middot;", "·").Replace("'", "‘").Replace("\"", "“");
            return result;
        }
        /// <summary>
        /// 获取参数，将半角单撇号和双引号替换成对应的全角符号
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static string Request(string key)
        {
            return Request(key, true);
        }
        #endregion

        #region GetQueryString
        /// <summary>
        /// 获取URL参数
        /// </summary>
        /// <param name="key"></param>
        /// <param name="replace">是否将半角单撇号和双引号替换成对应的全角符号</param>
        /// <returns></returns>
        public static string GetQueryString(string key, bool replace)
        {
            string result = HttpContext.Current.Request.QueryString[key];
            if (result == null || result == "")
                return "";
            //result = Utils.Traditional2Simplified(result);
            //
            if (replace)
                result = result.Replace("&middot;", "·").Replace("\"", "“").Replace("'", "‘");
            return result;
        }
        /// <summary>
        /// 获取URL参数，将半角单撇号和双引号替换成对应的全角符号
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static string GetQueryString(string key)
        {
            return GetQueryString(key, true);
        }
        #endregion

        #region GetQueryDate
        public static DateTime GetQueryDate(string key, DateTime defValue)
        {
            string val = GetQueryString(key);
            try
            {
                return DateTime.Parse(val);
            }
            catch (Exception)
            {

            }
            return defValue;// DateTime.Parse("1901-01-01 00:00:00");
        }
        public static DateTime GetQueryDate(string key)
        {
            return GetQueryDate(key, DateTime.Parse("1901-01-01 00:00:00"));
        }
        #endregion

        #region GetQueryInt
        public static int GetQueryInt(string key)
        {
            return Utils.StrToInt(DoRequest.GetQueryString(key), 0);
        }
        public static int GetQueryInt(string key, int def)
        {
            return Utils.StrToInt(DoRequest.GetQueryString(key), def);
        }
        #endregion

        #region RequestInt
        public static int RequestInt(string key)
        {
            return Utils.StrToInt(DoRequest.Request(key), 0);
        }
        //
        public static int RequestInt(string key, int def)
        {
            return Utils.StrToInt(DoRequest.Request(key), def);
        }
        #endregion

        #region GetQueryLong
        public static long GetQueryLong(string key)
        {
            return GetQueryLong(key, 0);
        }
        public static long GetQueryLong(string key, long def)
        {
            string val = DoRequest.GetQueryString(key);
            if (Utils.IsLong(val))
                return long.Parse(val);

            return def;
        }
        #endregion

        #region GetFormString
        /// <summary>
        /// 获取表单参数
        /// </summary>
        /// <param name="key"></param>
        /// <param name="replace">是否将半角单撇号和双引号替换成对应的全角符号</param>
        /// <returns></returns>
        public static string GetFormString(string key, bool replace)
        {
            string result = HttpContext.Current.Request.Form[key];
            if (result == null || result == "")
                return "";
            //result = Utils.Traditional2Simplified(result);
            //
            if (replace)
                result = result.Replace("&middot;", "·").Replace("\"", "“").Replace("'", "‘");
            return result;
        }
        /// <summary>
        /// 获取表单参数，将半角单撇号和双引号替换成对应的全角符号
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static string GetFormString(string key)
        {
            return GetFormString(key, true);
        }
        #endregion

        #region GetFormInt
        public static int GetFormInt(string key)
        {
            return Utils.StrToInt(DoRequest.GetFormString(key), 0);
        }
        public static int GetFormInt(string key, int def)
        {
            return Utils.StrToInt(DoRequest.GetFormString(key), def);
        }
        #endregion

        #region GetFormDecimal
        public static decimal GetFormDecimal(string key)
        {
            return GetFormDecimal(key, 0m);
        }
        public static decimal GetFormDecimal(string key, decimal def)
        {
            string val = DoRequest.GetFormString(key);
            if (Utils.IsNumber(val))
                return decimal.Parse(val);
            return def;
        }
        #endregion

        #region GetFormDate
        /// <summary>
        /// 获取日期类型
        /// </summary>
        /// <param name="key"></param>
        /// <returns></returns>
        public static DateTime GetFormDate(string key, DateTime def)
        {
            string val = GetFormString(key);
            if (string.IsNullOrEmpty(val))
                return def;
            try
            {
                return DateTime.Parse(val);
            }
            catch (Exception)
            {

            }
            return def;
        }
        public static DateTime GetFormDate(string key)
        {
            return GetFormDate(key, DateTime.Parse("1901-01-01 00:00:00"));
        }
        #endregion

        #region GetCookie
        /// <summary>
        /// 获取Cookie
        /// </summary>
        /// <param name="key">键值</param>
        /// <returns></returns>
        public static string GetCookie(string key)
        {
            if (HttpContext.Current.Request.Cookies != null && HttpContext.Current.Request.Cookies[key] != null)
            {
                return UrlDecode(HttpContext.Current.Request.Cookies[key].Value.ToString().Trim());
            }
            return "";
        }
        #endregion

        #region 设置Cookie
        /// <summary>
        /// 设置cookie
        /// </summary>
        /// <param name="key">键</param>
        /// <param name="value">值</param>
        /// <param name="expires">过期时间</param>
        /// <param name="expiresType">b:关闭浏览器时候cookie过期; d:过期单位为天; h:过期单位为小时; m:过期单位为分</param>
        /// <param name="domain">如果不为空,则设置Cookies的作用域为指定域名下所有子域名</param>
        public static void SetCookie(string key, string value, int expires, string expiresType, string domain)
        {
            HttpCookie cookie = HttpContext.Current.Request.Cookies[key];
            if (cookie == null)
            {
                cookie = new HttpCookie(key);
            }

            cookie.Value = value;
            expiresType = expiresType.ToLower();
            if (expires > 0)
            {
                switch (expiresType)
                {
                    case "d":
                        cookie.Expires = DateTime.Now.AddDays(expires);
                        break;
                    case "h":
                        cookie.Expires = DateTime.Now.AddHours(expires);
                        break;
                    case "m":
                        cookie.Expires = DateTime.Now.AddMinutes(expires);
                        break;
                    default:
                        break;
                }
            }

            if (domain.Trim() != "")
                cookie.Domain = domain.Trim();//设置Cookies的作用域为ccdodo.com下所有子域名

            HttpContext.Current.Response.AppendCookie(cookie);
        }
        #endregion

        #region Url
        /// <summary>
        /// 获得当前完整Url地址
        /// </summary>
        /// <returns>当前完整Url地址</returns>
        public static string Url
        {
            get
            {
                return HttpContext.Current.Request.Url.ToString().Trim();
            }
        }
        #endregion

        #region 返回 URL 字符串的编码结果
        /// <summary>
        /// 返回 URL 字符串的编码结果
        /// </summary>
        /// <param name="str">字符串</param>
        /// <returns>编码结果</returns>
        public static string UrlEncode(string str)
        {
            return HttpUtility.UrlEncode(str);
        }
        public static string UrlEncode(string str, string charset)
        {
            Encoding ec = Encoding.UTF8;
            return HttpUtility.UrlEncode(str, Encoding.GetEncoding(charset));
        }
        #endregion

        #region 返回 URL 字符串的编码结果
        /// <summary>
        /// 返回 URL 字符串的编码结果
        /// </summary>
        /// <param name="str">字符串</param>
        /// <returns>解码结果</returns>
        public static string UrlDecode(string str)
        {
            return HttpUtility.UrlDecode(str);
        }
        #endregion
        #region ClientIP
        /// <summary>
        /// 获得当前页面客户端的外网IP
        /// </summary>
        /// <returns>当前页面客户端的外网IP</returns>
        public static string ClientIP
        {
            get
            {
                string UserIP = "0.0.0.0";
                if (System.Web.HttpContext.Current.Request.ServerVariables["HTTP_VIA"] != null)
                {
                    if (HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"] == null)
                    {
                        if (HttpContext.Current.Request.ServerVariables["HTTP_CLIENT_IP"] != null)
                            UserIP = HttpContext.Current.Request.ServerVariables["HTTP_CLIENT_IP"];
                        else if (HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"] != null)
                            UserIP = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
                    }
                    else
                    {
                        UserIP = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
                    }
                }
                else
                    UserIP = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
                return string.IsNullOrEmpty(UserIP) ? "0.0.0.0" : UserIP.Trim();
            }
        }
        #endregion
    }
}

using System;
using System.IO;
using System.Web;
using System.Text;
using System.Web.Mvc;
using System.Configuration;
using System.Collections.Generic;

using System.Linq;

using JiuZhou.Common;
using JiuZhou.HttpTools;
using JiuZhou.Model;
using JiuZhou.MySql;
using JiuZhou.ControllerBase;

namespace JiuZhou.ControllerBase
{
    public class LoginUser
    {
        public long UID { get; set; }
        public string UserName { get; set; }
        public string NickName { get; set; }
        public string LoginIP { get; set; }
        public string LoginAddress { get; set; }
        public string CreateTime { get; set; }
        public string ExpiresTime { get; set; }
        public int UserType { get; set; }
    }
    public class Cookies
    {
        public static ConfigInfo config = ConnStringConfig.GetConfig;
        public static readonly string ClientIDCookieName = "EBaoShopClientID";
        public static readonly string UserIDCookieName = "EBaoShopUid";
        public static readonly string LoginCookieName = "LoginUser";
        public static readonly string LocalAddressCookieName = "EBaoShopLocalAddress";
        public static readonly string LoginCookieCkeckName = "LoginCookieCheckName";
        private static string sysDecryptKey
        {
            get
            {
                return Utils.MD5(config.DecryptKey);
            }
        }

        /// <summary>
        /// 获取登录信息
        /// </summary>
        /// <returns></returns>
        public static LoginInfo LoginCookies
        {
            get
            {
                LoginInfo _info = new LoginInfo();
                HttpCookie cookie = HttpContext.Current.Request.Cookies.Get(LoginCookieName);
                HttpCookie cookie2 = HttpContext.Current.Request.Cookies.Get(LoginCookieCkeckName);
                if (cookie != null)
                {
                    string loginTime = cookie.Values["AT"];
                    DateTime dt = DateTime.Now;
                    DateTime.TryParse(loginTime, out dt);
                    _info.ActionTime = dt;
                    _info.Guid = cookie.Values["GU"];
                    _info.UserID = Utils.StrToInt(cookie.Values["ID"], -1);
                    _info.UserName = HttpUtility.UrlDecode(cookie.Values["NE"]);
                    try
                    {
                        _info.ShowName = HttpUtility.UrlDecode(cookie.Values["SN"]);
                    }
                    catch (Exception)
                    {
                        _info.ShowName = _info.UserName;
                    }
                    _info.Authentication = cookie.Values["AU"];

                    _info.KeyCode = AES.Decode(DoRequest.UrlDecode(cookie.Values["KC"]));
                    Dictionary<string, string> _list = Utils.ParseParame(_info.KeyCode);

                    _info.UserLevel = Utils.StrToInt(Utils.GetDictionaryValue(_list, "level"), -1);
                    string clientIP = Utils.GetDictionaryValue(_list, "ip");
                    _info.UserType = Utils.StrToInt(Utils.GetDictionaryValue(_list, "type"), 1);
                 
                    if (_info == null || _info.UserID < 1
                        || _info.UserID != Utils.StrToInt(Utils.GetDictionaryValue(_list, "uid"))
                        || _info.UserName.Trim().ToLower() != Utils.GetDictionaryValue(_list, "name").Trim().ToLower()
                        || loginTime.Trim().ToLower() != Utils.GetDictionaryValue(_list, "time").Trim().ToLower()
                        || _info.UserType != 2
                        )
                    {
                        Logger.Error("ID:"+ _info.UserID +"  用户类别为非管理员");
                        _info = new LoginInfo();//登录信息被篡改
                    }
                }

                if (cookie2 != null && !cookie2.Value.Equals("")) {
                    string _value = HttpUtility.UrlDecode(AES.Decode(cookie2.Value));
                    string[] _value2 = _value.Split(',');
                    _info.MobileNo = _value2[0];
                    _info.LastLogionIp = _value2[1];
                    _info.LastLogionTime = _value2[2];
                }

                return _info;
            }
        }

      
        /// <summary>
        /// 保存登录cookie
        /// </summary>
        /// <param name="info"></param>
        public static void SaveLoginInfo(string mobile,string lastip, string lasttime)
        {
            string a = AES.Encode(HttpUtility.UrlEncode(mobile + "," + lastip + "," + lasttime ));
            DoRequest.SetCookie(LoginCookieCkeckName, a, 1, "d", config.Domain);
        }

        #region 退出管理后台
        public static void ClearManagerCookies()
        {
            /*
            DoRequest.SetCookie(UserIDCookieName
                    , ""
                    , -1
                    , "m"
                    , config.Domain);//管理员ID
            
            DoRequest.SetCookie(LoginCookieName
                    , ""
                    , -1
                    , "m"
                    , config.Domain);//管理员信息
             *  * */
            DoRequest.SetCookie(LoginCookieCkeckName
                   , ""
                   , -1
                   , "m"
                   , config.Domain);//管理员信息
        }
        #endregion

        #region IP对应的地址信息
        public static void SetLocalAddress(string val)
        {
            DoRequest.SetCookie(LocalAddressCookieName
                    , HttpUtility.UrlEncode(Utils.ToUnicode(val))
                    , 1
                    , "d"
                    , config.Domain);
        }
        public static string GetLocalAddress()
        {
            string val = DoRequest.GetCookie(LocalAddressCookieName);
            return val;
            //return Utils.DeUnicode(val);
        }
        #endregion

        #region 检测验证字串
        /// <summary>
        /// 检测验证字串
        /// </summary>
        /// <param name="message">返回错误描述</param>
        /// <returns>true=验证通过;false=发生错误</returns>
        public static bool CheckVerifyString(ref string message, ref long userId)
        {
            string codeString = DoRequest.GetQueryString("code").Trim();
            string loginString = DoRequest.GetQueryString("user").Trim();
            if (string.IsNullOrEmpty(codeString) || string.IsNullOrEmpty(loginString))
            {
                message = "参数错误";
                return false;
            }
            codeString = AES.Decode(codeString, config.DecryptKey).Trim();
            loginString = AES.Decode(loginString, config.DecryptKey).Trim();
            if (!Utils.IsDateTime(codeString))
            {
                message = "没有权限";
                return false;
            }
            DateTime time = DateTime.Parse(codeString);
            if (time.AddMinutes(3) < DateTime.Now || time > DateTime.Now)
            {
                message = "会话已超时";
                return false;
            }
            Dictionary<string, string> list = Utils.ParseParame(loginString.Trim());
            //LoginUser user = new LoginUser();
            string uidDic = Utils.GetDictionaryValue(list, "UID");
            if (!Utils.IsLong(uidDic))
            {
                message = "未登录或登录已超时";
                return false;
            }
            if (long.Parse(uidDic) < 1)
            {
                message = "登录超时";
                return false;
            }
            userId = long.Parse(uidDic);
            return true;
        }
        public static bool CheckVerifyString(ref string message)
        {
            long userId = 0;
            return CheckVerifyString(ref message, ref userId);
        }
        #endregion

        #region 拼接验证字串
        /// <summary>
        /// 拼接验证字串
        /// </summary>
        /// <returns></returns>
        public static string CreateVerifyString()
        {
            StringBuilder sb = new StringBuilder();
            string loginString = "UID=" + LoginCookies.UserID.ToString() + "&Name=" + LoginCookies.UserName;
            string code = AES.Encode(DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
            sb.Append("code=" + DoRequest.UrlEncode(code));
            sb.Append("&user=" + DoRequest.UrlEncode(AES.Encode(loginString)));
            return sb.ToString();
        }
        #endregion
    }
}

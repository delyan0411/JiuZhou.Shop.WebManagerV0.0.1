using System;
using System.IO;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Web.Mvc;
using System.Collections.Generic;
using System.Configuration;

using JiuZhou.Cache;
using JiuZhou.Common;
using JiuZhou.Common.Tools;
using JiuZhou.Model;
using JiuZhou.SqlServer;
using JiuZhou.XmlSource;
using JiuZhou.HttpTools;

namespace JiuZhou.ControllerBase
{
    /// <summary>
    /// 工具类
    /// </summary>
    public class UtilTools
    {
        #region 404错误页面
        public static void Error404(string message)
        {
            Robots _rbt = new Robots();
            System.Text.StringBuilder url = new System.Text.StringBuilder();
            url.Append(ConnStringConfig.GetConfig.UrlHome + "template?");
            url.Append(Cookies.CreateVerifyString());

            string html = _rbt.GetHtml(url.ToString(), "utf-8");
            if (_rbt.IsError)
            {
                System.Web.HttpContext.Current.Response.Write(_rbt.ErrorMsg);
                System.Web.HttpContext.Current.Response.End();
            }
            if (string.IsNullOrEmpty(html))
            {
                System.Web.HttpContext.Current.Response.Write(string.IsNullOrEmpty(message) ? "页面无响应" : message);
                System.Web.HttpContext.Current.Response.End();
            }
            if (!string.IsNullOrEmpty(message))
            {
                html = System.Text.RegularExpressions.Regex.Replace(html, "<h1>.*?</h1>", "<h1>" + message + "</h1>", Utils.GetRegexOptions);
            }
            System.Web.HttpContext.Current.Response.Write(html);
            System.Web.HttpContext.Current.Response.End();
        }
        public static void Error404()
        {
            Error404("");
        }
        #endregion


    }
}
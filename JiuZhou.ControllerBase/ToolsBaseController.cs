using System;
using System.IO;
using System.Web;
using System.Text;
using System.Web.Mvc;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;

using JiuZhou.Cache;
using JiuZhou.Common;
using JiuZhou.Model;
using JiuZhou.MySql;
using JiuZhou.XmlSource;
using JiuZhou.HttpTools;
using System.Text.RegularExpressions;

namespace JiuZhou.ControllerBase
{
    public class ToolsBaseController : ForeSysBaseController
    {
     
        #region 设置IP对应的地址
        [HttpPost]
        public ActionResult SetLocalAddress()
        {
            string val = DoRequest.GetFormString("address").Trim();
            Cookies.SetLocalAddress(val);
            return Json(new { error = false, message = "操作成功!"});
        }
        #endregion

        #region 获取所有区域信息
        [OutputCache(Duration = 86400, VaryByParam = "*")] //缓存24个小时
        public void AreaDataToJson()
        {
            List<AreaInfo> list = GetArea.Do(0).Body.area_list;
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append("var areas=[");
            int i = 0;
            foreach (AreaInfo s in list)
            {
                if (i > 0)
                    sb.Append(",");
                i++;
                sb.Append("{");
                sb.Append("'ID':" + s.area_id);
                sb.Append(",'ParentID':" + s.parent_id);
                sb.Append(",'AreaID':" + s.area_id);
                sb.Append(",'Code':'" + s.area_path + "'");
                sb.Append(",'Name':'" + s.area_name + "'");
                sb.Append("}");
            }
            sb.Append("];");
            System.Web.HttpContext.Current.Response.Write(sb.ToString());
            System.Web.HttpContext.Current.Response.End();
            //return Json(sList, JsonRequestBehavior.AllowGet);
        }

        #endregion

        public static string CleanHtml(string strHtml, bool style)
        {
            if (string.IsNullOrEmpty(strHtml)) return strHtml;
            if(style){
                string[] restr = { "script", "style", "link", "object", "embed", "html", "head", "video", "wbr", "base", "basefont", "meta", "title" };
                string _restr = "";
                for (int i = 0; i < restr.Length; i++)
                {
                    if (i == 0)
                    {
                        _restr = "<\\s*" + restr[i] + "[^>]*>(.*?<\\s*/" + restr[i] + "\\s*>)?|(<\\s*" + restr[i] + "(.+?)/\\s*>)";
                    }
                    else
                    {
                        _restr += "|<\\s*" + restr[i] + "[^>]*>(.*?<\\s*/" + restr[i] + "\\s*>)?|(<\\s*" + restr[i] + "(.+?)/\\s*>)";
                    }
                }

                strHtml = Regex.Replace(strHtml, _restr, "", RegexOptions.IgnoreCase | RegexOptions.Singleline);

                strHtml = Regex.Replace(strHtml, "<\\s*body[^>]*(/\\s*>|>)|<\\s*/body\\s*>", "", RegexOptions.IgnoreCase | RegexOptions.Singleline);
            }
            //过滤 on: 的事件
            //过滤on 带单引号的 过滤on  带双引号的 过滤on 不带有引号的
            string regOn1 = "<[\\s\\S]+(on)[a-zA-Z]{4,20}(\\s*)=(\\s*)[^>]{1,}>";
            string regOn2 = "((on)[a-zA-Z]{4,20}\\s*=\\s*'[^']{1,}')|((on)[a-zA-Z]{4,20}\\s*=\\s*\"[^\"]{1,}\")|((on)[a-zA-Z]{4,20}\\s*=\\s*[^>/]{1,})";
            strHtml = GetReplace(strHtml, regOn1, regOn2, "");
            //strHtml = Regex.Replace(strHtml, regOn1, "", RegexOptions.IgnoreCase | RegexOptions.Singleline);


            //过滤 javascript: 的事件
            string regOn3 = "<[\\s\\S]+(href|src|background|url|dynsrc|expression|codebase)(\\s*)=(\\s*)[\"']?(\\s*)(javascript\\s*:)[^>]{1,}>";
            string regOn4 = "('\\s*(javascript|vbscript|script)\\s*:\\s*([\\S^'])*\\s*')|(\"\\s*(javascript|vbscript|script)\\s*:\\s*[\\S^\"]*\\s*\")|([^=]*(javascript|vbscript|script)\\s*://s*[^/>]*)";
            strHtml = GetReplace(strHtml, regOn3, regOn4, "");

            return strHtml.Trim();
        }

        private static string GetReplace(string content, string splitKey1, string splitKey2, string newChars)
        {
            //splitKey1 第一个正则式匹配

            //splitKey2 匹配结果中再次匹配进行替换

            if (splitKey1 != null && splitKey1 != "" && splitKey2 != null && splitKey2 != "")
            {
                Regex rg = new Regex(splitKey1, RegexOptions.IgnoreCase);
                System.Text.RegularExpressions.MatchCollection mc = rg.Matches(content);


                foreach (System.Text.RegularExpressions.Match mc1 in mc)
                {
                    string oldChar = mc1.ToString();
                    string newChar = new Regex(splitKey2, RegexOptions.IgnoreCase).Replace(oldChar, newChars);
                    content = content.Replace(oldChar, newChar);
                }
                return content;
            }
            else
            {
                if (splitKey2 != null && splitKey2 != "")
                {
                    Regex rg = new Regex(splitKey2, RegexOptions.IgnoreCase);
                    return rg.Replace(content, newChars);
                }
            }
            return content;
        }
    }
}

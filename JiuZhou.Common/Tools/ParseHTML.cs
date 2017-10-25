using System;
using System.IO;
using System.Text;
using System.Reflection;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Security.Cryptography;
using System.Runtime.InteropServices;
using System.Text.RegularExpressions;
/// <summary>
/// Version: 1.0
/// Author: Atai Lu
/// </summary>
namespace JiuZhou.Common.Tools
{
    public class PageInfo
    {
        #region PageInfo
        private string _title = "";
        /// <summary>
        /// title标签的内容
        /// </summary>
        public string Title
        {
            get { return _title; }
            set { _title = value; }
        }
        private string _keywords = "";
        /// <summary>
        /// keywords标签的内容
        /// </summary>
        public string Keywords
        {
            get { return _keywords; }
            set { _keywords = value; }
        }
        private string _description = "";
        /// <summary>
        /// description标签的内容
        /// </summary>
        public string Description
        {
            get { return _description; }
            set { _description = value; }
        }
        //private List<string> _urls = new List<string>();
        private string _contents = "";
        /// <summary>
        /// 网页内容
        /// </summary>
        public string Contents
        {
            get { return _contents; }
            set { _contents = value; }
        }
        #endregion
    }

    public enum LinkType
    {
        /// <summary>
        /// 忽略
        /// </summary>
        NULL = -1,
        /// <summary>
        /// 文字链接(站内)
        /// </summary>
        TEXT = 0,
        /// <summary>
        /// 图片链接(站内)
        /// </summary>
        IMAGE = 1,
        /// <summary>
        /// 文字链接(外链)
        /// </summary>
        TEXT_OUT = 2,
        /// <summary>
        /// 图片链接(外链)
        /// </summary>
        IMAGE_OUT = 3,
        /// <summary>
        /// Javascript链接
        /// </summary>
        JAVASCRIPT = 4,
        /// <summary>
        /// 页内链接Anchor(锚点)
        /// </summary>
        ANCHOR = 5,
        /// <summary>
        /// 无效链接
        /// </summary>
        BAD = 6
    }

    public class UrlInfo
    {
        private string _loc = "";
        /// <summary>
        /// 链接地址
        /// </summary>
        public string Loc
        {
            get { return _loc; }
            set { _loc = value; }
        }
        private string _text = "";
        /// <summary>
        /// 链接名称
        /// </summary>
        public string Text
        {
            get { return _text; }
            set { _text = value; }
        }
        private string _title = "";
        /// <summary>
        /// 链接title属性
        /// </summary>
        public string Title
        {
            get { return _title; }
            set { _title = value; }
        }
        private LinkType _loctype = LinkType.NULL;
        /// <summary>
        /// 链接类型0:未处理;1:文字链接(站内);2:图片链接(站内);3:外部链接(文字);4:外部链接(图片);5:JavaScript链接/页内链接;6:无效链接
        /// </summary>
        public LinkType Loctype
        {
            get { return _loctype; }
            set { _loctype = value; }
        }
    }

    public class ParseHTML
    {
        #region 构造函数
        private string _Source = "";
        public string Source
        {
            get { return _Source; }
        }
        public ParseHTML(string source)
        {
            this._Source = source;
            this.Parse(source);
        }
        #endregion

        #region 属性
        private bool _isError = false;
        /// <summary>
        /// 是否出错
        /// </summary>
        public bool IsError
        {
            get { return _isError; }
            //set { _isError = value; }
        }
        //
        private string _errorMsg = "";
        /// <summary>
        /// 错误信息
        /// </summary>
        public string ErrorMsg
        {
            get { return _errorMsg; }
            //set { _errorMsg = value; }
        }
        #endregion

        private PageInfo _pageinfo = new PageInfo();
        private List<UrlInfo> _urls = new List<UrlInfo>();
        //private RegexOptions options = RegexOptions.IgnoreCase | RegexOptions.Compiled;

        #region
        private RegexOptions options
        {
            get
            {
                RegexOptions opt;
                if (Environment.Version.Major == 1)
                    opt = RegexOptions.Compiled | RegexOptions.IgnoreCase | RegexOptions.Multiline;
                else
                    opt = RegexOptions.IgnoreCase | RegexOptions.Multiline;
                return opt;
            }
        }
        #endregion

        #region ParseMeta
        private void ParseMeta(string html)
        {
            //string result = "";
            Regex r = null;
            Match m = null;
            //List<string> metas = new List<string>();
            r = new Regex(@"<meta[^>]*>", this.options);
            for (m = r.Match(html);
                m.Success;
                m = m.NextMatch())
            {
                string meta = m.Groups[0].ToString();
                Regex reg = new Regex(@"name\s*=\s*['""]?(?<name>[^>'""]*)", this.options);
                string name = reg.Match(meta).Groups["name"].Value.Trim().ToLower();
                reg = new Regex(@"content\s*=\s*['""]?(?<content>[^>'""]*)", this.options);
                string content = reg.Match(meta).Groups["content"].Value.Trim().ToLower();
                switch (name)
                {
                    case "keywords":
                        this._pageinfo.Keywords = content;
                        break;
                    case "description":
                        this._pageinfo.Description = content;
                        break;
                    case "robots":
                        break;
                    case "author":
                        break;
                    default:
                        break;
                }
            }
            //return result;
        }
        #endregion

        #region ParseUrls
        private void ParseUrls(string html)
        {
            html = Regex.Replace(html, @"<!--[\s\S]*?-->", "", this.options);//先清除掉注释

            
            //StringBuilder sb = new StringBuilder();

            Regex r = null;
            Match m = null;
            //List<string> metas = new List<string>();
            r = new Regex(@"<a[^>]*>[\s\S]*?</a>", this.options);
            for (m = r.Match(html);
                m.Success;
                m = m.NextMatch())
            {
                string str = m.Groups[0].ToString();
                
                UrlInfo _urlinfo = new UrlInfo();

                Regex reg = new Regex(@"href\s*=\s*['""](?<loc>[^>'""]*)", this.options);
                if (reg.IsMatch(str))
                    _urlinfo.Loc = reg.Match(str).Groups["loc"].Value.Trim().ToLower();
                if (_urlinfo.Loc.Equals("")
                    || _urlinfo.Loc.StartsWith("#")
                    || _urlinfo.Loc.StartsWith("void(0)")
                    || _urlinfo.Loc.StartsWith("javascript"))
                {
                    continue;//javascript链接或页内链接不需要处理
                }
                _urlinfo.Loctype = LinkType.NULL;
                //for (int k = 0; k < this._urls.Count; k++)
                //{
                //    if (this._urls[k].Loc == _urlinfo.Loc)
                //        break;
                //}

                reg = new Regex(@"<a[^>]*>(?<text>[\s\S]*?)</a>", this.options);
                if (reg.IsMatch(str))
                    _urlinfo.Text = reg.Match(str).Groups["text"].Value.Trim();
                reg = new Regex(@"<img[^>]*alt\s*=\s*['""](?<alt>[^>'""]*)[^>]*>", this.options);
                if (reg.IsMatch(_urlinfo.Text))
                {
                    _urlinfo.Text = reg.Match(_urlinfo.Text).Groups["alt"].Value.Trim();
                }
                _urlinfo.Text = this.ClearHtml(_urlinfo.Text);

                reg = new Regex(@"title\s*=\s*['""](?<title>[^>'""]*)", this.options);
                if (reg.IsMatch(str))
                    _urlinfo.Title = reg.Match(str).Groups["title"].Value.Trim();

                //sb.AppendLine(_urlinfo.Loc);
                
                this._urls.Add(_urlinfo);
            }
            //sb.AppendLine("x");
            //this._errorMsg = sb.ToString();
        }
        #endregion

        #region 清除html代码
        private string ClearHtml(string strHtml, bool clearSpace)
        {
            if (Utils.IsMatch(strHtml, "^\\s$"))
                return "";

            if (strHtml != "")
            {
                strHtml = strHtml.Replace("　", "");
                strHtml = Regex.Replace(strHtml, @"\s", "", this.options);
                strHtml = Regex.Replace(strHtml, @"<!--.*?-->", "", this.options);
                strHtml = Regex.Replace(strHtml, @"<style[^>]*>.*?</style>", "", this.options);
                strHtml = Regex.Replace(strHtml, @"<script[^>]*>.*?</script>", "", this.options);
                strHtml = Regex.Replace(strHtml, @"<[^>]+>", "", this.options);
            }
            strHtml = strHtml.Replace("&nbsp;", "");
            return strHtml.Trim();
        }
        private string ClearHtml(string strHtml)
        {
            return this.ClearHtml(strHtml, true);
        }
        #endregion

        #region Parse
        private void Parse(string html)
        {
            Regex reg = null;
            reg = new Regex(@"<title[^>]*>(?<title>.*?)</title>", this.options);
            html = Regex.Replace(html, @"(<a[^>]*href\s*)=([^'""][^>\s]*)", "$1='$2'", this.options);
            html = Regex.Replace(html, @"(<a[^>]*title\s*)=([^'""][^>\s]*)", "$1='$2'", this.options);
            html = Regex.Replace(html, @"(<img[^>]*alt\s*)=([^'""][^>\s]*)", "$1='$2'", this.options);
            //html = Regex.Replace(html, @"(name\s*)=\s*([^>\s]*)", "$1='$2'", this.options);
            html = Regex.Replace(html, @"(<meta[^>]*content\s*)=([^'""][^>\s]*)", "$1='$2'", this.options);
            if (reg.IsMatch(html))
                this._pageinfo.Title = reg.Match(html).Groups["title"].Value;//<title/>
            this.ParseMeta(html);
            //reg = new Regex(@"<meta\s*name=""Keywords"" content="""">");
            this.ParseUrls(html);

            this._pageinfo.Contents = this.ClearHtml(html);
        }
        #endregion

        #region GetLocType
        //public int GetLocType(string url)
        //{
        //    int result = 0;

        //    return result;
        //}
        #endregion

        #region 判断指定链接是否存在于GetUrls()中
        private bool IsBegin(string loc)
        {
            for (int i = 0; i < this._urls.Count; i++)
            {
                if (this._urls[i].Loc == loc)
                    return true;
            }
            return false;
        }
        private bool IsBegin(List<UrlInfo> list, string loc)
        {
            for (int i = 0; i < list.Count; i++)
            {
                if (list[i].Loc == loc)
                    return true;
            }
            return false;
        }
        #endregion

        #region Get
        public PageInfo GetPageInfo()
        {
            return this._pageinfo;
        }
        /// <summary>
        /// 得到链接(可能存在重复的链接)
        /// </summary>
        /// <returns></returns>
        public List<UrlInfo> GetUrls()
        {
            return this._urls;
        }
        /// <summary>
        /// 得到链接(去掉重复的链接)
        /// </summary>
        /// <returns></returns>
        public List<UrlInfo> GetUniqueUrls()
        {
            List<UrlInfo> list = new List<UrlInfo>();

            for (int i = 0; i < this._urls.Count; i++)
            {
                if (!this.IsBegin(list, this._urls[i].Loc))
                    list.Add(this._urls[i]);
            }

           return list;
        }
        #endregion
    }
}

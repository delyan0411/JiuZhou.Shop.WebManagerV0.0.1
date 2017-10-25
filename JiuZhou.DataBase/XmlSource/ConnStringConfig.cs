using System;
using System.Text;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Xml;
using System.Xml.XPath;

using JiuZhou.Model;
using JiuZhou.Cache;
using JiuZhou.Common;
using JiuZhou.HttpTools;

namespace JiuZhou.XmlSource
{
    public enum LogType
    {
        /// <summary>
        /// Sql运行日志
        /// </summary>
        SqlLog = 0,
        /// <summary>
        /// 其它日志
        /// </summary>
        Other = 1
    }

    public class ConnStringConfig
    {

        #region 获取配置文件信息
        /// <summary>
        /// 获取配置文件信息
        /// </summary>
        public static ConfigInfo GetConfig
        {
            get
            {
                ConfigInfo Info = new ConfigInfo();
                try
                {
                    JiuZhou.Cache.DoCache _cache = new JiuZhou.Cache.DoCache();
                    if (_cache.GetCache("ConfigInfo") != null)
                        return (ConfigInfo)_cache.GetCache("ConfigInfo");

                    string path = JiuZhou.HttpTools.DoRequest.RootPath + "/JiuZhouShop.config";
                    string xmlFilePath = JiuZhou.HttpTools.DoRequest.GetMapPath(path.Replace("//", "/"));
                    if (Utils.FileExists(xmlFilePath))
                    {
                        XmlDataDocument xmlDoc = new XmlDataDocument();
                        xmlDoc.Load(xmlFilePath);
                        XmlNode root = xmlDoc.SelectSingleNode("config");
                        Info.UserAgent = xmlDoc.GetElementsByTagName("userAgent")[0].Attributes["value"].Value;
                        Info.DecryptKey = root.SelectSingleNode("decryptKey").Attributes["value"].Value;
                        XmlNode debugSetting = xmlDoc.GetElementsByTagName("debug")[0];
                        string _debugString = debugSetting.Attributes["value"].Value;
                        Info.Debug = false;
                        string _att = "value";
                        if (_debugString.ToLower().Equals("true"))
                        {
                            Info.Debug = true;
                            _att = "debug";
                        }
                        Info.Log = debugSetting.Attributes["log"].Value;
                                                                 
                        Info.Domain = xmlDoc.GetElementsByTagName("domain")[0].Attributes[_att].Value;
                        Info.UrlHome = xmlDoc.GetElementsByTagName("urlHome")[0].Attributes[_att].Value;
                        Info.UrlUserCenter = xmlDoc.GetElementsByTagName("urlUserCenter")[0].Attributes[_att].Value;
                        Info.UrlManager = xmlDoc.GetElementsByTagName("urlManager")[0].Attributes[_att].Value;
                        Info.UrlPay = xmlDoc.GetElementsByTagName("urlPay")[0].Attributes[_att].Value;
                        Info.UrlImages = xmlDoc.GetElementsByTagName("urlImages")[0].Attributes[_att].Value;
                        Info.UrlData = xmlDoc.GetElementsByTagName("urlData")[0].Attributes[_att].Value;
                        Info.UrlData2 = xmlDoc.GetElementsByTagName("urlData2")[0].Attributes[_att].Value;
                        Info.DirPathImage = xmlDoc.GetElementsByTagName("urlImages")[0].Attributes["dirPath"].Value;
                        Info.UrlDataAnalysis = xmlDoc.GetElementsByTagName("urlDataAnalysis")[0].Attributes[_att].Value;

                        //Info.ExchangeRate = xmlDoc.GetElementsByTagName("orderRule")[0].Attributes["exchangeRate"].Value;
                       // string maxDiscountRate = xmlDoc.GetElementsByTagName("orderRule")[0].Attributes["maxDiscountRate"].Value;
                       // if (Utils.IsNumber(maxDiscountRate))
                 //       {
                   //         Info.MaxDiscountRate = decimal.Parse(maxDiscountRate);
                    //    }

                        if (!Info.Debug)//debug状态不缓存
                            _cache.SetCache("ConfigInfo", Info, 600);//缓存10分钟
                    }
                }
                catch (Exception e) {
                    Logger.Error(e.ToString());
                }
                return Info;
            }
        }
        #endregion

        #region WriteLog
        public static void WriteLog(LogType type, string val)
        {

            if (ConnStringConfig.GetConfig.Debug)
            {
                string path = ConnStringConfig.GetConfig.Log + @"\" + type.ToString() + @"\" + DateTime.Now.ToString("yyyy-MM") + @"\";
                path = path.Replace(@"\\", @"\");
                JiuZhou.Common.Utils.CreateDir(path);
                path += (type == LogType.SqlLog ? "sql-" : "") + "error-" + DateTime.Now.ToString("yyyyMMdd") + ".txt";

                System.Text.StringBuilder sb = new StringBuilder();
                sb.AppendLine("CreateDate: " + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"));
                sb.AppendLine("--------------------------------------------------------------------------------------------------------");
                sb.AppendLine("");
                sb.AppendLine("");
                sb.Append(val);
                JiuZhou.Common.Utils.AppenText(path, sb.ToString());
            }
        }
        #endregion

    }
}
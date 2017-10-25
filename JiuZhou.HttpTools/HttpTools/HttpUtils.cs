using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;
using System.Web;
using JiuZhou.Model;


namespace JiuZhou.HttpTools
{

    public class HttpUtils
    {
        private const int TimeOut = 30000;
        public static ConfigInfo config = JiuZhou.HttpTools.ConnStringConfig.GetConfig;//网站配置
        private static string testUrl = config.UrlData;
        

        public static string HttpPost(string requestStr)
        {
            return HttpPost(testUrl, requestStr);
        }

        public static string HttpPost(string url, string requestStr)
        {
            string responseStr = string.Empty;
            try
            {
                if (string.IsNullOrEmpty(url))
                {
                    url = testUrl;
                }
                HttpWebRequest request = HttpWebRequest.Create(url) as HttpWebRequest;
                request.Method = "POST";
                request.Timeout = TimeOut;
                request.ContentType = "application/x-www-form-urlencoded";

                WebResponse webResponse = null;
                StreamWriter streamWriter = null;
              //  Encoding myEncoding = Encoding.GetEncoding("gb2312");
                try
                {
                    streamWriter = new StreamWriter(request.GetRequestStream());

                    streamWriter.Write(requestStr);
                    streamWriter.Close();

                    webResponse = request.GetResponse();
                    if (webResponse != null)
                    {
                        StreamReader streamReader = new StreamReader(webResponse.GetResponseStream());
                        responseStr = streamReader.ReadToEnd();
                        streamReader.Close();
                    }
                }
                catch (Exception e)
                {
                    Logger.Error(e.ToString());
                }
            }
            catch (Exception e)
            {
                Logger.Error(e.ToString());
            }
            return responseStr;
        }
        
    }
}

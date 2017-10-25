using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Data;
using System.IO;
using System.Net;
using System.Drawing;
using System.Drawing.Imaging;
using System.Collections.Specialized;
//using System.Net.NetworkInformation;
/// <summary>
/// Version: 1.0
/// Author: Atai Lu
/// </summary>
namespace JiuZhou.Common.Tools
{
    public class Logger
    {
        static string ExistPath(string path)
        {
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            return path;
        }

        static void Write(string dir, string filename, string msg)
        {
            StreamWriter writer = null;
            try
            {
                string path = ExistPath(AppDomain.CurrentDomain.BaseDirectory + "\\" + dir + "\\" + DateTime.Now.ToString("yyyyMMdd")) + "\\";
                string fullname = path + DateTime.Now.ToString("yyyyMMdd_HH") + (string.IsNullOrEmpty(filename) ? "" : "_" + filename) + ".txt";
                writer = new StreamWriter(fullname, true, Encoding.UTF8);
                writer.WriteLine(msg);
            }
            catch (Exception)
            {
            }
            finally
            {
                if (writer != null)
                {
                    writer.Close();
                    writer.Dispose();
                }
            }
        }

        public static void Log(params string[] msg)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("=======================" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "=============================\t\r\n");
            sb.Append(string.Join("\r\n", msg));
            sb.Append("\r\n");
            Write("Log", "", sb.ToString());
        }

        public static void Error(params string[] msg)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("=======================" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "=============================\t\r\n");
            sb.Append(string.Join("\r\n", msg));
            sb.Append("\r\n");
            Write("Error", "", sb.ToString());
        }
    }
    public class Robots
    {
        public Robots()
        {

        }
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
        
        private string _UserAgent = "Mozilla/4.0 (compatible; MSIE 9.0; Windows NT 5.2; Atai Robot ; .NET CLR 1.1.4322; .NET CLR 2.0.50727)";
        /// <summary>
        /// UserAgent
        /// </summary>
        public string UserAgent
        {
            get { return _UserAgent; }
            set { _UserAgent = value; }
        }
        private string _ContentType = "";
        /// <summary>
        /// 响应的内容类型
        /// </summary>
        public string ContentType
        {
            get { return _ContentType; }
        }
        private string _PageEncoding = "";
        public string PageEncoding
        {
            get { return _PageEncoding; }
        }

        private HttpStatusCode _HttpStatusCode;
        /// <summary>
        /// 远程服务器响应状态
        /// </summary>
        public HttpStatusCode StatusCode
        {
            get { return _HttpStatusCode; }
        }
        #endregion

        #region 识别编码
        private string GetEncoding(string html)
        {
            string result = "utf-8";
            Regex reg_charset = new Regex(@"charset\b\s*=\s*(?<charset>[^""'\s]*)");

            if (reg_charset.IsMatch(html))
            {

                return reg_charset.Match(html).Groups["charset"].Value;

            }
            return result;
        }
        #endregion

        #region 抓取远程HTML
        public string GetHtml(string url)
        {
            return this.GetHtml(url, "");
        }
        public string GetHtml(string url, string charset)
        {
            string result = "";
            string referer = url;
            try
            {
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
                //声明一个HttpWebRequest请求
                request.Timeout = 30000;//设置连接超时时间
                request.UserAgent = this.UserAgent;
                request.AllowAutoRedirect = true;
                //
                //request.Referer = referer;//设置标头
                //
                HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                //HttpStatusCode status = ;
                this._HttpStatusCode = response.StatusCode;
                if (response.StatusCode == HttpStatusCode.OK && response.ContentLength < 1024 * 2048)//大于2M的文件不读取
                {
                    Stream streamReceive = response.GetResponseStream();//response.ContentType
                    //Stream streamReceive = Gzip(response);

                    //Encoding encoding = Encoding.Default;
                    StreamReader streamReader = null;
                    if (charset == null || charset == "")
                    {
                        streamReader = new StreamReader(streamReceive, Encoding.ASCII);
                        if (response.CharacterSet != string.Empty)
                            charset = response.CharacterSet;
                        else
                            charset = this.GetEncoding(streamReader.ReadToEnd());

                    }
                    this._PageEncoding = charset;
                    Encoding encoding = Encoding.GetEncoding(charset);
                    streamReader = new StreamReader(streamReceive, encoding);

                    result = streamReader.ReadToEnd();
                    streamReader.Close();
                    streamReader.Dispose();
                    streamReceive.Close();
                    streamReceive.Dispose();
                }
                else
                {
                    this._isError = true; this._errorMsg = response.StatusCode.ToString();
                }
                this._ContentType = response.ContentType;
                response.Close();
            }
            catch (Exception e) { this._isError = true; this._errorMsg = e.ToString(); }
            return result;
        }
        #endregion

        #region 把特定数据Post到远程服务器并获取返回结果
        public string Post(string url, string postdata, string charset)
        {
            string result = "";
            string referer = url;
            try
            {
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
                //声明一个HttpWebRequest请求
                request.Timeout = 30000;//设置连接超时时间
                request.UserAgent = this.UserAgent;
                request.AllowAutoRedirect = true;
                //
                request.Referer = referer;//设置标头
                request.Method = "POST";
                //request.Headers.Add("Content-Type", "application/x-www-form-urlencoded");
                request.ContentType = "application/x-www-form-urlencoded";
                Encoding encoding = Encoding.GetEncoding(charset);//
                byte[] byteArray = encoding.GetBytes(postdata);
                request.ContentLength = byteArray.Length;
                Stream stream = request.GetRequestStream();
                stream.Write(byteArray, 0, byteArray.Length);
                stream.Close();
                //request.Headers.
                HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                //response.CharacterSet
                //HttpStatusCode status = ;
                //response.StatusCode
                if (response.StatusCode == HttpStatusCode.OK && response.ContentLength < 1024 * 2048)//大于2M的文件不读取
                {
                    Stream streamReceive = response.GetResponseStream();
                    //Stream streamReceive = Gzip(response);
                    this._PageEncoding = charset;
                    StreamReader streamReader = new StreamReader(streamReceive, encoding);
                    result = streamReader.ReadToEnd();
                    streamReader.Close();
                    streamReader.Dispose();
                    streamReceive.Close();
                    streamReceive.Dispose();
                }
                else
                {
                    this._isError = true; this._errorMsg = response.StatusCode.ToString();
                }
                this._ContentType = response.ContentType;
                response.Close();
            }
            catch (Exception e) { this._isError = true; this._errorMsg = e.ToString(); }
            return result;
        }
        #endregion

        #region 把文件传输到远程服务器指定页面
        public string PostFile(string url, System.Web.HttpPostedFile file, string charset)
        {
            string result = "";
            string referer = url;
            try
            {
                Encoding encoding = Encoding.GetEncoding(charset);//
                //FileStream fs = file.InputStream;
                BinaryReader r = new BinaryReader(file.InputStream);
                string strBoundary = "----------" + DateTime.Now.Ticks.ToString("x");//时间戳
                byte[] boundaryBytes = Encoding.ASCII.GetBytes("\r\n--" + strBoundary + "\r\n");
                //头信息
                //string filePartHeader = "Content-Disposition: form-data; name=\"{0}\"; filename=\"{1}\"\r\n"
                //    + "Content-Type: application/octet-stream\r\n\r\n";
                StringBuilder sb = new StringBuilder();
                sb.Append("--");
                sb.AppendLine(strBoundary);
                sb.Append("Content-Disposition: form-data; name=\"name\"; ");
                sb.AppendLine("filename=\"" + file.FileName + "\"");

                sb.Append("Content-Type: ");
                sb.Append("application/octet-stream");
                sb.AppendLine("");
                sb.AppendLine("");
                string strPostHeader = sb.ToString();
                byte[] postHeaderBytes = encoding.GetBytes(strPostHeader);

                //写入字符串

                string stringKeyHeader = "\r\n--" + strBoundary +
                           "\r\nContent-Disposition: form-data; name=\"{0}\"" +
                           "\r\n\r\n{1}\r\n";


                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
                request.Timeout = 30000;//设置连接超时时间
                request.UserAgent = this.UserAgent;
                request.Referer = referer;//设置标头
                request.Method = "POST";
                request.ContentType = "multipart/form-data; boundary=" + strBoundary;
                long length = file.InputStream.Length + postHeaderBytes.Length + boundaryBytes.Length;
                request.ContentLength = length;

                byte[] byteArray = new byte[file.InputStream.Length];
                file.InputStream.Read(byteArray, 0, byteArray.Length);

                Stream stream = request.GetRequestStream();
                stream.Write(postHeaderBytes, 0, postHeaderBytes.Length);//头信息
                stream.Write(byteArray, 0, byteArray.Length);
                stream.Write(boundaryBytes, 0, boundaryBytes.Length);//尾部时间戳

                stream.Close();

                HttpWebResponse response = (HttpWebResponse)request.GetResponse();

                if (response.StatusCode == HttpStatusCode.OK && response.ContentLength < 1024 * 2048)//大于2M的文件不读取
                {
                    Stream streamReceive = response.GetResponseStream();
                    //Stream streamReceive = Gzip(response);
                    this._PageEncoding = charset;
                    StreamReader streamReader = new StreamReader(streamReceive, encoding);
                    result = streamReader.ReadToEnd();
                    streamReader.Close();
                    streamReader.Dispose();
                    streamReceive.Close();
                    streamReceive.Dispose();
                }
                else
                {
                    this._isError = true; this._errorMsg = response.StatusCode.ToString();
                }
                this._ContentType = response.ContentType;
                response.Close();

            }
            catch (Exception e) { this._isError = true; this._errorMsg = e.ToString(); }
            return result;
        }
        #endregion

        #region Ping
        public static System.Net.NetworkInformation.IPStatus Ping(string ip)
        {
            System.Net.NetworkInformation.Ping p = new System.Net.NetworkInformation.Ping();
            System.Net.NetworkInformation.PingOptions options = new System.Net.NetworkInformation.PingOptions();
            options.DontFragment = true;
            string data = "atai";
            byte[] buffer = Encoding.ASCII.GetBytes(data);
            //Wait seconds for a reply. 
            int timeout = 1000;
            System.Net.NetworkInformation.PingReply reply = p.Send(ip, timeout, buffer, options);
            return reply.Status;

        }
        #endregion

        #region 读取远程图片
        public static Image GetImage(string imgUrl)
        {
            Image image = null;
            try
            {
                WebRequest webreq = WebRequest.Create(imgUrl);
                System.Net.WebResponse webres = webreq.GetResponse();
                Stream stream = webres.GetResponseStream();
                image = Image.FromStream(stream);
                stream.Close();
            }
            catch (Exception)
            {

            }
            return image;
        }
        #endregion

        #region 上传至远程服务器
        public string HttpUploadFile(string url, System.Web.HttpPostedFile file, NameValueCollection nvc, string paramName = "file")
        {
            string returnValue = "";
            string boundary = "---------------------------" + DateTime.Now.Ticks.ToString("x");
            byte[] boundarybytes = System.Text.Encoding.ASCII.GetBytes("\r\n--" + boundary + "\r\n");

            HttpWebRequest wr = (HttpWebRequest)WebRequest.Create(url);
            wr.ContentType = "multipart/form-data; boundary=" + boundary;
            wr.Method = "POST";
            wr.KeepAlive = true;
            wr.Credentials = System.Net.CredentialCache.DefaultCredentials;

            Stream rs = wr.GetRequestStream();

            string formdataTemplate = "Content-Disposition: form-data; name=\"{0}\"\r\n\r\n{1}";
            foreach (string key in nvc.Keys)
            {
                rs.Write(boundarybytes, 0, boundarybytes.Length);
                string formitem = string.Format(formdataTemplate, key, nvc[key]);
                byte[] formitembytes = System.Text.Encoding.UTF8.GetBytes(formitem);
                rs.Write(formitembytes, 0, formitembytes.Length);
            }
            rs.Write(boundarybytes, 0, boundarybytes.Length);

            string headerTemplate = "Content-Disposition: form-data; name=\"{0}\"; filename=\"{1}\"\r\nContent-Type: application/octet-stream\r\n\r\n";
            string header = string.Format(headerTemplate, paramName, file.FileName);
            byte[] headerbytes = System.Text.Encoding.UTF8.GetBytes(header);
            rs.Write(headerbytes, 0, headerbytes.Length);
            byte[] buffer = new byte[4096];
            int bytesRead = 0;
            while ((bytesRead = file.InputStream.Read(buffer, 0, buffer.Length)) != 0)
            {
                rs.Write(buffer, 0, bytesRead);
            }
            byte[] trailer = System.Text.Encoding.ASCII.GetBytes("\r\n--" + boundary + "--\r\n");
            rs.Write(trailer, 0, trailer.Length);
            rs.Close();
            rs.Dispose();
            WebResponse wresp = null;
            try
            {
                wresp = wr.GetResponse();
                Stream stream2 = wresp.GetResponseStream();
                StreamReader reader2 = new StreamReader(stream2);
                returnValue = reader2.ReadToEnd();
                stream2.Close();
                stream2.Dispose();
                reader2.Close();
                reader2.Dispose();
            }
            catch (Exception)
            {
                if (wresp != null)
                {
                    wresp.Close();
                    wresp = null;
                }
            }
            finally
            {
                wr = null;
            }
            return returnValue;
        }
        #endregion
    }
}

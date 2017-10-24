using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using System.Web;
using JiuZhou.Model;

namespace JiuZhou.HttpTools
{
    //public interface IRequest{ }
    //public interface IRequestBody{ }

    [DataContract]
    public class Request<T>
    {
        [DataMember(Name = "body")]
        public T Body { get; set; }

        private string key = string.Empty;

        [DataMember(Name = "key")]
        public string Key
        {
            get { return key; }
            set { key = value; }
        }

        private RequestHeader header = new RequestHeader();

        [DataMember(Name = "header")]
        public RequestHeader Header
        {
            get { return header; }
            set { header = value; }
        }

        private static string LoginInfo = "LoginUser";
        private static string ClientSign = "ClientSign";
        public RequestHeader NewHeader()
        {         
            var header = new RequestHeader();
            if (HttpContext.Current != null)
            {
                var request = HttpContext.Current.Request;
                var browser = request.Browser;
                var cookies = HttpContext.Current.Request.Cookies.Get(LoginInfo);
                string token = "";
                string userId = "0";
                if (cookies != null && cookies.Values != null)
                {
                    token = cookies.Values.Get("GU");
                    userId = cookies.Values.Get("ID");
                }
                header.DevModel = browser.Type;
                header.DevNo = ClientIdentify;
                header.DevPlat = "WEB";
                header.DevVer = "1.0";
                header.IpAddr = request.UserHostAddress;
                header.PushId = "";
                header.SoftVer = browser.Version;
                header.TokenId = token;
                header.UserId = userId;
                header.use_cache = "NO";
            }
            return header;
        }

        public static string ClientIdentify
        {
            get
            {
                HttpCookie _clientCookie = HttpContext.Current.Request.Cookies[ClientSign];
                if (_clientCookie != null)
                {
                    return _clientCookie.Value;
                }
                else
                {
                    string Identify = Guid.NewGuid().ToString("N");
                    _clientCookie = new HttpCookie(ClientSign);
                    _clientCookie.Value = Identify;
                    _clientCookie.Path = "/";

                    _clientCookie.Domain = "shop.com";
                    //if(ConfigTools.GetConfig.Debug)
                    //    _clientCookie.Domain = "127.0.0.1";//调试状态
                    //else
                    //    _clientCookie.Domain = "dada360.com";//正式发布
                    _clientCookie.Expires = DateTime.MaxValue;

                    HttpContext.Current.Response.Cookies.Add(_clientCookie);
                    return Identify;
                }
            }
        }
    }

    [DataContract]
    public class Request : Request<RequestBodyEmpty> { }

    [DataContract]
    public class RequestBodyEmpty { }

    [DataContract]
    public class RequestHeader
    {
        private string tokenId = string.Empty;

        /// <summary>
        /// 唯一标识
        /// </summary>
        [DataMember(Name = "token_id")]
        public string TokenId
        {
            get { return tokenId; }
            set { tokenId = value; }
        }

        private string userId = string.Empty;

        /// <summary>
        /// 用户ID
        /// </summary>
        [DataMember(Name = "user_id")]
        public string UserId
        {
            get { return userId; }
            set { userId = value; }
        }

        private string devPlat = string.Empty;

        /// <summary>
        /// 设备平台
        /// </summary>
        [DataMember(Name = "dev_plat")]
        public string DevPlat
        {
            get { return devPlat; }
            set { devPlat = value; }
        }

        private string devVer = string.Empty;

        /// <summary>
        /// 设备版本
        /// </summary>
        [DataMember(Name = "dev_ver")]
        public string DevVer
        {
            get { return devVer; }
            set { devVer = value; }
        }

        private string devNo = string.Empty;

        /// <summary>
        /// 手机端-设备号，浏览器端-自动生成的cookie
        /// </summary>
        [DataMember(Name = "dev_no")]
        public string DevNo
        {
            get { return devNo; }
            set { devNo = value; }
        }

        private string devModel = string.Empty;

        /// <summary>
        /// 设备型号
        /// </summary>
        [DataMember(Name = "dev_model")]
        public string DevModel
        {
            get { return devModel; }
            set { devModel = value; }
        }

        private string softVer = string.Empty;
        /// <summary>
        /// 软件版本
        /// </summary>
        [DataMember(Name = "soft_ver")]
        public string SoftVer
        {
            get { return softVer; }
            set { softVer = value; }
        }

        private string pushId = string.Empty;

        /// <summary>
        /// 苹果的推送ID
        /// </summary>
        [DataMember(Name = "push_id")]
        public string PushId
        {
            get { return pushId; }
            set { pushId = value; }
        }

        private string ipAddr = string.Empty;

        /// <summary>
        /// 请求端的IP地址
        /// </summary>
        [DataMember(Name = "ip_addr")]
        public string IpAddr
        {
            get { return ipAddr; }
            set { ipAddr = value; }
        }

        private string Use_cache = string.Empty;
        /// <summary>
        /// 是否缓存
        /// </summary>
        [DataMember]
        public string use_cache 
        {
            get { return Use_cache; }
            set { Use_cache = value; }
        } 
    }

}

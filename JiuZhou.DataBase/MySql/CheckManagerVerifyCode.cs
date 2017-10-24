using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class CheckManagerVerifyCode
    {
        public static Response<CheckCodeInfo> Do(string code)
       {
           ReuestCheckCode body = new ReuestCheckCode();
           body.verify_code = code;

           Request<ReuestCheckCode> request = new Request<ReuestCheckCode>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "CheckManagerVerifyCode";
           string requestStr = JsonHelper.ObjectToJson<Request<ReuestCheckCode>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<CheckCodeInfo>>(responseStr);
           return response;
       }
    }

        [DataContract]
        public class ReuestCheckCode {
            [DataMember]
            public string verify_code { set; get; }
        }

        [DataContract]
        public class CheckCodeInfo {
            [DataMember]
            public string mobile_no { set; get; }

            [DataMember]
            public string last_login_time { set; get; }

            [DataMember]
            public string last_login_ip { set; get; }
        }
}

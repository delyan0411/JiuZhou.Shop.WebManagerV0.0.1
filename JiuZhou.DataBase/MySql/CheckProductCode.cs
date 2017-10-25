using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class CheckProductCode
    {
        public static Response<ResponseBodyEmpty> Do(string code)
       {
           CheckProductCodeInfo body = new CheckProductCodeInfo();
           body.product_code = code;

           Request<CheckProductCodeInfo> request = new Request<CheckProductCodeInfo>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "CheckProductCode";
           string requestStr = JsonHelper.ObjectToJson<Request<CheckProductCodeInfo>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class CheckProductCodeInfo
    {
        [DataMember]
        public string product_code { set; get; }
    }
}

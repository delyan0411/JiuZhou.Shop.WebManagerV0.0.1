using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class CheckQJProduct
    {
        public static Response<CheckQJProductResult> Do(string product_id, string product_code)
        {
            CheckQJProductInfo body = new CheckQJProductInfo();
            body.product_id = product_id;
            body.product_code = product_code;

            Request<CheckQJProductInfo> request = new Request<CheckQJProductInfo>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "CheckAllowProductsQJ";
            string requestStr = JsonHelper.ObjectToJson<Request<CheckQJProductInfo>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<CheckQJProductResult>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class CheckQJProductInfo
    {
        [DataMember]
        public string product_id { set; get; }

        [DataMember]
        public string product_code { set; get; }
    }
    [DataContract]
    public class CheckQJProductResult
    {
        [DataMember]
        public string result { set; get; }
    }
}

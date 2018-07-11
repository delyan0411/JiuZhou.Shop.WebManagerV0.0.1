using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class PushQjProduct
    {
        public static Response<PushQjProductResult> Do(string product_id, string product_type_name)
        {
            PushQjProductInfo body = new PushQjProductInfo();
            body.product_id = product_id;
            body.product_type_name = product_type_name;

            Request<PushQjProductInfo> request = new Request<PushQjProductInfo>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "PushProductForQj";
            string requestStr = JsonHelper.ObjectToJson<Request<PushQjProductInfo>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<PushQjProductResult>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class PushQjProductInfo
    {
        [DataMember]
        public string product_id { set; get; }

        [DataMember]
        public string product_type_name { set; get; }
    }
    [DataContract]
    public class PushQjProductResult
    {
        [DataMember]
        public string result { set; get; }
    }
}

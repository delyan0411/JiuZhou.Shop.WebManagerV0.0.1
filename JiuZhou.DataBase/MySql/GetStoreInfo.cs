using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetStoreInfo
    {
        public static Response<StoreInfo> Do(int id)
        {
            RequestStoreInfoBody body = new RequestStoreInfoBody();
            body.store_id = id.ToString();

            Request<RequestStoreInfoBody> request = new Request<RequestStoreInfoBody>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "GetStoreInfo";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestStoreInfoBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<StoreInfo>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class RequestStoreInfoBody
    {
        [DataMember]
        public string store_id { set; get; }
    }
}

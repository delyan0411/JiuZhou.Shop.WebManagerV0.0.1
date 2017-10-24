using JiuZhou.HttpTools;
using System.Runtime.Serialization;

namespace JiuZhou.MySql
{
    public class OpStore
    {
        public static Response<ResponseBodyEmpty> Do(StoreInfo item)
        {
            RequestOpStoreBody body = new RequestOpStoreBody();
            body.store_id = item.store_id.ToString();
            body.store_name = item.store_name;
            body.create_time = item.create_time;
            Request<RequestOpStoreBody> request = new Request<RequestOpStoreBody>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "OpStore";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestOpStoreBody>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
            return response;
        }
    }
   [DataContract]
   public class RequestOpStoreBody
    {
       [DataMember]
       public string store_id { set; get; }

       [DataMember]
       public string store_name { set; get; }


       [DataMember]
       public string create_time { set; get; }
   } 
}

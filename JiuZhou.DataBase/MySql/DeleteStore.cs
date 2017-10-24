using JiuZhou.HttpTools;
using System.Runtime.Serialization;

namespace JiuZhou.MySql
{
    public class DeleteStore
    {
        public static Response<ResponseBodyEmpty> Do(string ids)
        {
            RequestDeleteStoreBody body = new RequestDeleteStoreBody();
            body.store_ids = ids.Split(',');
            Request<RequestDeleteStoreBody> request = new Request<RequestDeleteStoreBody>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "DeleteStore";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteStoreBody>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class RequestDeleteStoreBody
    {
        [DataMember]
        public string[] store_ids { set; get; }
    }
}

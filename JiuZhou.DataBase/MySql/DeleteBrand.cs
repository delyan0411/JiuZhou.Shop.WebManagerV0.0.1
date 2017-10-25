using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteBrand
    {
        public static Response<ResponseBodyEmpty> Do(string ids)
       {
           RequestDeleteBrandBody body = new RequestDeleteBrandBody();

           body.brand_id = ids.Split(',');

           Request<RequestDeleteBrandBody> request = new Request<RequestDeleteBrandBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "DeleteBrand";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteBrandBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteBrandBody
    {
        [DataMember]
        public string[] brand_id { set; get; }
    }
}

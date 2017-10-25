using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetBrandListAll
    {
        public static Response<ResponseQueryBrandBody> Do(int brand_state)
       {
           RequestBrandBody brandBody = new RequestBrandBody();

           brandBody.brand_state = brand_state.ToString();
           Request<RequestBrandBody> request = new Request<RequestBrandBody>();
           request.Body = brandBody;
           request.Header = request.NewHeader();
           request.Key = "GetBrandListAll";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestBrandBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseQueryBrandBody>>(responseStr);
           if (response == null)
               response = new Response<ResponseQueryBrandBody>();
           return response;
       }
    }

    [DataContract]
    public class RequestBrandBody
    {
        [DataMember]
        public string brand_state { set; get; }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteInsType
    {
        public static Response<ResponseBodyEmpty> Do(int id)
       {
            RequestDeleteInsTypeBody body = new RequestDeleteInsTypeBody();

           body.id = id.ToString();

           Request<RequestDeleteInsTypeBody> request = new Request<RequestDeleteInsTypeBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "DeleteInsuranceType";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteInsTypeBody>>(request);
            Logger.Log(requestStr);
           string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteInsTypeBody
    {
        [DataMember]
        public string id { set; get; }
    }
}

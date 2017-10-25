using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteHomeType
    {
        public static Response<ResponseBodyEmpty> Do(int id)
       {
           RequestDeleteHomeTypeBody body = new RequestDeleteHomeTypeBody();

           body.home_pt_id = id.ToString();

           Request<RequestDeleteHomeTypeBody> request = new Request<RequestDeleteHomeTypeBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "DeleteHomeType";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteHomeTypeBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteHomeTypeBody
    {
        [DataMember]
        public string home_pt_id { set; get; }
    }
}

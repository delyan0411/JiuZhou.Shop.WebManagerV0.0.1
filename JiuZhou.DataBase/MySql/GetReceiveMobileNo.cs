using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetReceiveMobileNo
    {
        public static Response<RecMobile> Do(string no)
       {
           RequestGetRecMobile typeBody = new RequestGetRecMobile();
           typeBody.order_no = no;
            
           Request<RequestGetRecMobile> request = new Request<RequestGetRecMobile>();
           request.Body = typeBody;
           request.Header = request.NewHeader();
           request.Key = "GetReceiveMobileNo";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestGetRecMobile>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<RecMobile>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestGetRecMobile
    {
        [DataMember]
        public string order_no { set; get; }
    }

    [DataContract]
    public class RecMobile
    {
        [DataMember]
        public string receive_mobile_no { set; get; }
    }
}

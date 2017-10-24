using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetOrderCountByState
    {
        public static Response<ResponseOrderCount> Do()
       {
           RequestBodyEmpty body = new RequestBodyEmpty();
           
           Request<RequestBodyEmpty> request = new Request<RequestBodyEmpty>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "GetOrderCountByState";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestBodyEmpty>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseOrderCount>>(responseStr);
           return response;
       }
    }


    [DataContract]
    public class ResponseOrderCount
    {
        [DataMember]
        public int wait_pay_count { set; get; }

        [DataMember]
        public int wait_send_count { set; get; }

        [DataMember]
        public int wait_confirm_count { set; get; }

        [DataMember]
        public int wait_comment_count { set; get; }

        [DataMember]
        public int order_count { set; get; }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetOrderStatisticsInfo
    {
        public static Response<OrderStatisticsInfo> Do(string addtime)
       {
           RequestOrderStatisticsBody orderBody = new RequestOrderStatisticsBody();

           orderBody.add_time = addtime;
           Request<RequestOrderStatisticsBody> request = new Request<RequestOrderStatisticsBody>();
           request.Body = orderBody;
           request.Header = request.NewHeader();
           request.Key = "GetOrderStatisticsInfo";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOrderStatisticsBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<OrderStatisticsInfo>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestOrderStatisticsBody
    {
        [DataMember]
        public string add_time { set; get; }
    }

    [DataContract]
    public class OrderStatisticsInfo
   {
       [DataMember]
        public decimal sale_money { set; get; }

       [DataMember]
       public int pay_order_count { set; get; }
   } 
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetOrderTrackLogInfo
    {
        public static Response<OrderTrackLogList> Do(int orderid)
       {
           RequestOrderTrackLog logBody = new RequestOrderTrackLog();
           logBody.order_id = orderid.ToString();
           Request<RequestOrderTrackLog> request = new Request<RequestOrderTrackLog>();
           request.Body = logBody;
           request.Header = request.NewHeader();
           request.Key = "GetOrderTrackLogList";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOrderTrackLog>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<OrderTrackLogList>>(responseStr);
           return response;
       }
    }

   [DataContract]
   public class RequestOrderTrackLog
   {
       [DataMember]
       public string order_id { set; get; }
   }

   [DataContract]
   public class OrderTrackLogList
   {
       [DataMember]
       public List<OrderTrackLogListInfo> track_log_list { set; get; }
   }

   [DataContract]
   public class OrderTrackLogListInfo
   {
       [DataMember]
       public int track_log_id { set; get; }

       [DataMember]
       public string add_time { set; get; }

       [DataMember]
       public string op_log { set; get; }

       [DataMember]
       public string op_text { set; get; }
   }
}

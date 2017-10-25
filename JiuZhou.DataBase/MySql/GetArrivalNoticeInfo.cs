using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetArrivalNoticeInfo
    {
        public static Response<ResponseArrivalNoticeBody> Do()
       {
           RequestBodyEmpty empty = new RequestBodyEmpty();
           Request<RequestBodyEmpty> request = new Request<RequestBodyEmpty>();
           request.Body = empty;
           request.Header = request.NewHeader();
           request.Key = "GetArrivalNoticeInfo";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestBodyEmpty>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseArrivalNoticeBody>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class ResponseArrivalNoticeBody
    {
        [DataMember]
        public string rec_num { set; get; }
        [DataMember]
        public List<ArrivalNoticeInfo> Arri_list { set; get; }
    }
   [DataContract]
    public class ArrivalNoticeInfo
   {
       [DataMember]
       public int notice_id { set; get; }

       [DataMember]
       public int product_id { set; get; }

       [DataMember]
       public string product_name { set; get; }

       [DataMember]
       public int gift_id { set; get; }

       [DataMember]
       public int product_count { set; get; }

       [DataMember]
       public int gift_count { set; get; }

       [DataMember]
       public DateTime start_time { set; get; }

       [DataMember]
       public DateTime end_time { set; get; }
   } 
}

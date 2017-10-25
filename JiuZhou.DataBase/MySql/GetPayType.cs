using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetPayType
    {
        public static Response<PayTypeList> Do()
       {
            RequestBodyEmpty typeBody = new RequestBodyEmpty();

           Request<RequestBodyEmpty> request = new Request<RequestBodyEmpty>();
           request.Body = typeBody;
           request.Header = request.NewHeader();
           request.Key = "GetPayType";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestBodyEmpty>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<PayTypeList>>(responseStr);
           return response;
       }
    }

   [DataContract]
   public class PayTypeList
   {
       [DataMember]
       public string rec_num { set; get; }

       [DataMember]
       public List<PayTypeInfo> pay_type_list { set; get; }
   }

   [DataContract]
   public class PayTypeInfo {
       [DataMember]
       public int pay_type_id { set; get; }

       [DataMember]
       public string pay_type_name { set; get; }

       [DataMember]
       public string pay_type_logo { set; get; }

       [DataMember]
       public int pay_type_sort { set; get; }

       [DataMember]
       public int pay_online { set; get; }

       [DataMember]
       public int pay_prepay { set; get; }

       [DataMember]
       public decimal pay_rate { set; get; }

       [DataMember]
       public int pay_bank { set; get; }

       [DataMember]
       public int pay_credit { set; get; }
   }
}

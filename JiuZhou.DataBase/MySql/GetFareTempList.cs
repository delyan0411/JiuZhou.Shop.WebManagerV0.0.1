using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetFareTempList
    {
        public static Response<FareTempList> Do(int tempid)
       {
           RequestFareTempBody fareBody = new RequestFareTempBody();

           fareBody.fare_temp_id = tempid.ToString();
           Request<RequestFareTempBody> request = new Request<RequestFareTempBody>();
           request.Body = fareBody;
           request.Header = request.NewHeader();
           request.Key = "GetFareTempList";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestFareTempBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<FareTempList>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestFareTempBody {
        [DataMember]
        public string fare_temp_id { set; get; }
    }

    [DataContract]
    public class FareTempList
    {
        [DataMember]
        public string rec_num {set; get;}

        [DataMember]
        public List<FareTempInfo> fare_temp_list { set; get; }
    }
   [DataContract]
    public class FareTempInfo
   {
       [DataMember]
       public int template_id { set; get; }

       [DataMember]
       public string template_name { set; get; }

       [DataMember]
       public int first_weight { set; get; }

       [DataMember]
       public decimal min_free_price { set; get; }

       [DataMember]
       public int continue_weight { set; get; }

       [DataMember]
       public string template_remark { set; get; }

       [DataMember]
       public int template_priority { set; get; }

       [DataMember]
       public int template_state { set; get; }

       [DataMember]
       public int is_system { set; get; }

       [DataMember]
       public string add_time { set; get; }
   } 
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetReceiveAddrByMobileNo
    {
        public static Response<ResponseAdress> Do(string phone)
       {
           RequestReceiveBody body = new RequestReceiveBody();

           body.mobile_no = phone;
           Request<RequestReceiveBody> request = new Request<RequestReceiveBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "GetReceiveAddrByMobileNo";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestReceiveBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseAdress>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestReceiveBody {
        [DataMember]
        public string mobile_no { set; get; }
    }

    [DataContract]
    public class ResponseAdress
    {
        [DataMember]
        public string rec_num {set; get;}

        [DataMember]
        public List<AdressInfo> addr_list { set; get; }
    }
   [DataContract]
    public class AdressInfo
   {
       [DataMember]
       public int user_id { set; get; }

       [DataMember]
       public int receive_addr_id { set; get; }

       [DataMember]
       public string receive_name { set; get; }

       [DataMember]
       public string province_name { set; get; }

       [DataMember]
       public string city_name { set; get; }

       [DataMember]
       public string county_name { set; get; }

       [DataMember]
       public string receive_addr { set; get; }

       [DataMember]
       public string mobile_no { set; get; }

       [DataMember]
       public string user_tel { set; get; }

       [DataMember]
       public string add_time { set; get; }
   } 
}

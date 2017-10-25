using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class UpdateNeedReceiveAddr
    {
        public static Response<ResponseBodyEmpty> Do(string need_id, string receive_mobile_no, string province_name, string city_name, string county_name, string receive_addr, string receive_name)
       {
           RequestUpdataNeedAddr reset = new RequestUpdataNeedAddr();
           reset.need_id = need_id;
           reset.receive_mobile_no = receive_mobile_no;
           reset.province_name = province_name;
           reset.city_name = city_name;
           reset.county_name = county_name;
           reset.receive_addr = receive_addr;
           reset.receive_name = receive_name;
           reset.flag = "0";
           Request<RequestUpdataNeedAddr> request = new Request<RequestUpdataNeedAddr>();
           request.Body = reset;
           request.Header = request.NewHeader();
           request.Key = "UpdateNeeds";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestUpdataNeedAddr>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestUpdataNeedAddr
   {
       [DataMember]
       public string need_id { set; get; }

       [DataMember]
       public string receive_mobile_no { set; get; }

       [DataMember]
       public string province_name { set; get; }

       [DataMember]
       public string city_name { set; get; }

       [DataMember]
       public string county_name { set; get; }

       [DataMember]
       public string receive_addr { set; get; }

       [DataMember]
       public string receive_name { set; get; }

       [DataMember]
       public string flag { set; get; }
   }
}

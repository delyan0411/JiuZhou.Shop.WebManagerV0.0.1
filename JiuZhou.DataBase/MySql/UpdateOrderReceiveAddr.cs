using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class UpdateOrderReceiveAddr
    {
        public static Response<ResponseBodyEmpty> Do(string orderno, string receivename, string provincename, string cityname, string countyname, string receiveaddr, string mobile, string tel, string zipcode)
       {
           RequestUpdataReceiveAddr reset = new RequestUpdataReceiveAddr();
           reset.order_no = orderno;
           reset.receive_name = receivename;
           reset.province_name = provincename;
           reset.city_name = cityname;
           reset.county_name = countyname;
           reset.receive_addr = receiveaddr;
           reset.receive_mobile_no = mobile;
           reset.receive_user_tel = tel;
           reset.zip_code = zipcode;

           Request<RequestUpdataReceiveAddr> request = new Request<RequestUpdataReceiveAddr>();
           request.Body = reset;
           request.Header = request.NewHeader();
           request.Key = "UpdateOrderReceiveAddr";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestUpdataReceiveAddr>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestUpdataReceiveAddr
   {
       [DataMember]
       public string order_no { set; get; }

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
       public string receive_mobile_no { set; get; }

       [DataMember]
       public string receive_user_tel { set; get; }

       [DataMember]
       public string zip_code { set; get; }
   }
}

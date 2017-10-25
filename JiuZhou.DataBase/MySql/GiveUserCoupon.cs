using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GiveUserCoupon
    {
        public static Response<ResponseBodyEmpty> Do(int id, string name, string price, int num)
       {
           RequestResetCoupon reset = new RequestResetCoupon();
           reset.user_id = id.ToString();
           reset.coupon_name = name;
           reset.coupon_price = price;
           reset.coupon_num = num.ToString();

           Request<RequestResetCoupon> request = new Request<RequestResetCoupon>();
           request.Body = reset;
           request.Header = request.NewHeader();
           request.Key = "GiveUserCoupon";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestResetCoupon>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
    public class RequestResetCoupon
   {
       [DataMember]
       public string user_id { set; get; }

       [DataMember]
       public string coupon_name { set; get; }

       [DataMember]
       public string coupon_price { set; get; }

       [DataMember]
       public string coupon_num{ set; get; }
   }
}

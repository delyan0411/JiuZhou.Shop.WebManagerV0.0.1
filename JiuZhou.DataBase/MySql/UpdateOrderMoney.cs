using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class UpdateOrderMoney
    {
        public static Response<ResponseBodyEmpty> Do(string orderno, decimal money, decimal trans)
       {
           RequestResetPrice reset = new RequestResetPrice();
           reset.order_no = orderno;
           reset.order_money = money.ToString();
           reset.trans_money = trans.ToString();

           Request<RequestResetPrice> request = new Request<RequestResetPrice>();
           request.Body = reset;
           request.Header = request.NewHeader();
           request.Key = "UpdateOrderMoney";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestResetPrice>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestResetPrice
   {
       [DataMember]
       public string order_no { set; get; }

       [DataMember]
       public string order_money { set; get; }

       [DataMember]
       public string trans_money { set; get; }
   }
}

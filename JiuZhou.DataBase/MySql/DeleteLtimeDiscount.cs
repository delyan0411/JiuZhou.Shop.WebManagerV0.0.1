using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteLtimeDiscount
    {
        public static Response<ResponseBodyEmpty> Do(string assids)
       {
           RequestDeleteDiscountBody body = new RequestDeleteDiscountBody();

           body.lt_discount_ids = assids.Split(',');

           Request<RequestDeleteDiscountBody> request = new Request<RequestDeleteDiscountBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "DeleteLtimeDiscount";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteDiscountBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteDiscountBody
    {
        [DataMember]
        public string[] lt_discount_ids { set; get; }
    }
}

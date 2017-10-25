using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteCouponGetRule
    {
        public static Response<ResponseBodyEmpty> Do(string ids)
       {
           RequestDeleteCouponGetRyleBody body = new RequestDeleteCouponGetRyleBody();

           body.cget_rule_id = ids.Split(',');

           Request<RequestDeleteCouponGetRyleBody> request = new Request<RequestDeleteCouponGetRyleBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "DeleteCouponGetRule";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteCouponGetRyleBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteCouponGetRyleBody
    {
        [DataMember]
        public string[] cget_rule_id { set; get; }
    }
}

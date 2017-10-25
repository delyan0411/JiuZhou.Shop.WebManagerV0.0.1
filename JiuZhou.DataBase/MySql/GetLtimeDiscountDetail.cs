using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetLtimeDiscountDetail
    {
        public static Response<DiscountInfo> Do(int ruleid)
        {
            RequestGetKtimeDiscount body = new RequestGetKtimeDiscount();
            body.lt_discount_id = ruleid.ToString();

            Request<RequestGetKtimeDiscount> request = new Request<RequestGetKtimeDiscount>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "GetLtimeDiscountDetail";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestGetKtimeDiscount>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<DiscountInfo>>(responseStr);

            return response;
        }
    }

    [DataContract]
    public class RequestGetKtimeDiscount
    {
        [DataMember]
        public string lt_discount_id { set; get; }
    }
}

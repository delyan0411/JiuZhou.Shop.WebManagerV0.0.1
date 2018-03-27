using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class BalanceRefund
    {
        public static Response<ResponseBodyEmpty> Do(string orderno, int buyerid, int pay_type)
        {
            RequestBalanceRefund body = new RequestBalanceRefund();
            body.order_no = orderno;
            body.buyer_id = buyerid.ToString();
            body.pay_type = pay_type.ToString();
            Request<RequestBalanceRefund> request = new Request<RequestBalanceRefund>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "BalanceRefund";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestBalanceRefund>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class RequestBalanceRefund
    {
        [DataMember]
        public string order_no { set; get; }

        [DataMember]
        public string buyer_id { set; get; }

        [DataMember]
        public string pay_type { set; get; }
    }

}

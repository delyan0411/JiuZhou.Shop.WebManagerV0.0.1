using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class AuditOrder
    {
        public static Response<ResponseBodyEmpty> Do(string orderno, int result)
        {
            RequestAuditOrder body = new RequestAuditOrder();
            body.order_no = orderno;
            body.result = result.ToString();
            Request<RequestAuditOrder> request = new Request<RequestAuditOrder>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "AuditOrder";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestAuditOrder>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class RequestAuditOrder
    {
        [DataMember]
        public string order_no { set; get; }

        [DataMember]
        public string result { set; get; }
    }

}

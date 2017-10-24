using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class AddDeliveryInfo
    {
        public static Response<ResponseBodyEmpty> Do(string orderno, string company, string number)
       {
           RequestAddDeliveryBody delivery = new RequestAddDeliveryBody();

           delivery.order_no = orderno;
           delivery.express_company = company;
           delivery.express_number = number;

           Request<RequestAddDeliveryBody> request = new Request<RequestAddDeliveryBody>();
           request.Body = delivery;
           request.Header = request.NewHeader();
           request.Key = "AddDeliveryInfo";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestAddDeliveryBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestAddDeliveryBody
    {
        [DataMember]
        public string order_no { set; get; }

        [DataMember]
        public string express_company { set; get; }

        [DataMember]
        public string express_number { set; get; }
    } 
}

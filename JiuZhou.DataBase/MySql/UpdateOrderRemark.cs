using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class UpdateOrderRemark
    {
       public static Response<ResponseBodyEmpty> Do(string orderno, string remark)
       {
           RequestUpOrderRemark remarkBody = new RequestUpOrderRemark();
           remarkBody.order_no = orderno;
           remarkBody.inner_remark = remark;
           Request<RequestUpOrderRemark> request = new Request<RequestUpOrderRemark>();
           request.Body = remarkBody;
           request.Header = request.NewHeader();
           request.Key = "UpdateOrderRemark";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestUpOrderRemark>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestUpOrderRemark
   {
       [DataMember]
       public string order_no { set; get; }

       [DataMember]
       public string inner_remark { set; get; }
   }
}

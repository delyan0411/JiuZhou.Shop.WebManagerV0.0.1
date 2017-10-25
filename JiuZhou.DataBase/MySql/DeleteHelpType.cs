using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteHelpType
    {
        public static Response<ResponseBodyEmpty> Do(int id)
       {
           RequestDeleteHelpTypeBody body = new RequestDeleteHelpTypeBody();

           body.help_type_id = id.ToString();

           Request<RequestDeleteHelpTypeBody> request = new Request<RequestDeleteHelpTypeBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "DeleteHelpType";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteHelpTypeBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteHelpTypeBody
    {
        [DataMember]
        public string help_type_id { set; get; }
    }
}

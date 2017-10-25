using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteHelp
    {
        public static Response<ResponseBodyEmpty> Do(string ids)
       {
           RequestDeleteHelpBody body = new RequestDeleteHelpBody();

           body.help_ids = ids.Split(',');

           Request<RequestDeleteHelpBody> request = new Request<RequestDeleteHelpBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "DeleteHelp";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteHelpBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteHelpBody
    {
        [DataMember]
        public string[] help_ids { set; get; }
    }
}

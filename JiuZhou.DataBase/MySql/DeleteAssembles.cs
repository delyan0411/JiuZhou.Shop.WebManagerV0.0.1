using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteAssembles
    {
        public static Response<ResponseBodyEmpty> Do(string assids)
       {
           RequestDeleteAssembleBody productassembleBody = new RequestDeleteAssembleBody();

           productassembleBody.ass_ids = assids;

           Request<RequestDeleteAssembleBody> request = new Request<RequestDeleteAssembleBody>();
           request.Body = productassembleBody;
           request.Header = request.NewHeader();
           request.Key = "DeleteAssembles";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteAssembleBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteAssembleBody
    {
        [DataMember]
        public string ass_ids { set; get; }
    }
}

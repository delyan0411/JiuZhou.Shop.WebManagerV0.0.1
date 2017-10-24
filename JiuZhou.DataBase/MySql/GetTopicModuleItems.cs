using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetTopicModuleItems
    {
        public static Response<ResponseSTopicModuleItem> Do(int mid)
       {
           RequestSTopicModuleItemBody body = new RequestSTopicModuleItemBody();

           body.st_module_id = mid.ToString();

           Request<RequestSTopicModuleItemBody> request = new Request<RequestSTopicModuleItemBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "GetTopicModuleItems";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestSTopicModuleItemBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseSTopicModuleItem>>(responseStr);

           return response;
       }
    }
                  
    [DataContract]
    public class RequestSTopicModuleItemBody {
        [DataMember]
        public string st_module_id { set; get; }
    }

    [DataContract]
    public class ResponseSTopicModuleItem
    {
        [DataMember]
        public List<STItemInfo> item_list { set; get; }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpHelpType
    {
        public static Response<ResponseBodyEmpty> Do(HelpTypeInfo item)
        {
            RequestOpHelpTypeBody body = new RequestOpHelpTypeBody();
            body.help_type_id = item.help_type_id.ToString();
            body.parent_id = item.parent_id.ToString();
            body.type_name = item.type_name;
            body.sort_no = item.sort_no.ToString();

            Request<RequestOpHelpTypeBody> request = new Request<RequestOpHelpTypeBody>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "OpHelpType";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestOpHelpTypeBody>>(request);
            ;
            string responseStr = HttpUtils.HttpPost(requestStr);
            ;
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
            return response;
        }
    }
    [DataContract]
    public class RequestOpHelpTypeBody
    {
        [DataMember]
        public string help_type_id { set; get; }

        [DataMember]
        public string parent_id { set; get; }

        [DataMember]
        public string type_name { set; get; }

        [DataMember]
        public string sort_no { set; get; }
    }
}

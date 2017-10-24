using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetTopicInfoById
    {
        public static Response<STopicInfo> Do(int stid)
       {
           RequestTopicInfoBody body = new RequestTopicInfoBody();

           body.st_id = stid.ToString();

           Request<RequestTopicInfoBody> request = new Request<RequestTopicInfoBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "GetTopicInfo";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestTopicInfoBody>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<STopicInfo>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestTopicInfoBody {
        [DataMember]
        public string st_id { set; get; }
    }

    [DataContract]
    public class STopicInfo
    {
        [DataMember]
        public int st_id { set; get; }

        [DataMember]
        public string st_dir { set; get; }

        [DataMember]
        public string st_subject { set; get; }

        [DataMember]
        public string pic_src { set; get; }

        [DataMember]
        public string start_time { set; get; }

        [DataMember]
        public string end_time { set; get; }

        [DataMember]
        public string st_summary { set; get; }

        [DataMember]
        public string style_text { set; get; }

        [DataMember]
        public string seo_title { set; get; }

        [DataMember]
        public string seo_text { set; get; }

        [DataMember]
        public string seo_key { set; get; }

        [DataMember]
        public int type { set; get; }
    } 
}

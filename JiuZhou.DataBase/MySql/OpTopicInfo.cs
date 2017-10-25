using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpTopicInfo
    {
        public static Response<ResponseBodyEmpty> Do(STopicInfo info)
       {
           OPSTopicInfo body = new OPSTopicInfo();

           body.st_id = info.st_id.ToString();
           body.st_dir = info.st_dir;
           body.st_subject = info.st_subject;
           body.pic_src = info.pic_src;
           body.start_time = info.start_time;
           body.end_time = info.end_time;
           body.seo_title = info.seo_title;
           body.seo_key = info.seo_key;
           body.seo_text = info.seo_text;
           body.style_text = info.style_text;
           body.st_summary = info.st_summary;
            body.type = info.type.ToString();
           Request<OPSTopicInfo> request = new Request<OPSTopicInfo>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "OpTopicInfo";
           string requestStr = JsonHelper.ObjectToJson<Request<OPSTopicInfo>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);

           return response;
       }
    }

    [DataContract]
    public class OPSTopicInfo
    {
        [DataMember]
        public string st_id { set; get; }

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
        public string type { set; get; }
    } 
}

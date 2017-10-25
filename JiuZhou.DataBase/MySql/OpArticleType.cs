using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpArticleType
    {
        public static Response<ResponseBodyEmpty> Do(ArticleTypeInfo item)
        {
            RequestOpArticleTypeBody body = new RequestOpArticleTypeBody();
            body.article_type_id = item.article_type_id.ToString();
            body.parent_id = item.parent_id.ToString();
            body.article_type_name = item.article_type_name;
            body.sort_no = item.sort_no.ToString();

            Request<RequestOpArticleTypeBody> request = new Request<RequestOpArticleTypeBody>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "OpArticleType";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestOpArticleTypeBody>>(request);
            ;
            string responseStr = HttpUtils.HttpPost(requestStr);
            ;
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
            return response;
        }
    }
    [DataContract]
    public class RequestOpArticleTypeBody
    {
        [DataMember]
        public string article_type_id { set; get; }

        [DataMember]
        public string parent_id { set; get; }

        [DataMember]
        public string article_type_name { set; get; }

        [DataMember]
        public string sort_no { set; get; }
    }
}

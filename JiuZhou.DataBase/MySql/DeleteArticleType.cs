using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteArticleType
    {
        public static Response<ResponseBodyEmpty> Do(int id)
       {
           RequestDeleteArticleTypeBody body = new RequestDeleteArticleTypeBody();

           body.article_type_id = id.ToString();

           Request<RequestDeleteArticleTypeBody> request = new Request<RequestDeleteArticleTypeBody>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "DeleteArticleType";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteArticleTypeBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteArticleTypeBody
    {
        [DataMember]
        public string article_type_id { set; get; }
    }
}

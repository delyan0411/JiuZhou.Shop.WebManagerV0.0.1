using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetUserLoginInfo
    {
        public static Response<ShortUserInfo> Do()
       {
           RequestBodyEmpty body = new RequestBodyEmpty();

           Request<RequestBodyEmpty> request = new Request<RequestBodyEmpty>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "GetUserLoginInfo";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestBodyEmpty>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ShortUserInfo>>(responseStr);
      
           return response;
       }
    }
}

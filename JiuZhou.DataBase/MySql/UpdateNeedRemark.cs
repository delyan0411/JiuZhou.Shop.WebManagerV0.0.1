using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class UpdateNeedRemark
    {
       public static Response<ResponseBodyEmpty> Do(string needid, string remark)
       {
           RequestUpNeedRemark remarkBody = new RequestUpNeedRemark();
           remarkBody.need_id = needid;
           remarkBody.inner_remark = remark;
           remarkBody.flag = "1";
           Request<RequestUpNeedRemark> request = new Request<RequestUpNeedRemark>();
           request.Body = remarkBody;
           request.Header = request.NewHeader();
           request.Key = "UpdateNeeds";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestUpNeedRemark>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestUpNeedRemark
   {
       [DataMember]
       public string need_id { set; get; }

       [DataMember]
       public string inner_remark { set; get; }

       [DataMember]
       public string flag { set; get; }
   }
}

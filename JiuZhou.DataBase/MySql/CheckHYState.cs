using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class CheckHYState
    {
        public static Response<CheckHYStateResult> Do(string order_no)
        {
            CheckHYStateInfo body = new CheckHYStateInfo();
            body.order_no = order_no;

            Request<CheckHYStateInfo> request = new Request<CheckHYStateInfo>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "HyOrderPayState";
            string requestStr = JsonHelper.ObjectToJson<Request<CheckHYStateInfo>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<CheckHYStateResult>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class CheckHYStateInfo
    {
        [DataMember]
        public string order_no { set; get; }
    }
    [DataContract]
    public class CheckHYStateResult
    {
        [DataMember]
        public string order_no { set; get; }

        [DataMember]
        public string result { set; get; }
    }
}

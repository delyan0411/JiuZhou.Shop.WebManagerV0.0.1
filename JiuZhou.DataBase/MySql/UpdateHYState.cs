using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class UpdateHYState
    {
        //UpdateHYOrderState
        public static Response<ResponseBodyEmpty> Do(string order_no)
        {
            UpdateHYOrderStateInfo body = new UpdateHYOrderStateInfo();
            body.order_no = order_no;

            Request<UpdateHYOrderStateInfo> request = new Request<UpdateHYOrderStateInfo>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "UpdateHYOrderState";
            string requestStr = JsonHelper.ObjectToJson<Request<UpdateHYOrderStateInfo>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
            return response;
        }
    }

    [DataContract]
    public class UpdateHYOrderStateInfo
    {
        [DataMember]
        public string order_no { set; get; }
    }
}

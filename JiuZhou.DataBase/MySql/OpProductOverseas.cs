using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class OpProductOverseas
    {
        public static Response<ResponseBodyEmpty> Do(OverseasInfo overseasinfo)
        {
            ReqOverseasInfo reqproductinfo = new ReqOverseasInfo();
            Request<ReqOverseasInfo> request = new Request<ReqOverseasInfo>();
            reqproductinfo.id = overseasinfo.id.ToString();
            reqproductinfo.product_id = overseasinfo.product_id;
            reqproductinfo.countrycode = overseasinfo.countrycode;
            reqproductinfo.hscode = overseasinfo.hscode;
            reqproductinfo.taxrate = overseasinfo.taxrate;
            reqproductinfo.isfreetax = overseasinfo.isfreetax.ToString();
            reqproductinfo.freestarttime = overseasinfo.freestarttime;
            reqproductinfo.freeendtime = overseasinfo.freeendtime;
            request.Body = reqproductinfo;
            request.Header = request.NewHeader();
            request.Key = "OpProductOverseas";
            string requestStr = JsonHelper.ObjectToJson<Request<ReqOverseasInfo>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
            return response;
        }
    }
    [DataContract]
    public class ReqOverseasInfo
    {
        [DataMember]
        public string id  { set; get; }

        [DataMember]
        public string product_id { set; get; }

        [DataMember]
        public string countrycode { set; get; }

        [DataMember]
        public string hscode { set; get; }

        [DataMember]
        public string taxrate { set; get; }

        [DataMember]
        public string isfreetax { set; get; }

        [DataMember]
        public string freestarttime { set; get; }

        [DataMember]
        public string freeendtime { set; get; }
    }

}

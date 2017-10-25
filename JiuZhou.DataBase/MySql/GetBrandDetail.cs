using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetBrandDetail
    {
        public static Response<BrandInfo> Do(int brandid)
        {
            RequestGetBrand body = new RequestGetBrand();
            body.brand_id = brandid.ToString();

            Request<RequestGetBrand> request = new Request<RequestGetBrand>();
            request.Body = body;
            request.Header = request.NewHeader();
            request.Key = "GetBrandDetail";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestGetBrand>>(request);
            string responseStr = HttpUtils.HttpPost(requestStr);
            var response = JsonHelper.JsonToObject<Response<BrandInfo>>(responseStr);

            return response;
        }
    }

    [DataContract]
    public class RequestGetBrand
    {
        [DataMember]
        public string brand_id { set; get; }
    }
}

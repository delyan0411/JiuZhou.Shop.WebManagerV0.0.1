using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class NewProductInCategory
    {
        public static ConfigInfo _config = ConnStringConfig.GetConfig;
        public static Response<ResponceNewProductInCategory> Do(string stime, string etime)
       {
           RequestNewProductInCategoryBody search = new RequestNewProductInCategoryBody();

           search.start_time = stime;
           search.end_time = etime;

           Request<RequestNewProductInCategoryBody> request = new Request<RequestNewProductInCategoryBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "NewProductInCategory";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestNewProductInCategoryBody>>(request);
           string responseStr = HttpUtils.HttpPost(_config.UrlDataAnalysis,requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponceNewProductInCategory>>(responseStr);

           return response;
       }
    }

    [DataContract]
    public class RequestNewProductInCategoryBody
    {
        [DataMember]
        public string start_time { set; get; }

        [DataMember]
        public string end_time { set; get; }
    }

    [DataContract]
    public class ResponceNewProductInCategory
    {
        [DataMember]
        public List<NewProductInCategoryInfo> list { set; get; }
    }

    [DataContract]
    public class NewProductInCategoryInfo
    {
        [DataMember]
        public string type_name { set; get; }

        [DataMember]
        public string all_sku_num { set; get; }

        [DataMember]
        public string all_amount { set; get; }

        [DataMember]
        public string sku_num { set; get; }

        [DataMember]
        public string amount { set; get; }

        [DataMember]
        public string rate { set; get; }
    }
}

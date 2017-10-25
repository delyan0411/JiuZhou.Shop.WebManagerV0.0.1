using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpFullOff
    {
        public static Response<ResponseBodyEmpty> Do(FullOffDetail item, string addids, string delids)
       {
           RequestOpFullOff body = new RequestOpFullOff();

           body.fulloff_id = item.fulloff_id.ToString();
           body.fulloff_name = item.fulloff_name;
           body.fulloff_desc = item.fulloff_desc;
           body.img_src = item.img_src;
           body.min_price = item.min_price.ToString();
           body.off_price = item.off_price.ToString();
           body.begin_time = item.begin_time;
           body.end_time = item.end_time;

           body.add_product_ids = addids.Split(',');

           body.del_product_ids = delids.Split(',');
          
           Request<RequestOpFullOff> request = new Request<RequestOpFullOff>();
           request.Body = body;
           request.Header = request.NewHeader();
           request.Key = "OpFullOff";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpFullOff>>(request);
           ;
            /*
           string responseStr = "";
           Logger.Error(requestStr);
           if (delids.Equals(""))
           {
               string[] reusult = requestStr.Split(',');
               reusult[2] = reusult[2].Substring(0, 18) + "[]";
               string requestStr2 = string.Empty;
               int cout = 0;
               foreach (string s in reusult)
               {
                   if (cout == 0)
                   {
                       requestStr2 = s;
                   }
                   else
                   {
                       requestStr2 = requestStr2 + "," + s;
                   }
                   cout++;
               }
               responseStr = HttpUtils.HttpPost(requestStr2);
           }
           else {
               responseStr = HttpUtils.HttpPost(requestStr);
           }
             * */
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);

           return response;
       }
    }

    [DataContract]
    public class RequestOpFullOff
    {
        [DataMember]
        public string fulloff_id { set; get; }

        [DataMember]
        public string fulloff_name { set; get; }

        [DataMember]
        public string img_src { set; get; }

        [DataMember]
        public string fulloff_desc { set; get; }

        [DataMember]
        public string begin_time { set; get; }

        [DataMember]
        public string end_time { set; get; }

        [DataMember]
        public string min_price { set; get; }

        [DataMember]
        public string off_price { set; get; }

        [DataMember]
        public string[] add_product_ids { set; get; }

        [DataMember]
        public string[] del_product_ids { set; get; }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class OpProductJoin
    {
       public static Response<ResponseBodyEmpty> Do(ResponseProductJoinItem joinitem, string deleteids)
       {
           RequestOpProductJoinItemBody joinitembody = new RequestOpProductJoinItemBody();
           joinitembody.product_join_id = joinitem.product_join_id.ToString();
           joinitembody.join_name = joinitem.join_name;
           joinitembody.type_name = joinitem.type_name;
           joinitembody.allow_refresh = joinitem.allow_refresh.ToString();
           joinitembody.view_type = joinitem.view_type.ToString();

           List<RProductJoinItemInfo> rjoinitem = new List<RProductJoinItemInfo>();
           foreach (ProductJoinItemInfo item in joinitem.join_item_list) {
               RProductJoinItemInfo joiniteminfo = new RProductJoinItemInfo();
               joiniteminfo.join_item_id = item.join_item_id.ToString();
               joiniteminfo.product_id = item.product_id.ToString();
               joiniteminfo.item_name = item.item_name;
               joiniteminfo.sort_no = item.sort_no.ToString();
               rjoinitem.Add(joiniteminfo);
           }
           joinitembody.join_item_list = rjoinitem;
           joinitembody.del_join_item_ids = deleteids;

           Request<RequestOpProductJoinItemBody> request = new Request<RequestOpProductJoinItemBody>();
           request.Body = joinitembody;
           request.Header = request.NewHeader();
           request.Key = "OpProductJoin";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestOpProductJoinItemBody>>(request);
           ;
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           
           return response;
       }
    }
   [DataContract]
   public class RequestOpProductJoinItemBody
   {
       [DataMember]
       public string product_join_id { set; get; }

       [DataMember]
       public string type_name { set; get; }

       [DataMember]
       public string join_name { set; get; }

       [DataMember]
       public string allow_refresh { set; get; }

       [DataMember]
       public string view_type { set; get; }

       [DataMember]
       public List<RProductJoinItemInfo> join_item_list { set; get; }

       [DataMember]
       public string del_join_item_ids { set; get; }
   }

   [DataContract]
   public class RProductJoinItemInfo
   {
       [DataMember]
       public string join_item_id { set; get; }

       [DataMember]
       public string item_name { set; get; }

       [DataMember]
       public string product_id { set; get; }

       [DataMember]
       public string sort_no { set; get; }
   }
}

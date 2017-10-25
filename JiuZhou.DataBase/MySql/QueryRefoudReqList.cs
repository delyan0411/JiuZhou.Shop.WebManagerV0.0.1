using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class QueryRefoudReqList
    {
        public static Response<ResponseSearchRefoudReqBody> Do(int pagesize, int pageindex, int _type, string _skey, string sdate, string edate, ref int dataCount, ref int pageCount)
       {
           RequestSearchRefoudReqBody search = new RequestSearchRefoudReqBody();

           search.page_size = pagesize.ToString();
           search.page_no = pageindex.ToString();
           search.refoudreq_state = _type.ToString();
           search.search_key = _skey;
           search.start_date = sdate;
           search.end_date = edate;

           Request<RequestSearchRefoudReqBody> request = new Request<RequestSearchRefoudReqBody>();
           request.Body = search;
           request.Header = request.NewHeader();
           request.Key = "QueryRefoudReqList";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestSearchRefoudReqBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseSearchRefoudReqBody>>(responseStr);
           if (response != null && response.Body != null && response.Body.refoudReq_list != null)
           {
               dataCount = int.Parse(response.Body.rec_num);
               if (dataCount % pagesize == 0)
               {
                   pageCount = dataCount / pagesize;
               }
               else
               {
                   pageCount = dataCount / pagesize + 1;
               }
           }
           return response;
       }
    }

    [DataContract]
    public class RequestSearchRefoudReqBody
    {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string refoudreq_state { set; get; }

        [DataMember]
        public string search_key { set; get; }

        [DataMember]
        public string start_date { set; get; }

        [DataMember]
        public string end_date { set; get; }
    }

    [DataContract]
    public class ResponseSearchRefoudReqBody
    {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<RefoudReqInfo> refoudReq_list { set; get; }
    }

    [DataContract]
    public class RefoudReqInfo
    {
        [DataMember]
        public string id { set; get; }  

        [DataMember]
        public string order_no { set; get; }

        [DataMember]
        public string user_id { set; get; }

        [DataMember]
        public string refoudreq_time { set; get; }

        [DataMember]
        public string refoudreq_reason { set; get; }

        [DataMember]
        public string refoudreq_phone { set; get; }

        [DataMember]
        public string refoudresp_time { set; get; }

        [DataMember]
        public string refoudresp_reason { set; get; }

        [DataMember]
        public string state { set; get; }

    } 
}

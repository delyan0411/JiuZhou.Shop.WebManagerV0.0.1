using JiuZhou.HttpTools;
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace JiuZhou.MySql
{
    public class QueryInsuranceTypeList
    {
        public static Response<ResponseQueryInsuranceTypeListBody> Do(int pagesize, int pageindex, int insurancetype, ref int dataCount, ref int pageCount)
        {
            RequestQueryInsuranceTypeListBody search = new RequestQueryInsuranceTypeListBody();

            search.page_size = pagesize.ToString();
            search.page_no = pageindex.ToString();
            search.insurancetype = insurancetype.ToString();

            Request<RequestQueryInsuranceTypeListBody> request = new Request<RequestQueryInsuranceTypeListBody>();
            request.Body = search;
            request.Header = request.NewHeader();
            request.Key = "QueryInsusertypeList";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestQueryInsuranceTypeListBody>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<ResponseQueryInsuranceTypeListBody>>(responseStr);            
            if (response != null && response.Body != null && response.Body.rec_num != null)
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
    public class RequestQueryInsuranceTypeListBody
    {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

        [DataMember]
        public string insurancetype { set; get; }
    }

    [DataContract]
    public class ResponseQueryInsuranceTypeListBody
    {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<InsurancetypeInfo> insusertype_list { set; get; }
    }
}

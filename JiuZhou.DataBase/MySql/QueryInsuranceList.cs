using JiuZhou.HttpTools;
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace JiuZhou.MySql
{
    public class QueryInsuranceList
    {
        public static Response<ResponseQueInsuranceListBody> Do(int pagesize, int pageindex,  ref int dataCount, ref int pageCount)
        {
            RequestSearchInsuranceListBody search = new RequestSearchInsuranceListBody();

            search.page_size = pagesize.ToString();
            search.page_no = pageindex.ToString();

            Request<RequestSearchInsuranceListBody> request = new Request<RequestSearchInsuranceListBody>();
            request.Body = search;
            request.Header = request.NewHeader();
            request.Key = "QueryInsuranceList";
            string requestStr = JsonHelper.ObjectToJson<Request<RequestSearchInsuranceListBody>>(request);
            Logger.Log(requestStr);
            string responseStr = HttpUtils.HttpPost(requestStr);
            Logger.Log(responseStr);
            var response = JsonHelper.JsonToObject<Response<ResponseQueInsuranceListBody>>(responseStr);            
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
    public class RequestSearchInsuranceListBody
    {
        [DataMember]
        public string page_size { set; get; }

        [DataMember]
        public string page_no { set; get; }

    }

    [DataContract]
    public class ResponseQueInsuranceListBody
    {
        [DataMember]
        public string rec_num { set; get; }

        [DataMember]
        public List<InsuranceInfo> insurance_list { set; get; }
    }
}

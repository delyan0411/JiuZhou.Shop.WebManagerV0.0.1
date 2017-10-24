using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class AddSysPicFile
    {
        public static Response<ResponseBodyEmpty> Do(SysFilesInfo file)
       {
           SysPicFile picfile = new SysPicFile();

           picfile.sp_type_id = file.sp_type_id.ToString();
           picfile.file_name = file.file_name;
           picfile.save_name = file.save_name;
           picfile.save_path = file.save_path;
           picfile.client_ip = file.client_ip;
           picfile.user_agent = file.user_agent;

           Request<SysPicFile> request = new Request<SysPicFile>();
           request.Body = picfile;
           request.Header = request.NewHeader();
           request.Key = "AddSysPicFile";
           string requestStr = JsonHelper.ObjectToJson<Request<SysPicFile>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class SysPicFile
    {
        [DataMember]
        public string sp_type_id { set; get; }

        [DataMember]
        public string file_name { set; get; }

        [DataMember]
        public string save_name { set; get; }

        [DataMember]
        public string save_path { set; get; }

        [DataMember]
        public string client_ip { set; get; }

        [DataMember]
        public string user_agent { set; get; }
    } 
}

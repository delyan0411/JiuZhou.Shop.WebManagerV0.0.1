
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    [DataContract]
   public class ResponseFile{
 
        [DataMember]
        public List<FileNameList> fileNameList {set; get; }

        [DataMember]
        public string addressPrefix {set; get;}
   }

    [DataContract]
    public class FileNameList{
        [DataMember]
        public string fileKey { set; get; }

        [DataMember]
        public string fileUrl { set; get; }
    }
}

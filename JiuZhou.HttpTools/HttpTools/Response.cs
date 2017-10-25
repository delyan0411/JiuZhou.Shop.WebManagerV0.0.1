using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace JiuZhou.HttpTools
{
    //public interface IResponse { }

    //public interface IResponseBody { }

    [DataContract]
    public class ResponseBodyEmpty { }

    [DataContract]
    public class Response<T>
    {
        private string key = string.Empty;

        [DataMember(Name = "key")]
        public string Key
        {
            get { return key; }
            set { key = value; }
        }

        private ResponseHeader header = new ResponseHeader();

        [DataMember(Name = "header")]
        public ResponseHeader Header
        {
            get { return header; }
            set { header = value; }
        }
        
        [DataMember(Name = "body", EmitDefaultValue = false)]
        public T Body
        {
            set;
            get;
        }
    }

    [DataContract]
    public class ResponseHeader
    {
        private string tokenId = string.Empty;

        [DataMember(Name = "token_id", EmitDefaultValue=false)]
        public string TokenId
        {
            get { return tokenId; }
            set { tokenId = value; }
        }

        private ResponseResult result = new ResponseResult();

        [DataMember(Name = "ret_result")]
        public ResponseResult Result
        {
            get { return result; }
            set { result = value; }
        }
    }

    [DataContract]
    public class ResponseResult
    {

        private string code = string.Empty;

        [DataMember(Name = "ret_code")]
        public string Code
        {
            get { return code; }
            set { code = value; }
        }

        private string msg = string.Empty;

        [DataMember(Name = "ret_msg")]
        public string Msg
        {
            set { msg = value; }
            get { return msg; }
        }
    }

    [DataContract]
    public class Response : Response<ResponseBodyEmpty> { }
}

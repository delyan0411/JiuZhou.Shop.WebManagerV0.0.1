using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class DeleteProductAlbum
    {
        public static Response<ResponseBodyEmpty> Do(int albumId)
       {
           RequestDeleteImageBody productImgBody = new RequestDeleteImageBody();

           productImgBody.product_album_id = albumId.ToString();

           Request<RequestDeleteImageBody> request = new Request<RequestDeleteImageBody>();
           request.Body = productImgBody;
           request.Header = request.NewHeader();
           request.Key = "DeleteProductAlbum";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestDeleteImageBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestDeleteImageBody
    {
        [DataMember]
        public string product_album_id { set; get; }
    }
}

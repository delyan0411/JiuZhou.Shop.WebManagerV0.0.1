using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;

namespace JiuZhou.MySql
{
    public class GetProductAlbum
    {
        public static Response<ResponseProductAlbum> Do(int productId)
       {
           RequestProductAlbumBody shopsBody = new RequestProductAlbumBody();

           shopsBody.product_id = productId.ToString();
           Request<RequestProductAlbumBody> request = new Request<RequestProductAlbumBody>();
           request.Body = shopsBody;
           request.Header = request.NewHeader();
           request.Key = "GetProductAlbum";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestProductAlbumBody>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           var response = JsonHelper.JsonToObject<Response<ResponseProductAlbum>>(responseStr);
           return response;
       }
    }

    [DataContract]
    public class RequestProductAlbumBody {
        [DataMember]
        public string product_id { set; get; }
    }

    [DataContract]
    public class ResponseProductAlbum
    {
        [DataMember]
        public string rec_num {set; get;}

        [DataMember]
        public List<ProductAlbumList> pic_list { set; get; }
    }
   [DataContract]
    public class ProductAlbumList
   {
       [DataMember]
       public int product_album_id { set; get; }

       [DataMember]
       public string album_name { set; get; }

       [DataMember]
       public int is_main { set; get; }

       [DataMember]
       public string img_src { set; get; }
   } 
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using JiuZhou.HttpTools;
using JiuZhou.Model;

namespace JiuZhou.MySql
{
    public class OpProductAlbum
    {
       public static Response<ResponseBodyEmpty> Do(int productid, List<ProductAlbumInfo> productInfo)
       {
           RequestProductAlbumInfo reqproductAlbumInfo = new RequestProductAlbumInfo();
           reqproductAlbumInfo.product_id = productid.ToString();
           List<ProductAlbum> album_list = new List<ProductAlbum>();
           foreach (ProductAlbumInfo item in productInfo) {
               ProductAlbum product_album = new ProductAlbum();
               product_album.product_album_id = item.product_album_id.ToString();
               product_album.album_name = item.album_name;
               product_album.img_src = item.img_src;
               product_album.is_main = item.is_main.ToString();
               album_list.Add(product_album);
           }

           reqproductAlbumInfo.product_album_list = album_list;

           Request<RequestProductAlbumInfo> request = new Request<RequestProductAlbumInfo>();
           request.Body = reqproductAlbumInfo;
           request.Header = request.NewHeader();
           request.Key = "OpProductAlbum";
           string requestStr = JsonHelper.ObjectToJson<Request<RequestProductAlbumInfo>>(request);
           string responseStr = HttpUtils.HttpPost(requestStr);
           ;
           var response = JsonHelper.JsonToObject<Response<ResponseBodyEmpty>>(responseStr);
           return response;
       }
    }
   [DataContract]
   public class RequestProductAlbumInfo
   {
       [DataMember]
       public string product_id { set; get; }

       [DataMember]
       public List<ProductAlbum> product_album_list { set; get; }
   }

   [DataContract]
   public class ProductAlbum
   {
       [DataMember]
       public string product_album_id { set; get; }

       [DataMember]
       public string album_name { set; get; }

       [DataMember]
       public string img_src { set; get; }

       [DataMember]
       public string is_main { set; get; }
   }
}

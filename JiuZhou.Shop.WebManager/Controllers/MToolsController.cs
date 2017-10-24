using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Xml;
using System.Xml.XPath;
using System.Net;

using JiuZhou.ControllerBase;
using JiuZhou.HttpTools;
using JiuZhou.MySql;
using JiuZhou.Common;
using JiuZhou.Common.Tools;
using JiuZhou.Model;
using System.Collections.Specialized;

using JiuZhou.XmlSource;
using System.IO;
using System.Data;
using JiuZhou.Cache;

namespace JiuZhou.Shop.WebManager.Controllers
{
    public class ToolsController : ToolsBaseController
    {

    }

    public class MToolsController : ForeSysBaseController
    {
        public static ConfigInfo config = JiuZhou.HttpTools.ConnStringConfig.GetConfig;//网站配置

        #region 根据父ID获取子菜单
        public void GetHtmlNodes()
        {
            int rootId = DoRequest.RequestInt("parentid", 0);
            List<UserResBody> nodes = base._userResBody.FindAll(delegate(UserResBody item) { return item.parent_id == rootId; });
            int _count = 0;
            Response.Write("<dl>\n");
            foreach (UserResBody node in nodes)
            {
               // if (!USysGroupDB.HasNode(base._sysGroupItems, base._currManager.IsSysUser ? "" : node.NodeCode))
                 //   continue;
                if (_count == 0)
                {
                    Response.Write("<dt class=\"first\">" + node.res_name + "</dt>\n");
                }
                else
                {
                    Response.Write("<dt>" + node.res_name + "</dt>\n");
                }
                _count++;
                List<UserResBody> cNodes = base._userResBody.FindAll(delegate(UserResBody item) { return item.parent_id == node.res_id; });
                foreach (UserResBody em in cNodes)
                {
                  //  if (!USysGroupDB.HasNode(base._sysGroupItems, base._currManager.IsSysUser ? "" : em.NodeCode))
                    //    continue;
                    string url = "javascript:void(0);";
                    if (!string.IsNullOrEmpty(em.res_src))
                        url = em.res_src;
                    Response.Write("<dd val=\"" + em.res_path + "\"><a href=\"" + url + "\" title=\"" + em.res_name + "\">" + em.res_name + "</a></dd>\n");
                }
            }
            Response.Write("</dl>\n");
        }
        #endregion

        #region GetProductInfo
        [HttpPost]
        public ActionResult GetProductInfo()
        {
            int productid = DoRequest.GetFormInt("productid");
            ProductSeo product = new ProductSeo();
            var res = GetProductSeo.Do(productid);
            if (res != null && res.Body != null)
                product = res.Body;
            
            return Json(product, JsonRequestBehavior.AllowGet);
            //return Json(new {productname=product.product_name, seotitle=product.seo_title, seotext=product.seo_text,seokey=product.seo_key }, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region GetProductInfo2
        [HttpPost]
        public ActionResult GetProductInfo2()
        {
            int productid = DoRequest.GetFormInt("productid");
            ShortProductInfo product = new ShortProductInfo();
            var res = GetShortProductsByProductIds.Do(productid.ToString());
            if (res != null && res.Body != null && res.Body.product_list != null)
                product = res.Body.product_list[0];
            return Json(product, JsonRequestBehavior.AllowGet);
            //return Json(new {productname=product.product_name, seotitle=product.seo_title, seotext=product.seo_text,seokey=product.seo_key }, JsonRequestBehavior.AllowGet);
        }
        #endregion


        #region GetProductSkuList
        public ActionResult GetProductSkuList()
        {
            int productid = DoRequest.RequestInt("productid");
            List<SkuList> list = new List<SkuList>();
            var res = GetSkusByProductId.Do(productid);
            if (res != null && res.Body != null && res.Body.sku_list != null)
                list = res.Body.sku_list;

            return Json(new { data = list }, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region 已上传的图片列表
        public ActionResult GetImageList()
        {
            int pagesize = DoRequest.GetFormInt("size", 15);
            int pageindex = DoRequest.GetFormInt("page", 1);
            //string code = DoRequest.GetFormString("path");
            DateTime startDate = DoRequest.GetFormDate("sDate",DateTime.Now.AddYears(-100));
            DateTime endDate = DoRequest.GetFormDate("eDate", DateTime.Now);
            string query = DoRequest.GetFormString("query");
            int dataCount = 0;
            int pageCount = 0;

            List<PicFile> list = new List<PicFile>();
            var res = GetSysPicFile.Do(pagesize, pageindex, 3, startDate, endDate, query, ref dataCount, ref pageCount);
            if (res != null && res.Body != null && res.Body.pic_file_list != null)
                list = res.Body.pic_file_list;
            UpLoadFile upload = new UpLoadFile(false);
            return Json(new { error = false, total = dataCount, size = pagesize, pages = pageCount, page = pageindex, root = base._config.UrlImages, data = list }, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region 图片上传
        [HttpPost]
        public ActionResult UploadImage2()
        {
            HttpFileCollection postfiles = System.Web.HttpContext.Current.Request.Files;
            Robots robots = null;
            if (postfiles[0] != null && postfiles[0].FileName != null && postfiles[0].FileName != "")
            {
                string ext = postfiles[0].FileName.Substring(postfiles[0].FileName.LastIndexOf('.') + 1).ToLower();
                if (ext != "jpg" && ext != "jpeg" && ext != "gif" && ext != "bmp" && ext != "png")
                    return Json(new { error = true, message = "文件类型只能为jpg,jpeg,gif,bmp,png！" }, JsonRequestBehavior.AllowGet);
                
                NameValueCollection myCol = new NameValueCollection();
                robots = new Robots();
                string s = robots.HttpUploadFile(config.UrlImagesUpload, postfiles[0], myCol, "file");
                if (robots.IsError)
                {  
                    return Json(new { error = true, message = robots.ErrorMsg }, JsonRequestBehavior.AllowGet);
                }
                
                ResponseFile file = JsonHelper.JsonToObject<Response<ResponseFile>>(s).Body;
                string uploadSaveMapPath = JsonHelper.JsonToObject<Response<ResponseFile>>(s).Body.fileNameList[0].fileKey;

                uploadSaveMapPath = uploadSaveMapPath.Replace("jianbao/website/", "");
                string savepath = uploadSaveMapPath;
                string fullpathXX = JsonHelper.JsonToObject<Response<ResponseFile>>(s).Body.fileNameList[0].fileUrl;

                var returnVal = -1;
                #region 存储到数据表
                SysFilesInfo picfile = new SysFilesInfo();
                picfile.sp_type_id = 1;//未分类
                picfile.file_name = postfiles[0].FileName;
                picfile.save_name = uploadSaveMapPath.Substring(uploadSaveMapPath.LastIndexOf("/")+1);

                if (uploadSaveMapPath.StartsWith("/"))
                {
                    picfile.save_path = uploadSaveMapPath.Substring(1);
                }
                else {
                    picfile.save_path = uploadSaveMapPath;
                }
                picfile.user_agent = DoRequest.UserAgent;
                picfile.client_ip = DoRequest.ClientIP;
                var res = AddSysPicFile.Do(picfile);
                if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                    returnVal = Utils.StrToInt(res.Header.Result.Code, -1);
                #endregion
                if (returnVal == 0)
                {
                    uploadSaveMapPath = config.UrlImages + uploadSaveMapPath;
                    return Json(new { error = false, message = "成功",save=savepath, image = uploadSaveMapPath, fullPath = fullpathXX }, JsonRequestBehavior.AllowGet);
                }
                else {
                    return Json(new { error = true, message = "图片保存失败，请重新上传！" }, JsonRequestBehavior.AllowGet);
                }
            }else{
                    return Json(new { error = true, message = "失败,请重新选择文件！" }, JsonRequestBehavior.AllowGet);
            }
               

        }
       #endregion

        #region 格式化json
        private JsonResult formatJson(JsonResult json)
        {
            json.ContentType = "text/html";
            return json;
        }
        #endregion

        #region 图片上传
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult UploadImage()
        {
            //Response.Charset = "utf-8";
            //Response.ContentType = "text/javascript";
            int typeId = DoRequest.GetFormInt("code");//图片分类编码
            string allow = DoRequest.GetFormString("allow").ToLower().Trim();//允许上传哪些后缀的图片,多个后缀使用逗号隔开，缺省为允许jpg/jpeg/gif/png/bmp
            List<string> allowList = new List<string>();
            string[] arr = allow.Split(',');
            string _fullpath = "";
            foreach (string s in arr)
            {
                if (string.IsNullOrEmpty(s))
                    continue;
                string val = s.Trim();
                if (val.StartsWith(".")) val = val.Substring(1);
                allowList.Add(val);
            }
          
            if (!UpLoadFile.IsPostFile())
            {
                return this.formatJson(Json(new { error = true, message = "请选择上传的文件" }));
            }
            var returnValue = -1;
            Robots robots = null;
            HttpFileCollection postfiles = System.Web.HttpContext.Current.Request.Files;
            if (postfiles[0] != null && postfiles[0].FileName != null && postfiles[0].FileName != "")
            {
                HttpPostedFile file = postfiles[0];
                try
                {
                    string ext = file.FileName.ToLower().Substring(file.FileName.LastIndexOf('.') + 1).ToLower();
                    if (ext == "jpg" || ext == "jpeg" || ext == "gif" || ext == "bmp" || ext == "png")
                    {
                     
                    }
                    else
                    {
                        return this.formatJson(Json(new { error = true, message = "不允许上传此类型文件" }));
                    }
                }
                catch (Exception e)
                {
                    Logger.Error(e.ToString());
                }
                NameValueCollection myCol = new NameValueCollection();
                robots = new Robots();
                string s = robots.HttpUploadFile(config.UrlImagesUpload, file, myCol, "file");
                if (robots.IsError)
                {
                    return this.formatJson(Json(new { error = true, message = robots.ErrorMsg }));
                }
                string uploadSaveMapPath = JsonHelper.JsonToObject<Response<ResponseFile>>(s).Body.fileNameList[0].fileKey;

                uploadSaveMapPath = uploadSaveMapPath.Replace("jianbao/website/", "");
                string savepath = uploadSaveMapPath;
                string fullpathXX = JsonHelper.JsonToObject<Response<ResponseFile>>(s).Body.fileNameList[0].fileUrl;
                _fullpath = fullpathXX;
                #region 存储到数据表
                SysFilesInfo picfile = new SysFilesInfo();
                picfile.sp_type_id = typeId;//未分类
                picfile.file_name = postfiles[0].FileName;
                picfile.save_name = uploadSaveMapPath.Substring(uploadSaveMapPath.LastIndexOf("/") + 1);

                if (uploadSaveMapPath.StartsWith("/"))
                {
                    picfile.save_path = uploadSaveMapPath.Substring(1);
                }
                else {
                    picfile.save_path = uploadSaveMapPath;
                }
                picfile.user_agent = DoRequest.UserAgent;
                picfile.client_ip = DoRequest.ClientIP;
                 var res = AddSysPicFile.Do(picfile);
                  if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                      returnValue = Utils.StrToInt(res.Header.Result.Code, -1);
                #endregion    
            }
            if (returnValue == 0)
            {
                return this.formatJson(Json(new { error = false, message = "上传成功!", path = _fullpath }));
            }
            return this.formatJson(Json(new { error = true, message = "上传失败..." }));

        }
        #endregion

        #region GetProductTypeInfo
        [HttpPost]
        public ActionResult GetProductTypeInfo()
        {
            int parentId = DoRequest.GetFormInt("parentId");
            int itemId = DoRequest.GetFormInt("itemId");

            List<TypeList> tList = new List<TypeList>();
            var res = GetTypeListAll.Do(-1);
            if (res != null && res.Body != null && res.Body.type_list != null)
                tList = res.Body.type_list;

            TypeList pInfo = new TypeList();
            TypeList tInfo = new TypeList();

            List<TypeList> temList = tList.FindAll(
                    delegate(TypeList item)
                    {
                        return item.product_type_id == parentId;
                    });
            if (temList.Count > 0) pInfo = temList[0];
            //子分类
            temList = tList.FindAll(
                    delegate(TypeList item)
                    {
                        return item.product_type_id == itemId;
                    });
            if (temList.Count > 0) tInfo = temList[0];

            #region 设置排序
            if (tInfo.product_type_id < 1)
            {
                temList = tList.FindAll(
                    delegate(TypeList item)
                    {
                        return item.parent_type_id == parentId;
                    });
                int sort = 0;
                foreach (TypeList em in temList)
                {
                    if (em.sort_no > sort) sort = em.sort_no;
                }
                sort++;
                tInfo.sort_no = sort;
            }
            #endregion

            #region 分类名路径
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            string[] arr = null;
            sb.Append("根");
            if (pInfo.product_type_path != null)
            {
                arr = pInfo.product_type_path.Split(',');
                foreach (string s in arr)
                {
                    if (string.IsNullOrEmpty(s))
                        continue;
                    int val = Utils.StrToInt(s.Trim());
                    List<TypeList> list = tList.FindAll(
                        delegate(TypeList item)
                        {
                            return item.product_type_id == val;
                        });
                    if (list.Count > 0)
                    {
                        sb.Append(" >> " + list[0].type_name);
                    }
                }
            }
            #endregion

            return Json(new { parent = pInfo, type = tInfo, parentName = sb.ToString() }, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region GetProductList
        public ActionResult GetProductList()
        {
            string ids = DoRequest.Request("ids");
            List<ProductAssembleList> list = GetProductAsseembleListByIds.Do(ids).Body.ass_list;
            foreach(ProductAssembleList item in list){
                DateTime _sDate = DateTime.Parse(item.promotion_bdate);
                DateTime _eDate = DateTime.Parse(item.promotion_edate);
                if (_sDate <= DateTime.Now && DateTime.Now <= _eDate)
                {
                    item.sale_price = item.promotion_price;//促销价
                }
            }         

            return Json(list, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region GetProductList2
        public ActionResult GetProductList2()
        {
            string ids = DoRequest.Request("ids");
            List<ShortProductInfo> list = new List<ShortProductInfo>();
            var res = GetShortProductsByProductIds.Do(ids);
            if (res != null && res.Body != null && res.Body.product_list != null)
                list = res.Body.product_list;
            foreach (ShortProductInfo item in list)
            {
                DateTime _sDate = DateTime.Parse(item.promotion_bdate);
                DateTime _eDate = DateTime.Parse(item.promotion_edate);
                if (_sDate <= DateTime.Now && DateTime.Now <= _eDate)
                {
                    item.sale_price = item.promotion_price;//促销价
                }
            }

            List<TypeList> tList = GetTypeListAll.Do(-1).Body.type_list;
            foreach (ShortProductInfo item in list) {
                string path = item.product_type_path;
                string[] _tem = path.Split(',');
                int _xCount = 0;
                for (int x = 0; x < _tem.Length; x++)
                {
                    if (string.IsNullOrEmpty(_tem[x].Trim())) continue;
                    int _v = Utils.StrToInt(_tem[x].Trim());
                    foreach (TypeList em in tList)
                    {
                        if (em.product_type_id == _v)
                        {
                            if (_xCount > 0) item.type_name += (" &gt;&gt; ");
                            item.type_name += (em.type_name);
                            _xCount++;
                        }
                    }
                }
            }

            return Json(list, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region GetProductInfoByProductNumber
        [HttpPost]
        public ActionResult GetProductInfoByProductNumber()
        {
            string productNumber = DoRequest.GetFormString("productNumber");
            ProductInfoByCode product = new ProductInfoByCode();
            var res = GetProductInfoByCode.Do(productNumber);
            if (res == null || res.Body == null || res.Body.product_id < 1)
            {
                return Json(new { error = true, message = "未找到商品！" }, JsonRequestBehavior.AllowGet);
            }
            else {
                product = res.Body;
            }
            return Json(new { error = false, message = "成功！", product }, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region SeachProduct 搜索商品
        [ValidateInput(false)]
        public ActionResult SeachProduct()
        {
            int pagesize = DoRequest.RequestInt("size", 10);
            int pageindex = DoRequest.RequestInt("page", 1);
            if (pagesize > 100) pagesize = 100;
            if (pageindex < 1) pageindex = 1;
            int sType = DoRequest.RequestInt("stype");
            int isonsale = DoRequest.RequestInt("isonsale",1);

            string q = DoRequest.HtmlEncode(DoRequest.Request("q").Trim());
            string sKey = "";
            #region 处理查询关键词中的空格
            string[] qList = q.Split(' ');
            for (int i = 0; i < qList.Length; i++)
            {
                if (string.IsNullOrEmpty(qList[i].Trim()))
                    continue;
                if (i > 0)
                    sKey += " ";
                sKey += qList[i];
            }
            q = sKey;
            #endregion
            if (sKey.Length > 50)
                sKey = Utils.CutString(sKey, 0, 50);

            int dataCount = 0;
            int pageCount = 0;
            List<ProductsInfo> _table = new List<ProductsInfo>();
            var res = QueryProductInfo.Do(pagesize, pageindex
                , 0
                , -1
                , -1
                , sType
                , isonsale
                , 1
                , sKey
                , "modifytime"
                , "desc"
                , ref dataCount
                , ref pageCount);
            if (res != null && res.Body != null && res.Body.product_list != null)
                _table = res.Body.product_list;

            List<ShortProductInfo> list = new List<ShortProductInfo>();
           // System.Text.StringBuilder ids = new System.Text.StringBuilder();
            //ids.Append("0");
            foreach (ProductsInfo item in _table)
            {
                #region
                ShortProductInfo Info = new ShortProductInfo();
                Info.product_id = item.product_id;
                Info.product_code = item.product_code;
                Info.product_name = item.product_name;
                Info.product_type_path = item.product_type_path;
                Info.product_type_id = item.product_type_id;

                Info.market_price = item.market_price;
                Info.sale_price = item.sale_price;
                Info.mobile_price = item.mobile_price;

                decimal _promotion_price = item.promotion_price;
                DateTime _sDate = DateTime.Parse(item.promotion_bdate);
                DateTime _eDate = DateTime.Parse(item.promotion_edate);
                if (_sDate <= DateTime.Now && DateTime.Now <= _eDate)
                {
                    Info.sale_price = _promotion_price;//促销价
                }
                Info.product_brand = item.product_brand;
                Info.stock_num = item.stock_num;

                Info.sales_promotion = item.sales_promotion;
                Info.product_spec = item.product_spec;

                Info.shop_id = item.shop_id;
                Info.img_src = item.img_src;
                Info.sku_count = item.sku_count;
                #endregion
                list.Add(Info);
            }
            
            return Json(new
            {
                dataCount = dataCount
                ,
                pageCount = pageCount
                ,
                size = pagesize
                ,
                index = pageindex
                ,
                data = list
            }
                , JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region 文件上传
        [HttpPost]
        public ActionResult UploadFiles()
        {

            HttpFileCollection postfiles = System.Web.HttpContext.Current.Request.Files;
            Robots robots = null;
            if (postfiles[0] != null && postfiles[0].FileName != null && postfiles[0].FileName != "")
            {
                NameValueCollection myCol = new NameValueCollection();
                System.Text.StringBuilder url = new System.Text.StringBuilder();
                url.Append(base._config.UrlHome + "tools/UploadFiles?");
                url.Append(Cookies.CreateVerifyString());
                robots = new Robots();
                string s = robots.HttpUploadFile(url.ToString(), postfiles[0], myCol, "file");
                if (robots.IsError)
                {
                    return Json(new { error = true, message = robots.ErrorMsg }, JsonRequestBehavior.AllowGet);
                }
                return Json(new { error=false,message = s},JsonRequestBehavior.AllowGet);
              //  ResponseFile file = JsonHelper.JsonToObject<Response<ResponseFile>>(s).Body;
               // string uploadSaveMapPath = JsonHelper.JsonToObject<Response<ResponseFile>>(s).Body.fileNameList[0].fileKey;
               // string fullpathXX = JsonHelper.JsonToObject<Response<ResponseFile>>(s).Body.fileNameList[0].fileUrl;
                //return Json(new { error = false, message = "成功", image = uploadSaveMapPath, fullPath = fullpathXX }, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(new { error = true, message = "请选择文件！" }, JsonRequestBehavior.AllowGet);
            }
            /*
            string returnUrl = DoRequest.GetFormString("returnurl").Trim();

            if (!UpLoadFile.IsPostFile())
            {
                return Json(new { error = true, message = "请选择上传的文件" });
            }
            HttpFileCollection postfiles = System.Web.HttpContext.Current.Request.Files;
            if (postfiles[0] != null && postfiles[0].FileName != null && postfiles[0].FileName != "")
            {
                Robots _rbt = new Robots();

                System.Text.StringBuilder url = new System.Text.StringBuilder();
                url.Append(base._config.UrlHome + "tools/UploadFiles?");
                url.Append(Cookies.CreateVerifyString());

                string html = _rbt.PostFile(url.ToString(), postfiles[0], "utf-8");
                if (_rbt.IsError)
                {
                    return Json(new { error = true, message = _rbt.ErrorMsg });
                }
                if (string.IsNullOrEmpty(html))
                {
                    return Json(new { error = true, message = "远程页面无响应..." });
                }
                ParseJson pJson = new ParseJson();
                SortedDictionary<string, string> list = pJson.Parse(html);
                if (pJson.GetJsonValue(list, "error") == "true")
                {
                    return Json(new { error = true, message = pJson.GetJsonValue(list, "message") });
                }
                string uploadFileName = pJson.GetJsonValue(list, "path");
                if (string.IsNullOrEmpty(uploadFileName))
                {
                    return Json(new { error = true, message = "文件名获取失败..." });
                }

                return Json(new { error = false, message = "上传成功!", path = uploadFileName, fullPath = pJson.GetJsonValue(list, "fullPath"), url = returnUrl.Equals("") ? base._config.UrlHome : returnUrl });
            }

            return Json(new { error = true, message = "上传失败..." });
             * */

        }
        #endregion

        #region 图片修改
        [HttpPost]
        public ActionResult ChangeImage()
        {
            string _path = DoRequest.GetQueryString("path");

            HttpFileCollection postfiles = System.Web.HttpContext.Current.Request.Files;
            Robots robots = null;
            if (postfiles[0] != null && postfiles[0].FileName != null && postfiles[0].FileName != "")
            {
                string ext = postfiles[0].FileName.Substring(postfiles[0].FileName.LastIndexOf('.') + 1).ToLower();
                if (ext != "jpg" && ext != "jpeg" && ext != "gif" && ext != "bmp" && ext != "png")
                    return Json(new { error = true, message = "文件类型只能为jpg,jpeg,gif,bmp,png！" }, JsonRequestBehavior.AllowGet);

                NameValueCollection myCol = new NameValueCollection();
                myCol.Add("path", _path);
                robots = new Robots();
                string s = robots.HttpUploadFile("http://10.117.21.59/ImageServiceNetgate/uploadFileAtRoot", postfiles[0], myCol, "file");
                if (robots.IsError)
                {
                    return Json(new { error = true, message = robots.ErrorMsg }, JsonRequestBehavior.AllowGet);
                }
                ResponseFile file = JsonHelper.JsonToObject<Response<ResponseFile>>(s).Body;
                if (file != null && file.fileNameList != null && file.fileNameList[0] != null)
                {
                    string fullpathXX = file.fileNameList[0].fileUrl;
                    string path1 = file.fileNameList[0].fileKey.Replace("jianbao/website/", "");
                    string path2 = path1.Substring(0, path1.LastIndexOf("/") + 1);
                    if(!path2.Equals(_path))
                        return Json(new { error = true, message = "失败，请重新更改！" }, JsonRequestBehavior.AllowGet);
                    return Json(new { error = false, message = "成功！", fullpath = fullpathXX }, JsonRequestBehavior.AllowGet);
                }
                return Json(new { error = true, message = "失败，请重新更改1！" }, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(new { error = true, message = "请选择1个文件！" }, JsonRequestBehavior.AllowGet);
            }
        }
        #endregion

        #region GetNewGuid
        public ActionResult GetNewGuid()
        {
            string newguid = Guid.NewGuid().ToString().ToLower();
            return Json(new { error = false, guid = newguid }, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region ClearManagerCookie 退出登录
        //退出登录
        public void ClearManagerCookie()
        {
            Session.Clear();
            Cookies.ClearManagerCookies();
            System.Web.HttpContext.Current.Response.Redirect(base._config.UrlHome);
        }
        #endregion 

        #region ClearCache 清理缓存
        public ActionResult ClearCache()
        {
            //121.41.42.209
            //120.55.186.140
            Session.Clear();
            DoCache cache = new DoCache();
            cache.RemoveCacheAll();
            Robots _rob = new Robots();
            var html = _rob.GetHtml("http://121.41.42.209/EbaoLifeServer/runstate?cmdMode=clearCache");
            var html2 = _rob.GetHtml("http://120.55.186.140/EbaoLifeServer/runstate?cmdMode=clearCache");
            return Json(new { text1 = "http://121.41.42.209/EbaoLifeServer/runstate?cmdMode=clearCache", text2 = "http://120.55.186.140/EbaoLifeServer/runstate?cmdMode=clearCache" }, JsonRequestBehavior.AllowGet);
            //var html = _rob.GetHtml("http://115.28.79.0/EbaoLifeServer/runstate?cmdMode=clearCache");
            //var html2 = _rob.GetHtml("http://42.96.154.177/EbaoLifeServer/runstate?cmdMode=clearCache");
            //return Json(new { text1 = "http://115.28.79.0/EbaoLifeServer/runstate?cmdMode=clearCache", text2 = "http://42.96.154.177/EbaoLifeServer/runstate?cmdMode=clearCache" }, JsonRequestBehavior.AllowGet);
        //    Response.Write(html);
         //   Response.Write("<hr/>");
           // Response.Write(html2);
        }
        #endregion

    }
} 
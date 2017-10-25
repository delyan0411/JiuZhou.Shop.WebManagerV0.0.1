using System;
using System.Web;
using System.Collections.Generic;
using System.Text;
using System.Web.SessionState;

using JiuZhou.Cache;
using JiuZhou.Common;
using JiuZhou.Model;
using JiuZhou.XmlSource;

namespace JiuZhou.HttpTools
{
    public class FormatImagesUrl
    {
        public static ConfigInfo config = ConnStringConfig.GetConfig;//网站配置

        /// <summary>
        /// 获取产品图片url
        /// </summary>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public static string GetProductImageUrl(string filePath, int imageWidth, int imageHeight)
        {
            if (string.IsNullOrEmpty(filePath) || filePath == "none")
            {
                return config.UrlManager + "/images/none.jpg";
            }
            string name = filePath.Substring(0, filePath.LastIndexOf('.') > 0 ? filePath.LastIndexOf('.') : 1);
            string fileExtention = filePath.Substring(filePath.LastIndexOf('.'));
            if (filePath.ToLower().StartsWith("http://"))
            {


                //   if (filePath.StartsWith("/")) filePath = filePath.Substring(1);
                //string fileName = filePath.Substring(filePath.LastIndexOf('/') + 1);
                

                // UpLoadFile upload = new UpLoadFile(false);
                // string uploadRoot = upload.GetUploadRoot.StartsWith("/") ? upload.GetUploadRoot.Substring(1) : upload.GetUploadRoot;

                if (imageWidth < 0)
                {
                    return filePath;
                }

                return name + "_" + imageWidth.ToString() + "_" + imageHeight.ToString() + fileExtention;
            }
            else { 
                if(imageWidth < 0){
                    if (filePath.IndexOf('/') == 0)
                    {
                        return config.UrlImages + filePath.Substring(1);
                    }
                    else {
                        return config.UrlImages + filePath;
                    }
                }else{
                    if (name.IndexOf('/') == 0)
                    {
                        return config.UrlImages + name.Substring(1) + "_" + imageWidth.ToString() + "_" + imageHeight.ToString() + fileExtention;
                    }
                    else {
                        return config.UrlImages + name + "_" + imageWidth.ToString() + "_" + imageHeight.ToString() + fileExtention;
                    }
            }
            }
        }
        /// <summary>
        /// 获取商品主图缩略图
        /// </summary>
        /// <param imgurl="虚拟路径"></param>
        /// <returns></returns>
        public static string GetMainImageUrl(string imgurl)
        {
            if (string.IsNullOrEmpty(imgurl))
            {
                imgurl = "";
            }

            return GetProductImageUrl(imgurl, 120, 120);
        }
        public static string GetMainImageUrl(string imgurl, int imageWidth, int imageHeight)
        {
            if (string.IsNullOrEmpty(imgurl))
            {
                imgurl = "";
            }

            return GetProductImageUrl(imgurl, imageWidth, imageHeight);
        }

        public static string GetImageUrl2(string filePath, int imageWidth, int imageHeight)
        {
            if (string.IsNullOrEmpty(filePath) || filePath == "none")
            {
                return config.UrlHome + "/images/none.jpg";
            }
            if (filePath.ToLower().StartsWith("http://"))
            {
                return filePath;
            }
            UpLoadFile upload = new UpLoadFile(false);
            string uploadRoot = upload.GetUploadRoot.StartsWith("/") ? upload.GetUploadRoot.Substring(1) : upload.GetUploadRoot;
            if (imageWidth < 0)
            {
                return config.UrlImages + uploadRoot + filePath;
            }

            string fileName = filePath.Substring(filePath.LastIndexOf('/') + 1);
            string name = fileName.Substring(0, fileName.LastIndexOf('.') > 0 ? fileName.LastIndexOf('.') : 1);
            string fileExtention = fileName.Substring(fileName.LastIndexOf('.') + 1);

            

            return config.UrlImages + uploadRoot + filePath.Substring(0, filePath.LastIndexOf('/') + 1) + name + "-" + imageWidth.ToString() + "X" + imageHeight.ToString() + "." + fileExtention;
        }
        public static string GetImageUrl2(string filePath)
        {
            return GetImageUrl2(filePath, -1, -1);
        }

        #region
        /// <summary>
        /// 超链接转为手机地址
        /// </summary>
        /// <param name="url"></param>
        /// <returns></returns>
        public static string TransToMobileUrl(string url)
        {
            if (string.IsNullOrEmpty(url)) return "";
            return url.ToLower().Replace("www.dada360.com", "m.dada360.com");
        }
        #endregion
    }
}

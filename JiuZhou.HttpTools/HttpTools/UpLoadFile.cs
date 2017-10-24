using System;
using System.IO;
using System.Web;
using System.Text;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Reflection;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.Security.Cryptography;
using System.Runtime.InteropServices;
using System.Text.RegularExpressions;

using JiuZhou.Common;
using System.Drawing.Imaging;

namespace JiuZhou.HttpTools
{
    /// <summary>
    /// 上传类
    /// Version: 1.0
    /// Author: Atai Lu
    /// </summary>
    public class UpLoadFile
    {
        #region
        public string GetUploadRoot
        {
            get
            {
                //return ("/upload/");//.Replace("//", "/");
                return (DoRequest.RootPath + "/Product/").Replace("//", "/");
                //return ConfigurationManager.AppSettings["UploadRoot"].ToString();
            }
        }
        public UpLoadFile()
        {
            this._uploadDirPath = this.GetUploadRoot;//this.GetDirPath;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="autofolder">是否自动生成文件夹,false是必须设置SetUploadPath参数</param>
        public UpLoadFile(bool autofolder)
        {
            if (autofolder)
            {
                this._uploadDirPath = this.GetDirPath;
                this._autofolder = true;
            }
            else
            {
                this._uploadDirPath = "";
                this._autofolder = false;
            }
        }
        public UpLoadFile(string userDir)
        {
            DateTime dt = DateTime.Now;

            string dirPath = "";
            Utils.CreateDir(DoRequest.GetMapPath(this.GetUploadRoot));
            //用户目录
            dirPath += "userfiles/";
            this._userDir = dirPath;
            Utils.CreateDir(DoRequest.GetMapPath(this.GetUploadRoot + dirPath));
            //用户目录
            dirPath += userDir + "/";
            this._userDir = dirPath;
            Utils.CreateDir(DoRequest.GetMapPath(this.GetUploadRoot + dirPath));
            //分类目录(年)
            dirPath += dt.Year.ToString() + "/";
            //Utils.coutEnd(dirPath);
            Utils.CreateDir(DoRequest.GetMapPath(this.GetUploadRoot + dirPath));

            this._uploadDirPath = dirPath;
        }
        private bool _autofolder = true;
        private string _uploadDirPath = "";
        /// <summary>
        /// autofolder = false时此参数必须设置
        /// </summary>
        public string SetUploadPath
        {
            set { _uploadDirPath = value; }
        }

        private string _userUploadDirPath = "";
        /// <summary>
        /// 当需要为每位用户分配不同的目录时，需要设置
        /// </summary>
        public string SetUserUploadDirPath
        {
            set { _userUploadDirPath = value; }
        }

        //private string _dirPath = "~/upload/";
        /// <summary>
        /// 自动生成文件上传的路径
        /// </summary>
        private string GetDirPath
        {
            get
            {
                DateTime dt = DateTime.Now;

                string dirPath = "";
                Utils.CreateDir(DoRequest.GetMapPath(this.GetUploadRoot));
                //分类目录(年)
                dirPath += dt.Year.ToString() + "/";
                Utils.CreateDir(DoRequest.GetMapPath(this.GetUploadRoot + dirPath));
                //分类目录(月)
                dirPath += dt.Month.ToString() + "/";
                Utils.CreateDir(DoRequest.GetMapPath(this.GetUploadRoot + dirPath));
                this._userDir = dirPath;
                return dirPath;
            }
        }
        private long _userDirMaxSize = -1L;
        private string _userDir = "/";
        /// <summary>
        /// 用户文件目录最大值,单位k,-1为忽略此参数
        /// </summary>
        public long SetUserDirMaxSize
        {
            get
            {
                return _userDirMaxSize;
            }
            set
            {
                _userDirMaxSize = value;
            }
        }
        #endregion
        //
        #region 获取文件名
        private string GetFileName
        {
            get
            {
                return Utils.MD5(Guid.NewGuid().ToString());
            }
        }
        #endregion
        //
        #region 获取目录大小
        /// <summary>
        /// 获取目录大小
        /// </summary>
        /// <param name="dirpath">物理路径</param>
        /// <returns></returns>
        public long GetFolderSize(string dirpath)
        {
            if (!Directory.Exists(dirpath)) return -1;
            long len = 0;

            //定义一个DirectoryInfo对象
            DirectoryInfo di = new DirectoryInfo(dirpath);

            //通过GetFiles方法,获取di目录中的所有文件的大小
            foreach (FileInfo fi in di.GetFiles())
            {
                len += fi.Length;
            }
            //获取di中所有的文件夹,并存到一个新的对象数组中,以进行递归
            DirectoryInfo[] dis = di.GetDirectories();
            for (int i = 0; i < dis.Length; i++)
            {
                len += GetFolderSize(dis[i].FullName);
            }
            return len;
        }
        #endregion
        //
        #region 文件上传相关函数
        /// <summary>
        /// 判断是否有上传的文件
        /// </summary>
        /// <returns>是否有上传的文件</returns>
        public static bool IsPostFile()
        {
            for (int i = 0; i < HttpContext.Current.Request.Files.Count; i++)
            {
                if (HttpContext.Current.Request.Files[i].FileName != "")
                {
                    return true;
                }
            }
            return false;
        }
        #endregion
        //
        //private bool _isAllowImageFile = true;//默认支持图片格式文件
        #region
        private bool _IsAllowImageFile = true;
        /// <summary>
        /// 设置是否允许上传图片(jpg/gif/png/bmp)
        /// </summary>
        public bool IsAllowImageFile
        {
            set { _IsAllowImageFile = value; }
        }
        private bool _IsAllowOfficeFile = false;
        /// <summary>
        /// 设置是否允许上传office文档
        /// </summary>
        public bool IsAllowOfficeFile
        {
            set { _IsAllowOfficeFile = value; }
        }
        private bool _IsAllowZipFile = false;
        /// <summary>
        /// 设置是否允许上传.zip、.rar格式的文件
        /// </summary>
        public bool IsAllowZipFile
        {
            set { _IsAllowZipFile = value; }
        }
        private bool _IsAllowAllFile = false;
        /// <summary>
        /// 设置是否允许上传所有格式的文件
        /// </summary>
        public bool IsAllowAllFile
        {
            set { _IsAllowAllFile = value; }
        }
        //
        private bool _Err = false;
        /// <summary>
        /// 是否出错
        /// </summary>
        public bool Err
        {
            get { return _Err; }
            //set { _Err = value; }
        }
        //
        private string _ErrMsg = "";
        /// <summary>
        /// 错误信息
        /// </summary>
        public string ErrMsg
        {
            get { return _ErrMsg; }
            //set { _ErrMsg = value; }
        }
        #endregion
        //
        #region 读取文件前4个字节
        /// <summary>
        /// 读取文件前4个字节
        /// </summary>
        /// <param name="hifile"></param>
        /// <returns>
        /// .doc、xls文件返回20820717224
        /// .txt文件返回的值不确定
        /// .config文件返回23918719160
        /// .xml文件返回6063120109
        /// .jpg文件返回255216255224
        /// .gif文件返回71737056
        /// .bmp文件返回667717038
        /// .zip文件返回807534
        /// .rar文件返回829711433
        /// .exe文件返回77901440
        /// .wav文件返回82737070
        /// .mp3文件返回7368514
        /// </returns>
        private string GetFileClass(HttpPostedFile file)
        {
            string result = "";

            int count = 4;
            byte[] buffer = new byte[count];
            try
            {
                file.InputStream.Read(buffer, 0, count);
            }
            catch (Exception) { }
            for (int i = 0; i < buffer.Length; i++)
            {
                result += buffer[i].ToString();
            }

            return result;
        }
        #endregion
        //
        #region 非服务器控件的上传方法
        public string DoUploadFile(HttpPostedFile file, float maxLength)
        {
            string result = "";
            this._oname = file.FileName;//原始文件名
            //try
            //{
            //    byte[] bytes = Encoding.Convert(
            //        Encoding.UTF8,
            //        Encoding.Default,
            //        Encoding.Default.GetBytes(this._oname));
            //    //fname = bytes.ToString();
            //    Stream stream = new MemoryStream(bytes);
            //    StreamReader objReader = new StreamReader(stream, Encoding.Default);
            //    this._oname = objReader.ReadToEnd();
            //    objReader.Close();
            //    objReader.Dispose();
            //}
            //catch (Exception)
            //{

            //}
            int _lastIndex = this._oname.LastIndexOf("/");
            this._oname = (_lastIndex > 0 && _lastIndex + 1 < this._oname.Length) ? this._oname.Substring(_lastIndex + 1) : this._oname;

            if (!this._autofolder && this._uploadDirPath.Equals(""))
            {
                this._Err = true;
                return this._ErrMsg = "请设置文件存储目录...";
            }
            //
            #region 判断是否允许的文件类型
            string ext = this._oname.Substring(this._oname.LastIndexOf('.') + 1).ToLower();
            //Utils.WriteText(Utils.GetMapPath("/teasds.txt"), ext);
            if (!this._IsAllowAllFile)
            {
                this._Err = true;
                string fileclass = this.GetFileClass(file).Trim();
                //return this._ErrMsg = "不允许上传此类型的文件..." + this.GetFileClass(file).Trim();

                if ((ext == "jpg" || ext == "gif" || ext == "bmp" || ext == "png") && this._IsAllowImageFile) this._Err = false;
                
                //if (file.ContentType.StartsWith("image"))
                //{
                //    if (ext == "jpg" || ext == "gif" || ext == "bmp" || ext == "png") this._Err = false;
                //    //if (fileclass == "255216255224" || fileclass == "71737056" || fileclass == "667717038" || fileclass == "566969120") this._Err = false;
                //    //if (this._Err)
                //    //    return this._ErrMsg = "只能上传jpg/gif/bmp格式的图片...";
                //}
                if (this._Err && this._IsAllowZipFile)
                {
                    //if (fileclass == "807534" || fileclass == "829711433") this._Err = false;
                    if (ext == "rar" || ext == "zip") this._Err = false;
                }
                if (this._Err && this._IsAllowOfficeFile)
                {
                    if (fileclass == "20820717224" || fileclass == "807534") this._Err = false;
                }
                if (this._Err)
                    return this._ErrMsg = "不允许上传的文件类型" + ext + " " + fileclass;
                
            }
            this._Err = true;
            //string extension = this._oname.Substring(this._oname.LastIndexOf('.') + 1).ToLower();
            switch (ext)
            {
                case "jpg":
                case "gif":
                case "png":
                case "bmp":
                    this._Err = false;
                    break;
                case "zip":
                case "rar":
                    if (this._Err && this._IsAllowZipFile) this._Err = false;
                    break;
                case "doc":
                case "docx":
                case "txt":
                case "xls":
                case "xlsx":
                case "ppt":
                    if (this._Err && this._IsAllowOfficeFile) this._Err = false;
                    break;
                case "exe":
                case "wav":
                case "mp3":
                case "avi":
                case "swf":
                    if (this._Err && this._IsAllowAllFile) this._Err = false;
                    break;
                default:
                    break;
            }
            string extension = "." + ext;
            if (this._IsAllowAllFile)
                this._Err = false;
            //
            if (this._Err)
                return this._ErrMsg = "无法正确识别的文件类型或不允许上传的文件类型..." + this.GetFileClass(file).Trim();
            #endregion
            //
            #region 判断是否允许的文件大小
            float nFileLen = file.ContentLength;
            if (nFileLen / 1024 > maxLength)
            {
                this._Err = true;
                if (maxLength <= 1024)
                    return this._ErrMsg = "不能上传大于 " + maxLength + "K 的文件...";
                else
                    return this._ErrMsg = "不能上传大于 " + (maxLength / 1024).ToString("0.00") + "M 的文件...";
            }
            //else if (nFileLen / 1024 < 1)
            //{
            //    this._Err = true;
            //    return this._ErrMsg = "不能上传小于 1k 的文件...";
            //}
            #endregion
            //
            #region 判断目录大小是否已经超限
            double currFoderSize = ((double)nFileLen + (double)this.GetFolderSize(DoRequest.GetMapPath(this.GetUploadRoot + this._userUploadDirPath))) / 1024D;
            //this._Err = true;
            //this._ErrMsg = this._uploadDirPath;
            if (currFoderSize > (double)this.SetUserDirMaxSize && (double)this.SetUserDirMaxSize != -1D)
            {
                this._Err = true;
                if ((double)this.SetUserDirMaxSize < 1024D)
                    return this._ErrMsg = "您的文件存储目录已满,无法上传更多文件(限定" + this.SetUserDirMaxSize + "K,当前" + (long)currFoderSize + "K)...";
                else
                    return this._ErrMsg = "您的文件存储目录已满,无法上传更多文件(限定" + (this.SetUserDirMaxSize / 1024L) + "M,当前" + (long)(currFoderSize / 1024D) + "M)...";
            }
            #endregion
            //
            
            //this._oname = file.FileName;//原始文件名
            string __name = this.GetFileName;
            this._name = __name + extension;//新生成的文件名
            this._filesize = (float) file.ContentLength;

            #region 保存上传文件
            //获取文件类型
            //string extension = Path.GetExtension(file.FileName).ToLower();
            //得到最终的保存路径
            result = this._uploadDirPath + __name + extension;
            //保存
            //if(this._autofolder)
                file.SaveAs(DoRequest.GetMapPath(this.GetUploadRoot + result));//自动生成目录
            //else
            //    file.SaveAs(Utils.GetMapPath(result));//自定义存储目录
            #endregion
            //
            return result;
        }
        #endregion
        //
        #region 生成缩略图
        private bool ThumbnailCallback()
        {
            return false;
        }
        private int __DoSmallPicCount = 0;
        /// <summary>
        /// 生成缩略图
        /// </summary>
        /// <param name="filePath">源图路径(虚拟路径)</param>
        /// <param name="width"></param>
        /// <param name="height"></param>
        /// <param name="mode">
        /// 不区分大小写
        /// case "wh"://指定高宽缩放（可能变形）
        /// case "w"://指定宽，高按比例
        /// case "h"://指定高，宽按比例
        /// case "auto"://等比压缩
        /// case "cut"://指定高宽裁减（不变形）
        /// </param>
        /// <returns>缩略图路径</returns>
        public string DoSmallPic(string filePath, int width, int height, string mode, int sType)
        {
            
            string result = "";
            string imgPath = HttpContext.Current.Server.MapPath(this.GetUploadRoot + filePath);

            System.Drawing.Image originalImage = System.Drawing.Image.FromFile(imgPath);

            int towidth = width;
            int toheight = height;

            int x = 0;
            int y = 0;
            int ow = originalImage.Width;
            int oh = originalImage.Height;

            if (ow < towidth && oh < toheight)
                return filePath;

            this.__DoSmallPicCount++;//生成的缩略图数量

            double fwidth = 0d;
            double fheight = 0d;
            double proportionForWidth = (double)width / (double)originalImage.Width;
            double proportionForHeight = (double)height / (double)originalImage.Height;
            mode = mode.ToLower();
            switch (mode)
            {
                case "wh"://指定高宽缩放（可能变形）
                    break;
                case "w"://指定宽，高按比例
                    towidth = originalImage.Width;
                    fheight = (double)originalImage.Height * proportionForWidth;
                    toheight = (int)fheight;
                    break;
                case "h"://指定高，宽按比例
                    //towidth = originalImage.Width * height / originalImage.Height;
                    fwidth = (double)originalImage.Width * proportionForHeight;
                    towidth = (int)fwidth;
                    toheight = originalImage.Height;
                    break;
                case "auto"://等比压缩
                    if (width > originalImage.Width)
                    {
                        towidth = originalImage.Width;
                    }
                    if (height > originalImage.Height)
                    {
                        toheight = originalImage.Height;
                    }
                    if (proportionForWidth > proportionForHeight)
                    {
                        fwidth = proportionForHeight * (double)originalImage.Width;
                        towidth = (int)fwidth;
                    }
                    else if (proportionForWidth < proportionForHeight)
                    {
                        fheight = proportionForWidth * (double)originalImage.Height;
                        toheight = (int)fheight;
                    }
                    if (towidth < 1) towidth = 1;
                    if (toheight < 1) toheight = 1;
                    break;
                case "cut"://指定高宽裁减（不变形）
                    //if ((double)originalImage.Width / (double)originalImage.Height > (double)towidth / (double)toheight)
                    //{
                    //    oh = originalImage.Height;
                    //    ow = originalImage.Height * towidth / toheight;
                    //    y = 0;
                    //    x = (originalImage.Width - ow) / 2;
                    //}
                    //else
                    //{
                    //    ow = originalImage.Width;
                    //    oh = originalImage.Width * height / towidth;
                    //    x = 0;
                    //    y = (originalImage.Height - oh) / 2;
                    //}
                    break;
                default:
                    break;
            }
            //Utils.coutEnd(towidth + "//" + toheight);
            //新建一个画板
            //System.Drawing.Graphics g = System.Drawing.Graphics.FromImage(bitmap);

            ////设置高质量插值法
            //g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;

            ////设置高质量,低速度呈现平滑程度
            //g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;

            ////清空画布并以透明背景色填充
            //g.Clear(System.Drawing.Color.Transparent);

            ////在指定位置并且按指定大小绘制原图片的指定部分
            //g.DrawImage(originalImage, new System.Drawing.Rectangle(0, 0, towidth, toheight),
            //    new System.Drawing.Rectangle(x, y, ow, oh),
            //    System.Drawing.GraphicsUnit.Pixel);
            //缩略图路径
            string[] list = filePath.Split("/".ToCharArray());
            for (int i = 0; i < list.Length; i++)
            {
                if (list[i].Trim() != "")
                {
                    if (i + 1 == list.Length)
                    {
                        string _fname = list[i].Trim();
                        string ext = _fname.Substring(_fname.LastIndexOf('.') + 1).ToLower();
                        string fileName = _fname.Substring(0, _fname.LastIndexOf('.')).ToLower();

                        switch(sType)
                        {
                            case 0:
                                result += "/" + fileName + "-" + width + "X" + height + "." + ext;
                                break;
                            case 1:
                                result += "/" + fileName + "_" + width + "_" + height + "." + ext;
                                break;
                            default:
                                result += "/" + fileName + "-" + width + "X" + height + "." + ext;
                                break;
                        }
                    }
                    else
                        result += "/" + list[i].Trim();
                }
            }
            if (result.StartsWith("/"))
                result = result.Substring(1);
            //
            //// ＝＝＝裁剪图片＝＝＝
            //Bitmap bm = new Bitmap(bitmap);
            //Rectangle cloneRect = new Rectangle(0, 0, towidth, toheight);
            //System.Drawing.Imaging.PixelFormat format = bm.PixelFormat;
            //System.Drawing.Bitmap cloneBitmap = bm.Clone(cloneRect, format);
            //cloneBitmap.Save(Utils.getMapPath(result), System.Drawing.Imaging.ImageFormat.Jpeg);
            //bm.Dispose();
            //try
            //{
            if (mode == "cut")
            {
                //如果是需要裁剪图片
                Bitmap bm = new Bitmap(originalImage);
                try
                {
                    Rectangle cloneRect = new Rectangle(0, 0, towidth, toheight);
                    System.Drawing.Imaging.PixelFormat format = bm.PixelFormat;
                    System.Drawing.Bitmap cloneBitmap = bm.Clone(cloneRect, format);
                    cloneBitmap.Save(DoRequest.GetMapPath(result), System.Drawing.Imaging.ImageFormat.Jpeg);
                }
                catch (Exception) { }
                finally
                {
                    bm.Dispose();
                    originalImage.Dispose();
                }
            }
            else
            {
                /*
                System.Drawing.Image thumbnailImage = null;//缩略图
                System.Drawing.Image originalImagePath = System.Drawing.Image.FromFile(filePath);//原图
                System.Drawing.Image.GetThumbnailImageAbort callb = new System.Drawing.Image.GetThumbnailImageAbort(this.ThumbnailCallback);
                try
                {
                    //将原图按比例缩放
                    thumbnailImage = originalImagePath.GetThumbnailImage(towidth, toheight, callb, IntPtr.Zero);
                    //保存缩略图
                    thumbnailImage.Save(DoRequest.GetMapPath(this.GetUploadRoot + result), System.Drawing.Imaging.ImageFormat.Jpeg);
                    thumbnailImage.Dispose();
                }
                catch (Exception) { }
                finally
                {
                    //if (thumbnailImage != null) thumbnailImage.Dispose();
                    originalImage.Dispose();
                    //bitmap.Dispose();
                    //g.Dispose();
                }*/
                
                //新建一个bmp图片
                System.Drawing.Image bitmap = new System.Drawing.Bitmap(towidth, toheight);
                System.Drawing.Graphics g = System.Drawing.Graphics.FromImage(bitmap);
                //清空画布并以透明背景色填充
                g.Clear(System.Drawing.Color.Transparent);

                g.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality;
                //设置高质量,低速度呈现平滑程度
                g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
                //设置高质量插值法
                g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
                
                //在指定位置并且按指定大小绘制原图片的指定部分
                g.DrawImage(originalImage, new System.Drawing.Rectangle(0, 0, towidth, toheight)
                    , new System.Drawing.Rectangle(x, y, ow, oh)
                    , System.Drawing.GraphicsUnit.Pixel);
                // 以下代码为保存图片时,设置压缩质量
                /*
                EncoderParameters encoderParams = new EncoderParameters();
                long[] quality = new long[1];
                quality[0] = 100;
                EncoderParameter encoderParam = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, quality);
                encoderParams.Param[0] = encoderParam;
                //获得包含有关内置图像编码解码器的信息的ImageCodecInfo 对象.
                ImageCodecInfo[] arrayICI = ImageCodecInfo.GetImageEncoders();
                ImageCodecInfo jpegICI = null;
                for (int xx = 0; xx < arrayICI.Length; xx++)
                {
                    if (arrayICI[xx].FormatDescription.Equals("JPEG"))
                    {
                        jpegICI = arrayICI[xx];
                        //设置JPEG编码
                        break;
                    }
                }
                */
                try
                {
                    /*
                    if (jpegICI != null)
                    {
                        bitmap.Save(DoRequest.GetMapPath(this.GetUploadRoot + result), jpegICI, encoderParams);
                    }
                    else
                    {
                        bitmap.Save(DoRequest.GetMapPath(this.GetUploadRoot + result), originalImage.RawFormat);
                    }
                    */
                    //bitmap.Save(DoRequest.GetMapPath(this.GetUploadRoot + result), System.Drawing.Imaging.ImageFormat.Jpeg);
                    bitmap.Save(DoRequest.GetMapPath(this.GetUploadRoot + result), System.Drawing.Imaging.ImageFormat.Jpeg);
                }
                catch (Exception) { }
                finally
                {
                    bitmap.Dispose();
                    g.Dispose();
                    originalImage.Dispose();
                }
                /**/
            }
            //}
            //catch (Exception) { }
            //finally
            //{
            //    originalImage.Dispose();
            //    //bitmap.Dispose();
            //    //g.Dispose();
            //}

            return result;
        }
        public string DoSmallPic(string filePath, int width, int height, string mode)
        {
            return this.DoSmallPic(filePath, width, height, mode, 0);
        }
        #endregion

        #region
        private string _name = "";
        /// <summary>
        /// 得到保存的文件名称
        /// </summary>
        public string Name
        {
            get { return _name; }
        }
        private string _oname = "";
        /// <summary>
        /// 得到客户端未上传前的文件名称(原始文件名)
        /// </summary>
        public string OName
        {
            get { return _oname; }
        }
        private float _filesize = 0;
        /// <summary>
        /// 得到文件大小(单位byte,Filesize/1024的单位为k)
        /// </summary>
        public float Filesize
        {
            get { return _filesize; }
        }
        #endregion
        //
        #region FormatImageUrl
        public static string FormatImageUrl(string path, int size)
        {
            if (string.IsNullOrEmpty(path))
                return "";

            string returnValue = path;
            int idx = path.LastIndexOf(".");
            if (idx > 0)
            {
                string _pix = path.Substring(idx);
                returnValue = path.Substring(0, idx) + "-" + size + "X" + size + _pix;
            }
            return returnValue;
        }
        #endregion
    }
}
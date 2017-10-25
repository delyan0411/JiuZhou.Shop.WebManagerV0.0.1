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
    /// �ϴ���
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
        /// <param name="autofolder">�Ƿ��Զ������ļ���,false�Ǳ�������SetUploadPath����</param>
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
            //�û�Ŀ¼
            dirPath += "userfiles/";
            this._userDir = dirPath;
            Utils.CreateDir(DoRequest.GetMapPath(this.GetUploadRoot + dirPath));
            //�û�Ŀ¼
            dirPath += userDir + "/";
            this._userDir = dirPath;
            Utils.CreateDir(DoRequest.GetMapPath(this.GetUploadRoot + dirPath));
            //����Ŀ¼(��)
            dirPath += dt.Year.ToString() + "/";
            //Utils.coutEnd(dirPath);
            Utils.CreateDir(DoRequest.GetMapPath(this.GetUploadRoot + dirPath));

            this._uploadDirPath = dirPath;
        }
        private bool _autofolder = true;
        private string _uploadDirPath = "";
        /// <summary>
        /// autofolder = falseʱ�˲�����������
        /// </summary>
        public string SetUploadPath
        {
            set { _uploadDirPath = value; }
        }

        private string _userUploadDirPath = "";
        /// <summary>
        /// ����ҪΪÿλ�û����䲻ͬ��Ŀ¼ʱ����Ҫ����
        /// </summary>
        public string SetUserUploadDirPath
        {
            set { _userUploadDirPath = value; }
        }

        //private string _dirPath = "~/upload/";
        /// <summary>
        /// �Զ������ļ��ϴ���·��
        /// </summary>
        private string GetDirPath
        {
            get
            {
                DateTime dt = DateTime.Now;

                string dirPath = "";
                Utils.CreateDir(DoRequest.GetMapPath(this.GetUploadRoot));
                //����Ŀ¼(��)
                dirPath += dt.Year.ToString() + "/";
                Utils.CreateDir(DoRequest.GetMapPath(this.GetUploadRoot + dirPath));
                //����Ŀ¼(��)
                dirPath += dt.Month.ToString() + "/";
                Utils.CreateDir(DoRequest.GetMapPath(this.GetUploadRoot + dirPath));
                this._userDir = dirPath;
                return dirPath;
            }
        }
        private long _userDirMaxSize = -1L;
        private string _userDir = "/";
        /// <summary>
        /// �û��ļ�Ŀ¼���ֵ,��λk,-1Ϊ���Դ˲���
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
        #region ��ȡ�ļ���
        private string GetFileName
        {
            get
            {
                return Utils.MD5(Guid.NewGuid().ToString());
            }
        }
        #endregion
        //
        #region ��ȡĿ¼��С
        /// <summary>
        /// ��ȡĿ¼��С
        /// </summary>
        /// <param name="dirpath">����·��</param>
        /// <returns></returns>
        public long GetFolderSize(string dirpath)
        {
            if (!Directory.Exists(dirpath)) return -1;
            long len = 0;

            //����һ��DirectoryInfo����
            DirectoryInfo di = new DirectoryInfo(dirpath);

            //ͨ��GetFiles����,��ȡdiĿ¼�е������ļ��Ĵ�С
            foreach (FileInfo fi in di.GetFiles())
            {
                len += fi.Length;
            }
            //��ȡdi�����е��ļ���,���浽һ���µĶ���������,�Խ��еݹ�
            DirectoryInfo[] dis = di.GetDirectories();
            for (int i = 0; i < dis.Length; i++)
            {
                len += GetFolderSize(dis[i].FullName);
            }
            return len;
        }
        #endregion
        //
        #region �ļ��ϴ���غ���
        /// <summary>
        /// �ж��Ƿ����ϴ����ļ�
        /// </summary>
        /// <returns>�Ƿ����ϴ����ļ�</returns>
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
        //private bool _isAllowImageFile = true;//Ĭ��֧��ͼƬ��ʽ�ļ�
        #region
        private bool _IsAllowImageFile = true;
        /// <summary>
        /// �����Ƿ������ϴ�ͼƬ(jpg/gif/png/bmp)
        /// </summary>
        public bool IsAllowImageFile
        {
            set { _IsAllowImageFile = value; }
        }
        private bool _IsAllowOfficeFile = false;
        /// <summary>
        /// �����Ƿ������ϴ�office�ĵ�
        /// </summary>
        public bool IsAllowOfficeFile
        {
            set { _IsAllowOfficeFile = value; }
        }
        private bool _IsAllowZipFile = false;
        /// <summary>
        /// �����Ƿ������ϴ�.zip��.rar��ʽ���ļ�
        /// </summary>
        public bool IsAllowZipFile
        {
            set { _IsAllowZipFile = value; }
        }
        private bool _IsAllowAllFile = false;
        /// <summary>
        /// �����Ƿ������ϴ����и�ʽ���ļ�
        /// </summary>
        public bool IsAllowAllFile
        {
            set { _IsAllowAllFile = value; }
        }
        //
        private bool _Err = false;
        /// <summary>
        /// �Ƿ����
        /// </summary>
        public bool Err
        {
            get { return _Err; }
            //set { _Err = value; }
        }
        //
        private string _ErrMsg = "";
        /// <summary>
        /// ������Ϣ
        /// </summary>
        public string ErrMsg
        {
            get { return _ErrMsg; }
            //set { _ErrMsg = value; }
        }
        #endregion
        //
        #region ��ȡ�ļ�ǰ4���ֽ�
        /// <summary>
        /// ��ȡ�ļ�ǰ4���ֽ�
        /// </summary>
        /// <param name="hifile"></param>
        /// <returns>
        /// .doc��xls�ļ�����20820717224
        /// .txt�ļ����ص�ֵ��ȷ��
        /// .config�ļ�����23918719160
        /// .xml�ļ�����6063120109
        /// .jpg�ļ�����255216255224
        /// .gif�ļ�����71737056
        /// .bmp�ļ�����667717038
        /// .zip�ļ�����807534
        /// .rar�ļ�����829711433
        /// .exe�ļ�����77901440
        /// .wav�ļ�����82737070
        /// .mp3�ļ�����7368514
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
        #region �Ƿ������ؼ����ϴ�����
        public string DoUploadFile(HttpPostedFile file, float maxLength)
        {
            string result = "";
            this._oname = file.FileName;//ԭʼ�ļ���
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
                return this._ErrMsg = "�������ļ��洢Ŀ¼...";
            }
            //
            #region �ж��Ƿ�������ļ�����
            string ext = this._oname.Substring(this._oname.LastIndexOf('.') + 1).ToLower();
            //Utils.WriteText(Utils.GetMapPath("/teasds.txt"), ext);
            if (!this._IsAllowAllFile)
            {
                this._Err = true;
                string fileclass = this.GetFileClass(file).Trim();
                //return this._ErrMsg = "�������ϴ������͵��ļ�..." + this.GetFileClass(file).Trim();

                if ((ext == "jpg" || ext == "gif" || ext == "bmp" || ext == "png") && this._IsAllowImageFile) this._Err = false;
                
                //if (file.ContentType.StartsWith("image"))
                //{
                //    if (ext == "jpg" || ext == "gif" || ext == "bmp" || ext == "png") this._Err = false;
                //    //if (fileclass == "255216255224" || fileclass == "71737056" || fileclass == "667717038" || fileclass == "566969120") this._Err = false;
                //    //if (this._Err)
                //    //    return this._ErrMsg = "ֻ���ϴ�jpg/gif/bmp��ʽ��ͼƬ...";
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
                    return this._ErrMsg = "�������ϴ����ļ�����" + ext + " " + fileclass;
                
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
                return this._ErrMsg = "�޷���ȷʶ����ļ����ͻ������ϴ����ļ�����..." + this.GetFileClass(file).Trim();
            #endregion
            //
            #region �ж��Ƿ�������ļ���С
            float nFileLen = file.ContentLength;
            if (nFileLen / 1024 > maxLength)
            {
                this._Err = true;
                if (maxLength <= 1024)
                    return this._ErrMsg = "�����ϴ����� " + maxLength + "K ���ļ�...";
                else
                    return this._ErrMsg = "�����ϴ����� " + (maxLength / 1024).ToString("0.00") + "M ���ļ�...";
            }
            //else if (nFileLen / 1024 < 1)
            //{
            //    this._Err = true;
            //    return this._ErrMsg = "�����ϴ�С�� 1k ���ļ�...";
            //}
            #endregion
            //
            #region �ж�Ŀ¼��С�Ƿ��Ѿ�����
            double currFoderSize = ((double)nFileLen + (double)this.GetFolderSize(DoRequest.GetMapPath(this.GetUploadRoot + this._userUploadDirPath))) / 1024D;
            //this._Err = true;
            //this._ErrMsg = this._uploadDirPath;
            if (currFoderSize > (double)this.SetUserDirMaxSize && (double)this.SetUserDirMaxSize != -1D)
            {
                this._Err = true;
                if ((double)this.SetUserDirMaxSize < 1024D)
                    return this._ErrMsg = "�����ļ��洢Ŀ¼����,�޷��ϴ������ļ�(�޶�" + this.SetUserDirMaxSize + "K,��ǰ" + (long)currFoderSize + "K)...";
                else
                    return this._ErrMsg = "�����ļ��洢Ŀ¼����,�޷��ϴ������ļ�(�޶�" + (this.SetUserDirMaxSize / 1024L) + "M,��ǰ" + (long)(currFoderSize / 1024D) + "M)...";
            }
            #endregion
            //
            
            //this._oname = file.FileName;//ԭʼ�ļ���
            string __name = this.GetFileName;
            this._name = __name + extension;//�����ɵ��ļ���
            this._filesize = (float) file.ContentLength;

            #region �����ϴ��ļ�
            //��ȡ�ļ�����
            //string extension = Path.GetExtension(file.FileName).ToLower();
            //�õ����յı���·��
            result = this._uploadDirPath + __name + extension;
            //����
            //if(this._autofolder)
                file.SaveAs(DoRequest.GetMapPath(this.GetUploadRoot + result));//�Զ�����Ŀ¼
            //else
            //    file.SaveAs(Utils.GetMapPath(result));//�Զ���洢Ŀ¼
            #endregion
            //
            return result;
        }
        #endregion
        //
        #region ��������ͼ
        private bool ThumbnailCallback()
        {
            return false;
        }
        private int __DoSmallPicCount = 0;
        /// <summary>
        /// ��������ͼ
        /// </summary>
        /// <param name="filePath">Դͼ·��(����·��)</param>
        /// <param name="width"></param>
        /// <param name="height"></param>
        /// <param name="mode">
        /// �����ִ�Сд
        /// case "wh"://ָ���߿����ţ����ܱ��Σ�
        /// case "w"://ָ�����߰�����
        /// case "h"://ָ���ߣ�������
        /// case "auto"://�ȱ�ѹ��
        /// case "cut"://ָ���߿�ü��������Σ�
        /// </param>
        /// <returns>����ͼ·��</returns>
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

            this.__DoSmallPicCount++;//���ɵ�����ͼ����

            double fwidth = 0d;
            double fheight = 0d;
            double proportionForWidth = (double)width / (double)originalImage.Width;
            double proportionForHeight = (double)height / (double)originalImage.Height;
            mode = mode.ToLower();
            switch (mode)
            {
                case "wh"://ָ���߿����ţ����ܱ��Σ�
                    break;
                case "w"://ָ�����߰�����
                    towidth = originalImage.Width;
                    fheight = (double)originalImage.Height * proportionForWidth;
                    toheight = (int)fheight;
                    break;
                case "h"://ָ���ߣ�������
                    //towidth = originalImage.Width * height / originalImage.Height;
                    fwidth = (double)originalImage.Width * proportionForHeight;
                    towidth = (int)fwidth;
                    toheight = originalImage.Height;
                    break;
                case "auto"://�ȱ�ѹ��
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
                case "cut"://ָ���߿�ü��������Σ�
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
            //�½�һ������
            //System.Drawing.Graphics g = System.Drawing.Graphics.FromImage(bitmap);

            ////���ø�������ֵ��
            //g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;

            ////���ø�����,���ٶȳ���ƽ���̶�
            //g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;

            ////��ջ�������͸������ɫ���
            //g.Clear(System.Drawing.Color.Transparent);

            ////��ָ��λ�ò��Ұ�ָ����С����ԭͼƬ��ָ������
            //g.DrawImage(originalImage, new System.Drawing.Rectangle(0, 0, towidth, toheight),
            //    new System.Drawing.Rectangle(x, y, ow, oh),
            //    System.Drawing.GraphicsUnit.Pixel);
            //����ͼ·��
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
            //// �������ü�ͼƬ������
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
                //�������Ҫ�ü�ͼƬ
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
                System.Drawing.Image thumbnailImage = null;//����ͼ
                System.Drawing.Image originalImagePath = System.Drawing.Image.FromFile(filePath);//ԭͼ
                System.Drawing.Image.GetThumbnailImageAbort callb = new System.Drawing.Image.GetThumbnailImageAbort(this.ThumbnailCallback);
                try
                {
                    //��ԭͼ����������
                    thumbnailImage = originalImagePath.GetThumbnailImage(towidth, toheight, callb, IntPtr.Zero);
                    //��������ͼ
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
                
                //�½�һ��bmpͼƬ
                System.Drawing.Image bitmap = new System.Drawing.Bitmap(towidth, toheight);
                System.Drawing.Graphics g = System.Drawing.Graphics.FromImage(bitmap);
                //��ջ�������͸������ɫ���
                g.Clear(System.Drawing.Color.Transparent);

                g.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality;
                //���ø�����,���ٶȳ���ƽ���̶�
                g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
                //���ø�������ֵ��
                g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
                
                //��ָ��λ�ò��Ұ�ָ����С����ԭͼƬ��ָ������
                g.DrawImage(originalImage, new System.Drawing.Rectangle(0, 0, towidth, toheight)
                    , new System.Drawing.Rectangle(x, y, ow, oh)
                    , System.Drawing.GraphicsUnit.Pixel);
                // ���´���Ϊ����ͼƬʱ,����ѹ������
                /*
                EncoderParameters encoderParams = new EncoderParameters();
                long[] quality = new long[1];
                quality[0] = 100;
                EncoderParameter encoderParam = new EncoderParameter(System.Drawing.Imaging.Encoder.Quality, quality);
                encoderParams.Param[0] = encoderParam;
                //��ð����й�����ͼ��������������Ϣ��ImageCodecInfo ����.
                ImageCodecInfo[] arrayICI = ImageCodecInfo.GetImageEncoders();
                ImageCodecInfo jpegICI = null;
                for (int xx = 0; xx < arrayICI.Length; xx++)
                {
                    if (arrayICI[xx].FormatDescription.Equals("JPEG"))
                    {
                        jpegICI = arrayICI[xx];
                        //����JPEG����
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
        /// �õ�������ļ�����
        /// </summary>
        public string Name
        {
            get { return _name; }
        }
        private string _oname = "";
        /// <summary>
        /// �õ��ͻ���δ�ϴ�ǰ���ļ�����(ԭʼ�ļ���)
        /// </summary>
        public string OName
        {
            get { return _oname; }
        }
        private float _filesize = 0;
        /// <summary>
        /// �õ��ļ���С(��λbyte,Filesize/1024�ĵ�λΪk)
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
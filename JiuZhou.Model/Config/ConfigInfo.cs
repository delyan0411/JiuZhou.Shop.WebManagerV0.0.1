using System;
using System.Collections;
using System.Collections.Generic;


namespace JiuZhou.Model
{
    public class ConfigInfo
    {

        private string _userAgent = "Mozilla/4.0 (compatible; MSIE 9.0; Windows NT 5.2; Atai Robots ; .NET CLR 1.1.4322; .NET CLR 2.0.50727)";
        /// <summary>
        /// userAgent
        /// </summary>
        public string UserAgent
        {
            get { return _userAgent; }
            set { _userAgent = value; }
        }

        private string _decryptKey = "";
        /// <summary>
        /// 加密密钥(8位)
        /// </summary>
        public string DecryptKey
        {
            get { return _decryptKey; }
            set { _decryptKey = value; }
        }


        private bool _debug = false;
        /// <summary>
        /// Debug
        /// </summary>
        public bool Debug
        {
            get { return _debug; }
            set { _debug = value; }
        }

        private string _log = "";
        /// <summary>
        /// 日志存储路径(物理路径)
        /// </summary>
        public string Log
        {
            get { return _log; }
            set { _log = value; }
        }
      
        #region xx
        private string _exchangeRate = "";
        /// <summary>
        /// 积分与人民币的兑换率，格式：1RMB=30
        /// </summary>
        public string ExchangeRate
        {
            get { return _exchangeRate; }
            set { _exchangeRate = value; }
        }

        private decimal _maxDiscountRate = 0.9m;
        /// <summary>
        /// 单笔订单最大折扣率
        /// </summary>
        public decimal MaxDiscountRate
        {
            get { return _maxDiscountRate; }
            set { _maxDiscountRate = value; }
        }

        private string _domain = "";
        /// <summary>
        /// 网站域名
        /// </summary>
        public string Domain
        {
            get { return _domain; }
            set { _domain = value; }
        }

        private string _urlHome = "";
        /// <summary>
        /// 主站的链接
        /// </summary>
        public string UrlHome
        {
            get { return _urlHome; }
            set { _urlHome = value; }
        }

        private string _urlLogin = "";
        /// <summary>
        /// 登录
        /// </summary>
        public string UrlLogin
        {
            get { return _urlLogin; }
            set { _urlLogin = value; }
        }
        private string _urlUserCenter = "";
        /// <summary>
        /// 用户中心
        /// </summary>
        public string UrlUserCenter
        {
            get { return _urlUserCenter; }
            set { _urlUserCenter = value; }
        }

        private string _urlData = "";
        /// <summary>
        /// 服务器地址
        /// </summary>
        public string UrlData
        {
            get { return _urlData; }
            set { _urlData = value; }
        }

        private string _urlData2 = "";
        /// <summary>
        /// 服务器地址
        /// </summary>
        public string UrlData2
        {
            get { return _urlData2; }
            set { _urlData2 = value; }
        }


        private string _urlShoppingCart = "";
        /// <summary>
        /// 购物车
        /// </summary>
        public string UrlShoppingCart
        {
            get { return _urlShoppingCart; }
            set { _urlShoppingCart = value; }
        }
        private string _urlManager = "";
        /// <summary>
        /// 网站后台
        /// </summary>
        public string UrlManager
        {
            get { return _urlManager; }
            set { _urlManager = value; }
        }
        private string _urlShopManager = "";
        /// <summary>
        /// 网站第三方后台
        /// </summary>
        public string UrlShopManager
        {
            get { return _urlShopManager; }
            set { _urlShopManager = value; }
        }
        private string _urlPay = "";
        /// <summary>
        /// 支付
        /// </summary>
        public string UrlPay
        {
            get { return _urlPay; }
            set { _urlPay = value; }
        }
        private string _urlImages = "";
        /// <summary>
        /// 图片
        /// </summary>
        public string UrlImages
        {
            get { return _urlImages; }
            set { _urlImages = value; }
        }
        private string _imageupload = "";
        /// <summary>
        /// 图片上传
        /// </summary>
        public string UrlImagesUpload
        {
            get { return _imageupload; }
            set { _imageupload = value; }
        }
        private string _dataAnalysis = "";
        /// <summary>
        /// 数据分析
        /// </summary>
        public string UrlDataAnalysis
        {
            get { return _dataAnalysis; }
            set { _dataAnalysis = value; }
        }


        //public string UrlManager { get { return "http://sys.dada360.com/"; } }
        public string UrlMobile { get { return "http://m.dada360.com/"; } }

        private string _dirPath = "";
        /// <summary>
        /// 文件上传的物理目录
        /// </summary>
        public string DirPathImage
        {
            get { return _dirPath; }
            set { _dirPath = value; }
        }
        #endregion

        #region 图片地址
        /// <summary>
        /// 品牌图片网站地址
        /// </summary>
        public string UrlBrandImages { get { return UrlImages + "Brand"; } }

        /// <summary>
        /// 限时图片网站地址
        /// </summary>
        public string UrlRushImages { get { return UrlImages + "Rush"; } }

        /// <summary>
        /// 商品相册网站地址
        /// </summary>
        public string UrlProductAlbumV2 { get { return UrlImages + "ProductAlbumV2"; } }

        /// <summary>
        /// 礼包图片网站地址
        /// </summary>
        public string UrlGiftImages { get { return UrlImages + "Gift"; } }

        /// <summary>
        /// 产品图片网站地址
        /// </summary>
        public string UrlProductImages { get { return UrlImages + "Product/"; } }

        /// <summary>
        /// 广告图片网站网址
        /// </summary>
        public string UrlAdvertiseImage { get { return UrlImages + "Advertise"; } }
        /// <summary>
        /// 编辑器上传的图片存储目录
        /// </summary>
        public string UrlEditorFile { get { return UrlImages + "Editor"; } }

        private List<_Upload> _upload = new List<_Upload>();
        /// <summary>
        /// 上传设置
        /// </summary>
        public List<_Upload> Upload
        {
            get { return _upload; }
            set { _upload = value; }
        }

        #endregion

        #region class _Upload
        public class _Upload
        {
            private string _key = "";
            /// <summary>
            /// 索引
            /// </summary>
            public string Key
            {
                get { return _key; }
                set { _key = value; }
            }
            private string _url = "";
            /// <summary>
            /// Url
            /// </summary>
            public string Url
            {
                get { return _url; }
                set { _url = value; }
            }
            private string _folder = "";
            /// <summary>
            /// 文件存储路径
            /// </summary>
            public string Folder
            {
                get { return _folder; }
                set { _folder = value; }
            }
      
        }
        #endregion
    }
}

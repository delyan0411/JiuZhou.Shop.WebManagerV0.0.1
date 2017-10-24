using System;

namespace JiuZhou.Model
{
    public class ConnStringInfo
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
        //
        private string _connstringMain = "";
        /// <summary>
        /// 数据库链接字串(MainCore_Server)
        /// </summary>
        public string ConnstringMain
        {
            get { return _connstringMain; }
            set { _connstringMain=value; }
        }
        //
        private string _connstringNoteLog = "";
        /// <summary>
        /// 数据库链接字串(NoteLog_Server)
        /// </summary>
        public string ConnstringNoteLog
        {
            get { return _connstringNoteLog; }
            set { _connstringNoteLog = value; }
        }
        //
        private string _connstringOrder = "";
        /// <summary>
        /// 数据库链接字串(OrderCore_Server)
        /// </summary>
        public string ConnstringOrder
        {
            get { return _connstringOrder; }
            set { _connstringOrder = value; }
        }
        //
        private string _connstringProduct = "";
        /// <summary>
        /// 数据库链接字串(ProductCore_Server)
        /// </summary>
        public string ConnstringProduct
        {
            get { return _connstringProduct; }
            set { _connstringProduct = value; }
        }
        //
        private string _connstringStatistics = "";
        /// <summary>
        /// 数据库链接字串(Statistics_Server)
        /// </summary>
        public string ConnstringStatistics
        {
            get { return _connstringStatistics; }
            set { _connstringStatistics = value; }
        }
        //
        
        private string _connstringActionLog = "";
        /// <summary>
        /// 数据库链接字串(ActionLog_Server)
        /// </summary>
        public string ConnstringActionLog
        {
            get { return _connstringActionLog; }
            set { _connstringActionLog = value; }
        }
        //
        private string _connstringJiuZhouDrug = "";
        /// <summary>
        /// 数据库链接字串(JiuZhouDrug)
        /// </summary>
        public string ConnstringJiuZhouDrug
        {
            get { return _connstringJiuZhouDrug; }
            set { _connstringJiuZhouDrug = value; }
        }
        //
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

        private int _couponCount = 0;
        /// <summary>
        /// 设置注册时赠送的优惠券数量
        /// </summary>
        public int CouponCount
        {
            get { return _couponCount; }
            set { _couponCount = value; }
        }

        private decimal _couponPrice = 0m;
        /// <summary>
        /// 设置注册时赠送的优惠券面额
        /// </summary>
        public decimal CouponPrice
        {
            get { return _couponPrice; }
            set { _couponPrice = value; }
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
        #endregion
    }
}
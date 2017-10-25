using System;
namespace JiuZhou.Model
{
    /// <summary>
    /// FareRuleInfo:实体类(属性说明自动提取数据库字段的描述信息)
    /// </summary>
    [Serializable]
    public partial class FareRuleInfo
    {
        public FareRuleInfo()
        { }
        #region Model
        private long _ruleid = 0;
        private long _tempid = 0;
        private decimal _expressfirstprice = 0M;
        private decimal _expresscontinuedprice = 0M;
        private int _expressallow = 0;
        private decimal _urgentfirstprice = 0M;
        private decimal _urgentcontinuedprice = 0M;
        private int _urgentallow = 0;
        private decimal _emsfirstprice = 0M;
        private decimal _emscontinuedprice = 0M;
        private int _emsallow = 0;
        private decimal _codfirstprice = 0M;
        private decimal _codcontinuedprice = 0M;
        private int _codallow = 0;
        private decimal _minfreeprice = 0M;
        private string _remarks = "";
        private DateTime _addtime = DateTime.Now;
        /// <summary>
        /// 规则ID
        /// </summary>
        public long RuleID
        {
            set { _ruleid = value; }
            get { return _ruleid; }
        }
        /// <summary>
        /// 模板ID
        /// </summary>
        public long TempID
        {
            set { _tempid = value; }
            get { return _tempid; }
        }
        /// <summary>
        /// 普通快递首重价格
        /// </summary>
        public decimal ExpressFirstPrice
        {
            set { _expressfirstprice = value; }
            get { return _expressfirstprice; }
        }
        /// <summary>
        /// 普通快递续重价格
        /// </summary>
        public decimal ExpressContinuedPrice
        {
            set { _expresscontinuedprice = value; }
            get { return _expresscontinuedprice; }
        }
        /// <summary>
        /// 是否启用普通快递 0=不启用;1=启用
        /// </summary>
        public int ExpressAllow
        {
            set { _expressallow = value; }
            get { return _expressallow; }
        }
        /// <summary>
        /// 航空件首重价格
        /// </summary>
        public decimal UrgentFirstPrice
        {
            set { _urgentfirstprice = value; }
            get { return _urgentfirstprice; }
        }
        /// <summary>
        /// 航空件续重价格
        /// </summary>
        public decimal UrgentContinuedPrice
        {
            set { _urgentcontinuedprice = value; }
            get { return _urgentcontinuedprice; }
        }
        /// <summary>
        /// 是否启用航空件 0=不启用;1=启用
        /// </summary>
        public int UrgentAllow
        {
            set { _urgentallow = value; }
            get { return _urgentallow; }
        }
        /// <summary>
        /// EMS首重价格
        /// </summary>
        public decimal EMSFirstPrice
        {
            set { _emsfirstprice = value; }
            get { return _emsfirstprice; }
        }
        /// <summary>
        /// EMS续重价格
        /// </summary>
        public decimal EMSContinuedPrice
        {
            set { _emscontinuedprice = value; }
            get { return _emscontinuedprice; }
        }
        /// <summary>
        /// 是否启用EMS 0=不启用;1=启用
        /// </summary>
        public int EMSAllow
        {
            set { _emsallow = value; }
            get { return _emsallow; }
        }
        /// <summary>
        /// 货到付款首重价格
        /// </summary>
        public decimal CODFirstPrice
        {
            set { _codfirstprice = value; }
            get { return _codfirstprice; }
        }
        /// <summary>
        /// 货到付款续重价格
        /// </summary>
        public decimal CODContinuedPrice
        {
            set { _codcontinuedprice = value; }
            get { return _codcontinuedprice; }
        }
        /// <summary>
        /// 是否启用货到付款 0=不启用;1=启用
        /// </summary>
        public int CODAllow
        {
            set { _codallow = value; }
            get { return _codallow; }
        }
        /// <summary>
        /// 首重范围内，满多少元包邮(私有)，负数表示使用全局变量
        /// </summary>
        public decimal MinFreePrice
        {
            set { _minfreeprice = value; }
            get { return _minfreeprice; }
        }
        /// <summary>
        /// 备注
        /// </summary>
        public string Remarks
        {
            set { _remarks = value; }
            get { return _remarks; }
        }
        /// <summary>
        /// 添加时间
        /// </summary>
        public DateTime AddTime
        {
            set { _addtime = value; }
            get { return _addtime; }
        }

        private System.Collections.Generic.List<FareRuleItemInfo> _items = new System.Collections.Generic.List<FareRuleItemInfo>();
        /// <summary>
        /// 应用地区
        /// </summary>
        public System.Collections.Generic.List<FareRuleItemInfo> Items
        {
            set { _items = value; }
            get { return _items; }
        }
        #endregion Model

    }
}
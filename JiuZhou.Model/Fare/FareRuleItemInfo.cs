using System;
namespace JiuZhou.Model
{
    /// <summary>
    /// FareRuleItemInfo:实体类(属性说明自动提取数据库字段的描述信息)
    /// </summary>
    [Serializable]
    public partial class FareRuleItemInfo
    {
        public FareRuleItemInfo()
        { }
        #region Model
        private long _itemid = 0;
        private long _tempid = 0;
        private int _firstweight = 0;
        private decimal _tempminfreeprice = 0M;
        private int _continuedheavy = 0;
        private int _level = 0;
        private int _isvisible = 1;
        private int _issystem = 0;
        private long _ruleid = 0;
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
        private long _areaid = 0;
        private string _areaname = "";
        private DateTime _addtime = DateTime.Now;
        /// <summary>
        /// ItemID
        /// </summary>
        public long ItemID
        {
            set { _itemid = value; }
            get { return _itemid; }
        }
        /// <summary>
        /// 数据来自模板表，模板ID
        /// </summary>
        public long TempID
        {
            set { _tempid = value; }
            get { return _tempid; }
        }
        /// <summary>
        /// 数据来自模板表，首重重量(克)
        /// </summary>
        public int FirstWeight
        {
            set { _firstweight = value; }
            get { return _firstweight; }
        }
        /// <summary>
        /// 数据来自模板表，首重范围内最低包邮价(全局)
        /// </summary>
        public decimal TempMinFreePrice
        {
            set { _tempminfreeprice = value; }
            get { return _tempminfreeprice; }
        }
        /// <summary>
        /// 数据来自模板表，续重重量(克)
        /// </summary>
        public int ContinuedHeavy
        {
            set { _continuedheavy = value; }
            get { return _continuedheavy; }
        }
        /// <summary>
        /// 数据来自模板表，权重(优先级)
        /// </summary>
        public int Level
        {
            set { _level = value; }
            get { return _level; }
        }
        /// <summary>
        /// 数据来自模板表，是否启用
        /// </summary>
        public int IsVisible
        {
            set { _isvisible = value; }
            get { return _isvisible; }
        }
        /// <summary>
        /// 数据来自模板表，是否系统模板
        /// </summary>
        public int IsSystem
        {
            set { _issystem = value; }
            get { return _issystem; }
        }
        /// <summary>
        /// 数据来自规则表，规则ID
        /// </summary>
        public long RuleID
        {
            set { _ruleid = value; }
            get { return _ruleid; }
        }
        /// <summary>
        /// 数据来自规则表，普通快递首重价格
        /// </summary>
        public decimal ExpressFirstPrice
        {
            set { _expressfirstprice = value; }
            get { return _expressfirstprice; }
        }
        /// <summary>
        /// 数据来自规则表，普通快递续重价格
        /// </summary>
        public decimal ExpressContinuedPrice
        {
            set { _expresscontinuedprice = value; }
            get { return _expresscontinuedprice; }
        }
        /// <summary>
        /// 数据来自规则表，是否启用普通快递
        /// </summary>
        public int ExpressAllow
        {
            set { _expressallow = value; }
            get { return _expressallow; }
        }
        /// <summary>
        /// 数据来自规则表，航空件首重价格
        /// </summary>
        public decimal UrgentFirstPrice
        {
            set { _urgentfirstprice = value; }
            get { return _urgentfirstprice; }
        }
        /// <summary>
        /// 数据来自规则表，航空件续重价格
        /// </summary>
        public decimal UrgentContinuedPrice
        {
            set { _urgentcontinuedprice = value; }
            get { return _urgentcontinuedprice; }
        }
        /// <summary>
        /// 数据来自规则表，是否启用航空件
        /// </summary>
        public int UrgentAllow
        {
            set { _urgentallow = value; }
            get { return _urgentallow; }
        }
        /// <summary>
        /// 数据来自规则表，EMS首重价格
        /// </summary>
        public decimal EMSFirstPrice
        {
            set { _emsfirstprice = value; }
            get { return _emsfirstprice; }
        }
        /// <summary>
        /// 数据来自规则表，EMS续重价格
        /// </summary>
        public decimal EMSContinuedPrice
        {
            set { _emscontinuedprice = value; }
            get { return _emscontinuedprice; }
        }
        /// <summary>
        /// 数据来自规则表，是否启用EMS
        /// </summary>
        public int EMSAllow
        {
            set { _emsallow = value; }
            get { return _emsallow; }
        }
        /// <summary>
        /// 数据来自规则表，货到付款首重价格
        /// </summary>
        public decimal CODFirstPrice
        {
            set { _codfirstprice = value; }
            get { return _codfirstprice; }
        }
        /// <summary>
        /// 数据来自规则表，货到付款续重价格
        /// </summary>
        public decimal CODContinuedPrice
        {
            set { _codcontinuedprice = value; }
            get { return _codcontinuedprice; }
        }
        /// <summary>
        /// 数据来自规则表，是否启用货到付款
        /// </summary>
        public int CODAllow
        {
            set { _codallow = value; }
            get { return _codallow; }
        }
        /// <summary>
        /// 数据来自规则表，首重范围内，满多少元包邮(私有)，负数表示使用全局变量
        /// </summary>
        public decimal MinFreePrice
        {
            set { _minfreeprice = value; }
            get { return _minfreeprice; }
        }
        /// <summary>
        /// 地区编码
        /// </summary>
        public long AreaID
        {
            set { _areaid = value; }
            get { return _areaid; }
        }
        /// <summary>
        /// 地区名称
        /// </summary>
        public string AreaName
        {
            set { _areaname = value; }
            get { return _areaname; }
        }
        /// <summary>
        /// 添加时间
        /// </summary>
        public DateTime AddTime
        {
            set { _addtime = value; }
            get { return _addtime; }
        }
        #endregion Model

    }
}
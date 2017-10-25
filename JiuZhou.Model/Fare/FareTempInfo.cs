using System;
namespace JiuZhou.Model
{
    /// <summary>
    /// FareTempInfo:实体类(属性说明自动提取数据库字段的描述信息)
    /// </summary>
    [Serializable]
    public partial class FareTempInfo
    {
        public FareTempInfo()
        { }
        #region Model
        private long _tempid = 0;
        private string _tempname = "";
        private int _firstweight = 0;
        private decimal _tempminfreeprice = 0M;
        private int _continuedheavy = 0;
        private string _remarks = "";
        private int _level = 0;
        private int _isvisible = 1;
        private int _issystem = 0;
        private long _dateTimeTicks = 0;
        private DateTime _addtime = DateTime.Now;
        /// <summary>
        /// TempID
        /// </summary>
        public long TempID
        {
            set { _tempid = value; }
            get { return _tempid; }
        }
        /// <summary>
        /// 模版名
        /// </summary>
        public string TempName
        {
            set { _tempname = value; }
            get { return _tempname; }
        }
        /// <summary>
        /// 首重重量(克)
        /// </summary>
        public int FirstWeight
        {
            set { _firstweight = value; }
            get { return _firstweight; }
        }
        /// <summary>
        /// 首重范围内最低包邮价(全局)
        /// </summary>
        public decimal TempMinFreePrice
        {
            set { _tempminfreeprice = value; }
            get { return _tempminfreeprice; }
        }
        /// <summary>
        /// 续重重量(克)
        /// </summary>
        public int ContinuedHeavy
        {
            set { _continuedheavy = value; }
            get { return _continuedheavy; }
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
        /// 权重(优先级)
        /// </summary>
        public int Level
        {
            set { _level = value; }
            get { return _level; }
        }
        /// <summary>
        /// 是否启用 0=不启用;1=启用
        /// </summary>
        public int IsVisible
        {
            set { _isvisible = value; }
            get { return _isvisible; }
        }
        /// <summary>
        ///  是否系统模板
        /// </summary>
        public int IsSystem
        {
            set { _issystem = value; }
            get { return _issystem; }
        }
        /// <summary>
        /// 时间刻度，如DateTime.Now.Ticks
        /// </summary>
        public long DateTimeTicks
        {
            set { _dateTimeTicks = value; }
            get { return _dateTimeTicks; }
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
using System;
namespace JiuZhou.Model
{
    /// <summary>
    /// SysFilesInfo:实体类(属性说明自动提取数据库字段的描述信息)
    /// </summary>
    [Serializable]
    public partial class SysFilesInfo
    {
        public SysFilesInfo()
        { }
        #region Model
        private int _fileid = 0;
        private int _typeid = 0;
        private string _filename = "";
        private string _savename = "";
        private string _savepath = "";
        //private EFileType _filetype = EFileType.IMAGE;
        private long _usecount = 0;
        private string _clientip = "";
        private string _useragent = "";
        private DateTime _addtime = DateTime.Now;
        /// <summary>
        /// ID
        /// </summary>
        public int sp_file_id
        {
            set { _fileid = value; }
            get { return _fileid; }
        }
        /// <summary>
        /// 分类编码
        /// </summary>
        public int sp_type_id
        {
            set { _typeid = value; }
            get { return _typeid; }
        }
        /// <summary>
        /// 文件名
        /// </summary>
        public string file_name
        {
            set { _filename = value; }
            get { return _filename; }
        }
        /// <summary>
        /// 保存的文件名(不含路径)
        /// </summary>
        public string save_name
        {
            set { _savename = value; }
            get { return _savename; }
        }
        /// <summary>
        /// 保存的路径(含文件名)
        /// </summary>
        public string save_path
        {
            set { _savepath = value; }
            get { return _savepath; }
        }
        
        /// <summary>
        /// 图片引用次数
        /// </summary>
        public long use_count
        {
            set { _usecount = value; }
            get { return _usecount; }
        }
        /// <summary>
        /// 客户端IP
        /// </summary>
        public string client_ip
        {
            set { _clientip = value; }
            get { return _clientip; }
        }
        /// <summary>
        /// UserAgent
        /// </summary>
        public string user_agent
        {
            set { _useragent = value; }
            get { return _useragent; }
        }
        /// <summary>
        /// 添加时间
        /// </summary>
        public DateTime add_time
        {
            set { _addtime = value; }
            get { return _addtime; }
        }
        #endregion Model

    }
}
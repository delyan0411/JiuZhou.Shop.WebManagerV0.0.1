using System;
namespace JiuZhou.Model
{
    /// <summary>
    /// SysNodes:管理后台菜单
    /// </summary>
    [Serializable]
    public partial class SysNodeInfo
    {
        private long _id = 0;
        /// <summary>
        /// ID
        /// </summary>
        public long Id
        {
            get { return _id; }
            set { _id = value; }
        }
        private long _parent = 0;
        /// <summary>
        /// 父ID
        /// </summary>
        public long Parent
        {
            get { return _parent; }
            set { _parent = value; }
        }
        private int _index = 0;
        /// <summary>
        /// 排序
        /// </summary>
        public int Index
        {
            get { return _index; }
            set { _index = value; }
        }
        private string _url = "";
        /// <summary>
        /// 链接
        /// </summary>
        public string Url
        {
            get { return _url; }
            set { _url = value; }
        }
        private string _path = "";
        /// <summary>
        /// 路径
        /// </summary>
        public string Path
        {
            get { return _path; }
            set { _path = value; }
        }
        private int _type = 1;
        /// <summary>
        /// 类别 1：菜单
        /// </summary>
        public int Type
        {
            get { return _type; }
            set { _type = value; }
        }
        private string name = "";
        /// <summary>
        /// 名称
        /// </summary>
        public string Name
        {
            get { return name; }
            set { name = value; }
        }
        private string _desc = "";
        /// <summary>
        /// 描述 
        /// </summary>
        public string Desc
        {
            get { return _desc; }
            set { _desc = value; }
        }
        private EStatus _state = EStatus.NORMAL;
        /// <summary>
        /// 状态 
        /// </summary>
        public EStatus State
        {
            get { return _state; }
            set { _state = value; }
        }
        private DateTime _addtime = DateTime.Now;
        /// <summary>
        /// 状态 
        /// </summary>
        public DateTime AddTime
        {
            get { return _addtime; }
            set { _addtime = value; }
        }
    }
}

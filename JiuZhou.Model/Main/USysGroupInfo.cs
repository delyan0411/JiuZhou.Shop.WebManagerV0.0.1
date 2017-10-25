using System;
namespace JiuZhou.Model
{
    /// <summary>
    /// USysGroupInfo:系统用户组(管理组)实体类
    /// </summary>
    [Serializable]
    public partial class USysGroupInfo
    {
        public USysGroupInfo()
        { }
        #region Model
        private int _sysgroupid = 0;
        private string _sysgroupname = "";
        //private string _sysgroupcode = "";
        //private string _sysgroupimage = "";
        //private string _sysgroupcolor = "";
        private long _sysgrouplevel = 0;
        private bool _issystem = false;
        /// <summary>
        /// ID
        /// </summary>
        public int SysGroupID
        {
            set { _sysgroupid = value; }
            get { return _sysgroupid; }
        }
        /// <summary>
        /// 组名
        /// </summary>
        public string SysGroupName
        {
            set { _sysgroupname = value; }
            get { return _sysgroupname; }
        }
        ///// <summary>
        ///// 组编码
        ///// </summary>
        //public string SysGroupCode
        //{
        //    set { _sysgroupcode = value; }
        //    get { return _sysgroupcode; }
        //}
        ///// <summary>
        ///// 图标
        ///// </summary>
        //public string SysGroupImage
        //{
        //    set { _sysgroupimage = value; }
        //    get { return _sysgroupimage; }
        //}
        ///// <summary>
        ///// 颜色
        ///// </summary>
        //public string SysGroupColor
        //{
        //    set { _sysgroupcolor = value; }
        //    get { return _sysgroupcolor; }
        //}
        /// <summary>
        /// 权限级别
        /// </summary>
        public long SysGroupLevel
        {
            set { _sysgrouplevel = value; }
            get { return _sysgrouplevel; }
        }
        /// <summary>
        /// 是否系统内置角色
        /// </summary>
        public bool IsSystem
        {
            set { _issystem = value; }
            get { return _issystem; }
        }
        #endregion Model

    }
}
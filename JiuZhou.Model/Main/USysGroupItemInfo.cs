using System;
namespace JiuZhou.Model
{
    /// <summary>
    /// USysGroupItemInfo:实体类(属性说明自动提取数据库字段的描述信息)
    /// </summary>
    [Serializable]
    public partial class USysGroupItemInfo
    {
        public USysGroupItemInfo()
        { }
        #region Model
        private int _sysgroupid = 1;
        private string _permissioncode = "";
        /// <summary>
        /// 组ID
        /// </summary>
        public int SysGroupID
        {
            set { _sysgroupid = value; }
            get { return _sysgroupid; }
        }
        /// <summary>
        /// 权限编码
        /// </summary>
        public string PermissionCode
        {
            set { _permissioncode = value; }
            get { return _permissioncode; }
        }
        #endregion Model

    }
}
using System;
namespace JiuZhou.Model
{
    /// <summary>
    /// USysManagerInfo:实体类(属性说明自动提取数据库字段的描述信息)
    /// </summary>
    [Serializable]
    public partial class USysManagerInfo
    {
        public USysManagerInfo()
        { }
        #region Model
        private int _sysid = 0;
        private long _uid = 0;
        private string _username = "";
        private string _nickname = "";
        private string _password = "";
        private EStatus _status = EStatus.UNCHECKED;
        private int _sysgroupid = 0;
        private bool _issysuser = false;
        private DateTime _addtime = DateTime.Now;
        /// <summary>
        /// SysID
        /// </summary>
        public int SysID
        {
            set { _sysid = value; }
            get { return _sysid; }
        }
        /// <summary>
        /// UID(关联user表)
        /// </summary>
        public long UID
        {
            set { _uid = value; }
            get { return _uid; }
        }
        /// <summary>
        /// 登录名(与User表一致)
        /// </summary>
        public string UserName
        {
            set { _username = value; }
            get { return _username; }
        }
        /// <summary>
        /// 昵称
        /// </summary>
        public string NickName
        {
            set { _nickname = value; }
            get { return _nickname; }
        }
        /// <summary>
        /// 管理密码
        /// </summary>
        public string Password
        {
            set { _password = value; }
            get { return _password; }
        }
        /// <summary>
        /// 状态
        /// </summary>
        public EStatus Status
        {
            set { _status = value; }
            get { return _status; }
        }
        /// <summary>
        /// 管理员组
        /// </summary>
        public int SysGroupID
        {
            set { _sysgroupid = value; }
            get { return _sysgroupid; }
        }
        /// <summary>
        /// 是否系统内置账号
        /// </summary>
        public bool IsSysUser
        {
            set { _issysuser = value; }
            get { return _issysuser; }
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
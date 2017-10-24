using System;
namespace JiuZhou.Model
{
    /// <summary>
    /// ProductAlbumInfo:实体类(属性说明自动提取数据库字段的描述信息)
    /// </summary>
    [Serializable]
    public partial class ProductAlbumInfo
    {
        public ProductAlbumInfo()
        { }
        #region Model
        private int _id = 0;
        private int _p_id = 0;
        private string _album_name = "";
        private string _pic_virtualurl = "";
        private DateTime _add_date = DateTime.Now;
        private DateTime _edit_date = DateTime.Now;
        private int _add_user = 0;
        private int _isfigure = 0;
        /// <summary>
        /// ID
        /// </summary>
        public int product_album_id
        {
            set { _id = value; }
            get { return _id; }
        }
        /// <summary>
        /// 产品ID
        /// </summary>
        public int product_id
        {
            set { _p_id = value; }
            get { return _p_id; }
        }
        /// <summary>
        /// 图片名称
        /// </summary>
        public string album_name
        {
            set { _album_name = value; }
            get { return _album_name; }
        }
        /// <summary>
        /// 图片存储地址
        /// </summary>
        public string img_src
        {
            set { _pic_virtualurl = value; }
            get { return _pic_virtualurl; }
        }
        /// <summary>
        /// 添加时间
        /// </summary>
        public DateTime add_time
        {
            set { _add_date = value; }
            get { return _add_date; }
        }
        /// <summary>
        /// 修改时间
        /// </summary>
        public DateTime modify_time
        {
            set { _edit_date = value; }
            get { return _edit_date; }
        }
        /// <summary>
        /// 添加者
        /// </summary>
        public int add_user_id
        {
            set { _add_user = value; }
            get { return _add_user; }
        }
        /// <summary>
        /// 是否形象;0否;1是
        /// </summary>
        public int is_main
        {
            set { _isfigure = value; }
            get { return _isfigure; }
        }
        #endregion Model

    }
}
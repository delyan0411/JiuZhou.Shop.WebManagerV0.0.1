using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data;

using JiuZhou.ControllerBase;
using JiuZhou.MySql;
using JiuZhou.HttpTools;
using JiuZhou.Common;
using System.IO;
using System.Text;
using JiuZhou.Cache;

namespace JiuZhou.Shop.WebManager.Controllers
{
    [HandleError]
    public class HomeController : ForeSysBaseController
    {
        List<UserResBody> userResBody = null;
  
        public HomeController()
        {
            try
            {
                var res = QueryResource.Do(0, -1);
                if (res == null || res.Equals("") || res.Body == null || res.Body.Equals(""))
                {
                    userResBody = new List<UserResBody>();
                }
                else
                {
                    userResBody = res.Body.resource_list;
                }
            }
            catch (Exception)
            {
            }
        }

        #region 主页
        public ActionResult Index()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,108,109,112,"))
                {
                    currResBody = item;
                    break;
                }
            }
            HasPermission(currResBody.res_id);

 

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            return View();
        }
        #endregion

        #region 资源分类
        public ActionResult Nodes()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,108,111,114,"))
                {
                    currResBody = item;
                    break;
                }
            }

            HasPermission(currResBody.res_id);

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            return View();
        }
        #endregion


        #region  QuerySql
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult QuerySql()
        {
            UserResBody currResBody = new UserResBody();
            foreach (UserResBody item in base._userResBody)
            {
                if (item.res_path.Equals("0,1,108,238,239,"))
                {
                    currResBody = item;
                    break;
                }
            }

            HasPermission(currResBody.res_id);

            ViewData["currResBody"] = currResBody;//当前菜单
            string position = "";
            ViewData["pageTitle"] = base.FormatPageTile(currResBody, ref position);
            ViewData["position"] = position;//页面位置

            string q = DoRequest.GetFormString("q", false);
    
            string state = DoRequest.GetFormString("database");
           
            List<string> colname = new List<string>();
            DataTable infoList = new DataTable();
            if (!q.Equals("") && q != null)
            {
                var resp = QueryDataBySql.Do(state, q);

                infoList = resp;

                if (infoList == null)
                    infoList = new DataTable();

                for (int i = 0; i < infoList.Columns.Count; i++)
                {
                    colname.Add(infoList.Columns[i].ColumnName);
                }
            }

            ViewData["colname"] = colname;
            Session["colname"] = colname;
            ViewData["infoList"] = infoList;//数据列表
            Session["infoList"] = infoList;
           
            ViewData["sql"] = q;
            ViewData["type"] = state;

            System.Text.StringBuilder currPageUrl = new System.Text.StringBuilder();//拼接当前页面URL
            currPageUrl.Append("/home/querysql");

            return View();
        }
        #endregion

        #region PostNodeData 修改菜单
        [HttpPost]
        public ActionResult PostNodeData()
        {
            int parentId = DoRequest.GetFormInt("parentId");
            int nodeId = DoRequest.GetFormInt("nodeId");
            string name = DoRequest.GetFormString("name").Trim();
            int sort = DoRequest.GetFormInt("sort");
            string url = DoRequest.GetFormString("url").Trim();
            int restype = DoRequest.GetFormInt("restype");
            string rescode = DoRequest.GetFormString("rescode").Trim();
            #region 验证
            if (string.IsNullOrEmpty(name))
            {
                return Json(new { error = true, message = "名称不能为空" });
            }

            if (rescode.Equals("") || rescode == null) {
                return Json(new { error = true, message = "编码不能为空" });
            }

            if (HasChinese(url))
            {
                return Json(new { error = true, message = "URL不能含中文！" });
            }
            #endregion

            UserResBody pNode = userResBody.FindLast(delegate(UserResBody item) { return item.res_id == parentId; });
            UserResBody cNode = userResBody.FindLast(delegate(UserResBody item) { return item.res_id == nodeId; });
            if (pNode == null) pNode = new UserResBody();
            if (cNode == null) cNode = new UserResBody();

            #region 初始化参数
            if (pNode.res_id == 0 && cNode.res_id == 0)
            {
                cNode.parent_id = 1;
            }
            else
            {
                cNode.parent_id = pNode.res_id;
            }
            cNode.res_name = name;
            cNode.sort_no = sort;
            cNode.res_src = url;
            cNode.res_type = restype;
            cNode.res_code = rescode;
            #endregion

            int returnValue = -1;
            bool isAdd = false;
            if (cNode.res_id == 0)
            {
                //新增
                cNode.res_id = 0;
                cNode.res_state = 0;
                cNode.add_time = DateTime.Now.ToString();
                isAdd = true;
                var resResp = OpResource.Do(cNode);
                if (resResp != null && resResp.Header != null && resResp.Header.Result != null && resResp.Header.Result.Code != null)
                    returnValue = Utils.StrToInt(resResp.Header.Result.Code, -1);
            }
            else
            {
                //更新
                var resResp = OpResource.Do(cNode);
                if (resResp != null && resResp.Header != null && resResp.Header.Result != null && resResp.Header.Result.Code != null)
                    returnValue = Utils.StrToInt(resResp.Header.Result.Code, -1);
            }
            bool isError = true;
            string message = "操作失败";


            if (returnValue == 0)
            {
                isError = false;
                message = "操作成功";
            }

            return Json(new { error = isError, message = message, isadd = isAdd });
        }
        #endregion

        #region ResetNodeStatus 修改菜单状态
        [HttpPost]
        public ActionResult ResetNodeStatus()
        {
            int returnValue = -1;
            int id = DoRequest.GetFormInt("id");
            int status = DoRequest.GetFormInt("status");
            UserResBody user = userResBody.Find(delegate(UserResBody item) { return item.res_id == id; });
            user.res_state = status;
            var res = OpResource.Do(user);
            if (res != null && res.Header != null && res.Header.Result != null && res.Header.Result.Code != null)
                returnValue = Utils.StrToInt(res.Header.Result.Code, -1);

            if (returnValue == 0)
            {
                return Json(new { error = false, message = "操作成功" });
            }

            return Json(new { error = true, message = "操作失败" });
        }
        #endregion

        #region GetNode 获取节点信息
        //[HttpPost]
        public ActionResult GetNode()
        {
            int parentId = DoRequest.RequestInt("parentId");
            int nodeId = DoRequest.RequestInt("nodeId");

            UserResBody pInfo = userResBody.FindLast(delegate(UserResBody item) { return item.res_id == parentId; });
            UserResBody tInfo = userResBody.FindLast(delegate(UserResBody item) { return item.res_id == nodeId; });
            if (pInfo == null) pInfo = new UserResBody();
            if (tInfo == null) tInfo = new UserResBody();
            if (tInfo.res_id < 1)
            {
                List<UserResBody> temList = userResBody.FindAll(delegate(UserResBody item) { return item.parent_id == parentId; });
                tInfo.sort_no = 1;
                foreach (UserResBody node in temList)
                {
                    if (tInfo.sort_no <= node.sort_no)
                        tInfo.sort_no += 1;
                }
            }

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            string[] arr = null;
            sb.Append("根");
            try
            {
                arr = pInfo.res_path.Split(',');
                foreach (string s in arr)
                {
                    if (string.IsNullOrEmpty(s))
                        continue;
                    int val = Utils.StrToInt(s.Trim());
                    if (val == 0 || val == 1 || val == 2)
                        continue;
                    List<UserResBody> list = userResBody.FindAll(
                        delegate(UserResBody item)
                        {
                            return item.res_id == val;
                        });
                    if (list.Count > 0)
                        sb.Append(" >> " + list[0].res_name);
                }
            }
            catch (Exception)
            {
            }
            return Json(new { parent = pInfo, type = tInfo, parentName = sb.ToString() }, JsonRequestBehavior.AllowGet);
        }
        #endregion

        #region   下载页
        public ActionResult DownLoadPage()
        {
            List<string> sname = new List<string>();
            DataTable table = (DataTable)Session["infoList"];
            string _data = "";
            int _count = 0;
            for (int i = 0; i < table.Columns.Count;i++ )
            {
                DataColumn dc = table.Columns[i];
                if (_count == 0)
                {
                    _data = dc.ColumnName;
                }
                else
                {
                    _data = _data + "," + dc.ColumnName;
                }
                sname.Add(dc.ColumnName);
                _count++;
            }
            _data += "\r\n";

        
            for(int i = 0;i<table.Rows.Count ;i++){
                DataRow dr = table.Rows[i];
                _count=0;
                for (int j = 0; j < sname.Count; j++)
                {
                     if (_count == 0)
                     {
                         _data += dr[sname[j]].ToString().Replace(",", "，");
                     }else{
                         _data = _data + "," + dr[sname[j]].ToString().Replace(",", "，"); 
                     }
                     _count++;
                }
                _data += "\r\n";
            }
            byte[] _byte = Encoding.GetEncoding("gb2312").GetBytes(_data);

            Response.ClearHeaders();
            Response.Clear();
            Response.Expires = 0;
            Response.Buffer = true;
            Response.AddHeader("Accept-Language", "zh-cn");

            Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode("table.csv", System.Text.Encoding.GetEncoding("gb2312")));
            Response.ContentType = "application/octet-stream;charset=gb2312";
            Response.BinaryWrite(_byte);
            Response.End();

            return View();
        }
        #endregion
    }
}

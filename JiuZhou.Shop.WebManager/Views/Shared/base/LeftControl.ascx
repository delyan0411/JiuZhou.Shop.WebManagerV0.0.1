<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %> <%@ Import Namespace="JiuZhou.Model" %><%@ Import Namespace="JiuZhou.Common" %><%@ Import Namespace="JiuZhou.MySql" %>
 <%
    ConfigInfo config = (ConfigInfo)(ViewData["config"]);
//	UserInfo user = (UserInfo)ViewData["loginuser"];
	//UGroupInfo userGroup = (UGroupInfo)ViewData["userGroup"];
	//USysManagerInfo manager=(USysManagerInfo)ViewData["manager"];
//	USysGroupInfo sysgroup=(USysGroupInfo)ViewData["sysgroup"];
	//List<USysGroupItemInfo> permissionList = (List<USysGroupItemInfo>)ViewData["sysgroupitems"];
    List<UserResBody> sysNodes = (List<UserResBody>)ViewData["userNodes"];
    UserResBody currNode = (UserResBody)ViewData["currResBody"];
    if (currNode == null||currNode.Equals("")) currNode = new UserResBody();
    if (currNode.res_path == null)
        currNode.res_path = "";
	string[] arr=currNode.res_path.Split(',');
	int rootId=0;
	foreach(string s in arr){
		int _num=Utils.StrToInt(s);
		if(_num>2){
			rootId=_num;break;
		}
	}
    List<UserResBody> nodes = sysNodes.FindAll(delegate(UserResBody item) { return item.parent_id == rootId; });
%>
		<div id="syscp-menu" class="syscp-menu">
			<dl>
<%
	int _count=0;
    foreach (UserResBody node in nodes)
    {
		//if(!USysGroupDB.HasNode(permissionList, manager.IsSysUser?"":node.NodeCode))
			//continue;
		if(_count==0){
			Response.Write("<dt class=\"first\">"+ node.res_name +"</dt>\n");	
		}else{
			Response.Write("<dt>"+ node.res_name +"</dt>\n");
		}
		_count++;
        List<UserResBody> cNodes = sysNodes.FindAll(delegate(UserResBody item) { return item.parent_id == node.res_id; });
        foreach (UserResBody em in cNodes)
        {
		//	if(!USysGroupDB.HasNode(permissionList, manager.IsSysUser?"":em.NodeCode))
		//		continue;
			string url="javascript:void(0);";
			if(!string.IsNullOrEmpty(em.res_src))
				url = em.res_src;
			Response.Write("<dd val=\""+ em.res_path +"\"><a href=\""+ url +"\" title=\""+ em.res_name +"\">"+ em.res_name +"</a></dd>\n");
		}
	}
%>
			</dl>
		</div>
<script type="text/javascript">
    $(function () {
        var path = "<%=currNode.res_path%>";
        $("#syscp-menu dd").each(function () {
            if ($(this).attr("val") == path)
                if (!$(this).hasClass("on")) $(this).addClass("on");
                else
                    $(this).removeClass("on");
        });
    });
</script>
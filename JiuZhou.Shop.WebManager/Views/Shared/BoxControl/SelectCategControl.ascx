<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="System.Collections.Generic" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.MySql" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %>
<%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div id="selectCateg-boxControl" class="moveBox" style="height:560px;width:520px;">
	<div class="name">
		选择分类
		<div id="selectCateg-box-close"  v="atai-shade-close" class="close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>

<script language="c#" runat="server">
    List<TypeList> tList = GetTypeListAll.Do(-1).Body.type_list;

	int tree=0;
	public void PrintList(int parentId){
		if (parentId < 0) return;
        List<TypeList> items = tList.FindAll(
            delegate(TypeList em)
            {
				return em.parent_type_id==parentId;
		});
        if (items.Count <= 0) return;
		//tree++;
        bool isHasChild = false;
        Response.Write("<ul>");
		isHasChild = true;
        foreach (TypeList item in items)
        {
			string[] arr=item.product_type_path.Split(',');
			tree=arr.Length - 2;
			Response.Write("<li>");
			Response.Write("<div tree=\"" + tree + "\"><a href=\"javascript:;\" v=\"bt\" class='jslk'>&nbsp;</a>");
			Response.Write("<a href=\"javascript:;\" v=\"bt\" style=\"color:"+(item.is_visible>0?"#000":"#999")+"\">" + item.type_name + "</a>");
            List<TypeList> __ems = tList.FindAll(
                delegate(TypeList e)
                {
					return e.parent_type_id==item.product_type_id;
			});
			if(item.is_visible>0 && (tree>2 || __ems.Count==0)){
				Response.Write("<p class=\"b-list\" style=\"left:"+ (360 - (tree-1) * 18) +"px\">");
				//string name="";//Utils.ToUnicode(item.n_name);
				string clsName="";
				int _xCount=0;
				for(int x=0;x<arr.Length;x++){
					if(string.IsNullOrEmpty(arr[x].Trim())) continue;
					int _v=Utils.StrToInt(arr[x].Trim());
                    foreach (TypeList ie in tList)
                    {
				       if (ie.product_type_id ==_v){
						if(_xCount>0) clsName += " >> ";
							clsName += ie.type_name;
							_xCount++;
				   		}
			   		}
				}

				Response.Write("<a href=\"javascript:;\" onclick=\"selectThisCateg(event," + item.product_type_id + ", '"+ Utils.ToUnicode(clsName) +"')\" style=\"color:"+(item.is_visible>0?"#060":"#999")+"\" title=\"选择分类\">选择分类</a>");
				Response.Write("</p>");
			}
			Response.Write("</div>");
			PrintList(item.product_type_id);
			Response.Write("</li>\r\n");
		}
		if (isHasChild) Response.Write("</ul>\r\n");
	}
</script>
	<div id="class-list" v="class-list" style="height:500px;width:500px;margin:0 auto;overflow-x:hidden;overflow-y:scroll"><%PrintList(0);%></div>
</div>
    <script type="text/javascript">
        $(function () {
            var _list = new _list_utils();
            _list.isopen = true;
            _list.opentree = 1;
            _list.init(document.getElementById("class-list"));
        });
        var _selectCategEditorBoxDialog = false;
        var _returnInputId = false;
        var _showInputId = false;
        function selectCategBox(event, inputId, showInputId) {
            _returnInputId = inputId; 
            _showInputId = showInputId;
            var boxId = "#selectCateg-boxControl";
            var box = Atai.$(boxId);
            var _dialog = new AtaiShadeDialog();
            _dialog.init({
                obj: boxId
		, sure: function () { }
		, CWCOB: true
            });
            _selectCategEditorBoxDialog = _dialog;

            var _list = new _list_utils();
            _list.isopen = true;
            _list.opentree = 1;
            _list.init($(_dialog.dialog).find("div[v='class-list']")[0]);

            return false;
        }

        function selectThisCateg(event, typeId, name) {
            _returnInputId.val(typeId);
            _showInputId.val(name);
            _selectCategEditorBoxDialog.close();
        }
</script>
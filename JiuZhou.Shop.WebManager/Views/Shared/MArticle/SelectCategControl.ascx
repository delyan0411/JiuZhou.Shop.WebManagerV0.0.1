<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %><%@ Import namespace="System.Collections.Generic" %><%@ Import namespace="JiuZhou.Model" %><%@ Import namespace="JiuZhou.Common" %><%@ Import namespace="JiuZhou.MySql" %><%@ Import namespace="JiuZhou.Cache" %><%@ Import namespace="JiuZhou.XmlSource" %><%@ Import namespace="JiuZhou.HttpTools" %><%
	ConfigInfo config = (ConfigInfo)(ViewData["config"]);
%>
<div id="selectCateg-boxControl" class="moveBox" style="height:560px;width:520px;">
	<div class="name">
		选择分类
		<div class="close" v="atai-shade-close" title="关闭">&nbsp;</div>
	</div>
	<div class="clear">&nbsp;</div>
<script language="c#" runat="server">
    List<ArticleTypeInfo> tList = GetArticleType.Do(0,2,-1).Body.article_type_list;
	int tree=0;
	public void PrintList(int parentId){
		if (parentId < 0) return;
        if (tList == null)
            tList = new List<ArticleTypeInfo>();
        List<ArticleTypeInfo> items = tList.FindAll(
            delegate(ArticleTypeInfo em)
            {
				return em.parent_id==parentId;
		});
		
        if (items.Count <= 0) return;
		//tree++;
        Response.Write("<ul>");
        foreach (ArticleTypeInfo item in items)
        {
			string[] arr=item.type_path.Split(',');
			tree=arr.Length;
			Response.Write("<li>");
			Response.Write("<div tree=\"" + tree + "\"><a href=\"javascript:;\" v=\"bt\" class='jslk'>&nbsp;</a>");
			Response.Write("<a href=\"javascript:;\" v=\"bt\" style=\"color:"+(item.type_state==0?"#000":"#999")+"\">" + item.article_type_name + "</a>");
            List<ArticleTypeInfo> __ems = tList.FindAll(
                delegate(ArticleTypeInfo e)
                {
					return e.parent_id==item.article_type_id;
			});
			if(item.type_state==0 && (tree>2 || __ems.Count==0)){
				Response.Write("<p class=\"b-list\" style=\"left:"+ (360 - (tree-1) * 18) +"px\">");
				//string name="";//Utils.ToUnicode(item.n_name);
				string clsName="";
				int _xCount=0;
				for(int x=0;x<arr.Length;x++){
					if(string.IsNullOrEmpty(arr[x].Trim())) continue;
					int _v=Utils.StrToInt(arr[x].Trim());
                    foreach (ArticleTypeInfo ie in tList)
                    {
				       if (ie.article_type_id ==_v){
						if(_xCount>0) clsName += " >> ";
							clsName += ie.article_type_name;
							_xCount++;
				   		}
			   		}
				}
				bool isHasChild = false;
                List<ArticleTypeInfo> _emss = tList.FindAll(
                    delegate(ArticleTypeInfo emxx)
                    {
						return emxx.parent_id==item.article_type_id;
				});
				if(_emss.Count<1){
					Response.Write("<a href=\"javascript:;\" onclick=\"selectThisCateg(event," + item.article_type_id + ", '"+ Utils.ToUnicode(clsName) +"')\" style=\"color:"+(item.type_state==0?"#060":"#999")+"\" title=\"选择分类\">选择分类</a>");
				}
				Response.Write("</p>");
			}
			Response.Write("</div>");
			PrintList(item.article_type_id);
			Response.Write("</li>\r\n");
		}
		Response.Write("</ul>\r\n");
	}
</script>
	<div id="class-list" style="height:500px;width:500px;margin:0 auto;overflow-x:hidden;overflow-y:scroll"><%PrintList(0);%></div>
</div>
<script type="text/javascript">
var _selectCategEditorBoxDialog = false;
var _returnInputId=false;
var _showInputId=false;
function selectCategBox(event, inputId, showInputId){
	_returnInputId = inputId;_showInputId = showInputId;
	var boxId="#selectCateg-boxControl";
	var box = Atai.$(boxId);
	var _dialog = new AtaiShadeDialog();
	_dialog.init({
	    obj: boxId
		, sure: function () { }
		, CWCOB: false
	});
	_selectCategEditorBoxDialog=_dialog;
	return false;
}
$(function(){
	_list = new _list_utils();
	_list.isopen=true;
	_list.opentree=10;
	_list.init(document.getElementById("class-list"));
});
function selectThisCateg(event, typeId, name){
	$("#" + _returnInputId).val(typeId);
	$("#" + _showInputId).val(name);
	_selectCategEditorBoxDialog.close();
}
</script>
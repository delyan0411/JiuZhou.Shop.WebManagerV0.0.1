function checkAll(form,eventObj){
  var chkAll=document.getElementsByName("chkall");
  var delMode=document.getElementsByName("deleteMode");
  for(var i=0;i<delMode.length;i++)
 	delMode[i].checked=false;
  var chkAllChecked=eventObj.checked;
  for(var i=0;i<chkAll.length;i++)
 	chkAll[i].checked=chkAllChecked;

  for (var i=0;i<form.elements.length;i++){
    var e = form.elements[i];
    if (e.name != 'chkall' && e.name !='deleteMode' && !e.disabled)
       e.checked = chkAllChecked;
    }
}
function inverted(form,eventObj){
  var chkAll=document.getElementsByName("chkall");
  var delMode=document.getElementsByName("deleteMode");
  var chkAllChecked=eventObj.checked;
  for(var i=0;i<delMode.length;i++)
 	delMode[i].checked=chkAllChecked;
  
  for(var i=0;i<chkAll.length;i++)
 	chkAll[i].checked=false;
  for (var i=0;i<form.elements.length;i++)
    {
    var e = form.elements[i];
    if (e.name != 'chkall' && e.name !='deleteMode' && !e.disabled){
		if(!e.checked){e.checked=true;}
		else{e.checked=false;}
	}
    }
}

function selectOne(obj)
{
	if(!obj.checked){
		var chkAll=document.getElementsByName("chkall");
		for(var i=0;i<chkAll.length;i++)
			chkAll[i].checked=false;
	}
}

function checkSelect(form){
	var result=false;
	if(confirm('您确定要执行该操作吗？'))
	{
		for (var i=0;i<form.elements.length;i++){
		var e = form.elements[i];
		if (e.checked && e.name != 'chkall' && e.name !='deleteMode')
			result=true;
		}
		if(!result){
			alert('您没有选定任何项...');
			return false;
		}
	}
	else{
		return false;	
	}
}
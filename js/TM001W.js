var mainPg = "/pages/TM001W.jsp";

function doSubmitItem(form,loan_Item, loan_Item_Name) {		
	form.action= mainPg+"?act=subList&loan_Item="+loan_Item+"&loan_Item_Name="+loan_Item_Name+"&test=nothing";	
	form.submit();
}
function goEdit(form,loan_Item,loan_Item_Name,subItem){
	form.action= mainPg+"?act=Edit&subItem="+subItem+"&loan_Item="+loan_Item+"&loan_Item_Name="+loan_Item_Name+"&test=nothing";	
	form.submit();
}
function doClearEdit(form){
	if(confirm("確定要回復原有資料嗎?")){
		form.subItem_Name.value = "";
		form.loan_Rate.value = "0.0";
		form.base_Rate.value = "0.0";
	}
}
function doSubmit(form,fun) {
	form.action= mainPg+"?act="+fun+"&test=nothing";		
	form.submit();	
}
function checkDot(obj){   
	   //alert(event.keyCode);   
	   //0123456789   
	   if((event.keyCode > 47)&&(event.keyCode < 58)){   
	        return true;   
	    //Enter   
	    }else if(event.keyCode==13){   
	        return true;   
	    //.   
	    }else if((event.keyCode==110)||(event.keyCode==190)){   
	        //var tmpvalue = objobj.value.replace(/./,"");   
	        //if(tmpvalue.index)   
	        if(obj.value.indexOf(".", 0)>0){   
	            alert("只能有一個小數點!");   
	            return false;   
	        }else{   
	            return true;   
	        }   
	    //Delete,Backspace,left,right   
	    }else if((event.keyCode==8)||(event.keyCode==46)||(event.keyCode==37)||(event.keyCode==39)){   
	        return true;   
	    }else{   
	        alert("只能輸入數字或小數點!");   
	        return false;   
	    }   
}
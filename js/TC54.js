function doSubmit(form,cnd,FAULT_ID){
	    form.action="/pages/TC54.jsp?act="+cnd+"&test=nothing";
	    if(((cnd == "Insert") || (cnd == "Update") || (cnd == "Delete"))
	    && (!checkData(form,cnd))) return;
	    
	    if(cnd == "new" || cnd == "Qry") form.submit();
	    if(cnd == "Edit"){
	       form.action="/pages/TC54.jsp?act="+cnd+"&FAULT_ID="+FAULT_ID+"&test=nothing";	    	
	       form.submit();
	    }
	    if((cnd == "Insert") && AskInsert(form)) form.submit();
	    if((cnd == "Update") && AskUpdate(form)) form.submit();	
	    if((cnd == "Delete") && AskDelete(form)) form.submit();	        
}	
	
function checkData(form,cnd) 
{	
	if (trimString(form.FAULT_ID.value) =="" ){
		alert("檢查意見代碼不可為空白");
		form.FAULT_ID.focus();
		return false;
	}else{	   
	    if(form.FAULT_ID.value.length != 4){
	       alert("檢查意見代碼，須填入4碼");	
	       form.FAULT_ID.focus();
		   return false;
	    }
	}	
	
	if (trimString(form.FAULT_NAME.value) =="" ){
		alert("檢查意見名稱不可空白");
		form.FAULT_NAME.focus();
		return false;
	}
   return true;
}
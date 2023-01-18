function doSubmit(form,cnd,expertno_id){
	    form.action="/pages/TC52.jsp?act="+cnd+"&test=nothing";
	    if(((cnd == "Insert") || (cnd == "Update") || (cnd == "Delete"))
	    && (!checkData(form,cnd))) return;
	    
	    if(cnd == "new" || cnd == "Qry") form.submit();
	    if(cnd == "Edit"){
	       form.action="/pages/TC52.jsp?act="+cnd+"&EXPERTNO_ID="+expertno_id+"&test=nothing";	    	
	       form.submit();
	    }
	    if((cnd == "Insert") && AskInsert(form)) form.submit();
	    if((cnd == "Update") && AskUpdate(form)) form.submit();	
	    if((cnd == "Delete") && AskDelete(form)) form.submit();	        
}	
	
function checkData(form,cnd) 
{	
	if (trimString(form.EXPERTNO_ID.value) =="" ){
		alert("專長代碼不可為空白");
		form.EXPERTNO_ID.focus();
		return false;
	}else{	   
	    if(form.EXPERTNO_ID.value.length != 4){
	       alert("專長代碼，須填入4碼");	
	       form.EXPERTNO_ID.focus();
		   return false;
	    }
	}	
	if (trimString(form.EXPERTNO_NAME.value) =="" ){
		alert("專長代碼名稱不可空白");
		form.EXPERTNO_NAME.focus();
		return false;
	}
   return true;
}

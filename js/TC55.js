function doSubmit(form,cnd,ACT_ID){
	    form.action="/pages/TC55.jsp?act="+cnd+"&test=nothing";
	    if(((cnd == "Insert") || (cnd == "Update") || (cnd == "Delete"))
	    && (!checkData(form,cnd))) return;
	    
	    if(cnd == "new" || cnd == "Qry") form.submit();
	    if(cnd == "Edit"){
	       form.action="/pages/TC55.jsp?act="+cnd+"&ACT_ID="+ACT_ID+"&test=nothing";	    	
	       form.submit();
	    }
	    if((cnd == "Insert") && AskInsert(form)) form.submit();
	    if((cnd == "Update") && AskUpdate(form)) form.submit();	
	    if((cnd == "Delete") && AskDelete(form)) form.submit();	        
}	
	
function checkData(form,cnd) 
{	
	if (trimString(form.ACT_ID.value) =="" ){
		alert("處理意見代碼不可為空白");
		form.ACT_ID.focus();
		return false;
	}else{	   
	    if(form.ACT_ID.value.length != 4){
	       alert("處理意見代碼，須填入4碼");	
	       form.ACT_ID.focus();
		   return false;
	    }
	}	
	
	if (trimString(form.ACT_NAME.value) =="" ){
		alert("處理意見名稱不可空白");
		form.ACT_NAME.focus();
		return false;
	}
   return true;
}
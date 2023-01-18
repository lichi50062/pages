function doSubmit(form,cnd,PRJ_ITEM_ID){
	    form.action="/pages/TC17.jsp?act="+cnd+"&test=nothing";
	    if(((cnd == "Insert") || (cnd == "Update") || (cnd == "Delete"))
	    && (!checkData(form,cnd))) return;
	    
	    if(cnd == "new" || cnd == "Qry") form.submit();
	    if(cnd == "Edit"){
	       form.action="/pages/TC17.jsp?act="+cnd+"&PRJ_ITEM_ID="+PRJ_ITEM_ID+"&test=nothing";	    	
	       form.submit();
	    }
	    if((cnd == "Insert") && AskInsert(form)) form.submit();
	    if((cnd == "Update") && AskUpdate(form)) form.submit();	
	    if((cnd == "Delete") && AskDelete(form)) form.submit();	        
}	
	
function checkData(form,cnd) 
{	
	if (trimString(form.PRJ_ITEM_ID.value) =="" ){
		alert("專案檢查項目不可為空白");
		form.PRJ_ITEM_ID.focus();
		return false;
	}else{	   
	    if(form.PRJ_ITEM_ID.value.length != 4){
	       alert("專案檢查項目代碼，須填入4碼");	
	       form.PRJ_ITEM_ID.focus();
		   return false;
	    }
	}	
	
	if (trimString(form.PRJ_ITEM_NAME.value) =="" ){
		alert("專案檢查項目代碼名稱不可空白");
		form.PRJ_ITEM_NAME.focus();
		return false;
	}
   return true;
}
function doSubmit(form,cnd,item_id){
	    form.action="/pages/TC56.jsp?act="+cnd+"&test=nothing";
	    if(((cnd == "Insert") || (cnd == "Update") || (cnd == "Delete"))
	    && (!checkData(form,cnd))) return;
	    
	    if(cnd == "new" || cnd == "Qry") form.submit();
	    if(cnd == "Edit"){
	       form.action="/pages/TC56.jsp?act="+cnd+"&ITEM_ID="+item_id+"&test=nothing";	    	
	       form.submit();
	    }
	    if((cnd == "Insert") && AskInsert(form)) form.submit();
	    if((cnd == "Update") && AskUpdate(form)) form.submit();	
	    if((cnd == "Delete") && AskDelete(form)) form.submit();	        
}	
	
function checkData(form,cnd) 
{	
	if (trimString(form.ITEM_ID.value) =="" ){
		alert("警訊項目代碼不可為空白");
		form.ITEM_ID.focus();
		return false;
	}else{	   
	    if(form.ITEM_ID.value.length != 4){
	       alert("警訊項目代碼，須填入4碼");	
	       form.ITEM_ID.focus();
		   return false;
	    }
	}	
	if (trimString(form.ITEM_NAME.value) =="" ){
		alert("警訊項目代碼名稱不可空白");
		form.ITEM_NAME.focus();
		return false;
	}
   return true;
}

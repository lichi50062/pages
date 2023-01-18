function doSubmit(form,cnd,basis_id){
	    form.action="/pages/TC53.jsp?act="+cnd+"&test=nothing";
	    if(((cnd == "Insert") || (cnd == "Update") || (cnd == "Delete"))
	    && (!checkData(form,cnd))) return;
	    
	    if(cnd == "new" || cnd == "Qry") form.submit();
	    if(cnd == "Edit"){
	       form.action="/pages/TC53.jsp?act="+cnd+"&BASIS_ID="+basis_id+"&test=nothing";	    	
	       form.submit();
	    }
	    if((cnd == "Insert") && AskInsert(form)) form.submit();
	    if((cnd == "Update") && AskUpdate(form)) form.submit();	
	    if((cnd == "Delete") && AskDelete(form)) form.submit();	        
}	
	
function checkData(form,cnd) 
{	
	if (trimString(form.BASIS_ID.value) =="" ){
		alert("檢查依據代碼不可為空白");
		form.BASIS_ID.focus();
		return false;
	}else{	   
	    if(form.BASIS_ID.value.length != 4){
	       alert("檢查依據代碼，須填入4碼");	
	       form.BASIS_ID.focus();
		   return false;
	    }
	}	
	
	if (trimString(form.BASIS_NAME.value) =="" ){
		alert("檢查依據代碼名稱不可空白");
		form.BASIS_NAME.focus();
		return false;
	}
   return true;
}
function sameBank_Name(form){
  form.BANK_B_NAME.value = form.BANK_NAME.value;
}
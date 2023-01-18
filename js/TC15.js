function doSubmit(form,cnd,bank_no){	     	    	    
	    form.action="/pages/TC15.jsp?act="+cnd+"&test=nothing"; 
	    if(((cnd == "Insert") || (cnd == "Update") || (cnd == "Delete"))
	    && (!checkData(form,cnd))) return;	    	    	    
	    if(cnd == "new" || cnd == "Qry") form.submit();
	    if(cnd == "Edit"){
	       form.action="/pages/TC15.jsp?act="+cnd+"&BANK_NO="+bank_no+"&test=nothing";	    	
	       form.submit();
	    }	
	    if((cnd == "Insert") && AskInsert(form)) form.submit();	    
	    if((cnd == "Update") && AskUpdate(form)) form.submit();	    
	    if((cnd == "Delete") && AskDelete(form)) form.submit();	    
}	
	
function checkData(form,cnd) 
{	
	alert("checkData...Start");
	var ckDate;
	if((trimString(form.LAST_CHK_DATE_Y.value) != "" ) 
    || (trimString(form.LAST_CHK_DATE_M.value) != "" )
    || (trimString(form.LAST_CHK_DATE_D.value) != "" ))
    {				   	    
        if (trimString(form.LAST_CHK_DATE_Y.value)  != "" ){        
        	if(isNaN(Math.abs(form.LAST_CHK_DATE_Y.value))){
               alert("檢查日期(年)不可輸入文字");    
			   form.LAST_CHK_DATE_Y.focus();            
               return false;
            }
        }else{
			alert("檢查日期(年)不可空白");
			form.LAST_CHK_DATE_Y.focus();
			return false;   
		}   
        if (trimString(form.LAST_CHK_DATE_M.value) == "" ){
			alert("檢查日期(月)不可空白");
			form.LAST_CHK_DATE_M.focus();
			return false;
		}			
		if (trimString(form.LAST_CHK_DATE_D.value) == "" ){
			alert("檢查日期(日)不可空白");
			form.LAST_CHK_DATE_D.focus();		
			return false;
		}	    

    	ckDate = '' + (parseInt(form.LAST_CHK_DATE_Y.value)+1911) + '/' + form.LAST_CHK_DATE_M.value + '/' + form.LAST_CHK_DATE_D.value;
       
    	if( fnValidDate(ckDate) != true){
        	alert('檢查日期為無效日期!!');
        	form.LAST_CHK_DATE_D.focus();
        	return false;
    	}    
    	form.LAST_CHK_DATE.value = ckDate;
    	alert(ckDate);	    	
    }
    
	if (trimString(form.RT_DOCNO.value) =="" ){
		alert("文號不可空白");
		form.RT_DOCNO.focus();
		return false;
	}
   return true;
}

function sameBank_Name(form){
  form.BANK_B_NAME.value = form.BANK_NAME.value;
}
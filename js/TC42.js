function doSubmit(form,cnd){
	    form.action="/pages/TC42.jsp?act="+cnd+"&test=nothing";
	    if(((cnd == "Insert") || (cnd == "Update") || (cnd == "Delete"))
	    && (!checkData(form,cnd))) return;

	    //if(cnd == "new" || cnd == "Qry") form.submit();
	    if(cnd == "new") form.submit();
	    if(cnd == "Qry"){
	    	if(!checkDate(form,cnd)) return;
	    	if(!checkData(form,cnd)) return;
	    	form.submit();
	    }
	    if(cnd == "Edit"){
	    	//if(!checkDate(form,cnd)) return;
	       	//form.action="/pages/TC42.jsp?act="+cnd+"&BANK_NO="+bank_no+"&SERIAL="+serial+"&test=nothing";
	       	form.submit();
	    }
	    if((cnd == "Insert") && AskInsert(form)) form.submit();
	    if((cnd == "Update") && AskUpdate(form)) form.submit();
	    if((cnd == "Delete") && AskDelete(form)) form.submit();
}

//輸入日期資料檢核處理
function checkDate(form,cnd)
{
	var ckDate;

	//輸入查詢日期檢核處理
	if((trimString(form.BASE_DATE_Y.value) != "" )
    || (trimString(form.BASE_DATE_M.value) != "" )
    || (trimString(form.BASE_DATE_D.value) != "" ))
    {
        if (trimString(form.BASE_DATE_Y.value)  != "" ){
        	if(isNaN(Math.abs(form.BASE_DATE_Y.value))){
               alert("查詢日期(年)不可輸入文字");
			   form.BASE_DATE_Y.focus();
               return false;
            }
        }else{
			alert("查詢日期(年)不可空白");
			form.BASE_DATE_Y.focus();
			return false;
		}
        if (trimString(form.BASE_DATE_M.value) == "" ){
			alert("查詢日期(月)不可空白");
			form.BASE_DATE_M.focus();
			return false;
		}
		if (trimString(form.BASE_DATE_D.value) == "" ){
			alert("查詢日期(日)不可空白");
			form.BASE_DATE_D.focus();
			return false;
		}

    	ckDate = '' + (parseInt(form.BASE_DATE_Y.value)+1911) + '/' + form.BASE_DATE_M.value + '/' + form.BASE_DATE_D.value;

    	if( fnValidDate(ckDate) != true){
        	alert('查詢日期為無效日期!!');
        	form.BASE_DATE_D.focus();
        	return false;
    	}
    	form.BASE_DATE.value = ckDate;
    }else{
    	alert("查詢日期不可為空白");
    	return false;
    }

    return true;
}

//輸入資料檢核處理
function checkData(form,cnd)
{
	//檢核輸入日期
	if(!checkDate(form,cnd)) return;

	if (trimString(form.GETNO.value)  != "" ){
		if(isNaN(Math.abs(form.GETNO.value))){
			alert("家數資料不可輸入文字");
			form.GETNO.focus();
			return false;
        }
    }
            
	//輸入項目檢核
	//if (trimString(form.RT_DOCNO.value) =="" ){
	//	alert("農金局收文文號不可空白");
	//	form.RT_DOCNO.focus();
	//	return false;
	//}
   return true;
}

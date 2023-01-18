﻿function doSubmit(form,cnd){
	    form.action="/pages/TC13.jsp?act="+cnd+"&test=nothing";
	    if(((cnd == "Insert") || (cnd == "Update") || (cnd == "Delete"))
	    && (!checkData(form,cnd))) return;

	    //if(cnd == "new" || cnd == "Qry") form.submit();
	    if(cnd == "new") form.submit();

	    if(cnd == "Qry"){
	    	if(!checkData(form,cnd)) return;
	    	form.submit();
	    }
	    if(cnd == "Edit"){
	       	form.action="/pages/TC13.jsp?act="+cnd+"&test=nothing";
	       	form.submit();
	    }
	    if((cnd == "Insert") && AskInsert(form)) form.submit();
	    if((cnd == "Update") && AskUpdate(form)) form.submit();
	    if((cnd == "Delete") && AskDelete(form)) form.submit();
}

//重導TC13.jsp頁面以致輸出對應之金融機構資料
function getData(form,cnd,item){
	if(item == 'bank_type'){
		//初始BANK_NO值
	   	form.BANK_NO.value="";
	}
	form.action="/pages/TC13.jsp?act=getData&nowact="+cnd+"&test=nothing";
	form.submit();
}

//輸入日期資料檢核處理
function checkDate(form,cnd)
{
	var ckDate;
	var	startDate,endDate;

	//輸入檢查基準日期檢核處理
	if((trimString(form.BASE_DATE_BEG_Y.value) != "" )
    || (trimString(form.BASE_DATE_BEG_M.value) != "" )
    || (trimString(form.BASE_DATE_BEG_D.value) != "" ))
    {
        if (trimString(form.BASE_DATE_BEG_Y.value)  != "" ){
        	if(isNaN(Math.abs(form.BASE_DATE_BEG_Y.value))){
               alert("起始之檢查基準日期(年)不可輸入文字");
			   form.BASE_DATE_BEG_Y.focus();
               return false;
            }
        }else{
			alert("起始之檢查基準日期(年)不可空白");
			form.BASE_DATE_BEG_Y.focus();
			return false;
		}
        if (trimString(form.BASE_DATE_BEG_M.value) == "" ){
			alert("起始之檢查基準日期(月)不可空白");
			form.BASE_DATE_BEG_M.focus();
			return false;
		}
		if (trimString(form.BASE_DATE_BEG_D.value) == "" ){
			alert("起始之檢查基準日期(日)不可空白");
			form.BASE_DATE_BEG_D.focus();
			return false;
		}

    	ckDate = '' + (parseInt(form.BASE_DATE_BEG_Y.value)+1911) + '/' + form.BASE_DATE_BEG_M.value + '/' + form.BASE_DATE_BEG_D.value;
    	startDate = '' + (parseInt(form.BASE_DATE_BEG_Y.value)+1911) + form.BASE_DATE_BEG_M.value + form.BASE_DATE_BEG_D.value;

    	if( fnValidDate(ckDate) != true){
        	alert('起始之檢查基準日期為無效日期!!');
        	form.BASE_DATE_BEG_D.focus();
        	return false;
    	}
    	form.BASE_DATE_BEG.value = ckDate;
    }else{
    	alert("檢查基準日期不可為空白");
    	return false;
    }

	if((trimString(form.BASE_DATE_END_Y.value) != "" )
    || (trimString(form.BASE_DATE_END_M.value) != "" )
    || (trimString(form.BASE_DATE_END_D.value) != "" ))
    {
        if (trimString(form.BASE_DATE_END_Y.value)  != "" ){
        	if(isNaN(Math.abs(form.BASE_DATE_END_Y.value))){
               alert("結束之檢查基準日期(年)不可輸入文字");
			   form.BASE_DATE_END_Y.focus();
               return false;
            }
        }else{
			alert("結束之檢查基準日期(年)不可空白");
			form.BASE_DATE_END_Y.focus();
			return false;
		}
        if (trimString(form.BASE_DATE_END_M.value) == "" ){
			alert("結束之檢查基準日期(月)不可空白");
			form.BASE_DATE_END_M.focus();
			return false;
		}
		if (trimString(form.BASE_DATE_END_D.value) == "" ){
			alert("結束之檢查基準日期(日)不可空白");
			form.BASE_DATE_END_D.focus();
			return false;
		}

    	ckDate = '' + (parseInt(form.BASE_DATE_END_Y.value)+1911) + '/' + form.BASE_DATE_END_M.value + '/' + form.BASE_DATE_END_D.value;
    	endDate = '' + (parseInt(form.BASE_DATE_END_Y.value)+1911) + form.BASE_DATE_END_M.value + form.BASE_DATE_END_D.value;

    	if( fnValidDate(ckDate) != true){
        	alert('結束之檢查基準日期為無效日期!!');
        	form.BASE_DATE_END_D.focus();
        	return false;
    	}
    	form.BASE_DATE_END.value = ckDate;
    }else{
    	alert("檢查基準日期不可為空白");
    	return false;
    }

    if( eval(startDate) > eval(endDate) ){
    	alert("檢查日期起始日期不可大於結束日期");
    	return false;
    }

	return true;
}

//輸入資料檢核處理
function checkData(form,cnd)
{
	//輸入項目檢核
	//if (trimString(form.BANK_NO.value) =="" ){
	//	alert("機構代號不可空白");
	//	form.BANK_NO.focus();
	//	return false;
	//}
	//檢核輸入日期
	if(!checkDate(form,cnd)) return;

	//輸入項目檢核
	//if (trimString(form.REPORTNO.value) != "" ){
    //    if(isNaN(Math.abs(form.REPORTNO.value))){
    //       alert("檢查報告編號不可為文字");
    //       form.REPORTNO.focus();
    //       return false;
    //    }
	//}
   return true;
}

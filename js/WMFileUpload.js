function doSubmit(form) {			 
	
	if (!checkSingleYM(form.S_YEAR, form.S_MONTH)) {
		form.S_YEAR.focus();
		return;
	}
	
	//93.12.06 上傳檔名檢核 
	var FILE_NAME_LENGTH = 15; 	//A01002000009105
	var YM = ('000' + form.S_YEAR.value).substring(form.S_YEAR.value.length) + form.S_MONTH.value;	
	var fileName;    
	fileName = form.Report_no.value + form.bank_code.value + YM;	
	var i = form.UpFileName.value.length - FILE_NAME_LENGTH;
	if (form.UpFileName.value.substring(i) != fileName) {
		alert('檔名必須為' + fileName)
		form.UpFileName.focus();
		return;
	}
	
	if (form.Report_no.value == 'A05' || form.Report_no.value == 'B05') {
		if ((form.S_MONTH.value != '06') && (form.S_MONTH.value != '12')) {
			alert("半年報基準日必須為6月或12月!")
			return;
		}
	}	
	
	if (trimString(form.UpFileName.value) == "") {
		alert("上傳檔案位置必須輸入")
		form.UpFileName.focus();
		return;
	}
	
	form.act.value="Upload";	
	if (confirm('確定上傳該資料檔??')) {	   
		form.action="/pages/WMFileUpload.jsp?act="+form.act.value+"&FileName="+form.UpFileName.value+"&Report_no="+form.Report_no.value+"&S_YEAR="+form.S_YEAR.value+"&S_MONTH="+form.S_MONTH.value+"&test=nothing";
		form.submit();
	}else{
		return;
	}	
}

function ConfirmOverWrite(form,msg){		
		if(msg != ''){			
	    	if (confirm(msg)) {	    		
	    		form.action="/pages/WMFileUpload.jsp?act=OverWrite&FileName="+form.FileName.value+"&test=nothing";	    		  
	    		form.submit();	    		
    		}else{
    			history.back();		
    		}		   		
	    }
	    
	    return true;	    
}
function fillText(form,val){	
	form.amt320300.value=val;	
}	

function doSubmitStatus(form,Report_no, Report_name,bank_type) {		
	//alert(form);
	//var form = document.frmWMFileEdit;	
	form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&bank_type="+bank_type+"&test=nothing";	
	form.submit();
}


function doSubmit(form,fun,Report_no,S_YEAR,S_MONTH,bank_type) {		
	form.act.value=fun;			
	if(fun == 'Edit'){	   
	   form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&S_YEAR="+S_YEAR+"&S_MONTH="+S_MONTH+"&bank_type="+bank_type+"&bank_code=123456&test=nothing";		
	   form.submit();	   
	}
	if(fun == 'new'){	   
	   form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&bank_type="+bank_type+"&test=nothing";		
	   form.submit();	   
	}
	
	if(fun == 'Insert'){		
		if(Report_no == 'A01' && (checkShowInsert_A01(form, fun))){/* modify block by Winnin.chu 2004.11.24 ver1.0*/
	   		if(AskInsert(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	   		}
	   	}else if(Report_no == 'A02' && (checkShowInsert_A02(form, fun))){/* Add block by Winnin.chu 2004.11.24 ver1.0*/
	   		if(AskInsert(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	   		}
	   	}else if(Report_no == 'A03' && (checkShowInsert_A03(form, fun))){/* Add block by Winnin.chu 2004.11.24 ver1.0*/
	   		if(AskInsert(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	   		}
	   	}else if(Report_no == 'A04' && (checkShowInsert_A04(form, fun))){/* Add block by Winnin.chu 2004.11.24 ver1.0*/
	   		if(AskInsert(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	   		}
	   	}else if(Report_no == 'A05' && (checkShowInsert_A05(form, fun))){/* Add block by Winnin.chu 2004.11.24 ver1.0*/
	   		if(AskInsert(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	   		}
	   	}else if(Report_no == 'B01' && (checkShowInsert_B01(form, fun))){/* Add block by jei 2004.12.14 ver1.0*/
	   		if(AskInsert(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	   		}
	   	}else if(Report_no == 'B02' && (checkShowInsert_B02(form, fun))){/* Add block by jei 2004.12.14 ver1.0*/
	   		if(AskInsert(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	   		}
	   	}else if(Report_no == 'B03' && (checkShowInsert_B03(form, fun))){/* Add block by egg 2004.12.15 */
	   		if(AskInsert(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	   		}
	   	}else if(Report_no == 'M01' && (checkShowInsert_M01(form, fun))){/* Add block by egg 2004.12.10 ver1.0*/
	   		if(AskInsert(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	   		}
	   	}else if(Report_no == 'M02' && (checkShowInsert_M02(form, fun))){/* Add block by jei 2004.12.10 ver1.0*/
	   		if(AskInsert(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	   		}
	   	}else if(Report_no == 'M03' && (checkShowInsert_M03(form, fun))){/* Add block by egg 2004.12.11 */
	   		if(AskInsert(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	   		}
	   	}else if(Report_no == 'M04' && (checkShowInsert_M04(form, fun))){/* Add block by jei 2004.12.11 */
	   		if(AskInsert(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	   		}	
	   	}else if(Report_no == 'M05' && (checkShowInsert_M05(form, fun))){/* Add block by Winnin.chu 2004.11.24 ver1.0*/
	   		if(AskInsert(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	   		}
	   	}else if(Report_no == 'M06' && (checkShowInsert_M06(form, fun))){/* Add block by egg 2004.12.13 */
	   		if(AskInsert(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	   		}
	   	}else if(Report_no == 'M07' && (checkShowInsert_M07(form, fun))){/* Add block by egg 2004.12.13 */
	   		if(AskInsert(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	   		}
	   	}else if(Report_no == 'M08' && (checkShowInsert_M08(form, fun))){/* Add block by egg 2004.12.16 */
	   		if(AskInsert(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	   		}
	   	}
	}
	if(fun == 'Update') {
		if( Report_no == 'A01' && (checkShowInsert_A01(form, fun))){/* modify block by Winnin.chu 2004.11.24 ver1.0*/
	   		if(AskUpdate(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	       	}
	   	}else if( Report_no == 'A02' && (checkShowInsert_A02(form, fun))){/* Add block by Winnin.chu 2004.11.24 ver1.0*/
	   		if(AskUpdate(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	       	}
	   	}else if( Report_no == 'A03' && (checkShowInsert_A03(form, fun))){/* Add block by Winnin.chu 2004.11.24 ver1.0*/
	   		if(AskUpdate(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	       	}
	   	}else if( Report_no == 'A04' && (checkShowInsert_A04(form, fun))){/* Add block by Winnin.chu 2004.11.24 ver1.0*/
	   		if(AskUpdate(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	       	}
	   	}else if( Report_no == 'A05' && (checkShowInsert_A05(form, fun))){/* Add block by Winnin.chu 2004.11.24 ver1.0*/
	   		if(AskUpdate(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	       	}
	   	}else if( Report_no == 'B01' && (checkShowInsert_B01(form, fun))){/* Add block by jei 2004.12.14 ver1.0*/
	   		if(AskUpdate(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	       	}
	   	}else if( Report_no == 'B02' && (checkShowInsert_B02(form, fun))){/* Add block by jei 2004.12.14 ver1.0*/
	   		if(AskUpdate(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	       	}
	   	}else if( Report_no == 'B03' && (checkShowInsert_B03(form, fun))){/* Add block by egg 2004.12.15 */
	   		if(AskUpdate(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	       	}
	   	}else if( Report_no == 'M01' && (checkShowInsert_M01(form, fun))){/* Add block by egg 2004.12.10 ver1.0*/
	   		if(AskUpdate(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	       	}
	   	}else if( Report_no == 'M02' && (checkShowInsert_M02(form, fun))){/* Add block by jei 2004.12.10 ver1.0*/
	   		if(AskUpdate(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	       	}
	   	}else if( Report_no == 'M03' && (checkShowInsert_M03(form, fun))){/* Add block by egg 2004.12.13 */
	   		if(AskUpdate(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	       	}
	    }else if( Report_no == 'M04' && (checkShowInsert_M04(form, fun))){/* Add block by jei 2004.12.13 */
	   		if(AskUpdate(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	       	}
	   	}else if( Report_no == 'M05' && (checkShowInsert_M05(form, fun))){/* Add block by Winnin.chu 2004.11.24 ver1.0*/
	   		if(AskUpdate(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	       	}
	   	}else if( Report_no == 'M06' && (checkShowInsert_M06(form, fun))){/* Add block by egg 2004.12.13 */
	   		if(AskUpdate(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	       	}
	   	}else if( Report_no == 'M07' && (checkShowInsert_M07(form, fun))){/* Add block by egg 2004.12.13 */
	   		if(AskUpdate(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	       	}
		}else if( Report_no == 'M08' && (checkShowInsert_M08(form, fun))){/* Add block by egg 2004.12.16 */
	   		if(AskUpdate(form)){	
	       		form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       		form.submit();
	       	}
		}	   	
	}	
	if(fun == 'Delete'){
		if(AskDelete(form)){	
	       form.action="/pages/WMFileEdit.jsp?act="+form.act.value+"&Report_no="+Report_no+"&test=nothing";		
	       form.submit();
	   } 
	}	
}

function checkShowInsert_A01(form, fun) {	
	
	//if (!Check_Maintain(form))
	//	return false;
	
	//if (trimString(form.maintain_email.value) == "") {
	//	alert("承辦員E_MAIL必須輸入")
	//	form.maintain_email.focus();
	//	return false;
	//}
	
	if (fun == 'Insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
	}

	for (var i = 0; i < form.amt.length; i++) {
		if (!checkNumber(form.amt[i]))
			return false;
	}

	return true;
}


/* Add Method by Winnin.chu 2004.11.24 ver1.0*/
function checkShowInsert_A02(form, fun) {
	//if (!Check_Maintain(form))
	//	return false;
	
	//if (trimString(form.maintain_email.value) == "") {
	//	alert("承辦員E_MAIL必須輸入")
	//	form.maintain_email.focus();
	//	return false;
	//}
	
	if (fun == 'Insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
	}

	for (var i = 0; i < form.amt.length; i++) {
		if (!checkNumber(form.amt[i]))
			return false;
		if (i==30 && (parseInt(form.amt[i].value)<0 || parseInt(form.amt[i].value)>999)){  //最後結算年度
			alert('最近決算年度只能輸入3位(民國年)');
			return false;
		}
	}

	return true;
}

/* Add Method by Winnin.chu 2004.11.24 ver1.0*/
function checkShowInsert_A03(form, fun) {
	//if (!Check_Maintain(form))
	//	return false;
	
	//if (trimString(form.maintain_email.value) == "") {
	//	alert("承辦員E_MAIL必須輸入")
	//	form.maintain_email.focus();
	//	return false;
	//}
	
	if (fun == 'Insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
	}

	for (var i = 0; i < form.amt.length; i++) {
		if (!checkFloatNumber(form.amt[i]))
			return false;
	}

	return true;
}

/* Add Method by Winnin.chu 2004.11.24 ver1.0*/
function checkShowInsert_A04(form, fun) {
	//if (!Check_Maintain(form))
	//	return false;
	
	//if (trimString(form.maintain_email.value) == "") {
	//	alert("承辦員E_MAIL必須輸入")
	//	form.maintain_email.focus();
	//	return false;
	//}
	
	if (fun == 'Insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
	}

	for (var i = 0; i < form.amt.length; i++) {
		if (!checkFloatNumber(form.amt[i]))
			return false;
	}

	return true;
}

/* Add Method by Winnin.chu 2004.11.24 ver1.0*/
function checkShowInsert_A05(form, fun) {
	//if (!Check_Maintain(form))
	//	return false;
	
	//if (trimString(form.maintain_email.value) == "") {
	//	alert("承辦員E_MAIL必須輸入")
	//	form.maintain_email.focus();
	//	return false;
	//}
	
	if (fun == 'Insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
	}

	/* 
	for (var i = 0; i < form.amt.length; i++) {
		if (!checkFloatNumber(form.amt[i]))
			return false;
	}
	*/

	return true;
}

/* Add Method by jei 2004.12.14 ver1.0*/
function checkShowInsert_B01(form, fun) {
	//if (!Check_Maintain(form))
	//	return false;
	
	//if (trimString(form.maintain_email.value) == "") {
	//	alert("承辦員E_MAIL必須輸入")
	//	form.maintain_email.focus();
	//	return false;
	//}
	
	if (fun == 'Insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
	}

	/* 
	for (var i = 0; i < form.amt.length; i++) {
		if (!checkFloatNumber(form.amt[i]))
			return false;
	}
	*/

	return true;
}

/* Add Method by jei 2004.12.14 ver1.0*/
function checkShowInsert_B02(form, fun) {
	//if (!Check_Maintain(form))
	//	return false;
	
	//if (trimString(form.maintain_email.value) == "") {
	//	alert("承辦員E_MAIL必須輸入")
	//	form.maintain_email.focus();
	//	return false;
	//}
	
	if (fun == 'Insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
	}

	/* 
	for (var i = 0; i < form.amt.length; i++) {
		if (!checkFloatNumber(form.amt[i]))
			return false;
	}
	*/

	return true;
}

/* Add Method by egg 2004.12.15 */
function checkShowInsert_B03(form, fun) {
	//if (!Check_Maintain(form))
	//	return false;
	
	//if (trimString(form.maintain_email.value) == "") {
	//	alert("承辦員E_MAIL必須輸入")
	//	form.maintain_email.focus();
	//	return false;
	//}
	
	if (fun == 'Insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
	}

	/* 
	for (var i = 0; i < form.amt.length; i++) {
		if (!checkFloatNumber(form.amt[i]))
			return false;
	}
	*/

	return true;
}

/* Add Method by egg 2004.12.10 ver1.0*/
function checkShowInsert_M01(form, fun) {
	//if (!Check_Maintain(form))
	//	return false;
	
	//if (trimString(form.maintain_email.value) == "") {
	//	alert("承辦員E_MAIL必須輸入")
	//	form.maintain_email.focus();
	//	return false;
	//}
	
	if (fun == 'Insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
	}

	/* 
	for (var i = 0; i < form.amt.length; i++) {
		if (!checkFloatNumber(form.amt[i]))
			return false;
	}
	*/

	return true;
}

/* Add Method by jei 2004.12.10 ver1.0*/
function checkShowInsert_M02(form, fun) {
	//if (!Check_Maintain(form))
	//	return false;
	
	//if (trimString(form.maintain_email.value) == "") {
	//	alert("承辦員E_MAIL必須輸入")
	//	form.maintain_email.focus();
	//	return false;
	//}
	
	if (fun == 'Insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
	}

	/* 
	for (var i = 0; i < form.amt.length; i++) {
		if (!checkFloatNumber(form.amt[i]))
			return false;
	}
	*/

	return true;
}

/* Add Method by egg 2004.12.11 */
function checkShowInsert_M03(form, fun) {
	//if (!Check_Maintain(form))
	//	return false;
	
	//if (trimString(form.maintain_email.value) == "") {
	//	alert("承辦員E_MAIL必須輸入")
	//	form.maintain_email.focus();
	//	return false;
	//}
	
	if (fun == 'Insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
	}

	/* 
	for (var i = 0; i < form.amt.length; i++) {
		if (!checkFloatNumber(form.amt[i]))
			return false;
	}
	*/

	return true;
}

/* Add Method by jei 2004.12.11 */
function checkShowInsert_M04(form, fun) {
	//if (!Check_Maintain(form))
	//	return false;
	
	//if (trimString(form.maintain_email.value) == "") {
	//	alert("承辦員E_MAIL必須輸入")
	//	form.maintain_email.focus();
	//	return false;
	//}
	
	if (fun == 'Insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
	}

	/* 
	for (var i = 0; i < form.amt.length; i++) {
		if (!checkFloatNumber(form.amt[i]))
			return false;
	}
	*/

	return true;
}

/* Add Method by Winnin.chu 2004.11.24 ver1.0*/
function checkShowInsert_M05(form, fun) {
	//if (!Check_Maintain(form))
	//	return false;
	
	//if (trimString(form.maintain_email.value) == "") {
	//	alert("承辦員E_MAIL必須輸入")
	//	form.maintain_email.focus();
	//	return false;
	//}
	
	if (fun == 'Insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
	}

	/* 
	for (var i = 0; i < form.amt.length; i++) {
		if (!checkFloatNumber(form.amt[i]))
			return false;
	}
	*/

	return true;
}

/* Add Method by egg 2004.12.13 */
function checkShowInsert_M06(form, fun) {
	//if (!Check_Maintain(form))
	//	return false;
	
	//if (trimString(form.maintain_email.value) == "") {
	//	alert("承辦員E_MAIL必須輸入")
	//	form.maintain_email.focus();
	//	return false;
	//}
	
	if (fun == 'Insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
	}

	/* 
	for (var i = 0; i < form.amt.length; i++) {
		if (!checkFloatNumber(form.amt[i]))
			return false;
	}
	*/

	return true;
}

/* Add Method by egg 2004.12.13 */
function checkShowInsert_M07(form, fun) {
	//if (!Check_Maintain(form))
	//	return false;
	
	//if (trimString(form.maintain_email.value) == "") {
	//	alert("承辦員E_MAIL必須輸入")
	//	form.maintain_email.focus();
	//	return false;
	//}
	
	if (fun == 'Insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
	}

	/* 
	for (var i = 0; i < form.amt.length; i++) {
		if (!checkFloatNumber(form.amt[i]))
			return false;
	}
	*/

	return true;
}

/* Add Method by egg 2004.12.16 */
function checkShowInsert_M08(form, fun) {
	//if (!Check_Maintain(form))
	//	return false;
	
	//if (trimString(form.maintain_email.value) == "") {
	//	alert("承辦員E_MAIL必須輸入")
	//	form.maintain_email.focus();
	//	return false;
	//}
	
	if (fun == 'Insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
	}

	/* 
	for (var i = 0; i < form.amt.length; i++) {
		if (!checkFloatNumber(form.amt[i]))
			return false;
	}
	*/

	return true;
}

function checkShowInsert_G02(form, fun) {

    if (fun == 'delete') {
    	if (AskDelete()) {
    		form.Function.value = 'delete';
            form.submit();
            return true;
        } else
        	return false;
    }

	if (!Check_Maintain(form))
		return false;

	if (trimString(form.maintain_email.value) == "") {
		alert("承辦員E_MAIL必須輸入")
		form.maintain_email.focus();
		return false;
	}
	if (trimString(form.INPUT_NAME.value) == "") {
		alert("申報者姓名必須輸入")
		form.INPUT_NAME.focus();
		return false;
	}
	if (trimString(form.INPUT_TEL.value) == "") {
		alert("申報者電話必須輸入")
		form.INPUT_TEL.focus();
		return false;
	}

	if (fun == 'insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
		if (!CheckYear(form.beg_y))
			return false;
		if (!CheckYear(form.over_y))
			return false;
		if (trimString(form.cust_form.value) == "") {
			alert("統一編號或身分證字號必須輸入")
			return false;
		}
		if (trimString(form.cust_name.value) == "") {
			alert("大額授信客戶名稱必須輸入")
			return false;
		}
		if (trimString(form.beg_y.value) == "") {
			alert("開始動用日(年)必須輸入")
			return false;
		}
		if (trimString(form.beg_m.value) == "") {
			alert("開始動用日(月)必須輸入")
			return false;
		}
		if (trimString(form.beg_d.value) == "") {
			alert("開始動用日(日)必須輸入")
			return false;
		}
		if (trimString(form.over_y.value) == "") {
			alert("開始積欠日(年)必須輸入")
			return false;
		}
		if (trimString(form.over_m.value) == "") {
			alert("開始積欠日(月)必須輸入")
			return false;
		}
		if (trimString(form.over_d.value) == "") {
			alert("開始積欠日(日)必須輸入")
			return false;
		}
		var chkDate;
		chkDate =  '' + (parseInt(form.beg_y.value) + 1911) + '/' + form.beg_m.value + '/' + form.beg_d.value;
		if (fnValidDate(chkDate) != true) {
			alert('所輸入的開始動用日為無效日期!!');
    	    form.beg_d.focus();
        	return false;
   		}
		chkDate =  '' + (parseInt(form.over_y.value) + 1911) + '/' + form.over_m.value + '/' + form.over_d.value;
		if (fnValidDate(chkDate) != true) {
			alert('所輸入的開始積欠日為無效日期!!');
    	    form.over_d.focus();
        	return false;
   		}
	} //End of if

	for (var i =0; i < form.length; i++){
		if (form.elements[i].name == 'amt')	{
			if (!checkNumber(form.elements[i]))
				return false;
		}
	}
	form.Function.value = fun;
	if (fun == 'update')
		form.submit();

	return true;
}
function checkShowInsert_G05(form, fun) {

    if (fun == 'delete') {
    	if (AskDelete()) {
    		form.Function.value = 'delete';
            form.submit();
            return true;
        } else
        	return false;
    }

	if (!Check_Maintain(form))
		return false;

	if (trimString(form.maintain_email.value) == "") {
		alert("承辦員E_MAIL必須輸入")
		form.maintain_email.focus();
		return false;
	}
	if (trimString(form.INPUT_NAME.value) == "") {
		alert("申報者姓名必須輸入")
		form.INPUT_NAME.focus();
		return false;
	}
	if (trimString(form.INPUT_TEL.value) == "") {
		alert("申報者電話必須輸入")
		form.INPUT_TEL.focus();
		return false;
	}

	if (fun == 'insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
		if (trimString(form.cust_form.value) == "") {
			alert("統一編號或身分證字號必須輸入")
			return false;
		}
		if (trimString(form.cust_name.value) == "") {
			alert("大額授信客戶名稱必須輸入")
			return false;
		}
	} //End of if

	for (var i =0; i < form.length; i++){
		if (form.elements[i].name == 'amt')	{
			if (!checkNumber(form.elements[i]))
				return false;
		}
	}
	form.Function.value = fun;
	if (fun == 'update')
		form.submit();
	return true;
}
function checkShowInsert_H02(form, fun) {

    if (fun == 'delete') {
    	if (AskDelete()) {
    		form.Function.value = 'delete';
            form.submit();
            return true;
        } else
        	return false;
    }

	if (!Check_Maintain(form))
		return false;

	if (trimString(form.maintain_email.value) == "") {
		alert("承辦員E_MAIL必須輸入")
		form.maintain_email.focus();
		return false;
	}
	if (trimString(form.INPUT_NAME.value) == "") {
		alert("申報者姓名必須輸入")
		form.INPUT_NAME.focus();
		return false;
	}
	if (trimString(form.INPUT_TEL.value) == "") {
		alert("申報者電話必須輸入")
		form.INPUT_TEL.focus();
		return false;
	}

	if (fun == 'insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
	}

	for (var i =0; i < form.length; i++){
		if (form.elements[i].name == 'amt') {
			if (!checkNumber(form.elements[i]))
		   	    return false;
		}
	}
	return true;
}
function checkShowInsert_H03(form, fun) {

    if (fun == 'delete') {
    	if (AskDelete()) {
    		form.Function.value = 'delete';
            form.submit();
            return true;
        } else
        	return false;
    }

	if (!Check_Maintain(form))
		return false;

	if (trimString(form.maintain_email.value) == "") {
		alert("承辦員E_MAIL必須輸入")
		form.maintain_email.focus();
		return false;
	}
	if (trimString(form.INPUT_NAME.value) == "") {
		alert("申報者姓名必須輸入")
		form.INPUT_NAME.focus();
		return false;
	}
	if (trimString(form.INPUT_TEL.value) == "") {
		alert("申報者電話必須輸入")
		form.INPUT_TEL.focus();
		return false;
	}

	if (fun == 'insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
	}

	for (var i =0; i < form.length; i++){
//		if ((form.elements[i].name.substr(7) == 'amt') || (form.elements[i].name.substr(7) == 'amt1')) {
		if ((form.elements[i].name == 'amt') || (form.elements[i].name == 'amt1')) {
			if (!checkNumber(form.elements[i]))
		   	    return false;
		}
//		if (form.elements[i].name.substr(7) == 'rate') {
		if (form.elements[i].name == 'rate') {
			var m_rate = changeVal(form.elements[i]);
		    if (isNaN(Math.abs(m_rate))) {
		   	    alert("請輸入數字");
		   	    return false;
		    }
			if (!checkRate00(form.elements[i]))
				return false;
		}

	}
	return true;
}

function checkShowInsert_H04(form, fun) {

    if (fun == 'delete') {
    	if (AskDelete()) {
    		form.Function.value = 'delete';
            form.submit();
            return true;
        } else
        	return false;
    }

	if (!Check_Maintain(form))
		return false;

	if (trimString(form.maintain_email.value) == "") {
		alert("承辦員E_MAIL必須輸入")
		form.maintain_email.focus();
		return false;
	}
	if (trimString(form.INPUT_NAME.value) == "") {
		alert("申報者姓名必須輸入")
		form.INPUT_NAME.focus();
		return false;
	}
	if (trimString(form.INPUT_TEL.value) == "") {
		alert("申報者電話必須輸入")
		form.INPUT_TEL.focus();
		return false;
	}

	if (fun == 'insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
	}

	for (var i =0; i < form.length; i++){
		if (form.elements[i].name == 'amt') {
			if (!checkNumber(form.elements[i]))
		   	    return false;
		}
	}
	return true;
}
function checkShowInsert_H05(form, fun) {

    if (fun == 'delete') {
    	if (AskDelete()) {
    		form.Function.value = 'delete';
            form.submit();
            return true;
        } else
        	return false;
    }

	if (!Check_Maintain(form))
		return false;

	if (trimString(form.maintain_email.value) == "") {
		alert("承辦員E_MAIL必須輸入")
		form.maintain_email.focus();
		return false;
	}
	if (trimString(form.INPUT_NAME.value) == "") {
		alert("申報者姓名必須輸入")
		form.INPUT_NAME.focus();
		return false;
	}
	if (trimString(form.INPUT_TEL.value) == "") {
		alert("申報者電話必須輸入")
		form.INPUT_TEL.focus();
		return false;
	}

	if (fun == 'insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
	}

	for (var i =0; i < form.length; i++){
		if (form.elements[i].name == 'amt') {
			if (!checkNumber(form.elements[i]))
		   	    return false;
		}
	}
	return true;
}
function checkShowInsert_H06(form, fun) {

    if (fun == 'delete') {
    	if (AskDelete()) {
    		form.Function.value = 'delete';
            form.submit();
            return true;
        } else
        	return false;
    }

	if (!Check_Maintain(form))
		return false;

	if (trimString(form.maintain_email.value) == "") {
		alert("承辦員E_MAIL必須輸入")
		form.maintain_email.focus();
		return false;
	}
	if (trimString(form.INPUT_NAME.value) == "") {
		alert("申報者姓名必須輸入")
		form.INPUT_NAME.focus();
		return false;
	}
	if (trimString(form.INPUT_TEL.value) == "") {
		alert("申報者電話必須輸入")
		form.INPUT_TEL.focus();
		return false;
	}

	if (fun == 'insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
	}

	for (var i =0; i < form.length; i++){
		if (form.elements[i].name == 'amt') {
			if (!checkNumber(form.elements[i]))
		   	    return false;
		}
	}
	return true;
}
function checkShowInsert_H07(form, fun) {

    if (fun == 'delete') {
    	if (AskDelete()) {
    		form.Function.value = 'delete';
            form.submit();
            return true;
        } else
        	return false;
    }

	if (!Check_Maintain(form))
		return false;

	if (trimString(form.maintain_email.value) == "") {
		alert("承辦員E_MAIL必須輸入")
		form.maintain_email.focus();
		return false;
	}
	if (trimString(form.INPUT_NAME.value) == "") {
		alert("申報者姓名必須輸入")
		form.INPUT_NAME.focus();
		return false;
	}
	if (trimString(form.INPUT_TEL.value) == "") {
		alert("申報者電話必須輸入")
		form.INPUT_TEL.focus();
		return false;
	}

	if (fun == 'insert') {
		if (!checkSingleYM(form.S_YEAR, form.S_MONTH))
			return false;
	}

	for (var i =0; i < form.length; i++){
		if (form.elements[i].name == 'amt') {
			if (!checkNumber(form.elements[i]))
		   	    return false;
		}
		if (form.elements[i].name == 'rate') {
			var m_rate = changeVal(form.elements[i]);
		    if (isNaN(Math.abs(m_rate))) {
		   	    alert("請輸入數字");
		   	    return false;
		    }
			if (!checkRate00(form.elements[i]))
				return false;
		}
	}
	return true;
}
//=========================================================
function checkRate000(Rate1) {

	var rate = changeVal(Rate1)

    if (isNaN(Math.abs(rate))) {
// 	    alert("請輸入數字");
   	    return;
    }
    if (rate > 100.000 || rate < -99.999) {
        alert("利率不可大於 100.000, 也不可小於 -99.999")
        return;
    }
    if (rate.indexOf(".") != -1 ) {
        len = (rate.substring(rate.indexOf(".") + 1, rate.length));
        if (len.length > 3) {
            alert("小數點後只能有三個位數");
            return;
        }
    }
    return true;
}
//=========================================================
function checkRate00(Rate1) {

	var rate = changeVal(Rate1)

    if (isNaN(Math.abs(rate))) {
// 	    alert("請輸入數字");
   	    return;
    }
    if (rate > 100.00 || rate < -99.99) {
        alert("利率不可大於 100.00, 也不可小於 -99.99")
        return;
    }
    if (rate.indexOf(".") != -1 ) {
        len = (rate.substring(rate.indexOf(".") + 1, rate.length));
        if (len.length > 2) {
            alert("小數點後只能有二個位數");
            return;
        }
    }
    return true;
}

/* Add Method by Winnin.chu 2004.11.24*/
/* modify by 2354 2004.12.23*/
function changeStr_A05(amt_obj,amt_index,form){
	/* 上列以外依規定,風險權數未達100%之資產*/
	if(amt_obj.value=="") return;
	if(parseInt(form.acc_code[amt_index].value.substring(0,5))>=92071 &&
	   parseInt(form.acc_code[amt_index].value.substring(0,5))<=92075 &&
	   form.acc_code[amt_index].value.indexOf('N')==-1 &&
	   form.acc_code[amt_index].value.indexOf('P')!=-1){
		if(isNaN(amt_obj.value)==true){
			alert('請輸入數字');
			amt_obj.value="";
			amt_obj.focus();
			return ;
		}
		form.amt[amt_index-2].value=changeVal(form.amt[amt_index-2]);
		if(isNaN(form.amt[amt_index-2].value)){
			alert('請輸入帳面金額數字');
			form.amt[amt_index-2].focus();
			return ;
		}
		tmpassumed=parseInt(form.amt[amt_index-2].value)*parseFloat(amt_obj.value);
		tmpassumed=tmpassumed+"";
		/* 僅取到小數點後第3位*/
		if(tmpassumed.indexOf('.')!=-1) tmpassumed=tmpassumed.substring(0,tmpassumed.indexOf('.')+3);
		form.assumed_amt[amt_index-2].value=tmpassumed;
		form.assumed_amt[amt_index-2].value=changeStr(form.assumed_amt[amt_index-2]);
		document.all["div_assumed_amt"][amt_index-2].innerText=form.assumed_amt[amt_index-2].value;
		form.amt[amt_index-2].value=changeStr(form.amt[amt_index-2]);
	}else{
		amt_obj.value=changeStr(amt_obj);
		if(form.assumed[amt_index].value!="" && !isNaN(form.assumed[amt_index].value)){
			amt_obj.value=changeVal(amt_obj);
			tmpassumed=parseInt(amt_obj.value)*parseFloat(form.assumed[amt_index].value);
			tmpassumed=tmpassumed+"";
			/* 僅取到小數點後第3位*/
			if(tmpassumed.indexOf('.')!=-1) tmpassumed=tmpassumed.substring(0,tmpassumed.indexOf('.')+3);
			form.assumed_amt[amt_index].value=tmpassumed;
			form.assumed_amt[amt_index].value=changeStr(form.assumed_amt[amt_index]);
			document.all["div_assumed_amt"][amt_index].innerText=form.assumed_amt[amt_index].value;
			amt_obj.value=changeStr(amt_obj);
		}
	}
	i=0;
	assum=0;
	for(i=0;i<form.assumed_amt.length;i++){
		tmpstr=changeVal(form.assumed_amt[i]);
		if(tmpstr.length!=0 && !isNaN(tmpstr)){
			assum+=parseInt(tmpstr);
		}
	}
	form.amt[42].value=assum;
	form.amt[42].value=changeStr(form.amt[42]);
}

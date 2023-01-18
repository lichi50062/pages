function doSubmit(form,cnd,bank_type,bank_no,serial){
	    form.action="/pages/TC41.jsp?act="+cnd+"&test=nothing";
	    if(((cnd == "Insert") || (cnd == "Update") || (cnd == "Delete"))
	    && (!checkData(form,cnd))) return;

	    //if(cnd == "new" || cnd == "Qry") form.submit();
	    if(cnd == "new") form.submit();
	    if(cnd == "Qry"){
	    	if(!checkDate(form,cnd)) return;
	    	form.submit();
	    }
	    if(cnd == "Edit"){
	    	//if(!checkDate(form,cnd)) return;
	       	form.action="/pages/TC41.jsp?act="+cnd+"&SZBANK_TYPE="+bank_type+"&BANK_NO="+bank_no+"&SERIAL="+serial+"&test=nothing";
	       	form.submit();
	    }
	    if((cnd == "Insert") && AskInsert(form)) form.submit();
	    if((cnd == "Update") && AskUpdate(form)) form.submit();
	    if((cnd == "Delete") && AskDelete(form)) form.submit();
}

//重導TC41.jsp頁面以致輸出對應之金融機構資料
function getData(form,cnd,item){
	if(item == 'bank_type'){
		//初始BANK_NO值
	   	//form.BANK_NO.value="";
	}
	form.action="/pages/TC41.jsp?act=getData&nowact="+cnd+"&test=nothing";
	//940115 add
	//if(!checkData(form,cnd)) return;
	form.submit();
}

//輸入日期資料檢核處理
function checkDate(form,cnd)
{
	var ckDate;
	if(cnd =="Qry"){
		//輸入事件發生日期檢核處理
		if((trimString(form.EVENT_DATE_BEG_Y.value) != "" )
    	|| (trimString(form.EVENT_DATE_BEG_M.value) != "" )
    	|| (trimString(form.EVENT_DATE_BEG_D.value) != "" ))
    	{
    	    if (trimString(form.EVENT_DATE_BEG_Y.value)  != "" ){
    	    	if(isNaN(Math.abs(form.EVENT_DATE_BEG_Y.value))){
    	           alert("起始之事件發生日期(年)不可輸入文字");
				   form.EVENT_DATE_BEG_Y.focus();
    	           return false;
    	        }
    	    }else{
				alert("起始之事件發生日期(年)不可空白");
				form.EVENT_DATE_BEG_Y.focus();
				return false;
			}
    	    if (trimString(form.EVENT_DATE_BEG_M.value) == "" ){
				alert("起始之事件發生日期(月)不可空白");
				form.EVENT_DATE_BEG_M.focus();
				return false;
			}
			if (trimString(form.EVENT_DATE_BEG_D.value) == "" ){
				alert("起始之事件發生日期(日)不可空白");
				form.EVENT_DATE_BEG_D.focus();
				return false;
			}

    		ckDate = '' + (parseInt(form.EVENT_DATE_BEG_Y.value)+1911) + '/' + form.EVENT_DATE_BEG_M.value + '/' + form.EVENT_DATE_BEG_D.value;
    		startDate = '' + (parseInt(form.EVENT_DATE_BEG_Y.value)+1911) + form.EVENT_DATE_BEG_M.value + form.EVENT_DATE_BEG_D.value;

    		if( fnValidDate(ckDate) != true){
    	    	alert('起始之事件發生日期為無效日期!!');
    	    	form.EVENT_DATE_BEG_D.focus();
    	    	return false;
    		}
    		form.EVENT_DATE_BEG.value = ckDate;
    	}else{
    		alert("事件發生日期不可為空白");
    		return false;
    	}

		if((trimString(form.EVENT_DATE_END_Y.value) != "" )
    	|| (trimString(form.EVENT_DATE_END_M.value) != "" )
    	|| (trimString(form.EVENT_DATE_END_D.value) != "" ))
    	{
    	    if (trimString(form.EVENT_DATE_END_Y.value)  != "" ){
    	    	if(isNaN(Math.abs(form.EVENT_DATE_END_Y.value))){
    	           alert("結束之事件發生日期(年)不可輸入文字");
				   form.EVENT_DATE_END_Y.focus();
    	           return false;
    	        }
    	    }else{
				alert("結束之事件發生日期(年)不可空白");
				form.EVENT_DATE_END_Y.focus();
				return false;
			}
    	    if (trimString(form.EVENT_DATE_END_M.value) == "" ){
				alert("結束之事件發生日期(月)不可空白");
				form.EVENT_DATE_END_M.focus();
				return false;
			}
			if (trimString(form.EVENT_DATE_END_D.value) == "" ){
				alert("結束之事件發生日期(日)不可空白");
				form.EVENT_DATE_END_D.focus();
				return false;
			}

    		ckDate = '' + (parseInt(form.EVENT_DATE_END_Y.value)+1911) + '/' + form.EVENT_DATE_END_M.value + '/' + form.EVENT_DATE_END_D.value;
    		endDate = '' + (parseInt(form.EVENT_DATE_END_Y.value)+1911) + form.EVENT_DATE_END_M.value + form.EVENT_DATE_END_D.value;

    		if( fnValidDate(ckDate) != true){
    	    	alert('結束之事件發生日期為無效日期!!');
    	    	form.EVENT_DATE_END_D.focus();
    	    	return false;
    		}
    		form.EVENT_DATE_END.value = ckDate;
    	}else{
    		alert("事件發生日期不可為空白");
    		return false;
    	}

		if( eval(startDate) > eval(endDate) ){
    		alert("事件發生日期起始日期不可大於結束日期");
    	return false;
    	}

	}else {
    	//輸入事件日期檢核處理

		if((trimString(form.EVENT_DATE_Y.value) != "" )
    	|| (trimString(form.EVENT_DATE_M.value) != "" )
    	|| (trimString(form.EVENT_DATE_D.value) != "" ))
    	{
    	    if (trimString(form.EVENT_DATE_Y.value)  != "" ){
    	    	if(isNaN(Math.abs(form.EVENT_DATE_Y.value))){
    	           alert("事件日期(年)不可輸入文字");
				   form.EVENT_DATE_Y.focus();
    	           return false;
    	        }
    	    }else{
				alert("事件日期(年)不可空白");
				form.EVENT_DATE_Y.focus();
				return false;
			}
    	    if (trimString(form.EVENT_DATE_M.value) == "" ){
				alert("事件日期(月)不可空白");
				form.EVENT_DATE_M.focus();
				return false;
			}
			if (trimString(form.EVENT_DATE_D.value) == "" ){
				alert("事件日期(日)不可空白");
				form.EVENT_DATE_D.focus();
				return false;
			}

    		ckDate = '' + (parseInt(form.EVENT_DATE_Y.value)+1911) + '/' + form.EVENT_DATE_M.value + '/' + form.EVENT_DATE_D.value;

    		if( fnValidDate(ckDate) != true){
    	    	alert('事件日期為無效日期!!');
    	    	form.EVENT_DATE_D.focus();
    	    	return false;
    		}
    		form.EVENT_DATE.value = ckDate;
    	}else{
    		alert("事件發生日期不可為空白");
    		return false;
    	}

		if((trimString(form.RT_DATE_Y.value) != "" )
    	|| (trimString(form.RT_DATE_M.value) != "" )
    	|| (trimString(form.RT_DATE_D.value) != "" ))
    	{
    	    if (trimString(form.RT_DATE_Y.value)  != "" ){
    	    	if(isNaN(Math.abs(form.RT_DATE_Y.value))){
    	           alert("收文日期(年)不可輸入文字");
				   form.RT_DATE_Y.focus();
    	           return false;
    	        }
    	    }else{
				alert("收文日期(年)不可空白");
				form.RT_DATE_Y.focus();
				return false;
			}
    	    if (trimString(form.RT_DATE_M.value) == "" ){
				alert("收文日期(月)不可空白");
				form.RT_DATE_M.focus();
				return false;
			}
			if (trimString(form.RT_DATE_D.value) == "" ){
				alert("收文日期(日)不可空白");
				form.RT_DATE_D.focus();
				return false;
			}

    		ckDate = '' + (parseInt(form.RT_DATE_Y.value)+1911) + '/' + form.RT_DATE_M.value + '/' + form.RT_DATE_D.value;

    		if( fnValidDate(ckDate) != true){
    	    	alert('收文日期為無效日期!!');
    	    	form.RT_DATE_D.focus();
    	    	return false;
    		}
    		form.RT_DATE.value = ckDate;
    	}else{
    		alert("收文日期不可為空白");
    		return false;
    	}
    }

    return true;
}

//輸入資料檢核處理
function checkData(form,cnd)
{
	//alert("checkData 輸入項目檢核檢核 Start..");
	//檢核輸入日期
	if(!checkDate(form,cnd)) return;

	//輸入項目檢核
	if (trimString(form.RT_DOCNO.value) =="" ){
		alert("農金局收文文號不可空白");
		form.RT_DOCNO.focus();
		return false;
	}
   return true;
}
//組縣市別============
function changeCity(xml,year) {
	var form = this.document.forms[0];
	var citySeld = form.cityType.value; //已選擇的
	var banknoSeld = form.BANK_NO.value;
	var myXML,nodeValue, nodeName,nodeYear;
	//1.取得畫面年分 
	var begY = year.value=='' ? 0 : eval(year.value) ;
	Myear = '100' ;//預設年分100年
	if(begY!=0 && begY<=99) {
		Myear = '99' ;
	}
	//2.讀cityXml
	myXML = document.all(xml).XMLDocument;
	nodeValue = myXML.getElementsByTagName("cityValue");
	nodeName = myXML.getElementsByTagName("cityName");
	nodeYear = myXML.getElementsByTagName("cityYear");
	//3.移除已搬入的資料
	var target = document.getElementById("cityType");
	target.length = 0;
	
	var oOption = document.createElement("OPTION");
	oOption.text="全部";
	oOption.value="";
	target.add(oOption);
	
	//4.判斷縣市年分組選單
	for(var i=0;i<nodeName.length ;i++)	{
		if(nodeYear.item(i).firstChild.nodeValue==Myear) {
			oOption = document.createElement("OPTION");
       	 	oOption.text=nodeName.item(i).firstChild.nodeValue;
	        oOption.value=nodeValue.item(i).firstChild.nodeValue;  
	        target.add(oOption);
		}
	}
	setSelect(this.document.forms[0].cityType,citySeld);
	//this.document.forms[0].BANK_NO.value='';
}
/*
function changeCity(xml,year) {
	var citySeld = $('select[@name=cityType]').val() ; //已選擇的
	var flg = false ;
	var myXML,nodeValue, nodeName,nodeYear;
	//1.取得畫面年分 
	var begY = $('input[@name='+year+']').val()=='' ? 0 : eval($('input[@name='+year+']').val()) ;
	Myear = '100' ;//預設年分100年
	if(begY<=99) {
		Myear = '99' ;
	}
	//2.讀cityXml
	myXML = document.all(xml).XMLDocument;
	nodeValue = myXML.getElementsByTagName("cityValue");
	nodeName = myXML.getElementsByTagName("cityName");
	nodeYear = myXML.getElementsByTagName("cityYear");
	//3.移除已搬入的資料
	$('select[@name=cityType] >option').remove() ;
	
	$('select[@name=cityType]').append("<option value=''>全部</option>") ;
	//4.判斷縣市年分組選單
	for(var i=0;i<nodeName.length ;i++)	{
		if(nodeYear.item(i).firstChild.nodeValue==Myear) {
			if(nodeValue.item(i).firstChild.nodeValue==citySeld) {
				flg =true ;
			}
			$('select[@name=cityType]')
			.append("<option value='"+nodeValue.item(i).firstChild.nodeValue+"' year='"+nodeYear.item(i).firstChild.nodeValue+"' seleced='"+flg+"'>"+nodeName.item(i).firstChild.nodeValue+"</option>") ;
		}
		flg = false ;
	}
}*/
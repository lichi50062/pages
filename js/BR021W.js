//99.12.31 add 根據查詢年月.改變縣市別名稱
function changeCity(target, source, form) {
      var myXML,nodeType,nodeValue, nodeName,nodeYear,m_year;      
      m_year = source.value;
      if(m_year >= 100){
         m_year = 100;
      }else{
         m_year = 99;
      }
	var xmlDoc = $.parseXML($("xml[id=CityXML]").html()) ;
	var data = $(xmlDoc).find("data") ;
	target.length = 0;
	var oOption;

	oOption = document.createElement("OPTION");
	oOption.text='全部';
	oOption.value='ALL';
	target.add(oOption);

	$(data).each(function (i) {
		if ($(this).find("cityyear").text() == m_year)  {
			oOption = document.createElement("OPTION");
			oOption.text= $(this).find("cityname").text();
			oOption.value=$(this).find("cityvalue").text();
			target.add(oOption);
		}

	})
	;
	//document.BankListfrm.HSIEN_ID[0].selected=true;//111.03.21移除不使用
	changeOption(form,'');
}


//94.03.24 add 營運中/已裁撤 by 2295
function changeOption(form,cnd){
    var myXML,nodeType,nodeValue, nodeName,nodeYear;
    var m_year = form.S_YEAR.value;
    //alert(m_year);    
    if(m_year >= 100){
       m_year = 100;
    }else{
       m_year = 99;
    }
	form.BankListSrc.length = 0;
	if (cnd == 'change') {
		form.BankListDst.length = 0;
	}
	var oOption;
	var checkAdd = false;
	var xmlDoc = $.parseXML($("xml[id=TBankXML]").html()) ;
	var data = $(xmlDoc).find("data") ;
	$(data).each(function (i) {
		// if( form.bank_type.value!='ALL' && ($(this).find("banktype").text() != form.bank_type.value)) return;//農漁會別
		if($(this).find("bankyear").text() != m_year)	return;//顯示查詢年度的新機構名稱111113;
		if(form.HSIEN_ID.value == 'ALL'){
			oOption = document.createElement("OPTION");
			if(form.CANCEL_NO.value == 'N'){//營運中
				if($(this).find("bntype").text() != '2'){
					oOption.text= $(this).find("bankname").text();
					oOption.value=$(this).find("bankvalue").text();
				}
			}else{//已裁撤
				if($(this).find("bntype").text() == '2'){
					oOption.text= $(this).find("bankname").text();
					oOption.value=$(this).find("bankvalue").text();
				}
			}
			checkAdd=false;
			for(var k =0;k<form.BankListDst.length;k++){
				if(form.BankListDst.options[k].text == oOption.text){
					checkAdd = true;
				}
			}
			if(checkAdd == false && oOption.text != '' && oOption.value != ''){
				form.BankListSrc.add(oOption);
			}
		}else if ($(this).find("hsienid").text() == form.HSIEN_ID.value){
			oOption = document.createElement("OPTION");
			if(form.CANCEL_NO.value == 'N'){//營運中
				if($(this).find("bntype").text() != '2'){
					oOption.text= $(this).find("bankname").text();
					oOption.value=$(this).find("bankvalue").text();
				}
			}else{//已裁撤
				if($(this).find("bntype").text() == '2'){
					oOption.text= $(this).find("bankname").text();
					oOption.value=$(this).find("bankvalue").text();
				}
			}
			checkAdd=false;
			for(var k =0;k<form.BankListDst.length;k++){
				if(form.BankListDst.options[k].text == oOption.text){
					checkAdd = true;
				}
			}
			if(checkAdd == false && oOption.text != '' && oOption.value != ''){
				form.BankListSrc.add(oOption);
			}
		}
	})
	;
}
function setSelect(S1, bankid) {
    if(S1 == null)
    	return;
    for(i=0;i<S1.length;i++) {
      	if(S1.options[i].value==bankid)    	{
        	S1.options[i].selected=true;
        	break;
    	}
    }
}



function fn_ShowPanel(cnd){
	//act=BankList/RptColumn/RptOrder/RptType	
	this.document.forms[0].action = "/pages/BR021W.jsp?act="+cnd;	
	this.document.forms[0].target = '_self';
	this.document.forms[0].submit();
}
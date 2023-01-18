//撤銷項目============
//111.04.19 fix 調整xml取得方式
function changeRevoke(xml) {
	var form = document.form;
	//var myXML,nodeValue, nodeName;
	
	//1.讀revokeXml
	/*
	myXML = document.all(xml).XMLDocument;
	nodeValue = myXML.getElementsByTagName("revokeCode");
	nodeName = myXML.getElementsByTagName("revokeName");
	*/	
	//3.移除已搬入的資料
	var target = document.getElementById("revokeType");
	target.innerHTML = '';
	
	var xmlDoc = $.parseXML($("xml[id=RevokeXML]").html()) ;    
    var data = $(xmlDoc).find("data") ;
    
	//4.產生撤銷項目checkbox選單
	/*
	for(var i=0; i<nodeName.length ;i++)	{
		checkboxItem = document.createElement("INPUT");
		checkboxItem.setAttribute("type", "checkbox");
		checkboxItem.setAttribute("id", nodeValue.item(i).firstChild.nodeValue);
		checkboxItem.setAttribute("name", "revokeCheckbox");
		checkboxItem.setAttribute("value", nodeValue.item(i).firstChild.nodeValue);
		
		checkboxLabel = document.createElement("LABEL");
		checkboxLabel.innerHTML = nodeName.item(i).firstChild.nodeValue + '<br>';
		
		target.appendChild(checkboxItem);
		target.appendChild(checkboxLabel);
	}
	*/
	$(data).each(function (i) {      	
     	checkboxItem = document.createElement("INPUT");
		checkboxItem.setAttribute("type", "checkbox");
		checkboxItem.setAttribute("id", $(this).find("revokecode").text());
		checkboxItem.setAttribute("name", "revokeCheckbox");
		checkboxItem.setAttribute("value", $(this).find("revokecode").text());		
		checkboxLabel = document.createElement("LABEL");
		checkboxLabel.innerHTML = $(this).find("revokename").text() + '<br>';
		
		target.appendChild(checkboxItem);
		target.appendChild(checkboxLabel);	
    })
    ;
	
}
//組縣市別============
//111.04.19 fix 調整xml取得方式
function changeCity(xml,year) {
	var form = document.form;
	var citySeld = form.cityType.value; //已選擇的
	/*111.04.19
	var myXML,nodeValue, nodeName,nodeYear;
	//1.取得畫面年分 
	//var begY = year.value=='' ? 0 : eval(year.value) ;
	*/
	Myear = '100' ;//預設年分100年
	//if(begY<=99) {
		//Myear = '99' ;
	//}
	//2.讀cityXml
	/*111.04.19
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
	*/
	var xmlDoc = $.parseXML($("xml[id=CityXML]").html()) ;    
    var data = $(xmlDoc).find("data") ;
    var oOption;
    //3.移除已搬入的資料	
	document.form.cityType.length = 0;
	var oOption = document.createElement("OPTION");
	oOption.text="全部";
	oOption.value="";
	document.form.cityType.add(oOption);
	
	//4.判斷縣市年分組選單
	$(data).each(function (i) {      	
     	if ($(this).find("cityyear").text() == Myear)  {
            oOption = document.createElement("OPTION");  			
			oOption.text= $(this).find("cityname").text();
  			oOption.value=$(this).find("cityvalue").text();
  			document.form.cityType.add(oOption); 
    	}
     	
    })
    ;

	setSelect(form.cityType,citySeld);
}
//組金融機構畫面-僅show總機構
//111.04.19 fix 調整xml取得方式
function changeTbankWhenFilterBankKind(xml,year) {
	var form = document.form;
	//var myXML,nodeValue, nodeName,nodeYear,nodeType,nodeCity,nodeKind;
	//1.取得畫面年分 

	Myear = '100' ;//預設年分100年
	
	//2.讀cityXml
	/*111.04.19 fix
	myXML = document.all(xml).XMLDocument;
	nodeValue = myXML.getElementsByTagName("tbank_no");
	nodeName = myXML.getElementsByTagName("bankName");
	nodeYear = myXML.getElementsByTagName("m_year");
	nodeType = myXML.getElementsByTagName("bankType") ;
	nodeCity = myXML.getElementsByTagName("bankCity") ;
	nodeKind = myXML.getElementsByTagName("bankKind") ;
	*/
	//3.取得 城市代號
	citycode = form.cityType.value ;
	//4.取得金融機構類別
	bankType = form.bankType.value ;
	//5.移除已搬入的資料
	document.form.tbank.length = 0;	
	
	var oOption = document.createElement("OPTION");
		
	oOption.text="請選擇...";
	oOption.value="";
	document.form.tbank.add(oOption);
	
	//alert("changeTbankWhenFilterBankKind") ;
	/*111.04.19 fix
	for(var i=0;i<nodeName.length ;i++)	{
		if("0"==nodeKind.item(i).firstChild.nodeValue ) {
			if((citycode==''||nodeCity.item(i).firstChild.nodeValue== citycode) 
					&& nodeYear.item(i).firstChild.nodeValue==Myear
					&& (bankType==''||nodeType.item(i).firstChild.nodeValue==bankType)) {
				oOption = document.createElement("OPTION");
	       	 	oOption.text=nodeName.item(i).firstChild.nodeValue;
		        oOption.value=nodeValue.item(i).firstChild.nodeValue;  
		        target.add(oOption);
			}
		} else {
			//console.log("name = "+nodeName.item(i).firstChild.nodeValue) ;
		}
	}
	*/
	var xmlDoc = $.parseXML($("xml[id=TBankXML]").html()) ;    
    var data = $(xmlDoc).find("data") ;
	$(data).each(function (i) {      	
     	if("0"==$(this).find("bankkind").text() ) {
			if((citycode==''||$(this).find("bankcity").text()== citycode) 
					&& $(this).find("m_year").text()==Myear
					&& (bankType==''||$(this).find("banktype").text()==bankType)) {
				oOption = document.createElement("OPTION");
	       	 	oOption.text=$(this).find("bankname").text();
		        oOption.value=$(this).find("tbank_no").text();  
		        document.form.tbank.add(oOption);
			}
		}
     	
    })
    ;
	
	
}
//111.04.19 fix 調整xml取得方式
function changeTbank(xml,year) {
	var form = document.form;
	//var myXML,nodeValue, nodeName,nodeYear,nodeType,nodeCity;
	//1.取得畫面年分 

	Myear = '100' ;//預設年分100年
	
	//2.讀cityXml
	/*
	myXML = document.all(xml).XMLDocument;
	nodeValue = myXML.getElementsByTagName("bankValue");
	nodeName = myXML.getElementsByTagName("bankName");
	nodeYear = myXML.getElementsByTagName("m_year");
	nodeType = myXML.getElementsByTagName("bankType") ;
	nodeCity = myXML.getElementsByTagName("bankCity") ;
	*/
	//3.取得 城市代號
	citycode = form.cityType.value ;
	//4.取得金融機構類別
	bankType = form.bankType.value ;
	//5.移除已搬入的資料
	document.form.tbank.length = 0;	
	
	if(citycode==''){		
		var oOption = document.createElement("OPTION");
		oOption.text="全部";
		oOption.value="";
		document.form.tbank.add(oOption);
	}
	var xmlDoc = $.parseXML($("xml[id=TBankXML]").html()) ;    
    var data = $(xmlDoc).find("data") ;
	/*111.04.19 fix
	for(var i=0;i<nodeName.length ;i++)	{
		if((citycode==''||nodeCity.item(i).firstChild.nodeValue== citycode) 
				&& nodeYear.item(i).firstChild.nodeValue==Myear
				&& nodeType.item(i).firstChild.nodeValue==bankType) {
			oOption = document.createElement("OPTION");
       	 	oOption.text=nodeName.item(i).firstChild.nodeValue;
	        oOption.value=nodeValue.item(i).firstChild.nodeValue;  
	        target.add(oOption);
		}
	}
	*/
	$(data).each(function (i) {      	
     	if((citycode==''||$(this).find("bankcity").text()== citycode) 
				&& $(this).find("m_year").text()==Myear
				&& $(this).find("banktype").text()==bankType) {
            oOption = document.createElement("OPTION");  			
			oOption.text= $(this).find("bankname").text();
  			oOption.value=$(this).find("bankvalue").text();
  			document.form.tbank.add(oOption); 
    	}
     	
    })
    ;
}

function setSelect(S1, val) {
    if(S1 == null)
    	return;
    for(i=0;i<S1.length;i++) {
      	if(S1.options[i].value==val)    	{
        	S1.options[i].selected=true;
        	break;
    	}
    }
}
//查詢
function goQuery(f) {
	f.act.value = "Query";
	f.submit();
}
function goNewEdit(f) {
	f.act.value = "New";
	f.submit();
}
function goMtnPage(f , qTbankNo, seqNo){
	f.act.value = "Mtn";
	f.qTbankNo.value = qTbankNo;
	f.qSeqNo.value = seqNo;
	f.submit();
}
function setInsertData() {
	var jdata = {'data' :[]} ;
	var revokeList = $('input[name="revokeCheckbox"]:checked').each(function() {				
		jdata.data.push(this.value);
	});
	document.getElementsByName("jData")[0].value = JSON.stringify(jdata) ; 
}

function doInsert() {
	var form = document.form; 
	form.revokeDate.value = '';//撤銷日期
	//檢核
	var chkFlg = true ;
	if($("doc_no").val()=="") {
		alert("請輸入撤銷文號!");
		chkFlg = false ;
	}
	
	if($('input[name="revokeCheckbox"]:checked').length==0){
		alert("請勾選撤銷項目!");
		chkFlg = false ;
	}
	
	mergeCheckedDate("revokeDate_year;revokeDate_month;revokeDate_day","revokeDate");
	
	if (trimString(form.revokeDate.value) =="" ){
		alert("撤銷日期不可空白");
		chkFlg = false ;
	}
	if (trimString(form.doc_no.value) =="" ){
		alert("請輸入撤銷文號!");
		chkFlg = false ;
	}
	if(chkFlg) {
		form.act.value = "INS" ;
		setInsertData() ;
		form.submit();
	}
}
function doUpdate() {
	var form = document.form; 
	form.revokeDate.value = '';//撤銷日期
	//檢核
	var chkFlg = true ;
	if($("doc_no").val()=="") {
		alert("請輸入撤銷文號!");
		chkFlg = false ;
	}
	
	if($('input[name="revokeCheckbox"]:checked').length==0){
		alert("請勾選撤銷項目!");
		chkFlg = false ;
	}
	
	mergeCheckedDate("revokeDate_year;revokeDate_month;revokeDate_day","revokeDate");
	
	if (trimString(form.revokeDate.value) =="" ){
		alert("撤銷日期不可空白");
		chkFlg = false ;
	}
	if(chkFlg) {
		form.act.value = "UPD" ;
		setInsertData() ;
		form.submit();
	}
}
function doMtnDelete() {
	var delItem = $("#tbank").val()+","+$("#seqNo").val();
	
	var form = document.form; 
	form.delItem.value = delItem ;
	form.act.value = "DEL";
	form.submit() ;
}
function doDelete() {
	var delBox = document.getElementsByName("delBox") ;
	var selFlg = false ;
	var delItem = "";
	for(i=0;i < delBox.length ; i++) {
		if(delBox[i].checked) {
			if(delItem!="") {
				delItem+=";"+delBox[i].value ;
			} else {
				delItem = delBox[i].value ;
			}
			
			selFlg= true ;
		}
	}
	if(!selFlg) {
		alert("請選擇要刪除的機構代號選項!");
		return  ;
	} else {
		var form = document.form; 
		form.delItem.value = delItem ;
		form.act.value = "DEL"; 
		form.submit() ;
	}
}

function goBack() {
	var f = document.getElementsByName("form")[0] ;
	f.act.value = "List";
	f.submit();
}

function goBackAndQuery() {
	var f = document.getElementsByName("form")[0] ;
	f.act.value = "Query";
	f.submit();
}


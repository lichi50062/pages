//111.01.17 fix 調整xml取得方式
//組縣市別============
function changeCity() {
	var form = document.form;
	var citySeld = document.form.cityType.value; //已選擇的
	Myear = '100' ;//預設年分100年
	/*111.01.17 fix
	var myXML,nodeValue, nodeName,nodeYear;
	//1.取得畫面年分 
	//var begY = year.value=='' ? 0 : eval(year.value) ;
	Myear = '100' ;//預設年分100年
	//if(begY<=99) {
		//Myear = '99' ;
	//}
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
	*/
	
	
	var xmlDoc = $.parseXML($("xml[id=CityXML]").html()) ;
    document.form.cityType.length = 0;
    var data = $(xmlDoc).find("data") ;   
    var oOption = document.createElement("OPTION");
	oOption.text="全部";
	oOption.value="";	
    document.form.cityType.add(oOption);  
    
    
     $(data).each(function (i) {
    	if($(this).find("cityyear").text()==Myear) {
            oOption = document.createElement("OPTION");  			
			oOption.text= $(this).find("cityname").text();
  			oOption.value=$(this).find("cityvalue").text();
  			document.form.cityType.add(oOption);  			
        }       
    })
    ;
	
	setSelect(document.form.cityType,citySeld);
}
//組金融機構畫面-僅show總機構
function changeTbankWhenFilterBankKind() {
	var form = document.form;
	//var myXML,nodeValue, nodeName,nodeYear,nodeType,nodeCity,nodeKind;
	//1.取得畫面年分 

	Myear = '100' ;//預設年分100年
	/*111.01.17 fix
	//2.讀cityXml
	myXML = document.all(xml).XMLDocument;
	nodeValue = myXML.getElementsByTagName("tbank_no");
	nodeName = myXML.getElementsByTagName("bankName");
	nodeYear = myXML.getElementsByTagName("m_year");
	nodeType = myXML.getElementsByTagName("bankType") ;
	nodeCity = myXML.getElementsByTagName("bankCity") ;
	nodeKind = myXML.getElementsByTagName("bankKind") ;
	//3.取得 城市代號
	citycode = form.cityType.value ;
	//4.取得金融機構類別
	bankType = form.bankType.value ;
	//5.移除已搬入的資料
	var target = document.getElementById("tbank");
	target.length = 0;
	
	var oOption = document.createElement("OPTION");
	oOption.text="全部";
	oOption.value="";
	target.add(oOption);
	//alert("changeTbankWhenFilterBankKind") ;
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
	//3.取得 城市代號
	citycode = form.cityType.value ;
	//4.取得金融機構類別
	bankType = form.bankType.value ;
	var xmlDoc = $.parseXML($("xml[id=TBankXML]").html()) ;
    document.form.tbank.length = 0;
    var data = $(xmlDoc).find("data") ;   
    var oOption = document.createElement("OPTION");
	oOption.text="全部";
	oOption.value="";	
    document.form.tbank.add(oOption);  
    
    
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
//111.01.17 fix 調整xml取得方式
function changeTbank() {
	/*111.01.17 fix
	var form = document.forms[0];
	var myXML,nodeValue, nodeName,nodeYear,nodeType,nodeCity;
	//1.取得畫面年分 

	Myear = '100' ;//預設年分100年
	
	//2.讀cityXml
	myXML = document.all(xml).XMLDocument;
	nodeValue = myXML.getElementsByTagName("bankValue");
	nodeName = myXML.getElementsByTagName("bankName");
	nodeYear = myXML.getElementsByTagName("m_year");
	nodeType = myXML.getElementsByTagName("bankType") ;
	nodeCity = myXML.getElementsByTagName("bankCity") ;
	//3.取得 城市代號
	citycode = form.cityType.value ;
	//4.取得金融機構類別
	bankType = form.bankType.value ;
	//5.移除已搬入的資料
	var target = document.getElementById("tbank");
	target.length = 0;
	
	var oOption = document.createElement("OPTION");
	oOption.text="全部";
	oOption.value="";
	target.add(oOption);
	
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
	var form = document.form;
	//var myXML,nodeValue, nodeName,nodeYear,nodeType,nodeCity;
	//1.取得畫面年分 
	var Myear = '100' ;//預設年分100年
	//3.取得 城市代號
	var citycode = form.cityType.value ;
	//4.取得金融機構類別
	var bankType = form.bankType.value ;
	
	var xmlDoc = $.parseXML($("xml[id=TBankXML]").html()) ;
    document.form.tbank.length = 0;
    var data = $(xmlDoc).find("data") ;   
    var oOption = document.createElement("OPTION");
	oOption.text="全部";
	oOption.value="";	
    document.form.tbank.add(oOption);  
    
    
     $(data).each(function (i) {
    	if((citycode==''|| $(this).find("bankcity").text()== citycode) 
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
//查詢
function goQuery(f) {
	f.act.value = "Query";
	f.submit();
}
function goNewEdit(f) {
	f.act.value = "New";
	f.submit();
}
function goMtnPage(f , qTbankNo){
	f.act.value = "Mtn";
	f.qTbankNo.value = qTbankNo;
	f.submit();
}
function bankNoRolesCheck(bank_no) {
	if(bank_no.length!=7) {
		alert("機構代碼長度應為7碼，請再確認!") ;
		return false ;
	}
	var bank_array = new Array(7); 
	var power = new Array(3 , 7 , 9, 3 , 7 ,9 ) ;//權術
	

	bank_array[0] = parseInt(bank_no.substr(0,1) ,10 ) ;
	bank_array[1] = parseInt(bank_no.substr(1,1) ,10 ) ;
	bank_array[2] = parseInt(bank_no.substr(2,1) ,10 ) ;
	bank_array[3] = parseInt(bank_no.substr(3,1) ,10 ) ;
	bank_array[4] = parseInt(bank_no.substr(4,1) ,10 ) ;
	bank_array[5] = parseInt(bank_no.substr(5,1) ,10 ) ;

	var checkNumber1 = bank_array[0]*power[0] + bank_array[1]*power[1] + bank_array[2]*power[2] ;
	if(checkNumber1 >= 10 ) {
		var stemp = checkNumber1.toString() ;
		checkNumber1 = parseInt(stemp.substr(stemp.length-1 ,1 ) ,10) ;
	}
	var checkNumber2 = bank_array[3]*power[3] + bank_array[4]*power[4] + bank_array[5]*power[5] ;
	if(checkNumber2 >= 10 ) {
		var stemp = checkNumber2.toString() ;
		checkNumber2 = parseInt(stemp.substr(stemp.length-1 ,1 ) ,10) ;
	}
	var checkNumber3 = checkNumber1 + checkNumber2 ;
	var checkNumberF = 10-parseInt(checkNumber3.toString().substr(checkNumber3.toString().length-1,1) ,10);
	
	if(checkNumberF >= 10 ) {
		var stemp = checkNumberF.toString() ;
		checkNumberF = parseInt(stemp.substr(stemp.length-1 ,1 ) ,10) ;
	}
	
	
	if(parseInt(bank_no.substr(6,1) , 10) != checkNumberF){
		alert("變更後的機構代碼為["+bank_no+"]，最後一碼檢核碼為["+bank_no.substr(6,1)+"]，與運算後的檢核碼["+checkNumberF+"]不一致")
		return false ;
	}
	return true ;
}
//111.04.20 調整input欄位取得方式
function setInsertData() {
	var pbNo = document.getElementsByName("p_bank_no") ;
	var btype_tmp = document.getElementsByName("btype_ins") ;//111.04.20 add
	var bkind_tmp = document.getElementsByName("bkind_ins") ;//111.04.20 add
	var bankNo_tmp = document.getElementsByName("bankNo_ins") ;//111.04.20 add
	var tbank_tmp = document.getElementsByName("tbank_ins") ;//111.04.20 add
	//alert('pbNo.length='+pbNo.length);
	//alert('btype_tmp.length='+btype_tmp.length);
	//alert('bkind_tmp.length='+bkind_tmp.length);
	//alert('bankNo_tmp.length='+bankNo_tmp.length);
	//alert('tbank_tmp.length='+tbank_tmp.length);
	var jdata = {'data' :[]} ;
	for(i=0 ; i < pbNo.length ; i++) {
		//alert('i='+i);		
		var btype = btype_tmp[i].value ;
		var bkind = bkind_tmp[i].value ;
		var srcBankNo = bankNo_tmp[i].value ;
		var tbank = tbank_tmp[i].value ;
		var bankNo =pbNo[i].value ;
		//alert('btype='+btype);
		//alert('bkind='+bkind);
		//alert('srcBankNo='+srcBankNo);
		//alert('tbank='+tbank);
		//alert('bankNo='+bankNo);
		var rec = {
				"bankNo":bankNo ,
				"srcBankNo":srcBankNo ,
				"btype":btype ,
				"bkind":bkind ,
				"tbank":tbank
				}	;
		jdata.data.push(rec) ;
	}
	document.getElementsByName("jData")[0].value = JSON.stringify(jdata) ; 
}
//111.04.20 調整input欄位取得方式
function setUpdateData() {
	var pbNo = document.getElementsByName("p_bank_no") ;
	var srcBankNo_tmp = document.getElementsByName("srcBankNo_upd") ;//111.04.20 add
	var tbank_tmp = document.getElementsByName("tbank_upd") ;//111.04.20 add
	
	var jdata = {'data' :[]} ;
	//alert('pbNo.length='+pbNo.length);
	//alert('srcBankNo_tmp.length='+srcBankNo_tmp.length);
	//alert('tbank_tmp.length='+tbank_tmp.length);
	for(i=0 ; i < pbNo.length ; i++) {
		//alert('i='+i);		
		var srcBankNo = srcBankNo_tmp[i].value ;
		var tbank = tbank_tmp[i].value ;
		var bankNo =pbNo[i].value ;		
		//alert('srcBankNo='+srcBankNo);
		//alert('tbank='+tbank);
		//alert('bankNo='+bankNo);
		var rec = {
				"bankNo":bankNo ,
				"srcBankNo":srcBankNo ,				
				"tbank":tbank
				}	;
		jdata.data.push(rec) ;
	}
	document.getElementsByName("jData")[0].value = JSON.stringify(jdata) ; 
}

function doCancel(){
	var p = document.getElementsByName("p_bank_no") ;
	for(i=0 ; i < p.length ; i ++) {
		p[i].value = "" ;
	}
	alert("已清除變更後的代碼資料欄位。");
}
function doInsert() {
	var form = document.form; 
	form.onlineDate.value = '';//106.11.22 add 機構代碼轉換日期
	//檢核
	var chkFlg = true ;
	var bank_no = document.getElementsByName("p_bank_no") ;
	for(i = 0 ; i < bank_no.length ; i++) {
		if(bank_no[i].value=="") {
			alert("請輸入變更後的代碼!");
			chkFlg = false ;
			break ;
		} else {
			if(!bankNoRolesCheck(bank_no[i].value)) {
				chkFlg = false  ;
			}
		}
	}
	
	mergeCheckedDate("onlineDate_year;onlineDate_month;onlineDate_day","onlineDate");
	
	if (trimString(form.onlineDate.value) =="" ){
		alert("機構代號轉換日日期不可空白");
		return false;
	}
	//alert(form.onlineDate.value);
	if(chkFlg) {
		form.act.value = "INS" ;
		setInsertData() ;
		form.submit();
	}
}
function doUpdate() {
	var form = document.form; 
	form.onlineDate.value = '';//106.11.22 add 機構代碼轉換日期
	//檢核
	var chkFlg = true ;
	var bank_no = document.getElementsByName("p_bank_no") ;
	for(i = 0 ; i < bank_no.length ; i++) {
		if(bank_no[i].value=="") {
			alert("請輸入變更後的代碼!");
			chkFlg = false ;
			break ;
		} else {
			//alert('bank_no[i].value='+bank_no[i].value);
			if(!bankNoRolesCheck(bank_no[i].value)) {
				chkFlg = false  ;
			}
		}
	}
	mergeCheckedDate("onlineDate_year;onlineDate_month;onlineDate_day","onlineDate");
	
	if (trimString(form.onlineDate.value) =="" ){
		alert("機構代號轉換日日期不可空白");
		return false;
	}
	//alert(form.onlineDate.value);
	if(chkFlg) {
		form.act.value = "UPD" ;
		setUpdateData() ;
		form.submit();
	}
}
function doMtnDelete() {
	//p_bank_no
	var delBox = document.getElementsByName("p_bank_no") ;
	var tbank_tmp = document.getElementsByName("tbank_upd") ;//111.04.20 add
	var delItem = "";
	for(i=0;i < delBox.length ; i++) {
		if(delBox[i].tbank!="") {
			var tbank = tbank_tmp[i].value ;
			if(delItem!="") {
				delItem+=";"+tbank ;
			} else {
				delItem = tbank ;
			}
		}
	}

	if(delItem=="") {
		alert("請輸入變更後的配賦代號!");
		return  ;
	} else {
		var form = document.form; 
		form.delItem.value = delItem ;
		//form.act.value = "MTN_DEL";
		form.act.value = "DEL";
		form.submit() ;
	}
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

function doPrint() {
	var form = document.form; 
	form.act.value = "Print";
	form.submit();
}

function doDownload() {
	var form = document.form; 
	form.act.value = "Download";
	form.submit();
}

function goDetailPage(src_bank_no ,bank_no ) {
	var form = document.form; 
	form.bank_no.value = bank_no ;
	form.src_bank_no.value = src_bank_no ;
	form.act.value = "goDetailPg";
	form.submit();
}
function goBack() {
	var f = document.getElementsByName("form")[0] ;
	f.act.value = "List";
	f.submit();
}


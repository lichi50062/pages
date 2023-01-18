//101.09.21 拿掉缺失摘要長度限制 by 2295
//109.05.15 增加修改機構代碼及機構類別 by 2295
function doSubmit(form,cmd,id, report){
    if(cmd == "Qry") {
        if(checkDuringDate(form)) {
            form.act.value = "Qry";
            form.submit();
        }
    }else if(cmd == "Qry2") {    	
        form.reportno.value = id;
        form.act.value = "Qry2";
        form.submit();
    }else if(cmd == "New") {
        form.act.value = "New";
        form.submit();
    }else if(cmd == "Edit") {
        form.item_no.value = id;
        form.reportno_seq.value = report;
        form.act.value = "Edit";
        form.submit();
    }else if(cmd == "NewReportNo") {
        form.act.value = "NewReportNo";
        form.submit();   
    }else if(cmd == "InsertNew") { //111.06.09 add
        if(!checkExReportFData(form,"Insert")) {
            return ;
        }
        if(confirm("是否新增檢查報告資料?")) {
            form.act.value = "InsertNew";
            form.submit();
        }    
    }else if(cmd == "Insert") {
        if(!checkInsertData(form,"Insert")) {
            return ;
        }
        if(confirm("是否新增資料?")) {
            form.act.value = "Insert";
            form.submit();
        }
    }else if(cmd == "Update") {

        if(!checkUpdateData(form)) {
            return ;
        }
        if(confirm("是否修改資料?")) {
            isChangeSec1(form);
            isChangeSec2(form);
            form.act.value = "Update";
            form.submit();
        }
    } else if(cmd == "Delete") {
        if(confirm("是否刪除資料?")) {
            form.act.value = "Delete";
            form.submit();
        }
    } else if(cmd == "List") {
        form.act.value = "List";
        form.submit();

    }
    return ;
}
//101.09.21拿掉缺失摘要長度限制 by 2295
function checkInsertData(form,cmd) {
    if(form.item_no.value == "") {
        alert("缺失事項序號不可為空白");
        return false;
    }
    if(form.ex_content.value == "") {
        alert("檢查缺失摘要不可為空白");
        return false;
    }
    if(form.commentt.value == "") {
        alert("檢查處理意見不可為空白");
        return false;
    }
    if(form.fault_id.value == "") {
        alert("請選擇檢查意見代號");
        return false;
    }
    if(form.audit_oppinion.value == "") {
        alert("農金局處理意見不可為空白");
        return false;
    }
    if(form.act_id.value == "") {
        alert("請選擇農金局處理代號");
        return false;
    }

    // alert("form.ex_content.length = "+form.ex_content.value.length);
    if(cmd != "Update"){
       if(form.ex_content.value.length > 1000) {
        alert("檢查缺失摘要不可大於1000字");
        return false;
      }
	}
    // alert("form.commentt.length = "+form.commentt.value.length);
    if(form.commentt.value.length > 250) {
        alert("檢查處理意見不可大於250字");
        return false;
    }
    // alert("form.audit_oppinion.length = "+form.audit_oppinion.value.length);
    if(form.audit_oppinion.value.length > 250) {
        alert("農金局處理意見不可大於250字");
        return false;
    }
    // alert("form.digest.length = "+form.digest.value.length);
    if(form.digest.value.length > 500) {
        alert("函覆改善情形摘要不可大於500字");
        return false;
    }

    return true;
}


//111.06.09新增檢查報告 by 2295
function checkExReportFData(form,cmd) {
    if(form.tbank.value == "") {
        alert("總機構單位不可為空白");
        return false;
    }
    if(form.examine.value == "") {
        alert("受檢單位不可為空白");
        return false;
    }
    if(form.reportno.value == "") {
        alert("檢查報告編號不可為空白");
        return false;
    }
    
    if(form.chType.value == "") {
        alert("請選擇檢查性質");
        return false;
    }
    
    if(form.begY.value == "") {
        alert("開始年不能為空白");
        return false;
    }
    
    if(isNaN(Math.abs(form.begY.value))) {
        alert("年度一定要輸入數字");
        return false;
    }
    
    form.begDate.value = mergeDate(form.begY.value, form.begM.value, form.begD.value);
     
    return true;
}


//109.05.15 add 修改機構代碼
function updateBank_No(form,reportno){	
	//alert(this.document.forms[0].upd_bank_no.value);	
	//alert(this.document.forms[0].upd_bank_type.value);
	form.action="/pages/TC33.jsp?act=updbankno&reportno="+reportno+"&upd_bank_no="+form.upd_bank_no.value+"&upd_bank_type="+form.upd_bank_type.value;	
	form.submit();
}

function checkUpdateData(form) {
   if(!checkInsertData(form,"Update")) {
     return false;
   }
   if(form.rt_dateY.value != "") {
        form.rt_date.value = mergeDate(form.rt_dateY.value, form.rt_dateM.value, form.rt_dateD.value);
        //alert(form.rt_date.value);
        if(!fnValidDate(form.rt_date.value)) {
            alert("受檢單位來文日期不合法");
            return false;
        }
   }
   return true;
}

function isChangeSec1(form) {
    if(form.item_no.value != form.sitem_no.value) {
        form.changeSec1.value="U";
    }
    if(form.ex_content.value != form.sex_content.value) {
        form.changeSec1.value="U";
    }
    if(form.commentt.value != form.scommentt.value) {
        form.changeSec1.value="U";
    }
    if(form.fault_id.value != form.sfault_id.value) {
        form.changeSec1.value="U";
    }
    if(form.audit_oppinion.value != form.saudit_oppinion.value) {
        form.changeSec1.value="U";
    }
    if(form.act_id.value != form.sact_id.value) {
        form.changeSec1.value="U";
    }
}

function isChangeSec2(form) {
    if(form.audit_result.value != form.saudit_result.value) {
        form.changeSec2.value="U";
    }
    if(form.digest.value != form.sdigest.value) {
        form.changeSec2.value="U";
    }
    if(form.rt_date.value != form.srt_date.value) {
        form.changeSec2.value="U";
    }
    if(form.rt_docno.value != form.srt_docno.value) {
        form.changeSec2.value="U";
    }

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
    
    //$('select[@name='+S1.name+'] > option[@value='+bankid+']').attr('selected',true) ;
}

function addZero(id, num) {
    var temp = "";
    for(var i = 0; i < num; i++) {
        temp += "0";
    }
    temp = temp + id;
    end = temp.length;
    start = end - num;

    return temp.substring(start,end);
}



function mergeDate(yy, mm, dd) {
    dateY = eval(yy)+1911;
    dateM = addZero(mm, 2);
    dateD = addZero(dd, 2);
    return dateY+dateM+dateD;
}


function checkDuringDate(form) {
    if(form.begY.value == "") {
        alert("開始年不能為空白");
        return false;
    }
    if(form.endY.value == "") {
        alert("結束年不能為空白");
        return false;
    }
    if(isNaN(Math.abs(form.begY.value))) {
        alert("開始年一定要輸入數字");
        return false;
    }
    if(isNaN(Math.abs(form.endY.value))) {
        alert("結束年一定要輸入數字");
        return false;
    }
    form.begDate.value = mergeDate(form.begY.value, form.begM.value, form.begD.value);
    form.endDate.value = mergeDate(form.endY.value, form.endM.value, form.endD.value);

    if(eval(form.endDate.value) < eval(form.begDate.value)) {
        alert("開始日期不能小於結束日期");
        return false;
    }

    return true;
}

function clearAll() {
    if(confirm("是否清空你所鍵入的資料")) {

        document.all("form").reset();
    }
}

function toChineseYear(s1) {
   var fullYear="";
   if(s1.length == 8) {
       yy = eval(s1.substring(0,4))-1911;
       mm = eval(s1.substring(4,6));
       dd = eval(s1.substring(6,8));
       fullYear= yy +"年 "+mm+"月 "+dd+"日"
   }
   return fullYear;
}


function changeOption(xml, target, source, xml_bk){
    var myXML,nodeType,nodeValue, nodeName;

    target.length = 0;
    var oOption;
    oOption = document.createElement("OPTION");
	oOption.text="全部";
  	oOption.value="";
  	target.add(oOption);

  	myXML = document.all(xml_bk).XMLDocument;
    nodeType = myXML.getElementsByTagName("bankType");
	nodeValue = myXML.getElementsByTagName("bankValue");
	nodeName = myXML.getElementsByTagName("bankName");
	for(var i=0;i<nodeType.length ;i++)	{
  	    if ((nodeValue.item(i).firstChild.nodeValue == source.value))  {
  		    oOption = document.createElement("OPTION");
		    oOption.text=nodeName.item(i).firstChild.nodeValue;
  		    oOption.value=nodeValue.item(i).firstChild.nodeValue;
  		    target.add(oOption);
   	    }
    }

    myXML = document.all(xml).XMLDocument;
	nodeType = myXML.getElementsByTagName("bankType");
	nodeValue = myXML.getElementsByTagName("bankValue");
	nodeName = myXML.getElementsByTagName("bankName");

	for(var i=0;i<nodeType.length ;i++)	{

  		if ((nodeType.item(i).firstChild.nodeValue == source.value))  {
  			oOption = document.createElement("OPTION");
			oOption.text=nodeName.item(i).firstChild.nodeValue;
  			oOption.value=nodeValue.item(i).firstChild.nodeValue;
  			target.add(oOption);
    	}
    }


    if(target.length < 3 && source.value != 1) {

        myXML = document.all(xml_bk).XMLDocument;
        target.length = 0;
     	nodeType = myXML.getElementsByTagName("bankType");
	    nodeValue = myXML.getElementsByTagName("bankValue");
	    nodeName = myXML.getElementsByTagName("bankName");

	    for(var i=0;i<nodeType.length ;i++)	{
  		    if ((nodeValue.item(i).firstChild.nodeValue == source.value))  {
  			    oOption = document.createElement("OPTION");
			    oOption.text=nodeName.item(i).firstChild.nodeValue;
  			    oOption.value=nodeValue.item(i).firstChild.nodeValue;
  			    target.add(oOption);
    	    }
        }
        if(source.value == "" || source.value == "0") {
    	        oOption = document.createElement("OPTION");
			    oOption.text="全部";
  			    oOption.value="";
  			    target.add(oOption);
  	    }

    }

}

function resetOption() {
    var s1 = document.getElementById("tbank");
    var s2 = document.getElementById("examine");
    s1.length = 0;
    s2.length = 0;

    oOption = document.createElement("OPTION");
	oOption.text="全部";
  	oOption.value="";
  	s1.add(oOption);
  	oOption = document.createElement("OPTION");
	oOption.text="全部";
  	oOption.value="";
  	s2.add(oOption);
}

function message(form){
   if(form.msg.value == "success") {
       form.item_no.value = "";
       form.ex_content.value = "";
       form.commentt.value = "";
       alert("相關資料已寫入資料庫");
       return ;
   } else if(form.msg.value == "") {
       return ;
   } else {
       alert(form.msg.value);
   }
}

function fnValidDate(dateStr) {
    //alert(dateStr);
    //alert('year='+dateStr.substring(0,4));
    //alert('mm='+dateStr.substring(5,6));
    //alert('dd='+dateStr.substring(6,8));
    var  leap = 28;

    if(leapYear(parseInt(dateStr.substring(0,4))) == true)
         leap = 29;

    var mm = parseInt(dateStr.substring(5, 6))

    if(mm < 1 || mm > 12){    	
        return (false)
    }
    var monthTable = new Array(12);
    monthTable[1] = 31;
    monthTable[2] = leap;
    monthTable[3] = 31;
    monthTable[4] = 30;
    monthTable[5] = 31;
    monthTable[6] = 30;
    monthTable[7] = 31;
    monthTable[8] = 31;
    monthTable[9] = 30;
    monthTable[10] = 31;
    monthTable[11] = 30;
    monthTable[12] = 31;
    
    var dd = dateStr.substring(6,8);  

    if(dd < 1 || dd > monthTable[mm]){
        return false
    }

    return true
}

function leapYear (Year) {
        if (((Year % 4)==0) && ((Year % 100)!=0) || ((Year % 400)==0))
                return (true);
        else
                return (false);
}


function changeCity(xml, target, source, form) {
    var myXML,nodeType,nodeValue, nodeName,nodeCity;

    unit = form.bankType.value;
    if( unit == "6" || unit == "7") {
      var s2 = document.getElementById("examine");
      s2.length = 0;
      var oOption;
      oOption = document.createElement("OPTION");
	  oOption.text="全部";
  	  oOption.value="";
  	  s2.add(oOption);
      target.length = 0;
      var oOption;
      oOption = document.createElement("OPTION");
	  oOption.text="全部";
  	  oOption.value="";
  	  target.add(oOption);
      myXML = document.all(xml).XMLDocument;
      nodeType = myXML.getElementsByTagName("bankType");
      nodeCity = myXML.getElementsByTagName("bankCity");
	  nodeValue = myXML.getElementsByTagName("bankValue");
	  nodeName = myXML.getElementsByTagName("bankName");

	  for(var i=0;i<nodeType.length ;i++)	{
  	    if ((nodeCity.item(i).firstChild.nodeValue == source.value) &&
  	        (nodeType.item(i).firstChild.nodeValue == unit) )  {
  		    oOption = document.createElement("OPTION");
		    oOption.text=nodeName.item(i).firstChild.nodeValue;
  		    oOption.value=nodeValue.item(i).firstChild.nodeValue;
  		    target.add(oOption);
   	    }
      }
    } else {
      setSelect(source, "")
    }
}


function changeFault(source, target) {
  var myXML,nodeType,nodeValue, nodeName;

  target.length = 0;
  var oOption;
  oOption = document.createElement("OPTION");
  oOption.text="全部";
  oOption.value="";
  target.add(oOption);

  myXML = document.all("FaultXML").XMLDocument;
  nodeType = myXML.getElementsByTagName("faultType");
  nodeValue = myXML.getElementsByTagName("faultID");
  nodeName = myXML.getElementsByTagName("faultName");

  for(var i=0;i<nodeType.length ;i++)	{
  	if (nodeType.item(i).firstChild.nodeValue == source.value )  {
  	  oOption = document.createElement("OPTION");
	  oOption.text=nodeName.item(i).firstChild.nodeValue;
  	  oOption.value=nodeValue.item(i).firstChild.nodeValue;
  	  target.add(oOption);
   	}
  }
}
function checkCity() {
  if(document.getElementById("bankType").value == "6" ||
     document.getElementById("bankType").value == "7" ) {
    document.getElementById("cityType").disabled = false;
  } else {
    document.getElementById("cityType").disabled = true;
  }
}

function getRtData(form) {
  if(form.frt_docno.value == "") {
    alert("無最近一筆資料，無從抄錄請自行鍵入");
    return ;
  } else {
  	if(form.rt_docno.value == "" || form.rt_dateY.value == "") {
        form.rt_docno.value = form.frt_docno.value;
        form.rt_dateY.value = eval(form.frt_dateY.value)-1911;
        setSelect(form.rt_dateM,eval(form.frt_dateM.value));
        setSelect(form.rt_dateD,form.frt_dateD.value);
    } else {
        if(confirm("(受檢單位來文文號及日期) 欄巳有任一資料，你確定要執行抄錄功能(Y/N)?")) {
        form.rt_docno.value = form.frt_docno.value;
        form.rt_dateY.value = eval(form.frt_dateY.value)-1911;
        setSelect(form.rt_dateM,eval(form.frt_dateM.value));
        setSelect(form.rt_dateD,form.frt_dateD.value);
        } else {
          return ;
        }
    }

  }

}
//==================================================
//組縣市別============
function changeCity(xml,year) {
	var form = document.forms[0];
	var citySeld = form.cityType.value; //已選擇的
	var myXML,nodeValue, nodeName,nodeYear;
	//1.取得畫面年分 
	var begY = year.value=='' ? 0 : eval(year.value) ;
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
}
//組金融機構畫面
function changeTbank(xml,year) {
	var form = document.forms[0];
	var myXML,nodeValue, nodeName,nodeYear,nodeType,nodeCity;
	//1.取得畫面年分 
	var begY = year.value=='' ? 0 : eval(year.value) ;
	Myear = '100' ;//預設年分100年
	if(begY<=99) {
		Myear = '99' ;
	}
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
}
function changeExamine(xml,xml_bk,year) {
	var form = document.forms[0];
	var myXML,nodeValue, nodeName,nodeYear,nodeType,nodeCity;
	var begY = year.value=='' ? 0 : eval(year.value) ;
	Myear = '100' ;//預設年分100年
	if(begY<=99) {
		Myear = '99' ;
	}
	tbank = form.tbank.value ; 
	myXML = document.all(xml_bk).XMLDocument;
	nodeValue = myXML.getElementsByTagName("bankValue");
	nodeName = myXML.getElementsByTagName("bankName");
	nodeYear = myXML.getElementsByTagName("m_year");
	nodeType = myXML.getElementsByTagName("bankType") ;
	nodeCity = myXML.getElementsByTagName("bankCity") ;
	
	var target = document.getElementById("examine");
	target.length = 0;
	
	var oOption = document.createElement("OPTION");
	oOption.text="全部";
	oOption.value="";
	target.add(oOption);
	
	for(var i=0;i<nodeName.length ;i++)	{
		if((nodeValue.item(i).firstChild.nodeValue== tbank)&& nodeYear.item(i).firstChild.nodeValue==Myear) {
			oOption = document.createElement("OPTION");
       	 	oOption.text=nodeName.item(i).firstChild.nodeValue;
	        oOption.value=nodeValue.item(i).firstChild.nodeValue;  
	        target.add(oOption);
		}
	}
	myXML = document.all(xml).XMLDocument;
	nodeType = myXML.getElementsByTagName("bankType");
	nodeValue = myXML.getElementsByTagName("bankValue");
	nodeName = myXML.getElementsByTagName("bankName");
	for(var i=0;i<nodeName.length ;i++)	{
		if((nodeType.item(i).firstChild.nodeValue== tbank)) {
			oOption = document.createElement("OPTION");
       	 	oOption.text=nodeName.item(i).firstChild.nodeValue;
	        oOption.value=nodeValue.item(i).firstChild.nodeValue;  
	        target.add(oOption);
		}
	}
}
//受處年分改變==========
function chnageYear(id) {
	//1.修改縣市別
	changeCity("CityXML",id) ;
	//2.修改金融機構
	changeTbank("TBankXML",id);
	
	changeExamine("BankNoXML","TBankXML",id);
}
﻿function doSubmit(form,cmd,id){

    if(cmd == "Qry") {
        form.act.value = "Qry";
        if(mergeDate(form)) {
            if(checkDate(form.begDate.value, form.endDate.value)) {
                form.submit();
            }
        }
    }else if(cmd == "New") {
        
        form.act.value = "New";
        form.submit();
    }else if(cmd == "Edit") {
        form.exam_id.value = id;
        form.act.value = "Edit";
        form.submit();
    }else if(cmd == "Insert") {
        if(form.exam_id.value == "") {
            alert("檢查報告編號不可為空白");
            return ; 
        }
        
        if(!checkExeDate(form)) {
            return ;
        }
        
        if(confirm("是否新增資料?")) {
            form.act.value = "Insert";
            form.submit();
        }
    }else if(cmd == "Update") {
        if(!checkExeDate(form)) {
            return ;
        }
        if(confirm("是否修改資料?")) {
            form.act.value = "Update";
            form.submit();
        }
    }else if(cmd == "Delete") {
        if(confirm("是否刪除資料?")) {
            form.act.value = "Delete";
            form.submit();
        }
    }
    return ;
}

function checkExeDate(form) {
    if(form.originunt_id.value == "") {
        alert("檢查單位不可為空白");
        return false;
    }
    if(form.bankType.value == "0") {
        alert("金融機構類別不可為全部類別");
        return false;
    }
    if(form.examine.value == "") {
        alert("受檢單位不可為全部");
        return false;
    }
    if(form.base_dateY.value == "") {
        alert("檢查基準日年不可為空白");
        return false;
    }
    if(isNaN(Math.abs(form.base_dateY.value))) {
        alert("檢查基準日年應為數字");
        return false;
    }
    form.base_date.value = (eval(form.base_dateY.value)+1911) + addZero(form.base_dateM.value,2) + addZero(form.base_dateD.value,2);
    
    if(!fnValidDate(form.base_date.value)) {
        alert("檢查基準日不合法");
        return false;
    }
        
    if(form.ware_dateY1.value == "") {
        alert("檢查期間起年不可為空白");
        return false;
    }
    if(isNaN(Math.abs(form.ware_dateY1.value))) {
        alert("檢查期間起年應為數字");
        return false;
    }
    form.ware_date1.value = (eval(form.ware_dateY1.value)+1911) + addZero(form.ware_dateM1.value,2) + addZero(form.ware_dateD1.value,2);
    
    if(!fnValidDate(form.ware_date1.value)) {
        alert("檢查期間起不合法");
        return false;
    }
    
    if(form.ware_dateY2.value == "") {
        alert("檢查期間迄年不可為空白");
        return false;
    }
    if(isNaN(Math.abs(form.ware_dateY2.value))) {
        alert("檢查期間迄年應為數字");
        return false;
    }
    form.ware_date2.value = (eval(form.ware_dateY2.value)+1911) + addZero(form.ware_dateM2.value,2) + addZero(form.ware_dateD2.value,2);
    
    if(!fnValidDate(form.ware_date2.value)) {
        alert("檢查期間迄不合法");
        return false;
    }
    
    
    now = new Date();
    date = ""+now.getFullYear()+addZero((now.getMonth()+1),2)+addZero(now.getDate(),2);

    if(eval(form.base_date.value) > eval(date)) {
        alert("檢查基準日不可大於"+(now.getFullYear() - 1911)+"年"+(now.getMonth()+1)+"月"+now.getDate()+"日");
        return false;
    }
    
   // if(eval(form.ware_date.value) > eval(date)) {
   //     alert("檢查報告日期不可大於"+(now.getFullYear() - 1911)+"年"+(now.getMonth()+1)+"月"+now.getDate()+"日");
   //     return false;
   // }
    
    if(eval(form.ware_date1.value) > eval(form.ware_date2.value)) {
        alert("檢查期間起不可大於檢查期間迄");
        return false;
    }
    
    if (form.come_dateY.value != "") {
      if(isNaN(Math.abs(form.come_dateY.value))) {
        alert("來文日期應為數字");
        return false;
      }
      form.come_date.value = (eval(form.come_dateY.value)+1911) + addZero(form.come_dateM.value,2) + addZero(form.come_dateD.value,2);
    
      if(!fnValidDate(form.come_date.value)) {
        alert("來文日期不合法");
        return false;
      }
    }
    
    
    
    return true;
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

function setDateM(form) {
    date = new Date();
    new_month = date.getMonth()+1;
    
    if(form.begDate.value == "") {
        setSelect(form.begM,new_month);
    } else {
        setSelect(form.begM,eval(form.begDate.value.substring(3,5)));
    }
    if(form.endDate.value == "") {
        setSelect(form.endM,new_month);
    } else {
        setSelect(form.endM,eval(form.endDate.value.substring(3,5)));
    }
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

function mergeDate(form) {
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
    begY = eval(form.begY.value)+1911;
    begM = addZero(form.begM.value, 2);
    begD = addZero(form.begD.value, 2);
    form.begDate.value = begY+begM+begD;
    //alert(form.begDate.value);
    
    endY = eval(form.endY.value)+1911;
    endM = addZero(form.endM.value, 2);
    endD = addZero(form.endD.value, 2);
    form.endDate.value = endY+endM+endD;
    // alert(form.endDate.value);
    
    return true;
}

function checkDate(beg, end) {
    if(eval(end) < eval(beg)) {
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

function fnValidDate(dateStr) {
    
    var  leap = 28;
    
    if(leapYear(parseInt(dateStr.substring(0,4))) == true)
         leap = 29;
    
    var mm = parseInt(dateStr.substring(4, 6))
    
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

    var dd = parseInt(dateStr.substring(6,8))

    

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


function checkCity() { 
  if(document.getElementById("bankType").value == "6" ||
     document.getElementById("bankType").value == "7" ) {
    document.getElementById("cityType").disabled = false;
  } else {
    document.getElementById("cityType").disabled = true;
  }
}

//==================================================
//組縣市別============
function changeCity(xml,year) {
	var form = document.forms[0];
	var myXML,nodeValue, nodeName,nodeYear;
	var citySeld = form.cityType.value; //已選擇的
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
	setSelect(form.cityType,citySeld);
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

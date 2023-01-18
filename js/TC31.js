//96.11.14 fix 日期檢查錯誤 by 2295
function doSubmit(form,cmd,id, report){
    if(cmd == "Qry") {
        form.act.value = "Qry";
        if(checkDuringDate(form)) {
            mergeLimitDate(form)
            if(checkDate(form.begDate.value, form.endDate.value)) {
                form.submit();
            }
        }
    }else if(cmd == "New") {
        form.act.value = "New";
        form.submit();
    }else if(cmd == "Edit") {
        form.sn_docno.value = id;
        form.reportno.value = report; 
        form.act.value = "Edit";
        form.submit();
    }else if(cmd == "Insert") {
        if(!checkInsertData(form)) {
            return ;
        }
        if(confirm("是否新增資料?")) {
            form.act.value = "Insert";
            form.submit();
        }
    }else if(cmd == "Update") {
        if(!checkInsertData(form)) {
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

function checkInsertData(form) {
    if(form.reportno.value == "") {
        alert("檢查報告編號不可為空白");
        return false; 
    }
    if(form.sn_docno.value == "") {
        alert("發文文號不可為空白");
        return false;
    }
    if(form.sn_dateY.value == "") {
        alert("發文日期不可為空白"); 
        return false;
    }
    if(form.doctype.value == "") {
        alert("公文類別不可為空白"); 
        return false;
    }
    
    form.sn_date.value = mergeDate(form.sn_dateY.value, form.sn_dateM.value, form.sn_dateD.value);    
  
    if(!fnValidDate(form.sn_date.value)) {
        alert("發文日期不合法"); 
        return false;
    }
    
    d = new Date();
    dateString  = mergeDate(d.getFullYear()-1911, d.getMonth()+1, d.getDate());
    
    if(eval(form.sn_date.value) > parseInt(dateString)) {
           alert("發文日期不可大於現在日期");
           return false;
        }
    
    
    if(!mergeLimitDate(form)) {
        return false;
    }
    
    if(form.limitdate.value != "" ) {
        if(eval(form.limitdate.value) < eval(form.sn_date.value)) {
           alert("限期函報日不可小於發文日期");
           return false;
        }
    }
    
    if(form.doctype.value == "2") {
        if(form.doctype_cnt.value == "") {
            alert("缺失改善函之次數不可為零");
            return false;
        }
    }
    
    return true;
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


function mergeLimitDate(form) {
    if(form.limitY.value != "") {
        if(form.limitM.value == "") {
            alert("限期函報日, 月不可為空白");
            return false;
        }
        if(form.limitD.value == "") {
            alert("限期函報日, 日不可為空白");
            return false;
        } 
        form.limitdate.value = mergeDate(form.limitY.value, form.limitM.value, form.limitD.value);
        if(!fnValidDate(form.limitdate.value)) {
        alert("限期函報日期不合法"); 
        return false;
    }
    }
    return true;
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
/*

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
*/
function subOption() {
   if(document.all) {    
       document.all("limitY").disabled= true;
       document.all("limitM").disabled= true;
       document.all("limitD").disabled= true;
       document.all("doctype_cnt").disabled= true;
       if(document.all("doctype").value == "1") {
           document.all("limitY").value = "";
           document.all("limitM").value = "";
           document.all("limitD").value = "";
           document.all("doctype_cnt").value = "";   
           document.all("limitY").disabled= true;
           document.all("limitM").disabled= true;
           document.all("limitD").disabled= true;
           document.all("doctype_cnt").disabled= false;
       } else if(document.all("doctype").value == "2") {
           document.all("limitY").value = "";
           document.all("limitM").value = "";
           document.all("limitD").value = "";
           document.all("doctype_cnt").value = "";   
           document.all("limitY").disabled= false;
           document.all("limitM").disabled= false;
           document.all("limitD").disabled= false;
           document.all("doctype_cnt").disabled= false;
       } else {
           document.all("limitY").value = "";
           document.all("limitM").value = "";
           document.all("limitD").value = "";
           document.all("doctype_cnt").value = "";   
           document.all("limitY").disabled= true;
           document.all("limitM").disabled= true;
           document.all("limitD").disabled= true;
           document.all("doctype_cnt").disabled= true;
       }
   }
}
//96.11.14 fix 日期檢查錯誤 
function fnValidDate(dateStr) {    
    var  leap = 28;    
    if(leapYear(parseInt(dateStr.substring(0,4))) == true)
         leap = 29;
    
    var mm = parseInt(dateStr.substring(4,6),10);    
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
    
    var dd = parseInt(dateStr.substring(6,8),10);    
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
/*
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
*/
function calSendDate(form) {
  if( form.sn_dateY.value == "" ||
      form.sn_dateM.value == "" ||
      form.sn_dateD.value == ""  ) {
    alert("請先填入發文日期");
    return ;
  }
  
  if(isNaN(Math.abs(form.sn_dateY.value))) {
        alert("發文日期年一定要輸入數字");
        return false;
    }
    if(form.doctype.value == "" ||
       form.doctype.value == "3") {
      return ;
    }
    
    
    sn_date = new Date(eval(form.sn_dateY.value)+1911, form.sn_dateM.value, form.sn_dateD.value);
    
    
    
    var monthMs = 30*24*60*60*1000;
    if(form.doctype.value == "1" ) {
      monthMs *= 3;
      
    }
    if(form.doctype.value == "2" ) {
      monthMs *= 2;
      
    }
    
    monthMs += sn_date.getTime();
    limitDate = new Date(monthMs); 
    form.limitY.value = limitDate.getFullYear() - 1911;
    setSelect(form.limitM,""+limitDate.getMonth());
    setSelect(form.limitD, ""+limitDate.getDate());
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
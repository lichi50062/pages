function doSubmit(form,cmd,id){
    // alert(cmd);
    if(cmd == "Qry") {
        form.act.value = "Qry";
        if(mergeDate(form)) {
            if(checkDate(form.begDate.value, form.endDate.value)) {
                form.submit();
            }
        }
    }else if(cmd == "New") {
        if(form.disp_id.value == "") {
            alert("派差通知單編號不可為空白");
            return ; 
        }
        form.act.value = "New";
        form.submit();
    }else if(cmd == "Edit") {
        form.disp_id.value = id;
        form.act.value = "Edit";
        form.submit();
    }else if(cmd == "Insert") {
        
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
    
    if(form.go_dateY.value == "") {
        alert("去程日期年不可為空白");
        return false;
    }
    if(isNaN(Math.abs(form.go_dateY.value))) {
        alert("去程日期年應為數字");
        return false;
    }
    form.go_date.value = (eval(form.go_dateY.value)+1911) + addZero(form.go_dateM.value,2) + addZero(form.go_dateD.value,2);
    
    if(!fnValidDate(form.go_date.value)) {
        alert("去程日期不合法");
        return false;
    }
    
    if(form.ware_dateY.value == "") {
        alert("查庫日期年不可為空白");
        return false;
    }
    if(isNaN(Math.abs(form.ware_dateY.value))) {
        alert("查庫日期年應為數字");
        return false;
    }
    form.ware_date.value = (eval(form.ware_dateY.value)+1911) + addZero(form.ware_dateM.value,2) + addZero(form.ware_dateD.value,2);
    
    if(!fnValidDate(form.ware_date.value)) {
        alert("查庫日期不合法");
        return false;
    }
    
    if(form.st_dateY.value == "") {
        alert("開始檢查日年不可為空白");
        return false;
    }
    if(isNaN(Math.abs(form.st_dateY.value))) {
        alert("開始檢查日年應為數字");
        return false;
    }
    form.st_date.value = (eval(form.st_dateY.value)+1911) + addZero(form.st_dateM.value,2) + addZero(form.st_dateD.value,2);
    
    if(!fnValidDate(form.st_date.value)) {
        alert("開始檢查日不合法");
        return false;
    }
    
    if(form.en_dateY.value == "") {
        alert("完成檢查日年不可為空白");
        return false;
    }
    if(isNaN(Math.abs(form.en_dateY.value))) {
        alert("完成檢查日年應為數字");
        return false;
    }
    form.en_date.value = (eval(form.en_dateY.value)+1911) + addZero(form.en_dateM.value,2) + addZero(form.en_dateD.value,2);
    
    if(!fnValidDate(form.en_date.value)) {
        alert("完成檢查日不合法");
        return false;
    }
    
    if(form.bk_dateY.value == "") {
        alert("回程日期年不可為空白");
        return false;
    }
    if(isNaN(Math.abs(form.bk_dateY.value))) {
        alert("回程日期年應為數字");
        return false;
    }
    form.bk_date.value = (eval(form.bk_dateY.value)+1911) + addZero(form.bk_dateM.value,2) + addZero(form.bk_dateD.value,2);
    
    if(!fnValidDate(form.bk_date.value)) {
        alert("回程日期不合法");
        return false;
    }
    
    if(form.report_dateY.value == "") {
        alert("提出報告日期年不可為空白");
        return false;
    }
    if(isNaN(Math.abs(form.report_dateY.value))) {
        alert("提出報告日期年應為數字");
        return false;
    }
    form.report_date.value = (eval(form.report_dateY.value)+1911) + addZero(form.report_dateM.value,2) + addZero(form.report_dateD.value,2);
    
    if(!fnValidDate(form.report_date.value)) {
        alert("提出報告日期不合法");
        return false;
    }
    
    if(eval(form.ware_date.value) < eval(form.go_date.value)) {
        alert("查庫日期一定要大於等於去程日期");
        return false;
    }
    
    if(eval(form.st_date.value) < eval(form.go_date.value)) {
        alert("開始檢查日期一定要大於等於去程日期");
        return false;
    }
    
    if(eval(form.bk_date.value) < eval(form.en_date.value)) {
        alert("回程日期一定要大於等於完成檢查日期");
        return false;
    }
    
    if(eval(form.report_date.value) < eval(form.bk_date.value)) {
        alert("提出報告日期一定要大於等於回程日期"+eval(form.report_date.value) + " < " +eval(form.bk_date.value));
        return false;
    }
    
    if(eval(form.en_date.value) < eval(form.st_date.value)) {
        alert("完成檢查日期一定要大於等於開始檢查日期");
        return false;
    }
    return true;
}

function calWorkDay(form) {
    if(checkExeDate(form)) {
        stDate = new Date(eval(form.st_dateY.value), eval(form.st_dateM.value), eval(form.st_dateD.value));
        enDate = new Date(eval(form.en_dateY.value), eval(form.en_dateM.value), eval(form.en_dateD.value));
        
        n = (enDate.getTime() - stDate.getTime()) / (24*60*60*1000);
        // alert(n);
        
        if(eval(form.ware_date.value) < eval(form.st_date.value)) {
            n = n + 1;
        }
        
        form.workday.value = n;
        form.workmdays.value = n *  (document.all("inspect").rows.length - 1);
    }
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
    // alert(temp);
    // alert(temp.length);
    end = temp.length;
    start = end - num;

    // alert(temp.substring(start,end));
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

function addInspector(inspectName, expertName) {

      t1 = document.all("inspect").insertRow();
      t1.bgColor = "#EBF4E1";
      h = "<input type='text' name='inspector_name' value='"+inspectName+"'  size='30' readonly >"
      t1.insertCell().insertAdjacentHTML("AfterBegin",h);
      h = "<input type='text' name='expert_name' id='expert_name' value='" + expertName + "' size='50'  readonly >"
      t1.insertCell().insertAdjacentHTML("AfterBegin",h);

}

function addItem(form, inspectName, expertName) {
   rows = document.all("inspect").rows.length;
   if(document.all("inspector_name")) {
      
       if(document.all("inspector_name").length) {       
           for(var i = 0; i < rows-1; i++) {
              if(document.all("inspector_name")[i].value == inspectName) {
                 document.all("expert_name")[i].value += ";" + expertName ;
                 return ;
               }  
           }  
       }else {
           if(document.all("inspector_name").value == inspectName) {
                  document.all("expert_name").value += ";" + expertName;
                  return ;
           }
       }
   }
   addInspector(inspectName, expertName);
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
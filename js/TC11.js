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
        form.act.value = "New";
        form.submit();
    }else if(cmd == "Edit") {
        form.disp_id.value = id;
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
        if(!checkUpdateData(form)) {
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

function checkUpdateData(form) {
    return checkInsertData(form);
}


function checkInsertData(form) {
    if(form.bankType.value == "0") {
        alert("金融機構類別不可為全部類別");
        return false;
    }
    if(form.examine.value == "") {
        alert("受檢單位不可為全部");
        return false;
    }
    if(form.property.value == "") {
        alert("檢查性質不可為空白");
        return false;
    }

    if(form.property.value=="2" && form.prj_item.value == "") {
        alert("專案性質為專案時, 專案檢查項目不可為空白");
        return false;
    }
    if(form.property.value=="1" && form.prj_item.value != "") {
        alert("專案性質為一般時, 專案檢查項目不可輸入");
        return false;
    }
    
    if(!isBothDisp(form)) {
       alert("檢查證(函)編號及證(函)須同時為空白或有資料");
       return false;
    }
    
    
    if(form.dateY.value == "") {
        alert("核派日期不可為空白");
        return false;
    }
    if(isNaN(Math.abs(form.dateY.value))) {
        alert("核派日期應為數字");
        return false;
    }
    form.appr_date.value = (eval(form.dateY.value)+1911) + addZero(form.dateM.value,2) + addZero(form.dateD.value,2);
    
    if(!fnValidDate(form.appr_date.value)) {
        alert("日期不合法");
        return false;
    }
    
    return true;
}

function isBothDisp(form) {
     if(form.exam_id.value == "" && form.exam_div.value == "") {
        return true;
     }
     if(form.exam_id.value != "" && form.exam_div.value != "") {
        return true;
     }
     return false;
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



function changeOption1(form){
    
    var myXML,nodeID,nodeExpert, nodeName;

    myXML = document.all("ExpertXML").XMLDocument;
    form.expert.length = 0;
	nodeID = myXML.getElementsByTagName("ID");
	nodeExpert = myXML.getElementsByTagName("Expert");
	nodeName = myXML.getElementsByTagName("Name");
	var oOption;
	oOption = document.createElement("OPTION");
	oOption.text="        ";
  	oOption.value="";
  	form.expert.add(oOption);
	for(var i=0;i<nodeID.length ;i++)	{
  		if (nodeID.item(i).firstChild.nodeValue == form.inspector.value )  {
  			oOption = document.createElement("OPTION");
			oOption.text=nodeName.item(i).firstChild.nodeValue;
  			oOption.value=nodeExpert.item(i).firstChild.nodeValue;
  			form.expert.add(oOption);
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

function getOptionIndex(S1, bankid) {
    if(S1 == null)
    	return;
    for(i=0;i<S1.length;i++) {
      	if(S1.options[i].value==bankid) {
        	S1.options[i].selected=true;
        	return i;
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


function delInspector(index) {
    if(document.all("inspector_id").length) {
        for(var i=0; i < document.all("inspector_id").length; i++) {
            if( document.all("inspector_id")[i].value == index ) {
                document.all("inspect").deleteRow(i+1);
            }
         }
    } else {
       document.all("inspect").deleteRow(1);
    }    
}


function addInspector(inspectId, inspectName, expertId, expertName) {

      t1 = document.all("inspect").insertRow();
      t1.bgColor = "#EBF4E1";
      h = "<a href=\"javascript:delInspector('"+inspectId+"');\"onMouseOut=\"MM_swapImgRestore()\" onMouseOver=\"MM_swapImage('Image333','','images/bt_deleteb.gif',1)\"><img src=\"images/bt_delete.gif\" name=\"Image333\"  border=\"0\" id=\"Image333\"></a>";
      // h =  "<input type='button' value='刪除' onClick=\"delInspector('"+inspectId+"')\">";
      t1.insertCell().insertAdjacentHTML("AfterBegin",h);

      h =  "<input type='hidden' name='inspector_id' value='"+inspectId+"'><input type='text' name='inspector_name' value='"+inspectName+"'  size='30' readonly >";
      t1.insertCell().insertAdjacentHTML("AfterBegin",h);
    
      h =  "<input type='hidden' name='expert_id' id='expert_id' value='" + expertId + "'><input type='text' name='expert_name' id='expert_name' value='" + expertName + "' size='50'  readonly >";
      t1.insertCell().insertAdjacentHTML("AfterBegin",h);
}

function addItem(form,  tinspectId, tinspectName, texpertId, texpertName) {
   rows = document.all("inspect").rows.length;
   // alert("Rows: "+rows);
   inspectId = "";
     inspectName = "";
     expertId = "";
     expertName = "";
 
   if(tinspectId != "") {
     inspectId = tinspectId;
     inspectName = tinspectName;
     expertId = texpertId;
     expertName = texpertName;
     
   } else {
     inspectId = form.inspector.value;
     inspectName = form.inspector.options[getOptionIndex(form.inspector, form.inspector.value)].text;
     expertId = form.expert.value;
     expertName = form.expert.options[getOptionIndex(form.expert, form.expert.value)].text;
    
     if(inspectId == "" || inspectName == "") {
       alert("請選擇檢查人員");
       return;
     }
   
     if(expertId == "" || expertName == "" ) {
       alert("主要專長不可為空白");
       return;
     }
   }
   
   if(document.all("inspector_id")) {
      
       if(document.all("inspector_id").length) {
         
          
           for(var i = 0; i < rows-1; i++) {
               if(expertId == "0000") {
                 var cmp = document.all("expert_id")[i].value.split(";") ;
                 for(var k=0; k < cmp.length; k++) {
                   if(cmp[k] == expertId  ) {
                       alert("領隊已在名單,請選擇其它專長");
                       return ; 
                   }
                 }
               } 
               var tmp = document.all("expert_id")[i].value.split(";");
               for(var j = 0; j < tmp.length; j++) {
                 if(tmp[j] == expertId && document.all("inspector_id")[i].value == inspectId ) {
                   alert("此專長已存在,請選擇其它專長");
                   return ;
                 }
               }
               
              if(document.all("inspector_id")[i].value == inspectId) {
                  document.all("expert_id")[i].value += ";" + expertId;
                  document.all("expert_name")[i].value += ";" + expertName;
                  return ;
               }
                
              
           }  
       }else {
           if(expertId == "0000") {
             var cmp = document.all("expert_id").value.split(";") ;
             for(var k=0; k < cmp.length; k++) {
               if(cmp[k] == expertId) {
                 alert("領隊已在名單,請選擇其它專長");
                 return ; 
               }
             }
           }
           
           var tmp = document.all("expert_id").value.split(";");
               for(var j = 0; j < tmp.length; j++) {
                 if(tmp[j] == expertId && document.all("inspector_id").value == inspectId ) {
                   alert("此專長已存在,請選擇其它專長");
                   return ;
                 }
               }  
           if(document.all("inspector_id").value == inspectId) {
                 document.all("expert_id").value += ";" + expertId;
                  document.all("expert_name").value += ";" + expertName;
                  return ;
           }
       }
   }
   
   addInspector(inspectId, inspectName, expertId, expertName);

}

function clearAll() {
    if(confirm("是否清空你所鍵入的資料")) {
        rows = document.all("inspect").rows.length -1;
        for(var i=rows; i > 0; i--) {
            document.all("inspect").deleteRow(i);
        }
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
    var s3 = document.getElementById("cityType");
    
    s3.value = "";
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

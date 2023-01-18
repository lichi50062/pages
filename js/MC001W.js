//99.05.13 fix 縣市合併調整 by 2808
function doSubmit(form,cnd,tbank,violate_date){
	var flg = false;
	if(cnd=='add' || cnd =='modify' || cnd =='delete'){
		var action = '';
		if(cnd =='add'){
			if(!checkData(form)) return;	
			if(AskInsert_Permission()){
				action = 'Insert';
				flg = true;
			}
		}
	    if(cnd =='modify'){
	    	if(!checkData(form)) return;
	    	if(AskEdit_Permission()){
		    	action = 'Update';
		    	flg = true;
	    	}
	    }
	   if(cnd =='delete'){
		   if(AskDelete_Permission()){
			   action = 'Delete';
			   flg = true;
		   }
	   }
	   if(flg){
		   var param = "&tbank="+form.tbank.value+"&bankType="+form.bankType.value+"&violate_Date="+form.violate_Date.value
						+"&lawSuit_Date="+form.lawSuit_Date.value+"&gov_Date="+form.gov_Date.value+"&reply_Date="+form.reply_Date.value
						+"&lawSuit_DecDate="+form.lawSuit_DecDate.value+"&lawSuit_Item="+form.lawSuit_Item.value+"&lawSuit_Reason="+form.lawSuit_Reason.value
						+"&lawSuit_Result="+form.lawSuit_Result.value+"&isSue="+form.isSue.value+"&violate_Type="+form.violate_Type.value
						+"&title="+form.title.value+"&content="+form.content.value+"&law_Content="+form.law_Content.value
						+"&preTbank="+form.preTbank.value+"&preViolate_Date="+form.preViolate_Date.value+"&append_file="+form.reply_doc.value;
		   form.action="/pages/MC001W.jsp?act="+action+param;
		   form.submit();
	   }
	}else if(cnd == "Qry") {
        if(checkDuringDate(form)) {
            form.act.value = "Qry";
            form.submit();
        }
	}else if(cnd =="Clear"){
        if(confirm("是否要刪除已上傳的原始附件檔案(Y/N)?")){
        	form.action="/pages/MC001W.jsp?act=Clear&bankTypee="+form.bankType.value+"&bank_no="+form.preTbank.value+"&violate_date="+form.preViolate_Date.value+"&begY="+form.begY.value+"&append_file="+form.reply_doc.value;
        	form.submit();
        }else return;
        
	}else if(cnd =="Open"){  				   		
		form.action="/pages/DownLoadLink.jsp?directory=rptDir_MC001W&append_file="+form.reply_doc.value;
		form.submit();         	  	  	
   }else return ;
}


function checkData(form) {
	form.violate_Date.value='';
	form.lawSuit_Date.value='';
	form.gov_Date.value='';
	form.reply_Date.value='';
	form.lawSuit_DecDate.value='';
	form.violate_Type.value='';
	if(form.bankType.value==''){
		alert("請選擇金融機構類別");
		return false;
	}
	if(form.begY.value != "") {
        form.violate_Date.value = mergeDate(form.begY.value, form.begM.value, form.begD.value);
        if(!fnValidDate(form.violate_Date.value)) {
            alert("受處分日期不合法");
            return false;
        }
	}
	if(form.violate_Date.value==''){
		alert("請輸入受處分日期");
        return false;
	}
	if(form.lawSuitY.value != "") {
        form.lawSuit_Date.value = mergeDate(form.lawSuitY.value, form.lawSuitM.value, form.lawSuitD.value);
        if(!fnValidDate(form.lawSuit_Date.value)) {
            alert("訴願日期不合法");
            return false;
        }
	}
	if(form.govY.value != "") {
        form.gov_Date.value = mergeDate(form.govY.value, form.govM.value, form.govD.value);
        if(!fnValidDate(form.gov_Date.value)) {
            alert("移送訴願管轄機關日期不合法");
            return false;
        }
	}
	if(form.replyY.value != "") {
        form.reply_Date.value = mergeDate(form.replyY.value, form.replyM.value, form.replyD.value);
        if(!fnValidDate(form.reply_Date.value)) {
            alert("檢卷答辯日期不合法");
            return false;
        }
	}
	if(form.lawSuit_DecY.value != "") {
        form.lawSuit_DecDate.value = mergeDate(form.lawSuit_DecY.value, form.lawSuit_DecM.value, form.lawSuit_DecD.value);
        if(!fnValidDate(form.lawSuit_DecDate.value)) {
            alert("訴願決定日期不合法");
            return false;
        }
	}
	
	var violate_type = '';
	for(var i=0;i<6;i++){	
    	if(form.violate_type[i].checked) {	
    		violate_type += form.violate_type[i].value+":";
    	}
    }
	form.violate_Type.value = violate_type;
	if(form.violate_Type.value==''){
		alert("請選擇處分方式");
        return false;
	}
	for(var i=0; i<form.lawsuit_result.length; i++){       
		if (form.lawsuit_result[i].checked){         
			form.lawSuit_Result.value = form.lawsuit_result[i].value;
			break;
		}
	} 
	for(var i=0; i<form.issue.length; i++){       
		if (form.issue[i].checked){         
			form.isSue.value = form.issue[i].value;
			break;
		}
	} 
	return true;
}

//97.07.09 fix 結束日期.可不輸入 by 2295
function AskDelete_Permission() {
  if(confirm("確定要刪除此筆資料嗎？"))
    return true;
  else
    return false;
}

function AskInsert_Permission() {
  if(confirm("確定要新增此筆資料嗎？")){
	 if(''==form.tbank.value) {
		 alert('請選擇受處分機構!') ;
		 form.tbank.focus() ;
		 return false ;
	 }else {
		 return true;
	 }
  }else{
    return false;
  }
}
function AskEdit_Permission() {
  if(confirm("確定要修改此筆資料嗎？"))
    return true;
  else
    return false;
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



function mergeDate(yy, mm, dd) {
    dateY = eval(yy)+1911;
    dateM = addZero(mm, 2);
    dateD = addZero(dd, 2);
    return dateY+'/'+dateM+'/'+dateD;
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
    form.begDate.value = '' + (parseInt(form.begY.value)+1911) + form.begM.value + form.begD.value;
    form.endDate.value = '' + (parseInt(form.endY.value)+1911) + form.endM.value + form.endD.value;;
    
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

//97.08.14 fix 修正日期取得格式 by 2295
function fnValidDate(dateStr) {

    var leap = 28;
    var tmpStr = dateStr.substring(5,dateStr.length);
    //alert(tmpStr);   
    //alert('年='+dateStr.substring(0,4));
    //alert('月='+tmpStr.substring(0, tmpStr.indexOf("/")));
    if(leapYear(parseInt(dateStr.substring(0,4))) == true)
        leap = 29;
    var tmp = parseInt(tmpStr.substring(0, tmpStr.indexOf("/")))
    if(tmpStr.substring(0, tmpStr.indexOf("/")) == '08')
        tmp = 8;
    if(tmpStr.substring(0, tmpStr.indexOf("/")) == '09')
        tmp = 9
    if(tmp < 1 || tmp > 12){
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

    tmpStr = tmpStr.substring(tmpStr.indexOf("/")+1,tmpStr.length);
    //alert('日='+tmpStr);
    var dtmp = parseInt(tmpStr)

    if(tmpStr == '08')
        dtmp = 8;
    if(tmpStr == '09')
        dtmp = 9

    if(dtmp < 1 || dtmp > monthTable[tmp]){
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
/*
function changeCity(xml, target, source, form) {
    var myXML,nodeType,nodeValue, nodeName,nodeCity;

    unit = form.bankType.value;
    if( unit == "6" || unit == "7") {
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
//==================================================
///組縣市別============
function changeCity(xml) {
	var myXML,nodeValue, nodeName,nodeYear;
	var citySeld = form.cityType.value; //已選擇的
	//1.取得畫面年分 
	var begY = form.begY.value=='' ? 0 : eval(form.begY.value) ;
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
function changeTbank(xml) {
	var myXML,nodeValue, nodeName,nodeYear,nodeType,nodeCity;
	//1.取得畫面年分 
	var begY = form.begY.value=='' ? 0 : eval(form.begY.value) ;
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
//受處年分改變==========
function chnageYear() {
	//1.修改縣市別
	changeCity("CityXML") ;
	//2.修改金融機構
	changeTbank("TBankXML");
}

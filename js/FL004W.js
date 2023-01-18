//106.08.02 fix 調整loan_date貸款日期,轉換西元年的方式 by 2295
function doSubmit(form,cnd){
	if(cnd=='DetailList' || cnd=='New' || cnd=='RtnList' || cnd=='New1'){
		form.action="/pages/FL004W.jsp?act="+cnd; 
		form.submit();
	}else if(cnd=='List'){
		if(chkEx_No(form)){
			form.action="/pages/FL004W.jsp?act="+cnd; 
			form.submit();
		}
	}else if(cnd=='Insert'){
		if(chkEditPage(form,cnd)){
			if(AskInsert_Permission()){
				form.action="/pages/FL004W.jsp?act="+cnd; 
				form.submit();
			}
		}
	}else if(cnd=='Update'){
		if(chkEditPage(form,cnd)){
			if(AskEdit_Permission()){
				form.action="/pages/FL004W.jsp?act="+cnd; 
				form.submit();
			}
		}
	}else if(cnd=='Delete'){
		if(AskDelete_Permission()){
			form.action="/pages/FL004W.jsp?act="+cnd; 
			form.submit();
		}
	}
	
}
//106.08.02 fix 調整轉換西元年的方式 by 2295
function chkEditPage(form,act){
	var ex_type = '';
	if(act=='Insert' && form.act.value=='New'){
		for (var i=0; i<form.ex_Type.length; i++){
		   if (form.ex_Type[i].checked){
			   ex_type = form.ex_Type[i].value;
			   break;
		   }
		}
		if(ex_type==''){
			alert("請選擇查核類別");
			return false;
		}else{
			//insEx_No
			if(ex_type=="FEB"){
				if(form.ex_No.value==''){
					alert("請輸入檢查報告編號");
					form.ex_No.focus();
					return false;
				}else{
					form.insEx_No.value=form.ex_No.value;
				}
			}else if(ex_type=="AGRI"){
				form.begSeason.value='';
				if(form.begSeasonY.value=='' || form.begSeasonS.value==''){
					alert("請輸入查核季別");
					form.begSeasonY.focus();
					return false;
				}else{
					form.begSeason.value = addZero(form.begSeasonY.value,3)+addZero(form.begSeasonS.value,2);
					form.insEx_No.value=form.begSeason.value;
				}
			}else if(ex_type=="BOAF"){
				if(form.begY.value!=""){
				    if(!mergeCheckedDate("begY;begM;begD","begDate")){
				        form.begY.focus();
				        return false;
				    }
			    }else{
			    	alert("請選擇訪查日期");
			    	return false;
			    }
				form.insEx_No.value=parseInt(form.begDate.value)+19110000;
			}
		}
		if(form.tbank.value==''){
			alert("請選擇受檢單位");
			return false;
		}
	}else{
		ex_type=form.ex_Type.value;
	}
	var ex_kind = "";
	for (var i=0; i<form.ex_Kind.length; i++){
		   if (form.ex_Kind[i].checked){
			   ex_kind = form.ex_Kind[i].value;
			   break;
		   }
		}
	if(ex_kind==''){
		alert("請選擇抽查範圍");
		return false;
	}else{
		form.loanDate.value='';
		
		if(ex_kind=='C'){
			if(form.loanY.value!=""){
			    if(!mergeCheckedDate("loanY;loanM;loanD","loanDate")){
			        form.loanY.focus();
			        return false;
			    }else{			    	
			    	//form.loanDate.value=parseInt(form.loanDate.value)+19110000;//無法儲存100年以前的日期為變為0
			    	//106.08.02 fix 調整轉換西元年的方式 by 2295
			    	startdate = form.loanDate.value;
        			startdate = trimString(startdate);
			    	startdate = (Math.abs(startdate.substring(0, startdate.length - 4)) + 1911)
                			  + startdate.substring(startdate.length - 4, startdate.length);
                    form.loanDate.value = startdate;			    	
			    }
		    }
		}else{
			form.loan_Name.value='';
			form.loan_Item.value='';
			form.loan_Amt.value='';
		}
	}
	if(ex_type=="FEB"){
		form.ex_Result[1].checked;//若為金管會檢查報告時,查核結果固定為核有缺失
	}
	if(form.ex_Result[0].checked==true){
		form.def_Type.value='';
		form.def_Case.value='';
	}else if(form.ex_Result[1].checked==true){
		if(form.def_Case.value==''){
			alert("請選擇缺失內容");
			form.def_Case.focus();
			return false;
		}
	}
	return true;
}
function chkEx_No(form){
	form.begDate.value='';
	form.endDate.value='';
	form.begSeason.value='';
	form.endSeason.value='';
	if(!(form.ex_Type[0].checked || form.ex_Type[1].checked || form.ex_Type[2].checked)){
		alert("請選擇查核類別");
		return false;
	}else{
		if(form.ex_Type[1].checked){
			if(form.begSeasonY.value!='' && form.endSeasonY.value==''){
				alert("請選擇查核季別  (迄)");
				form.endSeasonY.focus();
				return false;
			}
			if(form.begSeasonY.value=='' && form.endSeasonY.value!=''){
				alert("請選擇查核季別  (起)");
				form.begSeasonY.focus();
				return false;
			}
			if(form.begSeasonY.value!='' && form.endSeasonY.value!=''){
				form.begSeason.value = addZero(form.begSeasonY.value,3)+addZero(form.begSeasonS.value,2);
				form.endSeason.value = addZero(form.endSeasonY.value,3)+addZero(form.endSeasonS.value,2);
				if(form.begSeason.value > form.endSeason.value){
			    	alert('查核季別  起不得大於迄!');
			    	form.begSeasonY.focus();
					return false ;
			    }
			}
		}else if(form.ex_Type[2].checked){
			if(form.begY.value!=""){
			    if(!mergeCheckedDate("begY;begM;begD","begDate")){
			        form.begY.focus();
			        return false;
			    }
		    }
			if(form.endY.value!=""){
			    if(!mergeCheckedDate("endY;endM;endD","endDate")){
			        form.endY.focus();
			        return false;
			    }
		    }
			if(form.begDate.value!='' && form.endDate.value==''){
				alert('請輸入 訪查日期 迄日!');
				form.endY.focus();
				return false ;
			}
			if(form.begDate.value=='' && form.endDate.value!=''){
				alert('請輸入 訪查日期 起日!');
				form.begY.focus();
				return false ;
			}
			if(form.begDate.value!='' && form.endDate.value!=''){
				if(form.begDate.value > form.endDate.value){
			    	alert('訪查日期  起日不得大於迄日!');
			    	form.begY.focus();
					return false ;
			    }
			}
		}
	}
	return true;
}
function changeEx_No(form){
	if(form.ex_Type[0].checked){//金管會檢查報告
		document.getElementById("showFEB").style.display='' ;
		document.getElementById("showAGRI").style.display='none' ;
		document.getElementById("showBOAF").style.display='none' ;
		form.begSeasonY.value="";form.begSeason.value="";
		form.begY.value="";form.begM.value="";form.begD.value="";
		form.endY.value="";form.endM.vlaue="";form.endD.value="";
	}else if(form.ex_Type[1].checked){//農業金庫查核
		document.getElementById("showFEB").style.display='none' ;
		document.getElementById("showAGRI").style.display='' ;
		document.getElementById("showBOAF").style.display='none' ;
		form.ex_No.value="";
		form.begY.value="";form.begM.value="";form.begD.value="";
		form.endY.value="";form.endM.vlaue="";form.endD.value="";
	}else if(form.ex_Type[2].checked){//農金局訪查
		document.getElementById("showFEB").style.display='none' ;
		document.getElementById("showAGRI").style.display='none' ;
		document.getElementById("showBOAF").style.display='' ;
		form.ex_No.value="";
		form.begSeasonY.value="";form.begSeason.value="";
		form.endSeasonY.value="";form.endSeason.value="";
	}
}

	


function showCase(id){
	var e = document.getElementsByName(id);
	for(var i=0;i<e.length;i++){
		if(e[i].style.display == 'block'){
			e[i].style.display = 'none';
		}else{
			e[i].style.display = 'block';
		}
		
	}
}



//97.07.09 fix 結束日期.可不輸入 by 2295
function AskDelete_Permission() {
  if(confirm("確定要刪除此筆資料嗎？"))
    return true;
  else
    return false;
}

function AskInsert_Permission() {
  if(confirm("確定要新增此筆資料嗎？"))
    return true;
  else
    return false;
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



//==================================================
//組縣市別============
function changeCity(xml,year) {
	var form = document.forms[0];
	var citySeld = form.cityType.value; //已選擇的
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
	setSelect(form.cityType,citySeld);
}
//組金融機構畫面
function changeTbank(xml,year) {
	var form = document.forms[0];
	var myXML,nodeValue, nodeName,nodeYear,nodeType,nodeCity;
	//1.取得畫面年分 
	//var begY = year.value=='' ? 0 : eval(year.value) ;
	Myear = '100' ;//預設年分100年
	//if(begY<=99) {
		//Myear = '99' ;
	//}
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
//缺失態樣
function changeDefType(xml) {
	var form = document.forms[0];
	var myXML,nodeKind,nodeKindName,nodeType,nodeTypeName,nodeValue, nodeName;
	//2.讀Xml
	myXML = document.all(xml).XMLDocument;
	nodeKind = myXML.getElementsByTagName("kind");
	nodeKindName = myXML.getElementsByTagName("kindName");
	nodeType = myXML.getElementsByTagName("type") ;
	nodeTypeName = myXML.getElementsByTagName("typeName") ;
	nodeValue = myXML.getElementsByTagName("case");
	nodeName = myXML.getElementsByTagName("caseName");
	
	//3.取得 ex_kind
	ex_kind = '';
	if(form.ex_Kind[0].checked)ex_kind =form.ex_Kind[0].value;
	if(form.ex_Kind[1].checked)ex_kind =form.ex_Kind[1].value;
	if(form.ex_Kind[2].checked)ex_kind =form.ex_Kind[2].value;
	
	//5.移除已搬入的資料
	var target = document.getElementById("def_Type");
	target.length = 0;
	
	var oOption = document.createElement("OPTION");
	oOption.text="請選擇...";
	oOption.value="";
	target.add(oOption);
	
	lastType = '';
	for(var i=0;i<nodeName.length ;i++)	{
		if((nodeKind.item(i).firstChild.nodeValue== ex_kind)
				&& nodeType.item(i).firstChild.nodeValue != lastType){
			oOption = document.createElement("OPTION");
       	 	oOption.text=nodeTypeName.item(i).firstChild.nodeValue;
	        oOption.value=nodeType.item(i).firstChild.nodeValue; 
	        target.add(oOption);
	        lastType = nodeType.item(i).firstChild.nodeValue;
		}
	}
	changeDefCase(xml);
}
//缺失態樣
function changeDefCase(xml) {
	var form = document.forms[0];
	var myXML,nodeKind,nodeKindName,nodeType,nodeTypeName,nodeValue, nodeName;
	//2.讀Xml
	myXML = document.all(xml).XMLDocument;
	nodeKind = myXML.getElementsByTagName("kind");
	nodeKindName = myXML.getElementsByTagName("kindName");
	nodeType = myXML.getElementsByTagName("type") ;
	nodeTypeName = myXML.getElementsByTagName("typeName") ;
	nodeValue = myXML.getElementsByTagName("case");
	nodeName = myXML.getElementsByTagName("caseName");
	
	//3.取得 ex_kind
	ex_kind = '';
	if(form.ex_Kind[0].checked)ex_kind =form.ex_Kind[0].value;
	if(form.ex_Kind[1].checked)ex_kind =form.ex_Kind[1].value;
	if(form.ex_Kind[2].checked)ex_kind =form.ex_Kind[2].value;
	def_type = form.def_Type.value;
	//5.移除已搬入的資料
	var target = document.getElementById("def_Case");
	target.length = 0;
	
	var oOption = document.createElement("OPTION");
	oOption.text="請選擇...";
	oOption.value="";
	target.add(oOption);
	
	for(var i=0;i<nodeName.length ;i++)	{
		if((nodeKind.item(i).firstChild.nodeValue == ex_kind)
				&& (nodeType.item(i).firstChild.nodeValue == def_type)){
			oOption = document.createElement("OPTION");
       	 	oOption.text=nodeName.item(i).firstChild.nodeValue;
	        oOption.value=nodeValue.item(i).firstChild.nodeValue; 
	        target.add(oOption);
		}
	}
}
function changeEx_Type(form,ex_Type){
	if(ex_Type=='FEB'){//金管會檢查報告
		document.getElementById("showFEB").style.display='' ;
		document.getElementById("showAGRI").style.display='none' ;
		document.getElementById("showBOAF").style.display='none' ;
		form.begSeasonY.value="";form.begSeason.value="";
		form.begY.value="";form.begM.value="";form.begD.value="";
	}else if(ex_Type=='AGRI'){//農業金庫查核
		document.getElementById("showFEB").style.display='none' ;
		document.getElementById("showAGRI").style.display='' ;
		document.getElementById("showBOAF").style.display='none' ;
		form.ex_No.value="";
		form.begY.value="";form.begM.value="";form.begD.value="";
	}else if(ex_Type=='BOAF'){//農金局訪查
		document.getElementById("showFEB").style.display='none' ;
		document.getElementById("showAGRI").style.display='none' ;
		document.getElementById("showBOAF").style.display='' ;
		form.ex_No.value="";
		form.begSeasonY.value="";form.begSeason.value="";
	}
	ctrEx_Type(form,ex_Type);
}
function ctrEx_Type(form,ex_Type){
	if(ex_Type=='FEB'){//金管會檢查報告
		document.getElementById("showEx_KindR").style.display='none' ;
		document.getElementById("showEx_Result").style.display='none' ;
		if(form.act.value=='New'){
			document.getElementById("showAddBtn1").style.display='none' ;
			document.getElementById("showAddBtn2").style.display='inline' ;
		}
	}else if(ex_Type=='AGRI'){//農業金庫查核
		document.getElementById("showEx_KindR").style.display='inline' ;
		document.getElementById("showEx_Result").style.display='' ;
		if(form.act.value=='New'){
			document.getElementById("showAddBtn1").style.display='inline' ;
			document.getElementById("showAddBtn2").style.display='none' ;
		}
	}else if(ex_Type=='BOAF'){//農金局訪查
		document.getElementById("showEx_KindR").style.display='inline' ;
		document.getElementById("showEx_Result").style.display='' ;
		if(form.act.value=='New'){
			document.getElementById("showAddBtn1").style.display='inline' ;
			document.getElementById("showAddBtn2").style.display='none' ;
		}
	}
	ctrDefType('1');
}
function ctrDefType(result){
	if(result=='0'){
		document.getElementById("showDefType").style.display='none' ;
		form.def_Type.value='';
		form.def_Case.value='';
	}else{
		document.getElementById("showDefType").style.display='' ;
	}
}
function ctrEx_Kind(kind){
	if(kind=='C'){
		document.getElementById("showLoan1").style.display = '';
		document.getElementById("showLoan2").style.display = '';
		document.getElementById("showLoan3").style.display = '';
		document.getElementById("showLoan4").style.display = '';
	}else{
		document.getElementById("showLoan1").style.display = 'none';
		document.getElementById("showLoan2").style.display = 'none';
		document.getElementById("showLoan3").style.display = 'none';
		document.getElementById("showLoan4").style.display = 'none';
		form.loan_Name.value='';
		form.loanY.value='';
		form.loanM.value='';
		form.loanD.value='';
		form.loan_Item.value='';
		form.loan_Amt.value='';
	}
}

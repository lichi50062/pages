﻿function doSubmit(form,cnd){
	if(cnd=='New' || cnd=='RtnList'){
		form.action="/pages/FL010W.jsp?act="+cnd; 
		form.submit();
	}else if(cnd=='List'){
		if(chkListVal(form)){
			form.action="/pages/FL010W.jsp?act="+cnd; 
			form.submit();
		}
	}else if(cnd=='Insert'){
		if(chkEditPage(form,cnd)){
			if(AskInsert_Permission()){
				form.action="/pages/FL010W.jsp?act="+cnd; 
				form.submit();
			}
		}
	}else if(cnd=='Update'){
		if(chkEditPage(form,cnd)){
			if(AskEdit_Permission()){
				form.action="/pages/FL010W.jsp?act="+cnd; 
				form.submit();
			}
		}
	}else if(cnd=='Delete'){
		if(AskDelete_Permission()){
			form.action="/pages/FL010W.jsp?act="+cnd; 
			form.submit();
		}
		
	}
}
function goEdit(form,bankno,exno,docno,seqId){
	var seqs = '';
	var e = document.getElementsByName(seqId);
	for(var i=0;i<e.length;i++){
		if(seqs!=''){
			seqs = seqs+",";
		}
		seqs += e[i].value;
	}
	form.action="/pages/FL010W.jsp?act=Edit&bank_No="+bankno+"&ex_No="+exno+"&docNo="+docno+"&def_Seq="+seqs; 
	form.submit();
}
function chkEditPage(form,act){
	form.doc_Date.value = '';
	if(form.docY.value!=""){
	    if(!mergeCheckedDate("docY;docM;docD","doc_Date")){
	        form.docY.focus();
	        return false;
	    }else{
	    	if(form.doc_Date.value!=''){
	    		form.doc_Date.value=parseInt(form.doc_Date.value)+19110000;
	    	}
	    }
    }
	if(form.docNo.value==''){
		alert("請輸入發文文號");
		return false;
	}
	var ex_type = '';
	if(act=='Insert'){
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
			if(ex_type=="FEB"){
				if(form.ex_No.value==''){
					alert("請選擇檢查報告編號");
					form.ex_No.focus();
					return false;
				}
			}else if(ex_type=="AGRI"){
				if(form.ex_No.value==''){
					alert("請選擇查核季別");
					form.ex_No.focus();
					return false;
				}
			}else if(ex_type=="BOAF"){
				if(form.ex_No.value==''){
					alert("請選擇訪查日期");
					form.ex_No.focus();
					return false;
				}
			}
		}
		if(form.tbank.value==''){
			alert("請選擇受檢單位");
			return false;
		}
		
	}else{
		ex_type=form.ex_Type.value;
	}
	
	if(form.isOver.checked==true){
		form.case_Status.value="0";
	}else{
		form.case_Status.value="1";
	}
	
	if(form.detailCnt.value>1){
		form.def_Seq.value='';
		form.refund_Amt.value='';
		for(var s=0;s<form.detailCnt.value;s++){
			if(form.amt[s].value==''){
				form.amt[s].value = "0";
			}else{
				if(form.over_Amt[s].value!=form.amt[s].value){
					alert("退還金額與農業金庫更正函的溢繳金額["+form.over_Amt[s].value+"元]不一致");
				}
			}
			
			if(form.def_Seq.value!='')form.def_Seq.value+=";";
			form.def_Seq.value+=form.seq[s].value;
			if(form.refund_Amt.value!='')form.refund_Amt.value+=";";
			form.refund_Amt.value+=form.amt[s].value;
		}
	}else if(form.detailCnt.value == 1){
		if(form.amt.value==''){
			form.amt.value = "0";
		}else{
			if(form.over_Amt.value!=form.amt.value){
				alert("退還金額與農業金庫更正函的溢繳金額["+form.over_Amt.value+"元]不一致");
			}
		}
		form.def_Seq.value=form.seq.value;
		form.refund_Amt.value=form.amt.value;
	}
	return true;
}

function chkListVal(form){
	form.begDate.value='';
	form.endDate.value='';
	form.begSeason.value='';
	form.endSeason.value='';
	form.docBegDate.value='';
	form.docEndDate.value='';
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
	if(form.docBegY.value!=""){
	    if(!mergeCheckedDate("docBegY;docBegM;docBegD","docBegDate")){
	        form.docBegY.focus();
	        return false;
	    }
    }
	if(form.docEndY.value!=""){
	    if(!mergeCheckedDate("docEndY;docEndM;docEndD","docEndDate")){
	        form.docEndY.focus();
	        return false;
	    }
    }
	return true;
}
function ctrEx_No(form){
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
function setRadio(S1, bankid) {
    if(S1 == null)
    	return;
    for(i=0;i<S1.length;i++) {
      	if(S1[i].value==bankid)    	{
        	S1[i].checked=true;
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
	oOption.text="請選擇...";
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

function changeEx_Type(form,ex_Type){
	if(ex_Type=='FEB'){//金管會檢查報告
		document.getElementById("ex_No_Title").innerHTML='檢查報告編號';//set title
	}else if(ex_Type=='AGRI'){//農業金庫查核
		document.getElementById("ex_No_Title").innerHTML='查核季別';
	}else if(ex_Type=='BOAF'){//農金局訪查
		document.getElementById("ex_No_Title").innerHTML='訪查日期';
	}
	changeExNo('DetailXML');//set option
}
function changeExNo(xml) {
	var form = document.forms[0];
	var myXML,nodeBank,nodeType,nodeExNo,nodeExNoList;
	//2.DetailXML
	myXML = document.all(xml).XMLDocument;
	nodeBank = myXML.getElementsByTagName("bank_no");
	nodeType = myXML.getElementsByTagName("ex_type");
	nodeExNo = myXML.getElementsByTagName("ex_no");
	nodeExNoList = myXML.getElementsByTagName("ex_no_list");
	//3.取得 受檢單位代號
	var sBankNo = form.tbank.value ;
	//4.取得 查核類別
	var sExType = '';
	if("New"==form.act.value){
		for (var i=0; i<form.ex_Type.length; i++){
			   if (form.ex_Type[i].checked){
				   sExType = form.ex_Type[i].value;
				   break;
			   }
		}
	}else{
		sExType = form.ex_Type.value;
	}
	//var sExNo = form.ex_No.value;
	
	var target = document.getElementById("ex_No");
	target.length = 0;
	var oOption = document.createElement("OPTION");
	oOption.text="請選擇...";
    oOption.value=""; 
    target.add(oOption);
	var lExNo = '';
	
	for(var i=0;i<nodeBank.length ;i++)	{
		if(nodeBank.item(i).firstChild.nodeValue==sBankNo
				&& nodeType.item(i).firstChild.nodeValue==sExType
				&& lExNo!=nodeExNo.item(i).firstChild.nodeValue) {
			oOption = document.createElement("OPTION");
       	 	oOption.text=nodeExNoList.item(i).firstChild.nodeValue;
	        oOption.value=nodeExNo.item(i).firstChild.nodeValue; 
	        lExNo = nodeExNo.item(i).firstChild.nodeValue;
	        target.add(oOption);
		}
	}
	setDetailList('DetailXML');
}

function setDetailList(xml){
	var form = document.forms[0];
	form.detailCnt.value='';
	var myXML,nodeBank,nodeType,nodeExNo,nodeExNoList;
	var nodeSeq,nodeLoanName,nodeLoanDate,nodeLoanAmt,nodeLoanItem,nodeLoanItemName;
	var nodeLoanAmt,nodeDefType,nodeDefCase,nodeCaseName,nodeNonLoanAmt,nodeNonLoanStatus;
	//2.DetailXml
	myXML = document.all(xml).XMLDocument;
	nodeBank = myXML.getElementsByTagName("bank_no");
	nodeType = myXML.getElementsByTagName("ex_type");
	nodeExNo = myXML.getElementsByTagName("ex_no");
	nodeExNoList = myXML.getElementsByTagName("ex_no_list");
	nodeSeq = myXML.getElementsByTagName("def_seq");
	nodeLoanName = myXML.getElementsByTagName("loan_name");
	nodeLoanDate = myXML.getElementsByTagName("loan_date");
	nodeLoanAmt = myXML.getElementsByTagName("loan_amt");
	nodeLoanItem = myXML.getElementsByTagName("loan_item");
	nodeLoanItemName = myXML.getElementsByTagName("loan_item_name");
	nodeCaseName = myXML.getElementsByTagName("case_name");
	nodeNonLoanAmt = myXML.getElementsByTagName("non_loan_amt");
	nodePayAmt = myXML.getElementsByTagName("pay_amt");
	nodeOverAmt = myXML.getElementsByTagName("over_amt");
	//3.取得 受檢單位代號
	var sBankNo = form.tbank.value ;
	//4.取得 查核類別
	var sExType = '';
	if("New"==form.act.value){
		for (var i=0; i<form.ex_Type.length; i++){
			   if (form.ex_Type[i].checked){
				   sExType = form.ex_Type[i].value;
				   break;
			   }
		}
	}else{
		sExType = form.ex_Type.value;
	}
	//4.取得 檢查報告編號
	var sExNo = form.ex_No.value ;
	
	//5.移除資料
	var num = document.getElementById("tbl").rows.length;
	if(num >1){//刪除最後一個
		for(var i=1;i<num;i++){
			document.getElementById("tbl").deleteRow(-1);
		}
	}
	var tCnt=0;
	var innerStr = '';
	var lName = '',lDate='',lItem='',lAmt='';
	var seq='',name='',date='',item='',itemname='',amt='',caseName='',non_loan_amt='',pay_amt='',over_amt='';
	var caseCnt=1;
	for(var i=0;i<nodeSeq.length ;i++)	{
		if(nodeBank.item(i).firstChild.nodeValue==sBankNo
				&& nodeExNo.item(i).firstChild.nodeValue==sExNo) {
			if(lName==nodeLoanName.item(i).firstChild.nodeValue
					&&lDate==nodeLoanDate.item(i).firstChild.nodeValue
					&&lItem==nodeLoanItemName.item(i).firstChild.nodeValue
					&&lAmt==nodeLoanAmt.item(i).firstChild.nodeValue ){
				seq=seq+","+nodeSeq.item(i).firstChild.nodeValue;
				caseCnt++;
				caseName=caseName+"<br>"+caseCnt+"."+nodeCaseName.item(i).firstChild.nodeValue;//缺失情節
			}else{
				if(i!=0 && seq!=''){
					setListInfo(tCnt,seq,name,date,itemname,amt,caseName,non_loan_amt,pay_amt,over_amt);
					tCnt++;
				}
				caseCnt=1;
				seq=nodeSeq.item(i).firstChild.nodeValue;
				name=nodeLoanName.item(i).firstChild.nodeValue;
				date=nodeLoanDate.item(i).firstChild.nodeValue;
				itemname=nodeLoanItemName.item(i).firstChild.nodeValue;
				amt=nodeLoanAmt.item(i).firstChild.nodeValue;
				caseName=caseCnt+"."+nodeCaseName.item(i).firstChild.nodeValue;//缺失情節
				non_loan_amt=nodeNonLoanAmt.item(i).firstChild.nodeValue;
				pay_amt=nodePayAmt.item(i).firstChild.nodeValue;
				over_amt=nodeOverAmt.item(i).firstChild.nodeValue;
				lName=name,lDate=date,lItem=itemname,lAmt=amt;
				date = date.replace('年','/');
				date = date.replace('月','/');
				date = date.replace('日','');
			}
		}
		
	}
	if(caseName!=''){//最後一筆
		setListInfo(tCnt,seq,name,date,itemname,amt,caseName,non_loan_amt,pay_amt,over_amt);
		tCnt++;
	}
	num = document.getElementById("tbl").rows.length;
	if(num==1){
		var tr = document.createElement('tr');
		tr.className='sbody';
		var td = document.createElement('td');
		td.innerHTML = "&nbsp;";
		tr.appendChild(td);
		td = document.createElement('td');
		td.innerHTML = "&nbsp;";
		tr.appendChild(td);
		td = document.createElement('td');
		td.innerHTML = "&nbsp;";
		tr.appendChild(td);
		td = document.createElement('td');
		td.innerHTML = "&nbsp;";
		tr.appendChild(td);
		td = document.createElement('td');
		td.innerHTML = "&nbsp;";
		tr.appendChild(td);
		td = document.createElement('td');
		td.innerHTML = "&nbsp;";
		tr.appendChild(td);
		td = document.createElement('td');
		td.innerHTML = "&nbsp;";
		tr.appendChild(td);
		td = document.createElement('td');
		td.innerHTML = "<font color='#FF0000'>查無符合資料</font>";
		td.setAttribute("colSpan","10");
		tr.appendChild(td);
		var s = tr.innerHTML;
		var tbody = document.getElementById('tbl').tBodies[0];
		tbody.appendChild(tr);
	}
	form.detailCnt.value = tCnt;
	if("New"==form.act.value){
		setSelect(form.ex_No,sExNo);
	}
}

function setListInfo(tCnt,seq,name,date,itemname,amt,caseName,non_loan_amt,pay_amt,over_amt){
	var tr = document.createElement('tr');
	tr.className='sbody';
	var td = document.createElement('td');
	td.innerHTML = (name=='null'?"&nbsp;":name);
	tr.appendChild(td);
	td = document.createElement('td');
	td.innerHTML = (date=='null'?"&nbsp;":date);
	tr.appendChild(td);
	td = document.createElement('td');
	td.innerHTML = (itemname=='null'?"&nbsp;":itemname);
	tr.appendChild(td);
	td = document.createElement('td');
	td.innerHTML = (amt=='null'?"&nbsp;":amt);
	tr.appendChild(td);
	td = document.createElement('td');
	td.innerHTML = (caseName=='null'?"&nbsp;":caseName);
	tr.appendChild(td);
	td = document.createElement('td');
	td.innerHTML = (non_loan_amt=='null'?"&nbsp;":non_loan_amt);
	tr.appendChild(td);
	td = document.createElement('td');
	td.innerHTML = (pay_amt=='null'?"&nbsp;":pay_amt);
	tr.appendChild(td);
	td = document.createElement('td');
	td.innerHTML = "<input type='hidden' name='seq' id='seq' value='"+seq+"'>"+
					"<input type='hidden' name='over_Amt' id='over_Amt' value='"+over_amt+"'>"+
					"<input type='text' name='amt' id='amt' value='0'  size='9' style='text-align: right;'>";
	tr.appendChild(td);
	var s = tr.innerHTML;
	var tbody = document.getElementById('tbl').tBodies[0];
	tbody.appendChild(tr);
}

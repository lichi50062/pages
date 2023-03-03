function doSubmit(form,cnd){
	if(cnd=='New' || cnd=='RtnList'){
		form.action="/pages/FL006W.jsp?act="+cnd; 
		form.submit();
	}else if(cnd=='List'){
		if(chkListVal(form)){
			form.action="/pages/FL006W.jsp?act="+cnd; 
			form.submit();
		}
	}else if(cnd=='Insert'){
		if(chkEditPage(form,cnd)){
			if(AskInsert_Permission()){
				form.action="/pages/FL006W.jsp?act="+cnd; 
				form.submit();
			}
		}
	}else if(cnd=='Update'){
		if(chkEditPage(form,cnd)){
			if(AskEdit_Permission()){
				form.action="/pages/FL006W.jsp?act="+cnd; 
				form.submit();
			}
		}
	}else if(cnd=='Delete'){
		if(AskDelete_Permission()){
			form.action="/pages/FL006W.jsp?act="+cnd; 
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
	form.action="/pages/FL006W.jsp?act=Edit&bank_No="+bankno+"&ex_No="+exno+"&docNo="+docno+"&def_Seq="+seqs; 
	form.submit();
}
function chkEditPage(form,act){
	form.bank_Rt_Doc_Date.value = '';
	if(form.docY.value!=""){
	    if(!mergeCheckedDate("docY;docM;docD","bank_Rt_Doc_Date")){
	        form.docY.focus();
	        return false;
	    }else{
	    	if(form.bank_Rt_Doc_Date.value!=''){
	    		form.bank_Rt_Doc_Date.value=parseInt(form.bank_Rt_Doc_Date.value)+19110000;
	    	}
	    }
    }
	if(form.bank_Rt_DocNo.value==''){
		alert("請輸入收文文號");
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
		if(form.docNo.value==''){
			alert("請選擇辦理依據");
			return false;
		}
	}else{
		ex_type=form.ex_Type.value;
	}
	
	form.fine_Date.value = '';
	if(document.getElementById("showFine1").style.display==''){
		if(form.fineY.value!=""){
		    if(!mergeCheckedDate("fineY;fineM;fineD","fine_Date")){
		        form.fineY.focus();
		        return false;
		    }else{
		    	if(form.fine_Date.value!=''){
		    		form.fine_Date.value=parseInt(form.fine_Date.value)+19110000;
		    	}
		    }
	    }
		if(form.fine_PayAmt.value!='' && form.fine_PayAmt.value!='0'){
			if(form.fine_PayAmt.value != form.fine_Amt.value){
				alert("繳交金額與罰鍰金額["+form.fine_Amt.value+"元]不一致");
			}
		}
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
function changeCity() {
	var citySeld = document.form.cityType.value; //已選擇的
	Myear = '100' ;//預設年分100年

	var xmlDoc = $.parseXML($("xml[id=CityXML]").html()) ;
	document.form.cityType.length = 0;
	var data = $(xmlDoc).find("data") ;
	var oOption = document.createElement("OPTION");
	oOption.text="全部";
	oOption.value="";
	document.form.cityType.add(oOption);


	$(data).each(function (i) {
		if($(this).find("cityyear").text()==Myear) {
			oOption = document.createElement("OPTION");``
			oOption.text= $(this).find("cityname").text();
			oOption.value=$(this).find("cityvalue").text();
			document.form.cityType.add(oOption);
		}
	})
	;

	setSelect(document.form.cityType,citySeld);
}
//組金融機構畫面
function changeTbank() {
	/*111.01.17 fix
	var form = document.forms[0];
	var myXML,nodeValue, nodeName,nodeYear,nodeType,nodeCity;
	//1.取得畫面年分changeDefCase

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

function changeEx_Type(form,ex_Type){
	if(ex_Type=='FEB'){//金管會檢查報告
		document.getElementById("ex_No_Title").innerHTML='檢查報告編號';//set title
	}else if(ex_Type=='AGRI'){//農業金庫查核
		document.getElementById("ex_No_Title").innerHTML='查核季別';
	}else if(ex_Type=='BOAF'){//農金局訪查
		document.getElementById("ex_No_Title").innerHTML='訪查日期';
	}
	changeItems();//set option
}
function changeItems() {

	var xmlDoc = $.parseXML($("xml[id=ItemXML]").html()) ;
	document.form.ex_No.length = 0;
	var data = $(xmlDoc).find("data") ;
	var oOption = document.createElement("OPTION");
	oOption.text="請選擇...";
	oOption.value="";
	document.form.ex_No.add(oOption);
	//3.取得 受檢單位代號
	var sBankNo = document.form.tbank.value ;
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

	var lExNo = '';

	$(data).each(function (i) {
		if($(this).find("bank_no").text()==sBankNo
			&& $(this).find("ex_type").text()==sExType
			&& lExNo!=$(this).find("ex_no").text()){

			lExNo = $(this).find("ex_no").text();

			oOption = document.createElement("OPTION");
			oOption.text= $(this).find("ex_no_list").text();
			oOption.value=$(this).find("ex_no").text();
			document.form.ex_No.add(oOption);
		}
	})
	;
	//form.ex_No.value = sExNo;
	changeDocSet(xmlDoc);
}
function changeDocSet(xml) {

	var xmlDoc = $.parseXML($("xml[id=ItemXML]").html()) ;
	var data = $(xmlDoc).find("data") ;
	document.form.docSet.length = 0;
	var form = document.form;

	//3.取得 受檢單位代號
	var sBankNo = form.tbank.value;
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
	var sExNo = form.ex_No.value;


	form.fine_Amt.value='';
	form.docNo.value='';
	var oOption = document.createElement("OPTION");
	oOption.text="請選擇...";
	oOption.value="";
	document.form.docSet.add(oOption);

    var lDocNo = '';
    var lDocDate='';

	$(data).each(function (i) {
		if($(this).find("bank_no").text()==sBankNo
			&& $(this).find("ex_no").text()==sExNo
			&& 'null' != $(this).find("docno").text()){

			if (lDocDate != $(this).find("doc_date").text()
			&& lDocNo != $(this).find("docno").text()) {

			lDocDate = $(this).find("doc_date").text();
			lDocNo = $(this).find("docno").text();
			oOption = document.createElement("OPTION");
			oOption.text = "發文日期："+lDocDate+" 發文文號："+lDocNo;
			oOption.value = lDocDate+";" + lDocNo+";" + $(this).find("audit_id_c1").text() + ";" + $(this).find("fine_amt").text();
			document.form.docSet.add(oOption);
			}
		}
	})
	;
}
function ctrDocSet(form){
	var docno = '';
	var c1 = '';
	var fine_amt = '';
	var docSet = form.docSet.value;
	if(docSet!=''){
		var ss = docSet.split(";");
		for(var i in ss){
			if(i==1 && ss[i]!='null')docno=ss[i];
			if(i==2 && ss[i]!='null')c1=ss[i];
			if(i==3 && ss[i]!='null')fine_amt=ss[i];
		}
	}
	if(c1=='1'){
		document.getElementById("showFine1").style.display='' ;
		document.getElementById("showFine2").style.display='' ;
	}else{
		document.getElementById("showFine1").style.display='none' ;
		document.getElementById("showFine2").style.display='none' ;
		form.fineY.value='';form.fineM.value='';form.fineD.value='';
		form.fine_PayAmt.value='';
		form.fine_Amt.value='';
	}
	form.docNo.value=docno;
	form.fine_Amt.value=fine_amt;
}

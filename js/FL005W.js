function doSubmit(form,cnd){
	if(cnd=='DetailList' || cnd=='New' || cnd=='RtnList'){
		form.action="/pages/FL005W.jsp?act="+cnd; 
		form.submit();
	}else if(cnd=='List'){
		if(chkListVal(form)){
			form.action="/pages/FL005W.jsp?act="+cnd; 
			form.submit();
		}
	}else if(cnd=='Insert'){
		if(chkEditPage(form,cnd)){
			if(AskInsert_Permission()){
				form.action="/pages/FL005W.jsp?act="+cnd; 
				form.submit();
			}
		}
	}else if(cnd=='Update'){
		if(form.bank_Rt_DocNo.value!=''
			|| form.ag_Rt_DocNo.value!=''){
			alert("該發文資料已有農漁會回文文號[ "+form.bank_Rt_DocNo.value+" ]或金庫來文文號[ "+form.ag_Rt_DocNo.value+" ],不提供異動原發文記錄!");
		}else{
			if(chkEditPage(form,cnd)){
				if(AskEdit_Permission()){
					form.action="/pages/FL005W.jsp?act="+cnd; 
					form.submit();
				}
			}
		}
	}else if(cnd=='Delete'){
		if(form.bank_Rt_DocNo.value!=''
			|| form.ag_Rt_DocNo.value!=''){
			if(confirm("該發文資料已有農漁會回文文號[ "+form.bank_Rt_DocNo.value+" ]或金庫來文文號[ "+form.ag_Rt_DocNo.value+" ],將一併刪除?")){
				form.action="/pages/FL005W.jsp?act="+cnd; 
				form.submit();
			}
		}else{
			if(AskDelete_Permission()){
				form.action="/pages/FL005W.jsp?act="+cnd; 
				form.submit();
			}
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
	form.action="/pages/FL005W.jsp?act=Edit&bank_No="+bankno+"&ex_No="+exno+"&docNo="+docno+"&def_Seq="+seqs; 
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
	var doc_type ='';//發文性質
	for (var i=0; i<form.doc_Type.length; i++){
		   if (form.doc_Type[i].checked){
			   doc_type = form.doc_Type[i].value;
			   break;
		   }
		}
	form.def_Seq.value='';
	if(doc_type==''){
		alert("請選擇發文性質");
		return false;
	}else{
		if(doc_type=='A'){
			form.def_Seq.value='0';
		}else if(doc_type=='C'){
			form.def_Seq.value='999';
		}else if(doc_type=='B'){
			var audit_type = '';
			for (var i=0; i<form.audit_Type.length; i++){
				   if (form.audit_Type[i].checked){
					   audit_type = form.audit_Type[i].value;
					   break;
				   }
				}
			if(audit_type==''){
				alert("請選擇核處類別");
				return false;
			}else{//A:缺失個案缺失 B:整体性缺失 C:行政處分
				if(form.detailCnt.value!=''){//是否有缺失個案明細
					if(audit_type=='A'){
						var e = document.getElementsByName("chkbox");
						var tmpStr= '';
						for(var i=0;i<e.length;i++){
							if(e[i].checked){
								if(tmpStr!='')tmpStr+=",";
								tmpStr+= e[i].value;
							}
						}
						if(tmpStr==''){
							alert("請至少選擇一筆缺失個案明細");
							return false;
						}else{
							form.def_Seq.value = tmpStr;
						}
					}else if(audit_type=='B'){
						if(form.detailCnt.value==0){
							alert("目前無對應之個案，故案件無法存檔!");
							return false;
						}else{
							var e = document.getElementById("chkbox");
							e.checked=true;
							form.def_Seq.value = e.value;
						}
					}else if(audit_type=='C'){
						if(form.c1.checked || form.c2.checked){
							form.def_Seq.value = "998";
						}
					}
				}
			}
			if(form.audit_Id.value==''){
				alert("請選擇核處情形");
				return false;
			}
		}
	}
	form.limitDate.value = '';
	if(form.limitY.value!=""){
	    if(!mergeCheckedDate("limitY;limitM;limitD","limitDate")){
	        form.limitY.focus();
	        return false;
	    }else{
	    	if(form.limitDate.value!=''){
	    		form.limitDate.value=parseInt(form.limitDate.value)+19110000;
	    	}
	    }
    }
	form.audit_Id_C1.value='';//糾正
	if(form.c1.checked){
		form.audit_Id_C1.value='1';
	}
	form.audit_Id_C2.value='';//罰鍰
	if(form.c2.checked){
		form.audit_Id_C2.value='1';
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
			oOption = document.createElement("OPTION");
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
function crtAuditIdList(xml){
	var form = document.forms[0];
	var myXML,nodeValue, nodeName,nodeType;

	//3.取得 城市代號
	sType = '' ;
	for (var i=0; i<form.audit_Type.length; i++){
		   if (form.audit_Type[i].checked){
			   sType = form.audit_Type[i].value;
			   break;
		   }
		}
	//5.移除已搬入的資料

	var xmlDoc = $.parseXML($("xml[id=AuditIdXML]").html()) ;
	document.form.tbank.length = 0;
	var data = $(xmlDoc).find("data") ;
	var oOption = document.createElement("OPTION");
	oOption.text="請選擇...";
	oOption.value="";
	document.form.audit_Id.add(oOption);

	$(data).each(function (i) {
		if($(this).find("audit_type").text()==sType) {
			oOption = document.createElement("OPTION");
			oOption.text= $(this).find("audit_case").text();
			oOption.value=$(this).find("audit_id").text();
			document.form.audit_Id.add(oOption);
		}
	})
	;
	
	// for(var i=0;i<nodeName.length ;i++)	{
	// 	if(nodeType.item(i).firstChild.nodeValue==sType) {
	// 		oOption = document.createElement("OPTION");
    //    	 	oOption.text=nodeName.item(i).firstChild.nodeValue;
	//         oOption.value=nodeValue.item(i).firstChild.nodeValue;
	//         target.add(oOption);
	// 	}
	// }
	ctrShowAudit(form);
}
function changeEx_Type(form,ex_Type){
	if(ex_Type=='FEB'){//金管會檢查報告
		document.getElementById("ex_No_Title").innerHTML='檢查報告編號';//set title
	}else if(ex_Type=='AGRI'){//農業金庫查核
		document.getElementById("ex_No_Title").innerHTML='查核季別';
	}else if(ex_Type=='BOAF'){//農金局訪查
		document.getElementById("ex_No_Title").innerHTML='訪查日期';
	}
	changeEx_No();//set option
}
function changeEx_No() {

	var xmlDoc = $.parseXML($("xml[id=DetailXML]").html()) ;
	document.form.ex_No.length = 0;
	var data = $(xmlDoc).find("data") ;
	var oOption = document.createElement("OPTION");
	oOption.text="請選擇...";
	oOption.value="";
	document.form.ex_No.add(oOption);
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
	setDetailList();
}
function setDetailList(){

	var form = document.forms[0];
	form.detailCnt.value='';
	var myXML,nodeBank,nodeType,nodeExNo,nodeExNoList;
	var nodeKind,nodeSeq,nodeLoanName,nodeLoanDate,nodeLoanItemName;
	var nodeLoanAmt,nodeCaseName;
	//2.DetailXml
	var xmlDoc = $.parseXML($("xml[id=DetailXML]").html()) ;
	var data = $(xmlDoc).find("data") ;


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
	var sAuditType = '';
	for (var i=0; i<form.audit_Type.length; i++){
		   if (form.audit_Type[i].checked){
			   sAuditType = form.audit_Type[i].value;
			   break;
		   }
	}
	//5.移除資料
	var num = document.getElementById("tbl").rows.length;
	if(num >1){//刪除最後一個
		for(var i=1;i<num;i++){
			document.getElementById("tbl").deleteRow(-1);
		}
	}
	var seqs=0;
	var innerStr = '';
	var lName = '',lDate='',lItem='',lAmt='';
	var seq='',name='',date='',item='',amt='',caseName='';
	var caseCnt=1;

	$(data).each(function (i) {
		isKind = false;
		if(sAuditType=='A' && $(this).find("ex_kind").text()=='C')isKind = true;
		if(sAuditType=='B' && $(this).find("ex_kind").text()!='C')isKind = true;
		if(isKind){
			if($(this).find("bank_no").text()==sBankNo
				&& $(this).find("ex_no").text()==sExNo) {
				if(lName==$(this).find("loan_name").text()
					&&lDate==$(this).find("loan_date").text()
					&&lItem==$(this).find("loan_item_name").text()
					&&lAmt==$(this).find("loan_amt").text() ){
					seq=seq+","+$(this).find("def_seq").text();
					caseCnt++;
					caseName=caseName+"<br>"+caseCnt+"."+$(this).find("case_name").text();
				}else{
					if(i!=0 && seq!=''){
						setListInfo(seq,name,date,item,amt,caseName);
						seqs++;
					}
					caseCnt=1;
					seq=$(this).find("def_seq").text();
					name=$(this).find("loan_name").text();
					date=$(this).find("loan_date").text();
					item=$(this).find("loan_item_name").text();
					amt=$(this).find("loan_amt").text();
					caseName=caseCnt+"."+$(this).find("case_name").text();
					lName=name,lDate=date,lItem=item,lAmt=amt;
				}
			}
		}
	});


	// for(var i=0;i<nodeSeq.length ;i++)	{
	// 	isKind = false;
	// 	if(sAuditType=='A' && nodeKind.item(i).firstChild.nodeValue=='C')isKind = true;
	// 	if(sAuditType=='B' && nodeKind.item(i).firstChild.nodeValue!='C')isKind = true;
	// 	if(isKind){
	// 		if($(this).find("bank_no").text()==sBankNo
	// 				&& $(this).find("ex_no").text()==sExNo) {
	// 			if(lName==$(this).find("loan_name").text()
	// 					&&lDate==$(this).find("nodeLoanDate").text()
	// 					&&lItem==$(this).find("nodeLoanItemName").text()
	// 					&&lAmt==$(this).find("nodeLoanAmt").text() ){
	// 				seq=seq+","+$(this).find("def_seq").text();
	// 				caseCnt++;
	// 				caseName=caseName+"<br>"+caseCnt+"."+$(this).find("case_name").text();
	// 			}else{
	// 				if(i!=0 && seq!=''){
	// 					setListInfo(seq,name,date,item,amt,caseName);
	// 					seqs++;
	// 				}
	// 				caseCnt=1;
	// 				seq=$(this).find("def_seq").text();
	// 				name=$(this).find("loan_name").text();
	// 				date=$(this).find("nodeLoanDate").text();
	// 				item=$(this).find("nodeLoanItemName").text();
	// 				amt=$(this).find("nodeLoanAmt").text();
	// 				caseName=caseCnt+"."+$(this).find("case_name").text();
	// 				lName=name,lDate=date,lItem=item,lAmt=amt;
	// 			}
	// 		}
	// 	}
	// }
	if(caseName!=''){//最後一筆
		setListInfo(seq,name,date,item,amt,caseName);
		seqs++;
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
		td.innerHTML = "<font color='#FF0000'>查無符合資料</font>";
		td.setAttribute("colSpan","7");
		tr.appendChild(td);
		var s = tr.innerHTML;
		var tbody = document.getElementById('tbl').tBodies[0];
		tbody.appendChild(tr);
	}
	form.detailCnt.value = seqs;
	if("New"==form.act.value){
		setSelect(form.ex_No,sExNo);
	}
}

function setListInfo(seq,name,date,item,amt,caseName){
	var tr = document.createElement('tr');
	tr.className='sbody';
	var td = document.createElement('td');
	tmpStr = "<input type='checkbox' name='chkbox' id='chkbox' value='"+seq+"' ";
	var  oriSeq = form.oriDef_Seq.value;
	//var ss = oriSeq.split(",");
	//for (var i in ss) {
		//if(ss[i]==seq){
	if(oriSeq==seq){
			tmpStr += " checked ";
	}
		//}
	//}
	tmpStr += ">";
	td.innerHTML = tmpStr;
	tr.appendChild(td);
	td = document.createElement('td');
	td.innerHTML = (name=='null'?"&nbsp;":name);
	tr.appendChild(td);
	td = document.createElement('td');
	td.innerHTML = (date=='null'?"&nbsp;":date.substr(0,3)+"/"+date.substr(3,2)+"/"+date.substr(5,2));
	tr.appendChild(td);
	td = document.createElement('td');
	td.innerHTML = (item=='null'?"&nbsp;":item);
	tr.appendChild(td);
	td = document.createElement('td');
	td.innerHTML = (amt=='null'?"&nbsp;":amt);
	tr.appendChild(td);
	td = document.createElement('td');
	td.innerHTML = (caseName=='null'?"&nbsp;":caseName);
	tr.appendChild(td);
	var s = tr.innerHTML;
	var tbody = document.getElementById('tbl').tBodies[0];
	tbody.appendChild(tr);
}

function ctrDetail(form){
	var doc_Type = '';
	for (var i=0; i<form.doc_Type.length; i++){
		if (form.doc_Type[i].checked){
			doc_Type = form.doc_Type[i].value;
			break;
		}
	}
	
	if(doc_Type=='B'){
		document.getElementById("showAuditType").style.display = '';
		document.getElementById("showAuditId").style.display = '';
		document.getElementById("showPointAuditType").style.display = 'inline'; 
		document.getElementById("showPointAuditId").style.display = 'inline';
		
		var audit_Type = '';
		for (var i=0; i<form.audit_Type.length; i++){
			if (form.audit_Type[i].checked){
				audit_Type = form.audit_Type[i].value;
				break;
			}
		}
		if(audit_Type =='A'){
			document.getElementById("showDetail").style.display = '';
		}else{
			document.getElementById("showDetail").style.display = 'none';
		}
	}else{
		document.getElementById("showAuditType").style.display = 'none';
		document.getElementById("showAuditId").style.display = 'none';
		document.getElementById("showPointAuditType").style.display = 'none'; 
		document.getElementById("showPointAuditId").style.display = 'none';
		document.getElementById("showDetail").style.display = 'none';
	}
	
}

function ctrShowAudit(form){
	//1.若核處情形為A1限期改善具報、B1限期改善具報,才顯示限期函報期限
	//2.若核處情形為A2未符規定，應收回貸款、繳還補貼息,才顯示不符規定金額。
	//3.若核處情形為A3調整貸款期限、繳還溢領之補貼息,才顯示應調整貸款金額、原貸款期限、修正後貸款期限。
	//4.若核處情形為C0裁處罰鍰、裁處糾正,才顯示勾選糾正、罰鍰及罰鍰金額
	var id = form.audit_Id.value;
	if(id=='A1' || id=='B1'){
		document.getElementById("showAudit1").style.display = '';
		document.getElementById("showAudit2").style.display = 'none';
		document.getElementById("showAudit2_1").style.display = 'none';
		document.getElementById("showAudit3").style.display = 'none';
		document.getElementById("showAudit3_1").style.display = 'none';
		document.getElementById("showAudit4").style.display = 'none';
		form.loan_Year.value='';form.change_Loan_Year.value='';
		form.non_Loan_Amt.value='';
		form.c1.checked=false;form.c2.checked=false;form.fine_Amt.value='';
	}else if(id=='A2'){
		document.getElementById("showAudit1").style.display = 'none';
		document.getElementById("showAudit2").style.display = 'inline';
		document.getElementById("showAudit2_1").style.display = 'inline';
		document.getElementById("showAudit3").style.display = 'none';
		document.getElementById("showAudit3_1").style.display = 'none';
		document.getElementById("showAudit4").style.display = 'none';
		form.limitY.value='';form.limitM.value='';form.limitD.value='';
		form.loan_Year.value='';form.change_Loan_Year.value='';
		form.c1.checked=false;form.c2.checked=false;form.fine_Amt.value='';
	}else if(id=='A3'){
		document.getElementById("showAudit1").style.display = 'none';
		document.getElementById("showAudit2").style.display = 'inline';
		document.getElementById("showAudit2_1").style.display = 'none';
		document.getElementById("showAudit3").style.display = 'inline';
		document.getElementById("showAudit3_1").style.display = 'inline';
		document.getElementById("showAudit4").style.display = 'none';
		form.limitY.value='';form.limitM.value='';form.limitD.value='';
		form.c1.checked=false;form.c2.checked=false;form.fine_Amt.value='';
	}else if(id=='C0'){
		document.getElementById("showAudit1").style.display = 'none';
		document.getElementById("showAudit2").style.display = 'none';
		document.getElementById("showAudit2_1").style.display = 'none';
		document.getElementById("showAudit3").style.display = 'none';
		document.getElementById("showAudit3_1").style.display = 'none';
		document.getElementById("showAudit4").style.display = '';
		form.limitY.value='';form.limitM.value='';form.limitD.value='';
		form.non_Loan_Amt.value='';
		form.loan_Year.value='';form.change_Loan_Year.value='';
	}else{
		document.getElementById("showAudit1").style.display = 'none';
		document.getElementById("showAudit2").style.display = 'none';
		document.getElementById("showAudit2_1").style.display = 'none';
		document.getElementById("showAudit3").style.display = 'none';
		document.getElementById("showAudit3_1").style.display = 'none';
		document.getElementById("showAudit4").style.display = 'none';
		form.limitY.value='';form.limitM.value='';form.limitD.value='';
		form.non_Loan_Amt.value='';
		form.loan_Year.value='';form.change_Loan_Year.value='';
		form.c1.checked=false;form.c2.checked=false;form.fine_Amt.value='';
	}
}

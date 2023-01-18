function doSubmit(form,cnd,reportno){
	    form.action="/pages/TC36.jsp?act="+cnd+"&test=nothing";
	    if(((cnd == "Insert") || (cnd == "Update") || (cnd == "Delete"))
	    && (!checkData(form,cnd))) return;

	    //if(cnd == "new" || cnd == "Qry" ) form.submit();
	    if(cnd == "new") form.submit();
	    if(cnd == "Qry"){
	    	if(!checkData(form)) return;
	    	form.submit();
	    }
	    if(cnd == "Edit" || cnd == "Report"){
	       	form.action="/pages/TC36.jsp?act="+cnd+"&reportno="+reportno+"&test=nothing";
	       	form.submit();
	    }
	    if((cnd == "Insert") && AskInsert(form)) form.submit();
	    if((cnd == "Update") && AskUpdate(form)) form.submit();
	    if((cnd == "Delete") && AskDelete(form)) form.submit();
}

//重導TC36.jsp頁面以致輸出對應之金融機構資料
function getData(form,cnd,item){
	if(item == 'bank_type'){
		//初始BANK_NO值
	   	form.BANK_NO.value="";
	}
	form.action="/pages/TC36.jsp?act=getData&nowact="+cnd+"&test=nothing";
	form.submit();
}

//輸入資料檢核處理
function checkData(form)
{
	//輸入項目檢核
	//if (trimString(form.BANK_NO.value) =="" ){
	//	alert("受檢單位不可空白");
	//	form.BANK_NO.focus();
	//	return false;
	//}
   return true;
}
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

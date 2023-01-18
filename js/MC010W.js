//98.10.22 拿掉業務開辦日期 by 2295
function doSubmit(form,cnd,tbank,violate_date){
	if(cnd =='add'){	   
	   if(!checkData(form)) return;
       var sel=[form.tbank];//select 陣列
       var seltxt=['受限制或核准機構'];
       var rad=[form.loalHide];//radio button陣列
       var radtxt=['是否將此筆資料給予檢查局 ?'];
       var input=[form.loalMgr,form.loalNum,form.loalContent,form.loalPs];
       var inputtxt=['核准或限制機關','限制或核准函號','限制或核准內容','備註'];
       if (!chkSelect(sel,seltxt)) return;     //檢核必選select是否皆已選
       else if (!chkInTxt(input,inputtxt)) return;
       else if(!chkRadio(rad,radtxt)) return;  //檢核必選radio button是否皆已點選	 
       //if(!chkOpendate(form,form.begY1,form.begM1,form.begD1)) return;
       if(AskInsert_Permission())
	   {
		 form.action="/pages/MC010W.jsp?act=Insert";	    
		 form.submit();
       }
    }
    else if(cnd =='modify'){
         //if(!chkOpendate(form,form.begY2,form.begM2,form.begD2)) return;
	     if(AskEdit_Permission()){
	        form.action="/pages/MC010W.jsp?act=Update";	    
	        form.submit();
	     }
   }
   else if(cnd =='delete'){
	       if(AskDelete_Permission()){
	          form.action="/pages/MC010W.jsp?act=Delete";	    
	          form.submit();
	      }
   }
   else if(cnd == "Qry") {
        if(checkDuringDate(form)) {
            form.act.value = "Qry";
            form.submit();
        }    
   }else return ;
}

//98.06.06  由使用者選擇或輸入核准或限制機關--by 2756
function chkLMgr(form)
{
	var a=form.loalMgr.value;
	if (a=="")
	{
	  alert("請選擇或輸入核准或限制機關");
	  form.loalMgr.focus();
	  return false;
	}
	return true;
}
//98.06.06 檢核必輸入的input及text_area
function chkInTxt(arrTxt,arrTxttxt)
{
	  for(i=0;i<arrTxt.length;i++)
	  {
	    if(arrTxt[i].value=="")
		{
		  alert("請輸入"+arrTxttxt[i]);
		  arrTxt[i].focus();
		  return false;
		}
	  }
	  return true;	
}
//98.06.06 檢核必選的select
function chkSelect(arrSel,arrSeltxt)
{
  for(i=0;i<arrSel.length;i++)
  {
    if(arrSel[i].selectedIndex==0)
	{
	  alert("請選擇"+arrSeltxt[i]);
	  arrSel[i].focus();
	  return false;
	}
  }
  return true;
}
//98.06.06 檢核必選的radio
function chkRadio(arrRad,arrRadtxt)
{
  var a=false;
  for(i=0;i<arrRad.length;i++)
  {
    for(j=0;j<arrRad[i].length;j++)
    {
    	if(arrRad[i][j].checked == true)
    	{
    		a=true;
    	}
    }
    if(!a) 
    {
      alert("請點選 "+arrRadtxt[i]);
      arrRad[i][0].focus();
      return false;
    }
  }  
  return true;
}

function checkData(form) 
{
	if(form.begY.value != "") {
        form.loalAddDate.value = mergeDate(form.begY.value, form.begM.value, form.begD.value);
        //alert(form.VIOLATE_DATE.value);
        if(!fnValidDate(form.loalAddDate.value)) {
            alert("函文日期不合法");
            return false;
        }
   }
	
   return true;
}

function chkOpendate(form,a,b,c) 
{

        if(a.value==""||b.value==""||c.value=="")
        {   
        	form.loalOpenDate.value = "";
        }
        else
        {
        	form.loalOpenDate.value = mergeDate(a.value, b.value, c.value);

        }

        if(form.loalOpenDate.value=="") 
        {
            if(form.loalOpenFlag.checked==true)
            {
            	form.loalOpenFlag.value="Y";
            }
            else
            {
        	  if(form.loalOpenFlag.disabled==true)
        	  {
                alert("請選擇完整的「業務開辦日期」");
        	  }
        	  else
        	  {
        		alert("請選擇完整的「業務開辦日期」或勾選「尚未開辦」");  
        	  }
        	  a.focus();
        	  return false;
            }            
        }
        else
        {
        	//form.loalOpenFlag.value="N";
        	if(form.loalOpenFlag.checked==true)
        	{
        		alert("請選擇完整的「業務開辦日期」或勾選「尚未開辦」");
        		form.loalOpenFlag.focus();
        		return false;
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

//==================================================
//組縣市別============
//組縣市別============
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
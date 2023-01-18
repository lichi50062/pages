function doSubmit(form,cnd,subcnd,item){
	var sel,seltxt,input,inputtxt;
	
	if(cnd =='add'){	   
	   if(!checkData(form)) return;	
	   sel=[form.tbank];//select 陣列
       seltxt=['被檢舉機構'];
	   input=[form.taRptr,form.taNum,form.taContent,form.taPs];//text textarea陣列
       inputtxt=['檢舉人','收文文號','檢舉內容','備註'];
       if (!chkSelect(sel,seltxt)) return;     //檢核必選select是否皆已選
       else if (!chkInTxt(input,inputtxt)) return;
       
       if(AskInsert_Permission())
	   {
		 form.action="/pages/MC014W.jsp?act=Insert";	    
		 form.submit();
       }
    }
    else if(cnd =='modify'){
       if(!chkUpdDate(form,subcnd,item)) return;

	   if(subcnd=='R')
	   {
		   input=[form.taPubNum,form.taPubContent,form.taContent];//text textarea陣列
           inputtxt=['發文文號','本局處理情形','檢舉內容'];
           if (!chkInTxt(input,inputtxt)) return;
	   }
	   else if(subcnd=='B')
	   {
		   input=[form.taBkNum,form.taBkResult];//text textarea陣列
           inputtxt=['回文函號','處理情形'];
           if (!chkInTxt(input,inputtxt)) return;		   
	   }
	   else if (subcnd=='N')
	   {
		   if(!checkData(form)) return;	
		   input=[form.taRptr,form.taNum,form.taContent,form.taPs];//text textarea陣列
	       inputtxt=['檢舉人','收文文號','檢舉內容','備註'];

	       if (!chkInTxt(input,inputtxt)) return;		   
	   }
       if(AskEdit_Permission())
	   {
	     form.action="/pages/MC014W.jsp?act=Update&flag="+subcnd+"&item="+item+"";	    
	     form.submit();
	   }
   }
   else if(cnd =='delete'){
	       if(AskDelete_Permission()){
	          form.action="/pages/MC014W.jsp?act=Delete&flag="+subcnd+"";	    
	          form.submit();
	      }
   }
   else if(cnd == 'Qry') 
   {
        
	   if(checkDuringDate(form,subcnd)) 
        {
            form.act.value = "Qry";
            form.flag.value = subcnd;
            if(subcnd=='R')//發文
            {
            	form.item.value="1";
            }
            else if(subcnd=="B")//回文
            {
            	form.item.value="2";
            }
            else if(subcnd=="N")
            {
            	form.item.value="1";
            }
            else//檢舉書
            {
            	form.item.value="3";
            }
            form.submit();
        }
        
   }else return ;
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
//98.06.17 檢核日期(發文作業,回文作業)
function chkUpdDate(form,item,item2) 
{
	if(item2=="1")
	{
	  if(item!="N")
	  {
	    if(form.begY1.value != "") 
	    {
            form.taPubDate.value = mergeDate(form.begY1.value, form.begM1.value, form.begD1.value);
            //alert(form.VIOLATE_DATE.value);
            if(!fnValidDate(form.taPubDate.value)) 
            {
                alert("發文日期不合法");
                return false;
            }
        }
	  }
	  else
	  {
			if(form.begY0.value != "") {
		        form.taDate.value = mergeDate(form.begY0.value, form.begM0.value, form.begD0.value);
		        //alert(form.VIOLATE_DATE.value);
		        if(!fnValidDate(form.taDate.value)) {
		            alert("收文日期不合法");
		            return false;
		        }
		   }
	  }
	}
	else if(item2=="2")
	{
		  if(form.begY2.value != "") 
		  {
	          form.taBkDate.value = mergeDate(form.begY2.value, form.begM2.value, form.begD2.value);
	          //alert(form.VIOLATE_DATE.value);
	          if(!fnValidDate(form.taBkDate.value)) 
	          {
	              alert("回文日期不合法");
	              return false;
	          }
	      }		
	}
   return true;
}



function checkData(form) 
{
	if(form.begY0.value != "") {
        form.taDate.value = mergeDate(form.begY0.value, form.begM0.value, form.begD0.value);
        //alert(form.VIOLATE_DATE.value);
        if(!fnValidDate(form.taDate.value)) {
            alert("收文日期不合法");
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
//98.06.09 顯示勾選的checkbox
function setCheckBox(cb, cbv)
{    
    if(cbv!="")
    {
      cbv2=cbv.split(',');//將帶有逗號的字串轉成陣列
      for(var i=0;i<cb.length;i++)
      {
    	  for(var j=0;j<cbv2.length;j++)
    	  {
    		  if(cbv2[j]==cb[i].value)
    		  {
    			  cb[i].checked=true;
    		  }
    	  }
      }
    }
}
//98.06.09 顯示勾選的checkbox
function setText(t, tv)
{    
	if(tv!="")
	{
		t.value=tv;
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


function checkDuringDate(form,flag) 
{
    //發文查詢日期檢核
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
    //回文日期檢核
    if(flag=="B"||flag=="")
    {
    	if(form.begY1.value == "") {
            alert("開始年不能為空白");
            return false;
        }
        if(form.endY1.value == "") {
            alert("結束年不能為空白");
            return false;
        }
        if(isNaN(Math.abs(form.begY1.value))) {
            alert("開始年一定要輸入數字");
            return false;
        }
        if(isNaN(Math.abs(form.endY1.value))) {
            alert("結束年一定要輸入數字");
            return false;
        }
        form.begDate1.value = '' + (parseInt(form.begY1.value)+1911) + form.begM1.value + form.begD1.value;
        form.endDate1.value = '' + (parseInt(form.endY1.value)+1911) + form.endM1.value + form.endD1.value;;
        
        if(eval(form.endDate1.value) < eval(form.begDate1.value)) {
            alert("開始日期不能小於結束日期");
            return false;
        }    	
    }
    //檢舉書日期檢核
    if(flag=="")
    {
    	if(form.begY2.value == "") {
            alert("開始年不能為空白");
            return false;
        }
        if(form.endY2.value == "") {
            alert("結束年不能為空白");
            return false;
        }
        if(isNaN(Math.abs(form.begY2.value))) {
            alert("開始年一定要輸入數字");
            return false;
        }
        if(isNaN(Math.abs(form.endY2.value))) {
            alert("結束年一定要輸入數字");
            return false;
        }
        form.begDate2.value = '' + (parseInt(form.begY2.value)+1911) + form.begM2.value + form.begD2.value;
        form.endDate2.value = '' + (parseInt(form.endY2.value)+1911) + form.endM2.value + form.endD2.value;;
        
        if(eval(form.endDate2.value) < eval(form.begDate2.value)) {
            alert("開始日期不能小於結束日期");
            return false;
        }    	
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
//受處年分改變==========
function chnageYear(yearNm) {
	//1.修改縣市別
	changeCity("CityXML",yearNm) ;
	//2.修改金融機構
	changeTbank("TBankXML",yearNm);
}
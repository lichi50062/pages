//96.11.14 fix 日期檢查錯誤 by 2295
function doSubmit(form,cmd,id, report,reportno){
    if(cmd == "Qry") {   
        if(checkDuringDate(form)) {
            form.act.value = "Qry";      
            form.submit();
        }
    }else if(cmd == "New") {
        form.act.value = "New";
        form.submit();
    }else if(cmd == "Edit") {
        form.rt_docno.value = id;
        form.sn_docno.value = report;
        form.reportno.value = reportno;
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
        if(!checkInsertData(form)) {
            return ;
        }
        if(confirm("是否修改資料?")) {
            form.act.value = "Update";
            form.submit();
        }
    } else if(cmd == "Delete") {
        if(confirm("是否刪除資料?")) {
            form.act.value = "Delete";
            form.submit();
        }
    }
    return ;
}

function checkInsertData(form) {
    
    if(form.sn_docno.value == "") {
        alert("發文文號不可為空白");
        return false;
    }
    if(form.rt_docno.value == "") {
        alert("回文文號不可為空白");
        return false;
    }
    if(form.receive_docno.value == "") {
        alert("農金局收文文號不可為空白");
        return false;
    }
    if(form.rt_dateY.value == "") {
        alert("回文日期不可為空白"); 
        return false;
    }
    form.rt_date.value = mergeDate(form.rt_dateY.value, form.rt_dateM.value, form.rt_dateD.value);
    
    if(!fnValidDate(form.rt_date.value)) {
       alert("回文日期不合法"); 
        return false;
    }
    // alert(form.rt_date.value);
    if(eval(form.rt_date.value) < eval(form.sn_date.value)) {
        alert("回文日期不可小於上次發文日期 "+toChineseYear(form.sn_date.value));
        return false;    
    } 
    return true;
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
    return dateY+dateM+dateD;  
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
    form.begDate.value = mergeDate(form.begY.value, form.begM.value, form.begD.value);
    form.endDate.value = mergeDate(form.endY.value, form.endM.value, form.endD.value);
    
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

//96.11.14 fix 日期檢查錯誤 
function fnValidDate(dateStr) {
    
    var  leap = 28;
    
    if(leapYear(parseInt(dateStr.substring(0,4))) == true)
         leap = 29;
    
    var mm = parseInt(dateStr.substring(4,6),10);        
    
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
    
    var dd = parseInt(dateStr.substring(6,8),10);   

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

function checkCity() { 
  if(document.getElementById("bankType").value == "6" ||
     document.getElementById("bankType").value == "7" ) {
    document.getElementById("cityType").disabled = false;
  } else {
    document.getElementById("cityType").disabled = true;
  }
}



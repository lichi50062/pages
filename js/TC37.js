function doSubmit(form,cmd,id){
    if(cmd == "Report") {   
        if(checkData(form)) {
            form.act.value = cmd;
            form.submit();
        }
    }
    return ;
}

function checkData(form) {
    
    if(form.yy1.value == "") {
        alert("起年不可為空白");
        return false;
    }
    if(isNaN(Math.abs(form.yy1.value))) {
        alert("起年一定要輸入數字");
        return false;
    }
    if(form.yy2.value == "") {
        alert("迄年不可為空白");
        return false;
    }
    if(isNaN(Math.abs(form.yy2.value))) {
        alert("迄年一定要輸入數字");
        return false;
    }
    
    form.startDate.value = mergeDate(form.yy1.value, form.mm1.value, form.dd1.value);
    form.endDate.value = mergeDate(form.yy2.value, form.mm2.value, form.dd2.value);
    
    if(!fnValidDate(form.startDate.value)) {
       alert("起日期不合法"); 
        return false;
    }
    if(!fnValidDate(form.endDate.value)) {
       alert("迄日期不合法"); 
        return false;
    }
    if(eval(form.endDate.value) < eval(form.startDate.value)) {
        alert("迄日不可小於起日");
        return false;    
    } 
   
    form.duringDate.value = form.yy1.value + " 年 " + form.mm1.value + " 月 " +  form.dd1.value + " 日 至 " +
                            form.yy2.value + " 年 " + form.mm2.value + " 月 " +  form.dd2.value + " 日 " ;
    
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

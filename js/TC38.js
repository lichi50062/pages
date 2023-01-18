function doSubmit(form,cnd){
    if(cnd == "Qry"){
    	form.action="/pages/TC38.jsp?act="+cnd;
    	if(!checkData(form)) return;
    	form.submit();
    }
    if(cnd == "Report"){
    	if(checkData(form)){
    		form.act.value = cnd;
    		form.action="/pages/TC38.jsp?act="+cnd;
           	form.submit();
    	}
    }
    return;
}

//輸入資料檢核處理
function checkData(form){
	form.begDate.value = mergeDate(form.begY.value, form.begM.value, form.begD.value); 
	form.endDate.value = mergeDate(form.endY.value, form.endM.value, form.endD.value);
	
	if(form.begDate.value>form.endDate.value) {
	    alert("使用日期之起始日期不得小於結束日期"); 
	    return false;
	}
	if(!fnValidDate(form.begDate.value)) {
		//alert(form.begDate.value);
	    alert("使用日期不合法(起)"); 
	    return false;
	}
	if(!fnValidDate(form.endDate.value)) {
		//alert(form.endDate.value);
	    alert("使用日期不合法(迄)"); 
	    return false;
	}
	
	d = new Date();
	dateString  = mergeDate(d.getFullYear()-1911, d.getMonth()+1, d.getDate());
	return true;
}

function setSelect(S1, date) {
    if(S1 == null)
    	return;
    for(i=0;i<S1.length;i++) {
      	if(S1.options[i].value==date){
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
/*
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
function leapYear(Year) {
    if (((Year % 4)==0) && ((Year % 100)!=0) || ((Year % 400)==0))
            return (true);
    else
            return (false);
}
*/
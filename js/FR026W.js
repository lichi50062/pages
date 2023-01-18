function doSubmit(cnd,form){
	if((form.tbank.value!='')){
       	form.action = "/pages/FR026W.jsp?act="+cnd;
   		form.submit();
	}else{
  		alert("請選擇一家農漁會");
    }
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
//111.02.22 fix 調整xml取得方式

function doSubmit(form,cnd){	     	    	  	     
	    form.action="/pages/ZZ002W.jsp?act="+cnd+"&test=nothing";	    
	    if(((cnd == "Insert") || (cnd == "Delete"))
	    && (!checkData(form))) return;	   	    
	    
	    if(cnd == "new" || cnd == "del" || cnd == "Qry" || cnd == "newQry" || cnd == "delQry") form.submit();	    	
	    if((cnd == "Insert") && AskInsert(form)) form.submit();	    	    	     	 
	    if((cnd == "Delete") && AskDelete(form)) form.submit();	    
}	

function getData(form,cnd){	     	    	    
	    form.action="/pages/ZZ002W.jsp?act=getData&nowact="+cnd+"&test=nothing";
	    form.submit();	    
}	
	
function checkData(form) 
{	
  var flag = false;  
  for (var i = 0 ; i < form.elements.length; i++) {    
    if ( form.elements[i].checked == true ) {
        flag = true;
    }    
  }
  if (flag == false) {         
    alert('請至少選擇一筆資料!');
    return false;
  }
  return true;
}

function selectAll(form) {  
  for ( var i = 0; i < form.elements.length; i++) {
      if (form.elements[i].type=='checkbox') {	
      	form.elements[i].checked = true;
      }	    
  }
  return;
}

function selectNo(form) {  
  for ( var i = 0; i < form.elements.length; i++) {
      if (form.elements[i].type=='checkbox') {	
      	form.elements[i].checked = false;
      }	    
  }
  return;
}


//111.02.22 fix 調整xml取得方式
function changeOption(){
	
    var xmlDoc = $.parseXML($("xml[id=BankNoListXML]").html()) ;    
    var data = $(xmlDoc).find("data") ;
    var oOption;
    document.UpdateForm.TBANK_NO.length = 0;
      $(data).each(function (i) {      	
     	if ($(this).find("banktype").text() == document.UpdateForm.BANK_TYPE.value)  {
            oOption = document.createElement("OPTION");  			
			oOption.text= $(this).find("bankname").text();
  			oOption.value=$(this).find("bankno").text();
  			document.UpdateForm.TBANK_NO.add(oOption); 
    	}
     	
     })
    ;
}

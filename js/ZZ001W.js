//94.03.25 add 重設密碼時,若暫停='Y',要先解除暫停才能重設密碼
//94.04.08 add 農金局系統管理者前7碼必須與總機構代碼相同
//96.03.22 add 總機構代碼使用XML
//111.02.21 fix 調整xml取得方式

function AskDelete_Permission() {
  if(confirm("確定要刪除嗎(一併刪除此帳號的權限)？"))
    return true;
  else
    return false;
}

function doSubmit(form,cnd,muser_id){	     	    	    
	    form.action="/pages/ZZ001W.jsp?act="+cnd+"&test=nothing";	    
	    if(((cnd == "Insert") || (cnd == "Update") || (cnd == "Delete") )
	    && (!checkData(form,cnd))) return;	    	    	    	    
	    
	    if(cnd == "new" || cnd == "Qry") form.submit();
	    if(cnd == "ResetPwd"){
	       //94.03.25 add 重設密碼時,若暫停='Y',要先解除暫停才能重設密碼
	       if(form.LOCK_MARK.value == 'Y'){
	       	  alert('請先解除暫停,才能執行重設密碼!!');	       	  
	       	  return;
	       }else if(AskResetPwd(form)){	       	  
	       	  form.submit();	    
	       }       	    
	       return;
	    } 
	    
	    if(cnd == "Edit"){
	       form.action="/pages/ZZ001W.jsp?act="+cnd+"&muser_id="+muser_id+"&test=nothing";	    	
	       form.submit();
	    }	
	    if((cnd == "Insert") && AskInsert(form)) form.submit();	    
	    if((cnd == "Update") && AskUpdate(form)) form.submit();	    
	    if((cnd == "Delete") && AskDelete_Permission(form)) form.submit();	    
	    
}	

function getData(form,cnd,item){	     	    
	    if(item == 'bank_type'){
	       form.TBANK_NO.value="";	 
		}	
		if(item == 'tbank_no'){
	       form.BANK_NO.value="";	 
		}
	    form.action="/pages/ZZ001W.jsp?act=getData&nowact="+cnd+"&test=nothing";
	    form.submit();	    
}	
	
function checkData(form,cnd) 
{	
	if (trimString(form.MUSER_ID.value) =="" ){
		alert("使用者帳號不可空白");
		form.MUSER_ID.focus();
		return false;
	}else{	   
	    if((form.BANK_TYPE.value == "2") && (form.MUSER_ID.value.length != 10)){
	       alert("農金局局內使用者帳號，須填入10碼");	
	       form.MUSER_ID.focus();
		   return false;
	    }	
	    if((form.BANK_TYPE.value != "2") && (form.MUSER_ID.value.length != 3) && (cnd != 'Update' && cnd != 'Delete') ){
	       alert("農金局局外使用者帳號，須填入任意3碼");	
	       form.MUSER_ID.focus();
		   return false;
	    }	
	    
	}	
	//alert(form.MUSER_ID.value.substring(0,7));
	//94.04.08 add 農金局系統管理者前7碼必須與總機構代碼相同
	if(form.lguser_id.value == 'A111111111' && 
	   form.lguser_type.value == 'S' && 
	   form.BANK_TYPE.value == '2' && 
	   form.TBANK_NO.value != form.MUSER_ID.value.substring(0,7))
	{
	  	alert("農金局系統管理者前7碼必須與總機構代碼相同!!");
	  	return false;	  	
	}  	
	if (trimString(form.MUSER_NAME.value) =="" ){
		alert("使用者姓名不可空白");
		form.MUSER_NAME.focus();
		return false;
	}		
   return true;
}
//111.02.21 fix 調整xml取得方式
//96.03.22 add 總機構代碼使用XML
function changeOption(){	
	/*111.02.21 fix
    var myXML,bankType,bankNo, bankName;
    myXML = document.all("BankNoListXML").XMLDocument;
    form.TBANK_NO.length = 0;
	bankType = myXML.getElementsByTagName("bankType");
	bankNo = myXML.getElementsByTagName("bankNo");
	bankName = myXML.getElementsByTagName("bankName");
	var oOption;	
	for(var i=0;i<bankType.length ;i++){		
  		if ((bankType.item(i).firstChild.nodeValue == form.BANK_TYPE.value)) {
  			oOption = document.createElement("OPTION");
			oOption.text=bankName.item(i).firstChild.nodeValue;
  			oOption.value=bankNo.item(i).firstChild.nodeValue;
  			form.TBANK_NO.add(oOption);
    	}
    }
    */
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



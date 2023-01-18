//94.03.23 add 營運中/已裁撤 by 2295
function changeOption(form,cnd){
    var myXML,nodeType,nodeType1,nodeValue, nodeName;	
    myXML = document.all("TBankXML").XMLDocument;
    form.BankListSrc.length = 0;    
    BnType = myXML.getElementsByTagName("BnType");    	
	nodeValue = myXML.getElementsByTagName("bankValue");
	nodeName = myXML.getElementsByTagName("bankName");	
	var oOption;
    
	for(var i=0;i<BnType.length ;i++)
	{
		oOption = document.createElement("OPTION");
		if(form.CANCEL_NO.value == 'N'){//營運中
		   if(BnType.item(i).firstChild.nodeValue != '2'){			   	  
		      oOption.text=nodeName.item(i).firstChild.nodeValue;
  		      oOption.value=nodeName.item(i).firstChild.nodeValue;   	    		        		      
		   }		
		}else{//已裁撤
		   if(BnType.item(i).firstChild.nodeValue == '2'){
		      oOption.text=nodeName.item(i).firstChild.nodeValue;
  		      oOption.value=nodeName.item(i).firstChild.nodeValue;   	  
		   }
		}	
		form.BankListSrc.add(oOption);   		
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
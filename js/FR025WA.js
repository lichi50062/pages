//94.03.23 add 營運中/已裁撤 by 2295
function changeOption(form,cnd){
    var myXML,nodeType,nodeType1,nodeValue, nodeName;

    myXML = document.all("BankXML").XMLDocument;
    form.BankListSrc.length = 0;
    if(cnd == 'change') form.BankListDst.length = 0;
    BnType = myXML.getElementsByTagName("BnType");    
	nodeType = myXML.getElementsByTagName("HsienId");
	nodeValue = myXML.getElementsByTagName("bankValue");
	nodeName = myXML.getElementsByTagName("bankName");
	nodeYear = myXML.getElementsByTagName("bankYear");
	var oOption;
    var checkAdd = false;	
    var year = form.S_YEAR.value==''? 99 : eval(form.S_YEAR.value ) ;
	m_year = '' ;
	if(year > 99) {
		m_year = '100' ;
	}else {
		m_year = '99' ;
	}
	//alert('cancel_no='+form.CANCEL_NO.value);
	for(var i=0;i<nodeType.length ;i++)
	{
		if(nodeYear.item(i).firstChild.nodeValue == m_year){
			if(form.cityType.value == 'ALL'){
				oOption = document.createElement("OPTION");
				   if(BnType.item(i).firstChild.nodeValue != '2'){			   	  
				      oOption.text=nodeName.item(i).firstChild.nodeValue;
	  			      oOption.value=nodeValue.item(i).firstChild.nodeValue;   
	  			      oOption.year=nodeYear.item(i).firstChild.nodeValue;
				   }		
				
	  			checkAdd=false;
				for(var k =0;k<form.BankListDst.length;k++){			
					if(form.BankListDst.options[k].text == oOption.text){		    
				   	   checkAdd = true;			       
			    	}   
		    	}
		    	if(checkAdd == false && oOption.text != '' && oOption.value != ''){	  
		    		form.BankListSrc.add(oOption); 
	  			}	
		    }else if (nodeType.item(i).firstChild.nodeValue == form.cityType.value){
	  			oOption = document.createElement("OPTION");
	  		
				   if(BnType.item(i).firstChild.nodeValue != '2'){			   	  
				      oOption.text=nodeName.item(i).firstChild.nodeValue;
	  			      oOption.value=nodeValue.item(i).firstChild.nodeValue;   	
	  			      oOption.year=nodeYear.item(i).firstChild.nodeValue;
				   }		
		
			    
				checkAdd=false;
				for(var k =0;k<form.BankListDst.length;k++){			
					if(form.BankListDst.options[k].text == oOption.text){		    
				   	   checkAdd = true;			       
			    	}   
		    	}
		    	if(checkAdd == false && oOption.text != '' && oOption.value != ''){	       
	  				form.BankListSrc.add(oOption); 
	  			}  			
	    	}
		}
    }
	//removeBankOption() ;
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



function fn_ShowPanel(cnd){
	//act=BankList/RptColumn/RptOrder/RptType	
	this.document.forms[0].action = "/pages/FR025WA.jsp?act="+cnd;	
	//if(cnd == 'createRpt'){
	//   this.document.forms[0].target = '_blank';
	//}else{
	   this.document.forms[0].target = '_self';
    //}
	this.document.forms[0].submit();
}
//99.03.09 add 根據查詢年月.改變縣市別名稱
/*
function changeCity(xml, target, source, form) {
	  if(form.showCityType.value != 'true') return;
      var myXML,nodeType,nodeValue, nodeName,nodeYear,m_year;
      
      m_year = source.value;
      if(m_year >= 100){
         m_year = 100;
      }else{
         m_year = 99;
      }	
      
      target.length = 0;      
      var oOption;
     
      myXML = document.all(xml).XMLDocument;
      nodeType = myXML.getElementsByTagName("cityType");//hsien_id
      nodeYear = myXML.getElementsByTagName("cityYear");//m_year
	  nodeValue = myXML.getElementsByTagName("cityValue");//hsien_id
	  nodeName = myXML.getElementsByTagName("cityName");//hsien_name
		
	  oOption = document.createElement("OPTION");
	  oOption.text='全部';
  	  oOption.value='ALL';
  	  target.add(oOption);		   
	  	
	  //alert('m_year='+m_year);
	  for(var i=0;i<nodeType.length ;i++)	{	  	
  	     if (nodeYear.item(i).firstChild.nodeValue == m_year)  {
  		    oOption = document.createElement("OPTION");
		    oOption.text=nodeName.item(i).firstChild.nodeValue;
  		    oOption.value=nodeValue.item(i).firstChild.nodeValue;
  		    target.add(oOption);
   	     }
      }
      form.HSIEN_ID[0].selected=true;
      changeOption(this.document.forms[0],'') ;
      removeBankOption() ;        
}
*/
/*
function removeBankOption() {
	var year = document.getElementsByName("S_YEAR").value==''? 99 : eval(document.getElementsByName("S_YEAR").value ) ;
	syear = '' ;
	if(year > 99) {
		syear = '100' ;
	}else {
		syear = '99' ;
	}
	var target = document.getElementById("BankListDst");
   	target.length = 0;

}*/
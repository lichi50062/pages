//95.07.23 add  by 2495
//99.04.09 縣市合併問題調整JS by 2808
function hiddenYM(form)
{
	if( form.report_type.value=='2')
	{
		//document.all.Downloadbtn.style.display='block';   
    //form.E_YEAR.style.display = "none"} 
    document.getElementById("cityType").disabled = false; 
    document.getElementById("BankListSrc").disabled = false;
    document.getElementById("BankListDst").disabled = false;     
  }else{
  	
   	document.getElementById("cityType").disabled = true; 
    document.getElementById("BankListSrc").disabled = true;
    document.getElementById("BankListDst").disabled = true;  
  }
  
}
//99.03.09 add 根據查詢年月.改變縣市別名稱
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
      form.cityType[0].selected=true;
      changeOption(this.document.forms[0],'') ;
      //removeBankOption() ;      
}

function changeOption(form,cnd){
	//var target = document.getElementById("BankListDst");
	//target.length = 0;
	
    var myXML,nodeType,nodeType1,nodeValue, nodeName;
    myXML = document.all("TBankXML").XMLDocument;
    form.BankListSrc.length = 0;
    var m_year = this.document.forms[0].S_YEAR.value==''? 99 : eval(this.document.forms[0].S_YEAR.value) ;
    if(m_year >= 100){
       m_year = 100;
    }else{
       m_year = 99;
    }
    if(cnd == 'change') form.BankListDst.length = 0;
    BnType = myXML.getElementsByTagName("BnType");    
	nodeType = myXML.getElementsByTagName("HsienId");
	nodeValue = myXML.getElementsByTagName("bankValue");
	nodeName = myXML.getElementsByTagName("bankName");
	nodeYear = myXML.getElementsByTagName("bankYear");
	var oOption;
    var checkAdd = false;	
	
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
    //removeBankOption();
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



function fn_ShowPanel(form,cnd){
	this.document.forms[0].action = "/pages/FR030WW.jsp?act="+cnd+"&report_type="+form.report_type.value;	  
	this.document.forms[0].target = '_self';
    this.document.forms[0].submit();
}

function checkflag() { 
  if(document.getElementById("rptStyle").value == "0" ) {
    document.getElementById("cityType").disabled = true; 
    document.getElementById("BankListSrc").disabled = true;
    document.getElementById("BankListDst").disabled = true;
    
  } 
  if(document.getElementById("rptStyle").value == "1" ) {
    document.getElementById("cityType").disabled = false;
    document.getElementById("BankListSrc").disabled = false;
    document.getElementById("BankListDst").disabled = false;
  }
}
/*
function removeBankOption() {
	var year = $('input[@name=S_YEAR]').val()==''? 99 : eval($('input[@name=S_YEAR]').val() ) ;
	var target = document.getElementById("BANK_NO");
    var type = '<%=bankType%>';
   	var m_year = form.S_YEAR.value;
   	target.length = 0;
	syear = '' ;
	if(year > 99) {
		syear = '100' ;
	}else {
		syear = '99' ;
	}
	$('select[@name=BankListSrc] > option').each(function(){
		if($(this).attr('year')!=syear) {
			$(this).remove() ;
		}
	});

}*/
//清除以選擇的單位===========
function clearSelectBlock() {
	var target = document.getElementById("BankListDst");
	target.length = 0;
}
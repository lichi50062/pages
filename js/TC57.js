//95.12.08 add 根據所選的金融機構類別/縣市別,顯示總機構單位 by 2295
//95.12.08 add 根據所選的總機構單位,顯示受檢單位 by 2295
function doSubmit(form,cnd,bank_no,subdep_id,muser_id){		 
	     form.action="/pages/TC57.jsp?act="+cnd+"&test=nothing";
	     if(cnd == "new" || cnd == "Qry") form.submit();
	     if(cnd == "Insert" && checkData(form) && AskInsert(form)) form.submit();
	     if(cnd == "Update" && checkData(form) && AskUpdate(form)) form.submit();
	     if(cnd == "Copy" && (hasSelected(form,cnd) == true)){//參照載入
	     	form.submit();
	     }	
	     if(cnd == "Delete" && (hasSelected(form,cnd) == true) && AskDelete(form)){//刪除
	     	form.submit();
	     } 	 
	     if(cnd == "Edit"){//編輯
	     	form.action="/pages/TC57.jsp?act="+cnd+"&BANK_NO="+bank_no+"&SUBDEP_ID="+subdep_id+"&MUSER_ID="+muser_id+"&test=nothing";
	        form.submit();
	     }
	     
	     
}
//95.12.15 add 顯示金融機構類別 by 2295
function changeOption_BankType(form){		
    var myXML,nodeType,nodeType1,nodeValue, nodeName,bankType;    
    form.BANK_TYPE_Src.length = 0;            	
	myXML = document.all("BankTypeXML").XMLDocument;    
	nodeValue = myXML.getElementsByTagName("BankType");
	nodeName = myXML.getElementsByTagName("BankName");
	var oOption;
    var checkAdd = false;	        	
  	for(var i=0;i<nodeValue.length ;i++)
	{	
		oOption = document.createElement("OPTION");  			
		oOption.text=nodeName.item(i).firstChild.nodeValue;
  		oOption.value=nodeValue.item(i).firstChild.nodeValue;   	  						      		
  		
		checkAdd=false;
		for(var k =0;k<form.BANK_TYPE.length;k++){			
			if(form.BANK_TYPE.options[k].text == oOption.text){		    
				checkAdd = true;			       
		   	}   		   		
	    }
	    	    
	    if(checkAdd == false && oOption.text != '' && oOption.value != ''){	       
  		   form.BANK_TYPE_Src.add(oOption); 
  		}  			    	           	  		        
    }
    
}

//95.12.08 add 根據所選的金融機構類別,顯示縣市別 by 2295
function changeOption_HsienID(form){		
    var myXML,nodeType,nodeType1,nodeValue, nodeName,bankType;
    myXML = document.all("HsienIDXML").XMLDocument;
    form.HSIEN_ID_Src.length = 0;            	
	nodeValue = myXML.getElementsByTagName("HsienId");
	nodeName = myXML.getElementsByTagName("HsienName");
	var oOption;
    var checkAdd = false;	        
  	//alert('金融機構類別:'+form.BANK_TYPE.length);
	for(var i=0;i<nodeValue.length ;i++)
	{	    
		checkAdd = false;
	    for(var k =0;k<form.BANK_TYPE.length;k++){				  	    	
			if(form.BANK_TYPE.options[k].value == '6' || form.BANK_TYPE.options[k].value == '7'){			   			   
			   checkAdd = true;//所選的金融機構類別屬於農.漁會
		    } 							    				
		}	    
		if(!checkAdd) continue;//不屬於選的金融機構類別		
		
		oOption = document.createElement("OPTION");  			
		oOption.text=nodeName.item(i).firstChild.nodeValue;
  		oOption.value=nodeValue.item(i).firstChild.nodeValue;   	  						      		
  		//alert(oOption.text);
  		//alert(oOption.value);
		checkAdd=false;
		for(var k =0;k<form.HSIEN_ID_Src.length;k++){			
			if(form.HSIEN_ID_Src.options[k].text == oOption.text){		    
				checkAdd = true;			       
		   	}   		   		
	    }
	    for(var k1 =0;k1<form.HSIEN_ID.length;k1++){			
			if(form.HSIEN_ID.options[k1].text == oOption.text){		    
				checkAdd = true;			       
		   	}   		   		
	    }	    
	    if(checkAdd == false && oOption.text != '' && oOption.value != ''){	       
  		   form.HSIEN_ID_Src.add(oOption); 
  		}  			    	           	  		        
    }    
    if(form.BANK_TYPE.length == 0){//95.12.18若已選的金融機構類別為空值時,清空縣市別.總機構單位.受檢單位
       form.HSIEN_ID_Src.length = 0;
       form.HSIEN_ID.length = 0;
       form.TBANK_NO_Src.length = 0;
       form.TBANK_NO.length = 0;
       form.EXAMINE_Src.length = 0;        
       form.EXAMINE.length = 0;        
    }	
}

//95.12.08 add 根據所選的金融機構類別/縣市別,顯示總機構單位 by 2295
function changeOption_TBankNO(form){			
    var myXML,nodeType,nodeType1,nodeValue, nodeName,bankType;
    myXML = document.all("TBankXML").XMLDocument;
    form.TBANK_NO_Src.length = 0;        
    bankType = myXML.getElementsByTagName("BankType");    
	nodeType = myXML.getElementsByTagName("HsienId");
	nodeValue = myXML.getElementsByTagName("bankValue");
	nodeName = myXML.getElementsByTagName("bankName");
	var oOption;
    var checkAdd = false;	        
  	//alert('縣市別'+form.HSIEN_ID.length);
	for(var i=0;i<nodeType.length ;i++)
	{
	    checkAdd = false;
	    for(var k =0;k<form.BANK_TYPE.length;k++){				  
			if(form.BANK_TYPE.options[k].value == bankType.item(i).firstChild.nodeValue){
			   if(bankType.item(i).firstChild.nodeValue == '1' || bankType.item(i).firstChild.nodeValue == '8'){
			   	  //屬於全國農業金庫.農漁會共用中心,直接add到總機構單位
			   	  oOption = document.createElement("OPTION");  			
			      oOption.text=nodeName.item(i).firstChild.nodeValue;
  			      oOption.value=nodeValue.item(i).firstChild.nodeValue;   	  						      		
			      checkAdd=false;
			      for(var k2 =0;k2<form.TBANK_NO_Src.length;k2++){			
				      if(form.TBANK_NO_Src.options[k2].text == oOption.text){		    
 			   	        checkAdd = true;			       
		    	      }   
	    	      }
	    	      for(var k1 =0;k1<form.TBANK_NO.length;k1++){			
				      if(form.TBANK_NO.options[k1].text == oOption.text){		    
 			   	        checkAdd = true;			       
		    	      }   
	    	      }
	    	      if(checkAdd == false && oOption.text != '' && oOption.value != ''){	       
  				     form.TBANK_NO_Src.add(oOption); 
  			      }  						   	  
			   }	 
			   checkAdd = true;//屬於所選的金融機構類別	
		    } 							    				
		}	    
		if(!checkAdd) continue;//不屬於選的金融機構類別		
		
		for(var k3 =0;k3<form.HSIEN_ID.length;k3++){//金融機構類別屬於農.漁會時判斷是否屬於所選的縣市別					
			//alert(nodeType.item(i).firstChild.nodeValue);
			//alert(form.BANK_TYPE.options[k1].value);
		    if (nodeType.item(i).firstChild.nodeValue == form.HSIEN_ID.options[k3].value){	    	  		
  			    oOption = document.createElement("OPTION");  			
			    oOption.text=nodeName.item(i).firstChild.nodeValue;
  			    oOption.value=nodeValue.item(i).firstChild.nodeValue;   	  						      		
			    checkAdd=false;
			    for(var k4 =0;k4<form.TBANK_NO_Src.length;k4++){			
				    if(form.TBANK_NO_Src.options[k4].text == oOption.text){		    
 			   	      checkAdd = true;			       
		    	    }   
	    	    }
	    	    for(var k5 =0;k5<form.TBANK_NO.length;k5++){			
				    if(form.TBANK_NO.options[k5].text == oOption.text){		    
 			   	      checkAdd = true;			       
		    	    }   
	    	    }
	    	    if(checkAdd == false && oOption.text != '' && oOption.value != ''){	       
  				   form.TBANK_NO_Src.add(oOption); 
  			    }  			
    	    }       	  		
        }
    }
    if(form.BANK_TYPE.length == 0){//95.12.18若已選的金融機構類別為空值時,清空總機構單位.受檢單位       
       form.TBANK_NO_Src.length = 0;
       form.TBANK_NO.length = 0;
       form.EXAMINE_Src.length = 0;        
       form.EXAMINE.length = 0;        
    }	
    /*
    if(form.TBANK_NO_Src.length == 0){
       form.TBANK_NO.length = 0;
    }*/	
}

//95.12.08 add 根據所選的總機構單位,顯示受檢單位 by 2295
function changeOption_BankNO(form){			
    var myXML,nodeType,nodeType1,nodeValue, nodeName,bankType;
    myXML = document.all("BankXML").XMLDocument;
    form.EXAMINE_Src.length = 0;        
    bankType = myXML.getElementsByTagName("BankType");    
    hsienId = myXML.getElementsByTagName("HsienId");    
	nodeType = myXML.getElementsByTagName("PBankNo");
	nodeValue = myXML.getElementsByTagName("bankValue");
	nodeName = myXML.getElementsByTagName("bankName");
	var oOption;
    var checkAdd = false;	        
  	//alert('總機構單位'+form.TBANK_NO.length);
	for(var i=0;i<nodeType.length ;i++)
	{
		for(var k1 =0;k1<form.TBANK_NO.length;k1++){//判斷是否屬於所選的總機構單位					
			//alert('PBankNO='+nodeType.item(i).firstChild.nodeValue);
			//alert('TBankNo='+form.TBANK_NO.options[k1].value);
		    if (nodeType.item(i).firstChild.nodeValue == form.TBANK_NO.options[k1].value){	    	  		
  			    oOption = document.createElement("OPTION");  			
			    oOption.text=nodeName.item(i).firstChild.nodeValue;
  			    //oOption.value=nodeValue.item(i).firstChild.nodeValue;   	  						      		  			    
  			    oOption.value=bankType.item(i).firstChild.nodeValue+":"+hsienId.item(i).firstChild.nodeValue+":"+nodeType.item(i).firstChild.nodeValue+":"+nodeValue.item(i).firstChild.nodeValue;   	  						      		
  			    //alert("oPtion.value="+oOption.value);		       	  						      		
			    checkAdd=false;
			    for(var k =0;k<form.EXAMINE_Src.length;k++){			
				    if(form.EXAMINE_Src.options[k].text == oOption.text){		    
 			   	      checkAdd = true;			       
		    	    }   
	    	    }
	    	    
	    	    for(var j =0;j<form.EXAMINE.length;j++){			
				    if(form.EXAMINE.options[j].text == oOption.text){		    
 			   	      checkAdd = true;			       
		    	    }   
	    	    }
	    	    if(checkAdd == false && oOption.text != '' && oOption.value != ''){	       
  				   form.EXAMINE_Src.add(oOption); 
  			    }  			
    	    }       	  		
        }
    }
    
    if(form.TBANK_NO.length == 0){
       form.EXAMINE.length = 0;
    }    
}

//95.12.08 add 根據所選的組室代號/科別代號,顯示員工代碼 by 2295
function changeOption_MuserID(form,act){			
    var myXML,bank_no,subdep_id,muser_id, muser_name;
    myXML = document.all("MuserIDXML").XMLDocument;
    form.MUSER_ID.length = 0;        
    bank_no = myXML.getElementsByTagName("bank_no");    
    subdep_id = myXML.getElementsByTagName("subdep_id");    
	muser_id = myXML.getElementsByTagName("muser_id");
	muser_name = myXML.getElementsByTagName("muser_name");	
	var oOption;
    var checkAdd = false;	        
  	if(act == "List" || act == "Qry"){
  		oOption = document.createElement("OPTION");  			
		oOption.text="全部";
  		oOption.value="";   	  						      		  			      			    
  		form.MUSER_ID.add(oOption); 
    }	
    
	for(var i=0;i<bank_no.length ;i++)
	{
		if(((bank_no.item(i).firstChild.nodeValue == form.BANK_NO.value) 
		     &&(subdep_id.item(i).firstChild.nodeValue == form.SUBDEP_ID.value))
		|| (form.BANK_NO.value == '' &&  form.SUBDEP_ID.value == ''))
		{	    	  		
  			oOption = document.createElement("OPTION");  			
			oOption.text=muser_name.item(i).firstChild.nodeValue;
  			oOption.value=muser_id.item(i).firstChild.nodeValue;   	  						      		  			      			    
  			//alert("oOption.value="+oOption.value);		       	  						      		
			checkAdd=false;
			for(var k =0;k<form.MUSER_ID.length;k++){			
			    if(form.MUSER_ID.options[k].text == oOption.text){		    
 			 	   checkAdd = true;			       
		    	}   
	    	}
	    	if(checkAdd == false && oOption.text != '' && oOption.value != ''){	       
  			   form.MUSER_ID.add(oOption); 
  			}  			    	          	  		
        }
    }
}

//=====================================================================
//將所有的ListDst中的item放到hidden button(value+text,value+text)
//=====================================================================
function MoveSelectToBtn(btn, ListDst)
{
	btn.value = '';
	for (var i =0; i < ListDst.options.length; i++){
		if (i == 0)
			btn.value = ListDst.options[i].value;
		else
			btn.value = btn.value + ',' + ListDst.options[i].value;
	}	
	//alert(btn.value);
}

function hasSelected(form,act)
{
  var flag = false;  
  var selectCount=0;
 
  for (var i = 0 ; i < form.elements.length; i++) {        
   	if(form.elements[i].type=='checkbox' && form.elements[i].checked == true) {	      	
   		selectCount++;
        flag = true;
    }    
  }
  if (flag == false) {     
  	if(act == "Copy"){    
       alert('請至少選擇一筆欲參照/載入的資料!');
    }else if(act == "Delete"){    
       alert('請至少選擇一筆欲刪除的資料!');
    }
    return false;
  }
  if(selectCount > 1 && act == "Copy"){
  	 alert('最多只能選擇一筆欲參照/載入的資料!');
     return false;
  }  
  return true;
}  
function checkData(form){
	if(trim(form.MUSER_ID.value) == ''){
	   alert('員工代碼不可為空白');	 
	   return false;
    } 	
    if(form.EXAMINE.length == 0){
       alert('受檢單位不可為空白');
       return false;
    }	
    return true;
}	
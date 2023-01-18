//96.01.08 fix changeCity若金融機構類別為全國農業金庫.共用中心時,直接顯示總機構單位 by 2295
//96.01.12 fix 若為全國農業金庫.農漁會共用中心時,縣市別顯示成全部 by 2295   
//96.01.15 fix 若金融機構類別為全國農業金庫.共用中心時,直接顯示總機構單位 for 總機構+受檢單位合併顯示  by 2295
//96.03.13 fix 若農/漁會且機構的縣市別為'-',不加入受檢單位 by 2295  	    	
function changeOption(xml, target, source, xml_bk){
    var myXML,nodeType,nodeValue, nodeName;
    
    target.length = 0;
    var oOption;
    oOption = document.createElement("OPTION");
	oOption.text="全部";
  	oOption.value="";
  	target.add(oOption);
  	//加入總機構代號至受檢單位========================================================================================
  	myXML = document.all(xml_bk).XMLDocument;
    nodeType = myXML.getElementsByTagName("bankType");
	nodeValue = myXML.getElementsByTagName("bankValue");
	nodeName = myXML.getElementsByTagName("bankName");
	bankCity = myXML.getElementsByTagName("bankCity");
	for(var i=0;i<nodeType.length ;i++)	{		
  	    if ((nodeValue.item(i).firstChild.nodeValue == source.value))  {
  	    	//96.03.13 fix 若農/漁會且機構的縣市別為'-',不加入受檢單位
  	    	//             wtt08.hsien_id='-'為該機構基本資料尚未輸入
  	    	if((nodeType.item(i).firstChild.nodeValue == '6' || nodeType.item(i).firstChild.nodeValue == '7')
  	    	&& (bankCity.item(i).firstChild.nodeValue != '-')){
  		       oOption = document.createElement("OPTION");
		       oOption.text=nodeName.item(i).firstChild.nodeValue;
  		       oOption.value=nodeValue.item(i).firstChild.nodeValue;
  		       target.add(oOption);
  		       //alert(bankCity.item(i).firstChild.nodeValue);
  		       //alert(oOption.text);
  		       //alert(oOption.value);
  		    }  		    
   	    }
    }
    //加入分支機構代號至受檢單位=====================================================================================
    myXML = document.all(xml).XMLDocument;
	nodeType = myXML.getElementsByTagName("bankType");
	nodeValue = myXML.getElementsByTagName("bankValue");
	nodeName = myXML.getElementsByTagName("bankName");
	
	for(var i=0;i<nodeType.length ;i++)	{
	   
  		if ((nodeType.item(i).firstChild.nodeValue == source.value))  {
  			oOption = document.createElement("OPTION");
			oOption.text=nodeName.item(i).firstChild.nodeValue;
  			oOption.value=nodeValue.item(i).firstChild.nodeValue;
  			target.add(oOption);
    	}
    }
    //================================================================================================================
    
    if(target.length < 3 && source.value != 1) {

        myXML = document.all(xml_bk).XMLDocument;
        target.length = 0;
     	nodeType = myXML.getElementsByTagName("bankType");
	    nodeValue = myXML.getElementsByTagName("bankValue");
	    nodeName = myXML.getElementsByTagName("bankName");

	    for(var i=0;i<nodeType.length ;i++)	{
  		    if ((nodeValue.item(i).firstChild.nodeValue == source.value))  {
  			    oOption = document.createElement("OPTION");
			    oOption.text=nodeName.item(i).firstChild.nodeValue;
  			    oOption.value=nodeValue.item(i).firstChild.nodeValue;
  			    target.add(oOption);
    	    }
        }
        if(source.value == "" || source.value == "0") {
    	        oOption = document.createElement("OPTION");
			    oOption.text="全部";
  			    oOption.value="";
  			    target.add(oOption);
  	    }
        
    } 
    
}

function resetOption() {
    var s1 = document.getElementById("tbank");
    var s2 = document.getElementById("examine");
    s1.length = 0;
    s2.length = 0;
      
    oOption = document.createElement("OPTION");
	oOption.text="全部";
  	oOption.value="";	
  	s1.add(oOption);
  	oOption = document.createElement("OPTION");
	oOption.text="全部";
  	oOption.value="";	
  	s2.add(oOption);
}
//96.01.08 fix 若金融機構類別為全國農業金庫.共用中心時,直接顯示總機構單位 by 2295
function changeCity(xml, target, source, form) {	
    var myXML,nodeType,nodeValue, nodeName,nodeCity;    
    unit = form.bankType.value;
    //alert('changeCity1='+unit);
    if( unit == "6" || unit == "7" ||  unit == "1" || unit == "8") {  
      var s2 = document.getElementById("examine");
      s2.length = 0;
      var oOption;
      oOption = document.createElement("OPTION");
	  oOption.text="全部";
  	  oOption.value="";
  	  s2.add(oOption);
      target.length = 0;
      var oOption;
      oOption = document.createElement("OPTION");
	  oOption.text="全部";
  	  oOption.value="";
  	  target.add(oOption); 
      myXML = document.all(xml).XMLDocument;
      nodeType = myXML.getElementsByTagName("bankType");
      nodeCity = myXML.getElementsByTagName("bankCity");
	  nodeValue = myXML.getElementsByTagName("bankValue");
	  nodeName = myXML.getElementsByTagName("bankName");
	
	  for(var i=0;i<nodeType.length ;i++)	{		  	
  	      if((unit == "6" || unit == "7") && //農.漁會 
  	         ((nodeCity.item(i).firstChild.nodeValue == source.value) &&
  	          (nodeType.item(i).firstChild.nodeValue == unit) ) ) {
  		       oOption = document.createElement("OPTION");
		       oOption.text=nodeName.item(i).firstChild.nodeValue;
  		       oOption.value=nodeValue.item(i).firstChild.nodeValue;
  		       target.add(oOption);
   	      }else if((unit == "1" || unit == "8") //全國農業金庫.共用中心
   	            && (nodeType.item(i).firstChild.nodeValue == unit)) {
   	      	   oOption = document.createElement("OPTION");
		       oOption.text=nodeName.item(i).firstChild.nodeValue;
  		       oOption.value=nodeValue.item(i).firstChild.nodeValue;
   		       target.add(oOption);
   		  }
      }
    }else {	
      setSelect(source, "");
    }
    //alert('changeCity2='+unit);
}

function checkCity() { 	  
  if(document.getElementById("bankType").value == "6" ||
     document.getElementById("bankType").value == "7" ) {
     document.getElementById("cityType").disabled = false;
  } else {
    document.getElementById("cityType").disabled = true;
  }  	  
}

//根據金融機構類別change縣市別代碼
//96.01.12 fix 若為全國農業金庫.農漁會共用中心時,縣市別顯示成全部 by 2295   
function changeHsienID(xml, target, source, form) {		
    var myXML,nodeType,nodeName,nodeCity,found;
    unit = form.bankType.value;    
    //alert('changeHsienID1='+unit);
    target.length = 0;      
    if( unit == "6" || unit == "7") {            	      
      var oOption;
      oOption = document.createElement("OPTION");	 
      myXML = document.all(xml).XMLDocument;
      nodeType = myXML.getElementsByTagName("bankType");
      nodeCity = myXML.getElementsByTagName("bankCity");	  
	  nodeName = myXML.getElementsByTagName("bankName");	  
	  for(var i=0;i<nodeType.length ;i++){
	  	//alert(nodeCity.item(i).firstChild.nodeValue);
	  	//alert('source.value='+source.value);
  	    if (nodeType.item(i).firstChild.nodeValue == source.value){
  		    oOption = document.createElement("OPTION");
		    oOption.text=nodeName.item(i).firstChild.nodeValue;
  		    oOption.value=nodeCity.item(i).firstChild.nodeValue;
  		    target.add(oOption);  		    		    
		}	    
      }
    } else {//96.01.12 fix 若為全國農業金庫.農漁會共用中心時,縣市別顯示成全部 by 2295    
      var oOption;
      oOption = document.createElement("OPTION");
	  oOption.text="全部";
  	  oOption.value="";
  	  target.add(oOption);  	      
      //setSelect(source, "");      
    }        
}

function setSelect(S1, bankid) {
    if(S1 == null)
    	return;
    for(i=0;i<S1.length;i++) {        
      	if(S1.options[i].value==bankid)	{
        	S1.options[i].selected=true;
        	break;
    	}
    }
}


//96.01.15 fix 若金融機構類別為全國農業金庫.共用中心時,直接顯示總機構單位 for 總機構+受檢單位合併顯示  by 2295
function changeCity_bankno(xml,xml_examine ,target, source, form) {	
    var myXML,nodeType,nodeValue, nodeName,nodeCity;    
    unit = form.bankType.value;
    var examineXML;
    var nodeType1,nodeValue1, nodeName1;        
    //alert('changeCity1='+unit);
    if( unit == "6" || unit == "7" ||  unit == "1" || unit == "8") {  
      var s2 = document.getElementById("tbank");
      s2.length = 0;
      var oOption;
      oOption = document.createElement("OPTION");
	  oOption.text="全部";
  	  oOption.value="";
  	  s2.add(oOption);
      target.length = 0;
      var oOption;
      oOption = document.createElement("OPTION");
	  oOption.text="全部";
  	  oOption.value="";
  	  target.add(oOption); 
      myXML = document.all(xml).XMLDocument;
      nodeType = myXML.getElementsByTagName("bankType");
      nodeCity = myXML.getElementsByTagName("bankCity");
	  nodeValue = myXML.getElementsByTagName("bankValue");
	  nodeName = myXML.getElementsByTagName("bankName");
	  
	  //受檢單位
	  examineXML = document.all(xml_examine).XMLDocument;
	  nodeType1 = examineXML.getElementsByTagName("bankType");      
	  nodeValue1 = examineXML.getElementsByTagName("bankValue");
	  nodeName1 = examineXML.getElementsByTagName("bankName");
	  
	  var tbank_no;
	  for(var i=0;i<nodeType.length ;i++)	{		  	
  	      if((unit == "6" || unit == "7") && //農.漁會 
  	         ((nodeCity.item(i).firstChild.nodeValue == source.value) &&
  	          (nodeType.item(i).firstChild.nodeValue == unit) ) ) {
  		       oOption = document.createElement("OPTION");
		       oOption.text=nodeName.item(i).firstChild.nodeValue;
  		       oOption.value=nodeValue.item(i).firstChild.nodeValue;  		       
  		       target.add(oOption);
  		       //96.01.15 add 把受檢單位也加到金融機構裡(總機構+分支機構)
  		       //alert(nodeType1.length);  		       
  		       tbank_no = nodeValue.item(i).firstChild.nodeValue;
  		       //alert('tbank='+tbank_no);	
  		       for(var j=0;j<nodeType1.length ;j++)	{	
  		       	   //alert('examine:j='+j+'='+nodeType1.item(j).firstChild.nodeValue+':');	    		       	     		       	   
  		       	   if(nodeType1.item(j).firstChild.nodeValue == tbank_no ){  		       	   	  
  		       	   	  oOption = document.createElement("OPTION");
		       		  oOption.text=nodeName1.item(j).firstChild.nodeValue;
  		       		  oOption.value=nodeValue1.item(j).firstChild.nodeValue;  		       
  		       		  target.add(oOption);
  		       	   }
  		       }
  		       //========================================================
   	      }else if((unit == "1" || unit == "8") //全國農業金庫.共用中心
   	            && (nodeType.item(i).firstChild.nodeValue == unit)) {
   	      	   oOption = document.createElement("OPTION");
		       oOption.text=nodeName.item(i).firstChild.nodeValue;
  		       oOption.value=nodeValue.item(i).firstChild.nodeValue;
   		       target.add(oOption);
   		  }
      }
    }else {	
      setSelect(source, "");
    }
    //alert('changeCity2='+unit);
}

function resetOption_bankno() {	
    var s1 = document.getElementById("tbank");    
    s1.length = 0;
    oOption = document.createElement("OPTION");
	oOption.text="全部";
  	oOption.value="";	
  	s1.add(oOption);   	
}
<!--判斷是否有縣市別-->
function checkCity() { 
  if(document.getElementById("bankType").value == "6" ||
     document.getElementById("bankType").value == "7" ) {
     document.getElementById("cityType").disabled = false;
  } else {
    document.getElementById("cityType").disabled = true;
    document.getElementById("cityType").value = "";
  }
}

function resetOption() {
    var s1 = document.getElementById("tbank");
    s1.length = 0;
      
    oOption = document.createElement("OPTION");
	oOption.text="全部";
  	oOption.value="";	
  	s1.add(oOption);
}

function changeOption(xml, target, source, xml_bk){
    var myXML,nodeType,nodeValue, nodeName;
      
    target.length = 0;
    var oOption;
    oOption = document.createElement("OPTION");
	oOption.text="全部";
  	oOption.value="";
  	target.add(oOption);
  	
  	myXML = document.all(xml_bk).XMLDocument;
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
}

function changeCity2(xml, target, source, form) {
	var myXML,nodeType,nodeValue, nodeName,nodeCity;
	unit = form.bankType.value;
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
		if ((((nodeCity.item(i).firstChild.nodeValue == source.value) || source.value=="") && 
			(nodeType.item(i).firstChild.nodeValue == unit)) ||
			(unit == "" && (nodeCity.item(i).firstChild.nodeValue == source.value)) || 
			(unit == "" && source.value==""))  {
				oOption = document.createElement("OPTION");
				oOption.text=nodeName.item(i).firstChild.nodeValue;
				oOption.value=nodeValue.item(i).firstChild.nodeValue;
				target.add(oOption);
		}
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



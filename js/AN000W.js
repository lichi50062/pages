function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function changeCity(xml, target, source, form) {
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
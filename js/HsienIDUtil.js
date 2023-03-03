//99.03.09 add 根據查詢年度.縣市別.改變總機構名稱
//99.04.07 add 設定是否顯示縣市別/總機構單位 by 2295
//99.04.08 add 縣市別=全部/縣市別=單一縣市
//             營運中/已裁撤選項 by 2295
function changeTbank(xml, target, source, form) {
	console.log('tbankl');
	if(form.showTbank.value != 'true') return;
    var myXML,nodeType,nodeValue, nodeName,nodeCity,nodeYear;
    var oOption;    
    var unit = document.form.bankType.value;
    var m_year = document.form.S_YEAR.value;
	console.log('m_year',m_year);
    if(m_year >= 100){
       m_year = 100;
    }else{
       m_year = 99;
    }
	var xmlDoc = $.parseXML($("xml[id=TBankXML]").html()) ;
	var data = $(xmlDoc).find("data") ;
	document.form.tbank.length = 0;


	$(data).each(function (i) {
	   if(($(this).find("bankYear").text() == m_year) &&
  	      ($(this).find("bankType").text() == unit) )  {//相同年度.農/漁會
  	       //1.縣市別=全部 2.縣市別=單一縣市
	       if(document.form.cityType.value == 'ALL' || ($(this).find("bankCity").text() == source.value)){
	           oOption = document.createElement("OPTION");
	           if(document.form.showCancel_No.value == 'true'){//有區分營運中/已裁撤
	       	      if(document.form.CANCEL_NO.value == 'N'){//營運中
			         if($(this).find("BnType").text() != '2'){
			            oOption.text=$(this).find("bankName").text();
  			            oOption.value=$(this).find("bankValue").text();
			         }		
		          }else{//已裁撤		    
		             if($(this).find("BnType").text() == '2'){
			            oOption.text=$(this).find("bankName").text();
  			            oOption.value=$(this).find("bankValue").text();
			         }
		          }
		       }else{//無區分營運中/已裁撤
		          oOption.text=$(this).find("bankName").text();
  			      oOption.value=$(this).find("bankValue").text();
		       }
			   document.form.tbank.add(oOption);
  	       } 
   	    }
    })
}

//99.03.09 add 根據查詢年月.改變縣市別名稱
function changeCity(xml, target, source, form) {
	  if(document.form.showCityType.value != 'true') return;

      var m_year = source.value;
	console.log('m_year' + m_year);
      if(m_year >= 100){
         m_year = 100;
      }else{
         m_year = 99;
      }

	var xmlDoc = $.parseXML($("xml[id=CityXML]").html()) ;
	document.form.cityType.length = 0;
	var data = $(xmlDoc).find("data") ;
	var oOption = document.createElement("OPTION");
	oOption.text="全部";
	oOption.value="";
	document.form.cityType.add(oOption);


	$(data).each(function (i) {
		if($(this).find("cityyear").text()==m_year) {
			oOption = document.createElement("OPTION");
			oOption.text= $(this).find("cityname").text();
			oOption.value=$(this).find("cityvalue").text();
			document.form.cityType.add(oOption);
		}
	})
	;
      document.form.cityType[0].selected=true;
      if(form.showTbank.value == 'true') changeTbank('TBankXML', form.tbank, form.cityType, form);     
}

<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
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
//-->
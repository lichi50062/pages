//111.02.17 fix changeOption調整xml取得方式       

function doSubmit(form,cnd){	   
	     if(!CheckQueryDate2(document.UpdateForm.S_YEAR,document.UpdateForm.S_MONTH,document.UpdateForm.S_DATE,"起始日期")) return false;
         if(!CheckQueryDate2(document.UpdateForm.E_YEAR,document.UpdateForm.E_MONTH,document.UpdateForm.E_DATE,"結束日期")) return false;     
	     if(trimString(document.UpdateForm.S_DATE.value)!="" && trimString(document.UpdateForm.E_DATE.value)!=""){
		    if(Math.abs(document.UpdateForm.S_DATE.value) > Math.abs(document.UpdateForm.E_DATE.value)){
    		   alert("起始查詢年月不可大於結束查詢年月");
    		   return false;
    	    }
    	 }   
    	 	  	     
	    document.UpdateForm.action="/pages/ZZ042W.jsp?act="+cnd+"&test=nothing";	    
	    if((cnd == 'MultiFiles') && !checkSelect(document.UpdateForm)){
	       return;	 
	    }	
	    document.UpdateForm.submit();	    		    
}	

	
function checkSelect(form) 
{	
  var flag = false;  
  for (var i = 0 ; i < form.elements.length; i++) {    
    if ( form.elements[i].checked == true ) {
        flag = true;
    }    
  }
  if (flag == false) {       	
      alert('請至少選擇一筆欲下載的報表!');        	   
      return false;
  }
  return true;
}	

function selectAll(form) {  
  for ( var i = 0; i < form.elements.length; i++) {
      if((form.elements[i].type=='checkbox') && form.elements[i].disabled == false) {	
      	form.elements[i].checked = true;
      }	          	  
  }
  return;
}

function selectNo(form) {  
  for ( var i = 0; i < form.elements.length; i++) {
       if((form.elements[i].type=='checkbox') && form.elements[i].disabled == false) {	
      	 form.elements[i].checked = false;
       }	           
  }
  return;
}

/*
農(漁)會別 -->rpt_output_type == 'X',顯示農會/漁會/農漁會 
              rpt_output_type == 'T',顯示農漁會 
縣市別 -->rpt_output_type == 'T',顯示"全部縣市"          
          rpt_include <> 'X',顯示"全部縣市"
          其他,顯示"全部縣市"及各個縣市別
111.02.17 fix 調整xml取得方式                 
*/
function changeOption(){	
	/*111.02.17 fix
    var myXML,hsienXML,rptCode,rptOutputType, rptInclude;
    //alert(form.RPT_CODE.value);
    myXML = document.all("ReportListXML").XMLDocument;    
    form.RPT_OUTPUT_TYPE.length = 0;
    form.HSIEN_ID.length = 0;
    form.RPT_SORT.length = 0;
	rptCode = myXML.getElementsByTagName("rptCode");
	rptOutputType = myXML.getElementsByTagName("rptOutputType");
	rptInclude = myXML.getElementsByTagName("rptInclude");
	hsienXML = document.all("hsienListXML").XMLDocument;
	hsien_id = hsienXML.getElementsByTagName("hsien_id");
	hsien_name = hsienXML.getElementsByTagName("hsien_name");
	var oOption;	
	for(var i=0;i<rptCode.length ;i++)
	{		
		//alert(rptCode.item(i).firstChild.nodeValue);  
  		if ((rptCode.item(i).firstChild.nodeValue == form.RPT_CODE.value))  {  			
  			//農(漁)會別
  			if ((rptOutputType.item(i).firstChild.nodeValue == 'X'))  {//顯示農會/漁會/農漁會  				  				 
  				 oOption = document.createElement("OPTION");
			     oOption.text="農會";
  			     oOption.value="6";  			     
  			     form.RPT_OUTPUT_TYPE.add(oOption);
  			     oOption = document.createElement("OPTION");
  			     oOption.text="漁會";
  			     oOption.value="7";
  			     form.RPT_OUTPUT_TYPE.add(oOption);
  			     oOption = document.createElement("OPTION");
  			     oOption.text="農漁會";
  			     oOption.value="ALL";
  			     form.RPT_OUTPUT_TYPE.add(oOption);
  		    }else if ((rptOutputType.item(i).firstChild.nodeValue == 'T'))  {//顯示農漁會  				  		    	 
  		    	 oOption = document.createElement("OPTION");
  		    	 oOption.text="農漁會";
  			     oOption.value="ALL";
  			     form.RPT_OUTPUT_TYPE.add(oOption);
  			     
  		    }   		    
  		    //縣市別
  		    if ((rptOutputType.item(i).firstChild.nodeValue == 'T'))  {
  		    	 //alert('rptouttype==T');
  			     //rpt_output_type = 'T',顯示"全部縣市"
  			     oOption = document.createElement("OPTION");
  		    	 oOption.text="全部縣市";
  			     oOption.value="ALL";
  			     form.HSIEN_ID.add(oOption);
  		    }else  if ((rptInclude.item(i).firstChild.nodeValue != 'X'))  {
  		    	 //alert('rptInclude !=X');
  		    	 //rpt_include <> 'X',顯示"全部縣市"
  			     oOption = document.createElement("OPTION");
  		    	 oOption.text="全部縣市";
  			     oOption.value="ALL";
  			     form.HSIEN_ID.add(oOption);
  		    }else{
  		    	 //alert('rptInclude ==X rptouttype!=T');
  		    	 oOption = document.createElement("OPTION");
  		    	 oOption.text="全部縣市";
  			     oOption.value="ALL";
  			     form.HSIEN_ID.add(oOption);
  			     //各個縣市別
  		    	 for(var j=0;j<hsien_id.length ;j++){
  		    	     oOption = document.createElement("OPTION");
  		    	     oOption.text=hsien_name.item(j).firstChild.nodeValue;
  			         oOption.value=hsien_id.item(j).firstChild.nodeValue;
  			         form.HSIEN_ID.add(oOption);
  		    	 }
  		    }		
  		    //列表順序
  		    if ((rptInclude.item(i).firstChild.nodeValue == 'T'))  {  		    	 
  			     oOption = document.createElement("OPTION");
  		    	 oOption.text="按報表年月、農(漁)會別";
  			     oOption.value="4";
  			     form.RPT_SORT.add(oOption);
  		    }else{
  		    	 oOption = document.createElement("OPTION");
  		    	 oOption.text="按縣市別、機構別、農(漁)會別、報表年月";
  			     oOption.value="1";
  			     form.RPT_SORT.add(oOption);
  			     oOption = document.createElement("OPTION");
  		    	 oOption.text="按縣市別、機構別、報表年月、農(漁)會別";
  			     oOption.value="2";
  			     form.RPT_SORT.add(oOption);
  			     oOption = document.createElement("OPTION");
  		    	 oOption.text="按報表年月、縣市別、機構別、農(漁)會別";
  			     oOption.value="3";
  			     form.RPT_SORT.add(oOption);
  		    }	  		    
    	}
    }
    */
    
    var xmlDoc = $.parseXML($("xml[id=ReportListXML]").html()) ;    
    var data = $(xmlDoc).find("data") ;
    var xmlhsien_id = $.parseXML($("xml[id=hsienListXML]").html()) ;    
    var data_hsien_id = $(xmlhsien_id).find("data") ;
    var oOption;   
      
    document.UpdateForm.RPT_OUTPUT_TYPE.length = 0;
    document.UpdateForm.HSIEN_ID.length = 0;
    document.UpdateForm.RPT_SORT.length = 0;
    
    
    $(data).each(function (i) {		
    	if (($(this).find("rptcode").text() == document.UpdateForm.RPT_CODE.value))  {  			
  			//農(漁)會別
  			if (($(this).find("rptoutputtype").text() == 'X'))  {//顯示農會/漁會/農漁會  				  				 
  				 oOption = document.createElement("OPTION");
			     oOption.text="農會";
  			     oOption.value="6";  			     
  			     document.UpdateForm.RPT_OUTPUT_TYPE.add(oOption);
  			     oOption = document.createElement("OPTION");
  			     oOption.text="漁會";
  			     oOption.value="7";
  			     document.UpdateForm.RPT_OUTPUT_TYPE.add(oOption);
  			     oOption = document.createElement("OPTION");
  			     oOption.text="農漁會";
  			     oOption.value="ALL";
  			     document.UpdateForm.RPT_OUTPUT_TYPE.add(oOption);
  		    }else if (($(this).find("rptoutputtype").text() == 'T'))  {//顯示農漁會  				  		    	 
  		    	 oOption = document.createElement("OPTION");
  		    	 oOption.text="農漁會";
  			     oOption.value="ALL";
  			     document.UpdateForm.RPT_OUTPUT_TYPE.add(oOption);  			     
  		    }     		
  		    		    
  		    //縣市別
  		    if (($(this).find("rptoutputtype").text() == 'T'))  {
  		    	 //alert('rptouttype==T');
  			     //rpt_output_type = 'T',顯示"全部縣市"
  			     oOption = document.createElement("OPTION");
  		    	 oOption.text="全部縣市";
  			     oOption.value="ALL";
  			     document.UpdateForm.HSIEN_ID.add(oOption);
  		    }else  if (($(this).find("rptinclude").text() != 'X'))  {
  		    	 //alert('rptInclude !=X');
  		    	 //rpt_include <> 'X',顯示"全部縣市"
  			     oOption = document.createElement("OPTION");
  		    	 oOption.text="全部縣市";
  			     oOption.value="ALL";
  			     document.UpdateForm.HSIEN_ID.add(oOption);
  		    }else{
  		    	 //alert('rptInclude ==X rptouttype!=T');
  		    	 oOption = document.createElement("OPTION");
  		    	 oOption.text="全部縣市";
  			     oOption.value="ALL";
  			     document.UpdateForm.HSIEN_ID.add(oOption);
  			     //各個縣市別
  			     $(data_hsien_id).each(function (i) {
  		    	     oOption = document.createElement("OPTION");
  		    	     oOption.text=$(this).find("hsien_name").text();
  			         oOption.value=$(this).find("hsien_id").text();
  			         document.UpdateForm.HSIEN_ID.add(oOption);
  		    	 })
                 ;

  		    }		
  		        
  		    //列表順序
  		    if (($(this).find("rptinclude").text() == 'T'))  {  		    	 
  			     oOption = document.createElement("OPTION");
  		    	 oOption.text="按報表年月、農(漁)會別";
  			     oOption.value="4";
  			     document.UpdateForm.RPT_SORT.add(oOption);
  		    }else{
  		    	 oOption = document.createElement("OPTION");
  		    	 oOption.text="按縣市別、機構別、農(漁)會別、報表年月";
  			     oOption.value="1";
  			     document.UpdateForm.RPT_SORT.add(oOption);
  			     oOption = document.createElement("OPTION");
  		    	 oOption.text="按縣市別、機構別、報表年月、農(漁)會別";
  			     oOption.value="2";
  			     document.UpdateForm.RPT_SORT.add(oOption);
  			     oOption = document.createElement("OPTION");
  		    	 oOption.text="按報表年月、縣市別、機構別、農(漁)會別";
  			     oOption.value="3";
  			     document.UpdateForm.RPT_SORT.add(oOption);
  		    }    
    	}
    	
    })
    ;
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

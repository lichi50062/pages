<%
// 96.07.12 create by 2295
// 99.11.10 fix 機構單位排序 by 2808	
//100.06.24 fix 機構排列順序,按照直轄市在前.其他縣市在後排序 by 2295
//100.07.01 fix 農金局/A111111111權限,點選農漁會/地方主管機關顯示機構列表不同 by 2295
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.*" %>
<%
	String report_no = "FR045W";
	Map dataMap =Utility.saveSearchParameter(request);
	String act = Utility.getTrimString(dataMap.get("act")) ;						
	String bank_type =Utility.getTrimString(dataMap.get("bank_type"))  ;	
	String muser_bank_type = ( session.getAttribute("bank_type")==null ) ? "" : (String)session.getAttribute("bank_type");			
    String muser_tbank_no = ( session.getAttribute("tbank_no")==null ) ? "" : (String)session.getAttribute("tbank_no");			  
    String lguser_id = ( session.getAttribute("muser_id")==null ) ? "" : (String)session.getAttribute("muser_id");		
	String title="";
	if(bank_type.equals("6")) title="農會";
	if(bank_type.equals("7")) title="漁會";
	
	
	String hsien_id = ( session.getAttribute("HSIEN_ID")==null ) ? "ALL" : (String)session.getAttribute("HSIEN_ID");				
	System.out.println("FR045W_BankList.hsien_id="+hsien_id);
	String wlx01_m_year = "";
    
    DataObject bean =  null;
    List cityList = Utility.getCity();
	if(cityList!=null) {
		// XML Ducument for 縣市別 begin
	    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"CityXML\">");
	    out.println("<datalist>");
	    for(int i=0;i< cityList.size(); i++) {
	        bean =(DataObject)cityList.get(i);
	        out.println("<data>");
	        out.println("<cityType>"+bean.getValue("hsien_id")+"</cityType>");
	        out.println("<cityName>"+bean.getValue("hsien_name")+"</cityName>");
	        out.println("<cityValue>"+bean.getValue("hsien_id")+"</cityValue>");
	        out.println("<cityYear>"+bean.getValue("m_year").toString()+"</cityYear>");
	        out.println("</data>");
	    }
	    out.println("</datalist>\n</xml>");
	    // XML Ducument for 縣市別 end
    }
    session.setAttribute("nowbank_type",bank_type);//100.06.24
    List tbankList =  Utility.getBankList(request) ; //按照直轄市在前.其他縣市在後排序
    	             //DBManager.QueryDB(sqlCmd,"");
    if(tbankList!=null) {
	    // XML Ducument for 總機構代碼 begin
	    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"TBankXML\">");
	    out.println("<datalist>");
	    for(int i=0;i< tbankList.size(); i++) {
	        bean =(DataObject)tbankList.get(i);
	        out.println("<data>");
	        out.println("<bankType>"+bean.getValue("bank_type")+"</bankType>");
	        out.println("<BnType>"+bean.getValue("bn_type")+"</BnType>");
	        out.println("<bankYear>"+bean.getValue("m_year").toString()+"</bankYear>");
	        out.println("<bankCity>"+bean.getValue("hsien_id")+"</bankCity>");
	        out.println("<bankValue>"+bean.getValue("bank_no")+"</bankValue>");
	        out.println("<bankName>"+bean.getValue("bank_no")+"  "+bean.getValue("bank_name")+"</bankName>");
	        out.println("</data>");
	    }
	    out.println("</datalist>\n</xml>");
	    // XML Ducument for 總機構代碼 end
    }
    
    List m2_nameList = DBManager.QueryDB_SQLParam(" select m_year,bank_no,bank_name from bn01 where bank_type='B' order by bank_no",null,"m_year");
    if(m2_nameList!=null) {
	    // XML Ducument for 地方主管機構代碼 begin
	    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"m2_nameXML\">");
	    out.println("<datalist>");
	    for(int i=0;i< m2_nameList.size(); i++) {
	        bean =(DataObject)m2_nameList.get(i);
	        out.println("<data>");
	        out.println("<bankYear>"+bean.getValue("m_year").toString()+"</bankYear>");
	        out.println("<bankValue>"+bean.getValue("bank_no")+"</bankValue>");
	        out.println("<bankName>"+bean.getValue("bank_no")+"  "+bean.getValue("bank_name")+"</bankName>");
	        out.println("</data>");
	    }
	    out.println("</datalist>\n</xml>");
	    // XML Ducument for 地方主管機構代碼 end
    }
       
   	//取得目前年月資料
	String S_YEAR = Utility.getTrimString(dataMap.get("S_YEAR")) ;
	String S_MONTH = Utility.getTrimString(dataMap.get("S_MONTH")) ;

	String YEAR  = Utility.getYear(); //回覆值為西元年故需-1911取得民國年;
   	String MONTH = Utility.getMonth();   //月份以0開始故加1取得實際月份;
   	
   	S_YEAR = (S_YEAR.equals(""))?YEAR:S_YEAR;   
  
%>



<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/DSUtil.js"></script>
<script language="javascript" src="js/movesels.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<script language="javascript" src="js/HsienIDUtil.js"></script><!-- 根據查詢年月.挑選縣市別/總機構單位-->
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
<!--

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

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

function MM_jumpMenu(targ,selObj,restore){ //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}

function doSubmit_banktype(cnd,bank_type){//農金局
   if(cnd == 'createRpt'){      
      if(this.document.forms[0].BankListDst.length == 0){      	 
      	 alert('金融機構代碼必須選擇');
      	 return;
      }
   }   
   
   MoveSelectToBtn(this.document.forms[0].BankList, this.document.forms[0].BankListDst);	
   this.document.forms[0].action = "/pages/FR045W_Excel.jsp?bank_type="+bank_type;		
   this.document.forms[0].target = '_self';
   this.document.forms[0].submit();     
}
function doSubmit(cnd,bank_type){//地方主管機關.全國農業金庫.農漁會   
   this.document.forms[0].action = "/pages/FR045W_Excel.jsp?bank_type="+bank_type;	
   this.document.forms[0].target = '_self';
   this.document.forms[0].submit();     
}

function ResetAllData(){
    if(confirm("確定要清除已選定的資料嗎？")){  	
        this.document.forms[0].BankListDst.length = 0;
        this.document.forms[0].HSIEN_ID[0].selected=true;	   
        changeOption(this.document.forms[0],'');
        clearBankList();
	}
	return;	
}

//99.03.09 add 根據查詢年度.縣市別.改變總機構名稱
//99.04.07 add 設定是否顯示縣市別/總機構單位 by 2295
//99.04.08 add 縣市別=全部/縣市別=單一縣市
//             營運中/已裁撤選項 by 2295
function changeTbank(xml, target, source, form) {    
	if(form.showTbank.value != 'true') return;
    var myXML,nodeType,nodeValue, nodeName,nodeCity,nodeYear;
    var oOption;    
    var unit = form.bankType.value;
    var m_year = form.S_YEAR.value;
    target.length = 0;
    if(m_year >= 100){
       m_year = 100;
    }else{
       m_year = 99;
    }	
    myXML = document.all(xml).XMLDocument;
    nodeType = myXML.getElementsByTagName("bankType");//bank_type農/漁會
    nodeCity = myXML.getElementsByTagName("bankCity");//hsien_id縣市別
	nodeValue = myXML.getElementsByTagName("bankValue");//bank_no機構代號
	nodeName = myXML.getElementsByTagName("bankName");//bank_no+bank_name
	nodeYear = myXML.getElementsByTagName("bankYear");//m_year所屬年度
	BnType = myXML.getElementsByTagName("BnType");//bn_type營運中/已裁撤
	
	for(var i=0;i<nodeType.length ;i++)	{
	   
	   if((nodeYear.item(i).firstChild.nodeValue == m_year) &&
  	      (nodeType.item(i).firstChild.nodeValue == unit) )  {//相同年度.農/漁會  	   
  	       //1.縣市別=全部 2.縣市別=單一縣市
	       if(form.cityType.value == 'ALL' || (nodeCity.item(i).firstChild.nodeValue == source.value)){	
	           oOption = document.createElement("OPTION");	           
			   if(BnType.item(i).firstChild.nodeValue != '2'){
			      oOption.text=nodeName.item(i).firstChild.nodeValue;
  			      oOption.value=nodeValue.item(i).firstChild.nodeValue;   	      			      			     
			   }
		       target.add(oOption);
  	       } 
   	    }
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
      if(form.showTbank.value == 'true'){         
         changeTbank('TBankXML', form.BankListSrc, form.cityType, form);     
      } 
}
/*
function changeOption(form,cnd){
    var myXML,nodeType,nodeType1,nodeValue, nodeName;

    myXML = document.all("TBankXML").XMLDocument;
    form.BankListSrc.length = 0;
    if(cnd == 'change') form.BankListDst.length = 0;
    BnType = myXML.getElementsByTagName("BnType");    
	nodeType = myXML.getElementsByTagName("HsienId");
	nodeValue = myXML.getElementsByTagName("bankValue");
	nodeName = myXML.getElementsByTagName("bankName");
	nodeYear = myXML.getElementsByTagName("bankYear");
	var oOption;
    var checkAdd = false;	
	
	for(var i=0;i<nodeType.length ;i++)
	{
		if(form.HSIEN_ID.value == 'ALL'){
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
	    		//alert('add '+oOption.text);
	    		//alert('add '+oOption.value);
  				form.BankListSrc.add(oOption); 
  			}	
	    }else if (nodeType.item(i).firstChild.nodeValue == form.HSIEN_ID.value){
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
*/
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

function changeTbankALL(xml) {
	var myXML,nodeType,nodeValue, nodeName,nodeCity,nodeYear;
    var oOption;    
    myXML = document.all(xml).XMLDocument;
    var target = document.getElementById("BANK_NO");
    target.length = 0;
    var y = this.document.forms[0].S_YEAR.value=='' ? 0 : eval(this.document.forms[0].S_YEAR.value) ;
	m_year = '100' ;
	if(y<=99) {
		m_year = '99' ;
	}
	
    nodeType = myXML.getElementsByTagName("bankCity");
    nodeCity = myXML.getElementsByTagName("bankCity");//hsien_id縣市別
	nodeValue = myXML.getElementsByTagName("bankValue");//bank_no機構代號
	nodeName = myXML.getElementsByTagName("bankName");//bank_no+bank_name
	nodeYear = myXML.getElementsByTagName("bankYear");//m_year所屬年度
	
	for(var i=0;i<nodeType.length ;i++)	{
		if(nodeYear.item(i).firstChild.nodeValue == m_year){
			oOption = document.createElement("OPTION");
	   	 	oOption.text=nodeName.item(i).firstChild.nodeValue;
	        oOption.value=nodeValue.item(i).firstChild.nodeValue;  
	        target.add(oOption);
		}
    }
	//removeBankOption() ;
	
}

function changeTbankB(xml) {//農金局.A111111111點選地方主管機關
	var myXML,nodeType,nodeValue, nodeName,nodeCity,nodeYear;
    var oOption;    
    myXML = document.all(xml).XMLDocument;
    var target = document.getElementById("BANK_NO");
    target.length = 0;
    var y = this.document.forms[0].S_YEAR.value=='' ? 0 : eval(this.document.forms[0].S_YEAR.value) ;
	m_year = '100' ;
	if(y<=99) {
		m_year = '99' ;
	}
	nodeValue = myXML.getElementsByTagName("bankValue");//bank_no機構代號
	nodeName = myXML.getElementsByTagName("bankName");//bank_no+bank_name
	nodeYear = myXML.getElementsByTagName("bankYear");//m_year所屬年度
	
	for(var i=0;i<nodeYear.length ;i++)	{
		if(nodeYear.item(i).firstChild.nodeValue == m_year){
			oOption = document.createElement("OPTION");
	   	 	oOption.text=nodeName.item(i).firstChild.nodeValue;
	        oOption.value=nodeValue.item(i).firstChild.nodeValue+"/"+nodeName.item(i).firstChild.nodeValue;  
	        target.add(oOption);
		}
    }
	//removeBankOption() ;
	
}
/*
function removeBankOption() {
	var y = $('input[@name=S_YEAR]').val()=='' ? 0 : eval($('input[@name=S_YEAR]').val()) ;
	m_year = '100' ;
	if(y<=99) {
		m_year = '99' ;
	}
	
	$('select[@name=BANK_NO] > option').each(function(){
		if($(this).attr('year')!=m_year) {
			$(this).remove() ;
		}
	});
}*/
//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form method=post action='#' name='BankListfrm'>
<input name="bankType" type="hidden" value='<%=bank_type %>'/>
<input type='hidden' name="showCityType" value='true'>
<input type='hidden' name="showTbank" value='true'>
<table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
     <td>&nbsp;</td>
  </tr>
  <tr> 
    <td bgcolor="#FFFFFF">
	<table width="600" border="0" align="center" cellpadding="1" cellspacing="1">        
        <tr> 
          <td><table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="100"><img src="images/banner_bg1.gif" width="100" height="17"></td>
                <td width="*"><font color='#000000' size=4> 
                  <center>
                    <font color="#336600"><%=title%>信用部存款帳戶分級差異化管理統計表</font>
                  </center>
                  </font> </td>
                <td width="100"><img src="images/banner_bg1.gif" width="100" height="17"></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td><img src="images/space_1.gif" width="8" height="8"></td>
        </tr>
        <tr> 
          <td><table width="600" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#5DA525">
              <tr> 
                <td bordercolor="#E9F4E3" bgcolor="#E9F4E3"><table width="600" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#E9F4E3">
                    <tr> 
                      <td bgcolor="#B0D595" class="sbody"> <div align="right">

                      	  <input type='radio' name="act" value='download' checked>下載報表
                      	  <%if(Utility.getPermission(request,report_no,"P")){ //Print %>                  	        	                                   		     			        
                      	  <% if(muser_bank_type.equals("2")  && (bank_type.equals("6") || bank_type.equals("7")) ){//農金局.點選農漁會 %>   
                      	  <a href="javascript:doSubmit_banktype('createRpt','<%=muser_bank_type%>');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image41','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image41" width="66" height="25" border="0" id="Image41"></a> 
                      	  <%}else{%>
                      	  <a href="javascript:doSubmit('createRpt','<%=bank_type%>');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image41','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image41" width="66" height="25" border="0" id="Image41"></a> 
                      	  <%}%>
                      	  <%}%>
                          <a href="javascript:ResetAllData();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image51','','images/bt_cancelb.gif',0)"><img src="images/bt_cancel.gif" name="Image51" width="66" height="25" border="0" id="Image51"></a> 
                          <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image61','','images/bt_reporthelpb.gif',1)"><img src="images/bt_reporthelp.gif" name="Image61" width="80" height="25" border="0" id="Image61"></a> 
                        </div></td>
                    </tr>

                    <tr> 
                      <td bgcolor="#E9F4E3">
                       <table width="580" border="0" align="center" cellpadding="0" cellspacing="0">
                     
                     <tr class="sbody">
                     <td>
                    <img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">查詢年月 :</span>
                    <input type='text' name='S_YEAR' value="<%=YEAR%>" size='3' maxlength='3' onblur='CheckYear(this)' onChange='ctrlTbank();'><font color='#000000'>年                            
                    			<select id="hide1" name=S_MONTH >
        						<%for (int j = 1; j <= 12; j++) {
                                         if (j < 10){%>
        								 <option value=0<%=j%> <%if(MONTH.equals(String.valueOf(j))) out.print("selected");%>>0<%=j%></option>
            							 <%}else{%>
            							 <option value=<%=j%> <%if(MONTH.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            							 <%}//end of else%>
        						<%}//end of for%>
        						</select><font color='#000000'>月</font>
                             <%if(muser_bank_type.equals("2") && (bank_type.equals("6") || bank_type.equals("7"))){                                  
                               }else{                               
                                  if (bank_type.equals("6") || bank_type.equals("7") || bank_type.equals("1")){//點選農.漁會.全國農業金庫時,可有年月區間                                  
                             %>                           
                           
                             ~ <input type='text' name='E_YEAR' value="<%=YEAR%>" size='3' maxlength='3' onblur='CheckYear(this)'><font color='#000000'>年
        						<select id="hide1" name=E_MONTH >        			
        						<%for (int j = 1; j <= 12; j++) {
                                         if (j < 10){%>
        								 <option value=0<%=j%> <%if(MONTH.equals(String.valueOf(j))) out.print("selected");%>>0<%=j%></option>
            							 <%}else{%>
            							 <option value=<%=j%> <%if(MONTH.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            							 <%}//end of else%>
        						<% }//end of for%>
        						</select><font color='#000000'>月</font>                           
                            <%    }else{}                            
                              }%>
                             </td>
                            
                    </tr>    
                    <%if(lguser_id.equals("A111111111") && (bank_type.equals("6") || bank_type.equals("7"))){//A111111111.點選農.漁會%>                   
                     <tr class="sbody">
                     <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">機構單位 :</span>                          
        				  <select name=BANK_NO >        			
        					 <%for(int bankidx = 0; bankidx < tbankList.size(); bankidx++){
                                      	 bean = (DataObject)tbankList.get(bankidx); %>                                         
        						 <option value=<%=(String)bean.getValue("bank_no")%> year=<%=bean.getValue("m_year").toString() %>><%=(String)bean.getValue("bank_no")%>&nbsp;<%=(String)bean.getValue("bank_name")%></option>            							 
        					 <%}//end of for%>
        				  </select>
                     </td>
                    </tr>  
                    <%}else if((muser_bank_type.equals("2") || lguser_id.equals("A111111111")) && bank_type.equals("B")){//農金局.A111111111點選地方主管機關 %>                    
                      <tr>
                      <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">機構單位 :</span>                          
        				  <select name=BANK_NO >        			
        					 <%for(int bankidx = 0; bankidx < m2_nameList.size(); bankidx++){
                                      	 bean = (DataObject)m2_nameList.get(bankidx); %>                                         
        						 <option value=<%=(String)bean.getValue("bank_no")%> year=<%=bean.getValue("m_year").toString() %> ><%=(String)bean.getValue("bank_no")%>&nbsp;<%=(String)bean.getValue("bank_name")%></option>            							 
        					 <%}//end of for%>
        				  </select>
                     </td>
                     </tr>    
                    <%}else if(muser_bank_type.equals("2")  && (bank_type.equals("6") || bank_type.equals("7")) ){//農金局.點選農漁會 %>                    
                    <tr class="sbody">  
                       	<td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">縣市別 :</span>                                
                           <select size="1" name="cityType" onchange="javascript:changeTbank('TBankXML', form.BankListSrc, form.cityType, form);" />
  							  
                        </td>
                    </tr>
      
                    </table></td>
                    </tr>
                    <tr> 
                      <td bgcolor="#E9F4E3"> <table width="579" border="0" align="center" cellpadding="1" cellspacing="1" bgcolor="#E9F4E3">
                          <tr> 
                            <td width="195">  
                            <select multiple  size=10  name="BankListSrc" ondblclick="javascript:movesel(this.document.forms[0].BankListSrc,this.document.forms[0].BankListDst);" style="width: 17em">							
							</select>
                            </td>
                            <td width="52"><table width="40" border="0" align="center" cellpadding="3" cellspacing="3">
                                <tr> 
                                  <td>
                                  <div align="center">                                 
                                  <a href="javascript:movesel(this.document.forms[0].BankListSrc,this.document.forms[0].BankListDst);"><img src="images/arrow_right.gif" width="24" height="22" border="0"></a>
                                  </div>
                                  </td>
                                </tr>
                                <tr> 
                                  <td>
                                  <div align="center">                                  
                                  <a href="javascript:moveallsel(this.document.forms[0].BankListSrc,this.document.forms[0].BankListDst);"><img src="images/arrow_rightall.gif" width="24" height="22" border="0"></a>
                                  </div>
                                  </td>
                                </tr>
                                <tr> 
                                  <td>
                                  <div align="center">                                  
                                  <a href="javascript:movesel(this.document.forms[0].BankListDst,this.document.forms[0].BankListSrc);"><img src="images/arrow_left.gif" width="24" height="22" border="0"></a>
                                  </div>
                                  </td>
                                </tr>
                                <tr> 
                                  <td height="22">
                                  <div align="center">                                  
                                  <a href="javascript:moveallsel(this.document.forms[0].BankListDst,this.document.forms[0].BankListSrc);"><img src="images/arrow_leftall.gif" width="24" height="22" border="0"></a>
                                  </div>
                                  </td>
                                </tr>
                               </table></td>
                               <td width="189"> 
                              <select multiple size=10  name="BankListDst" ondblclick="javascript:movesel(this.document.forms[0].BankListDst,this.document.forms[0].BankListSrc);" style="width: 17em">							
							 </select>
                          </tr>
                        </table></td>
                    </tr>
                    <%}%>
                    <tr class="sbody">
                      <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">輸出格式 :</span>
                          <input name='printStyle' type='radio' value='xls' checked>Excel
                          <input name='printStyle' type='radio' value='ods' >ODS
                          <input name='printStyle' type='radio' value='pdf' >PDF
		              </td>
                    </tr> 
                  </table></td>
              </tr>
            </table></td>
         </tr>  
      </table>
    </td>
  </tr>
</table>
<INPUT type="hidden" name=BankList><!--//BankList儲存已勾選的金融機構代碼-->
<INPUT type="hidden" name=btnFieldList value='<%if(session.getAttribute("btnFieldList") != null) out.print((String)session.getAttribute("btnFieldList"));%>'><!--//btnFieldList儲存已勾選的報表欄位名稱-->
</form>
<script language="JavaScript" >

function ctrlTbank(){
	<% if(muser_bank_type.equals("2")  && (bank_type.equals("6") || bank_type.equals("7")) ){//農金局.點選農漁會 %>                    

			changeCity('CityXML', this.document.forms[0].cityType, this.document.forms[0].S_YEAR, this.document.forms[0]);
			
			function clearBankList(){
			 <%
				session.setAttribute("BankList",null);//清除已勾選的BankList
			 %>
			}

		<%}else if((muser_bank_type.equals("2") || lguser_id.equals("A111111111")) && bank_type.equals("B")){//農金局.A111111111點選地方主管機關 %>                    

			
			changeTbankB("m2_nameXML") ;	
			
			//removeBankOption() ;

		<%} else {%>

			
			changeTbankALL("TBankXML") ;	
			
			//removeBankOption() ;

		<%} %>
}

ctrlTbank();
</script>


</body>
</html>

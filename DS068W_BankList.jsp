<%
//105.11.09 create 查核案件數彈性報表 by 2295
//108.05.03 add 報表格式轉換 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>

<%
	// 查詢條件值 
    Map dataMap =Utility.saveSearchParameter(request);
	String report_no = "DS068W";	
	String act = Utility.getTrimString(dataMap.get("act"));		
	
	//營運中/已裁撤===================================================================================
	String cancel_no = ( session.getAttribute("CANCEL_NO")==null ) ? "N" : (String)session.getAttribute("CANCEL_NO");				
	//========================================================================================================	
	String szExcelAction = (session.getAttribute("excelaction")==null)?"download":(String)session.getAttribute("excelaction");		
	
	String hsien_id = ( session.getAttribute("HSIEN_ID")==null ) ? "ALL" : (String)session.getAttribute("HSIEN_ID");				
	String rptKind = ( session.getAttribute("rptKind")==null ) ? "" : (String)session.getAttribute("rptKind");				
	System.out.println("DS068W_BankList.hsien_id="+hsien_id);
	String YEAR  = Utility.getYear();
   	String MONTH = Utility.getMonth();
	String S_YEAR = (session.getAttribute("S_YEAR")==null)?"":(String)session.getAttribute("S_YEAR");
	String E_YEAR = (session.getAttribute("E_YEAR")==null)?"":(String)session.getAttribute("E_YEAR");
	String S_MONTH = (session.getAttribute("S_MONTH")==null)?"":(String)session.getAttribute("S_MONTH");            
	String E_MONTH = (session.getAttribute("E_MONTH")==null)?"":(String)session.getAttribute("E_MONTH");    
	String S_DAY = (session.getAttribute("S_DAY")==null)?"":(String)session.getAttribute("S_DAY");            
	String E_DAY = (session.getAttribute("E_DAY")==null)?"":(String)session.getAttribute("E_DAY");         
	String begDate = Utility.getTrimString(dataMap.get("begDate")) ;
    String endDate = Utility.getTrimString(dataMap.get("endDate")) ;	
   	String Unit = (session.getAttribute("Unit")==null)?"":(String)session.getAttribute("Unit");   	   	
   	String printStyle = (session.getAttribute("printStyle")==null)?"xls":(String)session.getAttribute("printStyle");//108.05.03 add	
	//95.11.10 取得登入者資訊=================================================================================================
	String muser_id = ( session.getAttribute("muser_id")==null ) ? "" : (String)session.getAttribute("muser_id");		
    String muser_bank_type = ( session.getAttribute("bank_type")==null ) ? "" : (String)session.getAttribute("bank_type");			
    //==============================================================================================================    	    
    String bank_type = (session.getAttribute("nowbank_type")==null)?"6":(String)session.getAttribute("nowbank_type");	    
	String DS_bank_type = (session.getAttribute("DS_bank_type")==null)?"6":(String)session.getAttribute("DS_bank_type");	
	System.out.print("nowbank_type="+(String)session.getAttribute("nowbank_type"));
	System.out.print(report_no+"_BankList.szExcelAction="+szExcelAction);
    System.out.print(":S_YEAR="+S_YEAR+":S_MONTH="+S_MONTH+":S_DAY="+S_DAY);
	System.out.println(":bank_type="+bank_type);
	//String begY="",begM="",begD="",endY="",endM="",endD="";	
	//控制農漁會清單1 
	session.setAttribute("nowbank_type","");
	session.setAttribute("muser_id","");
	session.setAttribute("bank_type","3");
%>
<%@include file="./include/DS_bank_no_hsien_id.include" %>
<%  //控制農漁會清單2 
	session.setAttribute("nowbank_type", bank_type); 
	session.setAttribute("muser_id", muser_id);
	session.setAttribute("bank_type", bank_type);
%>
<script src="js/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/PopupCal.js"></script>
<script language="javascript" src="js/DSUtil.js"></script>
<script language="javascript" src="js/movesels.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
<!--
//102.11.11 add 漁會科目代號新舊無法同時列印
function doSubmit(report_no,cnd){
	
   if(cnd == 'createRpt'){      
      if(document.BankListfrm.rptkind.value == "3" && document.BankListfrm.BankListDst.length == 0){      	 
      	 alert('金融機構代碼必須選擇');
      	 return;
      }
     
      if(document.BankListfrm.S_YEAR.value+document.BankListfrm.S_MONTH.value > document.BankListfrm.E_YEAR.value+document.BankListfrm.E_MONTH.value ){
		 alert('起始日期不可大於結束日期');
		return false;
	  }
      
      if(document.BankListfrm.rptkind.value != "3" && document.BankListfrm.btnFieldList.value == ''){
         alert('報表欄位必須選擇');
         return;
      }      
      if(!confirm("本項報表會執行10-15秒，是否確定執行？")){
         return;
      }   
   }   
   
   MoveSelectToBtn(document.BankListfrm.BankList, document.BankListfrm.BankListDst);	
   if(!mergeCheckedDate("S_YEAR;S_MONTH;S_DAY","begDate")){   	  
	  document.BankListfrm.S_YEAR.focus();
      return ;
   }
   if(document.BankListfrm.begDate.value == ''){
   	  alert("查核期間不可為空白");
   	  document.BankListfrm.S_YEAR.focus();
      return ;
   }	
   document.BankListfrm.begDate.value=parseInt(document.BankListfrm.begDate.value)+19110000;
   
   //alert(this.document.forms[0].begDate.value);
   if(!mergeCheckedDate("E_YEAR;E_MONTH;E_DAY","endDate")){
	  document.BankListfrm.E_YEAR.focus();
      return ;
   }
   if(document.BankListfrm.endDate.value == ''){
   	  alert("查核期間不可為空白");
   	  document.BankListfrm.E_YEAR.focus();
      return ;
   }	
   document.BankListfrm.endDate.value=parseInt(document.BankListfrm.endDate.value)+19110000;
   //alert(this.document.forms[0].endDate.value);
   fn_ShowPanel(report_no,cnd);      
}

function changeOption_all(form,cnd){
   
	var oOption;
    var checkAdd = false;	
	
	if(form.HSIEN_ID.value == 'ALL'){	
		oOption = document.createElement("OPTION");			    
		oOption.text="全部";
  		oOption.value="ALL";   	  
		 			  		
  		checkAdd=false;
		for(var k =0;k<form.BankListDst.length;k++){			
			if(form.BankListDst.options[k].text == oOption.text){		    
		   	   checkAdd = true;			       
	    	}   
		}
		if(checkAdd == false && oOption.text != '' && oOption.value != ''){	  							
	   	   form.BankListSrc.add(oOption,0);   			
  		}	
	}     	
}


//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form method=post action='#' name='BankListfrm'>
<input type='hidden' name="begDate" >
<input type='hidden' name="endDate" >
<input type='hidden' name='rptkind' value="<%=rptKind%>">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
     <td>&nbsp;</td>
  </tr>
  <tr> 
    <td bgcolor="#FFFFFF">
	<table width="750" border="0" align="center" cellpadding="1" cellspacing="1">        
        <tr> 
          <td><table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="240"><img src="images/banner_bg1.gif" width="240" height="17"></td>
                <td width="*" class="title_font">查核案件數彈性報表</td>
                <td width="240"><img src="images/banner_bg1.gif" width="240" height="17"></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td><img src="images/space_1.gif" width="8" height="8"></td>
        </tr>
        <tr>          
          <td><table width="750" border="1" align="center" cellpadding="0" cellspacing="0" class="bordercolor">
              <tr> 
                <td bordercolor="#E9F4E3" bgcolor="#E9F4E3">
                <table width="750" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#E9F4E3">
                    <tr> 
                      <td class="bt_bgcolor"> 
                       <div align="right">
                          <!--input type='radio' name="excelaction" value='view' <%if(szExcelAction.equals("view")){out.print("checked");}%> >檢視報表-->
                      	  <input type='radio' name="excelaction" value='download' <%if(szExcelAction.equals("download")){out.print("checked");}%> >下載報表
                      	  <%if(Utility.getPermission(request,report_no,"P")){//Print--有列印權限時 %> 
                      	  <a href="javascript:doSubmit('<%=report_no%>','createRpt');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image41','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image41" width="66" height="25" border="0" id="Image41"></a> 
                      	  <%}%>
                          <a href="javascript:ResetAllData('BankList');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image51','','images/bt_cancelb.gif',0)"><img src="images/bt_cancel.gif" name="Image51" width="66" height="25" border="0" id="Image51"></a> 
                          <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image61','','images/bt_reporthelpb.gif',1)"><img src="images/bt_reporthelp.gif" name="Image61" width="80" height="25" border="0" id="Image61"></a> 
                        </div>
                       </td>
                    </tr>
                    <tr> 
                      <td class="menu_bgcolor"> 
                        <table width="700" border="0" align="center" cellpadding="1" cellspacing="1" class="sbody">
                          <tr class="sbody"> 
                            <td width="100"><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"> 
                              <a href="#"><font color="#CC6600">1.受檢單位</font></a></td>
                            <td width="100"><a href="javascript:doSubmit('<%=report_no%>','RptColumn')"><font color='black'>2.統計分類</font></a></td>                                                     
                          </tr>
                        </table></td>
                    </tr>                    
                     
                    <tr> 
                      <td class="body_bgcolor"> 
                       <table width="750" border="0" align="center" cellpadding="0" cellspacing="0">     
                         <tr class="sbody">
                           <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">查核期間 :</span> 		
                                <input type='text' name='S_YEAR' value="<%=S_YEAR%>" size='3' maxlength='3' onblur='CheckYear(this)' >    
                                <font color='#000000'>年
                                <select id="hide3" name=S_MONTH>
                                <option></option>
                                <%
                                	for (int j = 1; j <= 12; j++) {
                                	if (j < 10){%>        	
                                	<option value=0<%=j%>>0<%=j%></option>        		
                                	<%}else{%>
                                	<option value=<%=j%> ><%=j%></option>
                                	<%}%>
                                <%}%>
                                </select>月
                                <select id="hide4" name=S_DAY>
                                <option></option>
                                <%
                                	for (int j = 1; j < 32; j++) {
                                	if (j < 10){%>        	
                                	<option value=0<%=j%> >0<%=j%></option>        		
                                	<%}else{%>
                                	<option value=<%=j%> ><%=j%></option>
                                	<%}%>
                                <%}%>
                                </select>日</font>
                                		<button name='button1' onClick="popupCal('BankListfrm','S_YEAR,S_MONTH,S_DAY','BTN_date_1',event)">
                            			<img align="absmiddle" border='0' name='BTN_date_1' src='images/clander.gif'>
                            			</button>
                                         ～
                                <input type='text' name='E_YEAR' value="<%=E_YEAR%>" size='3' maxlength='3' onblur='CheckYear(this)'>
                                <font color='#000000'>年
                                <select id="hide5" name=E_MONTH>
                                <option></option>
                                <%
                                	for (int j = 1; j <= 12; j++) {
                                	if (j < 10){%>        	
                                	<option value=0<%=j%>>0<%=j%></option>        		
                                	<%}else{%>
                                	<option value=<%=j%>><%=j%></option>
                                	<%}%>
                                <%}%>
                                </select>月
                                <select id="hide6" name=E_DAY>
                                <option></option>
                                <%
                                	for (int j = 1; j < 32; j++) {
                                	if (j < 10){%>        	
                                	<option value=0<%=j%>>0<%=j%></option>        		
                                	<%}else{%>
                                	<option value=<%=j%> ><%=j%></option>
                                	<%}%>
                                <%}%>
                                </select>日</font>
                                		<button name='button2' onClick="popupCal('BankListfrm','E_YEAR,E_MONTH,E_DAY','BTN_date_2',event)">
                            			<img align="absmiddle" border='0' name='BTN_date_2' src='images/clander.gif'>
                            			</button>
                             </td>
                         </tr>  
                    	 <tr class="sbody">
                         <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">農(漁)會別 :</span>
                            <select size="1" name="bank_type" onchange="javascript:changeOption_loan(document.BankListfrm,'change');changeOption_all(document.BankListfrm,'change');"> 
                              <option value ='6' <%if((!bank_type.equals("")) && bank_type.equals("6")) out.print("selected");%>>農會</option>  
                              <option value ='7' <%if((!bank_type.equals("")) && bank_type.equals("7")) out.print("selected");%>>漁會</option>                                           
                              <option value ='ALL' <%if((!bank_type.equals("")) && bank_type.equals("ALL")) out.print("selected");%>>農漁會</option>    
                            </select>
		                  </td>
                         </tr> 
                         
                         <tr class="sbody">                                  		
  						   <input type='hidden' name='CANCEL_NO' value="N">  						    		
  					       </select>                   
                           <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">縣市別 :</span>                                                            
                              <select name="HSIEN_ID" onchange="javascript:changeOption_loan(document.BankListfrm,'');changeOption_all(document.forms[0],'change');"> 
                              <option value="ALL">全部</option>                                                             
                             </select>
                           </td>
                         </tr>
                          
                        </table>
                       </td>
                    </tr>
                    <%@include file="./include/DS_PrintStyle.include" %><!-- 輸出格式 -->    
                    <%@include file="./include/DS_BankList.include" %><!-- 可選擇項目-->
                    
                    <tr> 
                 	  <td class="body_bgcolor">
                  	    <table width="750" border="0" cellpadding="1" cellspacing="1">
                    	<tr>                           
                          <td width="750" align=left><font color="red" size=2>註：『已選擇項目』清單選取之項目說明</font></td>                              
                    	</tr>                              
                        <tr>                           
                          <td width="750" align=left><font color="red" size=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(1)選取[全部]：係以「各縣市彙總表」之報表格式列印 </font></td>                              
                        </tr>                                                                                                      
                        <tr>                           
                          <td width="750" align=left><font color="red" size=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(2)選取[多家農漁會信用部]：係以統計已選取信用部資料 </font></td>                              
                        </tr>
                        </table>
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
<INPUT type="hidden" name=clearbtnFieldList><!--//儲存是否清除btnFieldList-->
<INPUT type="hidden" name=agri_loan value="0"><!--//專案農貸註記-->
</form>
<script language="JavaScript" >
<!--

<%
//從session裡把勾選的金融機構代碼讀出來.放在BankListDst
if(session.getAttribute("BankList") != null && !((String)session.getAttribute("BankList")).equals("")){ 
   System.out.println("DS068W_BankList.BankList="+(String)session.getAttribute("BankList"));
%>
var bnlist;
bnlist = '<%=(String)session.getAttribute("BankList")%>';
var a = bnlist.split(',');
for (var i =0; i < a.length; i ++){
	var j = a[i].split('+');
	this.document.forms[0].BankListDst.options[i] = new Option(j[1], j[0]);
}
<%}%>
setSelect(document.BankListfrm.S_YEAR,"<%=S_YEAR%>");
setSelect(document.BankListfrm.S_MONTH,"<%=S_MONTH%>");
setSelect(document.BankListfrm.S_DAY,"<%=S_DAY%>");
setSelect(document.BankListfrm.E_YEAR,"<%=E_YEAR%>");
setSelect(document.BankListfrm.E_MONTH,"<%=E_MONTH%>");
setSelect(document.BankListfrm.E_DAY,"<%=E_DAY%>");
setSelect(document.BankListfrm.HSIEN_ID,"<%=hsien_id%>");
//setSelect(this.document.forms[0].CANCEL_NO,"<%=cancel_no%>");
changeCity(document.BankListfrm.HSIEN_ID, document.BankListfrm.S_YEAR, document.BankListfrm);

//changeOption(this.document.forms[0],'');
-->
</script>

</body>
</html>

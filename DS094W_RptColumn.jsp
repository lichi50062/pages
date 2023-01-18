<%
//110.10.04~08 created 系統登錄紀錄 by 2295
//111.04.13 調整Edge日期小視窗,未顯示全部日期 by 2295
//111.04.13 調整Edge可選擇項目,dbclick時無法將項目移至已選擇項目 by 2295
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
	String report_no = "DS094W";	
	String act = Utility.getTrimString(dataMap.get("act"));	
	String bank_type = (session.getAttribute("nowbank_type")==null)?"":(String)session.getAttribute("nowbank_type");		
	String szExcelAction = (session.getAttribute("excelaction")==null)?"download":(String)session.getAttribute("excelaction");	
	System.out.println(report_no+"_RptColumn.szExcelAction="+szExcelAction);		
	String YEAR  = Utility.getYear();
   	String MONTH = Utility.getMonth();
   	String q_loginFlag = "ALL";
   	String q_sysType = "ALL";
	String S_YEAR = (session.getAttribute("S_YEAR")==null)?YEAR:(String)session.getAttribute("S_YEAR");
	String E_YEAR = (session.getAttribute("E_YEAR")==null)?YEAR:(String)session.getAttribute("E_YEAR");
	String S_MONTH = (session.getAttribute("S_MONTH")==null)?MONTH:(String)session.getAttribute("S_MONTH");            
	String E_MONTH = (session.getAttribute("E_MONTH")==null)?MONTH:(String)session.getAttribute("E_MONTH");            
	String S_DAY = (session.getAttribute("S_DAY")==null)?"1":(String)session.getAttribute("S_DAY");            
	String E_DAY = (session.getAttribute("E_DAY")==null)?"31":(String)session.getAttribute("E_DAY");            
	String sysType = (session.getAttribute("sysType")==null)?"ALL":(String)session.getAttribute("sysType");   	   	
   	String loginFlag = (session.getAttribute("loginFlag")==null)?"ALL":(String)session.getAttribute("loginFlag");   	   	
   	String printStyle = (session.getAttribute("printStyle")==null)?"xls":(String)session.getAttribute("printStyle");//108.04.29 add
%>

<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/PopupCal.js"></script>
<script language="javascript" src="js/DSUtil.js"></script>
<script language="javascript" src="js/movesels.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
<!--
function doSubmit(report_no,cnd){   
   //alert(report_no);
   //alert(cnd);
   
   if(cnd == 'createRpt'){      
      if(!chInput1(document.RptColumnfrm,'')) return;//95.12.04 add 起始日期不可大於結束日期
      if(document.RptColumnfrm.FieldListDst.length == 0){        
      	 alert('報表欄位必須選擇');
      	 return;
      }
      if(!confirm("本項報表會執行10-15秒，是否確定執行？")){
         return;
      }   
   }   
   
   MoveSelectToBtn(document.RptColumnfrm.btnFieldList, document.RptColumnfrm.FieldListDst);	         
  
   fn_ShowPanel(report_no,cnd);      
}

//檢查登入期間-起始日期.不可大於結束日期
function chInput1(form,cnd){
	//alert(form.S_YEAR.value+form.S_MONTH.value+form.S_DAY.value);
	//alert(form.E_YEAR.value+form.E_MONTH.value+form.E_DAY.value);
	form.S_DATE.value=form.S_YEAR.value+form.S_MONTH.value+form.S_DAY.value;
	form.E_DATE.value=form.E_YEAR.value+form.E_MONTH.value+form.E_DAY.value;
    
	if(form.S_YEAR.value+form.S_MONTH.value+form.S_DAY.value > form.E_YEAR.value+form.E_MONTH.value+form.E_DAY.value ){
		alert('起始日期不可大於結束日期');
		return false;
	}
    
	if(trimString(form.S_DATE.value)!="" && trimString(form.E_DATE.value)!=""){
	  if(Math.abs(form.S_DATE.value) > Math.abs(form.E_DATE.value)){
    	 alert("起始查詢年月不可大於結束查詢年月");
    	 return false;
      }    	   
    }    
   
	return true;
}


//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form name="RptColumnfrm" method=post action='#'>
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
                <td width="180"><img src="images/banner_bg1.gif" width="180" height="17"></td>
                <td width="*" class="title_font"><%=Utility.getPgName(report_no)%></td>
                <td width="180"><img src="images/banner_bg1.gif" width="180" height="17"></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td><img src="images/space_1.gif" width="8" height="8"></td>
        </tr>        
        <tr> 
          <td><table width="750" border="1" align="center" cellpadding="0" cellspacing="0" class="bordercolor">
              <tr> 
                <td bordercolor="#E9F4E3" bgcolor="#E9F4E3"><table width="750" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#E9F4E3" >
                    <tr> 
                      <td class="bt_bgcolor"> <div align="right">
                          <!--input type='radio' name="excelaction" value='view' <%if(szExcelAction.equals("view")){out.print("checked");}%> >檢視報表-->
                      	  <input type='radio' name="excelaction" value='download' <%if(szExcelAction.equals("download")){out.print("checked");}%> >下載報表
                          <%if(Utility.getPermission(request,report_no,"P")){//Print--有列印權限時 %> 
                      	  <a href="javascript:doSubmit('<%=report_no%>','createRpt');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image411','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image411" width="66" height="25" border="0" id="Image41"></a> 
                      	  <%}%>
                          <a href="javascript:ResetAllData_AgriBank('RptColumn');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image511','','images/bt_cancelb.gif',0)"><img src="images/bt_cancel.gif" name="Image511" width="66" height="25" border="0" id="Image51"></a> 
                          <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image611','','images/bt_reporthelpb.gif',1)"><img src="images/bt_reporthelp.gif" name="Image611" width="80" height="25" border="0" id="Image61"></a> 
                        </div></td>
                    </tr>
                    <tr> 
                      <td class="menu_bgcolor"> <table width="700" border="0" align="center" cellpadding="1" cellspacing="1" class="sbody" >
                          <tr class="sbody">                            
                            <td width="100"><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"> 
                              <a href="#"><font color="#CC6600">1.報表欄位</font></a>
                            </td>
                            <td width="100"><a href="javascript:doSubmit('<%=report_no%>','RptStyle')"><font color='black'>2.報表格式</font></a></td>
                          </tr>
                        </table></td>
                    </tr>
                    <!--登入期間-->
                    <tr class="sbody">
                      <td class="body_bgcolor"><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">登入期間 :</span> 						  						
                         <input type='text' name='S_YEAR' value="<%=S_YEAR%>" size='3' maxlength='3' onblur='CheckYear(this)'><font color='#000000'>年                             
                    		<select id="hide3" name=S_MONTH>        						
                    		<%
                    			for (int j = 1; j <= 12; j++) {	
                    			if (j < 10){%>        	
                    			<option value=0<%=j%> <%if(String.valueOf(Integer.parseInt(S_MONTH)).equals(String.valueOf(j))) out.print("selected");%>>0<%=j%></option>        		
                    			<%}else{%>
                    			<option value=<%=j%> <%if(String.valueOf(Integer.parseInt(S_MONTH)).equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
                    			<%}%>
                    		<%}%>
                    		</select><font color='#000000'>月</font>
                    		<select id="hide4" name=S_DAY>
                            <option></option>  
                            <%  
                            	for (int j = 1; j < 32; j++) {  
                            	if (j < 10){%>        	  
                            	<option value=0<%=j%> <%if(String.valueOf(Integer.parseInt(S_DAY)).equals(String.valueOf(j))) out.print("selected");%>>0<%=j%></option>        		 	  
                            	<%}else{%>  
                            	<option value=<%=j%> <%if(String.valueOf(Integer.parseInt(S_DAY)).equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>  
                            	<%}%>  
                            <%}%>  
                            </select>日</font>  
                		    <button name='button1' onClick="popupCal('RptColumnfrm','S_YEAR,S_MONTH,S_DAY','BTN_date_1',event)">
            			    <img align="absmiddle" border='0' name='BTN_date_1' src='images/clander.gif'>
            			    </button>  
                         ～  
                    	<input type='text' name='E_YEAR' value="<%=E_YEAR%>" size='3' maxlength='3' onblur='CheckYear(this)'><font color='#000000'>年	
                    	<select id="hide5" name=E_MONTH>        						
                    		<%
                    			for (int j = 1; j <= 12; j++) {			
                    			if (j < 10){%>        	
                    			<option value=0<%=j%> <%if(String.valueOf(Integer.parseInt(E_MONTH)).equals(String.valueOf(j))) out.print("selected");%>>0<%=j%></option>        		
                    			<%}else{%>
                    			<option value=<%=j%> <%if(String.valueOf(Integer.parseInt(E_MONTH)).equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
                    			<%}%>
                    		<%}%>
                    		</select><font color='#000000'>月</font>
                    		<select id="hide6" name=E_DAY>
                            <option></option>  
                            <%  
                            	for (int j = 1; j < 32; j++) {  
                            	if (j < 10){%>        	  
                            	<option value=0<%=j%> <%if(String.valueOf(Integer.parseInt(E_DAY)).equals(String.valueOf(j))) out.print("selected");%>>0<%=j%></option>        		 	  
                            	<%}else{%>  
                            	<option value=<%=j%> <%if(String.valueOf(Integer.parseInt(E_DAY)).equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>  
                            	<%}%>  
                            <%}%>  
                            </select>日</font>  
                		    <button name='button1' onClick="popupCal('RptColumnfrm','E_YEAR,E_MONTH,E_DAY','BTN_date_2',event)">
            			    <img align="absmiddle" border='0' name='BTN_date_2' src='images/clander.gif'>
            			    </button>  
                    		<input type=hidden name=S_DATE value=''>
                    		<input type=hidden name=E_DATE value=''>
                        </td>
                    </tr> 
                    <!-- 系統類別-->
                    <tr class="sbody">
                     <td class="body_bgcolor"><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">系統類別 :</span>
                       <input name='sysType' type='radio' value='1' <%if(sysType.equals("1"))out.print("checked");%>>申報系統
                       <input name='sysType' type='radio' value='2' <%if(sysType.equals("2"))out.print("checked");%>>MIS管理系統
                       <input name='sysType' type='radio' value='ALL' <%if(sysType.equals("ALL"))out.print("checked");%>>全部        	     			   
                     </td>
                    </tr>    
                    <!-- 登入狀態-->
                    <tr class="sbody">
                     <td class="body_bgcolor"><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">登入狀態 :</span>                       
                        <input name='loginFlag' type='radio' value='Y' <%if(loginFlag.equals("Y"))out.print("checked");%>>成功
                        <input name='loginFlag' type='radio' value='N' <%if(loginFlag.equals("N"))out.print("checked");%>>失敗
                        <input name='loginFlag' type='radio' value='ALL' <%if(loginFlag.equals("ALL"))out.print("checked");%>>全部        
                     </td>
                    </tr>    
                    <!-- 輸出格式-->
                    <tr class="sbody">
                     <td class="body_bgcolor"><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">輸出格式 :</span>
                       <input name='printStyle' type='radio' value='xls' <%if(printStyle.equals("xls"))out.print("checked");%>>Excel
                       <input name='printStyle' type='radio' value='ods' <%if(printStyle.equals("ods"))out.print("checked");%>>ODS
                       <input name='printStyle' type='radio' value='pdf' <%if(printStyle.equals("pdf"))out.print("checked");%>>PDF        
                     </td>
                    </tr>   
                    <!-- 報表欄位.可挑選項目-->
                    <tr> 
                      <td class="body_bgcolor"> 
                      <table width="750" border="0" align="center" cellpadding="1" cellspacing="1" class="body_bgcolor">      
                          <tr> 
                            <td width="215">  
                            <table>
                            <tr class="sbody"><td align="center" class="chooseitem_bgcolor">可選擇項目</td></tr>
                            <tr><td>  
                            <select multiple  size=10  name="FieldListSrc" ondblclick="javascript:movesel(document.RptColumnfrm.FieldListSrc,document.RptColumnfrm.FieldListDst);" style="width: 292; height: 190">							
                    		</select>
                            </td></tr>
                    		</table>
                            </td>
                            <td width="52"><table width="40" border="0" align="center" cellpadding="3" cellspacing="3">
                                <tr> 
                                  <td>
                                  <div align="center">                                 
                                  <a href="javascript:movesel(document.RptColumnfrm.FieldListSrc,document.RptColumnfrm.FieldListDst);"><img src="images/arrow_right.gif" width="24" height="22" border="0"></a>
                                  </div>
                                  </td>
                                </tr>
                                <tr> 
                                  <td>
                                  <div align="center">                                  
                                  <a href="javascript:moveallsel(document.RptColumnfrm.FieldListSrc,document.RptColumnfrm.FieldListDst);"><img src="images/arrow_rightall.gif" width="24" height="22" border="0"></a>
                                  </div>
                                  </td>
                                </tr>
                                <tr> 
                                  <td>
                                  <div align="center">                                  
                                  <a href="javascript:movesel(document.RptColumnfrm.FieldListDst,document.RptColumnfrm.FieldListSrc);"><img src="images/arrow_left.gif" width="24" height="22" border="0"></a>
                                  </div>
                                  </td>
                                </tr>
                                <tr> 
                                  <td height="22">
                                  <div align="center">                                  
                                  <a href="javascript:moveallsel(document.RptColumnfrm.FieldListDst,document.RptColumnfrm.FieldListSrc);"><img src="images/arrow_leftall.gif" width="24" height="22" border="0"></a>
                                  </div>
                                  </td>
                                </tr>
                              </table></td>
                            <td width="340"> 
                            <table>
                            <tr class="sbody"><td align="center" class="chooseitem_bgcolor">已選擇項目</td></tr> 
                            <tr><td>
                            <select multiple size=10  name="FieldListDst" ondblclick="javascript:movesel(document.RptColumnfrm.FieldListDst,document.RptColumnfrm.FieldListSrc);" style="width: 292; height: 190">							
                    		</select>
                            </td></tr>
                    		</table>
                            </td>
                            <td width="130"><table width="116" border="0" align="center" cellpadding="3" cellspacing="3">
                                <tr>                                   
                                  <td width="24"><div align="center"><a href="javascript:moveup(document.RptColumnfrm.FieldListDst);"><img src="images/arrow_up.gif" width="24" height="22" border="0"></a></div></td>                        				        
                                  <td width="71" class="sbody">欄位上移</td>
                                </tr>
                                <tr> 
                                  <td width="24"><div align="center"><a href="javascript:movedown(document.RptColumnfrm.FieldListDst);"><img src="images/arrow_down.gif" width="24" height="22" border="0"></a></div></td>                        				        
                                  <td class="sbody">欄位下移</td>
                                </tr>
                              </table></td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    <tr> 
                     <td class="body_bgcolor">
                      <table width="750" border="0" cellpadding="1" cellspacing="1">
                       <tr>                           
                        <td width="750" align=left><font color="red" size=2>註：報表欄位按「登入期間」排序印出。</font></td>                              
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
<INPUT type="hidden" name=FieldList value=<%=request.getAttribute("FieldList")%>><!--//FieldList儲存所有的報表欄位名稱-->
<INPUT type="hidden" name=btnFieldList><!--//btnFieldList儲存已勾選的報表欄位名稱-->
</form>
<script language="JavaScript" >
<!-- 
    
<%//從session裡把勾選的報表欄位讀出來.放在FieldListDst 	
if(session.getAttribute("btnFieldList") != null && !((String)session.getAttribute("btnFieldList")).equals("")){ 
   System.out.println("DS094W_RptColumn.btnFieldList="+(String)session.getAttribute("btnFieldList"));
%>
	var bnlist;
	bnlist = '<%=(String)session.getAttribute("btnFieldList")%>';
	<%
	session.setAttribute("btnFieldList",null);//清除已勾選的勾選的報表欄位
    %>
	var a = bnlist.split(',');
	for (var i =0; i < a.length; i ++){
		var j = a[i].split('+');
		this.document.forms[0].FieldListDst.options[i] = new Option(j[1], j[0]);
	}
<%}%>

fn_loadFieldList(this.document.forms[0]);//顯示所有的報表欄位名稱

-->
</script>

</body>
</html>

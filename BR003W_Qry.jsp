<%
//94.01.20 create by 2295
//94.01.31 add 權限 by 2295
//94.03.24 add 區分營運中/已裁撤 by 2295
//99.12.30 fix 根據查詢年度.100年以後取得新縣市別.100年以前取得舊縣市別 by 2295
//108.05.31 add 報表格式轉換 by rock.tsai
//112.02.01 fix 無法挑選縣市別 by 6820
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%
  Map dataMap =Utility.saveSearchParameter(request);
  String report_no = "BR003W";	
  String act = Utility.getTrimString(dataMap.get("act"));				
  //94.03.24 add 營運中/已裁撤=================================================================================
  String cancel_no = ( request.getParameter("CANCEL_NO")==null ) ? "N" : (String)request.getParameter("CANCEL_NO");
  //===============================================================================================================
  String szExcelAction = (session.getAttribute("excelaction")==null)?"download":(String)session.getAttribute("excelaction");
  String bank_type = (session.getAttribute("nowbank_type")==null)?"":(String)session.getAttribute("nowbank_type");  
  String hsien_id = ( request.getParameter("HSIEN_ID")==null ) ? "ALL" : (String)request.getParameter("HSIEN_ID");				  
  String YEAR  = Utility.getYear();
  String MONTH = Utility.getMonth();
  String S_YEAR = (session.getAttribute("S_YEAR")==null)?YEAR:(String)session.getAttribute("S_YEAR");	
  String S_MONTH = (session.getAttribute("S_MONTH")==null)?MONTH:(String)session.getAttribute("S_MONTH");
  String printStyle = (session.getAttribute("printStyle")==null)?"xls":(String)session.getAttribute("printStyle");//108.05.31 add
%>
<%@include file="./include/BR_bank_no_hsien_id.include" %>
<script src="js/jquery-3.5.1.min.js"></script>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<script language="javascript" src="js/DSUtil.js"></script>
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
function doSubmit(cnd){   

   this.document.forms[0].action = "/pages/BR003W.jsp?act="+cnd;	
   this.document.forms[0].target = '_self';
   this.document.forms[0].submit();   
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

//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form method=post action='#' name='BankListfrm'>
<INPUT type="hidden" name=bank_type value=<%=bank_type%>>
<INPUT type="hidden" name=agri_loan value="0"><!--//專案農貸註記-->
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
                <td width="150"><img src="images/banner_bg1.gif" width="200" height="17"></td>
                <td width="300"><font color='#000000' size=4> 
                  <center>
                    <font color="#336600"><%=((bank_type.equals("6"))?"農會":"漁會")+Utility.getPgName(report_no)%></font>
                  </center>
                  </font> </td>
                <td width="150"><img src="images/banner_bg1.gif" width="200" height="17"></td>
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
                      	  <input type='radio' name="excelaction" value='download' checked> 下載報表                         
                      	   <%if(Utility.getPermission(request,report_no,"P")){//Print--有列印權限時 %> 
                      	  <a href="javascript:doSubmit('createRpt');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image411','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image411" width="66" height="25" border="0" id="Image41"></a> 
                      	  <%}%>
                          <a href="javascript:AskReset(this.document.forms[0]);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image511','','images/bt_cancelb.gif',0)"><img src="images/bt_cancel.gif" name="Image511" width="66" height="25" border="0" id="Image51"></a>                       	  
                          <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image611','','images/bt_reporthelpb.gif',1)"><img src="images/bt_reporthelp.gif" name="Image611" width="80" height="25" border="0" id="Image61"></a> 
                        </div></td>
                    </tr>
                   <!--查詢年月-->
                   <tr class="sbody">
                     <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">查詢年月 :</span> 						  						
                        <input type='text' name='S_YEAR' value="<%=S_YEAR%>" size='3' maxlength='3' onblur='CheckYear(this)' onchange="javascript:changeCity(document.BankListfrm.HSIEN_ID, document.BankListfrm.S_YEAR, document.BankListfrm);changeOption(document.BankListfrm,'change');"><font color='#000000'>年
                   		<select id="hide1" name=S_MONTH>        						
                   		<%
                   			for (int j = 1; j <= 12; j++) {			
                   			if (j < 10){%>        	
                   			<option value=0<%=j%> <%if(String.valueOf(Integer.parseInt(S_MONTH)).equals(String.valueOf(j))) out.print("selected");%>>0<%=j%></option>        		
                   			<%}else{%>
                   			<option value=<%=j%> <%if(String.valueOf(Integer.parseInt(S_MONTH)).equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
                   			<%}%>
                   		<%}%>
                   		</select><font color='#000000'>月</font>
                   		<input type=hidden name=S_DATE value=''>
                   		
                       </td>
                   </tr> 
                   <!-- 1.營運中/裁撤別 2.縣市別-->  
                   <tr class="sbody">
                    <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">營運中/裁撤別 :</span> 	 
                     <select name='CANCEL_NO'>
                     	<option  value="N" <%if((!cancel_no.equals("")) && cancel_no.equals("N")) out.print("selected");%>>營運中</option>
                     	<option  value="Y" <%if((!cancel_no.equals("")) && cancel_no.equals("Y")) out.print("selected");%>>已裁撤</option>
                     </select>
                    </td>
                   </tr>
                                             
                   <tr class="sbody">                           
                     <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">縣市別 :</span>                                                            
                        <select name="HSIEN_ID"> 
                        <option value="ALL">全部</option>                                                             
                       </select>
                     </td>
                   </tr>
                    <%@include file="./include/DS_PrintStyle.include" %><!-- 輸出格式 -->
                    <tr> 
                      <td bgcolor="#E9F4E3"><div align="center">
                          <table width="300" border="0" cellpadding="1" cellspacing="1">
                            <tr> 
                              <td width="34"><img src="images/print_1.gif" width="34" height="34"></td>
                              <td width="539"><font color="#CC6600">本報表採用A4紙張橫印 
                                </font></td>
                            </tr>
                          </table>
                        </div></td>
                    </tr>
                       </table></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
        </tr>    
      </table>
    </td>
  </tr>
</table>
</form>
<script language="JavaScript" >
<!--

setSelect(this.document.forms[0].HSIEN_ID,"<%=hsien_id%>");
setSelect(this.document.forms[0].CANCEL_NO,"<%=cancel_no%>");
changeCity(this.document.forms[0].HSIEN_ID, this.document.forms[0].S_YEAR, this.document.forms[0]);
-->
</script>
</body>
</html>

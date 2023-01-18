<%
// 95.07.10 create by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Calendar" %>
<%
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");					
	//94.03.23 add 營運中/已裁撤===================================================================================
	String cancel_no = ( session.getAttribute("CANCEL_NO")==null ) ? "N" : (String)session.getAttribute("CANCEL_NO");				
	//========================================================================================================
	String bank_type = (session.getAttribute("nowbank_type")==null)?"":(String)session.getAttribute("nowbank_type");
	String title=(bank_type.equals("6"))?"農會":"漁會";
	Calendar rightNow = Calendar.getInstance();
   	String YEAR  = String.valueOf(rightNow.get(Calendar.YEAR)-1911); //回覆值為西元年故需-1911取得民國年;
   	String MONTH = String.valueOf(rightNow.get(Calendar.MONTH)+1);   //月份以0開始故加1取得實際月份;
   	if(MONTH.equals("1")){//若本月為1月份是..則是申報上個年度的12月份
       YEAR = String.valueOf(Integer.parseInt(YEAR) - 1);
       MONTH = "12";
    }else{    
       MONTH = String.valueOf(Integer.parseInt(MONTH) - 1);//申報上個月份的
    }        
	String S_YEAR = ( request.getParameter("S_YEAR")==null ) ? YEAR : (String)request.getParameter("S_YEAR");		
	String S_MONTH = ( request.getParameter("S_MONTH")==null ) ? MONTH : (String)request.getParameter("S_MONTH");		
    String E_YEAR = ( request.getParameter("S_YEAR")==null ) ? YEAR : (String)request.getParameter("S_YEAR");		
	String E_MONTH = ( request.getParameter("S_MONTH")==null ) ? MONTH : (String)request.getParameter("S_MONTH");		
    
	
	String szExcelAction = (session.getAttribute("excelaction")==null)?"download":(String)session.getAttribute("excelaction");
	System.out.println("FR0066WA_BankList.szExcelAction="+szExcelAction);
	String hsien_id = ( session.getAttribute("HSIEN_ID")==null ) ? "ALL" : (String)session.getAttribute("HSIEN_ID");				
	System.out.println("FR0066WA_BankList.hsien_id="+hsien_id);
	String sqlCmd = " select bn01.bn_type,wlx01.hsien_id,bn01.bank_no, bn01.bank_name from bn01,wlx01 "
			      + " where bank_type = ?";
	/*		      
	if(cancel_no.equals("Y")){//已裁撤
	   sqlCmd += "  and bn_type = '2'";
	}else{//營運中
	   sqlCmd += "  and bn_type <> '2'";
	}*/			  
	 List paramList = new ArrayList();		
	paramList.add(bank_type);
	sqlCmd += " and bn01.bank_no = wlx01.bank_no "
		    + " order by wlx01.hsien_id,bn01.bank_no";
				  
    List tbankList = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");
    
    //取得FR0066WA的權限
	Properties permission = ( session.getAttribute("FR0066WA")==null ) ? new Properties() : (Properties)session.getAttribute("FR0066WA"); 
	if(permission == null){
       System.out.println("FR0066WA_BankList.permission == null");
    }else{
       System.out.println("FR0066WA_BankList.permission.size ="+permission.size());               
    }	
    
    // XML Ducument for 總機構代碼 begin
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"TBankXML\">");
    out.println("<datalist>");
    for(int i=0;i< tbankList.size(); i++) {
        DataObject bean =(DataObject)tbankList.get(i);
        out.println("<data>");        
        out.println("<BnType>"+bean.getValue("bn_type")+"</BnType>");
        out.println("<HsienId>"+bean.getValue("hsien_id")+"</HsienId>");
        out.println("<bankValue>"+bean.getValue("bank_no")+"</bankValue>");
        out.println("<bankName>"+bean.getValue("bank_no")+bean.getValue("bank_name")+"</bankName>");
        out.println("</data>");
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 總機構代碼 end 	
%>



<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/FR0066WA.js"></script>
<script language="javascript" src="js/BRUtil.js"></script>
<script language="javascript" src="js/movesels.js"></script>
<script language="javascript" event="onresize" for="window"></script>
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
   if(cnd == 'createRpt'){      
      if(this.document.forms[0].BankListDst.length == 0){      	 
      	 alert('金融機構代碼必須選擇');
      	 return;
      }
      if(this.document.forms[0].btnFieldList.value == ''){
         alert('報表欄位必須選擇');
         return;
      }
   }   
   
   MoveSelectToBtn(this.document.forms[0].BankList, this.document.forms[0].BankListDst);	
   fn_ShowPanel(cnd);      
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
//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form method=post action='#' name='BankListfrm'>
<table width="780" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
     <td>&nbsp;</td>
  </tr>
  <tr> 
    <td bgcolor="#FFFFFF">
	<table width="780" border="0" align="center" cellpadding="1" cellspacing="1">        
        <tr> 
          <td><table width="780" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="220"><img src="images/banner_bg1.gif" width="220" height="17"></td>
                <td width="340"><font color='#000000' size=4> 
                  <center>
                    <font color="#336600"><%=title%>信用部違反法定比率規定分析明細表</font>
                  </center>
                  </font> </td>
                <td width="220"><img src="images/banner_bg1.gif" width="220" height="17"></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td><img src="images/space_1.gif" width="8" height="8"></td>
        </tr>
        <tr> 
          <td><table width="780" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#5DA525">
              <tr> 
                <td bordercolor="#E9F4E3" bgcolor="#E9F4E3"><table width="780" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#E9F4E3">
                    <tr> 
                      <td bgcolor="#B0D595" class="sbody"> <div align="right">
                          <!--input type='radio' name="excelaction" value='view' <%if(szExcelAction.equals("view")){out.print("checked");}%> >檢視報表-->
                      	  <input type='radio' name="excelaction" value='download' <%if(szExcelAction.equals("download")){out.print("checked");}%> >下載報表
                      	  <%if(permission != null && permission.get("P") != null && permission.get("P").equals("Y")){//Print %>                   	        	                                   		     			        
                      	  <a href="javascript:doSubmit('createRpt');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image41','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image41" width="66" height="25" border="0" id="Image41"></a> 
                      	  <%}%>
                          <a href="javascript:ResetAllData();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image51','','images/bt_cancelb.gif',0)"><img src="images/bt_cancel.gif" name="Image51" width="66" height="25" border="0" id="Image51"></a> 
                          <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image61','','images/bt_reporthelpb.gif',1)"><img src="images/bt_reporthelp.gif" name="Image61" width="80" height="25" border="0" id="Image61"></a> 
                        </div></td>
                    </tr>
                    <tr> 
                      <td bgcolor="#CDE6BF"> <table width="700" border="0" align="center" cellpadding="1" cellspacing="1" class="sbody">
                          <tr class="sbody"> 
                            <td width="100"><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"> 
                              <a href="#"><font color="#CC6600">1.金融機構</font></a></td>
                            <td width="100"><a href="javascript:doSubmit('RptColumn')"><font color='black'>2.報表欄位</font></a></td>                            
                            <td width="100"><a href="javascript:doSubmit('RptOrder')"><font color='black'>3.排序欄位</font></a></td>
                            <td width="100"><a href="javascript:doSubmit('RptStyle')"><font color='black'>4.報表格式</font></a></td>
                          </tr>
                        </table></td>
                    </tr>
                    <tr> 
                      <td bgcolor="#E9F4E3"> <table width="780" border="0" align="center" cellpadding="0" cellspacing="0">
                          <tr>
                          <td><span class="mtext">起迄年月 :</span> 						  						
                            <input type='text' name='S_YEAR' value="<%=YEAR%>" size='3' maxlength='3' onblur='CheckYear(this)'>
        						<font color='#000000'>年
        						<select id="hide1" name=S_MONTH>        						
        						<%
        							for (int j = 1; j <= 12; j++) {
        							if (j < 10){%>        	
        							<option value=0<%=j%> <%if(MONTH.equals(String.valueOf(j))) out.print("selected");%>>0<%=j%></option>        		
            						<%}else{%>
            						<option value=<%=j%> <%if(MONTH.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select><font color='#000000'>月</font>
        					~ 
        					<input type='text' name='E_YEAR' value="<%=YEAR%>" size='3' maxlength='3' onblur='CheckYear(this)'>
        						<font color='#000000'>年
        						<select id="hide1" name=E_MONTH>        						
        						<%
        							for (int j = 1; j <= 12; j++) {
        							if (j < 10){%>        	
        							<option value=0<%=j%> <%if(MONTH.equals(String.valueOf(j))) out.print("selected");%>>0<%=j%></option>        		
            						<%}else{%>
            						<option value=<%=j%> <%if(MONTH.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select><font color='#000000'>月</font>	
                          </td>
                          </tr>  
                          
                          <tr>
                          <td><span class="mtext">違反法定比率 :</span> 	 
                           <select name='CANCEL_NO' onchange="javascript:changeOption(document.forms[0],'change');">
                            <option  value="Y" <%if((!cancel_no.equals("")) && cancel_no.equals("Y")) out.print("selected");%>>違反</option>
                           	<option  value="N" <%if((!cancel_no.equals("")) && cancel_no.equals("N")) out.print("selected");%>>不違反</option>                           	
                           </select>
                          </td>
                          </tr>
                          
                          <tr>
                          <td><span class="mtext">營運中/裁撤別 :</span> 	 
                           <select name='CANCEL_NO' onchange="javascript:changeOption(document.forms[0],'change');">
                           	<option  value="N" <%if((!cancel_no.equals("")) && cancel_no.equals("N")) out.print("selected");%>>營運中</option>
                           	<option  value="Y" <%if((!cancel_no.equals("")) && cancel_no.equals("Y")) out.print("selected");%>>已裁撤</option>
                           </select>
                          </td>
                          </tr>
                          
                          <tr> 
                          <%
                          List hsien_id_data = DBManager.QueryDB_SQLParam("select distinct hsien_id,hsien_name from cd01",null,""); 
                          %>
                            <td><span class="mtext">縣市別 :</span>                                
                               <select name="HSIEN_ID" onchange="javascript:changeOption(document.forms[0],'');">                               
                                <option value="ALL">全部</option>
                                <%for(int i=0;i<hsien_id_data.size();i++){%>                                
                                <option value="<%=(String)((DataObject)hsien_id_data.get(i)).getValue("hsien_id")%>"
                                <%if(((String)((DataObject)hsien_id_data.get(i)).getValue("hsien_id")).equals(hsien_id)) out.print("selected");%>
                                ><%=(String)((DataObject)hsien_id_data.get(i)).getValue("hsien_name")%></option>                            
                                <%}%>
                              </select>
                            </td>
                          </tr>
                        </table></td>
                    </tr>
                    <tr> 
                      <td bgcolor="#E9F4E3"> <table width="779" border="0" align="center" cellpadding="1" cellspacing="1" bgcolor="#E9F4E3">
                          <tr> 
                            <td width="195">  
                            <select multiple  size=10  name="BankListSrc" ondblclick="javascript:movesel(this.document.forms[0].BankListSrc,this.document.forms[0].BankListDst);" style="width: 300">							
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
                           <select multiple size=10  name="BankListDst" ondblclick="javascript:movesel(this.document.forms[0].BankListDst,this.document.forms[0].BankListSrc);" style="width: 300">							
							</select>
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
<INPUT type="hidden" name=BankList><!--//BankList儲存已勾選的金融機構代碼-->
<INPUT type="hidden" name=btnFieldList value='<%if(session.getAttribute("btnFieldList") != null) out.print((String)session.getAttribute("btnFieldList"));%>'><!--//btnFieldList儲存已勾選的報表欄位名稱-->
</form>
<script language="JavaScript" >
<!--

<%
//從session裡把勾選的金融機構代碼讀出來.放在BankListDst
if(session.getAttribute("BankList") != null && !((String)session.getAttribute("BankList")).equals("")){ 
   System.out.println("FR0066WA_BankList.BankList="+(String)session.getAttribute("BankList"));
%>
var bnlist;
bnlist = '<%=(String)session.getAttribute("BankList")%>';
var a = bnlist.split(',');
for (var i =0; i < a.length; i ++){
	var j = a[i].split('+');
	this.document.forms[0].BankListDst.options[i] = new Option(j[1], j[0]);
}
<%}%>

setSelect(this.document.forms[0].HSIEN_ID,"<%=hsien_id%>");
setSelect(this.document.forms[0].CANCEL_NO,"<%=cancel_no%>");
changeOption(this.document.forms[0],'');
function clearBankList(){
 <%
	session.setAttribute("BankList",null);//清除已勾選的BankList
 %>
}
-->
</script>

</body>
</html>

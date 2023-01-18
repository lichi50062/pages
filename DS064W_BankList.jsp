<%
//108.05.02 add 報表格式轉換 by 2295
//111.04.11 調整Edge無法挑選縣市別/金融機構代碼無資料可挑選 by 2295
//111.04.11 調整Edge可選擇項目,dbclick時無法將項目移至已選擇項目 by 2295
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
	String report_no = "DS064W";
	String title = Utility.getPgName(report_no);
	String act = Utility.getTrimString(dataMap.get("act"));		
	
	//營運中/已裁撤===================================================================================
	String cancel_no = ( session.getAttribute("CANCEL_NO")==null ) ? "N" : (String)session.getAttribute("CANCEL_NO");				
	//========================================================================================================	
	String szExcelAction = (session.getAttribute("excelaction")==null)?"download":(String)session.getAttribute("excelaction");		
	
	String hsien_id = ( session.getAttribute("HSIEN_ID")==null ) ? "ALL" : (String)session.getAttribute("HSIEN_ID");				
	System.out.println(report_no+"_BankList.hsien_id="+hsien_id);
	String YEAR  = Utility.getYear();
   	String MONTH = Utility.getMonth();
	String S_YEAR = (session.getAttribute("S_YEAR")==null)?YEAR:(String)session.getAttribute("S_YEAR");
	String S_MONTH = (session.getAttribute("S_MONTH")==null)?MONTH:(String)session.getAttribute("S_MONTH");            
   	String Unit = (session.getAttribute("Unit")==null)?"":(String)session.getAttribute("Unit");   	   	
	String printStyle = (session.getAttribute("printStyle")==null)?"xls":(String)session.getAttribute("printStyle");//108.05.02 add 
	//95.11.10 取得登入者資訊=================================================================================================
	String muser_id = ( session.getAttribute("muser_id")==null ) ? "" : (String)session.getAttribute("muser_id");		
    String muser_bank_type = ( session.getAttribute("bank_type")==null ) ? "" : (String)session.getAttribute("bank_type");			
    //==============================================================================================================    	    
    String bank_type = (session.getAttribute("nowbank_type")==null)?"6":(String)session.getAttribute("nowbank_type");	    
	String DS_bank_type = (session.getAttribute("DS_bank_type")==null)?"6":(String)session.getAttribute("DS_bank_type");	
	System.out.print("nowbank_type="+(String)session.getAttribute("nowbank_type"));
	System.out.print(report_no+"_BankList.szExcelAction="+szExcelAction);
    System.out.print(":S_YEAR="+S_YEAR+":S_MONTH="+S_MONTH);
	System.out.println(":bank_type="+bank_type);
	/*
	農(漁)會別:農會/漁會/農漁會
	可選擇項目:顯示各農漁會信用部名稱;農會顯示所有農會信用部/漁會顯示所有漁會信用部/農漁會顯示所有農漁會信用部名稱
	*/
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
<script language="javascript" src="js/DSUtil.js"></script>
<script language="javascript" src="js/movesels.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>
<script language="JavaScript" type="text/JavaScript">
<!--
//102.11.11 add 漁會科目代號新舊無法同時列印
function doSubmit(cnd){
   if(cnd == 'createRpt'){      
      if(document.BankListfrm.BankListDst.length == 0){      	 
      	 alert('金融機構代碼必須選擇');
      	 return;
      }
      if(document.BankListfrm.btnFieldList.value == ''){
         alert('報表欄位必須選擇');
         return;
      }      
      if(!confirm("本項報表會執行10-15秒，是否確定執行？")){
         return;
      }   
   }   
   
   MoveSelectToBtn(document.BankListfrm.BankList, document.BankListfrm.BankListDst);	
   fn_ShowPanel('<%=report_no%>',cnd);      
}

//-->
</script>
<body leftmargin="0" topmargin="0">
<form method=post action='#' name='BankListfrm'>
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
                <td width="200"><img src="images/banner_bg1.gif" width="200" height="17"></td>
                <td width="*" class="title_font"><%=title %></td>
                <td width="200"><img src="images/banner_bg1.gif" width="200" height="17"></td>
              </tr>
            </table></td>
        </tr>
        <%@include file="./include/DS_bank_no_all_agriloan.include" %><!-- 金融機構所有欄位-->        
        
      </table>
    </td>
  </tr>
</table>
<INPUT type="hidden" name=BankList ><!--//BankList儲存已勾選的金融機構代碼-->
<INPUT type="hidden" name=btnFieldList value='<%if(session.getAttribute("btnFieldList") != null) out.print((String)session.getAttribute("btnFieldList"));%>'><!--//btnFieldList儲存已勾選的報表欄位名稱-->
<INPUT type="hidden" name=loan_item value='<%if(session.getAttribute("loan_item") != null) out.print((String)session.getAttribute("loan_item"));%>'>
<INPUT type="hidden" name=clearbtnFieldList><!--//儲存是否清除btnFieldList-->
<INPUT type="hidden" name=agri_loan value="1"><!--//專案農貸註記-->
</form>
<script language="JavaScript" >
<!--

<%
//從session裡把勾選的金融機構代碼讀出來.放在BankListDst
if(session.getAttribute("BankList") != null && !((String)session.getAttribute("BankList")).equals("")){ 
   System.out.println(report_no+"_BankList.BankList="+(String)session.getAttribute("BankList"));
%>
var bnlist;
bnlist = '<%=(String)session.getAttribute("BankList")%>';
var a = bnlist.split(',');
for (var i =0; i < a.length; i ++){
	var j = a[i].split('+');
	this.document.forms[0].BankListDst.options[i] = new Option(j[1], j[0]);
}
<%}%>

setSelect(document.BankListfrm.HSIEN_ID,"<%=hsien_id%>");
setSelect(document.BankListfrm.CANCEL_NO,"<%=cancel_no%>");
changeCity(document.BankListfrm.HSIEN_ID, document.BankListfrm.S_YEAR, document.BankListfrm);
//changeOption(this.document.forms[0],'');


-->
</script>

</body>
</html>

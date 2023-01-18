<%
// 98.08.15 create by 2295
// 95.08.30 若為農漁會時,則不可挑選金融機構代號 by 2295
// 95.09.14 add 加可選擇項目.已選擇項目by 2295
// 95.11.10 add 區分BOAF.MIS配色 by 2295
//          add 有農/漁會的menu時,才可顯示農/漁會;登入者為A111111111 or 農金局時,才可顯示農漁會 by 2295
//          add 可選機構代號權限設定 by 2295
// 		    add 登入者為A111111111 or 農金局時,才可選全部 by 2295
// 95.12.01 add 增加年月區間 by 2295
// 95.12.04 add 起始日期不可大於結束日期 by 2295
// 95.12.07 add 金融機構代號若本來選全部->各信用部 or 各信用部->全部,清空已選報表欄位/排序欄位 by 2295
// 99.04.29 fix 根據查詢年度.100年以後取得新縣市別.100年以前取得舊縣市別 by 2295
//          fix 查詢年月/金額單位/可選擇項目 套用共用include by 2295
//102.11.11 add 漁會科目代號新舊無法同時列印 by 2295
//108.03.22 add 報表格式轉換 by 2295
//108.04.25 add 所有欄位移至DS_bank_no_all.include(因多個include會造成多列空白) by 2295
//111.03.22 調整Edge無法挑選縣市別/金融機構代碼無資料可挑選 by 2295
//111.03.22 調整Edge可選擇項目,dbclick時無法將項目移至已選擇項目 by 2295
//111.03.22 調整Edge>.>>.<.<<及上移.下移無作用 by 2295
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
	String report_no = "DS001W";	
	String ds_memo1 = "(1)選取[全部]：係以「各縣市彙總表」之報表格式列印&nbsp;&nbsp;";//108.04.25 add		
	String ds_memo2 = "(2)選取[各信用部]：按「營運明細資料」的報表內容列印";//108.04.25 add		
	String act = Utility.getTrimString(dataMap.get("act"));		
	
	//營運中/已裁撤===================================================================================
	String cancel_no = ( session.getAttribute("CANCEL_NO")==null ) ? "N" : (String)session.getAttribute("CANCEL_NO");				
	//========================================================================================================	
	String szExcelAction = (session.getAttribute("excelaction")==null)?"download":(String)session.getAttribute("excelaction");		
	
	String hsien_id = ( session.getAttribute("HSIEN_ID")==null ) ? "ALL" : (String)session.getAttribute("HSIEN_ID");				
	System.out.println("DS001W_BankList.hsien_id="+hsien_id);
	String YEAR  = Utility.getYear();
   	String MONTH = Utility.getMonth();
	String S_YEAR = (session.getAttribute("S_YEAR")==null)?YEAR:(String)session.getAttribute("S_YEAR");
	String E_YEAR = (session.getAttribute("E_YEAR")==null)?YEAR:(String)session.getAttribute("E_YEAR");
	String S_MONTH = (session.getAttribute("S_MONTH")==null)?MONTH:(String)session.getAttribute("S_MONTH");            
	String E_MONTH = (session.getAttribute("E_MONTH")==null)?MONTH:(String)session.getAttribute("E_MONTH");            
   	String Unit = (session.getAttribute("Unit")==null)?"":(String)session.getAttribute("Unit");   
    String printStyle = (session.getAttribute("printStyle")==null)?"xls":(String)session.getAttribute("printStyle");//108.03.22 add		   	
	
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
%>
<%@include file="./include/DS_bank_no_hsien_id.include" %>

<script src="js/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/DSUtil.js"></script>
<script language="javascript" src="js/movesels.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
<!--
//102.11.11 add 漁會科目代號新舊無法同時列印
function doSubmit(cnd){
   if(cnd == 'createRpt'){      
      if(document.BankListfrm.BankListDst.length == 0){      	 
      	 alert('金融機構代碼必須選擇');
      	 return;
      }
      if(!chInput(document.BankListfrm,'BankList')) return;//95.12.04 add 起始日期不可大於結束日期
      //漁會科目代號新舊無法同時列印    
      if(document.BankListfrm.bank_type.value == '7'){
        if(parseInt(document.BankListfrm.S_YEAR.value)<=102 && parseInt(document.BankListfrm.E_YEAR.value)>=103){
          alert('漁會於103年起改用新的科目代號，新舊漁會科目代號無法同時輸出，請重新輸入結束日期');
          return;
        } 	 
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
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

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
                <td width="240"><img src="images/banner_bg1.gif" width="240" height="17"></td>
                <td width="*" class="title_font">A01營運明細資料表</td>
                <td width="240"><img src="images/banner_bg1.gif" width="240" height="17"></td>
              </tr>
            </table></td>
        </tr>
         <%@include file="./include/DS_bank_no_all.include" %><!-- 金融機構所有欄位-->         
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
   System.out.println("DS001W_BankList.BankList="+(String)session.getAttribute("BankList"));
%>
var bnlist;
bnlist = '<%=(String)session.getAttribute("BankList")%>';
var a = bnlist.split(',');
for (var i =0; i < a.length; i ++){
	var j = a[i].split('+');
	document.BankListfrm.BankListDst.options[i] = new Option(j[1], j[0]);
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

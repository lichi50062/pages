<%
//94.01.24 create by 2295
//94.01.31 add 權限 by 2295
//99.12.27 add 範本格式套用共用include by 2295
//101.06   add 報表欄位 by 2968
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%
	Map dataMap =Utility.saveSearchParameter(request);
	String report_no = "BR005W";	
	String act = Utility.getTrimString(dataMap.get("act"));					
	String szExcelAction = (session.getAttribute("excelaction")==null)?"view":(String)session.getAttribute("excelaction");
	//System.out.println("BR005W_RptStyle.szExcelAction="+szExcelAction);
	String bank_type = (session.getAttribute("nowbank_type")==null)?"":(String)session.getAttribute("nowbank_type");	
%>



<script language="javascript" src="js/Common.js"></script>
<!--script language="javascript" src="js/BR005W.js"></script>
<script language="javascript" src="js/BRUtil.js"></script-->
<script language="javascript" src="js/DSUtil.js"></script>
<script language="javascript" src="js/movesels.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
<!--
	function doSubmit(report_no,cnd){   
		if(cnd == 'createRpt'){
		      if(this.document.forms[0].BankList.value == ''){        
		         alert('金融機構代碼必須選擇');
		         return;
		      }
		    
		      if(this.document.forms[0].btnFieldList.value == ''){
		         alert('報表欄位必須選擇');
		         return;
		      }
		   }   
	   	//MoveSelectToBtn(this.document.forms[0].btnFieldList, this.document.forms[0].FieldListDst);		         
	   	fn_ShowPanel(report_no,cnd);      
	}

	function ResetAllData(){
	    if(confirm("確定要清除已選定的資料嗎？")){  	
	        this.document.forms[0].FieldListDst.length = 0;
	        this.document.forms[0].SortListDst.length = 0;
	        this.document.forms[0].BankListDst.length = 0;
	        //fn_loadFieldList(this.document.forms[0]);//顯示所有的報表欄位名稱
		}
		return;	
	}
//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form method=post action='#' name='RptStylefrm'>
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
                <td width="225"><img src="images/banner_bg1.gif" width="225" height="17"></td>
                <td width="300"><font color='#000000' size=4> 
                  <center>
                    <font color="#336600"><%=((bank_type.equals("6"))?"農會":"漁會")+Utility.getPgName(report_no)%></font>
                  </center>
                  </font> </td>
                <td width="225"><img src="images/banner_bg1.gif" width="225" height="17"></td>
              </tr>
            </table></td>
        </tr>
        <%@include file="./include/BR_RptStyle.include" %><!-- 報表格式(範本檔) -->  
      </table>
    </td>
  </tr>
</table>

<INPUT type="hidden" name=SortList><!--//btnSortList儲存已勾選的報表排序欄位名稱-->
<INPUT type="hidden" name=btnFieldList value='<%if(session.getAttribute("btnFieldList") != null) out.print((String)session.getAttribute("btnFieldList"));%>'><!--//btnFieldList儲存已勾選的報表欄位名稱-->
<INPUT type="hidden" name=BankList value='<%if(session.getAttribute("BankList") != null) out.print((String)session.getAttribute("BankList"));%>'><!--//BankList儲存已勾選的金融機構-->
</form>

</body>
</html>

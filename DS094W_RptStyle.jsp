<%
//110.10.06~08 created 系統登錄紀錄 by 2295
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
					
	String szExcelAction = (session.getAttribute("excelaction")==null)?"download":(String)session.getAttribute("excelaction");	
	String bank_type = (session.getAttribute("nowbank_type")==null)?"":(String)session.getAttribute("nowbank_type");	
	System.out.println(report_no+"_RptStyle.szExcelAction="+szExcelAction);
	
    List templateList = null;
    if(request.getAttribute("templateList") != null){
       templateList = (List)request.getAttribute("templateList");
       System.out.println("templateList.size()="+templateList.size());
    }else{
       System.out.println("templateList is null");
    }   
%>



<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/DSUtil.js"></script>
<script language="javascript" src="js/movesels.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>

<script language="JavaScript" type="text/JavaScript">
<!--

//95.11.20 add 報表格式fuction
//95.12.04 add 起始日期不可大於結束日期
function doSubmit_RptStyle(report_no,cnd){//for 報表格式用
   if(cnd == 'createRpt'){//產生報表      
      if(!chInput1(this.document.forms[0])) return;//95.12.04 add 起始日期不可大於結束日期
      if(this.document.forms[0].btnFieldList.value == ''){
         alert('報表欄位必須選擇');
         return;
      }
      if(!confirm("本項報表會執行10-15秒，是否確定執行？")){
         return;
      }   
   }else if(cnd == 'SaveRpt'){//儲存格式檔   
      if(this.document.forms[0].template.value == ''){
         alert('欲儲存格式之名稱不可為空白!!');
         return;
      }
      //95.11.20 add 欲儲存的格式名稱不可有底線符號 by 2295
      if(this.document.forms[0].template.value.indexOf('_') != -1 ){
         alert('欲儲存格式之名稱不可為有底線[ _ ]符號!!');
         return;
      }
      if(!confirm('是否確定儲存本格式名稱 ??')){         
         return;
      }  
   }else if(cnd == 'DeleteRpt' || cnd == 'ReadRpt'){//刪除/讀取格式檔   
      //alert(this.document.forms[0].template_list.length);
      var flag = false;  
      for(var i = 0 ; i < this.document.forms[0].template_list.length; i++) {    
          if(this.document.forms[0].template_list[i].selected == true ) {
             flag = true;
          }    
      }
      if (flag == false) {     
         alert('請至少選擇一筆範本名稱!!');
         return;
      }
      if(cnd == 'DeleteRpt'){
         if(!confirm('是否確定刪除本格式名稱 ??')){
            return;
         }
      }
      if(cnd == 'ReadRpt'){   
	     if(!confirm('是否確定讀取本格式名稱 ??')){  
           return;
        }	   
      }         
   }
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
<form method=post action='#' name='RptStylefrm'>
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
     <td>&nbsp;</td>
  </tr>
  <tr> 
    <td bgcolor="#FFFFFF">
	<table width="791" border="0" align="center" cellpadding="1" cellspacing="1">        
        <tr> 
          <td width="824">
            <table width="797" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="180"><img src="images/banner_bg1.gif" width="180" height="17"></td>
                <td width="*" class="title_font"><%=Utility.getPgName(report_no)%></td>
                <td width="180"><img src="images/banner_bg1.gif" width="180" height="17"></td>
              </tr>
            </table>
          </td>
        </tr>
        <%@include file="./include/DS_RptStyle_AgriBank.include" %><!-- 報表格式(範本檔) -->   
    </table>
    </td>
  </tr>
</table>

<INPUT type="hidden" name=FieldList value=<%=request.getAttribute("FieldList")%>><!--//FieldList儲存所有的報表欄位名稱-->
<INPUT type="hidden" name=btnFieldList><!--//btnFieldList儲存已勾選的報表欄位名稱-->
<INPUT type="hidden" name=S_YEAR value='<%if(session.getAttribute("S_YEAR") != null) out.print((String)session.getAttribute("S_YEAR"));%>'><!--//95.12.04儲存已勾選的起始日期-年-->
<INPUT type="hidden" name=E_YEAR value='<%if(session.getAttribute("E_YEAR") != null) out.print((String)session.getAttribute("E_YEAR"));%>'><!--//95.12.04儲存已勾選的結束日期-年-->
<INPUT type="hidden" name=S_MONTH value='<%if(session.getAttribute("S_MONTH") != null) out.print((String)session.getAttribute("S_MONTH"));%>'><!--//95.12.04儲存已勾選的起始日期-月-->
<INPUT type="hidden" name=E_MONTH value='<%if(session.getAttribute("E_MONTH") != null) out.print((String)session.getAttribute("E_MONTH"));%>'><!--//95.12.04儲存已勾選的結束日期-月-->
<INPUT type="hidden" name=S_DAY value='<%if(session.getAttribute("S_DAY") != null) out.print((String)session.getAttribute("S_DAY"));%>'><!--//95.12.04儲存已勾選的起始日期-日-->
<INPUT type="hidden" name=E_DAY value='<%if(session.getAttribute("E_DAY") != null) out.print((String)session.getAttribute("E_DAY"));%>'><!--//95.12.04儲存已勾選的結束日期-日-->
<INPUT type="hidden" name=sysType value='<%if(session.getAttribute("sysType") != null) out.print((String)session.getAttribute("sysType"));%>'><!--//系統類別-->
<INPUT type="hidden" name=loginFlag value='<%if(session.getAttribute("loginFlag") != null) out.print((String)session.getAttribute("loginFlag"));%>'><!--//登入狀態-->
<INPUT type="hidden" name=S_DATE value=''><!--//登入期間-起始-->
<INPUT type="hidden" name=E_DATE value=''><!--//登入期間-結束-->
</form>

</body>
</html>

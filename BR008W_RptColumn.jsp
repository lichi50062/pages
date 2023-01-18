<%
//94.01.25 create by 2295
//94.01.31 add 權限 by 2295
//94.09.05 fix 拿掉檢視報表 by 2295
//99.01.08 add 增加卸任與否 by 2295
//99.12.29 add 報表欄位.可挑選項目套用共用include by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%
	String report_no = "BR008W";	
	Map dataMap =Utility.saveSearchParameter(request);
	String act = Utility.getTrimString(dataMap.get("act"));				
	String position_code = ( session.getAttribute("position_code")==null ) ? "ALL" : (String)session.getAttribute("position_code");				
	String abdicate_code = ( session.getAttribute("abdicate_code")==null ) ? "ALL" : (String)session.getAttribute("abdicate_code");				
	String bank_type = (session.getAttribute("nowbank_type")==null)?"":(String)session.getAttribute("nowbank_type");
	String title=(bank_type.equals("6"))?"農會":"漁會";
	String szExcelAction = (session.getAttribute("excelaction")==null)?"download":(String)session.getAttribute("excelaction");
	//System.out.println("BR008W_RptColumn.szExcelAction="+szExcelAction);
	System.out.println("BR008W_RptColumn.position_code="+position_code);		
%>

<script language="javascript" src="js/Common.js"></script>
<!--script language="javascript" src="js/BR008W.js"></script-->
<!--script language="javascript" src="js/BRUtil.js"></script-->
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
    
      if(this.document.forms[0].FieldListDst.length == 0){        
      	 alert('報表欄位必須選擇');
      	 return;
      }
   }   
   
   MoveSelectToBtn(this.document.forms[0].btnFieldList, this.document.forms[0].FieldListDst);		         
   fn_ShowPanel(report_no,cnd);      
}

function ResetAllData(){
    if(confirm("確定要清除已選定的資料嗎？")){  	
        this.document.forms[0].FieldListDst.length = 0;
        this.document.forms[0].POSITION_CODE[0].selected=true;	   
        fn_loadFieldList(this.document.forms[0]);//顯示所有的報表欄位名稱
	}
	return;	
}

//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form method=post action='#'>
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
        <tr> 
          <td><img src="images/space_1.gif" width="8" height="8"></td>
        </tr>
        <tr> 
          <td><table width="750" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#5DA525">
              <tr> 
                <td bordercolor="#E9F4E3" bgcolor="#E9F4E3"><table width="750" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#E9F4E3">
                    <tr> 
                      <td bgcolor="#B0D595" class="sbody"> <div align="right">
                          <!--input type='radio' name="excelaction" value='view' <%if(szExcelAction.equals("view")){out.print("checked");}%> >檢視報表-->
                      	  <input type='radio' name="excelaction" value='download' <%if(szExcelAction.equals("download")){out.print("checked");}%>>下載報表
                           <%if(Utility.getPermission(request,report_no,"P")){//Print--有列印權限時 %> 
                      	  <a href="javascript:doSubmit('<%=report_no%>','createRpt');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image411','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image411" width="66" height="25" border="0" id="Image41"></a> 
                      	  <%}%>
                          <a href="javascript:ResetAllData();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image511','','images/bt_cancelb.gif',0)"><img src="images/bt_cancel.gif" name="Image511" width="66" height="25" border="0" id="Image51"></a> 
                          <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image611','','images/bt_reporthelpb.gif',1)"><img src="images/bt_reporthelp.gif" name="Image611" width="80" height="25" border="0" id="Image61"></a> 
                        </div></td>
                    </tr>
                    <tr> 
                      <td bgcolor="#CDE6BF"> <table width="750" border="0" align="center" cellpadding="1" cellspacing="1" class="sbody">
                          <tr class="sbody"> 
                            <td width="100"><a href="javascript:doSubmit('<%=report_no%>','BankList')"><font color='black'>1.金融機構</font></a></td>                            
                            <td width="100"><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"> 
                              <a href="#"><font color="#CC6600">2.報表欄位</font></a></td>                           
                            <td width="100"><a href="javascript:doSubmit('<%=report_no%>','RptOrder')"><font color='black'>3.排序欄位</font></a></td>
                            <td width="100"><a href="javascript:doSubmit('<%=report_no%>','RptStyle')"><font color='black'>4.報表格式</font></a></td>
                          </tr>
                        </table></td>
                    </tr>
                    
                    <tr> 
                      <td bgcolor="#E9F4E3"> <table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
                          <tr class="sbody"> 
                          <%
                          List position_code_data = DBManager.QueryDB_SQLParam("select * from cdshareno where cmuse_div='008'",null,""); 
                          %>
                            <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">職稱 :</span>                                
                               <select name="POSITION_CODE">                               
                                <option value="ALL">全部</option>
                                <%for(int i=0;i<position_code_data.size();i++){%>                                
                                <option value="<%=(String)((DataObject)position_code_data.get(i)).getValue("cmuse_id")%>"
                                <%if(((String)((DataObject)position_code_data.get(i)).getValue("cmuse_id")).equals(position_code)) out.print("selected");%>
                                ><%=(String)((DataObject)position_code_data.get(i)).getValue("cmuse_name")%></option>                            
                                <%}%>
                              </select>
                            </td>
                          </tr >
                          <tr class="sbody"> 
                            <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">卸任與否 :</span>                                
                               <select name="ABDICATE_CODE">                               
                                <option value="ALL" <%if(abdicate_code.equals("ALL")) out.print("selected");%>>全部</option> 
                                <option value="N" <%if(abdicate_code.equals("N")) out.print("selected");%>>現任</option>                                                                  
                                <option value="Y" <%if(abdicate_code.equals("Y")) out.print("selected");%>>卸任</option>        
                              </select>
                            </td>
                          </tr>
                        </table></td>
                    </tr>
                    
                    <%@include file="./include/DS_RptColumn.include" %><!-- 報表欄位.可挑選項目-->   
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
<INPUT type="hidden" name=BankList value='<%if(session.getAttribute("BankList") != null) out.print((String)session.getAttribute("BankList"));%>'><!--//BankList儲存已勾選的金融機構代碼-->
</form>
<script language="JavaScript" >
<!-- 
    
<%//從session裡把勾選的報表欄位讀出來.放在FieldListDst 	
if(session.getAttribute("btnFieldList") != null && !((String)session.getAttribute("btnFieldList")).equals("")){ 
   System.out.println("BR008W_RptColumn.btnFieldList="+(String)session.getAttribute("btnFieldList"));
%>
	getbtnFieldList();
<%}%>
function getbtnFieldList(){
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
}	
fn_loadFieldList_BR(this.document.forms[0]);//顯示所有的報表欄位名稱

-->
</script>
</body>
</html>

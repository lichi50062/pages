<%
// 94.01.20 create by 2295
// 94.01.31 add 權限 by 2295
// 94.03.23 add 營運中/已裁撤 by 2295 
// 94.09.05 fix 拿掉檢視報表 by 2295
// 99.04.09 fix 因應縣市合併調整 by 2808
// 99.11.09 fix 機構單位排序&title對齊 by 2808
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.LinkedList" %> 
<%@ page import="java.util.Properties" %>
<%@include file="./include/bank_no_hsien_id.include" %>
<%!  
      String report_no = "FR025WA" ;
%>
<%
    
	//查詢條件值 
	Map dataMap =Utility.saveSearchParameter(request);
    showCancel_No=false;//顯示營運中/裁撤別
	showBankType=false;//顯示金融機構類別
	showCityType=true;//顯示縣市別
	showUnit=false;//顯示金額單位
	showPageSetting=false;//顯示報表列印格式
	setLandscape=false;//true:橫印
	
	String cancel_no = "" ;
	
	String act = Utility.getTrimString(dataMap.get("act")); 						
	String bank_type = (session.getAttribute("nowbank_type")==null)?"":(String)session.getAttribute("nowbank_type");
	String bankType = bank_type ;
	String title=(bank_type.equals("6"))?"農會":"漁會";
	
	String szExcelAction = (session.getAttribute("excelaction")==null)?"download":(String)session.getAttribute("excelaction");
	System.out.println("FR025WA_BankList.szExcelAction="+szExcelAction);
	String hsien_id = ( session.getAttribute("HSIEN_ID")==null ) ? "ALL" : (String)session.getAttribute("HSIEN_ID");				
	System.out.println("FR025WA_BankList.hsien_id="+hsien_id);
	
	List bankList = Utility.getBankList(request) ; 
    // XML Ducument for 總機構代碼 begin
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"BankXML\">");
    out.println("<datalist>");
    for(int i=0;i< bankList.size(); i++) { 
        bean =(DataObject)bankList.get(i);
        out.println("<data>");        
        out.println("<BnType>"+bean.getValue("bn_type")+"</BnType>");
        out.println("<HsienId>"+bean.getValue("hsien_id")+"</HsienId>");
        out.println("<bankValue>"+bean.getValue("bank_no")+"</bankValue>");
        out.println("<bankName>"+bean.getValue("bank_no")+bean.getValue("bank_name")+"</bankName>");
        out.println("<bankYear>"+bean.getValue("m_year").toString()+"</bankYear>");
        out.println("</data>");
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 總機構代碼 end 	
   	//取得目前年月資料
	String S_YEAR = Utility.getTrimString(dataMap.get("S_YEAR")) ; 
	String S_MONTH = Utility.getTrimString(dataMap.get("S_MONTH")) ; 
%>



<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/FR025WA.js"></script>
<script language="javascript" src="js/BRUtil.js"></script>
<script language="javascript" src="js/movesels.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<script language="javascript" src="js/HsienIDUtil.js"></script><!-- 根據查詢年月.挑選縣市別/總機構單位-->
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
<!--

function doSubmit(cnd){
   if(cnd == 'createRpt'){      
      if(this.document.forms[0].BankListDst.length == 0){      	 
      	 alert('金融機構代碼必須選擇');
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
<form name='form'  method=post action='#' id="form">
<input type='hidden' name="showTbank" value='false'><!-- 是否須顯示總機構單位 -->
<input type='hidden' name="showCityType" value='<%=showCityType%>'>
<table width='600' border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="20%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
    <td width="60%"><font color='#000000' size=4>
                  	<nobr>全體<%=title%>信用部ATM裝設台數及異動明細表</nobr>
                  	</font>
    </td>
    <td width="20%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
  </tr>
</table>
<table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
     <td>&nbsp;</td>
  </tr>
  <tr> 
    <td bgcolor="#FFFFFF">
	<table width="600" border="0" align="center" cellpadding="1" cellspacing="1">        
        <tr> 
          <td><img src="images/space_1.gif" width="8" height="8"></td>
        </tr>
        <tr> 
          <td><table width="600" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#5DA525">
              <tr> 
                <td bordercolor="#E9F4E3" bgcolor="#E9F4E3">
					<table width="600" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#E9F4E3">
                    <tr> 
                      <td bgcolor="#B0D595" class="sbody"> <div align="right">

                      	  <input type='radio' name="excelaction" value='download' <%if(szExcelAction.equals("download")){out.print("checked");}%> >下載報表
                      	  <%if(Utility.getPermission(request,report_no,"P")){//Print %>                   	        	                                   		     			        
                      	  <a href="javascript:doSubmit('createRpt');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image41','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image41" width="66" height="25" border="0" id="Image41"></a> 
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
						    <img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle">
							<span class="mtext">起迄年月 :</span> 						  						
                            <input type='text' name='S_YEAR' value="<%=YEAR%>" size='3' maxlength='3' onblur='CheckYear(this)' 
                                   onChange="changeCity('CityXML', form.cityType, form.S_YEAR, form);ctrBankListDst();">
        						<font color='#000000'>年</font>
        						<select id="hide1" name=S_MONTH>
        						<option></option>
        						<%
        							for (int j = 1; j <= 12; j++) {
        							if (j < 10){%>        	
        							<option value=0<%=j%> <%if(Integer.parseInt(MONTH)==j) out.print("selected");%>>0<%=j%></option>        		
            						<%}else{%>
            						<option value=<%=j%> <%if(Integer.parseInt(MONTH)==j) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select><font color='#000000'>月</font>
                        </td>
						</tr>
						<tr class="sbody">  
                       	<td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">縣市別 :</span>                                
                           <select size="1" id="cityType" name="cityType" onchange="javascript:changeOption(document.forms[0],'');ctrBankListDst();" />
  							  
                        </td>
                     	</tr>
	                    <tr class="sbody">
	                      <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">輸出格式 :</span>
	                          <input name='printStyle' type='radio' value='xls' checked>Excel
	                          <input name='printStyle' type='radio' value='ods' >ODS
	                          <input name='printStyle' type='radio' value='pdf' >PDF
			              </td>
	                    </tr>
                        </table>
						</td>
                    </tr> 
                    <tr> 
                      <td bgcolor="#E9F4E3"> <table width="579" border="0" align="center" cellpadding="1" cellspacing="1" bgcolor="#E9F4E3">
                          <tr> 
                            <td width="195">  
                            <select multiple  size=10 id="BankListSrc" name="BankListSrc" ondblclick="javascript:movesel(this.document.forms[0].BankListSrc,this.document.forms[0].BankListDst);" style="width: 17em">							
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
                           <select multiple size=10  id="BankListDst" name="BankListDst" ondblclick="javascript:movesel(this.document.forms[0].BankListDst,this.document.forms[0].BankListSrc);" style="width: 17em">							
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
   System.out.println("FR025WA_BankList.BankList="+(String)session.getAttribute("BankList"));
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


changeOption(this.document.forms[0],'');
function clearBankList(){
 <%
	session.setAttribute("BankList",null);//清除已勾選的BankList
 %>
}
-->
</script>
<script language="JavaScript" >
<!--
changeCity('CityXML', form.cityType, form.S_YEAR, form);
changeOption(this.document.forms[0],'');

function ctrBankListDst(){
	//移除以選擇的地區========
	var target = document.getElementById("BankListDst");
   	target.length = 0;
	changeOption(this.document.forms[0],'');
}

-->
</script>
</body>
</html>

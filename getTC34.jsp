<%
//96.01.15 create 讀取TC權限 by 2295
//96.01.15 add 金融機構類別/縣市別.總機構單位.受檢單位可個別顯示 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<%
    //95.08.24 add 金融機構類別.縣市別.總機構單位.受檢單位可個別顯示=========================================================== 
    String pgid = ( request.getParameter("pgid")==null ) ? "" : (String)request.getParameter("pgid");					
    String showBank_Type = ( request.getParameter("showBank_Type")==null ) ? "true" : (String)request.getParameter("showBank_Type");					
    String showTBank = ( request.getParameter("showTBank")==null ) ? "true" : (String)request.getParameter("showTBank");					
    String showBank_No = ( request.getParameter("showBank_No")==null ) ? "true" : (String)request.getParameter("showBank_No");					
    String showhsien_id = ( request.getParameter("showhsien_id")==null ) ? "true" : (String)request.getParameter("showhsien_id");					
    String tc_title_width = ( request.getParameter("tc_title_width")==null ) ? "111" : (String)request.getParameter("tc_title_width");					
    String tc_value_width = ( request.getParameter("tc_value_width")==null ) ? "423" : (String)request.getParameter("tc_value_width");					
    System.out.println("showBank_Type="+showBank_Type);
    System.out.println("showTBank="+showTBank);
    System.out.println("showBank_No="+showBank_No);
    System.out.println("showhsien_id="+showhsien_id);
    //=========================================================================================================================
    List bankTypeList = (List)session.getAttribute("Bank_Type");//金融機構類別    
    List hsienIDList = (List)session.getAttribute("hsien_id");//縣市別
	List tBankList = (List)session.getAttribute("TBank");//總機構單位
    List bankNoList = (List)session.getAttribute("Bank_No");//受檢單位
    
    
    // XML Ducument for 縣市別 begin
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"HsienIDXML\">");
    out.println("<datalist>");
    for(int i=0;i< hsienIDList.size(); i++) {
        DataObject bean =(DataObject)hsienIDList.get(i);
        out.println("<data>");
        out.println("<bankType>"+bean.getValue("bank_type")+"</bankType>");//金融機構類別
        out.println("<bankCity>"+bean.getValue("hsien_id")+"</bankCity>");//縣市代碼        
        out.println("<bankName>"+bean.getValue("hsien_name")+"</bankName>");//縣市名稱
        out.println("</data>");        
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 縣市別 end
    
    // XML Ducument for 總機構代碼 begin
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"TBankXML\">");
    out.println("<datalist>");
    for(int i=0;i< tBankList.size(); i++) {
        DataObject bean =(DataObject)tBankList.get(i);
        out.println("<data>");
        out.println("<bankType>"+bean.getValue("bank_type")+"</bankType>");//金融機構類別
        out.println("<bankCity>"+bean.getValue("hsien_id")+"</bankCity>");//縣市代碼 
        out.println("<bankValue>"+bean.getValue("bank_no")+"</bankValue>");//總機構代碼
        out.println("<bankName>"+bean.getValue("bank_no")+"  "+bean.getValue("bank_name")+"</bankName>");//總機構名稱
        out.println("</data>");        
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 總機構代碼 end
    
    // XML Ducument for 受檢代碼 begin
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"BankNoXML\">");
    out.println("<datalist>");
    for(int i=0;i< bankNoList.size(); i++) {
        DataObject bean =(DataObject)bankNoList.get(i);
        out.println("<data>");
        out.println("<bankType>"+bean.getValue("tbank_no")+"</bankType>");//總機構代碼
        out.println("<bankValue>"+bean.getValue("bank_no")+"</bankValue>");//分支機構代碼
        out.println("<bankName>"+bean.getValue("bank_no")+"  "+bean.getValue("bank_name")+"</bankName>");//分支機構名稱
        out.println("</data>");        
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 受檢代碼 end 
  
%>
<%//金融機構類別.縣市別==================================================================================================%>
<span id="bankType_div" style="display:block;">
<table border=1 width='100%' align=center bgcolor="#FFFFF" bordercolor="#76C657">
<tr class="sbody">
<td width="<%=tc_title_width%>" bgcolor="#BDDE9C" height="1">金融機構類別</td>
<td width="<%=tc_value_width%>" bgcolor="#EBF4E1" height="1">
   <select size="1" name="bankType" onChange="checkCity();resetOption_TC34();changeHsienID('HsienIDXML',form.cityType,form.bankType,form);changeCity_TC34('TBankXML','BankNoXML', form.tbank, form.cityType, form)">        											  
   <option value="">全部類別</option>
	<%if(bankTypeList != null) {
         for(int i=0; i < bankTypeList.size(); i++) {
             DataObject bean =(DataObject)bankTypeList.get(i); %>   
     <option value="<%=bean.getValue("cmuse_id")%>"><%=bean.getValue("cmuse_name")%></option>
	<%   }
     }%>
  </select> 
  縣市別:&nbsp;&nbsp; 
  <select size="1" name="cityType" onChange="changeCity_TC34('TBankXML','BankNoXML', form.tbank, form.cityType, form)<%if(showTBank.equals("false")) out.print(";changeOption('BankNoXML',form.examine, form.tbank, 'TBankXML');");%>" >
     <option value="" >全部</option>
  </select>    
</td>
</tr>
</table>
</span>

<%//總機構單位=======================================================================================================================%>
<span id="tbank_div" style="display:<%if(showTBank.equals("false")) out.print("none;"); else out.print("block;");%>">
<table border=1 width='100%' align=center bgcolor="#FFFFF" bordercolor="#76C657">
<tr class="sbody">
  <td width="<%=tc_title_width%>" bgcolor="#BDDE9C" height="1"><%if(pgid.equals("TC34")) out.print("金融機構"); else out.print("受檢單位");%></td>
  <td width="<%=tc_value_width%>" bgcolor="#EBF4E1" height="1">           
     <select size="1" name="tbank">
       <option value="" >全部</option>
     </select>
  </td>
</tr>
</table>
</span>
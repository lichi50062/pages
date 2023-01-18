<%// 99.05.31 fix 縣市合併 by 2808 %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>

<%	
    String hsien_id = "";
    String disp_id = "";
    String exam_id = "";
    String exam_div = "";
    String appr_date = "";
    String basis = "";
    String ch_type = "";
    String prj_item = "";
    String prj_remark = "";
    String bank_type = "";
    String bank_no ="";
    String tbank_no = "";
    String dateY = "";
    String dateM = "";
    String dateD = "";


	String act = Utility.getTrimString(request.getParameter("act"));				
	System.out.println("Page: TC11_Edit.jsp    Action:"+act);
	
	
	// 取參數值
	if("Edit".equals(act)) {
	    DataObject bean = (DataObject)request.getAttribute("DetailData");
	    if(bean != null) {
	       disp_id = bean.getValue("disp_id") != null ? (String)bean.getValue("disp_id") : "";
           exam_id = bean.getValue("exam_id") != null ? (String)bean.getValue("exam_id") : "";
           exam_div = bean.getValue("exam_div") != null ? (String)bean.getValue("exam_div") : "";
           appr_date = bean.getValue("appr_date") != null ? (String)bean.getValue("appr_date") : "";
           basis = bean.getValue("basis") != null ? (String)bean.getValue("basis") : "";
           ch_type = bean.getValue("ch_type") != null ? (String)bean.getValue("ch_type") : "";
           prj_item = bean.getValue("prj_item") != null ? (String)bean.getValue("prj_item") : "";
           prj_remark = bean.getValue("prj_remark") != null ? (String)bean.getValue("prj_remark") : "";
           bank_type = bean.getValue("bank_type") != null ? (String)bean.getValue("bank_type") : "";
           tbank_no = bean.getValue("tbank_no") != null ? (String)bean.getValue("tbank_no") : "";
           bank_no = bean.getValue("bank_no") != null ? (String)bean.getValue("bank_no") : "";
           hsien_id = bean.getValue("hsien_id") != null ? (String)bean.getValue("hsien_id") : "";
           
           if(appr_date.length() == 8) {
               dateY = String.valueOf(Integer.parseInt(appr_date.substring(0,4))-1911);
               dateM = String.valueOf(Integer.parseInt(appr_date.substring(4,6)));
               dateD = String.valueOf(Integer.parseInt(appr_date.substring(6,8)));
           }
        }else{
           System.out.println("WARNING !!!  Search detail data is NULL ");
        }
	}else {
	    disp_id = request.getAttribute("disp_id" )== null  ? "" : (String)request.getAttribute("disp_id");
	    Calendar c = Calendar.getInstance();
	    dateY = String.valueOf(c.get(Calendar.YEAR)-1911);
	    dateM = String.valueOf(c.get(Calendar.MONTH)+1);
	    dateD = String.valueOf(c.get(Calendar.DATE));
	}
	System.out.println("disp_id ="+disp_id);	
	System.out.println("exam_id ="+exam_id);
	System.out.println("exam_div ="+exam_div);
	System.out.println("appr_date ="+appr_date);
	System.out.println("basis ="+basis);
	System.out.println("ch_type ="+ch_type);
	System.out.println("prj_item ="+prj_item);
	System.out.println("prj_remark ="+prj_remark);
	System.out.println("bank_type ="+bank_type);
	System.out.println("bank_no ="+bank_no);
	System.out.println("dateY ="+dateY);
	System.out.println("dateM ="+dateM);
	System.out.println("dateD ="+dateD);

	// 寫出 XML 資料
        List bankNoList = (List)request.getAttribute("Bank_No");
    List chTypeList = (List)request.getAttribute("Ch_Type");
    List bankTypeList = (List)request.getAttribute("Bank_Type");
	System.out.println("bankNoList size="+bankNoList.size());
    HashMap bankNoMap = new HashMap();
    // XML Ducument for 受檢代碼 begin
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"BankNoXML\">");
    out.println("<datalist>");
    for(int i=0;i< bankNoList.size(); i++) {
        DataObject bean =(DataObject)bankNoList.get(i);
        out.println("<data>");
        out.println("<bankType>"+bean.getValue("tbank_no")+"</bankType>");
        out.println("<bankValue>"+bean.getValue("bank_no")+"</bankValue>");
        out.println("<bankName>"+bean.getValue("bank_no")+"  "+bean.getValue("bank_name")+"</bankName>");
        out.println("</data>");
        bankNoMap.put(bean.getValue("bank_no"),bean.getValue("bank_name"));
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 受檢代碼 end 
    
    List tBankList = (List)request.getAttribute("TBank");
    // XML Ducument for 總機構代碼 begin
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"TBankXML\">");
    out.println("<datalist>");
    for(int i=0;i< tBankList.size(); i++) {
        DataObject bean =(DataObject)tBankList.get(i);
        out.println("<data>");
        out.println("<bankType>"+bean.getValue("bank_type")+"</bankType>");
        out.println("<bankCity>"+bean.getValue("hsien_id")+"</bankCity>");
        out.println("<bankValue>"+bean.getValue("bank_no")+"</bankValue>");
        out.println("<bankName>"+bean.getValue("bank_no")+"  "+bean.getValue("bank_name")+"</bankName>");
        out.println("<m_year>"+bean.getValue("m_year").toString()+"</m_year>") ;
        out.println("</data>");
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 總機構代碼 end 

    List cityList = (List)request.getAttribute("City");
	if(cityList!=null) {
		// XML Ducument for 縣市別 begin
	    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"CityXML\">");
	    out.println("<datalist>");
	    for(int i=0;i< cityList.size(); i++) {
	    	DataObject bean =(DataObject)cityList.get(i);
	        out.println("<data>");
	        out.println("<cityType>"+bean.getValue("hsien_id")+"</cityType>");
	        out.println("<cityName>"+bean.getValue("hsien_name")+"</cityName>");
	        out.println("<cityValue>"+bean.getValue("hsien_id")+"</cityValue>");
	        out.println("<cityYear>"+bean.getValue("m_year").toString()+"</cityYear>");
	        out.println("</data>");
	    }
	    out.println("</datalist>\n</xml>");
	    // XML Ducument for 縣市別 end
    }
    
    //取得TC11的權限
	Properties permission = ( session.getAttribute("TC11")==null ) ? new Properties() : (Properties)session.getAttribute("TC11"); 
	if(permission == null){
       System.out.println("TC11_Edit.permission == null");
    }else{
       System.out.println("TC11_Edit.permission.size ="+permission.size());
    }
  
    
    
    List expertList = (List)request.getAttribute("ExpertData");
    System.out.println("ExpertData size="+expertList.size());
    HashMap expertMap = new HashMap();
    // XML Ducument for 檢查人員專長 begin
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"ExpertXML\">");
    out.println("<datalist1>");
    for(int i=0;i< expertList.size(); i++) {
        DataObject bean =(DataObject)expertList.get(i);
        out.println("<data1>");
        out.println("<ID>"+bean.getValue("muser_id")+"</ID>");
        out.println("<Expert>"+bean.getValue("expertno_id")+"</Expert>");
        out.println("<Name>"+bean.getValue("expertno_name")+"</Name>");
        out.println("</data1>");
        expertMap.put(bean.getValue("expertno_id"),bean.getValue("expertno_name"));
        bean = null;
    }
    out.println("</datalist1>\n</xml>");
    // XML Ducument for 查檢人員專長 end
%>



<HTML>
<HEAD>
<TITLE>檢查行政系統 檢查派差</TITLE>
<META content=text/html; charset=UTF-8 >
</HEAD>
<script src="js/TC11.js"></script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
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
//-->
</script>

<BODY bgColor=#FFFFFF>
<Form name='form' method=post action='/pages/TC11.jsp'>
<input type='hidden' name='act' value=''>
<input type='hidden' name='appr_date' value=''>
<input type=hidden name=Function>
     <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr> 
           <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
           <td width="50%"><font color='#000000' size=4><b><center>檢查派差新增修改維護 </center></b></font> </td>
           <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
         </tr>
     </table>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
<tr>  
    <div align="right">
      <jsp:include page="getLoginUser.jsp" flush="true" />
    </div> 
</tr> 
</table>
<Table border=1 width="100%" align=center height="87" bgcolor="#FFFFF" bordercolor="#76C657">    
  <tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">派差通知單編號</td>
    <td width="416" bgcolor="#EBF4E1" height="1" ><input type="text" name="disp_id" size="10" maxlength="7" value="<%=disp_id%>" readonly>&nbsp;&nbsp<font color="#FF0000">(建檔時自動賦予)</font></td> 
  </tr>
  <tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">檢查證(函)編號</td>
    <td width="416" bgcolor="#EBF4E1" height="1">&nbsp;<input type="text" name="exam_id" size="32" maxlength="7" value="<%=exam_id%>"> 
    &nbsp;&nbsp;&nbsp;證(函) &nbsp;<select size="1" name="exam_div">
    <option value=''></option>
      <%List examDivList = (List) request.getAttribute("Exam_Div");
      if(examDivList != null) {
          for(int i=0; i < examDivList.size(); i++) {
             DataObject bean =(DataObject)examDivList.get(i);%>
    <option value='<%=bean.getValue("cmuse_id")%>'><%=bean.getValue("cmuse_name")%></option>
    <%    }
      } %>
    </select></td>
  </tr>
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">核派日期</td>
<td width="416" bgcolor="#EBF4E1" height="1">
<input type="text" name="dateY" size="3" maxlength="3" value="<%= dateY%>" onChange="chnageYear(form.dateY)"> 
  年 <select name="dateM">               
    <option value></option>
    <option value="1">01</option>
    <option value="2">02</option>
    <option value="3">03</option>
    <option value="4">04</option>
    <option value="5">05</option>
    <option value="6">06</option>
    <option value="7">07</option>
    <option value="8">08</option>
    <option value="9">09</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
  </select>月 <select name="dateD">               
    <option value></option>
    <option value="1">01</option>
    <option value="2">02</option>
    <option value="3">03</option>
    <option value="4">04</option>
    <option value="5">05</option>
    <option value="6">06</option>
    <option value="7">07</option>
    <option value="8">08</option>
    <option value="9">09</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
    <option value="13">13</option>
    <option value="14">14</option>
    <option value="15">15</option>
    <option value="16">16</option>
    <option value="17">17</option>
    <option value="18">18</option>
    <option value="19">19</option>
    <option value="20">20</option>
    <option value="21">21</option>
    <option value="22">22</option>
    <option value="23">23</option>
    <option value="24">24</option>
    <option value="25">25</option>
    <option value="26">26</option>
    <option value="27">27</option>
    <option value="28">28</option>
    <option value="29">29</option>
    <option value="30">30</option>
    <option value="31">31</option>
  </select>日</td>
</tr>
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">金融機構類別</td>
<td width="416" bgcolor="#EBF4E1" height="1">
   <select size="1" name="bankType" onChange="checkCity();resetOption();changeTbank('TBankXML',form.dateY);">
     
<%   if(bankTypeList != null) {
         for(int i=0; i < bankTypeList.size(); i++) {
             DataObject bean =(DataObject)bankTypeList.get(i);
%>   
     <option value="<%=bean.getValue("cmuse_id")%>"><%=bean.getValue("cmuse_name")%></option>
<%       }
     }
%>
  </select>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  縣市別:&nbsp;&nbsp;
  <select size="1" name="cityType" onChange="changeTbank('TBankXML',form.dateY);changeExamine('BankNoXML','TBankXML',form.dateY);" >
    </select>
  
  
  </td>
</tr>

<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">總機構單位</td>
<td width="416" bgcolor="#EBF4E1" height="1">           
  <select size="1" name="tbank" onChange='changeExamine("BankNoXML","TBankXML",form.dateY)'>
    <option value="" >全部</option>
  </select> </td>
</tr>

<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">受檢單位</td>
<td width="416" bgcolor="#EBF4E1" height="1">
  <select size="1" name="examine">
    <option value="" >全部</option>
  </select> </td>
</tr>
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">檢查性質</td>
<td width="416" bgcolor="#EBF4E1" height="1">
<select size="1" name="property">
<option value=''></option>
<% HashMap chTypeMap = new HashMap();
   if(chTypeList != null) {
       for(int i =0; i < chTypeList.size(); i++) {
           DataObject bean =(DataObject)chTypeList.get(i);
           chTypeMap.put(bean.getValue("cmuse_id"),bean.getValue("cmuse_name"));
%> 
    <option value="<%=bean.getValue("cmuse_id")%>"><%=bean.getValue("cmuse_name")%></option>
       
<%       }
     }
%>    
  </select> </td>
</tr>
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">檢查依據</td>
<td width="416" bgcolor="#EBF4E1" height="1">
<select size="1" name="basis">
<option value=''></option>
<%
   List basisList = (List) request.getAttribute("BasisList");
   if(basisList != null) {
       for(int i =0; i < basisList.size(); i++) {
           DataObject bean =(DataObject)basisList.get(i);
          
%> 
    <option value="<%=bean.getValue("basis_id")%>"><%=bean.getValue("basis_name")%></option>
       
<%       }
     }
%>   
</select></td>
</tr>
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">專案檢查項目</td>
<td width="416" bgcolor="#EBF4E1" height="1">
<input type="text" name="prj_item" size="50" maxlength="100" value="<%=prj_item%>"> 
</td>
</tr>
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">專案檢查備註</td>
<td width="416" bgcolor="#EBF4E1" height="1"><textarea rows="2" name="prj_remark" cols="53" ><%=prj_remark%></textarea></td>
</tr>
<tr class="sbody">
<td  bgcolor="#BDDE9C" height="17" colspan="2" nowrap v=''>&nbsp;&nbsp;&nbsp;&nbsp;檢查人員: 
<%
  List inspectorData = (List)request.getAttribute("InspectorData");
    System.out.println("InspectorData size="+inspectorData.size());
    HashMap inspectorMap = new HashMap();
%>  
  <select size="1" name="inspector" onChange="changeOption1(form)">
    <option value=''> </option>
    <%
    if(inspectorData != null) {
        for(int i=0; i < inspectorData.size(); i++) {
            DataObject bean =(DataObject)inspectorData.get(i);
            inspectorMap.put(bean.getValue("muser_id"),bean.getValue("muser_name"));
    %>
    <option value='<%=bean.getValue("muser_id")%>'><%=bean.getValue("muser_name")%></option>
<%      }
    }
    %>
  </select>&nbsp;&nbsp;&nbsp;&nbsp;查核項目: 
  <select size="1" name="expert" >
    <option value=''>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
  </select>&nbsp;&nbsp;&nbsp;&nbsp;
  <a href="javascript:addItem(form,'');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image110','','images/bt_07b.gif',1)"><img src="images/bt_07.gif" name="Image110"  border="0" id="Image110"></a> 
  </td>
</tr>

<tr class="sbody">
<td width="100%" bgcolor="#BDDE9C" colspan="2">

    <table border="1" width="100%" id="inspect"  bgcolor="#FFFFF" bordercolor="#76C657">   
      <tr class="sbody"  bgcolor="#BFDFAE">
        <td width="10%" align="center">&nbsp;</td>
        <td width="30%" align="center"> 姓名</td>  
        <td width="60%" align="center"> 查核項目</td> 
      </tr>    
    </table>

</td>
</tr>
</Table>
<table border=0 align=center width=550>
<tr class="sbody"><th>
<% if(act.equals("New")) {%>
<%if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){ %>
<a href="javascript:doSubmit(form,'Insert','');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_confirmb.gif',1)"><img src="images/bt_confirm.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a>
<a href="javascript:clearAll();"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image104','','images/bt_cancelb.gif',1)"><img src="images/bt_cancel.gif" name="Image104" width="66" height="25" border="0" id="Image104"></a>
<%}%>
<% } else if(act.equals("Edit")) {%>
<%if(permission != null && permission.get("U") != null && permission.get("U").equals("Y")){ %>
<a href="javascript:doSubmit(form,'Update','');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_updateb.gif',1)"><img src="images/bt_update.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a>
<%}%>
<%if(permission != null && permission.get("D") != null && permission.get("D").equals("Y")){ %>
<a href="javascript:doSubmit(form,'Delete','');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image103','','images/bt_deleteb.gif',1)"><img src="images/bt_delete.gif" name="Image103" width="66" height="25" border="0" id="Image103"></a>
<% }
} %>
<a href="javascript:history.back();"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image105" width="80" height="25" border="0" id="Image105"></a>

</th></tr></Table>
<table width="100%" border="0" cellpadding="1" cellspacing="1" class="sbody">
  <tr> 
    <td colspan="2">
      <font color='#990000'>
        <img src="images/arrow_1.gif" width="28" height="23" align="absmiddle">
        <font color="#007D7D" size="3">使用說明  : </font></font></td>
  </tr>
  <tr> 
    <td width="3%">&nbsp;</td>
    <td width="97%"> 
      <ul>                                                
        <%if(act.equals("List")) {%>
            <li>本網頁提供基本資料查詢功能。</li>
            <li>按<font color="#666666">【查詢】</font>則依查詢條件值查詢資料。</li> 
		    <li>按<font color="#666666">【新增】</font>則新增一筆資料。</li> 
        <% } else if(act.equals("Qry")) {%>
            <li>本網頁提供基本資料查詢功能。</li>
            <li>按<font color="#666666">【查詢】</font>則依查詢條件值查詢資料。</li> 
		    <li>按<font color="#666666">【新增】</font>則新增一筆資料。</li> 
		    <li>按<font color="#666666">【查詢資料連結】</font>則可修改或查看此筆資料。</li>
        <%} else if(act.equals("New")) {%>
            <li>本網頁提供基本資料維護功能。</li>
		    <li>按<font color="#666666">【確定】</font>即將資料寫入資料庫。</li> 
		    <li>按<font color="#666666">【取消】</font>放棄資料修改。</li>
		<%} else if(act.equals("Edit")) {%>
            <li>本網頁提供基本資料維護功能。</li>
            <li>按<font color="#666666">【修改】</font>即將修改資料寫入資料庫。</li> 
		    <li>按<font color="#666666">【刪除】</font>刪除這一筆資料。</li>
        <% } %> 
        <li>按<font color="#666666">【回上一頁】則回至上個畫面</font>。</li>
      </ul>
    </td>
 </tr>
</table>


</form>
</BODY>

<script language="JavaScript" >
<!--
//1.修改縣市別
setSelect(form.bankType,"<%=bank_type%>");
changeCity("CityXML",form.dateY) ;
setSelect(form.cityType,"<%=hsien_id%>");
//2.修改金融機構
changeTbank("TBankXML",form.dateY);
setSelect(form.tbank,"<%=tbank_no%>");
changeExamine("BankNoXML","TBankXML",form.dateY);
setSelect(form.examine,"<%=bank_no%>");

//changeOption('TBankXML',form.tbank, form.bankType, 'TBankXML');

//changeOption('BankNoXML',form.examine, form.tbank, 'TBankXML');

setSelect(form.property, "<%=ch_type%>");
setSelect(form.basis,'<%=basis%>')
setSelect(form.dateM,"<%=dateM%>");
setSelect(form.dateD,"<%=dateD%>");
setSelect(form.exam_div,"<%=exam_div%>");
checkCity();


<%
if(act.equals("Edit")) {
  List expertDataList = (List)request.getAttribute("ExpertDetailData");
  if(expertDataList != null) {
      System.out.println("ExpertDetailData Size= "+expertDataList.size());
      for(int i=0; i < expertDataList.size(); i++) {
            DataObject bean =(DataObject)expertDataList.get(i);
%>
addItem(form, '<%=bean.getValue("muser_id")%>', '<%=(String) inspectorMap.get(bean.getValue("muser_id"))%>', '<%=bean.getValue("exam_item")%>', '<%=(String) expertMap.get(bean.getValue("exam_item"))%>')
<%    }
  }
}
%>

-->
</script>
</HTML>

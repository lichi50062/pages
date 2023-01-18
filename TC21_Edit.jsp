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
    String disp_id = "";
    String exam_id = "";
    String exam_div = "";
    String ch_type = "";
    String bank_type = "";
    String cityType = "";
    String tbank_no = "";
    String bank_name = "";
    String bank_no ="";
    String come_docno = "";
    String receive_docno = "";
    String base_dateY ="";
    String base_dateM ="";
    String base_dateD ="";

    String come_dateY ="";
    String come_dateM ="";
    String come_dateD ="";
    
    String disabled = "";
    String hsien_id = "";
    String originunt_id = "2";
    boolean exist = false;
    
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");				
	System.out.println("Page: TC21_Edit.jsp    Action:"+act);
	
	Calendar c = Calendar.getInstance();
	String ware_dateY1 = String.valueOf(c.get(Calendar.YEAR)-1911);
	String ware_dateM1 = String.valueOf(c.get(Calendar.MONTH)+1);
	String ware_dateD1 = String.valueOf(c.get(Calendar.DATE));
	    
	String ware_dateY2 = String.valueOf(c.get(Calendar.YEAR)-1911);
	String ware_dateM2 = String.valueOf(c.get(Calendar.MONTH)+1);
	String ware_dateD2 = String.valueOf(c.get(Calendar.DATE));
	
	
	List exTripList = (List) request.getAttribute("ExTrip");
	if(exTripList != null && exTripList.size() > 0 ) {
	    DataObject bean = (DataObject) exTripList.get(0);
	    disp_id = bean.getValue("disp_id") != null ? (String)bean.getValue("disp_id") : "";
        
        exam_div = bean.getValue("exam_div") != null ? (String)bean.getValue("exam_div") : "";
        bank_no = bean.getValue("bank_no") != null ? (String)bean.getValue("bank_no") : "";
        tbank_no = bean.getValue("tbank_no") != null ? (String)bean.getValue("tbank_no") : "";
        bank_name = bean.getValue("bank_name") != null ? (String)bean.getValue("bank_name") : "";
        ch_type = bean.getValue("ch_type") != null ? (String)bean.getValue("ch_type") : "";
        bank_type = bean.getValue("bank_type") != null ? (String)bean.getValue("bank_type") : "";
        
        try {
          ware_dateY1 = String.valueOf(Integer.parseInt((String)bean.getValue("ware_datey1"))-1911);
	      ware_dateM1 = String.valueOf(Integer.parseInt((String)bean.getValue("ware_datem1")));
	      ware_dateD1 = String.valueOf(Integer.parseInt((String)bean.getValue("ware_dated1")));
 
	      ware_dateY2 = String.valueOf(Integer.parseInt((String)bean.getValue("ware_datey2"))-1911);
	      ware_dateM2 = String.valueOf(Integer.parseInt((String)bean.getValue("ware_datem2")));
	      ware_dateD2 = String.valueOf(Integer.parseInt((String)bean.getValue("ware_dated2")));
	    } catch(Exception e) {
	      ware_dateY1 = "";
	      ware_dateM1 = "";
	      ware_dateD1 = "";
 
	      ware_dateY2 = "";
	      ware_dateM2 = "";
	      ware_dateD2 = "";
	    }
        // disabled = "disabled";
	}

	// 取參數值
	if(act.equals("Edit")) {
	    List exDateList = (List) request.getAttribute("ExDate");
	    if (exDateList != null && exDateList.size() > 0) {
	        DataObject bean = (DataObject) exDateList.get(0);
	        
            base_dateY = String.valueOf(Integer.parseInt((String)bean.getValue("base_datey"))-1911);
	        base_dateM = String.valueOf(Integer.parseInt((String)bean.getValue("base_datem")));
	        base_dateD = String.valueOf(Integer.parseInt((String)bean.getValue("base_dated")));

	          
	        
	        
	        hsien_id = bean.getValue("hsien_id") != null ? (String)bean.getValue("hsien_id") : "";
	        come_docno = bean.getValue("report_come_docno") != null ? (String)bean.getValue("report_come_docno") : "";
	        receive_docno = bean.getValue("report_receive_docno") != null ? (String)bean.getValue("report_receive_docno") : "";
	        exam_id = bean.getValue("reportno") != null ? (String)bean.getValue("reportno") : "";
            disp_id = bean.getValue("disp_id") != null ? (String)bean.getValue("disp_id") : "";
            bank_no = bean.getValue("bank_no") != null ? (String)bean.getValue("bank_no") : "";
            ch_type = bean.getValue("ch_type") != null ? (String)bean.getValue("ch_type") : "";
            bank_type = bean.getValue("bank_type") != null ? (String)bean.getValue("bank_type") : "";
            tbank_no = bean.getValue("tbank_no") != null ? (String)bean.getValue("tbank_no") : "";
            originunt_id = bean.getValue("originunt_id") != null ? (String)bean.getValue("originunt_id") : "";
	        
	        
	        try {
	          ware_dateY1 = String.valueOf(Integer.parseInt((String)bean.getValue("ware_datey1"))-1911);
	          ware_dateM1 = String.valueOf(Integer.parseInt((String)bean.getValue("ware_datem1")));
	          ware_dateD1 = String.valueOf(Integer.parseInt((String)bean.getValue("ware_dated1")));
	        } catch(Exception e) {
	          ware_dateY1 = "";
	          ware_dateM1 = "";
	          ware_dateD1 = "";
	        }
	        
	        try {
	          ware_dateY2 = String.valueOf(Integer.parseInt((String)bean.getValue("ware_datey2"))-1911);
	          ware_dateM2 = String.valueOf(Integer.parseInt((String)bean.getValue("ware_datem2")));
	          ware_dateD2 = String.valueOf(Integer.parseInt((String)bean.getValue("ware_dated2")));
	        } catch(Exception e) {
	          ware_dateY2 = "";
	          ware_dateM2 = "";
	          ware_dateD2 = "";
	        }
	        
	        try {
	          come_dateY = String.valueOf(Integer.parseInt((String)bean.getValue("come_datey"))-1911);
	          come_dateM = String.valueOf(Integer.parseInt((String)bean.getValue("come_datem")));
	          come_dateD = String.valueOf(Integer.parseInt((String)bean.getValue("come_dated")));
	        } catch(Exception e) {
	          come_dateY = "";
	          come_dateM = "";
	          come_dateD = "";
	        }
	        
        }else{
           System.out.println("WARNING !!!  Search detail data is NULL ");
        }
	}else {
	    
	    base_dateY = String.valueOf(c.get(Calendar.YEAR)-1911);
	    base_dateM = String.valueOf(c.get(Calendar.MONTH)+1);
	    base_dateD = String.valueOf(c.get(Calendar.DATE)); 
	}
	
	//取得TC21的權限
	Properties permission = ( session.getAttribute("TC21")==null ) ? new Properties() : (Properties)session.getAttribute("TC21"); 
	if(permission == null){
       System.out.println("TC21_Edit.permission == null");
    }else{
       System.out.println("TC21_Edit.permission.size ="+permission.size());
  }
	
	System.out.println("disp_id ="+disp_id);	
	System.out.println("exam_id ="+exam_id);
	System.out.println("exam_div ="+exam_div);
	System.out.println("bank_name ="+bank_name);
	System.out.println("bank_no ="+bank_no);
	
	
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
    if(bankTypeList != null) {
         for(int i=0; i < bankTypeList.size(); i++) {
             DataObject bean =(DataObject)bankTypeList.get(i);
             bankNoMap.put(bean.getValue("cmuse_id"),bean.getValue("cmuse_name"));
         }
    }
	
	exist = disp_id.equals("") ? false : true;
%>


<HTML>
<HEAD>
<TITLE>檢查行政系統 檢查報告編號維護</TITLE>
</HEAD>

<script language="javascript" src="js/TC21.js"></script>
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
<Form name='form' method=post action='TC21.jsp'>
<input type='hidden' name='act' value=''>
<input type='hidden' name='base_date' value=''>
<input type='hidden' name='come_date' value=''>
<input type='hidden' name='ware_date1' value=''>
<input type='hidden' name='ware_date2' value=''>

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
     <tr> 
           <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
           <td width="50%"><font color='#000000' size=4><b><center>檢查報告編號建檔維護管理 </center></b></font> </td>
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

<Table border=1 width='100%' align=center height="83" bgcolor="#FFFFF" bordercolor="#76C657">
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">派差通知單編號</td>
<td width="70%" bgcolor="#EBF4E1" height="1">
<%=disp_id%>&nbsp;
<% if(!disp_id.equals("")) {%>
<br><font color="#FF0000">檢查報告建檔後，檢查派差及檢查行程計畫就不可再異動</font>
<% }%>
<input type="hidden" name="disp_id" value='<%=disp_id%>' >
</tr>
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">檢查單位</td>
<td width="70%" bgcolor="#EBF4E1" height="1">
  <%if(!disp_id.equals("")) {%>
     農委員農金局
     <input type="hidden" name="originunt_id" value='2' >
  <%} else {%>


  <select size="1" name="originunt_id" >
     <option value="" ></option>
    <%   
    List originuntIdList = (List)request.getAttribute("Originunt_Id"); 
    if(originuntIdList != null) {
         for(int i=0; i < originuntIdList.size(); i++) {
             DataObject bean =(DataObject)originuntIdList.get(i);
             if(bean.getValue("cmuse_id").equals("2"))
                 continue;
%>   
     <option value="<%=bean.getValue("cmuse_id")%>"><%=bean.getValue("cmuse_name")%></option>
<%       }
     }

%>
  </select>
<%}%>
</td>
</tr>
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">檢查報告編號</td>
<td width="70%" bgcolor="#EBF4E1" height="1">&nbsp;
<%if(act.equals("New")) {%>
<input type="text" name="exam_id" size="18" maxlength="7" value="<%=exam_id%>">
<%} else {%>
<input type="hidden" name="exam_id" size="18" maxlength="7" value="<%=exam_id%>"><%=exam_id%>
<%}%>
</td></tr>
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">檢查基準日</td>
<td width="70%" bgcolor="#EBF4E1" height="1">
<%if(exist) {%>
<input type='hidden' name='base_dateY' value='<%=base_dateY%>'>
<input type='hidden' name='base_dateM' value='<%=base_dateM%>'>
<input type='hidden' name='base_dateD' value='<%=base_dateD%>'>
<%=base_dateY%>年<%=base_dateM%>月<%=base_dateD%>日
<% } else {%>
<input type="text" name="base_dateY" size="3" maxlength="3" value='<%=base_dateY%>' <%=disabled%> onChange="chnageYear(form.base_dateY)"> 
  年 <select name="base_dateM" <%=disabled%> >                 
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
  </select>月 <select name="base_dateD" <%=disabled%> >                 
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
  <%}%>
</tr>
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">檢查期間起迄</td>
<td width="70%" bgcolor="#EBF4E1" height="1">
<%if(exist) {%>
<input type='hidden' name='ware_dateY1' value='<%=ware_dateY1%>'>
<input type='hidden' name='ware_dateM1' value='<%=ware_dateM1%>'>
<input type='hidden' name='ware_dateD1' value='<%=ware_dateD1%>'>
<input type='hidden' name='ware_dateY2' value='<%=ware_dateY2%>'>
<input type='hidden' name='ware_dateM2' value='<%=ware_dateM2%>'>
<input type='hidden' name='ware_dateD2' value='<%=ware_dateD2%>'>

<%=ware_dateY1%>年<%=ware_dateM1%>月<%=ware_dateD1%>日&nbsp;&nbsp;至&nbsp;&nbsp;
<%=ware_dateY2%>年<%=ware_dateM2%>月<%=ware_dateD2%>日
<%} else {%>

<input type="text" name="ware_dateY1" size="3" maxlength="3" value='<%=ware_dateY1%>'  > 
  年 <select name="ware_dateM1" >                 
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
  </select>月 <select name="ware_dateD1"  >                 
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
  </select>日&nbsp;&nbsp;至&nbsp;&nbsp;
  <input type="text" name="ware_dateY2" size="3" maxlength="3" value='<%=ware_dateY2%>'  > 
  年 <select name="ware_dateM2" >                 
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
  </select>月 <select name="ware_dateD2"  >                 
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
<% } %>
</tr>
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">金融機構類別</td>
<td width="416" bgcolor="#EBF4E1" height="1">
<% if(!disp_id.equals("")) {%>
 &nbsp;<input type='hidden' name='bankType' value='<%=bank_type%>'>
 <%=bankNoMap.get(bank_type)%>
<%} else {%>

   <select size="1" name="bankType" onChange="checkCity();resetOption();changeTbank('TBankXML',form.base_dateY);">
     
<%   if(bankTypeList != null) {
         for(int i=0; i < bankTypeList.size(); i++) {
             DataObject bean =(DataObject)bankTypeList.get(i);
             
             
%>   
     <option value="<%=bean.getValue("cmuse_id")%>"><%=bean.getValue("cmuse_name")%></option>
<%       }
     }
 
%>
  </select>
  <%}%>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  縣市別:&nbsp;&nbsp;
   <select size="1" name="cityType" onChange="changeTbank('TBankXML',form.dateY);changeExamine('BankNoXML','TBankXML',form.base_dateY);" >
    </select>
  

  </td>
</tr>

<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">總機構單位</td>
<td width="416" bgcolor="#EBF4E1" height="1">
<% if(!disp_id.equals("")) {%>
 &nbsp;<input type='hidden' name='tbank' value='<%=tbank_no%>'>
<%=tbank_no%> &nbsp;&nbsp;&nbsp;&nbsp; <%=bankNoMap.get(tbank_no)%>
<%} else {%>           
  <select size="1" name="tbank" onChange='changeExamine("BankNoXML","TBankXML",form.base_dateY)'>
    <option value="" >全部</option>
  </select> 
 <%}%></td>
</tr>

<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">受檢單位</td>
<td width="416" bgcolor="#EBF4E1" height="1">
<% if(!disp_id.equals("")) {%>
 &nbsp;<input type='hidden' name='examine' value='<%=bank_no%>'>
<%=bank_no%> &nbsp;&nbsp;&nbsp;&nbsp; <%=bankNoMap.get(bank_no)%>
<%} else {%>   
  <select size="1" name="examine">
    <option value="" >全部</option>
  </select> 
<%}%>  
  </td>
</tr>
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">檢查性質</td>
<td width="70%" bgcolor="#EBF4E1" height="1">

<select size="1" name="property" <%=disabled%> >

<%
   if(chTypeList != null) {
       for(int i =0; i < chTypeList.size(); i++) {
         DataObject bean =(DataObject)chTypeList.get(i);
         if(exist) { 
           if(((String)bean.getValue("cmuse_id")).equals(ch_type)) {%>
       <option value="<%=bean.getValue("cmuse_id")%>"><%=bean.getValue("cmuse_name")%></option>
<%         } 
         } else {%> 
       <option value="<%=bean.getValue("cmuse_id")%>"><%=bean.getValue("cmuse_name")%></option>    
<%       }
      } 
    }%>    </td>
</tr>

<%if(!exist) {%>

<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">來文日期</td>
<td width="70%" bgcolor="#EBF4E1" height="1">
<input type="text" name="come_dateY" size="3" maxlength="3" value='<%=come_dateY%>'  > 
  年 <select name="come_dateM"  >                 
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
  </select>月 <select name="come_dateD"  >                 
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
<td width="30%" bgcolor="#BDDE9C" height="1">來文文號</td>
<td width="70%" bgcolor="#EBF4E1" height="1">&nbsp;
<input type="text" name="come_docno" size="20" maxlength="40" value="<%=come_docno%>">
</td>
</tr>

<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">農金局收文文號</td>
<td width="70%" bgcolor="#EBF4E1" height="1">&nbsp;
<input type="text" name="receive_docno" size="20" maxlength="40" value="<%=receive_docno%>">
</td>
</tr>
<% } else {%>
<input type="hidden" name="come_dateY"  value="<%=come_dateY%>">
<input type="hidden" name="come_docno"   value="<%=come_docno%>">
<input type="hidden" name="receive_docno"   value="<%=receive_docno%>">
<% } %>





</Table>
<table width="100%" border="0" cellpadding="1" cellspacing="1" class="sbody">
  <tr>
    <td colspan='2' align='center'>
        <% if(act.equals("New")) {%>
<%if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){ %>
<a href="javascript:doSubmit(form,'Insert','');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_confirmb.gif',1)"><img src="images/bt_confirm.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a>
<a href="javascript:clearAll();"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image104','','images/bt_cancelb.gif',1)"><img src="images/bt_cancel.gif" name="Image104" width="66" height="25" border="0" id="Image104"></a>
<%}%>
  <% } else if(act.equals("Edit")) {%>
<%if(permission != null && permission.get("U") != null && permission.get("U").equals("Y")){ %> 
<a href="javascript:doSubmit(form,'Update','');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_updateb.gif',1)"><img src="images/bt_update.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a>
<%}%>
<%if(permission != null && permission.get("D") != null && permission.get("D").equals("Y")){ %>
<a href="javascript:doSubmit(form,'Delete','');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image103','','images/bt_deleteb.gif',1)"><img src="images/bt_delete.gif" name="Image103" width="66" height="25" border="0" id="Image103"></a>
<%}%> 
  <% } %>
<a href="javascript:history.back();"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image105" width="80" height="25" border="0" id="Image105"></a>
      
    </td>
  </tr>
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
		    <li>按<font color="#666666">【派差通知單編號連結】</font>則可修改或查看此筆資料。</li>
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
<% if(disp_id.equals("")) { %>
setSelect(form.bankType,"<%=bank_type%>");
changeCity("CityXML",form.dateY) ;
//changeOption('TBankXML',form.tbank, form.bankType, 'TBankXML');

//changeOption('BankNoXML',form.examine, form.tbank, 'TBankXML');
setSelect(form.examine,"<%=bank_no%>");
setSelect(form.originunt_id, '<%=originunt_id%>');
setSelect(form.cityType,"<%=cityType%>");
changeTbank("TBankXML",form.dateY);
setSelect(form.tbank,"<%=tbank_no%>");
changeExamine("BankNoXML","TBankXML",form.dateY);
checkCity();
<%}
if(!exist) { %>
setSelect(form.come_dateM, '<%=come_dateM%>');
setSelect(form.come_dateD, '<%=come_dateD%>');
setSelect(form.base_dateM, '<%=base_dateM%>');
setSelect(form.base_dateD, '<%=base_dateD%>');
setSelect(form.ware_dateM1, '<%=ware_dateM1%>');
setSelect(form.ware_dateD1, '<%=ware_dateD1%>');
setSelect(form.ware_dateM2, '<%=ware_dateM2%>');
setSelect(form.ware_dateD2, '<%=ware_dateD2%>');
setSelect(form.property, '<%=ch_type%>');
<% } %>

setSelect(form.cityType, '<%=hsien_id%>');

setSelect(form.exam_div, '<%=exam_div%>');



-->
</script>
</HTML>

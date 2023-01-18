	<%
//98.06.18 檢舉書查詢--by 2756
//99.05.28 fix 縣市合併調整&sql injection by 2808
%>
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
    String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");	
    String flag = ( request.getParameter("flag")==null ) ? "" : (String)request.getParameter("flag");//判斷是那一種查詢情況("":受理/P:發文/B:回文)
    String item = ( request.getParameter("item")==null ) ? "" : (String)request.getParameter("item");//判斷是那一種查詢情況(1:發文/2:回文/3:檢舉書)
    
    Properties permission = ( session.getAttribute("MC014W")==null ) ? new Properties() : (Properties)session.getAttribute("MC014W");
    if(permission == null){
       System.out.println("MC014W_Edit.permission == null");
    }else{
       System.out.println("MC014W_Edit.permission.size ="+permission.size());
    }			
    System.out.println("Page: MC014W_Edit.jsp    Action:"+act);

    String tbank="",bank_name="",taNum="",taRptr="",taContent="",taNo="",taDate="",taPubNum="",taPubDate="",taBkNum="",taBkDate="",taBkResult="",taPs="",taHide="",taPubContent="";
    String bankType = request.getParameter("bankType" )== null    ? "" : (String)request.getParameter("bankType");    
    String cityType = request.getParameter("cityType" )== null    ? "" : (String)request.getParameter("cityType");   
    String begDate = request.getParameter("begDate" )== null  ? "" : (String)request.getParameter("begDate");
    String endDate = request.getParameter("endDate" )== null  ? "" : (String)request.getParameter("endDate");
    String begDate1 = request.getParameter("begDate1" )== null  ? "" : (String)request.getParameter("begDate1");
    String endDate1 = request.getParameter("endDate1" )== null  ? "" : (String)request.getParameter("endDate1");
    String begDate2 = request.getParameter("begDate2" )== null  ? "" : (String)request.getParameter("begDate2");
    String endDate2 = request.getParameter("endDate2" )== null  ? "" : (String)request.getParameter("endDate2");
        
    String titleState="";//控制Table的標題;

    
    String [] dtBgn={begDate,begDate1,begDate2};
    String [] dtEnd={endDate,endDate1,endDate2};
    int [] begY=new int[3];
    int [] endY=new int[3];
    int [] begM=new int[3];
    int [] endM=new int[3];
    int [] begD={1,1,1};
    int [] endD={31,31,31};
    Calendar c = Calendar.getInstance();
    
    //設定表title
    if(flag.equals("") && act.equals("New"))
    {
      titleState="受理作業";
    }
    else if(flag.equals("R"))
    {
      titleState="發文作業";
    }
    else if(flag.equals("B"))
    {
      taNo = request.getParameter("taNo" )== null  ? "" : (String)request.getParameter("taNo");
      titleState="回文作業";
    }
    else if(flag.equals("N"))//受理查詢
    {
    	taNo= request.getParameter("taNo" )== null  ? "" : (String)request.getParameter("taNo");
    	titleState="受理作業";
    }
    else
    {
      titleState="明細";
    }
    
    for(int i=0;i<3;i++)//設定年月日
    {    	
    	begY[i]=c.get(Calendar.YEAR)-1911;
    	begM[i] = c.get(Calendar.MONTH)+1;

    	endY[i]=c.get(Calendar.YEAR)-1911;
    	endM[i] = c.get(Calendar.MONTH)+1;

    	if(dtBgn[i].length()>6)
    	{
    		begY[i] = Integer.parseInt(dtBgn[i].substring(0,4))-1911;
    		begM[i] = Integer.parseInt(dtBgn[i].substring(4,6));
    		begD[i] = Integer.parseInt(dtBgn[i].substring(6,8));
   	    }
    	if(dtEnd[i].length()>6)
    	{
    		endY[i] = Integer.parseInt(dtEnd[i].substring(0,4))-1911;
    		endM[i] = Integer.parseInt(dtEnd[i].substring(4,6));
    		endD[i] = Integer.parseInt(dtEnd[i].substring(6,8));
    	}
    
    }    


    if(act.equals("New")) { 
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
    }else if(act.equals("Edit")) {    	
    	if(flag.equals("N")){
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
    	}
        DataObject bean = (DataObject) request.getAttribute("DETAIL");
        if(bean != null) {            
 
        	tbank = bean.getValue("bank_no") != null ? (String) bean.getValue("bank_no") : "";
            bank_name = bean.getValue("bank_name") != null ? (String) bean.getValue("bank_name") : "";
            taNum = bean.getValue("ta_number") != null ? (String) bean.getValue("ta_number") : "";
            taRptr= bean.getValue("ta_reporter") != null ? (String) bean.getValue("ta_reporter") : "";
            taContent = bean.getValue("ta_content") != null ? (String)bean.getValue("ta_content") : "";

            taDate = bean.getValue("ta_date") != null ? (String) bean.getValue("ta_date") : ""; 
            taPubNum = bean.getValue("ta_publicnum") != null ? (String) bean.getValue("ta_publicnum") : "";
            taPubDate = bean.getValue("ta_publicdate") != null ? (String) bean.getValue("ta_publicdate") : "";
            taPubContent = bean.getValue("ta_publiccontent") != null ? (String) bean.getValue("ta_publiccontent") : "";

            taBkNum = bean.getValue("ta_backnum") != null ? (String) bean.getValue("ta_backnum") : "";
            taBkDate = bean.getValue("ta_bakdate") != null ? (String) bean.getValue("ta_bakdate") : "";   
            taBkResult = bean.getValue("ta_backresult") != null ? (String) bean.getValue("ta_backresult") : "";

            taPs = bean.getValue("ta_ps") != null ? (String) bean.getValue("ta_ps") : "";

            taNo = bean.getValue("ta_no") != null ? (String) bean.getValue("ta_no") : "";
            taHide = bean.getValue("ta_hide") != null ? (String) bean.getValue("ta_hide") : "";
   
            System.out.println("params:"+"tbank:"+tbank+" bank_name:"+bank_name+" taNum:"+taNum+" taRptr:"+taRptr+" taContent:"+taContent+"taDate:"+taDate+" taPubNum:"+taPubNum+" taPubDate:"+taPubDate+" taPubContent:"+taPubContent+"taBkNum:"+taBkNum+" taBkDate:"+taBkDate+" taBkResult:"+taBkResult+" taPs:"+taPs+" taNo:"+taNo+" taPs:"+taPs);
            System.out.println("sub_tadate:"+taDate+taDate.substring(6,8));
        }

    }
%>

<HTML>
<HEAD>
<TITLE>檢舉書</TITLE>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/MC014W.js"></script>
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
<Form name='form' method=post action='MC014W.jsp'>
<input type='hidden' name="act" value=''>
<input type='hidden' name="flag" value=''>
<input type='hidden' name="begDate" value='<%=begDate%>'>
<input type='hidden' name="endDate" value='<%=endDate%>'>
<input type='hidden' name="begDate1" value='<%=begDate1%>'>
<input type='hidden' name="endDate1" value='<%=endDate1%>'>
<input type='hidden' name="begDate2" value='<%=begDate2%>'>
<input type='hidden' name="endDate2" value='<%=endDate2%>'>
<input type='hidden' name="item" value=''>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
     <tr> 
           <td width="35%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
           <td width="30%"><font color='#000000' size=4><b><center>檢舉書<%=titleState%></center></b></font> </td>
           <td width="35%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
         </tr>
</table>

<Table border=1 width='100%' align=center height="65" bgcolor="#FFFFF" bordercolor="#76C657">

<%if(act.equals("New")||flag.equals("N")){%>
<%if(act.equals("New")){%>
<tr class="sbody">
<td width='25%' bgcolor="#BDDE9C" height="1">金融機構類別</td>
<td width='75%' bgcolor="#EBF4E1" height="1" colspan=3>
 <select size="1" name="bankType"onChange="changeTbank('TBankXML',form.begY0)" >
     <option value="6">農會</option>
     <option value="7">漁會</option>
  </select>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  縣市別:&nbsp;&nbsp;
   <select size="1" name="cityType" onChange="changeTbank('TBankXML',form.begY0)" >
   </select>
<%   }%>
 
  </td>
</tr>
<%if(act.equals("New")){%>
<tr class="sbody">
<td width='25%' bgcolor="#BDDE9C" height="1">被檢舉機構</td>
<td width='75%' bgcolor="#EBF4E1" height="1" colspan=3>           
  <select size="1" name="tbank" >
    <option value="" >全部</option>
  </select>  </td>
</tr>
<%}else if(flag.equals("N")){%>
<tr class="sbody">
<td width='25%' bgcolor="#BDDE9C" height="1">被檢舉機構</td>
<td width='75%' bgcolor="#EBF4E1" height="1" colspan=3><%=tbank%><%=bank_name%></td>
</tr>
<%}%>
<tr class="sbody">
<td width='25%' bgcolor="#BDDE9C" height="1">檢舉人</td>
<td width='75%' bgcolor="#EBF4E1" height="1" colspan=3>
<input type='text' maxlength='30' name="taRptr" size="27" value=<%=taRptr%>></td>
</tr>
<tr class="sbody">
    <td width='25%' bgcolor="#BDDE9C" height="1">收文文號</td>
    <td width='75%' bgcolor="#EBF4E1" height="1" colspan=3>
    <input type='text' maxlength='50' name="taNum" size="27" value=<%=taNum%>></td>   
</tr> 
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">檢舉內容</td>
  <td width='75%' bgcolor="#EBF4E1" height="20" colspan=3>
  <textarea rows="8" cols="73" name='taContent' ><%=taContent%></textarea></td>
  <input type='hidden' name='taDate' value='<%=taDate%>'>
</tr>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">收文日期</td>
  <td width='75%' bgcolor="#EBF4E1" height="20" colspan=3>
    <input type='text' name='begY0' value="<%=begY[0]%>" size='3' maxlength='3' onblur='CheckYear(this)' onChange='chnageYear(form.begY0);'>
    <font color='#000000'>年
    <select id="hide1" name=begM0>
    <option></option>
    <%
    	for (int j = 1; j <= 12; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(begM[0] == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(begM[0] == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select>月
    <select id="hide1" name=begD0>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(begD[0] == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(begD[0] == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select>日</font></td>
</tr>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">備註</td>
  <td width='75%' bgcolor="#EBF4E1" height="20" colspan=3>
  <textarea rows="4" cols="73" name='taPs' ><%=taPs%></textarea></td>
  <input type='hidden' name='taNo' value='<%=taNo%>'>
</tr>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">是否將此筆資料給予檢查局 ?</td>
  <td width='75%' bgcolor="#EBF4E1" height="20" colspan=3>
  <input type='radio' name='taHide' value="0" <%if(taHide.equals("0")||act.equals("New")) out.print("checked");%> checked>是
  <input type='radio' name='taHide' value="1" <%if(taHide.equals("1")) out.print("checked");%>>否</td>
</tr>
<%}%>    
<%if(act.equals("Edit")&&!flag.equals("N")){%>
<%if(flag.equals("R"))
{%>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">收文文號</td>
  <td width='75%' bgcolor="#EBF4E1" height="20" colspan=3><%=taNum%></td>
  <input type='hidden' name='taNum' value='<%=taNum%>'>
  <input type='hidden' name='taPubDate' value='<%=taPubDate%>'>
</tr>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">檢舉人</td>
  <td width='75%' bgcolor="#EBF4E1" height="20" colspan=3><%=taRptr%></td>
  <input type='hidden' name='taRptr' value='<%=taRptr%>'>
</tr>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">被檢舉機構</td>
  <td width='75%' bgcolor="#EBF4E1" height="20" colspan=3><%=tbank%><%=bank_name%></td>
  <input type='hidden' name='taNo' value='<%=taNo%>'>
  <input type='hidden' name='tbank' value='<%=tbank%>'>
</tr>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">發文文號</td>
  <td width='75%' bgcolor="#EBF4E1" height="20" colspan=3>
  <input type='text' maxlength='10' name="taPubNum" size="24" value='<%=taPubNum%>'></td>
</tr>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">發文日期</td>
  <td width='75%' bgcolor="#EBF4E1" height="20"colspan=3>
    <input type='text' name='begY1' value="<%=begY[1]%>" size='3' maxlength='3' onblur='CheckYear(this)'>
    <font color='#000000'>年
    <select id="hide4" name=begM1>
    <option></option>
    <%
    	for (int j = 1; j <= 12; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(begM[1] == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(begM[1] == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select>月
    <select id="hide5" name=begD1>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(begD[1] == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(begD[1] == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select>日</font></td>
</tr>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">本局處理情形</td>
  <td width='75%' bgcolor="#EBF4E1" height="20"colspan=3>
  <textarea rows="6" cols="73" name='taPubContent' ><%=taPubContent%></textarea></td>
</tr>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">檢舉內容</td>
  <td width='75%' bgcolor="#EBF4E1" height="20"colspan=3>
  <textarea rows="8" cols="73" name='taContent' ><%=taContent%></textarea></td>
</tr>

<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">收文日期</td>
  <td width='75%' bgcolor="#EBF4E1" height="20"colspan=3><%=taDate%></td>
  <input type='hidden' name='taDate' value='<%=taDate%>'>
</tr>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">備註</td>
  <td width='75%' bgcolor="#EBF4E1" height="20" colspan=3><%=taPs%></td>
  <input type='hidden' name='taPs' value='<%=taPs%>'>
</tr>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">是否將此筆資料給予檢查局 ?</td>
  <td width='75%' bgcolor="#EBF4E1" height="20" colspan=3>
  <input type='radio' name='taHide' value="0" <%if(taHide.equals("0")||act.equals("New")) out.print("checked");%> checked>是
  <input type='radio' name='taHide' value="1" <%if(taHide.equals("1")) out.print("checked");%>>否</td>
</tr>
<%}%>
<% if(flag.equals("B"))
{%>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">收文文號</td>
  <td width='25%' bgcolor="#EBF4E1" height="20"><%=taNum%></td>
  <input type='hidden' name='taNum' value='<%=taNum%>'>
  <td width='25%' bgcolor="#BDDE9C" height="20">收文日期</td>
  <td width='25%' bgcolor="#EBF4E1" height="20"><%=taDate%></td>
  <input type='hidden' name='taDate' value='<%=taDate%>'>
</tr>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">發文文號</td>
  <td width='25%' bgcolor="#EBF4E1" height="20"><%=taPubNum%></td>
  <input type='hidden' name='taPubNum' value='<%=taPubNum%>'>
  <td width='25%' bgcolor="#BDDE9C" height="20">發文日期</td>
  <td width='25%' bgcolor="#EBF4E1" height="20"><%=taPubDate%></td>
  <input type='hidden' name='taPubDate' value='<%=taPubDate%>'>
</tr>
<tr class="sbody">
  <td width="173" bgcolor="#BDDE9C" height="20">檢舉人</td>
  <td width="200" bgcolor="#EBF4E1" height="20"><%=taRptr%></td>
  <input type='hidden' name='taRptr' value='<%=taRptr%>'>
  <td width="173" bgcolor="#BDDE9C" height="20">被檢舉機構</td>
  <td width="200" bgcolor="#EBF4E1" height="20"><%=tbank%><%=bank_name%></td>
  <input type='hidden' name='taNo' value='<%=taNo%>'>
</tr>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">本局處理意見</td>
  <td width='75%' bgcolor="#EBF4E1" height="20" colspan=3><%=taPubContent%></td>
  <input type='hidden' name='taPubContent' value='<%=taPubContent%>'>
  <input type='hidden' name='taBkDate' value='<%=taBkDate%>'>
</tr>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">檢舉內容</td>
  <td width='75%' bgcolor="#EBF4E1" height="20" colspan=3><%=taContent%></td>
  <input type='hidden' name='taContent' value='<%=taContent%>'>
</tr>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">回文函號</td>
  <td width='25%' bgcolor="#EBF4E1" height="20">
  <input type='text' maxlength='10' name="taBkNum" size="27" value='<%=taBkNum%>'></td>
  <td width='25%' bgcolor="#BDDE9C" height="20">回文日期</td>
  <td width='25%' bgcolor="#EBF4E1" height="20">
    <input type='text' name='begY2' value="<%=begY[2]%>" size='3' maxlength='3' onblur='CheckYear(this)'>
    <font color='#000000'>年
    <select id="hide2" name=begM2>
    <option></option>
    <%
    	for (int j = 1; j <= 12; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(begM[2] == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(begM[2] == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select>月
    <select id="hide3" name=begD2>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(begD[2] == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(begD[2] == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select>日</font></td>

</tr>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">處理情形</td>
  <td width='75%' bgcolor="#EBF4E1" height="20" colspan=3>
  <textarea rows="6" cols="74" name='taBkResult'><%=taBkResult%></textarea></td>
</tr>
<tr class="sbody">
  <td width="173" bgcolor="#BDDE9C" height="20">備註</td>
  <td width="200" bgcolor="#EBF4E1" height="20" colspan=3><%=taPs%></td>
  <input type='hidden' name='taPs' value='<%=taPs%>'>
</tr>
<%}%>
<% if(flag.equals("")) 
{%>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">收文文號</td>
  <td width='25%' bgcolor="#EBF4E1" height="20"><%=taNum%></td>
  <input type='hidden' name='taNum' value='<%=taNum%>'>
  <td width='25%' bgcolor="#BDDE9C" height="20">收文日期</td>
  <td width='25%' bgcolor="#EBF4E1" height="20"><%=taDate%></td>
  <input type='hidden' name='taDate' value='<%=taDate%>'>
</tr>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">發文文號</td>
  <td width='25%' bgcolor="#EBF4E1" height="20"><%=taPubNum%></td>
  <input type='hidden' name='taPubNum' value='<%=taPubNum%>'>
  <td width='25%' bgcolor="#BDDE9C" height="20">發文日期</td>
  <td width='25%' bgcolor="#EBF4E1" height="20"><%=taPubDate%></td>
  <input type='hidden' name='taPubDate' value='<%=taPubDate%>'>
</tr>
<tr class="sbody">
  <td width="173" bgcolor="#BDDE9C" height="20">檢舉人</td>
  <td width="200" bgcolor="#EBF4E1" height="20"><%=taRptr%></td>
  <input type='hidden' name='taRptr' value='<%=taRptr%>'>
  <td width="173" bgcolor="#BDDE9C" height="20">被檢舉機構</td>
  <td width="200" bgcolor="#EBF4E1" height="20"><%=tbank%><%=bank_name%></td>
  <input type='hidden' name='taNo' value='<%=taNo%>'>
</tr>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">本局處理意見</td>
  <td width='75%' bgcolor="#EBF4E1" height="20" colspan=3><%=taPubContent%></td>
  <input type='hidden' name='taPubContent' value='<%=taPubContent%>'>
</tr>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">檢舉內容</td>
  <td width='75%' bgcolor="#EBF4E1" height="20" colspan=3><%=taContent%></td>
  <input type='hidden' name='taContent' value='<%=taContent%>'>
</tr>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">回文函號</td>
  <td width='25%' bgcolor="#EBF4E1" height="20"><%=taBkNum%></td>
  <input type='hidden' name='taBkNum' value='<%=taBkNum%>'>
  <td width='25%' bgcolor="#BDDE9C" height="20">回文日期</td>
  <td width='25%' bgcolor="#EBF4E1" height="20"><%=taBkDate%></td>
  <input type='hidden' name='taBkDate' value='<%=taBkDate%>'>
</tr>
<tr class="sbody">
  <td width='25%' bgcolor="#BDDE9C" height="20">處理情形</td>
  <td width='75%' bgcolor="#EBF4E1" height="20" colspan=3><%=taBkResult%></td>
  <input type='hidden' name='taBkResult' value='<%=taBkResult%>'>
</tr>
<tr class="sbody">
  <td width="173" bgcolor="#BDDE9C" height="20">備註</td>
  <td width="200" bgcolor="#EBF4E1" height="20" colspan=3><%=taPs%></td>
  <input type='hidden' name='taPs' value='<%=taPs%>'>
</tr>
<%}%>
<%}%>

</Table>
                    <tr>
                      <td colspan="2" width="583" height="41">
                      <div align="center">
                    <table width="243" border="0" cellpadding="1" cellspacing="1">
                      <tr>
                       <%if(!item.equals("3")){ %>
                       <%if(act.equals("New")){
                       if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){//Add
                      %>
				        <td width="66"><div align="center"><a href="javascript:doSubmit(this.document.forms[0],'add','<%=tbank%>');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_confirmb.gif',1)"><img src="images/bt_confirm.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a></div></td>
				        <% } }else
				        {
				        if(permission != null && permission.get("U") != null && permission.get("U").equals("Y")){//Update %>
				        <td width="66"><div align="center"><a href="javascript:doSubmit(this.document.forms[0],'modify','<%=flag%>','<%=item%>');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image103','','images/bt_updateb.gif',1)"><img src="images/bt_update.gif" name="Image103" width="66" height="25" border="0" id="Image103"></a></div></td>
				        <td width="66"><div align="center"><a href="javascript:doSubmit(this.document.forms[0],'delete','<%=flag%>');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image104','','images/bt_deleteb.gif',1)"><img src="images/bt_delete.gif" name="Image104" width="66" height="25" border="0" id="Image104"></a></div></td>
				         <% }}%>
                        <td width="66"><div align="center"><a href="javascript:AskReset(this.document.forms[0]);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_cancelb.gif',1)"><img src="images/bt_cancel.gif" name="Image105" width="66" height="25" border="0" id="Image105"></a></div></td>
                        <%}%>
                        <td width="93"><div align="center"><a href="javascript:history.back();"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image106','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image106" width="80" height="25" border="0" id="Image106"></a></div></td>                        
                      </tr>
       
                    </table>
<table width="100%" border="0" cellpadding="1" cellspacing="1" class="sbody">
  <tr>
    <td colspan='2' align='center'>
    
    </td>
  </tr>
    <td width="3%">　</td>
    <td width="97%"> 
      <ul>                                                
        <% if(act.equals("Qry")) {%>
            <li>本網頁提供檢舉書查詢功能。</li>
            <li>按<font color="#666666">【查詢】</font>則依查詢條件值查詢資料。</li>
        <%} else if(act.equals("New")) {%>
            </li>
            <li>本網頁提供檢舉書受理作業維護功能。</li>
		    <li>按<font color="#666666">【確定】</font>即將資料寫入資料庫。</li> 
		    <li>按<font color="#666666">【取消】</font>放棄資料修改。</li>
		<%} else if(act.equals("Edit")) {%>
            <%if(flag.equals("R")){ %>
            <li>本網頁提供檢舉書發文作業維護功能。</li>
            <%}else if(flag.equals("B")){ %>
            <li>本網頁提供檢舉書回文作業維護功能。</li>		    
            <%}%>
            <%if(!flag.equals("")){ %>
            <li>按<font color="#666666">【修改】</font>即將修改資料寫入資料庫。</li>
		    <li>按<font color="#666666">【刪除】</font>刪除這一筆資料。</li>
            <li>按<font color="#666666">【取消】</font>放棄資料修改。</li> 
            <%}%>
        <%}%> 
        <li>按<font color="#666666">【回上一頁】則回至上個畫面</font>。</li>
      </ul>
    </td>
 </tr>
</table>
</form>
</BODY>


<script language="JavaScript" >
<!--
<%if(act.equals("New")){%>
changeCity("CityXML",form.begY0) ;
changeTbank("TBankXML",form.begY0);
setSelect(form.bankType,"<%=bankType%>");
//changeOption('TBankXML',form.tbank, form.bankType, 'TBankXML');
setSelect(form.tbank,"<%=tbank%>");
setSelect(form.cityType,"<%=cityType%>");
setSelect(form.begM0,"<%=begM[0]%>");
setSelect(form.endM0,"<%=endM[0]%>");
setSelect(form.begD0,"1");
setSelect(form.endD0,"31");
<%}%>
<%if(act.equals("Edit") && flag.equals("R")){%>
setSelect(form.begM1,"<%=begM[1]%>");
setSelect(form.endM1,"<%=endM[1]%>");
setSelect(form.begD1,"1");
setSelect(form.endD1,"31");
<%}%>
<%if(act.equals("Edit") && flag.equals("B")){%>
setSelect(form.begM2,"<%=begM[2]%>");
setSelect(form.endM2,"<%=endM[2]%>");
setSelect(form.begD2,"1");
setSelect(form.endD2,"31");
<%}%>
<%if(flag.equals("N")){%>
setSelect(form.begM0,"<%=begM[0]%>");
setSelect(form.endM0,"<%=endM[0]%>");
setSelect(form.begD0,"<%=begM[0]%>");
setSelect(form.endD0,"<%=endD[0]%>");
<%}%>
-->
</script>


</HTML>


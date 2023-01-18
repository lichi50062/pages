<%
//98.06.18 檢舉書查詢--by 2756
//99.05.28 fix 縣市合併調整&sql injection by 2808
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>


<%
	Map dataMap =Utility.saveSearchParameter(request);
	String act = Utility.getTrimString(dataMap.get("act")) ;
    String flag = Utility.getTrimString(dataMap.get("flag")) ;//判斷是那一種查詢情況(R:發文/B:回文/"":檢舉書)
    String item = Utility.getTrimString(dataMap.get("item")) ;//判斷是那一種查詢情況下的table顯示資料(1:發文2:回文3:檢舉書)

	System.out.println("Page: MC014W_List.jsp    Action:"+act);
	System.out.println("Page: MC014W_List.jsp    flag:"+flag);

    // 查詢條件值 
    
    String bankType = Utility.getTrimString(dataMap.get("bankType")) ;    
    String tbank = Utility.getTrimString(dataMap.get("tbank")) ;
    String cityType = Utility.getTrimString(dataMap.get("cityType")) ;   
    String begDate = Utility.getTrimString(dataMap.get("begDate")) ;//受理日期-起始
    String endDate = Utility.getTrimString(dataMap.get("endDate")) ;//受理日期-結束
    String begDate1 = Utility.getTrimString(dataMap.get("begDate1")) ;//受理日期-起始
    String endDate1 = Utility.getTrimString(dataMap.get("endDate1")) ;//受理日期-結束
    String begDate2 =Utility.getTrimString(dataMap.get("begDate2")) ;//受理日期-起始
    String endDate2 = Utility.getTrimString(dataMap.get("endDate2")) ;//受理日期-結束
    String taContent =Utility.getTrimString(dataMap.get("taContent")) ;
    String titleState="";//控制Table的標題; 
    String [] dtBgn={begDate,begDate1,begDate2};
    String [] dtEnd={endDate,endDate1,endDate2};
    int [] begY=new int[3];
    int [] endY=new int[3];
    int [] begM=new int[3];
    int [] endM=new int[3];
    int [] begD={1,1,1};
    int [] endD={31,31,31};
    System.out.println("begDate:"+begDate+";"+begDate1+";"+begDate2+";");
    System.out.println("endDate:"+endDate+";"+endDate1+";"+endDate2+";");
    Calendar c = Calendar.getInstance();
    Properties permission = ( session.getAttribute("MC014W")==null ) ? new Properties() : (Properties)session.getAttribute("MC014W");

    if(flag.equals("R"))
    {
    	titleState="發文";//檢舉書發文
    }
    else if(flag.equals("B"))//檢舉書回文
    {
    	titleState="回文";
    }
    else if(flag.equals("N"))//受理查詢
    {
    	titleState="受理";
    }
    else
    {
    	titleState="";
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
           <td width="30%"><font color='#000000' size=4><b><center>檢舉書<%=titleState%>查詢</center></b></font> </td>
           <td width="35%"><img src="images/banner_bg1.gif" width="113%" height="17"></td>
         </tr>
</table>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
<tr>  
    <div align="right">
      <jsp:include page="getLoginUser.jsp" flush="true" />
    </div> 
</tr> 
</table> 

<Table border=1 width='100%' align=center height="65" bgcolor="#FFFFF" bordercolor="#76C657">
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">金融機構類別</td>
<td width="416" bgcolor="#EBF4E1" height="1">
   <select size="1" name="bankType" onChange="changeTbank('TBankXML',form.begY)">
     <option value="6">農會</option>
     <option value="7">漁會</option>
  </select>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  縣市別:&nbsp;&nbsp;
   <select size="1" name="cityType" onChange="changeTbank('TBankXML',form.begY)" >
   </select>
  &nbsp;&nbsp;&nbsp;&nbsp;     
  <a href="javascript:doSubmit(form,'Qry','<%=flag%>');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_queryb.gif',1)"><img src="images/bt_query.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a>&nbsp;&nbsp;&nbsp;&nbsp;      
  <%if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){//Add %>     
  <%}%>  
  </td>
</tr>

<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">被檢舉機構</td>
<td width="416" bgcolor="#EBF4E1" height="1">           
  <select size="1" name="tbank" >
    <option value="" >全部</option>
  </select> </td>
</tr>
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">受理日期</td>
    <td width="416" bgcolor="#EBF4E1" height="1">
    <input type='text' name='begY' value="<%=begY[0]%>" size='3' maxlength='3' onblur='CheckYear(this)' onChange="chnageYear(form.begY)">    
    <font color='#000000'>年
    <select id="hide3" name=begM>
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
    <select id="hide4" name=begD>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(begD[0] == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(begD[0] == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select>日</font>
    <font color="#FF0000">至</font>  
    <input type='text' name='endY' value="<%=endY[0]%>" size='3' maxlength='3' onblur='CheckYear(this)'>
    <font color='#000000'>年
    <select id="hide5" name=endM>
    <option></option>
    <%
    	for (int j = 1; j <= 12; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(endM[0] == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(endM[0] == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select>月
    <select id="hide6" name=endD>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(endD[0] == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(endD[0] == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select>日</font>
</tr>        
<% if(act.equals("Qry")){%>
      <% if(flag.equals("B")||flag.equals("")) 
         {%>
     <tr class="sbody">
     <td width="118" bgcolor="#BDDE9C" height="1">發文日期</td>
     <td width="416" bgcolor="#EBF4E1" height="1">
     <input type='text' name='begY1' value="<%=begY[1]%>" size='3' maxlength='3' onblur='CheckYear(this)'>    
     <font color='#000000'>年
     <select id="hide7" name=begM1>
     <option></option>
     <%
      	for (int j = 1; j <= 12; j++) 
      	{
    	  if (j < 10)
    	  {%>        	
    	    <option value=0<%=j%> <%if(begM[1] == j) out.print("selected");%>>0<%=j%></option>        		
    	  <%
    	  }
    	  else
    	  {%>
    	    <option value=<%=j%> <%if(begM[1] == j) out.print("selected");%>><%=j%></option>
    	<%}%>
       <%}%>
     </select>月
     <select id="hide8" name=begD1>
     <option></option>
     <%
      	 for (int j = 1; j < 32; j++) 
      	 {
    	   if (j < 10)
    	   {%>        	
    	   <option value=0<%=j%> <%if(begD[1] == j) out.print("selected");%>>0<%=j%></option>        		
    	   <%
    	   }
    	  else
    	   {%>
    	   <option value=<%=j%> <%if(begD[1] == j) out.print("selected");%>><%=j%></option>
    	 <%}%>
       <%}%>
     </select>日</font>
     <font color="#FF0000">至</font>  
     <input type='text' name='endY1' value="<%=endY[1]%>" size='3' maxlength='3' onblur='CheckYear(this)'>
     <font color='#000000'>年
     <select id="hide9" name=endM1>
     <option></option>
     <%
    	for (int j = 1; j <= 12; j++) 
    	{
    	  if (j < 10)
    	  {%>        	
    	    <option value=0<%=j%> <%if(endM[1] == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}
    	  else
    	  {%>
    	    <option value=<%=j%> <%if(endM[1] == j) out.print("selected");%>><%=j%></option>
    	<%}%>
      <%}%>
      </select>月
     <select id="hide8" name=endD1>
     <option></option>
     <%
      	 for (int j = 1; j < 32; j++) 
      	 {
    	   if (j < 10)
    	   {%>        	
    	   <option value=0<%=j%> <%if(endD[1] == j) out.print("selected");%>>0<%=j%></option>        		
    	  <%
    	   }
    	   else
    	   {%>
    	   <option value=<%=j%> <%if(endD[1] == j) out.print("selected");%>><%=j%></option>
    	 <%}%>
       <%}%>
     </select>日</font>
     </tr>

       <%}%>
      <% if(flag.equals(""))
      {%>
    <tr class="sbody">
      <td width="118" bgcolor="#BDDE9C" height="1">回文日期</td>
      <td width="416" bgcolor="#EBF4E1" height="1">
      <input type='text' name='begY2' value="<%=begY[2]%>" size='3' maxlength='3' onblur='CheckYear(this)'>    
      <font color='#000000'>年
      <select id="hide1" name=begM2>
      <option></option>
    <%
    	for (int j = 1; j <= 12; j++) 
    	{
    	  if (j < 10)
    	  {%>        	
      	  <option value=0<%=j%> <%if(begM[2] == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}
    	  else
    	  {%>
    	  <option value=<%=j%> <%if(begM[2] == j) out.print("selected");%>><%=j%></option>
    	<%}%>
      <%}%>
    </select>月
   <select id="hide1" name=begD2>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) 
    	{
    	  if (j < 10)
    	  {%>        	
    	    <option value=0<%=j%> <%if(begD[2] == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}
    	  else
    	  {%>
    	  <option value=<%=j%> <%if(begD[2] == j) out.print("selected");%>><%=j%></option>
    	<%}%>
      <%}%>
    </select>日</font>
    <font color="#FF0000">至</font>  
    <input type='text' name='endY2' value="<%=endY[2]%>" size='3' maxlength='3' onblur='CheckYear(this)'>
    <font color='#000000'>年
    <select id="hide1" name=endM2>
    <option></option>
    <%
    	for (int j = 1; j <= 12; j++) 
    	{
    	  if (j < 10)
    	  {%>        	
    	  <option value=0<%=j%> <%if(endM[2] == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}
    	  else
    	  {%>
    	  <option value=<%=j%> <%if(endM[2] == j) out.print("selected");%>><%=j%></option>
    	<%}%>
       <%}%>
    </select>月
     <select id="hide8" name=endD2>
     <option></option>
     <%
      	 for (int j = 1; j < 32; j++) 
      	 {
    	   if (j < 10)
    	   {%>        	
    	   <option value=0<%=j%> <%if(endD[2] == j) out.print("selected");%>>0<%=j%></option>        		
    	  <%
    	  }
    	  else
    	  {%>
    	   <option value=<%=j%> <%if(endD[2] == j) out.print("selected");%>><%=j%></option>
    	<%}%>
       <%}%>
     </select>日</font>
     </tr>
     <tr class="sbody">
       <td width="118" bgcolor="#BDDE9C" height="1">檢舉內容查詢</td>
       <td width="550" bgcolor="#EBF4E1" height="1">
       <input type="text" name="taContent" size="49">&nbsp; (依輸入內容模糊查詢)
    </tr> 	
       <%}%>
</Table>

<% if(item.equals("1")) 
   {%>
	<Table border="1" width="100%"  bgcolor="#FFFFF" bordercolor="#76C657">
    <tr class="sbody" bgcolor="#BFDFAE">
      <td width="15%" height="14">收文文號</td>
      <td width="20%" height="14">檢舉人</td>          
      <td width="25%" height="14">被檢舉機構</td>
      <td width="10%" height="14">收文日期</td>
      <td width="30%" height="14">檢舉內容</td> 
    </tr>

    <%
    List rs = (List)request.getAttribute("QueryResult");
    
    if(rs != null && rs.size() > 0) 
    {
      System.out.println("Query Result Data Size= "+rs.size());
      for(int i=0; i<rs.size(); i++) 
      {
        DataObject bean =(DataObject)rs.get(i);
    %>      
    <tr class="sbody" bgcolor='<%=(i % 2 == 0)?"#EBF4E1":"#FFFFCC"%>'>
      <td width="15%" height="1"><a href=MC014W.jsp?act=Edit&bank_no=<%=bean.getValue("bank_no")%>&taNum=<%=bean.getValue("ta_number")%>&taNo=<%=bean.getValue("ta_no")%>&flag=<%=flag%>&item=<%=item%>><%=bean.getValue("ta_number")%></a>&nbsp;</td>
      <td width="20%" height="1"><%=bean.getValue("ta_reporter") != null ? bean.getValue("ta_reporter") : "&nbsp;"%></td>
      <td width="25%" height="1"><%=bean.getValue("bank_no") != null ? bean.getValue("bank_no") : "&nbsp;"%><%=bean.getValue("bank_name") != null ? bean.getValue("bank_name") : "&nbsp;"%></td>
      <td width="10%" height="1"><%=bean.getValue("ta_date") != null ? bean.getValue("ta_date") : "&nbsp;"%></td>
      <td width="30%" height="1"><%=bean.getValue("ta_content") != null ? (String)bean.getValue("ta_content") : "&nbsp;"%></td>
    </tr>
    <%        
      }
    }
    else 
    {%>            
    <tr bgcolor="#EBF4E1" class="sbody">
       <td width="100%" colspan='5' align='center'><font color="#FF0000">查無符合資料</font></td>
    </tr>
  <%}%>        
  </Table>
<%}%>
<%if(item.equals("2")) 
  {%>

<Table border="1" width="100%"  bgcolor="#FFFFF" bordercolor="#76C657">
      <tr class="sbody" bgcolor="#BFDFAE">
        <td width="15%" height="14">收文文號</td>
        <td width="15%" height="14">發文文號</td>          
        <td width="10%" height="14">發文日期</td>
        <td width="20%" height="14">被檢舉機構</td>
        <td width="40%" height="14">本局處理意見</td> 
      </tr>

      <%
      List rs = (List)request.getAttribute("QueryResult");
      
      if(rs != null && rs.size() > 0) 
      {
        System.out.println("Query Result Data Size= "+rs.size());
        for(int i=0; i<rs.size(); i++) 
        {
          DataObject bean =(DataObject)rs.get(i);
        %>      
      <tr class="sbody" bgcolor='<%=(i % 2 == 0)?"#EBF4E1":"#FFFFCC"%>'>
        <td width="15%" height="1"><a href=MC014W.jsp?act=Edit&bank_no=<%=bean.getValue("bank_no")%>&taNum=<%=bean.getValue("ta_number")%>&taNo=<%=bean.getValue("ta_no")%>&flag=<%=flag%>&item=<%=item%>><%=bean.getValue("ta_number")%></a>&nbsp;</td>
        <td width="15%" height="1"><%=bean.getValue("ta_publicnum") != null ? bean.getValue("ta_publicnum") : ""%></td>
        <td width="10%" height="1"><%=bean.getValue("ta_publicdate") != null ? bean.getValue("ta_publicdate") : ""%></td>
        <td width="20%" height="1"><%=bean.getValue("bank_name") != null ? bean.getValue("bank_name") : ""%></td>
        <td width="40%" height="1"><%=bean.getValue("ta_publiccontent") != null ? bean.getValue("ta_publiccontent") : ""%></td>
      </tr>
      <%
         }
      }
      else 
      {%>            
     <tr bgcolor="#EBF4E1" class="sbody">
        <td width="100%" colspan='5' align='center'><font color="#FF0000">查無符合資料</font></td>
      </tr>
     <%   
      }
     %>        
</Table>
<%}%>
<%if(item.equals("3")) 
  {%>
<Table border="1" width="100%"  bgcolor="#FFFFF" bordercolor="#76C657">
      <tr class="sbody" bgcolor="#BFDFAE">
        <td width="15%" height="14">收文文號</td>
        <td width="20%" height="14">檢舉人</td>          
        <td width="25%" height="14">被檢舉機構</td>
        <td width="45%" height="14">檢舉內容</td>
      </tr>
      <%
      List rs = (List)request.getAttribute("QueryResult");
      
      if(rs != null && rs.size() > 0) 
      {
        System.out.println("Query Result Data Size= "+rs.size());
        for(int i=0; i<rs.size(); i++) 
        {
          DataObject bean =(DataObject)rs.get(i);
        %>      
      <tr class="sbody" bgcolor='<%=(i % 2 == 0)?"#EBF4E1":"#FFFFCC"%>'>
        <td width="15%" height="1"><a href=MC014W.jsp?act=Edit&bank_no=<%=bean.getValue("bank_no")%>&taNum=<%=bean.getValue("ta_number")%>&taNo=<%=bean.getValue("ta_no")%>&flag=<%=flag%>&item=<%=item%>><%=bean.getValue("ta_number")%></a>&nbsp;</td>
        <td width="20%" height="1"><%=bean.getValue("ta_reporter") != null ? bean.getValue("ta_reporter") : ""%></td>
        <td width="25%" height="1"><%=bean.getValue("bank_name") != null ? bean.getValue("bank_name") : ""%></td>
        <td width="45%" height="1"><%=bean.getValue("ta_content") != null ? bean.getValue("ta_content") : ""%></td>
      </tr>
      <%        
        }
      }
      else 
      {%>            
     <tr bgcolor="#EBF4E1" class="sbody">
        <td width="100%" colspan='4' align='center'><font color="#FF0000">查無符合資料</font></td>
      </tr>
    <%}%>       
</Table>
<%}%>
<%}%>
<table width="100%" border="0" cellpadding="1" cellspacing="1" class="sbody">
  <tr>
    <td colspan='2' align='center'>
    
    </td>
  </tr>
  <tr> 
    <td colspan="2">
      <font color='#990000'>
        <img src="images/arrow_1.gif" width="28" height="23" align="absmiddle">
        <font color="#007D7D" size="3">使用說明  : </font></font></td>
  </tr>
  <tr> 
    <td width="3%">　</td>
    <td width="97%"> 
      <ul>                                                
        <%if(act.equals("List")) {%>
            <li>本網頁提供檢舉書查詢功能。</li>
            <li>按<font color="#666666">【查詢】</font>則依查詢條件值查詢資料。</li> 
		   
        <% } else if(act.equals("Qry")) {%>
            <%if(flag.equals("R")){%>
              <li>本網頁提供檢舉書發文查詢功能。</li>
            <%}else if(flag.equals("B")){%>
              <li>本網頁提供檢舉書回文查詢功能。</li>
            <%}else{%>
              <li>本網頁提供檢舉書查詢功能。</li>
            <%}%>              
            <li>按<font color="#666666">【查詢】</font>則依查詢條件值查詢資料。</li>
            <%if(item.equals("1")){%>
		      <li>按<font color="#666666">【收文文號】連結</font>則可查看此筆資料。</li>
            <%}else if(item.equals("2")){%>
              <li>按<font color="#666666">【收文文號】連結</font>則可查看此筆資料。</li>
            <%}else if(item.equals("3")){%>
              <li>按<font color="#666666">【收文文號】連結</font>則可查看此筆資料。</li>
            <%}%>              
        <%} else if(act.equals("New")) {%>
            <li>本網頁檢舉書受理作業維護功能。</li>
		    <li>按<font color="#666666">【確定】</font>即將資料寫入資料庫。</li> 
		    <li>按<font color="#666666">【取消】</font>放棄資料修改。</li>
		<%} else if(act.equals("Edit")) {%>
            <li>本網頁提供檢舉書作業維護功能。</li>
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
changeCity("CityXML",form.begY) ;
changeTbank("TBankXML",form.begY);
setSelect(form.bankType,"<%=bankType%>");
//changeOption('TBankXML',form.tbank, form.bankType, 'TBankXML');
setSelect(form.tbank,"<%=tbank%>");
setSelect(form.begM,"<%=begM[0]%>");
setSelect(form.endM,"<%=endM[0]%>");
setSelect(form.begD,"<%=begD[0]%>");
setSelect(form.endD,"<%=endD[0]%>");
setSelect(form.cityType,"<%=cityType%>");
<%if(flag.equals("B")||flag.equals(""))
{%>
  setSelect(form.begM1,"<%=begM[1]%>");
  setSelect(form.endM1,"<%=endM[1]%>");
  setSelect(form.begD1,"<%=begD[1]%>");
  setSelect(form.endD1,"<%=endD[1]%>");
<%}%>
<%
if(flag.equals(""))
{%>
	  setSelect(form.begM2,"<%=begM[2]%>");
	  setSelect(form.endM2,"<%=endM[2]%>");
	  setSelect(form.begD2,"<%=begD[2]%>");
	  setSelect(form.endD2,"<%=endD[2]%>");
	  setText(form.taContent,"<%=taContent%>");	  
<%}%>
-->
</script>

</HTML>

<%
//97.08.29-09.01 create 違反農金法及其子法而遭罰款 by 2295
//99.05.13 fix 縣市合併調整&sql injection by 2808
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");				
	System.out.println("Page: MC001W_List.jsp    Action:"+act);

    // 查詢條件值 
    String bankType = request.getParameter("bankType" )== null ? (String)request.getAttribute("bankType") : (String)request.getParameter("bankType");    
    String tbank = request.getParameter("tbank" )== null ? "" : (String)request.getParameter("tbank");
    String cityType = request.getParameter("cityType" )== null ? (String)request.getAttribute("cityType") : (String)request.getParameter("cityType");   
    String begDate = request.getParameter("begDate" )== null ? (String)request.getAttribute("begDate") : (String)request.getParameter("begDate");
    String endDate = request.getParameter("endDate" )== null ? (String)request.getAttribute("endDate") : (String)request.getParameter("endDate");
    String content = request.getParameter("content" )== null ? (String)request.getAttribute("content") : (String)request.getParameter("content");
    String violate_type = request.getParameter("violate_type" )== null ? (String)request.getAttribute("violate_type") : (String)request.getParameter("violate_type");
    
    Properties permission = ( session.getAttribute("MC001W")==null ) ? new Properties() : (Properties)session.getAttribute("MC001W");
    if (permission == null) {
        System.out.println("MC001W_List.permission == null");
    }else {
        System.out.println("MC001W_List.permission.size ="+permission.size());
        System.out.println(permission.get("A"));
    }
    
	// 轉換西元年到民國年
	Calendar c = Calendar.getInstance();
	int begY = c.get(Calendar.YEAR)-1911;
	int endY = c.get(Calendar.YEAR)-1911;
	if(begDate.length() > 6 )
	    begY = Integer.parseInt(begDate.substring(0,4))-1911;	
	if(endDate.length() > 6 )
	    endY = Integer.parseInt(endDate.substring(0,4))-1911;
	
	int begM = c.get(Calendar.MONTH)+1;
	int endM = c.get(Calendar.MONTH)+1;
	if(begDate.length() > 6 )
	    begM = Integer.parseInt(begDate.substring(4,6));	
	if(endDate.length() > 6 )
	    endM = Integer.parseInt(endDate.substring(4,6));
	    
	int begD = 1;
	int endD = 31;
	if(begDate.length() > 6 )
	    begD = Integer.parseInt(begDate.substring(6,8));	
	if(endDate.length() > 6 )
	    endD = Integer.parseInt(endDate.substring(6,8));
        
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
    List paramList = new ArrayList();
		StringBuffer sql = new StringBuffer();
		
		sql.append(" select cmuse_id,cmuse_name from cdshareno where cmuse_div=? order by input_order"); 
		paramList.add("038");		
		List violate_type_dbdate = DBManager.QueryDB_SQLParam(sql.toString(),paramList,"");                    
    DataObject bean = null;
    String report_no = "MC001W";	
    List violate_type_list=null;
    violate_type_list = Utility.getStringTokenizerData(violate_type,":");
%>

<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<TITLE>違反農金法及其子法而遭罰款增加訴願案件資料</TITLE>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/MC001W.js"></script>
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
<Form name='form' method=post action='MC001W.jsp'>
<input type='hidden' name="act" value=''>
<input type='hidden' name="begDate" value='<%=begDate%>'>
<input type='hidden' name="endDate" value='<%=endDate%>'>

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
     <tr> 
           <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
           <td width="50%"><font color='#000000' size=4><b><center><%=Utility.getPgName(report_no)%>查詢 </center></b></font> </td>
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

<Table border=1 width='100%' align=center height="65" bgcolor="#FFFFF" bordercolor="#76C657">
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">受處分日期</td>
    <td width="460" bgcolor="#EBF4E1" height="1">
    <input type='text' name='begY' value="<%=begY%>" size='3' maxlength='3' onblur='CheckYear(this)' onChange="chnageYear()"></input>    
    <font color='#000000'>年
    <select id="hide1" name=begM>
    <option></option>
    <%
    	for (int j = 1; j <= 12; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(begM == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(begM == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>月
    <select id="hide1" name=begD>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(begD == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(begD == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>日</font>
    <font color="#FF0000">至</font>  
    <input type='text' name='endY' value="<%=endY%>" size='3' maxlength='3' onblur='CheckYear(this)'>
    <font color='#000000'>年
    <select id="hide1" name=endM>
    <option></option>
    <%
    	for (int j = 1; j <= 12; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(endM == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(endM == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>月
    <select id="hide1" name=endD>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(endD == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(endD == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>日</font>
</tr>
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">金融機構類別</td>
<td width="460" bgcolor="#EBF4E1" height="1">
   <select size="1" name="bankType" onChange="changeTbank('TBankXML')">
     <option value="6">農會</option>
     <option value="7">漁會</option>
  </select>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  縣市別:&nbsp;&nbsp;
  <select size="1" name="cityType" onChange="changeTbank('TBankXML')" >
  </select>
  &nbsp;&nbsp;&nbsp;&nbsp; 
  <a href="javascript:doSubmit(form,'Qry','');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_queryb.gif',1)"><img src="images/bt_query.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a>&nbsp;&nbsp;&nbsp;&nbsp;
  <%if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){//Add %>  
  <a href="/pages/MC001W.jsp?act=New" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_addb.gif',1)">
     <img src="images/bt_add.gif" name="Image102" width="66" height="25" border="0" id="Image101"></a>
  <%}%>
</td>
</tr>

<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">受處分機構</td>
<td width="460" bgcolor="#EBF4E1" height="1">           
  <select size="1" name="tbank" ></select>
</td>
</tr>
    
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">處分方式</td>
<td width="460" bgcolor="#EBF4E1" height="1">           
  <%for(int i=0;i<violate_type_dbdate.size();i++){
    bean = (DataObject)violate_type_dbdate.get(i);
  	%>
  	<input type="checkbox" name="violate_type_<%=(i+1)%>" value="<%=bean.getValue("cmuse_id")%>" 
  	<%
  	for(int j=0;j<violate_type_list.size();j++){
  	//System.out.println((String)violate_type_list.get(j));
  	if(((String)violate_type_list.get(j)).equals(bean.getValue("cmuse_id"))) out.print(" checked ");
  	}
  	%>
  	><%=bean.getValue("cmuse_name")%>
    <%} %>
    
</td>
</tr>
    
<tr class="sbody">
  <td width="118" bgcolor="#BDDE9C" height="20">受處分說明</td>
  <td width="460" bgcolor="#EBF4E1" height="20">
  <input type="text" name="content" size="30" value="<%=content%>">&nbsp;&nbsp;&nbsp;&nbsp;  
    <font color="#FF0000">(依輸入內容模糊查詢)</font></td>
</tr>


</Table>

<% if(act.equals("Qry")) {%>


<Table border="1" width="100%"  bgcolor="#FFFFF" bordercolor="#76C657">
      <tr class="sbody" bgcolor="#BFDFAE">
        <td width="20%" height="14">受處分機構</td>
        <td width="10%" height="14">受處分日期</td>       
        <td width="10%" height="14">處分方式</td>    
        <td width="15%" height="14">主旨</td>
        <td width="30%" height="14">說明</td> 
        <td width="15%" height="14">法令依據</td>
      </tr>
      
      <%
      
      List rs = (List)request.getAttribute("QueryResult");
      String violate_type_name = "";
      DataObject violate_type_bean = null;
      if(rs != null && rs.size() > 0) {
          System.out.println("Query Result Data Size= "+rs.size());
          for(int i=0; i<rs.size(); i++) {
              bean =(DataObject)rs.get(i);
      %>      
      <tr class="sbody" bgcolor='<%=(i % 2 == 0)?"#EBF4E1":"#FFFFCC"%>'>
        <td width="20%" height="1"><a href=MC001W.jsp?act=Edit&bankType=<%=bankType %>&bank_no=<%=bean.getValue("bank_no")%>&violate_date=<%=bean.getValue("violate_date_1")%>><%=bean.getValue("bank_name")%></a>&nbsp;</td>
        <td width="10%" height="1"><%=bean.getValue("violate_date") != null ? bean.getValue("violate_date") : ""%></td>
        <td width="10%" height="1">
        <%
           violate_type_list= new LinkedList();
           violate_type_name = bean.getValue("violate_type") != null ? (String)bean.getValue("violate_type") : "";
           if(!"".equals(violate_type_name)){
              violate_type_list = Utility.getStringTokenizerData(violate_type_name,":");
              violate_type_name = "";
  					  for(int j=0;j<violate_type_list.size();j++){//處分方式
  					  	  System.out.println("j="+(String)violate_type_list.get(j));
  					  	  violate_type_loop:
  					      for(int k=0;k<violate_type_dbdate.size();k++){//代碼檔
    								  violate_type_bean = (DataObject)violate_type_dbdate.get(k);  	
  									  if(((String)violate_type_list.get(j)).equals(violate_type_bean.getValue("cmuse_id"))){
  									  		violate_type_name += violate_type_bean.getValue("cmuse_name")+"<br>";
  									  		System.out.println(violate_type_name);
  									  		break violate_type_loop;
  										}
  					  		}//end of violate_type_dbdate
           		}//end of violate_type_list
    		   }//end of violate_type != ''
    		   out.print(violate_type_name);
  			%>
  	    </td>
        <td width="15%" height="1"><%=bean.getValue("title") != null ? bean.getValue("title") : ""%></td>
        <td width="30%" height="1"><%=bean.getValue("content") != null ? bean.getValue("content") : ""%></td>
        <td width="15%" height="1"><%=bean.getValue("law_content") != null ? bean.getValue("law_content") : ""%></td>
      </tr>
      <%        }
     }else {%>   
     <tr bgcolor="#EBF4E1" class="sbody">
        <td width="100%" colspan='6' align='center'><font color="#FF0000">查無符合資料</font></td>
      </tr>
<%   }
}   %>      
</Table>

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
    <td width="3%">&nbsp;</td>
    <td width="97%"> 
      <ul>                                                
        <%if(act.equals("List")) {%>
            <li>本網頁提供基本資料查詢功能。</li>
            <li>按<font color="#666666">【查詢】</font>則依查詢條件值查詢資料。</li> 
		   
        <% } else if(act.equals("Qry")) {%>
            <li>本網頁提供基本資料查詢功能。</li>
            <li>按<font color="#666666">【查詢】</font>則依查詢條件值查詢資料。</li> 
		    <li>按<font color="#666666">【受處分機構】連結</font>則可查看此筆資料。</li>
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
setSelect(form.bankType,"<%=bankType%>");
changeCity("CityXML") ;
changeTbank("TBankXML");

//changeOption('TBankXML',form.tbank, form.bankType, 'TBankXML');
setSelect(form.tbank,"<%=tbank%>");
setSelect(form.begM,"<%=begM%>");
setSelect(form.endM,"<%=endM%>");
setSelect(form.begD,"<%=begD%>");
setSelect(form.endD,"<%=endD%>");
setSelect(form.cityType,"<%=cityType%>");
-->
</script>

</HTML>

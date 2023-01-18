<%
//98.06.02 限制或核准業務函令查詢--by 2756
//98.10.22 拿掉業務開辦日期 by 2295
//99.05.27 fix 縣市合併調整&sql injection by 2808
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
String act = Utility.getTrimString(request.getParameter("act")) ;	
    Properties permission = ( session.getAttribute("MC010W")==null ) ? new Properties() : (Properties)session.getAttribute("MC010W");
    if(permission == null){
       System.out.println("MC010W_Edit.permission == null");
    }else{
       System.out.println("MC010W_Edit.permission.size ="+permission.size());
    }			
    System.out.println("Page: MC010W_Edit.jsp    Action:"+act);

    String tbank="",bank_name="",loalAddDate="",loalMgr="",loalNum="",loalContent="",loalState="",loalPs="",loalHide="",loalNo="",a="",loalOpenDate="",loalOpenFlag="";
    String bankType = Utility.getTrimString(request.getParameter("bankType")) ;  
    String cityType = Utility.getTrimString(request.getParameter("cityType")) ;
    String begDate = Utility.getTrimString(request.getParameter("begDate")) ;
    String endDate = Utility.getTrimString(request.getParameter("endDate")) ;
    String begDate1 = Utility.getTrimString(request.getParameter("begDate1")) ;
    String endDate1 = Utility.getTrimString(request.getParameter("endDate1")) ;

    String [] dtBgn={begDate,begDate1};
    String [] dtEnd={endDate,endDate1};
    int [] begY=new int[3];
    int [] endY=new int[3];
    int [] begM=new int[3];
    int [] endM=new int[3];
    int [] begD=new int[3];
    int [] endD=new int[3];
    boolean openflag =false;//當已存在業務開辦日期時,預設不可勾選尚未開辦
    
    Calendar c = Calendar.getInstance();
    
    for(int i=0;i<1;i++)//設定函文日期的年月日
    {    	

    	  begY[i]=c.get(Calendar.YEAR)-1911;
    	  begM[i] = c.get(Calendar.MONTH)+1;
    	  begD[i]=1;

      	  endY[i]=c.get(Calendar.YEAR)-1911;
    	  endM[i] = c.get(Calendar.MONTH)+1;
    	  endD[i]=31;

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


    
 /*  
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
*/

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
    }
    else if(act.equals("Edit")) 
    {
        DataObject bean = (DataObject) request.getAttribute("DETAIL");
        if(bean != null) {            
            tbank = bean.getValue("bank_no") != null ? (String) bean.getValue("bank_no") : "";
            bank_name = bean.getValue("bank_name") != null ? (String) bean.getValue("bank_name") : "";
            loalAddDate= bean.getValue("loal_add_date") != null ? String.valueOf(bean.getValue("loal_add_date")) : "";
            loalMgr= bean.getValue("loal_manager") != null ? String.valueOf(bean.getValue("loal_manager")) : "";
            loalNum= bean.getValue("loal_number") != null ? String.valueOf(bean.getValue("loal_number")) : "";
            loalContent= bean.getValue("loal_content") != null ? String.valueOf(bean.getValue("loal_content")) : "";
            loalState= bean.getValue("loal_states") != null ? String.valueOf(bean.getValue("loal_states")) : "";
            loalPs= bean.getValue("loal_ps") != null ? String.valueOf(bean.getValue("loal_ps")) : "";
            loalHide= bean.getValue("loal_hide") != null ? String.valueOf(bean.getValue("loal_hide")) : "";
            loalNo= bean.getValue("loal_no") != null ? String.valueOf(bean.getValue("loal_no")) : "";
            
            loalOpenDate=bean.getValue("loal_open_date") != null ? String.valueOf(bean.getValue("loal_open_date")) : "";
            loalOpenFlag=bean.getValue("loal_open_flag") != null ? String.valueOf(bean.getValue("loal_open_flag")) : "";  
            
            System.out.println("loalopendate:"+loalOpenDate);
            //設定修改時的業務開辦日期之年月日
            if(!loalOpenDate.equals("")&&!loalOpenDate.equals("尚未開辦"))//此時無法再勾選「尚未開辦」
            {
        		  begY[2] = Integer.parseInt(loalOpenDate.substring(0,2));
        		  begM[2] = Integer.parseInt(loalOpenDate.substring(3,5));
        		  begD[2] = Integer.parseInt(loalOpenDate.substring(6,8));
        		  System.out.println("beg:"+String.valueOf(begY[2])+","+String.valueOf(begM[2])+","+String.valueOf(begD[2]));
            }
            else
            {
            	openflag=true;
            }
        }
    }
%>

<HTML>
<HEAD>
<TITLE>限制或核准業務函令</TITLE>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/MC010W.js"></script>
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

function MoveSel(a,b) {
  if(a!="請選擇")
  {
    b.value=a;
  }  
 }
//-->
</script>
<BODY bgColor=#FFFFFF>
<Form name='form' method=post action='MC010W.jsp'>
<input type='hidden' name="act" value=''>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
     <tr> 
           <td width="35%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
           <td width="30%"><font color='#000000' size=4><b><center>限制或核准業務函令</center></b></font> </td>
           <td width="35%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
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

<%if(act.equals("New")){%>
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">金融機構類別</td>
<td width="416" bgcolor="#EBF4E1" height="1">
 <select size="1" name="bankType" onChange="changeTbank('TBankXML')">
     <option value="6">農會</option>
     <option value="7">漁會</option>
  </select>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  縣市別:&nbsp;&nbsp;
 <select size="1" name="cityType" onChange="changeTbank('TBankXML')" >
 </select>
  </td>
</tr>

<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">受限制或核准機構</td>
<td width="416" bgcolor="#EBF4E1" height="1">           
  <select size="1" name="tbank" >
    <option value="" >全部</option>
  </select>  </td>
</tr>

<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">函文日期</td>
    <td width="416" bgcolor="#EBF4E1" height="1">
    <input type='hidden' name="loalAddDate" value="">
    <input type='text' name='begY' value="<%=begY[0]%>" size='3' maxlength='3' onblur='CheckYear(this)' onChange='chnageYear();'>
    <font color='#000000'>年
    <select id="hide1" name=begM>
    <option></option>
    <%
    	for (int j = 1; j <= 12; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(begM[0] == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(begM[0] == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>月
    <select id="hide1" name=begD>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(begD[0] == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(begD[0] == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select></font><font color='#000000'>日</font>
	</td>  
</tr> 
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">限制或核准機關</td>
<td width="550" bgcolor="#EBF4E1" height="1">           
  <select size="1" name="loalMgr0" >
    <option value="">請選擇</option>
<%   List mgrList = (List) request.getAttribute("LMgr");
     if(mgrList != null) {
         for(int i=0; i < mgrList.size(); i++) {
             DataObject bean =(DataObject)mgrList.get(i);
%>   
     <option value="<%=bean.getValue("select_num")%>"><%=bean.getValue("select_name")%></option>
<%       }
     }
%>
    
  </select><img src="images/arrow_right.gif" width="24" height="22" border="0" onclick="MoveSel(document.form.loalMgr0.options[document.form.loalMgr0.selectedIndex].text,document.form.loalMgr)">
  <input type='text' maxlength='30' name="loalMgr"  size="27">&nbsp; (選擇後請點選&quot; ->&quot;， 或自行輸入)
</td>
</tr>
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">限制或核准函號</td>
<td width="416" bgcolor="#EBF4E1" height="1">
  <input type='text' maxlength='30' name="loalNum" size="20"></td>
</tr>
<!--98.10.21 拿掉業務開辦日期>
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">業務開辦日期</td>
<td width="416" bgcolor="#EBF4E1" height="1">
    <input type='hidden' name="loalOpenDate" value="">
    <input type='text' name='begY1' value="" size='3' maxlength='3' onblur='CheckYear(this)'>
    <font color='#000000'>年
    <select id="hide2" name=begM1>
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
    <select id="hide3" name=begD1>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(begD[1] == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(begD[1] == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select>日</font> ，<input type="checkbox" name="loalOpenFlag">尚未開辦</td>
</tr-->
<%}%>    
<%if(act.equals("Edit")){%>
<tr class="sbody">
<td width="118" bgcolor="#BDDE9C" height="1">受限制或核准機構</td>
<td width="416" bgcolor="#EBF4E1" height="1"><%=tbank%><%=bank_name%></td>
<input type='hidden' name='loalNo' value='<%=loalNo%>'>
</tr>
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">函文日期</td>
    <td width="416" bgcolor="#EBF4E1" height="1"><%=loalAddDate%></td>   
    <input type='hidden' name='loalAddDate' value='<%=loalAddDate%>'>
</tr> 
<!--98.10.21 拿掉業務開辦日期>
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">業務開辦日期</td>
    <td width="416" bgcolor="#EBF4E1" height="1">
    <input type='hidden' name="loalOpenDate" value="">
    <%if(!loalOpenDate.equals("")&&!loalOpenDate.equals("尚未開辦")){%>
    <input type='text' name='begY2' size='3' maxlength='3' value=<%=begY[2]%> onblur='CheckYear(this)'>
    <%}else{%>
    <input type='text' name='begY2' size='3' maxlength='3' onblur='CheckYear(this)'>
    <%}%>
    <font color='#000000'>年
    <select id="hide4" name=begM2>
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
    <select id="hide5" name=begD2>
    <option></option>
    <%
    	for (int j = 1; j < 32; j++) {
    	if (j < 10){%>        	
    	<option value=0<%=j%> <%if(begD[2] == j) out.print("selected");%>>0<%=j%></option>        		
    	<%}else{%>
    	<option value=<%=j%> <%if(begD[2] == j) out.print("selected");%>><%=j%></option>
    	<%}%>
    <%}%>
    </select>日</font> ，<%if(loalOpenFlag.equals("Y")){%>
               <input type="checkbox" name="loalOpenFlag" checked><%}else{%>
               <input type="checkbox" name="loalOpenFlag" disabled><%}%>                         
                                       尚未開辦</td>   
</tr-->
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">限制或核准機關</td>
    <td width="416" bgcolor="#EBF4E1" height="1"><%=loalMgr%></td>   
    <input type='hidden' name='loalMgr' value='<%=loalMgr%>'>
</tr>
<tr class="sbody">
  <td width="118" bgcolor="#BDDE9C" height="20">限制或核准函號</td>
  <td width="416" bgcolor="#EBF4E1" height="20"><%=loalNum%></td>
  <input type='hidden' name='loalNum' value='<%=loalNum%>'>
</tr>       
<%}%>
<tr class="sbody">
  <td width="118" bgcolor="#BDDE9C" height="20">限制或核准內容</td>
  <td width="416" bgcolor="#EBF4E1" height="20">
  <textarea rows="6" cols="87" name='loalContent'><%=loalContent%></textarea> 
  </td>
</tr>
<tr class="sbody">
  <td width="118" bgcolor="#BDDE9C" height="20">狀態</td>
  <td width="416" bgcolor="#EBF4E1" height="20">
  &nbsp;<select size="1" name="loalState" >
<%   List stateList = (List) request.getAttribute("LState");
     if(stateList != null) {
         for(int i=0; i < stateList.size(); i++) {
             DataObject bean =(DataObject)stateList.get(i);
             a=String.valueOf(bean.getValue("select_num"));
%>   
     <option value="<%=bean.getValue("select_num")%>" <%if (loalState.equals(a)) out.print("selected");%>><%=bean.getValue("select_name")%></option>
<%       }
     }
%>
  </select></td>
</tr>

<tr class="sbody">
  <td width="118" bgcolor="#BDDE9C" height="20">備註</td>
  <td width="416" bgcolor="#EBF4E1" height="20">
  <textarea rows="2" cols="50" name='loalPs' maxlength='300' ><%=loalPs%></textarea> 
  </td>
</tr>
<tr class="sbody">
  <td width="173" bgcolor="#BDDE9C" height="20">是否將此筆資料給予檢查局 ?</td>
  <td width="416" bgcolor="#EBF4E1" height="20">
  <input type='radio' name='loalHide' value="0" <%if(loalHide.equals("0")||act.equals("New")) out.print("checked");%>>是 
  <input type='radio' name='loalHide' value="1" <%if(loalHide.equals("1")) out.print("checked");%>>否
  </td>
</tr>

</Table>
                    <tr>
                      <td colspan="2" width="583" height="41">
                      <div align="center">
                    <table width="243" border="0" cellpadding="1" cellspacing="1">
                      <tr>
                       <%if(act.equals("New")){
                       if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){//Add
                      %>
				        <td width="66"><div align="center"><a href="javascript:doSubmit(this.document.forms[0],'add','<%=tbank%>');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_confirmb.gif',1)"><img src="images/bt_confirm.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a></div></td>
				        <% } }else{
				        if(permission != null && permission.get("U") != null && permission.get("U").equals("Y")){//Update %>
				        <td width="66"><div align="center"><a href="javascript:doSubmit(this.document.forms[0],'modify','');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image103','','images/bt_updateb.gif',1)"><img src="images/bt_update.gif" name="Image103" width="66" height="25" border="0" id="Image103"></a></div></td>
				        <td width="66"><div align="center"><a href="javascript:doSubmit(this.document.forms[0],'delete','');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image104','','images/bt_deleteb.gif',1)"><img src="images/bt_delete.gif" name="Image104" width="66" height="25" border="0" id="Image104"></a></div></td>
				         <% }}%>
                        <td width="66"><div align="center"><a href="javascript:AskReset(this.document.forms[0]);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_cancelb.gif',1)"><img src="images/bt_cancel.gif" name="Image105" width="66" height="25" border="0" id="Image105"></a></div></td>
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
        <%if(act.equals("List")) {%>
            <li>本網頁提供限制或核准業務函令查詢功能。</li>
            <li>按<font color="#666666">【查詢】</font>則依查詢條件值查詢資料。</li> 
		   
        <% } else if(act.equals("Qry")) {%>
            <li>本網頁提供限制或核准業務函令查詢功能。</li>
            <li>按<font color="#666666">【查詢】</font>則依查詢條件值查詢資料。</li>
        <%} else if(act.equals("New")) {%>
            </li>
            <li>本網頁提供限制或核准業務函令維護功能。</li>
		    <li>按<font color="#666666">【確定】</font>即將資料寫入資料庫。</li> 
		    <li>按<font color="#666666">【取消】</font>放棄資料修改。</li>
		<%} else if(act.equals("Edit")) {%>
            <li>本網頁提供限制或核准業務函令維護功能。</li>
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
<%if(act.equals("New")){%>
<script language="JavaScript" >
<!--
changeCity("CityXML") ;
changeTbank("TBankXML");
setSelect(form.bankType,"<%=bankType%>");
//changeOption('TBankXML',form.tbank, form.bankType, 'TBankXML');
setSelect(form.tbank,"<%=tbank%>");
setSelect(form.begM,"<%=begM[0]%>");
setSelect(form.endM,"<%=endM[0]%>");
setSelect(form.begD,"1");
setSelect(form.endD,"31");
setSelect(form.cityType,"<%=cityType%>");
-->
</script>
<%}%>
</HTML>

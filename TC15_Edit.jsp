<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%
	String szbank_type = ( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");		
	String sztbank_no = ( request.getParameter("tbank_no")==null ) ? "" : (String)request.getParameter("tbank_no");		
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");				
	String LAST_CHK_DATE_Y="";
	String LAST_CHK_DATE_M="";
	String LAST_CHK_DATE_D="";
	String LAST_CHK_DATE="";
		
	System.out.println("@@TC15_Edit.jsp Start...");
	System.out.println("act="+act);
	System.out.println("TC15_Edit.sztbank_no="+sztbank_no);
	
	List BA01 = (List)request.getAttribute("BA01");
	if(BA01 != null){
		if(BA01.size() != 0){
   	    	int i = 0;
			if(((DataObject)BA01.get(0)).getValue("exrecent_date") != null){
			   LAST_CHK_DATE = Utility.getCHTdate((((DataObject)BA01.get(0)).getValue("exrecent_date")).toString().substring(0, 10), 0);
			   System.out.println("@@LAST_CHK_DATE="+LAST_CHK_DATE);
			   i = 0;
			   if(LAST_CHK_DATE.length() == 9) i = 1; 
			   LAST_CHK_DATE_Y = LAST_CHK_DATE.substring(0,2+i);
			   LAST_CHK_DATE_M = LAST_CHK_DATE.substring(3+i,5+i);
			   LAST_CHK_DATE_D = LAST_CHK_DATE.substring(6+i,LAST_CHK_DATE.length());
			   System.out.println("@@LAST_CHK_DATE_Y="+LAST_CHK_DATE_Y);
			   System.out.println("@@LAST_CHK_DATE_M="+LAST_CHK_DATE_M);
			   System.out.println("@@LAST_CHK_DATE_D="+LAST_CHK_DATE_D);
			}
		}
	}else {
		System.out.println("LIST BA01 = NULL");
	}
		
	String title="「金融機構評等代號」";			
	title =(act.equals("Edit"))?title+"異動維護建檔":title;
	title =(act.equals("new"))?title+"新增建檔":title;
	
	//取得TC15的權限
	Properties permission = ( session.getAttribute("TC15")==null ) ? new Properties() : (Properties)session.getAttribute("TC15"); 
	if(permission == null){
       System.out.println("TC15_Edit.permission == null");
    }else{
       System.out.println("TC15_Edit.permission.size ="+permission.size());
               
    }	
	
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/TC15.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<title><%=title%></title>
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
</head>

<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" leftmargin="0">
<form method=post action='#'>
<input type="hidden" name="act" value="">  
<table width="600" border="0" align="left" cellpadding="0" cellspacing="1" bgcolor="#FFFFFF">
  		<tr> 
   		 <td><img src="images/space_1.gif" width="12" height="12"></td>
  		</tr>
        <tr> 
          <td bgcolor="#FFFFFF">
			<table width="560" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td><table width="560" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="110"><img src="images/banner_bg1.gif" width="110" height="17"></td>
                      <td width="380"><font color='#000000' size=4><b> 
                        <center>
                          <%=title%> 
                        </center>
                        </b></font> </td>
                      <td width="110"><img src="images/banner_bg1.gif" width="110" height="17"></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td><img src="images/space_1.gif" width="12" height="12"></td>
              </tr>
              <tr> 
                <td><table width="560" border="0" align="center" cellpadding="0" cellspacing="0">
               
                    <tr> 
                      <div align="right"><jsp:include page="getLoginUser.jsp?width=560" flush="true" /></div> 
                    </tr>
                    <%System.out.println("test1");%>
                    <tr> 
                      <td><table width=560 border=1 align=center cellpadding="1" cellspacing="1" bordercolor="#3A9D99">
                          <tr class="sbody">
						  <td width='15%' align='left' bgcolor='#D8EFEE'>金融機構類別</td>
						  <% List bank_type = DBManager.QueryDB_SQLParam("select cmuse_id,cmuse_name from cdshareno where cmuse_div='020' and cmuse_id <> '0' order by input_order",null,"");%>
						  <td width='85%' colspan=2 bgcolor='e7e7e7'>
                            <select name='BANK_TYPE' <%if(act.equals("Edit")) out.print("disabled");%> >                            
                            <%for(int i=0;i<bank_type.size();i++){%>
                            <option value="<%=(String)((DataObject)bank_type.get(i)).getValue("cmuse_id")%>"
                            <%if((BA01 != null && BA01.size() != 0) && ( ((DataObject)BA01.get(0)).getValue("bank_type") != null && ((String)((DataObject)BA01.get(0)).getValue("bank_type")).equals((String)((DataObject)bank_type.get(i)).getValue("cmuse_id")))) out.print("selected");%>
                            <%if(szbank_type.equals((String)((DataObject)bank_type.get(i)).getValue("cmuse_id"))) out.print("selected");%>
                            ><%=(String)((DataObject)bank_type.get(i)).getValue("cmuse_name")%></option>                            
                            <%}%>
                            </select>
                          </td>
                          </tr>     
					      
					      <tr class="sbody">
						  <td width='15%' align='left' bgcolor='#D8EFEE'>金融機構代碼</td>						  
						  <td width='85%' colspan=2 bgcolor='e7e7e7'>
						    <%if(act.equals("Edit")){%>
  		                     <input type='hidden' name='BANK_NO' value="<%if(BA01 != null && BA01.size() != 0 && ((DataObject)BA01.get(0)).getValue("bank_no") != null ) out.print((String)((DataObject)BA01.get(0)).getValue("bank_no"));%>">
  		                     <%if(BA01 != null && BA01.size() != 0 && ((DataObject)BA01.get(0)).getValue("bank_no") != null ) out.print((String)((DataObject)BA01.get(0)).getValue("bank_no"));%>
  		                    <%}else{%>
  		                    <input type='text' name='BANK_NO' value="<%if(BA01 != null && BA01.size() != 0 && ((DataObject)BA01.get(0)).getValue("bank_no") != null ) out.print((String)((DataObject)BA01.get(0)).getValue("bank_no"));%>" size='7' maxlength='7'>
  		                    <%}%>                                                                                						                              
                          </td>
                          </tr>                             
					     
					      <tr class="sbody">
						  <td width='15%' align='left' bgcolor='#D8EFEE'>金融機構名稱</td>
						  <td width='85%' colspan=2 bgcolor='e7e7e7'>                        		                    
  		                    <input type='text' name='BANK_NAME' value="<%if(BA01 != null && BA01.size() != 0 && ((DataObject)BA01.get(0)).getValue("bank_name") != null ) out.print((String)((DataObject)BA01.get(0)).getValue("bank_name"));%>" size='30' maxlength='30'>  		                    
                          </td>
                          </tr>
					                               
                          <tr class="sbody">
						  <td width='15%' align='left' bgcolor='#D8EFEE'>檢查評等</td>
						  <% List exGrade = DBManager.QueryDB_SQLParam("select cmuse_id, cmuse_name from cdshareno where cmuse_div='021' order by input_order",null,"");%>
						  <td width='85%' colspan=2 bgcolor='e7e7e7'>
                            <select name='EXGRADE'>                            
                            <%for(int i=0;i<exGrade.size();i++){%>
                            <option value="<%=(String)((DataObject)exGrade.get(i)).getValue("cmuse_id")%>"
                            	<%if((BA01 != null && BA01.size() != 0) && ( ((DataObject)BA01.get(0)).getValue("exgrade") != null && ((String)((DataObject)BA01.get(0)).getValue("exgrade")).equals((String)((DataObject)exGrade.get(i)).getValue("cmuse_id")))) out.print("selected");%>
                            ><%=(String)((DataObject)exGrade.get(i)).getValue("cmuse_name")%>
                            </option>                            
                            <%}%>					
                          </tr>
                          <tr class="sbody">
						  <td width='20%' align='left' bgcolor='#D8EFEE'>最近一次檢查日期</td>
						  <td width='80%' colspan=2 bgcolor='e7e7e7'>
                          <input type='hidden' name='LAST_CHK_DATE' value="">
                            <input type='text' name='LAST_CHK_DATE_Y' value="<%=LAST_CHK_DATE_Y%>" size='3' maxlength='3' onblur='CheckYear(this)'>
        						<font color='#000000'>年
        						<select id="hide1" name=LAST_CHK_DATE_M>
        						<option></option>
        						<%
        							for (int j = 1; j <= 12; j++) {
        							if (j < 10){%>
        							<option value=0<%=j%> <%if(LAST_CHK_DATE_M.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>        		
            						<%}else{%>
            						<option value=<%=j%> <%if(LAST_CHK_DATE_M.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select></font><font color='#000000'>月
        						<select id="hide1" name=LAST_CHK_DATE_D>
        						<option></option>
        						<%
        							for (int j = 1; j < 32; j++) {
        							if (j < 10){%>        	
        							<option value=0<%=j%> <%if(LAST_CHK_DATE_D.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>        		
            						<%}else{%>
            						<option value=<%=j%> <%if(LAST_CHK_DATE_D.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select></font><font color='#000000'>日</font>                      
                          		
                        </Table></td>
                    </tr>                 
                    <tr>                  
                <td><div align="right"><jsp:include page="getMaintainUser.jsp?width=560" flush="true" /></div></td>                                              
              </tr>
              
              <tr> 
                <td><div align="center"> 
                    <table width="243" border="0" cellpadding="1" cellspacing="1">
                      <tr>                             
				        <%if(act.equals("new")){%>       
                        <td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Insert');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_confirmb.gif',1)"><img src="images/bt_confirm.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a></div></td>
         				<%}%>
         				<%if(act.equals("Edit")){%>         				
				        <td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Update');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_updateb.gif',1)"><img src="images/bt_update.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a></div></td>
				        <td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Delete');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image103','','images/bt_deleteb.gif',1)"><img src="images/bt_delete.gif" name="Image103" width="66" height="25" border="0" id="Image103"></a></div></td>
						<%}%>				
         				<%if(!act.equals("Query")){%>       
                        <td width="66"> <div align="center"><a href="javascript:AskReset(this.document.forms[0]);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image104','','images/bt_cancelb.gif',1)"><img src="images/bt_cancel.gif" name="Image104" width="66" height="25" border="0" id="Image104"></a></div></td>
		                <%}%>        
                        <td width="80"><div align="center"><a href="javascript:history.back();"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image105" width="80" height="25" border="0" id="Image105"></a></div></td>
                      </tr>
                      </tr>
                    </table>
                  </div></td>
              </tr>                               
      </table></td>
  </tr>
  <tr> 
                <td><table width="560" border="0" cellpadding="1" cellspacing="1" class="sbody">
                    <tr> 
                      <td colspan="2"><font color='#990000'><img src="images/arrow_1.gif" width="28" height="23" align="absmiddle"><font color="#007D7D" size="3">使用說明 
                        : </font></font></td>
                    </tr>
                    <tr> 
                      <td width="16">&nbsp;</td>
                      <td width="500"> <ul>                                            
                          <li>本網頁提供新增金融機構代碼功能。</li>                          
                          <li>金融機構代碼，須填入7碼。</li> 
                          <li>新增時,可直接於空格內輸入資料，按<font color="#666666">【確定】</font>即將本表上的資料於資料庫中建檔。</li>
                          <li>修改時,資料更改完畢後，按<font color="#666666">【修改】</font>即將本表上的資料於資料庫中建檔。</li>                        
                          <li>按<font color="#666666">【取消】</font>即重新輸入資料。</li>                         
                          <li>按<font color="#666666">【回上一頁】則放棄新增金融機構代碼, 回至上個畫面</font>。</li>
                        </ul></td>
                    </tr>
                  </table></td>
              </tr>
              <!--tr> 
                <td><div align="center"><img src="images/line_1.gif" width="600" height="12"></div></td>
              </tr-->
</table>
</form>
</body>
</html>
<%System.out.println("@@TC15_Edit.jsp End..");%>
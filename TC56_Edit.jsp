<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%
	String szbank_type = ( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");		
	String sztbank_no = ( request.getParameter("tbank_no")==null ) ? "" : (String)request.getParameter("tbank_no");		
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");				
		
	System.out.println("TC56_Edit.sztbank_no="+sztbank_no);
	
	List EXWARNIDF = (List)request.getAttribute("EXWARNIDF");		
	String title="異常警訊項目";			
	title =(act.equals("Edit"))?title+"異動維護建檔":title;
	title =(act.equals("new"))?title+"新增維護建檔":title;
	
	//取得TC56的權限
	//Mark for test
	Properties permission = ( session.getAttribute("TC56")==null ) ? new Properties() : (Properties)session.getAttribute("TC56"); 
	if(permission == null){
       System.out.println("TC56_Edit.permission == null");
    }else{
       System.out.println("TC56_Edit.permission.size ="+permission.size());
               
    }
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/TC56.js"></script>
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
                    <tr> 
                      <td><table width=560 border=1 align=center cellpadding="1" cellspacing="1" bordercolor="#76C657">
                    <tr class="sbody">
						<td width='15%' align='left' bgcolor='#BDDE9C'>異常警訊項目</td>
						<td width='85%' colspan=2 bgcolor='EBF4E1'>
                          	<%if(act.equals("Edit")){%>
                          		<input type='hidden' name='ITEM_ID' value="<%if(EXWARNIDF != null && EXWARNIDF.size() != 0 && ((DataObject)EXWARNIDF.get(0)).getValue("item_id") != null ) out.print((String)((DataObject)EXWARNIDF.get(0)).getValue("item_id"));%>">
  		                     	<%if(EXWARNIDF != null && EXWARNIDF.size() != 0 && ((DataObject)EXWARNIDF.get(0)).getValue("item_id") != null ) out.print((String)((DataObject)EXWARNIDF.get(0)).getValue("item_id"));%>
                            <%}else{%>
                            	<input type='text' name='ITEM_ID' value="<%if(EXWARNIDF != null && EXWARNIDF.size() != 0 && ((DataObject)EXWARNIDF.get(0)).getValue("item_id") != null ) out.print((String)((DataObject)EXWARNIDF.get(0)).getValue("item_id"));%>" size='4' maxlength='4'>
                            <%}%>
                          </td>
                          </tr>     
					      
					      <tr class="sbody">
						  <td width='15%' align='left' bgcolor='#BDDE9C'>代碼名稱</td>						  
						  <td width='85%' colspan=2 bgcolor='EBF4E1'>
  		                    <input type='text' name='ITEM_NAME' value="<%if(EXWARNIDF != null && EXWARNIDF.size() != 0 && ((DataObject)EXWARNIDF.get(0)).getValue("item_id") != null ) out.print((String)((DataObject)EXWARNIDF.get(0)).getValue("item_name"));%>" size='50' maxlength='100'>                                                                              						                              
                          </td>
                          </tr>                             
                          
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
				        	<%if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){ %> 
                        		<td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Insert');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_confirmb.gif',1)"><img src="images/bt_confirm.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a></div></td>
         					<%}%>
         				<%}%>
         				<%if(act.equals("Edit")){%>
         					<%if(permission != null && permission.get("U") != null && permission.get("U").equals("Y")){ %>         				
				        		<td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Update');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_updateb.gif',1)"><img src="images/bt_update.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a></div></td>
				        	 <%}%>
				        	<%if(permission != null && permission.get("D") != null && permission.get("D").equals("Y")){ %>
				        		<td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Delete');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image103','','images/bt_deleteb.gif',1)"><img src="images/bt_delete.gif" name="Image103" width="66" height="25" border="0" id="Image103"></a></div></td>
							<%}%>
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
                      <td width="520"> <ul>                                            
                          <li>本網頁提供新增異常警訊項目功能。</li>                          
                          <li>異常警訊項目，須填入4碼。</li>      
                          <li>新增時,可直接於空格內輸入資料，按<font color="#666666">【確定】</font>即將本表上的資料於資料庫中建檔。</li>
                          <li>修改時,資料更改完畢後，按<font color="#666666">【修改】</font>即將本表上的資料於資料庫中建檔。</li>                        
                          <li>按<font color="#666666">【取消】</font>即重新輸入資料。</li>                         
                          <li>按<font color="#666666">【回上一頁】</font>則放棄新增異常警訊項目, 回至上個畫面。</li>
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

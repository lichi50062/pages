<%
//105.9.6 create by 2968
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.LinkedList" %>

<%
    //String bank_type = ( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");		
	
	//System.out.println("bank_type="+bank_type);	
	
	//貸款種類清單===============================================================================================
	String sqlCmd = "";
	List paramList = new ArrayList();
	//String muser_id = ( session.getAttribute("muser_id")==null ) ? "" : (String)session.getAttribute("muser_id");		
	sqlCmd = " select loan_item,loan_item_name from loan_item order by loan_item ";   
    List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");		   
    String[][] Report_List = new String[dbData.size()][2];
    if(dbData != null && dbData.size() != 0){		   
       for(int i=0;i<dbData.size();i++){
           Report_List[i][0]=(String)((DataObject)dbData.get(i)).getValue("loan_item");
	       Report_List[i][1]=(String)((DataObject)dbData.get(i)).getValue("loan_item_name");
       }
	}	   		       
	
	//String bank_type = ( request.getParameter("bank_type")==null ) ? "1" : (String)request.getParameter("bank_type");			
	
	//String[][] DLId_List = ListArray.getUpListArray(bank_type);//可申報的檔案類型
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/TM001W.js"></script>
<script language="javascript" event="onresize" for="window"></script>

<html>
<head>
<title>協助措施規劃內容基本資料維護作業</title>
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
<form name=frmWMFileEdit method=post>
<input type="hidden" name="act" value="Status">  
<table width="640" border="0" align="left" cellpadding="0" cellspacing="1" bgcolor="#FFFFFF">
  		<tr> 
   		 <td><img src="images/space_1.gif" width="12" height="12"></td>
  		</tr>
        <tr> 
          <td bgcolor="#FFFFFF">
			<table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td><table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="130"><img src="images/banner_bg1.gif" width="130" height="17"></td>
                      <td width="340"><font color='#000000' size=4><b> 
                        <center>協助措施規劃內容基本資料維護作業 </center>
                        </b></font> </td>
                      <td width="130"><img src="images/banner_bg1.gif" width="130" height="17"></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td><img src="images/space_1.gif" width="12" height="12"></td>
              </tr>
              <tr> 
                <td><table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
               
                    <tr> 
                      <div align="right"><jsp:include page="getLoginUser.jsp" flush="true" /></div> 
                    </tr>
                    <tr> 
                      <td>&nbsp;</td> 
                    </tr>
                    <tr> 
                      <td><table width=600 border=1 align=center cellpadding="1" cellspacing="1"  bordercolor="#76C657">
                          <tr align=left bgcolor="#BFDFAE">                           
                          <td width=10% class="sbody">序號</td>
						  <td width=90% class="sbody">貸款種類別</td>
                          </tr>
                        </Table></td>
                    </tr>
                  
                    <tr> 
                      <td><table width='600' border=1 align='center' cellpadding="1" cellspacing="1" bordercolor="#76C657">                   
                          <%
                          String bgcolor="#FFFFCC"; 
                          if(dbData==null || dbData.size() == 0){%>
                        	<tr class="sbody" bgcolor="<%=bgcolor%>">                   			   
                  			   <td colspan=10 align=center >無資料可供查詢</td><tr>
                  			<tr> 
                         <%}else{
	                           for(int i = 0; i < Report_List.length; i++){
	                        	   bgcolor = (i % 2 == 0)?"#EBF4E1":"#FFFFCC";
	                           %>
							   <tr class="sbody" bgcolor="<%=bgcolor%>"> 
								<td width=10% ><%=i+1 %></td>	   
								<td width=90% ><a href="javascript:doSubmitItem(this.document.forms[0],'<%=Report_List[i][0]%>','<%=Report_List[i][1]%>');"><%=Report_List[i][1]%></a></td>	   	
	    						</tr>    
	    					   <%}%>	  
    					  <%}%>                                     
            			</table>
            		 </td>
        </tr>        
      </table></td>
  </tr>
</table>
</form>
</body>
</html>

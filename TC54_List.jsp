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
	
	System.out.println("@@TC54_List.jsp Start...");
	System.out.println("TC54_List.sztbank_no="+sztbank_no);	
	
	List EXFAULTFList = (List)request.getAttribute("EXFAULTFList");		
	if(EXFAULTFList == null){
	   System.out.println("EXFAULTFList == null");
	}else{
	   System.out.println("EXFAULTFList.size()="+EXFAULTFList.size());
	}
	
	System.out.println("szbank_type="+szbank_type);
	System.out.println("szbank_no="+sztbank_no);
	
	//取得TC54的權限
	Properties permission = ( session.getAttribute("TC54")==null ) ? new Properties() : (Properties)session.getAttribute("TC54"); 
	if(permission == null){
       System.out.println("TC54_List.permission == null");
    }else{
       System.out.println("TC54_List.permission.size ="+permission.size());               
    }
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/TC54.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<title> 檢查意見代碼維護 </title>
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
		  <table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td><table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="150"><img src="images/banner_bg1.gif" width="150" height="17"></td>
                      <td width="300"><font color='#000000' size=4><b> 
                        <center> 檢查意見代碼維護 </center>
                        </b></font> </td>
                      <td width="150"><img src="images/banner_bg1.gif" width="150" height="17"></td>
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
                    <table width=600 border=1 align=center cellpadding="1" cellspacing="1" bordercolor="#76C657">               
					<tr class="sbody">
						<td width='20%' align='left' bgcolor='#BDDE9C'>檢查意見代碼</td>						  
						<td width='80%' colspan=2 bgcolor='EBF4E1'>
					  		<input type='text' name='FAULT_ID' value="" size='4' maxlength='4' >
					  		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <%if(permission != null && permission.get("Q") != null && permission.get("Q").equals("Y")){ %>
                            	<a href="javascript:doSubmit(this.document.forms[0],'Qry');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_queryb.gif',1)"><img src="images/bt_query.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a>
                            <%}%>
                            <%if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){ %>
                            	<a href="javascript:doSubmit(this.document.forms[0],'new');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_addb.gif',1)"><img src="images/bt_add.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a>
                            <%}%>
                        </td>    
                    </tr>
                    <tr class="sbody">
						<td width='20%' align='left' bgcolor='#BDDE9C'>代碼名稱</td>						  
						<td width='80%' colspan=2 bgcolor='EBF4E1'>
					  		<input type='text' name='FAULT_NAME' value="" size='50' maxlength='100' ></td>
                    </tr>
                    </table>
                      <tr><td><table><tr><br></tr></table></td></tr>  
                      
                    <tr> 
                      	<td><table width=600 border=1 align=center cellpadding="1" cellspacing="1" bordercolor="#76C657">                      
                      		<%
                      		String tmpbank_type="";                      
                      		int i = 0;      
                      		String bgcolor="#FFFFCC";       
                      		if(EXFAULTFList != null){ %>
                      		 	<tr class="sbody" bgcolor="#BFDFAE">
                      		    	<td width="10%">&nbsp;</td>           
                      		    	<td width="15%">檢查意見代碼</td>
                      		    	<td width="75%">代碼名稱</td>
								</tr>   
                   		    <%
                   		    if(EXFAULTFList.size() == 0){%>
                   			   	<tr class="sbody" bgcolor="<%=bgcolor%>">
                   			   		<td colspan=11 align=center>無資料可供查詢</td>
                   			   	<tr>
                   			<%}
                    			while(i < EXFAULTFList.size()){ 
                    		      	bgcolor = (i % 2 == 0)?"#EBF4E1":"#FFFFCC";	                    		      
                      		%>                         	  
                          		<tr class="sbody" bgcolor="<%=bgcolor%>">
                            		<td width="10%"><%=i+1%></td>           
            						<td width="15%"><a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(String)((DataObject)EXFAULTFList.get(i)).getValue("fault_id")%>');">
            							<%if( ((DataObject)EXFAULTFList.get(i)).getValue("fault_id") != null ){
                    		    			out.print((String)((DataObject)EXFAULTFList.get(i)).getValue("fault_id")); 
                    		  			}%></td>
                    		  		<td width="75%"><a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(String)((DataObject)EXFAULTFList.get(i)).getValue("fault_id")%>');">
                    					<%if( ((DataObject)EXFAULTFList.get(i)).getValue("fault_name") != null ){
                    						out.print((String)((DataObject)EXFAULTFList.get(i)).getValue("fault_name"));
                    					}%> </td>
   					      		</tr> 
					      <%
                  			   i++;
	                  		   }//end of while
	                  		}//end of if
                  			%>            
					      </table>      
                      </td>    
                      </tr>
                                  
      </table></td>
  </tr> 
</table>
</form>
</body>
</html>
<%System.out.println("@@TC54_List.jsp End..");%>
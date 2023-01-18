<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%
	String bank_no = ( request.getParameter("bank_no")==null ) ? "" : (String)request.getParameter("bank_no");		
	String subdep_id = ( request.getParameter("subdep_id")==null ) ? "" : (String)request.getParameter("subdep_id");
	String muser_id = ( request.getParameter("muser_id")==null ) ? "" : (String)request.getParameter("muser_id");
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");				
	
	System.out.println("@@TC51_List.jsp Start...");
	System.out.println("bank_no="+bank_no);
	System.out.println("subdep_id="+subdep_id);
	System.out.println("muser_id="+muser_id);
	
	List EXPERSONFList = (List)request.getAttribute("EXPERSONFList");		
	if(EXPERSONFList == null){
	   System.out.println("EXPERSONFList == null");
	}else{
	   System.out.println("EXPERSONFList.size()="+EXPERSONFList.size());
	}
	
	//取得TC51的權限
	Properties permission = ( session.getAttribute("TC51")==null ) ? new Properties() : (Properties)session.getAttribute("TC51"); 
	if(permission == null){
       System.out.println("TC51_List.permission == null");
    }else{
       System.out.println("TC51_List.permission.size ="+permission.size());               
    }
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/TC51.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<title> 檢查人員專長維護 </title>
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
                        <center> 檢查人員專長維護 </center>
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
						<td width='15%' align='left' bgcolor='#BDDE9C'>組室代號</td>	
						<% List bank_no_list = DBManager.QueryDB_SQLParam("select bank_no,bank_name from ba01 where bank_type='2' and bank_kind = '1' and pbank_no = 'BOAF000' order by bank_no",null,"");%>					  
						<td width='85%' colspan=2 bgcolor='EBF4E1'>
							<select name='BANK_NO'>
								<option value="">全部</option>
					  			<%for(int i=0;i<bank_no_list.size();i++){%>
                            	<option value="<%=(String)((DataObject)bank_no_list.get(i)).getValue("bank_no")%>"
                            		<%if( ((DataObject)bank_no_list.get(i)).getValue("bank_no") != null &&  (bank_no.equals((String)((DataObject)bank_no_list.get(i)).getValue("bank_no")))) out.print("selected");%>
                            	>
                            	<%=(String)((DataObject)bank_no_list.get(i)).getValue("bank_name")%></option>                            
                            	<%}%>
                            </select>
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
						<td width='15%' align='left' bgcolor='#BDDE9C'>科別代號</td>
						<% List subdep_id_list = DBManager.QueryDB_SQLParam("select cmuse_id,cmuse_name from cdshareno where cmuse_div='010' order by input_order",null,"");%>
						<td width='85%' colspan=2 bgcolor='EBF4E1'>
					  		<select name='SUBDEP_ID' onchange="javascript:getData(this.document.forms[0],'<%=act%>','subdep_id');">
                            	<option value="">全部</option>
                            	<%for(int i=0;i<subdep_id_list.size();i++){%>
                            	<option value="<%=(String)((DataObject)subdep_id_list.get(i)).getValue("cmuse_id")%>"
                            		<%if(subdep_id.equals("") && ((String)((DataObject)subdep_id_list.get(i)).getValue("cmuse_id")).equals("")) out.print("selected");%>
                            		<%if(((DataObject)subdep_id_list.get(i)).getValue("cmuse_id") != null && (subdep_id.equals((String)((DataObject)subdep_id_list.get(i)).getValue("cmuse_id")))) out.print("selected");%>
                               	>
                            	<%if(((DataObject)subdep_id_list.get(i)).getValue("cmuse_name") != null) out.print((String)((DataObject)subdep_id_list.get(i)).getValue("cmuse_name"));%>                            
                            	</option>                            
                            	<%}%>
                            </select>
                        </td>    
                    </tr>
                    <tr class="sbody">
						<td width='15%' align='left' bgcolor='#BDDE9C'>員工代碼</td>	
						<% 	List muser_id_list = (List)request.getAttribute("muser_id");
							System.out.println("TC51_List.getAttribute.size="+muser_id_list.size());
						%>
						<td width='85%' colspan=2 bgcolor='EBF4E1'>
					  		<select name='MUSER_ID'>
					  			<option value="">全部</option>
                            	<%for(int i=0;i<muser_id_list.size();i++){%>
                            	<option value="<%=(String)((DataObject)muser_id_list.get(i)).getValue("muser_id")%>"
                            		<%if(((DataObject)muser_id_list.get(i)).getValue("cmuse_id") != null && (muser_id.equals((String)((DataObject)muser_id_list.get(i)).getValue("muser_id")))) out.print("selected");%>
                            	>
                            		<%if(((DataObject)muser_id_list.get(i)).getValue("muser_id") != null) out.print((String)((DataObject)muser_id_list.get(i)).getValue("muser_id"));%>
                            		&nbsp;
                            		<%if(((DataObject)muser_id_list.get(i)).getValue("muser_name") != null) out.print((String)((DataObject)muser_id_list.get(i)).getValue("muser_name"));%>                            
                            	</option>                            
                            	<%}%>
                            </select>
                        </td>    
                    </tr>

                    </table>
                      <tr><td><table><tr><br></tr></table></td></tr>
                    <tr> 
                      	<td><table width=600 border=1 align=center cellpadding="1" cellspacing="1" bordercolor="#76C657">                      
                      		<%
                      		String tmpbank_type="";                      
                      		int i = 0;      
                      		String bgcolor="#FFFFCC";       
                      		if(EXPERSONFList != null){ %>
                      		 	<tr class="sbody" bgcolor="#BFDFAE">
                      		    	<td width="5%">&nbsp;</td>
                      		    	<td width="20%">組室名稱</td>
                      		    	<td width="10%">科別</td>
                      		    	<td width="30%">檢查人員</td>
                      		    	<td width="90%">專長說明</td>
								</tr>   
                   		    <%
                   		    if(EXPERSONFList.size() == 0){%>
                   			   	<tr class="sbody" bgcolor="<%=bgcolor%>">
                   			   		<td colspan=11 align=center>無資料可供查詢</td>
                   			   	<tr>
                   			<%}
                    			while(i < EXPERSONFList.size()){ 
                    		      	bgcolor = (i % 2 == 0)?"#EBF4E1":"#FFFFCC";	                    		      
                      		%>                         	  
                          		<tr class="sbody" bgcolor="<%=bgcolor%>">
                            		<td width="5%"><%=i+1%></td>
                            		<td width="20%"><a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(String)((DataObject)EXPERSONFList.get(i)).getValue("bank_no")%>','<%=(String)((DataObject)EXPERSONFList.get(i)).getValue("subdep_id")%>','<%=(String)((DataObject)EXPERSONFList.get(i)).getValue("muser_id")%>','<%=(String)((DataObject)EXPERSONFList.get(i)).getValue("expertno_id")%>');">
            							<%if( ((DataObject)EXPERSONFList.get(i)).getValue("bank_name") != null ){
                    		    			out.print((String)((DataObject)EXPERSONFList.get(i)).getValue("bank_name")); 
                    		  			}%></td>
                    		  		<td width="10%"><a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(String)((DataObject)EXPERSONFList.get(i)).getValue("bank_no")%>','<%=(String)((DataObject)EXPERSONFList.get(i)).getValue("subdep_id")%>','<%=(String)((DataObject)EXPERSONFList.get(i)).getValue("muser_id")%>','<%=(String)((DataObject)EXPERSONFList.get(i)).getValue("expertno_id")%>');">
            							<%if( ((DataObject)EXPERSONFList.get(i)).getValue("cmuse_name") != null ){
                    		    			out.print((String)((DataObject)EXPERSONFList.get(i)).getValue("cmuse_name")); 
                    		  			}%></td>
                            		<td width="30%"><a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(String)((DataObject)EXPERSONFList.get(i)).getValue("bank_no")%>','<%=(String)((DataObject)EXPERSONFList.get(i)).getValue("subdep_id")%>','<%=(String)((DataObject)EXPERSONFList.get(i)).getValue("muser_id")%>','<%=(String)((DataObject)EXPERSONFList.get(i)).getValue("expertno_id")%>');">
            							<%if( ((DataObject)EXPERSONFList.get(i)).getValue("muser_id") != null ){
                    		    			out.print((String)((DataObject)EXPERSONFList.get(i)).getValue("muser_id"));%>&nbsp;
                    		    			<%out.print((String)((DataObject)EXPERSONFList.get(i)).getValue("muser_name"));
                    		  			}%></td>           
            						<td width="90%"><a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(String)((DataObject)EXPERSONFList.get(i)).getValue("bank_no")%>','<%=(String)((DataObject)EXPERSONFList.get(i)).getValue("subdep_id")%>','<%=(String)((DataObject)EXPERSONFList.get(i)).getValue("muser_id")%>','<%=(String)((DataObject)EXPERSONFList.get(i)).getValue("expertno_id")%>');">
            							<%if( ((DataObject)EXPERSONFList.get(i)).getValue("expertno_id") != null ){
                    		    			out.print((String)((DataObject)EXPERSONFList.get(i)).getValue("expertno_id"));%>&nbsp;
                    		    			<%out.print((String)((DataObject)EXPERSONFList.get(i)).getValue("expertno_name")); 
                    		  			}
                    		  			while(i < EXPERSONFList.size()-1){
                    		  			    if(((DataObject)EXPERSONFList.get(i)).getValue("muser_id").equals(((DataObject)EXPERSONFList.get(i+1)).getValue("muser_id"))) {
                    		  			        ++i;
                    		  			        %>
                    		  			        <br><a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(String)((DataObject)EXPERSONFList.get(i)).getValue("bank_no")%>','<%=(String)((DataObject)EXPERSONFList.get(i)).getValue("subdep_id")%>','<%=(String)((DataObject)EXPERSONFList.get(i)).getValue("muser_id")%>','<%=(String)((DataObject)EXPERSONFList.get(i)).getValue("expertno_id")%>');">
            							     <%if( ((DataObject)EXPERSONFList.get(i)).getValue("expertno_id") != null ){
                    		    			out.print((String)((DataObject)EXPERSONFList.get(i)).getValue("expertno_id"));%>&nbsp;
                    		    			<%out.print((String)((DataObject)EXPERSONFList.get(i)).getValue("expertno_name")); 
                    		  			       } 
                    		  			    } else {
                    		  			       break;
                    		  			    }
                    		  			}
                    		  			  %>



                                    </td>
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
<%System.out.println("@@TC51_List.jsp End..");%>
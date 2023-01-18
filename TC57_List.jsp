<%
//95.11.24 create by 2495
//95.12.15 完成檢查追蹤管理維護作業 by 2295
//99.06.02 fix sql injection by 2808
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>

<%
	String bank_no = ( request.getParameter("bank_no")==null ) ? "" : (String)request.getParameter("bank_no");		
	String subdep_id = ( request.getParameter("subdep_id")==null ) ? "" : (String)request.getParameter("subdep_id");
	String muser_id = ( request.getParameter("muser_id")==null ) ? "" : (String)request.getParameter("muser_id");
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");				
	
	System.out.println("TC57_List.jsp.bank_no="+bank_no);
	System.out.println("TC57_List.jsp.subdep_id="+subdep_id);
	System.out.println("TC57_List.jsp.muser_id="+muser_id);
	System.out.println("TC57_List.jsp.act="+act);
	Calendar now = Calendar.getInstance();
   	String YEAR  = String.valueOf(now.get(Calendar.YEAR)-1911);
   	String u_year = "99" ;
   	String cd01Table = "cd01_99" ;
   	if(Integer.parseInt(YEAR) > 99) {
   		u_year = "100" ;
   		cd01Table = "cd01" ;
   	}
	List wtt08List = (List)request.getAttribute("wtt08List");		
	
	if(wtt08List == null){
	   System.out.println("request.wtt08List == null");
	   wtt08List = (List)session.getAttribute("wtt08List");			   
	   if(wtt08List == null){
	      System.out.println("session.wtt08List == null");
	   }else{
	      System.out.println("session.wtt08List.size()="+wtt08List.size());
	   }   
	}else{
	   System.out.println("request.wtt08List.size()="+wtt08List.size());
	}
	
	
	//95.12.11 add 員工代碼=======================================================================================    
	String sqlCmd = " select bank_no,subdep_id,muser_id,muser_name from wtt01 " 
				  + " where bank_type ='2'"
				  + " order by muser_id ";
    List muser_id_data = DBManager.QueryDB_SQLParam(sqlCmd,null,""); 				  
	// XML Ducument for 員工代碼 begin
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"MuserIDXML\">");    
    out.println("<datalist>"); 		      
 	if(muser_id_data != null){
       for(int i=0;i< muser_id_data.size(); i++) {
           DataObject bean =(DataObject)muser_id_data.get(i);
           out.println("<data>");                              
           out.println("<bank_no>"+bean.getValue("bank_no")+"</bank_no>");//組室代號           
           out.println("<subdep_id>"+bean.getValue("subdep_id")+"</subdep_id>");//科別代號
           out.println("<muser_id>"+bean.getValue("muser_id")+"</muser_id>");//員工代碼
           out.println("<muser_name>"+bean.getValue("muser_id")+bean.getValue("muser_name")+"</muser_name>");//代碼+名稱
           out.println("</data>");           
       }       
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 員工代碼 end 	                         				  
	
	//取得TC57的權限
	Properties permission = ( session.getAttribute("TC57")==null ) ? new Properties() : (Properties)session.getAttribute("TC57"); 
	if(permission == null){
       System.out.println("TC57_List.permission == null");
    }else{
       System.out.println("TC57_List.permission.size ="+permission.size());               
    }
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/TC57.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<title> 檢查追蹤管理系統權限 </title>
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
<%if(wtt08List != null && wtt08List.size() != 0){%>
<input type="hidden" name="row" value="<%=wtt08List.size()+1%>">   
<%}%>
<table width="600" border="0" align="left" cellpadding="0" cellspacing="1" bgcolor="#FFFFFF">
  		<tr> 
   		 <td><img src="images/space_1.gif" width="12" height="12"></td>
  		</tr>

        <tr> 
          <td bgcolor="#FFFFFF">
		  <table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
             <tr> 
                <td><table width="825" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="180"><img src="images/banner_bg1.gif" width="180" height="17"></td>
                      <td width="466"><font color='#000000' size=4><b><center>檢查追蹤管理系統權限管理</center></b></font> </td>
                      <td width="180"><img src="images/banner_bg1.gif" width="180" height="17"></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
              <tr> 
                <td><img src="images/space_1.gif" width="12" height="12"></td>
              </tr>
              <tr> 
                <td><table width="825" border="0" align="center" cellpadding="0" cellspacing="0">
               
                    <tr> 
                      <div align="right"><jsp:include page="getLoginUser.jsp" flush="true" /></div> 
                    </tr>    
                    <tr> 
                    <table width=825 border=1 align=center cellpadding="1" cellspacing="1" bordercolor="#76C657">               
					<tr class="sbody">
						<td width='15%' align='left' bgcolor='#BDDE9C'>組室代號</td>	
						<%  StringBuffer sql = new StringBuffer() ;
						    List paramList = new ArrayList() ;
						    sql.append("select bank_no,bank_name from ba01 where m_year=? and bank_type=?  and bank_kind = ? and pbank_no = ? order by bank_no") ;
						    paramList.add(u_year) ;
						    paramList.add("2") ;
						    paramList.add("1") ;
						    paramList.add("BOAF000") ;
							List bank_no_list = DBManager.QueryDB_SQLParam(sql.toString(),paramList,"");%>					  
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
                            	<a href="javascript:doSubmit(this.document.forms[0],'Qry','','','');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_queryb.gif',1)"><img src="images/bt_query.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a>
                            <%}%>
                            <%if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){ %>
                            	<a href="javascript:doSubmit(this.document.forms[0],'new','','','');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_addb.gif',1)"><img src="images/bt_add.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a>
                            <%}%>
                            <%if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){ %>
                            	<a href="javascript:doSubmit(this.document.forms[0],'Copy','','','');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image103','','images/bt_loaduserb.gif',1)"><img src="images/bt_loaduser.gif" name="Image103" width="80" height="25" border="0" id="Image103"></a>
                            <%}%>
                            <%if(permission != null && permission.get("D") != null && permission.get("D").equals("Y")){ %>
                            	<a href="javascript:doSubmit(this.document.forms[0],'Delete','','','');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image104','','images/bt_deleteb.gif',1)"><img src="images/bt_delete.gif" name="Image104" width="66" height="25" border="0" id="Image104"></a>
                            <%}%>
                        </td>    
                    </tr>
                    <tr class="sbody">
						<td width='15%' align='left' bgcolor='#BDDE9C'>科別代號</td>
						<% List subdep_id_list = DBManager.QueryDB_SQLParam("select cmuse_id,cmuse_name from cdshareno where cmuse_div='010' order by input_order",null,"");%>
						<td width='85%' colspan=2 bgcolor='EBF4E1'>
					  		<select name='SUBDEP_ID' onchange="changeOption_MuserID(this.document.forms[0],'<%=act%>');">
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
						<td width='85%' colspan=2 bgcolor='EBF4E1'>
					  		<select name='MUSER_ID'></select>
                        </td>    
                    </tr>

                    </table>
                      <tr><td><table><tr><br></tr></table></td></tr>
                    <tr> 
                      	<td><table width=825 border=1 align=center cellpadding="1" cellspacing="1" bordercolor="#76C657">                      
                      	      <tr class="sbody" bgcolor="#BFDFAE">
                      		   	<td width="9">　</td>
                      		    <td width="20"><p align="center">&nbsp;參照</p></td>
                      		    <td width="96">組室名稱</td>
                      		    <td width="34">科別</td>
                      		    <td width="71">檢查人員</td>
                      		    <td width="94">金融機構類別</td>
                      		    <td width="51">縣市別</td>
                      		    <td width="197">總機構單位</td>
                      		    <td width="210">受檢單位</td>
							   </tr>   
                      		<%                      		
                      		int i = 0,j =0;      
                      		String bgcolor="#FFFFCC";                         		
                   		    if(wtt08List == null || wtt08List.size() == 0){%>
                   			   	<tr class="sbody" bgcolor="<%=bgcolor%>">
                   			   		<td colspan=9 align=center>無資料可供查詢</td>
                   			   	<tr>
                   			<%}else{
                   			DataObject bean = null;                   			       			                   			
                   			List bank_type_List = null;
                      		List hsien_id_List = null;
                      		List tbank_no_List = null;
                      		List examine_List = null; 
                   			while(i < wtt08List.size()){                
                   			     muser_id="";                   			   		  
                   				 bgcolor = (i % 2 == 0)?"#EBF4E1":"#FFFFCC";	                               			
                    		     bean = (DataObject)wtt08List.get(i);      		                          		    
                    		     if( bean.getValue("muser_id") != null ){
                    		         muser_id = (String)bean.getValue("muser_id");
                    		     }    
                      		%>  
                      			 <tr class="sbody" bgcolor="<%=bgcolor%>">
                          		 <td width="9"><%=i+1%></td>
                      		     <td width="20"><input type="checkbox" name="isModify_<%=(i+1)%>" value="<%=(String)bean.getValue("muser_id")%>"></td>
                      		     <td width="96"><a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(String)bean.getValue("bank_no")%>','<%=(String)bean.getValue("subdep_id")%>','<%=(String)bean.getValue("muser_id")%>');">
            									<%if( bean.getValue("bank_name") != null ){ out.print((String)bean.getValue("bank_name")); } else {out.print("&nbsp;");}%>
           						 </td>
                      		     <td width="34"><a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(String)bean.getValue("bank_no")%>','<%=(String)bean.getValue("subdep_id")%>','<%=(String)bean.getValue("muser_id")%>');">
            									<%if( bean.getValue("subdep_id_name") != null ){ out.print((String)bean.getValue("subdep_id_name")); } else {out.print("&nbsp;");}%>
            					 </td>
                      		     <td width="71"><a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(String)bean.getValue("bank_no")%>','<%=(String)bean.getValue("subdep_id")%>','<%=(String)bean.getValue("muser_id")%>');">
            									<%if( bean.getValue("muser_id") != null ){ out.print((String)bean.getValue("muser_id")); }%>                      		     
            									<%if( bean.getValue("muser_name") != null ){ out.print((String)bean.getValue("muser_name")); }%>                      		     
                      		     </td>
                      		     <td width="94"><a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(String)bean.getValue("bank_no")%>','<%=(String)bean.getValue("subdep_id")%>','<%=(String)bean.getValue("muser_id")%>');">
                      		     <%
                      		     sql.setLength(0) ;
                      		     paramList.clear() ;
                      		     sql.append( " select distinct bank_type,bank_type_name from"
									    + " (select wtt08.muser_id,"
       									+ " wtt08.bank_type,bank_type_data.cmuse_name as bank_type_name"
										+ " from wtt08 left join (select cmuse_id,cmuse_name "
	       			   					+ " 					  from cdshareno "
					   					+ " 					  where cmuse_div=?"
					   					+ " order by input_order)bank_type_data on bank_type_data.cmuse_id = wtt08.bank_type"
										+ " where wtt08.muser_id in (?)"     		   		    
								        + " order by wtt08.bank_type) where muser_id = ? ");
                      		     paramList.add("001") ;
                      		     paramList.add(muser_id) ;
                      		     paramList.add(muser_id) ;
								 bank_type_List = DBManager.QueryDB_SQLParam(sql.toString(),paramList,"");
								 for( j=0;j<bank_type_List.size();j++){     
								     if(((DataObject)bank_type_List.get(j)).getValue("bank_type") != null ){
                    		    	    //out.print((String)((DataObject)bank_type_List.get(j)).getValue("bank_type")); 
                    		    	    out.print((String)((DataObject)bank_type_List.get(j)).getValue("bank_type_name")+"<br>"); 
								     }	
                      		     }%>
            					 </td>
            					 
                      		     <td width="51"><a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(String)bean.getValue("bank_no")%>','<%=(String)bean.getValue("subdep_id")%>','<%=(String)bean.getValue("muser_id")%>');">
                      		     <%
                      		     sql.setLength(0) ;
                      		     paramList.clear() ;
                      		     
                      		     sql.append(" select distinct hsien_id,hsien_name from"
										+ " (select wtt08.muser_id,wtt08.hsien_id,cd01.HSIEN_NAME"
										+ " from wtt08 left join ").append(cd01Table).append(" cd01 on wtt08.hsien_id = cd01.HSIEN_ID " 	
										+ " where wtt08.muser_id in (? )"     		   		    
										+ " and   wtt08.hsien_id <> '-'"
										+ " order by wtt08.muser_id,wtt08.hsien_id)");
                      		     paramList.add(muser_id) ;
 							     hsien_id_List = DBManager.QueryDB_SQLParam(sql.toString(),paramList,"");
								 for(j=0;j<hsien_id_List.size();j++){     
								     if(((DataObject)hsien_id_List.get(j)).getValue("hsien_id") != null ){
                    		    	    //out.print((String)((DataObject)hsien_id_List.get(j)).getValue("hsien_id")); 
                    		    	    out.print((String)((DataObject)hsien_id_List.get(j)).getValue("hsien_name")+"<br>"); 
								     }										
                      		     }
                      		     %>
                      		     </td>
                      		     <td width="197"><a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(String)bean.getValue("bank_no")%>','<%=(String)bean.getValue("subdep_id")%>','<%=(String)bean.getValue("muser_id")%>');">
                      		     <%
                      		     sql.setLength(0) ;
                      		     paramList.clear() ;
                      		     sql.append(" select wtt08.muser_id,"
	   								    + " wtt08.tbank_no,bn01.bank_name as tbank_no_name"
									    + " from wtt08 left join (select * from bn01 where m_year=? )bn01 on bank_no = wtt08.tbank_no"
										+ " where wtt08.muser_id in (?)"
										+ " group by muser_id,tbank_no,bn01.bank_name"     		   		    
										+ " order by wtt08.muser_id,wtt08.tbank_no" );
                      		     paramList.add(u_year)  ;
                      		     paramList.add(muser_id) ;
                      		     
								 tbank_no_List = DBManager.QueryDB_SQLParam(sql.toString(),paramList,"");										
								 for( j=0;j<tbank_no_List.size();j++){     
								     if(((DataObject)tbank_no_List.get(j)).getValue("tbank_no") != null ){
                    		    	    out.print((String)((DataObject)tbank_no_List.get(j)).getValue("tbank_no")+"&nbsp"); 
                    		    	    out.print((String)((DataObject)tbank_no_List.get(j)).getValue("tbank_no_name")+"<br>"); 
								     }			
								 }
            					 %>	
                      		     </td>
                      		     <td width="220"><a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(String)bean.getValue("bank_no")%>','<%=(String)bean.getValue("subdep_id")%>','<%=(String)bean.getValue("muser_id")%>');">
                      		     <%
                      		     sql.setLength(0) ;
                      		     paramList.clear() ;
                      		     sql.append(" select wtt08.muser_id,"
	   									+ " wtt08.examine,ba01.bank_name as examine_name"
										+ " from wtt08 left join (select * from ba01 where m_year=? )ba01 on bank_no = wtt08.examine"
										+ " where wtt08.muser_id in (?)"
										+ " group by wtt08.muser_id,wtt08.examine,ba01.bank_name "		   		    
										+ " order by wtt08.muser_id,wtt08.examine");
                      		     paramList.add(u_year) ;
                      		     paramList.add(muser_id ) ;
								 examine_List = DBManager.QueryDB_SQLParam(sql.toString(),paramList,"");										
								 for( j=0;j<examine_List.size();j++){     
								     if(((DataObject)examine_List.get(j)).getValue("examine") != null ){
                    		    	    out.print((String)((DataObject)examine_List.get(j)).getValue("examine")+"&nbsp"); 
                    		    	    out.print((String)((DataObject)examine_List.get(j)).getValue("examine_name")+"<br>"); 
								     }			
								 }
								 %>
								 </td>
                      		     </tr>         
	                  	   <%i++;
	                  	     }//end of while
	                  		}//end of if having data
                  			%>  
					      </table>      
                      </td>    
                      </tr>
                                  
      </table></td>
  </tr> 
</table>
</form>
<script language="JavaScript" >
<!--
changeOption_MuserID(this.document.forms[0],'<%=act%>');
-->
</script>
</body>
</html>
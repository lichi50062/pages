<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%
	
	//String szbank_type = ( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");		
	//String sztbank_no = ( request.getParameter("tbank_no")==null ) ? "" : (String)request.getParameter("tbank_no");		
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");				
	String bank_no = ( request.getParameter("bank_no")==null ) ? "" : (String)request.getParameter("bank_no");		
	String subdep_id = ( request.getParameter("subdep_id")==null ) ? "" : (String)request.getParameter("subdep_id");
	String muser_id = ( request.getParameter("muser_id")==null ) ? "" : (String)request.getParameter("muser_id");
	String expert_id = ( request.getParameter("expertno_id")==null ) ? "" : (String)request.getParameter("expertno_id");
	
	System.out.println("TC51_Edit.jsp Start..");
	System.out.println("act="+act);
	System.out.println("bank_no="+bank_no);
	System.out.println("subdep_id="+subdep_id);
	System.out.println("muser_id="+muser_id);
	System.out.println("expert_id="+expert_id);
	
	//List muser_id_list = (List)request.getAttribute("muser_id");
	
	//List EXPERSONF = (List)request.getAttribute("EXPERSONF");
	//System.out.println("EXPERSONF.size="+EXPERSONF.size());
	
	String title="檢查人員專長";			
	title =(act.equals("Edit"))?title+"異動維護建檔":title;
	title =(act.equals("new"))?title+"新增維護建檔":title;
	
	//取得TC51的權限
	Properties permission = ( session.getAttribute("TC51")==null ) ? new Properties() : (Properties)session.getAttribute("TC51"); 
	if(permission == null){
       System.out.println("TC51_Edit.permission == null");
    }else{
       System.out.println("TC51_Edit.permission.size ="+permission.size());
               
    }
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/TC51.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<title><%=title%></title>
<link href="css/b51.css" rel="stylesheet" type="text/css">
<script language="javascript" src="js/movesels.js"></script>
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

function addOption(id1, id2, value, text) {
   s1 = document.getElementById(id1);
   s2 = document.getElementById(id2);
   
   var o = document.createElement("OPTION");
   o.text = text;
   o.value = value;
   
   if(s2.length == 0) {
     s1.add(o);
   } else {
     var count=0;
     for(var i=0; i < s2.length; i++) {
       if(s2[i].value == value) {
         count += 1;
       }
     }
     if(count == 0) {
       s1.add(o);
     }
   }
}




//-->
</script>
</head>

<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" leftmargin="0">
<form method=post action='#'>
<input type="hidden" name="act" value="">
<input type="hidden" name="BEF_EXPERT_ID" value=""> 
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
                    </tr>
                    <tr class="sbody">
						<td width='15%' align='left' bgcolor='#BDDE9C'>組室代號</td>
						<td width='85%' colspan=2 bgcolor='EBF4E1'>
							<%// List bank_no_list = DBManager.QueryDB("select bank_no,bank_name from ba01 where bank_type='2' and bank_kind = '1' and pbank_no = 'BOAF000' order by bank_no","");%>
                            <%List bank_no_list = DBManager.QueryDB_SQLParam("Select distinct b.bank_name, a.bank_no from  wtt01 a, ba01 b  where  a.MUSER_I_O = 'I' and a.BANK_TYPE = '2' and a.bank_no = b.bank_no and a.tbank_no = b.pbank_no order by a.bank_no",null,"");%>
							<select name='BANK_NO' onchange="javascript:getData(this.document.forms[0],'<%=act%>','subdep_id');" <%if(act.equals("Edit")) out.print("disabled");%> >
								
                                    <%for(int i=0;i<bank_no_list.size();i++){
									if(act.equals("Edit")){%>
										<option value="<%=(String)((DataObject)bank_no_list.get(i)).getValue("bank_no")%>" <%if(((DataObject)bank_no_list.get(i)).getValue("bank_no") != null && (bank_no.equals((String)((DataObject)bank_no_list.get(i)).getValue("bank_no")))) out.print("selected");%>>
										<%=(String)((DataObject)bank_no_list.get(i)).getValue("bank_name")%></option>
									<%}else{%>
                        			    <option value="<%=(String)((DataObject)bank_no_list.get(i)).getValue("bank_no")%>"
                        			     <%if(((DataObject)bank_no_list.get(i)).getValue("bank_no") != null && (bank_no.equals((String)((DataObject)bank_no_list.get(i)).getValue("bank_no")))) out.print("selected");%> 
                        			    >
                        			    <%=(String)((DataObject)bank_no_list.get(i)).getValue("bank_name")%></option>                            
                        			<%}%>
                        		<%}%>
                        	</select>
                        </td>
                    </tr>
                    <tr class="sbody">
						<td width='15%' align='left' bgcolor='#BDDE9C'>科別代號</td>
						<td width='85%' colspan=2 bgcolor='EBF4E1'>
							<% // List subdep_id_list = DBManager.QueryDB("select cmuse_id,cmuse_name from cdshareno where cmuse_div='010' order by input_order","");%>
                            <%List subdep_id_list = DBManager.QueryDB_SQLParam("Select distinct a.subdep_id as cmuse_id ,  c.cmuse_name from  wtt01 a, cdshareno c where  a.MUSER_I_O  = 'I' and a.BANK_TYPE = '2' and a.bank_no = '"+bank_no+"'  and (a.SUBDEP_ID  =  c. cmuse_id and c.cmuse_div = '010' ) order by  a.SUBDEP_ID",null,"");%>
							<select name='SUBDEP_ID' <%if(act.equals("Edit")) out.print("disabled");%> onchange="javascript:getData(this.document.forms[0],'<%=act%>','subdep_id');">
								
                                   <%for(int i=0;i<subdep_id_list.size();i++){
									if(act.equals("Edit")){%>
										<option value="<%((DataObject)subdep_id_list.get(i)).getValue("cmuse_id");%>" <%if(((DataObject)subdep_id_list.get(i)).getValue("cmuse_id") != null && (subdep_id.equals((String)((DataObject)subdep_id_list.get(i)).getValue("cmuse_id")))) out.print("selected");%>>
										<%if(((DataObject)subdep_id_list.get(i)).getValue("cmuse_name") != null) out.print((String)((DataObject)subdep_id_list.get(i)).getValue("cmuse_name"));%>
									<%}else{%>
                            			<option value="<%=(String)((DataObject)subdep_id_list.get(i)).getValue("cmuse_id")%>"
                            				<%if(subdep_id.equals("") && ((String)((DataObject)subdep_id_list.get(i)).getValue("cmuse_id")).equals("9")) out.print("selected");%>
                            				<%if(((DataObject)subdep_id_list.get(i)).getValue("cmuse_id") != null && (subdep_id.equals((String)((DataObject)subdep_id_list.get(i)).getValue("cmuse_id")))) out.print("selected");%>>
                            				<%if(((DataObject)subdep_id_list.get(i)).getValue("cmuse_name") != null) out.print((String)((DataObject)subdep_id_list.get(i)).getValue("cmuse_name"));%>                            
                            			</option>                            
                            		<%}%>
                        		<%}%>
                            </select>
                        </td>
                    </tr>
                    <tr class="sbody">
						<td width='15%' align='left' bgcolor='#BDDE9C'>員工代碼</td>
						<td width='85%' colspan=2 bgcolor='EBF4E1'>
                          	<%if(act.equals("Edit")){
	                          		List EXPERSONF = (List)request.getAttribute("EXPERSONF");
	                          		System.out.println("EXPERSONF.size="+EXPERSONF.size());
	                          		System.out.println("act.equals(\"Edit\")");%>
                          		<input type='hidden' name='MUSER_ID' value="<%=muser_id%>"><%=muser_id%>
  		                     	
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <%if(EXPERSONF != null && EXPERSONF.size() != 0 && ((DataObject)EXPERSONF.get(0)).getValue("user_name") != null ) out.print((String)((DataObject)EXPERSONF.get(0)).getValue("user_name"));%>
                            <%}else{%>
                            	<%System.out.println("act.equals(\"new\")");
                            		List muser_id_list = (List)request.getAttribute("muser_id");            
                            	    System.out.println("TC51_List.getAttribute.size="+muser_id_list.size());
                            	%>  
                            	<select name='MUSER_ID' onchange="javascript:getData(this.document.forms[0],'<%=act%>','');">
					  			<%for(int i=0;i<muser_id_list.size();i++){%>
                            	<option value="<%=(String)((DataObject)muser_id_list.get(i)).getValue("muser_id")%>"
                            	<%if((String)((DataObject)muser_id_list.get(i)).getValue("muser_id") != null && (muser_id.equals((String)((DataObject)muser_id_list.get(i)).getValue("muser_id")))) out.print("selected");%> 
                            	>
                            		<%if(((DataObject)muser_id_list.get(i)).getValue("muser_id") != null) out.print((String)((DataObject)muser_id_list.get(i)).getValue("muser_id"));%>
                            		&nbsp;
                            		<%if(((DataObject)muser_id_list.get(i)).getValue("muser_name") != null) out.print((String)((DataObject)muser_id_list.get(i)).getValue("muser_name"));%>                            
                            	</option>                            
                            	<%}%>
                            </select>
                       			
                            <%}%>
                          </td>
                          </tr>     
					      
					      <tr class="sbody">
					      <td colspan='3' width='100%'>
					      
					      <table width="560" border="0" align="center" cellpadding="1" cellspacing="1" bgcolor="#E9F4E3">
                          <tr class="sbody"> 
                            <td width="45%" align="center">
                            專長選項<BR>
                            <select multiple  size=10 id="EXPERT_ID_SRC" name="EXPERT_ID_SRC" ondblclick="javascript:movesel(this.document.forms[0].EXPERT_ID_SRC,this.document.forms[0].EXPERT_ID);" style="width: 17em">							
							</select>
                            </td>
                            
                            <td width="10%">
                              <table width="100%" border="0" align="center" cellpadding="3" cellspacing="3">
                                <tr> 
                                  <td align="center">                                 
                                    <a href="javascript:movesel(this.document.forms[0].EXPERT_ID_SRC,this.document.forms[0].EXPERT_ID);">
                                    <img src="images/arrow_right.gif" width="24" height="22" border="0"></a>
                                  </td>
                                </tr>
                                <tr> 
                                  <td align="center">                               
                                  <a href="javascript:moveallsel(this.document.forms[0].EXPERT_ID_SRC,this.document.forms[0].EXPERT_ID);">
                                  <img src="images/arrow_rightall.gif" width="24" height="22" border="0"></a>
                                  </td>
                                </tr>
                                <tr> 
                                  <td align="center">
                                                             
                                  <a href="javascript:movesel(this.document.forms[0].EXPERT_ID,this.document.forms[0].EXPERT_ID_SRC);">
                                  <img src="images/arrow_left.gif" width="24" height="22" border="0"></a>
                               
                                  </td>
                                </tr>
                                <tr> 
                                  <td align="center">
                                                              
                                  <a href="javascript:moveallsel(this.document.forms[0].EXPERT_ID,this.document.forms[0].EXPERT_ID_SRC);">
                                  <img src="images/arrow_leftall.gif" width="24" height="22" border="0"></a>
                               
                                  </td>
                                </tr>
                              </table>
                            </td>
                            <td width="45%" align="center" > 
                            檢查人員專長<BR>
                           <select multiple size=10 id="EXPERT_ID" name="EXPERT_ID" ondblclick="javascript:movesel(this.document.forms[0].EXPERT_ID,this.document.forms[0].EXPERT_ID_SRC);" style="width: 17em">							
							</select>                           
                            </td>                           
                          </tr>
                        </table>
					    				      
					      
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
                                <td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Update');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_confirmb.gif',1)"><img src="images/bt_confirm.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a></div></td>
				        		<!-- <td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Update');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_updateb.gif',1)"><img src="images/bt_update.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a></div></td> -->
				        	<%}%>
				        	<%if(permission != null && permission.get("D") != null && permission.get("D").equals("Y")){ %>
<!--				        		<td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Delete');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image103','','images/bt_deleteb.gif',1)"><img src="images/bt_delete.gif" name="Image103" width="66" height="25" border="0" id="Image103"></a></div></td> -->
							<%}%>
						<%}%>
         				<%if(!act.equals("Query")){%>       
                        	<!-- <td width="66"> <div align="center"><a href="javascript:AskReset(this.document.forms[0]);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image104','','images/bt_cancelb.gif',1)"><img src="images/bt_cancel.gif" name="Image104" width="66" height="25" border="0" id="Image104"></a></div></td> -->
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
                          <li>本網頁提供新增檢查人員之專長代碼功能。</li>                          
                          <li>請用滑鼠點選「專長選項」區的專長項目(或按【Crtl鍵+滑鼠】分別選項 或按【Shift 鍵+滑鼠】區段連續選項) ，按 『>』(『>>』表全部) 後會將所選的專長項目移至欲建檔的「檢查人員專長」區(反之『<』(『<<』移至「專長選項」)</li>      
                          <li>按了【確定】即將本表上的「檢查人員專長」資料於資料庫中建檔(如果 清空 表示不建立該員的專長資料)</li>
                          
                         <!-- <li>按<font color="#666666">【取消】</font>即重新輸入資料。</li>                         -->
                          <li>按<font color="#666666">【回上一頁】</font>則放棄新增檢查依據代碼, 回至上個畫面。</li>
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
<script type="text/javascript">
<!--
<% List expert_id_list = DBManager.QueryDB_SQLParam("select b.expertno_id, b.expertno_name from EXPERSONF a, expertnof b where a.EXPERTNO_ID = b.EXPERTNO_ID and a.muser_id = '"+muser_id+"' order by expertno_id",null,"");%>						  						 						  
<%for(int i=0;i<expert_id_list.size();i++){%>
addOption("EXPERT_ID","EXPERT_ID_SRC", "<%=(String)((DataObject)expert_id_list.get(i)).getValue("expertno_id")%>", "<%if(((DataObject)expert_id_list.get(i)).getValue("expertno_id") != null) out.print((String)((DataObject)expert_id_list.get(i)).getValue("expertno_id"));%>  <%if(((DataObject)expert_id_list.get(i)).getValue("expertno_name") != null) out.print((String)((DataObject)expert_id_list.get(i)).getValue("expertno_name"));%>");
<%}%>




<% expert_id_list = DBManager.QueryDB_SQLParam("select expertno_id,expertno_name from expertnof order by expertno_id",null,"");%>						  						 
document.forms[0].BEF_EXPERT_ID.value="<%=expert_id%>"; 
						  
<%for(int i=0;i<expert_id_list.size();i++){%>
addOption("EXPERT_ID_SRC","EXPERT_ID", "<%=(String)((DataObject)expert_id_list.get(i)).getValue("expertno_id")%>", "<%if(((DataObject)expert_id_list.get(i)).getValue("expertno_id") != null) out.print((String)((DataObject)expert_id_list.get(i)).getValue("expertno_id"));%>  <%if(((DataObject)expert_id_list.get(i)).getValue("expertno_name") != null) out.print((String)((DataObject)expert_id_list.get(i)).getValue("expertno_name"));%>");
<%}%>




<!--
</script>


</html>

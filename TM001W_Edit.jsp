<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="java.util.*" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>

<%
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");
	String loan_Item = ( request.getAttribute("loan_Item")==null ) ? "" : (String)request.getAttribute("loan_Item");		
	String loan_Item_Name = ( request.getAttribute("loan_Item_Name")==null ) ? "" : (String)request.getAttribute("loan_Item_Name");	
	String subItem = ( request.getParameter("subItem")==null ) ? "" : (String)request.getParameter("subItem");		
	System.out.println(" sLoan_Item="+loan_Item+"  sLoan_Item_Name="+loan_Item_Name+"  ssubItem="+subItem);
	String list1Color="list1Color_sbody";
    String list2Color="list2Color_sbody";
    String listColor="list1Color_sbody"; 
    List dataList = (List)request.getAttribute("dataList");
    String subItem_Name = "";
    double loan_Rate = 0,base_Rate = 0;
    if(dataList != null && dataList.size() != 0 ){
    	if(((DataObject)dataList.get(0)).getValue("subitem_name") != null){
    		subItem_Name = (String)((DataObject)dataList.get(0)).getValue("subitem_name");
    	}
    	if(((DataObject)dataList.get(0)).getValue("loan_rate") != null){
    		loan_Rate = Double.valueOf(((DataObject)dataList.get(0)).getValue("loan_rate").toString());
    	}
    	if(((DataObject)dataList.get(0)).getValue("base_rate") != null){
    		base_Rate = Double.valueOf(((DataObject)dataList.get(0)).getValue("base_rate").toString());
    	}
    }
    //取得TM001W的權限
  	Properties permission = ( session.getAttribute("TM001W")==null ) ? new Properties() : (Properties)session.getAttribute("TM001W"); 
  	if(permission == null){
         System.out.println("TM001W_Edit.permission == null");
      }else{
         System.out.println("TM001W_Edit.permission.size ="+permission.size());
                 
      }
  	String title="協助措施規劃內容基本資料維護作業";
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/TM001W.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<HTML>
<HEAD>
<TITLE><%=title %></TITLE>
<link href="css/b51.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
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
</script>
</head>
<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" leftmargin="0">
<form name='form' method=post action='#'>
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
						    <td width='15%' bgcolor='#BDDE9C'>貸款種類</td>
							<td width='85%' bgcolor='EBF4E1'>&nbsp;<%=loan_Item_Name%>
							<input type='hidden' name='loan_Item' value='<%=loan_Item%>'>
							<input type='hidden' name='loan_Item_Name' value='<%=loan_Item_Name%>'>
							</td>			    
						  </tr>
						  <tr class="sbody"> 
						    <td width='15%' bgcolor='#BDDE9C'>貸款子目別</td>
							<td width='85%' bgcolor='EBF4E1'>
								<input type='text' name='subItem_Name' size=40 value='<%=subItem_Name%>'>
								<input type='hidden' name='subItem' value='<%=subItem%>'>
							</td>			    
						  </tr>
						  <tr class="sbody"> 
						    <td width='15%' bgcolor='#BDDE9C'>貸款利率</td>
							<td width='85%' bgcolor='EBF4E1'>
								<input type='text' name='loan_Rate' onKeyUp="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" maxlength='6' value='<%=loan_Rate%>'>&nbsp;<font color='red'>(單位：x.xxx%)</font>
							</td>			    
						  </tr>
						  <tr class="sbody"> 
						    <td width='15%' bgcolor='#BDDE9C'>補貼基準</td>
							<td width='85%' bgcolor='EBF4E1'>
								<input type='text' name='base_Rate' onKeyUp="if(isNaN(value))execCommand('undo')" onafterpaste="if(isNaN(value))execCommand('undo')" maxlength='6' value='<%=base_Rate%>'>&nbsp;<font color='red'>(單位：x.xxx%)</font>
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
	<td colspan='4' >
	<%if(act.equals("new")){%>
		<%if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){ %> 
			<a href="javascript:doSubmit(this.document.forms[0],'Insert');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_confirmb.gif',1)"><img src="images/bt_confirm.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a>
			<a href="javascript:doClearEdit(form);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_cancelb.gif',1)"><img src="images/bt_cancel.gif" name="Image105" width="66" height="25" border="0" id="Image105"></a>
		<%}%>
	<%}%>
	<%if(act.equals("Edit")){%>
		<%if(permission != null && permission.get("U") != null && permission.get("U").equals("Y")){ %>
			 <a href="javascript:doSubmit(this.document.forms[0],'Update');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_updateb.gif',1)"><img src="images/bt_update.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a>
				        		<!-- <td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Update');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_updateb.gif',1)"><img src="images/bt_update.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a></div></td> -->
		<%}%>
		<%if(permission != null && permission.get("D") != null && permission.get("D").equals("Y")){ %>
			 <a href="javascript:doSubmit(this.document.forms[0],'Delete');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image103','','images/bt_deleteb.gif',1)"><img src="images/bt_delete.gif" name="Image103" width="66" height="25" border="0" id="Image103"></a>
		<%}%>
	<%}%>
    <a href="javascript:history.back();"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image106','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image106" width="80" height="25" border="0" id="Image106"></a>
    </td>   
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
                          	<li>本網頁提供新增功能。</li>
							<li>新增時，可直接於空格內輸入資料，按[確定]即將本表上的資料於資料庫中建檔。</li>
							<li>修改時，資料更改完畢後，按[修改]即將本表上的資料於資料庫中建檔。</li>
							<li>按[取消]即重新輸入資料。</li>
							<li>按[回上一頁] 則放棄資料新增回至上個畫面。</li>
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
</HTML>


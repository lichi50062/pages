﻿<%
// 94.02.03 fix 區分網際網路申報/MIS管理系統的配色 by 2295
// 94.03.25 fix 鎖定改成暫停 by 2295
// 96.03.22 add 總機構代碼使用XML by 2295
// 99.12.08 fix sqlInjection by 2808
//111.02.21 調整點選機構類別,總機構代碼無法連動 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%
	
	//String muser_type = ( request.getParameter("muser_type")==null ) ? "S" : (String)request.getParameter("muser_type");		
	String muser_type = (session.getAttribute("muser_type") == null)?"":(String)session.getAttribute("muser_type");		
	String szbank_type = ( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");		
	String sztbank_no = ( request.getParameter("tbank_no")==null ) ? "" : (String)request.getParameter("tbank_no");		
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");			
	
	System.out.println("ZZ001W_List.sztbank_no="+sztbank_no);
	
	List WTT01List = (List)request.getAttribute("WTT01List");		
	if(WTT01List == null){
	   System.out.println("WTT01List == null");
	}else{
	   System.out.println("WTT01List.size()="+WTT01List.size());
	}
	String title="「使用者帳號維護」建檔管理";		
	title =(muser_type.equals("S"))?"系統管理者"+title:title;
	System.out.println("muser_type="+muser_type);
	if(muser_type.equals("A")){
	   szbank_type = (session.getAttribute("bank_type") == null)?"":(String)session.getAttribute("bank_type");		   
	   sztbank_no = (session.getAttribute("tbank_no") == null)?"":(String)session.getAttribute("tbank_no");		   
	}
	
	System.out.println("szbank_type="+szbank_type);
	System.out.println("szbank_no="+sztbank_no);
	//取得ZZ001W的權限
	Properties permission = ( session.getAttribute("ZZ001W")==null ) ? new Properties() : (Properties)session.getAttribute("ZZ001W"); 
	if(permission == null){
       System.out.println("ZZ001W_Edit.permission == null");
    }else{
       System.out.println("ZZ001W_Edit.permission.size ="+permission.size());
               
    }	
    //111.02.21 調整xml的tag皆為小寫且為同一行    
	//96.03.22 add總機構代碼使用XML
	List paramList =new ArrayList() ;
	paramList.add(Integer.parseInt(Utility.getYear())>99 ?"100":"99") ;
	List BankNoList = DBManager.QueryDB_SQLParam("select bank_type,bank_no,bank_name from bn01 where m_year=? order by bank_no",paramList,"");	
	// XML Ducument for 總機構代碼 begin
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"BankNoListXML\">");
    out.println("<datalist>");
    for(int i=0;i< BankNoList.size(); i++) {
        DataObject bean =(DataObject)BankNoList.get(i);
        out.print("<data>");
        out.print("<banktype>"+(String)bean.getValue("bank_type")+"</banktype>");
        out.print("<bankno>"+(String)bean.getValue("bank_no")+"</bankno>");
        out.print("<bankname>"+(String)bean.getValue("bank_no")+"  "+(String)bean.getValue("bank_name")+"</bankname>");       
        out.print("</data>");
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 總機構代碼 end 	
	
%>

<script src="js/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/ZZ001W.js"></script>
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
<form method=post action='#' name="UpdateForm">
<input type="hidden" name="act" value="">   
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
                      <td width="75"><img src="images/banner_bg1.gif" width="75" height="17"></td>
                      <td width="350"><font color='#000000' size=4><b> 
                        <center>
                          <%=title%>
                        </center>
                        </b></font> </td>
                      <td width="75"><img src="images/banner_bg1.gif" width="75" height="17"></td>
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
                    <%
                      String nameColor="nameColor_sbody";
                      String textColor="textColor_sbody";
                      String bordercolor="#3A9D99";
                     %>            
                    <tr> 
                      <td><table width=600 border=1 align=center cellpadding="1" cellspacing="1" class="bordercolor">
                          <tr class="sbody">
						  <td width='15%' class="<%=nameColor%>">機構類別</td>
						  <% List bank_type = DBManager.QueryDB_SQLParam("select cmuse_id,cmuse_name from cdshareno where cmuse_div='001' and cmuse_id <> 'Z'order by input_order",null,"");%>
						  <td width='85%' colspan=2 class="<%=textColor%>">
                            <select name='BANK_TYPE' onchange="javascript:changeOption();"
                             <%if(!muser_type.equals("S")) out.print("disabled");%>                             
                            >                            
                            <%for(int i=0;i<bank_type.size();i++){%>
                            <option value="<%=(String)((DataObject)bank_type.get(i)).getValue("cmuse_id")%>"                            
                            <%if(szbank_type.equals((String)((DataObject)bank_type.get(i)).getValue("cmuse_id"))) out.print("selected");%>
                            ><%=(String)((DataObject)bank_type.get(i)).getValue("cmuse_name")%></option>                            
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
                          </td>
                           
                          </tr>     
					      
					      <tr class="sbody">
						  <td width='15%' class="<%=nameColor%>">總機構代碼</td>
						  <% List tbank_no = (List)request.getAttribute("tbank_no");%>
						  <td width='85%' colspan=2 class="<%=textColor%>">
                            <select name='TBANK_NO'
                            <%if(!muser_type.equals("S")) out.print("disabled");%>                                                                                 
                            >        
                            <option value="ALL">全部</option>
                            <%                            
                            for(int i=0;i<tbank_no.size();i++){%>
                            <option value="<%=(String)((DataObject)tbank_no.get(i)).getValue("bank_no")%>"                            
                            <%if( ((DataObject)tbank_no.get(i)).getValue("bank_no") != null &&  (sztbank_no.equals((String)((DataObject)tbank_no.get(i)).getValue("bank_no")))) out.print("selected");%>
                            >
                            <%//if(((DataObject)tbank_no.get(i)).getValue("bank_no") != null) out.print((String)((DataObject)tbank_no.get(i)).getValue("bank_no"));%>
                            
                            <%if(((DataObject)tbank_no.get(i)).getValue("bank_name") != null) out.print((String)((DataObject)tbank_no.get(i)).getValue("bank_name"));%>                            
                            </option>                            
                            <%}%>
                            </select>
                          </td>
                          </tr>   
                          </table>      
                      </td>    
                      </tr>
                      <tr><td><table><tr><br></tr></table></td></tr>  
                      <%if(WTT01List != null){ %>
                      <tr> 
                      <td><table width=600 border=1 align=center cellpadding="1" cellspacing="1" class="bordercolor">                      
                      <%
                      String tmpbank_name="";
                      String usertype="&nbsp;";
                      int i = 0;      
                      String listTitle="listTitleColor_sbody"; 
                      String list1Color="list1Color_sbody";
                      String list2Color="list2Color_sbody";
                      String listColor="list1Color_sbody";                       
                      %>
                       	  <tr class="<%=listTitle%>">
                            <td width="25">&nbsp;</td>           
            				<td width="100">總機構代碼名稱</td>
            				<td width="100">組室名稱</td>
            				<td width="30">科別</td>
            				<td width="70">帳號</td>
            				<td width="40">姓名</td>           
            				<td width="40">建置者</td>    
            				<td width="40">類別</td>               
            				<td width="20">起始</td>               
            				<td width="20">暫停</td>               
            				<td width="20">刪除</td>   
					      </tr>   
                   		    <% if(WTT01List.size() == 0){%>
                   			   <tr class="<%=list1Color%>">
                   			   <td colspan=11 align=center>無資料可供查詢</td><tr>
                   			   <tr>                   			   
                   			<% }
                    		   while(i < WTT01List.size()){ 
                    		      listColor = (i % 2 == 0)?list2Color:list1Color;	      
                    		      usertype="一般使用者";
                      %>                         	  
                          <tr class="<%=listColor%>">
                            <td width="25"><%=i+1%></td>           
            				<td width="100">
            				<%if( ((DataObject)WTT01List.get(i)).getValue("tbank_no") != null ){                      		
                       			  if(tmpbank_name.equals((String)((DataObject)WTT01List.get(i)).getValue("tbank_no"))){   
                       			     out.print("&nbsp;");
                    		      }else{
                    		        out.print((String)((DataObject)WTT01List.get(i)).getValue("tbank_no"));
                    		        out.print("<br>");
                    		        out.print((String)((DataObject)WTT01List.get(i)).getValue("tbank_name"));
                    		        tmpbank_name = (String)((DataObject)WTT01List.get(i)).getValue("tbank_no");
                    		      }  
                    		  }    
                    		%>    
                    		</td>
            				<td width="100"><%if( ((DataObject)WTT01List.get(i)).getValue("bank_name") != null ) out.print((String)((DataObject)WTT01List.get(i)).getValue("bank_name")); else out.print("&nbsp;");%></td>
            				<td width="30"><%if( ((DataObject)WTT01List.get(i)).getValue("cmuse_name") != null  && !((((String)((DataObject)WTT01List.get(i)).getValue("cmuse_name"))).trim()).equals("") ) out.print((String)((DataObject)WTT01List.get(i)).getValue("cmuse_name")); else out.print("&nbsp;");%></td>
            				<td width="70"><a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(String)((DataObject)WTT01List.get(i)).getValue("muser_id")%>');"><%if( ((DataObject)WTT01List.get(i)).getValue("muser_id") != null ) out.print((String)((DataObject)WTT01List.get(i)).getValue("muser_id"));%></a></td>
            				<td width="40"><%if( ((DataObject)WTT01List.get(i)).getValue("muser_name") != null ) out.print((String)((DataObject)WTT01List.get(i)).getValue("muser_name")); else out.print("&nbsp;");%></td>           
            				<td width="40"><%if( ((DataObject)WTT01List.get(i)).getValue("add_name") != null ) out.print((String)((DataObject)WTT01List.get(i)).getValue("add_name")); else out.print("&nbsp;");%></td>    
            				<td width="40">            				
                    		<%if( ((DataObject)WTT01List.get(i)).getValue("muser_type") != null ){
                    		     if(((String)((DataObject)WTT01List.get(i)).getValue("muser_type")).equals("S")){
                    		        usertype="super user";
                    		     }else if(((String)((DataObject)WTT01List.get(i)).getValue("muser_type")).equals("A")){
                    		        usertype="管理者";
                    		     }else{
                    		        usertype="一般使用者";
                    		     }
                    		  }
                    		  out.print(usertype);
                    		%>                    		
            				</td>    
            				<td width="20"><%if( ((DataObject)WTT01List.get(i)).getValue("firstlogin_mark") != null ) out.print((String)((DataObject)WTT01List.get(i)).getValue("firstlogin_mark")); else out.print("&nbsp;");%></a></td>               
            				<td width="20"><%if( ((DataObject)WTT01List.get(i)).getValue("lock_mark") != null ) out.print((String)((DataObject)WTT01List.get(i)).getValue("lock_mark")); else out.print("&nbsp;");%></a></td>               
            				<td width="20"><%if( ((DataObject)WTT01List.get(i)).getValue("delete_mark") != null ) out.print((String)((DataObject)WTT01List.get(i)).getValue("delete_mark")); else out.print("&nbsp;");%></a></td>   
					      </tr> 
					      <%
                  			   i++;
	                  		   }//end of while
	                  		//}//end of if
                  			%>            
					      </table>      
                      </td>    
                      </tr>
                      <%
                      }//end of if
                  	  %>              
      </table></td>
  </tr> 
</table>
</form>
</body>
</html>

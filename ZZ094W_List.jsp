<%
//110.09.30 create 系統登錄紀錄查詢,並區分BOAF/MIS配色 by 2295
//111.04.27 移除日期視窗 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%
String errMsg = Utility.getTrimString(request.getAttribute("errMsg")) ;
String act = Utility.getTrimString(request.getAttribute("act")) ;
String report_no = "ZZ094W";
Map dataMap =Utility.saveSearchParameter(request);
// 查詢條件值 
String q_begDate = Utility.getTrimString(request.getAttribute("q_begDate")) ;//登入日期-起始
String q_endDate = Utility.getTrimString(request.getAttribute("q_endDate")) ;//登入日期-結束
String begY="",begM="",begD="",endY="",endM="",endD="";	
System.out.println("q_begDate="+q_begDate);
System.out.println("q_endDate="+q_endDate);
if(!"".equals(q_begDate)){
    	begY=q_begDate.substring(0, 3);
    	begM=q_begDate.substring(3, 5);
    	begD=q_begDate.substring(5, 7);
}   	
if(!"".equals(q_endDate)){
    	endY=q_endDate.substring(0, 3);
    	endM=q_endDate.substring(3, 5);
    	endD=q_endDate.substring(5, 7);
}



//查詢條件
String q_muserId = Utility.getTrimString(request.getAttribute("q_muserId")) ;
String q_sysType = Utility.getTrimString(request.getAttribute("q_sysType")) ;
String q_loginFlag = Utility.getTrimString(request.getAttribute("q_loginFlag")) ;
String q_ipAddr = Utility.getTrimString(request.getAttribute("q_ipAddr")) ;

//Query DATA List resutl 
List qDataList = request.getAttribute("dataList") ==null?null:(List)request.getAttribute("dataList") ;

%>
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
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/PopupCal.js"></script>
<script language="javascript" src="js/ZZ094W.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
	<head>
	<title>系統登錄紀錄查詢</title>
	
	<link href="css/b51.css" rel="stylesheet" type="text/css">
	
	</head>
	<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" leftmargin="0">
		<form name='form' method=post action='/pages/ZZ094W.jsp'>
		<input type='hidden' name="act" value=''>
		<input type='hidden' name="begDate" value='<%=q_begDate%>'>
        <input type='hidden' name="endDate" value='<%=q_endDate%>'>
		<input type='hidden' name='q_muserId' value='<%=q_muserId%>'>
		<input type='hidden' name='q_sysType' value='<%=q_sysType%>'>
		<input type='hidden' name='q_loginFlag' value='<%=q_loginFlag%>'>
		<input type='hidden' name='q_ipAddr' value='<%=q_ipAddr%>'>
		
		<%
             String nameColor="nameColor_sbody";
             String textColor="textColor_sbody";
             String bordercolor="#76C657";//MIS系統使用
             //String bordercolor="#3A9D99";//BOAF系統使用
        %>   
			
		<table width="780" border="0" align="left" cellpadding="0" cellspacing="1" bgcolor="#FFFFFF">
  			<tr> 
   		    	<td><img src="images/space_1.gif" width="12" height="12"></td>
  			</tr>
  			<tr> 
        		<td bgcolor="#FFFFFF">
            		<table width="780" border="0" align="left" cellpadding="0" cellspacing="1" >
	     				<tr> 
	           				<td width="35%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
	           				<td width="30%"><font color='#000000' size=4><b><center>系統登錄紀錄查詢</center></b></font> </td>
	           				<td width="35%"><img src="images/banner_bg1.gif" width="113%" height="17"></td>
	         			</tr>
         			</table>
         		</td>
         	</tr>
         	<tr>
         		<td bgcolor="#FFFFFF" align="left">
	         		<table width="780" border="0" cellpadding="0" cellspacing="0" >
			 			<tr>  
			    			<div align="right">
			      				<jsp:include page="getLoginUser.jsp?width=780" flush="true" />
			    			</div> 
			 			</tr> 
			 		</table>
			 	</td>
         	</tr>
         	<tr>
         		<td bgcolor="#FFFFFF">
			
			<table width="780" border=1  align=center height="65" class="bordercolor">
			<tr class="sbody">
				<td width="80" height="1" class="<%=nameColor%>">登入帳號</td>
				<td class="<%=textColor%>" height="1">
     			 <input name='muserId' value='<%=q_muserId%>' size="50">  		
                  &nbsp;&nbsp;&nbsp;&nbsp;     
                  <a href="javascript:doSubmit(form,'Qry');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_queryb.gif',1)"><img src="images/bt_query.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a>&nbsp;                  
	 	 
       			</td>
			</tr>    
			
			<tr class="sbody">
                <td width="80" height="1" class="<%=nameColor%>">登入日期</td>
                <td class="<%=textColor%>" height="1">
                <input type='text' name='begY' value="<%=begY%>" size='3' maxlength='3' onblur='CheckYear(this)' >    
                <font color='#000000'>年
                <select id="hide3" name=begM>
                <option></option>
                <%
                	for (int j = 1; j <= 12; j++) {
                	if (j < 10){%>        	
                	<option value=0<%=j%>>0<%=j%></option>        		
                	<%}else{%>
                	<option value=<%=j%> ><%=j%></option>
                	<%}%>
                <%}%>
                </select>月
                <select id="hide4" name=begD>
                <option></option>
                <%
                	for (int j = 1; j < 32; j++) {
                	if (j < 10){%>        	
                	<option value=0<%=j%> >0<%=j%></option>        		
                	<%}else{%>
                	<option value=<%=j%> ><%=j%></option>
                	<%}%>
                <%}%>
                </select>日</font>
                		<!--button name='button1' onClick="popupCal('form','begY,begM,begD','BTN_date_1',event)">
            			<img align="absmiddle" border='0' name='BTN_date_1' src='images/clander.gif'-->
            			</button>
                         ～
                <input type='text' name='endY' value="<%=endY%>" size='3' maxlength='3' onblur='CheckYear(this)'>
                <font color='#000000'>年
                <select id="hide5" name=endM>
                <option></option>
                <%
                	for (int j = 1; j <= 12; j++) {
                	if (j < 10){%>        	
                	<option value=0<%=j%>>0<%=j%></option>        		
                	<%}else{%>
                	<option value=<%=j%>><%=j%></option>
                	<%}%>
                <%}%>
                </select>月
                <select id="hide6" name=endD>
                <option></option>
                <%
                	for (int j = 1; j < 32; j++) {
                	if (j < 10){%>        	
                	<option value=0<%=j%>>0<%=j%></option>        		
                	<%}else{%>
                	<option value=<%=j%> ><%=j%></option>
                	<%}%>
                <%}%>
                </select>日</font>
                		<!--button name='button2' onClick="popupCal('form','endY,endM,endD','BTN_date_2',event)">
            			<img align="absmiddle" border='0' name='BTN_date_2' src='images/clander.gif'-->
            			</button>
            			<font color='red'>＊必要查詢條件</font>
            </tr>  
			
			    
			<tr class="sbody">
				<td width="80" class="<%=nameColor%>" height="1">系統類別</td>
				<td bgcolor="#EBF4E1" height="1" class="<%=textColor%>">
	   				<select size="1" name="sysType">
	   				    <option value="ALL" <%if(q_sysType.equals("ALL"))out.print("selected");%>>全部</option>
	     				<option value="1" <%if(q_sysType.equals("1"))out.print("selected");%>>申報系統</option>
	     				<option value="2" <%if(q_sysType.equals("2"))out.print("selected");%>>MIS管理系統</option>
	     				
	  				</select>
	  			</td>
			</tr>
			<tr class="sbody">
				<td width="80" height="1" class="<%=nameColor%>">登入狀態</td>
				<td class="<%=textColor%>" height="1">
					<select size="1" name="loginFlag" >
					<option value="ALL" <%if(q_loginFlag.equals("ALL"))out.print("selected");%>>全部</option>
	    			<option value="Y" <%if(q_loginFlag.equals("Y"))out.print("selected");%>>成功</option>
	    			<option value="N" <%if(q_loginFlag.equals("N"))out.print("selected");%>>失敗</option>	    			
	 				 </select>
				</td>
			</tr>
			
			<tr class="sbody" >
                   <td width="80" height="1" class="<%=nameColor%>">登入IP</td>
                   <td height="1" class="<%=textColor%>">
                   <input type="text" name="ipAddr" value='<%=q_ipAddr %>' size="50">
            </tr>  
            
			</table>
			<%
			String listTitle="listTitleColor_sbody"; 
	        String list1Color="list1Color_sbody";
	        String list2Color="list2Color_sbody";
	        String listColor="list1Color_sbody";
			%>
			<table width=780 border=1 align=center cellpadding="1" cellspacing="1" class="bordercolor">
			<tr class="sbody">
				<td class='<%=listTitle%>' width="3%" height="14">序號</td>
				<td class='<%=listTitle%>' width="8%" height="14">登入帳號</td>
				<td class='<%=listTitle%>' width="16%" height="14">總機構名稱</td>
				<td class='<%=listTitle%>' width="10%" height="14">使用者名稱</td>
				<td class='<%=listTitle%>' width="17%" height="14">登入時間</td>
				<td class='<%=listTitle%>' width="5%" height="14">狀態</td>
				<td class='<%=listTitle%>' width="17%" height="14">登出時間</td>
				<td class='<%=listTitle%>' width="12%" height="14">系統類別</td>
				<td class='<%=listTitle%>' width="12%" height="14">來源IP</td>
			</tr>
			<%if("List".equalsIgnoreCase(act)) { %>
				<tr>
				<td colspan='9' class="<%=listColor%>">請輸入查詢條件。</td>
				</tr>
			<%} else { %>
			<% if(qDataList==null || qDataList.size()==0)  {%>
				<tr>
				<td colspan='9' class="<%=listColor%>">查無相關資料。</td>
				</tr>
			<% } else { %>
			<%   for(int i=0 ; i < qDataList.size() ; i++) {%>
			<%    listColor = (i % 2 == 0)?list2Color:list1Color; %>
			<%	  DataObject bean =(DataObject)qDataList.get(i); 
			      //System.out.println("bank_name="+(String)bean.getValue("bank_name"));					      		 
			%>
			<tr>
				<td class="<%=listColor%>"><%=String.valueOf((i+1)) %></td>
				<td class="<%=listColor%>"><%=Utility.getTrimString(bean.getValue("muser_id")) %></td>
				<td class="<%=listColor%>">
				    <%if(bean.getValue("bank_name") == null){%> 
						&nbsp;&nbsp;
					<%} else if(!"".equals((String)bean.getValue("bank_name"))){ 
						out.print((String)bean.getValue("bank_name"));
					} else { %>
					&nbsp;&nbsp;
					<%} %>
				</td>
				
				<td class="<%=listColor%>">
					<%if(bean.getValue("muser_name") != null|| !"".equals((String)bean.getValue("muser_name"))){ 
						out.print((String)bean.getValue("muser_name"));
					} else { %>
					&nbsp;&nbsp;
					<%} %>
				</td>
				<td class="<%=listColor%>">
					<%if(!"".equals((String)bean.getValue("input_date"))){ 
						out.print((String)bean.getValue("input_date"));
					} else { %>
					&nbsp;&nbsp;
					<%} %>
				</td>
				<td class="<%=listColor%>"><%=Utility.getTrimString(bean.getValue("login_flag")) %></td>
				<td class="<%=listColor%>">
					<%if(bean.getValue("logout_time") != null){ 
						out.print((String)bean.getValue("logout_time"));
					} else { %>
					&nbsp;&nbsp;
					<%} %>
				</td>
				
				<td class="<%=listColor%>"><%=Utility.getTrimString(bean.getValue("type")) %></td>
				<td class="<%=listColor%>"><%=Utility.getTrimString(bean.getValue("ip_address")) %></td>
				
			<tr>
			<%   } %>
			<% } %>
		<% } %>
			</table>		
             </td>
        </tr>
        </table>
		
	</body>
	<script language="JavaScript" >		
		if("<%=errMsg%>"!="") {
			alert("<%=errMsg%>") ;
		}
	setSelect(form.begM,"<%=begM%>");
    setSelect(form.endM,"<%=endM%>");
    setSelect(form.begD,"<%=begD%>");
    setSelect(form.endD,"<%=endD%>")	
	</script>
</html>

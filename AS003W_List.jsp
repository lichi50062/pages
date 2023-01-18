<%
//106.11.22 add 機構代碼轉換日期;原轉換日期調整為MIS系統轉換日期 by 2295
//106.12.04 add 下載機構代號轉換清單 by 2295
//107.01.11 調整 區分BOAF/MIS配色 by 2295
//108.05.14 add 報表格式挑選 by 2295
//111.01.17 調整 挑選農漁會別時,縣市別及總機構代碼無法連動 by 2295
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
String report_no = "AS003W";
Map dataMap =Utility.saveSearchParameter(request);
String cityType = Utility.getTrimString(dataMap.get("cityType")) ; //縣市別
//查詢條件
String q_bankType = Utility.getTrimString(request.getAttribute("q_bankType")) ;
String q_tbank = Utility.getTrimString(request.getAttribute("q_tbank")) ;
String q_cityType = Utility.getTrimString(request.getAttribute("q_cityType")) ;
String printStyle = "".equals(Utility.getTrimString(request.getAttribute("printStyle")))? "xls":Utility.getTrimString(request.getAttribute("printStyle")) ;//108.05.14 add

List tBankList = (List)request.getAttribute("TBank");
//111.01.17 調整xml的tag皆為小寫且為同一行
// XML Ducument for 總機構代碼 begin
out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"TBankXML\">");
out.println("<datalist>");
for(int i=0;i< tBankList.size(); i++) {
    DataObject bean =(DataObject)tBankList.get(i);
    out.print("<data>");
    out.print("<banktype>"+bean.getValue("bank_type")+"</banktype>");
    out.print("<bankcity>"+bean.getValue("hsien_id")+"</bankcity>");
    out.print("<bankvalue>"+bean.getValue("bank_no")+"</bankvalue>");
    out.print("<bankname>"+bean.getValue("bank_no")+"  "+bean.getValue("bank_name")+"</bankname>");
    out.print("<m_year>"+bean.getValue("m_year").toString()+"</m_year>") ;
    out.print("</data>");
}
out.println("</datalist>\n</xml>");
// XML Ducument for 總機構代碼 end 

List cityList = (List)request.getAttribute("City");
if(cityList!=null) {
	//111.01.17 調整xml的tag皆為小寫且為同一行
	// XML Ducument for 縣市別 begin
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"CityXML\">");
    out.println("<datalist>");
    for(int i=0;i< cityList.size(); i++) {
    	DataObject bean =(DataObject)cityList.get(i);
        out.print("<data>");
        out.print("<citytype>"+bean.getValue("hsien_id")+"</citytype>");
        out.print("<cityname>"+bean.getValue("hsien_name")+"</cityname>");
        out.print("<cityvalue>"+bean.getValue("hsien_id")+"</cityvalue>");
        out.print("<cityyear>"+bean.getValue("m_year").toString()+"</cityyear>");
        out.print("</data>");
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 縣市別 end
}
//Query DATA List resutl 
List qDataList = request.getAttribute("dataList") ==null?null:(List)request.getAttribute("dataList") ;
%>
<html>
	<head>
	<title>配賦代號轉換作業</title>	
	<script src="js/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
	<script language="javascript" src="js/Common.js"></script>
	<script language="javascript" src="js/PopupCal.js"></script>
	<script language="javascript" src="js/AS003W.js"></script>
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
		<form name='form' method=post action='/pages/AS003W.jsp'>
		<input type='hidden' name="act" value=''>
		<input type='hidden' name='qTbankNo' value=''>
		<input type='hidden' name='delItem' value''>
		<input type='hidden' name='bank_no' value=''>
		<input type='hidden' name='src_bank_no' value=''>
		<input type='hidden' name='q_bankType' value='<%=q_bankType%>'>
		<input type='hidden' name='q_tbank' value='<%=q_tbank%>'>
		<input type='hidden' name='q_cityType' value='<%=q_cityType%>'>
		
		<table width="640" border="0" align="left" cellpadding="0" cellspacing="1" bgcolor="#FFFFFF">
  		<tr> 
   		     <td><img src="images/space_1.gif" width="12" height="12"></td>
  		</tr>
  		<tr> 
             <td bgcolor="#FFFFFF">
             <table width="640" border="0" align="left" cellpadding="0" cellspacing="1" bgcolor="#FFFFFF">
	     	<tr> 
	           <td width="35%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
	           <td width="40%"><font color='#000000' size=4><b><center>配賦代號轉換作業</center></b></font> </td>
	           <td width="35%"><img src="images/banner_bg1.gif" width="113%" height="17"></td>
	         </tr>
         	</table>
	         <table width="640" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
			 <tr>  
			    <div align="right">
			      <jsp:include page="getLoginUser.jsp?width=640" flush="true" />
			    </div> 
			 </tr> 
			 </table>
			<%
             String nameColor="nameColor_sbody";
             String textColor="textColor_sbody";
             String bordercolor="#3A9D99";
            %>   
			
			<table width="640" border=1  align=center height="65" bgcolor="#FFFFF" class="bordercolor">
			<tr class="sbody">
				<td width="118" class="<%=nameColor%>" height="1">農漁會別</td>
				<td bgcolor="#EBF4E1" height="1" class="<%=textColor%>">
	   				<select size="1" name="bankType" onChange="changeTbank()">
	     				<option value="6">農會</option>
	     				<option value="7">漁會</option>
	  				</select>
	  				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  				縣市別:&nbsp;&nbsp;
	   				<select size="1" name="cityType" onChange="changeTbank()" >
	   				</select>
	   				<%if(Utility.getPermission(request,report_no,"Q")){ %>   
	   				<a href="javascript:goQuery(this.document.forms[0]);" 
	   				   onMouseOut="MM_swapImgRestore()" 
	   				   onMouseOver="MM_swapImage('Image101','','images/bt_queryb.gif',1)">
	   				   <img src="images/bt_query.gif" name="Image101" width="66" height="25" border="0" id="Image101"/></a>
	   				<%} %>
	   				<%if(Utility.getPermission(request,report_no,"A")){ %>                   	        	                                   		     
	                    <a href="javascript:goNewEdit(this.document.forms[0]);" 
	                       onMouseOut="MM_swapImgRestore()" 
	                       onMouseOver="MM_swapImage('Image102','','images/bt_addb.gif',1)">
	                    <img src="images/bt_add.gif" name="Image102" width="66" height="25" border="0" id="Image102"/></a>                       
	                <%}%>
	                <%if(Utility.getPermission(request,report_no,"D")){ %>                   	        	                                   		     
	                    <a href="javascript:doDelete();" 
	                       onMouseOut="MM_swapImgRestore()" 
	                       onMouseOver="MM_swapImage('Image103','','images/bt_deleteb.gif',1)">
	                    <img src="images/bt_delete.gif" name="Image103" width="66" height="25" border="0" id="Image103"/></a>                       
	                <%}%>
	                <%if(Utility.getPermission(request,report_no,"P")){ %>             			 	           	        	                                   		     
	                    <a href="javascript:doDownload();" 
	                       onMouseOut="MM_swapImgRestore()" 
	                       onMouseOver="MM_swapImage('Image104','','images/bt_downloadb.gif',1)">
	                    <img src="images/bt_download.gif" name="Image104" width="66" height="25" border="0" id="Image104"/></a>   
	                                    
	                 <%}%>
	  			</td>
	  			
			</tr>
			<tr class="sbody">
				<td width="118" height="1" class="<%=nameColor%>">總機構單位</td>
				<td class="<%=textColor%>" height="1">
					<select size="1" name="tbank" >
	    			<option value="" >全部</option>
	 				 </select>
				</td>
			</tr>
			
			<tr class="sbody">
				<td width="118" height="1" class="<%=nameColor%>">輸出格式</td>
				<td class="<%=textColor%>" height="1">
     			 <input name='printStyle' type='radio' value='xls' <%if(printStyle.equals("xls"))out.print("checked");%>>Excel
  			 	 <input name='printStyle' type='radio' value='ods' <%if(printStyle.equals("ods"))out.print("checked");%>>ODS
  			 	 <input name='printStyle' type='radio' value='pdf' <%if(printStyle.equals("pdf"))out.print("checked");%>>PDF     
       			</td>
			</tr>        
			
			</table>
			<%
			String listTitle="listTitleColor_sbody"; 
	        String list1Color="list1Color_sbody";
	        String list2Color="list2Color_sbody";
	        String listColor="list1Color_sbody";
			%>
			<table width=640 border=1 align=center cellpadding="1" cellspacing="1" class="bordercolor">
			<tr class="sbody" bgcolor="#BFDFAE">
				<td class='<%=listTitle%>' width="5%" height="14">序號</td>
				<td class='<%=listTitle%>' width="5%" height="14">選項</td>
				<td class='<%=listTitle%>' width="12%" height="14">新機構代號</td>
				<td class='<%=listTitle%>' width="12%" height="14">舊機構代號</td>
				<td class='<%=listTitle%>' width="24%" height="14">總機構名稱</td>
				<td class='<%=listTitle%>' width="18%" height="14">機構代號轉換日期</td>
				<td class='<%=listTitle%>' width="18%" height="14">MIS系統轉換日期</td>
			</tr>
			<%if("List".equalsIgnoreCase(act)) { %>
				<tr>
				<td colspan='7' class="<%=listColor%>">請輸入查詢條件。</td>
				</tr>
			<%} else { %>
			<% if(qDataList==null)  {%>
				<tr>
				<td colspan='7' class="<%=listColor%>">查無相關資料。</td>
				</tr>
			<% } else { %>
			<%   for(int i=0 ; i < qDataList.size() ; i++) {%>
			<%    listColor = (i % 2 == 0)?list2Color:list1Color; %>
			<%	  DataObject bean =(DataObject)qDataList.get(i); %>
			<tr>
				<td class="<%=listColor%>"><%=String.valueOf((i+1)) %></td>
				<td class="<%=listColor%>">
					<%if("".equals(Utility.getTrimString(bean.getValue("trans_date")))){ %>
					<input type='checkbox' name='delBox' value='<%=Utility.getTrimString(bean.getValue("pbank_no")) %>'/>
					<%} else { %>
					&nbsp;&nbsp;
					<%} %>
				</td>
				<td class="<%=listColor%>">
					<%if("".equals(Utility.getTrimString(bean.getValue("trans_date")))){ %>
					<a href="javascript:goMtnPage(form,'<%=Utility.getTrimString(bean.getValue("pbank_no")) %>')">
						<%=Utility.getTrimString(bean.getValue("bank_no")) %></a>
					<%} else { %>
					<a href="javascript:goDetailPage('<%=Utility.getTrimString(bean.getValue("src_bank_no")) %>'
					        ,'<%=Utility.getTrimString(bean.getValue("bank_no")) %>')">
						<%=Utility.getTrimString(bean.getValue("bank_no")) %></a>
					<%} %>
				</td>
				<td class="<%=listColor%>">
					<%if("".equals(Utility.getTrimString(bean.getValue("trans_date")))){ %>
					<a href="javascript:goMtnPage(form,'<%=Utility.getTrimString(bean.getValue("pbank_no")) %>')">
						<%=Utility.getTrimString(bean.getValue("src_bank_no")) %></a>
					<%} else { %>
					<a href="javascript:goDetailPage('<%=Utility.getTrimString(bean.getValue("src_bank_no")) %>'
					        ,'<%=Utility.getTrimString(bean.getValue("bank_no")) %>')">
						<%=Utility.getTrimString(bean.getValue("src_bank_no")) %></a>
					<%} %>
					
				</td>
				<td class="<%=listColor%>"><%=Utility.getTrimString(bean.getValue("bank_name")) %></td>
				<td class="<%=listColor%>">
					<%if(!"".equals(Utility.getTrimString(bean.getValue("online_date")))){ %>
						<%=Utility.getCHTdate(Utility.getTrimString(bean.getValue("online_date")),0) %>
					<%} else {%>
						&nbsp;&nbsp;	
					<%} %>
				</td> 
				<td class="<%=listColor%>">
					<%if(!"".equals(Utility.getTrimString(bean.getValue("trans_date")))){ %>
						<%=Utility.getCHTdate(Utility.getTrimString(bean.getValue("trans_date")),0) %>
					<%} else {%>
						&nbsp;&nbsp;	
					<%} %>
				</td> 
				
			<tr>
			<%   } %>
			<% } %>
			<%} %>
			
			</table>		
             </td>
        </tr>
        </table>
		
	</body>
	<script language="JavaScript" >
		changeCity() ;
		changeTbank();
		var qtbank = "<%=Utility.getTrimString(request.getAttribute("qtbank"))%>" ;
		//還原查詢參數
		if(form.q_bankType.value!="") {
			setSelect(form.bankType , form.q_bankType.value) ;
			changeTbank();
		}
		if(form.q_cityType.value!="") {
			setSelect(form.cityType , form.q_cityType.value) ;
			changeTbank();
		}
		if(form.q_tbank.value!="") {
			setSelect(form.tbank , form.q_tbank.value);
		}
		
		if("<%=errMsg%>"!="") {
			alert("<%=errMsg%>") ;
		}
	</script>
</html>
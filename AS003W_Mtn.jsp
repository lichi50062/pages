<%
//106.11.22 add 機構代碼轉換日期;原轉換日期調整為MIS系統轉換日期 by 2295
//108.05.14 調整 機構代碼轉換日期若為空白會顯示錯誤 by 2295
//108.05.14 add 報表格式挑選 by 2295
//111.04.20 調整input變更前後單位名稱取得方式 by 2295
//111.04.25 移除日期視窗 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%
String report_no = "AS003W";
String errMsg = Utility.getTrimString(request.getAttribute("errMsg")) ;
String printStyle = "".equals(Utility.getTrimString(request.getAttribute("printStyle")))? "xls":Utility.getTrimString(request.getAttribute("printStyle")) ;//108.05.14 add

Map dataMap =Utility.saveSearchParameter(request);
String onlineDate_year="",onlineDate_month="",onlineDate_day="";

List tBankList = (List)request.getAttribute("TBank");


List tDataList = (List)request.getAttribute("TBankList");
for(int i=0; i<tDataList.size(); i++){
	
	if( ((DataObject)tDataList.get(i)).getValue("online_date") != null ){		
		String tmp=(((DataObject)tDataList.get(i)).getValue("online_date")).toString();//108.05.14 調整		
		String tmpDate[] = tmp.split("/");//108.05.14	
		onlineDate_year = String.valueOf(Integer.parseInt(tmpDate[0])-1911);
		onlineDate_month = tmpDate[1];
		onlineDate_day = tmpDate[2];	
	}
}

String listTitle="listTitleColor_sbody"; 
String list1Color="list1Color_sbody";
String list2Color="list2Color_sbody";
String listColor="list1Color_sbody";
     
String nameColor="nameColor_sbody";
String textColor="textColor_sbody";
String bordercolor="#3A9D99";
       
%>
<script src="js/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/PopupCal.js"></script>
<script language="javascript" src="js/json2.js"></script>
<script language="javascript" src="js/AS003W.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>

<title>配賦代號轉換作業</title>	

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
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form name="form" method=post action='#'>
		
		<input type='hidden' name='delItem'>
<table width="600" border="0" align="left" cellpadding="0" cellspacing="1" bgcolor="#FFFFFF">
	<tr> 
 		 <td><img src="images/space_1.gif" width="12" height="12"></td>
	</tr>
    <tr> 
        <td bgcolor="#FFFFFF">
	<table width="560" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr><td>
		<table width="560" border="0" align="center" cellpadding="0" cellspacing="0" >
     	<tr> 
           <td width="35%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
           <td width="30%"><font color='#000000' size=4><b><center>配賦代號轉換作業</center></b></font> </td>
           <td width="35%"><img src="images/banner_bg1.gif" width="113%" height="17"></td>
         </tr>
         </table>
         <table width="560" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
		 <tr>  
		    <div align="right">
		      <jsp:include page="getLoginUser.jsp?width=560" flush="true" />
		    </div> 
		 </tr> 
		 </table>
	
		<table border=1 width='560' align=center height="65" class="bordercolor">

  		
		<tr class="sbody">
			<td width="118" class="<%=nameColor%>" >欲轉換的機構單位</td>
			<td class="<%=textColor%>" colspan='2' >
				<select size="1" name="tbank" >
				<%for(Object obj: tBankList ) { %>
				<%	DataObject bean =(DataObject) obj; %>
				<option value='<%=Utility.getTrimString(bean.getValue("tbank_no"))%>'>
    			<%=Utility.getTrimString(bean.getValue("tbank_no"))%>
    			<%=Utility.getTrimString(bean.getValue("bank_name"))%>
				<%} %>
    			
 				 </select>
			</td>
		</tr>
		<tr class="sbody">
			<td width="118" class="<%=nameColor%>">機構代碼轉換日期</td>
			<td colspan=2 class="<%=textColor%>">                              		                    
  		      <input type='hidden' name='onlineDate'><!-- //機構代碼日期 -->
			<input type='text' id='onlineDate_year' name='onlineDate_year' value='<%=onlineDate_year%>' size='2' maxlength='3' >年
			<select id='onlineDate_month' name='onlineDate_month' >
				<option></option>
				<%for (int j = 1; j <= 12; j++) {
					if (j < 10){%>
						<option value=0<%=j%> <%if(!"".equals(onlineDate_month) && Integer.parseInt(onlineDate_month)==j) out.print("selected");%> >0<%=j%></option>
					<%}else{%>
						<option value=<%=j%>  <%if(!"".equals(onlineDate_month) && Integer.parseInt(onlineDate_month)==j) out.print("selected");%>  ><%=j%></option>
					<%}
				}%>
			</select>月
					            			
			<select id='onlineDate_day' name='onlineDate_day' >
				<option></option>
				<%for (int j = 1; j <= 31; j++) {
					if (j < 10){ %>
						<option value=0<%=j%>  <%if(!"".equals(onlineDate_day) && Integer.parseInt(onlineDate_day)==j) out.print("selected");%> >0<%=j%></option>
					<%}else{ %>
						<option value=<%=j%> <%if(!"".equals(onlineDate_day) && Integer.parseInt(onlineDate_day)==j) out.print("selected");%> ><%=j%></option>
					<%}
				}%>
			</select>日
			<!--button name='button_onlineDate' onClick="popupCal('form','onlineDate_year,onlineDate_month,onlineDate_day','BTN_date_onlineDate',event)">
			<img align="absmiddle" border='0' name='BTN_date_onlineDate' src='images/clander.gif'-->
			</button>
            </td>
        </tr>
		<tr class='sbody'>
			<td width='30%' class="<%=nameColor%>" >單位名稱</td>
			<td width='35%' class="<%=textColor%>">變更前</td>
			<td width='35%' class="<%=textColor%>">變更後</td>
		</tr>
		<%for(Object obj : tDataList ) { %>
		<%    DataObject bean =(DataObject) obj ;%>
		<tr class='sbody'>
			<td width='30%' class="<%=nameColor%>"><%=Utility.getTrimString(bean.getValue("bank_name")) %></td>
			<td width='35%' class="<%=textColor%>"><%=Utility.getTrimString(bean.getValue("src_bank_no"))%></td>
			<td width='35%' class="<%=textColor%>">
			<input type='text' name='p_bank_no' maxlength='7' value='<%=Utility.getTrimString(bean.getValue("bank_no"))%>'>
			<input type='hidden' name='srcBankNo_upd' value='<%=Utility.getTrimString(bean.getValue("src_bank_no"))%>'> 
			<input type='hidden' name='tbank_upd' value='<%=Utility.getTrimString(bean.getValue("pbank_no"))%>'> 
			</td>
		</tr>	
		<%} %>
        <tr class='sbody'>
			<td width='30%' class="<%=nameColor%>" >輸出格式</td>
			<td width='70%' class="<%=textColor%>" colspan="2">
			 <input name='printStyle' type='radio' value='xls' <%if(printStyle.equals("xls"))out.print("checked");%>>Excel
  			 <input name='printStyle' type='radio' value='ods' <%if(printStyle.equals("ods"))out.print("checked");%>>ODS
  			 <input name='printStyle' type='radio' value='pdf' <%if(printStyle.equals("pdf"))out.print("checked");%>>PDF            		
			</td>
		</tr>
		</table>
		</td></tr>
		<div id='editArea'></div>
	
		<%//登入者資訊 %>
		<tr>                  
            <td>
            <div align="right"><jsp:include page="getMaintainUser.jsp?width=560" flush="true" /></div>
           	</td>                                              
        </tr>
		<tr> 
            <td><div align="center"> 
                <table width="243" border="0" cellpadding="1" cellspacing="1">
                  <tr>       
                    <%if(Utility.getPermission(request,report_no,"U")){ %>                        
           			<td width="66"> <div align="center">
           			<a href="javascript:doUpdate();" 
           			   onMouseOut="MM_swapImgRestore()" 
           			   onMouseOver="MM_swapImage('Image101','','images/bt_updateb.gif',1)">
           			   <img src="images/bt_update.gif" name="Image101" width="66" height="25" border="0" id="Image101">
           			 </a>
           			 </div></td>
           			 <%}%>
           			 <%if(Utility.getPermission(request,report_no,"D")){ %>           
        			 <td width="66"> <div align="center">
           			 <a href="javascript:doMtnDelete()" 
           			   onMouseOut="MM_swapImgRestore()" 
           			   onMouseOver="MM_swapImage('Image102','','images/bt_deleteb.gif',1)">
           			   <img src="images/bt_delete.gif" name="Image102" width="66" height="25" border="0" id="Image102">
           			 </a>
           			 </div></td>
           			 <%}%>
           			 <%if(Utility.getPermission(request,report_no,"P")){ %>  
           			 	<td width="66"> <div align="center">                 	        	                                   		     
	                    <a href="javascript:doPrint();" 
	                       onMouseOut="MM_swapImgRestore()" 
	                       onMouseOver="MM_swapImage('Image103','','images/bt_printb.gif',1)">
	                    <img src="images/bt_print.gif" name="Image103" width="66" height="25" border="0" id="Image103"/></a>    
	                    
           			   </div></td>                   
	                 <%}%>
                    <td width="80"><div align="center"><a href="javascript:goBack();"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image105" width="80" height="25" border="0" id="Image105"></a></div></td>
                  </tr>
                  </tr>
                </table>
            </div></td>
      </tr> 
	  </table>
	  </td>
	</tr>
	</table>
	<input type='hidden' name="act" value=''/>
		<input type='hidden' name='jData' value=''/>
		<input type='hidden' name='errMsg' value='<%=errMsg%>'/>
		<input type='hidden' name='bankType' value="<%=Utility.getTrimString(request.getAttribute("q_bankType"))%>">
		<input type='hidden' name='cityType' value="<%=Utility.getTrimString(request.getAttribute("q_cityType"))%>">
	</form>
	
	<script language="JavaScript" >

		
		if(document.getElementsByName("errMsg")[0].value!="") {
			alert(document.getElementsByName("errMsg")[0].value) ;
		}
	</script>
	</body>
</html>
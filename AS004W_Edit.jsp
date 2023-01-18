<%
//110.03.02 add 新增撤銷核准項目維護作業 by 6493
//111.04.19 調整Edge無法挑選縣市別/總機構單位無法連動及挑選 by 2295
//111.04.25 移除日期視窗 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%
String report_no = "AS004W";
String errMsg = Utility.getTrimString(request.getAttribute("errMsg")) ;
Map dataMap =Utility.saveSearchParameter(request);
String cityType = Utility.getTrimString(dataMap.get("cityType")) ; //縣市別
String revokeDate_year="",revokeDate_month="",revokeDate_day="";
List tBankList = (List)request.getAttribute("TBank");
String qTbankNo = (String)request.getAttribute("qTbankNo");
String qSeqNo = (String)request.getAttribute("qSeqNo");

// XML Ducument for 總機構代碼 begin
//111.04.19 調整xml的tag皆為小寫且為同一行    
out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"TBankXML\">");
out.println("<datalist>");
for(int i=0;i< tBankList.size(); i++) {
    DataObject bean =(DataObject)tBankList.get(i);
    out.print("<data>");
	out.print("<banktype>"+bean.getValue("bank_type")+"</banktype>");
	out.print("<bankkind>"+bean.getValue("bank_kind")+"</bankkind>");
	out.print("<tbank_no>"+bean.getValue("tbank_no")+"</tbank_no>");
	out.print("<bankcity>"+bean.getValue("hsien_id")+"</bankcity>");
	out.print("<bankvalue>"+bean.getValue("bank_no")+"</bankvalue>");
	out.print("<bankname>"+bean.getValue("bank_no")+"  "+bean.getValue("bank_name")+"</bankname>");
	out.print("<bankjustname>"+bean.getValue("bank_name")+"</bankjustname>");
	out.print("<m_year>"+bean.getValue("m_year")+"</m_year>");
	out.print("</data>");
}
out.println("</datalist>\n</xml>");
// XML Ducument for 總機構代碼 end 

List cityList = (List)request.getAttribute("City");
if(cityList!=null) {
	//111.04.19 調整xml的tag皆為小寫且為同一行    
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

List revokeList = (List)request.getAttribute("Revoke");
if(revokeList!=null) {
	// XML Ducument for 撤銷項目 begin
	//111.04.19 調整xml的tag皆為小寫且為同一行    
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"RevokeXML\">");
    out.println("<datalist>");
    for(int i=0;i< revokeList.size(); i++) {
    	DataObject bean =(DataObject)revokeList.get(i);
        out.print("<data>");
        out.print("<revokecode>"+bean.getValue("columnlink")+"</revokecode>");
        out.print("<revokename>"+bean.getValue("cmuse_name")+"</revokename>");
        out.print("</data>");
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 撤銷項目 end
}

%>
<script src="js/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/PopupCal.js"></script>
<script language="javascript" src="js/json2.js"></script>
<script language="javascript" src="js/AS004W.js"></script>


<html>
<head>
<title>撤銷核准項目維護作業</title>
<link href="css/b51.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
$(document).ready(function(){
	changeRevoke("RevokeXML") ;
	changeCity("CityXML",'') ;
	changeTbankWhenFilterBankKind('TBankXML','');
	if(document.getElementsByName("errMsg")[0].value!="") {
		alert(document.getElementsByName("errMsg")[0].value) ;
	}
}) ;
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

function setEditBank(){
	var form = document.form;
	if(form.tbank.value=="") {
		alert("請選取總機構單位");
		return false ;
	}
}
	
</script>
</head>

<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" leftmargin="0">
<form name='form' method=post action='/pages/AS004W.jsp'>
<input type='hidden' name="act" value=''/>
<input type='hidden' name='jData' value=''/>
<input type='hidden' name='errMsg' value='<%=errMsg%>'/>
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
                      <td width="140"><img src="images/banner_bg1.gif" width="140" height="17"></td>
                      <td width="320"><font color='#000000' size=4><b> 
                        <center> 撤銷核准項目維護作業</center>
                        </b></font> </td>
                      <td width="140"><img src="images/banner_bg1.gif" width="140" height="17"></td>
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
                    <%
                      String nameColor="nameColor_sbody";
                      String textColor="textColor_sbody";
                      String bordercolor="#3A9D99";
                    %>         
                    <tr> 
                      <td>
                      <table width=560 border=1 align=center cellpadding="1" cellspacing="1" class="bordercolor">
                      	  <tr class="sbody">
						  <td width='15%' class="<%=nameColor%>">農漁會別</td>
						  <td width='85%' colspan=2 class="<%=textColor%>">
                            <select size="1" name="bankType" onChange="changeTbankWhenFilterBankKind('TBankXML','')">
			     				<option value="6">農會</option>
			     				<option value="7">漁會</option>
			  				</select>
                          </td>
                          </tr>   
					      
					      <tr class="sbody">
						  <td width='15%' class="<%=nameColor%>">縣市別</td>						  
						  <td width='85%' colspan=2 class="<%=textColor%>">
						    <select size="1" name="cityType" onChange="changeTbankWhenFilterBankKind('TBankXML','')" >
   							</select> 
                          </td>
                          </tr>   		      
					     
					      <tr class="sbody">
						  <td width='15%' class="<%=nameColor%>">總機構單位</td>
						  <td width='85%' colspan=2 class="<%=textColor%>">                              		                    
  		                    <select size="1" name="tbank" onChange='setEditBank()' >
			    			<option value="" >請選擇...</option>
			 				</select>
                          </td>
                          </tr>
                          <tr class="sbody">
						  <td width='15%' class="<%=nameColor%>">撤銷日期</td>
						  <td width='85%' colspan=2 class="<%=textColor%>">                              		                    
  		                    <input type='hidden' name='revokeDate'><!-- //機構代碼日期 -->
							<input type='text' id='revokeDate_year' name='revokeDate_year' value='<%=revokeDate_year%>' size='2' maxlength='3' >年
							<select id='revokeDate_month' name='revokeDate_month' >
								<option></option>
								<%for (int j = 1; j <= 12; j++) {
									if (j < 10){%>
										<option value=0<%=j%> <%if(!"".equals(revokeDate_month) && Integer.parseInt(revokeDate_month)==j) out.print("selected");%> >0<%=j%></option>
									<%}else{%>
										<option value=<%=j%>  <%if(!"".equals(revokeDate_month) && Integer.parseInt(revokeDate_month)==j) out.print("selected");%>  ><%=j%></option>
									<%}
								}%>
							</select>月
									            			
							<select id='revokeDate_day' name='revokeDate_day' >
								<option></option>
								<%for (int j = 1; j <= 31; j++) {
									if (j < 10){ %>
										<option value=0<%=j%>  <%if(!"".equals(revokeDate_day) && Integer.parseInt(revokeDate_day)==j) out.print("selected");%> >0<%=j%></option>
									<%}else{ %>
										<option value=<%=j%> <%if(!"".equals(revokeDate_day) && Integer.parseInt(revokeDate_day)==j) out.print("selected");%> ><%=j%></option>
									<%}
								}%>
							</select>日
							<!--button name='button_revokeDate' onClick="popupCal('form','revokeDate_year,revokeDate_month,revokeDate_day','BTN_date_revokeDate',event)">
							<img align="absmiddle" border='0' name='BTN_date_revokeDate' src='images/clander.gif'-->
							</button>
                          </td>
                          </tr>
					     
					      <tr class="sbody">
							  <td width='15%' class="<%=nameColor%>" >撤銷文號</td>
							  <td width='85%' class="<%=textColor%>">農授金字第<input id="doc_no" name="doc_no" />號函</td>
                          </tr>
                          
                          <tr class="sbody">
							  <td width='15%' class="<%=nameColor%>" >撤銷項目</td>
							  <td width='85%' class="<%=textColor%>">
							  	<div id="revokeType"></div>
							  </td>
                          </tr>
                             
                          
                        </table>
                        <table id='editArea' width=560 border=1 align=center cellpadding="1" cellspacing="1" class="bordercolor">
                        </table>
                        </td>
                    </tr>
                     
                                     
                    <tr>                  
                		<td>
                		<%//登入者資訊 %>
                		<div align="right"><jsp:include page="getMaintainUser.jsp?width=560" flush="true" /></div></td>                                              
              		</tr>
              
              <tr> 
                <td><div align="center"> 
                    <table width="243" border="0" cellpadding="1" cellspacing="1">
                      <tr>                             
				        
                     <td width="66"> 
                     <div align="center">
	           			<a href="javascript:doInsert();" 
	           			   onMouseOut="MM_swapImgRestore()" 
	           			   onMouseOver="MM_swapImage('Image101','','images/bt_confirmb.gif',1)">
	           			   <img src="images/bt_confirm.gif" name="Image101" width="66" height="25" border="0" id="Image101">
	           			 </a>
           			 </div></td>
        			 <td width="66"> <div align="center">
	           			 <a href="javascript:doCancel();" 
	           			   onMouseOut="MM_swapImgRestore()" 
	           			   onMouseOver="MM_swapImage('Image101','','images/bt_cancelb.gif',1)">
	           			   <img src="images/bt_cancel.gif" name="Image101" width="66" height="25" border="0" id="Image101">
	           			 </a>
           			 </div></td>
                     <td width="80"><div align="center"><a href="javascript:goBack();"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image105" width="80" height="25" border="0" id="Image105"></a></div></td>
                      </tr>
                    </table>
                  </div></td>
              </tr>                               
      </table></td>
  </tr>

</table>
</form>
</body>

</html>

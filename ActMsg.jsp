<%
//94.02.15 fix 若actMsg屬於檔案上傳成功時,則回到上傳時的那一個頁面 by 2295
//94.10.31 fix 若actMsg在農漁會新增申報完成後，則顯示回到查詢頁 by 4180
//94.11.15 add 回查詢頁所要link的jsp名稱 by 2295
//94.11.23 add FR028W alert超過12個月份 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<%
	String Report_no = ( request.getParameter("Report_no")==null ) ? "" : (String)request.getParameter("Report_no");
	String S_YEAR = ( request.getParameter("S_YEAR")==null ) ? "" : (String)request.getParameter("S_YEAR");
	String S_MONTH = ( request.getParameter("S_MONTH")==null ) ? "" : (String)request.getParameter("S_MONTH");
	String loan_Item = ( request.getParameter("loan_Item")==null ) ? "" : (String)request.getParameter("loan_Item");
	String loan_Item_Name = ( request.getParameter("loan_Item_Name")==null ) ? "" : (String)request.getParameter("loan_Item_Name");
	//94.11.15 add 回查詢頁所要link的jsp名稱 
	String goPages = ( request.getParameter("goPages")==null ) ? "" : (String)request.getParameter("goPages");
	String bank_code = ( request.getParameter("bank_code")==null ) ? "" : (String)request.getParameter("bank_code");
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");
	
  //取得是否為農漁會新增資料程式
  String FX = ( request.getParameter("FX")==null ) ? "" : (String)request.getParameter("FX");
	String actMsg = ( request.getAttribute("actMsg")==null ) ? "" : (String)request.getAttribute("actMsg");
	String alertMsg = ( request.getAttribute("alertMsg")==null ) ? "" : (String)request.getAttribute("alertMsg");
	String webURL_Y = ( request.getAttribute("webURL_Y")==null ) ? "" : (String)request.getAttribute("webURL_Y");
	String webURL_N = ( request.getAttribute("webURL_N")==null ) ? "" : (String)request.getAttribute("webURL_N");
	System.out.println("actMsg="+actMsg);
	System.out.println("alertMsg="+alertMsg);
	System.out.println("webURL_Y="+webURL_Y);
	System.out.println("webURL_N="+webURL_N);

%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<HTML>
<HEAD>
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
function rtnEditPage(form){
	history.back();
}
//-->
</script>
</HEAD>
<form method=post name="Msgform">
<%if(!webURL_N.equals("")){      
%>
<BODY onLoad="javascript:ConfirmMsg(this.document.Msgform,'<%=alertMsg%>','<%=webURL_Y%>','<%=webURL_N%>')">
<%}else if(alertMsg.equals("Over12Month")){/*FR028W超過12個月*/%>
<BODY onLoad="javascript:AlertMsg(this.document.Msgform,'查詢月份超過12個月','<%=webURL_Y%>')">
<%}else{%>
<BODY onLoad="javascript:AlertMsg(this.document.Msgform,'<%=alertMsg%>','<%=webURL_Y%>')">
<%}%>
<%= actMsg %>
<% if(alertMsg.equals("")){ %>
<center>
<tr class="sbody">
<%if(actMsg.indexOf("檔案上傳成功") != -1){%>
<div><a href='/pages/WMFileUpload.jsp?act=new&Report_no=<%=Report_no%>&S_YEAR=<%=S_YEAR%>&S_MONTH=<%=S_MONTH%>&test=nothing' onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image8','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image8" width="80" height="25" border="0"></a></div>
<%//若農漁會新增資料，則可回查詢頁
}else if(FX.indexOf("FX") != -1){%>
<div><a href='/pages/<%=FX%>.jsp?act=List' onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image8','','images/bt_05b.gif',1)"><img src="images/bt_05.gif" name="Image8" width="80" height="25" border="0"></a></div>
<%}else if(!goPages.equals("")){ //94.11.15 add 回查詢頁的link%>
	<div>
	<%if("FL004W.jsp".equals(goPages)){ %>
	<input type='button' value='回原建檔畫面季新增個案缺失' onClick='rtnEditPage(form)'>
	<a href='/pages/<%=goPages%>?act=<%=act%>&bank_No=<%=(String)request.getParameter("bank_No")%>&ex_Type=<%=(String)request.getParameter("ex_Type")%>&ex_No=<%=(String)request.getParameter("ex_No")%>&def_Seq=<%=(String)request.getParameter("def_Seq")%>' onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image8','','images/bt_05b.gif',1)"><img src="images/bt_05.gif" name="Image8" width="80" height="25" border="0"></a>
	<%}else if(!"".equals(loan_Item)){ //TM001W%>
	<a href='/pages/<%=goPages%>?act=<%=act%>&loan_Item=<%=loan_Item%>&loan_Item_Name=<%=loan_Item_Name%>&test=nothing' onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image8','','images/bt_05b.gif',1)"><img src="images/bt_05.gif" name="Image8" width="80" height="25" border="0"></a>
	<%}else{ %>
	<a href='/pages/<%=goPages%>?act=<%=act%>&Report_no=<%=Report_no%>&bank_code=<%=bank_code%>&S_YEAR=<%=S_YEAR%>&S_MONTH=<%=S_MONTH%>&loan_Item=<%=loan_Item%>&loan_Item_Name=<%=loan_Item_Name%>&test=nothing' onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image8','','images/bt_05b.gif',1)"><img src="images/bt_05.gif" name="Image8" width="80" height="25" border="0"></a>
	<%} %>
	</div>
<%}else{%>
<div><a href="javascript:history.back();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image8','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image8" width="80" height="25" border="0"></a></div>
<%}%>
<tr>
<%}%>
</form>
</BODY>

</HTML>





<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.URLEncoder" %>
<% 
	String actMsg = ( request.getAttribute("actMsg")==null ) ? "" : (String)request.getAttribute("actMsg");
	String prePageURL = ( request.getAttribute("prePageURL")==null ) ? "" : (String)request.getAttribute("prePageURL");
	String queryURL = ( request.getAttribute("queryURL")==null ) ? "" : (String)request.getAttribute("queryURL");
	String alertMsg = ( request.getAttribute("alertMsg")==null ) ? "" : (String)request.getAttribute("alertMsg");
	String webURL_Y = ( request.getAttribute("webURL_Y")==null ) ? "" : (String)request.getAttribute("webURL_Y");	
	String webURL_N = ( request.getAttribute("webURL_N")==null ) ? "" : (String)request.getAttribute("webURL_N");	
	System.out.println("actMsg="+actMsg);
	System.out.println("alertMsg="+alertMsg);
	System.out.println("webURL_Y="+webURL_Y);	
	System.out.println("webURL_N="+webURL_N);	
	System.out.println("prePageURL="+prePageURL);

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
//-->
</script>
</HEAD>
<form method=post name="Msgform">
<%if(!webURL_Y.equals("")){%>
<BODY onLoad="javascript:ConfirmMsg(this.document.Msgform,'<%=alertMsg%>','<%=webURL_Y%>','<%=webURL_N%>')">
<%}else{%>
<BODY onLoad="javascript:AlertMsg(this.document.Msgform,'<%=alertMsg%>','<%=webURL_Y%>')">
<%}%>
<br>
<center>
<FONT COLOR="#0000FF">
<%= actMsg %>
</FONT>
<center>
<br>
<br>
<br>
<br>
<% if(alertMsg.equals("")){ 
       if(!queryURL.equals("")) {%>
<center>
<tr class="sbody">
<div><a href="<%=queryURL%>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image8','','images/bt_05b.gif',1)"><img src="images/bt_05.gif" name="Image8" width="80" height="25" border="0"></a>
     <a href="<%=prePageURL.equals("") ? "javascript:history.back()" : "javascript:location.replace('" + prePageURL +"');" %>" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image8','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image8" width="80" height="25" border="0"></a>
     
</div>
<tr>
       
       <% } else {%>   
<center>
<tr class="sbody">
<div><a href="javascript:history.back();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image8','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image8" width="80" height="25" border="0"></a></div>
<tr>
<% } %>
<%}%>
</form>
</BODY>

</HTML>



 

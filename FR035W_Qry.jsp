<%
//95.01.04 create  by lilic0c0 4183
//99.11.04 fix 報表介面 by 2295
//108.05.28 add 報表格式挑選 by rock.tsai
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>

<%
	Map dataMap =Utility.saveSearchParameter(request);
	String report_no = "FR035W";
	String bank_type = Utility.getTrimString(dataMap.get("bank_type"));	
	String YEAR  = Utility.getYear();
   	int MONTH = Integer.parseInt(Utility.getMonth());
%>

<link href="css/b51.css" rel="stylesheet" type="text/css">
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
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

function MM_jumpMenu(targ,selObj,restore){ //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}

function doSubmit(){
   if(!confirm("本項報表會執行3~5秒，是否確定執行？"))
   		return;
   this.document.forms[0].action = "/pages/FR035W_Excel.jsp";
   this.document.forms[0].target = '_self';
   this.document.forms[0].submit();
}

//-->
</script>

<head>
</head>

<html>
<body>

<form method=post action='#'>

<input type=hidden name="bank_type" value="<%= bank_type %>" >

<table width='600' border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
     <td>&nbsp;</td>
  </tr>
  <tr>
    <td width="10%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
    <td width="80%"><font color='#000000' size=4><b><center>全國各<%=((bank_type.equals("6"))?"農會":"漁會")%><%=Utility.getPgName(report_no)%></center></b></font></td>
    <td width="10%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
  </tr>
</table>
<Table border=1 width='600' align=center height="65" bgcolor="#FFFFF" bordercolor="#76C657">
<tr class="sbody" bgcolor="#BDDE9C">
    <td colspan="2" height="1">
      <div align="right">
       <input type='radio' name="act" value='download' checked>下載報表  
       <%if(Utility.getPermission(request,report_no,"P")){//Print %> 
       <a href="javascript:doSubmit('createRpt')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image411','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image411" width="66" height="25" border="0" id="Image41"></a>
       <%}%>
       <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image511','','images/bt_cancelb.gif',0)"><img src="images/bt_cancel.gif" name="Image511" width="66" height="25" border="0" id="Image51"></a>
       <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image611','','images/bt_reporthelpb.gif',1)"><img src="images/bt_reporthelp.gif" name="Image611" width="80" height="25" border="0" id="Image61"></a>
      </div>
    </td>
</tr>
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">查詢日期</td>
    <td width="416" bgcolor="#EBF4E1" height="1">
     <input type='text' name='S_YEAR' value="<%=YEAR%>" size='3' maxlength='3' onblur='CheckYear(this)'>
     <font color='#000000'>年</font>
     <select id="hide1" name='S_MONTH'>
     	<option></option>
     	<% for (int j = 1; j <= 4; j++) {%>
     	  <option value=<%=j%> <% if((((MONTH+15)/4))%4+1==j) out.print("selected");%>><%=j%></option>
     	<%}%>
     </select><font color='#000000'>季</font>
    </td>
</tr>
<tr class="sbody">
    <td width="118" bgcolor="#BDDE9C" height="1">金額單位</td>
    <td width="416" bgcolor="#EBF4E1" height="1">
      <select size="1" name="Unit">
        <option value ='1' selected>元</option>
        <option value ='1000'>千元</option>
        <option value ='10000'>萬元</option>
        <option value ='1000000'>百萬元</option>
        <option value ='10000000'>千萬元</option>
        <option value ='100000000'>億元</option>
      </select>
    </td>
</tr>
<%@include file="./include/rpt_style.include" %><!--報表格式挑選--> 
</Table>
<table border="1" width="600" align="center" height="54" bgcolor="#FFFFF" bordercolor="#76C657">
  <tr>
  	<td bgcolor="#E9F4E3" colspan="2">
       <div align="center">
  		<table width="555" border="0" cellpadding="1" cellspacing="1">
  		<tr>
            <td width="34"><img src="images/print_1.gif" width="34" height="34"></td>
            <td width="222"><font color="#CC6600">本報表採用A4紙張橫印</font></td>
          </tr>
        </table>
        </div>
    </td>
  </tr>  
</table>   

</form>

</body>
</html>

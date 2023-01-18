<%
//98.06.09 create 信用部主任及分部主任參訓情形總表 by 2660
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Calendar" %>
<%
  Calendar rightNow = Calendar.getInstance();
  Calendar now = Calendar.getInstance();
  String YEAR  = String.valueOf(now.get(Calendar.YEAR)-1911); //回覆值為西元年故需-1911取得民國年;
  String MONTH = String.valueOf(now.get(Calendar.MONTH)+1);
  if(MONTH.equals("1")){//若本月為1月份是..則是申報上個年度的12月份
    YEAR = String.valueOf(Integer.parseInt(YEAR) - 1);
    MONTH = "12";
  }else{    
    MONTH = String.valueOf(Integer.parseInt(MONTH) - 1);//申報上個月份的
  }

  String bank_type = ( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");			    	
  String title=(bank_type.equals("6"))?"農會":"漁會";

  //取得FR056W的權限
  Properties permission = ( session.getAttribute("FR056W")==null ) ? new Properties() : (Properties)session.getAttribute("FR056W"); 
  if(permission == null){
    System.out.println("FR056W_Qry.permission == null");
  }else{
    System.out.println("FR056W_Qry.permission.size ="+permission.size());               
  }
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
  <head>
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
  if (confirm("本項報表會報行10-15秒，是否確定執行？")) {
    this.document.forms[0].action = "/pages/FR056W_Excel.jsp";	
    this.document.forms[0].target = '_self';
    this.document.forms[0].submit();
  }
}
//-->
    </script>
    <link href="css/b51.css" rel="stylesheet" type="text/css">
  </head>
  <body leftmargin="0" topmargin="21">
    <form method=post action='#'>
      <input type=hidden name="bank_type" value="<%=bank_type %>" >
      <table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr> 
          <td width="150"><img src="images/banner_bg1.gif" width="150" height="17"></td>
          <td width="*"><font color='#000000' size=4> 
            <center><font color="#336600">信用部主任及分部主任參訓情形總表</font></center></font>
          </td>
          <td width="150"><img src="images/banner_bg1.gif" width="150" height="17"></td>
        </tr>
      </table>
      <div><img src="images/space_1.gif" width="14" height="14"/></div>
      <center>
        <div style="width=600;border-width:1px;border-color:#5DA525;border-style:solid;padding=1px">
          <table width="600" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#E9F4E3">
            <tr>
              <td bgcolor="#B0D595" class="sbody" align="right">
                <div style="display:inline">
                  <!--input type='radio' name="act" value='view' checked>檢視報表-->
                  <input type='radio' name="act" value='download' checked>下載報表
                </div>
                <div style="vertical-align:middle;display:inline">
<%
  if (permission != null && permission.get("P") != null && permission.get("P").equals("Y")) { //Print
%>                   	        	                                   		     			                               
                  <a href="javascript:doSubmit()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image411','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image411" width="66" height="25" border="0" id="Image41"></a> 
<%}%>
                  <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image511','','images/bt_cancelb.gif',0)"><img src="images/bt_cancel.gif" name="Image511" width="66" height="25" border="0" id="Image51"></a> 
                  <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image611','','images/bt_reporthelpb.gif',1)"><img src="images/bt_reporthelp.gif" name="Image611" width="80" height="25" border="0" id="Image61"></a> 
                </div>
              </td>
            </tr>

             <tr class="sbody">
              <td>
                <img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">查詢年月 :</span> 						  						
                <input type='text' name='S_YEAR' value="<%=YEAR%>" size='3' maxlength='3' onblur='CheckYear(this)'>
                <font color='#000000'>年</font>
                <select id="hide1" name='S_MONTH'>
                  <option></option>
<%
  for (int j = 1; j <= 12; j++) {
    if (j < 10) {
%>        	
                  <option value=0<%=j%> <%if(Integer.parseInt(MONTH)==j) out.print("selected");%>>0<%=j%></option>        		
<%
    } else {
%>
                  <option value=<%=j%> <%if(Integer.parseInt(MONTH)==j) out.print("selected");%>><%=j%></option>
<%
    }
  }
%>
                </select><font color='#000000'>月</font>
              </td>
            </tr>
            <tr class="sbody">
              <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">輸出格式 :</span>
                  <input name='printStyle' type='radio' value='xls' checked>Excel
                  <input name='printStyle' type='radio' value='ods' >ODS
                  <input name='printStyle' type='radio' value='pdf' >PDF
			  </td>
            </tr>     
            <tr> 
              <td bgcolor="#E9F4E3">
                <div style="margin:30px;vertical-align:middle;display:inline">
                  <img src="images/print_1.gif" width="34" height="34">
                </div>
                <div style="display:inline">
                  <font color="#CC6600">本報表採用A4紙張橫印</font>
                </div>
              </td>
            </tr>
          </table>
        </div>
      </center>
    </form>
  </body>
</html>
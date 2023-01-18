<%
//101.1.9 create 全體農(漁)會信用部聯合貸款案件彙總表 by 2968
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.tradevan.util.*" %>
<%@ page import="java.util.*" %>

<%
	String report_no = "FR064W";
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
 	//String title="全體"+((bank_type.equals("6"))?"農會":"漁會")+"信用部聯合貸款案件彙總表";
 	String title = "全體農漁會信用部聯合貸款案件彙總表";
 	//取得FR064W的權限
	Properties permission = ( session.getAttribute("FR064W")==null ) ? new Properties() : (Properties)session.getAttribute("FR064W"); 
	if(permission == null){
       System.out.println("FR064W_Qry.permission == null");
    }else{
       System.out.println("FR064W_Qry.permission.size ="+permission.size());               
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
   /*
   var tmp_year,tmp_month;
   tmp_year = parseInt(this.document.forms[0].S_YEAR.value);
   tmp_month = parseInt(this.document.forms[0].S_MONTH.value);
   alert(this.document.forms[0].S_MONTH.value);
   alert(tmp_month);
   alert(tmp_year * 100 + tmp_month);
   if( tmp_year * 100 + tmp_month < 9406){
      alert('94年6月起開始受理申報資料');
      return;
   } 
   */	 
   if(confirm("本項報表會報行10-15秒，是否確定執行？"))
   {
   this.document.forms[0].action = "/pages/FR064W_Excel.jsp";	
   this.document.forms[0].target = '_self';
   this.document.forms[0].submit();   
	}
}

//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form method=post action='#'>
<input type=hidden name="bank_type" value=<%=bank_type%>>
<input type=hidden name="showEng">

  
  <table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
     <td>&nbsp;</td>
  </tr>
        <tr>
            <td width="18%"><img src="images/banner_bg1.gif" width="110" height="17"></td>
            <td width="68%"><font color='#000000' size=4>
            <center><font color="#336600"><%=title%></font>
            </center>
            </font> </td>
                <td width="15%"><img src="images/banner_bg1.gif" width="110" height="17"></td>
        </tr>
  </table>
  <table border=1 width='600' align=center bgcolor="#FFFFF" bordercolor="#76C657">
		<tr class="sbody" bgcolor="#BDDE9C">
		    <td colspan="2" height="1">
		      <div align="right">
		      <input type='radio' name="act" value='download' checked>下載報表  
		      <%if(Utility.getPermission(request,report_no,"P")){//Print %> 
              <a href="javascript:doSubmit()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image411','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image411" width="66" height="25" border="0" id="Image41"></a> 
              <%}%>
              <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image511','','images/bt_cancelb.gif',0)"><img src="images/bt_cancel.gif" name="Image511" width="66" height="25" border="0" id="Image51"></a> 
              <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image611','','images/bt_reporthelpb.gif',1)"><img src="images/bt_reporthelp.gif" name="Image611" width="80" height="25" border="0" id="Image61"></a> 
              </div>
		    </td>
		</tr>
        <tr class="sbody">
            <td width="118" bgcolor="#BDDE9C" height="1">查詢日期</td>
            <td width="416" bgcolor="#EBF4E1" height="1">
            <input type='text' name='S_YEAR' value="<%=YEAR%>" size='3' maxlength='3' onblur='CheckYear(this)'><font color='#000000'>年
        	<select id="hide1" name=S_MONTH >        						
				<%for (int j = 1; j <= 12; j++) {
                	if (j < 10){%>
        				<option value=0<%=j%> <%if(MONTH.equals(String.valueOf(j))) out.print("selected");%>>0<%=j%></option>
            		<%}else{%>
            			<option value=<%=j%> <%if(MONTH.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            		<%}//end of else%>
        		<%}//end of for%>
        	</select><font color='#000000'>月</font></td>
         </tr>

         <tr class="sbody">
         	<td width="118" bgcolor="#BDDE9C" height="1">金額單位</td>
			<td width="416" bgcolor="#EBF4E1" height="1">
            <select size="1" name="Unit" >
        		<option value="1">元</option>
                <option value="1000" selected>千元</option>
                <option value="10000">萬元</option>
                <option value="1000000">百萬元</option>
                <option value="10000000">仟萬元</option>
                <option value="100000000">億元</option>
            </select></td>
         </tr>
 		 <%@include file="./include/rpt_style.include" %><!--報表格式挑選-->
	</table>
	<table border="1" width="600" align="center" height="54" bgcolor="#FFFFF" bordercolor="#76C657">
		<tr>
  			<td bgcolor="#E9F4E3" colspan="2">
       		<div align="center">
  				<table width="574" border="0" cellpadding="1" cellspacing="1">
  					<tr>
  						<td width="34"><img src="images/print_1.gif" width="34" height="34"></td>
            			<td width="492"><font color="#CC6600">本表採用A4紙張橫印</font></td>                              
        			</tr>
        		</table>
        	</div></td>
  		</tr>  
	</table>
</form>
<%System.out.println("FR064W_Qry.jsp Program End...");%>
</body>
</html>

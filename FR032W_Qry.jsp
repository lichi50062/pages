<%
//94.03.11	調整查詢畫面左靠處理(調整width="600")
//94.08.15  add Office 2003版Excel現僅提供「下載報表」功能 
// 94.09.05 fix 拿掉檢視報表 by 2295
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%     
   //2005 09 15 fix timeout by 2495 取得session資料,取得成功時,才繼續往下執行===================================================
   RequestDispatcher rd = null;	
   if(session.getAttribute("muser_id") == null){//session timeout		
      System.out.println("FR032W login timeout");   
	   rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );         	   
	   try{
          rd.forward(request,response);
       }catch(Exception e){
          System.out.println("forward Error:"+e+e.getMessage());
       }
   }

%>
<%
	Calendar rightNow = Calendar.getInstance();
	String S_YEAR = String.valueOf(rightNow.get(Calendar.YEAR)-1911);
	String S_MONTH = "01";
	if (S_MONTH.length()==1) S_MONTH="0"+S_MONTH;
	String E_YEAR = String.valueOf(rightNow.get(Calendar.YEAR)-1911);
	String E_MONTH = String.valueOf(rightNow.get(Calendar.MONTH)+1);
	if (E_MONTH.length()==1) E_MONTH="0"+E_MONTH;
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

function chInput(form){
	if(!checkDateS(form.S_YEAR,form.S_MONTH,'查詢年月','1')) return;
	if(form.S_YEAR.value+form.S_MONTH.value > '<%=E_YEAR+E_MONTH%>' ){
		alert('查詢年月不可大於目前月份');
		return;
	}
	form.submit();
}

//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form name='FR032W' method=post action='FR032W_Excel.jsp'>
<table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
    <td bgcolor="#FFFFFF">
<table width="600" border="0" align="center" cellpadding="1" cellspacing="1">
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td><table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="50"><img src="images/banner_bg1.gif" width="150" height="17"></td>
                <td width="300"><font color='#000000' size=4> 
                  <center>
                    <font color="#336600">農業信用保證基金業務統計(二)</font>
                  </center>
                  </font> </td>
                <td width="50"><img src="images/banner_bg1.gif" width="150" height="17"></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td><img src="images/space_1.gif" width="8" height="8"></td>
        </tr>
        <tr> 
          <td><table width="600" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#5DA525">
              <tr> 
                <td bordercolor="#E9F4E3" bgcolor="#E9F4E3"><table width="600" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#E9F4E3">
                    <tr> 
                      <td bgcolor="#B0D595" class="sbody"> <div align="right">
                          <!--input type='radio' name="act" value='view' checked>檢視報表-->
                      	  <input type='radio' name="act" value='download' checked> 下載報表                         
                          <a href="javascript:chInput(FR032W);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image411','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image411" width="66" height="25" border="0" id="Image41"></a> 
                          <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image511','','images/bt_cancelb.gif',0)"><img src="images/bt_cancel.gif" name="Image511" width="66" height="25" border="0" id="Image51"></a> 
                          <!--<a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image611','','images/bt_reporthelpb.gif',1)"><img src="images/bt_reporthelp.gif" name="Image611" width="80" height="25" border="0" id="Image61"></a> -->
                        </div></td>
                    </tr>

                           <tr class="sbody">
                          <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">查詢年月 :</span>
                            <input type='text' name='S_YEAR' value="<%=S_YEAR%>" size='3' maxlength='3' onblur='CheckYear(this)'>
        						<font color='#000000'>年
        						<select id="hide1" name=S_MONTH>
        						<option></option>
        						<%
        							for (int j = 1; j <= 12; j++) {
        							if (j < 10){%>        	
        							<option value=0<%=j%> <%if(Integer.parseInt(S_MONTH)==j) out.print("selected");%>>0<%=j%></option>        		
            						<%}else{%>
            						<option value=<%=j%> <%if(Integer.parseInt(S_MONTH)==j) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select><font color='#000000'>月</font>
                            </td>
                          </tr>                         
                                 
                    </tr>
                    <!--tr> 
                      <td bgcolor="#E9F4E3"> <table width="580" border="0" align="center" cellpadding="0" cellspacing="0">
                          <tr class="sbody">
                            <td class="sbody"><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">是否加上列印日期 :</span> 						  						
                              <input type='radio' name='datestate' value="1">加註列印日期
                              <input type='radio' name='datestate' value="0">不加註列印日期
                            </td>
                          </tr>                         
                          <tr><td><br></td></tr>
                        </table></td>                        
                    </tr-->
                    <tr class="sbody">
                      <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">輸出格式 :</span>
                          <input name='printStyle' type='radio' value='xls' checked>Excel
                          <input name='printStyle' type='radio' value='ods' >ODS
                          <input name='printStyle' type='radio' value='pdf' >PDF
		              </td>
                    </tr> 
                    <tr> 
                      <td bgcolor="#E9F4E3"><div align="center">
                          <table width="555" border="0" cellpadding="1" cellspacing="1">
                            <tr> 
                              <td width="34"><img src="images/print_1.gif" width="34" height="34"></td>
                              <td width="222"><font color="#CC6600">本報表採用A4紙張直印</font></td>
                              <!--td width="293" align=right><font color="red" size=2>註:Office 2003版Excel現僅提供「下載報表」功能</font></td-->                              
                            </tr>                            
                          </table>
                        </div></td>
                    </tr>
                       </table></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td height="50">&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</form>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
</body>
</html>

<%
// 94.09.09 fix 拿掉檢視報表 by 2295
//108.05.28 add 報表格式挑選 by rock.tsai
//108.06.11 fix 報表格式挑選 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");
	String reportno = ( request.getParameter("SZREPORTNO")==null ) ? "" : (String)request.getParameter("SZREPORTNO");
	String BASE_DATE_BEG_Y = ( request.getParameter("BASE_DATE_BEG_Y")==null ) ? "" : (String)request.getParameter("BASE_DATE_BEG_Y");

	System.out.println("TC36_Qry.jsp Start...");
	System.out.println("act="+act);
	System.out.println("reportno="+reportno);
	System.out.println("BASE_DATE_BEG_Y="+BASE_DATE_BEG_Y);
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

function doSubmit_1(cnd,reportno,BASE_DATE_BEG_Y){
   this.document.forms[0].action = "/pages/TC36_Excel.jsp?act="+cnd+"&reportno="+reportno+"&test=nothing"+"&BASE_DATE_BEG_Y="+BASE_DATE_BEG_Y;
   this.document.forms[0].target = '_self';
   this.document.forms[0].submit();
}

//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0">
<form method=post action='#'>
<table width="780" border="0" align="left" cellpadding="0" cellspacing="0">
  <tr>
    <td bgcolor="#FFFFFF">
<table width="700" border="0" align="left" cellpadding="0" cellspacing="1">
        <tr>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td><table width="600" border="0" align="left" cellpadding="0" cellspacing="0">
              <tr>
                <td width="10"><img src="images/banner_bg1.gif" width="90" height="17"></td>
                <td width="800"><font color='#000000' size=4>
                  <center>
                    <font color="#336600">金融業務檢查缺失改善情形報告表 </font>
                  </center>
                  </font> </td>
                <td width="100"><img src="images/banner_bg1.gif" width="90" height="17"></td>
              </tr>
            </table></td>
        </tr>
        <tr>
          <td><img src="images/space_1.gif" width="8" height="8"></td>
        </tr>
        <tr>
          <td><table width="600" border="1" align="left" cellpadding="0" cellspacing="0" bordercolor="#5DA525">
              <tr>
                <td bordercolor="#E9F4E3" bgcolor="#E9F4E3"><table width="600" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#E9F4E3">

                    <tr>
                      <td bgcolor="#B0D595" class="sbody"> <div align="right">
                          <!--input type='radio' name="excelaction" value='view' checked>檢視報表-->
                      	  <input type='radio' name="excelaction" value='download' checked> 下載報表
                      	  <a href="javascript:doSubmit_1('createRpt','<%=reportno%>','<%=BASE_DATE_BEG_Y %>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image411','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image411" width="66" height="25" border="0" id="Image41"></a>
                          <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image511','','images/bt_cancelb.gif',0)"><img src="images/bt_cancel.gif" name="Image511" width="66" height="25" border="0" id="Image51"></a>
                          <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image611','','images/bt_reporthelpb.gif',1)"><img src="images/bt_reporthelp.gif" name="Image611" width="80" height="25" border="0" id="Image61"></a>
                        </div></td>
                    </tr>
					<tr class="sbody">
                      <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">輸出格式 :</span>
                          <input name='printStyle' type='radio' value='xls' checked>Excel
                          <input name='printStyle' type='radio' value='ods' >ODS
                          <input name='printStyle' type='radio' value='pdf' >PDF
		              </td>
                    </tr> 
                    <tr>
                      <td bgcolor="#E9F4E3"><div align="center">
                          <table width="300" border="0" cellpadding="1" cellspacing="1">
                            <tr>
                              <td width="34"><img src="images/print_1.gif" width="34" height="34"></td>
                              <td width="539"><font color="#CC6600">本報表採用A4紙張橫印
                                </font></td>
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

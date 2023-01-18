<%
// 94.01.20 create by 2295
// 94.01.31 add 權限 by 2295
// 94.09.05 fix 拿掉檢視報表 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");					
	String bank_type = (session.getAttribute("nowbank_type")==null)?"":(String)session.getAttribute("nowbank_type");
	String title=(bank_type.equals("6"))?"農會":"漁會";
	String szSortBy = ( session.getAttribute("SortBy")==null ) ? "asc" : (String)session.getAttribute("SortBy");				
	System.out.println("szSortBy="+szSortBy);
	String szExcelAction = (session.getAttribute("excelaction")==null)?"download":(String)session.getAttribute("excelaction");
	System.out.println("FR0066WA_RptOrder.szExcelAction="+szExcelAction);
	//取得FR0066WA的權限
	Properties permission = ( session.getAttribute("FR0066WA")==null ) ? new Properties() : (Properties)session.getAttribute("FR0066WA"); 
	if(permission == null){
       System.out.println("FR0066WA_RptOrder.permission == null");
    }else{
       System.out.println("FR0066WA_RptOrder.permission.size ="+permission.size());               
    }	
%>



<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/FR0066WA.js"></script>
<script language="javascript" src="js/BRUtil.js"></script>
<script language="javascript" src="js/movesels.js"></script>
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

function doSubmit(cnd){
    if(cnd == 'createRpt'){
      if(this.document.forms[0].BankList.value == ''){        
         alert('金融機構代碼必須選擇');
         return;
      }
    
      if(this.document.forms[0].btnFieldList.value == ''){
         alert('報表欄位必須選擇');
         return;
      }
   }   
   MoveSelectToBtn(this.document.forms[0].SortList, this.document.forms[0].SortListDst);	
   fn_ShowPanel(cnd);      
}
function ResetAllData(){
    if(confirm("確定要清除已選定的資料嗎？")){  	
        this.document.forms[0].SortListDst.length = 0;
        getbtnFieldList();    	
	}
	return;	
}
//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form method=post action='#' name='RptOrderfrm'>
<table width="780" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
     <td>&nbsp;</td>
  </tr>
  <tr> 
    <td bgcolor="#FFFFFF">
	<table width="780" border="0" align="center" cellpadding="1" cellspacing="1">        
        <tr> 
          <td><table width="780" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="220"><img src="images/banner_bg1.gif" width="220" height="17"></td>
                <td width="340"><font color='#000000' size=4> 
                  <center>
                    <font color="#336600"><%=title%>信用部違反法定比率規定分析明細表</font>
                  </center>
                  </font> </td>
                <td width="220"><img src="images/banner_bg1.gif" width="220" height="17"></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td><img src="images/space_1.gif" width="8" height="8"></td>
        </tr>
        <tr> 
          <td><table width="780" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#5DA525">
              <tr> 
                <td bordercolor="#E9F4E3" bgcolor="#E9F4E3"><table width="700" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#E9F4E3">
                    <tr> 
                      <td bgcolor="#B0D595" class="sbody"> <div align="right">
                          <!--input type='radio' name="excelaction" value='view' <%if(szExcelAction.equals("view")){out.print("checked");}%> >檢視報表-->
                      	  <input type='radio' name="excelaction" value='download' <%if(szExcelAction.equals("download")){out.print("checked");}%> >下載報表
                          <%if(permission != null && permission.get("P") != null && permission.get("P").equals("Y")){//Print %>                   	        	                                   		     			        
                      	  <a href="javascript:doSubmit('createRpt');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image411','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image411" width="66" height="25" border="0" id="Image41"></a> 
                      	  <%}%>
                          <a href="javascript:ResetAllData();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image511','','images/bt_cancelb.gif',0)"><img src="images/bt_cancel.gif" name="Image511" width="66" height="25" border="0" id="Image51"></a> 
                          <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image611','','images/bt_reporthelpb.gif',1)"><img src="images/bt_reporthelp.gif" name="Image611" width="80" height="25" border="0" id="Image61"></a> 
                        </div></td>
                    </tr>
                    <tr> 
                      <td bgcolor="#CDE6BF"> <table width="700" border="0" align="center" cellpadding="1" cellspacing="1" class="sbody">
                          <tr class="sbody"> 
                            <td width="100"><a href="javascript:doSubmit('BankList')"><font color='black'>1.金融機構</font></a></td>                            
                            <td width="100"><a href="javascript:doSubmit('RptColumn')"><font color='black'>2.報表欄位</font></a></td>
                            <td width="100"><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"> 
                              <a href="#"><font color="#CC6600">3.排序欄位</font></a></td>                                                       
                            <td width="100"><a href="javascript:doSubmit('RptStyle')"><font color='black'>4.報表格式</font></a></td>
                          </tr>
                        </table></td>
                    </tr>
                    <tr> 
                      <td bgcolor="#E9F4E3"> <table width="779" border="0" align="center" cellpadding="1" cellspacing="1" bgcolor="#E9F4E3">
                          <tr> 
                            <td width="195">  
                            <select multiple  size=10  name="SortListSrc" ondblclick="javascript:movesel(this.document.forms[0].SortListSrc,this.document.forms[0].SortListDst);" style="width: 300 ; font-size: 8pt">							
							</select>
                            </td>
                            <td width="52"><table width="40" border="0" align="center" cellpadding="3" cellspacing="3">
                                <tr> 
                                  <td>
                                  <div align="center">                                 
                                  <a href="javascript:movesel(this.document.forms[0].SortListSrc,this.document.forms[0].SortListDst);"><img src="images/arrow_right.gif" width="24" height="22" border="0"></a>
                                  </div>
                                  </td>
                                </tr>
                                <tr> 
                                  <td>
                                  <div align="center">                                  
                                  <a href="javascript:moveallsel(this.document.forms[0].SortListSrc,this.document.forms[0].SortListDst);"><img src="images/arrow_rightall.gif" width="24" height="22" border="0"></a>
                                  </div>
                                  </td>
                                </tr>
                                <tr> 
                                  <td>
                                  <div align="center">                                  
                                  <a href="javascript:movesel(this.document.forms[0].SortListDst,this.document.forms[0].SortListSrc);"><img src="images/arrow_left.gif" width="24" height="22" border="0"></a>
                                  </div>
                                  </td>
                                </tr>
                                <tr> 
                                  <td height="22">
                                  <div align="center">                                  
                                  <a href="javascript:moveallsel(this.document.forms[0].SortListDst,this.document.forms[0].SortListSrc);"><img src="images/arrow_leftall.gif" width="24" height="22" border="0"></a>
                                  </div>
                                  </td>
                                </tr>
                              </table></td>
                            <td width="189"> 
                           <select multiple size=10  name="SortListDst" ondblclick="javascript:movesel(this.document.forms[0].SortListDst,this.document.forms[0].SortListSrc);" style="width: 300 ; font-size: 8pt">							
							</select>
                           
                            </td>
                            <td width="130"><table width="116" border="0" align="center" cellpadding="3" cellspacing="3">
                                <tr>                                   
                                  <td width="24"><div align="center"><a href="javascript:moveup(this.document.forms[0].SortListDst);"><img src="images/arrow_up.gif" width="24" height="22" border="0"></a></div></td>                        				        
                                  <td width="71" class="sbody">欄位上移</td>
                                </tr>
                                <tr> 
                                  <td width="24"><div align="center"><a href="javascript:movedown(this.document.forms[0].SortListDst);"><img src="images/arrow_down.gif" width="24" height="22" border="0"></a></div></td>                        				        
                                  <td class="sbody">欄位下移</td>
                                </tr>
                                <tr> 
                                  <td colspan=2 class="sbody"><div align="left"><input type="radio" name="SortBy" value="asc" 
                                  <%if(szSortBy.equals("asc")) out.print("checked");%>
                                  >遞增排序</div></td>                        				                                          
                                </tr>
                                <tr> 
                                  <td colspan=2 class="sbody"><div align="left"><input type="radio" name="SortBy" value="desc"
                                  <%if(szSortBy.equals("desc")) out.print("checked");%>
                                  >遞減排序</div></td>                        				                                          
                                </tr>
                              </table></td>
                          </tr>
                        </table></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
        </tr>        
      </table>
    </td>
  </tr>
</table>
<INPUT type="hidden" name=SortList><!--//btnSortList儲存已勾選的報表排序欄位名稱-->
<INPUT type="hidden" name=btnFieldList value='<%if(session.getAttribute("btnFieldList") != null) out.print((String)session.getAttribute("btnFieldList"));%>'><!--//btnFieldList儲存已勾選的報表欄位名稱-->
<INPUT type="hidden" name=BankList value='<%if(session.getAttribute("BankList") != null) out.print((String)session.getAttribute("BankList"));%>'><!--//BankList儲存已勾選的金融機構-->
</form>
<script language="JavaScript" >
<!--  

<%//從session裡把勾選的欲sort的報表欄位讀出來.放在SortListDst 	
if(session.getAttribute("SortList") != null && !((String)session.getAttribute("SortList")).equals("")){ 
%>
	var bnlist;
	bnlist = '<%=(String)session.getAttribute("SortList")%>';
	var a = bnlist.split(',');
	for (var i =0; i < a.length; i ++){
		var j = a[i].split('+');
		this.document.forms[0].SortListDst.options[i] = new Option(j[1], j[0]);
	}
<%}%>

<%//從session裡把已勾選的報表欄位讀出來.放在FieldListDst 	
if(session.getAttribute("btnFieldList") != null && !((String)session.getAttribute("btnFieldList")).equals("")){ 
   System.out.println("FR0066WA_RptOrder.btnFieldList="+(String)session.getAttribute("btnFieldList"));
%>
	getbtnFieldList();
<%}%>
function getbtnFieldList(){
	var bnlist;
	var checkAdd = false;
	var addCount = 0;		
	bnlist = '<%=(String)session.getAttribute("btnFieldList")%>';	
	<%
	session.setAttribute("SortList",null);//清除已勾選的欲sort的報表欄位
	%>
	var a = bnlist.split(',');
	for (var i =0; i < a.length; i ++){
		var j = a[i].split('+');
		checkAdd=false;
		for(var k =0;k<this.document.forms[0].SortListDst.length;k++){			
			if(this.document.forms[0].SortListDst.options[k].text == j[1]){		    
		   		checkAdd = true;			       
	    	}   
    	}
    	if(checkAdd == false){	       	       
       		this.document.forms[0].SortListSrc.options[addCount] = new Option(j[1], j[0]);
       		addCount++;
    	}	
	
	}
}
-->
</script>
</body>
</html>

<%
// 95/01/03 create by 4180
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");						
	String bank_type = (session.getAttribute("nowbank_type")==null)?"":(String)session.getAttribute("nowbank_type");
	String title=(bank_type.equals("6"))?"農會":"漁會";
	
	String szExcelAction = (session.getAttribute("excelaction")==null)?"download":(String)session.getAttribute("excelaction");
	System.out.println("FR036WA_BankList.szExcelAction="+szExcelAction);
	String hsien_id = ( session.getAttribute("HSIEN_ID")==null ) ? "ALL" : (String)session.getAttribute("HSIEN_ID");				
	System.out.println("FR036WA_BankList.hsien_id="+hsien_id);
	String sqlCmd = " select bn01.bn_type,wlx01.hsien_id,bn01.bank_no, bn01.bank_name from bn01,wlx01 "
			      + " where bank_type = ?";
	  
	List paramList = new ArrayList();
	paramList.add(bank_type);
	sqlCmd += " and bn01.bank_no = wlx01.bank_no "
		    + " order by wlx01.hsien_id,bn01.bank_no";
				  
    List tbankList = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");
    
    //取得FR036WA的權限
	Properties permission = ( session.getAttribute("FR036WA")==null ) ? new Properties() : (Properties)session.getAttribute("FR036WA"); 
	if(permission == null){
       System.out.println("FR036WA_BankList.permission == null");
    }else{
       System.out.println("FR036WA_BankList.permission.size ="+permission.size());               
    }	
    
    // XML Ducument for 總機構代碼 begin
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"TBankXML\">");
    out.println("<datalist>");
    for(int i=0;i< tbankList.size(); i++) {
        DataObject bean =(DataObject)tbankList.get(i);
        out.println("<data>");        
        out.println("<BnType>"+bean.getValue("bn_type")+"</BnType>");
        out.println("<HsienId>"+bean.getValue("hsien_id")+"</HsienId>");
        out.println("<bankValue>"+bean.getValue("bank_no")+"</bankValue>");
        out.println("<bankName>"+bean.getValue("bank_no")+bean.getValue("bank_name")+"</bankName>");
        out.println("</data>");
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 總機構代碼 end 	
    
   	//取得目前年月資料
	String S_YEAR = ( request.getParameter("S_YEAR")==null ) ? "" : (String)request.getParameter("S_YEAR");
	String S_MONTH = ( request.getParameter("S_MONTH")==null ) ? "" : (String)request.getParameter("S_MONTH");

	Calendar rightNow = Calendar.getInstance();
   	String YEAR  = String.valueOf(rightNow.get(Calendar.YEAR)-1911); //回覆值為西元年故需-1911取得民國年;
   	String MONTH = String.valueOf(rightNow.get(Calendar.MONTH)+1);   //月份以0開始故加1取得實際月份;
%>



<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/FR036WA.js"></script>
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
      if(this.document.forms[0].rptStyle.value ==1 && this.document.forms[0].BankListDst.length == 0){      	 
      	 alert('金融機構代碼必須選擇');
      	 return;
      }
   }   
   
   MoveSelectToBtn(this.document.forms[0].BankList, this.document.forms[0].BankListDst);	
   fn_ShowPanel(cnd);      
}

function ResetAllData(){
    if(confirm("確定要清除已選定的資料嗎？")){  	
        this.document.forms[0].BankListDst.length = 0;
        this.document.forms[0].HSIEN_ID[0].selected=true;	   
        changeOption(this.document.forms[0],'');
        clearBankList();
	}
	return;	
}
//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form method=post action='#' name='BankListfrm'>
<table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
     <td>&nbsp;</td>
  </tr>
  <tr> 
    <td bgcolor="#FFFFFF">
	<table width="600" border="0" align="center" cellpadding="1" cellspacing="1">        
        <tr> 
          <td><table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="150"><img src="images/banner_bg1.gif" width="200" height="17"></td>
                <td width="300"><font color='#000000' size=4> 
                  <center>
                    <font color="#336600">全體<%=title%>信用部統一貸款資料_指定單月新增戶數金額比較_明細表及總表</font>
                  </center>
                  </font> </td>
                <td width="150"><img src="images/banner_bg1.gif" width="200" height="17"></td>
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

                      	  <input type='radio' name="excelaction" value='download' <%if(szExcelAction.equals("download")){out.print("checked");}%> >下載報表
                      	  <%if(permission != null && permission.get("P") != null && permission.get("P").equals("Y")){//Print %>                   	        	                                   		     			        
                      	  <a href="javascript:doSubmit('createRpt');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image41','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image41" width="66" height="25" border="0" id="Image41"></a> 
                      	  <%}%>
                          <a href="javascript:ResetAllData();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image51','','images/bt_cancelb.gif',0)"><img src="images/bt_cancel.gif" name="Image51" width="66" height="25" border="0" id="Image51"></a> 
                          <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image61','','images/bt_reporthelpb.gif',1)"><img src="images/bt_reporthelp.gif" name="Image61" width="80" height="25" border="0" id="Image61"></a> 
                        </div></td>
                    </tr>
                   
					<%@include file="./include/rpt_style.include" %><!--報表格式挑選--> 
                 
                    <tr> 
                      <td bgcolor="#E9F4E3"> <table width="580" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr>
                     <td>
                    <img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">查詢年月 :</span>
                            <input type='text' name='S_YEAR' value="<%=YEAR%>" size='3' maxlength='3' onblur='CheckYear(this)'><font color='#000000'>年
        						<select id="hide1" name=S_MONTH >
        			
        						<%
                                        for (int j = 1; j <= 12; j++) {
                                         if (j < 10){%>
        								 <option value=0<%=j%> <%if(MONTH.equals(String.valueOf(j))) out.print("selected");%>>0<%=j%></option>
            							 <%}else{%>
            							 <option value=<%=j%> <%if(MONTH.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            							 <%}//end of else%>
        						<%}//end of for%>
        						</select><font color='#000000'>月</font>
                            </td>
                    </tr>
                     <tr>
                      <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">金額單位 :</span>
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
                    <tr>
<td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">報表格式 :</span>
                          <select size="1" name="rptStyle" onChange="checkflag()">                         
                             <option value ='1' selected>明細表</option>
                             <option value ='0' >總表</option>                            
                          </select>
		              </td>
</tr>            




          
                          <tr> 
                          <%   
                          List hsien_id_data = DBManager.QueryDB_SQLParam("select distinct hsien_id,hsien_name from cd01",null,""); 
                          %>
                            <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">縣市別 :</span>                                
                               <select name="HSIEN_ID" onchange="javascript:changeOption(document.forms[0],'');" >                               
                                <option value="ALL">全部</option>
                                <%for(int i=0;i<hsien_id_data.size();i++){%>                                
                                <option value="<%=String.valueOf(((DataObject)hsien_id_data.get(i)).getValue("hsien_id"))%>"
                                <%if((String.valueOf(((DataObject)hsien_id_data.get(i)).getValue("hsien_id")).equals(hsien_id))) out.print("selected");%>
                                ><%=String.valueOf(((DataObject)hsien_id_data.get(i)).getValue("hsien_name"))%></option>                            
                                <%}%>
                              </select>
                            </td>
                          </tr>





                          
                        </table></td>
                    </tr>
                    <tr> 
                      <td bgcolor="#E9F4E3"> <table width="579" border="0" align="center" cellpadding="1" cellspacing="1" bgcolor="#E9F4E3">
                          <tr> 
                            <td width="195">  
                            <select multiple  size=10  name="BankListSrc" ondblclick="javascript:movesel(this.document.forms[0].BankListSrc,this.document.forms[0].BankListDst);" style="width: 17em">							
							</select>
                            </td>
                            <td width="52"><table width="40" border="0" align="center" cellpadding="3" cellspacing="3">
                                <tr> 
                                  <td>
                                  <div align="center">                                 
                                  <a href="javascript:movesel(this.document.forms[0].BankListSrc,this.document.forms[0].BankListDst);"><img src="images/arrow_right.gif" width="24" height="22" border="0"></a>
                                  </div>
                                  </td>
                                </tr>
                                <tr> 
                                  <td>
                                  <div align="center">                                  
                                  <a href="javascript:moveallsel(this.document.forms[0].BankListSrc,this.document.forms[0].BankListDst);"><img src="images/arrow_rightall.gif" width="24" height="22" border="0"></a>
                                  </div>
                                  </td>
                                </tr>
                                <tr> 
                                  <td>
                                  <div align="center">                                  
                                  <a href="javascript:movesel(this.document.forms[0].BankListDst,this.document.forms[0].BankListSrc);"><img src="images/arrow_left.gif" width="24" height="22" border="0"></a>
                                  </div>
                                  </td>
                                </tr>
                                <tr> 
                                  <td height="22">
                                  <div align="center">                                  
                                  <a href="javascript:moveallsel(this.document.forms[0].BankListDst,this.document.forms[0].BankListSrc);"><img src="images/arrow_leftall.gif" width="24" height="22" border="0"></a>
                                  </div>
                                  </td>
                                </tr>
                               </table></td>
                               <td width="189"> 
                              <select multiple size=10  name="BankListDst" ondblclick="javascript:movesel(this.document.forms[0].BankListDst,this.document.forms[0].BankListSrc);" style="width: 17em">							
							 </select>
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
<INPUT type="hidden" name=BankList><!--//BankList儲存已勾選的金融機構代碼-->
<INPUT type="hidden" name=btnFieldList value='<%if(session.getAttribute("btnFieldList") != null) out.print((String)session.getAttribute("btnFieldList"));%>'><!--//btnFieldList儲存已勾選的報表欄位名稱-->
</form>
<script language="JavaScript" >
<!--

<%
//從session裡把勾選的金融機構代碼讀出來.放在BankListDst
if(session.getAttribute("BankList") != null && !((String)session.getAttribute("BankList")).equals("")){ 
   System.out.println("FR036WA_BankList.BankList="+(String)session.getAttribute("BankList"));
%>
var bnlist;
bnlist = '<%=(String)session.getAttribute("BankList")%>';
var a = bnlist.split(',');
for (var i =0; i < a.length; i ++){
	var j = a[i].split('+');
	this.document.forms[0].BankListDst.options[i] = new Option(j[1], j[0]);
}
<%}%>

setSelect(this.document.forms[0].HSIEN_ID,"<%=hsien_id%>");


changeOption(this.document.forms[0],'');
function clearBankList(){
 <%
	session.setAttribute("BankList",null);//清除已勾選的BankList
 %>
}
-->
</script>

</body>
</html>

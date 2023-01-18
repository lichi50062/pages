<%
//105.11.09 create 查核案件數彈性報表 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%
	// 查詢條件值
    Map dataMap =Utility.saveSearchParameter(request);
	String report_no = "DS068W";
	String act = Utility.getTrimString(dataMap.get("act"));
	String bank_type = (session.getAttribute("nowbank_type")==null)?"":(String)session.getAttribute("nowbank_type");
	String rptKind = (session.getAttribute("rptKind")==null)?"1":(String)session.getAttribute("rptKind");
	String szExcelAction = (session.getAttribute("excelaction")==null)?"download":(String)session.getAttribute("excelaction");
	System.out.println(report_no+"_RptColumn.szExcelAction="+szExcelAction);
	
	DataObject bean = null;
	StringBuffer sql = new StringBuffer();		
	List paramList = new ArrayList();
    sql.append(" select '1' as rptkind,");//--統計分類:貸款種類
	sql.append(" loan_item,");//--貸款種類代碼	
    sql.append(" loan_item_name,");// --貸款種類名稱
    sql.append(" input_order");
    sql.append(" from frm_loan_item");
    sql.append(" union");
    sql.append(" select '2' as rptKind,");//--統計分類:缺失態樣 
    sql.append(" cmuse_id,");//--缺失態樣代碼
    sql.append(" cmuse_name,");// --缺失態樣名稱
    sql.append(" input_order ");//
    sql.append(" from cdshareno where cmuse_div='047' ");
    sql.append(" order by rptkind,input_order");
    
    List FieldList = DBManager.QueryDB_SQLParam(sql.toString(),null,""); 
    //111.04.12 調整xml的tag皆為小寫且為同一行    
    // XML Ducument for 統計分類(貸款種類/缺失態樣) begin
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"rptXML\">");
    out.println("<datalist>");
    for(int i=0;i< FieldList.size(); i++) {
        bean =(DataObject)FieldList.get(i);
        out.print("<data>");
        out.print("<rptkind>"+(String)bean.getValue("rptkind")+"</rptkind>");
        out.print("<rptname>"+bean.getValue("loan_item_name")+"</rptname>");
        out.print("<rptvalue>"+bean.getValue("loan_item")+"</rptvalue>");      
        out.print("</data>");
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 縣市別 end
%>
<script src="js/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/DSUtil.js"></script>
<script language="javascript" src="js/movesels.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
<!--
function doSubmit(report_no,cnd){
	var rptkind = "";   
	for (var i=0; i<document.RptColumnfrm.rptKind.length; i++){
	   if (document.RptColumnfrm.rptKind[i].checked){
		   rptkind = document.RptColumnfrm.rptKind[i].value;
		   break;
	   }
	}
   if(cnd == 'createRpt'){
      if(rptkind == "3" && document.RptColumnfrm.BankList.value == ''){
         alert('金融機構代碼必須選擇');
         return;
      }           
      
      if(rptkind != "3" && document.RptColumnfrm.FieldListDst.length == 0){
      	 alert('報表欄位必須選擇');
      	 return;
      }
      if(!confirm("本項報表會執行10-15秒，是否確定執行？")){
         return;
      }
   }

   MoveSelectToBtn(document.RptColumnfrm.btnFieldList, document.RptColumnfrm.FieldListDst);
   fn_ShowPanel(report_no,cnd);
}

function changeOption_rptKind(form,cnd){	
    //var myXML,rptKind,rptValue,rptName;
    
    //myXML = document.all("rptXML").XMLDocument;
    var xmlDoc = $.parseXML($("xml[id=rptXML]").html()) ;    
    var data = $(xmlDoc).find("data") ;
    form.FieldListSrc.length = 0;
    if(cnd == 'change') form.FieldListDst.length = 0;
    /*    
    rptKind = myXML.getElementsByTagName("rptKind");//rptKind 
	rptValue = myXML.getElementsByTagName("rptValue");//rptValue
	rptName = myXML.getElementsByTagName("rptName");//rptName
	*/
	var oOption;
	var rptkind = "";
    var checkAdd = false;	
    
   
	for (var i=0; i<form.rptKind.length; i++){
	   if (form.rptKind[i].checked){
		   rptkind = form.rptKind[i].value;
		   break;
	   }
	}
	
    //alert('rptkind='+rptkind);
    /*111.04.12 fix
	for(var i=0;i<rptKind.length ;i++){		
		//alert('rptKind='+rptKind.item(i).firstChild.nodeValue);		
		if(rptKind.item(i).firstChild.nodeValue != rptkind)continue;//統計分類		
		
	    oOption = document.createElement("OPTION");
		oOption.text=rptName.item(i).firstChild.nodeValue;
  		oOption.value=rptValue.item(i).firstChild.nodeValue;   	    			     
					  		
  		checkAdd=false;
		for(var k =0;k<form.FieldListDst.length;k++){			
			if(form.FieldListDst.options[k].text == oOption.text){		    
		   	   checkAdd = true;			       
		   	}   
	    }
	    if(checkAdd == false && oOption.text != '' && oOption.value != ''){
  	       form.FieldListSrc.add(oOption);   			
  		}     	  		
    }
    */
    $(data).each(function (i) { 
    	if($(this).find("rptkind").text() != rptkind) return;//統計分類		
		
	    oOption = document.createElement("OPTION");
		oOption.text=$(this).find("rptname").text();
  		oOption.value=$(this).find("rptvalue").text();   	    			     
					  		
  		checkAdd=false;
		for(var k =0;k<form.FieldListDst.length;k++){			
			if(form.FieldListDst.options[k].text == oOption.text){		    
		   	   checkAdd = true;			       
		   	}   
	    }
	    if(checkAdd == false && oOption.text != '' && oOption.value != ''){
  	       form.FieldListSrc.add(oOption);   			
  		}     	  		
    })
    ;
}

//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form method=post action='#' name="RptColumnfrm">
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
     <td>&nbsp;</td>
  </tr>
  <tr>
    <td bgcolor="#FFFFFF">
	<table width="750" border="0" align="center" cellpadding="1" cellspacing="1">
        <tr>
          <td><table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr>
                <td width="240"><img src="images/banner_bg1.gif" width="240" height="17"></td>
                <td width="*" class="title_font">查核案件數彈性報表</td>
                <td width="240"><img src="images/banner_bg1.gif" width="240" height="17"></td>
              </tr>
            </table></td>
        </tr>
        <tr>
          <td><img src="images/space_1.gif" width="8" height="8"></td>
        </tr>
        <tr>
          <td><table width="750" border="1" align="center" cellpadding="0" cellspacing="0" class="bordercolor">
              <tr>
                <td bordercolor="#E9F4E3" bgcolor="#E9F4E3"><table width="750" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#E9F4E3">
                    <tr>
                      <td class="bt_bgcolor"> <div align="right">
                          <!--input type='radio' name="excelaction" value='view' <%if(szExcelAction.equals("view")){out.print("checked");}%> >檢視報表-->
                      	  <input type='radio' name="excelaction" value='download' <%if(szExcelAction.equals("download")){out.print("checked");}%> >下載報表
                          <%if(Utility.getPermission(request,report_no,"P")){//Print--有列印權限時 %>
                      	  <a href="javascript:doSubmit('<%=report_no%>','createRpt');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image411','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image411" width="66" height="25" border="0" id="Image41"></a>
                      	  <%}%>
                          <a href="javascript:ResetAllData('RptColumn');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image511','','images/bt_cancelb.gif',0)"><img src="images/bt_cancel.gif" name="Image511" width="66" height="25" border="0" id="Image51"></a>
                          <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image611','','images/bt_reporthelpb.gif',1)"><img src="images/bt_reporthelp.gif" name="Image611" width="80" height="25" border="0" id="Image61"></a>
                        </div></td>
                    </tr>
                    <tr>
                      <td class="menu_bgcolor"> <table width="700" border="0" align="center" cellpadding="1" cellspacing="1" class="sbody">
                          <tr class="sbody">
                            <td width="100"><a href="javascript:doSubmit('<%=report_no%>','BankList')"><font color='black'>1.受檢單位</font></a></td>
                            <td width="100"><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle">
                              <a href="#"><font color="#CC6600">2.統計分類</font></a></td>
                          </tr>
                        </table></td>
                    </tr>
                    
                    <tr> 
                      <td class="body_bgcolor"> 
                       <table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
                    	 <tr class="sbody">
                         <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">統計分類:</span>                           
                            <input type="radio" value="1" name="rptKind" <%if((!rptKind.equals("")) && rptKind.equals("1")) out.print("checked");%> onClick="javascript:changeOption_rptKind(document.forms[0],'change');">貸款種類&nbsp;&nbsp;
					        <input type="radio" value="2" name="rptKind" <%if((!rptKind.equals("")) && rptKind.equals("2")) out.print("checked");%> onClick="javascript:changeOption_rptKind(document.forms[0],'change');">缺失態樣&nbsp;&nbsp;
					        <input type="radio" value="3" name="rptKind" <%if((!rptKind.equals("")) && rptKind.equals("3")) out.print("checked");%> onClick="javascript:changeOption_rptKind(document.forms[0],'change');">農漁會                             
		                  </td>
                         </tr>
                        </table>
                       </td>
                    </tr>


                    <%@include file="./include/DS_RptColumn.include" %><!-- 報表欄位.可挑選項目-->
                    
                    <tr> 
                 	  <td class="body_bgcolor">
                  	    <table width="750" border="0" cellpadding="1" cellspacing="1">
                    	<tr>                           
                          <td width="750" align=left><font color="red" size=2>註：『已選擇項目』清單選取之項目說明</font></td>                              
                    	</tr>                              
                        <tr>                           
                          <td width="750" align=left><font color="red" size=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(1)統計分類:貸款種類,係以統計已選取之貸款種類資料 </font></td>                              
                        </tr>                                                                                                      
                        <tr>                           
                          <td width="750" align=left><font color="red" size=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(2)統計分類:缺失態樣,係以統計已選取之缺失態樣資料 </font></td>                              
                        </tr>
                        <tr>                           
                          <td width="750" align=left><font color="red" size=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(3)統計分類:農漁會,係以統計已選取信用部之案件資料或各縣市彙總資料 </font></td>                              
                        </tr>
                        </table>
                      </td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
        </tr>

      </table>
    </td>
  </tr>
</table>
<INPUT type="hidden" name=FieldList value=<%=request.getAttribute("FieldList")%>><!--//FieldList儲存所有的報表欄位名稱-->
<INPUT type="hidden" name=btnFieldList><!--//btnFieldList儲存已勾選的報表欄位名稱-->
<INPUT type="hidden" name=BankList value='<%if(session.getAttribute("BankList") != null) out.print((String)session.getAttribute("BankList"));%>'><!--//BankList儲存已勾選的金融機構代碼-->
<INPUT type="hidden" name=S_YEAR value='<%if(session.getAttribute("S_YEAR") != null) out.print((String)session.getAttribute("S_YEAR"));%>'><!--//95.12.04儲存已勾選的起始日期-年-->
<INPUT type="hidden" name=E_YEAR value='<%if(session.getAttribute("E_YEAR") != null) out.print((String)session.getAttribute("E_YEAR"));%>'><!--//95.12.04儲存已勾選的結束日期-年-->
<INPUT type="hidden" name=S_MONTH value='<%if(session.getAttribute("S_MONTH") != null) out.print((String)session.getAttribute("S_MONTH"));%>'><!--//95.12.04儲存已勾選的起始日期-月-->
<INPUT type="hidden" name=E_MONTH value='<%if(session.getAttribute("E_MONTH") != null) out.print((String)session.getAttribute("E_MONTH"));%>'><!--//95.12.04儲存已勾選的結束日期-月-->
<INPUT type="hidden" name=DS_bank_type value='<%if(session.getAttribute("DS_bank_type") != null) out.print((String)session.getAttribute("DS_bank_type"));%>'><!--//102.11.11儲存已勾選的結束日期-月-->
</form>
<script language="JavaScript" >
<!--

<%//從session裡把勾選的報表欄位讀出來.放在FieldListDst
if(session.getAttribute("btnFieldList") != null && !((String)session.getAttribute("btnFieldList")).equals("")){
   System.out.println("DS068W_RptColumn.btnFieldList="+(String)session.getAttribute("btnFieldList"));
%>
	var bnlist;
	bnlist = '<%=(String)session.getAttribute("btnFieldList")%>';
	<%
	session.setAttribute("btnFieldList",null);//清除已勾選的勾選的報表欄位
    %>
	var a = bnlist.split(',');
	for (var i =0; i < a.length; i ++){
		var j = a[i].split('+');
		this.document.forms[0].FieldListDst.options[i] = new Option(j[1], j[0]);
	}
<%}%>

//fn_loadFieldList(this.document.forms[0]);//顯示所有的報表欄位名稱
changeOption_rptKind(document.RptColumnfrm,'');

-->
</script>

</body>
</html>

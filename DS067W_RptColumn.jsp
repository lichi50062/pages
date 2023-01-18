<%
//111.04.12 調整Edge貸款種類-[申報基準日]/[貸款種類]無資料可挑選 by 2295
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
	String report_no = "DS067W";
	String title = Utility.getPgName(report_no);
	String act = Utility.getTrimString(dataMap.get("act"));	
	String bank_type = (session.getAttribute("nowbank_type")==null)?"":(String)session.getAttribute("nowbank_type");		
	String szExcelAction = (session.getAttribute("excelaction")==null)?"download":(String)session.getAttribute("excelaction");	
	String acc_tr_type = ( session.getAttribute("ACC_TR_TYPE")==null ) ? "" : (String)session.getAttribute("ACC_TR_TYPE");
	String applydate = ( session.getAttribute("APPLYDATE")==null ) ? "" : (String)session.getAttribute("APPLYDATE");
	String acc_div = ( session.getAttribute("ACC_DIV")==null ) ? "" : (String)session.getAttribute("ACC_DIV");
	
	List AllAccTr = (List)request.getAttribute("AllAccTr");
	List AllAccList = (List)request.getAttribute("AllAccList");
	List AllApplyDates = (List)request.getAttribute("AllApplyDates");
	
	System.out.println(report_no+"_RptColumn.szExcelAction="+szExcelAction);
	
		DataObject bean = null;
		//111.04.12 調整xml的tag皆為小寫且為同一行    
		out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"DateXML\">");    
		out.println("<datalist>"); 
		if(AllApplyDates != null){
		    for(int i=0;i< AllApplyDates.size(); i++) {
		        bean =(DataObject)AllApplyDates.get(i);
		        out.print("<data>");        
		        out.print("<acc_tr_type>"+bean.getValue("acc_tr_type").toString()+"</acc_tr_type>");
		        out.print("<applydate>"+bean.getValue("applydate")+"</applydate>");
		        out.print("<applydate_show>"+Utility.getCHTdate(bean.getValue("applydate").toString(), 0)+"</applydate_show>");
		        out.print("</data>");
		    }       
		 }
		 out.println("</datalist>\n</xml>");
		
		bean = null;
		out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"AccListXML\">");    
		out.println("<datalist>"); 
		if(AllAccList != null){
			for(int i=0;i< AllAccList.size(); i++) {
			    bean =(DataObject)AllAccList.get(i);
			    out.print("<data>");        
			    out.print("<acc_tr_type>"+bean.getValue("acc_tr_type").toString()+"</acc_tr_type>");
			    out.print("<acc_div>"+bean.getValue("acc_div")+"</acc_div>");
			    out.print("<acc_code>"+bean.getValue("acc_code")+"</acc_code>");
			    out.print("<acc_name>"+bean.getValue("acc_name")+"</acc_name>");
			    out.print("</data>");
			}       
		}
		out.println("</datalist>\n</xml>");
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
//102.11.11 add 漁會科目代號新舊無法同時列印
function doSubmit(report_no,cnd){   
   if(cnd == 'createRpt'){
      if(document.RptColumnfrm.BankList.value == ''){        
         alert('貸款經辦機構代碼必須選擇');
         return;
      }
      if(document.RptColumnfrm.FieldListDst.length == 0){        
      	 alert('貸款種類欄位必須選擇');
      	 return;
      }
      if(!confirm("本項報表會執行10-15秒，是否確定執行？")){
         return;
      }   
   }   
   
   MoveSelectToBtn(document.RptColumnfrm.btnFieldList, document.RptColumnfrm.FieldListDst);		         
   fn_ShowPanel(report_no,cnd);      
}
//111.04.12 fix 調整xml取得方式 by 2295
function changeDate(form){
	/*111.04.12 fix
	myXML = document.all("DateXML").XMLDocument;
	nodeType = myXML.getElementsByTagName("acc_tr_type"); 
	nodeValue = myXML.getElementsByTagName("applydate");
	nodeName = myXML.getElementsByTagName("applydate_show");
	var sType = form.ACC_TR_TYPE.value;
	var sDate = form.APPLYDATE.value;
	var target = document.getElementById("APPLYDATE");
	target.length = 0;
	var oOption = document.createElement("OPTION");
	for(var i=0;i<nodeName.length ;i++)	{
		if(nodeType.item(i).firstChild.nodeValue==sType) {
			oOption = document.createElement("OPTION");
       	 	oOption.text=nodeName.item(i).firstChild.nodeValue;
	        oOption.value=nodeValue.item(i).firstChild.nodeValue;  
	        target.add(oOption);
		}
	}
	*/
	var sType = form.ACC_TR_TYPE.value;
	var sDate = form.APPLYDATE.value;
	document.RptColumnfrm.APPLYDATE.length = 0;
	var xmlDoc = $.parseXML($("xml[id=DateXML]").html()) ;    
    var data = $(xmlDoc).find("data") ;
    var oOption;
	$(data).each(function (i) { 
		if($(this).find("acc_tr_type").text()==sType) {
			oOption = document.createElement("OPTION");
       	 	oOption.text=$(this).find("applydate_show").text();
	        oOption.value=$(this).find("applydate").text();  
	        document.RptColumnfrm.APPLYDATE.add(oOption);
		}
    })
    ;
    
	if(sDate!=''){
		setSelect(form.APPLYDATE,sDate);
	}
	
}
//111.04.12 fix 調整xml取得方式 by 2295
function changeAccList(form,cnd){
	changeDate(form);
    //myXML = document.all("AccListXML").XMLDocument;
    var xmlDoc = $.parseXML($("xml[id=AccListXML]").html()) ;    
    var data = $(xmlDoc).find("data") ;
    form.FieldListSrc.length = 0;
    if(cnd == 'change') form.FieldListDst.length = 0;
    /*
    nodeType = myXML.getElementsByTagName("acc_tr_type"); 
    nodeDiv = myXML.getElementsByTagName("acc_div");   
	nodeValue = myXML.getElementsByTagName("acc_code");
	nodeName = myXML.getElementsByTagName("acc_name");
	*/
	var sType = form.ACC_TR_TYPE.value;
	var sDiv = "01";
	if(form.ACC_DIV[1].checked)sDiv='02';
	var oOption;
    var checkAdd = false;	
    /*111.04.12 fix
	for(var i=0;i<nodeType.length ;i++){
		if(nodeType.item(i).firstChild.nodeValue == sType
				&& nodeDiv.item(i).firstChild.nodeValue == sDiv){
			oOption = document.createElement("OPTION");
	  		oOption.text=nodeName.item(i).firstChild.nodeValue;
			oOption.value=nodeValue.item(i).firstChild.nodeValue;
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
    }
    */
    $(data).each(function (i) { 
    	if($(this).find("acc_tr_type").text() == sType
				&& $(this).find("acc_div").text() == sDiv){
			oOption = document.createElement("OPTION");
	  		oOption.text=$(this).find("acc_name").text();
			oOption.value=$(this).find("acc_code").text();
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
                <td width="220"><img src="images/banner_bg1.gif" width="220" height="17"></td>
                <td width="*" class="title_font"><%=title%></td>
                <td width="220"><img src="images/banner_bg1.gif" width="220" height="17"></td>
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
                          	<td width="200"><a href="javascript:doSubmit('<%=report_no%>','BankList')"><font color='black'>1.貸款經辦機構</font></a></td>
                            <td width="200"><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"> 
                              <a href="#"><font color="#CC6600">2.貸款種類</font></a></td>
                                                                                 
                          </tr>
                        </table></td>
                    </tr>
                    <tr> 
                      <td class="body_bgcolor"> 
                       <table width="750" border="0" align="center" cellpadding="0" cellspacing="0">     
                         <tr class="sbody">                                  		
                           <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">協助措施名稱 :</span>                                                            
                              <select name="ACC_TR_TYPE" onchange="javascript:changeAccList(document.RptColumnfrm,'change');"> 
							     <%if(AllAccTr!=null && AllAccTr.size()>0){
										for(int i=0; i<AllAccTr.size(); i++){ 
											out.print("<option value='"+(String)((DataObject)AllAccTr.get(i)).getValue("acc_tr_type")+"'>"+(String)((DataObject)AllAccTr.get(i)).getValue("acc_tr_name")+"</option>");
										}
								 }%>
						     </select>
                           </td>
                         </tr>  
                    	 <tr class="sbody">
                         <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">申報基準日:</span>
                            <select size="1" name="APPLYDATE" onchange="javascript:changeAccList(document.RptColumnfrm,'');"> 
                            </select>
		                  </td>
                         </tr> 
                         <tr class="sbody">                                  		
                           <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">報表分類 :</span>                                                            
                              <input type='radio' name='ACC_DIV' value='01' onClick="javascript:changeAccList(document.RptColumnfrm,'change');" checked >舊貸展延需求&nbsp;
                              <input type='radio' name='ACC_DIV' value='02' onClick="javascript:changeAccList(document.RptColumnfrm,'change');">新貸需求
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
                          <td width="750" align=left><font color="red" size=2>註：Excel報表欄位限制最多255個</font></td>                              
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
<INPUT type="hidden" name=Unit value='<%if(session.getAttribute("Unit") != null) out.print((String)session.getAttribute("Unit"));%>'><!--//95.12.04儲存已勾選的起始日期-年-->
<INPUT type="hidden" name=HSIEN_ID value='<%if(session.getAttribute("HSIEN_ID") != null) out.print((String)session.getAttribute("HSIEN_ID"));%>'><!--//95.12.04儲存已勾選的起始日期-月-->
<INPUT type="hidden" name=DS_bank_type value='<%if(session.getAttribute("DS_bank_type") != null) out.print((String)session.getAttribute("DS_bank_type"));%>'><!--//102.11.11-->
<INPUT type="hidden" name=bank_type value='<%=bank_type%>'>
</form>
<script language="JavaScript" >
<!-- 
    
<%//從session裡把勾選的報表欄位讀出來.放在FieldListDst 	
if(session.getAttribute("btnFieldList") != null && !((String)session.getAttribute("btnFieldList")).equals("")){ 
   System.out.println(report_no+"_RptColumn.btnFieldList="+(String)session.getAttribute("btnFieldList"));
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

fn_loadFieldList(document.RptColumnfrm);//顯示所有的報表欄位名稱
setSelect(document.RptColumnfrm.ACC_TR_TYPE,"<%=acc_tr_type%>");
if("<%=acc_div%>"=='02') document.RptColumnfrm.ACC_DIV[1].checked = true;
changeAccList(document.RptColumnfrm,'');
setSelect(document.RptColumnfrm.APPLYDATE,"<%=applydate%>");
-->
</script>

</body>
</html>

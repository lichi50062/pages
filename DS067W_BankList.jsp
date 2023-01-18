<%
//105.11.15 create 協助措施彈性報表 by 2968
//108.05.03 add 報表格式轉換 by 2295
//111.04.12 調整Edge貸款經辦構-[縣市別]/貸款經辦機構-無資料可挑選 by 2295
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
	
	//營運中/已裁撤===================================================================================
	String cancel_no = ( session.getAttribute("CANCEL_NO")==null ) ? "N" : (String)session.getAttribute("CANCEL_NO");				
	//========================================================================================================	
	String szExcelAction = (session.getAttribute("excelaction")==null)?"download":(String)session.getAttribute("excelaction");		
	
	String hsien_id = ( session.getAttribute("HSIEN_ID")==null ) ? "ALL" : (String)session.getAttribute("HSIEN_ID");				
	System.out.println("DS067W_BankList.hsien_id="+hsien_id);
   	String Unit = (session.getAttribute("Unit")==null)?"":(String)session.getAttribute("Unit");   	   	
    String acc_tr_type = (session.getAttribute("ACC_TR_TYPE")==null)?"":(String)session.getAttribute("ACC_TR_TYPE");
    String acc_div = ( session.getAttribute("ACC_DIV")==null ) ? "" : (String)session.getAttribute("ACC_DIV");
    String applydate = ( session.getAttribute("APPLYDATE")==null ) ? "" : (String)session.getAttribute("APPLYDATE");
    String YEAR  = Utility.getYear();
   	String MONTH = Utility.getMonth();
   	String printStyle = (session.getAttribute("printStyle")==null)?"xls":(String)session.getAttribute("printStyle");//108.05.03 add
	//95.11.10 取得登入者資訊=================================================================================================
	String muser_id = ( session.getAttribute("muser_id")==null ) ? "" : (String)session.getAttribute("muser_id");		
    String muser_bank_type = ( session.getAttribute("bank_type")==null ) ? "" : (String)session.getAttribute("bank_type");			
    //==============================================================================================================    	    
    List AllAccTr = (List)request.getAttribute("AllAccTr");
    List AllLoanBank = (List)request.getAttribute("AllLoanBank");
    String bank_type = (session.getAttribute("nowbank_type")==null)?"ALL":(String)session.getAttribute("nowbank_type");	    
	String DS_bank_type = (session.getAttribute("DS_bank_type")==null)?"6":(String)session.getAttribute("DS_bank_type");	
	System.out.print("nowbank_type="+(String)session.getAttribute("nowbank_type"));
	System.out.print(report_no+"_BankList.szExcelAction="+szExcelAction);
    //System.out.print(":S_YEAR="+S_YEAR+":S_MONTH="+S_MONTH+":S_DAY="+S_DAY);
    System.out.println(":acc_tr_type="+acc_tr_type+":bank_type="+bank_type);
	//控制農漁會清單1 
	session.setAttribute("nowbank_type","");
	session.setAttribute("muser_id","");
	session.setAttribute("bank_type","3");
%>
<% 
    //111.04.11 調整xml的tag皆為小寫且為同一行    
	//XML Ducument for 總機構代碼 begin
	DataObject bean = null;
	out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"TBankXML\">");    
	out.println("<datalist>"); 
	if(AllLoanBank != null){
	    for(int i=0;i< AllLoanBank.size(); i++) {
	        bean =(DataObject)AllLoanBank.get(i);
	        out.print("<data>");        
	        out.print("<acc_tr_type>"+bean.getValue("acc_tr_type").toString()+"</acc_tr_type>");
	        out.print("<banktype>"+bean.getValue("bank_type")+"</banktype>");
	        out.print("<hsienid>"+bean.getValue("hsien_id")+"</hsienid>");
	        out.print("<bankvalue>"+bean.getValue("bank_code")+"</bankvalue>");
	        out.print("<bankname>"+bean.getValue("bank_code")+bean.getValue("bank_name")+"</bankname>");
	        out.print("<bankyear>100</bankyear>") ;
	        out.print("</data>");
	        //System.out.println("<option>"+bean.getValue("bank_no")+"&nbsp;"+bean.getValue("bank_name")+"</option>");
	    }       
	 }
	 out.println("</datalist>\n</xml>");
	 // XML Ducument for 總機構代碼 end
	 
	
	 List cityList = Utility.getCity();
	//111.04.11 調整xml的tag皆為小寫且為同一行     	
	// XML Ducument for 縣市別 begin
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"CityXML\">");
    out.println("<datalist>");
    for(int i=0;i< cityList.size(); i++) {
        bean =(DataObject)cityList.get(i);
        out.print("<data>");
        out.print("<citytype>"+bean.getValue("hsien_id")+"</citytype>");
        out.print("<cityname>"+bean.getValue("hsien_name")+"</cityname>");
        out.print("<cityvalue>"+bean.getValue("hsien_id")+"</cityvalue>");
        out.print("<cityyear>"+bean.getValue("m_year").toString()+"</cityyear>");
        out.print("</data>");
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 縣市別 end
%>
<%  //控制農漁會清單2 
	session.setAttribute("nowbank_type", bank_type); 
	session.setAttribute("muser_id", muser_id);
	session.setAttribute("bank_type", bank_type);
%>
<script src="js/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/PopupCal.js"></script>
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
      if(document.BankListfrm.BankListDst.length == 0){      	 
      	 alert('貸款經辦機構代碼必須選擇');
      	 return;
      }
     /*
      if(this.document.forms[0].S_YEAR.value+this.document.forms[0].S_MONTH.value > this.document.forms[0].E_YEAR.value+this.document.forms[0].E_MONTH.value ){
		 alert('起始日期不可大於結束日期');
		return false;
	  }*/
      
      if(document.BankListfrm.btnFieldList.value == ''){
         alert('貸款種類必須選擇');
         return;
      }      
      if(!confirm("本項報表會執行10-15秒，是否確定執行？")){
         return;
      }   
   }   
   
   MoveSelectToBtn(document.BankListfrm.BankList, document.BankListfrm.BankListDst);	
   /*if(!mergeCheckedDate("S_YEAR;S_MONTH;S_DAY","begDate")){   	  
	  this.document.forms[0].S_YEAR.focus();
      return ;
   }
   if(this.document.forms[0].begDate.value == ''){
   	  alert("查核期間不可為空白");
   	  this.document.forms[0].S_YEAR.focus();
      return ;
   }	
   this.document.forms[0].begDate.value=parseInt(this.document.forms[0].begDate.value)+19110000;
   
   //alert(this.document.forms[0].begDate.value);
   if(!mergeCheckedDate("E_YEAR;E_MONTH;E_DAY","endDate")){
	  this.document.forms[0].E_YEAR.focus();
      return ;
   }
   if(this.document.forms[0].endDate.value == ''){
   	  alert("查核期間不可為空白");
   	  this.document.forms[0].E_YEAR.focus();
      return ;
   }	
   this.document.forms[0].endDate.value=parseInt(this.document.forms[0].endDate.value)+19110000;
   //alert(this.document.forms[0].endDate.value);
   */
   fn_ShowPanel(report_no,cnd);      
}


//111.04.11 fix 調整xml取得方式 by 2295
function changeBankList(form,cnd){	
    //var myXML,nodeType,nodeType1,nodeValue, nodeName,bankType,nodeYear;
    var m_year = form.S_YEAR.value;
    if(m_year >= 100){
       m_year = 100;
    }else{
       m_year = 99;
    }	
    /*111.04.11 fix
    myXML = document.all("TBankXML").XMLDocument;
    form.BankListSrc.length = 0;
    if(cnd == 'change'){
    	form.BankListDst.length = 0;
    	form.btnFieldList.value="";
    }
    AccType = myXML.getElementsByTagName("acc_tr_type"); 
    bankType = myXML.getElementsByTagName("BankType");//bank_type    
	nodeType = myXML.getElementsByTagName("HsienId");//hsien_id
	nodeValue = myXML.getElementsByTagName("bankValue");//bank_no
	nodeName = myXML.getElementsByTagName("bankName");//bank_no+bank_name
	nodeYear = myXML.getElementsByTagName("BankYear");//m_year
	var oOption;
    var checkAdd = false;	
	for(var i=0;i<nodeType.length ;i++){
		if( form.bank_type.value!='ALL' && (bankType.item(i).firstChild.nodeValue != form.bank_type.value))continue;//農漁會別
		if(nodeYear.item(i).firstChild.nodeValue != m_year)	continue;//顯示查詢年度的新機構名稱
		if(AccType.item(i).firstChild.nodeValue == form.ACC_TR_TYPE.value){
			flg = false;
			if(form.HSIEN_ID.value == 'ALL'){
				flg = true;
			}else  if (nodeType.item(i).firstChild.nodeValue == form.HSIEN_ID.value){
				flg = true;
			}
			if(flg){
				oOption = document.createElement("OPTION");
	  			oOption.text=nodeName.item(i).firstChild.nodeValue;
			    oOption.value=nodeValue.item(i).firstChild.nodeValue;
			    checkAdd=false;
				for(var k =0;k<form.BankListDst.length;k++){			
					if(form.BankListDst.options[k].text == oOption.text){		    
				   	   checkAdd = true;			       
			    	}   
		    	}
		    	if(checkAdd == false && oOption.text != '' && oOption.value != ''){	      
	  				form.BankListSrc.add(oOption); 
	  			}
			}
		}
    }
    */
    form.BankListSrc.length = 0;
    if(cnd == 'change'){
    	form.BankListDst.length = 0;
    	form.btnFieldList.value="";
    }
    var oOption;
    var checkAdd = false;
    var xmlDoc = $.parseXML($("xml[id=TBankXML]").html()) ;    
    var data = $(xmlDoc).find("data") ;
    $(data).each(function (i) {         	
    	if( form.bank_type.value!='ALL' && ($(this).find("banktype").text() != form.bank_type.value)) return;//農漁會別
		if($(this).find("bankyear").text() != m_year)	return;//顯示查詢年度的新機構名稱
		if($(this).find("acc_tr_type").text() == form.ACC_TR_TYPE.value){
			flg = false;
			if(form.HSIEN_ID.value == 'ALL'){
				flg = true;
			}else  if ($(this).find("hsienid").text() == form.HSIEN_ID.value){
				flg = true;
			}
			if(flg){
				oOption = document.createElement("OPTION");
	  			oOption.text=$(this).find("bankname").text();
			    oOption.value=$(this).find("bankvalue").text();
			    checkAdd=false;
				for(var k =0;k<form.BankListDst.length;k++){			
					if(form.BankListDst.options[k].text == oOption.text){		    
				   	   checkAdd = true;			       
			    	}   
		    	}
		    	if(checkAdd == false && oOption.text != '' && oOption.value != ''){	      
	  				form.BankListSrc.add(oOption); 
	  			}
			}
		}
    })
    ;
	changeOption_all(form,cnd);
}
function changeOption_all(form,cnd){
	var oOption;
    var checkAdd = false;	
	if(form.HSIEN_ID.value == 'ALL' && form.BankListSrc.length>0){	
		oOption = document.createElement("OPTION");			    
		oOption.text="全部";
  		oOption.value="ALL";   	  
		 			  		
  		checkAdd=false;
		for(var k =0;k<form.BankListDst.length;k++){			
			if(form.BankListDst.options[k].text == oOption.text){		    
		   	   checkAdd = true;			       
	    	}   
		}
		if(checkAdd == false && oOption.text != '' && oOption.value != ''){	  							
	   	   form.BankListSrc.add(oOption,0);   			
  		}	
	}     	
}
//111.04.12 fix 調整xml取得方式 by 2295
function changeCity(target, source, form) {
    //var myXML,nodeType,nodeValue, nodeName,nodeYear,m_year;      
    var m_year = source.value;
    if(m_year >= 100){
       m_year = 100;
    }else{
       m_year = 99;
    }	
    
    target.length = 0;      
    var oOption;
    
    /*111.03.21 fix
    myXML = document.all(xml).XMLDocument;
    nodeType = myXML.getElementsByTagName("cityType");//hsien_id
    nodeYear = myXML.getElementsByTagName("cityYear");//m_year
	nodeValue = myXML.getElementsByTagName("cityValue");//hsien_id
	nodeName = myXML.getElementsByTagName("cityName");//hsien_name
		
	oOption = document.createElement("OPTION");
	oOption.text='全部';
	oOption.value='ALL';
	target.add(oOption);
	  
	for(var i=0;i<nodeType.length ;i++)	{	  	
	     if (nodeYear.item(i).firstChild.nodeValue == m_year)  {
		    oOption = document.createElement("OPTION");
		    oOption.text=nodeName.item(i).firstChild.nodeValue;
		    oOption.value=nodeValue.item(i).firstChild.nodeValue;
		    target.add(oOption);
 	     }
    }
    */
    var xmlDoc = $.parseXML($("xml[id=CityXML]").html()) ;    
    var data = $(xmlDoc).find("data") ;
    oOption = document.createElement("OPTION");
	oOption.text='全部';
	oOption.value='ALL';
	target.add(oOption);
	$(data).each(function (i) {      	
     	if ($(this).find("cityyear").text() == m_year)  {
            oOption = document.createElement("OPTION");  			
			oOption.text= $(this).find("cityname").text();
  			oOption.value=$(this).find("cityvalue").text();
  			target.add(oOption);
    	}
     	
    })
    ;    
    
    //form.HSIEN_ID[0].selected=true;//111.04.12移除不使用           
    
}

//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form method=post action='#' name='BankListfrm'>
<input type='hidden' name='S_YEAR' value="<%=YEAR%>">
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
                <td width="*" class="title_font"><%=title %></td>
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
                <td bordercolor="#E9F4E3" bgcolor="#E9F4E3">
                <table width="750" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#E9F4E3">
                    <tr> 
                      <td class="bt_bgcolor"> 
                       <div align="right">
                          <!--input type='radio' name="excelaction" value='view' <%if(szExcelAction.equals("view")){out.print("checked");}%> >檢視報表-->
                      	  <input type='radio' name="excelaction" value='download' <%if(szExcelAction.equals("download")){out.print("checked");}%> >下載報表
                      	  <%if(Utility.getPermission(request,report_no,"P")){//Print--有列印權限時 %> 
                      	  <a href="javascript:doSubmit('<%=report_no%>','createRpt');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image41','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image41" width="66" height="25" border="0" id="Image41"></a> 
                      	  <%}%>
                          <a href="javascript:ResetAllData('BankList');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image51','','images/bt_cancelb.gif',0)"><img src="images/bt_cancel.gif" name="Image51" width="66" height="25" border="0" id="Image51"></a> 
                          <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image61','','images/bt_reporthelpb.gif',1)"><img src="images/bt_reporthelp.gif" name="Image61" width="80" height="25" border="0" id="Image61"></a> 
                        </div>
                       </td>
                    </tr>
                    <tr> 
                      <td class="menu_bgcolor"> 
                        <table width="700" border="0" align="center" cellpadding="1" cellspacing="1" class="sbody">
                          <tr class="sbody"> 
                            <td width="200"><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"> 
                              <a href="#"><font color="#CC6600">1.貸款經辦機構</font></a></td>
                            <td width="200"><a href="javascript:doSubmit('<%=report_no%>','RptColumn')"><font color='black'>2.貸款種類</font></a></td>                                                     
                          </tr>
                        </table></td>
                    </tr>                    
                     
                    <tr> 
                      <td class="body_bgcolor"> 
                       <table width="750" border="0" align="center" cellpadding="0" cellspacing="0">     
                         <tr class="sbody">                                  		
                           <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">協助措施名稱 :</span>                                                            
                              <select name="ACC_TR_TYPE" onchange="javascript:changeBankList(document.BankListfrm,'change');"> 
							     <%if(AllAccTr!=null && AllAccTr.size()>0){
										for(int i=0; i<AllAccTr.size(); i++){ 
											out.print("<option value='"+(String)((DataObject)AllAccTr.get(i)).getValue("acc_tr_type")+"'>"+(String)((DataObject)AllAccTr.get(i)).getValue("acc_tr_name")+"</option>");
										}
								 }%>
						     </select>
                           </td>
                         </tr>  
                    	 <tr class="sbody">
                         <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">貸款經辦機構別 :</span>
                            <select size="1" name="bank_type" onchange="javascript:changeBankList(document.BankListfrm,'change');"> 
                              <option value ='ALL' <%if((!bank_type.equals("")) && bank_type.equals("ALL")) out.print("selected");%>>全部</option>
                              <option value ='6' <%if((!bank_type.equals("")) && bank_type.equals("6")) out.print("selected");%>>農會</option>  
                              <option value ='7' <%if((!bank_type.equals("")) && bank_type.equals("7")) out.print("selected");%>>漁會</option> 
                              <option value ='A' <%if((!bank_type.equals("")) && bank_type.equals("A")) out.print("selected");%>>銀行</option>                                          
                            </select>
		                  </td>
                         </tr> 
                         <%@include file="./include/DS_Unit.include" %><!-- 金額單位-->
                         <tr class="sbody">                                  		
  						   <input type='hidden' name='CANCEL_NO' value="N">  						    		
                           <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">縣市別 :</span>                                                            
                              <select name="HSIEN_ID" onchange="javascript:changeBankList(document.BankListfrm,'');"> 
                              <option value="ALL">全部</option>                                                             
                             </select>
                           </td>
                         </tr>
                         <%@include file="./include/DS_PrintStyle.include" %><!-- 輸出格式 -->    
                        </table>
                       </td>
                    </tr>
                    
                    <%@include file="./include/DS_BankList.include" %><!-- 可選擇項目-->
                    <!-- 
                    <tr> 
                 	  <td class="body_bgcolor">
                  	    <table width="750" border="0" cellpadding="1" cellspacing="1">
                    	<tr>                           
                          <td width="750" align=left><font color="red" size=2>註：『已選擇項目』清單選取之項目說明</font></td>                              
                    	</tr>                              
                        <tr>                           
                          <td width="750" align=left><font color="red" size=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(1)選取[全部]：係以「各縣市彙總表」之報表格式列印 </font></td>                              
                        </tr>                                                                                                      
                        <tr>                           
                          <td width="750" align=left><font color="red" size=2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(2)選取[多家農漁會信用部]：係以統計已選取信用部資料 </font></td>                              
                        </tr>
                        </table>
                      </td>
                    </tr> -->
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
<INPUT type="hidden" name=clearbtnFieldList><!--//儲存是否清除btnFieldList-->
<input type='hidden' name='APPLYDATE' value="<%=applydate%>">
<input type='hidden' name='ACC_DIV' value="<%=acc_div%>">
</form>
<script language="JavaScript" >
<!--

<%
//從session裡把勾選的金融機構代碼讀出來.放在BankListDst
if(session.getAttribute("BankList") != null && !((String)session.getAttribute("BankList")).equals("")){ 
   System.out.println("DS067W_BankList.BankList="+(String)session.getAttribute("BankList"));
%>
var bnlist;
bnlist = '<%=(String)session.getAttribute("BankList")%>';
var a = bnlist.split(',');
for (var i =0; i < a.length; i ++){
	var j = a[i].split('+');
	this.document.forms[0].BankListDst.options[i] = new Option(j[1], j[0]);
}
<%}%>
setSelect(document.BankListfrm.ACC_TR_TYPE,"<%=acc_tr_type%>");
setSelect(document.BankListfrm.bank_type,"<%=bank_type%>");
setSelect(document.BankListfrm.Unit,"<%=Unit%>");
setSelect(document.BankListfrm.HSIEN_ID,"<%=hsien_id%>");

changeCity(document.BankListfrm.HSIEN_ID, document.BankListfrm.S_YEAR, document.BankListfrm);
changeBankList(document.BankListfrm,'');

-->
</script>

</body>
</html>

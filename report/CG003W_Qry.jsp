<%
// 95.10.30 稽核記錄統計管理功能 - 項目明細報表列印 created by ABYSS Brenda
//108.05.16 add 報表格式挑選 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.HashMap" %>
<%!
	private String[][] tableEName = {{"A01_LOG","A02_LOG","A03_LOG","A04_LOG","A05_LOG","A06_LOG","A99_LOG"}
									,{"B01_log","B02_log","B03_1_log","B03_2_log","B03_3_log","B03_4_log","BN04_log","BANK_CMML_log"}
									,{"ExDisTripF_log","ExHelpItemF_log","ExScheduleF_log","ExReportF_log"
									,"ExSnDocF_log","ExRtDocF_log","ExDefGoodF_log","ExDG_HistoryF_log"
									,"ExWarningF_log","F01_log"}
									,{"WML01_log","WML02_log","WML03_log","WLX05_M_ATM_log","WLX05_ATM_SETUP_log"
									,"WLX06_M_OUTPUSH_log","WLX07_M_IMPORTANT_log","WLX08_S_GAGE_APPLY_log"
									,"WLX08_S_GAGE_log","WLX09_S_WARNING_log","WLX_APPLY_LOCK_log","WLX_Notify_log"
									,"WTT07","WTT07_ELM_log","WLX_S_RATE_log","WLX01_log","WLX01_M_log","WLX02_log"
									,"WLX02_M_log","WLX04_log","WTT01_log","WZZ07_log"}
									,{"M01_log","M02_log","M03_log","M03_NOTE_log","M04_log","M05_TOTACC_log","M05_log","M05_NOTE_log"
									,"M06_log","M07_log","M08_log","MUSER_DATA_log"}};
	private String[][] tableCName = {{"農漁會營運明細資料","法定比率資料","平均比率資料","資本品質分析資料","資本適足率資料","逾期放款資料","法定比率資料"}
									,{"農業發展基金及農業天然災害基金貸款執行情形表","農業發展基金及農業天然災害救助基金貸放餘額統計","農業發展基金貸款統計表"
									,"農業發展基金貸款逾期情形表","農業發展基金來源運用表","各經辦機構辦理農業發展基金貸款餘額統計表","配賦資料異動紀錄檔"
									,"農業行庫暨相關機構通訊錄"}
									,{"檢查派差_LOG","檢查派差_助檢人員負責項目","檢查行程計劃","檢查報告","發文紀錄維護_LOG","回文紀錄維護_LOG","缺失改善_LOG"
									,"缺失改善歷程紀錄","異常警訊資料","在台無住所外國人新台幣存款主檔"}
									,{"申報歷程紀錄檔","更新錯誤紀錄檔","更新錯誤紀錄檔_描述","各農漁會金融卡情形及ATM裝設情形統計","各農漁會ATM裝設紀錄"
									,"各農漁會委外催收委外之對象","各農漁會信用部重要業務辦理情形","各農漁會某季申請[無]承受擔保品延長處分申報"
									,"各農漁會承受擔保品延長處分申報情形","金融機構警示帳戶調查","基本資料每月季申請紀錄及鎖住檔","首頁公告維護檔"
									,"擷取農漁會[理監事及負責人]資料之登入紀錄檔","擷取農漁會[理監事及負責人]資料之身份證別檔","農漁會信用部版告利率每季申報資料檔"
									,"總機構基本資料維護_LOG","總機構高階主管基本資料維護","國內營業分支機構基本資料維護","國內營業分支機構負責人基本資料"
									,"理監事基本資料維護","使用者帳號LOG","維護人員檔"}
									,{"保證案件月報表(按保證項目)","保證案件月報表(按貸款機關)","本月份與上月份及去年同期保證情形比較表","本月份與上月份及去年同期保證情形比較表_附註"
									,"貸款用途分機表","代位清償案件原因分析表_累計保證","代位清償案件原因分析表","代位清償案件原因分析表_附註","地區別保證案件分析表(農會)"
									,"地區別保證案件分析表(漁會)","身份別_保證案件分析表","系統管理者及使用者基本資料"}};
%>
<%
	String title = "稽核記錄統計管理功能 - 項目明細報表列印";
	//取得時間
	Calendar calendar = Calendar.getInstance();
	calendar.set(calendar.get(1), calendar.get(2), 1);
	int eYear = calendar.get(Calendar.YEAR) - 1911;
	int eMonth = calendar.get(Calendar.MONTH) + 1;
	calendar.add(2, -2);
	calendar.set(calendar.get(1), calendar.get(2), 1);
	int sYear = calendar.get(Calendar.YEAR) - 1911;
	int sMonth = calendar.get(Calendar.MONTH) + 1;
	System.out.println("sDate="+sYear+"/"+sMonth);
	System.out.println("eDate="+eYear+"/"+eMonth);
   	
 	//取得權限
	Properties permission = ( session.getAttribute("CG003W")==null ) ? new Properties() : (Properties)session.getAttribute("CG003W"); 
	if(permission == null){
       System.out.println("CG003W_Qry.permission == null");
    }else{
       System.out.println("CG003W_Qry.permission.size ="+permission.size());               
    }
    
    // 查詢條件值 
    String reportGroup = request.getParameter("reportGroup" )== null ? "A" : (String)request.getParameter("reportGroup");
    String bankType = request.getParameter("bankType" )== null ? "" : (String)request.getParameter("bankType");
    String tbank = request.getParameter("tbank" )== null ? "" : (String)request.getParameter("tbank");
    String cityType = request.getParameter("cityType" )== null ? "" : (String)request.getParameter("cityType");
    
    List bankTypeList = (List)request.getAttribute("Bank_Type");
    List tBankList = (List)request.getAttribute("TBank");
    // XML Ducument for 總機構代碼 begin
    HashMap bankNoMap = new HashMap();
    out.println("<xml version=\"1.0\" encoding=\"big5\" ID=\"TBankXML\">");
    out.println("<datalist>");
    for(int i=0;i< tBankList.size(); i++) {
        DataObject bean =(DataObject)tBankList.get(i);
        out.println("<data>");
        out.println("<bankType>"+bean.getValue("bank_type")+"</bankType>");
        out.println("<bankCity>"+bean.getValue("hsien_id")+"</bankCity>");
        out.println("<bankValue>"+bean.getValue("bank_no")+"</bankValue>");
        out.println("<bankName>"+bean.getValue("bank_no")+"  "+bean.getValue("bank_name")+"</bankName>");
        out.println("</data>");
        bankNoMap.put(bean.getValue("bank_no"),bean.getValue("bank_name"));
    }
    out.println("</datalist>\n</xml>");
    
    
%>
<script language="javascript" src="../js/Common.js"></script>
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
	var qYear = document.form.Q_YEAR.value;
	var qMonth = document.form.Q_MONTH.value;
	if(qMonth.length < 2) qMonth = "0" + qMonth;
	var sYear = document.form.S_YEAR.value;
	var sMonth = document.form.S_MONTH.value;
	if(sMonth.length < 2) sMonth = "0" + sMonth;
	var eYear = document.form.E_YEAR.value;
	var eMonth = document.form.E_MONTH.value;
	if(eMonth.length < 2) eMonth = "0" + eMonth;
	
    if((eval(qYear+qMonth+"01") > eval(eYear+eMonth+"01")) || (eval(qYear+qMonth+"01") < eval(sYear+sMonth+"01"))) {
       alert("只能查詢三個月內資料");
       return;
    }
    if (!confirm("本項報表會執行 15-30 秒，是否確定執行？")){return;}
	this.document.forms[0].action = "/pages/report/CG003W.jsp?act=Excel";
	this.document.forms[0].submit();   
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
<script language="javascript" src="../js/CG003W.js"></script>
<link href="../css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form method=post action='#' name='form'>
<INPUT type="hidden" name=reportGroup value="<%=reportGroup%>">
	<table width="780" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr> 
			<td>　</td>
		</tr>
		<tr> 
			<td bgcolor="#FFFFFF">
				<table width="780" border="0" align="center" cellpadding="1" cellspacing="1">        
					<tr> 
						<td>
							<table width="780" border="0" align="center" cellpadding="0" cellspacing="0">
								<tr> 
									<td width="220"><img src="../images/banner_bg1.gif" width="220" height="17"></td>
									<td width="340">
										<font color='#336600' size=4> 
										<center><%=title%></center>
										</font> 
									</td>
									<td width="220"><img src="../images/banner_bg1.gif" width="220" height="17"></td>
								</tr>
							</table>
						</td>
					</tr>
			        <tr> 
			        	<td><img src="../images/space_1.gif" width="8" height="8"></td>
			        </tr>
			        <tr> 
			          <td>
			          	<table width="780" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#5DA525">
			            	<tr> 
			                	<td bordercolor="#E9F4E3" bgcolor="#E9F4E3">
			                		<table width="780" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#E9F4E3">
			                    		<tr> 
			                      			<td bgcolor="#B0D595" class="sbody"> <div align="right">
			                          			<!--input type='radio' name="excelaction" value='view'  >檢視報表-->
												<input type='radio' name="excelaction" value='download' checked >下載報表  
												<a href="javascript:doSubmit()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image41','','../images/bt_execb.gif',1)"><img src="../images/bt_exec.gif" name="Image41" width="66" height="25" border="0" id="Image41"></a>   
												<a href="javascript:ResetAllData();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image51','','../images/bt_cancelb.gif',0)"><img src="../images/bt_cancel.gif" name="Image51" width="66" height="25" border="0" id="Image51"></a>  
												<a href="法定比率_使用者說明.doc"  target='_Blank' onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image61','','../images/bt_reporthelpb.gif',1)"><img src="../images/bt_reporthelp.gif" name="Image61" width="80" height="25" border="0" id="Image61"></a>  
			                        			</div>
			                        		</td>
			                    		</tr>
			                    		<tr> 
			                      			<td bgcolor="#CDE6BF"> 
			                      				<table width="700" border="0" align="center" cellpadding="1" cellspacing="1" class="sbody">
			                          				<tr class="sbody"> 
			                            				<td width="100"> 
															<table width="780" border="0" align="center" cellpadding="1" cellspacing="1" class="sbody" id="table1">
																			<tr class="sbody"> 
																				<td width="154">
																				<% if(reportGroup.equals("A")){%>
																					<img src="../images/2_icon_01.gif" width="16" height="16" align="absmiddle">
																					<a href="CG003W.jsp?act=Qry&reportGroup=A"><font color="#CC6600">1.經營指標類(A開頭)</font></a>
																				<%}else{%>
																					<a href="CG003W.jsp?act=Qry&reportGroup=A"><font color="black">1.經營指標類(A開頭)</font></a>
																				<%}%>
																				</td>                            
																				<td width="153" class="mtext">
																				<% if(reportGroup.equals("B")){%><img src="../images/2_icon_01.gif" width="16" height="16" align="absmiddle">
																					<a href="CG003W.jsp?act=Qry&reportGroup=B"><font color="#CC6600">2.農發基金類(B開頭)</a>
																				<%}else{%>
																					<a href="CG003W.jsp?act=Qry&reportGroup=B"><font color="black">2.農發基金類(B開頭)</a>
																				<%}%>
																				</td>
																				<td width="166" class="mtext">
																				<% if(reportGroup.equals("EF")){%><img src="../images/2_icon_01.gif" width="16" height="16" align="absmiddle">
																					<a href="CG003W.jsp?act=Qry&reportGroup=EF"><font color="#CC6600">3.檢查缺失類(EF開頭)</a>
																				<%}else{%>
																					<a href="CG003W.jsp?act=Qry&reportGroup=EF"><font color="black">3.檢查缺失類(EF開頭)</a>
																				<%}%>
																				</td>
																				<td width="188" class="mtext">
																				<% if(reportGroup.equals("WZ")){%><img src="../images/2_icon_01.gif" width="16" height="16" align="absmiddle">
																					<a href="CG003W.jsp?act=Qry&reportGroup=WZ"><font color="#CC6600">4.重要業務類(WZ開頭)</a>
																				<%}else{%>
																					<a href="CG003W.jsp?act=Qry&reportGroup=WZ"><font color="black">4.重要業務類(WZ開頭)</a>
																				<%}%>
																				</td>
																				<td width="100" class="mtext">&nbsp;
																				<% if(reportGroup.equals("OTHER")){%><img src="../images/2_icon_01.gif" width="16" height="16" align="absmiddle">
																					<a href="CG003W.jsp?act=Qry&reportGroup=OTHER"><font color="#CC6600">5.其他類別</a>                           
																				<%}else{%>
																					<a href="CG003W.jsp?act=Qry&reportGroup=OTHER"><font color="black">5.其他類別</a>                       
																				<%}%>
																				</td>                                                                                   
																			</tr>
																		</table>
			                        					</td>               
			                          				</tr>
			                        			</table>
			                        		</td>
			                    		</tr>
			                    		<tr> 
			                      			<td bgcolor="#E9F4E3"> 
			                      				<table width="780" border="0" align="center" cellpadding="0" cellspacing="0">
			                          				<tr class="sbody">
			                          					<td width="17">
			                          						<img src="../images/2_icon_01.gif" width="16" height="16" align="absmiddle"> 
			                          					</td>
			                          					<td width="742">
			                          						<span class="mtext">年月 :</span> 						  						               
			                            					<input type='hidden' name='S_YEAR' value="<%=sYear%>" size='3' maxlength='3'>
			                            					<input type='hidden' name='S_MONTH' value="<%=sMonth%>" size='3' maxlength='3'>
			                            					<input type='hidden' name='E_YEAR' value="<%=eYear%>" size='3' maxlength='3'>
			                            					<input type='hidden' name='E_MONTH' value="<%=eMonth%>" size='3' maxlength='3'>
															
															<input type='text' name='Q_YEAR' value="<%=eYear%>" size='3' maxlength='3' onblur='CheckYear(this)'>
															<font color='#000000'>年</font>
															<select id="hide1" name='Q_MONTH'>        						
															<%
															calendar = Calendar.getInstance();
															calendar.add(2, -2);
															int tmMonth = calendar.get(Calendar.MONTH) + 1;
															if(tmMonth < 10){
																out.print("<option value='0"+tmMonth+"'");
																if(tmMonth==eMonth) out.print(" selected ");
																out.println(">0"+tmMonth+"</option>");
															}else{
																out.print("<option value='"+tmMonth+"'");
																if(tmMonth==eMonth) out.print(" selected ");
																out.println(">"+tmMonth+"</option>");
															}
																														
                											calendar.add(2, 1);
                											tmMonth = calendar.get(Calendar.MONTH) + 1;
															if(tmMonth < 10){
																out.print("<option value='0"+tmMonth+"'");
																if(tmMonth==eMonth) out.print(" selected ");
																out.println(">0"+tmMonth+"</option>");
															}else{
																out.print("<option value='"+tmMonth+"'");
																if(tmMonth==eMonth) out.print(" selected ");
																out.println(">"+tmMonth+"</option>");
															}
                											
															calendar.add(2, 1);
                											tmMonth = calendar.get(Calendar.MONTH) + 1;
															if(tmMonth < 10){
																out.print("<option value='0"+tmMonth+"'");
																if(tmMonth==eMonth) out.print(" selected ");
																out.println(">0"+tmMonth+"</option>");
															}else{
																out.print("<option value='"+tmMonth+"'");
																if(tmMonth==eMonth) out.print(" selected ");
																out.println(">"+tmMonth+"</option>");
															}
															%>        		
															</select><font color='#000000'>月</font>
			                          					</td>
			                          					<td width="15">	
			                          					</td>
			                          				</tr>  
			                          				<tr class="sbody">
														<td width="17">
															<img src="../images/2_icon_01.gif" width="16" height="16" align="absmiddle"> 
														</td>
														<td colspan="2" width="759"><span class="mtext">金融機構類別 :</span> 	                
															<select size="1" name="bankType" onChange="checkCity();resetOption();changeOption('TBankXML',form.tbank, form.bankType, 'TBankXML')">
																<option value="">全部類別</option>
															<%   
																if(bankTypeList != null) {
																	for(int i=0; i < bankTypeList.size(); i++) {
																		DataObject bean =(DataObject)bankTypeList.get(i);
															%>   
																		<option value="<%=bean.getValue("cmuse_id")%>"><%=bean.getValue("cmuse_name")%></option>
															<%      
																	}
																}
															%>
															</select>
			                          					</td>
													</tr>
													<tr class="sbody">
								                        <td width="17">	
								                        	<img src="../images/2_icon_01.gif" width="16" height="16" align="absmiddle"> 
								                        </td>
			                          					<td colspan="2" width="759">
			                          						<span class="mtext">縣市別 :</span> 	                
															<select size="1" name="cityType" onChange="changeCity2('TBankXML', form.tbank, form.cityType, form)" >
																<option value="">全部</option>
																<%   
																List cityList = (List) request.getAttribute("City");
																if(cityList != null) {
																	for(int i=0; i < cityList.size(); i++) {
																		DataObject bean =(DataObject)cityList.get(i);
																%>   
																		<option value="<%=bean.getValue("hsien_id")%>"><%=bean.getValue("hsien_name")%></option>
																<%       
																	}
																}
																%>
															</select>
			                          					</td>
			                          				</tr>
			                          				<tr class="sbody">
			                          					<td width="17">
			                          						<img src="../images/2_icon_01.gif" width="16" height="16" align="absmiddle"> 
			                          					</td>
														<td colspan="2" width="759"><span class="mtext">總機構單位 :</span> 	                
															<select size="1" name="tbank">
																<option value="">全部</option>
															</select>
														</td>
			                          				</tr>
													<tr class="sbody">
														<td width="17">
															<img src="../images/2_icon_01.gif" width="16" height="16" align="absmiddle"> 
														</td>
														<td colspan="2" width="759"><span class="mtext">報表類別 :</span> 	                
															<select size=1  name="tbName">
															<%
																int itemIndex=0;
																if(reportGroup.equals("A"))
																	itemIndex=0;
																else if(reportGroup.equals("B"))
																	itemIndex=1;
																else if(reportGroup.equals("EF"))
																	itemIndex=2;
																else if(reportGroup.equals("WZ"))
																	itemIndex=3;
																else if(reportGroup.equals("OTHER"))
																	itemIndex=4;
																for(int ai=0;ai<tableEName[itemIndex].length;ai++){
																	out.println("<option value='"+tableEName[itemIndex][ai]+"@"+tableCName[itemIndex][ai]+"'>"+tableCName[itemIndex][ai]+"("+tableEName[itemIndex][ai]+")</option>");
																}
															%>
															</select>
														</td>
													</tr>
													
													<tr class="sbody">
			                          					<td width="17">
			                          						<img src="../images/2_icon_01.gif" width="16" height="16" align="absmiddle"> 
			                          					</td>
														<td colspan="2" width="759"><span class="mtext">輸出格式 :</span> 	                
																<input name='printStyle' type='radio' value='xls' checked>Excel
  				 												<input name='printStyle' type='radio' value='ods' >ODS
  				 												<input name='printStyle' type='radio' value='pdf' >PDF
														</td>
			                          				</tr>
													
                    							</table>
                    						</td>
                						</tr>
              						</table>
              					</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>

<script language="JavaScript" >
<!--
setSelect(form.bankType,"<%=bankType%>");
changeOption('TBankXML',form.tbank, form.bankType, 'TBankXML');
setSelect(form.tbank,"<%=tbank%>");
setSelect(form.cityType,"<%=cityType%>");
checkCity();
-->
</script>
</html>

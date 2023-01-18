<%
//95.10.30
//CG001W 稽核記錄統計管理功能 - 統計報表列印
//created by ABYSS Brenda
//104.10.07 add rs.close by 2295
//108.05.15 add 報表格式挑選 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.sql.*"%>
<%@ page import="com.tradevan.util.dao.RdbCommonDao"%>
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
									,"M06_log","M07_log","M08_log","MUSER_DATA_log","WTT06", "WTT01"}};
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
									,{"保證案件月報表(按保證目)","保證案件月報表(按貸款機關)","本月份與上月份及去年同期保證情形比較表","本月份與上月份及去年同期保證情形比較表_附註"
									,"貸款用途分機表","代位清償案件原因分析表_累計保證","代位清償案件原因分析表","代位清償案件原因分析表_附註","地區別保證案件分析表(農會)"
									,"地區別保證案件分析表(漁會)","身份別_保證案件分析表","系統管理者及使用者基本資料","使用者帳號期間未使用報表","使用者帳號數量統計概況表"}};
%>
<%
	String title = "稽核記錄統計管理功能 - 統計報表列印";
	Calendar rightNow = Calendar.getInstance();
	String thisYear  = String.valueOf(rightNow.get(1)-1911); //回覆值為西元年故需-1911取得民國年;	
	System.out.println("thisYear="+thisYear);
	int thisMonth = rightNow.get(2)+1;
	//取得權限
	Properties permission = ( session.getAttribute("CG001W")==null ) ? new Properties() : (Properties)session.getAttribute("CG001W"); 
	if(permission == null){
		System.out.println("CG001W_Qry.permission == null");
	}else{
		System.out.println("CG001W_Qry.permission.size ="+permission.size());               
	}
	String reportGroup = request.getParameter("reportGroup")==null?"A":request.getParameter("reportGroup");
	Connection conn =null;
	ResultSet rs = null;
	List cmustList = new ArrayList();
	try{
		conn = (new RdbCommonDao("")).newConnection();
		String selCmd = "SELECT CMUSE_ID,CMUSE_NAME FROM CDSHARENO WHERE CMUSE_DIV = '001' AND CMUSE_ID <> 'Z' ORDER BY CMUSE_DIV,CMUSE_ID";
		rs = conn.createStatement().executeQuery(selCmd);
		while(rs.next()){
			String optionStr = "<option value='"+rs.getString(1)+"'>"+rs.getString(2)+"</option>";
			cmustList.add(optionStr);
		}
	}catch(Exception ex){
		
	}finally{
		try{
			if(rs != null){
			    rs.close();//104.10.07 add
			    rs =  null;
			}
			if(!conn.isClosed()){//104.10.07 add
			    conn.close();
			    conn = null;
			}
		    
		}catch(Exception sqlEx){
			conn=null;
		}
	}
%>
<script language="javascript" src="../js/Common.js"></script>
<script language="javascript" src="../js/FR0066W.js"></script>
<script language="javascript" src="../js/BRUtil.js"></script>
<script language="javascript" src="../js/movesels.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
	<head>
		<title><%=title%></title>
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
			var p,i,x;
			if(!d) d=document;
			if((p=n.indexOf("?"))>0&&parent.frames.length) {
				d=parent.frames[n.substring(p+1)].document;
				n=n.substring(0,p);
			}
			if(!(x=d[n])&&d.all) x=d.all[n];
				for (i=0;!x&&i<d.forms.length;i++)
					x=d.forms[i][n];
				for(i=0;!x&&d.layers&&i<d.layers.length;i++)
					x=MM_findObj(n,d.layers[i].document);
				if(!x && d.getElementById)
					x=d.getElementById(n);
				return x;
		}
		function MM_swapImage() { //v3.0
			var i,j=0,x,a=MM_swapImage.arguments;
			document.MM_sr=new Array;
			for(i=0;i<(a.length-2);i+=3){
				if ((x=MM_findObj(a[i]))!=null){
					document.MM_sr[j++]=x;
					if(!x.oSrc) x.oSrc=x.src;
					x.src=a[i+2];
				}
			}
		}
		
		function MM_jumpMenu(targ,selObj,restore){ //v3.0
			eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
			if (restore) selObj.selectedIndex=0;
		}
		
//-->
			function PrintReport(reportGroupVar){
				var bankList = document.BankListfrm.BankListDst2;
				var si = bankList.length;
				if(si==0){
					alert('請至少選擇一項欲查詢項目');
					return;
				}
				if(reportGroupVar=='OTHER'){
					for(var ai=0; ai<si; ai++){
						if(bankList[ai].value == "WTT06" && si>1){
							alert("使用者帳號期間未使用報表,不得於其他報表一併列印");
							return;
						}
						if(bankList[ai].value == "WTT01" && si>1){
							alert("使用者帳號數量統計概況表,不得於其他報表一併列印");
							return;
						}
					}
				}
				var OptionValue1 = new Array();
				for(i=0;i<si;i++){
					OptionValue1[i] = document.BankListfrm.BankListDst2.options[i].value;
				}
				this.document.forms[0].BankListDst.value = OptionValue1;
				this.document.forms[0].action = "/pages/report/CG001W.jsp?act=Excel";
				
				if (!confirm("本項報表會執行 15-30 秒，是否確定執行？")){return;}
				this.document.forms[0].submit();
			}
			
			function AllPrintReport(){
				this.document.forms[0].action = "/pages/report/CG001W.jsp?act=Excel";
				if (!confirm("本項報表會執行 25-50 秒，是否確定執行？")){return;}
				this.document.forms[0].submit();
			}
		</script>
		<link href="../css/b51.css" rel="stylesheet" type="text/css">
	</head>
	<body leftmargin="0" topmargin="0">
		<form method=post action='' name='BankListfrm'>
			<input type="hidden" name="reportGroup" value="<%=reportGroup%>">
			<table width="780" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr> 
					<td>&nbsp;</td>
				</tr>
				<tr> 
					<td bgcolor="#FFFFFF">
						<table width="780" border="0" align="center" cellpadding="1" cellspacing="1">        
							<tr> 
								<td>
									<table width="780" border="0" align="center" cellpadding="0" cellspacing="0">
										<tr> 
											<td width="220"><img src="../images/banner_bg1.gif" width="220" height="17"></td>
											<td width="340"><font color='#000000' size=4> 
												<font color='#336600' size=4> 
												<center><%=title%></center>
												</font> 
											</font></td>
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
														<td bgcolor="#B0D595" class="sbody" align="right">
															<!--input type='radio' name="excelaction" value='view'  >檢視報表-->
															<input type='radio' name="excelaction" value='download' checked >下載報表  
															<a href="javascript:PrintReport('<%=reportGroup%>');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image41','','../images/bt_execb.gif',1)"><img src="../images/bt_exec.gif" name="Image41" width="66" height="25" border="0" id="Image41"></a>   
															<a href="javascript:ResetAllData();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image51','','../images/bt_cancelb.gif',0)"><img src="../images/bt_cancel.gif" name="Image51" width="66" height="25" border="0" id="Image51"></a>  
															<a href="#"  target='_Blank' onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image61','','../images/bt_reporthelpb.gif',1)"><img src="../images/bt_reporthelp.gif" name="Image61" width="80" height="25" border="0" id="Image61"></a>  
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
																					<a href="CG001W_Qry.jsp?reportGroup=A"><font color="#CC6600">1.經營指標類(A開頭)</font></a>
																				<%}else{%>
																					<a href="CG001W_Qry.jsp?reportGroup=A"><font color="black">1.經營指標類(A開頭)</font></a>
																				<%}%>
																				</td>                            
																				<td width="153" class="mtext">
																				<% if(reportGroup.equals("B")){%><img src="../images/2_icon_01.gif" width="16" height="16" align="absmiddle">
																					<a href="CG001W_Qry.jsp?reportGroup=B"><font color="#CC6600">2.農發基金類(B開頭)</a>
																				<%}else{%>
																					<a href="CG001W_Qry.jsp?reportGroup=B"><font color="black">2.農發基金類(B開頭)</a>
																				<%}%>
																				</td>
																				<td width="166" class="mtext">
																				<% if(reportGroup.equals("EF")){%><img src="../images/2_icon_01.gif" width="16" height="16" align="absmiddle">
																					<a href="CG001W_Qry.jsp?reportGroup=EF"><font color="#CC6600">3.檢查缺失類(EF開頭)</a>
																				<%}else{%>
																					<a href="CG001W_Qry.jsp?reportGroup=EF"><font color="black">3.檢查缺失類(EF開頭)</a>
																				<%}%>
																				</td>
																				<td width="188" class="mtext">
																				<% if(reportGroup.equals("WZ")){%><img src="../images/2_icon_01.gif" width="16" height="16" align="absmiddle">
																					<a href="CG001W_Qry.jsp?reportGroup=WZ"><font color="#CC6600">4.重要業務類(WZ開頭)</a>
																				<%}else{%>
																					<a href="CG001W_Qry.jsp?reportGroup=WZ"><font color="black">4.重要業務類(WZ開頭)</a>
																				<%}%>
																				</td>
																				<td width="100" class="mtext">&nbsp;
																				<% if(reportGroup.equals("OTHER")){%><img src="../images/2_icon_01.gif" width="16" height="16" align="absmiddle">
																					<a href="CG001W_Qry.jsp?reportGroup=OTHER"><font color="#CC6600">5.其他類別</a>                           
																				<%}else{%>
																					<a href="CG001W_Qry.jsp?reportGroup=OTHER"><font color="black">5.其他類別</a>                       
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
																	<td colspan="2" width="742" class="mtext">起迄年月 : 						  						               
																		<input type='text' name='S_YEAR' size='3' maxlength='3' onblur='CheckYear(this)' value='<%=thisYear%>'>年     
																		<select name='S_MONTH'>
<%
																		for(int mi=1;mi<=12;mi++){
																			if(mi<10)
																				out.print("<option value='0"+mi+"'");
																			else
																				out.print("<option value='"+mi+"'");
																			if(mi==thisMonth)
																				out.print(" selected ");
																			if(mi<10)
																				out.println(">0"+mi+"</option>");
																			else
																				out.println(">"+mi+"</option>");
																		}
%>
																		</select> 月~
																		<input type='text' name='E_YEAR' size='3' maxlength='3' onblur='CheckYear(this)' value='<%=thisYear%>'>年
																		<select name='E_MONTH'>
<%
																		for(int mi=1;mi<=12;mi++){
																			if(mi<10)
																				out.print("<option value='0"+mi+"'");
																			else
																				out.print("<option value='"+mi+"'");
																			if(mi==thisMonth)
																				out.print(" selected ");
																			if(mi<10)
																				out.println(">0"+mi+"</option>");
																			else
																				out.println(">"+mi+"</option>");
																		}
%>
																		</select>月
																	</td>
																</tr>  
																<tr class="sbody">
																	<td width="17">
																		<img src="../images/2_icon_01.gif" width="16" height="16" align="absmiddle"> 
																	</td>
																	<td colspan="2" width="759" class="mtext">機構類別 :
																		<select name='BANK_TYPE' size="1">
																			<option value="ALL">全部</option>
<%
																		for(int li=0;li<cmustList.size();li++){
																			out.println((String)cmustList.get(li));
																		}
%> 
																		</select>
																	</td>
																</tr>
																<tr class="sbody">
																	<td width="17">
																		<img src="../images/2_icon_01.gif" width="16" height="16" align="absmiddle"> 
																	</td>
																	<td width="759" class="mtext">報表格式 :
																		<select name='REPORT_TYPE' size="1">
																			<option  value="1">稽核記錄統計總表</option>
																			<option  value="2">稽核記錄統計明細表</option>                           	
																		</select>
																	</td>
																	<td width="15">
																		<input type='button' name='button1' value='所有類別' onClick="javascript:AllPrintReport();">
																	</td>
																</tr>
																
																<tr class="sbody">
																	<td width="17">
																		<img src="../images/2_icon_01.gif" width="16" height="16" align="absmiddle"> 
																	</td>
																	<td width="759" class="mtext">輸出格式 :
																		<input name='printStyle' type='radio' value='xls' checked>Excel
  				 														<input name='printStyle' type='radio' value='ods' >ODS
  				 														<input name='printStyle' type='radio' value='pdf' >PDF
																	</td>
																</tr>
																
															</table>
														</td>
													</tr>
													<tr> 
														<td bgcolor="#E9F4E3">
															<table width="779" border="0" align="center" cellpadding="1" cellspacing="1" bgcolor="#E9F4E3">
																<tr> 
																	<td width="195" bgcolor="#BFDFAE">可選擇項目</td>
																	<td width="52" bgcolor="#BFDFAE">&nbsp;</td>
																	<td width="189" bgcolor="#BFDFAE">已選擇項目</td>
																</tr>
																<tr> 
																	<td width="195">  
																		<select multiple  size=10  name="BankListSrc" ondblclick="javascript:movesel(this.document.forms[0].BankListSrc,this.document.forms[0].BankListDst2);" style="width: 300">
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
																				out.println("<option value='"+tableEName[itemIndex][ai]+"'>"+tableCName[itemIndex][ai]+"("+tableEName[itemIndex][ai]+")</option>");
																			}
%>
																		</select>
																	</td>
																	<td width="52">
																		<table width="40" border="0" align="center" cellpadding="3" cellspacing="3">
																			<tr> 
																				<td align="center">                                 
																					<a href="javascript:movesel(this.document.forms[0].BankListSrc,this.document.forms[0].BankListDst2);"><img src="../images/arrow_right.gif" width="24" height="22" border="0"></a>
																				</td>
																			</tr>
																			<tr> 
																				<td align="center">                                  
																					<a href="javascript:moveallsel(this.document.forms[0].BankListSrc,this.document.forms[0].BankListDst2);"><img src="../images/arrow_rightall.gif" width="24" height="22" border="0"></a>
																				</td>
																			</tr>
																			<tr> 
																				<td align="center">                                  
																					<a href="javascript:movesel(this.document.forms[0].BankListDst2,this.document.forms[0].BankListSrc);"><img src="../images/arrow_left.gif" width="24" height="22" border="0"></a>
																				</td>
																			</tr>
																			<tr> 
																				<td height="22" align="center">                                  
																					<a href="javascript:moveallsel(this.document.forms[0].BankListDst2,this.document.forms[0].BankListSrc);"><img src="../images/arrow_leftall.gif" width="24" height="22" border="0"></a>
																				</td>
																			</tr>
																		</table>
																	</td>
																	<td width="189"> 
																		<select multiple size=10  name="BankListDst2" ondblclick="javascript:movesel(this.document.forms[0].BankListDst,this.document.forms[0].BankListSrc);" style="width: 300">							
																			
																		</select>
																		<input type="hidden" name="BankListDst">
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
</html>

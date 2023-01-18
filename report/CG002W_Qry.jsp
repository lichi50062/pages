<%
// 95.10.30
// CG002W 稽核記錄統計管理功能 - 清檔備份
// created by ABYSS Brenda
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.HashMap" %>
<%
	String title = "稽核記錄統計管理功能 - 清檔備份";
	
   	//取得時間
	Calendar calendar = Calendar.getInstance();
	calendar.add(2, -3);
	calendar.set(calendar.get(1), calendar.get(2), 1);
	int eYear = calendar.get(Calendar.YEAR) - 1911;
	int eMonth = calendar.get(Calendar.MONTH) + 1;
	calendar.add(2, -2);
	calendar.set(calendar.get(1), calendar.get(2), 1);
	int sYear = calendar.get(Calendar.YEAR) - 1911;
	int sMonth = calendar.get(Calendar.MONTH) + 1;
   	
   	String isBakDB = ( request.getParameter("isBakDB")==null ) ? null :request.getParameter("isBakDB").toString();
   	System.out.println("isBakDB=" + isBakDB);
   	if(isBakDB == null){
   		
   	}else if(isBakDB.equals("")){%>
   		<script>
   			alert("備份成功！");
   		</script>
   	<%}else{%>
   		<script>
   			alert("備份失敗！'<%=isBakDB%>'");
   		</script>
   	<%}
   	
 	//取得權限
	Properties permission = ( session.getAttribute("CG002W")==null ) ? new Properties() : (Properties)session.getAttribute("CG002W"); 
	if(permission == null){
       System.out.println("CG002W_Qry.permission == null");
    }else{
       System.out.println("CG002W_Qry.permission.size ="+permission.size());               
    }
%>
<script language="javascript" src="../js/Common.js"></script>
<script language="javascript" src="../js/AN000W.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=big5">
		<script language="JavaScript" type="text/JavaScript">
			function doSubmit(){      
				var chkYear = document.form.chkYear.value;
				var chkMonth = document.form.chkMonth.value;
				if(chkMonth.length < 2) chkMonth = "0" + chkMonth;
				var sYear = document.form.S_YEAR.value;
				var sMonth = document.form.S_MONTH.value;
				var eYear = document.form.E_YEAR.value;
				var eMonth = document.form.E_MONTH.value;
				
	            if(eval(sYear+sMonth+"01") > eval(eYear+eMonth+"01")) {
			       alert("開始日期不能小於結束日期");
			       return;
			    }
			    
			    if(eval(chkYear+chkMonth+"01") < eval(eYear+eMonth+"01")) {
			       alert("不可備份三個月內資料，請重新選擇日期");
			       return;
			    }
			    if (!confirm("本項功能會執行 30-60 分鐘，是否確定執行？")){return;}
				this.document.forms[0].action = "/pages/report/CG002W.jsp?act=Log";
				this.document.forms[0].submit();   
			}
		</script>
		<!-- <link href="../css/b51.css" rel="stylesheet" type="text/css"> -->
	</head>
	<body leftmargin="0" topmargin="0">
		<form name='form' method=post action='#'>
			<input type='hidden' name='chkYear' value="<%=eYear%>">
			<input type='hidden' name='chkMonth' value="<%=eMonth%>">
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
											<td width="340"><font color='#336600' size=4><center><%=title%></center></font></td>
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
															<a href="javascript:doSubmit()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image41','','../images/bt_execb.gif',1)"><img src="../images/bt_exec.gif" name="Image41" width="66" height="25" border="0" id="Image41"></a>   
															<a href="javascript:ResetAllData();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image51','','../images/bt_cancelb.gif',0)"><img src="../images/bt_cancel.gif" name="Image51" width="66" height="25" border="0" id="Image51"></a>  
															<a href="../法定比率_使用者說明.doc"  target='_Blank' onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image61','','../images/bt_reporthelpb.gif',1)"><img src="../images/bt_reporthelp.gif" name="Image61" width="80" height="25" border="0" id="Image61"></a>  
														</div></td>
													</tr>
													<tr> 
														<td bgcolor="#E9F4E3"> 
															<table width="780" border="0" align="center" cellpadding="0" cellspacing="0">
																<tr>
																	<td width="17"><img src="../images/2_icon_01.gif" width="16" height="16" align="absmiddle"> 
																	</td>
																		<td width="742"><span class="mtext">起迄年月 :</span> 						  						               
																		<input type='text' name='S_YEAR' value="<%=sYear%>" size='3' maxlength='3' onblur='CheckYear(this)'>
																		<font color='#000000'>年</font>
																		<select id="hide1" name=S_MONTH>        						
																		<%
																		for(int mi=1;mi<=12;mi++){
																			if(mi<10)
																				out.print("<option value='0"+mi+"'");
																			else
																				out.print("<option value='"+mi+"'");
																			if(mi==sMonth)
																				out.print(" selected ");
																			if(mi<10)
																				out.println(">0"+mi+"</option>");
																			else
																				out.println(">"+mi+"</option>");
																		}
																		%>
																		</select><font color='#000000'>月</font>
																		~
																		<input type='text' name='E_YEAR' value="<%=eYear%>" size='3' maxlength='3' onblur='CheckYear(this)'>
																		<font color='#000000'>年</font>
																		<select id="hide1" name=E_MONTH>        						
																		<%
																		for(int mi=1;mi<=12;mi++){
																			if(mi<10)
																				out.print("<option value='0"+mi+"'");
																			else
																				out.print("<option value='"+mi+"'");
																			if(mi==eMonth)
																				out.print(" selected ");
																			if(mi<10)
																				out.println(">0"+mi+"</option>");
																			else
																				out.println(">"+mi+"</option>");
																		}
																		%>        		
																		</select><font color='#000000'>月</font>
																	</td>
																	<td width="15">	
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

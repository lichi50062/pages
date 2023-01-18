<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%
	String szbank_type = ( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");
	String sztbank_no = ( request.getParameter("tbank_no")==null ) ? "" : (String)request.getParameter("tbank_no");
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");
	String EVENT_DATE_Y ="";
	String EVENT_DATE_M ="";
	String EVENT_DATE_D ="";
	String RT_DATE_Y ="";
	String RT_DATE_M ="";
	String RT_DATE_D ="";

	System.out.println("TC42_Edit.sztbank_no="+sztbank_no);

	List EXWARNINGF = (List)request.getAttribute("EXWARNINGF");
	System.out.println("EXWARNINGF.size="+EXWARNINGF.size());
	//2004/01/01轉換為93 01 01處理
	if(EXWARNINGF != null){
		if(EXWARNINGF.size() != 0){
   	    	int i = 0;
   	    	String EVENT_DATE="";
   	    	String RT_DATE="";
			if(((DataObject)EXWARNINGF.get(0)).getValue("eventdate") != null){
				System.out.println("日期轉換處理");
			   	//事件日期轉換處理
			   	EVENT_DATE = Utility.getCHTdate((((DataObject)EXWARNINGF.get(0)).getValue("eventdate")).toString().substring(0, 10), 0);
			   	System.out.println("@@EVENT_DATE="+EVENT_DATE);
			   	i = 0;
			   	if(EVENT_DATE.length() == 9) i = 1;
			   	EVENT_DATE_Y = EVENT_DATE.substring(0,2+i);
			   	EVENT_DATE_M = EVENT_DATE.substring(3+i,5+i);
			   	EVENT_DATE_D = EVENT_DATE.substring(6+i,EVENT_DATE.length());
			   	System.out.println("@@EVENT_DATE_Y="+EVENT_DATE_Y);
			   	System.out.println("@@EVENT_DATE_M="+EVENT_DATE_M);
			   	System.out.println("@@EVENT_DATE_D="+EVENT_DATE_D);
			}
			if(((DataObject)EXWARNINGF.get(0)).getValue("rt_date") != null){
				System.out.println("日期轉換處理");
			   	//事件日期轉換處理
			   	RT_DATE = Utility.getCHTdate((((DataObject)EXWARNINGF.get(0)).getValue("rt_date")).toString().substring(0, 10), 0);
			   	System.out.println("@@RT_DATE="+RT_DATE);
			   	i = 0;
			   	if(RT_DATE.length() == 9) i = 1;
			   	RT_DATE_Y = RT_DATE.substring(0,2+i);
			   	RT_DATE_M = RT_DATE.substring(3+i,5+i);
			   	RT_DATE_D = RT_DATE.substring(6+i,RT_DATE.length());
			   	System.out.println("@@RT_DATE_Y="+RT_DATE_Y);
			   	System.out.println("@@RT_DATE_M="+RT_DATE_M);
			   	System.out.println("@@RT_DATE_D="+RT_DATE_D);
			}
		}
	}else {
		System.out.println("LIST EXWARNINGF = NULL");
	}

	String title="專長代號";
	title =(act.equals("Edit"))?title+"異動維護建檔":title;
	title =(act.equals("new"))?title+"新增維護建檔":title;

	//取得TC42的權限
	Properties permission = ( session.getAttribute("TC42")==null ) ? new Properties() : (Properties)session.getAttribute("TC42");
	if(permission == null){
       System.out.println("TC42_Edit.permission == null");
    }else{
       System.out.println("TC42_Edit.permission.size ="+permission.size());

    }
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/TC42.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<title><%=title%></title>
<link href="css/b51.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
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
//-->
</script>
</head>

<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" leftmargin="0">
<form method=post action='#'>
<input type="hidden" name="act" value="">
<table width="600" border="0" align="left" cellpadding="0" cellspacing="1" bgcolor="#FFFFFF">
  		<tr>
   		 <td><img src="images/space_1.gif" width="12" height="12"></td>
  		</tr>
        <tr>
          <td bgcolor="#FFFFFF">
			<table width="560" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr>
                <td><table width="560" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="110"><img src="images/banner_bg1.gif" width="110" height="17"></td>
                      <td width="380"><font color='#000000' size=4><b>
                        <center>
                          <%=title%>
                        </center>
                        </b></font> </td>
                      <td width="110"><img src="images/banner_bg1.gif" width="110" height="17"></td>
                    </tr>
                  </table></td>
              </tr>
              <tr>
                <td><img src="images/space_1.gif" width="12" height="12"></td>
              </tr>
              <tr>
                <td><table width="560" border="0" align="center" cellpadding="0" cellspacing="0">

                    <tr>
                      <div align="right"><jsp:include page="getLoginUser.jsp?width=560" flush="true" /></div>
                    </tr>
                    <tr>
                      <td><table width=560 border=1 align=center cellpadding="1" cellspacing="1" bordercolor="#76C657">
                    <tr class="sbody">
						 <td width='15%' align='left' bgcolor='#BDDE9C'>金融機構類別</td>
						 <% List bank_type = DBManager.QueryDB_SQLParam("select cmuse_id,cmuse_name from cdshareno where cmuse_div='020' order by input_order",null,"");%>
						 <td width='85%' colspan=2 bgcolor='EBF4E1'>
                         	<select name='BANK_TYPE' >
                           	<%for(int i=0;i<bank_type.size();i++){%>
                           		<option value="<%=(String)((DataObject)bank_type.get(i)).getValue("cmuse_id")%>"
                           		<%if( ((DataObject)bank_type.get(i)).getValue("cmuse_id") != null &&  (szbank_type.equals((String)((DataObject)bank_type.get(i)).getValue("cmuse_id")))) out.print("selected");%>
                           	>
                           	<%=(String)((DataObject)bank_type.get(i)).getValue("cmuse_name")%></option>
                           	<%}%>
                           	</select>
                          </td>
                         </td>

                    </tr>
                    <tr class="sbody">
						<td width='15%' align='left' bgcolor='#BDDE9C'>金融機構</td>
						<input type='hidden' name='SERIAL' value="<%=(((DataObject)EXWARNINGF.get(0)).getValue("serial")).toString()%>">
						<%List bank_no_list = (List)request.getAttribute("bank_no");
						 	System.out.println("TC51_List.getAttribute.size="+bank_no_list.size());
						%>
						  <td width='85%' colspan=2 bgcolor='EBF4E1'>
                            <select name='BANK_NO'>
                            <%for(int i=0;i<bank_no_list.size();i++){%>
                            <option value="<%=(String)((DataObject)bank_no_list.get(i)).getValue("bank_no")%>"
                            <%if(((String)((DataObject)bank_no_list.get(i)).getValue("bank_no")).equals("0")) out.print("selected");%>
                            >
                            <%=(String)((DataObject)bank_no_list.get(i)).getValue("bank_no")%>
                            <%=(String)((DataObject)bank_no_list.get(i)).getValue("bank_name")%></option>
                            <%}%>
                            </select>
                           </td>
                          </td>

                    </tr>
                    <tr class="sbody">
						  <td width='15%' align='left' bgcolor='#BDDE9C'>事件發生日期</td>
						  <td width='85%' colspan=2 bgcolor='EBF4E1'>
						    <input type='hidden' name='EVENT_DATE' value="">
                            <input type='text' name='EVENT_DATE_Y' value="<%=EVENT_DATE_Y%>" size='3' maxlength='3' onblur='CheckYear(this)'>
        						<font color='#000000'>年
        						<select id="hide1" name=EVENT_DATE_M>
        						<option></option>
        						<%
        							for (int j = 1; j <= 12; j++) {
        							if (j < 10){%>
        							<option value=0<%=j%> <%if(EVENT_DATE_M.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>
            						<%}else{%>
            						<option value=<%=j%> <%if(EVENT_DATE_M.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select></font><font color='#000000'>月
        						<select id="hide1" name=EVENT_DATE_D>
        						<option></option>
        						<%
        							for (int j = 1; j < 32; j++) {
        							if (j < 10){%>
        							<option value=0<%=j%> <%if(EVENT_DATE_D.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>
            						<%}else{%>
            						<option value=<%=j%> <%if(EVENT_DATE_D.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select></font><font color='#000000'>日</Font>
        				  </td>
	  			   </tr>
                    <tr class="sbody">
						<td width='15%' align='left' bgcolor='#BDDE9C'>農金局收文文號</td>
						<td width='85%' colspan=2 bgcolor='EBF4E1'>
                          	<%if(act.equals("Edit")){%>
                          		<input type='hidden' name='RT_DOCNO' value="<%if(EXWARNINGF != null && EXWARNINGF.size() != 0 && ((DataObject)EXWARNINGF.get(0)).getValue("rt_docno") != null ) out.print((String)((DataObject)EXWARNINGF.get(0)).getValue("rt_docno"));%>">
  		                     	<%if(EXWARNINGF != null && EXWARNINGF.size() != 0 && ((DataObject)EXWARNINGF.get(0)).getValue("rt_docno") != null ) out.print((String)((DataObject)EXWARNINGF.get(0)).getValue("rt_docno"));%>
                            <%}else{%>
                            	<input type='text' name='RT_DOCNO' value="<%if(EXWARNINGF != null && EXWARNINGF.size() != 0 && ((DataObject)EXWARNINGF.get(0)).getValue("rt_docno") != null ) out.print((String)((DataObject)EXWARNINGF.get(0)).getValue("rt_docno"));%>" size='20' maxlength='20'>
                            <%}%>
                          </td>
                          </tr>
                   <tr class="sbody">
						  <td width='15%' align='left' bgcolor='#BDDE9C'>收文日期</td>
						  <td width='85%' colspan=2 bgcolor='EBF4E1'>
						    <input type='hidden' name='RT_DATE' value="">
                            <input type='text' name='RT_DATE_Y' value="<%=RT_DATE_Y%>" size='3' maxlength='3' onblur='CheckYear(this)'>
        						<font color='#000000'>年
        						<select id="hide1" name=RT_DATE_M>
        						<option></option>
        						<%
        							for (int j = 1; j <= 12; j++) {
        							if (j < 10){%>
        							<option value=0<%=j%> <%if(RT_DATE_M.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>
            						<%}else{%>
            						<option value=<%=j%> <%if(RT_DATE_M.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select></font><font color='#000000'>月
        						<select id="hide1" name=RT_DATE_D>
        						<option></option>
        						<%
        							for (int j = 1; j < 32; j++) {
        							if (j < 10){%>
        							<option value=0<%=j%> <%if(RT_DATE_D.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>
            						<%}else{%>
            						<option value=<%=j%> <%if(RT_DATE_D.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select></font><font color='#000000'>日</Font>
        				  </td>
	  			   </tr>
                   <tr class="sbody">
						<td width='15%' align='left' bgcolor='#BDDE9C'>項目別</td>
						<% List item_id = DBManager.QueryDB_SQLParam("SELECT ITEM_ID,ITEM_NAME FROM EXWARNIDF ORDER BY ITEM_ID",null,"");%>
						<td width='85%' colspan=2 bgcolor='EBF4E1'>
							<%if(act.equals("Edit")){%>
								<select name='ITEM_ID' >
                     			<%for(int i=0;i<item_id.size();i++){%>
                     				<option value="<%=(String)((DataObject)item_id.get(i)).getValue("item_id")%>"
                     				<%if((EXWARNINGF != null && EXWARNINGF.size() != 0) && ( ((DataObject)EXWARNINGF.get(0)).getValue("item_id") != null && ((String)((DataObject)EXWARNINGF.get(0)).getValue("item_id")).equals((String)((DataObject)item_id.get(i)).getValue("item_id")))) out.print("selected");%>
                     				>
                     				<%=(String)((DataObject)item_id.get(i)).getValue("item_id")%>&nbsp;&nbsp;<%=(String)((DataObject)item_id.get(i)).getValue("item_name")%></option>
                     				<%}%>
                     			</select>
							<%}else{%>
                     			<select name='ITEM_ID'>
                     			<%for(int i=0;i<item_id.size();i++){%>
                     				<option value="<%=(String)((DataObject)item_id.get(i)).getValue("item_id")%>">
                     				<%=(String)((DataObject)item_id.get(i)).getValue("item_id")%>&nbsp;&nbsp;<%=(String)((DataObject)item_id.get(i)).getValue("item_name")%></option>
                     				<%}%>
                     			</select>
                     		<%}%>
                    	</td>
                   </td>
                    </tr>
                    <tr class="sbody">
						<td width='15%' align='left' bgcolor='#BDDE9C'>列管</td>
							<% List track = DBManager.QueryDB_SQLParam("SELECT CMUSE_ID,CMUSE_NAME FROM CDSHARENO WHERE CMUSE_DIV = '027' ORDER BY INPUT_ORDER",null,"");%>
						<td width='85%' colspan=2 bgcolor='EBF4E1'>
                            <%if(act.equals("Edit")){%>
                            	<select name='TRACK'>
                            		<%for(int i=0;i<track.size();i++){%>
                            		<option value="<%=(String)((DataObject)track.get(i)).getValue("cmuse_id")%>"
                            		<%if((EXWARNINGF != null && EXWARNINGF.size() != 0) && ( ((DataObject)EXWARNINGF.get(0)).getValue("track") != null && ((String)((DataObject)EXWARNINGF.get(0)).getValue("track")).equals((String)((DataObject)track.get(i)).getValue("cmuse_id")))) out.print("selected");%>
                            		>
                            		<%=(String)((DataObject)track.get(i)).getValue("cmuse_id")%>&nbsp;&nbsp;<%=(String)((DataObject)track.get(i)).getValue("cmuse_name")%></option>
                            		<%}%>
                            	</select>
                            <%}else{%>
                         		<select name='TRACK'>
                            		<%for(int i=0;i<track.size();i++){%>
                            		<option value="<%=(String)((DataObject)track.get(i)).getValue("cmuse_id")%>">
                            		<%=(String)((DataObject)track.get(i)).getValue("cmuse_id")%>&nbsp;&nbsp;<%=(String)((DataObject)track.get(i)).getValue("cmuse_name")%></option>
                            		<%}%>
                            	</select>
                            <%}%>
                        </td>
                    </tr>
						  <tr class="sbody">
						  <td width='15%' align='left' bgcolor='#BDDE9C'>摘要說明</td>
						  <td width='85%' colspan=2 bgcolor='EBF4E1'>
  		                    <TextArea textarea' rows='10' cols='60' name='SUMMARY' ><%if(EXWARNINGF != null && EXWARNINGF.size() != 0 && ((DataObject)EXWARNINGF.get(0)).getValue("summary") != null ) out.print((String)((DataObject)EXWARNINGF.get(0)).getValue("summary"));%>
  		                    </TextArea>
                          </td>
                          </tr>
					      <tr class="sbody">
						  <td width='15%' align='left' bgcolor='#BDDE9C'>備註</td>
						  <td width='85%' colspan=2 bgcolor='EBF4E1'>
  		                    <TextArea textarea' rows='4' cols='60' name='REMARK' ><%if(EXWARNINGF != null && EXWARNINGF.size() != 0 && ((DataObject)EXWARNINGF.get(0)).getValue("remark") != null ) out.print((String)((DataObject)EXWARNINGF.get(0)).getValue("remark"));%>
  		                    </TextArea>
                          </td>
                          </tr>

                        </Table></td>
                    </tr>
                    <tr>
                <td><div align="right"><jsp:include page="getMaintainUser.jsp?width=560" flush="true" /></div></td>
              </tr>

              <tr>
                <td><div align="center">
                    <table width="243" border="0" cellpadding="1" cellspacing="1">
                      <tr>
				        <%if(act.equals("new")){%>
				        	<%if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){ %> 
                        		<td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Insert');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_confirmb.gif',1)"><img src="images/bt_confirm.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a></div></td>
                        	<%}%>
         				<%}%>
         				<%if(act.equals("Edit")){%>
         					<%if(permission != null && permission.get("U") != null && permission.get("U").equals("Y")){ %>
				        		<td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Update');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_updateb.gif',1)"><img src="images/bt_update.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a></div></td>
				        	<%}%>
				        	<%if(permission != null && permission.get("D") != null && permission.get("D").equals("Y")){ %>
				        		<td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Delete');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image103','','images/bt_deleteb.gif',1)"><img src="images/bt_delete.gif" name="Image103" width="66" height="25" border="0" id="Image103"></a></div></td>
				        	<%}%>
						<%}%>
         				<%if(!act.equals("Query")){%>
                        	<td width="66"> <div align="center"><a href="javascript:AskReset(this.document.forms[0]);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image104','','images/bt_cancelb.gif',1)"><img src="images/bt_cancel.gif" name="Image104" width="66" height="25" border="0" id="Image104"></a></div></td>
		                <%}%>
                        <td width="80"><div align="center"><a href="javascript:history.back();"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image105" width="80" height="25" border="0" id="Image105"></a></div></td>
                      </tr>
                      </tr>
                    </table>
                  </div></td>
              </tr>
      </table></td>
  </tr>
  <tr>
                <td><table width="560" border="0" cellpadding="1" cellspacing="1" class="sbody">
                    <tr>
                      <td colspan="2"><font color='#990000'><img src="images/arrow_1.gif" width="28" height="23" align="absmiddle"><font color="#007D7D" size="3">使用說明
                        : </font></font></td>
                    </tr>
                    <tr>
                      <td width="16">&nbsp;</td>
                      <td width="520"> <ul>
                          <li>本網頁提供新增專長代碼功能。</li>
                          <li>專長代碼，須填入4碼。</li>
                          <li>新增時,可直接於空格內輸入資料，按<font color="#666666">【確定】</font>即將本表上的資料於資料庫中建檔。</li>
                          <li>修改時,資料更改完畢後，按<font color="#666666">【修改】</font>即將本表上的資料於資料庫中建檔。</li>
                          <li>按<font color="#666666">【取消】</font>即重新輸入資料。</li>
                          <li>按<font color="#666666">【回上一頁】</font>則放棄新增專長代碼, 回至上個畫面。</li>
                        </ul></td>
                    </tr>
                  </table></td>
              </tr>
              <!--tr>
                <td><div align="center"><img src="images/line_1.gif" width="600" height="12"></div></td>
              </tr-->
</table>
</form>
</body>
</html>

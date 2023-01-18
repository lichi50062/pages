<%
//94.03.07	1.fix 修改時下拉選單未依選擇調整而異動處理
//			2.編輯修改時文號改為可提供輸入調整處理
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%
	//String szbank_type = ( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");
	//String sztbank_no = ( request.getParameter("tbank_no")==null ) ? "" : (String)request.getParameter("tbank_no");
	String szbank_type = ( request.getParameter("SZBANK_TYPE")==null ) ? "" : (String)request.getParameter("SZBANK_TYPE");
	String szbank_no = ( request.getParameter("SZBANK_NO")==null ) ? "" : (String)request.getParameter("SZBANK_NO");
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");
	String serial = ( request.getParameter("SERIAL")==null ) ? "" : (String)request.getParameter("SERIAL");
	//String bank_type = ( request.getParameter("BANK_TYPE_1")==null ) ? "" : (String)request.getParameter("BANK_TYPE_1");
	String EVENT_DATE_Y =Utility.getTrimString(request.getAttribute("EVENT_DATE_Y")) ;
	String RT_DATE_Y =Utility.getTrimString(request.getAttribute("RT_DATE_Y")) ;
	String EVENT_DATE_M = Utility.getTrimString(request.getAttribute("EVENT_DATE_M")) ;
	String EVENT_DATE_D = Utility.getTrimString(request.getAttribute("EVENT_DATE_D")) ;
	String RT_DOCNO = Utility.getTrimString(request.getAttribute("RT_DOCNO")) ;
	String RT_DATE_M = Utility.getTrimString(request.getAttribute("RT_DATE_M")) ;
	String RT_DATE_D = Utility.getTrimString(request.getAttribute("RT_DATE_D")) ;
	String ITEM_ID = Utility.getTrimString(request.getAttribute("ITEM_ID")) ;
	String TRACK = Utility.getTrimString(request.getAttribute("TRACK")) ;
	String SUMMARY = Utility.getTrimString(request.getAttribute("SUMMARY")) ;
	String REMARK = Utility.getTrimString(request.getAttribute("REMARK")) ;
	//System.out.println("TC41_Edit.sztbank_no="+sztbank_no);
	System.out.println("TC41_Edit.szbank_type="+szbank_type);
	System.out.println("TC41_Edit.szbank_no="+szbank_no);
	System.out.println("serial="+serial);
	//System.out.println("bank_type="+bank_type);

	List EXWARNINGF = (List)request.getAttribute("EXWARNINGF");
	System.out.println("EXWARNINGF.size="+EXWARNINGF.size());
	//2004/01/01轉換為93 01 01處理
	if(EXWARNINGF != null){
		if(EXWARNINGF.size() != 0){
   	    	int i = 0;
   	    	String EVENT_DATE="";
   	    	String RT_DATE="";
   	    	if("".equals(EVENT_DATE_Y)){
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
   	    	}
   	    	if("".equals(RT_DATE_Y)){
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
			//String EVENT_DATE_M = Utility.getTrimString(request.getAttribute("EVENT_DATE_M")) ;
			//String EVENT_DATE_D = Utility.getTrimString(request.getAttribute("EVENT_DATE_D")) ;
			//String RT_DATE_M = Utility.getTrimString(request.getAttribute("RT_DATE_M")) ;
			//String RT_DATE_D = Utility.getTrimString(request.getAttribute("RT_DATE_D")) ;
			if("".equals(RT_DOCNO)){
				RT_DOCNO = (((DataObject)EXWARNINGF.get(0)).getValue("rt_docno")).toString();
			}
			if("".equals(ITEM_ID)){
				ITEM_ID = (((DataObject)EXWARNINGF.get(0)).getValue("item_id")).toString();
			}
			if("".equals(TRACK)){
				TRACK = (((DataObject)EXWARNINGF.get(0)).getValue("track")).toString();
			}
			if("".equals(SUMMARY)){
				SUMMARY = (((DataObject)EXWARNINGF.get(0)).getValue("summary")).toString();
			}
			if("".equals(REMARK)){
				REMARK = (((DataObject)EXWARNINGF.get(0)).getValue("remark")).toString();
			}
		}
	}else {
		System.out.println("LIST EXWARNINGF = NULL");
	}

	String title="異常警訊";
	title =(act.equals("Edit"))?title+"異動維護建檔":title;
	title =(act.equals("new"))?title+"新增維護建檔":title;

	//取得TC41的權限
	/*Mark for test
	Properties permission = ( session.getAttribute("TC41")==null ) ? new Properties() : (Properties)session.getAttribute("TC41");
	if(permission == null){
       System.out.println("TC41_Edit.permission == null");
    }else{
       System.out.println("TC41_Edit.permission.size ="+permission.size());

    }
	*/
	List cityList = (List)request.getAttribute("City");
	if(cityList!=null) {
		// XML Ducument for 縣市別 begin
	    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"CityXML\">");
	    out.println("<datalist>");
	    for(int i=0;i< cityList.size(); i++) {
	    	DataObject bean =(DataObject)cityList.get(i);
	        out.println("<data>");
	        out.println("<cityType>"+bean.getValue("hsien_id")+"</cityType>");
	        out.println("<cityName>"+bean.getValue("hsien_name")+"</cityName>");
	        out.println("<cityValue>"+bean.getValue("hsien_id")+"</cityValue>");
	        out.println("<cityYear>"+bean.getValue("m_year").toString()+"</cityYear>");
	        out.println("</data>");
	    }
	    out.println("</datalist>\n</xml>");
	    // XML Ducument for 縣市別 end
    }
	System.out.println("=====================before:"+EVENT_DATE_Y) ;
	String cityType = Utility.getTrimString(request.getAttribute("cityType")) ;
	String bank_no = Utility.getTrimString(request.getAttribute("BANK_NO")) ;
	
	/*
	if("".equals(Utility.getTrimString(EVENT_DATE_Y))) {
		System.out.println("event_date_y is null ") ;
		EVENT_DATE_Y = Utility.getTrimString(request.getAttribute("EVENT_DATE_Y")) ;
		System.out.println("=====================after:"+EVENT_DATE_Y) ;
	}*/
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/TC41.js"></script>
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


function disableCity(form) {
  for(var i=0; i<form.BANK_TYPE.length; i++) {
    if(form.BANK_TYPE[i].selected == true) {       
        if(form.BANK_TYPE[i].value == "6" || form.BANK_TYPE[i].value == "7") {
          form.cityType.disabled = false;
        } else {
          form.cityType.value = ""; 
          form.cityType.disabled = true;
        }
        break;
    }
  }
}

function setSelect(S1, bankid) {
    if(S1 == null)
    	return;
    for(i=0;i<S1.length;i++) {
      	if(S1.options[i].value==bankid)    	{
        	S1.options[i].selected=true;
        	break;
    	}
    }
}
//-->
</script>
</head>

<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" leftmargin="0">
<form method=post action='#'>
<input type="hidden" name="act" value="">
<input type="hidden" name="CHECK" value="">
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
						 <td width='85%' colspan=2 bgcolor='EBF4E1'>
						 	<%List bank_type_list = DBManager.QueryDB_SQLParam("select cmuse_id,cmuse_name from cdshareno where cmuse_div='020' and cmuse_id <> 0 order by input_order",null,"");%>
                         	<select name='BANK_TYPE' onchange="javascript:getData(this.document.forms[0],'<%=act%>','bank_type');">
                         	  	<%for(int i=0;i<bank_type_list.size();i++){%>
                         	  		<option value="<%=(String)((DataObject)bank_type_list.get(i)).getValue("cmuse_id")%>"
                         	  		
                         	  		><%=(String)((DataObject)bank_type_list.get(i)).getValue("cmuse_name")%></option>
                         	  	<%}%>
                         	</select>
                         	<!-- 2005.4.21 新增縣市別開始 -->
                           	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                           	縣市別:&nbsp;&nbsp;
                           <select size="1" name="cityType" id="cityType" onChange="getData(this.document.forms[0],'<%=act%>','bank_type');" >
                           </select>
                          <!-- 2005.4.21 新增縣市別結束 -->
                         </td>                          
                         </td>

                    </tr>
                    <tr class="sbody">
						<td width='15%' align='left' bgcolor='#BDDE9C'>金融機構</td>
						<input type='hidden' name='SERIAL' value="<%=serial%>">
						  <td width='85%' colspan=2 bgcolor='EBF4E1'>
                            <select name='BANK_NO'>
							
								<%List bank_no_list = (List)request.getAttribute("bank_no");
                            	for(int i=0;i<bank_no_list.size();i++){%>
                            	<option value="<%=(String)((DataObject)bank_no_list.get(i)).getValue("bank_no")%>"
                            	<%if(EXWARNINGF != null && bank_no_list.size() != 0 && ((DataObject)bank_no_list.get(i)).getValue("bank_no") != null ) out.print("selected");%>
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
                            <input type='text' name='EVENT_DATE_Y' value="<%=EVENT_DATE_Y%>" size='3' maxlength='3' onblur='CheckYear(this) ;changeCity("CityXML",this.document.forms[0].EVENT_DATE_Y);getData(this.document.forms[0],"<%=act%>","bank_type");setSelect(this.document.forms[0].cityType,"<%=cityType%>");setSelect(this.document.forms[0].BANK_NO,"<%=bank_no%>");'>
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
                          		<input type='text' name='RT_DOCNO' value="<%=RT_DOCNO%>">
  		                     	<%//if(EXWARNINGF != null && EXWARNINGF.size() != 0 && ((DataObject)EXWARNINGF.get(0)).getValue("rt_docno") != null ) out.print((String)((DataObject)EXWARNINGF.get(0)).getValue("rt_docno"));%>
                            <%}else{%>
                            	<input type='text' name='RT_DOCNO' value="<%=RT_DOCNO%>" size='50' maxlength='50'>
                            <%}%>
                          </td>
                          </tr>
                   <tr class="sbody">
						  <td width='18%' align='left' bgcolor='#BDDE9C'>收文日期</td>
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
                     				<%if(ITEM_ID.equals((String)((DataObject)item_id.get(i)).getValue("item_id"))) out.print("selected");%>
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
                            		<%if(TRACK.equals((String)((DataObject)track.get(i)).getValue("cmuse_id"))) out.print("selected");%>
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
  		                    <TextArea textarea rows='10' cols='51' name='SUMMARY' ><%=SUMMARY%>
  		                    </TextArea>
                          </td>
                          </tr>
					      <tr class="sbody">
						  <td width='15%' align='left' bgcolor='#BDDE9C'>備註</td>
						  <td width='85%' colspan=2 bgcolor='EBF4E1'>
  		                    <TextArea textarea rows='4' cols='51' name='REMARK' ><%=REMARK%>
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
                        	<td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Insert');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_confirmb.gif',1)"><img src="images/bt_confirm.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a></div></td>
         				<%}%>
         				<%if(act.equals("Edit")){%>
				        	<td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Update');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_updateb.gif',1)"><img src="images/bt_update.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a></div></td>
				        	<td width="66"> <div align="center"><a href="javascript:doSubmit(this.document.forms[0],'Delete');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image103','','images/bt_deleteb.gif',1)"><img src="images/bt_delete.gif" name="Image103" width="66" height="25" border="0" id="Image103"></a></div></td>
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
                          <li>本網頁提供新增異常警訊資料功能。</li>
                          <li>新增時,可直接於空格內輸入資料，按<font color="#666666">【確定】</font>即將本表上的資料於資料庫中建檔。</li>
                          <li>修改時,資料更改完畢後，按<font color="#666666">【修改】</font>即將本表上的資料於資料庫中建檔。</li>
                          <li>按<font color="#666666">【取消】</font>即重新輸入資料。</li>
                          <li>按<font color="#666666">【回上一頁】</font>則放棄新增異常警訊, 回至上個畫面。</li>
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
<script type="text/javascript">
changeCity("CityXML",this.document.forms[0].EVENT_DATE_Y)  ;
<%
   
   String cityCode =( request.getParameter("cityType")==null ) ? "" : (String)request.getParameter("cityType");
   String bankNo = szbank_no;
   String bankType = szbank_type; 
   String isCheck = ( request.getAttribute("isChecked")==null ) ? "F" : (String)request.getAttribute("isChecked");
   if(EXWARNINGF != null && EXWARNINGF.size() != 0 && isCheck.equals("F")) {
     cityCode = (String)((DataObject)EXWARNINGF.get(0)).getValue("hsien_id");
     bankNo = (String)((DataObject)EXWARNINGF.get(0)).getValue("bank_no");
     bankType = (String)((DataObject)EXWARNINGF.get(0)).getValue("bank_type");
     isCheck = "T";
   }
%>
setSelect(this.document.forms[0].BANK_TYPE,'<%=bankType%>');
setSelect(this.document.forms[0].cityType,'<%=cityCode%>');
setSelect(this.document.forms[0].BANK_NO,'<%=bankNo%>');
disableCity(this.document.forms[0]);
this.document.forms[0].CHECK.value= "<%=isCheck%>";

</script>
</html>

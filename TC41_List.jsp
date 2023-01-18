<%
//94.03.04 	1.fix 金融機構類別預設為全部類別及下拉選單全部產品查詢受檢單位僅需輸出全部調整
//			2.add 上一頁按鈕處理
//94.03.07	fix 修改時下拉選單未依選擇調整而異動處理
//94.03.09	拿掉上一頁button處理
// 99.06.01 fix 縣市合併 by 2808
//102.11.15 fix 修改.查詢日期格式,QueryDB改preparestatement by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.GregorianCalendar" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%
	System.out.println("@@TC41_List.jsp Start...");

	String szbank_type = ( request.getParameter("SZBANK_TYPE")==null ) ? "" : (String)request.getParameter("SZBANK_TYPE");
	String szbank_no = ( request.getParameter("SZBANK_NO")==null ) ? "" : (String)request.getParameter("SZBANK_NO");
	String szrt_docno = ( request.getParameter("SZRT_DOCNO")==null ) ? "" : (String)request.getParameter("SZRT_DOCNO");
	String szitem_id = ( request.getParameter("SZITEM_ID")==null ) ? "" : (String)request.getParameter("SZITEM_ID");
	String sztrack = ( request.getParameter("SZTRACK")==null ) ? "" : (String)request.getParameter("SZTRACK");
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");
	//取得TC41.jsp 傳回之機構代號資料
	//String bank_no = ( request.getParameter("bank_no")==null ) ? "" : (String)request.getParameter("bank_no");
	//取得TC41.js 傳回之日期資料
	String EVENT_DATE_BEG= ( request.getParameter("EVENT_DATE_BEG")==null ) ? "" : (String)request.getParameter("EVENT_DATE_BEG");
	String EVENT_DATE_END= ( request.getParameter("EVENT_DATE_END")==null ) ? "" : (String)request.getParameter("EVENT_DATE_END");
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
	String cityType = Utility.getTrimString(request.getAttribute("cityType")) ;
	String bank_no = Utility.getTrimString(request.getAttribute("BANK_NO")) ;
	String EVENT_DATE_BEG_Y = "" ;
	String EVENT_DATE_BEG_M ="";
	String EVENT_DATE_BEG_D ="";
	String EVENT_DATE_END_Y ="";
	String EVENT_DATE_END_M ="";
	String EVENT_DATE_END_D ="";

	//取得個別年月日資料
	if((!EVENT_DATE_BEG.equals(""))&& (!EVENT_DATE_BEG.equals(""))){
		//日期轉換 EX:2002/09/23->91/09/23
		EVENT_DATE_BEG = Utility.getCHTdate(EVENT_DATE_BEG,0);
		EVENT_DATE_END = Utility.getCHTdate(EVENT_DATE_END,0);
		System.out.println("EVENT_DATE_BEG="+EVENT_DATE_BEG);
		System.out.println("EVENT_DATE_END="+EVENT_DATE_END);
		int i=0;

		System.out.println("TC41.js inpute date not spaces");

		if(EVENT_DATE_BEG.length() == 9) i = 1;
		//取得事件發生起始日期
		if(EVENT_DATE_BEG.startsWith("1")){        
           	EVENT_DATE_BEG_Y = EVENT_DATE_BEG.substring(0,3);
			EVENT_DATE_BEG_M = EVENT_DATE_BEG.substring(4,6);
			EVENT_DATE_BEG_D = EVENT_DATE_BEG.substring(7,9);
        }else{
          	EVENT_DATE_BEG_Y = EVENT_DATE_BEG.substring(0,2);
			EVENT_DATE_BEG_M = EVENT_DATE_BEG.substring(3,5);
			EVENT_DATE_BEG_D = EVENT_DATE_BEG.substring(6,8);                                		
        }      
		
		//取得事件發生結束日期
		if(EVENT_DATE_END.startsWith("1")){        
           	EVENT_DATE_END_Y = EVENT_DATE_END.substring(0,3);
			EVENT_DATE_END_M = EVENT_DATE_END.substring(4,6);
			EVENT_DATE_END_D = EVENT_DATE_END.substring(7,9);
        }else{
          	EVENT_DATE_END_Y = EVENT_DATE_END.substring(0,2);
			EVENT_DATE_END_M = EVENT_DATE_END.substring(3,5);
			EVENT_DATE_END_D = EVENT_DATE_END.substring(6,8);                                		
        }     
		
	}else{
		//取得目前年份資料
		GregorianCalendar cal = new GregorianCalendar();
		EVENT_DATE_BEG_Y = String.valueOf(cal.get(cal.YEAR)-1911);
		EVENT_DATE_END_Y = String.valueOf(cal.get(cal.YEAR)-1911);
	}
	if(!"".equals(Utility.getTrimString(request.getAttribute("EVENT_DATE_BEG_Y")) )){
		EVENT_DATE_BEG_Y = Utility.getTrimString(request.getAttribute("EVENT_DATE_BEG_Y"))  ;
	}
	System.out.println("act="+act);
	System.out.println("TC41_List.szbank_no="+szbank_no);

	//String bank_type = ( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");
	System.out.println("szbank_type="+szbank_type);
	System.out.println("szbank_no="+szbank_no);

	List EXWARNINGFList = (List)request.getAttribute("EXWARNINGFList");
	if(EXWARNINGFList == null){
	   System.out.println("EXWARNINGFList == null");
	}else{
	   System.out.println("不為NULL EXWARNINGFList.size()="+EXWARNINGFList.size());
	}

	//取得TC41的權限
	Properties permission = ( session.getAttribute("TC41")==null ) ? new Properties() : (Properties)session.getAttribute("TC41");
	if(permission == null){
       System.out.println("TC41_List.permission == null");
    }else{
       System.out.println("TC41_List.permission.size ="+permission.size());
    }
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/TC41.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<title> 異常警訊維護 </title>
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
<table width="100%" border="0" align="left" cellpadding="0" cellspacing="1" bgcolor="#FFFFFF">
  		<tr>
   		 <td><img src="images/space_1.gif" width="12" height="12"></td>
  		</tr>

        <tr>
          <td bgcolor="#FFFFFF">
		  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr>
                <td><table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr>
                      <td width="150"><img src="images/banner_bg1.gif" width="150" height="17"></td>
                      <td width="300"><font color='#000000' size=4><b>
                        <center> 異常警訊維護 </center>
                        </b></font> </td>
                      <td width="150"><img src="images/banner_bg1.gif" width="150" height="17"></td>
                    </tr>
                  </table></td>
              </tr>
              <tr>
                <td><img src="images/space_1.gif" width="12" height="12"></td>
              </tr>
              <tr>
                <td><table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">

                    <tr>
                      <div align="right"><jsp:include page="getLoginUser.jsp" flush="true" /></div>
                    </tr>
                    <tr>
                    <table width="100%" border=1 align=center cellpadding="1" cellspacing="1" bordercolor="#76C657">
					<tr class="sbody">
						 <td width='15%' align='left' bgcolor='#BDDE9C'>金融機構類別</td>
						 <% List bank_type = DBManager.QueryDB_SQLParam("select cmuse_id,cmuse_name from cdshareno where cmuse_div='020' order by input_order",null,"");%>
						 <td width='85%' colspan=2 bgcolor='EBF4E1'>
                         	<select name='BANK_TYPE' onchange="javascript:getData(this.document.forms[0],'<%=act%>','bank_type');">
                           	<%for(int i=0;i<bank_type.size();i++){%>
                           		<option value="<%=(String)((DataObject)bank_type.get(i)).getValue("cmuse_id")%>"
                           		<%if( ((DataObject)bank_type.get(i)).getValue("cmuse_id") != null &&  (szbank_type.equals((String)((DataObject)bank_type.get(i)).getValue("cmuse_id")))) out.print("selected");%>
                           	>
                           	<%=(String)((DataObject)bank_type.get(i)).getValue("cmuse_name")%></option>
                           	<%}%>
                           	</select>
                           	<!-- 2005.4.21 新增縣市別開始 -->
                           	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                           	縣市別:&nbsp;&nbsp;
                           <select size="1" name="cityType" id="cityType" onChange="getData(this.document.forms[0],'<%=act%>','bank_type');" >
                           </select>
                          <!-- 2005.4.21 新增縣市別結束 -->
                           	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                           	<%if(permission != null && permission.get("Q") != null && permission.get("Q").equals("Y")){%>
                           		<a href="javascript:doSubmit(this.document.forms[0],'Qry');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_queryb.gif',1)"><img src="images/bt_query.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a>
                           	<%}%>
                           	<%if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){%>
                           		<a href="javascript:doSubmit(this.document.forms[0],'new');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_addb.gif',1)"><img src="images/bt_add.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a>
                           	<%}%>
                          </td>
                         </td>

                    </tr>
                    <tr class="sbody">
						<td width='15%' align='left' bgcolor='#BDDE9C'>金融機構</td>
						<%List bank_no_list = (List)request.getAttribute("bank_no");
						 	System.out.println("TC51_List.getAttribute.size="+bank_no_list.size());
						%>
						  <td width='85%' colspan=2 bgcolor='EBF4E1'>
                            <select name='BANK_NO'>
                            <%if(szbank_type.equals("0")) {%>
                            	<option value="">全部</option>
                            <%}else {%>
                            	<option value="" "selected">全部</option>
                            	<%for(int i=0;i<bank_no_list.size();i++){%>
                            		<option value="<%=(String)((DataObject)bank_no_list.get(i)).getValue("bank_no")%>"
                            		<%//if(((String)((DataObject)bank_no_list.get(i)).getValue("bank_no")).equals("0")) out.print("selected");%>
                            		<%if( ((DataObject)bank_no_list.get(i)).getValue("bank_no") != null &&  (szbank_no.equals((String)((DataObject)bank_no_list.get(i)).getValue("bank_no")))) out.print("selected");%>
                            		>
                            		<%=(String)((DataObject)bank_no_list.get(i)).getValue("bank_no")%>
                            		<%=(String)((DataObject)bank_no_list.get(i)).getValue("bank_name")%></option>
                            	<%}%>
                            <%}%>
                            </select>
                           </td>
                          </td>

                    </tr>
                    <tr class="sbody">
						  <td width='15%' align='left' bgcolor='#BDDE9C'>事件發生日期</td>
						  <td width='85%' colspan=2 bgcolor='EBF4E1'>
						    <input type='hidden' name='EVENT_DATE_BEG' value="">
                            <input type='text' name='EVENT_DATE_BEG_Y' value="<%=EVENT_DATE_BEG_Y%>" size='3' maxlength='3' onblur='CheckYear(this);changeCity("CityXML",this.document.forms[0].EVENT_DATE_BEG_Y);getData(this.document.forms[0],"<%=act%>","bank_type");setSelect(this.document.forms[0].cityType,"<%=cityType%>");setSelect(this.document.forms[0].BANK_NO,"<%=bank_no%>");'>
        						<font color='#000000'>年
        						<select id="hide1" name=EVENT_DATE_BEG_M>
        						<option></option>
        						<%
        							for (int j = 1; j <= 12; j++) {
        							if (j < 10){%>
        							<option value=0<%=j%>
        								<%if( EVENT_DATE_BEG_M.equals("") && String.valueOf(j).equals("1") ) out.print("selected");%>
        								<%if( (!EVENT_DATE_BEG_M.equals("")) && EVENT_DATE_BEG_M.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>
            						<%}else{%>
            						<option value=<%=j%> <%if(EVENT_DATE_BEG_M.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select></font><font color='#000000'>月
        						<select id="hide1" name=EVENT_DATE_BEG_D>
        						<option></option>
        						<%
        							for (int j = 1; j < 32; j++) {
        							if (j < 10){%>
        							<option value=0<%=j%>
        								<%if( EVENT_DATE_BEG_D.equals("") && String.valueOf(j).equals("1") ) out.print("selected");%>
        								<%if( (!EVENT_DATE_BEG_D.equals("")) && EVENT_DATE_BEG_D.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>
            						<%}else{%>
            						<option value=<%=j%> <%if(EVENT_DATE_BEG_D.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select></font><font color='#000000'>日至</font>
        					<input type='hidden' name='EVENT_DATE_END' value="">
                            <input type='text' name='EVENT_DATE_END_Y' value="<%=EVENT_DATE_END_Y%>" size='3' maxlength='3' onblur='CheckYear(this);changeCity("CityXML",this.name);getData(this.document.forms[0],"<%=act%>","bank_type");setSelect(this.document.forms[0].cityType,"<%=cityType%>");setSelect(this.document.forms[0].BANK_NO,"<%=bank_no%>");'>
        						<font color='#000000'>年
        						<select id="hide1" name=EVENT_DATE_END_M>
        						<option></option>
        						<%
        							for (int j = 1; j <= 12; j++) {
        							if (j < 10){%>
        							<option value=0<%=j%> <%if(EVENT_DATE_END_M.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>
            						<%}else{%>
            						<option value=<%=j%>
            							<%if( EVENT_DATE_END_M.equals("") && String.valueOf(j).equals("12") ) out.print("selected");%>
            							<%if( (!EVENT_DATE_END_M.equals("")) && EVENT_DATE_END_M.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select></font><font color='#000000'>月
        						<select id="hide1" name=EVENT_DATE_END_D>
        						<option></option>
        						<%
        							for (int j = 1; j < 32; j++) {
        							if (j < 10){%>
        							<option value=0<%=j%> <%if(EVENT_DATE_END_D.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>
            						<%}else{%>
            						<option value=<%=j%>
            							<%if( EVENT_DATE_END_D.equals("") && String.valueOf(j).equals("31") ) out.print("selected");%>
            							<%if( (!EVENT_DATE_END_D.equals("")) && EVENT_DATE_END_D.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select></font><font color='#000000'>日止</Font>
                            </td>
	  					</tr>
					<tr class="sbody">
						<td width='17%' align='left' bgcolor='#BDDE9C'>農金局收文文號</td>
						<td width='85%' colspan=2 bgcolor='EBF4E1'>
					  		<input type='text' name='RT_DOCNO' value="<%=szrt_docno%>" size='50' maxlength='50' ></td>
                    </tr>
					<tr class="sbody">
						  <td width='15%' align='left' bgcolor='#BDDE9C'>項目別</td>
						  <% List item_id = DBManager.QueryDB_SQLParam("SELECT ITEM_ID,ITEM_NAME FROM EXWARNIDF ORDER BY ITEM_ID",null,"");%>
						  <td width='85%' colspan=2 bgcolor='EBF4E1'>
                            <select name='ITEM_ID'>
                            <option value="" >全部
                            <%for(int i=0;i<item_id.size();i++){%>
                            	<option value="<%=(String)((DataObject)item_id.get(i)).getValue("item_id")%>"
                            	<%if( ((DataObject)item_id.get(i)).getValue("item_id") != null &&  (szitem_id.equals((String)((DataObject)item_id.get(i)).getValue("item_id")))) out.print("selected");%>
                            	>
                            	<%=(String)((DataObject)item_id.get(i)).getValue("item_id")%>&nbsp;&nbsp;<%=(String)((DataObject)item_id.get(i)).getValue("item_name")%></option>
                            <%}%>
                            </select>
                           </td>
                          </td>
                    </tr>
                    <tr class="sbody">
						  <td width='15%' align='left' bgcolor='#BDDE9C'>列管</td>
						  <% List track = DBManager.QueryDB_SQLParam("SELECT CMUSE_ID,CMUSE_NAME FROM CDSHARENO WHERE CMUSE_DIV = '027' ORDER BY INPUT_ORDER",null,"");%>
						  <td width='85%' colspan=2 bgcolor='EBF4E1'>
                            <select name='TRACK'>
                            <option value="" >全部
                            <%for(int i=0;i<track.size();i++){%>
                            	<option value="<%=(String)((DataObject)track.get(i)).getValue("cmuse_id")%>"
                            	<%if( ((DataObject)track.get(i)).getValue("cmuse_id") != null &&  (sztrack.equals((String)((DataObject)track.get(i)).getValue("cmuse_id")))) out.print("selected");%>
                            	>
                            	<%=(String)((DataObject)track.get(i)).getValue("cmuse_id")%>&nbsp;&nbsp;<%=(String)((DataObject)track.get(i)).getValue("cmuse_name")%></option>
                            <%}%>
                            </select>
                           </td>
                          </td>
                    </tr>
                    </table>
                      <tr><td><table><tr><br></tr></table></td></tr>

                    <tr>
                      	<td><table width="100%" border=1 align=center cellpadding="1" cellspacing="1" bordercolor="#76C657">
                      		<%
                      		String tmpbank_type="";
                      		int i = 0;
                      		String bgcolor="#FFFFCC";
                      		if(EXWARNINGFList != null){ %>
                      		 	<tr class="sbody" bgcolor="#BFDFAE">
                      		    	<td width="5%">&nbsp;</td>
                      		    	<td width="30%">金融機構</td>
                      		    	<td width="10%">事件日期</td>
                      		    	<td width="15%">收文文號</td>
                      		    	<td width="30%">項目別</td>
                      		    	<td width="10%">列管</td>
								</tr>
                   		    <%
                   		    if(EXWARNINGFList.size() == 0){%>
                   			   	<tr class="sbody" bgcolor="<%=bgcolor%>">
                   			   		<td colspan=11 align=center>無資料可供查詢</td>
                   			   	<tr>
                   			<%}
                    			while(i < EXWARNINGFList.size()){
                    		      	bgcolor = (i % 2 == 0)?"#EBF4E1":"#FFFFCC";
                      		%>
                          		<tr class="sbody" bgcolor="<%=bgcolor%>">
                            		<td width="5%"><%=i+1%></td>
            						<td width="30%"><a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(String)((DataObject)EXWARNINGFList.get(i)).getValue("bank_type")%>','<%=(String)((DataObject)EXWARNINGFList.get(i)).getValue("bank_no")%>','<%=(((DataObject)EXWARNINGFList.get(i)).getValue("serial")).toString()%>');">
            							<input type='hidden' name='SZBANK_TYPE' value="<%=(String)((DataObject)EXWARNINGFList.get(i)).getValue("bank_type")%>">
            							<%if( ((DataObject)EXWARNINGFList.get(i)).getValue("bank_name") != null ){
                    		    			out.print((String)((DataObject)EXWARNINGFList.get(i)).getValue("bank_name"));
                    		    			System.out.println("List時的bank_type="+(String)((DataObject)EXWARNINGFList.get(i)).getValue("bank_type"));
                    		  			}%>
                    		  			</td>
                    		  		<td width="10%">
                    		  			<%if( ((DataObject)EXWARNINGFList.get(i)).getValue("eventdate") != null ){%>
                    		  				<a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(String)((DataObject)EXWARNINGFList.get(i)).getValue("bank_no")%>','<%=(((DataObject)EXWARNINGFList.get(i)).getValue("serial")).toString()%>');">
                    						<%=Utility.getCHTdate((((DataObject)EXWARNINGFList.get(i)).getValue("eventdate")).toString().substring(0, 10), 0)%>
                    						</a>
                    						<%System.out.println("Tc41_List.jsp eventdate="+Utility.getCHTdate((((DataObject)EXWARNINGFList.get(i)).getValue("eventdate")).toString().substring(0, 10), 0));%>
                    					<%}else{%>
                    						<%System.out.println("日期為null");%>
            				 				&nbsp;
            							<%}%>

                    					</td>
                    				<td width="15%"><a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(String)((DataObject)EXWARNINGFList.get(i)).getValue("bank_no")%>','<%=(((DataObject)EXWARNINGFList.get(i)).getValue("serial")).toString()%>');">
                    				<%if( ((DataObject)EXWARNINGFList.get(i)).getValue("rt_docno") != null ){
                    					out.print((String)((DataObject)EXWARNINGFList.get(i)).getValue("rt_docno"));
                    				}%> </td>
                    				<td width="30%"><a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(String)((DataObject)EXWARNINGFList.get(i)).getValue("bank_no")%>','<%=(((DataObject)EXWARNINGFList.get(i)).getValue("serial")).toString()%>');">
                    				<%if( ((DataObject)EXWARNINGFList.get(i)).getValue("item_name") != null ){
                    					out.print((String)((DataObject)EXWARNINGFList.get(i)).getValue("item_name"));
                    				}%> </td>
                    				<td width="10%"><a href="javascript:doSubmit(this.document.forms[0],'Edit','<%=(String)((DataObject)EXWARNINGFList.get(i)).getValue("bank_no")%>','<%=(((DataObject)EXWARNINGFList.get(i)).getValue("serial")).toString()%>');">
                    				<%if( ((DataObject)EXWARNINGFList.get(i)).getValue("cmuse_name") != null ){
                    					out.print((String)((DataObject)EXWARNINGFList.get(i)).getValue("cmuse_name"));
                    					System.out.println("cmuse_name="+(String)((DataObject)EXWARNINGFList.get(i)).getValue("cmuse_name"));
                    				}%> </td>
   					      		</tr>
					      <%
                  			   i++;
	                  		   }//end of while
	                  		}//end of if
                  			%>
					      </table>
                      </td>
                      </tr>

      </table></td>
  </tr>
</table>
</form>
</body>
<script type="text/javascript">




changeCity("CityXML",this.document.forms[0].EVENT_DATE_BEG_Y) ;
setSelect(this.document.forms[0].cityType,'<%=cityType%>');
setSelect(this.document.forms[0].BANK_NO,'<%=bank_no%>');
disableCity(this.document.forms[0]);

</script>
</html>
<%System.out.println("@@TC41_List.jsp End..");%>
<%
//94.03.08	1.fix 畫面輸出之發文文號變小，機構代號名稱欄位放大，發文類別適中調整處理
//94.03.09	拿掉上一頁button處理
// 99.06.01 fix 縣市合併 by 2808
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
	System.out.println("@@TC34_List.jsp Start...");

	String szbank_type = ( request.getParameter("SZBANK_TYPE")==null ) ? "" : (String)request.getParameter("SZBANK_TYPE");
	String szbank_no = ( request.getParameter("SZBANK_NO")==null ) ? "" : (String)request.getParameter("SZBANK_NO");
	String szreportno = ( request.getParameter("SZREPORTNO")==null ) ? "" : (String)request.getParameter("SZREPORTNO");
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");
	String BASE_DATE_BEG= ( request.getParameter("BASE_DATE_BEG")==null ) ? "" : (String)request.getParameter("BASE_DATE_BEG");
	String BASE_DATE_END= ( request.getParameter("BASE_DATE_END")==null ) ? "" : (String)request.getParameter("BASE_DATE_END");
	// 2005.4.21 取得縣市
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
	String BASE_DATE_BEG_Y ="";
	String BASE_DATE_BEG_M ="";
	String BASE_DATE_BEG_D ="";
	String BASE_DATE_END_Y ="";
	String BASE_DATE_END_M ="";
	String BASE_DATE_END_D ="";

	//取得個別年月日資料
	if((!BASE_DATE_BEG.equals(""))&& (!BASE_DATE_BEG.equals(""))){
		//日期轉換 EX:2002/09/23->91/09/23
		BASE_DATE_BEG = Utility.getCHTdate(BASE_DATE_BEG,0);
		BASE_DATE_END = Utility.getCHTdate(BASE_DATE_END,0);
		System.out.println("BASE_DATE_BEG="+BASE_DATE_BEG);
		System.out.println("BASE_DATE_END="+BASE_DATE_END);
		int i=0;
		int j=0;

		System.out.println("TC41.js inpute date not spaces");

		if(BASE_DATE_BEG.length() == 9) i = 1;
		if(BASE_DATE_END.length() == 9) j = 1;
		//取得檢查基準起始日期
		BASE_DATE_BEG_Y = BASE_DATE_BEG.substring(0,2+i);
		BASE_DATE_BEG_M = BASE_DATE_BEG.substring(3+i,5+i);
		BASE_DATE_BEG_D = BASE_DATE_BEG.substring(6+i,BASE_DATE_BEG.length());
		System.out.println("BASE_DATE_BEG_Y="+BASE_DATE_BEG_Y);
		System.out.println("BASE_DATE_BEG_M="+BASE_DATE_BEG_M);
		System.out.println("BASE_DATE_BEG_D="+BASE_DATE_BEG_D);
		//取得檢查基準結束日期
		BASE_DATE_END_Y = BASE_DATE_END.substring(0,2+j);
		BASE_DATE_END_M = BASE_DATE_END.substring(3+j,5+j);
		BASE_DATE_END_D = BASE_DATE_END.substring(6+j,BASE_DATE_END.length());
		System.out.println("BASE_DATE_END_Y="+BASE_DATE_END_Y);
		System.out.println("BASE_DATE_END_M="+BASE_DATE_END_M);
		System.out.println("BASE_DATE_END_D="+BASE_DATE_END_D);
	}else{
		//取得目前年份資料
		GregorianCalendar cal = new GregorianCalendar();
		BASE_DATE_BEG_Y = String.valueOf(cal.get(cal.YEAR)-1911);
		BASE_DATE_END_Y = String.valueOf(cal.get(cal.YEAR)-1911);
	}

	System.out.println("act="+act);
	System.out.println("szbank_type="+szbank_type);
	System.out.println("szreportno="+szreportno);

	List EXDEFGOODFList = (List)request.getAttribute("EXDEFGOODFList");
	if(EXDEFGOODFList == null){
	   System.out.println("EXDEFGOODFList == null");
	}else{
	   System.out.println("不為NULL EXDEFGOODFList.size()="+EXDEFGOODFList.size());
	}

	//取得TC34的權限
	Properties permission = ( session.getAttribute("TC34")==null ) ? new Properties() : (Properties)session.getAttribute("TC34");
	if(permission == null){
       System.out.println("TC34_List.permission == null");
    }else{
       System.out.println("TC34_List.permission.size ="+permission.size());
    }
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/TC34.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<title> 缺失未改善明細查詢 </title>
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
                        <center> 缺失未改善明細查詢 </center>
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
                          <select size="1" name="cityType" onChange="getData(this.document.forms[0],'<%=act%>','bank_type');" >
                           </select>
                          <!-- 2005.4.21 新增縣市別結束 -->
                           	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                           	
                           	
                           	<%if(permission != null && permission.get("Q") != null && permission.get("Q").equals("Y")){%>
                           		<a href="javascript:doSubmit(this.document.forms[0],'Qry');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_queryb.gif',1)"><img src="images/bt_query.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a>
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
                            		<%if( ((DataObject)bank_no_list.get(i)).getValue("bank_no") != null &&  (szbank_no.equals((String)((DataObject)bank_no_list.get(i)).getValue("bank_no")))) out.print("selected");%>>
                            		<%=(String)((DataObject)bank_no_list.get(i)).getValue("bank_no")%> <%=(String)((DataObject)bank_no_list.get(i)).getValue("bank_name")%></option>
                            	<%}%>
                            <%}%>
                            </select>
                           </td>
                          </td>

                    </tr>
					<tr class="sbody">
						<td width='15%' align='left' bgcolor='#BDDE9C'>檢查報告編號</td>
						<td width='85%' colspan=2 bgcolor='EBF4E1'>
					  		<input type='text' name='REPORTNO' value="<%=szreportno%>" size='10' maxlength='10' ></td>
                    </tr>
					<tr class="sbody">
						  <td width='15%' align='left' bgcolor='#BDDE9C'>檢查基準日</td>
						  <td width='85%' colspan=2 bgcolor='EBF4E1'>
						    <input type='hidden' name='BASE_DATE_BEG' value="">
                            <input type='text' name='BASE_DATE_BEG_Y' value="<%=BASE_DATE_BEG_Y%>" size='3' maxlength='3' onblur='CheckYear(this) ;changeCity("CityXML",this.document.forms[0].BASE_DATE_BEG_Y) ;'>
        						<font color='#000000'>年
        						<select id="hide1" name=BASE_DATE_BEG_M>
        						<option></option>
        						<%
        							for (int j = 1; j <= 12; j++) {
        							if (j < 10){%>
        							<option value=0<%=j%>
        								<%if( BASE_DATE_BEG_M.equals("") && String.valueOf(j).equals("1") ) out.print("selected");%>
        								<%if(BASE_DATE_BEG_M.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>
            						<%}else{%>
            						<option value=<%=j%> <%if(BASE_DATE_BEG_M.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select></font><font color='#000000'>月
        						<select id="hide1" name=BASE_DATE_BEG_D>
        						<option></option>
        						<%
        							for (int j = 1; j < 32; j++) {
        							if (j < 10){%>
        							<option value=0<%=j%>
        								<%if( BASE_DATE_BEG_D.equals("") && String.valueOf(j).equals("1") ) out.print("selected");%>
        								<%if(BASE_DATE_BEG_D.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>
            						<%}else{%>
            						<option value=<%=j%> <%if(BASE_DATE_BEG_D.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select></font><font color='#000000'>日至</font>
        					<input type='hidden' name='BASE_DATE_END' value="">
                            <input type='text' name='BASE_DATE_END_Y' value="<%=BASE_DATE_END_Y%>" size='3' maxlength='3' onblur='CheckYear(this)'>
        						<font color='#000000'>年
        						<select id="hide1" name=BASE_DATE_END_M>
        						<option></option>
        						<%
        							for (int j = 1; j <= 12; j++) {
        							if (j < 10){%>
        							<option value=0<%=j%> <%if(BASE_DATE_END_M.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>
            						<%}else{%>
            						<option value=<%=j%>
            							<%if( BASE_DATE_END_M.equals("") && String.valueOf(j).equals("12") ) out.print("selected");%>
            							<%if(BASE_DATE_END_M.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select></font><font color='#000000'>月
        						<select id="hide1" name=BASE_DATE_END_D>
        						<option></option>
        						<%
        							for (int j = 1; j < 32; j++) {
        							if (j < 10){%>
        							<option value=0<%=j%> <%if(BASE_DATE_END_D.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>
            						<%}else{%>
            						<option value=<%=j%>
            							<%if( BASE_DATE_END_D.equals("") && String.valueOf(j).equals("31") ) out.print("selected");%>
            							<%if(BASE_DATE_END_D.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select></font><font color='#000000'>日止</Font>
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
                      		if(EXDEFGOODFList != null){ %>
                      		 	<tr class="sbody" bgcolor="#BFDFAE">
                      		    	<td width="5%">&nbsp;</td>
                      		    	<td width="15%">機構代號</td>
                      		    	<td width="40%">機構名稱</td>
                      		    	<td width="20%">檢查報告編號</td>
                      		    	<td width="20%">檢查基準日</td>
								</tr>
                   		    <%
                   		    if(EXDEFGOODFList.size() == 0){%>
                   			   	<tr class="sbody" bgcolor="<%=bgcolor%>">
                   			   		<td colspan=11 align=center>無資料可供查詢</td>
                   			   	<tr>
                   			<%}
                    			while(i < EXDEFGOODFList.size()){
                    		      	bgcolor = (i % 2 == 0)?"#EBF4E1":"#FFFFCC";
                      		%>
                          		<tr class="sbody" bgcolor="<%=bgcolor%>">
                            		<td width="5%"><%=i+1%></td>
            						<td width="15%">
            							<%if( ((DataObject)EXDEFGOODFList.get(i)).getValue("bank_no") != null ){
                    		    			out.print((String)((DataObject)EXDEFGOODFList.get(i)).getValue("bank_no"));
                    		  			}%></td>
                    		  		<td width="40%">
            							<%if( ((DataObject)EXDEFGOODFList.get(i)).getValue("bank_name") != null ){
                    		    			out.print((String)((DataObject)EXDEFGOODFList.get(i)).getValue("bank_name"));
                    		  			}%></td>
                    				<td width="20%">
                    					<%if( ((DataObject)EXDEFGOODFList.get(i)).getValue("reportno") != null ){
                    						out.print((String)((DataObject)EXDEFGOODFList.get(i)).getValue("reportno"));
                    					}%> </td>
                    		  		<td width="20%">
                    		  			<%if( ((DataObject)EXDEFGOODFList.get(i)).getValue("base_date") != null ){%>
                    						<%=Utility.getCHTdate((((DataObject)EXDEFGOODFList.get(i)).getValue("base_date")).toString().substring(0, 10), 0)%>
                    						</a>
                    						<%System.out.println("TC34_List.jsp sn_date="+Utility.getCHTdate((((DataObject)EXDEFGOODFList.get(i)).getValue("base_date")).toString().substring(0, 10), 0));%>
                    					<%}else{%>
                    						<%System.out.println("日期為null");%>
            				 				&nbsp;
            							<%}%>
                    					</td>
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

changeCity("CityXML",this.document.forms[0].BASE_DATE_BEG_Y) ;
setSelect(this.document.forms[0].cityType,'<%=cityType%>');
disableCity(this.document.forms[0]);

</script>
</html>
<%System.out.println("@@TC34_List.jsp End..");%>
<%
//94.03.09	拿掉上一頁button處理
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
	System.out.println("@@TC13_List.jsp Start...");

	String szmuser_id = ( request.getParameter("SZMUSER_ID")==null ) ? "" : (String)request.getParameter("SZMUSER_ID");
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");
	String BASE_DATE_BEG= ( request.getParameter("BASE_DATE_BEG")==null ) ? "" : (String)request.getParameter("BASE_DATE_BEG");
	String BASE_DATE_END= ( request.getParameter("BASE_DATE_END")==null ) ? "" : (String)request.getParameter("BASE_DATE_END");
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

		System.out.println("TC41.js inpute date not spaces");

		if(BASE_DATE_BEG.length() == 9) i = 1;
		//取得檢查基準起始日期
		BASE_DATE_BEG_Y = BASE_DATE_BEG.substring(0,2+i);
		BASE_DATE_BEG_M = BASE_DATE_BEG.substring(3+i,5+i);
		BASE_DATE_BEG_D = BASE_DATE_BEG.substring(6+i,BASE_DATE_BEG.length());
		System.out.println("BASE_DATE_BEG_Y="+BASE_DATE_BEG_Y);
		System.out.println("BASE_DATE_BEG_M="+BASE_DATE_BEG_M);
		System.out.println("BASE_DATE_BEG_D="+BASE_DATE_BEG_D);
		//取得檢查基準結束日期
		BASE_DATE_END_Y = BASE_DATE_END.substring(0,2+i);
		BASE_DATE_END_M = BASE_DATE_END.substring(3+i,5+i);
		BASE_DATE_END_D = BASE_DATE_END.substring(6+i,BASE_DATE_END.length());
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
	System.out.println("szmuser_id="+szmuser_id);

	List EXDISTRIPFList = (List)request.getAttribute("EXDISTRIPFList");
	if(EXDISTRIPFList == null){
	   System.out.println("EXDISTRIPFList == null");
	}else{
	   System.out.println("不為NULL EXDISTRIPFList.size()="+EXDISTRIPFList.size());
	}

	//取得TC13的權限
	Properties permission = ( session.getAttribute("TC13")==null ) ? new Properties() : (Properties)session.getAttribute("TC13");
	if(permission == null){
       System.out.println("TC13_List.permission == null");
    }else{
       System.out.println("TC13_List.permission.size ="+permission.size());
    }
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/TC13.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<title> 檢查人員檢查經歷查詢 </title>
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
                        <center> 檢查人員檢查經歷查詢 </center>
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
						 <td width='15%' align='left' bgcolor='#BDDE9C'>檢查人員</td>
						 <% List muser_id = DBManager.QueryDB_SQLParam("SELECT DISTINCT A.MUSER_ID,B.MUSER_NAME FROM EXPERSONF A, WTT01 B  WHERE A.MUSER_ID = B.MUSER_ID ORDER BY MUSER_ID",null,"");%>
						 <td width='85%' colspan=2 bgcolor='EBF4E1'>
                         	<select name='MUSER_ID'>
                           	<%for(int i=0;i<muser_id.size();i++){%>
                           		<option value="<%=(String)((DataObject)muser_id.get(i)).getValue("muser_id")%>"
                           		<%if( ((DataObject)muser_id.get(i)).getValue("muser_id") != null &&  (szmuser_id.equals((String)((DataObject)muser_id.get(i)).getValue("muser_id")))) out.print("selected");%>
                           	>
                           	<%=(String)((DataObject)muser_id.get(i)).getValue("muser_id")%>&nbsp;&nbsp;<%=(String)((DataObject)muser_id.get(i)).getValue("muser_name")%></option>
                           	<%}%>
                           	</select>
                           	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                           	<%if(permission != null && permission.get("Q") != null && permission.get("Q").equals("Y")){%>
                           		<a href="javascript:doSubmit(this.document.forms[0],'Qry');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_queryb.gif',1)"><img src="images/bt_query.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a>
                           	<%}%>
                          </td>
                         </td>
                    </tr>
					<tr class="sbody">
						  <td width='15%' align='left' bgcolor='#BDDE9C'>檢查日期</td>
						  <td width='85%' colspan=2 bgcolor='EBF4E1'>
						    <input type='hidden' name='BASE_DATE_BEG' value="">
                            <input type='text' name='BASE_DATE_BEG_Y' value="<%=BASE_DATE_BEG_Y%>" size='3' maxlength='3' onblur='CheckYear(this)'>
        						<font color='#000000'>年
        						<select id="hide1" name=BASE_DATE_BEG_M>
        						<%
        							for (int j = 1; j <= 12; j++) {
        							if (j < 10){%>
        							<option value=0<%=j%>
        								<%if( BASE_DATE_BEG_M.equals("") && String.valueOf(j).equals("1") ) out.print("selected");%>
        								<%if((!BASE_DATE_BEG_M.equals("")) && BASE_DATE_BEG_M.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>
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
        								<%if( (!BASE_DATE_BEG_D.equals("")) && BASE_DATE_BEG_D.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>
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
        							<option value=0<%=j%>
        								<%if( (!BASE_DATE_END_M.equals("")) && BASE_DATE_END_M.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>
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
        							<option value=0<%=j%>
        								<%if( (!BASE_DATE_END_D.equals("")) && BASE_DATE_END_D.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>
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
                      		int i = 0; //資料筆數;
							String bgcolor="#FFFFCC";
                      		if(EXDISTRIPFList != null){%>
                      		 	<tr class="sbody" bgcolor="#BFDFAE">
                      		    	<td width="02%">&nbsp;</td>
                      		    	<td width="15%">檢查人員</td>
                      		    	<td width="28%">金融機構</td>
                      		    	<td width="05%">檢查性質</td>
                      		    	<td width="20%">檢查起迄日</td>
                      		    	<td width="30">負責項目</td>
								</tr>
                   		    	<%if(EXDISTRIPFList.size() == 0){%>
                   			   		<tr class="sbody" bgcolor="<%=bgcolor%>">
                   			   			<td colspan=11 align=center>無資料可供查詢</td>
                   			   		<tr>
                   				<%}else{
                    				while(i < EXDISTRIPFList.size()){
                    					bgcolor = (i % 2 == 0)?"#EBF4E1":"#FFFFCC";%>
                          				<tr class="sbody" bgcolor="<%=bgcolor%>">
                            				<td width="02%"><%=i+1%></td>
            								<td width="15%">
            									<%if( ((DataObject)EXDISTRIPFList.get(i)).getValue("muser_name") != null ){
            										out.print((String)((DataObject)EXDISTRIPFList.get(i)).getValue("muser_name"));
                    		  					}%></td>
                    		  				<td width="28%">
            									<%if( ((DataObject)EXDISTRIPFList.get(i)).getValue("bank_name") != null ){
                    		    					out.print((String)((DataObject)EXDISTRIPFList.get(i)).getValue("bank_name"));
                    		  					}%></td>
                    		  				<td width="05%">
                    						<%if( ((DataObject)EXDISTRIPFList.get(i)).getValue("cmuse_name") != null ){
                    							out.print((String)((DataObject)EXDISTRIPFList.get(i)).getValue("cmuse_name"));
                    						}%> </td>
                    		  				<td width="20%">
                    		  					<%if( ((DataObject)EXDISTRIPFList.get(i)).getValue("st_date") != null ){%>
													<%=Utility.getCHTdate((((DataObject)EXDISTRIPFList.get(i)).getValue("st_date")).toString().substring(0, 10), 0)%>~
													<%=Utility.getCHTdate((((DataObject)EXDISTRIPFList.get(i)).getValue("en_date")).toString().substring(0, 10), 0)%>
                    								</a>
                    								<%System.out.println("TC13_List.jsp st_date="+Utility.getCHTdate((((DataObject)EXDISTRIPFList.get(i)).getValue("st_date")).toString().substring(0, 10), 0));%>
                    							<%}else{%>
                    								<%System.out.println("日期為null");%>
            				 						&nbsp;
            									<%}%></td>
                    						<td width="30%">
                    						<% if( ((DataObject)EXDISTRIPFList.get(i)).getValue("exam_item") != null ){
                    							out.print((String)((DataObject)EXDISTRIPFList.get(i)).getValue("exam_item") +" " + (String)((DataObject)EXDISTRIPFList.get(i)).getValue("expertno_name"));
                     						}%></td>
   					      				</tr>
					    		<%
                  			    	i++;
	                  		    	}//end of while
	                  			}//end of if
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
</html>
<%System.out.println("@@TC13_List.jsp End..");%>
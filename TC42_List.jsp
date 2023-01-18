<%
//1 94.03.07	Fix 下拉選單資料末依編緝條件異動錯誤處理
//94.03.09	拿掉上一頁button處理
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.GregorianCalendar" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%
	System.out.println("@@TC42_List.jsp Start...");

	String szbank_type = ( request.getParameter("SZBANK_TYPE")==null ) ? "" : (String)request.getParameter("SZBANK_TYPE");
	String sztbank_no = ( request.getParameter("tbank_no")==null ) ? "" : (String)request.getParameter("tbank_no");
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");
	String getNo=( request.getParameter("getNo")==null ) ? "" : (String)request.getParameter("getNo");
	String report_type = ( request.getParameter("report_type")==null ) ? "" : (String)request.getParameter("report_type");
	//取得TC42.js 傳回之日期資料
	String BASE_DATE= ( request.getParameter("BASE_DATE")==null ) ? "" : (String)request.getParameter("BASE_DATE");
	String BASE_DATE_Y ="";
	String BASE_DATE_M ="";
	String BASE_DATE_D ="";

	//取得個別年月日資料
	if(!BASE_DATE.equals("")){
		//日期轉換 EX:2002/09/23->91/09/23
		BASE_DATE = Utility.getCHTdate(BASE_DATE,0);
		System.out.println("BASE_DATE="+BASE_DATE);
		int i=0;

		System.out.println("TC42.js inpute date not spaces");

		if(BASE_DATE.length() == 9) i = 1;
		//取得基準日起始日期
		BASE_DATE_Y = BASE_DATE.substring(0,2+i);
		BASE_DATE_M = BASE_DATE.substring(3+i,5+i);
		BASE_DATE_D = BASE_DATE.substring(6+i,BASE_DATE.length());
		System.out.println("BASE_DATE_Y="+BASE_DATE_Y);
		System.out.println("BASE_DATE_M="+BASE_DATE_M);
		System.out.println("BASE_DATE_D="+BASE_DATE_D);
	}else{
		//取得目前年份資料
		GregorianCalendar cal = new GregorianCalendar();
		BASE_DATE_Y = String.valueOf(cal.get(cal.YEAR)-1911);
	}

	System.out.println("act="+act);
	System.out.println("getNo="+getNo);
	System.out.println("TC42_List.sztbank_no="+sztbank_no);
	System.out.println("report_type="+report_type);

	//String bank_type = ( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");
	//System.out.println("szbank_type="+szbank_type);
	//System.out.println("szbank_no="+sztbank_no);

	List EXREPORTFList = (List)request.getAttribute("EXREPORTFList");
	if(EXREPORTFList == null){
	   System.out.println("EXREPORTFList == null");
	}else{
	   System.out.println("不為NULL EXREPORTFList.size()="+EXREPORTFList.size());
	}

	//取得TC42的權限
	Properties permission = ( session.getAttribute("TC42")==null ) ? new Properties() : (Properties)session.getAttribute("TC42");
	if(permission == null){
       System.out.println("TC42_List.permission == null");
    }else{
       System.out.println("TC42_List.permission.size ="+permission.size());
    }
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/TC42.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<title> 久未檢查金融機構名單 </title>
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
                        <center> 久未檢查金融機構名單 </center>
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
						 <td width='15%' align='left' bgcolor='#BDDE9C'>報表類別</td>
						 <td width='85%' colspan=2 bgcolor='EBF4E1'>
                         	<select name='REPORT_TYPE' >
                           	<option value="0" <%if(report_type.equals("0")) out.print("selected");%>>未曾檢查金融機構N家數 </option>
                           	<option value="1" <%if(report_type.equals("1")) out.print("selected");%>>距上次檢查期間最長金融機構家數</option>
                           	</select>
                           	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                           	<%if(permission != null && permission.get("Q") != null && permission.get("Q").equals("Y")){ %>
                           		<a href="javascript:doSubmit(this.document.forms[0],'Qry');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_queryb.gif',1)"><img src="images/bt_query.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a>
                           	<%}%>
                          </td>
                         </td>
                    </tr>
					<tr class="sbody">
						<td width='15%' align='left' bgcolor='#BDDE9C'>家數</td>
						<td width='85%' colspan=2 bgcolor='EBF4E1'>
					  		<input type='text' name='GETNO' value="<%=getNo%>" size='3' maxlength='3' ></td>
                    </tr>
                    <tr class="sbody">
						  <td width='15%' align='left' bgcolor='#BDDE9C'>起始日期</td>
						  <td width='85%' colspan=2 bgcolor='EBF4E1'>
						    <input type='hidden' name='BASE_DATE' value="">
                            <input type='text' name='BASE_DATE_Y' value="<%=BASE_DATE_Y%>" size='3' maxlength='3' onblur='CheckYear(this)'>
        						<font color='#000000'>年
        						<select id="hide1" name=BASE_DATE_M>
        						<option></option>
        						<%
        							for (int j = 1; j <= 12; j++) {
        							if (j < 10){%>
        							<option value=0<%=j%>
        								<%if( BASE_DATE_M.equals("") && String.valueOf(j).equals("1") ) out.print("selected");%>
        								<%if( (!BASE_DATE_M.equals("")) && BASE_DATE_M.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>
            						<%}else{%>
            						<option value=<%=j%> <%if(BASE_DATE_M.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select></font><font color='#000000'>月
        						<select id="hide1" name=BASE_DATE_D>
        						<option></option>
        						<%
        							for (int j = 1; j < 32; j++) {
        							if (j < 10){%>
        							<option value=0<%=j%>
        								<%if( BASE_DATE_D.equals("") && String.valueOf(j).equals("1") ) out.print("selected");%>
        								<%if( (!BASE_DATE_D.equals("")) && BASE_DATE_D.equals(String.valueOf("0"+j))) out.print("selected");%>>0<%=j%></option>
            						<%}else{%>
            						<option value=<%=j%> <%if(BASE_DATE_D.equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select></font><font color='#000000'>日</Font>
                            </td>
	  					</tr>
                 </table>
                      <tr><td><table><tr><br></tr></table></td></tr>
                    <tr>
                      	<td><table width=100% border=1 align=center cellpadding="1" cellspacing="1" bordercolor="#76C657">
                      		<%
                      		String tmpbank_type="";
                      		int i = 0;
                      		String bgcolor="#FFFFCC";
                      		if(EXREPORTFList != null){ %>
                      		 	<tr class="sbody" bgcolor="#BFDFAE">
                      		    	<td width="5%">&nbsp;</td>
                      		    	<td width="10%">機構代碼</td>
                      		    	<td width="55%" nowrap>金融機構名稱</td>
                      		    	<td width="10%">檢查性質</td>
                      		    	<td width="20%">檢查基準日</td>
								</tr>
                   		    <%
                   		    if(EXREPORTFList.size() == 0){%>
                   			   	<tr class="sbody" bgcolor="<%=bgcolor%>">
                   			   		<td colspan=11 align=center>無資料可供查詢</td>
                   			   	<tr>
                   			<%}
                    			while(i < EXREPORTFList.size()){
                    		      	bgcolor = (i % 2 == 0)?"#EBF4E1":"#FFFFCC";
                      		%>
                          		<tr class="sbody" bgcolor="<%=bgcolor%>">
                            		<td width="5%"><%=i+1%></td>
                            		<td width="10%" >
            							<%if( ((DataObject)EXREPORTFList.get(i)).getValue("bank_no") != null ){
                    		    			out.print((String)((DataObject)EXREPORTFList.get(i)).getValue("bank_no"));
                    		  			}%></td>
            						<td width="55%" nowrap>
            							<%if( ((DataObject)EXREPORTFList.get(i)).getValue("bank_name") != null ){
                    		    			out.print((String)((DataObject)EXREPORTFList.get(i)).getValue("bank_name"));
                    		  			}%></td>
                    		  		<td width="10%">&nbsp;
                    				<%if( ((DataObject)EXREPORTFList.get(i)).getValue("cmuse_name") != null ){
                    					out.print((String)((DataObject)EXREPORTFList.get(i)).getValue("cmuse_name"));
                    				}%> </td>
                    		  		<td width="20%">
                    		  			<%if( ((DataObject)EXREPORTFList.get(i)).getValue("base_date") != null ){%>
                    						<%=Utility.getCHTdate((((DataObject)EXREPORTFList.get(i)).getValue("base_date")).toString().substring(0, 10), 0)%>
                    						</a>
                    						<%System.out.println("Tc41_List.jsp base_date="+Utility.getCHTdate((((DataObject)EXREPORTFList.get(i)).getValue("base_date")).toString().substring(0, 10), 0));%>
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
</html>
<%System.out.println("@@TC42_List.jsp End..");%>
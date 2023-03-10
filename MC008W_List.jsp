<%
//97.10.13 create 發佈檢查局財務報表 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>

<%
	
    String YEAR  = Utility.getYear();
   	String MONTH = Utility.getMonth();   
    
	String bank_type = (session.getAttribute("bank_type") == null)?"":(String)session.getAttribute("bank_type");				
	String tbank_no = (session.getAttribute("tbank_no") == null)?"":(String)session.getAttribute("tbank_no");					
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");
	
	String S_YEAR = ( request.getParameter("S_YEAR")==null ) ? YEAR : (String)request.getParameter("S_YEAR");				
	String S_MONTH = ( request.getParameter("S_MONTH")==null ) ? MONTH : (String)request.getParameter("S_MONTH");
    String lguser_id = ( session.getAttribute("muser_id")==null ) ? "" : (String)session.getAttribute("muser_id");		    
    String firstStatus = ( request.getParameter("firstStatus")==null ) ? "" : (String)request.getParameter("firstStatus");			    	
	System.out.print("MC008W_List.act="+act);
	System.out.print(":S_YEAR="+S_YEAR);		    
	System.out.print(":S_MONTH="+S_MONTH);		    
	System.out.println(":firstStatus="+firstStatus);		    
    List reportList = (List)request.getAttribute("reportList");	
	String sqlCmd = "";
	
	//取得MC008W的權限
	Properties permission = ( session.getAttribute("MC008W")==null ) ? new Properties() : (Properties)session.getAttribute("MC008W"); 
	if(permission == null){
       System.out.println("MC008W_List.permission == null");
    }else{
       System.out.println("MC008W_List.permission.size ="+permission.size());               
    }
    
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<title>「檢查局財務報表產生及上傳」</title>
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

function doSubmit(form,cnd){	   
	     if (!checkSingleYM(form.S_YEAR, form.S_MONTH)) {
		      form.S_YEAR.focus();
		      return;
	     } 
    	 if(cnd == 'GenerateRpt'){
    	 	if(!confirm("本作業須執行幾分鐘(注意：執行時請勿強制中斷，以免會產生結果不完整)，你確定要執行？")) return;    	 		 	
	     }	 	  	     
	     form.action="/pages/MC008W.jsp?act="+cnd+"&test=nothing";	    
	     form.submit();	    		    
}	
//-->
</script>
</head>

<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" leftmargin="0">
<form method=post action='#'>
<input type="hidden" name="act" value=""> 
<table width="660" border="0" align="left" cellpadding="0" cellspacing="1" bgcolor="#FFFFFF">
  		<tr> 
   		 <td><img src="images/space_1.gif" width="12" height="12"></td>
  		</tr>
        <%
          String nameColor="nameColor_sbody";
          String textColor="textColor_sbody";
          String bordercolor="#76C657";
        %>  
        <tr> 
          <td bgcolor="#FFFFFF">
		  <table width="660" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td><table width="660" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="190"><img src="images/banner_bg1.gif" width="190" height="17"></td>
                      <td width="280"><font color='#000000' size=4><b> 
                        <center>
                          「檢查局財務報表產生及上傳」 
                        </center>
                        </b></font> </td>
                      <td width="190"><img src="images/banner_bg1.gif" width="190" height="17"></td>
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td><img src="images/space_1.gif" width="12" height="12"></td>
              </tr>
              <tr> 
                <td><table width="660" border="0" align="center" cellpadding="0" cellspacing="0">
               
                    <tr> 
                      <div align="right"><jsp:include page="getLoginUser.jsp?width=660" flush="true" /></div> 
                    </tr>                    
                    <tr> 
                      <td><table width=660 border=1 align=center cellpadding="1" cellspacing="1" bordercolor="<%=bordercolor%>">                                                                              
                          
                          <tr class="sbody">                          
						  <td width='15%' align='left' class="<%=nameColor%>">基準年月</td>
                          <td width='85%' class="<%=textColor%>">	
                            <input type='text' name='S_YEAR' value="<%=S_YEAR%>" size='3' maxlength='3' onblur='CheckYear(this)' <%if(act.equals("List")) out.print("readonly");%>>
        						<font color='#000000'>年
        						<select id="hide1" name=S_MONTH <%if(act.equals("List")) out.print("disabled");%>>
        						<option></option>
        						<%
        							for (int j = 1; j <= 12; j++) {
        							if (j < 10){%>        	
        							<option value=0<%=j%><%if(String.valueOf(Integer.parseInt(S_MONTH)).equals(String.valueOf(j))){out.print(" selected");}%>>0<%=j%></option>        		
            						<%}else{%>
            						<option value=<%=j%><%if(String.valueOf(Integer.parseInt(S_MONTH)).equals(String.valueOf(j))){out.print(" selected");}%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select><font color='#000000'>月</font>
        						&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;                             
        						&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;                             
        						&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;                             
                            <input type="button" value="報表產生及上傳" onclick="javascript:doSubmit(this.document.forms[0],'GenerateRpt');">  &nbsp;                                                                                                                                                            
                          </td>                                   
                          </tr>
                                                                        		      					      
                          </table>      
                      </td>    
                      </tr>    
      </table></td>
  </tr> 
</table>
</form>
</body>

</html>

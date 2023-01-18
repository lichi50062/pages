<%
// 94.04.25 fix 把寫入WTT01.login_mark='N'拿掉 by 2295
// 96.08.15 add 密碼必須為8碼的文數字組合 by 2295
//110.08.05 add 增加寫入登出時間 by 2295
//111.07.25 調整batchno寫入DB錯誤 by 2295	  		
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.LinkedList" %>

<% 
String actMsg = ( request.getAttribute("actMsg")==null ) ? "" : (String)request.getAttribute("actMsg");
String muser_id = ( request.getParameter("muser_id")==null ) ? "" : (String)request.getParameter("muser_id");					
String timeout = ( request.getParameter("timeout")==null ) ? "" : (String)request.getParameter("timeout");					
String logout = ( request.getParameter("logout")==null ) ? "" : (String)request.getParameter("logout");					
							   				   

if(timeout.equals("true") || logout.equals("true")){ 
   
   if(logout.equals("true")){           
      muser_id = (session.getAttribute("muser_id") == null)?"":(String)session.getAttribute("muser_id");
      
      if(!muser_id.equals("") && !muser_id.equals("null")){//104.10.08 fix
      	 List paramList =new ArrayList() ;  
	     String sqlCmd = "UPDATE WTT01 SET "
				    + " login_mark='N'"
				    + ",update_date=sysdate" 	
  				    + " where muser_id=? ";			   
 	     paramList.add(muser_id) ;	  		
 	     this.updDbUsesPreparedStatement(sqlCmd,paramList) ;      	
	 }
	 String batch_no = (session.getAttribute("batch_no") == null)?"":(String)session.getAttribute("batch_no");//110.08.05 add                 
	 if(!batch_no.equals("") && !batch_no.equals("null")){//110.08.05 add
      	 List paramList =new ArrayList() ;  
	     String sqlCmd = "UPDATE WTT06 SET "				 
				    + " logout_time=sysdate" 	
  				    + " where serialno=? ";			   
 	     paramList.add(String.valueOf(batch_no)) ;//111.07.15 調整batchno寫入DB錯誤 by 2295	  			  		
 	     this.updDbUsesPreparedStatement(sqlCmd,paramList) ;      	
	 } 
   }	 
   session.invalidate();   			
}   
System.out.println("LoginError.timeout="+timeout);
System.out.println("LoginError.logout="+logout);
%>
<%!
    private boolean updDbUsesPreparedStatement(String sql ,List paramList) throws Exception{
		List updateDBList = new ArrayList();//0:sql 1:data
	    List updateDBSqlList = new ArrayList();//欲執行updatedb的sql list
		List updateDBDataList = new ArrayList();//儲存參數的List
		
		updateDBDataList.add(paramList);
		updateDBSqlList.add(sql);
		updateDBSqlList.add(updateDBDataList);
		updateDBList.add(updateDBSqlList);
		return DBManager.updateDB_ps(updateDBList) ;
	}
%>
<html>
<head>
<title>MIS管理系統及檢查缺失追蹤管理系統</title>
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

function doSubmit(form){
    if(trimString(form.muser_id.value) =="" ){
       alert("用戶帳號不可為空白");
       form.muser_id.focus();
       return;
    }
    if(trimString(form.muser_password.value) =="" ){
       alert("用戶密碼不可為空白");
       form.muser_password.focus();
       return;
    }else{            
       if((trimString(form.ChangePwd.value) !="" ) && (form.muser_password.value == form.ChangePwd.value)){
          alert("卻更改之密碼不可與舊密碼相同");
          form.ChangePwd.focus();
          return;
       }       
    }
    
    if((trimString(form.ChangePwd.value) !="" ) || (trimString(form.ConfirmPwd.value) !="" )){
       if(form.ChangePwd.value != form.ConfirmPwd.value){
          alert("欲更改之密碼與確認密碼不符合");
          form.ConfirmPwd.focus();
          return;
       }
    }
    
    if(trimString(form.ChangePwd.value) !=""  && form.ChangePwd.value.length < 8 ){
       alert("欲更改之密碼至少為8碼的文數字組合");
       form.ChangePwd.focus();
       return;
    }
    if(trimString(form.ChangePwd.value) !="" && !checkPwd(form.ChangePwd.value)){
       alert("欲更改之密碼必須為文數字組合");
       form.ChangePwd.focus();
       return;
    }
    
    if(trimString(form.ChangePwd.value) !="" && (trimString(form.ChangePwd.value) == trimString(form.muser_id.value))){
       alert("欲更改之密碼不可與帳號相同");     
       form.ChangePwd.focus();
       return;   
    }
    form.submit();
}

function checkPwd(pwd){
   letter = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
   number = "0123456789";
   var count_letter=0;
   var count_num=0;
   //alert(pwd.length);
   for(i =0;i<pwd.length;i++){
       j = letter.indexOf( pwd.charAt(i).toUpperCase() );
       if ( j != -1 ) count_letter=count_letter+1;
   }
   //alert('count_letter='+count_letter);
   if ( count_letter <= 0 ){        
        return false;
   }
   
   for(i =0;i<pwd.length;i++){
       j = number.indexOf( pwd.charAt(i) );
       if ( j != -1 ) count_num=count_num+1;
   }
   if ( count_num <= 0 ){        
        return false;
   }
   //alert('count_num='+count_num);
   return true;
}
function doLink(url){
	
	window.open(url); 
}

var keyPressed;

function chkKey(e){  
    keyPressed = String.fromCharCode(window.event.keyCode);
    if (keyPressed == "\x0D") {
      doSubmit(window.document.loginfrm);
    }  
}

if (window.document.captureEvents!=null) 
  window.document.captureEvents(Event.KEYPRESS)
window.document.onkeypress = chkKey;


//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
<script language="javascript" src="js/Common.js"></script>
</head>

<body background="images/2_bg_1.gif" leftmargin="0" topmargin="0" onLoad="MM_preloadImages('images/2_login_button_01b.gif','images/2_login_button_02b.gif')">
<form name="loginfrm" method=post action='/pages/Login.jsp'>
<table width="780" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
    <td width="344"><img src="images/2_login_image_01.gif" width="344" height="278"></td>
    <td width="79"><img src="images/2_login_image_02.gif" width="86" height="278"></td>
    <td width="130"><img src="images/2_login_image_03.gif" width="328" height="278"></td>
    <td width="227"><img src="images/2_login_image_04.gif" width="21" height="278"></td>
  </tr>
  <tr> 
    <td valign="top" bgcolor="#EAF4E3"><img src="images/2_login_image_05.gif" width="344" height="104"></td>
    <td bgcolor="#EAF4E3">&nbsp;</td>
    <td bgcolor="#C6E0B3"><table width="250" border="0" align="center" cellpadding="0" cellspacing="1" class="sbody">
        <tr> 
          <td class="sbody">用戶帳號:</td>
          <td><input type="text" maxlength=12 name=muser_id value="<%=muser_id%>" size=12></td>
        </tr>        
        <tr> 
          <td width="65" class="sbody">用戶密碼 :</td>
          <td width="181"><input type="password" maxlength=20 name=muser_password size=20></td>
        </tr>        
        <tr> 
          <td class="sbody">更正密碼:</td>
          <td><input type="password" maxlength=20 name=ChangePwd size=20></td>
        </tr>
        <tr> 
          <td class="sbody">確認密碼:</td>
          <td><input type="password" maxlength=20 name=ConfirmPwd size=20></td>
        </tr>        
        <tr> 
          <td>&nbsp;</td>
          <td><table width="150" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="68"><a href="javascript:doSubmit(this.document.forms[0]);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10','','images/2_login_button_01b.gif',1)"><img src="images/2_login_button_01.gif" name="Image10" width="58" height="22" border="0"></a></td>
                <td width="82"><a href="javascript:AskReset(this.document.forms[0]);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image11','','images/2_login_button_02b.gif',1)"><img src="images/2_login_button_02.gif" name="Image11" width="58" height="22" border="0"></a></td>
              </tr>
            </table> </td>
        </tr>  
        
        <%if(!actMsg.equals("")){%>
        <tr> 
          <td colspan="2"><img src="images/icon_1.gif" width="12" height="12" align="absmiddle"> 
           <font color="#006666"><%=actMsg%>
          </font></td>
        </tr>
        <%}%>
              
        <%if(timeout.equals("true")){%>
        <tr> 
           <td colspan="2"><img src="images/icon_1.gif" width="12" height="12" align="absmiddle"> 
             <font color="#006666">登入時間已超過,請重新登入</font>
           </td>
        </tr>
        <%}%>
        <%if(logout.equals("true")){%>
        <tr> 
          <td colspan="2"><img src="images/icon_1.gif" width="12" height="12" align="absmiddle"> 
            <font color="#006666">登出成功!!</font></td>
          </tr>
        <%}%>     
      </table></td>
    <td bgcolor="#C6E0B3">&nbsp;</td>
  </tr>
  <tr> 
    <td colspan="2" bgcolor="#EAF4E3"><table width="400" border="0" align="center" cellpadding="1" cellspacing="1">
        <tr> 
          <td class="sbody">建議使用IE 5.0以上版本之瀏覽器螢幕解析度800X600以上瀏覽</td>
        </tr>
        <tr>
          <td class="sbody">版權所有 翻版必究 Copyringht 2004<a href="#"> BOAF </a>All 
            Rights Reserved .</td>
        </tr>
      </table></td>
    <td bgcolor="#C6E0B3"><table width="310" border="0" align="center" cellpadding="1" cellspacing="1">
        <!--tr> 
          <td width="10"><img src="images/2_icon_01.gif" width="12" height="12" align="absmiddle"></td>
          <td width="283" class="sbody">MIS管理系統及檢查追蹤管理系統線上申請作業說明。</td>
        </tr-->
        <tr> 
          <td valign="top"><img src="images/2_icon_01.gif" width="12" height="12" align="absmiddle"></td>
          <td class="sbody">本系統全年全天候開放，惟須暫停連線服務時，將事先於本網站首頁公佈。</td>
        </tr>
      </table></td>
    <td bgcolor="#C6E0B3">&nbsp;</td>
  </tr>
  
</table>
</form>
</body>
<script language="javascript">
  window.scrollTo(window.pageXOffset,1200);
</script>
</html>

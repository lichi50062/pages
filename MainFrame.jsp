<%
//111.02.08 fix 調整上方功能列高度 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
   String UpdateMuser_Data = null;
   if(session.getAttribute("UpdateMuser_Data") != null){
      UpdateMuser_Data = (String)session.getAttribute("UpdateMuser_Data");
   }   
   System.out.println("MainFrame.UpdateMuser_Data="+UpdateMuser_Data);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>農委會農業金融局管理系統</title>
</head>

<FRAMESET rows="0%,*">
<FRAME SRC=CloseBrowser.jsp>
<frameset rows="98,*" frameborder="NO" border="0" framespacing="0">
  <frame src="TopFrame.jsp" name="topFrame" scrolling="NO" noresize >
  <frameset rows="*" cols="160,*" framespacing="0" frameborder="NO" border="0">
    <%if(UpdateMuser_Data == null || UpdateMuser_Data.equals("false")){%>
    <frame src="UserProgram.jsp?menu=FR" name="leftFrame" frameborder="YES" border="1" framespacing="1">
    <%}else{%>
    <frame src="UserProgram_ZZ.jsp" name="leftFrame" frameborder="YES" border="1" framespacing="1">
    <%}%>
    <frame src="logo.html" name="targetframe">
  </frameset>
</frameset>
<noframes><body>

</body></noframes>
</html>
<%
// 95.08.28 add 申報資料分析支援系統-DS by 2295
// 95.10.16 add 業務經營分析報告-AN
// 			        稽核記錄統計管理-CLG by 2295
// 95.11.20 add 調整符合800*600 by 2295
// 97.08.28 add 監理資訊共享平台 by 2295
// 97.10.07 add 移至監理系統共享平台網址 by 2295
//101.07.18 add 資訊揭露/公務統計 by 2295
//102.06.24 add 警示報表 by 2295
//104.04.29 fix 取消顯示移至監理交換系統 by 2295
//105.05.27 add 專案農貸檢查缺失追蹤管理系統 by 2295
//105.09.05 add 協助措施 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="common.jsp"%>
<%
   String UpdateMuser_Data = null;
   if(session.getAttribute("UpdateMuser_Data") != null){
      UpdateMuser_Data = (String)session.getAttribute("UpdateMuser_Data");
   }   
   System.out.println("TopFrame.UpdateMuser_Data="+UpdateMuser_Data);  
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>無標題文件</title>
<link href="css/b51_menu.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
<!--
function mmLoadMenus() {
  if (window.mm_menu_1) return;
  //金融監理
  window.mm_menu_1 = new Menu("root",120,18,"",12,"#000000","#009966","#FFFFD0","#B0D396","left","middle",0,0,1000,-5,7,true,false,false,0,false,true);    
  mm_menu_1.addMenuItem("<a href='UserProgram.jsp?menu=FR' style='TEXT-DECORATION: none' target=leftFrame>財務報表</a>");
  mm_menu_1.addMenuItem("<a href='UserProgram.jsp?menu=BR' style='TEXT-DECORATION: none' target=leftFrame>基本報表</a>");  
  mm_menu_1.addMenuItem("<a href='UserProgram_WR.jsp' style='TEXT-DECORATION: none' target=leftFrame>警示報表</a>");//102.06.24 add 
  mm_menu_1.addMenuItem("<a href='UserProgram_AN.jsp' style='TEXT-DECORATION: none' target=leftFrame>業務經營分析報告</a>");//95.10.16 add    
  mm_menu_1.addMenuItem("<a href='UserProgram_TM.jsp' style='TEXT-DECORATION: none' target=leftFrame>協助措施</a>");//105.09.05 add   
  mm_menu_1.addMenuItem("<a href='UserProgram_CG.jsp' style='TEXT-DECORATION: none' target=leftFrame>稽核記錄統計管理</a>");//105.05.27 dd 
  
  mm_menu_1.hideOnMouseOut=true;
  mm_menu_1.bgColor='#FFFFFF';
  mm_menu_1.menuBorder=1;
  mm_menu_1.menuLiteBgColor='#FFFFFF';
  mm_menu_1.menuBorderBgColor='#FFFFFF';
  
  
  //金融監理 
  
  if (window.mm_menu_2) return;
  //檢查追蹤管理系統
  window.mm_menu_2 = new Menu("root",120,18,"",12,"#000000","#009966","#FFFFD0","#B0D396","left","middle",1,0,1000,-5,7,true,false,false,0,false,true);
  mm_menu_2.addMenuItem("<a href='UserProgram.jsp?menu=TC' style='TEXT-DECORATION: none' target=leftFrame>檢查行政</a>");//105.05.27 add
  mm_menu_2.addMenuItem("<a href='UserProgram_FL.jsp' style='TEXT-DECORATION: none' target=leftFrame>專案農貸</a>");//105.05.27 add
  mm_menu_2.hideOnMouseOut=true;
  mm_menu_2.bgColor='#FFFFFF';
  mm_menu_2.menuBorder=1;
  mm_menu_2.menuLiteBgColor='#FFFFFF';
  mm_menu_2.menuBorderBgColor='#FFFFFF'; 
  mm_menu_1.writeMenus();
  mm_menu_2.writeMenus();
} // mmLoadMenus()

//-->
</script>
<script language="JavaScript" src="js/mm_menu.js"></script>
</head>

<body bgcolor="#E9F4E3" leftmargin="0" topmargin="0">
<script language="JavaScript1.2">mmLoadMenus();</script>
<table width="1024" border="0" cellpadding="0" cellspacing="0" background="images/TopBanner1_bg_EX.gif">
  <tr> 
    <td width="1024" background="images/TopBanner1_bg_EX.gif"> <table width="780" border="0" align="left" cellpadding="0" cellspacing="0">
        <tr> 
          <td background="images/TopBanner1_bg.gif"> <table width="780" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="195" rowspan="3" bgcolor="#92C374"><img src="images/TopBanner2.gif" width="195" height="70"></td>
                <td width="821"><img src="images/TopBanner3.gif" width="605" height="31"></td>
              </tr>
              <tr> 
                <td height="22" background="images/TopBanner2_bg.gif"><table width="832" height="22" border="0" align="center" cellpadding="1" cellspacing="1">
                    <tr class="sbody"> 
                    <%  
					  if(UpdateMuser_Data == null || UpdateMuser_Data.equals("false")){//95.08.28 add 申報資料分析支援系統-DS//95.10.16 add 稽核記錄統計管理-CLG //101.07.18 add 資訊揭露/公務統計 %>
                      <td width="67"> <div align="center"><a href="#" name="link1" id="link1" style='TEXT-DECORATION: none' onMouseOver="MM_showMenu(window.mm_menu_1,0,20,null,'link1')" onMouseOut="MM_startTimeout();"><font color="#000000">金融監理</font></a></div></td>                      
                      <td width="116"> <div align="center"><a href="#" name="link2" id="link2" style='TEXT-DECORATION: none' onMouseOver="MM_showMenu(window.mm_menu_2,0,20,null,'link2')" onMouseOut="MM_startTimeout();"><font color="#000000">檢查追蹤管理系統</font></a></div></td>                      
                      <!--td width="116"><div align="center"><a href="UserProgram.jsp?menu=TC" target='leftFrame' style='TEXT-DECORATION: none'><font color="#000000">檢查追蹤管理系統</font></a></div></td-->                      
                      <td width="147"><div align="center"><a href="UserProgram.jsp?menu=DS" target='leftFrame' style='TEXT-DECORATION: none'><font color="#000000">申報資料分析支援系統</font></a></div></td>                      
                      <!--td width="111"><div align="center"><a href="UserProgram_CG.jsp" target='leftFrame' style='TEXT-DECORATION: none'><font color="#000000">稽核記錄統計管理</font></a></div></td 105.05.27 移至金融監理-->                      
                      <td width="111"> <div align="center"><a href="UserProgram_MC.jsp" target='leftFrame' style='TEXT-DECORATION: none'><font color="#000000">監理資訊共享平台</font></a></div></td>                                            
                      <td width="57"><div align="center"><a href="UserProgram.jsp?menu=EX" target='leftFrame' style='TEXT-DECORATION: none'><font color="#000000">資訊揭露</font></a></div></td>                      
                      <td width="55"><div align="center"><a href="UserProgram.jsp?menu=OR" target='leftFrame' style='TEXT-DECORATION: none'><font color="#000000">公務統計</font></a></div></td>                      
                      <!--td width="147"><div align="center"><a href="UserProgram.jsp?menu=AG" target='leftFrame' style='TEXT-DECORATION: none'><font color="#000000">專案農貸檢查追蹤管理系統</font></a></div></td-->                    
                      <%}%>
                      <td width="61"><div align="center"><a href="UserProgram_ZZ.jsp" target='leftFrame' style='TEXT-DECORATION: none'><font color="#000000">管理系統</font></a></div></td>                      
                      <td width="55"> <div align="center"><a href="LoginError.jsp?logout=true" target='_top' style='TEXT-DECORATION: none'><font color="#000000">登出</font></a></div></td>
                                        
                    </tr>
                  </table></td>
              </tr>
              <tr> 
                <td bgcolor="#92C374">&nbsp;</td>
              </tr>
            </table></td>
        </tr>
      </table></td>
    <td width="190" background="images/TopBanner1_bg_EX.gif" bgcolor="#92C374">&nbsp;</td>
  </tr>
</table>
</body>
</html>

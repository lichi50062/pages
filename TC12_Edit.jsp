<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%!
   final static int base_date = 0;
   final static int go_date = 1;
   final static int bk_date = 2;
   final static int ware_date = 3;
   final static int st_date = 4;
   final static int en_date = 5;
   final static int report_date = 6;
   final static int date_num = 7;
%>


<%	
    
    
    String disp_id = "";
    String exam_id = "";
    String exam_div = "";
    String appr_date = "";
    String basis = "";
    String ch_type = "";
    String prj_item = "";
    String prj_remark = "";
    String bank_name = "";
    String bank_no ="";
    String workday = "0";
    String workmday = "0";
    String go_dateAP = "";
    String st_dateAP = "";
    String en_dateAP = "";
    String bk_dateAP = "";
    String[] dateY = new String[date_num];
    String[] dateM = new String[date_num];
    String[] dateD = new String[date_num];
    boolean exist = false;
    
    
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");				
	System.out.println("Page: TC12_Edit.jsp    Action:"+act);
	
	List exTripList = (List) request.getAttribute("ExTrip");
	if(exTripList != null) {
	    DataObject bean = (DataObject) exTripList.get(0);
	    disp_id = bean.getValue("disp_id") != null ? (String)bean.getValue("disp_id") : "";
        exam_id = bean.getValue("exam_id") != null ? (String)bean.getValue("exam_id") : "";
        exam_div = bean.getValue("exam_div") != null ? (String)bean.getValue("exam_div") : "";
        bank_no = bean.getValue("bank_no") != null ? (String)bean.getValue("bank_no") : "";
        bank_name = bean.getValue("bank_name") != null ? (String)bean.getValue("bank_name") : "";
        
	}
	
	// 取參數值
	if(act.equals("Edit")) {
	    List exDateList = (List) request.getAttribute("ExDate");
	    exist = ((String) request.getAttribute("Exist")).equals("T") ? true : false ;
	    if (exDateList != null && exDateList.size() > 0 ) {
	        DataObject bean = (DataObject) exDateList.get(0);
	        
	        workday = (String)bean.getValue("workdays");
            workmday = (String)bean.getValue("workmdays");
            go_dateAP = (String)bean.getValue("go_ampm");
            st_dateAP = (String)bean.getValue("st_ampm");
            en_dateAP = (String)bean.getValue("en_ampm");
            bk_dateAP = (String)bean.getValue("bk_ampm");
            
            dateY[base_date] = String.valueOf(Integer.parseInt((String)bean.getValue("base_datey"))-1911);
	        dateM[base_date] = String.valueOf(Integer.parseInt((String)bean.getValue("base_datem")));
	        dateD[base_date] = String.valueOf(Integer.parseInt((String)bean.getValue("base_dated")));
	        
	        dateY[go_date] = String.valueOf(Integer.parseInt((String)bean.getValue("go_datey"))-1911);
	        dateM[go_date] = String.valueOf(Integer.parseInt((String)bean.getValue("go_datem")));
	        dateD[go_date] = String.valueOf(Integer.parseInt((String)bean.getValue("go_dated")));
	        
	        dateY[bk_date] = String.valueOf(Integer.parseInt((String)bean.getValue("bk_datey"))-1911);
	        dateM[bk_date] = String.valueOf(Integer.parseInt((String)bean.getValue("bk_datem")));
	        dateD[bk_date] = String.valueOf(Integer.parseInt((String)bean.getValue("bk_dated")));
	        
	        dateY[ware_date] = String.valueOf(Integer.parseInt((String)bean.getValue("ware_datey"))-1911);
	        dateM[ware_date] = String.valueOf(Integer.parseInt((String)bean.getValue("ware_datem")));
	        dateD[ware_date] = String.valueOf(Integer.parseInt((String)bean.getValue("ware_dated")));
	        
	        dateY[st_date] = String.valueOf(Integer.parseInt((String)bean.getValue("st_datey"))-1911);
	        dateM[st_date] = String.valueOf(Integer.parseInt((String)bean.getValue("st_datem")));
	        dateD[st_date] = String.valueOf(Integer.parseInt((String)bean.getValue("st_dated")));
	        
	        dateY[en_date] = String.valueOf(Integer.parseInt((String)bean.getValue("en_datey"))-1911);
	        dateM[en_date] = String.valueOf(Integer.parseInt((String)bean.getValue("en_datem")));
	        dateD[en_date] = String.valueOf(Integer.parseInt((String)bean.getValue("en_dated")));
	        
	        dateY[report_date] = String.valueOf(Integer.parseInt((String)bean.getValue("report_datey"))-1911);
	        dateM[report_date] = String.valueOf(Integer.parseInt((String)bean.getValue("report_datem")));
	        dateD[report_date] = String.valueOf(Integer.parseInt((String)bean.getValue("report_dated")));
        }else{
           System.out.println("WARNING !!!  Search detail data is NULL ");
        }
	}else {
	    Calendar c = Calendar.getInstance();
	    go_dateAP = String.valueOf(c.get(Calendar.AM_PM));
        st_dateAP = String.valueOf(c.get(Calendar.AM_PM));
        en_dateAP = String.valueOf(c.get(Calendar.AM_PM));
        bk_dateAP = String.valueOf(c.get(Calendar.AM_PM));
	    for(int i=0; i < dateY.length; i++) {
	        dateY[i] = String.valueOf(c.get(Calendar.YEAR)-1911);
	        dateM[i] = String.valueOf(c.get(Calendar.MONTH)+1);
	        dateD[i] = String.valueOf(c.get(Calendar.DATE));
	        System.out.println("date["+i+"]= "+dateY[i]+dateM[i]+dateD[i]);
	    }
	}
	System.out.println("disp_id ="+disp_id);	
	System.out.println("exam_id ="+exam_id);
	System.out.println("exam_div ="+exam_div);
	System.out.println("appr_date ="+appr_date);
	System.out.println("basis ="+basis);
	System.out.println("ch_type ="+ch_type);
	System.out.println("prj_item ="+prj_item);
	System.out.println("prj_remark ="+prj_remark);
	System.out.println("bank_name ="+bank_name);
	System.out.println("bank_no ="+bank_no);
	
	//取得TC12的權限
	Properties permission = ( session.getAttribute("TC12")==null ) ? new Properties() : (Properties)session.getAttribute("TC12"); 
	if(permission == null){
       System.out.println("TC12_Edit.permission == null");
    }else{
       System.out.println("TC12_Edit.permission.size ="+permission.size());
  }
%>

<HTML>
<HEAD>
<TITLE>檢查行政系統 檢查行程計劃</TITLE>
<META content=text/html; charset=UTF-8 http-equiv=Content-Type>
</HEAD>


<script language="javascript" src="js/TC12.js"></script>
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

<BODY bgColor=#FFFFFF>
<Form name='form' method=post action='/pages/TC12.jsp'>
<input type='hidden' name="act" value=''>
<input type='hidden' name="base_date" value=''>
<input type='hidden' name="go_date" value=''>
<input type='hidden' name="bk_date" value=''>
<input type='hidden' name="ware_date" value=''>
<input type='hidden' name="st_date" value=''>
<input type='hidden' name="en_date" value=''>
<input type='hidden' name="report_date" value=''>
<input type='hidden' name="disp_id" value='<%=disp_id%>'>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
     <tr> 
           <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
           <td width="50%"><font color='#000000' size=4><b><center>檢查行程計劃建檔維護管理 </center></b></font> </td>
           <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
         </tr>
</table>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
<tr>  
    <div align="right">
      <jsp:include page="getLoginUser.jsp" flush="true" />
    </div> 
</tr> 
</table>  

<Table border=1 width='100%' align=center height="35" bgcolor="#FFFFF" bordercolor="#76C657">
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">派差通知單編號</td>
<td width="70%" bgcolor="#EBF4E1" height="1"><%=disp_id%></td>
</tr>
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">檢查證(函)編號</td>
<td width="70%" bgcolor="#EBF4E1" height="1"><%=exam_id%>
  <select name="exam_div" size="1" disabled>
    <option values=''></option>
    <%List examDivList = (List) request.getAttribute("Exam_Div");
      if(examDivList != null) {
          for(int i=0; i < examDivList.size(); i++) {
             DataObject bean =(DataObject)examDivList.get(i);%>
    <option value='<%=bean.getValue("cmuse_id")%>'><%=bean.getValue("cmuse_name")%></option>
    <%    }
      } %>
  </select></td>
</tr>
<tr class="sbody">
<td width="100%" height="1" colspan="2">
  <table border="1" id="inspect" width="100%" bgcolor="#FFFFF" bordercolor="#76C657">
    <tr class="sbody" bgcolor="#BFDFAE">
      <td width="30%">姓名</td>
      <td width="70%">查核項目</td>
    </tr>
    <%
      List inspectorList = (List)request.getAttribute("Inspector");
      if( inspectorList != null ) { 
    %>
      
    <% }else { %>
    <tr class="sbody" bgcolor="#D3EBE0">
      <td width="30%"><input type="text" name="inspector" size="20" maxlength="7" value="無資料" readonly></td>
      <td width="70%"><input type="text" name="expert" size="40" maxlength="7" value="無資料" readonly></td>
    </tr>
    <%
    }
    %>
  </table>
</td>
</tr>
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">受檢單位</td>
<td width="70%" bgcolor="#EBF4E1" height="1"><%=bank_no%>&nbsp;&nbsp;&nbsp;&nbsp;<%=bank_name%></td>   
</tr>
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">檢查基準日</td>
<td width="70%" bgcolor="#EBF4E1" height="1">
<% if(exist) {%>
<input type="hidden" name="base_dateY" value="<%=dateY[base_date]%>">
<input type="hidden" name="base_dateM" value="<%=dateM[base_date]%>">
<input type="hidden" name="base_dateD" value="<%=dateD[base_date]%>">
<%=dateY[base_date]%>年<%=dateM[base_date]%>月<%=dateD[base_date]%>日
<% } else {%>
<input type="text" name="base_dateY" size="3" maxlength="3" value="<%=dateY[base_date]%>"> 
  年 <select name="base_dateM" size="1">       
    <option value="1">01</option>
    <option value="2">02</option>
    <option value="3">03</option>
    <option value="4">04</option>
    <option value="5">05</option>
    <option value="6">06</option>
    <option value="7">07</option>
    <option value="8">08</option>
    <option value="9">09</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
  </select>月 
  <select name="base_dateD" size="1">       
    <option value="1">01</option>
    <option value="2">02</option>
    <option value="3">03</option>
    <option value="4">04</option>
    <option value="5">05</option>
    <option value="6">06</option>
    <option value="7">07</option>
    <option value="8">08</option>
    <option value="9">09</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
    <option value="13">13</option>
    <option value="14">14</option>
    <option value="15">15</option>
    <option value="16">16</option>
    <option value="17">17</option>
    <option value="18">18</option>
    <option value="19">19</option>
    <option value="20">20</option>
    <option value="21">21</option>
    <option value="22">22</option>
    <option value="23">23</option>
    <option value="24">24</option>
    <option value="25">25</option>
    <option value="26">26</option>
    <option value="27">27</option>
    <option value="28">28</option>
    <option value="29">29</option>
    <option value="30">30</option>
    <option value="31">31</option>
  </select>日<%}%></td>
</tr>
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">去程日期</td>
<td width="70%" bgcolor="#EBF4E1" height="1">
<% if(exist) {%>
<input type="hidden" name="go_dateY" value="<%=dateY[go_date]%>">
<input type="hidden" name="go_dateM" value="<%=dateM[go_date]%>">
<input type="hidden" name="go_dateD" value="<%=dateD[go_date]%>">
<%=dateY[go_date]%>年<%=dateM[go_date]%>月<%=dateD[go_date]%>日 <%= go_dateAP.equals("0") ?  "上午" : "下午"%>
<% } else {%>
<input type="text" name="go_dateY" size="3" maxlength="3" value="<%=dateY[go_date]%>"> 
  年 <select name="go_dateM" size="1">       
    <option value="1">01</option>
    <option value="2">02</option>
    <option value="3">03</option>
    <option value="4">04</option>
    <option value="5">05</option>
    <option value="6">06</option>
    <option value="7">07</option>
    <option value="8">08</option>
    <option value="9">09</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
  </select>月 <select name="go_dateD" size="1">       
    <option value="1">01</option>
    <option value="2">02</option>
    <option value="3">03</option>
    <option value="4">04</option>
    <option value="5">05</option>
    <option value="6">06</option>
    <option value="7">07</option>
    <option value="8">08</option>
    <option value="9">09</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
    <option value="13">13</option>
    <option value="14">14</option>
    <option value="15">15</option>
    <option value="16">16</option>
    <option value="17">17</option>
    <option value="18">18</option>
    <option value="19">19</option>
    <option value="20">20</option>
    <option value="21">21</option>
    <option value="22">22</option>
    <option value="23">23</option>
    <option value="24">24</option>
    <option value="25">25</option>
    <option value="26">26</option>
    <option value="27">27</option>
    <option value="28">28</option>
    <option value="29">29</option>
    <option value="30">30</option>
    <option value="31">31</option>
  </select>日<select name="go_dateAP" size="1">
    <option value="0">上午</option>
    <option value="1">下午</option>
  </select><%}%></td>
</tr>
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">查庫日期</td>
<td width="70%" bgcolor="#EBF4E1" height="1">
<% if(exist) {%>
<input type="hidden" name="ware_dateY" value="<%=dateY[ware_date]%>">
<input type="hidden" name="ware_dateM" value="<%=dateM[ware_date]%>">
<input type="hidden" name="ware_dateD" value="<%=dateD[ware_date]%>">
<%=dateY[ware_date]%>年<%=dateM[ware_date]%>月<%=dateD[ware_date]%>日 
<% } else {%>
<input type="text" name="ware_dateY" size="3" maxlength="3" value="<%=dateY[ware_date]%>" > 
  年 <select name="ware_dateM" size="1">       
    <option value="1">01</option>
    <option value="2">02</option>
    <option value="3">03</option>
    <option value="4">04</option>
    <option value="5">05</option>
    <option value="6">06</option>
    <option value="7">07</option>
    <option value="8">08</option>
    <option value="9">09</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
  </select>月 <select name="ware_dateD" size="1">       
    <option value="1">01</option>
    <option value="2">02</option>
    <option value="3">03</option>
    <option value="4">04</option>
    <option value="5">05</option>
    <option value="6">06</option>
    <option value="7">07</option>
    <option value="8">08</option>
    <option value="9">09</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
    <option value="13">13</option>
    <option value="14">14</option>
    <option value="15">15</option>
    <option value="16">16</option>
    <option value="17">17</option>
    <option value="18">18</option>
    <option value="19">19</option>
    <option value="20">20</option>
    <option value="21">21</option>
    <option value="22">22</option>
    <option value="23">23</option>
    <option value="24">24</option>
    <option value="25">25</option>
    <option value="26">26</option>
    <option value="27">27</option>
    <option value="28">28</option>
    <option value="29">29</option>
    <option value="30">30</option>
    <option value="31">31</option>
  </select>日<%}%></td>
</tr>
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">開始檢查日</td>
<td width="70%" bgcolor="#EBF4E1" height="1">
<% if(exist) {%>
<input type="hidden" name="st_dateY" value="<%=dateY[st_date]%>">
<input type="hidden" name="st_dateM" value="<%=dateM[st_date]%>">
<input type="hidden" name="st_dateD" value="<%=dateD[st_date]%>">
<%=dateY[st_date]%>年<%=dateM[st_date]%>月<%=dateD[st_date]%>日 <%= st_dateAP.equals("0") ?  "上午" : "下午"%>
<% } else {%>
<input type="text" name="st_dateY" size="3" value="<%=dateY[st_date]%>"> 
  年 <select name="st_dateM" size="1">       
    <option value="1">01</option>
    <option value="2">02</option>
    <option value="3">03</option>
    <option value="4">04</option>
    <option value="5">05</option>
    <option value="6">06</option>
    <option value="7">07</option>
    <option value="8">08</option>
    <option value="9">09</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
  </select>月 <select name="st_dateD" size="1">       
    <option value="1">01</option>
    <option value="2">02</option>
    <option value="3">03</option>
    <option value="4">04</option>
    <option value="5">05</option>
    <option value="6">06</option>
    <option value="7">07</option>
    <option value="8">08</option>
    <option value="9">09</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
    <option value="13">13</option>
    <option value="14">14</option>
    <option value="15">15</option>
    <option value="16">16</option>
    <option value="17">17</option>
    <option value="18">18</option>
    <option value="19">19</option>
    <option value="20">20</option>
    <option value="21">21</option>
    <option value="22">22</option>
    <option value="23">23</option>
    <option value="24">24</option>
    <option value="25">25</option>
    <option value="26">26</option>
    <option value="27">27</option>
    <option value="28">28</option>
    <option value="29">29</option>
    <option value="30">30</option>
    <option value="31">31</option>
  </select>日<select name="st_dateAP" size="1">
    <option value="0">上午</option>
    <option value="1">下午</option>
  </select><%}%></td>
</tr>
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">完成檢查日</td>
<td width="70%" bgcolor="#EBF4E1" height="1">
<% if(exist) {%>
<input type="hidden" name="en_dateY" value="<%=dateY[en_date]%>">
<input type="hidden" name="en_dateM" value="<%=dateM[en_date]%>">
<input type="hidden" name="en_dateD" value="<%=dateD[en_date]%>">
<%=dateY[en_date]%>年<%=dateM[en_date]%>月<%=dateD[en_date]%>日 <%= en_dateAP.equals("0") ?  "上午" : "下午"%>
<% } else {%>
<input type="text" name="en_dateY" size="3" maxlength="3" value="<%=dateY[en_date]%>"> 
  年 <select name="en_dateM" size="1">      
    <option value="1">01</option>
    <option value="2">02</option>
    <option value="3">03</option>
    <option value="4">04</option>
    <option value="5">05</option>
    <option value="6">06</option>
    <option value="7">07</option>
    <option value="8">08</option>
    <option value="9">09</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
  </select>月 <select name="en_dateD" size="1">      
    <option value="1">01</option>
    <option value="2">02</option>
    <option value="3">03</option>
    <option value="4">04</option>
    <option value="5">05</option>
    <option value="6">06</option>
    <option value="7">07</option>
    <option value="8">08</option>
    <option value="9">09</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
    <option value="13">13</option>
    <option value="14">14</option>
    <option value="15">15</option>
    <option value="16">16</option>
    <option value="17">17</option>
    <option value="18">18</option>
    <option value="19">19</option>
    <option value="20">20</option>
    <option value="21">21</option>
    <option value="22">22</option>
    <option value="23">23</option>
    <option value="24">24</option>
    <option value="25">25</option>
    <option value="26">26</option>
    <option value="27">27</option>
    <option value="28">28</option>
    <option value="29">29</option>
    <option value="30">30</option>
    <option value="31">31</option>
  </select>日<select name="en_dateAP" size="1">
    <option value="0">上午</option>
    <option value="1">下午</option>
  </select><%}%></td>
</tr>
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">回程日期</td>

<td width="70%" bgcolor="#EBF4E1" height="1">
<% if(exist) {%>
<input type="hidden" name="bk_dateY" value="<%=dateY[bk_date]%>">
<input type="hidden" name="bk_dateM" value="<%=dateM[bk_date]%>">
<input type="hidden" name="bk_dateD" value="<%=dateD[bk_date]%>">
<%=dateY[bk_date]%>年<%=dateM[bk_date]%>月<%=dateD[bk_date]%>日 <%= bk_dateAP.equals("0") ?  "上午" : "下午"%>
<% } else {%>
<input type="text" name="bk_dateY" size="3" maxlength="3" value="<%=dateY[bk_date]%>"> 
  年 <select name="bk_dateM" size="1">       
    <option value="1">01</option>
    <option value="2">02</option>
    <option value="3">03</option>
    <option value="4">04</option>
    <option value="5">05</option>
    <option value="6">06</option>
    <option value="7">07</option>
    <option value="8">08</option>
    <option value="9">09</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
  </select>月 <select name="bk_dateD" size="1">       
    <option value="1">01</option>
    <option value="2">02</option>
    <option value="3">03</option>
    <option value="4">04</option>
    <option value="5">05</option>
    <option value="6">06</option>
    <option value="7">07</option>
    <option value="8">08</option>
    <option value="9">09</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
    <option value="13">13</option>
    <option value="14">14</option>
    <option value="15">15</option>
    <option value="16">16</option>
    <option value="17">17</option>
    <option value="18">18</option>
    <option value="19">19</option>
    <option value="20">20</option>
    <option value="21">21</option>
    <option value="22">22</option>
    <option value="23">23</option>
    <option value="24">24</option>
    <option value="25">25</option>
    <option value="26">26</option>
    <option value="27">27</option>
    <option value="28">28</option>
    <option value="29">29</option>
    <option value="30">30</option>
    <option value="31">31</option>
  </select>日<select name="bk_dateAP" size="1">
    <option value="0">上午</option>
    <option value="1">下午</option>
  </select><%}%></td>
</tr>
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">提出報告日</td>
<td width="70%" bgcolor="#EBF4E1" height="1">
<% if(exist) {%>
<input type="hidden" name="report_dateY" value="<%=dateY[report_date]%>">
<input type="hidden" name="report_dateM" value="<%=dateM[report_date]%>">
<input type="hidden" name="report_dateD" value="<%=dateD[report_date]%>">
<%=dateY[report_date]%>年<%=dateM[report_date]%>月<%=dateD[report_date]%>日
<% } else {%>
<input type="text" name="report_dateY" size="3" maxlength="3" value="<%=dateY[report_date]%>" > 
  年 <select name="report_dateM" size="1">      
    <option value="1">01</option>
    <option value="2">02</option>
    <option value="3">03</option>
    <option value="4">04</option>
    <option value="5">05</option>
    <option value="6">06</option>
    <option value="7">07</option>
    <option value="8">08</option>
    <option value="9">09</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
  </select>月 <select name="report_dateD" size="1">      
    <option value="1">01</option>
    <option value="2">02</option>
    <option value="3">03</option>
    <option value="4">04</option>
    <option value="5">05</option>
    <option value="6">06</option>
    <option value="7">07</option>
    <option value="8">08</option>
    <option value="9">09</option>
    <option value="10">10</option>
    <option value="11">11</option>
    <option value="12">12</option>
    <option value="13">13</option>
    <option value="14">14</option>
    <option value="15">15</option>
    <option value="16">16</option>
    <option value="17">17</option>
    <option value="18">18</option>
    <option value="19">19</option>
    <option value="20">20</option>
    <option value="21">21</option>
    <option value="22">22</option>
    <option value="23">23</option>
    <option value="24">24</option>
    <option value="25">25</option>
    <option value="26">26</option>
    <option value="27">27</option>
    <option value="28">28</option>
    <option value="29">29</option>
    <option value="30">30</option>
    <option value="31">31</option>
  </select>日<%}%></td>
</tr>
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">工作天</td>
<td width="70%" bgcolor="#EBF4E1" height="1">
  <%if(exist) {%>
     <%=workday%>
  <% } else {%>
  <input type="text" name="workday" size="3" maxlength="3" value ="<%=workday%>" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  
  <a href="javascript:calWorkDay(form);"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image112','','images/bt_01b.gif',1)"><img src="images/bt_01.gif" name="Image102"  border="0" id="Image112"></a> 
  <%}%>
</td>
</tr>
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">工作人天</td>
<td width="70%" bgcolor="#EBF4E1" height="1">
<%if(exist) {%>
     <%=workmday%>
  <% } else {%>
<input type="text" name="workmdays" size="3" maxlength="3" value ="<%=workmday%>" readonly> 
<%}%>
</td>
</tr>
</Table>
<table border=0 align=center width=550>
<tr class="sbody"><th>
<% if(act.equals("New")) {%>
<%if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){ %>
<a href="javascript:doSubmit(form,'Insert','');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_addb.gif',1)"><img src="images/bt_add.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a>
<a href="javascript:clearAll();"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image104','','images/bt_cancelb.gif',1)"><img src="images/bt_cancel.gif" name="Image104" width="66" height="25" border="0" id="Image104"></a>
<%}%>
  <% } else if(act.equals("Edit")) {%>
<%if(permission != null && permission.get("U") != null && permission.get("U").equals("Y")){ %> 
<a href="javascript:doSubmit(form,'Update','');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image122','','images/bt_updateb.gif',1)"><img src="images/bt_update.gif" name="Image122" width="66" height="25" border="0" id="Image122"></a>
<%}%>
<%if(permission != null && permission.get("D") != null && permission.get("D").equals("Y")){ %>
<a href="javascript:doSubmit(form,'Delete','');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image103','','images/bt_deleteb.gif',1)"><img src="images/bt_delete.gif" name="Image103" width="66" height="25" border="0" id="Image103"></a>
<%}%>  
<% } %>
<a href="javascript:history.back();"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image105" width="80" height="25" border="0" id="Image105"></a>

</th></tr></Table>
<table width="100%" border="0" cellpadding="1" cellspacing="1" class="sbody">
  <tr> 
    <td colspan="2">
      <font color='#990000'>
        <img src="images/arrow_1.gif" width="28" height="23" align="absmiddle">
        <font color="#007D7D" size="3">使用說明  : </font></font></td>
  </tr>
  <tr> 
    <td width="3%">&nbsp;</td>
    <td width="97%"> 
      <ul>                                                
        <%if(act.equals("List")) {%>
            <li>本網頁提供基本資料查詢功能。</li>
            <li>按<font color="#666666">【查詢】</font>則依查詢條件值查詢資料。</li> 
		    <li>按<font color="#666666">【新增】</font>則新增一筆資料。</li> 
        <% } else if(act.equals("Qry")) {%>
            <li>本網頁提供基本資料查詢功能。</li>
            <li>按<font color="#666666">【查詢】</font>則依查詢條件值查詢資料。</li> 
		    <li>按<font color="#666666">【新增】</font>則新增一筆資料。</li> 
		    <li>按<font color="#666666">【派差通知單編號連結】</font>則可修改或查看此筆資料。</li>
        <%} else if(act.equals("New")) {%>
            <li>本網頁提供基本資料維護功能。</li>
		    <li>按<font color="#666666">【確定】</font>即將資料寫入資料庫。</li> 
		    <li>按<font color="#666666">【取消】</font>放棄資料修改。</li>
		<%} else if(act.equals("Edit")) {%>
            <li>本網頁提供基本資料維護功能。</li>
            <li>按<font color="#666666">【修改】</font>即將修改資料寫入資料庫。</li> 
		    <li>按<font color="#666666">【刪除】</font>刪除這一筆資料。</li>
        <% } %> 
        <li>按<font color="#666666">【回上一頁】則回至上個畫面</font>。</li>
      </ul>
    </td>
 </tr>
</table>
</form>
</BODY>
<script language="javascript">

<!--
<%if(!exist) { %>
setSelect(form.base_dateM, '<%=dateM[base_date]%>');
setSelect(form.base_dateD, '<%=dateD[base_date]%>');

setSelect(form.go_dateM, '<%=dateM[go_date]%>');
setSelect(form.go_dateD, '<%=dateD[go_date]%>');


setSelect(form.ware_dateM, '<%=dateM[ware_date]%>');
setSelect(form.ware_dateD, '<%=dateD[ware_date]%>');

setSelect(form.st_dateM, '<%=dateM[st_date]%>');
setSelect(form.st_dateD, '<%=dateD[st_date]%>');

setSelect(form.en_dateM, '<%=dateM[en_date]%>');
setSelect(form.en_dateD, '<%=dateD[en_date]%>');

setSelect(form.report_dateM, '<%=dateM[report_date]%>');
setSelect(form.report_dateD, '<%=dateD[report_date]%>');

setSelect(form.go_dateAP, '<%=go_dateAP%>');
setSelect(form.st_dateAP, '<%=st_dateAP%>');
setSelect(form.en_dateAP, '<%=en_dateAP%>');

<%}%>
setSelect(form.bk_dateAP, '<%=bk_dateAP%>');
setSelect(form.bk_dateM, '<%=dateM[bk_date]%>');
setSelect(form.bk_dateD, '<%=dateD[bk_date]%>');

<%
      if( inspectorList != null ) { 
        for(int i=0; i<inspectorList.size(); i++) {
            DataObject bean = (DataObject) inspectorList.get(i);
    %>
    addItem(form,'<%=bean.getValue("muser_name")%>', '<%=bean.getValue("expertno_name")%>');
<%      }
      } %>

 setSelect(form.exam_div,"<%=exam_div%>");
-->
</script>
</HTML>




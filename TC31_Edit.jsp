<%// 99.06.01 fix 縣市合併 by 2808 %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>

<% 
Map dataMap =Utility.saveSearchParameter(request);
String bank_type = Utility.getTrimString(dataMap.get("bank_type")) ;
String bank_no = Utility.getTrimString(dataMap.get("bank_no")) ;
String sn_docno = Utility.getTrimString(dataMap.get("sn_docno")) ;
String reportno = Utility.getTrimString(dataMap.get("reportno")) ;
String sn_date = Utility.getTrimString(dataMap.get("sn_date")) ;
String doctype = Utility.getTrimString(dataMap.get("doctype")) ;
String doctype_cnt =Utility.getTrimString(dataMap.get("doctype_cnt")) ;
String limitdate =Utility.getTrimString(dataMap.get("limitdate")) ;
String message = Utility.getTrimString(dataMap.get("actMsg")) ;
String sn_dateY =Utility.getTrimString(dataMap.get("sn_dateY")) ;
String sn_dateM = Utility.getTrimString(dataMap.get("sn_dateM")) ;
String sn_dateD = Utility.getTrimString(dataMap.get("sn_dateD")) ;
String limitY = Utility.getTrimString(dataMap.get("limitY")) ;
String limitM = Utility.getTrimString(dataMap.get("limitM")) ;
String limitD = Utility.getTrimString(dataMap.get("limitD")) ;
int flag = 2;
String act =  Utility.getTrimString(dataMap.get("act")) ;				
System.out.println("Page: TC31_Edit.jsp    Action:"+act);
System.out.println("message = "+message);
List bankList = (List)request.getAttribute("BANK");
if(bankList != null && bankList.size() > 0) {
    System.out.println("BANK SIZE : "+bankList.size());
    DataObject bean = (DataObject) bankList.get(0);
    bank_type = (String)bean.getValue("cmuse_name");
    bank_no = (String)bean.getValue("bank_no");
}

if(act.equals("New")) {
    Calendar c = Calendar.getInstance();
    sn_dateY = String.valueOf(c.get(Calendar.YEAR)-1911);
    // sn_dateM = String.valueOf(c.get(Calendar.MONTH)+1);
    // sn_dateD = String.valueOf(c.get(Calendar.DATE));
    // sn_dateM = "";
    // sn_dateD = "";
}
else if(act.equals("Edit")) {
    List detailList = (List) request.getAttribute("DETAIL");
    if(detailList != null && detailList.size() > 0) {
            DataObject bean = (DataObject)detailList.get(0);
            sn_docno = bean.getValue("sn_docno") != null ? (String)bean.getValue("sn_docno") : "";
            doctype = bean.getValue("doctype") != null ? (String)bean.getValue("doctype") : "";
            doctype_cnt = bean.getValue("doctype_cnt") != null ? (String)bean.getValue("doctype_cnt") : "";
            sn_dateY = bean.getValue("sn_datey") != null ? (String)bean.getValue("sn_datey") : "";
            sn_dateM = bean.getValue("sn_datem") != null ? (String)bean.getValue("sn_datem") : "";
            sn_dateD = bean.getValue("sn_dated") != null ? (String)bean.getValue("sn_dated") : "";
            limitY = bean.getValue("limity") != null ? (String)bean.getValue("limity") : "";
            limitM = bean.getValue("limitm") != null ? (String)bean.getValue("limitm") : "";
            limitD = bean.getValue("limitd") != null ? (String)bean.getValue("limitd") : "";
            
            if(!sn_dateY.equals("") && !sn_dateM.equals("") && !sn_dateD.equals("")) {
                sn_dateY =  String.valueOf(Integer.parseInt(sn_dateY)-1911);
                sn_dateM =  String.valueOf(Integer.parseInt(sn_dateM));
                sn_dateD =  String.valueOf(Integer.parseInt(sn_dateD));
            }
            if(!limitY.equals("") && !limitM.equals("") && !limitD.equals("")) {
                limitY =  String.valueOf(Integer.parseInt(limitY)-1911);
                limitM =  String.valueOf(Integer.parseInt(limitM));
                limitD =  String.valueOf(Integer.parseInt(limitD));
            }
    }
}

//取得權限
	Properties permission = ( session.getAttribute("TC31")==null ) ? new Properties() : (Properties)session.getAttribute("TC31"); 
	if(permission == null){
       System.out.println("TC31_Edit.permission == null");
    }else{
       System.out.println("TC31_Edit.permission.size ="+permission.size());
  }

%>

<HTML>
<HEAD>
<TITLE>發文記錄維護</TITLE>
</HEAD>
<script language="javascript" src="js/TC31.js"></script>
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

function message() {
<% if(!message.equals("")) {%>
   alert("<%=message%>");
<%}%>
return ;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

//-->
</script>
<BODY bgColor=#FFFFFF >
<Form name='form' method=post action='TC31.jsp'>
<input type='hidden' name='act' value=<%=act %>>
<input type='hidden' name='limitdate' value=''>
<input type='hidden' name='sn_date' value=''>

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
     <tr> 
           <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
           <td width="50%"><font color='#000000' size=4><b><center>發文記錄建檔維護管理 </center></b></font> </td>
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
<td width="30%" bgcolor="#BDDE9C" height="1">金融機構類別</td>
<td width="70%" bgcolor="#EBF4E1" height="1">
<input type='hidden' size='30' value='<%=bank_type%>' > <%=bank_type%> &nbsp;</td>
</tr>
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">金融機構代號</td>
<td width="70%" bgcolor="#EBF4E1" height="1">
<input type='hidden' size='50' value='<%=bank_no%>' ><%=bank_no%> &nbsp;</td>
</tr>
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">檢查報告編號</td>
<td width="70%" bgcolor="#EBF4E1" height="1">

<input type="text" name="reportno" size="30" maxlength="30" value='<%=reportno %>'>&nbsp; 

  <a href="javascript:doSubmit(form,'<%=act%>','<%=sn_docno%>',form.reportno.value);"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image112','','images/bt_02b.gif',1)"><img src="images/bt_02.gif" name="Image112"  border="0" id="Image112"></a>
 </td>
</tr>
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">發文文號</td>
<td width="70%" bgcolor="#EBF4E1" height="1">
<%if(act.equals("New")) {%>
<input type="text" name="sn_docno" size="30" maxlength="30" value='<%=sn_docno%>'>
<%} else {%>
<input type="hidden" name="sn_docno" size="30" value='<%=sn_docno%>'>
<%=sn_docno%>&nbsp;
<%}%>
  </td>
</tr>
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">發文日期</td>
<td width="70%" bgcolor="#EBF4E1" height="1">
<input type="text" name="sn_dateY" size="3" maxlength="3" value='<%=sn_dateY%>'> 
  年 <select name="sn_dateM">     
    <option value=""></option>
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
  <select name="sn_dateD">
    <option value=""></option>    
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
  </select>日</td>
</tr>
<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">公文類別</td>
<td width="70%" bgcolor="#EBF4E1" height="1" nowrap>

 <select size="1" name="doctype" >
    <option value="">請選擇...</option>
    <% List docTypeList = (List) request.getAttribute("DOCTYPE");
       if(docTypeList != null) {
           for(int i=0 ; i < docTypeList.size(); i++) {
               DataObject bean = (DataObject) docTypeList.get(i);
    %>
    <option value="<%=bean.getValue("cmuse_id")%>"><%=bean.getValue("cmuse_name")%></option>
    <%     }
       }%>
  </select>&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;
  次數
  <select name="doctype_cnt">    
    <option value="">00</option>
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
  </select>
  &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;
  <a href="javascript:calSendDate(form);"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image223','','images/0228_bt_09b.gif',1)"><img src="images/0228_bt_09.gif" name="Image223"  height="25" border="0" id="Image223"></a>

  </td>
</tr>

<tr class="sbody">
<td width="30%" bgcolor="#BDDE9C" height="1">限期函報日期</td>
<td width="70%" bgcolor="#EBF4E1" height="1">
<input type="text" name="limitY" size="3" value="<%=limitY%>"> 
  年 <select name="limitM">     
    <option value=""></option>
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
  
  <select name="limitD">     
    <option value></option>
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
  </select>日
  
  </td>
</tr>

</Table>
<table width="100%" border="0" cellpadding="1" cellspacing="1" class="sbody">
  <tr>
    <td colspan='2' align='center'>
    <% if(act.equals("New")) {%>
<%if(permission != null && permission.get("A") != null && permission.get("A").equals("Y")){ %>
  <a href="javascript:doSubmit(form,'Insert','');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_confirmb.gif',1)"><img src="images/bt_confirm.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a>
  <a href="javascript:clearAll();"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image104','','images/bt_cancelb.gif',1)"><img src="images/bt_cancel.gif" name="Image104" width="66" height="25" border="0" id="Image104"></a>
  <a href="javascript:location.replace('TC31.jsp?act=List');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_05b.gif',1)"><img src="images/bt_05.gif" name="Image105" width="80" height="25" border="0" id="Image105"></a>
<%}%>
  <% } else if(act.equals("Edit")) {%>
<%if(permission != null && permission.get("U") != null && permission.get("U").equals("Y")){ %> 
  <a href="javascript:doSubmit(form,'Update','');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image102','','images/bt_updateb.gif',1)"><img src="images/bt_update.gif" name="Image102" width="66" height="25" border="0" id="Image102"></a>
  
  
<%}%>
<%if(permission != null && permission.get("D") != null && permission.get("D").equals("Y")){ %> 
  <a href="javascript:doSubmit(form,'Delete','');"onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image103','','images/bt_deleteb.gif',1)"><img src="images/bt_delete.gif" name="Image103" width="66" height="25" border="0" id="Image103"></a>
 
<%}%>
   <a href="javascript:location.replace('TC31.jsp?act=List');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_05b.gif',1)"><img src="images/bt_05.gif" name="Image105" width="80" height="25" border="0" id="Image105"></a>
<% } %>
  </td>
    
    </td>
  </tr>
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

        <li>按<font color="#666666">【回查詢頁】</font>則回至查詢畫面。</li>
      </ul>
    </td>
 </tr>
</table>
</form>
</BODY>
<script language="javascript" >
<!--

message();
setSelect(form.sn_dateM,"<%=sn_dateM%>");
setSelect(form.sn_dateD,"<%=sn_dateD%>");



setSelect(form.doctype,"<%=doctype%>");
//subOption();
setSelect(form.doctype_cnt,"<%=doctype_cnt%>");
form.limitY.value = "<%=limitY%>";
setSelect(form.limitM,"<%=limitM%>");
setSelect(form.limitD,"<%=limitD%>");
-->
</script>
</HTML>






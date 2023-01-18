<%
//101.08 created by 2968
//101.11.29 改為清單式鎖定狀態
//102.02.06 fix 年月.月份若不為2位數時,補0 by 2295
//108.05.27 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@include file="./include/bank_no_hsien_id.include" %>
<%
	// 查詢條件值 
    Map dataMap =Utility.saveSearchParameter(request);
	String report_no = "FR001WD";
	showCancel_No=false;//顯示營運中/裁撤別
	showBankType=false;//顯示金融機構類別
    showCityType=false;//顯示縣市別
    showUnit=false;//顯示金額單位
    showPageSetting=true;//顯示本報表採用A4紙張直印/橫印 
	setLandscape=false;//true:橫印
    String cancel_no = "N";
	String act = Utility.getTrimString(dataMap.get("act"));	
    String bank_type = Utility.getTrimString(dataMap.get("bank_type"));	  
    String bankType = bank_type;//ym_hsien_id_unit.include用
    String title = ((bank_type.equals("6"))?"農會":"漁會");  
    
  	//101.11.29  改為清單式鎖定狀態
  	List paramList =new ArrayList() ;
  	paramList.add(Integer.parseInt(Utility.getYear()+(Utility.getMonth().length() == 1?"0":"")+Utility.getMonth())) ;
  	List FR001WDList = DBManager.QueryDB_SQLParam(
  	    "select rpt_month_yymm.m_year,rpt_month_yymm.m_month,"+
  	    "		rpt_month_yymm.m_year || '/' || decode(length(rpt_month_yymm.m_month),1,'0')||rpt_month_yymm.m_month as m_yearmonth,"+ //--查詢年月
  	    "		decode(rpt_month.lock_count,null,'未鎖定',0,'未鎖定','已鎖定') as lock_status "+ //--鎖定狀態
  	    "  from rpt_month_yymm left join "+
  	    " 		(select m_year,m_month,report_no,count(*) as lock_count from rpt_month where report_no='FR001WD' "+
  	    "group by m_year,m_month,report_no )rpt_month on rpt_month_yymm.m_year = rpt_month.m_year "+
  	    "   and rpt_month_yymm.m_month = rpt_month.m_month "+
  	    "   and rpt_month_yymm.report_no = rpt_month.report_no "+
  	    " where  rpt_month_yymm.report_no='FR001WD' "+
  	    "   and ((rpt_month_yymm.m_year * 100 + rpt_month_yymm.m_month) >= '9012' "+
  	    "   and (rpt_month_yymm.m_year * 100 + rpt_month_yymm.m_month) <= ? ) "+
  	    "order by rpt_month_yymm.m_year desc,rpt_month_yymm.m_month desc ",paramList,"");	
	if(FR001WDList == null){
	   System.out.println("FR001WDList == null");
	}else{
	   System.out.println("FR001WDList.size()="+FR001WDList.size());
	}
%>

<script language="javascript" src="js/Common.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
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

function MM_jumpMenu(targ,selObj,restore){ //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}

function doSubmit(act,locYear,locMonth){ 
	if(act=="download"){	
	   this.document.forms[0].action = "/pages/FR001WD_Excel.jsp?act="+act;	
	}else{
	   this.document.forms[0].action = "/pages/FR001WD.jsp?act="+act+"&locYear="+locYear+"&locMonth="+locMonth;	
	}
   this.document.forms[0].target = '_self';
   this.document.forms[0].submit();   
}

//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form method=post action='#'>
<input type=hidden name="bank_type" value=<%=bank_type%>>
<input type='hidden' name="showTbank" value='false'>
<input type='hidden' name="showCityType" value='<%=showCityType%>'>
<input type='hidden' name="showCancel_No" value='<%=showCancel_No%>'>
<input type='hidden' name="locYear" value=''>
<input type='hidden' name="locMonth" value=''>
<table width='550' border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
     <td>&nbsp;</td>
  </tr>
  <tr>
    <td width="30%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
    <td width="40%"><font color='#000000' size=4><b><center>農漁會信用部營運概況</center></b></font></td>
    <td width="30%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
  </tr>
</table>
<Table border=1 width='550' align=center height="65" bgcolor="#FFFFF" bordercolor="#76C657">
	<tr class="sbody">
	    <td width="118" bgcolor="#BDDE9C" height="1">查詢日期</td>
	    <td width="416" bgcolor="#EBF4E1" height="1">
	    <input type="text" name="S_YEAR" size="3" maxlength="3" value="<%=YEAR%>"
	    <%if(showCityType) { //added by 2808 99.11.5%> 
	    	onChange="changeCity('CityXML', form.cityType, form.S_YEAR, form)"
	    <%} %> 
	    >
	      年      
	    <select id="hide1" name=S_MONTH>        						
	     <%
	     	for (int j = 1; j <= 12; j++) {
	     	if (j < 10){%>        	
	     	<option value=0<%=j%> <%if(String.valueOf(Integer.parseInt(MONTH)).equals(String.valueOf(j))) out.print("selected");%>>0<%=j%></option>        		
	     	<%}else{%>
	     	<option value=<%=j%> <%if(String.valueOf(Integer.parseInt(MONTH)).equals(String.valueOf(j))) out.print("selected");%>><%=j%></option>
	     	<%}%>
	     <%}%>
	     </select><font color='#000000'>月</font>
	     <%if(Utility.getPermission(request,report_no,"P")){//Print %> 
	       <a href="javascript:doSubmit('download','','')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image411','','images/bt_print.gif',1)"><img src="images/bt_print.gif" name="Image411" width="66" height="25" border="0" id="Image41"></a>
	       <%}%>
		</td>
	</tr>
	<tr class="sbody">
		<td width="118" bgcolor="#BDDE9C" height="1">金額單位</td>
		<td width="416" bgcolor="#EBF4E1" height="1">
	   	<select size="1" name="Unit">
	     	<option value ='1'>元</option>
	     	<option value ='1000'>千元</option>
	     	<option value ='10000'>萬元</option>
	     	<option value ='1000000'>百萬元</option>
	     	<option value ='10000000'>千萬元</option>
	     	<option value ='100000000' selected>億元</option>
	   	</select><font color="red">該年月資料,請確認資料正確性後,再執行鎖定</font>
		</td>
	</tr>
	<%@include file="./include/rpt_style.include" %><!--報表格式挑選-->
</Table>

<table border="1" width="550" align="center" height="54" bgcolor="#FFFFF" bordercolor="#76C657">
	<%
        int i = 0;      
        if(FR001WDList != null){ %>
        	<tr class="sbody"  bgcolor="#BFDFAE">
				<td width="18%">基準年月</td>
				<td width="21%">鎮定狀態</td>
				<td width="27%">執行鎖定</td>    
			</tr>   
            <% 	if(FR001WDList.size() == 0){%>
                 <tr class="sbody"  bgcolor="#BFDFAE">
                   	<td colspan=11 align=center>無資料可供查詢</td>
            <% }
               	while(i < FR001WDList.size()){ 
               		if(i%2==0){%>
                    	<tr class="sbody"  bgcolor='#EBF4E1'>
                 <% }else{%>
                        <tr class="sbody"  bgcolor='#FFFFCC'>
                 <% }
			        String m_yearmonth=(String)((DataObject)FR001WDList.get(i)).getValue("m_yearmonth");
                 	String m_year="";
                 	String m_month="";
               		if(!m_yearmonth.equals("")||!m_yearmonth.equals(null)){
                 	    int l = m_yearmonth.length();
                 	    if(l==6){
                 	        m_year=m_yearmonth.substring(0, 3);
                 	        m_month=m_yearmonth.substring(4, 6);
                 	    }else{
                 	        m_year=m_yearmonth.substring(0, 2);
                	        m_month=m_yearmonth.substring(3, 5);
                 	    }
                 	}
                 %>
			        <td width="18%"><%if( ((DataObject)FR001WDList.get(i)).getValue("m_yearmonth") != null ) out.print((String)((DataObject)FR001WDList.get(i)).getValue("m_yearmonth")); else out.print("&nbsp;");%></td>
			        <td width="21%"><%if( ((DataObject)FR001WDList.get(i)).getValue("lock_status") != null  && !((((String)((DataObject)FR001WDList.get(i)).getValue("lock_status"))).trim()).equals("") ) out.print((String)((DataObject)FR001WDList.get(i)).getValue("lock_status")); else out.print("&nbsp;");%></td>
			        <td width="27%">&nbsp;<a href="javascript:doSubmit('goLocked','<%=m_year%>','<%=m_month%>')" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image511','','images/bt_lock.gif',0)"><img src="images/bt_lock.gif" name="Image511" width="66" height="25" border="0" id="Image51"></a></td>    
				</tr> 
				<%
                  	i++;
	                }//end of while
	    }//end of if
	    %>            
</table>
<table border="0" width="550" align="center" height="54" >
	<tr class="sbody" >
	  <td><font color="red">該年月資料,請確認資料正確性後,再執行鎖定</font></td>        
	</tr>
</table>
</form>
</BODY>
</html>
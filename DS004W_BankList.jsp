<%
// 95.10.17 create by 2295
// 95.11.14 add 區分BOAF.MIS配色 by 2295
//          add 有農/漁會的menu時,才可顯示農/漁會;登入者為A111111111 or 農金局時,才可顯示農漁會 by 2295
//          add 可選機構代號權限設定 by 2295
// 		   add 登入者為A111111111 or 農金局時,才可選全部 by 2295
// 95.12.04 add 增加年月區間 by 2295
//          add 起始日期不可大於結束日期 by 2295
// 95.12.07 add 金融機構代號若本來選全部->各信用部 or 各信用部->全部,清空已選報表欄位/排序欄位 by 2295
// 99.05.14 fix 配合縣市合併調整 程式 by 2808
//108.03.25 add 報表格式轉換 by 2295
//108.04.25 add 所有欄位移至DS_bank_no_all.include(因多個include會造成多列空白) by 2295
//111.03.23 調整Edge無法挑選縣市別/金融機構代碼無資料可挑選 by 2295
//111.03.23 調整Edge可選擇項目,dbclick時無法將項目移至已選擇項目 by 2295
//111.03.23 調整Edge>.>>.<.<<及上移.下移無作用 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>

<%@ page import="java.util.*" %>
<%
	//查詢條件值 
	Map dataMap =Utility.saveSearchParameter(request);
	String report_no = "DS004W";	
	String ds_memo1 = "(1)選取[全部]：係以「各縣市彙總表」之報表格式列印&nbsp;&nbsp;";//108.04.25 add		
	String ds_memo2 = "(2)選取[各信用部]：按「資產品質分析明細資料」的報表內容列印";//108.04.25 add		
	String act = Utility.getTrimString(dataMap.get("act"));	
	
	//營運中/已裁撤===================================================================================
	String cancel_no = ( session.getAttribute("CANCEL_NO")==null ) ? "N" : (String)session.getAttribute("CANCEL_NO");				
	//========================================================================================================
	String bank_type = (session.getAttribute("nowbank_type")==null)?"6":(String)session.getAttribute("nowbank_type");
	//String title=(bank_type.equals("6"))?"農會":"漁會";	
	String szExcelAction = (session.getAttribute("excelaction")==null)?"download":(String)session.getAttribute("excelaction");		
	System.out.println("DS004W_BankList.szExcelAction="+szExcelAction);
	String hsien_id = ( session.getAttribute("HSIEN_ID")==null ) ? "ALL" : (String)session.getAttribute("HSIEN_ID");				
	System.out.println("DS004W_BankList.hsien_id="+hsien_id);
	String YEAR  = Utility.getYear();
   	String MONTH = Utility.getMonth();
	String S_YEAR = (session.getAttribute("S_YEAR")==null)?YEAR:(String)session.getAttribute("S_YEAR");
	String E_YEAR = (session.getAttribute("E_YEAR")==null)?YEAR:(String)session.getAttribute("E_YEAR");
	String S_MONTH = (session.getAttribute("S_MONTH")==null)?MONTH:(String)session.getAttribute("S_MONTH");            
	String E_MONTH = (session.getAttribute("E_MONTH")==null)?MONTH:(String)session.getAttribute("E_MONTH");                      
   	String Unit = (session.getAttribute("Unit")==null)?"":(String)session.getAttribute("Unit");   
   	String printStyle = (session.getAttribute("printStyle")==null)?"xls":(String)session.getAttribute("printStyle");//108.03.25 add	
   	//95.11.10 取得登入者資訊.DS_bank_type=================================================================================================
	String muser_id = ( session.getAttribute("muser_id")==null ) ? "" : (String)session.getAttribute("muser_id");		
    String muser_bank_type = ( session.getAttribute("bank_type")==null ) ? "" : (String)session.getAttribute("bank_type");			    
	String DS_bank_type = (session.getAttribute("DS_bank_type")==null)?"6":(String)session.getAttribute("DS_bank_type");	
	
	//==============================================================================================================    	    
    System.out.println("S_MONTH="+S_MONTH);
	System.out.println("bank_type="+bank_type);
	System.out.println("DS_bank_type="+DS_bank_type);			
      
%>

<%@include file="./include/DS_bank_no_hsien_id.include" %>

<script src="js/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/DSUtil.js"></script>
<script language="javascript" src="js/movesels.js"></script>
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

function doSubmit(cnd){
   if(cnd == 'createRpt'){      
      if(document.BankListfrm.BankListDst.length == 0){      	 
      	 alert('金融機構代碼必須選擇');
      	 return;
      }
      if(!chInput(document.BankListfrm,'BankList')) return;//95.12.04 add 起始日期不可大於結束日期
      if(document.BankListfrm.btnFieldList.value == ''){
         alert('報表欄位必須選擇');
         return;
      }
      
      if(!confirm("本項報表會執行10-15秒，是否確定執行？")){
         return;
      }   
   }
   MoveSelectToBtn(document.BankListfrm.BankList, document.BankListfrm.BankListDst);	
   fn_ShowPanel('<%=report_no%>',cnd);     
}


function ResetAllData(){
    if(confirm("確定要清除已選定的資料嗎？")){  	
        document.BankListfrm.BankListDst.length = 0;
        document.BankListfrm.HSIEN_ID[0].selected=true;	   
        changeOption(document.BankListfrm,'');
        //clearBankList();95.12.07
	}
	return;	
}
//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form method=post action='#' name='BankListfrm'>
<table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
     <td>&nbsp;</td>
  </tr>
  <tr> 
    <td bgcolor="#FFFFFF">
	<table width="750" border="0" align="center" cellpadding="1" cellspacing="1">        
        <tr> 
          <td><table width="750" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="240"><img src="images/banner_bg1.gif" width="240" height="17"></td>
                <td width="*" class="title_font">A04資產品質分析資料 </td>
                <td width="240"><img src="images/banner_bg1.gif" width="240" height="17"></td>
              </tr>
            </table></td>
        </tr>
        <%@include file="./include/DS_bank_no_all.include" %><!-- 金融機構所有欄位-->         
        
      </table>
    </td>
  </tr>
</table>
<INPUT type="hidden" name=BankList><!--//BankList儲存已勾選的金融機構代碼-->
<INPUT type="hidden" name=btnFieldList value='<%if(session.getAttribute("btnFieldList") != null) out.print((String)session.getAttribute("btnFieldList"));%>'><!--//btnFieldList儲存已勾選的報表欄位名稱-->
<INPUT type="hidden" name=clearbtnFieldList><!--//儲存是否清除btnFieldList-->
<INPUT type="hidden" name=agri_loan value="0"><!--//專案農貸註記-->
</form>
<script language="JavaScript" >
<!--

<%
//從session裡把勾選的金融機構代碼讀出來.放在BankListDst
if(session.getAttribute("BankList") != null && !((String)session.getAttribute("BankList")).equals("")){ 
   System.out.println("DS004W_BankList.BankList="+(String)session.getAttribute("BankList"));
%>
var bnlist;
bnlist = '<%=(String)session.getAttribute("BankList")%>';
var a = bnlist.split(',');
for (var i =0; i < a.length; i ++){
	var j = a[i].split('+');
	this.document.forms[0].BankListDst.options[i] = new Option(j[1], j[0]);
}
<%}%>

setSelect(document.BankListfrm.HSIEN_ID,"<%=hsien_id%>");
setSelect(document.BankListfrm.CANCEL_NO,"<%=cancel_no%>");
//changeOption(this.document.forms[0],'');//
changeCity(document.BankListfrm.HSIEN_ID, document.BankListfrm.S_YEAR, document.BankListfrm);
/*95.12.07
function clearBankList(){
 <%
	//session.setAttribute("BankList",null);//清除已勾選的BankList
 %>
}
*/
-->
</script>

</body>
</html>

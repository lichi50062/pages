<%
// 95/01/03 create by 4180
// 99.11.10 機構單位排序 fix by 2808
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%
	Map dataMap = Utility.saveSearchParameter(request);
	boolean showCancel_No=false;//顯示營運中/裁撤別
	boolean showBankType=true;//顯示金融機構類別
	boolean showCityType=true;//顯示縣市別
	boolean showUnit=false;//顯示金額單位
	boolean showPageSetting=true;//顯示報表列印格式
	boolean setLandscape=false;//true:橫印
	String report_no  = "FR036WW" ;
	String Unit  = "1000" ;
	String act = Utility.getTrimString(dataMap.get("act")) ;
					
	String bank_type = (session.getAttribute("nowbank_type")==null)?"":(String)session.getAttribute("nowbank_type");
	String title=(bank_type.equals("6"))?"農會":"漁會";
	
	String szExcelAction = (session.getAttribute("excelaction")==null)?"download":(String)session.getAttribute("excelaction");
	String hsien_id = ( session.getAttribute("HSIEN_ID")==null ) ? "ALL" : (String)session.getAttribute("HSIEN_ID");
	System.out.println("FR036WW_BankList.szExcelAction="+szExcelAction);
					
	//System.out.println("FR036WW_BankList.hsien_id="+hsien_id);

	List tbankList = Utility.getBankList(request) ; 
	DataObject bean = null;
    //取得FR034WW的權限 ==> move to Utility
    //縣市別=============================
	List cityList  =  Utility.getCity() ;
	// XML Ducument for 縣市別 begin
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"CityXML\">");
    out.println("<datalist>");
    for(int i=0;i< cityList.size(); i++) {
        bean =(DataObject)cityList.get(i);
        out.println("<data>");
        out.println("<cityType>"+bean.getValue("hsien_id")+"</cityType>");
        out.println("<cityName>"+bean.getValue("hsien_name")+"</cityName>");
        out.println("<cityValue>"+bean.getValue("hsien_id")+"</cityValue>");
        out.println("<cityYear>"+bean.getValue("m_year").toString()+"</cityYear>");
        out.println("</data>");
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 縣市別 end
    // XML Ducument for 總機構代碼 begin 
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"TBankXML\">");
    out.println("<datalist>");
    for(int i=0;i< tbankList.size(); i++) {
        bean =(DataObject)tbankList.get(i);
        out.println("<data>");        
        out.println("<BnType>"+bean.getValue("bn_type")+"</BnType>");
        out.println("<HsienId>"+bean.getValue("hsien_id")+"</HsienId>");
        out.println("<bankValue>"+bean.getValue("bank_no")+"</bankValue>");
        out.println("<bankName>"+bean.getValue("bank_no")+bean.getValue("bank_name")+"</bankName>");
        out.println("<bankYear>"+bean.getValue("m_year").toString()+"</bankYear>");
        out.println("</data>");
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 總機構代碼 end	
    
   	//取得目前年月資料
	String S_YEAR = ( request.getParameter("S_YEAR")==null ) ? "" : (String)request.getParameter("S_YEAR");
	String S_MONTH = ( request.getParameter("S_MONTH")==null ) ? "" : (String)request.getParameter("S_MONTH");

	Calendar rightNow = Calendar.getInstance();
   	String YEAR  = String.valueOf(rightNow.get(Calendar.YEAR)-1911); //回覆值為西元年故需-1911取得民國年;
   	String MONTH = String.valueOf(rightNow.get(Calendar.MONTH)+1);   //月份以0開始故加1取得實際月份;
   	String E_YEAR = YEAR;
    String E_MONTH = MONTH;
    if (E_MONTH.length()==1) E_MONTH="0"+E_MONTH;
%>



<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/FR036WW.js"></script>
<script language="javascript" src="js/BRUtil.js"></script>
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

function doSubmit(form,cnd){
   if(cnd == 'createRpt'){      
      if(this.document.forms[0].rptStyle.value ==1 && this.document.forms[0].BankListDst.length == 0){      	 
      	 alert('金融機構代碼必須選擇');
      	 return;
      }
   }   
   
   MoveSelectToBtn(this.document.forms[0].BankList, this.document.forms[0].BankListDst);	
   fn_ShowPanel(form,cnd);      
}

function ResetAllData(){
    if(confirm("確定要清除已選定的資料嗎？")){  	
        this.document.forms[0].BankListDst.length = 0;
        this.document.forms[0].HSIEN_ID[0].selected=true;	   
        changeOption(this.document.forms[0],'');
        clearBankList();
	}
	return;	
}
//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<form method=post action='#' name='BankListfrm'>
<input type='hidden' name="showTbank" value='<%=showBankType %>'><!-- 是否須顯示總機構單位 -->
<input type='hidden' name="showCityType" value='<%=showCityType%>'>
<input type="hidden" name='showCancel_No' value='<%=showCancel_No %>'/>
<input type="hidden" name="bankType" value="<%=bank_type %>"/>
<input type="hidden" name="bank_type" value="<%=bank_type %>"/>
<table width='600' border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
    <td width="50%"><font color='#000000' size=4><center><%=title%>信用部統一貸款資料各項報表 </center></font></td>
    <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
  </tr>
</table>
<table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
     <td>&nbsp;</td>
  </tr>
  <tr> 
    <td bgcolor="#FFFFFF">
	<table width="600" border="0" align="center" cellpadding="1" cellspacing="1">        
        <tr> 
          <td><img src="images/space_1.gif" width="8" height="8"></td>
        </tr>
        <tr> 
          <td><table width="600" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#5DA525">
              <tr> 
                <td bordercolor="#E9F4E3" bgcolor="#E9F4E3"><table width="600" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#E9F4E3">
                    <tr> 
                      <td bgcolor="#B0D595" class="sbody"> <div align="right">

                      	  <input type='radio' name="excelaction" value='download' <%if(szExcelAction.equals("download")){out.print("checked");}%> >下載報表
                      	  <%if(Utility.getPermission(request,report_no,"P")){//Print %>                    	        	                                   		     			        
                      	  <a href="javascript:doSubmit( this.document.forms[0],'createRpt');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image41','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image41" width="66" height="25" border="0" id="Image41"></a> 
                      	  <%}%>
                          <a href="javascript:ResetAllData();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image51','','images/bt_cancelb.gif',0)"><img src="images/bt_cancel.gif" name="Image51" width="66" height="25" border="0" id="Image51"></a> 
                          <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image61','','images/bt_reporthelpb.gif',1)"><img src="images/bt_reporthelp.gif" name="Image61" width="80" height="25" border="0" id="Image61"></a> 
                        </div></td>
                    </tr>

                    <tr > 
                      <td bgcolor="#E9F4E3"> <table width="580" border="0" align="center" cellpadding="0" cellspacing="0">
                        <tr class="sbody">
                     	<td>
                    		<img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">報表格式 :</span>
                            <select size="1" name="report_type" onchange="javascript:hiddenYM(this.document.forms[0]);">                   
                            <option value ='3' selected>信用部統一農貸資料某二指定期間新增戶數金額比較報表</option>
                            <option value ='2'>信用部統一貸款資料指定單月新增戶數金額比較報表</option>
                            <option value ='1'>信用部統一貸款資料單月報表</option>
                            
                          </select>
        						
                        </td>
                    </tr>
                    
                     <tr class="sbody">
                     <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">起迄年月 :</span> 						  						
                            
							<input type='text' name='S_YEAR' value="<%=YEAR%>" size='3' maxlength='3' onblur='CheckYear(this)' 
                                   onChange="clearSelectBlock();changeCity('CityXML', form.HSIEN_ID, form.S_YEAR, form)" >
        						<font color='#000000'>年
        						<select id="hide1" name=S_MONTH>
        						<option></option>
        						<%
        							for (int j = 1; j <= 12; j++) {
        							if (j < 10){%>        	
        							<option value=0<%=j%> <%if(Integer.parseInt(MONTH)==j) out.print("selected");%>>0<%=j%></option>        		
            						<%}else{%>
            						<option value=<%=j%> <%if(Integer.parseInt(MONTH)==j) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select><font color='#000000'>月</font>
							~
                            <input type='text' name='E_YEAR' value="<%=E_YEAR%>" size='3' maxlength='3' onblur='CheckYear(this)'>
        						<font color='#000000'>年
        						<select id="hide1" name=E_MONTH>
        						<option></option>
        						<%
        							for (int j = 1; j <= 12; j++) {
        							if (j < 10){%>        	
        							<option value=0<%=j%> <%if(Integer.parseInt(E_MONTH)==j) out.print("selected");%>>0<%=j%></option>        		
            						<%}else{%>
            						<option value=<%=j%> <%if(Integer.parseInt(E_MONTH)==j) out.print("selected");%>><%=j%></option>
            						<%}%>
        						<%}%>
        						</select><font color='#000000'>月</font>
        						 <input type=hidden name=S_DATE value=''>
        						 <input type=hidden name=E_DATE value=''>
                            </td>
                    </tr>
                    
                        
                     <tr class="sbody">
                      <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">金額單位 :</span>
                          <select size="1" name="Unit">
                            <option value ='1' <%if((!Unit.equals("")) && Unit.equals("1")) out.print("selected");%>>元</option>
						     <option value ='1000' <%if((!Unit.equals("")) && Unit.equals("1000")) out.print("selected");%>>千元</option>
						     <option value ='10000' <%if((!Unit.equals("")) && Unit.equals("10000")) out.print("selected");%>>萬元</option>
						     <option value ='1000000' <%if((!Unit.equals("")) && Unit.equals("1000000")) out.print("selected");%>>百萬元</option>
						     <option value ='10000000' <%if((!Unit.equals("")) && Unit.equals("10000000")) out.print("selected");%>>千萬元</option>
						     <option value ='100000000' <%if((!Unit.equals("")) && Unit.equals("100000000")) out.print("selected");%>>億元</option>
                          </select>
		              </td>
                    </tr> 
                    <tr class="sbody">
					  <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">報表格式 :</span>
                          <select size="1" name="rptStyle" onChange="checkflag()">                         
                             <option value ='1' selected>明細表</option>
                             <option value ='0' >總表</option>                            
                          </select>
		              </td>
					</tr>            
					<tr class="sbody"> 
                       <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">縣市別 :</span>                                
                           <select size="1" name="HSIEN_ID" onchange="javascript:changeOption(document.forms[0],'');" />
						</td>
                    </tr>
                    <tr class="sbody">
                      <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">輸出格式 :</span>
                          <input name='printStyle' type='radio' value='xls' checked>Excel
                          <input name='printStyle' type='radio' value='ods' >ODS
                          <input name='printStyle' type='radio' value='pdf' >PDF
		              </td>
                    </tr> 





                          
                        </table></td>
                    </tr>
                    <td width="500"   bgcolor='#BDDE9C' height="5" align="right"> 可選擇項目&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;已選擇項目                   	        
                    <tr> 
                    
                      <td bgcolor="#E9F4E3"> <table width="579" border="0" align="center" cellpadding="1" cellspacing="1" bgcolor="#E9F4E3">
                          <tr> 
                            <td width="195">  
                            <select multiple  size=10  id="BankListSrc" name="BankListSrc" ondblclick="javascript:movesel(this.document.forms[0].BankListSrc,this.document.forms[0].BankListDst);" style="width: 17em">							
							</select>
                            </td>
                            <td width="52"><table width="40" border="0" align="center" cellpadding="3" cellspacing="3">
                                <tr> 
                                  <td>
                                  <div align="center">                                 
                                  <a href="javascript:movesel(this.document.forms[0].BankListSrc,this.document.forms[0].BankListDst);"><img src="images/arrow_right.gif" width="24" height="22" border="0"></a>
                                  </div>
                                  </td>
                                </tr>
                                <tr> 
                                  <td>
                                  <div align="center">                                  
                                  <a href="javascript:moveallsel(this.document.forms[0].BankListSrc,this.document.forms[0].BankListDst);"><img src="images/arrow_rightall.gif" width="24" height="22" border="0"></a>
                                  </div>
                                  </td>
                                </tr>
                                <tr> 
                                  <td>
                                  <div align="center">                                  
                                  <a href="javascript:movesel(this.document.forms[0].BankListDst,this.document.forms[0].BankListSrc);"><img src="images/arrow_left.gif" width="24" height="22" border="0"></a>
                                  </div>
                                  </td>
                                </tr>
                                <tr> 
                                  <td height="22">
                                  <div align="center">                                  
                                  <a href="javascript:moveallsel(this.document.forms[0].BankListDst,this.document.forms[0].BankListSrc);"><img src="images/arrow_leftall.gif" width="24" height="22" border="0"></a>
                                  </div>
                                  </td>
                                </tr>
                               </table></td>
                               <td width="189"> 
                              <select multiple size=10  name="BankListDst" ondblclick="javascript:movesel(this.document.forms[0].BankListDst,this.document.forms[0].BankListSrc);" style="width: 17em">							
							 </select>
                          </tr>
                        </table></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
         </tr>  
      </table>
    </td>
  </tr>
</table>
<INPUT type="hidden" name=BankList><!--//BankList儲存已勾選的金融機構代碼-->
<INPUT type="hidden" name=btnFieldList value='<%if(session.getAttribute("btnFieldList") != null) out.print((String)session.getAttribute("btnFieldList"));%>'><!--//btnFieldList儲存已勾選的報表欄位名稱-->
</form>
<script language="JavaScript" >
<!--

<%
//從session裡把勾選的金融機構代碼讀出來.放在BankListDst
if(session.getAttribute("BankList") != null && !((String)session.getAttribute("BankList")).equals("")){ 
   System.out.println("FR036WW_BankList.BankList="+(String)session.getAttribute("BankList"));
%>
var bnlist;
bnlist = '<%=(String)session.getAttribute("BankList")%>';
var a = bnlist.split(',');
for (var i =0; i < a.length; i ++){
	var j = a[i].split('+');
	this.document.forms[0].BankListDst.options[i] = new Option(j[1], j[0]);
}
<%}%>

setSelect(this.document.forms[0].HSIEN_ID,"<%=hsien_id%>");

changeCity('CityXML', this.document.forms[0].HSIEN_ID, this.document.forms[0].S_YEAR, this.document.forms[0]);
changeOption(this.document.forms[0],'');
function clearBankList(){
 <%
	session.setAttribute("BankList",null);//清除已勾選的BankList
 %>
}
-->
</script>

</body>
</html>

<%
//97.09.05 create 信用部防制洗錢歷次函報情形明細表 by 2295
//99.05.26 fix 套用共用權限 Header.include & 縣市合併挑選 by 2808
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>
<%! private final String report_no = "MC005W" ; 
	//取得所有總機構資料
	private List getTatolBankType(){
			//查詢條件
			//String sqlCmd = " Select HSIEN_id, BN01.BANK_NO , BANK_NAME, BANK_TYPE  from  BN01, WLX01  WHERE BN01.BANK_NO = WLX01.BANK_NO(+) AND bank_type in ( select cmuse_id from cdshareno where cmuse_div = '020' ) order by BANK_NO ";
			//fix 增加縣市合併判斷用m_year by 2808
			StringBuffer sql = new StringBuffer() ;
			sql.append(" select bn01.bn_type,HSIEN_id, BN01.BANK_NO , BANK_NAME, BANK_TYPE,bn01.m_year  ");
			sql.append(" from  BN01, WLX01 ");
			sql.append(" where BN01.BANK_NO = WLX01.BANK_NO(+) ");
			sql.append(" and wlx01.m_year = bn01.m_year ");    		
			sql.append(" order by BANK_NO  ");  
	        List dbData = DBManager.QueryDB_SQLParam(sql.toString(),null,"m_year");
	        return dbData;
	}
%>
<%	
   	String bankType = ( request.getParameter("bankType")==null ) ? "" : (String)request.getParameter("bankType");   	
    String cityType = request.getParameter("cityType" )== null ? "" : (String)request.getParameter("cityType");
    String tbank = "";
    String YEAR  = Utility.getYear();
   	String MONTH = Utility.getMonth();
 	
   	List tBankList = this.getTatolBankType();//Utility.getBankList(request);//this.getTatolBankType();
    // XML Ducument for 總機構代碼 begin
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"TBankXML\">");
    out.println("<datalist>");
    for(int i=0;i< tBankList.size(); i++) {
        DataObject bean =(DataObject)tBankList.get(i);
        out.println("<data>");
        out.println("<bankType>"+bean.getValue("bank_type")+"</bankType>");
        out.println("<bankCity>"+bean.getValue("hsien_id")+"</bankCity>");
        out.println("<bankValue>"+bean.getValue("bank_no")+"</bankValue>");
        out.println("<bankName>"+bean.getValue("bank_no")+"  "+bean.getValue("bank_name")+"</bankName>");
        out.println("<m_year>"+bean.getValue("m_year").toString()+"</m_year>") ;
        out.println("</data>");
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 總機構代碼 end 
    List cityList = Utility.getCity();
	if(cityList!=null) {
		// XML Ducument for 縣市別 begin
	    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"CityXML\">");
	    out.println("<datalist>");
	    for(int i=0;i< cityList.size(); i++) {
	    	DataObject bean =(DataObject)cityList.get(i);
	        out.println("<data>");
	        out.println("<cityType>"+bean.getValue("hsien_id")+"</cityType>");
	        out.println("<cityName>"+bean.getValue("hsien_name")+"</cityName>");
	        out.println("<cityValue>"+bean.getValue("hsien_id")+"</cityValue>");
	        out.println("<cityYear>"+bean.getValue("m_year").toString()+"</cityYear>");
	        out.println("</data>");
	    }
	    out.println("</datalist>\n</xml>");
	    // XML Ducument for 縣市別 end
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



function setSelect(S1, bankid) {
    if(S1 == null)
    	return;
    for(i=0;i<S1.length;i++) {
      	if(S1.options[i].value==bankid)    	{
        	S1.options[i].selected=true;
        	break;
    	}
    }
}


function doSubmit(){   
  if(confirm("本項報表會報行10-15秒，是否確定執行？"))
  {
        this.document.forms[0].action = "/pages/MC005W_Excel.jsp";	
        this.document.forms[0].target = '_self';
        this.document.forms[0].submit();   
  } 
}
//組縣市別============
function changeCity(xml) {
	var myXML,nodeValue, nodeName,nodeYear;
	var citySeld = form.cityType.value; //已選擇的
	//1.取得畫面年分 
	var begY = form.S_YEAR.value=='' ? 0 : eval(form.S_YEAR.value) ;
	Myear = '100' ;//預設年分100年
	if(begY<=99) {
		Myear = '99' ;
	}
	//2.讀cityXml
	myXML = document.all(xml).XMLDocument;
	nodeValue = myXML.getElementsByTagName("cityValue");
	nodeName = myXML.getElementsByTagName("cityName");
	nodeYear = myXML.getElementsByTagName("cityYear");
	//3.移除已搬入的資料
	var target = document.getElementById("cityType");
	target.length = 0;
	
	var oOption = document.createElement("OPTION");
	oOption.text="全部";
	oOption.value="";
	target.add(oOption);
	
	//4.判斷縣市年分組選單
	for(var i=0;i<nodeName.length ;i++)	{
		if(nodeYear.item(i).firstChild.nodeValue==Myear) {
			oOption = document.createElement("OPTION");
       	 	oOption.text=nodeName.item(i).firstChild.nodeValue;
	        oOption.value=nodeValue.item(i).firstChild.nodeValue;  
	        target.add(oOption);
		}
	}
	setSelect(form.cityType,citySeld);
}
//組金融機構畫面
function changeTbank(xml) {
	var myXML,nodeValue, nodeName,nodeYear,nodeType,nodeCity;
	//1.取得畫面年分 
	var begY = form.S_YEAR.value=='' ? 0 : eval(form.S_YEAR.value) ;
	Myear = '100' ;//預設年分100年
	if(begY<=99) {
		Myear = '99' ;
	}
	//2.讀cityXml
	myXML = document.all(xml).XMLDocument;
	nodeValue = myXML.getElementsByTagName("bankValue");
	nodeName = myXML.getElementsByTagName("bankName");
	nodeYear = myXML.getElementsByTagName("m_year");
	nodeType = myXML.getElementsByTagName("bankType") ;
	nodeCity = myXML.getElementsByTagName("bankCity") ;
	//3.取得 城市代號
	citycode = form.cityType.value ;
	//4.取得金融機構類別
	bankType = form.bankType.value ;
	//5.移除已搬入的資料
	var target = document.getElementById("tbank");
	target.length = 0;
	
	var oOption = document.createElement("OPTION");
	oOption.text="全部";
	oOption.value="";
	target.add(oOption);
	
	for(var i=0;i<nodeName.length ;i++)	{
		if((citycode==''||nodeCity.item(i).firstChild.nodeValue== citycode) 
				&& nodeYear.item(i).firstChild.nodeValue==Myear
				&& nodeType.item(i).firstChild.nodeValue==bankType) {
			oOption = document.createElement("OPTION");
       	 	oOption.text=nodeName.item(i).firstChild.nodeValue;
	        oOption.value=nodeValue.item(i).firstChild.nodeValue;  
	        target.add(oOption);
		}
	}
}

//受處年分改變==========
function chnageYear() {
	//1.修改縣市別
	changeCity("CityXML") ;
	//2.修改金融機構
	changeTbank("TBankXML");
}
//-->
</script>
<link href="css/b51.css" rel="stylesheet" type="text/css">
</head>

<body leftmargin="0" topmargin="0">
<Form name='form' method=post action='MC005W.jsp'>
<input type='hidden' name="begDate" value=''>
<input type='hidden' name="endDate" value=''>
<table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr> 
     <td>&nbsp;</td>
  </tr>
  <tr> 
    <td bgcolor="#FFFFFF">
	<table width="600" border="0" align="center" cellpadding="1" cellspacing="1">        
        <tr> 
          <td><table width="600" border="0" align="center" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="100"><img src="images/banner_bg1.gif" width="100" height="17"></td>
                <td width="*"><font color='#000000' size=4> 
                  <center>
                    <font color="#336600">農漁會信用部防制洗錢歷次函報情形明細表</font>
                  </center>
                  </font> </td>
                <td width="100"><img src="images/banner_bg1.gif" width="100" height="17"></td>
              </tr>
            </table></td>
        </tr>
        <tr> 
          <td><img src="images/space_1.gif" width="8" height="8"></td>
        </tr>
        <tr> 
          <td><table width="600" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#5DA525">
              <tr> 
                <td bordercolor="#E9F4E3" bgcolor="#E9F4E3"><table width="600" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#E9F4E3">
                    
                    <tr> 
                      <td bgcolor="#B0D595" class="sbody"> <div align="right">                          
                      	  <input type='radio' name="act" value='download' checked>下載報表  
                      	  <%if(Utility.getPermission(request,report_no,"P")){//Print %>                     	        	                                   		     			                               
                      	  <a href="javascript:doSubmit()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image411','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif" name="Image411" width="66" height="25" border="0" id="Image41"></a> 
                      	  <%}%>
                          <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image511','','images/bt_cancelb.gif',0)"><img src="images/bt_cancel.gif" name="Image511" width="66" height="25" border="0" id="Image51"></a> 
                          <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image611','','images/bt_reporthelpb.gif',1)"><img src="images/bt_reporthelp.gif" name="Image611" width="80" height="25" border="0" id="Image61"></a> 
                        </div></td>
                    </tr>  
                    <tr class="sbody">
                          <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">查詢年月 :</span> 						  						
                             <input type='text' name='S_YEAR' value="<%=YEAR%>" size='3' maxlength='3' 
									onblur='CheckYear(this)'
									onchange="chnageYear();">
								<font color='#000000'>年                            
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
                            </td>
                    </tr>                      
                    <tr class='sbody'>
						<td>
							<img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">金融機構類別 :</span>                                
                       		 <select size="1" name="bankType" onChange="changeTbank('TBankXML');">
     						  <option value="6">農會</option>
     						  <option value="7">漁會</option>
  							 </select>
                       </td>
                    </tr> 
                    
                    <tr class='sbody'>
						<td>
							<img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">縣市別 :</span>                                
                       		 <select size="1" name="cityType" onChange='changeTbank("TBankXML");'>
  							 </select>
                       </td>
                    </tr> 
                           
                    <tr class='sbody'>
						<td>
							<img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">機構名稱 :</span>                                
                       		<select size="1" name="tbank" >
    						 
  							</select>
                       </td>
                    </tr>
                    <tr class="sbody">
					  <td><img src="images/2_icon_01.gif" width="16" height="16" align="absmiddle"><span class="mtext">輸出格式 :</span>
						  <input name='printStyle' type='radio' value='xls' checked>Excel
						  <input name='printStyle' type='radio' value='ods' >ODS
						  <input name='printStyle' type='radio' value='pdf' >PDF
					  </td>
					</tr>  
                    <tr> 
                      <td bgcolor="#E9F4E3"><div align="center">
                          <table width="555" border="0" cellpadding="1" cellspacing="1">
                            <tr> 
                              <td width="34"><img src="images/print_1.gif" width="34" height="34"></td>
                              <td width="222"><font color="#CC6600">本報表採用A4紙張橫印</font></td>                              
                            </tr>                            
                          </table>
                        </div></td>
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
</form>

</body>
<script language="JavaScript" >
<!--
setSelect(form.bankType,"<%=bankType%>");
setSelect(form.tbank,"<%=tbank%>");
setSelect(form.cityType,"<%=cityType%>");
changeCity("CityXML") ;
changeTbank("TBankXML");
-->
</script>
</html>

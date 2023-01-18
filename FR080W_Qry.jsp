<%
//107.05.18 create 洗錢關鍵字報表-依縣市別 by 6417
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.*" %>
<%@include file="./include/bank_no_hsien_id.include" %>
<%
    // 查詢條件值
    Map dataMap = Utility.saveSearchParameter(request);
    String report_no = "FR0080W";
    showCancel_No = false;//顯示營運中/裁撤別
    showBankType = true;//顯示金融機構類別
    showCityType = true;//顯示縣市別
    showPageSetting = true;//顯示本報表採用A4紙張直印/橫印
    setLandscape = false;//true:橫印
    String act = Utility.getTrimString(dataMap.get("act"));
    String bankType = Utility.getTrimString(dataMap.get("bankType"));
    String tbank = Utility.getTrimString(dataMap.get("tbank"));
    String cityType = Utility.getTrimString(dataMap.get("cityType"));
    String title = ((bankType.equals("6")) ? "農會" : "漁會");
    System.out.println(report_no + "_Qry.act=" + act);
    System.out.println("cityType=" + cityType);
%>

<HTML>
<HEAD>
    <TITLE>洗錢關鍵字報表-縣市別</TITLE>
    <style type="text/css">
        .keyword {
            text-align: right;
            width: 300px;
        }
    </style>
    <script language="javascript" src="js/HsienIDUtil.js"></script><!-- 根據查詢年月.挑選縣市別/總機構單位-->
    <link href="css/b51.css" rel="stylesheet" type="text/css">
        <%
  String nameColor="nameColor_sbody";
  String textColor="textColor_sbody";
  String bordercolor="#76C657";
%>
<BODY bgColor=#FFFFFF>
<Form name='form' method=post action='#'>
    <input type='hidden' name="act" value=''>
    <input type='hidden' name="rtf_bank_type" value=''>
    <input type="hidden" name="wordaction" value='download'>
    <input type='hidden' name="showTbank" value='true'>
    <input type='hidden' name="showCityType" value='<%=showCityType%>'>
    <input type='hidden' name="showCancel_No" value='<%=showCancel_No%>'>
    <input type='hidden' name="bankType" value='<%=bankType%>'>
    <input type='hidden' name="tbank" value='<%=tbank%>'>

    <table width='600' border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
            <td width="50%"><font color='#000000' size=4><b>
                <center>洗錢關鍵字報表-縣市別</center>
            </b></font></td>
            <td width="25%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
        </tr>
    </table>
    <table border=1 width='600' align=center height="65" bgcolor="#FFFFF" bordercolor="<%=bordercolor%>">
        <tr class="sbody">
            <td colspan="2" height="1" class="<%=nameColor%>">
                <div align="right">
                    <input type='radio' name="excelaction" value='download' checked> 下載報表
                    <a href="javascript:doSubmit('createRpt')" onMouseOut="MM_swapImgRestore()"
                       onMouseOver="MM_swapImage('Image411','','images/bt_execb.gif',1)"><img src="images/bt_exec.gif"
                                                                                              name="Image411" width="66"
                                                                                              height="25" border="0"
                                                                                              id="Image41"></a>
                    <a href="#" onMouseOut="MM_swapImgRestore()"
                       onMouseOver="MM_swapImage('Image511','','images/bt_cancelb.gif',0)"><img
                            src="images/bt_cancel.gif" name="Image511" width="66" height="25" border="0"
                            id="Image51"></a>
                    <a href="#" onMouseOut="MM_swapImgRestore()"
                       onMouseOver="MM_swapImage('Image611','','images/bt_reporthelpb.gif',1)"><img
                            src="images/bt_reporthelp.gif" name="Image611" width="80" height="25" border="0"
                            id="Image61"></a>
                </div>
            </td>
        </tr>
        <tr class="sbody">
            <td width="118" bgcolor="#BDDE9C" height="1">查詢日期</td>
            <td width="416" bgcolor="#EBF4E1" height="1">
                <input type="text" name="S_YEAR" size="3" maxlength="3" value="<%=YEAR%>"
                    <%if(showCityType) {%>
                       onChange="changeCity('CityXML', form.cityType, form.S_YEAR, form)"
                    <%} %>
                >
                年
                <select id="hide1" name=S_MONTH>
                    <%
                        for (int j = 1; j <= 12; j++) {
                            if (j < 10) {%>
                    <option value=0<%=j%> <%
                        if (String.valueOf(Integer.parseInt(MONTH)).equals(String.valueOf(j))) out.print("selected");%>>
                        0<%=j%>
                    </option>
                    <%} else {%>
                    <option value=<%=j%> <%if (String.valueOf(Integer.parseInt(MONTH)).equals(String.valueOf(j)))
                        out.print("selected");
                    %>><%=j%>
                    </option>
                    <%}%>
                    <%}%>
                </select><font color='#000000'>月</font>
                <span style="color: red;">至</span>
                <input type="text" name="E_YEAR" size="3" maxlength="3" value="<%=YEAR%>"
                    <%if(showCityType) {%>
                       onChange="changeCity('CityXML', form.cityType, form.S_YEAR, form)"
                    <%} %>
                >
                年
                <select id="hide1" name=E_MONTH>
                    <%
                        for (int j = 1; j <= 12; j++) {
                            if (j < 10) {%>
                    <option value=0<%=j%> <%
                        if (String.valueOf(Integer.parseInt(MONTH)).equals(String.valueOf(j))) out.print("selected");%>>
                        0<%=j%>
                    </option>
                    <%} else {%>
                    <option value=<%=j%> <%if (String.valueOf(Integer.parseInt(MONTH)).equals(String.valueOf(j)))
                        out.print("selected");
                    %>><%=j%>
                    </option>
                    <%}%>
                    <%}%>
                </select><font color='#000000'>月</font>
            </td>
            </td>

        </tr>

        <tr class="sbody">
            <td width="118" bgcolor="#BDDE9C" height="1">縣市別</td>
            <td width="416" bgcolor="#EBF4E1" height="1">
                <select size="1" name="cityType" onChange="changeTbank('TBankXML', form.tbank, form.cityType, form)">
                </select>
                &nbsp;&nbsp;&nbsp;&nbsp;
            </td>
        </tr>
        <tr class="sbody">
            <td width="118" bgcolor="#BDDE9C" height="1">洗錢關鍵字</td>
            <td id="extraArea" bgcolor="#EBF4E1" height="1">
                <input type="text" class="keyword" name="extraKeyword"  value="資恐"></input>
                <input type="text" class="keyword" name="extraKeyword"  value="資助恐怖分子"></input>
                <input type="text" class="keyword" name="extraKeyword"  value="洗錢"></input>
                <input type="text" class="keyword" name="extraKeyword"  value="防制洗錢"></input>
                <input type="text" class="keyword" name="extraKeyword"  value="洗錢防制"></input>
                <input type="text" class="keyword" name="extraKeyword"  value="疑似洗錢"></input>
                <input type="text" class="keyword" name="extraKeyword"  value="一定金額"></input>
                <input type="text" class="keyword" name="extraKeyword"  value="大額通貨交易"></input>
                <input type="text" class="keyword" name="extraKeyword"  value="可疑交易"></input>
                <input type="text" class="keyword" name="extraKeyword"  value="認識客戶"></input>
                <input type="text" class="keyword" name="extraKeyword"  value="確認客戶身分"></input>
                <input type="text" class="keyword" name="extraKeyword"  value="關懷客戶"></input>
                <br>
                <button onclick="clearKeywords() ">清除關鍵字</button>

            </td>
        </tr>
        <tr class="sbody">
            <td width="118" bgcolor="#BDDE9C" height="1">其他關鍵字</td>
            <td id="otherArea" width="416" bgcolor="#EBF4E1" height="1">
                <input type="text" class="keyword" name="extraKeyword" value=""></input>
                <button style=" margin-right:5px;  font-size: 15px ;width: 25px;" onclick="addOtherKeywordArea()">＋
                </button>
            </td>
        </tr>
        <%@include file="./include/rpt_style.include" %><!--報表格式挑選-->
        <table border="1" width="600" align="center" height="54" bgcolor="#FFFFF" bordercolor="<%=bordercolor%>">
            <tr>
                <td class="<%=nameColor%>" colspan="2">
                    <div align="center">
                        <table width="574" border="0" cellpadding="1" cellspacing="1">
                            <tr>
                                <td width="34"><img src="/pages/images/print_1.gif" width="34" height="34"></td>
                                <td width="492"><font color="#CC6600">本報表採用A4紙張橫印</font></td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
        </table>
    </table>
</form>
</BODY>
<script language="JavaScript">

    function clearKeywords() {
        var el = document.getElementById("extraArea").childNodes;
        for (var i = 0; i < el.length; i++) {
            if (el[i].name == "extraKeyword") {
                el[i].value = "";
            }
        }
    }

    function addOtherKeywordArea() {
        var otherArea = document.getElementById("otherArea");
        otherArea.innerHTML += "<div><input type='text' class='keyword' name='extraKeyword'  value=''></input><button style=' margin-right:5px;  font-size: 15px ;width: 25px;' onclick='addOtherKeywordArea()'>＋</button><button style='font-size: 15px ;width: 25px;' onclick='clearOtherKeywordArea(this)'>－</button></div>";
    }

    function clearOtherKeywordArea(element) {
        var parent = element.parentNode
        parent.parentNode.removeChild(parent);
    }

    function doSubmit() {
    	var sYear = this.document.forms[0].elements["S_YEAR"].value;
    	var eYear = this.document.forms[0].elements["E_YEAR"].value;

   		if(sYear == ""){
   			alert("請輸入起始查詢年度");
   		}else if(eYear == ""){
   			alert("請輸入結束查詢年度");
   		}else if(!this.checkDate()){
   			alert("起始日不得大於結束日");
   		}else if(!checkKeywordEmpty()){
   			alert("關鍵字至少需輸入一個");
   		}else if (confirm("本項報表會報行10-15秒，是否確定執行？")) {
   		
            this.document.forms[0].action = "/pages/FR080W_Excel.jsp?act=download";
            this.document.forms[0].target = '_self';
            this.document.forms[0].submit();
        }
    }
	function checkDate(){
    	var sYear = this.document.forms[0].elements["S_YEAR"].value;
    	var eYear = this.document.forms[0].elements["E_YEAR"].value;
    	var sMonth = this.document.forms[0].elements["S_MONTH"].value;
    	var eMonth  = this.document.forms[0].elements["E_MONTH"].value;
    	
    	if(parseInt(sYear) > parseInt(eYear)) {
    		return false;
    	}else if(parseInt(sYear) == parseInt(eYear)&& parseInt(sMonth) > parseInt(eMonth)){
    		return false;
    	}
    	return true;
	}
	
	function checkKeywordEmpty(){
    	var keywords = this.document.getElementsByName("extraKeyword");
    	var result = false;
    	for (var index = 0; index < keywords.length; index++) {
			if("" != keywords[index].value){
				result = true;
				break;
			}
		}
    	return result;
	}
    changeCity('CityXML', form.cityType, form.S_YEAR, form);
    changeTbank('TBankXML', form.tbank, form.cityType, form);

</script>
</HTML>
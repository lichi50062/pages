<%
//106.11.22 add 機構代碼轉換日期;原轉換日期調整為MIS系統轉換日期 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%
String report_no = "AS003W";


String listTitle="listTitleColor_sbody"; 
String list1Color="list1Color_sbody";
String list2Color="list2Color_sbody";
String listColor="list1Color_sbody";
     
String nameColor="nameColor_sbody";
String textColor="textColor_sbody";
String bordercolor="#3A9D99";
HashMap <String , String > h = new HashMap<String , String>();
List detailList3 = (List)request.getAttribute("detailList3");
for(int k=0 ; k < detailList3.size() ; k ++ ){
   DataObject detail3 =(DataObject)detailList3.get(k);
   //out.println("trans_type="+Utility.getTrimString(detail3.getValue("trans_type")) ) ;
   //out.println("cnt ="+Utility.getTrimString(detail3.getValue("cnt")) ) ;
   h.put(Utility.getTrimString(detail3.getValue("trans_type")) 
		   , Utility.getTrimString(detail3.getValue("cnt")) ) ;
}
%>

<html>
	<head>
	<title>配賦代號轉換作業</title>
	<script language="javascript" src="js/Common.js"></script>
	<script language="javascript" src="js/PopupCal.js"></script>
	<script language="javascript" src="js/json2.js"></script>
	<script language="javascript" src="js/AS003W.js"></script>
	
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
	<script>
	function showCase(id){
		//alert(id);
		var e = document.getElementsByName(id);
		//alert("object .length="+e.length);
		for(var i=0;i<e.length;i++){
			if(e[i].style.display == 'block'){
				e[i].style.display = 'none';
			}else{
				e[i].style.display = 'block';
			}
			
		}
	}
	</script> 
	</head>
	<body bgColor=#FFFFFF>
		<form name='form' method=post action='/pages/AS003W.jsp'>
		<input type='hidden' name="act" value=''/>
		
		<tr><td>
		<table width="80%" border="0" align="center" cellpadding="0" cellspacing="0" >
     	<tr> 
           <td width="35%"><img src="images/banner_bg1.gif" width="100%" height="17"></td>
           <td width="30%"><font color='#000000' size=4><b><center>配賦代號轉換作業</center></b></font> </td>
           <td width="35%"><img src="images/banner_bg1.gif" width="113%" height="17"></td>
         </tr>
         </table>
         <table width="80%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
		 <tr>  
		    <div align="right">
		      <jsp:include page="getLoginUser.jsp" flush="true" />
		    </div> 
		 </tr> 
		 </table>
	
		<table border=1 width='80%' align=center height="65" class="bordercolor" >
		<tr class="sbody">
			<td colspan='3' height="1" class="<%=nameColor%>"><center>轉換代碼明細</center></td>
			
  		</tr>
  		<tr class='sbody'>
			<td width='30%' class="<%=nameColor%>" >單位名稱</td>
			<td width='35%' class="<%=textColor%>">變更前</td>
			<td width='35%' class="<%=textColor%>">變更後</td>
		</tr>
		
		<%List detailList1 = (List)request.getAttribute("detailList1");		%>
		<%String trans_date = "&nbsp;" ;
		  String online_date = "&nbsp;" ;
		//同一批資料會一起轉換，所以時間都相同  
		if(detailList1!=null && detailList1.size() >0 ) {
			  DataObject bean = (DataObject)detailList1.get(0) ;
			  trans_date = Utility.getTrimString(bean.getValue("trans_date")) ;
			  online_date = Utility.getCHTdate(Utility.getTrimString(bean.getValue("online_date")),0);
		  }
		%>
		<%for(int i=0;i< detailList1.size(); i++) {  %>
		<%    DataObject bean =(DataObject)detailList1.get(i); %>
		<tr>
			<td width='30%' class="<%=nameColor%>" ><%=Utility.getTrimString(bean.getValue("bank_name")) %></td>
			<td width='35%' class="<%=textColor%>"><%=Utility.getTrimString(bean.getValue("src_bank_no")) %></td>
			<td width='35%' class="<%=textColor%>"><%=Utility.getTrimString(bean.getValue("bank_no")) %></td>
		</tr>
		
		
		<%} %>
		<tr class='sbody'>
		<td width='30%' class="<%=nameColor%>">機構代號轉換日期</td>
		<td colspan='2' class="<%=textColor%>"><%=online_date%></td>
		</tr>
		<tr class='sbody'>
		<td width='30%' class="<%=nameColor%>">MIS系統轉換日期及時間</td>
		<td colspan='2' class="<%=textColor%>"><%=trans_date%></td>
		</tr>
		<tr class="sbody">
			<td align='center' colspan='3' height="1" class="<%=nameColor%>" ><center>轉換明細資料</center></td>
		</tr>
  		<%List detailList2 = (List)request.getAttribute("detailList2");		%>
		<%for(int i=0;i< detailList2.size(); i++) {  %>
		<%    DataObject bean =(DataObject)detailList2.get(i); %>
		<%    String trans_Type = Utility.getTrimString(bean.getValue("trans_type")); %>
		<%    boolean linkFlg = "1".equals(h.get(trans_Type))?false : true ; %>
		
		<% //大項顯示
		     if("0".equals(Utility.getTrimString(bean.getValue("sub_item")))){ %>
		<tr>
			<td width='30%' class="<%=nameColor%>" ><%=Utility.getTrimString(bean.getValue("item_name")) %></td>
			<td colspan='2' class="<%=textColor%>">
				<%if(linkFlg) {%>
				<a href="javascript:showCase('<%=trans_Type%>')">
					<%=Utility.getTrimString(bean.getValue("trans_cnt")).concat("筆") %>
				</a>
				<%} else { %>
					<%=Utility.getTrimString(bean.getValue("trans_cnt")).concat("筆") %>
				<%} %>
		</tr>
		<%  } else {%>
		<%//細項資料 %>
		<tr class="sbody" id='<%=trans_Type%>' name='<%=trans_Type%>' style="display:'none'">
			<td width='30%' class="<%=nameColor%>" >&nbsp;&nbsp;</td>
			<td colspan='2' class="<%=textColor%>">
			<%=Utility.getTrimString(bean.getValue("item_name")).concat("(")
							.concat(Utility.getTrimString(bean.getValue("fun_id"))).concat("):")
							.concat(Utility.getTrimString(bean.getValue("trans_cnt"))).concat("筆")
					%>
			</td>
		</tr>
		<%} %>
		<%} %>
		
		</table>
		</td></tr>
		

		<%//登入者資訊 %>
		<tr>                  
            <td>
            <div align="right"><jsp:include page="getMaintainUser.jsp?width=80%" flush="true" /></div>
           	</td>                                              
        </tr>
		<tr> 
            <td><div align="center"> 
                <table width="243" border="0" cellpadding="1" cellspacing="1">
                  <tr>                             
           			
                    <td width="80"><div align="center"><a href="javascript:history.back();"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image105" width="80" height="25" border="0" id="Image105"></a></div></td>
                  </tr>
                  </tr>
                </table>
            </div></td>
      </tr> 
		
	</body>

</html>
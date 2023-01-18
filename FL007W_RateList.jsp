<%
//105.10.25 create by 2968
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>


<%
	Map dataMap =Utility.saveSearchParameter(request);
	String act = Utility.getTrimString(dataMap.get("act")) ;
	System.out.println("Page: FL007W_RateList.jsp");
    List rs = (List)request.getAttribute("RateList");
    String item_name=Utility.getTrimString(dataMap.get("item_Name"));
%>

<HTML>
<HEAD>
<TITLE>收回補貼息案件農業金庫來文維護作業</TITLE>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/PopupCal.js"></script>
<script language="javascript" src="js/FL007W.js"></script>
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
<Form name='form' method=post action='/pages/FL007W.jsp'>
<input type='hidden' name="act" value=''>



<Table border=1 width='90%' align=center height="65" bgcolor="#FFFFF" bordercolor="#76C657">
<tr class="sbody" >
       <td width="20%" bgcolor="#BDDE9C" height="1">貸款種類名稱</td>
       <td bgcolor="#EBF4E1" height="1"><%=item_name %>
       </td>
</tr>  
</Table>
	<Table>
		<tr class="sbody" >
		       <td>&nbsp;</td>
		</tr>  
	</Table>

	<Table border="1" width="90%" align='center' bgcolor="#FFFFF" bordercolor="#76C657">
    <tr class="sbody" bgcolor="#BFDFAE">
    	<td width="8%" >序號</td>
    	<td width="30%" >貸款子目別</td>
        <td width="15%" >實施日期</td>        
      	<td width="10%" >貸款利率</td>
      	<td width="10%" >補貼基準</td>
      	<td width="27%" >農業金庫基準利率加一成利率</td>
    </tr>
    <%
	if(rs != null && rs.size() > 0) {
      	System.out.println("Query Result Data Size= "+rs.size());
      	String lSItem = "";
      	String style = "";
      	String color = "#EBF4E1";
      	String trId = "";
      	for(int i=0; i<rs.size(); i++) {
			DataObject bean =(DataObject)rs.get(i);
			color = "#EBF4E1";
			style = "";
			trId = "";
			String subitem = bean.getValue("subitem") != null ? "<a href=javascript:showCase('item_"+bean.getValue("subitem")+"') >"+(String)bean.getValue("subitem")+"</a>" : "&nbsp;";
			String subitem_name = bean.getValue("subitem_name") != null ? (String)bean.getValue("subitem_name") : "&nbsp;";
			if(lSItem.equals(bean.getValue("subitem"))){
				color = "#FFFFCC";
				subitem = "&nbsp;";
				subitem_name = "&nbsp;";
				style = "none";
				trId = "item_"+ bean.getValue("subitem");
			}
			lSItem = (String)bean.getValue("subitem");
			
    %>      
		    <tr class="sbody" bgcolor="<%=color%>" id='<%=trId%>' name='<%=trId%>' style="display:<%=style%>">
		      <td><%=subitem %></td>
		      <td><%=subitem_name %></td>
		      <td><%=bean.getValue("start_date") != null ? bean.getValue("start_date") : "&nbsp;"%></td>
		      <td><%=bean.getValue("loan_rate") != null ? bean.getValue("loan_rate").toString()+"%" : "&nbsp;"%></td>
		      <td><%=bean.getValue("base_rate") != null ? bean.getValue("base_rate").toString()+"%" : "&nbsp;"%></td>
		      <td><%=bean.getValue("agbase_rate") != null ? bean.getValue("agbase_rate").toString()+"%" : "&nbsp;"%></td>
		    </tr>
    <%  
    		
		}
	}else{%>            
    <tr bgcolor="#EBF4E1" class="sbody">
       <td width="100%" colspan='9' align='center'><font color="#FF0000">查無符合資料</font></td>
    </tr>
  <%}%>        
  </Table>

</form>
</BODY>
<script language="JavaScript" >
<!--
-->
</script>

</HTML>

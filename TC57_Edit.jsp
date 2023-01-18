<%
//95.11.24 create by 2495
//95.12.08 add根據所選的金融機構類別及縣市別顯示總機構單位及受檢單位 by 2295
//95.12.15 完成檢查追蹤管理維護作業 by 2295
//95.12.18 全國農業金庫.農漁會共用中心.縣市別以"-"代替 by 2295
//95.01.02 fix 若為Copy時,不變更員工代碼,顯示複製的員工代碼 by 2295
//99.06.02 fix sql injection by 2808
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>

<%
	
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");				
	String bank_no = ( request.getParameter("bank_no")==null ) ? "" : (String)request.getParameter("bank_no");		
	String subdep_id = ( request.getParameter("subdep_id")==null ) ? "" : (String)request.getParameter("subdep_id");
	String muser_id = ( request.getParameter("muser_id")==null ) ? "" : (String)request.getParameter("muser_id");	
	
	System.out.println("TC57_Edit.act="+act);
	System.out.println("TC57_Edit.bank_no="+bank_no);
	System.out.println("TC57_Edit.subdep_id="+subdep_id);
	System.out.println("TC57_Edit.act="+act);
	
	String sqlCmd="";
	String title="檢查追蹤管理系統權限";			
	title =(act.equals("Edit"))?title+"異動維護":title;
	title =(act.equals("new"))?title+"新增維護":title;
	Calendar now = Calendar.getInstance();
   	String YEAR  = String.valueOf(now.get(Calendar.YEAR)-1911);
   	String u_year = "99" ;
   	String cd01Table = "cd01_99" ;
   	if(Integer.parseInt(YEAR) > 99) {
   		u_year = "100" ;
   		cd01Table = "cd01" ;
   	}
   	
	//取得TC57的權限
	Properties permission = ( session.getAttribute("TC57")==null ) ? new Properties() : (Properties)session.getAttribute("TC57"); 
	if(permission == null){
       System.out.println("TC57_Edit.permission == null");
    }else{
       System.out.println("TC57_Edit.permission.size ="+permission.size());
               
    }
    
    List bank_type_data = DBManager.QueryDB_SQLParam("select cmuse_id,cmuse_name from cdshareno where cmuse_div='001' and cmuse_id in('1','6','7','8') order by input_order",null,"");                            							            
    // XML Ducument for 金融機構類別 begin
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"BankTypeXML\">");    
    out.println("<datalist>"); 	
    if(bank_type_data != null){
       for(int i=0;i< bank_type_data.size(); i++) {
           DataObject bean =(DataObject)bank_type_data.get(i);
           out.println("<data>");                              
           out.println("<BankType>"+bean.getValue("cmuse_id")+"</BankType>");           
           out.println("<BankName>"+bean.getValue("cmuse_name")+"</BankName>");
           out.println("</data>");           
       }       
    }    
    out.println("</datalist>\n</xml>");
    // XML Ducument for 金融機構類別 end 
    
    //95.12.08 add 縣市別代碼=======================================================================================    
    List hsien_id_data = DBManager.QueryDB_SQLParam("select distinct hsien_id,hsien_name from "+cd01Table,null,""); 
    // XML Ducument for 總縣市別代碼 begin
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"HsienIDXML\">");    
    out.println("<datalist>"); 		      
 	if(hsien_id_data != null){
       for(int i=0;i< hsien_id_data.size(); i++) {
           DataObject bean =(DataObject)hsien_id_data.get(i);
           out.println("<data>");                              
           out.println("<HsienId>"+bean.getValue("hsien_id")+"</HsienId>");           
           out.println("<HsienName>"+bean.getValue("hsien_id")+bean.getValue("hsien_name")+"</HsienName>");
           out.println("</data>");           
       }       
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 縣市別代碼 end 	                         
    
    //95.12.08 add 總機構代碼=======================================================================================
    StringBuffer sql = new StringBuffer() ;
    List paramList =new ArrayList() ;
    sql.append(" select bn01.bank_type,nvl(wlx01.hsien_id,'-') as hsien_id,bn01.bank_no,bn01.bank_name from (select * from bn01 where m_year=? )bn01 "
	       + " LEFT JOIN (select * from wlx01 where m_year=? )WLX01 on bn01.bank_no = WLX01.bank_no"
		   + " where bn01.bank_type in (?,?,?,?)"
		   + " and bn01.bn_type <> ? "
		   + " order by bn01.bank_type,hsien_id" );
    paramList.add(u_year) ;
    paramList.add(u_year) ;
    paramList.add("6") ;
    paramList.add("7") ;
    paramList.add("8") ;
    paramList.add("1") ;
    paramList.add("2") ;
    List tbankList = DBManager.QueryDB_SQLParam(sql.toString(),paramList,"hsien_id");	
    // XML Ducument for 總機構代碼 begin
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"TBankXML\">");    
    out.println("<datalist>"); 		      
 	if(tbankList != null){
       for(int i=0;i< tbankList.size(); i++) {
           DataObject bean =(DataObject)tbankList.get(i);
           out.println("<data>");                   
           out.println("<BankType>"+bean.getValue("bank_type")+"</BankType>");
           out.println("<HsienId>"+bean.getValue("hsien_id").toString()+"</HsienId>");
           out.println("<bankValue>"+bean.getValue("bank_no")+"</bankValue>");
           out.println("<bankName>"+bean.getValue("bank_no")+bean.getValue("bank_name")+"</bankName>");
           out.println("</data>");
           //System.out.println("<option>"+bean.getValue("bank_no")+"&nbsp;"+bean.getValue("bank_name")+"</option>");
       }       
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 總機構代碼 end 	
    //95.12.08 add 受檢單位=======================================================================================
    /*
    sqlCmd = " select ba01.bank_type,ba01.pbank_no,ba01.bank_no,ba01.bank_name from ba01"
		   + " left join bn01 on ba01.pbank_no = bn01.bank_no"
		   + " where ba01.bank_type in ('6','7','8','1') "
		   + " and bn01.bn_type <> '2' "
		   + " order by ba01.bank_type,ba01.pbank_no,ba01.bank_no";*/
    sql.setLength(0) ;
    paramList.clear() ;
	sql.append( " select ba01.bank_type,nvl(wlx012.hsien_id,'-') as hsien_id,ba01.pbank_no,ba01.bank_no,ba01.bank_name from (select * from ba01 where m_year=?) ba01 "
		   + " left join (select * from bn01 where m_year=? )bn01 on ba01.pbank_no = bn01.bank_no"
		   + " left join (select wlx01.bank_no,wlx01.hsien_id from wlx01 where m_year=? "
	  	   + "		      union"
		   + "			  select wlx02.bank_no,wlx02.hsien_id from wlx02 where m_year=? )  wlx012 on wlx012.bank_no = ba01.bank_no"
		   + " where ba01.bank_type in (?,?,?,?) "
		   + " and bn01.bn_type <> ? "  
		   + " order by ba01.bank_type,ba01.pbank_no,ba01.bank_no " );
	 paramList.add(u_year) ;
	 paramList.add(u_year) ;
	 paramList.add(u_year) ;
	 paramList.add(u_year) ;
	 paramList.add("6") ;
    paramList.add("7") ;
    paramList.add("8") ;
    paramList.add("1") ;
    paramList.add("2") ;
	// XML Ducument for 受檢單位 begin
	List bankList = DBManager.QueryDB_SQLParam(sql.toString(),paramList,"hsien_id");	
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"BankXML\">");    
    out.println("<datalist>"); 		      
 	if(bankList != null){
       for(int i=0;i< bankList.size(); i++) {
           DataObject bean =(DataObject)bankList.get(i);
           out.println("<data>");                   
           out.println("<BankType>"+bean.getValue("bank_type")+"</BankType>");
           //System.out.println(bean.getValue("bank_no")+bean.getValue("hsien_id").toString());
           out.println("<HsienId>"+bean.getValue("hsien_id").toString()+"</HsienId>");
           out.println("<PBankNo>"+bean.getValue("pbank_no")+"</PBankNo>");
           out.println("<bankValue>"+bean.getValue("bank_no")+"</bankValue>");
           out.println("<bankName>"+bean.getValue("bank_no")+bean.getValue("bank_name")+"</bankName>");
           out.println("</data>");
           //System.out.println("<option>"+bean.getValue("bank_no")+"&nbsp;"+bean.getValue("bank_name")+"</option>");
       }       
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 受檢單位 end 		       
    
    
    //員工代碼
    sql.setLength(0) ;
    paramList.clear() ;
    sql.append(" select bank_no,subdep_id,muser_id,muser_name from wtt01 " 
		   + " where bank_type =? "   		
		   + " and muser_id not in (select distinct muser_id from wtt08)"
		   + " order by muser_id " );
    paramList.add("2") ;
    List muser_id_data = DBManager.QueryDB_SQLParam(sql.toString(),paramList,""); 				  
	// XML Ducument for 員工代碼 begin
    out.println("<xml version=\"1.0\" encoding=\"UTF-8\" ID=\"MuserIDXML\">");    
    out.println("<datalist>"); 		      
 	if(muser_id_data != null){
       for(int i=0;i< muser_id_data.size(); i++) {
           DataObject bean =(DataObject)muser_id_data.get(i);
           out.println("<data>");                              
           out.println("<bank_no>"+bean.getValue("bank_no")+"</bank_no>");//組室代號           
           out.println("<subdep_id>"+bean.getValue("subdep_id")+"</subdep_id>");//科別代號
           out.println("<muser_id>"+bean.getValue("muser_id")+"</muser_id>");//員工代碼
           out.println("<muser_name>"+bean.getValue("muser_id")+bean.getValue("muser_name")+"</muser_name>");//代碼+名稱
           out.println("</data>");           
       }       
    }
    out.println("</datalist>\n</xml>");
    // XML Ducument for 員工代碼 end 			   
    
%>
<script language="javascript" src="js/Common.js"></script>
<script language="javascript" src="js/movesels.js"></script>
<script language="javascript" src="js/TC57.js"></script>
<script language="javascript" event="onresize" for="window"></script>
<html>
<head>
<title><%=title%></title>
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
</head>
<body marginwidth="0" marginheight="0" leftmargin="0" topmargin="0" leftmargin="0">
<form method=post action='#'>
<input type="hidden" name="act" value="">
<input type="hidden" name="BEF_EXPERT_ID" value=""> 
<table width="600" border="0" align="left" cellpadding="0" cellspacing="1" bgcolor="#FFFFFF">
  		<tr> 
   		 <td><img src="images/space_1.gif" width="12" height="12"></td>
  		</tr>
        <tr> 
          <td bgcolor="#FFFFFF">
			<table width="675" border="0" align="center" cellpadding="0" cellspacing="0">
			 <tr> 
                <td width="675"><table width="675" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td width="157"><img src="images/banner_bg1.gif" width="157" height="17"></td>
                      <td width="*"><font color='#000000' size=4><b> 
                        <center>
                          <%=title%> 
                        </center>
                        </b></font> </td>
                      <td width="157"><img src="images/banner_bg1.gif" width="157" height="17"></td>
                    </tr>
                  </table>
                </td>
              </tr>              
              <tr> 
                <td width="694"><img src="images/space_1.gif" width="12" height="12"></td>
              </tr>
              <tr> 
                <td width="694"><table width="560" border="0" align="center" cellpadding="0" cellspacing="0">
                    <tr> 
                      <div align="right"><jsp:include page="getLoginUser.jsp?width=674" flush="true" /></div> 
                    </tr>
                    <tr> 
                      <td><table width=674 border=1 align=center cellpadding="1" cellspacing="1" bordercolor="#76C657" height="440"> 
                    <tr class="sbody">
						<td width='96' align='left' bgcolor='#BDDE9C' height="24">組室代號</td>
						<td width='562' bgcolor='EBF4E1' height="24" colspan="2">
						    <% List bank_no_list = DBManager.QueryDB_SQLParam("select bank_no,bank_name from ba01 where bank_type='2' and bank_kind = '1' and pbank_no = 'BOAF000' order by bank_no",null,"");%>					  
							<select name='BANK_NO' <%if(act.equals("Edit")) out.print("disabled");%>>							    
					  			<%for(int i=0;i<bank_no_list.size();i++){%>
                            	<option value="<%=(String)((DataObject)bank_no_list.get(i)).getValue("bank_no")%>"
                            		<%if( ((DataObject)bank_no_list.get(i)).getValue("bank_no") != null &&  (bank_no.equals((String)((DataObject)bank_no_list.get(i)).getValue("bank_no")))) out.print("selected");%>
                            	>
                            	<%=(String)((DataObject)bank_no_list.get(i)).getValue("bank_name")%></option>                            
                            	<%}%>
                            </select>
                        </td>
                    </tr>
                    <tr class="sbody">
						<td width='96' align='left' bgcolor='#BDDE9C' height="24">科別代號</td>
						<td width='562' bgcolor='EBF4E1' height="24" colspan="2">							
                            <% List subdep_id_list = DBManager.QueryDB_SQLParam("select cmuse_id,cmuse_name from cdshareno where cmuse_div='010' order by input_order",null,"");%>
							<select name='SUBDEP_ID' onchange="javascript:changeOption_MuserID(this.document.forms[0],'<%=act%>');" <%if(act.equals("Edit")) out.print("disabled");%>>					  		    
                            	<%for(int i=0;i<subdep_id_list.size();i++){%>
                            	<option value="<%=(String)((DataObject)subdep_id_list.get(i)).getValue("cmuse_id")%>"
                            		<%if(subdep_id.equals("") && ((String)((DataObject)subdep_id_list.get(i)).getValue("cmuse_id")).equals("")) out.print("selected");%>
                            		<%if(((DataObject)subdep_id_list.get(i)).getValue("cmuse_id") != null && (subdep_id.equals((String)((DataObject)subdep_id_list.get(i)).getValue("cmuse_id")))) out.print("selected");%>
                               	>
                            	<%if(((DataObject)subdep_id_list.get(i)).getValue("cmuse_name") != null) out.print((String)((DataObject)subdep_id_list.get(i)).getValue("cmuse_name"));%>                            
                            	</option>                            
                            	<%}%>
                            </select>
                        </td>
                    </tr>
                    <tr>
						<td width='96' align='left' bgcolor='#BDDE9C' height="23" class="sbody">員工代碼</td>
						<td width='562' bgcolor='EBF4E1' height="23" class="sbody" colspan="2">						  
						  <% String muser_name="";
						     if(act.equals("Edit") || act.equals("Copy")){
						    	sql.setLength(0 ) ;
						    	paramList.clear() ;
						        sql.append("select muser_id,muser_name from wtt01 where muser_id=? " );
						        paramList.add(muser_id) ;
						        List dbData = DBManager.QueryDB_SQLParam(sql.toString(),paramList,"");
						        if(dbData != null && dbData.size() == 1){
						           muser_name = (String)((DataObject)dbData.get(0)).getValue("muser_name");
						        }
						     }  
						  %>
                          	<select name='MUSER_ID'>							  		    
                          	<option value='<%=muser_id%>'><%if(!act.equals("Copy")){%><%=muser_id%><%=muser_name%><%}%></option>
                            </select>
                            <%//96.01.02 add 顯示複製的員工代碼
						     if(act.equals("Copy")){
						        out.print("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;複製的員工代碼:"+muser_id+"&nbsp;"+muser_name);
						     }  
						  %>
                       </td>
                    </tr>
                    <tr class="sbody">
						<td width='96' align='left' bgcolor='#BDDE9C' height="50" rowspan="2">金融機構類別</td>
						<td width='281' bgcolor='#BDDE9C' height="20" align="center">可選擇項目</td>
						<td width='281' bgcolor='#BDDE9C' height="20" align="center">已選擇項目</td>
                    </tr>
                    <tr class="sbody">
						<td width='562' bgcolor='EBF4E1' height="30" colspan="2">
                          	<table width="560" border="0" align="center" cellpadding="1" cellspacing="1" bgcolor="#E9F4E3" height="1">
                          <tr class="sbody"> 
                            <td width="45%" align="center" height="1">
                            <select multiple  size=10 id="BANK_TYPE_Src" name="BANK_TYPE_Src" ondblclick="javascript:movesel(this.document.forms[0].BANK_TYPE_Src,this.document.forms[0].BANK_TYPE);changeOption_HsienID(this.document.forms[0]);" style="width: 246; height: 133">							                            
                            	<option  value="1">全國農業金庫</option>
                            	<option  value="6">農會</option>
                            	<option  value="7">漁會</option>
                            	<option  value="8">農漁會共用中心</option>                            							            
							</select>
                            </td>
                            
                            <td width="10%" height="1">
                              <table width="100%" border="0" align="center" cellpadding="3" cellspacing="3" height="143">
                                <tr> 
                                  <td align="center" height="28">                                 
                                    <a href="javascript:movesel(this.document.forms[0].BANK_TYPE_Src,this.document.forms[0].BANK_TYPE);changeOption_HsienID(this.document.forms[0]);"><img src="images/arrow_right.gif" width="24" height="22" border="0"></a>
                                  </td>
                                </tr>
                                <tr> 
                                  <td align="center" height="28">                               
                                  <a href="javascript:moveallsel(this.document.forms[0].BANK_TYPE_Src,this.document.forms[0].BANK_TYPE);changeOption_HsienID(this.document.forms[0]);"><img src="images/arrow_rightall.gif" width="24" height="22" border="0"></a>
                                  </td>
                                </tr>
                                <tr> 
                                  <td align="center" height="28">                                                             
                                   <a href="javascript:movesel(this.document.forms[0].BANK_TYPE,this.document.forms[0].BANK_TYPE_Src);changeOption_HsienID(this.document.forms[0]);"><img src="images/arrow_left.gif" width="24" height="22" border="0"></a>                               
                                  </td>
                                </tr>
                                <tr> 
                                  <td align="center" height="19">                                                              
                                  <a href="javascript:moveallsel(this.document.forms[0].BANK_TYPE,this.document.forms[0].BANK_TYPE_Src);changeOption_HsienID(this.document.forms[0]);"><img src="images/arrow_leftall.gif" width="24" height="22" border="0"></a>                               
                                  </td>
                                </tr>
                              </table>
                            </td>
                            <td width="45%" align="center" height="1" > 
                            <select multiple size=10 id="BANK_TYPE" name="BANK_TYPE"  ondblclick="javascript:movesel(this.document.forms[0].BANK_TYPE,this.document.forms[0].BANK_TYPE_Src);changeOption_HsienID(this.document.forms[0]);" style="width: 237; height: 129"></select>                                                                            
                            </td>                           
                          </tr>
                        </table>
                          </td>
                          </tr>     
					      
                    <tr class="sbody">
						<td width='96' align='left' bgcolor='#BDDE9C' height="17">縣市別</td>
						<td width='562' bgcolor='EBF4E1' height="17" colspan="2">
                          	<table width="560" border="0" align="center" cellpadding="1" cellspacing="1" bgcolor="#E9F4E3" height="1">
                          <tr class="sbody"> 
                            <td width="45%" align="center" height="1">
                            <select multiple  size=10 id="HSIEN_ID_Src" name="HSIEN_ID_Src" ondblclick="javascript:movesel(this.document.forms[0].HSIEN_ID_Src,this.document.forms[0].HSIEN_ID);changeOption_TBankNO(this.document.forms[0]);" style="width: 246; height: 135">                            
                            </td>
                            
                            <td width="10%" height="1">
                              <table width="100%" border="0" align="center" cellpadding="3" cellspacing="3" height="143">
                                <tr> 
                                  <td align="center" height="28">                                 
                                    <a href="javascript:movesel(this.document.forms[0].HSIEN_ID_Src,this.document.forms[0].HSIEN_ID);changeOption_TBankNO(this.document.forms[0]);"><img src="images/arrow_right.gif" width="24" height="22" border="0"></a>
                                  </td>
                                </tr>
                                <tr> 
                                  <td align="center" height="28">                               
                                   <a href="javascript:moveallsel(this.document.forms[0].HSIEN_ID_Src,this.document.forms[0].HSIEN_ID);changeOption_TBankNO(this.document.forms[0]);"><img src="images/arrow_rightall.gif" width="24" height="22" border="0"></a>
                                  </td>
                                </tr>
                                <tr> 
                                  <td align="center" height="28">                                                             
                                   <a href="javascript:movesel(this.document.forms[0].HSIEN_ID,this.document.forms[0].HSIEN_ID_Src);changeOption_TBankNO(this.document.forms[0]);"><img src="images/arrow_left.gif" width="24" height="22" border="0"></a>                               
                                  </td>
                                </tr>
                                <tr> 
                                  <td align="center" height="19">                                                              
                                    <a href="javascript:moveallsel(this.document.forms[0].HSIEN_ID,this.document.forms[0].HSIEN_ID_Src);changeOption_TBankNO(this.document.forms[0]);"><img src="images/arrow_leftall.gif" width="24" height="22" border="0"></a>                               
                                  </td>
                                </tr>
                              </table>
                            </td>
                            <td width="45%" align="center" height="1" > 
                            <select multiple size=10 id="HSIEN_ID" name="HSIEN_ID" ondblclick="javascript:movesel(this.document.forms[0].HSIEN_ID,this.document.forms[0].HSIEN_ID_Src);changeOption_TBankNO(this.document.forms[0]);" style="width: 237; height: 136">							
							</select>                                                      
                            </td>                           
                          </tr>
                        </table>

                          </td>
                          </tr>     
					      
                    <tr class="sbody">
						<td width='96' align='left' bgcolor='#BDDE9C' height="17">總機構單位</td>
						<td width='562' bgcolor='EBF4E1' height="17" colspan="2">
                        <table width="560" border="0" align="center" cellpadding="1" cellspacing="1" bgcolor="#E9F4E3" height="1">
                          <tr class="sbody"> 
                            <td width="45%" align="center" height="1">
                            <select multiple  size=10 id="TBANK_NO_Src" name="TBANK_NO_Src" ondblclick="javascript:movesel(this.document.forms[0].TBANK_NO_Src,this.document.forms[0].TBANK_NO);changeOption_BankNO(this.document.forms[0]);"style="width: 246; height: 135">
                            </select>  
                            </td>
                            
                            <td width="10%" height="1">
                              <table width="100%" border="0" align="center" cellpadding="3" cellspacing="3" height="143">
                                <tr> 
                                  <td align="center" height="28">                                 
                                    <a href="javascript:movesel(this.document.forms[0].TBANK_NO_Src,this.document.forms[0].TBANK_NO);changeOption_BankNO(this.document.forms[0]);"><img src="images/arrow_right.gif" width="24" height="22" border="0"></a>
                                  </td>
                                </tr>
                                <tr> 
                                  <td align="center" height="28">                               
                                  <a href="javascript:moveallsel(this.document.forms[0].TBANK_NO_Src,this.document.forms[0].TBANK_NO);changeOption_BankNO(this.document.forms[0]);"><img src="images/arrow_rightall.gif" width="24" height="22" border="0"></a>
                                  </td>
                                </tr>
                                <tr> 
                                  <td align="center" height="28">                                                             
                                  <a href="javascript:movesel(this.document.forms[0].TBANK_NO,this.document.forms[0].TBANK_NO_Src);changeOption_BankNO(this.document.forms[0]);"><img src="images/arrow_left.gif" width="24" height="22" border="0"></a>                               
                                  </td>
                                </tr>
                                <tr> 
                                  <td align="center" height="19">                                                              
                                  <a href="javascript:moveallsel(this.document.forms[0].TBANK_NO,this.document.forms[0].TBANK_NO_Src);changeOption_BankNO(this.document.forms[0]);"><img src="images/arrow_leftall.gif" width="24" height="22" border="0"></a>                               
                                  </td>
                                </tr>
                              </table>
                            </td>
                            <td width="45%" align="center" height="1" > 
                            <select multiple size=10 id="TBANK_NO" name="TBANK_NO" ondblclick="javascript:movesel(this.document.forms[0].TBANK_NO,this.document.forms[0].TBANK_NO_Src);changeOption_BankNO(this.document.forms[0]);" style="width: 237; height: 136">							
							</select>                        
                            </td>                           
                          </tr>
                        </table>
                            
                          </td>
                          </tr>     
					      
                    <tr class="sbody">
						<td width='96' align='left' bgcolor='#BDDE9C' height="17">受檢單位</td>
						<td width='562' bgcolor='EBF4E1' height="17" colspan="2">
                          		<table width="560" border="0" align="center" cellpadding="1" cellspacing="1" bgcolor="#E9F4E3" height="1">
                          <tr class="sbody"> 
                            <td width="45%" align="center" height="1">
                             <select multiple  size=10 id="EXAMINE_Src" name="EXAMINE_Src" ondblclick="javascript:movesel(this.document.forms[0].EXAMINE_Src,this.document.forms[0].EXAMINE);" style="width: 246; height: 138">
                             </select>     
                            </td>
                            
                            <td width="10%" height="1">
                              <table width="100%" border="0" align="center" cellpadding="3" cellspacing="3" height="143">
                                <tr> 
                                  <td align="center" height="28">                                 
                                    <a href="javascript:movesel(this.document.forms[0].EXAMINE_Src,this.document.forms[0].EXAMINE);">
                                    <img src="images/arrow_right.gif" width="24" height="22" border="0"></a>
                                  </td>
                                </tr>
                                <tr> 
                                  <td align="center" height="28">                               
                                  <a href="javascript:moveallsel(this.document.forms[0].EXAMINE_Src,this.document.forms[0].EXAMINE);">
                                  <img src="images/arrow_rightall.gif" width="24" height="22" border="0"></a>
                                  </td>
                                </tr>
                                <tr> 
                                  <td align="center" height="28">
                                                             
                                  <a href="javascript:movesel(this.document.forms[0].EXAMINE,this.document.forms[0].EXAMINE_Src);">
                                  <img src="images/arrow_left.gif" width="24" height="22" border="0"></a>
                               
                                  </td>
                                </tr>
                                <tr> 
                                  <td align="center" height="19">
                                                              
                                  <a href="javascript:moveallsel(this.document.forms[0].EXAMINE,this.document.forms[0].EXAMINE_Src);">
                                  <img src="images/arrow_leftall.gif" width="24" height="22" border="0"></a>
                               
                                  </td>
                                </tr>
                              </table>
                            </td>
                            <td width="45%" align="center" height="1" > 
                           <select multiple size=10 id="EXAMINE" name="EXAMINE" ondblclick="javascript:movesel(this.document.forms[0].EXAMINE,this.document.forms[0].EXAMINE_Src);" style="width: 246; height: 138">							
							</select>                           
                            </td>                           
                          </tr>
                        </table>
                       			
                            
                          </td>
                          </tr>     
                        </table>
                          </td>
                          </tr>     
					      
                        </Table></td>
                    </tr>                 
                    <tr>                  
                <td><div align="right"><jsp:include page="getMaintainUser.jsp?width=675" flush="true" /></div></td>                                              
              </tr>
              
              <tr> 
                <td><div align="center"> 
                    <table width="243" border="0" cellpadding="1" cellspacing="1">
                      <tr>  
                         <td width="66"> <div align="center"><a href="javascript:MoveSelectToBtn(this.document.forms[0].DataList, this.document.forms[0].EXAMINE);doSubmit(this.document.forms[0],'<%if(act.equals("Edit")) out.print("Update"); else out.print("Insert");%>','','','');" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image101','','images/bt_confirmb.gif',1)"><img src="images/bt_confirm.gif" name="Image101" width="66" height="25" border="0" id="Image101"></a></div></td>
                        	<!-- <td width="66"> <div align="center"><a href="javascript:AskReset(this.document.forms[0]);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image104','','images/bt_cancelb.gif',1)"><img src="images/bt_cancel.gif" name="Image104" width="66" height="25" border="0" id="Image104"></a></div></td> -->
		                        
                        <td width="80"><div align="center"><a href="javascript:history.back();"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image105','','images/bt_backb.gif',1)"><img src="images/bt_back.gif" name="Image105" width="80" height="25" border="0" id="Image105"></a></div></td>
                      </tr>
                      </tr>
                    </table>
                  </div></td>
              </tr>                               
      </table></td>
  </tr>
  <tr> 
                <td width="694"><table width="688" border="0" cellpadding="1" cellspacing="1" class="sbody">
                    <tr> 
                      <td colspan="2" width="680"><font color='#990000'><img src="images/arrow_1.gif" width="28" height="23" align="absmiddle"><font color="#007D7D" size="3">使用說明          
                        : </font></font></td>
                    </tr>
                    <tr> 
                      <td width="17">&nbsp;</td>
                      <td width="657"> <ul>                                            
                          <li>本網頁提供維護檢查人員之檢查追蹤管理系統權限功能。</li>                          
                          <li>按了【確定】即將本表上的「檢查人員之檢查追蹤管理系統權限」資料於資料庫中建檔</li>         
                          <li>按<font color="#666666">【回上一頁】</font>則放棄新增檢查人員之檢查追蹤管理系統權限, 回至上個畫面。</li>         
                        </ul></td>
                    </tr>
                  </table></td>
              </tr>
              <!--tr> 
                <td><div align="center"><img src="images/line_1.gif" width="600" height="12"></div></td>
              </tr-->
</table>

<INPUT type="hidden" name=DataList value=''><!--//儲存已勾選的欲新增的wtt08資料-->
<INPUT type="hidden" name=BankTypeList value='<%if(session.getAttribute("BankTypeList") != null) out.print((String)session.getAttribute("BankTypeList"));%>'><!--//儲存已勾選的金融機構類別-->
<INPUT type="hidden" name=HsienIdList value='<%if(session.getAttribute("HsienIdList") != null) out.print((String)session.getAttribute("HsienIdList"));%>'><!--//儲存已勾選的縣市別-->
<INPUT type="hidden" name=TBankNoList value='<%if(session.getAttribute("TBankNoList") != null) out.print((String)session.getAttribute("TBankNoList"));%>'><!--//儲存已勾選的總機構單位-->
<INPUT type="hidden" name=ExamineList value='<%if(session.getAttribute("ExamineList") != null) out.print((String)session.getAttribute("ExamineList"));%>'><!--//儲存已勾選的受檢單位-->
</form>
<script language="JavaScript" >
<!--
<%if(!act.equals("Edit") && !act.equals("Copy")){//95.01.02 add 為Copy時,不變更員工代碼%>
changeOption_MuserID(this.document.forms[0],'<%=act%>');
<%}%>
<%if(act.equals("Edit") || act.equals("Copy")){%>
var bnlist;
bnlist = '<%=(String)session.getAttribute("BankTypeList")%>';
var a = bnlist.split(',');
for (var i =0; i < a.length; i ++){
	var j = a[i].split('+');
	this.document.forms[0].BANK_TYPE.options[i] = new Option(j[1], j[0]);
}

bnlist = '<%=(String)session.getAttribute("HsienIdList")%>';
var a = bnlist.split(',');
for (var i =0; i < a.length; i ++){
	var j = a[i].split('+');	
	this.document.forms[0].HSIEN_ID.options[i] = new Option(j[1], j[0]);
}

bnlist = '<%=(String)session.getAttribute("TBankNoList")%>';
var a = bnlist.split(',');
for (var i =0; i < a.length; i ++){
	var j = a[i].split('+');
	this.document.forms[0].TBANK_NO.options[i] = new Option(j[1], j[0]);	
}

bnlist = '<%=(String)session.getAttribute("ExamineList")%>';
var a = bnlist.split(',');
for (var i =0; i < a.length; i ++){
	var j = a[i].split('+');
	this.document.forms[0].EXAMINE.options[i] = new Option(j[1], j[0]);	
}
changeOption_BankType(this.document.forms[0]);
changeOption_HsienID(this.document.forms[0]);
changeOption_TBankNO(this.document.forms[0]);
changeOption_BankNO(this.document.forms[0]);
<%}%>
-->
</script>
</body>
</html>

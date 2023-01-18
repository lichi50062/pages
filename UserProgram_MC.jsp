<%
//97.08.29 add 監理資訊共享平台UserProgram
//98.06.23 add 檢舉書menu.區分子目錄 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="common.jsp"%> 
<%
    RequestDispatcher rd = null;
    String muser_id = ( session.getAttribute("muser_id")==null ) ? "" : (String)session.getAttribute("muser_id");				    
    String muser_type = ( session.getAttribute("muser_type")==null ) ? "" : (String)session.getAttribute("muser_type");				    
    String bank_type = ( session.getAttribute("bank_type")==null ) ? "" : (String)session.getAttribute("bank_type");				        
    String tbank_no = ( session.getAttribute("tbank_no")==null ) ? "" : (String)session.getAttribute("tbank_no");				        
    String muser_i_o = ( session.getAttribute("muser_i_o")==null ) ? "" : (String)session.getAttribute("muser_i_o");				        
    
    if(session.getAttribute("muser_id") == null){	 
       System.out.println("UserProgram_MC.login timeout"); 
	   rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );         	   
       rd.forward(request,response);
    } 
     
    String sqlCmd = "";
    List paramList = new ArrayList();
    sqlCmd = " select  WTT03_1.program_id,WTT03_1.PROGRAM_NAME,WTT03_1.url_id,"
	   	   + " WTT04.P_ADD,WTT04.P_DELETE,WTT04.P_UPDATE,"
	   	   + " WTT04.P_QUERY,WTT04.P_PRINT,WTT04.P_UPLOAD,"
	   	   + " WTT04.P_DOWNLOAD,WTT04.P_LOCK,WTT04.P_OTHER"
		   + " from WTT04 "		   		   
		   + " LEFT JOIN WTT03_1 on WTT03_1.PROGRAM_ID=WTT04.PROGRAM_ID	"
		   + " where WTT04.muser_id=?"		
		   + " and (WTT03_1.program_id like 'MC%' or WTT03_1.program_id like 'RptFileUpload%')";		   
    paramList.add(muser_id);		
    List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");
    if(dbData != null){
       System.out.println("dbData.size()="+dbData.size());
    }
%>
<html><head>
<title>監理資訊共享平台</title>
<link rel='stylesheet' href='js/ftie4style.css'>
<script src='js/ftiens4.js'></script>
<td>&nbsp;&nbsp;<font color='red' size='2px'><b>監理資訊共享平台</b></font></td>
<script>
<%        
out.println("foldersTree = gFld('<font size=2>監理資訊共享平台</font>', ' ');");//95.10.16當沒有權限時,預設顯示該資料夾                          
System.out.println("MC000 -- print initializeDocument");

if(dbData != null && dbData.size() != 0){
   String Program_Type="";
   String program_id="";
   String program_name="";
   String program_url="";
   String program_type_name="";   
   Properties permission = null;
   int i=0;   
   //顯示監理資訊共享平台的Menu============================================================================
   for(i=0;i<dbData.size();i++){   
       program_id=(String)((DataObject)dbData.get(i)).getValue("program_id");
       program_name=(String)((DataObject)dbData.get(i)).getValue("program_name");      
       program_url=(String)((DataObject)dbData.get(i)).getValue("url_id");       
       
       if(program_id.equals("MC014W")){//98.06.23 add 檢舉書menu
           out.println("aux1 = insFld(foldersTree, gFld('<font size=2>檢舉書(MC014W)</font>', ''));") ;              
   		   out.println("insDoc(aux1, gLnk(0, '<font size=2>&nbsp;&nbsp;受理</font><font size=1><br>&nbsp;</font>', 'MC014W.jsp?act=New'));");
   		   out.println("insDoc(aux1, gLnk(0, '<font size=2>&nbsp;&nbsp;發文</font><font size=1><br>&nbsp;</font>', 'MC014W.jsp?act=Qry&flag=R'));");
   		   out.println("insDoc(aux1, gLnk(0, '<font size=2>&nbsp;&nbsp;回文</font><font size=1><br>&nbsp;</font>', 'MC014W.jsp?act=Qry&flag=B'));");
   		   out.println("insDoc(aux1, gLnk(0, '<font size=2>&nbsp;&nbsp;查詢</font><font size=1><br>&nbsp;</font>', 'MC014W.jsp?act=Qry'));");   		  
       }else{
       	   out.println("insDoc(foldersTree, gLnk(0, '<font size=2>"+program_name+"("+program_id+")</font><font size=1><br>&nbsp;</font>', '"+program_url+"'));");                                    			   		                 	   
       }              
   }
}//end of dbData.size != 0 

out.println("initializeDocument()");
out.println("foldersTree.setState(1)");//把Menu展開				
%>
</script></head>
<body bgcolor="#BFDFAE" leftmargin="0" topmargin="0">
</body>
</html>

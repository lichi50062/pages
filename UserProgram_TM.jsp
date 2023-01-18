<%
//105.09.05 add 協助措施UserProgram
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
       System.out.println("UserProgram_TM.login timeout"); 
	   rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );         	   
       rd.forward(request,response);
    } 
    List paramList = new ArrayList();
    String sqlCmd = "";
    sqlCmd = " select  WTT03_1.program_id,wtt03_2.web_type,WTT03_1.PROGRAM_NAME,WTT03_1.url_id,"
	   	   + " WTT04.P_ADD,WTT04.P_DELETE,WTT04.P_UPDATE,"
	   	   + " WTT04.P_QUERY,WTT04.P_PRINT,WTT04.P_UPLOAD,"
	   	   + " WTT04.P_DOWNLOAD,WTT04.P_LOCK,WTT04.P_OTHER"
		   + " from WTT04 "		   		   
		   + " LEFT JOIN WTT03_1 on WTT03_1.PROGRAM_ID=WTT04.PROGRAM_ID	"
		   + " left join wtt03_2 on wtt04.program_id=wtt03_2.program_id "
		   + " where WTT04.muser_id=?"		
		   + " and web_type='2'"//105.10.20屬於MIS管理系統才顯示 
		   + " and (WTT03_1.program_id like 'TM%' or WTT03_1.program_id = 'DS067W')"
		   + " order by to_number(wtt03_1.input_order)";		   
    paramList.add(muser_id);
			
    List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");
    if(dbData != null){
       System.out.println("dbData.size()="+dbData.size());
    }
%>
<html><head>
<title>協助措施</title>
<link rel='stylesheet' href='js/ftie4style.css'>
<script src='js/ftiens4.js'></script>
<td>&nbsp;&nbsp;<font color='red' size='2px'><b>協助措施</b></font></td>
<script>
<%   
out.println("foldersTree = gFld('<font size=2>協助措施</font>', ' ');");//95.10.16當沒有權限時,預設顯示該資料夾                          
System.out.println("AN000 -- print initializeDocument");
if(dbData != null && dbData.size() != 0){
   String Program_Type="";
   String program_id="";
   String program_name="";
   String program_url="";
   String program_type_name="";   
   Properties permission = null;
   int i=0;   
   //顯示金融協助措施的Menu============================================================================
   for(i=0;i<dbData.size();i++){   
       program_id=(String)((DataObject)dbData.get(i)).getValue("program_id");
       program_name=(String)((DataObject)dbData.get(i)).getValue("program_name");      
       program_url=(String)((DataObject)dbData.get(i)).getValue("url_id");                      		   
   	   out.println("insDoc(foldersTree, gLnk(0, '<font size=2>"+program_name+"("+program_id+")</font><font size=1><br>&nbsp;</font>', '"+program_url+"'));");                                    			   		            
   }
}//end of dbData.size != 0       
out.println("initializeDocument()");
out.println("foldersTree.setState(1)");//把Menu展開	       
%>
</script></head>
<body bgcolor="#BFDFAE" leftmargin="0" topmargin="0">
</body>
</html>

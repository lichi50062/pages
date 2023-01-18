<%
//94.01.31 add 檢查追蹤系統的UserProgram
//94.02.04 fix 不是superBOAF才需輸入使用者基本資料
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
       System.out.println("UserProgram_TC.login timeout"); 
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
		   + " and (WTT03_1.program_id like 'ZZ%' or WTT03_1.program_id like 'AS%')";
		   //+ " and WTT03_1.program_id <> 'ZZ042W'"; //zz042只有在BOAF才可用  
	paramList.add(muser_id);	
    List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");
    if(dbData != null){
       System.out.println("dbData.size()="+dbData.size());
    }
%>
<html><head>
<title>管理系統</title>
<link rel='stylesheet' href='js/ftie4style.css'>
<script src='js/ftiens4.js'></script>
<script>
<%
//94.01.10 fix 若Muser_Data裡的e-mail為空白時,須強制輸入基本資料============================
String UpdateMuser_Data = null;
if(session.getAttribute("UpdateMuser_Data") != null){
   UpdateMuser_Data = (String)session.getAttribute("UpdateMuser_Data");
   System.out.println("UpdateMuser_Data="+UpdateMuser_Data);
}

zz025wLoop:
if((UpdateMuser_Data != null && UpdateMuser_Data.equals("true")) || 
   ((dbData == null || dbData.size() == 0 ) && (!muser_id.equals("superBOAF"))) )
{
   if(muser_id.equals("superBOAF")) break zz025wLoop;//94.02.04 fix 不是superBOAF才需輸入使用者基本資料
   out.println("foldersTree = gFld('<font size=2>管理系統</font>', ' ');");                       
   out.println("insDoc(foldersTree, gLnk(0, '<font size=2>使用者基本資料維護(ZZ025W)</font><font size=1><br>&nbsp;</font>', 'ZZ025W.jsp?act=Edit&bank_type=Z'));");                                              
   System.out.println("zz025 -- print initializeDocument");
   out.println("initializeDocument()");
   out.println("foldersTree.setState(1)");//把Menu展開					 
}
//====================================================================================
if(( dbData == null || dbData.size() == 0 ) && (muser_id.equals("superBOAF"))){
   out.println("foldersTree = gFld('<font size=2>管理系統</font>', ' ');");                       
   out.println("insDoc(foldersTree, gLnk(0, '<font size=2>使用者帳號管理(ZZBOAF)</font><font size=1><br>&nbsp;</font>', 'ZZBOAF.jsp?act=List'));");                                              
   System.out.println("superBOAF print initializeDocument");
   out.println("initializeDocument()");
   out.println("foldersTree.setState(1)");//把Menu展開					 
}
          
if( ( UpdateMuser_Data == null || !UpdateMuser_Data.equals("true")) && (dbData != null && dbData.size() != 0)){
   String Program_Type="";
   String program_id="";
   String program_name="";
   String program_url="";
   String program_type_name="";   
   Properties permission = null;
   int i=0;   
   
   boolean firstZZ = false;  
   //顯示管理系統的Menu============================================================================
   for(i=0;i<dbData.size();i++){   
       program_id=(String)((DataObject)dbData.get(i)).getValue("program_id");
       program_name=(String)((DataObject)dbData.get(i)).getValue("program_name");      
       program_url=(String)((DataObject)dbData.get(i)).getValue("url_id");       
       
       //if(!program_id.equals("ZZ031W")){            
           if(!firstZZ){ 
              firstZZ=true;
		      out.println("foldersTree = gFld('<font size=2>管理系統</font>', ' ');");                       	               
           }   		
           if(program_id.equals("ZZ004W") || program_id.equals("ZZ003W")){	
              program_url = program_url+"&menu=MIS";
            }     		   
   		   out.println("insDoc(foldersTree, gLnk(0, '<font size=2>"+program_name+"("+program_id+")</font><font size=1><br>&nbsp;</font>', '"+program_url+"'));");                                    			   		   
       //}       
      
   }
   
   if(firstZZ){ 
   	  System.out.println("ZZ print initializeDocument");
   	  out.println("initializeDocument()");
   	  out.println("foldersTree.setState(1)");//把Menu展開		
   }   
}//end of dbData.size != 0       
%>
</script></head>
<body bgcolor="#BFDFAE" leftmargin="0" topmargin="0">
</body>
</html>

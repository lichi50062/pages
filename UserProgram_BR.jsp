<%
//93.12.22 fix FX004W(農業行庫相關機構通訊錄)不顯示bank_list
//93.12.23 add superuser可以看到bank_list
//93.12.28 fix ZZ003W(程式_歸屬系統類別維護)只有super user才能使用
//94.01.10 fix 若Muser_Data裡的e-mail為空白時,須強制輸入基本資料 by 2295
//94.01.12 fix 農會.漁會不顯示FX004W(機構基本資料維護) by 2295
//94.01.14 fix bank_type=共用中心8/地方主管機關B/農金局局內2/super user 可看到Bank_List by 2295
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
    String menu = ( request.getParameter("menu")==null ) ? "" : (String)request.getParameter("menu");			    	
    String title = (menu.equals("BR"))?"MIS管理系統":"檢查缺失及追蹤管理系統";
    if(session.getAttribute("muser_id") == null){	 
       System.out.println("UserProgram.login timeout"); 
	   rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );         	   
       rd.forward(request,response);
    }  
    String sqlCmd = "";
    List paramList = new ArrayList();
    sqlCmd = " select WTT02.bank_type,cdshareno.CMUSE_NAME,cdshareno.INPUT_ORDER,";
    if(menu.equals("TC")){
       sqlCmd += "WTT03_1.sub_type,";
    }
    sqlCmd += " WTT03_2.program_id,WTT03_1.PROGRAM_NAME,WTT03_1.url_id,"
	   	   + " WTT04.P_ADD,WTT04.P_DELETE,WTT04.P_UPDATE,"
	   	   + " WTT04.P_QUERY,WTT04.P_PRINT,WTT04.P_UPLOAD,"
	   	   + " WTT04.P_DOWNLOAD,WTT04.P_LOCK,WTT04.P_OTHER"
		   + " from WTT02";
    if(menu.equals("BR")){		   
	   sqlCmd += " LEFT JOIN cdshareno on WTT02.BANK_TYPE = cdshareno.CMUSE_ID and cdshareno.CMUSE_DIV='016'";
	}else if(menu.equals("TC")){		      	
	   sqlCmd += " LEFT JOIN cdshareno on WTT03_1.sub_type = cdshareno.CMUSE_ID and cdshareno.CMUSE_DIV='028'";
    }		   
	sqlCmd += " LEFT JOIN WTT03_2  on WTT03_2.PROGRAM_TYPE = WTT02.BANK_TYPE "
		   + " LEFT JOIN WTT04 on WTT03_2.PROGRAM_ID=WTT04.PROGRAM_ID "
		   + " LEFT JOIN WTT03_1 on WTT03_1.PROGRAM_ID=WTT04.PROGRAM_ID"
		   + " where WTT02.muser_id=?"		  
		   + " and WTT03_2.WEB_TYPE='2'"
		   + " and WTT04.muser_id = WTT02.muser_id"
		   + " and WTT03_1.program_id like '"+menu+"%'";
	paramList.add(muser_id);
	if(menu.equals("BR")){		   
	   sqlCmd += " order by cdshareno.INPUT_ORDER,WTT04.program_id";
    }else if(menu.equals("TC")){		      	
	   sqlCmd += "order by WTT03_1.sub_type,order_type";
	}
	   
    List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");
    if(dbData != null){
       System.out.println("dbData.size()="+dbData.size());
    }
%>
<html><head>
<title><%=title%></title>
<link rel='stylesheet' href='js/ftie4style.css'>
<script src='js/ftiens4.js'></script>
<script>
<%
//94.01.10 fix 若Muser_Data裡的e-mail為空白時,須強制輸入基本資料
/*
String UpdateMuser_Data = null;
if(session.getAttribute("UpdateMuser_Data") != null){
   UpdateMuser_Data = (String)session.getAttribute("UpdateMuser_Data");
}

if((UpdateMuser_Data != null && UpdateMuser_Data.equals("true")) || 
   ((dbData == null || dbData.size() == 0 ) && (!muser_id.equals("superBOAF"))) )
{
   out.println("foldersTree = gFld('<font size=2>管理系統</font>', ' ');");                       
   out.println("insDoc(foldersTree, gLnk(0, '<font size=2>使用者基本資料維護(ZZ025W)</font><font size=1><br>&nbsp;</font>', 'ZZ025W.jsp?act=Edit&bank_type=Z'));");                                              
   System.out.println("ZZ025 -- print initializeDocument");
   out.println("initializeDocument()");
   out.println("foldersTree.setState(0)");			 
}
if(( dbData == null || dbData.size() == 0 ) && (muser_id.equals("superBOAF"))){
   out.println("foldersTree = gFld('<font size=2>管理系統</font>', ' ');");                       
   out.println("insDoc(foldersTree, gLnk(0, '<font size=2>使用者帳號管理(ZZBOAF)</font><font size=1><br>&nbsp;</font>', 'ZZBOAF.jsp?act=List'));");                                              
   System.out.println("superBOAF -- print initializeDocument");
   out.println("initializeDocument()");
   out.println("foldersTree.setState(0)");			 
}
*/          
if( ( UpdateMuser_Data == null || !UpdateMuser_Data.equals("true")) && (dbData != null && dbData.size() != 0)){
   String Program_Type="";
   String program_id="";
   String program_name="";
   String program_url="";
   String program_type_name="";   
   Properties permission = null;
   		
   for(int i=0;i<dbData.size();i++){   
       System.out.println("i="+i);
       System.out.println("Program_Type="+Program_Type);
       System.out.println("bank_type="+(String)((DataObject)dbData.get(i)).getValue("bank_type"));
       program_id=(String)((DataObject)dbData.get(i)).getValue("program_id");
       program_name=(String)((DataObject)dbData.get(i)).getValue("program_name");
      
       program_url=(String)((DataObject)dbData.get(i)).getValue("url_id");
       program_type_name=(String)((DataObject)dbData.get(i)).getValue("cmuse_name");       
       //取得該program_id的權限==============================================================
       permission =  ( session.getAttribute(program_id)==null ) ? new Properties() : (Properties)session.getAttribute(program_id); 	
       //====================================================================================
      
       
       if(Program_Type.equals((String)((DataObject)dbData.get(i)).getValue("bank_type"))){                     				   
          if(permission != null && permission.get("Q") != null && permission.get("Q").equals("Y")){                    	        	                           
             program_url = (program_url.indexOf("?") != -1)?program_url+"&":program_url+"?";
             program_url = program_url + "bank_type="+(String)((DataObject)dbData.get(i)).getValue("bank_type");                                                    
             out.println("insDoc(foldersTree, gLnk(0, '<font size=2>"+program_name+"("+program_id+")</font><font size=1><br>&nbsp;</font>', '"+program_url+"'));");                                              
          }  		  
       }else{        
          System.out.println("Program_Type !==");  
          if(i != 0){             
             System.out.println("print initializeDocument");
             out.println("initializeDocument()");
			 out.println("foldersTree.setState(0)");			 
          }  
          Program_Type = (String)((DataObject)dbData.get(i)).getValue("bank_type");
          out.println("foldersTree = gFld('<font size=2>"+program_type_name+"</font>', ' ');");                    
          
          if(permission != null && permission.get("Q") != null && permission.get("Q").equals("Y")){                    	        	                                   		                           
             program_url = (program_url.indexOf("?") != -1)?program_url+"&":program_url+"?";
             program_url = program_url + "bank_type="+(String)((DataObject)dbData.get(i)).getValue("bank_type");                                                    
             out.println("insDoc(foldersTree, gLnk(0, '<font size=2>"+program_name+"("+program_id+")</font><font size=1><br>&nbsp;</font>', '"+program_url+"'));");                                              
          }   
       }       
   }//end of for        
   out.println("initializeDocument();");
   out.println("foldersTree.setState(0);");	
}//end of dbData.size != 0       
%>
</script></head>
<body bgcolor="#6FBEBB" leftmargin="0" topmargin="0">
</body>
</html>

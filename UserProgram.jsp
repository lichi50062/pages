<%
// 93.12.22 fix FX004W(農業行庫相關機構通訊錄)不顯示bank_list
// 93.12.23 add superuser可以看到bank_list
// 93.12.28 fix ZZ003W(程式_歸屬系統類別維護)只有super user才能使用
// 94.01.10 fix 若Muser_Data裡的e-mail為空白時,須強制輸入基本資料 by 2295
// 94.01.12 fix 農會.漁會不顯示FX004W(機構基本資料維護) by 2295
// 94.01.14 fix bank_type=共用中心8/地方主管機關B/農金局局內2/super user 可看到Bank_List by 2295
// 94.02.16 fix 若為FR003W(資產負債表)/FR004W(損益表)/FR007W/FR008W/FR009W則加上農會/漁會至menu by 2295
// 94.02.24 fix 若為FR001W/FR002W/FR005W加上農會/漁會至menu by 2295
// 95.03.28 fix 若為FR004W_month加上農會/漁會至menu by 2295
// 95.08.28 add menu加上DS申報資料分析支援系統 by 2295
//101.07.18 add EX-資訊揭露/OR-公務用統計報表 by 2295
//101.08.21 fix FR025W/FR027W預設不顯示英文名稱 by 2295
//105.10.06 add 專案農貸檢查缺失追蹤管理系統 by 2295
//109.06.19 fix 調整查詢sql by 2295
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
    String title = "";
    List paramList = new ArrayList();
    if(menu.equals("BR")){
      title = "金融監理基本報表";
    }else if(menu.equals("FR")){
      title = "金融監理財務報表";
    }else if(menu.equals("TC")){
      title = "檢查追蹤管理系統";
    }else if(menu.equals("DS")){
      title = "申報資料分析支援系統";
    }else if(menu.equals("EX")){//101.07.18 add
      title = "資訊揭露專區";
    }else if(menu.equals("OR")){//101.07.18 add
      title = "公務統計報表";  
    }else if(menu.equals("FL")){//105.10.06 add
      title = "專案農貸檢查追蹤管理系統";  
    }
    if(session.getAttribute("muser_id") == null){	 
       System.out.println("UserProgram.login timeout"); 
	     rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );         	   
       rd.forward(request,response);
    }  
    String sqlCmd = "";
    sqlCmd = " select WTT02.bank_type,cdshareno.CMUSE_NAME,cdshareno.INPUT_ORDER,";
    if(menu.equals("TC")){
       sqlCmd += "WTT03_1.sub_type,";
    }
    sqlCmd += " WTT03_2.program_id,WTT03_1.PROGRAM_NAME,WTT03_1.url_id,"
	   	   + " WTT04.P_ADD,WTT04.P_DELETE,WTT04.P_UPDATE,"
	   	   + " WTT04.P_QUERY,WTT04.P_PRINT,WTT04.P_UPLOAD,"
	   	   + " WTT04.P_DOWNLOAD,WTT04.P_LOCK,WTT04.P_OTHER"
		   + " from WTT02";
    if(menu.equals("BR") || menu.equals("FR") || menu.equals("DS") || menu.equals("EX") || menu.equals("OR") || menu.equals("FL")){//101.07.18 add EX/OR		   
	     sqlCmd += " LEFT JOIN cdshareno on WTT02.BANK_TYPE = cdshareno.CMUSE_ID and cdshareno.CMUSE_DIV='016'";
	  }		  
	  
	sqlCmd += " LEFT JOIN WTT03_2  on WTT03_2.PROGRAM_TYPE = WTT02.BANK_TYPE "
		   + " LEFT JOIN WTT04 on WTT03_2.PROGRAM_ID=WTT04.PROGRAM_ID "
		   + " LEFT JOIN WTT03_1 on WTT03_1.PROGRAM_ID=WTT04.PROGRAM_ID";
	if(menu.equals("TC")){		      	
	   sqlCmd += " LEFT JOIN cdshareno on WTT03_1.sub_type = cdshareno.CMUSE_ID and cdshareno.CMUSE_DIV='028'";
  }	   
   
	sqlCmd += " where WTT02.muser_id=?"		  
		   + " and WTT03_2.WEB_TYPE=?"
		   + " and WTT04.muser_id = WTT02.muser_id";
	paramList.add(muser_id);
	paramList.add("2");
	 //101.07.18 add EX-資訊揭露/OR-公務用統計報表 by 2295	   
    if(menu.equals("EX")){
    	 sqlCmd += " AND WTT03_2.SYS_TYPE = ?";
    	 paramList.add("12");
    }else if(menu.equals("OR")){			   
    	 sqlCmd += " AND WTT03_2.SYS_TYPE = ?";   
    	 paramList.add("13");
    }else if(menu.equals("BR")){	
    	 sqlCmd += " AND WTT03_2.SYS_TYPE = ?";//101.09.03 add   	 
    	 paramList.add("2");
    }else if(menu.equals("FR")){
	   sqlCmd += " and WTT03_1.program_id like '"+menu+"%'"
	          + " AND WTT03_2.SYS_TYPE = ?";//101.07.18 add
	   paramList.add("3");        
    }else{	
    	 sqlCmd += " and WTT03_1.program_id like '"+menu+"%'";  
    }	 
	if(menu.equals("BR") || menu.equals("FR") || menu.equals("DS") || menu.equals("EX") || menu.equals("OR") || menu.equals("FL")){//95.08.28 add 加上DS申報資料分析支援系統	//101.07.18 add EX-資訊揭露/OR-公務用統計報表	   
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
<td>&nbsp;&nbsp;<font color='red' size='2px'><b><%=title%></b></font></td>
<script>
<%
//94.01.10 fix 若Muser_Data裡的e-mail為空白時,須強制輸入基本資料

String UpdateMuser_Data = null;

if(session.getAttribute("UpdateMuser_Data") != null){
   UpdateMuser_Data = (String)session.getAttribute("UpdateMuser_Data");
}
/*
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
       //System.out.println("i="+i);
       //System.out.println("Program_Type="+Program_Type);
       //System.out.println("bank_type="+(String)((DataObject)dbData.get(i)).getValue("bank_type"));
       program_id=(String)((DataObject)dbData.get(i)).getValue("program_id");
       program_name=(String)((DataObject)dbData.get(i)).getValue("program_name");
      
       program_url=(String)((DataObject)dbData.get(i)).getValue("url_id");
       program_type_name=(String)((DataObject)dbData.get(i)).getValue("cmuse_name");       
       //取得該program_id的權限==============================================================
       permission =  ( session.getAttribute(program_id)==null ) ? new Properties() : (Properties)session.getAttribute(program_id); 	
       //====================================================================================
      
       
       if(( menu.equals("BR") && Program_Type.equals((String)((DataObject)dbData.get(i)).getValue("bank_type")))
        ||( menu.equals("FR") && Program_Type.equals((String)((DataObject)dbData.get(i)).getValue("bank_type")))
        ||( menu.equals("DS") && Program_Type.equals((String)((DataObject)dbData.get(i)).getValue("bank_type")))
        ||( menu.equals("EX") && Program_Type.equals((String)((DataObject)dbData.get(i)).getValue("bank_type")))
        ||( menu.equals("OR") && Program_Type.equals((String)((DataObject)dbData.get(i)).getValue("bank_type")))
        ||( menu.equals("TC") && Program_Type.equals((String)((DataObject)dbData.get(i)).getValue("sub_type")))
       )//95.08.28 add 加上DS申報資料分析支援系統//101.07.18 add EX-資訊揭露/OR-公務用統計報表 
       {                     				   
          if(permission != null && permission.get("Q") != null && permission.get("Q").equals("Y")){                    	        	                           
             program_url = (program_url.indexOf("?") != -1)?program_url+"&":program_url+"?";
             program_url = program_url + "bank_type="+(String)((DataObject)dbData.get(i)).getValue("bank_type");  
             if( menu.equals("EX") || menu.equals("OR")){
             	if(!(program_id.equals("FR025W") || program_id.equals("FR027W"))){//101.08.21 fix FR025W/FR027W預設不顯示英文名稱
               		program_url += "&showEng=true";//101.07.18 add
            	}
             }	                                                  
             //94.02.16 fix 若為FR003W(資產負債表)/FR004W(損益表)/FR007W/FR008W/FR009W則加上農會/漁會至menu
             //94.02.24 fix 若為FR001W/FR002W/FR005W加上農會/漁會至menu by 2295
             //95.03.28 fix 若為FR004W_month加上農會/漁會至menu by 2295
             if(program_id.equals("FR003W") || program_id.equals("FR004W") || program_id.equals("FR007W") || program_id.equals("FR008W") || program_id.equals("FR009W") ||
                program_id.equals("FR001W") || program_id.equals("FR002W") || program_id.equals("FR005W") || program_id.equals("FR004W_month") || program_id.equals("FR037W")){
                if(Program_Type.equals("6")){//農會
                   program_name ="農會"+program_name;
                }else if(Program_Type.equals("7")){//漁會
                   program_name ="漁會"+program_name;
                }
             }
             out.println("insDoc(foldersTree, gLnk(0, '<font size=2>"+program_name+"("+program_id+")</font><font size=1><br>&nbsp;</font>', '"+program_url+"'));");                                              
          }  		  
       }else{        
          //System.out.println("Program_Type !==");  
          if(i != 0){             
             //System.out.println("print initializeDocument");
             out.println("initializeDocument()");
			 			 out.println("foldersTree.setState(0)");			 
          }  
          if(menu.equals("BR") || menu.equals("FR") || menu.equals("DS") || menu.equals("EX") || menu.equals("OR") || menu.equals("FL")){//95.08.28 add 加上DS申報資料分析支援系統//101.07.18 add EX-資訊揭露/OR-公務用統計報表
             Program_Type = (String)((DataObject)dbData.get(i)).getValue("bank_type");
          }else if(menu.equals("TC")){   
             Program_Type = (String)((DataObject)dbData.get(i)).getValue("sub_type");
          }
          out.println("foldersTree = gFld('<font size=2>"+program_type_name+"</font>', ' ');");                    
          
          if(permission != null && permission.get("Q") != null && permission.get("Q").equals("Y")){                    	        	                                   		                           
             program_url = (program_url.indexOf("?") != -1)?program_url+"&":program_url+"?";
             program_url = program_url + "bank_type="+(String)((DataObject)dbData.get(i)).getValue("bank_type");    
             if( menu.equals("EX") || menu.equals("OR")){
               program_url += "&showEng=true";//101.07.18 add
             }	                                                 
             //94.02.16 fix 若為FR003W(資產負債表)/FR004W(損益表)/FR007W/FR008W/FR009W則加上農會/漁會至menu
             //94.02.24 fix 若為FR001W/FR002W/FR005W加上農會/漁會至menu by 2295
             if(program_id.equals("FR003W") || program_id.equals("FR004W") || program_id.equals("FR007W") || program_id.equals("FR008W") || program_id.equals("FR009W") ||
                program_id.equals("FR001W") || program_id.equals("FR002W") || program_id.equals("FR005W") || program_id.equals("FR004W_month") || program_id.equals("FR037W") ){             
                if(Program_Type.equals("6")){//農會
                   program_name ="農會"+program_name;
                }else if(Program_Type.equals("7")){//漁會
                   program_name ="漁會"+program_name;
                }
             }
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

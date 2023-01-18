<%
//95.09.29 create  2495	
//95.10.02 add 下載報表 by 2495
//95.10.17 增加 insert A01_LOG BY 2495 						  																	
//95.12.13 fix 讀取目前的BANK_TYPE by 2295
//102.01.21 fix A02_LOG 增加amt_name by 2295
//102.02.04 fix MIS讀取參數不同 by 2295
//108.03.27 add 報表格式挑選 by 2295
//108.05.31 add 增加ODT檔案轉換 by 2295
//110.09.03 fix 調整寫入A02_LOG失敗 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.RptFR0066W" %>
<%@ page import="com.tradevan.util.DBManager"%>	
<%@ page import="com.tradevan.util.transfer.rptTrans" %>
<%
   	System.out.println("FR006W_Excel.jsp Start...");
   	//95.12.13 fix 讀取目前的BANK_TYPE
   	String bank_type = ( request.getParameter("BANK_TYPE")==null ) ? "" : (String)request.getParameter("BANK_TYPE");//BOAF讀取
   	if(bank_type.equals("")){
	bank_type = ( request.getParameter("bankType")==null ) ? "" : (String)request.getParameter("bankType");//MIS讀取
	}
	System.out.println("bank_type ="+bank_type);

//   	response.setContentType("APPLICATION/msword;charset=Big5");//以上這行設定本網頁為excel格式的網頁
//	response.setContentType("application/octet-stream; charset=iso-8859-1");//以上這行設定本網頁為excel格式的網頁
        response.setContentType("application/octet-stream");//以上這行設定本網頁為excel格式的網頁
   	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");
   	System.out.println("act="+act);
	  String unit =request.getParameter("unit")==null?"":request.getParameter("unit");
	  System.out.println("unit = "+unit);
   	//String BANK_DATA = ( request.getParameter("BANK_NO")==null ) ? "" : (String)request.getParameter("BANK_NO");
   	//String BANK_NO = BANK_DATA.substring(0,BANK_DATA.indexOf("/"));
   	//String BANK_NAME = BANK_DATA.substring(BANK_DATA.indexOf("/")+1,BANK_DATA.length());
   	String BANK_NO = ( request.getParameter("BANK_NO")==null ) ? "" : (String)request.getParameter("BANK_NO");//BOAF讀取
   	if(BANK_NO.equals("") || BANK_NO == null){
   	   BANK_NO = ( request.getParameter("tbank")==null ) ? "" : (String)request.getParameter("tbank");//MIS讀取
	}
   	String S_YEAR = ( request.getParameter("S_YEAR")==null ) ? "" : (String)request.getParameter("S_YEAR");
   	String S_MONTH = ( request.getParameter("S_MONTH")==null ) ? "" : (String)request.getParameter("S_MONTH");
   	String printStyle = ( request.getParameter("printStyle")==null ) ? "rtf" : (String)request.getParameter("printStyle");//108.03.27 add   	
   	String muser_id = ( request.getParameter("muser_id")==null ) ? "" : (String)request.getParameter("muser_id");
    String muser_name = ( request.getParameter("muser_name")==null ) ? "" : (String)request.getParameter("muser_name");
   	System.out.println("FR0066W_Rtf.S_YEAR="+S_YEAR+":S_MONTH="+S_MONTH+":printStyle="+printStyle+":muser_id="+muser_id+":muser_name="+muser_name+":BANK_NO="+BANK_NO);
   	//System.out.println("BANK_NAME="+BANK_NAME);

		/*
   	String wordAction = request.getParameter("wordaction")==null  ? "" : request.getParameter("wordaction");
   	System.out.println("wordAction.equals ="+wordAction);
   	
   	if(wordAction.equals("view")){
   	   //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
   	   //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔
   	   response.setHeader("Content-disposition","inline; filename=view.rtf");
   	}else if (wordAction.equals("download")){
   	*/
   	   response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.03.27調整顯示的副檔名
   	//}
%>
<%
	try{
	    String actMsg = RptFR0066W.createRpt(S_YEAR,S_MONTH,BANK_NO,null,bank_type,null,false,"rtf");//108.03.27 fix
	    System.out.println("createRpt="+actMsg);
	    
	    String filename = (bank_type.equals("6")?"農":"漁")+"會各項法定比率表";
	    System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename+".rtf");
	    
	    if(printStyle.equalsIgnoreCase("pdf") || printStyle.equalsIgnoreCase("odt")) {//108.05.30 增加odt格式轉換	           
	    	if(printStyle.equalsIgnoreCase("pdf")) {//108.03.27pdf檔須執行轉換	                
	  			rptTrans rptTrans = new rptTrans();	  			
	  			filename = rptTrans.transOutputFormat ("w"+printStyle,filename+".rtf",""); 
	  			System.out.println("pdf-newfilename="+filename);	  			   
        	
        	};
        	if(printStyle.equalsIgnoreCase("odt")) {//108.05.31 增加odt檔轉換	          
        	   /*108.05.31      
        	   WordConverter odtTrans = new WordConverter();
        	   odtTrans.convertWordToOdt(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename+".rtf",Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename+".odt");		        
        	   filename = Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename+".odt";
        	   */
        	   rptTrans rptTrans = new rptTrans();	  			
	  		   filename = rptTrans.transOutputFormat (printStyle,filename+".rtf",""); 
	  		   System.out.println("odt-newfilename="+filename);	
        	}   	
        }else{
           filename +=".rtf";
        };
        System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
	    FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
	    
		ServletOutputStream out1 = response.getOutputStream();

		byte[] line = new byte[1024];
		int getBytes=0;
		while( ((getBytes=fin.read(line,0,1024)))!=-1 ){
			out1.write(line,0,getBytes);
			out1.flush();
	    }
		//關閉檔案
		fin.close();
		out1.close();
    //95.10.17 增加 insert A02_LOG BY 2495 	       
        String acc_code="ALL",atm="0",user_id_c="",user_name_c="",update_type_c="L";
        INSERT_A02_LOG(S_YEAR,S_MONTH,BANK_NO,acc_code,atm,muser_id,muser_name,update_type_c); 
	}catch(Exception e){
	   System.out.println(e.getMessage());
	}
	System.out.println("FR006W_Excel.jsp End...");
%>
<%!
	  //95.10.17 ADD insert A02_LOG BY 2495 
	  private String INSERT_A02_LOG(String m_year,String m_month,String bank_code,String acc_code,String atm,String user_id_c,String user_name_c,String update_type_c) throws Exception{    	
		String sqlCmd = "";		
		String errMsg="";		
		
		try {
				List updateDBSqlList = new LinkedList();								   				   
				//insert A02_LOG===================================================		    
				sqlCmd = "INSERT INTO A02_LOG VALUES ("+m_year
				      	   + ",'" + m_month + "'" 					       
				           + ",'" + bank_code + "'" 
					   + ",'" + acc_code + "'" 					       
				           + ",'" + atm + "'" 
				      	   + ",'" + user_id_c + "'" 					       
				           + ",'" + user_name_c + "'" 
					   + ",sysdate" 					       
				           + ",'" + update_type_c + "','','','')" ;				
				          			           
			 								   
				updateDBSqlList.add(sqlCmd);	
					            		            		
				if(DBManager.updateDB(updateDBSqlList)){
				errMsg = errMsg + "無法寫入A02_log資料";					
				}else{
				  	errMsg = errMsg + "無法寫入A02_log資料";;
				}    	   		
		}catch (Exception e){
				System.out.println(e+":"+e.getMessage());
				errMsg = errMsg + "無法寫入A02_log資料<br>[Exception Error]";								
		}	

		return errMsg;
	}  			
%>
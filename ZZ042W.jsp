﻿<%
// 94.12.13 create by 2295
// 94.12.28 add 將已下載完成的檔案包成zip 
// 95.03.16.21 fix sql by 2295
// 99.12.10 fix sqlInjection by 2808
//100.02.16 fix 查無資料 by 2295
//100.02.18 fix FR002WA_STDET查無資料 by 2295
//105.03.18 add FR003W/FR004W開放給縣市政府查詢(只能查詢其轄區下的信用部) by 2295
//106.10.03 add 增加轉換前代碼查詢 by 2295
//107.02.05 add 無法依縣市別查詢 by 2295
//108.03.20 add 報表格式轉換 by 2295
//110.06.29 add 取消使用FTP改用SFTP上傳檔案 by 2295   
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.ftp.MyFTPClient" %>
<%@ page import="com.tradevan.util.sftp.MySFTPClient" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.StringTokenizer" %>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>
<%
	RequestDispatcher rd = null;
	String ftpMsg = "";
	String actMsg = "";	
	String alertMsg = "";	
	String webURL = "";	
	boolean doProcess = false;	
	
	//取得session資料,取得成功時,才繼續往下執行===================================================
	if(session.getAttribute("muser_id") == null){//session timeout	
       System.out.println("ZZ042W login timeout");   
	   rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );         	   
	   try{
          rd.forward(request,response);
       }catch(Exception e){
          System.out.println("forward Error:"+e+e.getMessage());
       }
    }else{
      doProcess = true;
    }    
	if(doProcess){//若muser_id資料時,表示登入成功====================================================================	
	
	String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");				
	
	
	System.out.println("act="+act);	
   
	//登入者資訊
	String lguser_id = ( session.getAttribute("muser_id")==null ) ? "" : (String)session.getAttribute("muser_id");		
	String lguser_name = ( session.getAttribute("muser_name")==null ) ? "" : (String)session.getAttribute("muser_name");		
	String lguser_type = ( session.getAttribute("muser_type")==null ) ? "" : (String)session.getAttribute("muser_type");				
	String lguser_tbank_no = ( session.getAttribute("tbank_no")==null ) ? "" : (String)session.getAttribute("tbank_no");			
	session.setAttribute("nowtbank_no",null);//94.01.05 fix 沒有Bank_List,把所點選的Bank_no清除======	
	String bank_type = ( session.getAttribute("bank_type")==null ) ? "" : (String)session.getAttribute("bank_type");				
			
	String szrpt_code = ( request.getParameter("RPT_CODE")==null ) ? "" : (String)request.getParameter("RPT_CODE");				
    String szrpt_output_type = ( request.getParameter("RPT_OUTPUT_TYPE")==null ) ? "" : (String)request.getParameter("RPT_OUTPUT_TYPE");				
    String szhsien_id = ( request.getParameter("HSIEN_ID")==null ) ? "" : (String)request.getParameter("HSIEN_ID");				
    String S_YEAR = ( request.getParameter("S_YEAR")==null ) ? "" : (String)request.getParameter("S_YEAR");				
    String S_MONTH = ( request.getParameter("S_MONTH")==null ) ? "" : (String)request.getParameter("S_MONTH");				
    String E_YEAR = ( request.getParameter("E_YEAR")==null ) ? "" : (String)request.getParameter("E_YEAR");				
    String E_MONTH = ( request.getParameter("E_MONTH")==null ) ? "" : (String)request.getParameter("E_MONTH");				
    String szrpt_sort = ( request.getParameter("RPT_SORT")==null ) ? "" : (String)request.getParameter("RPT_SORT");				
    String firstStatus = ( request.getParameter("firstStatus")==null ) ? "" : (String)request.getParameter("firstStatus");			    	
    String filename = ( request.getParameter("filename")==null ) ? "" : (String)request.getParameter("filename");			    	
    String yyymm = ( request.getParameter("yyymm")==null ) ? "" : (String)request.getParameter("yyymm");
    String printStyle = ( request.getParameter("printStyle")==null ) ? "xls" : (String)request.getParameter("printStyle");//108.03.20 add
    			    	
    System.out.println("ZZ042W.szrpt_code="+szrpt_code);		    
	System.out.println("ZZ042W.szrpt_output_type="+szrpt_output_type);		    
	System.out.println("ZZ042W.szrpt_sort="+szrpt_sort);		    
	System.out.println("ZZ042W.szhsien_id="+szhsien_id);		    
	System.out.println("ZZ042W.S_YEAR="+S_YEAR);		    
	System.out.println("ZZ042W.S_MONTH="+S_MONTH);		    
	System.out.println("ZZ042W.E_YEAR="+E_YEAR);		    
	System.out.println("ZZ042W.E_MONTH="+E_MONTH);
    System.out.println("ZZ042W.printStyle="+printStyle);
		
	String rptIP=Utility.getProperties("rptIP");			
	String rptID=Utility.getProperties("rptID");			
	String rptPwd=Utility.getProperties("rptPwd");	
    List filename_List  = new LinkedList();	
    if(!CheckPermission(request)){//無權限時,導向到LoginError.jsp
        rd = application.getRequestDispatcher( LoginErrorPgName );        
    }else{            
    	//set next jsp 	    	
    	if(act.equals("Qry")){                    	        	    
    	    rd = application.getRequestDispatcher( ListPgName +"?act=Qry&firstStatus="+firstStatus);            	        	        	    	    
    	}else if(act.equals("List")){                    	    
    	    List dbData = getQryResult(bank_type,lguser_tbank_no,szrpt_code,szrpt_output_type,szhsien_id,S_YEAR,S_MONTH,E_YEAR,E_MONTH,szrpt_sort,lguser_id);    	       
    	    request.setAttribute("reportList",dbData);    	     	        	        	     	    
    	    rd = application.getRequestDispatcher( ListPgName +"?act=Qry&RPT_CODE="+szrpt_code+"&RPT_OUTPUT_TYPE="+szrpt_output_type+"&HSIEN_ID="+szhsien_id+"&S_YEAR="+S_YEAR+"&S_MONTH="+S_MONTH+"&E_YEAR="+E_YEAR+"&E_MONTH="+E_MONTH+"&RPT_SORT="+szrpt_sort+"&printStyle="+printStyle);            	        	        	    	    
    	}else if(act.equals("Download")){
    	     File ClientRptDir = new File(Utility.getProperties("ClientRptDir"));        
	         if(!ClientRptDir.exists()){
         		if(!Utility.mkdirs(Utility.getProperties("ClientRptDir"))){
         	   		actMsg=actMsg+Utility.getProperties("ClientRptDir")+"目錄新增失敗";
         		}    
        	 }
        	 if(actMsg.equals("")){
    	     	System.out.println("Download.filename="+filename);
    	     	
    	     	filename_List.add(filename);    
    	     	MySFTPClient msftp = new MySFTPClient(rptIP, rptID, rptPwd);//110.06.29 add	使用SFTP上傳     
    	     	//MyFTPClient ftpC = new MyFTPClient(rptIP, rptID, rptPwd);//110.06.29 fix 取消使用FTP上傳   	     
    	     	boolean downloadSuccess = false;//110.06.29 add
    	     	System.out.println("serverRptDir="+Utility.getProperties("serverRptDir")+szrpt_code+"/"+yyymm);
    	     	System.out.println("ClientRptDir="+Utility.getProperties("ClientRptDir")+System.getProperty("file.separator"));
    	     	
    	     	downloadSuccess = msftp.getMyFiles(Utility.getProperties("serverRptDir")+szrpt_code+"/"+yyymm, Utility.getProperties("ClientRptDir")+System.getProperty("file.separator"), filename);
    	     	System.out.println(filename+(downloadSuccess==true?"檔案下載完成":"檔案下載失敗")); 
             	//actMsg = ftpC.getFiles(Utility.getProperties("serverRptDir")+szrpt_code+"/"+yyymm, Utility.getProperties("ClientRptDir")+System.getProperty("file.separator"),filename_List);//110.06.29 fix                                       
             	
             	if(!printStyle.equalsIgnoreCase("xls")) {//108.03.20非xls檔須執行轉換	                
	  			   rptTrans rptTrans = new rptTrans();	  			
	  			   filename = rptTrans.transOutputFormat (printStyle,filename,Utility.getProperties("ClientRptDir")); 
	  			   System.out.println("newfilename="+filename);	  			   
                };
             	
             	
             	response.setContentType("multipart/form-data;charset=UTF-8;Content-Transfer-Encoding=8bit;");
	         	//response.setHeader("Content-Disposition","filename=" + filename + ";size=100;charset=8859_1;Content-Transfer-Encoding=8bit;");
	         	response.setHeader("Content-Disposition","attachment; filename="+filename);
	         
             	FileInputStream fin = new FileInputStream(Utility.getProperties("ClientRptDir")+System.getProperty("file.separator")+filename);  		 
			 	ServletOutputStream out1 = response.getOutputStream();           
			 	byte[] line = new byte[8196];
			 	int getBytes=0;
			 	while( ((getBytes=fin.read(line,0,8196)))!=-1 ){		    		
					out1.write(line,0,getBytes);
					out1.flush();
	    	 	}
	    	 	fin.close();
			 	out1.close();       			 
			 	File tmpFile = new File(Utility.getProperties("ClientRptDir")+System.getProperty("file.separator")+filename);
			 	if(tmpFile.exists()) tmpFile.delete();
			 	//ftpC=null;                   
			 	msftp=null;
			 }
		}else if(act.equals("MultiFiles")){
		        //取出form裡的所有變數=================================== 
		  	    Enumeration ep = request.getParameterNames();
		  		Enumeration ea = request.getAttributeNames();
		  		Hashtable t = new Hashtable();
		  		String name = "";
		  
		  		for ( ; ep.hasMoreElements() ; ) {
			   		name = (String)ep.nextElement();
			   		t.put( name, request.getParameter(name) );			   
		  		}		  
		  		int row =Integer.parseInt((String)t.get("row"));
		  		System.out.println("row="+row);
		  	    List rptData = new LinkedList();
		  		for ( int i = 0; i < row; i++) {		  	    		  	  			  
					if ( t.get("isModify_" + (i+1)) != null ) {					  
					     rptData.add((String)t.get("isModify_"+(i+1)));
					}										
		  		}	
		  		System.out.println("rptData.size="+rptData.size());		  					    
			    
         		//File rptDir = new File(Utility.getProperties("rptDir")+System.getProperty("file.separator"));        
		  		
        		
		  		if(actMsg.equals("")){
		  		   List downloadRptData = null;
		  		   File ClientRptDir = null;
		  		   MySFTPClient msftp = new MySFTPClient(rptIP, rptID, rptPwd);//110.06.29 add	使用SFTP上傳     
		  		   boolean downloadSuccess = false;//110.06.29 add
		  		   //MyFTPClient ftpC = new MyFTPClient(rptIP, rptID, rptPwd); //110.06.29 fix 取消使用FTP上傳   	    	     
		  		   for(int i=0;i<rptData.size();i++){					       			        		  		    
		  		       yyymm="";
		  		       yyymm = ((String)rptData.get(i)).substring(0,((String)rptData.get(i)).indexOf(":"));  
		  		       ClientRptDir = new File(Utility.getProperties("ClientRptDir")+System.getProperty("file.separator")+szrpt_code+System.getProperty("file.separator")+yyymm);        
	        		   if(!ClientRptDir.exists()){
         				   if(!Utility.mkdirs(Utility.getProperties("ClientRptDir"))){
         		   		       actMsg=actMsg+Utility.getProperties("ClientRptDir")+"目錄新增失敗";
         			       }    
        		       }
		  		       filename = ((String)rptData.get(i)).substring(((String)rptData.get(i)).indexOf(":")+1,((String)rptData.get(i)).length());           			
         			   System.out.println("MultiFiles.filename="+filename);
         			   System.out.println("MultiFiles.yyymm="+yyymm);
    	     	       System.out.println("serverRptDir="+Utility.getProperties("serverRptDir")+szrpt_code+"/"+yyymm);
    	               System.out.println("ClientRptDir="+Utility.getProperties("ClientRptDir")+System.getProperty("file.separator")+szrpt_code+System.getProperty("file.separator")+yyymm);
    	               downloadRptData = new LinkedList();
    	               downloadRptData.add(filename);
    	               
    	               downloadSuccess = msftp.getMyFiles(Utility.getProperties("serverRptDir")+szrpt_code+"/"+yyymm, Utility.getProperties("ClientRptDir")+System.getProperty("file.separator")+szrpt_code+System.getProperty("file.separator")+yyymm, filename);
    	               System.out.println(filename+(downloadSuccess==true?"檔案下載完成":"檔案下載失敗")); 
              	               
    	               //ftpMsg = ftpC.getFiles(Utility.getProperties("serverRptDir")+szrpt_code+"/"+yyymm, Utility.getProperties("ClientRptDir")+System.getProperty("file.separator")+szrpt_code+System.getProperty("file.separator")+yyymm,downloadRptData);
    	               
                       //if( ftpMsg != null){ //110.06.29                      
                       if(!downloadSuccess){  //110.02.29                     
         			      actMsg += Utility.getProperties("ClientRptDir")+System.getProperty("file.separator")+szrpt_code+System.getProperty("file.separator")+yyymm+System.getProperty("file.separator")+filename+"儲存失敗[錯誤原因]"+ftpMsg+"<br>";     	         			   
                       }else{
                          actMsg += Utility.getProperties("ClientRptDir")+System.getProperty("file.separator")+szrpt_code+System.getProperty("file.separator")+yyymm+System.getProperty("file.separator")+filename+"儲存完成<br>";     	         			   
                          filename_List.add(Utility.getProperties("ClientRptDir")+System.getProperty("file.separator")+szrpt_code+System.getProperty("file.separator")+yyymm+System.getProperty("file.separator")+filename);
                       }                                                
                   }//end of filename
                   //94.12.28 add 將已下載完成的檔案包成zip==========================================================
                   if(actMsg.indexOf("儲存完成") != -1){
                      File tmpFile = null;
                      if(!msftp.CreateZIP(Utility.getProperties("ClientRptDir")+System.getProperty("file.separator"),filename_List)){
                		  actMsg += "無法建立zip file";
            		  }else{
            		     for(int i=0;i<filename_List.size();i++){
            		         tmpFile = new File((String)filename_List.get(i));
			 		  	     if(tmpFile.exists()) tmpFile.delete();            		   
            		     }
            		  }   
            		  //ftpC=null;//110.06.29 fix 
                      response.setContentType("multipart/form-data;charset=UTF-8;Content-Transfer-Encoding=8bit;");	         	
	         		  response.setHeader("Content-Disposition","attachment; filename=outfile.zip");	         
             		  FileInputStream fin = new FileInputStream(Utility.getProperties("ClientRptDir")+System.getProperty("file.separator")+"outfile.zip");  		 
			 		  ServletOutputStream out1 = response.getOutputStream();           
			 		  byte[] line = new byte[8196];
			 		  int getBytes=0;
			 		  while( ((getBytes=fin.read(line,0,8196)))!=-1 ){		    		
					 	 out1.write(line,0,getBytes);
					  	 out1.flush();
	    	 		  }
	    	 		  fin.close();
			 		  out1.close();       			 
			 		  tmpFile = new File(Utility.getProperties("ClientRptDir")+System.getProperty("file.separator")+"outfile.zip");
			 		  if(tmpFile.exists()) tmpFile.delete();
			 		}  
			 		//==============================================================================================
		  		}
         	   rd = application.getRequestDispatcher( nextPgName );                       
    	}	     	
    	request.setAttribute("actMsg",actMsg);    
    }        
     
%>

<%
	try {
        //forward to next present jsp
        rd.forward(request, response);
    } catch (NullPointerException npe) {
    }
    }//end of doProcess
%>


<%!
    private final static String nextPgName = "/pages/ActMsg.jsp";        
    private final static String ListPgName = "/pages/ZZ042W_List.jsp";        
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
    private boolean CheckPermission(HttpServletRequest request){//檢核權限    	    
    	    boolean CheckOK=false;
    	    HttpSession session = request.getSession();            
            Properties permission = ( session.getAttribute("ZZ042W")==null ) ? new Properties() : (Properties)session.getAttribute("ZZ042W");				                
            if(permission == null){
              System.out.println("ZZ042W.permission == null");
            }else{
               System.out.println("ZZ042W.permission.size ="+permission.size());
               
            }
            //只要有Query的權限,就可以進入畫面
        	if(permission != null && permission.get("Q") != null && permission.get("Q").equals("Y")){            
        	   CheckOK = true;//Query
        	}
        	return CheckOK;
    }
    
    //取得查詢結果
    //100.02.16 fix 查無資料 by 2295
    //100.02.18 fix FR002WA_STDET查無資料 by 2295
    //105.03.18 add FR003W/FR004W開放給縣市政府查詢(只能查詢其轄區下的信用部) by 2295
    private List getQryResult(String bank_type,String bank_code,String szrpt_code,String szrpt_output_type,String szhsien_id,String S_YEAR,String S_MONTH,String E_YEAR,String E_MONTH,String szrpt_sort,String lguser_id){    	       
    		//查詢條件        		
    		String sqlCmd = "";
    		List paramList =new ArrayList() ;
    		String yy = Integer.parseInt(S_YEAR) > 99 ?"100" :"99" ;
    		String cd01Table = Integer.parseInt(S_YEAR) > 99 ?"cd01" :"cd01_99" ;
            String tmp_openbankno="";
            String ori_bank_no="";//106.10.03 add
            String rpt_include="";
            if(lguser_id.equals("A111111111")){
               tmp_openbankno="9999999";               
            }else if(bank_type.equals("6") || bank_type.equals("7") || bank_type.equals("B")){
               tmp_openbankno=bank_code;
            }else{
               tmp_openbankno="9999999";
            }
            
            System.out.println("bank_type="+bank_type);
            sqlCmd = " select  distinct  rpt_code,rpt_name,rpt_output_type,rpt_include "
		   		   + " from rpt_nof "
		   		   + " where rpt_code =? "	       
	       		   + " order by  rpt_code";
            paramList.add(szrpt_code) ;
    		List rpt_nof_List = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");
    		
    		//106.10.03 add
    		sqlCmd = " select bank_no,ori_bank_no,trans_date from bn01 where m_year=? and bank_no=?";     
    		paramList.clear() ; 
            paramList.add(yy) ;
            paramList.add(bank_code) ;
    		List bank_no_List = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"trans_date");
    		if(bank_no_List != null && bank_no_List.size() != 0){
    		   ori_bank_no = (String)((DataObject)bank_no_List.get(0)).getValue("ori_bank_no");
    		}
    		    		
    		paramList.clear() ;
    		if(rpt_nof_List != null && rpt_nof_List.size() != 0){
    		   rpt_include = (String)((DataObject)rpt_nof_List.get(0)).getValue("rpt_include");
    		}
    		    		
    		if(rpt_include.equals("X") || rpt_include.equals("B")){//X:各信用別單一家明細 B:地方主管機關
    			System.out.println("test1");
    			if(szrpt_code.equals("FR002WA_STDET")){//B:地方主管機關and rpt_code=FR002WA_STDET
    			System.out.println("test2");
    		      sqlCmd = " select * from "
    		             + " ( "
    		             + " select (BN01.bank_no || BN01.bank_name)  as S_Report_Name,"
       				     + " decode(SUBSTR(rpt_dirf.rpt_fname,1,1),'6','農會','7','漁會','農漁會')   as S_BankType_Name,"
				         + " (to_char(rpt_dirf.m_year)|| LPAD(to_char(rpt_dirf.m_month),2,'0')) as S_yymm,"
					     + " rpt_dirf.rpt_fname, "     
					     + " ((to_char(rpt_dirf.UPDATE_DATE,'yyyymmdd')-19110000)  ||  to_char(rpt_dirf.UPDATE_DATE,' hh24:mi'))  as S_UpdateDate,"
					     + " ' '  as  S_SORT "	
					     + " from " 
     			         + " (select * from rpt_dirf "
	  				     + " where rpt_dirf.rpt_code = ? "	
	  				     + " and ( (rpt_dirf.m_year * 100 + rpt_dirf.m_month) >= ?" 
					     + " and   (rpt_dirf.m_year * 100 + rpt_dirf.m_month) <= ?) "					          			  
					     + " and ((? ='ALL') OR (?='6' and  SUBSTR(RPT_DIRF.rpt_fname,1,1) =  '6')"
					     + " or (?='7' and  SUBSTR(RPT_DIRF.rpt_fname,1,1) =  '7')) "        			  
					     + " and ((? = 'ALL')  or "
        			     + "      (SUBSTR(RPT_DIRF.RPT_Fname,4,1) =?)"
        			     + "     )"
        			     + " ) rpt_dirf "
    		   		     + " left join  (select * from bn01 where m_year=? )bn01 on "    		   		  
    		   		     + "     ((? =  '9999999') OR "
 					     + "      (SUBSTR(RPT_DIRF.rpt_fname,4,7) = ? ) ) "
 					     + " and  (SUBSTR(RPT_DIRF.rpt_fname,2,1) in ('6', '7', 'B' ) and "
 				         + "       (SUBSTR(RPT_DIRF.rpt_fname,4,7) = BN01.BANK_NO or SUBSTR(RPT_DIRF.rpt_fname,4,7) = BN01.ORI_BANK_NO) ) "//106.10.03 add 轉換前的bank_no        
 				         + " ) temp_result where S_Report_Name <> ' '"; 	
 				   paramList.add(szrpt_code) ; 				   
 				   paramList.add(S_YEAR+S_MONTH) ;
 				   paramList.add(E_YEAR+E_MONTH) ; 				   
 				   paramList.add(szrpt_output_type) ;
 				   paramList.add(szrpt_output_type) ;
 				   paramList.add(szrpt_output_type) ;
 				   paramList.add(szhsien_id) ;
 				   paramList.add(szhsien_id) ; 				
 				   paramList.add(yy) ;
 				   paramList.add(tmp_openbankno) ;
 				   paramList.add(tmp_openbankno) ;
    		   }else if(bank_type.equals("B") && (szrpt_code.equals("FR003W_DET") || szrpt_code.equals("FR004W_DET"))){//105.03.18 add FR003W/FR004W開放給縣市政府查詢(只能查詢其轄區下的信用部)
    		   	//B:地方主管機關and rpt_code=FR003W_DET/FR004W_DET
    		   	System.out.println("test3");
    		      sqlCmd = " select * from "
    		             + " ( "
    		             + " select (BN01.bank_no || BN01.bank_name)  as S_Report_Name,"
       				     + " decode(SUBSTR(rpt_dirf.rpt_fname,1,1),'6','農會','7','漁會','農漁會')   as S_BankType_Name,"
				         + " (to_char(rpt_dirf.m_year)|| LPAD(to_char(rpt_dirf.m_month),2,'0')) as S_yymm,"
					     + " rpt_dirf.rpt_fname, "     
					     + " ((to_char(rpt_dirf.UPDATE_DATE,'yyyymmdd')-19110000)  ||  to_char(rpt_dirf.UPDATE_DATE,' hh24:mi'))  as S_UpdateDate,"
					     + " ' '  as  S_SORT "	
					     + " from " 
     			         + " (select * from rpt_dirf "
	  				     + " where rpt_dirf.rpt_code = ? "	
	  				     + " and ( (rpt_dirf.m_year * 100 + rpt_dirf.m_month) >= ?" 
					     + " and   (rpt_dirf.m_year * 100 + rpt_dirf.m_month) <= ?) "	
				         + " ) rpt_dirf "
    		   		     + " left join  (select bn01.* from bn01 left join (select * from wlx01 where m_year=?)wlx01 on bn01.bank_no = wlx01.bank_no"
    		   	         + " where bn01.m_year=? and wlx01.m2_name  =? )bn01 on ("
    		   	         + " ((?='6' and SUBSTR(RPT_DIRF.rpt_fname,2,1) in ('6')) or   (?='7' and SUBSTR(RPT_DIRF.rpt_fname,2,1) in ('7')) or  (?='ALL' and SUBSTR(RPT_DIRF.rpt_fname,2,1) in ('6','7','B')) )"
    		   	         + " and (SUBSTR(RPT_DIRF.rpt_fname,4,7) = BN01.BANK_NO or SUBSTR(RPT_DIRF.rpt_fname,4,7) = BN01.ORI_BANK_NO) ) " //106.10.03 add 轉換前的bank_no         
 				         + " ) temp_result where S_Report_Name <> ' '"; 	
 				   paramList.add(szrpt_code) ; 				   
 				   paramList.add(S_YEAR+S_MONTH) ;
 				   paramList.add(E_YEAR+E_MONTH) ;
 				   paramList.add(yy) ;		
 				   paramList.add(yy) ;//105.03.17 add
 				   paramList.add(tmp_openbankno) ;//105.03.17 add 	
 				   paramList.add(szrpt_output_type) ;//105.03.18 add 
 				   paramList.add(szrpt_output_type) ;//105.03.18 add 	
 				   paramList.add(szrpt_output_type) ;//105.03.18 add  			   
    		   }else{
    		   	System.out.println("test4");
    		   	  //各別單一機構
    		   	  //X:各信用別單一家明細
    		      sqlCmd = " select * from "
    		             + " ( "
    		             + " select (BN01.bank_no || BN01.bank_name)  as S_Report_Name,"
       				     + " decode(SUBSTR(rpt_dirf.rpt_fname,1,1),'6','農會','7','漁會','農漁會')   as S_BankType_Name,"
				         + " (to_char(rpt_dirf.m_year)|| LPAD(to_char(rpt_dirf.m_month),2,'0')) as S_yymm,"
					     + " rpt_dirf.rpt_fname, "     
					     + " ((to_char(rpt_dirf.UPDATE_DATE,'yyyymmdd')-19110000)  ||  to_char(rpt_dirf.UPDATE_DATE,' hh24:mi'))  as S_UpdateDate,"
					     + " nvl(fr001w_output_order, ' ') as  S_SORT "
					     + " from " 
     			         + " (select * from rpt_dirf "
	  				     + " where rpt_dirf.rpt_code = ? "	
	  				     + " and ( (rpt_dirf.m_year * 100 + rpt_dirf.m_month) >= ?" 
					     + " and   (rpt_dirf.m_year * 100 + rpt_dirf.m_month) <= ?)"					          			  
					     + " and ((? ='ALL') OR (?='6' and  SUBSTR(RPT_DIRF.rpt_fname,1,1) =  '6')"
					     + " or (?='7' and  SUBSTR(RPT_DIRF.rpt_fname,1,1) =  '7')) " 
					     + " ) rpt_dirf "
    		   		     + " left join (select * from bn01 where m_year=? ) bn01 on "    		   		  
    		   		     + "     ((? =  '9999999') OR "
 					     + "      (SUBSTR(RPT_DIRF.rpt_fname,4,7) = ? ) OR "
 					     + "      (SUBSTR(RPT_DIRF.rpt_fname,4,7) = ? )) " //106.10.03 add 轉換前的bank_no
 					     + " and  (SUBSTR(RPT_DIRF.rpt_fname,2,1) in ('6', '7', 'B' ) and "
 				         + "      (SUBSTR(RPT_DIRF.rpt_fname,4,7) = BN01.BANK_NO or SUBSTR(RPT_DIRF.rpt_fname,4,7) = BN01.ORI_BANK_NO)) "//106.10.03 add 轉換前的bank_no                   
      				     + " left join "
           			     + " (select distinct BANK_NO, ORI_BANK_NO,TRANS_DATE,fr001w_output_order, WLX01.HSIEN_ID  "//106.10.03 add 轉換前的bank_no  
		      		     + " from  (select wlx01.*,bn01.ori_bank_no,bn01.trans_date from (select * from wlx01 where m_year=?)wlx01 left join (select * from bn01 where m_year=?)bn01 on wlx01.bank_no=bn01.bank_no )wlx01, "+cd01Table+" cd01 where WLX01.HSIEN_ID = CD01.HSIEN_ID ORDER BY BANK_NO) wlx01 "
		      		     + " on (SUBSTR(RPT_DIRF.rpt_fname,4,7) = WLX01.BANK_NO  or SUBSTR(RPT_DIRF.rpt_fname,4,7) = WLX01.ORI_BANK_NO) "//106.10.03 add 轉換前的bank_no //107.02.05 fix 無法依縣市別查詢明細                  
		      		     + " and ((? = 'ALL')  or "   		  			     
		  			     + "     (WLX01.HSIEN_ID = ?))"      
		  			     + " ) temp_result where S_Report_Name <> ' ' and s_sort <> ' '";
		  		   paramList.add(szrpt_code) ;		  		   
 				   paramList.add(S_YEAR+S_MONTH) ;
 				   paramList.add(E_YEAR+E_MONTH) ;
		  		   paramList.add(szrpt_output_type) ;
		  		   paramList.add(szrpt_output_type) ;
		  		   paramList.add(szrpt_output_type) ;
		  		   paramList.add(yy);
		  		   paramList.add(tmp_openbankno);
		  		   paramList.add(tmp_openbankno);
		  		   paramList.add(ori_bank_no);//106.10.03 add
		  		   paramList.add(yy);
		  		   paramList.add(yy);
		  		   paramList.add(szhsien_id) ;
		  		   paramList.add(szhsien_id) ;
    		   }

 		       /*
    		   sqlCmd = " select * from "
    		          + " ( "
    		          + " select (BN01.bank_no || BN01.bank_name)  as S_Report_Name,"
       				  + " decode(SUBSTR(rpt_dirf.rpt_fname,1,1),'6','農會','7','漁會','農漁會')   as S_BankType_Name,"
				      + " (to_char(rpt_dirf.m_year)|| LPAD(to_char(rpt_dirf.m_month),2,'0')) as S_yymm,"
					  + " rpt_dirf.rpt_fname, "     
					  + " ((to_char(rpt_dirf.UPDATE_DATE,'yyyymmdd')-19110000)  ||  to_char(rpt_dirf.UPDATE_DATE,' hh24:mi'))  as S_UpdateDate,"
					  + " nvl(fr001w_output_order, '   ') as  S_SORT "			
					  + " from " 
     			      + " (select * from rpt_dirf "
	  				  + " where rpt_dirf.rpt_code = '"+szrpt_code+"'"	
	  				  + " and ( to_char(rpt_dirf.m_year * 100 + rpt_dirf.m_month) >= "+S_YEAR+S_MONTH 
					  + " and   to_char(rpt_dirf.m_year * 100 + rpt_dirf.m_month) <= "+E_YEAR+E_MONTH + ")"					          			  
					  + " and (('"+szrpt_output_type + "' ='ALL') OR ('"+szrpt_output_type + "'='6' and  SUBSTR(RPT_DIRF.rpt_fname,1,1) =  '6')"
					  + " or ('"+szrpt_output_type + "'='7' and  SUBSTR(RPT_DIRF.rpt_fname,1,1) =  '7')) "        			  
					  + " and ( RPT_DIRF.RPT_Code ='"+szrpt_code+"' and "
				      + "     (('"+szhsien_id+"' = 'ALL')  or "
        			  + "      (SUBSTR(RPT_DIRF.RPT_Fname,4,1) = '"+szhsien_id+"'))"
        			  + "     )"
        			  + " ) rpt_dirf "
    		   		  + " left join  bn01 on "    		   		  
    		   		  + "     (('"+tmp_openbankno+"' =  '9999999') OR "
 					  + "      (SUBSTR(RPT_DIRF.rpt_fname,4,7) = '"+tmp_openbankno+"' ) ) "
 					  + " and  (SUBSTR(RPT_DIRF.rpt_fname,2,1) in ('6', '7', 'B' ) and "
 				      + "       SUBSTR(RPT_DIRF.rpt_fname,4,7) = BN01.BANK_NO ) "          
      				  + " left join "
           			  + " (select distinct BANK_NO, fr001w_output_order, WLX01.HSIEN_ID  "
		      		  + " from  wlx01, cd01 where WLX01.HSIEN_ID = CD01.HSIEN_ID) wlx01 "
          			  + " on "
		  			  + " SUBSTR(RPT_DIRF.rpt_fname,4,7) = WLX01.BANK_NO       and  "
		  			  + " (('"+szhsien_id+"' = 'ALL')  or "   
		  			  + " (WLX01.HSIEN_ID = '"+szhsien_id+"'))"      
		              + "  ) temp_result where S_Report_Name <> ' '"; 	
    		   */
    		   /*
    		   sqlCmd = " select (BN01.bank_no || BN01.bank_name)  as S_Report_Name,"
       				  + " decode(SUBSTR(rpt_dirf.rpt_fname,1,1),'6','農會','7','漁會','農漁會')   as S_BankType_Name,"
				      + " (to_char(rpt_dirf.m_year)|| LPAD(to_char(rpt_dirf.m_month),2,'0')) as S_yymm,"
					  + " rpt_dirf.rpt_fname, "     
					  + " ((to_char(rpt_dirf.UPDATE_DATE,'yyyymmdd')-19110000)  ||  to_char(rpt_dirf.UPDATE_DATE,' hh24:mi'))  as S_UpdateDate,"
					  + " nvl(fr001w_output_order, '   ') as  S_SORT "					  
					  + " from rpt_dirf,bn01,wlx01,cd01"
				      + " where rpt_dirf.rpt_code = '"+szrpt_code+"'"				      
				      + " and to_char(rpt_dirf.m_year * 100 + rpt_dirf.m_month) >= "+S_YEAR+S_MONTH 
					  + " and to_char(rpt_dirf.m_year * 100 + rpt_dirf.m_month) <= "+E_YEAR+E_MONTH
					  + " and (('"+szrpt_output_type + "' ='ALL') OR ('"+szrpt_output_type + "'='6' and  SUBSTR(RPT_DIRF.rpt_fname,1,1) =  '6')"
                      + " or ('"+szrpt_output_type + "'='7' and  SUBSTR(RPT_DIRF.rpt_fname,1,1) =  '7')) "
                      + " and (('"+tmp_openbankno+"' =  '9999999') OR "
 					  + "      (SUBSTR(RPT_DIRF.rpt_fname,4,7) = '"+tmp_openbankno+"' ) )  and"
				      + "      (SUBSTR(RPT_DIRF.rpt_fname,2,1) in ('6', '7', 'B' ) "
 				      + " and SUBSTR(RPT_DIRF.rpt_fname,4,7) = BN01.BANK_NO ) "    
 				      + " and (( RPT_DIRF.RPT_Code ='"+szrpt_code+"' and "
				      + " (('"+szhsien_id+"' = 'ALL')  or "
				      + " (SUBSTR(RPT_DIRF.RPT_Fname,4,1) = '"+szhsien_id+"'))"
            		  + " )"
 				      + " OR (SUBSTR(RPT_DIRF.rpt_fname,4,7) = WLX01.BANK_NO  "
 				      + " and WLX01.HSIEN_ID = CD01.HSIEN_ID "
 				      + " and (('"+szhsien_id+"' = 'ALL') or (WLX01.HSIEN_ID = '"+szhsien_id+"')))"					 
 				      + " )";
 				 */     
			    if(szrpt_sort.equals("1")){
			       sqlCmd += " order by s_sort,s_report_name,s_banktype_name,s_yymm";
			    }else if(szrpt_sort.equals("2")){
			       sqlCmd += " order by s_sort,s_report_name,s_yymm,s_banktype_name";
			    }else if(szrpt_sort.equals("3")){
			       sqlCmd += " order by s_yymm,s_sort,s_report_name,s_banktype_name";
			    }
    		}else{    			
    			System.out.println("test5");
    		   sqlCmd = " select  RPT_NOF.rpt_name  as S_Report_Name,"
       				  + " decode(SUBSTR(RPT_DIRF.rpt_fname,1,1), '6',  '農會','7','漁會', '農漁會')   as S_BankType_Name,"
					  + " (to_char(RPT_DIRF.m_year)|| LPAD(to_char(RPT_DIRF.m_month),2,'0')) as S_yymm,"					  
					  + " RPT_DIRF. rpt_fname,"      
					  + " ((to_char(RPT_DIRF.UPDATE_DATE,'yyyymmdd')-19110000)  ||  to_char(RPT_DIRF.UPDATE_DATE,' hh24:mi'))  as S_UpdateDate"
					  + " from RPT_DIRF,RPT_NOF"
					  + " where RPT_DIRF.rpt_code = ?"
					  + " and (rpt_dirf.m_year * 100 + rpt_dirf.m_month) >= ?" 
					  + " and (rpt_dirf.m_year * 100 + rpt_dirf.m_month) <= ?"
					  + " and ((? ='ALL') OR (?='6' and  SUBSTR(RPT_DIRF.rpt_fname,1,1) =  '6')"
                      + " or (?='7' and  SUBSTR(RPT_DIRF.rpt_fname,1,1) =  '7')) "
					  + " and RPT_DIRF.rpt_code  =  RPT_NOF.rpt_code"					  
					  + " order by  S_yymm , S_BankType_Name";
				paramList.add(szrpt_code) ;				
 				paramList.add(S_YEAR+S_MONTH) ;
 				paramList.add(E_YEAR+E_MONTH) ;
				paramList.add(szrpt_output_type) ;
				paramList.add(szrpt_output_type) ;
				paramList.add(szrpt_output_type) ;
    		}
    		System.out.println(sqlCmd);
    		List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"");
    		if(dbData != null && dbData.size() != 0){
    		   System.out.println("dbData.size="+dbData.size());  
    		}else{
    		   System.out.println("dbData is null or size = 0");  
    		}
    		
			return dbData;
    }
    
%>    
<%
//108.05.27 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>	
<%@ page import="com.tradevan.util.report.RptFR007WA" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>							          
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>
<%
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁	     
   act = dataMap.get("act")==null?"view" : (String) dataMap.get("act") ;			  
   String Unit = dataMap.get("Unit")==null?"1" : (String) dataMap.get("Unit") ;			  
   String bank_type = Utility.getTrimString(dataMap.get("bank_type")) ;			    
   String S_YEAR =  Utility.getTrimString(dataMap.get("S_YEAR")) ;
   String S_MONTH = Utility.getTrimString(dataMap.get("S_MONTH")) ;
   String datestate =  Utility.getTrimString(dataMap.get("datestate")) ;   
   String filename=(bank_type.equals("6"))?"農會資產品質分析明細表.xls":"漁會資產品質分析明細表.xls";
   String printStyle = Utility.getTrimString(dataMap.get("printStyle")); //108.05.27 add
   
   
   if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
        	rd = application.getRequestDispatcher( LoginErrorPgName );        
    }else{            
	    	//set next jsp 	
	    	if(act.equals("Qry")){
	    	   rd = application.getRequestDispatcher( QryPgName + "?bank_type="+bank_type);        
	    	}else if(act.equals("view")){
      		   //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
      		   //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔 
      			response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.05.27調整顯示的副檔名
   			}else if (act.equals("download")){   
   				response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.27調整顯示的副檔名
   			}   
   			if(act.equals("view") || act.equals("download")){
   				try{		    
	    			actMsg = RptFR007WA.createRpt(S_YEAR,S_MONTH,Unit,datestate,bank_type);	    
	    			System.out.println("createRpt="+actMsg);
	    			System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
	   	  			if(!printStyle.equalsIgnoreCase("xls")) {//108.05.27非xls檔須執行轉換	                
			  			   rptTrans rptTrans = new rptTrans();	  	  			  	
			  			   filename = rptTrans.transOutputFormat (printStyle,filename,""); 
			  			   System.out.println("newfilename="+filename);	  			   
					};
					FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);  		 
					ServletOutputStream out1 = response.getOutputStream();           
					byte[] line = new byte[8196];
					int getBytes=0;
					while( ((getBytes=fin.read(line,0,8196)))!=-1 ){		    		
						out1.write(line,0,getBytes);
						out1.flush();
	    			}
		
					fin.close();
					out1.close();            		      
		
				}catch(Exception e){
	   				System.out.println(e.getMessage());
				}   			
   			}
   		}
   		request.setAttribute("actMsg",actMsg);    	
%>
<%@include file="./include/Tail.include" %>

<%!
    private final static String report_no = "FR007WA" ;
    private final static String nextPgName = "/pages/ActMsg.jsp";    
    private final static String QryPgName = "/pages/"+report_no+"_Qry.jsp";        
    private final static String RptCreatePgName = "/pages/"+report_no+"_Excel.jsp";        
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
    
%>
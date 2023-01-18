<%
//96.07.12 add by 2295
//99.05.12 fix by 2808 修改部分程式改為共用
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.ListArray" %>	
<%@ page import="com.tradevan.util.report.*" %>								          
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.*" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>
<%@include file="./include/Header.include" %>


<%
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁	     
    
   String tbank_no = request.getParameter("BANK_NO") ;//(session.getAttribute("tbank_no") == null)?"":(String)session.getAttribute("tbank_no"); 
   act = dataMap.get("act")==null?"view" : (String) dataMap.get("act");			  		  
   String bank_type = Utility.getTrimString(dataMap.get("bank_type")) ;			  
   String S_YEAR = Utility.getTrimString(dataMap.get("S_YEAR")) ;
   String S_MONTH = Utility.getTrimString(dataMap.get("S_MONTH")) ;
   String E_YEAR =  Utility.getTrimString(dataMap.get("E_YEAR")) ;
   String E_MONTH = Utility.getTrimString(dataMap.get("E_MONTH")) ; 
   String bank_no = Utility.getTrimString(dataMap.get("BANK_NO")) ;
   String printStyle = Utility.getTrimString(dataMap.get("printStyle")); //108.05.28 add
   //tbank_no = (bank_no.equals(""))?tbank_no:bank_no;
   //String filename="存款帳戶分級差異化管理統計表.xls";
   //String filename="存款帳戶分級差異化管理統計表_縣市政府.xls";
   //String filename="存款帳戶分級差異化管理統計表_農漁會.xls";
   //String filename="存款帳戶分級差異化管理統計表_全國農業金庫.xls";
   String filename="存款帳戶分級差異化管理統計表";
   String BankList="";
   List BankList_data=null;
   if(request.getParameter("BankList") !=null  && !((String)request.getParameter("BankList")).equals("")){
	  BankList = (String)request.getParameter("BankList");
	  BankList_data = Utility.getReportData(BankList);
	  //System.out.println("BankList_data.size()="+BankList_data.size());	  
   }
   if(bank_type.equals("2")) filename += ".xls";//農金局
   if(bank_type.equals("B")) filename += "_縣市政府.xls";//縣市政府
   if(bank_type.equals("1")) filename += "_全國農業金庫.xls";
   if(bank_type.equals("6") || bank_type.equals("7")) filename += "_農漁會.xls";
   
	   if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
        	rd = application.getRequestDispatcher( LoginErrorPgName );        
    	}else{            
	    	//set next jsp 	
	    	if(act.equals("Qry")){
	    	   rd = application.getRequestDispatcher( QryPgName + "?bank_type="+bank_type);        
	    	}else if(act.equals("view")){
      		   //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
      		   //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔 
      			response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.05.28調整顯示的副檔名
   			}else if (act.equals("download")){   
   				response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.28調整顯示的副檔名
   			}   
   			if(act.equals("view") || act.equals("download")){
   				try{	
   					System.out.println("===============================");
   					System.out.println("tbank_no:"+tbank_no) ;
   					System.out.println("bank_type:"+bank_type) ;
   					System.out.println("===============================");
	    			if(bank_type.equals("2")){//農金局
	    			   actMsg = RptFR045W.createRpt(S_YEAR,S_MONTH,bank_type,lguser_name,BankList_data);//農金局	    
	    			}else if(bank_type.equals("B")){//地方主管機關
	    			   actMsg = RptFR045W_bank_b.createRpt(S_YEAR,S_MONTH,tbank_no);//地方主管機關
	    			}else if(bank_type.equals("6") || bank_type.equals("7")){//農.漁會 
    				   actMsg = RptFR045W_bank_67.createRpt(S_YEAR,S_MONTH,E_YEAR,E_MONTH,tbank_no);//農漁會
    				}else if(bank_type.equals("1")){//全國農業金庫
    				   actMsg = RptFR045W_bank_1.createRpt(S_YEAR,S_MONTH,E_YEAR,E_MONTH);//全國農業金庫
    				}
	    			System.out.println("createRpt="+actMsg);
	    			System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
	    			if(!printStyle.equalsIgnoreCase("xls")) {//108.05.28非xls檔須執行轉換	                
    				   rptTrans rptTrans = new rptTrans();	  	  			  	
    				   filename = rptTrans.transOutputFormat (printStyle,filename,""); 
    				   System.out.println("newfilename="+filename);	  			   
    				}
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
    private final static String report_no = "FR045W" ;
    private final static String nextPgName = "/pages/ActMsg.jsp";    
    private final static String QryPgName = "/pages/"+report_no+"_Qry.jsp";              
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
%>
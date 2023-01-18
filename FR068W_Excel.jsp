<%
//104.01.08 add by 2968  		
//108.05.10 add 報表格式挑選 by 2295																	
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>								          
<%@ page import="com.tradevan.util.report.FR068W_Excel" %>	
<%@ page import="com.tradevan.util.transfer.rptTrans" %>							          
<%
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁	     
   String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");			  
   System.out.println("act="+act);
   
   String BANK_DATA = ( request.getParameter("BANK_NO")==null ) ? "" : (String)request.getParameter("BANK_NO");			  
   String BANK_NO = "";
   if(!"".equals(BANK_DATA)){
	   String[] strarray=BANK_DATA.split("/");
	   BANK_NO = strarray[0].toString();
   }
   String S_YEAR = ( request.getParameter("S_YEAR")==null ) ? "" : (String)request.getParameter("S_YEAR");
   String S_MONTH = ( request.getParameter("S_MONTH")==null ) ? "" : (String)request.getParameter("S_MONTH");
   String Unit = ( request.getParameter("Unit")==null ) ? "1" : (String)request.getParameter("Unit");//94.11.16 add 金額單位	
   String bank_type =( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");
   String printStyle = ( request.getParameter("printStyle")==null ) ? "" : (String)request.getParameter("printStyle");//108.05.10
   String filename="逾期放款及轉銷呆帳及存款準備率降低所增盈餘月報表.xls";
   
   System.out.println("S_YEAR="+S_YEAR);
   System.out.println("S_MONTH="+S_MONTH); 
   System.out.println("BANK_DATA="+BANK_DATA);
   System.out.println("BANK_NO="+BANK_NO);
   System.out.println("Unit="+Unit);
   System.out.println("bank_type="+bank_type);
   String excelAction = ( request.getParameter("excelaction")==null ) ? "" : (String)request.getParameter("excelaction");			    	
   if(excelAction.equals("view")){
      //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
      //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔 
      response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.05.10調整顯示的副檔名            
   }else if (excelAction.equals("download")){   
      response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.10調整顯示的副檔名            
   }
   
%>
<%
	RequestDispatcher rd = null;
	boolean doProcess = false;	
	String actMsg = "";		
	//取得session資料,取得成功時,才繼續往下執行===================================================
	if(session.getAttribute("muser_id") == null){//session timeout		
	   System.out.println("FR068W login timeout");   
		   rd = application.getRequestDispatcher( "/pages/reLogin.jsp?url=LoginError.jsp?timeout=true" );         	   
		   try{
		       rd.forward(request,response);
		    }catch(Exception e){
		       System.out.println("forward Error:"+e.getMessage());
		    }
	}else{
	   doProcess = true;
	}    
	if(doProcess){//若muser_id資料時,表示登入成功====================================================================	
		if(!CheckPermission(request)){//無權限時,導向到LoginError.jsp
	     	rd = application.getRequestDispatcher( LoginErrorPgName );        
	 	}else{            
		    	//set next jsp 	
		    	if(act.equals("Qry")){
		    	    rd = application.getRequestDispatcher(QryPgName+"?bank_type="+bank_type); 
			    	session.setAttribute("nowbank_type",bank_type);//100.06.24
			    	request.setAttribute("TBank",Utility.getBankList(request) );//按照直轄市在前.其他縣市在後排序.
		    	}else if(act.equals("view")){
		   		   //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
		   		   //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔 
		   			response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.05.10調整顯示的副檔名      
				}else if (act.equals("download")){   
	   				response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.10調整顯示的副檔名      
				}   
				if(act.equals("view") || act.equals("download")){
					try{	
						actMsg = FR068W_Excel.createRpt(S_YEAR,S_MONTH,BANK_NO,Unit,bank_type,(String)session.getAttribute("muser_id"));
					    System.out.println("createRpt="+actMsg);
					    System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
					    					      
					    if(!printStyle.equalsIgnoreCase("xls")) {//108.05.10非xls檔須執行轉換	                
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
			try {
		     	//forward to next present jsp
		     	rd.forward(request, response);
		 	} catch (NullPointerException npe) {
		 	}
	 }//end of doProcess
		       
%>

<%!
    private final static String nextPgName = "/pages/ActMsg.jsp";    
    private final static String QryPgName = "/pages/FR068W_Qry.jsp";        
    private final static String RptCreatePgName = "/pages/FR068W_Excel.jsp";        
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
    private boolean CheckPermission(HttpServletRequest request){//檢核權限    	        		
    	    boolean CheckOK=false;
    	    HttpSession session = request.getSession();            
            Properties permission = ( session.getAttribute("FR068W")==null ) ? new Properties() : (Properties)session.getAttribute("FR068W");				                
            if(permission == null){
              System.out.println("FR068W.permission == null");
            }else{
               System.out.println("FR068W.permission.size ="+permission.size());
               
            }
            //只要有Query的權限,就可以進入畫面
        	if(permission != null && permission.get("Q") != null && permission.get("Q").equals("Y")){            
        	   CheckOK = true;//Query
        	}
        	System.out.println("CheckOk="+CheckOK);        	
        	return CheckOK;
    }   
%>

<%
//94.11/23 by 4180
//99.04.12  修改部分程式為共用 fix by 2808 
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.ListArray" %>	
<%@ page import="com.tradevan.util.report.RptFR025WA" %>	
<%@ page import="com.tradevan.util.transfer.rptTrans" %>							          
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>

<%
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁	  
   act = "".equals(act) ? "view" : act ; 
   		  		  
   String bank_type = ( session.getAttribute("nowbank_type")==null ) ? "" : (String)session.getAttribute("nowbank_type");	    
   String S_YEAR = Utility.getTrimString(dataMap.get("S_YEAR")) ;
   String S_MONTH = Utility.getTrimString(dataMap.get("S_MONTH")) ;
   String printStyle = Utility.getTrimString(dataMap.get("printStyle")); //108.05.28 add
   String filename=(bank_type.equals("6"))?"農漁會信用部ATM裝設台數及異動明細表.xls":"農漁會信用部ATM裝設台數及異動明細表.xls";
   String BankList="";
   List BankList_data=null;
   if(session.getAttribute("BankList") != null && !((String)session.getAttribute("BankList")).equals("")){
		   		BankList = (String)session.getAttribute("BankList");
		   		BankList_data = getReportData(BankList);
		   		System.out.println("BankList_data.size()="+BankList_data.size());
		   		System.out.print("農漁會信用部:"+BankList);		   
	 }
   System.out.println("S_YEAR="+S_YEAR);
   System.out.println("S_MONTH="+S_MONTH);
   System.out.println("act="+act);
   System.out.println("bank_type="+bank_type);
   
    
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
	    			actMsg = RptFR025WA.createRpt(S_YEAR,S_MONTH,bank_type,BankList_data);	    
	    			//actMsg = RptFR025WA.createRpt(S_YEAR,S_MONTH,bank_type);	
	    			System.out.println("createRpt="+actMsg);
	    			System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
	   	  			if(!printStyle.equalsIgnoreCase("xls")) {//108.05.28非xls檔須執行轉換	                
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
    private final static String report_no = "FR025WA" ;
    private final static String nextPgName = "/pages/ActMsg.jsp";    
    private final static String QryPgName = "/pages/"+report_no+"_Qry.jsp";              
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
    
//將選擇的bank_list取出
	private List getReportData(String rptData){
	    List rptList = new LinkedList();
	    StringTokenizer paserData = null;
	    List rptDetail = null;
		try{
			StringTokenizer paser = new StringTokenizer(rptData.trim(),",");			
	        while (paser.hasMoreTokens()){
	            paserData = new StringTokenizer(paser.nextToken(","),"+");
	            rptDetail = new LinkedList();
	            while (paserData.hasMoreTokens()){
	                rptDetail.add(paserData.nextToken());  
	            }//end of have "+" data	            
	            rptList.add(rptDetail);
			}//end of have "," data 
		}catch(Exception e){
			System.out.println("getReportData Error:"+e+e.getMessage());
		}
		return rptList;
	}

%>
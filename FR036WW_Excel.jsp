<%
//94/01/03 by 4180
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.ListArray" %>	
<%@ page import="com.tradevan.util.report.RptFR036W" %>	
<%@ page import="com.tradevan.util.transfer.rptTrans" %>			          
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Enumeration" %>

<%  
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁	     
   String act = ( request.getParameter("act")==null ) ? "view" : (String)request.getParameter("act");			  		  
   String bank_type = ( session.getAttribute("nowbank_type")==null ) ? "" : (String)session.getAttribute("nowbank_type");	    
   String S_YEAR = ( request.getParameter("YEAR")==null ) ? "" : (String)request.getParameter("YEAR");
   String S_MONTH = ( request.getParameter("MONTH")==null ) ? "" : (String)request.getParameter("MONTH");
   String unit = ( request.getParameter("Unit")==null ) ?"1" : (String)request.getParameter("Unit");
   String rptStyle=( request.getParameter("rptStyle")==null ) ? "" : (String)request.getParameter("rptStyle");   
   String filename="";
   String report_type = ( request.getParameter("report_type")==null ) ? "" : (String)request.getParameter("report_type");
   String printStyle = ( request.getParameter("printStyle")==null ) ? "" : (String)request.getParameter("printStyle"); //108.05.28 add 
   
   System.out.println("report_type="+report_type);
   /*
   //信用部統一貸款資料單月報表_1
   if(report_type.equals("1"))
   {
		   if(bank_type.equals("6"))
		   {
		   	    if(rptStyle.equals("0"))
						{
							filename="全體農會信用部統一農貸資料總表.xls";
						}
						if(rptStyle.equals("1"))
						{
							filename="全體農會信用部統一農貸資料明細表.xls";
						}
		   }
		   else
		   {
		   		  if(rptStyle.equals("0"))
						{
							filename="全體漁會信用部統一漁貸資料總表.xls";
						}
						if(rptStyle.equals("1"))
						{
							filename="全體漁會信用部統一漁貸資料明細表.xls";
						}
		   }
   }
   //信用部統一貸款資料指定單月新增戶數金額比較報表_2
   if(report_type.equals("2"))
   {
		   if(bank_type.equals("6"))
		   {
		   	    if(rptStyle.equals("0"))
						{
							filename="全體農會信用部統一農貸資料某二指定期間新增戶數金額比較總表.xls";
						}
						if(rptStyle.equals("1"))
						{
							filename="全體農會信用部統一農貸資料某二指定期間新增戶數金額比較明細表.xls";
						}
		   }
		   else
		   {
		   		  if(rptStyle.equals("0"))
						{
							filename="全體漁會信用部統一漁貸資料某二指定期間新增戶數金額比較總表.xls";
						}
						if(rptStyle.equals("1"))
						{
							filename="全體漁會信用部統一漁貸資料某二指定期間新增戶數金額比較明細表.xls";
						}
		   }
   }
   //信用部統一農貸資料某二指定期間新增戶數金額比較報表_3
   if(report_type.equals("3"))
   {
		   if(bank_type.equals("6"))
		   {
		   	    if(rptStyle.equals("0"))
						{
							filename="全體農會信用部統一農貸資料指定單月新增戶數金額比較總表.xls";
						}
						if(rptStyle.equals("1"))
						{
							filename="全體農會信用部統一農貸資料指定單月新增戶數金額比較明細表.xls";
						}
		   }
		   else
		   {
		   		  if(rptStyle.equals("0"))
						{
							filename="全體漁會信用部統一漁貸資料指定單月新增戶數金額比較總表.xls";
						}
						if(rptStyle.equals("1"))
						{
							filename="全體漁會信用部統一漁貸資料指定單月新增戶數金額比較明細表.xls";
						}
		   }
   }
   */
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
   
   RequestDispatcher rd = null;
   boolean doProcess = false;	
   String actMsg = "";		
   //取得session資料,取得成功時,才繼續往下執行===================================================
   if(session.getAttribute("muser_id") == null){//session timeout		
      System.out.println("FR036WW login timeout");   
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
   		if(!CheckPermission(request)){//無權限時,導向到LoginError.jsp
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
   				  System.out.println("AAAAAS_YEAR="+S_YEAR);
   				  System.out.println("S_MONTH="+S_MONTH);
   				  System.out.println("unit="+unit);
   				  System.out.println("bank_type="+bank_type);
   				  System.out.println("BankList_data="+BankList_data);	
   				  System.out.println("rptStyle="+rptStyle); 
   				  //信用部統一貸款資料單月報表   
	    			actMsg = RptFR036W.createRpt(S_YEAR,S_MONTH,unit,bank_type,BankList_data,rptStyle);	    
	    			//信用部統一貸款資料指定單月新增戶數金額比較報表
	    			//actMsg = RptFR036WA.createRpt(S_YEAR,S_MONTH,unit,bank_type,BankList_data,rptStyle);
	    			//信用部統一農貸資料某二指定期間新增戶數金額比較報表
	    			//actMsg = RptFR036WB.createRpt(S_YEAR,S_MONTH,E_YEAR,E_MONTH,unit,bank_type,BankList_data,rptStyle);
	    			
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
		try {
        	//forward to next present jsp
        	rd.forward(request, response);
    	} catch (NullPointerException npe) {
    	}
    }//end of doProcess
%>


<%!
    private final static String nextPgName = "/pages/ActMsg.jsp";    
    private final static String QryPgName = "/pages/FR036WW_Qry.jsp";              
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
    private boolean CheckPermission(HttpServletRequest request){//檢核權限    	        		
    	    boolean CheckOK=false;
    	    HttpSession session = request.getSession();            
            Properties permission = ( session.getAttribute("FR036WW")==null ) ? new Properties() : (Properties)session.getAttribute("FR036WW");				                
            if(permission == null){
              System.out.println("FR036WW.permission == null");
            }else{
               System.out.println("FR036WW.permission.size ="+permission.size());
               
            }
            //只要有Query的權限,就可以進入畫面
        	if(permission != null && permission.get("Q") != null && permission.get("Q").equals("Y")){            
        	   CheckOK = true;//Query
        	}
        	System.out.println("CheckOk="+CheckOK);        	
        	return CheckOK;
    }   

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
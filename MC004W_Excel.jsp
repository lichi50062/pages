<%
//97.09.03 create 違反農金法及其子法總表/明細表 by 2295
//99.05.26 fixed 套用共用權限Header.include by 2808
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>
<%
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁
   act = "".equals(Utility.getTrimString(dataMap.get("act")))?"view" : Utility.getTrimString(dataMap.get("act")) ;   
   
   String HSIEN_ID = Utility.getTrimString(dataMap.get("cityType")) ;
   String begDate  = Utility.getTrimString(dataMap.get("begDate")) ;
   String endDate  = Utility.getTrimString(dataMap.get("endDate")) ;
   String begY = Utility.getTrimString(dataMap.get("begY") ) ;
   String printStyle = Utility.getTrimString(dataMap.get("printStyle")); //108.05.28 add
   String filename="農漁會信用部違反農金局及其子法而遭處分明細表.xls";
   


   if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
        rd = application.getRequestDispatcher( LoginErrorPgName );
   }else{
	    	//set next jsp
	    	if(act.equals("Qry")){
	    	   rd = application.getRequestDispatcher( QryPgName );
	    	}else if(act.equals("view")){
      		   //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
      		   //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔
      			response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.05.28調整顯示的副檔名
   			}else if (act.equals("download")){
   				response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.28調整顯示的副檔名
   			}
   			if(act.equals("view") || act.equals("download")){
   				try{
   				
   						String violate_type = "" ;//處分方式    					
    		      //取出form裡的所有變數=================================== 
		  	      Enumeration ep = request.getParameterNames();
		  	      Enumeration ea = request.getAttributeNames();
		  	      Hashtable t = new Hashtable();
		  	      String name = "";
		  	      String violate_type_condition = "";
		  	      for ( ; ep.hasMoreElements() ; ) {
			         		name = (String)ep.nextElement();
			         		t.put( name, request.getParameter(name) );		
			         		System.out.println(name+"="+request.getParameter(name));	   
		  	      }	
		  	      
		  	      for(int i=0;i<9;i++){	
              		if(t.get("violate_type_" + (i+1)) != null ) {
              		   violate_type += (violate_type.length() > 0?" or ":"") + " violate_type like '%"+t.get("violate_type_" + (i+1))+"%'";              		   
              		}
              }
              System.out.println("violate_type="+violate_type);
    	        if(violate_type.indexOf("7") != -1){
    	           violate_type = "";//選全部時，清成空白
    	           System.out.println("violate_type="+violate_type);
    	        }     				
   				
	    			  actMsg =RptFR049W.createRpt(HSIEN_ID,begDate,endDate,begY,violate_type);
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
	private final static String report_no = "MC004W" ;
    private final static String nextPgName = "/pages/ActMsg.jsp";
    private final static String QryPgName = "/pages/"+report_no+"_Qry.jsp";
    private final static String RptCreatePgName = "/pages/"+report_no+"_Excel.jsp";
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";    
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.manager.ReportManager" %>
<%@ page import="com.tradevan.util.dao.RdbCommonDao" %>
<%@ page import="com.tradevan.util.newreport.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.tradevan.util.dao.DaoUtil" %>
<%
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁
   String act = ( request.getParameter("act")==null ) ? "view" : (String)request.getParameter("act");
   String Unit = ( request.getParameter("Unit")==null ) ? "1" : (String)request.getParameter("Unit");
   String bank_type = ( request.getParameter("bank_type")==null ) ? "" : (String)request.getParameter("bank_type");
   String S_YEAR = ( request.getParameter("S_YEAR")==null ) ? "" : (String)request.getParameter("S_YEAR");
   String S_MONTH = ( request.getParameter("S_MONTH")==null ) ? "" : (String)request.getParameter("S_MONTH");
   String datestate = ( request.getParameter("datestate")==null ) ? "" : (String)request.getParameter("datestate");
   String filename=(bank_type.equals("6"))?"農會資產品質分析明細表.xls":"漁會資產品質分析明細表.xls";
   System.out.println("S_YEAR="+S_YEAR);
   System.out.println("S_MONTH="+S_MONTH);
   System.out.println("act="+act);
   System.out.println("Unit="+Unit);
   System.out.println("datestate="+datestate);
   System.out.println("bank_type="+bank_type);
   System.out.println("userid = "+(String)session.getAttribute("muser_id"));

   RequestDispatcher rd = null;
   boolean doProcess = false;
   String actMsg = "";
   //取得session資料,取得成功時,才繼續往下執行===================================================
   if(session.getAttribute("muser_id") == null){//session timeout
      System.out.println("FR007WX login timeout");
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
      			response.setHeader("Content-disposition","inline; filename=view.xls");
   			}else if (act.equals("download")){
      			response.setHeader("Content-Disposition","attachment; filename=download.xls");
   			}
   			if(act.equals("view") || act.equals("download")){
                             Connection con=null;
   				try{
                                     RdbCommonDao dao = new RdbCommonDao("");
                                     Map h = Utility.saveSearchParameter(request);
                                     h.put("reportId","FR007WX");
                                     h.put("userId",(String)session.getAttribute("muser_id"));
                                     ReportManager rm = (ReportManager)ReportManager.getManager();
                                     con  = dao.newConnection();
                                     List v1 = (List)rm.prepareRepList(h,con);
                                     if(con!=null){
                                     	con.close();
                                     }
                                	RptFR007WX rep= new RptFR007WX();
                               	 	rep.setListData(v1);
                                	rep.setReportId("FR007WX");
                                	String fName=rep.createReport();
					FileInputStream fin = new FileInputStream(fName);
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
                                  	if(con!=null){
                                  		con.close();
                                        }
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
    private final static String QryPgName = "/pages/FR007WX_Qry.jsp";
    private final static String RptCreatePgName = "/pages/FR007WX_Excel.jsp";
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";
    private boolean CheckPermission(HttpServletRequest request){//檢核權限
    	    boolean CheckOK=false;
    	    HttpSession session = request.getSession();
            Properties permission = ( session.getAttribute("FR007WX")==null ) ? new Properties() : (Properties)session.getAttribute("FR007WX");
            if(permission == null){
              System.out.println("FR007WX.permission == null");
            }else{
               System.out.println("FR007WX.permission.size ="+permission.size());

            }
            //只要有Query的權限,就可以進入畫面
        	if(permission != null && permission.get("Q") != null && permission.get("Q").equals("Y")){
        	   CheckOK = true;//Query
        	}
        	System.out.println("CheckOk="+CheckOK);
        	return CheckOK;
    }
%>

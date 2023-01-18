<%
//108.05.28 add 報表格式挑選 by rock.tsai
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>

<%@ page import="com.tradevan.util.report.RptFL017W" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>


<%
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁

   String rptStyle = "1";
   String printStyle = ( request.getParameter("printStyle")==null ) ? "" : (String)request.getParameter("printStyle"); //108.05.28 add
   String filename="RptFL017W.xls";
   
  
   
    if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp
    	rd = application.getRequestDispatcher( LoginErrorPgName );
    }else{
	 	//set next jsp
	 	if(act.equals("Qry")){
	 		request.setAttribute("TBank", getTatolBankType());           
    	    request.setAttribute("City", Utility.getCity());
    	    //request.setAttribute("queryCondition",getQueryCondition()) ;
    	    request.setAttribute("queryCondition2",getQueryCondition2()) ;//貸款種類
    	    request.setAttribute("queryCondition3",getQueryCondition3()) ;
	 	    rd = application.getRequestDispatcher( QryPgName );
	 	}else if(act.equals("view")){
    	   //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
    	   //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔
    		response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.05.28調整顯示的副檔名
    	}
    	if(act.equals("view") || act.equals("download")){
    		response.setHeader("Content-Disposition","attachment; filename=download"+"_"+getYYYYMMDDHHMMSS()+"."+printStyle);//108.05.28調整顯示的副檔名
    		try{
	 			System.out.println("=========call RptFL017W") ;
	 			Map h = Utility.saveSearchParameter(request) ;
	 			//String begDate = Utility.getTrimString(request.getParameter("begDate")) ;
	 			//String endDate = Utility.getTrimString(request.getParameter("endDate")) ;
    			actMsg =RptFL017W.createRpt(h);
	 			
	 			//System.out.println("filename="+Utility.getProperties("reportDir")+System.getProperty("file.separator")+filename);
	 			if(!printStyle.equalsIgnoreCase("xls")) {//108.05.28非xls檔須執行轉換	                
				   rptTrans rptTrans = new rptTrans();	  	  			  	
				   actMsg = rptTrans.transOutputFormat (printStyle,actMsg,""); 
				   System.out.println("newfilename="+actMsg);	  			   
				}
	 			FileInputStream fin = new FileInputStream(
	 					Utility.getProperties("reportDir")
	 					+System.getProperty("file.separator") + actMsg
	 					);
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
    private final static String report_no = "FL017W";
    private final static String nextPgName = "/pages/ActMsg.jsp";
    private final static String QryPgName = "/pages/"+report_no+"_Qry.jsp";
    private final static String RptCreatePgName = "/pages/"+report_no+"_Excel.jsp";
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";    
    
     //取得所有總機構資料
    private List getTatolBankType(){//查詢條件
		StringBuffer sql = new StringBuffer() ;
		sql.append(" select bn01.bn_type,HSIEN_id, BN01.BANK_NO , BANK_NAME, BANK_TYPE,bn01.m_year  ");
		sql.append(" from  BN01, WLX01 ");
		sql.append(" where BN01.BANK_NO = WLX01.BANK_NO(+) ");
		sql.append(" and wlx01.m_year = bn01.m_year ");    		
		sql.append(" order by BANK_NO  ");  
	    List dbData = DBManager.QueryDB_SQLParam(sql.toString(),null,"m_year");
	    return dbData;
    }
   /*  private List getQueryCondition() {
    	StringBuffer sql = new StringBuffer() ;
    	sql.append(" select ex_type,");//--查核類別 FEB:金管會檢查報告,'AGRI','農業金庫查核','BOAF','農金局訪查'
		sql.append(" ex_no,");//--查核報告編號
		 //--下拉選單顯示的檢查報告編號或查核季別或訪查日期
		sql.append(" decode(ex_type,'FEB',ex_no,'AGRI',substr(ex_no,0,3)||'年第'||substr(ex_no,4,2)||'季','BOAF',F_TRANSCHINESEDATE(to_date(ex_no,'yyyymmdd')),'') as ex_no_list,");//
		sql.append(" bank_no ");//--機構代碼
		sql.append(" from frm_exmaster ");
		List dbData = DBManager.QueryDB_SQLParam(sql.toString(),null,null);
	    return dbData;
    } */
    private List getQueryCondition2() {
    	StringBuffer sql = new StringBuffer() ;
    	sql.append(" select loan_item, ");//貸款種類代碼
		sql.append(" loan_item_name ");//--貸款種類名稱
		sql.append(" from  frm_loan_item  ");
		sql.append(" order by input_order ");
		
		List dbData = DBManager.QueryDB_SQLParam(sql.toString(),null,null);
	    return dbData;
    }
    private List getQueryCondition3() {
    	StringBuffer sql = new StringBuffer() ;
    	sql.append(" select cmuse_id , ");//缺失態樣代碼
		sql.append(" cmuse_name ");//缺失態樣名稱
		sql.append(" from cdshareno where cmuse_div='047' order by input_order ");
		
		
		List dbData = DBManager.QueryDB_SQLParam(sql.toString(),null,null);
	    return dbData;
    }
    private String getYYYYMMDDHHMMSS(){
    	Calendar rightNow = Calendar.getInstance();
        String year = (new Integer(rightNow.get(Calendar.YEAR))).toString();
        String month = (new Integer(rightNow.get(Calendar.MONTH) + 1)).toString();
        String day = (new Integer(rightNow.get(Calendar.DAY_OF_MONTH))).toString();
        String hour = (new Integer(rightNow.get(Calendar.HOUR_OF_DAY))).toString();
        String minute = (new Integer(rightNow.get(Calendar.MINUTE))).toString();
        String second = (new Integer(rightNow.get(Calendar.SECOND))).toString();

        if (month.length() == 1) {
            month = "0" + month;
        }
        if (day.length() == 1) {
            day = "0" + day;
        }
        if (hour.length() == 1) {
            hour = "0" + hour;
        }
        if (minute.length() == 1) {
            minute = "0" + minute;
        }
        if (second.length() == 1) {
            second = "0" + second;

        }
        return (year + month + day + hour + minute + second);
    }
%>

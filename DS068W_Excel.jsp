<%
//105.11.09 create 查核案件數彈性報表 by 2295
//108.05.03 add 報表格式轉換 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.Region" %>
<%@ page import="com.tradevan.util.Utility" %>								          
<%@ page import="com.tradevan.util.report.RptDS068W" %>								          
<%@ page import="com.tradevan.util.report.HssfStyle" %>								          
<%@ page import="com.tradevan.util.report.reportUtil" %>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="java.text.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>
<%
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁   
   String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");			  
   System.out.println("act="+act);
   String printStyle = "";//輸出格式 108.05.03 add 	     
   //輸出格式 108.05.03 add
   if(session.getAttribute("printStyle") != null && !((String)session.getAttribute("printStyle")).equals("")){
   	 printStyle = (String)session.getAttribute("printStyle");		  				   
   }
   if(act.equals("view")){
      //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
      //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔 
      response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.05.03調整顯示的副檔名
   }else if (act.equals("download")){   
      response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.03調整顯示的副檔名
   }   
%>
<%
	String actMsg = "";
	FileOutputStream fileOut = null;
    reportUtil reportUtil = new reportUtil();
    String BankList = "";//儲存bank_code/bank_name
    String btnFieldList = "";//儲存所選取的大類acc_code/名稱
    String rptKind = "";//統計分類
    String SortList = "";//排序的acc_code
    String CANCEL_NO = "";//裁撤別
    String S_YEAR = "";//年
    String E_YEAR = "";//年
    String S_MONTH = "";//月
    String E_MONTH = "";//月
    String S_DAY = "";//日
    String E_DAY = "";//日
    String begDate = "";//查核期間
    String endDate = "";//查核期間
    List BankList_data = null;//儲存bank_code/bank_name的集合
    List btnFieldList_data = null;
    List SortList_data = null;    
	int i = 0;
	int j= 0;
	String lguser_name = ( session.getAttribute("muser_name")==null ) ? "" : (String)session.getAttribute("muser_name");

	String hasBankListALL="false";
	
	try{
	      	
			
			//儲存報表的目錄================================================================
        	File reportDir = new File(Utility.getProperties("reportDir"));       
    		if(!reportDir.exists()){
     			if(!Utility.mkdirs(Utility.getProperties("reportDir"))){
     	   			actMsg +=Utility.getProperties("reportDir")+"目錄新增失敗";
     			}    
    		}
    		//==============================================================================
    		//營運中/已裁撤
			if(session.getAttribute("CANCEL_NO") != null && !((String)session.getAttribute("CANCEL_NO")).equals("")){
		  		CANCEL_NO = (String)session.getAttribute("CANCEL_NO");		  				   
			}
    		//金融機構
			if(session.getAttribute("BankList") != null && !((String)session.getAttribute("BankList")).equals("")){
		   		BankList = (String)session.getAttribute("BankList");
		   		BankList_data = Utility.getReportData(BankList);
		   		System.out.println("BankList_data.size()="+BankList_data.size());		   
		   		System.out.println("BankList_data="+BankList_data);		   
			}
			//報表欄位
			if(session.getAttribute("btnFieldList") != null && !((String)session.getAttribute("btnFieldList")).equals("")){
		   		btnFieldList = (String)session.getAttribute("btnFieldList");
		   		btnFieldList_data = Utility.getReportData(btnFieldList);
		   		System.out.println("btnFieldList_data.size()="+btnFieldList_data.size());		   
		   		System.out.println("btnFieldList_data="+btnFieldList_data);		   
			}
			//統計分類
			if(session.getAttribute("rptKind") != null && !((String)session.getAttribute("rptKind")).equals("")){
			    rptKind = (String)session.getAttribute("rptKind");		  				   
			}        	
        		
			//年
			if(session.getAttribute("S_YEAR") != null && !((String)session.getAttribute("S_YEAR")).equals("")){
		  		S_YEAR = (String)session.getAttribute("S_YEAR");		  				   
			}
			//年
			if(session.getAttribute("E_YEAR") != null && !((String)session.getAttribute("E_YEAR")).equals("")){
		  		E_YEAR = (String)session.getAttribute("E_YEAR");		  				   
			}			
			//月
			if(session.getAttribute("S_MONTH") != null && !((String)session.getAttribute("S_MONTH")).equals("")){
		  		S_MONTH = (String)session.getAttribute("S_MONTH");		  				   
			}
			//月
			if(session.getAttribute("E_MONTH") != null && !((String)session.getAttribute("E_MONTH")).equals("")){
		  		E_MONTH = (String)session.getAttribute("E_MONTH");		  				   
			}
			
			//日
			if(session.getAttribute("S_DAY") != null && !((String)session.getAttribute("S_DAY")).equals("")){
		  		S_DAY = (String)session.getAttribute("S_DAY");		  				   
			}
			//日
			if(session.getAttribute("E_DAY") != null && !((String)session.getAttribute("E_DAY")).equals("")){
		  		E_DAY = (String)session.getAttribute("E_DAY");		  				   
			}
			
			//查核期間
			if(session.getAttribute("begDate") != null && !((String)session.getAttribute("begDate")).equals("")){
		  		begDate = (String)session.getAttribute("begDate");		  				   
			}
			//查核期間
			if(session.getAttribute("endDate") != null && !((String)session.getAttribute("endDate")).equals("")){
		  		endDate = (String)session.getAttribute("endDate");		  				   
			}
								
			String selectBank_no = "";//選取的金融機構代號
            //金融機構代號=============================================================
            if(BankList_data != null && BankList_data.size() != 0){               
               for(i=0;i<BankList_data.size();i++){
                   //95.09.04 判斷機構代號是否為ALL:全部===============================================
			       if(((String)((List)BankList_data.get(i)).get(0)).equals("ALL")){
			          hasBankListALL="true";
			       
			       }    			       			   
            	   selectBank_no +="'"+(String)((List)BankList_data.get(i)).get(0)+"'";            	
            	   if(i < BankList_data.size()-1) selectBank_no +=",";
               }               
               System.out.println("select bank_no="+selectBank_no);
            }   
            
            //統計分類代碼=============================================================
            String selectRptKindCode="";//所選取的貸款種類或缺失態樣
            if(btnFieldList_data != null && btnFieldList_data.size() != 0){               
               for(i=0;i<btnFieldList_data.size();i++){                   			       			   
            	   selectRptKindCode +="'"+(String)((List)btnFieldList_data.get(i)).get(0)+"'";            	
            	   if(i < btnFieldList_data.size()-1) selectRptKindCode +=",";
               }               
               System.out.println("select rptKindCode="+selectRptKindCode);
            }   
            //==============================================================================
            
            
            if(rptKind.equals("1") || rptKind.equals("2")){//統計分類:貸款種類            	
            	RptDS068W.createRpt(rptKind,S_YEAR,S_MONTH,S_DAY,E_YEAR,E_MONTH,E_DAY,begDate,endDate,selectRptKindCode,hasBankListALL);  
        	}else if(rptKind.equals("3")){	        		
        	   RptDS068W.createRpt(rptKind,S_YEAR,S_MONTH,S_DAY,E_YEAR,E_MONTH,E_DAY,begDate,endDate,selectBank_no,hasBankListALL);     
        	}   
            
            String filename = "DS068W.xls";//108.05.03 add
            if(!printStyle.equalsIgnoreCase("xls")) {//108.05.03非xls檔須執行轉換	                
	  			rptTrans rptTrans = new rptTrans();	  			
	  			filename = rptTrans.transOutputFormat (printStyle,filename,""); 
	  			System.out.println("newfilename="+filename);	  			   
            };
            
            FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+ filename);//108.05.03 fix 	 
			ServletOutputStream out1 = response.getOutputStream();           
			byte[] line = new byte[8196];
			int getBytes=0;
			while( ((getBytes=fin.read(line,0,8196)))!=-1 ){		    		
				out1.write(line,0,getBytes);
				out1.flush();
	    	}
		
			fin.close();
			out1.close();        
					      
        } catch ( Exception e ) {            
            e.printStackTrace();
            
        } finally {
            try {
                if ( fileOut != null ) {
                    fileOut.close();
                }
            } catch ( Exception e ) {
                  System.out.println(e.getMessage() );
            }
        }   
%>	    		
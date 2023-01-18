<%
//109.07.07 create 信用部電子銀行基本資料表 by 2295
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="org.apache.poi.poifs.filesystem.*,org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.Region" %>
<%@ page import="com.tradevan.util.Utility" %>								          
<%@ page import="com.tradevan.util.report.Report01" %>								          
<%@ page import="com.tradevan.util.report.HssfStyle" %>								          
<%@ page import="com.tradevan.util.report.reportUtil" %>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.StringTokenizer" %>
<%@ page import="java.lang.StringBuffer" %>
<%@ page import="java.lang.Short" %>
<%@ page import="java.lang.Math" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>

<%
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁   
   String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");			  
   System.out.println("act="+act);
   String printStyle = "xls";//輸出格式 108.03.25 add
   //輸出格式 108.03.25 add
   if(session.getAttribute("printStyle") != null && !((String)session.getAttribute("printStyle")).equals("")){
   	 printStyle = (String)session.getAttribute("printStyle");		  				   
   }
   if(act.equals("view")){
      //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
      //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔 
      response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.03.25調整顯示的副檔名
   }else if (act.equals("download")){   
      response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.03.25調整顯示的副檔名
   }   
%>
<%
	String actMsg = "";
	FileOutputStream fileOut = null;      	
    HSSFCellStyle defaultStyle;
    HSSFCellStyle rightStyle;
    HSSFCellStyle noBorderDefaultStyle;
    HSSFCellStyle noBorderLeftStyle;
    HSSFCellStyle noBorderCenter_Red_UnderlineStyle;    
    HSSFCellStyle noBorderRight_Red_UnderlineStyle;    
    HSSFCellStyle titleStyle;
	HSSFCellStyle columnStyle;
	HSSFCellStyle column_LeftStyle;
	HSSFCellStyle noBoderStyle;
	HSSFRow row;
	HSSFRow acc_code_row;//讀取acc_code的row
	HSSFCell cell = null;//宣告一個儲存格
	String titleName = "信用部";
    reportUtil reportUtil = new reportUtil();
    String BankList = "";//儲存bank_code/bank_name
    String btnFieldList = "";//儲存所選取的大類acc_code/名稱
    String SortList = "";//排序的acc_code
    String CANCEL_NO = "";//裁撤別
    String acc_div = "";//1.資產負債表:2.損益表
    String Unit = "";//列印單位
    String S_YEAR = "";//年
    String E_YEAR = "";//年
    String S_MONTH = "";//月
    String u_year = "99" ;//判斷縣市合併用
    String cdTable = "cd01_99" ;//判斷縣市合併用
    List BankList_data = null;//儲存bank_code/bank_name的集合
    List btnFieldList_data = null;
    List SortList_data = null;    
	int i = 0;
	int j= 0;
	int detailidx= 0;
	String lguser_name = "測試使用者";
	String bank_type="";
	String hasBankListALL="false";
	try{
			bank_type = ((String)session.getAttribute("nowbank_type")).equals("")?"6":(String)session.getAttribute("nowbank_type");	
			System.out.println("bank_type="+bank_type);
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
			//排序欄位
			if(session.getAttribute("SortList") != null && !((String)session.getAttribute("SortList")).equals("")){
		  		SortList = (String)session.getAttribute("SortList");
		  		SortList_data = Utility.getReportData(SortList);
		   		System.out.println("SortList_data.size()="+SortList_data.size());		   
		   		System.out.println("SortList_data="+SortList_data);		   
			}
        	
        	//機構類別
			if(session.getAttribute("nowbank_type") != null && !((String)session.getAttribute("nowbank_type")).equals("")){
			    if(((String)session.getAttribute("nowbank_type")).equals("6")){
			       titleName = "農會" + titleName;
			    }else if(((String)session.getAttribute("nowbank_type")).equals("7")){
			       titleName = "漁會" + titleName;
			    }else{
			       titleName = "農漁會" + titleName;
			    }			    
			}
			titleName += "電子銀行基本資料表";
			//年
			if(session.getAttribute("S_YEAR") != null && !((String)session.getAttribute("S_YEAR")).equals("")){
		  		S_YEAR = (String)session.getAttribute("S_YEAR");	
		  	}
			if(S_YEAR!=null && Integer.parseInt(S_YEAR)>99) {
				u_year = "100" ;
				cdTable = "cd01" ;
			}
			
			//金額單位
			if(session.getAttribute("Unit") != null && !((String)session.getAttribute("Unit")).equals("")){
		  		Unit = (String)session.getAttribute("Unit");		  				   
			}
			//月
			if(session.getAttribute("S_MONTH") != null && !((String)session.getAttribute("S_MONTH")).equals("")){
		  		S_MONTH = (String)session.getAttribute("S_MONTH");		  				   
			}			
			
			//讀取欄位大類所包含的中類===================================================================================        	
        	Properties prop_detail_column = new Properties();
			prop_detail_column.load(new FileInputStream(Utility.getProperties("schemaDir")+System.getProperty("file.separator")+"WLX_Elimit_detail.TXT"));									
			//取出欄位中類將資料存入MAP-->key=大類acc_code,value=中類acc_code=============================================================
			HashMap h_column_detail = new HashMap();//儲存column大類,及其中類的acc_code			
			List detail_column_detail = new LinkedList();
			String column_tmp_detail = "";						
			for(i=0;i<btnFieldList_data.size();i++){			    
			    column_tmp_detail = "";
			    column_tmp_detail = (String)prop_detail_column.get((String)((List)btnFieldList_data.get(i)).get(0));
			    System.out.println("column_tmp_detail="+column_tmp_detail);
			    if(!column_tmp_detail.equals("")){
			        detail_column_detail = Utility.getStringTokenizerData(column_tmp_detail,"+");
			        //System.out.println((String)((List)btnFieldList_data.get(i)).get(0)+"="+detail_column_detail);			        		      
			        h_column_detail.put((String)((List)btnFieldList_data.get(i)).get(0),detail_column_detail);//大類->中類			       			      
			    }
			}
			System.out.println("大類->中類.h_column_detail.size()="+h_column_detail.size());
			
			
			//讀取欄位中類所包含的細項===================================================================================        	
			Properties prop_column = new Properties();
			prop_column.load(new FileInputStream(Utility.getProperties("schemaDir")+System.getProperty("file.separator")+"WLX_Elimit_detail_column.TXT"));									
			//取出欄位細項將資料存入MAP-->key=中類acc_code,value=細項acc_code=============================================================
			HashMap h_column = new HashMap();//儲存column中類,及其細項的acc_code			
			List detail_column = new LinkedList();
			String column_tmp = "";			
			String selectacc_code = "";//選取的detail科目代號
			int columnLength=0;//column個數			
			for(i=0;i<btnFieldList_data.size();i++){			    
			    column_tmp = "";
			    System.out.println("master.column="+(String)((List)btnFieldList_data.get(i)).get(0));
			    detail_column_detail = (List)h_column_detail.get((String)((List)btnFieldList_data.get(i)).get(0));//取得大類.包含的中類
			    for(detailidx=0;detailidx<detail_column_detail.size();detailidx++){
			        column_tmp = (String)prop_column.get((String)detail_column_detail.get(detailidx));//取得中類.包含的細項
			        System.out.println("column_tmp="+column_tmp);
			        if(!column_tmp.equals("")){
			           detail_column = Utility.getStringTokenizerData(column_tmp,"+");
			           System.out.println(detail_column);
			           if(detail_column != null && detail_column.size() != 0){               
			              columnLength += detail_column.size();//累加總欄位個數
              		      for(j=0;j<detail_column.size();j++){
            	 		      selectacc_code +="'"+(String)detail_column.get(j)+"'";            	
            	 		      if(j < detail_column.size()-1){            	 		         
            	 		         selectacc_code +=",";
            	 		      }   
               		      }                              		   
               		      //System.out.println("select acc_code="+selectacc_code);
            	       }			      			        
			       }
			       h_column.put((String)detail_column_detail.get(detailidx),detail_column);			       			       
			       if(detailidx < detail_column_detail.size()-1){
			          selectacc_code +=",";			       
			       }   
			    }//end of 中類			     
			    if(i < btnFieldList_data.size()-1){			       
			       selectacc_code +=",";			       
			    }   
			}//end of 大類
			System.out.println("select acc_code="+selectacc_code);
			System.out.println("中類->細項.h_column.size()="+h_column.size());
        	//讀取報表欄位名稱===================================================================================        	
        	Properties prop_column_name = new Properties();        	
			prop_column_name.load(new FileInputStream(Utility.getProperties("schemaDir")+System.getProperty("file.separator")+"WLX_Elimit_column.TXT"));			
			//====================================================================================================
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
            //==============================================================================
            String order = "";//排序欄位
            //排序欄位=========================================================================
            if(SortList_data != null && SortList_data.size() != 0){
            	for(i=0;i<SortList_data.size();i++){
            		order += (String)((List)SortList_data.get(i)).get(0);
            		if(i < SortList_data.size() -1 ) order +=",";            
	            }
	            System.out.println("order="+order);
            }
            //====================================================================================            
  			/*
  			//各別機構  			
  			select  wlx01.bank_no,bn01.bank_name,wlx01.hsien_id,cd01.hsien_name,
                    TO_CHAR(ebank_doc_date,'YYYY/MM/DD') as field_ebank_doc_date,
                    ebank_doc_no as field_ebank_doc_no,
                    field_1010_each,field_1010_day,field_1010_month,
                    field_1020_each,field_1020_day,field_1020_month,
                    field_1032_each,field_1032_day,field_1032_month,   
                    field_1033_each,field_1033_day,field_1033_month,
                    decode(ebank_s1,'Y','V','') as field_ebank_s1,
                    decode(ebank_s2,'Y','V','') as field_ebank_s2,
                    TO_CHAR(wlx01_epay_203.doc_date,'YYYY/MM/DD') as field_203_doc_date,
                    wlx01_epay_203.doc_no as field_203_doc_no,
                    field_2031_each,field_2031_day,field_2031_month,
                    field_2032_each,field_2032_day,field_2032_month,
                    field_2036_each,field_2036_day,field_2036_month,
                    TO_CHAR(wlx01_epay_204.doc_date,'YYYY/MM/DD') as field_204_doc_date,
                    wlx01_epay_204.doc_no as field_204_doc_no,
                    field_2047_each,field_2047_day,field_2047_month
            from (select * from bn01 where bn01.m_year=100)bn01 left join (select * from wlx01 where m_year=100)wlx01 on bn01.bank_no = wlx01.bank_no
            left join cd01 on wlx01.HSIEN_ID = cd01.HSIEN_ID  
            left join (
                 select bank_no,
                        sum(decode(limit_type,'101',decode(sub_type,'0',each_limit,0),0)) as field_1010_each,
                        sum(decode(limit_type,'101',decode(sub_type,'0',day_limit,0),0)) as field_1010_day,
                        sum(decode(limit_type,'101',decode(sub_type,'0',month_limit,0),0)) as field_1010_month,
                        sum(decode(limit_type,'102',decode(sub_type,'0',each_limit,0),0)) as field_1020_each,
                        sum(decode(limit_type,'102',decode(sub_type,'0',day_limit,0),0)) as field_1020_day,
                        sum(decode(limit_type,'102',decode(sub_type,'0',month_limit,0),0)) as field_1020_month,
                        sum(decode(limit_type,'103',decode(sub_type,'2',each_limit,0),0)) as field_1032_each,
                        sum(decode(limit_type,'103',decode(sub_type,'2',day_limit,0),0)) as field_1032_day,
                        sum(decode(limit_type,'103',decode(sub_type,'2',month_limit,0),0)) as field_1032_month,
                        sum(decode(limit_type,'103',decode(sub_type,'3',each_limit,0),0)) as field_1033_each,
                        sum(decode(limit_type,'103',decode(sub_type,'3',day_limit,0),0)) as field_1033_day,
                        sum(decode(limit_type,'103',decode(sub_type,'3',month_limit,0),0)) as field_1033_month
                  from wlx01_elimit
                  group by bank_no
                  order by bank_no
                  )wlx01_elimit on bn01.bank_no=wlx01_elimit.bank_no
            left join (
                 select bank_no,
                        sum(decode(limit_type,'203',decode(sub_type,'1',each_limit,0),0)) as field_2031_each,
                        sum(decode(limit_type,'203',decode(sub_type,'1',day_limit,0),0)) as field_2031_day,
                        sum(decode(limit_type,'203',decode(sub_type,'1',month_limit,0),0)) as field_2031_month,
                        sum(decode(limit_type,'203',decode(sub_type,'2',each_limit,0),0)) as field_2032_each,
                        sum(decode(limit_type,'203',decode(sub_type,'2',day_limit,0),0)) as field_2032_day,
                        sum(decode(limit_type,'203',decode(sub_type,'2',month_limit,0),0)) as field_2032_month,
                        sum(decode(limit_type,'203',decode(sub_type,'6',each_limit,0),0)) as field_2036_each,
                        sum(decode(limit_type,'203',decode(sub_type,'6',day_limit,0),0)) as field_2036_day,
                        sum(decode(limit_type,'203',decode(sub_type,'6',month_limit,0),0)) as field_2036_month,
                        sum(decode(limit_type,'204',decode(sub_type,'7',each_limit,0),0)) as field_2047_each,
                        sum(decode(limit_type,'204',decode(sub_type,'7',day_limit,0),0)) as field_2047_day,
                        sum(decode(limit_type,'204',decode(sub_type,'7',month_limit,0),0)) as field_2047_month
                  from wlx01_epay
                  group by bank_no
                  order by bank_no
                  )wlx01_epay_sum on bn01.bank_no=wlx01_epay_sum.bank_no
            left join (select distinct bank_no,limit_type,doc_date,doc_no from wlx01_epay where limit_type='203')wlx01_epay_203 on  bn01.bank_no=wlx01_epay_203.bank_no                                
            left join (select distinct bank_no,limit_type,doc_date,doc_no from wlx01_epay where limit_type='204')wlx01_epay_204 on  bn01.bank_no=wlx01_epay_204.bank_no
            where  bn01.bank_no in ('6030016','6060019') and bn01.bn_type <> '2' and business_item like '%13%' --業務項目有勾選電子銀行
            order by wlx01.bank_no

			//縣市別小計.無縣市別統計			
  			*/
  			
            String column = "";//選取欄位           
            String condition = "";//其他條件            
			condition += " and bn01.bn_type "+(CANCEL_NO.equals("N")?"<>":"=")+" '2' and a02.bank_code = bn01.bank_no ";		  	 
			//======================================================
            //String sqlCmd="";
			StringBuffer sqlCmd = new StringBuffer() ;
			List sqlCmdList = new ArrayList() ;
			List sqlCmd_paramList = new ArrayList();
            String sqlCmd_sum="";//縣市別小計
            
            sqlCmd.append("");              
  			sqlCmd.append(" select  wlx01.bank_no,bn01.bank_name,wlx01.hsien_id,cd01.hsien_name,");
  			sqlCmd.append(" TO_CHAR(ebank_doc_date,'YYYY/MM/DD') as field_ebank_doc_date,");
            sqlCmd.append(" ebank_doc_no as field_ebank_doc_no,");
            sqlCmd.append(" field_1010_each,field_1010_day,field_1010_month,");
            sqlCmd.append(" field_1020_each,field_1020_day,field_1020_month,");
            sqlCmd.append(" field_1032_each,field_1032_day,field_1032_month,");   
            sqlCmd.append(" field_1033_each,field_1033_day,field_1033_month,");
            sqlCmd.append(" decode(ebank_s1,'Y','V',' ') as field_ebank_s1,");
            sqlCmd.append(" decode(ebank_s2,'Y','V',' ') as field_ebank_s2,");
            sqlCmd.append(" TO_CHAR(wlx01_epay_203.doc_date,'YYYY/MM/DD') as field_203_doc_date,");
            sqlCmd.append(" wlx01_epay_203.doc_no as field_203_doc_no,");
            sqlCmd.append(" field_2031_each,field_2031_day,field_2031_month,");
            sqlCmd.append(" field_2032_each,field_2032_day,field_2032_month,");
            sqlCmd.append(" field_2036_each,field_2036_day,field_2036_month,");
            sqlCmd.append(" TO_CHAR(wlx01_epay_204.doc_date,'YYYY/MM/DD') as field_204_doc_date,");
            sqlCmd.append(" wlx01_epay_204.doc_no as field_204_doc_no,");
            sqlCmd.append(" field_2047_each,field_2047_day,field_2047_month");
            sqlCmd.append(" from (select * from bn01 where bn01.m_year=?)bn01 left join (select * from wlx01 where m_year=?)wlx01 on bn01.bank_no = wlx01.bank_no");
            sqlCmd_paramList.add(u_year);     
            sqlCmd_paramList.add(u_year);      
            sqlCmd.append(" left join cd01 on wlx01.HSIEN_ID = cd01.HSIEN_ID");
            sqlCmd.append(" left join (");
            sqlCmd.append("      select bank_no,");
            sqlCmd.append("             sum(decode(limit_type,'101',decode(sub_type,'0',each_limit,0),0)) as field_1010_each,");
            sqlCmd.append("             sum(decode(limit_type,'101',decode(sub_type,'0',day_limit,0),0)) as field_1010_day,");
            sqlCmd.append("             sum(decode(limit_type,'101',decode(sub_type,'0',month_limit,0),0)) as field_1010_month,");
            sqlCmd.append("             sum(decode(limit_type,'102',decode(sub_type,'0',each_limit,0),0)) as field_1020_each,");
            sqlCmd.append("             sum(decode(limit_type,'102',decode(sub_type,'0',day_limit,0),0)) as field_1020_day,");
            sqlCmd.append("             sum(decode(limit_type,'102',decode(sub_type,'0',month_limit,0),0)) as field_1020_month,");
            sqlCmd.append("             sum(decode(limit_type,'103',decode(sub_type,'2',each_limit,0),0)) as field_1032_each,");
            sqlCmd.append("             sum(decode(limit_type,'103',decode(sub_type,'2',day_limit,0),0)) as field_1032_day,");
            sqlCmd.append("             sum(decode(limit_type,'103',decode(sub_type,'2',month_limit,0),0)) as field_1032_month,");
            sqlCmd.append("             sum(decode(limit_type,'103',decode(sub_type,'3',each_limit,0),0)) as field_1033_each,");
            sqlCmd.append("             sum(decode(limit_type,'103',decode(sub_type,'3',day_limit,0),0)) as field_1033_day,");
            sqlCmd.append("             sum(decode(limit_type,'103',decode(sub_type,'3',month_limit,0),0)) as field_1033_month");
            sqlCmd.append("       from wlx01_elimit");
            sqlCmd.append("       group by bank_no");
            sqlCmd.append("       order by bank_no");
            sqlCmd.append("       )wlx01_elimit on bn01.bank_no=wlx01_elimit.bank_no");
            sqlCmd.append(" left join (");
            sqlCmd.append("      select bank_no,");
            sqlCmd.append("             sum(decode(limit_type,'203',decode(sub_type,'1',each_limit,0),0)) as field_2031_each,");
            sqlCmd.append("             sum(decode(limit_type,'203',decode(sub_type,'1',day_limit,0),0)) as field_2031_day,");
            sqlCmd.append("             sum(decode(limit_type,'203',decode(sub_type,'1',month_limit,0),0)) as field_2031_month,");
            sqlCmd.append("             sum(decode(limit_type,'203',decode(sub_type,'2',each_limit,0),0)) as field_2032_each,");
            sqlCmd.append("             sum(decode(limit_type,'203',decode(sub_type,'2',day_limit,0),0)) as field_2032_day,");
            sqlCmd.append("             sum(decode(limit_type,'203',decode(sub_type,'2',month_limit,0),0)) as field_2032_month,");
            sqlCmd.append("             sum(decode(limit_type,'203',decode(sub_type,'6',each_limit,0),0)) as field_2036_each,");
            sqlCmd.append("             sum(decode(limit_type,'203',decode(sub_type,'6',day_limit,0),0)) as field_2036_day,");
            sqlCmd.append("             sum(decode(limit_type,'203',decode(sub_type,'6',month_limit,0),0)) as field_2036_month,");
            sqlCmd.append("             sum(decode(limit_type,'204',decode(sub_type,'7',each_limit,0),0)) as field_2047_each,");
            sqlCmd.append("             sum(decode(limit_type,'204',decode(sub_type,'7',day_limit,0),0)) as field_2047_day,");
            sqlCmd.append("             sum(decode(limit_type,'204',decode(sub_type,'7',month_limit,0),0)) as field_2047_month");
            sqlCmd.append("       from wlx01_epay");
            sqlCmd.append("       group by bank_no");
            sqlCmd.append("       order by bank_no");
            sqlCmd.append("       )wlx01_epay_sum on bn01.bank_no=wlx01_epay_sum.bank_no");
            sqlCmd.append(" left join (select distinct bank_no,limit_type,doc_date,doc_no from wlx01_epay where limit_type=?)wlx01_epay_203 on  bn01.bank_no=wlx01_epay_203.bank_no");                                
            sqlCmd_paramList.add("203");   
            sqlCmd.append(" left join (select distinct bank_no,limit_type,doc_date,doc_no from wlx01_epay where limit_type=?)wlx01_epay_204 on  bn01.bank_no=wlx01_epay_204.bank_no");
            sqlCmd_paramList.add("204");   
            sqlCmd.append(" where  bn01.bank_no in ("+selectBank_no+") and bn01.bn_type <> ? and business_item like '%13%' "); //業務項目有勾選電子銀行
            sqlCmd_paramList.add("2") ;    
            
            if(!order.equals("")){	  
			    //有挑選排序欄位年月時,查詢SQL error by 2295 						    	    
			    sqlCmd.append(" order by ").append(order) ;		    
  				//SoryBy=asc/desc
  				if( session.getAttribute("SortBy") != null && !((String)session.getAttribute("SortBy")).equals("")){	   
  		            sqlCmd.append(" " + (String)session.getAttribute("SortBy"));	  		              		        
  		        }
  		    }else{  		    	
  		    	//order by wlx01.bank_no   		       
  		       sqlCmd.append(" order by wlx01.bank_no ");  		       
  		    }    
                  			      
            //System.out.println("sqlCmd="+sqlCmd);
            //讀取報表欄位名稱===================================================================================        	
        	Properties p = new Properties();
			p.load(new FileInputStream(Utility.getProperties("schemaDir")+System.getProperty("file.separator")+"WLX_Elimit_column.TXT"));			
			//====================================================================================================
			
            //Creating Cells
            HSSFWorkbook wb = new HSSFWorkbook();
            HSSFSheet sheet = wb.createSheet( "report" ); //建立sheet，及名稱
            wb.setSheetName(0, titleName, HSSFWorkbook.ENCODING_UTF_16 );
            HSSFPrintSetup ps = sheet.getPrintSetup(); //取得設定            
            //設定頁面符合列印大小
            //sheet.setZoom(80, 100); // 螢幕上看到的縮放大小
            //sheet.setAutobreaks(true); //自動分頁            
            sheet.setAutobreaks( false );
            ps.setScale( ( short )100 ); //列印縮放百分比
            ps.setPaperSize( ( short )9 ); //設定紙張大小 A4            
            ps.setLandscape( true ); // 設定橫印
            //ps.setFitWidth((short)14);
            HSSFFooter footer = sheet.getFooter();            
            //設定樣式和位置(請精減style物件的使用量，以免style物件太多excel報表無法開啟)
			defaultStyle = reportUtil.getDefaultStyle(wb);//有框內文置中
			rightStyle = reportUtil.getRightStyle(wb);//有框內文置右
    		noBorderDefaultStyle = reportUtil.getNoBorderDefaultStyle(wb);//無框內文置中
    		noBorderLeftStyle = reportUtil.getNoBorderLeftStyle(wb);//無框內文置左
    		noBorderCenter_Red_UnderlineStyle = reportUtil.getCenter_Red_UnderlineStyle(wb);//95.09.21 add 無框內文置中.紅字+底線
    		noBorderRight_Red_UnderlineStyle = reportUtil.getRight_Red_UnderlineStyle(wb);//95.09.21 add 無框內文置右.紅字+底線
			reportUtil.setDefaultStyle(defaultStyle);
			reportUtil.setNoBorderDefaultStyle(noBorderDefaultStyle);			
    		titleStyle = reportUtil.getTitleStyle(wb); //標題用
    		columnStyle = reportUtil.getColumnStyle(wb);//報表欄位名稱用--有框內文置中			                                               
    		column_LeftStyle = reportUtil.getColumn_LeftStyle(wb);//報表欄位名稱用--有框內文置左	
    		noBoderStyle = reportUtil.getNoBoderStyle(wb);//無框置右			                                               
    		//============================================================================                        
            //設定表頭(信用部電子銀行基本資料表)===============================================================================
            row = sheet.createRow( ( short )1 );
            reportUtil.createCell( wb, row, ( short )1, titleName, titleStyle );
            
            for(i=2;i<columnLength+2;i++){
              reportUtil.createCell( wb, row, ( short )i, "", noBorderDefaultStyle );
            }            
            sheet.addMergedRegion( new Region( ( short )1, ( short )1,
                                               ( short )1,
                                               ( short )(columnLength+2)) );//依列印單位代號/機構名稱,再加2欄   
            /*                                   
            //列印年月=======================================================================================
            row = sheet.createRow( ( short )2 );            
            row.setHeight((short) 0x200);
            reportUtil.createCell( wb, row, ( short )1, S_YEAR + "年" + S_MONTH + "月", titleStyle );
            for(i=2;i<columnLength+4;i++){
               reportUtil.createCell( wb, row, ( short )i, "", noBorderDefaultStyle );
            }            
            sheet.addMergedRegion( new Region( ( short )2, ( short )1,
                                               ( short )2,
                                               ( short )(columnLength+4) ) );
            */                                   
            //======================================================================================================                                                                     
            row = sheet.createRow( ( short )3 );            
            String printTime = Utility.getDateFormat("  HH:mm:ss");
            String printDate = Utility.getDateFormat("yyyy/MM/dd");                                    
            reportUtil.createCell( wb, row, ( short )1, "列印日期："+Utility.getCHTdate(printDate, 1)+printTime, noBoderStyle );
            sheet.addMergedRegion( new Region( ( short )3, ( short )1,
                                               ( short )3,
                                               ( short )(columnLength+2) ) ); //依列印單位代號/機構名稱,再加2欄                      
            row = sheet.createRow( ( short )4 );                        
            //列印單位=======================================================================================            
            //System.out.println("unit_name="+Utility.getUnitName(Unit));                                               
            //System.out.println("columnLength="+columnLength);
            reportUtil.createCell( wb, row, ( short )1, "單位：新台幣"+Utility.getUnitName(Unit)+"、％", noBorderLeftStyle );                                                
            sheet.addMergedRegion( new Region( ( short )4, ( short )1,
                                               ( short )4,
                                               ( short )2) );          
            //設定列印人員==========================================================            
            reportUtil.createCell( wb, row, ( short )4, "列印人員："+lguser_name, noBoderStyle );
            sheet.addMergedRegion( new Region( ( short )4, ( short )4,
                                               ( short )4,
                                               ( short )(columnLength+2) ) ); //依列印單位代號/機構名稱,再加2欄           
            //報表欄位=======================================================================
            //列印單位代號+機構名稱             
            for(i=5;i<9;i++){
                row = sheet.createRow( ( short )i );
                reportUtil.createCell( wb, row, ( short )1, "單位代號", columnStyle );               
                reportUtil.createCell( wb, row, ( short )2, "單位名稱", columnStyle );                   
            }   
            
            sheet.addMergedRegion( new Region( ( short )5, ( short )1,
                                               ( short )8,
                                               ( short )1) );                                                                     
            sheet.addMergedRegion( new Region( ( short )5, ( short )2,
                                               ( short )8,
                                               ( short )2) );                                              
                                                                                                      
            System.out.println("大類表頭");                                               
            row = sheet.createRow( ( short )5 );//大類表頭
            int columnIdx = 3;
            int detailsize = 0;
            for(i=0;i<btnFieldList_data.size();i++){
                //System.out.println("["+i+"]i="+(String)((List)btnFieldList_data.get(i)).get(1));
                //System.out.println("columnIdx="+columnIdx);
                //設定表頭大類欄位
                detailsize=0;
                detail_column_detail = (List)h_column_detail.get((String)((List)btnFieldList_data.get(i)).get(0));//取得大類.包含的中類
			    for(detailidx=0;detailidx<detail_column_detail.size();detailidx++){
                    detailsize += ((List)h_column.get(((String)detail_column_detail.get(detailidx)))).size();//取得中類的細項			
                }
                
                for(j=columnIdx;j<detailsize + columnIdx;j++){                  
                  reportUtil.createCell( wb, row, ( short )j, (String)((List)btnFieldList_data.get(i)).get(1), columnStyle );               
                }
                //同意備查.約定帳戶轉帳.非約定帳戶轉帳.特店收單先不合併欄位(若先合併會造成最後合併大類及中類時.該項目merge無效果)
                if(!("同意備查".equals((String)((List)btnFieldList_data.get(i)).get(1)) || 
                     "約定帳戶轉帳".equals((String)((List)btnFieldList_data.get(i)).get(1)) || 
                     "非約定帳戶轉帳".equals((String)((List)btnFieldList_data.get(i)).get(1)) || 
                     "特店收單".equals((String)((List)btnFieldList_data.get(i)).get(1))
                )){
                
                sheet.addMergedRegion( new Region( ( short )5, ( short )columnIdx,
                                                   ( short )5,
                                                   ( short )(detailsize + columnIdx - 1)) );                                              
                }                                    
                columnIdx += detailsize;                                             
            }
            System.out.println("中類表頭");            
            row = sheet.createRow( ( short ) 6);//中類表頭            
            //row.setHeightInPoints(68);//設定大類表頭高度
            columnIdx = 3; 
            for(i=0;i<btnFieldList_data.size();i++){
               //System.out.println("["+i+"]i="+(String)((List)btnFieldList_data.get(i)).get(1));
               //System.out.println("columnIdx="+columnIdx);
               //設定表頭中類欄位               
               detail_column_detail = (List)h_column_detail.get((String)((List)btnFieldList_data.get(i)).get(0));//取得大類.包含的中類
			   for(detailidx=0;detailidx<detail_column_detail.size();detailidx++){
                   //System.out.println("detail.size="+((List)h_column.get(((String)detail_column_detail.get(detailidx)))).size());//取得中類的細項			
                   for(j=columnIdx;j<((List)h_column.get(((String)detail_column_detail.get(detailidx)))).size() + columnIdx;j++){
                      //System.out.println("detail.column="+(String)detail_column_detail.get(detailidx));
                      //System.out.println("detail.name="+Utility.ISOtoUTF8((String)prop_column_name.get((String)detail_column_detail.get(detailidx))));
                      reportUtil.createCell( wb, row, ( short )j, Utility.ISOtoUTF8((String)prop_column_name.get((String)detail_column_detail.get(detailidx))), columnStyle );                              
                   }
                   //同意備查.約定帳戶轉帳.非約定帳戶轉帳.特店收單先不合併欄位(若先合併會造成最後合併大類及中類時.該項目merge無效果)
                   if(!("同意備查".equals((String)((List)btnFieldList_data.get(i)).get(1)) || 
                        "約定帳戶轉帳".equals((String)((List)btnFieldList_data.get(i)).get(1)) || 
                        "非約定帳戶轉帳".equals((String)((List)btnFieldList_data.get(i)).get(1)) || 
                        "特店收單".equals((String)((List)btnFieldList_data.get(i)).get(1))
                   )){
                   sheet.addMergedRegion( new Region( ( short )6, ( short )columnIdx,
                                                      ( short )6,
                                                      ( short )(((List)h_column.get(((String)detail_column_detail.get(detailidx)))).size() + columnIdx - 1)) );                                              
                   }                                    
                   columnIdx +=  ((List)h_column.get(((String)detail_column_detail.get(detailidx)))).size(); 
               }                                           
            }
            System.out.println("細項表頭");  
            row = sheet.createRow( ( short ) 7);//細項表頭
            //row.setHeightInPoints(100);//設定細項表頭高度
            columnIdx = 3;          
            for(i=0;i<btnFieldList_data.size();i++){
               //System.out.println("["+i+"]i="+(String)((List)btnFieldList_data.get(i)).get(1));
               //System.out.println("columnIdx="+columnIdx);
               detail_column_detail = (List)h_column_detail.get((String)((List)btnFieldList_data.get(i)).get(0));//取得大類.包含的中類
               for(detailidx=0;detailidx<detail_column_detail.size();detailidx++){//中類
                   //System.out.println("detail.size="+((List)h_column.get(((String)detail_column_detail.get(detailidx)))).size());//取得中類.包含細項的size	
                   detail_column = (List)h_column.get(((String)detail_column_detail.get(detailidx)));//取得中類的細項		
                   //設定細項表頭欄位
                   for(j=0 ;j<detail_column.size();j++){                    
                       //System.out.println((String)detail_column.get(j)+"="+Utility.ISOtoUTF8((String)prop_column_name.get((String)detail_column.get(j))));                                           
                       reportUtil.createCell( wb, row, ( short )columnIdx, Utility.ISOtoUTF8((String)prop_column_name.get((String)detail_column.get(j))), columnStyle );               
                       columnIdx ++;
                   }//end of 細項                        
               }//end of中類                        
            }//end of 大類
            System.out.println("細項-科目代號");       
            row = sheet.createRow( ( short ) 8);//細項-科目代號
            columnIdx = 3;  
            for(i=0;i<btnFieldList_data.size();i++){
               //System.out.println("["+i+"]i="+(String)((List)btnFieldList_data.get(i)).get(1));
               //System.out.println("columnIdx="+columnIdx);
               detail_column_detail = (List)h_column_detail.get((String)((List)btnFieldList_data.get(i)).get(0));//取得大類.包含的中類
               for(detailidx=0;detailidx<detail_column_detail.size();detailidx++){//中類
                   //System.out.println("detail.size="+((List)h_column.get(((String)detail_column_detail.get(detailidx)))).size());//取得中類.包含細項的size	
                   detail_column = (List)h_column.get(((String)detail_column_detail.get(detailidx)));//取得中類的細項		
                   //設定細項表頭欄位
                   for(j=0 ;j<detail_column.size();j++){                    
                       //System.out.println((String)detail_column.get(j)+"="+Utility.ISOtoUTF8((String)prop_column_name.get((String)detail_column.get(j))));                                           
                       reportUtil.createCell( wb, row, ( short )columnIdx, (String)detail_column.get(j), columnStyle );               
                       columnIdx ++;
                   }//end of 細項                        
               }//end of中類                        
            }//end of 大類                    
            
            
            //wb.setRepeatingRowsAndColumns( 0, 1, 9, 1, 3 ); //設定表頭 為固定 先設欄的起始再設列的起始              
            wb.setRepeatingRowsAndColumns(0, 1, columnLength+2, 1, 8); //設定表頭 為固定 先設欄的起始再設列的起始
              						
  			//System.out.println("BR011W_Excel.sqlCmd="+sqlCmd);	   
  			
  			List dbData = null;
  			System.out.println("Query====================================") ;
			dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),sqlCmd_paramList,					
			        "field_1010_each,field_1010_day,field_1010_month,"+
                    "field_1020_each,field_1020_day,field_1020_month,"+
                    "field_1032_each,field_1032_day,field_1032_month,"+   
                    "field_1033_each,field_1033_day,field_1033_month,"+
                    "field_2031_each,field_2031_day,field_2031_month,"+
                    "field_2032_each,field_2032_day,field_2032_month,"+
                    "field_2036_each,field_2036_day,field_2036_month,"+
                    "field_2047_each,field_2047_day,field_2047_month"
                     ) ;
			
			short rowNo = ( short )9;//資料起始列     
			//無資料時,顯示訊息========================================================================			
			if(dbData == null || dbData.size() == 0){
			   	row = sheet.createRow( rowNo );     
                row.setHeight((short) 0x120); 
                reportUtil.createCell( wb, row, ( short )1,"無資料" ,noBorderDefaultStyle ); 
                sheet.addMergedRegion( new Region( ( short )9, ( short )1,
                                               ( short )9,
                                               ( short )(columnLength+4)) );
			}else{
				System.out.println("dbData.size()="+dbData.size());			
			    
			    //將DBData寫入===============================================================================================      
                acc_code_row = sheet.getRow(8);
                short lastCellNum = acc_code_row.getLastCellNum();
                //System.out.println("lastCellNum="+lastCellNum);                        
                columnIdx = 1;       
                double amt_d = 0.0;                 
                float amt_f = 0; 
                String amt_type="";
                String amt="";
                String prtbank_code="";
                for(i=0;i<dbData.size();i++){            
                    row = sheet.createRow( rowNo );                      
                    row.setHeight((short) 0x120);   
                   
                    reportUtil.createCell( wb, row, ( short )columnIdx, (String) ((DataObject) dbData.get(i)).getValue("bank_no"), defaultStyle );//單位代號
                    columnIdx++;
                    reportUtil.createCell( wb, row, ( short )columnIdx, (String) ((DataObject) dbData.get(i)).getValue("bank_name"), defaultStyle );//機構名稱
                    columnIdx++;                    
                
                    for(int cellIdx =3;cellIdx < (new Short(lastCellNum)).intValue();cellIdx++){                    
                         amt="";
                         amt_type = "";
                         cell = acc_code_row.getCell((short)cellIdx);                    
                         //System.out.println("acc_code="+cell.getStringCellValue());     
                         
                         if(((DataObject) dbData.get(i)).getValue(cell.getStringCellValue()) != null){ 
                         	amt =(((DataObject) dbData.get(i)).getValue(cell.getStringCellValue())).toString();  
                         	//金額欄位才須除以單位
                         	if(cell.getStringCellValue().indexOf("1010") != -1 || cell.getStringCellValue().indexOf("1020") != -1 || cell.getStringCellValue().indexOf("1032") != -1 || 
						       cell.getStringCellValue().indexOf("1033") != -1 || cell.getStringCellValue().indexOf("2031") != -1 || cell.getStringCellValue().indexOf("2032") != -1 || 
							   cell.getStringCellValue().indexOf("2036") != -1 || cell.getStringCellValue().indexOf("2047") != -1 )
							{
	    	                   amt = Utility.getRound(amt,Unit);                        
	        	               amt = Utility.setCommaFormat(amt);
                	        }
                         }                        
                         reportUtil.createCell( wb, row, ( short )columnIdx, amt, rightStyle );               
                         columnIdx ++;
                    }       
                    columnIdx = 1;
                    rowNo++;                   
                }//end of dbData   
            
            }//end of 有data   
            
            //95.09.21 設定表頭欄位.把中間值的acc_code合併成一個欄位只顯示中文名稱=======================================================================                        
            row = sheet.getRow(7);
            columnIdx = 3;    
                    
             for(i=0;i<btnFieldList_data.size();i++){
               //System.out.println("["+i+"]i="+(String)((List)btnFieldList_data.get(i)).get(1));
               //System.out.println("columnIdx="+columnIdx);
               detail_column_detail = (List)h_column_detail.get((String)((List)btnFieldList_data.get(i)).get(0));//取得大類.包含的中類
               for(detailidx=0;detailidx<detail_column_detail.size();detailidx++){//中類
                   //System.out.println("detail.size="+((List)h_column.get(((String)detail_column_detail.get(detailidx)))).size());//取得中類.包含細項的size	
                   detail_column = (List)h_column.get(((String)detail_column_detail.get(detailidx)));//取得中類的細項		
                   //設定細項表頭欄位                   
                   for(j=0 ;j<detail_column.size();j++){                    
                       //System.out.println((String)detail_column.get(j)+"="+Utility.ISOtoBig5((String)prop_column_name.get((String)detail_column.get(j))));
                       reportUtil.createCell( wb, row, ( short )columnIdx, Utility.ISOtoUTF8((String)prop_column_name.get((String)detail_column.get(j))), columnStyle );                                      
                        
                       //System.out.println((String)prop_column_name.get((String)detail_column.get(j)));
                      
                       //設定細項表頭欄位.把中間值的acc_code合併成一個欄位只顯示中文名稱=====================================                                      
                       sheet.addMergedRegion( new Region( ( short )7, ( short )columnIdx,
                        				                  ( short )8,
                                        			      ( short ) columnIdx ) );                             
                                     			           
                       columnIdx ++;
                   }//end of 細項                                                                                                     
               }//end of中類                        
            }//end of 大類  			
               
                             
            row = sheet.getRow(5);
            columnIdx = 3;    
            int merge_idx_b=0;
            int merge_idx_e=0;
            //109.06.24 合併大類及中類(只合併同意備查/約定帳戶轉帳/非約定帳戶轉帳/特店收單)    
            for(i=0;i<btnFieldList_data.size();i++){
               //System.out.println("["+i+"]i="+(String)((List)btnFieldList_data.get(i)).get(1));
               //System.out.println("columnIdx="+columnIdx);
               merge_idx_b = columnIdx;
               detail_column_detail = (List)h_column_detail.get((String)((List)btnFieldList_data.get(i)).get(0));//取得大類.包含的中類
               for(detailidx=0;detailidx<detail_column_detail.size();detailidx++){//中類
               	   //System.out.println("columnIdx="+columnIdx);
                   //System.out.println("detail.size="+((List)h_column.get(((String)detail_column_detail.get(detailidx)))).size());//取得中類.包含細項的size	
                   detail_column = (List)h_column.get(((String)detail_column_detail.get(detailidx)));//取得中類的細項		
                   //設定細項表頭欄位                   
                   for(j=0 ;j<detail_column.size();j++){                    
                       //System.out.println((String)detail_column.get(j)+"="+Utility.ISOtoUTF8((String)prop_column_name.get((String)detail_column.get(j))));
                       //109.07.07reportUtil.createCell( wb, row, ( short )columnIdx, Utility.ISOtoUTF8((String)prop_column_name.get((String)detail_column.get(j))), columnStyle );                                      
                       reportUtil.createCell( wb, row, ( short )columnIdx, (String)((List)btnFieldList_data.get(i)).get(1), columnStyle ); 
                       //System.out.println(Utility.ISOtoUTF8((String)prop_column_name.get((String)detail_column.get(j))));
                       merge_idx_e=columnIdx;//109.07.07 add
                       columnIdx ++;
                   }//end of 細項                                                                                                     
               }//end of中類     
               if("同意備查".equals((String)((List)btnFieldList_data.get(i)).get(1)) || 
                  "約定帳戶轉帳".equals((String)((List)btnFieldList_data.get(i)).get(1)) || 
                  "非約定帳戶轉帳".equals((String)((List)btnFieldList_data.get(i)).get(1)) || 
                  "特店收單".equals((String)((List)btnFieldList_data.get(i)).get(1))
               ){
               	 //System.out.println("merge_idx_b="+merge_idx_b+":merge_idx_e="+merge_idx_e);
               	 //設定細項表頭欄位.把中間值的acc_code合併成一個欄位只顯示中文名稱=====================================                                             	         
                  sheet.addMergedRegion( new Region( ( short )5, ( short )merge_idx_b,
                     	  		                     ( short )6,
                                        			 ( short ) merge_idx_e ) ); 
                                        			     
               }	                   
            }//end of 大類/中類-合併表頭  			
            
                                           			      
                                        			      
               
            //設定寬度============================================================                                   
            for ( i = 1; i <= columnLength+4; i++ ) {                
                if(i==2){
                  sheet.setColumnWidth( ( short )i,
                                        ( short ) ( 256 * ( 25 + 4 ) ) );//機構名稱
                }else{
                  sheet.setColumnWidth( ( short )i,
                                        ( short ) ( 256 * ( 8 + 4 ) ) );
                }                        
            }		
			//======================================================================================
			
            //設定涷結欄位
            //if(haveViolate.equals("false")){//隱藏違反(***)
                //sheet.setColumnWidth( ( short )1,(short)0);//違反(***)
            //}
            
            //sheet.createFreezePane(0,1,0,1);
            footer.setCenter( "Page:" + HSSFFooter.page() + " of " +
                             HSSFFooter.numPages() );		                                 
			footer.setRight(Utility.getDateFormat("yyyy/MM/dd hh:mm aaa"));			
			
            // Write the output to a file            
            fileOut = new FileOutputStream( Utility.getProperties("reportDir")+System.getProperty("file.separator")+ titleName+".xls" );
            wb.write( fileOut );
            fileOut.close();            
            
            String filename = titleName+".xls";//108.03.25 add
            if(!printStyle.equalsIgnoreCase("xls")) {//108.03.25非xls檔須執行轉換	                
	  			rptTrans rptTrans = new rptTrans();	  			
	  			filename = rptTrans.transOutputFormat (printStyle,filename,""); 
	  			System.out.println("newfilename="+filename);	  			   
            };
            
            FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+ filename);//108.03.25 fix 		 
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
        	System.out.println("BR011W_Report have erros:"+e.getMessage()) ; 
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
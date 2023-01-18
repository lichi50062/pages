<%
//94.01.20  create by 2295
//94.03.23  add 營運中/已裁撤 by 2295
//94.06.14  fix 改用left join by 2295
//98.07.15  add 原始核准該單位設立之機構代號/地方主管機關代號/參加的電腦共用中心機構代碼
//			    本機構員工總人數(不含分支機構人數)從事信用業務之員工人數
//			    國內營業分支機構家數/分支機構員工總人數/理事人數/監事人數   by 2295
//99.12.14  fix SQLInjection by 2479
//99.12.23  fix 根據查詢年度.100年以後取得新縣市別.100年以前取得舊縣市別 by 2295
//101.06    add 報表欄位 by 2968
//103.01    add 稽核人員報表欄位 by 2968 
//104.06    add 人員配置欄位 by 2968
//106.03    add 通匯代號、業務項目、其他揭露事項 by 2968
//106.12.20 fix 部份欄位無法顯示問題 by 2295
//107.05.14 add 最近地方主管機關同意信用部分部主任函日期/最近地方主管機關同意信用部分部主任函文號 by 6404
//108.04.29 add 報表格式轉換 by 2295
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
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.lang.StringBuffer" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>


<%
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁
   
   String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");			  
   System.out.println("act="+act);
   String printStyle = "";//輸出格式 108.04.29 add 	     
   //輸出格式 108.04.29 add
   if(session.getAttribute("printStyle") != null && !((String)session.getAttribute("printStyle")).equals("")){
   	 printStyle = (String)session.getAttribute("printStyle");		  				  
   }
   if(act.equals("view")){
      //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
      //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔 
      response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.04.29調整顯示的副檔名
   }else if (act.equals("download")){   
      response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.04.29調整顯示的副檔名
   }
   
%>
<%
	String actMsg = "";
	FileOutputStream fileOut = null;      
	/*
  	int[] columnLen = {
  	15,30,18,40,18,
  	40,15,12,13,10,
  	15,10,40,20,15,
  	40,15,20,17,40,
  	17,20,15,23,18,
  	40,20,18,15};
  	*/
  	int[] columnLen = null;
    HSSFCellStyle defaultStyle;
    HSSFCellStyle noBorderDefaultStyle;
    HSSFCellStyle titleStyle;
	HSSFCellStyle columnStyle;
	HSSFCellStyle noBoderStyle;
	HSSFRow row;
	String report_no = "BR002W";	 
	String titleName = Utility.getPgName(report_no);
    reportUtil reportUtil = new reportUtil();
    String BankList = "";
    String btnFieldList = "";
    String SortList = "";
    String CANCEL_NO = "";
    String S_YEAR = "";//99.12.23 add
    String S_MONTH = "";//99.12.23 add
    List BankList_data = null;
    List btnFieldList_data = null;
    List SortList_data = null;    
	int i = 0;	
	String lguser_name = ( session.getAttribute("muser_name")==null ) ? "" : (String)session.getAttribute("muser_name");
	//99.12.23 add==================================================================
	String cd01_table = "";
    String wlx01_m_year = "";    
	//============================================================================
	try{
			//儲存報表的目錄================================================================
        	File reportDir = new File(Utility.getProperties("reportDir"));       
    		if(!reportDir.exists()){
     			if(!Utility.mkdirs(Utility.getProperties("reportDir"))){
     	   			actMsg +=Utility.getProperties("reportDir")+"目錄新增失敗";
     			}    
    		}
    		//==============================================================================
    		//查詢日期-年//99.12.23 add
    		if(session.getAttribute("S_YEAR") != null && !((String)session.getAttribute("S_YEAR")).equals("")){
		  		S_YEAR = (String)session.getAttribute("S_YEAR");		  				   
			}
			//查詢日期-月//99.12.23 add
			if(session.getAttribute("S_MONTH") != null && !((String)session.getAttribute("S_MONTH")).equals("")){
		  		S_MONTH = (String)session.getAttribute("S_MONTH");		  				   
			}
    		//營運中/已裁撤
			if(session.getAttribute("CANCEL_NO") != null && !((String)session.getAttribute("CANCEL_NO")).equals("")){
		  		CANCEL_NO = (String)session.getAttribute("CANCEL_NO");		  				   
			}
    		//金融機構
			if(session.getAttribute("BankList") != null && !((String)session.getAttribute("BankList")).equals("")){
		   		BankList = (String)session.getAttribute("BankList");
		   		BankList_data = Utility.getReportData(BankList);
		   		System.out.println("BankList_data.size()="+BankList_data.size());		   
			}
			//報表欄位
			if(session.getAttribute("btnFieldList") != null && !((String)session.getAttribute("btnFieldList")).equals("")){
		   		btnFieldList = (String)session.getAttribute("btnFieldList");
		   		btnFieldList_data = Utility.getReportData(btnFieldList);
		   		System.out.println("btnFieldList_data.size()="+btnFieldList_data.size());		   
			}
			//排序欄位
			if(session.getAttribute("SortList") != null && !((String)session.getAttribute("SortList")).equals("")){
		  		SortList = (String)session.getAttribute("SortList");
		  		SortList_data = Utility.getReportData(SortList);
		   		System.out.println("SortList_data.size()="+SortList_data.size());		   
			}
        	
        	//機構類別
			if(session.getAttribute("nowbank_type") != null && !((String)session.getAttribute("nowbank_type")).equals("")){
		  		if(((String)session.getAttribute("nowbank_type")).equals("6")){
		  		   titleName = "農會"+titleName;
		  		}		  		
		  		if(((String)session.getAttribute("nowbank_type")).equals("7")){
		  		   titleName = "漁會"+titleName;
		  		}
			}
			System.out.println("titleName="+titleName);
        	//讀取報表欄位長度===================================================================================
        	Properties p = new Properties();
			p.load(new FileInputStream(Utility.getProperties("schemaDir")+System.getProperty("file.separator")+"WLX01.length"));
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
    		noBorderDefaultStyle = reportUtil.getNoBorderDefaultStyle(wb);//無框內文置中
			reportUtil.setDefaultStyle(defaultStyle);
			reportUtil.setNoBorderDefaultStyle(noBorderDefaultStyle);			
    		titleStyle = reportUtil.getTitleStyle(wb); //標題用
    		columnStyle = reportUtil.getColumnStyle(wb);//報表欄位名稱用--有框內文置中			                                               
    		noBoderStyle = reportUtil.getNoBoderStyle(wb);//無框置右			                                               
    		//============================================================================
            
            
            //設定title===============================================================================
            row = sheet.createRow( ( short )1 );
            reportUtil.createCell( wb, row, ( short )1, titleName, titleStyle );
            
            for(i=2;i<btnFieldList_data.size()+2;i++){
              reportUtil.createCell( wb, row, ( short )i, "", noBorderDefaultStyle );
            }
            
            sheet.addMergedRegion( new Region( ( short )1, ( short )1,
                                               ( short )1,
                                               ( short )(btnFieldList_data.size()) ) );
            
            row = sheet.createRow( ( short )2 );
            
            row.setHeight((short) 0x200);
            reportUtil.createCell( wb, row, ( short )1, "", titleStyle );
            for(i=2;i<btnFieldList_data.size()+2;i++){
               reportUtil.createCell( wb, row, ( short )i, "", noBorderDefaultStyle );
            }            
            //設定列印日期==========================================================
            row = sheet.createRow( ( short )3 );            
            String printTime = Utility.getDateFormat("  HH:mm:ss");
            String printDate = Utility.getDateFormat("yyyy/MM/dd");                                    
            reportUtil.createCell( wb, row, ( short )1, "列印日期："+Utility.getCHTdate(printDate, 1)+printTime, noBoderStyle );
            sheet.addMergedRegion( new Region( ( short )3, ( short )1,
                                               ( short )3,
                                               ( short )(btnFieldList_data.size()) ) );
            //設定列印人員==========================================================
            row = sheet.createRow( ( short )4 );                        
            reportUtil.createCell( wb, row, ( short )1, "列印人員："+lguser_name, noBoderStyle );
            sheet.addMergedRegion( new Region( ( short )4, ( short )1,
                                               ( short )4,
                                               ( short )(btnFieldList_data.size()) ) );
            
            //===============================================================================
            columnLen = new int[btnFieldList_data.size()];
            String column = "";//選取欄位
            String selectBank_no = "";//選取的金融機構代號
            String condition = " BN01.bank_no=WLX01.bank_no ";
            String leftjointable = " ";//94.06.14
            String cdsharenotable = "";//94.06.14
            //99.12.23 add 查詢年度100年以前.縣市別不同===============================
  	    	cd01_table = (Integer.parseInt(S_YEAR) < 100)?"cd01_99":"cd01"; 
  	    	wlx01_m_year = (Integer.parseInt(S_YEAR) < 100)?"99":"100"; 
  	    	//=====================================================================      
            //94.03.23 add 營運中/已裁撤============================ 
            if(CANCEL_NO.equals("N")){//營運中
			   condition += " and BN01.bn_type <> '2'";//條件
			}else{//已裁撤
			   condition += " and BN01.bn_type = '2'";//條件
			}			  	 
			//======================================================
            String table = " (select * from bn01 where m_year=?)BN01,(select * from wlx01 where m_year=?)WLX01 ";//查詢table
            String order = "";//排序欄位
            String sqlCmd="";                     
            
            List paramList = new ArrayList() ;
            
            paramList.add(wlx01_m_year);//bn01用
            paramList.add(wlx01_m_year);//wlx01用
            boolean joinAudit = false;
            boolean flg = true;
            //報表欄位=======================================================================
            row = sheet.createRow( ( short )5 );//表頭
            for(i=0;i<btnFieldList_data.size();i++){
               System.out.println("["+i+"]i="+(String)((List)btnFieldList_data.get(i)).get(1)+":"+(String)((List)btnFieldList_data.get(i)).get(0));
               //設定表頭欄位
               reportUtil.createCell( wb, row, ( short )(i+1), (String)((List)btnFieldList_data.get(i)).get(1), columnStyle );               
               //取得報表欄位長度
               columnLen[i]=Integer.parseInt(((String)p.get((String)((List)btnFieldList_data.get(i)).get(0))).trim());
               //選取欄位         			 
			   if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("cdshareno.cmuse_name")){
			       column += " cdshareno.cmuse_name as chg_license_reason_name";			   	  
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("cd01_02.hsien_name")){
			       column += " cd01_02.hsien_name as it_hsien_name";			   	  
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("cd02_02.area_name")){
			   	   column += " cd02_02.area_name as it_area_name";			   	  
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("wlx01_audit.name")){
			       column += " wlx01_audit.name as audit_name";
			       joinAudit = true;
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("wlx01_audit.telno")){
			       column += " wlx01_audit.telno as audit_telno";
			       joinAudit = true;
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("wlx01_audit.addr")){
			       column += " wlx01_audit.addr as audit_addr";  
			       joinAudit = true;
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("cd01_03.hsien_name")){
			       column += " cd01_03.hsien_name as audit_hsien_name";
			       joinAudit = true;
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("cd02_03.area_name")){
			       column += " cd02_03.area_name as audit_area_name";
			       joinAudit = true;
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("wlx01_audit.area_id")){
			       column += " wlx01_audit.area_id as AUDIT_AREA_ID";
			       joinAudit = true;
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("wlx01_audit.department")){
			       column += " wlx01_audit.department as audit_department";
			       joinAudit = true;
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("wlx01_audit.setup_date")){
			       column += " wlx01_audit.setup_date as audit_setup_date";
			       joinAudit = true;
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("wlx01_audit.setup_no")){
			       column += " wlx01_audit.setup_no as audit_setup_no";
			       joinAudit = true;
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("wlx01_audit.full_time")){
			       column += " decode(WLX01_AUDIT.FULL_TIME,'Y','是','N','否',WLX01_AUDIT.FULL_TIME) as audit_full_time";
			       joinAudit = true;
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("wlx01_audit.part_time")){
			       column += " decode(WLX01_AUDIT.PART_TIME,'Y','是','N','否',WLX01_AUDIT.PART_TIME) as audit_part_time";
			       joinAudit = true;
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("wlx01_audit.part_time_date")){
			       column += " wlx01_audit.part_time_date as audit_part_time_date";
			       joinAudit = true;
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("wlx01_audit.part_time_no")){
			       column += " wlx01_audit.part_time_no as audit_part_time_no";
			       joinAudit = true;
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("cdshareno1.cmuse_name")){
			       column += " cdshareno1.cmuse_name as setup_approval_unt_name";
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("WLX01.bank_no_1name")){
			       column += " F_COMBWLX01_MNAME(WLX01.bank_no,'1') as wlx04_1name";
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("WLX01.bank_no_2name")){
			       column += " F_COMBWLX01_MNAME(WLX01.bank_no,'2') as wlx04_2name";
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("WLX01.bank_no_3name")){
			       column += " F_COMBWLX01_MNAME(WLX01.bank_no,'3') as wlx04_3name";
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("WLX01.bank_no_4name")){
			       column += " F_COMBWLX01_MNAME(WLX01.bank_no,'4') as wlx04_4name";
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("WLX01.BUSINESS_ITEM")){
			       column += " F_TRANSBUSITEM(WLX01.BUSINESS_ITEM,WLX01.BUSINESS_ITEM_EXTRA) as BUSINESS_ITEM";
			   }else { 			  
               		column += (String)((List)btnFieldList_data.get(i)).get(0);
               }
               		
               if(i < btnFieldList_data.size() -1){
               	  column += ", ";
               }
               //條件式跟table=============================================================================
               if(joinAudit && flg){
                   leftjointable += " LEFT JOIN WLX01_AUDIT on WLX01_AUDIT.bank_no=WLX01.bank_no ";
               	   flg = false;
               }
               if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("cdshareno.cmuse_name")){
               	  //condition += " and cdshareno.cmuse_div = '004' and cdshareno.cmuse_id=wlx01.chg_license_reason";
               	  //table += ",cdshareno";
               	  //cdsharenotable = ",cdshareno";
               	   leftjointable += " LEFT JOIN cdshareno on cdshareno.cmuse_id=WLX01.chg_license_reason  and cdshareno.cmuse_div = '004'";
               }
               
               if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("cd01_01.hsien_name")){               	 
               	  leftjointable += " LEFT JOIN "+cd01_table+" cd01_01 on WLX01.hsien_id=cd01_01.hsien_id ";
               }
               
               if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("cd02_01.area_name")){               	  
               	   leftjointable += " LEFT JOIN cd02 cd02_01 on WLX01.area_id=cd02_01.area_id ";
               }
               
               if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("cd01_02.hsien_name")){               	 
               	  leftjointable += " LEFT JOIN "+cd01_table+" cd01_02 on WLX01.it_hsien_id=cd01_02.hsien_id ";
               }
				
			   if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("cd02_02.area_name")){               	  
               	  leftjointable += " LEFT JOIN cd02 cd02_02 on WLX01.it_area_id=cd02_02.area_id ";
               }	
               
               if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("cd01_03.hsien_name")){               	 
               	  leftjointable += " LEFT JOIN "+cd01_table+" cd01_03 on WLX01_AUDIT.hsien_id=cd01_03.hsien_id ";
               }
               
               if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("cd02_03.area_name")){               	    
               	  leftjointable += " LEFT JOIN cd02 cd02_03 on WLX01_AUDIT.area_id=cd02_03.area_id ";        	  
               }
               //原始核准該單位設立之機構代號
               if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("cdshareno1.cmuse_name")){
               	  leftjointable += " LEFT JOIN cdshareno cdshareno1 on cdshareno1.cmuse_id=WLX01.SETUP_APPROVAL_UNT  and cdshareno1.cmuse_div = '019' ";        	  
               }
               //地方主管機關代號
               if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("ba01.m2_name_bank_name")){
               	  leftjointable += " LEFT JOIN (select bank_no,bank_name as m2_name_bank_name from (select * from ba01 where m_year=?)ba01 where bank_type='B' and bank_kind='0')ba01 on ba01.bank_no = WLX01.M2_NAME ";        	  
               	  paramList.add(wlx01_m_year);
               }
               //電腦共用中心
               if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("ba01_1.center_no_name")){
               	  leftjointable += " LEFT JOIN (select bank_no,bank_name as center_no_name from (select * from ba01 where m_year=?)ba01 where bank_type='8' and bank_kind='0')ba01_1 on ba01_1.bank_no = WLX01.CENTER_NO ";        	  
               	  paramList.add(wlx01_m_year);
               }
               //國內營業分支機構家數/分支機構員工總人數              
               if(   leftjointable.indexOf("wlx02count") == -1 &&
                  (((String)((List)btnFieldList_data.get(i)).get(0)).equals("wlx02.wlx02count") ||
                  ((String)((List)btnFieldList_data.get(i)).get(0)).equals("wlx02.wlx02staff_num")))
               {
               	  leftjointable += " LEFT JOIN (select tbank_no,count(*) as wlx02count, " //--國內營業分支機構家數
	   						    +  "                   sum(staff_num) as wlx02staff_num "//---分支機構員工總人數
								+  "            from (select * from wlx02 where m_year=?)wlx02"
								+  "            where CANCEL_NO <> 'Y' OR CANCEL_NO IS NULL "
								+  "            group by tbank_no)wlx02 on wlx02.tbank_no = WLX01.bank_no ";        	  
				  paramList.add(wlx01_m_year);			
               }
               //理事人數/監事人數  
               if(   leftjointable.indexOf("wlx04_1count") == -1 &&          
                 (((String)((List)btnFieldList_data.get(i)).get(0)).equals("wlx04.wlx04_1count") ||
                  ((String)((List)btnFieldList_data.get(i)).get(0)).equals("wlx04.wlx04_2count")))
               {
               	  leftjointable += " LEFT JOIN (select bank_no," 
							    +  "                   sum(decode(wlx04.position_code,'1',1,0)) as wlx04_1count,"//--理事人數
								+  " 		 		   sum(decode(wlx04.position_code,'2',1,0)) as wlx04_2count "// --監事人數
								+  "   			from wlx04 "
								+  "    	    where (wlx04.abdicate_code <> 'Y' OR wlx04.abdicate_code IS NULL) "
								+  "   			group by bank_no)wlx04 on wlx04.bank_no = WLX01.bank_no ";		       	  
               }
               //=========================================================================================
            }
            
            
            //排序欄位=========================================================================
            if(SortList_data != null && SortList_data.size() != 0){
            	for(i=0;i<SortList_data.size();i++){
            	    if("WLX01.bank_no_1name".equals(((List)SortList_data.get(i)).get(0))){
            	        order += "wlx04_1name";
            	    }else if("WLX01.bank_no_2name".equals(((List)SortList_data.get(i)).get(0))){
            	        order += "wlx04_2name";
            	    }else if("WLX01.bank_no_3name".equals(((List)SortList_data.get(i)).get(0))){
            	        order += "wlx04_3name";
            	    }else if("WLX01.bank_no_4name".equals(((List)SortList_data.get(i)).get(0))){
            	        order += "wlx04_4name";
            	    }else{
            	        order += (String)((List)SortList_data.get(i)).get(0);
            	    }
            		if(i < SortList_data.size() -1 ) order +=",";            
	            }
	            System.out.println("order="+order);
            }
            //====================================================================================
            //wb.setRepeatingRowsAndColumns( 0, 1, 8, 1, 3 ); //設定表頭 為固定 先設欄的起始再設列的起始
            wb.setRepeatingRowsAndColumns(0, 1, btnFieldList_data.size(), 1, 5); //設定表頭 為固定 先設欄的起始再設列的起始
  			
  			//金融機構代號=============================================================
            if(BankList_data != null && BankList_data.size() != 0){
               selectBank_no += " WLX01.bank_no IN (";
               for(i=0;i<BankList_data.size();i++){
                 selectBank_no +="?";
                 paramList.add((String)((List)BankList_data.get(i)).get(0));
            	 //selectBank_no +="'"+(String)((List)BankList_data.get(i)).get(0)+"'";            	
            	 if(i < BankList_data.size()-1) selectBank_no +=",";
               }
               selectBank_no += ")";
            }   
            //==============================================================================
            
            /*
            select  BN01.BANK_NO, BN01.exchange_no, --通匯代號 106.02.18 add
             		BN01.BANK_NAME, WLX01.SETUP_DATE, WLX01.SETUP_NO, 
                    WLX01.CHG_LICENSE_DATE, WLX01.CHG_LICENSE_NO,  
                    cdshareno.cmuse_name as chg_license_reason_name, 
                    WLX01.START_DATE, WLX01.BUSINESS_ID, 
                    ba01.m2_name_bank_name, ba01_1.center_no_name, 
                    WLX01.STAFF_NUM, 
                    WLX01.CREDIT_STAFF_NUM, 
                    WLX01.CREDIT_STAFF,--正式職員 104.03.19 add
                    WLX01.SKILL_STAFF,--技工  104.03.19 add
                    WLX01.MANUAL_STAFF,--工友 104.03.19 add
                    WLX01.TEMP_STAFF,--特約人員 104.03.19 add
                    cd01_01.hsien_name, 
                    cd02_01.area_name, WLX01.AREA_ID, WLX01.ADDR, WLX01.TELNO,                     
                    WLX01.FAX,
                    WLX01.WEB_SITE,--網址 101.06.11 add 
                    WLX01.EMAIL, --email帳號
                    cd01_02.hsien_name as it_hsien_name,  
                    cd02_02.area_name as it_area_name, WLX01.IT_AREA_ID, WLX01.IT_ADDR, 
                    WLX01.IT_NAME, WLX01.IT_TELNO,  
                    --原audit拿掉 --增加為新的 103.01.02 add 並按照下列順序增加在可挑選欄位
                    WLX01_AUDIT.name as AUDIT_NAME, --稽核人員聯絡姓名
                    WLX01_AUDIT.telno as AUDIT_TELNO, --稽核人員電話
                    WLX01_AUDIT.addr as AUDIT_ADDR, --稽核人員地址
                    cd01_03.hsien_name as audit_hsien_name, --稽核人員縣市別  
                    cd02_03.area_name as audit_area_name, --稽核人員(鄉/鎮/市/區)
                    WLX01_AUDIT.area_id as AUDIT_AREA_ID, --稽核人員郵遞區號                    
                    WLX01_AUDIT.DEPARTMENT as audit_department, --稽核人員隸屬部門  
                    WLX01_AUDIT.SETUP_DATE as audit_setup_date, --稽核人員主管機關核准日期 
                    WLX01_AUDIT.SETUP_NO as audit_setup_no, --稽核人員主管機關核准文號 
                    decode(WLX01_AUDIT.FULL_TIME,'Y','是','N','否',WLX01_AUDIT.FULL_TIME) as audit_full_time, --稽核人員專任與否 
                    decode(WLX01_AUDIT.PART_TIME,'Y','是','N','否',WLX01_AUDIT.PART_TIME) as audit_part_time, --稽核人員兼任與否 103.01.07 add
                    WLX01_AUDIT.PART_TIME_DATE as audit_part_time_date, --稽核人員主管機關核准兼任日期103.01.07 add 
                    WLX01_AUDIT.PART_TIME_NO as audit_part_time_no, --稽核人員主管機關核准兼任文號103.01.07 add 
                    WLX01.OPEN_DATE, 
                    WLX01.SETUP_APPROVAL_UNT,cdshareno1.cmuse_name as setup_approval_unt_name, --原始核准該單位設立之機構代號
                    WLX01.M2_NAME,ba01.m2_name_bank_name, --地方主管機關代號
                    WLX01.CENTER_NO,ba01_1.center_no_name, --電腦共用中心
                    WLX01.STAFF_NUM, --總機構員工總人數(不含分支機構人數)
                    WLX01.CREDIT_STAFF_NUM, --從事信用業務之員工人數(含總機構及分支機構)
                    wlx02.wlx02count,--分支機構總數 -->101.06.11 add
                    wlx02.wlx02staff_num, ---分支機構員工總人數
                    wlx04.wlx04_1count,--理事人數
                    wlx04.wlx04_2count, --監事人數
                    F_COMBWLX04NAME(WLX01.bank_no,'1') as wlx04_1name,-- 理事長姓名
                    F_COMBWLX04NAME(WLX01.bank_no,'2') as wlx04_2name,-- 常務監事姓名
                    F_COMBWLX04NAME(WLX01.bank_no,'3') as wlx04_3name,--總幹事姓名
                    F_COMBWLX04NAME(WLX01.bank_no,'4') as wlx04_4name, --信用部主任姓名
                    WLX01.business_item, --業務項目 106.02.18 add
                    WLX01.business_item_extra, --其他業務項目說明 106.02.18 add
                    WLX01.extra_info --其他揭露事項 106.02.18 add
             from  (select * from BN01 where m_year=100)bn01, (select * from wlx01 where m_year=100)WLX01  
             LEFT JOIN WLX01_AUDIT on  WLX01_AUDIT.bank_no=WLX01.bank_no        
             LEFT JOIN cd01 cd01_01 on WLX01.hsien_id=cd01_01.hsien_id  --總機構.地址
             LEFT JOIN cd02 cd02_01 on WLX01.area_id=cd02_01.area_id  
             LEFT JOIN cd01 cd01_02 on WLX01.it_hsien_id=cd01_02.hsien_id  --資訊單位.地址
             LEFT JOIN cd02 cd02_02 on WLX01.it_area_id=cd02_02.area_id  
             LEFT JOIN cd01 cd01_03 on WLX01_AUDIT.hsien_id=cd01_03.hsien_id --稽核人員.地址103.01.02 add
             LEFT JOIN cd02 cd02_03 on WLX01_AUDIT.area_id=cd02_03.area_id --稽核人員.地址103.01.02 add
             LEFT JOIN cdshareno on cdshareno.cmuse_id=WLX01.chg_license_reason  and cdshareno.cmuse_div = '004'
             LEFT JOIN cdshareno cdshareno1 on cdshareno1.cmuse_id=WLX01.SETUP_APPROVAL_UNT  and cdshareno1.cmuse_div = '019'
             LEFT JOIN (select bank_no,bank_name as m2_name_bank_name from (select * from ba01 where m_year=99)ba01 where bank_type='B' and bank_kind='0')ba01 on ba01.bank_no = WLX01.M2_NAME
             LEFT JOIN (select bank_no,bank_name as center_no_name from (select * from ba01 where m_year=99)ba01 where bank_type='8' and bank_kind='0')ba01_1 on ba01_1.bank_no = WLX01.CENTER_NO
             LEFT JOIN (select tbank_no,count(*) as wlx02count, --國內營業分支機構家數
                        sum(staff_num) as wlx02staff_num ---分支機構員工總人數
                        from (select * from wlx02 where m_year=99)wlx02
                        where CANCEL_NO <> 'Y' OR CANCEL_NO IS NULL
                        group by tbank_no)wlx02 on wlx02.tbank_no = WLX01.bank_no     
             LEFT JOIN (select bank_no, 
                        sum(decode(wlx04.position_code,'1',1,0)) as wlx04_1count,--理事人數
                        sum(decode(wlx04.position_code,'2',1,0)) as wlx04_2count --監事人數
                       from wlx04
                       where (wlx04.abdicate_code <> 'Y' OR wlx04.abdicate_code IS NULL) 
                       group by bank_no)wlx04 on wlx04.bank_no = WLX01.bank_no 
                       where WLX01.bank_no IN ('6030016','5030019') 
                       and   BN01.bank_no=WLX01.bank_no  and BN01.bn_type <> '2'
            */
            
            
  			sqlCmd = " select "+ column 
  				   + " from "  + table
  				   + leftjointable
  				   + " where " + selectBank_no + " and "
  				   + condition;	
  			if(!order.equals("")){	   				  
  				sqlCmd += " order by " + order;
  				//SoryBy=asc/desc
  				if( session.getAttribute("SortBy") != null && !((String)session.getAttribute("SortBy")).equals("")){	   
  		            sqlCmd += " " + ((String)session.getAttribute("SortBy"));	
  		         }
  		    }	
  			
  			System.out.println("BR002W_Excel.sqlCmd="+sqlCmd);	   
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"audit_setup_date,audit_part_time_date,chg_license_date,start_date,open_date,staff_num,credit_staff_num,credit_staff,skill_staff,manual_staff,temp_staff,wlx02count,wlx02staff_num,wlx04_1count,wlx04_2count,agree_date");         
            
			//List dbData = DBManager.QueryDB(sqlCmd,"setup_date,chg_license_date,start_date,open_date,staff_num,credit_staff_num,wlx02count,wlx02staff_num,wlx04_1count,wlx04_2count");            
			String field = "";
			
			short rowNo = ( short )6;//資料起始列      
			//無資料時,顯示訊息========================================================================
			if(dbData == null || dbData.size() == 0){
			   	row = sheet.createRow( rowNo );     
                row.setHeight((short) 0x120); 
                reportUtil.createCell( wb, row, ( short )1,"無信用部基本資料" ,noBorderDefaultStyle ); 
                sheet.addMergedRegion( new Region( ( short )6, ( short )1,
                                               ( short )6,
                                               ( short )(btnFieldList_data.size()) ) );
			}
			//=========================================================================================           			
            int maxLine=0;
			for ( i = 0; i < dbData.size(); i ++) {                
                row = sheet.createRow( rowNo );     
                //row.setHeight((short) 0x120); 
                for(int j=0;j<btnFieldList_data.size();j++){
                	field = ((String)((List)btnFieldList_data.get(j)).get(0)).toLowerCase();	
                	//System.out.println("cretea cell="+field);
                	//除了須轉換成其他欄位的.不去除原table名稱,其餘只取.後面的欄位名稱
                	if((!((field.indexOf("cdshareno") != -1) || (field.indexOf("wlx01_audit") != -1) 
                	|| (field.indexOf("cd01_02") != -1) || (field.indexOf("cd02_02") != -1) 
                	|| (field.indexOf("cd01_03") != -1) || (field.indexOf("cd02_03") != -1)                	
                	))
                	&& (field.indexOf(".") != -1)){                	
                	   field = field.substring(field.indexOf(".")+1,field.length());
                	   //System.out.println("cretea cell-1="+field);
                	}
                	
			        if(field.equals("chg_license_date") || field.equals("start_date") || field.equals("open_date") || field.equals("setup_date") || field.equals("part_time_date") || field.equals("wlx01_audit.setup_date") || field.equals("wlx01_audit.part_time_date") || field.equals("agree_date")){
			           if((field).equals("wlx01_audit.setup_date")){field = "audit_setup_date";}
			           if((field).equals("wlx01_audit.part_time_date")){field = "audit_part_time_date";}
			           if((((DataObject)dbData.get(i)).getValue(field)) != null){
				 		  reportUtil.createCell( wb, row, ( short )(j+1),Utility.getCHTdate((((DataObject)dbData.get(i)).getValue(field)).toString().substring(0, 10), 1) ,defaultStyle );				   
					   }else{				   
				   		  reportUtil.createCell( wb, row, ( short )(j+1),"" ,defaultStyle );   
					  }					     
			        }else{
			        	//System.out.println("cretea cell-2="+field);
			           //加上SQL中有須更名的欄位 	
			           if((field).equals("cdshareno.cmuse_name")){field = "chg_license_reason_name";}
			           if((field).equals("cd01_02.hsien_name")){field = "it_hsien_name";}
			           if((field).equals("cd02_02.area_name")){field = "it_area_name";}
			           //稽核人員增加欄位==================================================================
			           if((field).equals("wlx01_audit.name")){field = "audit_name";}
			           if((field).equals("wlx01_audit.telno")){field = "audit_telno";}
			           if((field).equals("wlx01_audit.addr")){field = "audit_addr";}
			           if((field).equals("cd01_03.hsien_name")){field = "audit_hsien_name";}
			           if((field).equals("cd02_03.area_name")){field = "audit_area_name";}
			           if((field).equals("wlx01_audit.area_id")){field = "audit_area_id";}
			           if((field).equals("wlx01_audit.department")){field = "audit_department";}
			           if((field).equals("wlx01_audit.setup_no")){field = "audit_setup_no";}
			           if((field).equals("wlx01_audit.full_time")){field = "audit_full_time";}
			           if((field).equals("wlx01_audit.part_time")){field = "audit_part_time";}
			           if((field).equals("wlx01_audit.part_time_no")){field = "audit_part_time_no";}
			           //====================================================================================
			           if((field).equals("cdshareno1.cmuse_name")){field = "setup_approval_unt_name";}
			           if((field).equals("bank_no_1name")){field = "wlx04_1name";}
			           if((field).equals("bank_no_2name")){field = "wlx04_2name";}
			           if((field).equals("bank_no_3name")){field = "wlx04_3name";}
			           if((field).equals("bank_no_4name")){field = "wlx04_4name";}
			           
			           
			           if(field.equals("wlx04_1name") || field.equals("wlx04_2name") 
			           || field.equals("wlx04_3name") || field.equals("wlx04_4name") ){
			             
			               int h = 0;
					          if(((DataObject)dbData.get(i)).getValue(field) != null){
					              
					              String getData = (String)((DataObject)dbData.get(i)).getValue(field);
					              //System.out.println("field :"+getData);
						          String[] tokens = getData.split(";");
						          String strToken= "";
						           for(String token : tokens) {  
						               
						               if(h>=1){
						                   strToken += token+"\n";
						               }else{
						                   strToken += token;
						               }
						               h += 1;
						              
						            }
					              if(h>maxLine){
						                maxLine=h;
						            }
						            //System.out.println("setHeight:rowk ------->"+maxLine);
					               //設定高度============================================================
						            row.setHeight((short)(maxLine*(short) 0x120));
					               //============================================================
						            reportUtil.createCell( wb, row, ( short )(j+1), strToken ,defaultStyle );
					          }else{
					              	reportUtil.createCell( wb, row, ( short )(j+1), "" ,defaultStyle );
					          }
			               
					          
					          
			           }else{
				           String fieldVal = "";
			               if(((DataObject)dbData.get(i)).getValue(field) != null){
			                   //if((field).equals("audit_full_time")|| (field).equals("audit_part_time")){
			                   //    fieldVal = Utility.ISOtoUTF8((((DataObject)dbData.get(i)).getValue(field)).toString());
			                   //}else{
			                       fieldVal = (((DataObject)dbData.get(i)).getValue(field)).toString();
			                   //}
				           }
				           reportUtil.createCell( wb, row, ( short )(j+1),fieldVal,defaultStyle );					
			              					
			           }
			        }
			        
                }  
                
				rowNo ++ ;
			}
            
            
            //設定寬度============================================================
            for ( i = 1; i <= columnLen.length; i++ ) {                
                sheet.setColumnWidth( ( short )i,
                                      ( short ) ( 256 * ( columnLen[i - 1] + 4 ) ) );
            }
			//======================================================================================
            //設定涷結欄位
            //sheet.createFreezePane(0,1,0,1);
            footer.setCenter( "Page:" + HSSFFooter.page() + " of " +
                             HSSFFooter.numPages() );		                                 
			footer.setRight(Utility.getDateFormat("yyyy/MM/dd hh:mm aaa"));			
			
            // Write the output to a file            
            fileOut = new FileOutputStream( Utility.getProperties("reportDir")+System.getProperty("file.separator")+ titleName+".xls" );
            wb.write( fileOut );
            fileOut.close();            
            
            String filename = titleName+".xls";//108.04.29 add
            if(!printStyle.equalsIgnoreCase("xls")) {//108.04.29非xls檔須執行轉換	                
	  			rptTrans rptTrans = new rptTrans();	  			
	  			filename = rptTrans.transOutputFormat (printStyle,filename,""); 
	  			System.out.println("newfilename="+filename);	  			   
            };
            
            FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+ filename);//108.04.29 fix  	
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

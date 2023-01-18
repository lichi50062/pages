<%
// 94.01.20 create by 2295
// 94.02.17 fix 每一筆bank_no,bank_name都要顯示 by 2295
// 94.02.21 fix 頁尾加上列印日期及時間 by2295
// 94.03.24 add 營運中/已裁撤 by 2295
// 95.09.06 fix 只抓沒有被裁撤的分支機構 by 2295
// 99.12.14 fix SQLInjection by 2479
// 99.12.27 fix 根據查詢年度.100年以後取得新縣市別.100年以前取得舊縣市別 by 2295
//100.11.16 fix 代碼改為最近換照事由 by 2295
//101.06    add 報表欄位 by 2968
//101.10.17 fix 修正無法顯示分部主任 by 2295 
//105.10.27 fix 調整for農委會格式(增加bank_type=ALL) by 2295
//106.03    add 通匯代號、業務項目、其他揭露事項 by 2968
//107.05.14 add 增加最近地方主管機關備查信用部分部主任函日期、文號 by 6404
//108.05.31 add 報表格式轉換 by rock.tsai
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
<%@ page import="java.util.StringTokenizer" %>
<%@ page import="java.lang.StringBuffer" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>


<%
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁
   
   String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");			  
   System.out.println("act="+act);
   String printStyle = "";//輸出格式 108.05.31 add
   //輸出格式 108.05.31 add
   if(session.getAttribute("printStyle") != null && !((String)session.getAttribute("printStyle")).equals("")){
    printStyle = (String)session.getAttribute("printStyle");		  				   
   }
   if(act.equals("view")){
      //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
      //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔 
      response.setHeader("Content-disposition","inline; filename=view."+printStyle);//108.05.31調整顯示的副檔名
   }else if (act.equals("download")){   
	   response.setHeader("Content-Disposition","attachment; filename=download."+printStyle);//108.05.31調整顯示的副檔名
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
	String report_no = "BR005W";	 
	String titleName = Utility.getPgName(report_no);	
    reportUtil reportUtil = new reportUtil();
    String BankList = "";
    String btnFieldList = "";
    String SortList = "";
    String CANCEL_NO = "";
    String S_YEAR = Utility.getYear();//99.12.27 add
    String S_MONTH = Utility.getMonth();//99.12.27 add
    List BankList_data = null;
    List btnFieldList_data = null;
    List SortList_data = null;    
	int i = 0;
	String lguser_name = ( session.getAttribute("muser_name")==null ) ? "" : (String)session.getAttribute("muser_name");
    List paramList = new ArrayList();
    //99.12.27 add==================================================================
	String cd01_table = "";
    String u_year = "";
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
    		//查詢日期-年//99.12.27 add
    		if(session.getAttribute("S_YEAR") != null && !((String)session.getAttribute("S_YEAR")).equals("")){
		  		S_YEAR = (String)session.getAttribute("S_YEAR");		  				   
			}
			//查詢日期-月//99.12.27 add
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
		   		BankList_data = getReportData(BankList);
		   		System.out.println("BankList_data.size()="+BankList_data.size());		   
			}
			//報表欄位
			if(session.getAttribute("btnFieldList") != null && !((String)session.getAttribute("btnFieldList")).equals("")){				
		   		btnFieldList = (String)session.getAttribute("btnFieldList");
		   		System.out.println("btnFieldList="+btnFieldList);		   
		   		btnFieldList_data = getReportData(btnFieldList);
		   		System.out.println("btnFieldList_data.size()="+btnFieldList_data.size());		   
		   		/*
		   		for(i=0;i<btnFieldList_data.size();i++){
		   			System.out.println((String)((List)btnFieldList_data.get(i)).get(0));
		   			System.out.println((String)((List)btnFieldList_data.get(i)).get(1));
		   		}
		   		*/
			}
			//排序欄位
			if(session.getAttribute("SortList") != null && !((String)session.getAttribute("SortList")).equals("")){
		  		SortList = (String)session.getAttribute("SortList");
		  		SortList_data = getReportData(SortList);
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
		  		//105.10.27 add
		  		if(((String)session.getAttribute("nowbank_type")).equals("ALL")){
		  		   titleName = "農漁會"+titleName;
		  		}
			}
			
        	//讀取報表欄位長度===================================================================================
        	Properties p = new Properties();
			p.load(new FileInputStream(Utility.getProperties("schemaDir")+System.getProperty("file.separator")+"WLX02.length"));
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
            //HSSFCell cell;
            //HSSFCellStyle style;
            //HSSFFont font;
            //style = wb.createCellStyle();
            //Font = wb.createFont();

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
            String column = "BN01.bank_name as tbank_no_name,BN02.bank_name as bank_no_name,";//選取欄位
            String selectBank_no = "";//選取的金融機構代號
            String condition = "";//條件
            //99.12.27 add 查詢年度100年以前.縣市別不同===============================
  	    	cd01_table = (Integer.parseInt(S_YEAR) < 100)?"cd01_99":"cd01"; 
  	    	u_year = (Integer.parseInt(S_YEAR) < 100)?"99":"100";
  	    	//=====================================================================      
            //94.03.24 add 營運中/已裁撤============================ 
            if(CANCEL_NO.equals("N")){//營運中
			   condition += " and BN01.bn_type <> '2'";//條件
			}else{//已裁撤
			   condition += " and BN01.bn_type = '2'";//條件
			}			  	 
			//======================================================
 			condition += " and (BN02.bank_no = WLX02.bank_no and BN02.bn_type <> '2')" //95.09.06 fix 只抓沒有被裁撤的分支機構 by 2295					     
 					   + " and BN01.bank_no = BN02.tbank_no"
 					   + " and BN01.bank_no = WLX01.bank_no";
            //String table = " BN02,BN01,WLX02";//查詢table
            StringBuffer table = new StringBuffer();
            table.append(" (select * from bn02 where m_year=?)BN02,(select * from bn01 where m_year=?)BN01,(select * from wlx02 where m_year=?)WLX02"); 
            paramList.add(u_year);//bn02用
            paramList.add(u_year);//bn01用
            paramList.add(u_year);//wlx02用
            table.append(",(select * from wlx01 where m_year=?)WLX01 ");
            paramList.add(u_year);//wlx01用
            String order = "";//排序欄位
            String sqlCmd="";
            
            //報表欄位=======================================================================
            row = sheet.createRow( ( short )5 );//表頭
            for(i=0;i<btnFieldList_data.size();i++){
               //System.out.println("["+i+"]i="+(String)((List)btnFieldList_data.get(i)).get(1));
               //System.out.println("["+i+"]i="+(String)((List)btnFieldList_data.get(i)).get(0));
               //設定表頭欄位
               reportUtil.createCell( wb, row, ( short )(i+1), (String)((List)btnFieldList_data.get(i)).get(1), columnStyle );               
               //取得報表欄位長度
               columnLen[i]=Integer.parseInt(((String)p.get((String)((List)btnFieldList_data.get(i)).get(0))).trim());
               //System.out.println("["+i+"]i="+columnLen[i]);
               //選取欄位         			 
			   if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("WLX02.CONST_TYPE")){
			       column += " c2.cmuse_name as const_type_name";//分支機構類別			   	  
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("WLX02.CHG_LICENSE_REASON")){
			       column += " c1.cmuse_name as chg_license_reason_name";//最近換照事由
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("ba01.m2_name_bank_name")){
			       column += " WLX01.M2_NAME,ba01.m2_name_bank_name";//所屬之地方主管機關	
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("ba01_1.center_no_name")){
			       column += " WLX01.CENTER_NO,ba01_1.center_no_name";//所屬之資訊共用中心
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("WLX02.wlx02_m_name")){
			       column += " F_COMBWLX02_MNAME(WLX02.bank_no,'1') as wlx02_m_name";//分部主任
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("WLX02.BUSINESS_ITEM")){
			       column += " F_TRANSBUSITEM(WLX02.BUSINESS_ITEM,WLX02.BUSINESS_ITEM_EXTRA) as BUSINESS_ITEM";
			   }else { 			  
               	   column += (String)((List)btnFieldList_data.get(i)).get(0);
               }
               		
               if(i < btnFieldList_data.size() -1){
               	  column += ", ";
               }
               //條件式跟table=============================================================================
               if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("WLX02.CONST_TYPE")){
               	  condition += " and c2.cmuse_div = '006' and c2.cmuse_id=wlx02.const_type";
               	  table.append(",cdshareno c2");
               }
               //100.11.16 fix 代碼改為最近換照事由
               if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("WLX02.CHG_LICENSE_REASON")){
               	  condition += "  and c1.cmuse_div = '015' and c1.cmuse_id=wlx02.chg_license_reason";
               	  table.append(",cdshareno c1");
               }
               
               if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("CD01.HSIEN_NAME")){               	  
                  if(table.toString().indexOf("WLX02") != -1){
               	    table.insert(table.toString().indexOf("WLX02")+5," LEFT JOIN "+cd01_table+" cd01 on cd01.hsien_id = WLX02.hsien_id ");
               	  }
               }
              
               if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("ba01.m2_name_bank_name")){               	  
                   if(table.toString().indexOf("WLX01") != -1){
                  	    table.insert(table.toString().indexOf("WLX01")+5," LEFT JOIN (select bank_no,bank_name as m2_name_bank_name from (select * from ba01 where m_year=?)ba01 where bank_type='B' and bank_kind='0')ba01 on ba01.bank_no = WLX01.M2_NAME ");
                  	  	paramList.add(u_year);
                   }
                }
               if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("ba01_1.center_no_name")){               	  
                   if(table.toString().indexOf("WLX01") != -1){
                  	    table.insert(table.toString().indexOf("WLX01")+5," LEFT JOIN (select bank_no,bank_name as center_no_name from (select * from ba01 where m_year=?)ba01 where bank_type='8' and bank_kind='0')ba01_1 on ba01_1.bank_no = WLX01.CENTER_NO ");
                  	  	paramList.add(u_year);
                   }
                }
               if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("CD02.AREA_NAME")){               	 
               	  if(table.toString().indexOf("WLX02") != -1){
               	    if(table.toString().indexOf("WLX02.hsien_id") != -1){
               	       table.insert(table.toString().indexOf("WLX02.hsien_id")+14," LEFT JOIN cd02 on cd02.area_id = WLX02.area_id");
               	    }else{
               	       table.insert(table.toString().indexOf("WLX02")+5," LEFT JOIN cd02 on cd02.area_id = WLX02.area_id");
               	    }
               	  }
               	  
               }               
               //=========================================================================================
            }            
          //金融機構代號=============================================================
          
            if(BankList_data != null && BankList_data.size() != 0){
               if(!((String)((List)BankList_data.get(0)).get(0)).equals("ALL")){//105.10.27 add
                   selectBank_no += " BN02.tbank_no IN (";
                   for(i=0;i<BankList_data.size();i++){
                        paramList.add((String)((List)BankList_data.get(i)).get(0));
                        selectBank_no +=" ? ";            	
            	        //selectBank_no +="'"+(String)((List)BankList_data.get(i)).get(0)+"'";            	
            	        if(i < BankList_data.size()-1) selectBank_no +=",";
                   }
                   selectBank_no += ")";
               }
               System.out.println("selectBank_no="+selectBank_no);
            }   
            //==============================================================================
            //排序欄位=========================================================================
            if(SortList_data != null && SortList_data.size() != 0){
            	for(i=0;i<SortList_data.size();i++){
            		order += (String)((List)SortList_data.get(i)).get(0);
            		if(i < SortList_data.size() -1 ) order +=",";            
	            }
	            System.out.println("order="+order);
            }
            //====================================================================================
            //wb.setRepeatingRowsAndColumns( 0, 1, 8, 1, 3 ); //設定表頭 為固定 先設欄的起始再設列的起始
            wb.setRepeatingRowsAndColumns(0, 1, btnFieldList_data.size(), 1, 5); //設定表頭 為固定 先設欄的起始再設列的起始

            
            
            	
            /*
            SELECT BN01.bank_name AS tbank_no_name,
		       BN02.bank_name AS bank_no_name,
		       BN02.TBANK_NO, --總機構代碼
		       BN01.BANK_NAME, --所屬總機構名稱 101.06.11 add
		       BN02.BANK_NO, --分支機構配賦代號 101.06.11 add
		       BN02.BANK_NAME, --分支機構名稱
		       c2.cmuse_name AS const_type_name, --分支機構類別
		       WLX02.SETUP_NO, --原始核准設立文號
		       WLX02.SETUP_NO_DATE, --原始核准設立文號日期
		       WLX02.SETUP_DATE, --原始開業日期
		       WLX02.CHG_LICENSE_DATE, --最近換照日期
		       WLX02.CHG_LICENSE_NO, --最近換照文號
		       c1.cmuse_name AS chg_license_reason_name, --最近換照事由
		       WLX02.START_DATE, --開始營業日
		       CD01.HSIEN_NAME, --縣市別
		       CD02.AREA_NAME, --鄉鎮 101.06.11 add
		       WLX02.AREA_ID, --郵遞區號
		       WLX02.ADDR, --地址
		       WLX02.TELNO, --電話
		       WLX02.FAX, --傳真 101.06.11 add
		       WLX01.M2_NAME,ba01.m2_name_bank_name, --所屬之地方主管機關 -->101.06.19 add
		       WLX01.CENTER_NO,ba01_1.center_no_name, --所屬之資訊共用中心 -->101.06.19 add
		       F_COMBWLX02_MNAME(WLX02.bank_no,'1') as wlx02_m_name,--分部主任 -->101.06.19 add 
		        WLX02.WEB_SITE,--網址 101.06.11 add
		        WLX02.EMAIL,--e-mail帳號 101.06.11 add
		        WLX02.STAFF_NUM--分支機構員工數 101.06.11 add       
		  		FROM (SELECT *  FROM bn02 WHERE m_year = '100') BN02,
		            (SELECT *  FROM bn01  WHERE m_year = '100') BN01,       
		            (SELECT *  FROM wlx02  WHERE m_year = '100') WLX02
		            LEFT JOIN  cd01 cd01  ON cd01.hsien_id = WLX02.hsien_id
		            LEFT JOIN  cd02  ON cd02.area_id = WLX02.area_id,   
		            cdshareno c2,  cdshareno c1,
		             (select * from wlx01 where m_year= '100'))WLX01  
		              LEFT JOIN (select bank_no,bank_name as m2_name_bank_name from (select * from ba01 where m_year=99)ba01 where bank_type='B' and bank_kind='0')ba01 on ba01.bank_no = WLX01.M2_NAME
		             LEFT JOIN (select bank_no,bank_name as center_no_name from (select * from ba01 where m_year=99)ba01 where bank_type='8' and bank_kind='0')ba01_1 on ba01_1.bank_no = WLX01.CENTER_NO           
		 		WHERE     BN02.tbank_no IN ('6060019')
		       AND BN01.bn_type <> '2'
		       AND BN01.BANK_NO = WLX01.bank_no
		       AND (BN02.bank_no = WLX02.bank_no AND BN02.bn_type <> '2')     
		       AND BN01.bank_no = BN02.tbank_no
		       AND c2.cmuse_div = '006'
		       AND c2.cmuse_id = wlx02.const_type
		       AND c1.cmuse_div = '015'
		       AND c1.cmuse_id = wlx02.chg_license_reason
                  			  
  			*/
  			
  			
  			sqlCmd = " select "+ column 
  				   + " from "  + table.toString();
  			if(!selectBank_no.equals("")){	   
  				   sqlCmd+= " where " + selectBank_no;  
  			}else{//for 農委會用 105.10.27 add
  				   sqlCmd+= " where BN01.bn_type <> '2'";  
  			}		   
  		    sqlCmd+= condition;	   
  			if(!order.equals("")){	   				  
  				sqlCmd += " order by " + order;
  				//SoryBy=asc/desc
  				if( session.getAttribute("SortBy") != null && !((String)session.getAttribute("SortBy")).equals("")){	   
  		            sqlCmd += " " + ((String)session.getAttribute("SortBy"));	
  		         }
  		    }	
  			
  			System.out.println("BR005W_Excel.sqlCmd="+sqlCmd);	   
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"setup_no_date,setup_date,chg_license_date,start_date,staff_num,refer_date");       
			//List dbData = DBManager.QueryDB(sqlCmd,"setup_no_date,setup_date,chg_license_date,start_date");
			String field = "";
			String tmptbank_no = "";
			String tmptbank_name = "";
			short rowNo = ( short )6;//資料起始列            			
			//無資料時,顯示訊息========================================================================
			if(dbData == null || dbData.size() == 0){
			   	row = sheet.createRow( rowNo );     
                row.setHeight((short) 0x120); 
                reportUtil.createCell( wb, row, ( short )1,"無分支機構基本資料" ,noBorderDefaultStyle ); 
                sheet.addMergedRegion( new Region( ( short )6, ( short )1,
                                               ( short )6,
                                               ( short )(btnFieldList_data.size()) ) );
			}
			//=========================================================================================          
            for ( i = 0; i < dbData.size(); i ++) {
                row = sheet.createRow( rowNo );     
                //row.setHeight((short) 0x120); 
                for(int j=0;j<btnFieldList_data.size();j++){
                	field = ((String)((List)btnFieldList_data.get(j)).get(0)).toLowerCase();
                	//System.out.println("cretea cell="+field);
                	if(field.indexOf(".") != -1){                	
                	   if(!(field.equals("bn01.bank_name") || field.equals("bn02.bank_name"))){
                	   	   field = field.substring(field.indexOf(".")+1,field.length());
                	   }
                	}
                	
			        if(field.equals("setup_no_date") || field.equals("setup_date") 
			        || field.equals("chg_license_date") || field.equals("start_date")||field.equals("refer_date")){
			           if((((DataObject)dbData.get(i)).getValue(field)) != null){
				 		  reportUtil.createCell( wb, row, ( short )(j+1),Utility.getCHTdate((((DataObject)dbData.get(i)).getValue(field)).toString().substring(0, 10), 1) ,defaultStyle );				   
				 		   //System.out.println(Utility.getCHTdate((((DataObject)dbData.get(i)).getValue(field)).toString().substring(0, 10), 1));
					   }else{				   
				   		  reportUtil.createCell( wb, row, ( short )(j+1),"" ,defaultStyle );   
					  }					     
			        }else{
			           if((field).equals("const_type")){field = "const_type_name";}
			           if((field).equals("chg_license_reason")){field = "chg_license_reason_name";}	
			           if((field).equals("m2_name_bank_name")){field = "m2_name_bank_name";}
			           if((field).equals("center_no_name")){field = "center_no_name";}
			           if((field).equals("bn01.bank_name")){field = "tbank_no_name";}			           
			           if((field).equals("bn02.bank_name")){field = "bank_no_name";}
			           if(field.equals("staff_num")){
			                reportUtil.createCell( wb, row, ( short )(j+1),(((DataObject)dbData.get(i)).getValue(field)).toString() ,defaultStyle );
			                
			           }else{
			           		reportUtil.createCell( wb, row, ( short )(j+1),(String)((DataObject)dbData.get(i)).getValue(field) ,defaultStyle );
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
            
            String filename = titleName+".xls";//108.05.31 add
            if(!printStyle.equalsIgnoreCase("xls")) {//108.05.31非xls檔須執行轉換	                
            	rptTrans rptTrans = new rptTrans();	  			
            	filename = rptTrans.transOutputFormat (printStyle,filename,""); 
            	System.out.println("newfilename="+filename);	  			   
            }

            FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+  filename);//108.05.31 fix  		 
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
<%! 
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
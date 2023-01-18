<%
//94.01.20 create by 2295
//94.03.24 add 營運中/已裁撤 by 2295
//94.06.14 fix BN02用LEFT JOIN by 2295
//99.12.14 fix SQLInjection by 2479
//99.12.30 fix 根據查詢年度.100年以後取得新縣市別.100年以前取得舊縣市別 by 2295
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
	
  	int[] columnLen = {10,20,40,15,10,40,10};
  	/*
  	1.金融機代號 10
	2.金融機構名稱 20
	3.地址 40
	4.電話 15 
	5.傳真號碼 10
	6.電子郵件帳號 40
	7.國內營業分支機構家數 10
  	*/  	
    HSSFCellStyle defaultStyle;
    HSSFCellStyle noBorderDefaultStyle;
    HSSFCellStyle titleStyle;
	HSSFCellStyle columnStyle;
	HSSFCellStyle noBoderStyle;
	HSSFRow row;
    List paramList = new ArrayList() ;
    String report_no = "BR003W";	 
	String titleName = Utility.getPgName(report_no);	
    reportUtil reportUtil = new reportUtil();
    String bank_type = "";
	String hsien_id = ( request.getParameter("hsien_id")==null ) ? "" : (String)request.getParameter("hsien_id");
	String cancel_no = ( request.getParameter("cancel_no")==null ) ? "" : (String)request.getParameter("cancel_no");
	String S_YEAR = ( request.getParameter("S_YEAR")==null ) ? "" : (String)request.getParameter("S_YEAR");;//99.12.30 add
    String S_MONTH = ( request.getParameter("S_MONTH")==null ) ? "" : (String)request.getParameter("S_MONTH");;//99.12.30 add
	String hsien_name = "";
	int i = 0;
	String lguser_name = ( session.getAttribute("muser_name")==null ) ? "" : (String)session.getAttribute("muser_name");
	//99.12.30 add==================================================================
	String cd01_table = "";
    String wlx01_m_year = "";    
	//============================================================================
	try{
			//99.12.30 add 查詢年度100年以前.縣市別不同===============================
  	    	cd01_table = (Integer.parseInt(S_YEAR) < 100)?"cd01_99":"cd01"; 
  	    	wlx01_m_year = (Integer.parseInt(S_YEAR) < 100)?"99":"100"; 
  	    	//=====================================================================      
			//儲存報表的目錄================================================================
        	File reportDir = new File(Utility.getProperties("reportDir"));       
    		if(!reportDir.exists()){
     			if(!Utility.mkdirs(Utility.getProperties("reportDir"))){
     	   			actMsg +=Utility.getProperties("reportDir")+"目錄新增失敗";
     			}    
    		}
    		//==============================================================================
    		
			//機構類別
			if(session.getAttribute("nowbank_type") != null && !((String)session.getAttribute("nowbank_type")).equals("")){
			    bank_type = (String)session.getAttribute("nowbank_type");
		  		if(((String)session.getAttribute("nowbank_type")).equals("6")){
		  		   titleName = "農會"+titleName;
		  		}		  		
		  		if(((String)session.getAttribute("nowbank_type")).equals("7")){
		  		   titleName = "漁會"+titleName;
		  		}
			}        	      		
      		//縣市別
      		if(hsien_id.equals("ALL")){
      		   hsien_name = "縣市別:全部";
      		}else{
                paramList.clear();
                paramList.add(hsien_id);
                List hsien_data = DBManager.QueryDB_SQLParam("select * from "+cd01_table+" cd01 where hsien_id=?",paramList,"");                     
      			//List hsien_data = DBManager.QueryDB("select * from cd01 where hsien_id='"+hsien_id+"'","");
      		    if(hsien_data != null && hsien_data.size() != 0){
      		       hsien_name = "縣市別:"+(String)((DataObject)hsien_data.get(0)).getValue("hsien_name");
      		    }
      		}
      		
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
            reportUtil.createCell( wb, row, ( short )0, titleName, titleStyle );           
            sheet.addMergedRegion( new Region( ( short )1, ( short )0,
                                               ( short )1,
                                               ( short )(columnLen.length -1) ) );
            
            row = sheet.createRow( ( short )2 );
            
            row.setHeight((short) 0x200);
            reportUtil.createCell( wb, row, ( short )0, "", titleStyle );
            for(i=0;i<columnLen.length;i++){
               reportUtil.createCell( wb, row, ( short )i, "", noBorderDefaultStyle );
            }            
            //設定列印日期==========================================================
            row = sheet.createRow( ( short )3 );            
            String printTime = Utility.getDateFormat("  HH:mm:ss");
            String printDate = Utility.getDateFormat("yyyy/MM/dd");                                    
            reportUtil.createCell( wb, row, ( short )0, "列印日期："+Utility.getCHTdate(printDate, 1)+printTime, noBoderStyle );
            sheet.addMergedRegion( new Region( ( short )3, ( short )0,
                                               ( short )3,
                                               ( short ) (columnLen.length -1) ) );
            //設定列印人員==========================================================
            row = sheet.createRow( ( short )4 ); 
			reportUtil.createCell( wb, row, ( short )0, hsien_name, noBoderStyle );                                   
            reportUtil.createCell( wb, row, ( short )1, "列印人員："+lguser_name, noBoderStyle );
            sheet.addMergedRegion( new Region( ( short )4, ( short )1,
                                               ( short )4,
                                               ( short )(columnLen.length-1) ) );
            
            //===============================================================================
            
            //報表欄位表頭=======================================================================
            row = sheet.createRow( ( short )5 );//表頭    
            reportUtil.createCell( wb, row, ( short )0, "金融機構代號", columnStyle );               
            reportUtil.createCell( wb, row, ( short )1, "金融機構名稱", columnStyle );               
            reportUtil.createCell( wb, row, ( short )2, "地址", columnStyle );               
            reportUtil.createCell( wb, row, ( short )3, "電話", columnStyle );               
            reportUtil.createCell( wb, row, ( short )4, "傳真號碼", columnStyle );               
            reportUtil.createCell( wb, row, ( short )5, "電子郵件帳號", columnStyle );               
            reportUtil.createCell( wb, row, ( short )6, "國內營業分支機構家數", columnStyle );                                       
            //====================================================================================
            //wb.setRepeatingRowsAndColumns( 0, 1, 8, 1, 3 ); //設定表頭 為固定 先設欄的起始再設列的起始
            wb.setRepeatingRowsAndColumns(0, 0, 6, 0, 5); //設定表頭 為固定 先設欄的起始再設列的起始

            
            
            paramList.clear();
            paramList.add(wlx01_m_year);//bn01用
            paramList.add(wlx01_m_year);//wlx01用
            paramList.add(wlx01_m_year);//bn01用
            paramList.add(wlx01_m_year);//bn02用
            paramList.add(bank_type);	
            paramList.add(bank_type);
            String sqlCmd = "select WLX01.bank_no, WLX01.addr, WLX01.telno, WLX01.fax, WLX01.email," 
	   					  + " Count(BN02.bank_no) as bank_cnt, "
	   			   		  + " (Select bank_name from (select * from bn01 where m_year=?)bn01 where bank_no = WLX01.bank_no) as bank_name "
				   		  + " from (select * from wlx01 where m_year=?)WLX01 , (select * from bn01 where m_year=?)BN01 LEFT JOIN (select * from bn02 where m_year=?)BN02 on  BN01.bank_no = BN02.tbank_no  and  BN02.bank_type =?"
				   		  + " where BN01.bank_no = WLX01.bank_no and BN01.bank_type=?";
/*            
            String sqlCmd = "select WLX01.bank_no, WLX01.addr, WLX01.telno, WLX01.fax, WLX01.email," 
	   					  + " Count(BN02.bank_no) as bank_cnt, "
	   			   		  + " (Select bank_name from bn01 where bank_no = WLX01.bank_no) as bank_name "
				   		  + " from WLX01 , BN01 LEFT JOIN BN02 on  BN01.bank_no = BN02.tbank_no  and  BN02.bank_type = '"+bank_type+"' "
				   		  + " where BN01.bank_no = WLX01.bank_no and BN01.bank_type='"+bank_type+"' ";
*/                          
			//94.03.24 add 區分營運中/已裁撤========================================	   		  			
			if(cancel_no.equals("N")){//營運中	  			 		  
			   sqlCmd += " and  BN01.bn_type <> '2' ";
			}else{//已裁撤	   	
			   sqlCmd += " and  BN01.bn_type = '2' ";	  
			}	   		  
			//======================================================================
			if(!hsien_id.equals("ALL")){		
                paramList.add(hsien_id);	
                sqlCmd += " and WLX01.hsien_id =? ";
			    //sqlCmd += " and WLX01.hsien_id = '" + hsien_id + "'";
			}	   
			sqlCmd += " group by WLX01.bank_no,WLX01.addr,WLX01.telno, WLX01.fax, WLX01.email "
				   + " order by WLX01.bank_no ";                    			  
  			
  			System.out.println("BR003W_Excel.sqlCmd="+sqlCmd);	   
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,"bank_cnt");  
			//List dbData = DBManager.QueryDB(sqlCmd,"bank_cnt");            
			String field = "";
			
			short rowNo = ( short )6;//資料起始列            			
			//無資料時,顯示訊息========================================================================
			if(dbData == null || dbData.size() == 0){
			   	row = sheet.createRow( rowNo );     
                row.setHeight((short) 0x120);                
                reportUtil.createCell( wb, row, ( short )0,"無信用部通訊錄" ,noBorderDefaultStyle ); 
                sheet.addMergedRegion( new Region( ( short )6,( short )0,
                                                   ( short )6,( short )6 ));
			}
			//=========================================================================================           			
            
            for ( i = 0; i < dbData.size(); i ++) {                
                row = sheet.createRow( rowNo );     
                row.setHeight((short) 0x120);                 
                reportUtil.createCell( wb, row, ( short )0,(String)((DataObject)dbData.get(i)).getValue("bank_no") ,defaultStyle );					
                reportUtil.createCell( wb, row, ( short )1,(String)((DataObject)dbData.get(i)).getValue("bank_name") ,defaultStyle );					                
                reportUtil.createCell( wb, row, ( short )2,(String)((DataObject)dbData.get(i)).getValue("addr") ,defaultStyle );					
                reportUtil.createCell( wb, row, ( short )3,(String)((DataObject)dbData.get(i)).getValue("telno") ,defaultStyle );					
                reportUtil.createCell( wb, row, ( short )4,(String)((DataObject)dbData.get(i)).getValue("fax") ,defaultStyle );					
                reportUtil.createCell( wb, row, ( short )5,(String)((DataObject)dbData.get(i)).getValue("email") ,defaultStyle );					                
                reportUtil.createCell( wb, row, ( short )6,(((DataObject)dbData.get(i)).getValue("bank_cnt")).toString() ,defaultStyle );				   
				rowNo ++ ;
			}
            
            //設定寬度============================================================
            for ( i = 0; i < columnLen.length; i++ ) {                
                sheet.setColumnWidth( ( short )i,
                                      ( short ) ( 256 * ( columnLen[i] + 4 ) ) );
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

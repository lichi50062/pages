<%
//101.06 create by 2968
//105.10.27 fix 調整for農委會格式(增加bank_type=ALL) by 2295
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
<%@ page import="java.lang.StringBuffer" %>
<%@ page import="com.tradevan.util.transfer.rptTrans" %>


<%
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁
   
   String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");
   String S_YEAR = Utility.getYear();	
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
	String report_no = "BR010W";	 
	String titleName = Utility.getPgName(report_no);
    reportUtil reportUtil = new reportUtil();
    String BankList = "";
    String btnFieldList = "";
    String SortList = "";
    String CANCEL_NO = "";
    List BankList_data = null;
    List btnFieldList_data = null;
    List SortList_data = null;    
	int i = 0;	
	String lguser_name = ( session.getAttribute("muser_name")==null ) ? "" : (String)session.getAttribute("muser_name");
	//==================================================================
	//99.12.23 add 查詢年度100年以前.縣市別不同===============================
  	 String m_year = (Integer.parseInt(S_YEAR) < 100)?"99":"100";    
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
		  		if("6".equals((String)session.getAttribute("nowbank_type"))){
		  		   titleName = "農會"+titleName;
		  		}		  		
		  		if("7".equals((String)session.getAttribute("nowbank_type"))){
		  		   titleName = "漁會"+titleName;
		  		}
		  		if("ALL".equals((String)session.getAttribute("nowbank_type"))){
		  		   titleName = "農漁會"+titleName;
		  		}
			}
			System.out.println("titleName="+titleName);
        	//讀取報表欄位長度===================================================================================
        	Properties p = new Properties();
			p.load(new FileInputStream(Utility.getProperties("schemaDir")+System.getProperty("file.separator")+"BR010W.length"));
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
            
            /*
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
            reportUtil.createCell( wb, row, ( short )1, Utility.ISOtoBig5("列印日期：")+Utility.getCHTdate(printDate, 1)+printTime, noBoderStyle );
            sheet.addMergedRegion( new Region( ( short )3, ( short )1,
                                               ( short )3,
                                               ( short )(btnFieldList_data.size()) ) );
            //設定列印人員==========================================================
            row = sheet.createRow( ( short )4 );                        
            reportUtil.createCell( wb, row, ( short )1, Utility.ISOtoBig5("列印人員：")+lguser_name, noBoderStyle );
            sheet.addMergedRegion( new Region( ( short )4, ( short )1,
                                               ( short )4,
                                               ( short )(btnFieldList_data.size()) ) );
            */
            //===============================================================================
            columnLen = new int[btnFieldList_data.size()];
            String column = "";//選取欄位
            String selectBank_no = "";//選取的金融機構代號
            String condition = " BN01.bank_no=WLX01.bank_no ";
            String leftjointable = "";
            String cdsharenotable = "";
  	    	//=====================================================================      
            //94.03.23 add 營運中/已裁撤============================ 
            if(CANCEL_NO.equals("N")){//營運中
			   condition += " and BN01.bn_type <> '2'";//條件
			}else{//已裁撤
			   condition += " and BN01.bn_type = '2'";//條件
			}			  	 
			//======================================================
            String table = " (select * from BN01 where m_year = ? )bn01, (select * from wlx01 where m_year = ? )WLX01 ";//查詢table
            String order = "";//排序欄位
            String sqlCmd="";                     
            
            List paramList = new ArrayList() ;
            
            paramList.add(m_year); //bn01
            paramList.add(m_year); //wlx01
            
            //報表欄位=======================================================================
            row = sheet.createRow( ( short )0 );//表頭
            for(i=0;i<btnFieldList_data.size();i++){
               //System.out.println("["+i+"]i="+(String)((List)btnFieldList_data.get(i)).get(1));
               //設定表頭欄位
               reportUtil.createCell( wb, row, ( short )i, (String)((List)btnFieldList_data.get(i)).get(1), columnStyle );               
               //取得報表欄位長度
               columnLen[i]=Integer.parseInt(((String)p.get((String)((List)btnFieldList_data.get(i)).get(0))).trim());
               //選取欄位         			 
			   if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("WLX01_m.firstname")){
			       column += " decode(wlx01_m.name,null,'',substr(wlx01_m.name,2,length(wlx01_m.name))) as firstname";			   	  
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("WLX01_m.lastname")){
			       column += " decode(wlx01_m.name,null,'',substr(wlx01_m.name,0,1)) as lastname";	
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("WLX01.ADDR")){
			       column += " WLX01.AREA_ID||' '||WLX01.ADDR as addr";
			   }else{ 			  
               		column += (String)((List)btnFieldList_data.get(i)).get(0);
               }
               		
               if(i < btnFieldList_data.size() -1){
               	  column += ", ";
               }
               //條件式跟table=============================================================================
               //名字或姓氏       
              /* if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("WLX01_m.firstname")
                       || ((String)((List)btnFieldList_data.get(i)).get(0)).equals("WLX01_m.lastname") ){
               	   leftjointable += " LEFT JOIN (select * from wlx01_m where (abdicate_code <> 'Y' OR abdicate_code IS NULL) "
                       +"AND POSITION_CODE = '4') wlx01_m on wlx01_m.bank_no = WLX01.bank_no";
               }*/
              
               //=========================================================================================
            }            
            
            //排序欄位=========================================================================
            if(SortList_data != null && SortList_data.size() != 0){
            	for(i=0;i<SortList_data.size();i++){
            	    if("WLX01_m.firstname".equals(((List)SortList_data.get(i)).get(0))){
            	        order += "firstname";
            	    }else if("WLX01_m.lastname".equals(((List)SortList_data.get(i)).get(0))){
            	        order += "lastname";
            	    }else if("WLX01.ADDR".equals(((List)SortList_data.get(i)).get(0))){
            	        order += "addr";
            	    }else{
            	        order += (String)((List)SortList_data.get(i)).get(0);
            	    }
            		if(i < SortList_data.size() -1 ) order +=",";            
	            }
            }
            //====================================================================================
            //wb.setRepeatingRowsAndColumns( 0, 1, 8, 1, 3 ); //設定表頭 為固定 先設欄的起始再設列的起始
            wb.setRepeatingRowsAndColumns(0, 1, btnFieldList_data.size(), 1, 5); //設定表頭 為固定 先設欄的起始再設列的起始
  			
  			/*
  			select  BN01.BANK_NO, 
					BN01.BANK_NAME,--公司
					decode(wlx01_m.name,null,'',substr(wlx01_m.name,2,length(wlx01_m.name))) as firstname,--名字
					decode(wlx01_m.name,null,'',substr(wlx01_m.name,0,1)) as lastname,--姓氏
					WLX01.AREA_ID||' '||WLX01.ADDR,--商務-街
					WLX01.FAX,--商務傳真
					WLX01.TELNO, --商務電話
					WLX01.EMAIL --電子郵件地址                    
			from  (select * from BN01 where m_year=100)bn01, (select * from wlx01 where m_year=100)WLX01
			LEFT JOIN (select * from wlx01_m where (abdicate_code <> 'Y' OR abdicate_code IS NULL) 
						AND POSITION_CODE = '4' --信用部主任
						)wlx01_m on wlx01_m.bank_no = WLX01.bank_no     
			where   WLX01.bank_no IN ('5030019') 
					and BN01.bank_no=WLX01.bank_no  
					and BN01.bn_type <> '2'

  			*/
  			
  			//金融機構代號=============================================================
            if(BankList_data != null && BankList_data.size() != 0){
               if(!((String)((List)BankList_data.get(0)).get(0)).equals("ALL")){//105.10.27 add
                  selectBank_no += " WLX01.bank_no IN (";
                  for(i=0;i<BankList_data.size();i++){
                    selectBank_no +="?";
                    paramList.add((String)((List)BankList_data.get(i)).get(0));
            	    //selectBank_no +="'"+(String)((List)BankList_data.get(i)).get(0)+"'";            	
            	    if(i < BankList_data.size()-1) selectBank_no +=",";
                  }
                  selectBank_no += ")";
               }
               System.out.println("selectBank_no="+selectBank_no);           
            }   
            //==============================================================================
             leftjointable += " LEFT JOIN (select * from wlx01_m where (abdicate_code <> 'Y' OR abdicate_code IS NULL) "
                       +"AND POSITION_CODE = '4') wlx01_m on wlx01_m.bank_no = WLX01.bank_no";
                    
  			sqlCmd = " select "+ column 
  				   + " from "  + table
  				   + leftjointable;
  		    if(!selectBank_no.equals("")){	   		   
  				   sqlCmd+= " where " + selectBank_no + " and "
  				   + condition;	
  			}else{//for 農委會用 105.10.27 add
  			      sqlCmd+= " where "+condition;
  			}		   
  			if(!order.equals("")){	   				  
  				sqlCmd += " order by " + order;
  				//SoryBy=asc/desc
  				if( session.getAttribute("SortBy") != null && !((String)session.getAttribute("SortBy")).equals("")){	   
  		            sqlCmd += " " + ((String)session.getAttribute("SortBy"));	
  		         }
  		    }	
  			
  			//System.out.println("BR010W_Excel.sqlCmd="+sqlCmd);
            List dbData = DBManager.QueryDB_SQLParam(sqlCmd,paramList,column);         
			String field = "";
			
			short rowNo = ( short )1;//資料起始列      
			//無資料時,顯示訊息========================================================================
			if(dbData == null || dbData.size() == 0){
			   	row = sheet.createRow( rowNo );     
                row.setHeight((short) 0x120); 
                reportUtil.createCell( wb, row, ( short )0,"無信用部基本資料" ,noBorderDefaultStyle ); 
                sheet.addMergedRegion( new Region( ( short )0, ( short )0,( short )0,( short )(btnFieldList_data.size()) ) );
			}
			//=========================================================================================           			
            int maxLine=0;
			for ( i = 0; i < dbData.size(); i ++) { 
                row = sheet.createRow( rowNo );     
                row.setHeight((short) 0x120); 
                for(int j=0;j<btnFieldList_data.size();j++){
                	field = ((String)((List)btnFieldList_data.get(j)).get(0)).toLowerCase();	
			           if((field).equals("wlx01_m.firstname")){field = "firstname";}
			           if((field).equals("wlx01_m.lastname")){field = "lastname";}
			           if((field).equals("bn01.bank_name")){field = "bank_name";}
			           if((field).equals("wlx01.addr")){field = "addr";}
			           if((field).equals("wlx01.fax")){field = "fax";}
			           if((field).equals("wlx01.telno")){field = "telno";}
			           if((field).equals("wlx01.email")){field = "email";}
			           if(((DataObject)dbData.get(i)).getValue(field) != null){
			                reportUtil.createCell( wb, row, ( short )j,(((DataObject)dbData.get(i)).getValue(field)).toString() ,defaultStyle );					
			             }else{
			                reportUtil.createCell( wb, row, ( short )j,"" ,defaultStyle );					
			             }
               }  
                
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

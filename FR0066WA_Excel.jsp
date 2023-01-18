<%
//94.01.20 create by 2295
//94.03.23 add 營運中/已裁撤 by 2295
//94.06.14 fix 改用left join by 2295
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
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.StringTokenizer" %>
<%@ page import="java.lang.StringBuffer" %>


<%
   response.setContentType("application/msexcel;charset=UTF-8");//以上這行設定本網頁為excel格式的網頁
   
   String act = ( request.getParameter("act")==null ) ? "" : (String)request.getParameter("act");			  
   System.out.println("act="+act);
   if(act.equals("view")){
      //以上這行設定傳送到前端瀏覽器時的檔名為test1.xls
      //就是靠這一行，讓前端瀏覽器以為接收到一個excel檔 
      response.setHeader("Content-disposition","inline; filename=view.xls");
   }else if (act.equals("download")){   
      response.setHeader("Content-Disposition","attachment; filename=download.xls");
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
	String titleName = "信用部基本資料表";
    reportUtil reportUtil = new reportUtil();
    String BankList = "";
    String btnFieldList = "";
    String SortList = "";
    String CANCEL_NO = "";
    List BankList_data = null;
    List btnFieldList_data = null;
    List SortList_data = null;    
	int i = 0;
	String lguser_name = "測試使用者";
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
		   		BankList_data = getReportData(BankList);
		   		System.out.println("BankList_data.size()="+BankList_data.size());		   
			}
			//報表欄位
			if(session.getAttribute("btnFieldList") != null && !((String)session.getAttribute("btnFieldList")).equals("")){
		   		btnFieldList = (String)session.getAttribute("btnFieldList");
		   		btnFieldList_data = getReportData(btnFieldList);
		   		System.out.println("btnFieldList_data.size()="+btnFieldList_data.size());		   
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
			}
			
        	//讀取報表欄位長度===================================================================================
        	Properties p = new Properties();
			p.load(new FileInputStream(Utility.getProperties("schemaDir")+System.getProperty("file.separator")+"WLX01.length"));
			//====================================================================================================
			
            //Creating Cells
            HSSFWorkbook wb = new HSSFWorkbook();
            HSSFSheet sheet = wb.createSheet( "report" ); //建立sheet，及名稱
            wb.setSheetName(0, titleName, HSSFWorkbook.ENCODING_UTF_16 );
            HSSFPrintSetup ps = sheet.getPrintSetup(); //取得設定
            /*
            System.out.println("sheet.BottomMargin="+sheet.BottomMargin );
			System.out.println("sheet.TopMargin ="+sheet.TopMargin  );
			System.out.println("sheet.LeftMargin="+sheet.LeftMargin );
			System.out.println("sheet.RightMargin ="+sheet.RightMargin  );
			sheet.setMargin(sheet.BottomMargin, (double)1); 
			sheet.setMargin(sheet.LeftMargin, (double)1); 
			sheet.setMargin(sheet.RightMargin, (double)1); 
			sheet.setMargin(sheet.TopMargin, (double)1); 
			System.out.println("sheet.BottomMargin="+sheet.BottomMargin );
			System.out.println("sheet.TopMargin ="+sheet.TopMargin  );
			System.out.println("sheet.LeftMargin="+sheet.LeftMargin );
			System.out.println("sheet.RightMargin ="+sheet.RightMargin  );
			*/
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
            String column = "";//選取欄位
            String selectBank_no = "";//選取的金融機構代號
            String condition = " BN01.bank_no=WLX01.bank_no ";
            String leftjointable = "";//94.06.14
            String cdsharenotable = "";//94.06.14
            //94.03.23 add 營運中/已裁撤============================ 
            if(CANCEL_NO.equals("N")){//營運中
			   condition += " and BN01.bn_type <> '2'";//條件
			}else{//已裁撤
			   condition += " and BN01.bn_type = '2'";//條件
			}			  	 
			//======================================================
            String table = " BN01,WLX01 ";//查詢table
            String order = "";//排序欄位
            String sqlCmd="";
            //金融機構代號=============================================================
            if(BankList_data != null && BankList_data.size() != 0){
               selectBank_no += " WLX01.bank_no IN (";
               for(i=0;i<BankList_data.size();i++){
            	 selectBank_no +="'"+(String)((List)BankList_data.get(i)).get(0)+"'";            	
            	 if(i < BankList_data.size()-1) selectBank_no +=",";
               }
               selectBank_no += ")";
            }   
            //==============================================================================
            
            //報表欄位=======================================================================
            row = sheet.createRow( ( short )5 );//表頭
            for(i=0;i<btnFieldList_data.size();i++){
               System.out.println("["+i+"]i="+(String)((List)btnFieldList_data.get(i)).get(1));
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
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("cd01_03.hsien_name")){
			   	   column += " cd01_03.hsien_name as audit_hsien_name";			   	  	 
			   }else if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("cd02_03.area_name")){
			       column += " cd02_03.area_name as audit_area_name";			   	  	 
			   }else { 			  
               		column += (String)((List)btnFieldList_data.get(i)).get(0);
               }
               		
               if(i < btnFieldList_data.size() -1){
               	  column += ", ";
               }
               //條件式跟table=============================================================================
               if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("cdshareno.cmuse_name")){
               	  //condition += " and cdshareno.cmuse_div = '004' and cdshareno.cmuse_id=wlx01.chg_license_reason";
               	  //table += ",cdshareno";
               	  //cdsharenotable = ",cdshareno";
               	   leftjointable += " LEFT JOIN cdshareno on cdshareno.cmuse_id=WLX01.chg_license_reason  and cdshareno.cmuse_div = '004'";
               }
               
               if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("cd01_01.hsien_name")){
               	  //condition += " and wlx01.hsien_id=cd01_01.hsien_id";
               	  //table += ",cd01 cd01_01";
               	  leftjointable += " LEFT JOIN cd01 cd01_01 on WLX01.hsien_id=cd01_01.hsien_id ";
               }
               
               if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("cd02_01.area_name")){
               	  //condition += " and wlx01.area_id=cd02_01.area_id";
               	  //table += ",cd02 cd02_01";
               	   leftjointable += " LEFT JOIN cd02 cd02_01 on WLX01.area_id=cd02_01.area_id ";
               }
               
               if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("cd01_02.hsien_name")){
               	  //condition += " and wlx01.it_hsien_id=cd01_02.hsien_id";
               	  //table += ",cd01 cd01_02";
               	  leftjointable += " LEFT JOIN cd01 cd01_02 on WLX01.it_hsien_id=cd01_02.hsien_id ";
               }
				
			   if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("cd02_02.area_name")){
               	  //condition += " and wlx01.it_area_id=cd02_02.area_id";
               	  //table += ",cd02 cd02_02";
               	  leftjointable += " LEFT JOIN cd02 cd02_02 on WLX01.it_area_id=cd02_02.area_id ";
               }	
               
               if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("cd01_03.hsien_name")){
               	  //condition += " and wlx01.audit_hsien_id=cd01_03.hsien_id";
               	  //table += ",cd01 cd01_03";
               	  leftjointable += " LEFT JOIN cd01 cd01_03 on WLX01.audit_hsien_id=cd01_03.hsien_id ";
               }
               
               if(((String)((List)btnFieldList_data.get(i)).get(0)).equals("cd02_03.area_name")){
               	  //condition += " and wlx01.audit_area_id=cd02_03.area_id";
               	  //table += ",cd02 cd02_03";      
               	  leftjointable += " LEFT JOIN cd02 cd02_03 on WLX01.audit_area_id=cd02_03.area_id ";        	  
               }
               //=========================================================================================
            }            
            
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
  			select  BN01.BANK_NO, BN01.BANK_NAME, WLX01.SETUP_DATE, WLX01.SETUP_NO, 
 					WLX01.CHG_LICENSE_DATE, WLX01.CHG_LICENSE_NO,  
 					cdshareno.cmuse_name as chg_license_reason_name, 
 					WLX01.START_DATE, WLX01.BUSINESS_ID, cd01_01.hsien_name, 
 					cd02_01.area_name, WLX01.AREA_ID, WLX01.ADDR, WLX01.TELNO, 
 					WLX01.FAX, WLX01.EMAIL,  cd01_02.hsien_name as it_hsien_name,  
 					cd02_02.area_name as it_area_name, WLX01.IT_AREA_ID, WLX01.IT_ADDR, 
 					WLX01.IT_NAME, WLX01.IT_TELNO,  cd01_03.hsien_name as audit_hsien_name,  
 					cd02_03.area_name as audit_area_name, WLX01.AUDIT_AREA_ID, WLX01.AUDIT_ADDR, 
 					WLX01.AUDIT_NAME, WLX01.AUDIT_TELNO, WLX01.OPEN_DATE 
 			from  BN01, WLX01  
 					    LEFT JOIN cd01 cd01_01 on WLX01.hsien_id=cd01_01.hsien_id  
 					    LEFT JOIN cd02 cd02_01 on WLX01.area_id=cd02_01.area_id  
 						LEFT JOIN cd01 cd01_02 on WLX01.it_hsien_id=cd01_02.hsien_id  
 						LEFT JOIN cd02 cd02_02 on WLX01.it_area_id=cd02_02.area_id  
 						LEFT JOIN cd01 cd01_03 on WLX01.audit_hsien_id=cd01_03.hsien_id  
 						LEFT JOIN cd02 cd02_03 on WLX01.audit_area_id=cd02_03.area_id 
 						LEFT JOIN cdshareno on cdshareno.cmuse_id=WLX01.chg_license_reason  and cdshareno.cmuse_div = '004' 
 			where WLX01.bank_no IN ('6200031') 
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
  			
  			System.out.println("FR0066WA_Excel.sqlCmd="+sqlCmd);	   
			List dbData = DBManager.QueryDB_SQLParam(sqlCmd,"setup_date,chg_license_date,start_date,open_date");            
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
                			
            for ( i = 0; i < dbData.size(); i ++) {                
                row = sheet.createRow( rowNo );     
                row.setHeight((short) 0x120); 
                for(int j=0;j<btnFieldList_data.size();j++){
                	field = ((String)((List)btnFieldList_data.get(j)).get(0)).toLowerCase();	
                	//System.out.println("cretea cell="+field);
                	if((!((field.indexOf("cdshareno") != -1) 
                	|| (field.indexOf("cd01_02") != -1) || (field.indexOf("cd02_02") != -1) 
                	|| (field.indexOf("cd01_03") != -1) || (field.indexOf("cd02_03") != -1)))
                	&& (field.indexOf(".") != -1)){                	
                	   field = field.substring(field.indexOf(".")+1,field.length());
                	}
                	
			        if(field.equals("setup_date") || field.equals("chg_license_date") 
			        || field.equals("start_date") || field.equals("open_date")){
			           if((((DataObject)dbData.get(i)).getValue(field)) != null){
				 		  reportUtil.createCell( wb, row, ( short )(j+1),Utility.getCHTdate((((DataObject)dbData.get(i)).getValue(field)).toString().substring(0, 10), 1) ,defaultStyle );				   
				 		   //System.out.println(Utility.getCHTdate((((DataObject)dbData.get(i)).getValue(field)).toString().substring(0, 10), 1));
					   }else{				   
				   		  reportUtil.createCell( wb, row, ( short )(j+1),"" ,defaultStyle );   
					  }					     
			        }else{
			           if((field).equals("cdshareno.cmuse_name")){field = "chg_license_reason_name";}
			           if((field).equals("cd01_02.hsien_name")){field = "it_hsien_name";}
			           if((field).equals("cd02_02.area_name")){field = "it_area_name";}
			           if((field).equals("cd01_03.hsien_name")){field = "audit_hsien_name";}
			           if((field).equals("cd02_03.area_name")){field = "audit_area_name";}
			           reportUtil.createCell( wb, row, ( short )(j+1),(String)((DataObject)dbData.get(i)).getValue(field) ,defaultStyle );					
			           //System.out.println((String)((DataObject)dbData.get(i)).getValue(field));
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
            
            FileInputStream fin = new FileInputStream(Utility.getProperties("reportDir")+System.getProperty("file.separator")+ titleName+".xls");  		 
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
<%
//109.06.17 create A15電子銀行及網路銀行交易情形資料表 by 2295
//111.04.11 調整排序欄位不是null時,才加入欄位 by 2295    
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
    String E_MONTH = "";//月
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
			titleName += "A15電子銀行及網路銀行交易情形資料表";
			//年
			if(session.getAttribute("S_YEAR") != null && !((String)session.getAttribute("S_YEAR")).equals("")){
		  		S_YEAR = (String)session.getAttribute("S_YEAR");		  				   
			}
			//年
			if(session.getAttribute("E_YEAR") != null && !((String)session.getAttribute("E_YEAR")).equals("")){
		  		E_YEAR = (String)session.getAttribute("E_YEAR");		  				   
			}
			//95.12.01 增加年月區間
			//月
			if(session.getAttribute("S_MONTH") != null && !((String)session.getAttribute("S_MONTH")).equals("")){
		  		S_MONTH = (String)session.getAttribute("S_MONTH");		  				   
			}
			//月
			if(session.getAttribute("E_MONTH") != null && !((String)session.getAttribute("E_MONTH")).equals("")){
		  		E_MONTH = (String)session.getAttribute("E_MONTH");		  				   
			}
			if(S_YEAR!=null && Integer.parseInt(S_YEAR)>99) {
				u_year = "100" ;
				cdTable = "cd01" ;
			}	
			
			
			//金額單位
			if(session.getAttribute("Unit") != null && !((String)session.getAttribute("Unit")).equals("")){
		  		Unit = (String)session.getAttribute("Unit");		  				   
			}
			
			//讀取欄位大類所包含的中類===================================================================================        	
        	Properties prop_detail_column = new Properties();
			prop_detail_column.load(new FileInputStream(Utility.getProperties("schemaDir")+System.getProperty("file.separator")+"A15_detail.TXT"));									
			//取出欄位中類將資料存入MAP-->key=大類acc_code,value=中類acc_code=============================================================
			HashMap h_column_detail = new HashMap();//儲存column大類,及其中類的acc_code			
			List detail_column_detail = new LinkedList();
			String column_tmp_detail = "";						
			for(i=0;i<btnFieldList_data.size();i++){			    
			    column_tmp_detail = "";
			    column_tmp_detail = (String)prop_detail_column.get((String)((List)btnFieldList_data.get(i)).get(0));
			    //System.out.println("column_tmp_detail="+column_tmp_detail);
			    if(!column_tmp_detail.equals("")){
			        detail_column_detail = Utility.getStringTokenizerData(column_tmp_detail,"+");
			        //System.out.println((String)((List)btnFieldList_data.get(i)).get(0)+"="+detail_column_detail);			        		      
			        h_column_detail.put((String)((List)btnFieldList_data.get(i)).get(0),detail_column_detail);//大類->中類			       			      
			    }
			}
			System.out.println("大類->中類.h_column_detail.size()="+h_column_detail.size());
			
			//讀取欄位中類所包含的細項===================================================================================        	
			Properties prop_column = new Properties();
			prop_column.load(new FileInputStream(Utility.getProperties("schemaDir")+System.getProperty("file.separator")+"A15_detail_column.TXT"));									
			//取出欄位細項將資料存入MAP-->key=中類acc_code,value=細項acc_code=============================================================
			HashMap h_column = new HashMap();//儲存column中類,及其細項的acc_code			
			List detail_column = new LinkedList();
			String column_tmp = "";			
			String selectacc_code = "";//選取的detail科目代號
			List acc_code_List = new LinkedList();//109.06.17
			String acc_code = "";//109.06.17 add
			boolean exist_acc_code = false;//109/06.17 add
			int columnLength=0;//column個數			
			for(i=0;i<btnFieldList_data.size();i++){			    
			    column_tmp = "";
			    //System.out.println("test111="+(String)((List)btnFieldList_data.get(i)).get(0));
			    detail_column_detail = (List)h_column_detail.get((String)((List)btnFieldList_data.get(i)).get(0));//取得大類.包含的中類
			    for(detailidx=0;detailidx<detail_column_detail.size();detailidx++){
			        column_tmp = (String)prop_column.get((String)detail_column_detail.get(detailidx));//取得中類.包含的細項
			        //System.out.println("column_tmp="+column_tmp);
			        if(!column_tmp.equals("")){
			           detail_column = Utility.getStringTokenizerData(column_tmp,"+");
			           //System.out.println(detail_column);
			           if(detail_column != null && detail_column.size() != 0){               
			              columnLength += detail_column.size();//累加總欄位個數
              		      for(j=0;j<detail_column.size();j++){
            	 		      selectacc_code +="'"+(String)detail_column.get(j)+"'";   
            	 		      //field_900100_month         	
            	 		      acc_code = ((String)detail_column.get(j)).substring(6,12);
            	 		      //System.out.println("acc_code="+acc_code);
            	 		      if(acc_code_List.size() == 0) acc_code_List.add(acc_code);
            	 		      //System.out.println("acc_code_List.size()="+acc_code_List.size());
            	 		      exist_acc_code = false;
							  for(int k=0;k<acc_code_List.size();k++){
							  	  //System.out.println("k="+k+"="+(String)acc_code_List.get(k));
							      if(((String)acc_code_List.get(k)).equals(acc_code)){
							      	 exist_acc_code = true;
							      }	
							  }	     
							  if(!exist_acc_code){
							  	 acc_code_List.add(acc_code);
							     //System.out.println("acc_code add "+acc_code);       	 		      
							  }       
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
			System.out.println("acc_code_List.size()="+acc_code_List.size());
			/*
			for(int k=0;k<acc_code_List.size();k++){
				System.out.println("k="+k+"="+(String)acc_code_List.get(k));
			}*/	    
			System.out.println("中類->細項.h_column.size()="+h_column.size());
        	//讀取報表欄位名稱===================================================================================        	
        	Properties prop_column_name = new Properties();        	
			prop_column_name.load(new FileInputStream(Utility.getProperties("schemaDir")+System.getProperty("file.separator")+"A15_column.TXT"));			
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
            		if(!"null".equals((String)((List)SortList_data.get(i)).get(0))){//111.04.11不是null時,才加入欄位
            		   order += (String)((List)SortList_data.get(i)).get(0);
            		   if(i < SortList_data.size() -1 ) order +=",";            
            		}
	            }
	            System.out.println("order="+order);
            }
            //====================================================================================            
  			/*
  			//各別機構  		
  			部份	
  			select a15.bank_code,bn01.bank_name,a15.m_year || '/' || m_month as m_yearmonth,wlx01.hsien_id,cd01.hsien_name,
			a15.field_900100_month,field_900100_year,field_900200_month,field_900200_year,
			field_900300_month,field_900300_year,field_900400_month,field_900400_year,
			field_910101_month,field_910101_year, field_910102_month,field_910102_year
            from (
                  select m_year,m_month,bank_code,
                         sum(decode(acc_code,'900100',month_amt,0)) as field_900100_month,
                         sum(decode(acc_code,'900100',year_amt,0)) as field_900100_year, 
                         sum(decode(acc_code,'900200',month_amt,0)) as field_900200_month,
                         sum(decode(acc_code,'900200',year_amt,0)) as field_900200_year,
                         sum(decode(acc_code,'900300',month_amt,0)) as field_900300_month,
                         sum(decode(acc_code,'900300',year_amt,0)) as field_900300_year,
                         sum(decode(acc_code,'900400',month_amt,0)) as field_900400_month,
                         sum(decode(acc_code,'900400',year_amt,0)) as field_900400_year,
                         sum(decode(acc_code,'910101',month_amt,0)) as field_910101_month,
                         sum(decode(acc_code,'910101',year_amt,0)) as field_910101_year,
                         sum(decode(acc_code,'910102',month_amt,0)) as field_910102_month,
                         sum(decode(acc_code,'910102',year_amt,0)) as field_910102_year,
                         '0' as type_900100_month,
                         '0' as type_900100_year,
                         '0' as type_900200_month,
                         '0' as type_900200_year,
                         '0' as type_900300_month,
                         '0' as type_900300_year,
                         '0' as type_900400_month,
                         '0' as type_900400_year,
                         '0' as type_910101_month,
                         '0' as type_910101_year,
                         '0' as type_910102_month,
                         '0' as type_910102_year
                  from (select * 
                        from 
                              ( select m_year,m_month,bank_code,acc_code,'0' as type,month_amt,year_amt from a15
                              where (to_char(m_year * 100 + m_month) >= 10812 and to_char(m_year * 100 + m_month) <= 10901)
                                and bank_code in  ('6030016','6060019')
                            )
                       ) 
                  group by m_year,m_month,bank_code
                 )a15 
            ,(select * from bn01 where bn01.m_year=100)bn01 left join (select * from wlx01 where m_year=100)wlx01                 
            on bn01.bank_no = wlx01.bank_no
            left join cd01 on wlx01.HSIEN_ID = cd01.HSIEN_ID  
            where a15.bank_code = bn01.bank_no
            and bn01.bank_no in ('6030016','6060019') and bn01.bn_type <> '2' 
            and a15.bank_code = bn01.bank_no
            group by a15.bank_code,bn01.bank_name,a15.m_year,a15.m_month,wlx01.hsien_id,cd01.hsien_name,a15.field_900100_month, field_900100_year,
            field_900200_month,field_900200_year,field_900300_month,field_900300_year,field_900400_month,field_900400_year,field_910101_month,field_910101_year, field_910102_month,field_910102_year
            order by a15.bank_code,a15.m_year,a15.m_month	
            
            
            
           select a15.bank_code,bn01.bank_name,a15.m_year || '/' || m_month as m_yearmonth,wlx01.hsien_id,cd01.hsien_name,
                  field_900100_month,field_900100_year,field_900200_month,field_900200_year,
                  field_900300_month,field_900300_year,field_900400_month,field_900400_year,
                  field_910101_month,field_910101_year,field_910102_month,field_910102_year,
                  field_910201_month,field_910201_year,field_910202_month,field_910202_year,
                  field_910311_month,field_910311_year,field_910312_month,field_910312_year,
                  field_910321_month,field_910321_year,field_910322_month,field_910322_year,
                  field_910331_month,field_910331_year,field_910332_month,field_910332_year,
                  field_910341_month,field_910341_year,field_910342_month,field_910342_year,
                  field_920101_month,field_920101_year,field_920102_month,field_920102_year,
                  field_920201_month,field_920201_year,field_920202_month,field_920202_year,
                  field_920311_month,field_920311_year,field_920312_month,field_920312_year,
                  field_920321_month,field_920321_year,field_920322_month,field_920322_year,
                  field_920331_month,field_920331_year,field_920332_month,field_920332_year,
                  field_920341_month,field_920341_year,field_920342_month,field_920342_year,
                  field_920351_month,field_920351_year,field_920352_month,field_920352_year,
                  field_920471_month,field_920471_year,field_920472_month,field_920472_year,
                  type_900100_month,type_900100_year,type_900200_month,type_900200_year,
                  type_900300_month,type_900300_year,type_900400_month,type_900400_year,
                  type_910101_month,type_910101_year,type_910102_month,type_910102_year,
                  type_910201_month,type_910201_year,type_910202_month,type_910202_year,
                  type_910311_month,type_910311_year,type_910312_month,type_910312_year,
                  type_910321_month,type_910321_year,type_910322_month,type_910322_year,
                  type_910331_month,type_910331_year,type_910332_month,type_910332_year,
                  type_910341_month,type_910341_year,type_910342_month,type_910342_year,
                  type_920101_month,type_920101_year,type_920102_month,type_920102_year,
                  type_920201_month,type_920201_year,type_920202_month,type_920202_year,
                  type_920311_month,type_920311_year,type_920312_month,type_920312_year,
                  type_920321_month,type_920321_year,type_920322_month,type_920322_year,
                  type_920331_month,type_920331_year,type_920332_month,type_920332_year,
                  type_920341_month,type_920341_year,type_920342_month,type_920342_year,
                  type_920351_month,type_920351_year,type_920352_month,type_920352_year,
                  type_920471_month,type_920471_year,type_920472_month,type_920472_year 
            from (
                  select m_year,m_month,bank_code,
                         sum(decode(acc_code,'900100',month_amt,0)) as field_900100_month,
                         sum(decode(acc_code,'900100',year_amt,0)) as field_900100_year, 
                         sum(decode(acc_code,'900200',month_amt,0)) as field_900200_month,
                         sum(decode(acc_code,'900200',year_amt,0)) as field_900200_year,
                         sum(decode(acc_code,'900300',month_amt,0)) as field_900300_month,
                         sum(decode(acc_code,'900300',year_amt,0)) as field_900300_year,
                         sum(decode(acc_code,'900400',month_amt,0)) as field_900400_month,
                         sum(decode(acc_code,'900400',year_amt,0)) as field_900400_year,
                         sum(decode(acc_code,'910101',month_amt,0)) as field_910101_month,
                         sum(decode(acc_code,'910101',year_amt,0)) as field_910101_year,
                         sum(decode(acc_code,'910102',month_amt,0)) as field_910102_month,
                         sum(decode(acc_code,'910102',year_amt,0)) as field_910102_year,
                         sum(decode(acc_code,'910201',month_amt,0)) as field_910201_month,
                         sum(decode(acc_code,'910201',year_amt,0)) as field_910201_year,
                         sum(decode(acc_code,'910202',month_amt,0)) as field_910202_month,
                         sum(decode(acc_code,'910202',year_amt,0)) as field_910202_year,
                         sum(decode(acc_code,'910311',month_amt,0)) as field_910311_month,
                         sum(decode(acc_code,'910311',year_amt,0)) as field_910311_year,
                         sum(decode(acc_code,'910312',month_amt,0)) as field_910312_month,
                         sum(decode(acc_code,'910312',year_amt,0)) as field_910312_year,
                         sum(decode(acc_code,'910321',month_amt,0)) as field_910321_month,
                         sum(decode(acc_code,'910321',year_amt,0)) as field_910321_year,
                         sum(decode(acc_code,'910322',month_amt,0)) as field_910322_month,
                         sum(decode(acc_code,'910322',year_amt,0)) as field_910322_year,
                         sum(decode(acc_code,'910331',month_amt,0)) as field_910331_month,
                         sum(decode(acc_code,'910331',year_amt,0)) as field_910331_year,
                         sum(decode(acc_code,'910332',month_amt,0)) as field_910332_month,
                         sum(decode(acc_code,'910332',year_amt,0)) as field_910332_year,
                         sum(decode(acc_code,'910341',month_amt,0)) as field_910341_month,
                         sum(decode(acc_code,'910341',year_amt,0)) as field_910341_year,
                         sum(decode(acc_code,'910342',month_amt,0)) as field_910342_month,
                         sum(decode(acc_code,'910342',year_amt,0)) as field_910342_year,
                         sum(decode(acc_code,'920101',month_amt,0)) as field_920101_month,
                         sum(decode(acc_code,'920101',year_amt,0)) as field_920101_year,
                         sum(decode(acc_code,'920102',month_amt,0)) as field_920102_month,
                         sum(decode(acc_code,'920102',year_amt,0)) as field_920102_year,
                         sum(decode(acc_code,'920201',month_amt,0)) as field_920201_month,
                         sum(decode(acc_code,'920201',year_amt,0)) as field_920201_year,
                         sum(decode(acc_code,'920202',month_amt,0)) as field_920202_month,
                         sum(decode(acc_code,'920202',year_amt,0)) as field_920202_year,
                         sum(decode(acc_code,'920311',month_amt,0)) as field_920311_month,
                         sum(decode(acc_code,'920311',year_amt,0)) as field_920311_year,
                         sum(decode(acc_code,'920312',month_amt,0)) as field_920312_month,
                         sum(decode(acc_code,'920312',year_amt,0)) as field_920312_year,
                         sum(decode(acc_code,'920321',month_amt,0)) as field_920321_month,
                         sum(decode(acc_code,'920321',year_amt,0)) as field_920321_year,
                         sum(decode(acc_code,'920322',month_amt,0)) as field_920322_month,
                         sum(decode(acc_code,'920322',year_amt,0)) as field_920322_year,
                         sum(decode(acc_code,'920331',month_amt,0)) as field_920331_month,
                         sum(decode(acc_code,'920331',year_amt,0)) as field_920331_year,
                         sum(decode(acc_code,'920332',month_amt,0)) as field_920332_month,
                         sum(decode(acc_code,'920332',year_amt,0)) as field_920332_year,
                         sum(decode(acc_code,'920341',month_amt,0)) as field_920341_month,
                         sum(decode(acc_code,'920341',year_amt,0)) as field_920341_year,
                         sum(decode(acc_code,'920342',month_amt,0)) as field_920342_month,
                         sum(decode(acc_code,'920342',year_amt,0)) as field_920342_year,
                         sum(decode(acc_code,'920351',month_amt,0)) as field_920351_month,
                         sum(decode(acc_code,'920351',year_amt,0)) as field_920351_year,
                         sum(decode(acc_code,'920352',month_amt,0)) as field_920352_month,
                         sum(decode(acc_code,'920352',year_amt,0)) as field_920352_year,
                         sum(decode(acc_code,'920471',month_amt,0)) as field_920471_month,
                         sum(decode(acc_code,'920471',year_amt,0)) as field_920471_year,
                         sum(decode(acc_code,'920472',month_amt,0)) as field_920472_month,
                         sum(decode(acc_code,'920472',year_amt,0)) as field_920472_year,                                                  
                         '0' as type_900100_month,
                         '0' as type_900100_year,
                         '0' as type_900200_month,
                         '0' as type_900200_year,
                         '0' as type_900300_month,
                         '0' as type_900300_year,
                         '0' as type_900400_month,
                         '0' as type_900400_year,
                         '0' as type_910101_month,
                         '0' as type_910101_year,
                         '0' as type_910102_month,
                         '0' as type_910102_year,
                         '0' as type_910201_month,
                         '0' as type_910201_year,
                         '0' as type_910202_month,
                         '0' as type_910202_year,
                         '0' as type_910311_month,
                         '0' as type_910311_year,
                         '0' as type_910312_month,
                         '0' as type_910312_year,
                         '0' as type_910321_month,
                         '0' as type_910321_year,
                         '0' as type_910322_month,
                         '0' as type_910322_year,
                         '0' as type_910331_month,
                         '0' as type_910331_year,
                         '0' as type_910332_month,
                         '0' as type_910332_year,
                         '0' as type_910341_month,
                         '0' as type_910341_year,
                         '0' as type_910342_month,
                         '0' as type_910342_year,
                         '0' as type_920101_month,
                         '0' as type_920101_year,
                         '0' as type_920102_month,
                         '0' as type_920102_year,
                         '0' as type_920201_month,
                         '0' as type_920201_year,
                         '0' as type_920202_month,
                         '0' as type_920202_year,
                         '0' as type_920311_month,
                         '0' as type_920311_year,
                         '0' as type_920312_month,
                         '0' as type_920312_year,
                         '0' as type_920321_month,
                         '0' as type_920321_year,
                         '0' as type_920322_month,
                         '0' as type_920322_year,
                         '0' as type_920331_month,
                         '0' as type_920331_year,
                         '0' as type_920332_month,
                         '0' as type_920332_year,
                         '0' as type_920341_month,
                         '0' as type_920341_year,
                         '0' as type_920342_month,
                         '0' as type_920342_year,
                         '0' as type_920351_month,
                         '0' as type_920351_year,
                         '0' as type_920352_month,
                         '0' as type_920352_year,
                         '0' as type_920471_month,
                         '0' as type_920471_year,
                         '0' as type_920472_month,
                         '0' as type_920472_year
                  from (select * 
                        from 
                              ( select m_year,m_month,bank_code,acc_code,'0' as type,month_amt,year_amt from a15
                              where (to_char(m_year * 100 + m_month) >= 10901 and to_char(m_year * 100 + m_month) <= 10902)
                                and bank_code in  ('6030016','6060019')
                            )
                       ) 
                  group by m_year,m_month,bank_code
                 )a15 
            ,(select * from bn01 where bn01.m_year=100)bn01 left join (select * from wlx01 where m_year=100)wlx01                 
            on bn01.bank_no = wlx01.bank_no
            left join cd01 on wlx01.HSIEN_ID = cd01.HSIEN_ID  
            where a15.bank_code = bn01.bank_no
            and bn01.bank_no in ('6030016') and bn01.bn_type <> '2' 
            and a15.bank_code = bn01.bank_no
            group by a15.bank_code,bn01.bank_name,a15.m_year,a15.m_month,wlx01.hsien_id,cd01.hsien_name,
                  a15.field_900100_month,field_900100_year,field_900200_month,field_900200_year,field_900300_month,field_900300_year,field_900400_month,field_900400_year,
                  field_910101_month,field_910101_year, field_910102_month,field_910102_year,field_910201_month,field_910201_year,field_910202_month,field_910202_year,
                  field_910311_month,field_910311_year,field_910312_month,field_910312_year,field_910321_month,field_910321_year,field_910322_month,field_910322_year, 
                  field_910331_month,field_910331_year,field_910332_month,field_910332_year,field_910341_month,field_910341_year,field_910342_month,field_910342_year,
                  field_920101_month,field_920101_year,field_920102_month,field_920102_year,field_920201_month,field_920201_year,field_920202_month,field_920202_year,
                  field_920311_month,field_920311_year,field_920312_month,field_920312_year,field_920321_month,field_920321_year,field_920322_month,field_920322_year,
                  field_920331_month,field_920331_year,field_920332_month,field_920332_year,field_920341_month,field_920341_year,field_920342_month,field_920342_year,
                  field_920351_month,field_920351_year,field_920352_month,field_920352_year,field_920471_month,field_920471_year,field_920472_month,field_920472_year,
                  type_900100_month,type_900100_year,type_900200_month,type_900200_year,type_900300_month,type_900300_year,type_900400_month,type_900400_year,
                  type_910101_month,type_910101_year,type_910102_month,type_910102_year,type_910201_month,type_910201_year,type_910202_month,type_910202_year,
                  type_910311_month,type_910311_year,type_910312_month,type_910312_year,type_910321_month,type_910321_year,type_910322_month,type_910322_year,
                  type_910331_month,type_910331_year,type_910332_month,type_910332_year,type_910341_month,type_910341_year,type_910342_month,type_910342_year,
                  type_920101_month,type_920101_year,type_920102_month,type_920102_year,type_920201_month,type_920201_year,type_920202_month,type_920202_year,
                  type_920311_month,type_920311_year,type_920312_month,type_920312_year,type_920321_month,type_920321_year,type_920322_month,type_920322_year,
                  type_920331_month,type_920331_year,type_920332_month,type_920332_year,type_920341_month,type_920341_year,type_920342_month,type_920342_year,
                  type_920351_month,type_920351_year,type_920352_month,type_920352_year,type_920471_month,type_920471_year,type_920472_month,type_920472_year 
            order by a15.bank_code,a15.m_year,a15.m_month
            
			//縣市別小計.無縣市別統計			
  			*/
  			
            String column = "";//選取欄位                      
			//======================================================
            //String sqlCmd="";
			StringBuffer sqlCmd = new StringBuffer() ;
			List sqlCmdList = new ArrayList() ;
			List sqlCmd_paramList = new ArrayList();
            String sqlCmd_sum="";//縣市別小計            
            
            sqlCmd.append("");  
            sqlCmd.append(" select a15.bank_code,bn01.bank_name,a15.m_year || '/' || m_month as m_yearmonth,wlx01.hsien_id,cd01.hsien_name,");
            for(int k=0;k<acc_code_List.size();k++){
				//System.out.println("k="+k+"="+(String)acc_code_List.get(k));
				sqlCmd.append(" field_"+(String)acc_code_List.get(k)+"_month,");
				sqlCmd.append(" field_"+(String)acc_code_List.get(k)+"_year,");				
				sqlCmd.append(" type_"+(String)acc_code_List.get(k)+"_month,");
				sqlCmd.append(" type_"+(String)acc_code_List.get(k)+"_year"+((k == acc_code_List.size()-1)?" ":","));				
			} 
           
            sqlCmd.append("  from (");
            sqlCmd.append("  select m_year,m_month,bank_code,");
            for(int k=0;k<acc_code_List.size();k++){
				//System.out.println("k="+k+"="+(String)acc_code_List.get(k));
				sqlCmd.append(" sum(decode(acc_code,'"+(String)acc_code_List.get(k)+"',month_amt,0)) as field_"+(String)acc_code_List.get(k)+"_month,");
				sqlCmd.append(" sum(decode(acc_code,'"+(String)acc_code_List.get(k)+"',year_amt,0)) as field_"+(String)acc_code_List.get(k)+"_year,");
				sqlCmd.append(" '0' as type_"+(String)acc_code_List.get(k)+"_month,");
                sqlCmd.append(" '0' as type_"+(String)acc_code_List.get(k)+"_year"+((k == acc_code_List.size()-1)?" ":","));				
			}           
            
          
            sqlCmd.append("      from (select * ");
            sqlCmd.append("            from ");
            sqlCmd.append("                ( select m_year,m_month,bank_code,acc_code,'0' as type,month_amt,year_amt from a15");
            sqlCmd.append("                  where (to_char(m_year * 100 + m_month) >= ? and to_char(m_year * 100 + m_month) <= ?)");
            sqlCmd_paramList.add(S_YEAR+S_MONTH);
			sqlCmd_paramList.add(E_YEAR+E_MONTH);
            sqlCmd.append("                    and bank_code in  ("+selectBank_no+")");
            sqlCmd.append("                )");
            sqlCmd.append("           ) ");
            sqlCmd.append("           group by m_year,m_month,bank_code");
            sqlCmd.append(" )a15 ");
            sqlCmd.append(" ,(select * from bn01 where bn01.m_year=?)bn01 left join (select * from wlx01 where m_year=?)wlx01");                 
            sqlCmd_paramList.add(u_year);
			sqlCmd_paramList.add(u_year);
            sqlCmd.append(" on bn01.bank_no = wlx01.bank_no");
            sqlCmd.append(" left join cd01 on wlx01.HSIEN_ID = cd01.HSIEN_ID");
            sqlCmd.append(" where a15.bank_code = bn01.bank_no");
            sqlCmd.append(" and bn01.bank_no in ("+selectBank_no+") and bn01.bn_type <> ?");
            sqlCmd_paramList.add("2") ;
            sqlCmd.append(" and a15.bank_code = bn01.bank_no");
            sqlCmd.append(" group by a15.bank_code,bn01.bank_name,a15.m_year,a15.m_month,wlx01.hsien_id,cd01.hsien_name,");
            
            for(int k=0;k<acc_code_List.size();k++){
				//System.out.println("k="+k+"="+(String)acc_code_List.get(k));
				sqlCmd.append(" field_"+(String)acc_code_List.get(k)+"_month,");
				sqlCmd.append(" field_"+(String)acc_code_List.get(k)+"_year,");				
				sqlCmd.append(" type_"+(String)acc_code_List.get(k)+"_month,");
				sqlCmd.append(" type_"+(String)acc_code_List.get(k)+"_year"+((k == acc_code_List.size()-1)?" ":","));				
			}
            
		    if(!order.equals("")){	  
			    //有挑選排序欄位年月時,查詢SQL error by 2295 						    	    
			    sqlCmd.append(" order by ").append(order) ;		    
  				//SoryBy=asc/desc
  				if( session.getAttribute("SortBy") != null && !((String)session.getAttribute("SortBy")).equals("") && !((String)session.getAttribute("SortBy")).equals("null")){//111.04.11不是null時,才加入欄位
  		            sqlCmd.append(" " + (String)session.getAttribute("SortBy"));	  		              		        
  		        }
  		    }else{  		    	
  		    	//order by a15.bank_code,a15.m_year,a15.m_month    		       
  		       sqlCmd.append(" order by a15.bank_code,a15.m_year,a15.m_month ");  		       
  		    }    
			            			      
            //System.out.println("sqlCmd="+sqlCmd);
            //讀取報表欄位名稱===================================================================================        	
        	Properties p = new Properties();
			p.load(new FileInputStream(Utility.getProperties("schemaDir")+System.getProperty("file.separator")+"A02_"+bank_type+"_column"+((Integer.parseInt(S_YEAR+S_MONTH) >= 9901)?"_9901":"")+".TXT"));			
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
            //設定表頭(資產負債表/損益表)===============================================================================
            row = sheet.createRow( ( short )1 );
            reportUtil.createCell( wb, row, ( short )1, titleName, titleStyle );
            
            for(i=2;i<columnLength+5;i++){
              reportUtil.createCell( wb, row, ( short )i, "", noBorderDefaultStyle );
            }            
            sheet.addMergedRegion( new Region( ( short )1, ( short )1,
                                               ( short )1,
                                               ( short )(columnLength+3)) );
            //列印年月=======================================================================================
            row = sheet.createRow( ( short )2 );            
            row.setHeight((short) 0x200);
            reportUtil.createCell( wb, row, ( short )1, S_YEAR + "年" + S_MONTH + "月", titleStyle );
            for(i=2;i<columnLength+5;i++){
               reportUtil.createCell( wb, row, ( short )i, "", noBorderDefaultStyle );
            }            
            sheet.addMergedRegion( new Region( ( short )2, ( short )1,
                                               ( short )2,
                                               ( short )(columnLength+3) ) );
            //======================================================================================================                                                                     
            row = sheet.createRow( ( short )3 );            
            String printTime = Utility.getDateFormat("  HH:mm:ss");
            String printDate = Utility.getDateFormat("yyyy/MM/dd");                                    
            reportUtil.createCell( wb, row, ( short )1, "列印日期："+Utility.getCHTdate(printDate, 1)+printTime, noBoderStyle );
            sheet.addMergedRegion( new Region( ( short )3, ( short )1,
                                               ( short )3,
                                               ( short )(columnLength+3) ) );            
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
                                               ( short )(columnLength+3) ) );            
            //報表欄位=======================================================================
            //列印單位代號+機構名稱             
            for(i=5;i<9;i++){
                row = sheet.createRow( ( short )i );
                reportUtil.createCell( wb, row, ( short )1, "單位代號", columnStyle );               
                reportUtil.createCell( wb, row, ( short )2, "單位名稱", columnStyle );   
                reportUtil.createCell( wb, row, ( short )3, "查詢年月", columnStyle );//95.12.01 add 查詢年月
            }    
                    
            sheet.addMergedRegion( new Region( ( short )5, ( short )1,
                                               ( short )8,
                                               ( short )1) );                                                                     
            sheet.addMergedRegion( new Region( ( short )5, ( short )2,
                                               ( short )8,
                                               ( short )2) );                                              
            sheet.addMergedRegion( new Region( ( short )5, ( short )3,
                                               ( short )8,
                                               ( short )3) );                                                                           
            //System.out.println("大類表頭");                                                         
            row = sheet.createRow( ( short )5 );//大類表頭
            //row.setHeightInPoints(25);//設定表頭高度
            int columnIdx = 4;
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
                
                sheet.addMergedRegion( new Region( ( short )5, ( short )columnIdx,
                                                   ( short )5,
                                                   ( short )(detailsize + columnIdx - 1)) );                                              
                                                                 
                columnIdx += detailsize;                                             
            }
            //System.out.println("中類表頭");                                                         
            row = sheet.createRow( ( short ) 6);//中類表頭            
            //row.setHeightInPoints(25);//設定大類表頭高度
            columnIdx = 4; 
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
                   
                   sheet.addMergedRegion( new Region( ( short )6, ( short )columnIdx,
                                                      ( short )6,
                                                      ( short )(((List)h_column.get(((String)detail_column_detail.get(detailidx)))).size() + columnIdx - 1)) );                                              
                                                      
                   columnIdx +=  ((List)h_column.get(((String)detail_column_detail.get(detailidx)))).size(); 
               }                                           
            }
            //System.out.println("細項表頭");                                                         
            row = sheet.createRow( ( short ) 7);//細項表頭
            //row.setHeightInPoints(25);//設定細項表頭高度
            columnIdx = 4;          
            for(i=0;i<btnFieldList_data.size();i++){
               //System.out.println("["+i+"]i="+(String)((List)btnFieldList_data.get(i)).get(1));
               //System.out.println("columnIdx="+columnIdx);
               detail_column_detail = (List)h_column_detail.get((String)((List)btnFieldList_data.get(i)).get(0));//取得大類.包含的中類
               for(detailidx=0;detailidx<detail_column_detail.size();detailidx++){//中類
                   //System.out.println("detail.size="+((List)h_column.get(((String)detail_column_detail.get(detailidx)))).size());//取得中類.包含細項的size	
                   detail_column = (List)h_column.get(((String)detail_column_detail.get(detailidx)));//取得中類的細項		
                   //設定細項表頭欄位
                   for(j=0 ;j<detail_column.size();j++){                    
                       System.out.println((String)detail_column.get(j)+"="+Utility.ISOtoUTF8((String)prop_column_name.get((String)detail_column.get(j))));                                           
                       reportUtil.createCell( wb, row, ( short )columnIdx, Utility.ISOtoUTF8((String)prop_column_name.get((String)detail_column.get(j))), columnStyle );               
                       columnIdx ++;
                   }//end of 細項                        
               }//end of中類                        
            }//end of 大類
            //System.out.println("細項-科目代號");          
            row = sheet.createRow( ( short ) 8);//細項-科目代號
            columnIdx = 4;  
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
              						
  			//System.out.println("DS001W_Excel.sqlCmd="+sqlCmd);	   
  			
  			List dbData = null;
  			
			//dbData = DBManager.QueryDB(sqlCmd,"amt");
			System.out.println("Query====================================") ;
			dbData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),sqlCmd_paramList,
			         "field_900100_month,field_900100_year,field_900200_month,field_900200_year,field_900300_month,field_900300_year,field_900400_month,field_900400_year,"+
                     "field_910101_month,field_910101_year, field_910102_month,field_910102_year,"+
                     "field_910201_month,field_910201_year,field_910202_month,field_910202_year,"+
                     "field_910311_month,field_910311_year,field_910312_month,field_910312_year,"+
                     "field_910321_month,field_910321_year,field_910322_month,field_910322_year,field_910331_month,field_910331_year,field_910332_month,field_910332_year,field_910341_month,field_910341_year,field_910342_month,field_910342_year,"+
                     "field_920101_month,field_920101_year,field_920102_month,field_920102_year,field_920201_month,field_920201_year,field_920202_month,field_920202_year,"+
                     "field_920311_month,field_920311_year,field_920312_month,field_920312_year,field_920321_month,field_920321_year,field_920322_month,field_920322_year,"+
                     "field_920331_month,field_920331_year,field_920332_month,field_920332_year,field_920341_month,field_920341_year,field_920342_month,field_920342_year,"+
                     "field_920351_month,field_920351_year,field_920352_month,field_920352_year,field_920471_month,field_920471_year,field_920472_month,field_920472_year"+
                     "type_900100_month,type_900100_year,type_900200_month,type_900200_year,type_900300_month,type_900300_year,type_900400_month,type_900400_year,"+
                     "type_910101_month,type_910101_year,type_910102_month,type_910102_year,type_910201_month,type_910201_year,type_910202_month,type_910202_year,"+ 
                     "type_910311_month,type_910311_year,type_910312_month,type_910312_year,type_910321_month,type_910321_year,type_910322_month,type_910322_year,"+ 
                     "type_910331_month,type_910331_year,type_910332_month,type_910332_year,type_910341_month,type_910341_year,type_910342_month,type_910342_year,"+ 
                     "type_920101_month,type_920101_year,type_920102_month,type_920102_year,type_920201_month,type_920201_year,type_920202_month,type_920202_year,"+                        
                     "type_920311_month,type_920311_year,type_920312_month,type_920312_year,type_920321_month,type_920321_year,type_920322_month,type_920322_year,"+
                     "type_920331_month,type_920331_year,type_920332_month,type_920332_year,type_920341_month,type_920341_year,type_920342_month,type_920342_year,"+ 
                     "type_920351_month,type_920351_year,type_920352_month,type_920352_year,type_920471_month,type_920471_year,type_920472_month,type_920472_year") ;
			//System.out.println("DS001W_Excel.sqlCmd="+sqlCmd);	          
			         
			           
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
                    //System.out.println("rowNo="+rowNo);   
                    //System.out.println("m_yearmonth="+(((DataObject) dbData.get(i)).getValue("m_yearmonth")).toString());
                    row.setHeight((short) 0x120);    
                    //System.out.println("bank_code="+(String) ((DataObject) dbData.get(i)).getValue("bank_code"));                
                    
                    reportUtil.createCell( wb, row, ( short )columnIdx, (String) ((DataObject) dbData.get(i)).getValue("bank_code"), defaultStyle );//單位代號
                    columnIdx++;
                    reportUtil.createCell( wb, row, ( short )columnIdx, (String) ((DataObject) dbData.get(i)).getValue("bank_name"), defaultStyle );//機構名稱
                    columnIdx++;
                    
                    //95.12.01 add 查詢年月
                    reportUtil.createCell( wb, row, ( short )columnIdx, (((DataObject) dbData.get(i)).getValue("m_yearmonth")).toString(), defaultStyle );//查詢年月
                    columnIdx++;
                    for(int cellIdx =4;cellIdx < (new Short(lastCellNum)).intValue();cellIdx++){                    
                         amt="";
                         amt_type = "";
                         cell = acc_code_row.getCell((short)cellIdx);                    
                         //System.out.println("acc_code="+cell.getStringCellValue());                  
                         amt =(((DataObject) dbData.get(i)).getValue(cell.getStringCellValue())).toString();                                        
                         
                         amt_type = (((DataObject) dbData.get(i)).getValue(cell.getStringCellValue().replaceAll("field", "type"))).toString();                                                             
                         //System.out.println("amt="+amt);
                         //System.out.println("amt_type="+amt_type);
                         if(!amt_type.equals("4")){//該值不為利率時.再除以單位4捨五入
                         	//金額欄位才須除以單位
                         	if(cell.getStringCellValue().indexOf("910102") != -1 || cell.getStringCellValue().indexOf("910202") != -1 || cell.getStringCellValue().indexOf("910312") != -1 || 
							   cell.getStringCellValue().indexOf("910322") != -1 || cell.getStringCellValue().indexOf("910332") != -1 || cell.getStringCellValue().indexOf("910342") != -1 || 
							   cell.getStringCellValue().indexOf("920102") != -1 || cell.getStringCellValue().indexOf("920202") != -1 || cell.getStringCellValue().indexOf("920312") != -1 || 
							   cell.getStringCellValue().indexOf("920322") != -1 || cell.getStringCellValue().indexOf("920332") != -1 || cell.getStringCellValue().indexOf("920342") != -1 || 
							   cell.getStringCellValue().indexOf("920352") != -1 || cell.getStringCellValue().indexOf("920472") != -1 )
							{
	                            amt = Utility.getRound(amt,Unit);                        
                        	}   
                         }  
                            
                         amt = Utility.setCommaFormat(amt);
                         reportUtil.createCell( wb, row, ( short )columnIdx, amt, rightStyle );               
                         columnIdx ++;
                    }       
                    columnIdx = 1;
                    rowNo++;
                    //prtbank_code = (String) ((DataObject) dbData.get(i)).getValue("bank_code");
                }//end of dbData   
                            
            }//end of 有data   
            
            
            //95.09.21 設定表頭欄位.把中間值的acc_code合併成一個欄位只顯示中文名稱=======================================================================                        
            row = sheet.getRow(7);
            columnIdx = 4;    
                    
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
        	System.out.println("DS069W_Report have erros:"+e.getMessage()) ; 
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
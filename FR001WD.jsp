<%
//101.08 created by2968
//101.11.29 改為清單式鎖定狀態   by2968
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tradevan.util.DBManager" %>
<%@ page import="com.tradevan.util.dao.DataObject" %>
<%@ page import="com.tradevan.util.ListArray" %>
<%@ page import="com.tradevan.util.Utility" %>
<%@ page import="com.tradevan.util.report.reportUtil" %>
<%@ page import="java.util.*" %>
<%@include file="./include/Header.include" %>								          

<%	
	String unit =Utility.getTrimString(dataMap.get("Unit"));
	String bank_type =Utility.getTrimString(dataMap.get("bank_type"));
	String s_year =Utility.getTrimString(dataMap.get("S_YEAR"));
	String s_month =Utility.getTrimString(dataMap.get("S_MONTH"));
	String locYear = Utility.getTrimString(dataMap.get("locYear"));
	String locMonth = Utility.getTrimString(dataMap.get("locMonth"));
	System.out.println("*** locYear="+locYear);
	System.out.println("*** locMonth="+locMonth);
	System.out.println(report_no+".act="+act);
	
	
    if(!Utility.CheckPermission(request,report_no)){//無權限時,導向到LoginError.jsp//95.11.03 fix 使用Utility.CheckPermission檢核權限 by 2295
        rd = application.getRequestDispatcher( LoginErrorPgName );        
    }else{            
        if("goLocked".equals(act)){
	        StringBuffer sqlCmd = new StringBuffer();		
	        List paramList = new ArrayList();
	        List DBSqlList = new LinkedList();
	        List<List> updateDBList = new ArrayList<List>();//0:sql 1:data
	        List updateDBSqlList = new ArrayList();
	        List<List> updateDBDataList = new ArrayList<List>();//儲存參數的List
            
	        sqlCmd.append(" select * from rpt_month where m_year = ? and m_month = ? and report_no='FR001WD' ");
     		paramList.add(locYear);
     		paramList.add(locMonth);
	        List qData = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList,""); 
     		System.out.println("### qData.size="+qData.size());
     		
     		sqlCmd.setLength(0) ;
		    paramList = new ArrayList () ;
	        sqlCmd.append("	 select a01.m_year,");
	        sqlCmd.append("			a01.m_month,");
	        sqlCmd.append("			bn01_month.bank_sum_6,");
	        sqlCmd.append("			bn01_month.bank_sum_7,");
	        sqlCmd.append("			field_190000,");//--農會總資產
	        sqlCmd.append("			field_100000,");//--漁會總資產
	        sqlCmd.append("			field_asset,");//--農漁會總資產
	        sqlCmd.append("			round(field_asset/?,0) as field_asset_unit,");//--農漁會總資產取到億元
	        sqlCmd.append("       	field_310000,");//--農會事業資金及公積 
	        sqlCmd.append("       	field_320000,");//--農會盈虧及損益 
	        sqlCmd.append("			field_300000,");//--漁會淨值
	        sqlCmd.append("			field_networth,");//--農漁會淨值
	        sqlCmd.append("			round(field_networth/?,0) as field_networth_unit,");//--農漁會淨值取到億元
	        sqlCmd.append("      	field_220000_6,");//--農會存款 
	        sqlCmd.append("  		field_220000_7,");//--漁會存款 
	        sqlCmd.append("     	field_debit,");//--農漁會存款
	        sqlCmd.append("			round(field_debit/?,0) as field_debit_unit,");//--農漁會存款總額取到億元
	        sqlCmd.append("			field_120000_6,");//--農會放款 
	        sqlCmd.append("			field_120000_7,");//--漁會放款 
	        sqlCmd.append("			field_120800_6,");//--農會備抵呆帳-放款 
	        sqlCmd.append("			field_120800_7,");//--漁會備抵呆帳-放款 
	        sqlCmd.append("			field_150300_6,");//--農會備抵呆帳-催收款項 
	        sqlCmd.append("			field_150300_7,");//--漁會備抵呆帳-催收款項 
	        sqlCmd.append("			field_credit,");//--農漁會放款總額
	        sqlCmd.append("			round(field_credit/?,0) as field_credit_unit,");//--農漁會放款總額取到億元
	        sqlCmd.append("			field_990000_6,");//--農會.狹義逾期放款金額 
	        sqlCmd.append("			field_990000_7,");//--漁會.狹義逾期放款金額
	        sqlCmd.append("			field_990000,");//--農漁會.狹義逾期放款金額
	        sqlCmd.append("			round(field_990000/?,0) as field_990000_unit,");//--農漁會.狹義逾期放款金額.取到億元
	        sqlCmd.append("			field_840740_6,");//--農會.廣義逾期放款
	        sqlCmd.append("			field_840740_7,");//--漁會.廣義逾期放款
	        sqlCmd.append("			field_840740,");//--農漁會.廣義逾期放款
	        sqlCmd.append("			round(field_840740/?,0) as field_840740_unit,");//--農漁會.廣義逾期放款.取到億元
	        sqlCmd.append("			decode(field_credit,0,0,round(field_990000 /  field_credit *100 ,2))  as   field_990000_rate,");//--狹義逾放比率
	        sqlCmd.append("			decode(field_credit,0,0,round(field_840740 /  field_credit *100 ,2))  as   field_840740_rate ");//--廣義逾放比率
	        paramList.add(unit);
	        paramList.add(unit);
	        paramList.add(unit);
	        paramList.add(unit);
	        paramList.add(unit);
	        paramList.add(unit);
	        sqlCmd.append("	from (  ");
	        sqlCmd.append("		select a01.m_year,a01.m_month,");
	        sqlCmd.append("			round(sum(decode(bank_type,'6',decode(a01.acc_code,'190000',amt,0))) /1,0)     as field_190000,");
	        sqlCmd.append("			round(sum(decode(bank_type,'7',decode(a01.acc_code,'100000',amt,0))) /1,0)     as field_100000,");
	        sqlCmd.append("			round(sum(decode(bank_type,'6',decode(a01.acc_code,'190000',amt,0),'7',decode(a01.acc_code,'100000',amt,0))) /1,0)     as field_ASSET,");
	        sqlCmd.append("			round(sum(decode(bank_type,'6',decode(a01.acc_code,'310000',amt,0))) /1,0)     as field_310000,");
	        sqlCmd.append("			round(sum(decode(bank_type,'6',decode(a01.acc_code,'320000',amt,0))) /1,0)     as field_320000,");
	        sqlCmd.append("			round(sum(decode(bank_type,'7',decode(a01.acc_code,'300000',amt,0))) /1,0)     as field_300000,");
	        sqlCmd.append("			round(sum(decode(bank_type,'6',decode(a01.acc_code,'310000',amt,'320000',amt,0),'7',decode(a01.acc_code,'300000',amt,0))) /1,0)     as field_NETWorth,");
	        sqlCmd.append("			round(sum(decode(bank_type,'6',decode(a01.acc_code,'220000',amt,0))) /1,0)     as field_220000_6,");
	        sqlCmd.append("			round(sum(decode(bank_type,'7',decode(a01.acc_code,'220000',amt,0))) /1,0)     as field_220000_7,");
	        sqlCmd.append("			round(sum(decode(a01.acc_code,'220000',amt,0)) /1,0) as field_DEBIT,");
	        sqlCmd.append("			round(sum(decode(bank_type,'6',decode(a01.acc_code,'120000',amt,0))) /1,0)     as field_120000_6,");
	        sqlCmd.append("			round(sum(decode(bank_type,'7',decode(a01.acc_code,'120000',amt,0))) /1,0)     as field_120000_7,");
	        sqlCmd.append("			round(sum(decode(bank_type,'6',decode(a01.acc_code,'120800',amt,0))) /1,0)     as field_120800_6,");
	        sqlCmd.append("			round(sum(decode(bank_type,'7',decode(a01.acc_code,'120800',amt,0))) /1,0)     as field_120800_7,");
	        sqlCmd.append("			round(sum(decode(bank_type,'6',decode(a01.acc_code,'150300',amt,0))) /1,0)     as field_150300_6,");
	        sqlCmd.append("			round(sum(decode(bank_type,'7',decode(a01.acc_code,'150300',amt,0))) /1,0)     as field_150300_7,");
	        sqlCmd.append("			round(sum(decode(a01.acc_code,'120000',amt,'120800',amt,'150300',amt,0)) /1,0) as  field_CREDIT,");
	        sqlCmd.append("			round(sum(decode(bank_type,'6',decode(a01.acc_code,'990000',amt,0))) /1,0)     as field_990000_6,");
	        sqlCmd.append("			round(sum(decode(bank_type,'7',decode(a01.acc_code,'990000',amt,0))) /1,0)     as field_990000_7,");
	        sqlCmd.append("			round(sum(decode(a01.acc_code,'990000',amt,0)) /1,0) as field_990000");
	        sqlCmd.append("		from   (select * from a01 ");
	        sqlCmd.append("		where a01.m_year= ? ");
	        sqlCmd.append("		and a01.m_month=? ");
	        paramList.add(locYear);
     		paramList.add(locMonth);
	        sqlCmd.append("		and acc_code in ('190000','100000','310000','320000','300000','220000','120000','120800','150300','990000'))a01");
	        sqlCmd.append("		left join  (select * from bn01 where m_year=100)bn01 on bn01.bank_no = a01.bank_code");
	        sqlCmd.append("		group by a01.m_year,a01.m_month)a01,");
	        sqlCmd.append("		( ");
	        sqlCmd.append("		select a04.m_year,a04.m_month,");
	        sqlCmd.append("			round(sum(decode(bank_type,'6',decode(a04.acc_code,'840740',amt,'840760',amt,0))) /1,0) as field_840740_6,");
	        sqlCmd.append("			round(sum(decode(bank_type,'7',decode(a04.acc_code,'840740',amt,'840760',amt,0))) /1,0) as field_840740_7,");
	        sqlCmd.append("			round(sum(decode(a04.acc_code,'840740',amt,'840760',amt,0)) /1,0) as field_840740 ");
	        sqlCmd.append("		from   (select * from a04 where a04.m_year  = ? and a04.m_month=? ");
	        paramList.add(locYear);
     		paramList.add(locMonth);
	        sqlCmd.append("			and a04.ACC_code in ('840740','840760') ) a04");
	        sqlCmd.append("			left join  (select * from bn01 where m_year=100)bn01 on bn01.bank_no = a04.bank_code");
	        sqlCmd.append("			group by a04.m_year,a04.m_month)a04,");
	        sqlCmd.append("			(select * ");
	        sqlCmd.append("			from bn01_month where m_year = ? and m_month=? )bn01_month");
	        paramList.add(locYear);
     		paramList.add(locMonth);
	        sqlCmd.append("			where a01.m_year = a04.m_year(+) and a01.m_month = a04.m_month(+)");
	        sqlCmd.append("			and a01.m_year = bn01_month.m_year(+) and a01.m_month= bn01_month.m_month(+)");
	        sqlCmd.append("			order by m_year,m_month");
	        List qList = DBManager.QueryDB_SQLParam(sqlCmd.toString(),paramList
                    ,"m_year,m_month,bank_sum_6,bank_sum_7,field_190000,field_100000,field_asset,field_asset_unit,field_310000,field_320000,field_300000,field_networth,field_networth_unit,field_220000_6,field_220000_7,field_debit,field_debit_unit,field_120000_6,field_120000_7,field_120800_6,field_120800_7,field_150300_6,field_150300_7,field_credit,field_credit_unit,field_990000_6,field_990000_7,field_990000,field_990000_unit,field_840740_6,field_840740_7,field_840740,field_840740_unit,field_990000_rate,field_840740_rate");
			
	       if(qList.size()==0){
	           alertMsg = locYear+"年"+locMonth+"月無資料";
	       }
	       
                for(int j=0;j<qList.size();j++){
                    DataObject bean = (DataObject) qList.get(j);
                    String m_year=((bean.getValue("m_year") == null)?"0":bean.getValue("m_year")).toString();
                    String m_month=((bean.getValue("m_month") == null)?"0":bean.getValue("m_month")).toString();
                    String field_990000_rate = ((bean.getValue("field_990000_rate") == null)?"0.00":bean.getValue("field_990000_rate")).toString();
                    String field_840740_rate = ((bean.getValue("field_840740_rate") == null)?"0.00":bean.getValue("field_840740_rate")).toString();
                    String field_190000=((bean.getValue("field_190000") == null)?"0":bean.getValue("field_190000")).toString();
                    String field_100000=((bean.getValue("field_100000") == null)?"0":bean.getValue("field_100000")).toString();
                    String field_asset = ((bean.getValue("field_asset") == null)?"0":bean.getValue("field_asset")).toString();
                    String field_310000=((bean.getValue("field_310000") == null)?"0":bean.getValue("field_310000")).toString();
                    String field_320000=((bean.getValue("field_320000") == null)?"0":bean.getValue("field_320000")).toString();
                    String field_300000= ((bean.getValue("field_300000") == null)?"0":bean.getValue("field_300000")).toString();
                    String field_networth = ((bean.getValue("field_networth") == null)?"0":bean.getValue("field_networth")).toString();
                    String field_220000_6=((bean.getValue("field_220000_6") == null)?"0":bean.getValue("field_220000_6")).toString();
                    String field_220000_7=((bean.getValue("field_220000_7") == null)?"0":bean.getValue("field_220000_7")).toString();
                    String field_debit= ((bean.getValue("field_debit") == null)?"0":bean.getValue("field_debit")).toString();
                    String field_120000_6=((bean.getValue("field_120000_6") == null)?"0":bean.getValue("field_120000_6")).toString();
                    String field_120000_7=((bean.getValue("field_120000_7") == null)?"0":bean.getValue("field_120000_7")).toString();
                    String field_120800_6=((bean.getValue("field_120800_6") == null)?"0":bean.getValue("field_120800_6")).toString();
                    String field_120800_7=((bean.getValue("field_120800_7") == null)?"0":bean.getValue("field_120800_7")).toString();
                    String field_150300_6=((bean.getValue("field_150300_6") == null)?"0":bean.getValue("field_150300_6")).toString();
                    String field_150300_7=((bean.getValue("field_150300_7") == null)?"0":bean.getValue("field_150300_7")).toString();
                    String field_credit = ((bean.getValue("field_credit") == null)?"0":bean.getValue("field_credit")).toString();
                    String field_990000_6=((bean.getValue("field_990000_6") == null)?"0":bean.getValue("field_990000_6")).toString();
                    String field_990000_7=((bean.getValue("field_990000_7") == null)?"0":bean.getValue("field_990000_7")).toString();
                    String field_990000=((bean.getValue("field_990000") == null)?"0":bean.getValue("field_990000")).toString();
                    String field_840740_6=((bean.getValue("field_840740_6") == null)?"0":bean.getValue("field_840740_6")).toString();
                    String field_840740_7=((bean.getValue("field_840740_7") == null)?"0":bean.getValue("field_840740_7")).toString();
                    String field_840740=((bean.getValue("field_840740") == null)?"0":bean.getValue("field_840740")).toString();
                    
                    if(qData.size()>0){
                        sqlCmd.setLength(0) ;
        			    paramList = new ArrayList () ;
        			    updateDBSqlList = new ArrayList() ;
        			    updateDBDataList = new ArrayList<List> () ;
        			    sqlCmd.append(" DELETE FROM rpt_month WHERE m_year = ? AND m_month = ? AND report_no=? ");
        			    paramList.add(Integer.parseInt(locYear));
        	     		paramList.add(Integer.parseInt(locMonth));
        	     		paramList.add(report_no);
        	     		updateDBSqlList.add(sqlCmd.toString()) ;
        			    updateDBDataList.add(paramList) ;
        			    updateDBSqlList.add(updateDBDataList) ;
        			    updateDBList.add(updateDBSqlList) ;
        			    System.out.println(locYear+"年"+locMonth+"月資料刪除並更新");
        			}else{
        			    System.out.println(locYear+"年"+locMonth+"月無資料更新");
        			}
                    
                    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
        	        sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
        	        paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("6");
             		paramList.add("field_190000");
             		paramList.add(0);
             		paramList.add(Long.parseLong(field_190000));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
        	        
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
    			    sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
        	        paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("7");
             		paramList.add("field_100000");
             		paramList.add(0);
             		paramList.add(Long.parseLong(field_100000));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
        	        
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
        	        sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
        	        paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("ALL");
             		paramList.add("field_asset");
             		paramList.add(0);
             		paramList.add(Long.parseLong(field_asset));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
        	        
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
    			    sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
        	        paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("6");
             		paramList.add("field_310000");
             		paramList.add(0);
             		paramList.add(Long.parseLong(field_310000));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
        	        
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
    			    sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
        	        paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("6");
             		paramList.add("field_320000");
             		paramList.add(0);
             		paramList.add(Long.parseLong(field_320000));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
        	        
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
    			    sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
        	        paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("7");
             		paramList.add("field_300000");
             		paramList.add(0);
             		paramList.add(Long.parseLong(field_300000));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
        	        
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
    			    sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
        	        paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("ALL");
             		paramList.add("field_networth");
             		paramList.add(0);
             		paramList.add(Long.parseLong(field_networth));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
        	        
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
    			    sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
        	        paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("6");
             		paramList.add("field_220000_6");
             		paramList.add(0);
             		paramList.add(Long.parseLong(field_220000_6));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
        	       
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
    			    sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
        	        paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("7");
             		paramList.add("field_220000_7");
             		paramList.add(0);
             		paramList.add(Long.parseLong(field_220000_7));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
        	        
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
    			    sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
        	        paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("ALL");
             		paramList.add("field_debit");
             		paramList.add(0);
             		paramList.add(Long.parseLong(field_debit));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
        	        
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
    			    sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
        	        paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("6");
             		paramList.add("field_120000_6");
             		paramList.add(0);
             		paramList.add(Long.parseLong(field_120000_6));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
        	        
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
    			    sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
        	        paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("7");
             		paramList.add("field_120000_7");
             		paramList.add(0);
             		paramList.add(Long.parseLong(field_120000_7));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
        	        
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
    			    sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
        	        paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("6");
             		paramList.add("field_120800_6");
             		paramList.add(0);
             		paramList.add(Long.parseLong(field_120800_6));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
        	        
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
    			    sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
        	        paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("7");
             		paramList.add("field_120800_7");
             		paramList.add(0);
             		paramList.add(Long.parseLong(field_120800_7));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
        	        
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
    			    sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
        	        paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("6");
             		paramList.add("field_150300_6");
             		paramList.add(0);
             		paramList.add(Long.parseLong(field_150300_6));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
        	        
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
    			    sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
        	        paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("7");
             		paramList.add("field_150300_7");
             		paramList.add(0);
             		paramList.add(Long.parseLong(field_150300_7));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
        	        
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
    			    sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
    			    paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("ALL");
             		paramList.add("field_credit");
             		paramList.add(0);
             		paramList.add(Long.parseLong(field_credit));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
        	        
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
    			    sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
        	        paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("6");
             		paramList.add("field_990000_6");
             		paramList.add(0);
             		paramList.add(Long.parseLong(field_990000_6));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
        	        
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
    			    sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
        	        paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("7");
             		paramList.add("field_990000_7");
             		paramList.add(0);
             		paramList.add(Long.parseLong(field_990000_7));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
        	        
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
    			    sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
        	        paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("ALL");
             		paramList.add("field_990000");
             		paramList.add(0);
             		paramList.add(Long.parseLong(field_990000));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
        	        
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
    			    sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
        	        paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("6");
             		paramList.add("field_840740_6");
             		paramList.add(0);
             		paramList.add(Long.parseLong(field_840740_6));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
        	        
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
    			    sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
    			    paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("7");
             		paramList.add("field_840740_7");
             		paramList.add(0);
             		paramList.add(Long.parseLong(field_840740_7));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
        	        
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
    			    sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
    			    paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("ALL");
             		paramList.add("field_840740");
             		paramList.add(0);
             		paramList.add(Long.parseLong(field_840740));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
        	        
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
    			    sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
        	        paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("ALL");
             		paramList.add("field_990000_rate");
             		paramList.add(4);
             		paramList.add(Double.parseDouble(field_990000_rate));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
    			    
    			    sqlCmd.setLength(0) ;
    			    paramList = new ArrayList () ;
    			    updateDBSqlList = new ArrayList() ;
    			    updateDBDataList = new ArrayList<List> () ;
        	        sqlCmd.append(" INSERT INTO rpt_month(m_year,m_month,report_no,bank_type,acc_code,type,amt,update_date) VALUES(?,?,?,?,?,?,?,sysdate) ");
        	        paramList.add(Integer.parseInt(m_year));
             		paramList.add(Integer.parseInt(m_month));
             		paramList.add(report_no);
             		paramList.add("ALL");
             		paramList.add("field_840740_rate");
             		paramList.add(4);
             		paramList.add(Double.parseDouble(field_840740_rate));
             		updateDBSqlList.add(sqlCmd.toString()) ;
    			    updateDBDataList.add(paramList) ;
    			    updateDBSqlList.add(updateDBDataList) ;
    			    updateDBList.add(updateDBSqlList) ;
    			    
             		if(DBManager.updateDB_ps(updateDBList)){
             		   alertMsg = locYear+"年"+locMonth+"月,農漁會信用部營運概況資料已鎖定完成 ";
         			}else{
         			   alertMsg = locYear+"年"+locMonth+"月,農漁會信用部營運概況資料已鎖定 失敗 ";
         			}
                }
                
         }
        rd = application.getRequestDispatcher( nextPgName );
    	request.setAttribute("alertMsg",alertMsg);	
     }
    
          
          
%>

<%@include file="./include/Tail.include" %>
<%!
    private final static String report_no = "FR001WD";
    private final static String nextPgName = "/pages/ActMsg.jsp";    
    private final static String QryPgName = "/pages/"+report_no+"_Qry.jsp";        
    private final static String RptCreatePgName = "/pages/"+report_no+"_Excel.jsp";        
    private final static String LoginErrorPgName = "/pages/LoginError.jsp";   
%>
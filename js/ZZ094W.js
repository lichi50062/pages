function doSubmit(form,cnd){
	if(cnd=='Qry'){		
		if(chkListVal(form)){		
			form.action="/pages/ZZ094W.jsp?act="+cnd; 
			form.submit();
		}
	}
	
}


function chkListVal(form){
	form.begDate.value='';
	form.endDate.value='';
	
	if(form.begY.value!=""){		
	    if(!mergeCheckedDate("begY;begM;begD","begDate")){			
		    form.begY.focus();
		    return false;
		}
	}
	if(form.endY.value!=""){		
		if(!mergeCheckedDate("endY;endM;endD","endDate")){
	        form.endY.focus();
	        return false;
	    }
	}
	if(form.begDate.value =='' || form.endDate.value==''){
		alert('請輸入 登入日期 !');
		return false;
    }	
	if(form.begDate.value!='' && form.endDate.value==''){
		alert('請輸入 登入日期 迄日!');
		form.endY.focus();
		return false ;
	}
	if(form.begDate.value=='' && form.endDate.value!=''){
		alert('請輸入 登入日期 起日!');
		form.begY.focus();
		return false ;
	}
	if(form.begDate.value!='' && form.endDate.value!=''){
		if(form.begDate.value > form.endDate.value){
	    	alert('登入日期  起日不得大於迄日!');
	    	form.begY.focus();
			return false ;
	    }
	}
	

	return true;
}


function setSelect(S1, bankid) {
    if(S1 == null)
    	return;
    for(i=0;i<S1.length;i++) {
        
      	if(S1.options[i].value==bankid)    	{

        	S1.options[i].selected=true;
        	break;
    	}
    }
}
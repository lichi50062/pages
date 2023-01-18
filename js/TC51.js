function doSubmit(form,cnd,bank_no,subdep_id,muser_id,expertno_id){
	    form.action="/pages/TC51.jsp?act="+cnd+"&test=nothing";
	    if(((cnd == "Insert") || (cnd == "Update") || (cnd == "Delete") || (cnd == "ResetPwd"))
	    && (!checkData(form,cnd))) return;
	    if(cnd == "new" || cnd == "Qry") form.submit();
	    if(cnd == "Edit"){
	       form.action="/pages/TC51.jsp?act="+cnd+"&BANK_NO="+bank_no+"&SUBDEP_ID="+subdep_id+"&muser_id="+muser_id+"&expertno_id="+expertno_id+"&test=nothing";
	       form.submit();
	    }
	    if((cnd == "Insert") && ask1(form, "Insert") && AskInsert(form) ) form.submit();
	    if((cnd == "Update") && ask1(form, "Update") && AskUpdate(form) ) form.submit();
	    if((cnd == "Delete") && AskDelete(form)) form.submit();
	    if((cnd == "ResetPwd") && AskResetPwd(form)) form.submit();


}

function ask1(form, cmd) {
   if(form.EXPERT_ID.length == 0) {
     if(confirm("確定不建立該員的專長資料, Y/N")) {
       return true;
     } else {
       return false;
     }
   }
   
   for(var i=0; i < form.EXPERT_ID.length; i++ ) {
     form.EXPERT_ID[i].selected = true;
   }
   
   
   
   return true;
}

function getData(form,cnd,item){
	    if(item == 'subdep_id'){
	       form.MUSER_ID.value="";
		}
	    form.action="/pages/TC51.jsp?act=getData&nowact="+cnd+"&test=nothing";
	    form.submit();
}

function checkData(form,cnd)
{
	if (trimString(form.MUSER_ID.value) =="" ){
		alert("員工代號不可為空白");
		form.MUSER_ID.focus();
		return false;
	}
   return true;
}


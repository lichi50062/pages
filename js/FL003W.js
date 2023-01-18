/**
 * 
 */
function checkDocType(docTypeVal) {
	if(docTypeVal == "B") {
		document.getElementById("auditType").disabled = false;
		document.getElementById("auditCase").disabled = false;
	} else {
		document.getElementById("auditType").disabled = true;
		document.getElementById("auditCase").disabled = true;
	}
}
function goEditPage(docType , auditType , auditId , auditCase) {
	form.docType.value = docType;
	form.auditType.value = auditType;
	form.auditId.value = auditId;
	form.auditCase.value = auditCase;
	form.action="/pages/FL003W.jsp?act=showEditPage";
	form.submit();
}
function doSubmit(form , cnd){
	var act = form.act.value;
	
	form.action="/pages/FL003W.jsp?act="+cnd;
	if(!checkData(form , cnd)) {
		return;
	}
	form.submit();
	return;
}
function checkData(form , cnd) {
	
	return true;
}
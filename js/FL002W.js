/**
 * 
 */
function doSubmit(form , cnd){
	if(cnd == "showInsert") {
		form.operation.value = "insert"
	}
	
	if(!checkData(form , cnd)) {
		return;
	}
	form.action="/pages/FL002W.jsp?act=" + cnd;
	form.submit();
	return;
}
function checkData(form , cnd) {
	
	return true;
}
function goEditPage(defKind , defType , defCase , caseName) {
	var defKindRadios = document.getElementsByName("defKind");
	for(var i = 0 ; i < defKindRadios.length ; i++ ) {
		var defKindRadio = defKindRadios[i];
		if(defKindRadio.value == defKind) {
			defKindRadio.checked = true;
		}
	}
	form.defType.value = defType;
	form.defCase.value = defCase;
	form.caseName.value = caseName;
	
	form.action="/pages/FL002W.jsp?act=goEditPage";
	form.submit();
}
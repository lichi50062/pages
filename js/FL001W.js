/**
 * 
 */
function initEditPage() {
	var actVal = form.act.value;
	if(actVal == "goInsertPage") {
		document.getElementById("loanItem").style.display = "none";
		form.loanItem.value = form.loanItemTemp.value;
		form.loanItemName.value = form.loanItemNameTemp.value;
		document.getElementById("loanItemNameDiv").innerHTML = form.loanItemNameTemp.value;
		document.getElementById("updateLink").style.display = "none";
		document.getElementById("delLink").style.display = "none";
	} else if(actVal == "goInsertRagePage") {
		document.getElementById("loanItem").style.display = "none";
		document.getElementById("subitem").style.display = "none";
		document.getElementById("subitemName").style.display = "none";
		form.loanItem.value = form.loanItemTemp.value;
		form.loanItemName.value = form.loanItemNameTemp.value;
		document.getElementById("loanItemNameDiv").innerHTML = form.loanItemNameTemp.value;
		form.subitem.value = form.subitemTemp.value;
		form.subitemName.value = form.subitemNameTemp.value;
		document.getElementById("subitemNameDiv").innerHTML = form.subitemNameTemp.value;
		document.getElementById("updateLink").style.display = "none";
		document.getElementById("delLink").style.display = "none";
	} else {
//		document.getElementById('begYear').disabled = true;
//		document.getElementById('begMonth').disabled = true;
//		document.getElementById('begDay').disabled = true;
		form.loanItemName.value = form.loanItemNameTemp.value;
		document.getElementById("confirmLink").style.display = "none";
		document.getElementById("loanItem").style.display = "none";
		document.getElementById("subitem").style.display = "none";
		document.getElementById("subitemName").style.display = "none";
	}
	
	var startDateVal = form.startDate.value;
	form.begYear.value = startDateVal.substring(0,3);
	form.begMonth.value = startDateVal.substring(3,5);
	form.begDay.value = startDateVal.substring(5,7);
}

function doSubmit(form , cnd){
	var act = form.act.value;
	if(act == "goInsertPage") {
		form.operation.value = "goInsertPage";
	} else if(act == "goInsertRagePage") {
		form.operation.value = "goInsertRagePage";
	}
	
	form.action="/pages/FL001W.jsp?act="+cnd;
	if(!checkData(form , cnd)) {
		return;
	}
	form.submit();
	return;
}
function checkData(form , cnd) {
	if(cnd == "insert" || cnd == "update" || cnd == "delete") {
		if(form.begYear.value == "" || form.begMonth.value == "" || form.begDay.value == "") {
			alert("請輸入實施日期");
			return false;
		}
		var loanRateVal = form.loanRate.value;
		if(!checkRate(loanRateVal)) {
			alert("貸款利率格式錯誤");
			return false;
		}
		var baseRateVal = form.baseRate.value;
		if(!checkRate(baseRateVal)) {
			alert("補貼基準格式錯誤");
			return false;
		}
		var agbaseRateVal = form.agbaseRate.value;
		if(!checkRate(agbaseRateVal)) {
			alert("農業金庫基準利率加一成利率格式錯誤");
			return false;
		}
		
		var begYearVal = parseInt(form.begYear.value,10) + 1911;
		var begMonthSel = form.begMonth;
		var begMonthVal = begMonthSel.options[begMonthSel.selectedIndex].text;
		var begDaySel = form.begDay;
		var begDayVal = begDaySel.options[begDaySel.selectedIndex].text;
		
		form.startDate.value = begYearVal + begMonthVal + begDayVal;
		
		var startDateHidden = form.startDateHidden.value;
		var hideYearVal = parseInt(startDateHidden.substring(0,3),10) + 1911;
		
		form.startDateHidden.value = hideYearVal + startDateHidden.substring(3,7);
	}
	
	
	return true;
}
function goSubListPage(loanItem , loanItemName) {
	form.loanItem.value = loanItem;
	form.loanItemName.value = loanItemName;
	form.action="/pages/FL001W.jsp?act=SubList";
	form.submit();
}
function goInsertPage() {
	form.action="/pages/FL001W.jsp?act=goInsertPage";
	form.submit();
}
function goInsertRagePage(subitem , subitemName) {
	form.subitem.value = subitem;
	form.subitemName.value = subitemName;
	form.action="/pages/FL001W.jsp?act=goInsertRagePage";
	form.submit();
}
function showDetailList(loanItem , subitem) {
	var details = document.getElementsByName("detail_" + subitem);
	for(var i = 0 ; i < details.length ; i++ ) {
		var detail = details[i];
		if(detail.style.display == "") {
			detail.style.display = "none";
		} else {
			detail.style.display = "";
		}
	}
	
//	form.loanItem.value = loanItem;
//	form.subitem.value = subitem;
//	form.action="/pages/FL001W.jsp?act=showDetailList";
//	form.submit();
}
function showEditPage(loanItem , subitem , startDate) {
	form.loanItem.value = loanItem;
	form.subitem.value = subitem;
	form.startDate.value= chtDateToWestDate(startDate);
	form.action="/pages/FL001W.jsp?act=showEditPage";
	form.submit();
}
function chtDateToWestDate(chtDate) {
	var westYear = parseInt(chtDate.split("/")[0],10) + 1911;
	return chtDate.replace(chtDate.split("/")[0] , westYear);
}
function checkRate(rate) {
	var re = /^[0-9](\.[0-9]{1,4})?$/;
	if(!re.test(rate)) {
		return false
	}
	return true;
}
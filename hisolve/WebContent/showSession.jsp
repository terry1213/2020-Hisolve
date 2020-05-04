<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import="user.SessionDAO" %>
<%@ page import="user.ResultDAO" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hisolve</title>

<link rel="icon" href="favicon.ico">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.14.3/xlsx.full.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.3.8/FileSaver.min.js"></script>
<script defer src="https://use.fontawesome.com/releases/v5.0.8/js/solid.js" integrity="sha384-+Ga2s7YBbhOD6nie0DzrZpJes+b2K1xkpKxTFFcx59QmVPaSA8c7pycsNaFwUK6l" crossorigin="anonymous"></script>
<script defer src="https://use.fontawesome.com/releases/v5.0.8/js/fontawesome.js" integrity="sha384-7ox8Q2yzO/uWircfojVuCQOZl+ZZBg2D2J5nkpLqzH1HY0C1dHlTKIbpRz/LG23c" crossorigin="anonymous"></script>

</head>

<script>
function s2ab(s) { 
    var buf = new ArrayBuffer(s.length); //convert s to arrayBuffer
    var view = new Uint8Array(buf);  //create uint8array as viewer
    for (var i=0; i<s.length; i++) view[i] = s.charCodeAt(i) & 0xFF; //convert to octet
    return buf;    
}
function exportExcel(){ 
    var wb = XLSX.utils.book_new();

    var newWorksheet = excelHandler.getWorksheet();
    
    XLSX.utils.book_append_sheet(wb, newWorksheet, excelHandler.getSheetName());

    var wbout = XLSX.write(wb, {bookType:'xlsx',  type: 'binary'});

    saveAs(new Blob([s2ab(wbout)],{type:"application/octet-stream"}), excelHandler.getExcelFileName());
}
</script>

<script>
var excelHandler = {
        getExcelFileName : function(){
            return '결과표.xlsx';
        },
        getSheetName : function(){
            return '참여학생 결과표';
        },
        getExcelData : function(){
            return document.getElementById('tableData'); 
        },
        getWorksheet : function(){
            return XLSX.utils.table_to_sheet(this.getExcelData());
        }
}
</script>

<body>

	<script>
		if(sessionStorage.getItem("allowed")!="professorPage.jsp" && sessionStorage.getItem("allowed")!="deleteProblem.jsp" && sessionStorage.getItem("allowed")!="addProblem.jsp" && sessionStorage.getItem("allowed")!="showProblem.jsp" && sessionStorage.getItem("allowed")!="seeResult.jsp" && sessionStorage.getItem("allowed")!="showSession.jsp" && sessionStorage.getItem("allowed")!="reviseTime.jsp" && sessionStorage.getItem("allowed")!="similarityMeasure.jsp"){
			alert("잘못된 접근입니다.");
			history.back();
		}
		else{
			sessionStorage.setItem("allowed", "showSession.jsp");
		}
	</script>

	<script>
	function showProblemInfo(problemID){
		$.ajax({
			url : "upload/problem/" + problemID + "/problemContent.txt",
	       	dataType: "text",
	       	success : function (data) {
	       		document.getElementById('problemInfo' + problemID).innerHTML = data;
	       	}
	   	}); 
	}
	</script>
	
	<div id="nav" name="nav">
	</div>
	
	<% 
		String userID = request.getParameter("userID");
		String sessionName = request.getParameter("sessionName");
		String openTime = request.getParameter("openTime");
		String closeTime = request.getParameter("closeTime");
		String sessionID = request.getParameter("sessionID");
		
		SessionDAO sessionDAO = new SessionDAO();
		ResultDAO resultDAO = new ResultDAO();
		
		int result = sessionDAO.howmany2(userID,sessionName);
		int result2 = sessionDAO.howmany4(userID,sessionName);
		int temp[] = new int[result];
		String[] temp2 = new String[result2];
		String[][] show = new String[result][4];
		
		temp = sessionDAO.keyinfo2(userID,sessionName,result);
		temp2 = sessionDAO.seeStudent(userID,sessionName,result2);
		
		for(int i=0;i<result;i++){
			show[i] = sessionDAO.seeproblem(temp[i]);
		}
	%>
	
	<div class="card" style="width:70%;margin-left:2%; margin-bottom:2%; margin-top:2%;">
		
	<div class="jumbotron">
  		<h1><%=sessionName %></h1>
  		<h3>ID : <%=sessionID %></h3>
  		<h3>기간 : <%= openTime %> ~ <%= closeTime %></h3>
  		<div class="card" style="margin-bottom:10px;">
  			<div class="card-header">결과표</div>
  			<div class="card-body">
  			<table class="table table-bordered" id="tableData">
  				<thread>
  					<tr>
  						<th scope="col">#</th>
  						<th scope="col">참여자</th>
  						<% 
  							for(int i=0;i<result;i++){
  								
  						%>
      						<th scope="col"><%=i+1 %>번 (<%= show[i][2] %>)</th>
      						<th><%=i+1 %>번 채점 횟수</th>
      					<%
  							}
  	      					%>
  	      					<th scope="col">최종 결과</th>
  	  					</tr>
  				</thread>
  				<tbody>
  				<% 
  					String[] fin = new String[result];
  					for(int i=0;i<result2;i++){
  						int correct=0;
  				%>
  					<tr>
  						<th scope="row"><%=i+1%></th>
  						<td><%=temp2[i]%></td>
  						<% 
  						for(int j=0;j<result;j++){
  							int count = resultDAO.howmany(temp2[i], sessionID, show[j][0]);
  							int choose = sessionDAO.checkResult(temp2[i],sessionID,show[j][0], "correct");
  							if(choose == 1){
  								fin[j] = "정답";
  								correct++;
  							}
  							else{
  								fin[j] = "진행중";
  							}
  						%>
     					<td style="cursor:pointer" onclick="seeResult(<%=show[j][0]%>, '<%=temp2[i]%>');"><%=fin[j]%>
     					<%
  						int newComment = resultDAO.countComment5(sessionID, show[j][0], temp2[i], "new");
     					if(newComment > 0){
     						%>
     						<span class="badge badge-pill badge-success"><%=newComment%></span>
     						<%
     					}%>
     					</td>
     					<td><%=count%>번</td>
     					<% 
  						}
     					%>
     					<td><%=correct%> / <%=result%></td>
  					</tr>
  				<% 
					}
				%>
  				</tbody>
  			</table>
  			</div>
  		</div>
  		<button id="similarityMeasure" type="button" class="btn btn-primary" onclick="javascript: similarityMeasure()">유사성 검사</button>
  		<button id="reviseTime" type="button" class="btn btn-primary">시간 변경하기</button>
  		<button type="button" class="btn btn-primary" onclick="javascript: exportExcel()"> 엑셀 다운로드 </button>
  		<button type="button" class="btn btn-primary"  onclick="javascript: tossback()"> 돌아가기 </button>
	</div>

	<div class="card">
		<div class="card-header"><h3>문제 리스트</h3></div>
		<div class="card-body">
			<lu id="problemList" class="list-group">
		<% 
			for(int i=0;i<result;i++){
				
		%>
			<li class="list-group-item" style="border: 1px solid lightgray; margin-bottom:10px; background-color:lightgray;">
				<i class="fas fa-times fa-2x" style="float:right; margin-top:20px; cursor:pointer;" onclick="deleteProblem('<%=show[i][0]%>');"></i>
    			<h4 class="list-group-item-heading"> <%= show[i][2] %> / <%= show[i][3] %>sec</h4>
    			<p id="problemInfo<%=show[i][0]%>" class="list-group-item-text" style="font-size : 20px;"><script type="text/javascript">showProblemInfo(<%=show[i][0]%>);</script></p>
    		</li>
		<% 
			}
		%>
			</lu>
		</div>
		
		<center>
			<i class="fas fa-plus-square fa-3x" style="margin-bottom:10px; cursor:pointer;" onclick="addProblem();"></i>
		</center>
	</div>
		
	</div>
		
	<script>
	$('#nav').load("nav.jsp?userName=" + sessionStorage.getItem("userName"));
	
	function downloadExcel(id, title) {
		var tab_text = '<html xmlns:x="urn:schemas-microsoft-com:office:excel">';
		tab_text = tab_text + '<head><meta http-equiv="content-type" content="application/vnd.ms-excel; charset=UTF-8">';
		tab_text = tab_text + '<xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet>'
		tab_text = tab_text + '<x:Name>Test Sheet</x:Name>';
		tab_text = tab_text + '<x:WorksheetOptions><x:Panes></x:Panes></x:WorksheetOptions></x:ExcelWorksheet>';
		tab_text = tab_text + '</x:ExcelWorksheets></x:ExcelWorkbook></xml></head><body>';
		tab_text = tab_text + "<table border='1px'>";
		var exportTable = $('#' + id).clone();
		exportTable.find('input').each(function (index, elem) { $(elem).remove(); });
		tab_text = tab_text + exportTable.html();
		tab_text = tab_text + '</table></body></html>';
		var data_type = 'data:application/vnd.ms-excel';
		var ua = window.navigator.userAgent;
		var msie = ua.indexOf("MSIE ");
		var fileName = title + '.xls';
		//Explorer 환경에서 다운로드
		if (msie > 0 || !!navigator.userAgent.match(/Trident.*rv\:11\./)) {
		if (window.navigator.msSaveBlob) {
		var blob = new Blob([tab_text], {
		type: "application/csv;charset=utf-8;"
		});
		navigator.msSaveBlob(blob, fileName);
		}
		} else {
		var blob2 = new Blob([tab_text], {
		type: "application/csv;charset=utf-8;"
		});
		var filename = fileName;
		var elem = window.document.createElement('a');
		elem.href = window.URL.createObjectURL(blob2);
		elem.download = filename;
		document.body.appendChild(elem);
		elem.click();
		document.body.removeChild(elem);
		}
	}
	
	function submitForm(){

		var f = document.form1;
		f.action="download.jsp";
		
		var m = document.createElement("input");
		m.setAttribute("type","hidden");
		m.setAttribute("name","userID");
		m.setAttribute("value",sessionStorage.getItem("userID"));
		f.appendChild(m);
		
		var i = document.createElement("input");
		i.setAttribute("type","hidden");
		i.setAttribute("name","sessionName");
		i.setAttribute("value","<%=sessionName%>");
		f.appendChild(i);
		
		var n = document.createElement("input");
		n.setAttribute("type","hidden");
		n.setAttribute("name","sessionID");
		n.setAttribute("value","<%=sessionID%>");
		f.appendChild(n);
		
		f.submit();

	}
		
		function tossback(){
			var f = document.createElement("form");
			f.setAttribute("method","post");
			f.setAttribute("action","professorPage.jsp");
			document.body.appendChild(f);
		
			var i = document.createElement("input");
			i.setAttribute("type","hidden");
			i.setAttribute("name","userID");
			i.setAttribute("value",sessionStorage.getItem("userID"));
			f.appendChild(i);
			
			var j = document.createElement("input");
			j.setAttribute("type","hidden");
			j.setAttribute("name","userName");
			j.setAttribute("value",sessionStorage.getItem("userName"));
			f.appendChild(j);
		
			f.submit();
		}
		
		
		function deleteProblem(problemID){
			var input = confirm("해당 세션에서 문제를 삭제하시겠습니까?");
			if(input==true){
				sendinfo2(problemID);
			}
		}
		
		function sendinfo2(problemID){
			$.ajax({
		    	url:'deleteProblem.jsp',
		    	dataType:'text',
		    	type:'POST',
		    	data:{'problemID':problemID, 'sessionName':'<%=sessionName%>', 'userID': sessionStorage.getItem("userID")},
		    	success : function(data){
		    		location.reload();
		        },
		    	error : function(request,status,error){
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		    	}
			});
		}
		
		function addProblem(){
			var f = document.createElement("form");
			f.setAttribute("method","post");
			f.setAttribute("action","addProblem.jsp");
			document.body.appendChild(f);
		
			var i = document.createElement("input");
			i.setAttribute("type","hidden");
			i.setAttribute("name","sessionName");
			i.setAttribute("value","<%=sessionName%>");
			f.appendChild(i);
			
			var k = document.createElement("input");
			k.setAttribute("type","hidden");
			k.setAttribute("name","openTime");
			k.setAttribute("value","<%=openTime%>");
			f.appendChild(k);
			
			var l = document.createElement("input");
			l.setAttribute("type","hidden");
			l.setAttribute("name","closeTime");
			l.setAttribute("value","<%=closeTime%>");
			f.appendChild(l);
			
			var m = document.createElement("input");
			m.setAttribute("type","hidden");
			m.setAttribute("name","userID");
			m.setAttribute("value",sessionStorage.getItem("userID"));
			f.appendChild(m);
			
			var n = document.createElement("input");
			n.setAttribute("type","hidden");
			n.setAttribute("name","sessionID");
			n.setAttribute("value","<%=sessionID%>");
			f.appendChild(n);
			
			f.submit();
		}
		
		function seeResult(problemID, studentID){
			var f = document.createElement("form");
			f.setAttribute("method","post");
			f.setAttribute("action","seeResult.jsp");
			document.body.appendChild(f);
		
			var i = document.createElement("input");
			i.setAttribute("type","hidden");
			i.setAttribute("name","problemID");
			i.setAttribute("value",problemID);
			f.appendChild(i);
			
			var l = document.createElement("input");
			l.setAttribute("type","hidden");
			l.setAttribute("name","sessionID");
			l.setAttribute("value","<%=sessionID%>");
			f.appendChild(l);
			
			var m = document.createElement("input");
			m.setAttribute("type","hidden");
			m.setAttribute("name","userID");
			m.setAttribute("value",sessionStorage.getItem("userID"));
			f.appendChild(m);
			
			var n = document.createElement("input");
			n.setAttribute("type","hidden");
			n.setAttribute("name","testID");
			n.setAttribute("value",studentID);
			f.appendChild(n);
			
			f.submit();
		}

		$("#reviseTime").click(function(){
			var f = document.createElement("form");
			f.setAttribute("method","post");
			f.setAttribute("action","reviseTime.jsp");
			document.body.appendChild(f);
			
			var i = document.createElement("input");
			i.setAttribute("type","hidden");
			i.setAttribute("name","sessionName");
			i.setAttribute("value","<%=sessionName%>");
			f.appendChild(i);
			
			var l = document.createElement("input");
			l.setAttribute("type","hidden");
			l.setAttribute("name","sessionID");
			l.setAttribute("value","<%=sessionID%>");
			f.appendChild(l);
			
			var m = document.createElement("input");
			m.setAttribute("type","hidden");
			m.setAttribute("name","userID");
			m.setAttribute("value",sessionStorage.getItem("userID"));
			f.appendChild(m);
			
			f.submit();
		});
		
		function similarityMeasure(){
			var f = document.createElement("form");
			f.setAttribute("method","post");
			f.setAttribute("action","similarityMeasure.jsp");
			document.body.appendChild(f);
			
			var i = document.createElement("input");
			i.setAttribute("type","hidden");
			i.setAttribute("name","sessionName");
			i.setAttribute("value","<%=sessionName%>");
			f.appendChild(i);
			
			var l = document.createElement("input");
			l.setAttribute("type","hidden");
			l.setAttribute("name","sessionID");
			l.setAttribute("value","<%=sessionID%>");
			f.appendChild(l);
			
			var m = document.createElement("input");
			m.setAttribute("type","hidden");
			m.setAttribute("name","userID");
			m.setAttribute("value",sessionStorage.getItem("userID"));
			f.appendChild(m);
			
			f.submit();
		}
	</script>

</body>
</html>
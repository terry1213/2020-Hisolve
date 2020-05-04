<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.io.File"%>
<%@page import= "java.io.FilenameFilter"%>
<%@ page import="user.ProblemDAO" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%
   String uploadPath = request.getParameter("uploadPath");
   String problemName = request.getParameter("problemName");
   String timeLimit = request.getParameter("timeLimit");
   String problemContent = request.getParameter("problemContent");
   String inputNum = request.getParameter("inputNum");
   String userID = request.getParameter("userID");
   String type = request.getParameter("type");
   
   ProblemDAO problemDAO = new ProblemDAO();
   int problemNum = problemDAO.howmany(userID);
       
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hisolve</title>

<link rel="icon" href="favicon.ico">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
</head>
<body>
	<script>
		if(sessionStorage.getItem("allowed")!="addTestCase.jsp" && sessionStorage.getItem("allowed")!="reviseTestCase.jsp"){
			alert("잘못된 접근입니다.");
			history.back();
		}
		else{
			sessionStorage.setItem("allowed", "addSampleProgram.jsp");
		}
	</script>
	
	<div id="nav" name="nav">
    </div>
	
<div class="container">
	<div class="row">
		<div class="col-md-8">
			<div class="page-header">
				<h5>샘플 프로그램 등록하기</h5>
			</div>
			<form id="postData">
				<div class="row">
	
					<div class="input-group mb-3 col-md-6">
						<div class="input-group-prepend">
    						<label class="input-group-text" for="problemName">문제 이름:</label>
  						</div>
						<input name="problemName" id="problemName" type="text" class="form-control" value="<%=problemName%>" readonly required>
					</div>
					
					<div class="input-group mb-3 col-md-6">
						<div class="input-group-prepend">
    						<label class="input-group-text" for="timeLimit">제한 시간(초):</label>
  						</div>
						<input name="timeLimit" id="timeLimit" type="number" class="form-control" value="<%=timeLimit%>" readonly required>
					</div>
				</div>
			
				<div class="input-group mb-3">
					<div class="input-group-prepend">
    					<label class="input-group-text" for="problemContent">문제 유형:</label>
    					<input name="type" id="type" class="form-control" value="<%=type%>" readonly required>
  					</div>
				</div>
				
				<div class="input-group mb-3">
					<div class="input-group-prepend">
    					<label class="input-group-text" for="problemContent">문제 설명:</label>
  					</div>
					<textarea name="problemContent" id="problemContent" style="resize: none;" class="form-control" readonly required><%=problemContent%></textarea>
				</div>
				
				<input name="userID" id="userID" type="hidden">
				<input name="inputNum" id="inputNum" type="hidden" value="<%=inputNum%>">
				<textarea name="result" id="result" style="display:none" readonly required></textarea>
				<input name="uploadPath" id="uploadPath" type="hidden" required value="<%=uploadPath%>">
				<input name="problemNum" id="problemNum" type="hidden" value="<%=problemNum%>">
			</form>
			
			<form method="post" enctype="multipart/form-data" id="fileData">
				<div class="form-group">
                    <label for="sampleProgram"><strong><%=inputNum%>개의 테스트 케이스에 대한 샘플 프로그램을 올려주세요.</strong></label>
                    <input type="file" name="sampleProgram" id="sampleProgram" accept=".c" class="form-control" required>
                 </div>
              </form>
			
			<div class="form-group">
					<button id="test" class="btn btn-info btn-sm">테스트</button>
			</div>
		</div>
	</div>
</div>

<script>
$('#nav').load("nav.jsp?userName=" + sessionStorage.getItem("userName"));

var content = "";
$("#test").click(function(){
	
	var codefile = document.getElementById("sampleProgram").files[0];
	if (codefile) {
    	var reader = new FileReader();
    	reader.readAsText(codefile, "UTF-8");
    	reader.onload = function (evt) {
    		content = evt.target.result;
    			$.ajax({
        	    	url:'save.jsp',
        	    	dataType:'text',
        	    	type:'POST',
        	    	data:{'data':content, 'fileName':'sampleProgram.c', 'uploadPath':'<%=uploadPath%>/'},
        	    	success : function(){
        	    		get_result();
        	        },
        	    	error : function(request,status,error){
        				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        	    	}
        		});
    	}
    	reader.onerror = function (evt) {
    		alert("파일을 읽는데 에러가 발생했습니다.");
    	}
	}
	
});

function get_result(){
	
		$.ajax({
	    	url:'resultPage.jsp',
	    	dataType:'text',
	    	type:'POST',
	    	data:{'uploadPath':'<%=uploadPath%>', 'txtPath':'<%=uploadPath%>', 'fileName':'sampleProgram.c', 'userID': sessionStorage.getItem("userID"), 'timeLimit': '<%=timeLimit%>', 'problemName': '<%=problemName%>', 'problemContent': '<%=problemContent%>', 'type': '<%=type%>', 'testing':'NO'},
	    	success : function(data){
	            $('#result').val(data);
	            $("#result").load(document.URL + " #result");
	            $('#userID').val(sessionStorage.getItem("userID"));
	     		document.getElementById('postData').method = "post";
	    		document.getElementById('postData').action = "testSampleProgram.jsp"
	    		document.getElementById('postData').submit();
	        },
	    	error : function(request,status,error){
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	    	}
		});
}

</script>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.io.File"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import="user.ResultDAO" %>
<%@ page import="user.ProblemDAO" %>
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
		if(sessionStorage.getItem("allowed")!="addSampleProgram.jsp"){
			alert("잘못된 접근입니다.");
			history.back();
		}
		else{
			sessionStorage.setItem("allowed", "testSampleProgram.jsp");
		}
	</script>

	<div id="nav" name="nav">
	</div>

<%
	String uploadPath = request.getParameter("uploadPath");
	String problemName = request.getParameter("problemName");
	String timeLimit = request.getParameter("timeLimit");
	String problemContent = request.getParameter("problemContent");
	String inputNum = request.getParameter("inputNum");
	String userID = request.getParameter("userID");
	String result = request.getParameter("result");
	String problemNum = request.getParameter("problemNum");
	String type = request.getParameter("type");
	
	ProblemDAO problemDAO = new ProblemDAO();
	
%>

<div class="container">
	<div class="row">
		<div class="col-md-8">
			<div class="page-header">
				<h5>샘플 프로그램의 테스트</h5>
			</div>
			<form id="postData">
			
				<input name="problemName" id="problemName" type="hidden" value="<%=problemName%>" readonly required>
		
				<input name="timeLimit" id="timeLimit" type="hidden" value="<%=timeLimit%>">
				
				<input name="type" id="type" type="hidden" value="<%=type%>">

				<textarea name="problemContent" id="problemContent" style="display: none;" readonly required><%=problemContent%></textarea>
		
				<input name="inputNum" id="inputNum" type="hidden" value="<%=inputNum%>">
		
				<input name="uploadPath" id="uploadPath" type="hidden" required value="<%=uploadPath%>">
				
				<div class="input-group mb-3">
					<div class="input-group-prepend">
    					<label class="input-group-text" for="result">테스트 결과:</label>
  					</div>
					<textarea name="result" id="result" style="resize: none; height: 700px;" class="form-control" readonly><%=result%></textarea>
				</div>
				
			</form>
			<div class="form-group">
					<label id="submitLabel" for="revise" style="display: none;"><strong>테스트가 통과되어 문제가 등록되었습니다.</strong></label>
					<button id="submit" style="display: none;" class="btn btn-primary" onclick="submit()">완료</button>
					<label id="reviseLabel" for="submit" style="display: none;"><strong>테스트 결과에 문제가 있습니다. input&output이나 샘플 프로그램을 수정해주세요.</strong></label>
					<button id="revise" style="display: none;" class="btn btn-primary" onclick="revise()">수정하기</button>
			</div>
		</div>
	</div>
</div>


<%
	int check1 = problemDAO.howmany(userID);
	
	if(check1 == Integer.parseInt(problemNum) + 1){
			%>
			<script>
			document.getElementById("submit").style.display = "block";
			document.getElementById("submitLabel").style.display = "block";
			</script>
			<%
	}else{
		%>
		<script>
		/* alert("input&output 혹은 sample program을 수정해주세요."); */
		document.getElementById("revise").style.display = "block";
		document.getElementById("reviseLabel").style.display = "block";
		</script>
		<%
	}
%>
<script>
	$('#nav').load("nav.jsp?userName=" + sessionStorage.getItem("userName"));

	function submit(){
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
	
	function revise(){
		var x = document.getElementById("inputNum").value;
/* 		for(var i = 1; i <= x; i++){
			textDelete(i);
		} */
		
 		document.getElementById('postData').method = "post";
		document.getElementById('postData').action = "reviseTestCase.jsp"
		document.getElementById('postData').submit();
		
		function textDelete(l){
		 	$.ajax({
		    	url:'delete.jsp',
		    	dataType:'text',
		    	type:'POST',
		    	data:{'fileName':'input' + (l-1) + '.txt', 'deletePath':'<%=uploadPath%>/input'},
		    	success : function(){
		    		
		        },
		    	error : function(request,status,error){
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		    	}
			});
			
			$.ajax({
		    	url:'delete.jsp',
		    	dataType:'text',
		    	type:'POST',
		    	data:{'fileName':'output' + (l-1) + '.txt', 'deletePath':'<%=uploadPath%>/output'},
		    	success : function(){
		    		
		        },
		    	error : function(request,status,error){
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		    	}
			});
		}
	}
</script>

</body>
</html>
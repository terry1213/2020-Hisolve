<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.io.File"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%
	String uploadPath = request.getSession().getServletContext().getRealPath("/upload") + '/' + request.getParameter("userID") + "/problem/test";

	class Directory{
		public Directory(){}
		public boolean deleteAll(File dir) {
			if (!dir.exists()) {
				return true;
			}
			boolean res = true;
			if (dir.isDirectory()) {
				File[] files = dir.listFiles();
				for (int i = 0; i < files.length; i++) {
				res &= deleteAll(files[i]);
				}
			}
			else {
				res = dir.delete();
			}
			dir.delete();
			return res;
		}
	}
	
	Directory d = new Directory();

	File f = new File(uploadPath);
	if(f.exists()){
		d.deleteAll(f);
	}
	f.mkdirs();
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
		if(sessionStorage.getItem("allowed")!="professorPage.jsp" && sessionStorage.getItem("allowed")!="addTestCase.jsp"){
			alert("잘못된 접근입니다.");
			history.back();
		}
		else{
			sessionStorage.setItem("allowed", "createProblem.jsp");
		}
	</script>

	<div id="nav" name="nav">
	</div>

<div class="container">
	<div class="row">
		<div class="col-md-8">
			<div class="page-header">
				<h5>문제 등록하기</h5>
			</div>
			<form id="postData">
				
				<div class="row">
					<div class="input-group mb-3 col-md-6">
						<div class="input-group-prepend">
    						<label class="input-group-text" for="problemName">문제 이름:</label>
  						</div>
						<input name="problemName" id="problemName" type="text" placeholder="문제 이름을 적어주세요." class="form-control" required>
					</div>
				
					<div class="input-group mb-3 col-md-6">
						<div class="input-group-prepend">
    						<label class="input-group-text" for="timeLimit">시간 제한(초):</label>
  						</div>
						<input name="timeLimit" id="timeLimit" type="number" placeholder="최소 1초 최대 300초"  min="1" max="300" class="form-control" required>
					</div>
				</div>
				
				<div class="input-group mb-3">
					<div class="input-group-prepend">
    					<label class="input-group-text" for="problemContent">문제 유형:</label>
  					</div>
					<input type="radio" id="single" name="type" value="single" required> 
					<label for ="single">파일 하나</label>
					<input type="radio" id="multi" name="type" value="multi"> 
					<label for ="multi">파일 여러개</label>
				</div>
				
				<div class="input-group mb-3">
					<div class="input-group-prepend">
    					<label class="input-group-text" for="problemContent">문제 설명:</label>
  					</div>
					<textarea name="problemContent" id="problemContent" style="resize: none; height: 200px;" placeholder="문제에 대한 설명을 적어주세요." class="form-control" required></textarea>
				</div>
				
				<input name="uploadPath" id="uploadPath" type="hidden" required value="<%=uploadPath%>">

			<div class="form-group">
					<button id="submit" class="btn btn-primary">등록</button>
					<button onclick="history.back();" class="btn btn-primary">취소</button>
			</div>
			
			</form>
		</div>
	</div>
</div>

<script>
	$('#nav').load("nav.jsp?userName=" + sessionStorage.getItem("userName"));
	
	$("#submit").click(function(){
		$.ajax({
	    	url:'save.jsp',
	    	dataType:'text',
	    	type:'POST',
	    	data:{'data':document.getElementById('problemContent').value, 'fileName':'problemContent.txt', 'uploadPath':'<%=uploadPath%>'},
	    	success : function(){
	    		
	        },
	    	error : function(request,status,error){
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	    	}
		});
		document.getElementById('postData').method = "post";
		document.getElementById('postData').action = "addTestCase.jsp"
		document.getElementById('postData').submit();
	
	});
	

	
</script>
</body>
</html>
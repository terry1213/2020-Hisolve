<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@page import="java.io.*"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Hisolve</title>

<link rel="icon" href="favicon.ico">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
</head>
<body>

	<script>
		if(sessionStorage.getItem("allowed")!="applySession.jsp" && sessionStorage.getItem("allowed")!="upload.jsp"){
			alert("잘못된 접근입니다.");
			history.back();
		}
		else{
			sessionStorage.setItem("allowed", "sendingPage.jsp");
		}
	</script>

	<%
	String problemID = request.getParameter("problemID");
	String state = request.getParameter("state");
	String problemName = request.getParameter("problemName");
	String timeLimit = request.getParameter("timeLimit");
	String sessionID = request.getParameter("sessionID");
	String userID = request.getParameter("userID");
	String uploadPath = request.getSession().getServletContext().getRealPath("/upload") + '/' + userID + '/' + sessionID + '/' + problemID;
	
	File f = new File(uploadPath);
	if(!f.exists()){
		f.mkdirs();
	}
	%>

	<div id="nav" name="nav">
	</div>

	<div class="container">
		<div class="row">
			<div class="col-md-8">
				<div class="page-header">
					<h5>문제 풀기</h5>
					<h6>

					</h6>
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
    							<label class="input-group-text" for="timeLimit">시간 제한(초):</label>
  							</div>
							<input name="timeLimit" id="timeLimit" type="number" class="form-control" value="<%=timeLimit%>" readonly required>
						</div>
					
				</div>
			
				<div class="input-group mb-3">
					<div class="input-group-prepend">
    					<label class="input-group-text" for="problemContent">문제 설명:</label>
  					</div>
					<textarea name="problemContent" id="problemContent" style="resize: none;" class="form-control" readonly required></textarea>
				</div>
				
				</form>
				
				
				<form method="post" enctype="multipart/form-data" id="fileData">
					<div class="form-group">
						<label for="sampleProgram"><strong>프로그램을 올려주세요.</strong></label>
						<input type="file" name="fileName" id="fileName" accept=".c" class="form-control" required>
					</div>
				</form>
				<button id="dataUpload" class="btn btn-primary">업로드</button>
				<button onclick="history.back();" class="btn btn-primary">돌아가기</button>
			</div>
		</div>
	</div>
	
	<script>
	
	$('#nav').load("nav.jsp?userName=" + sessionStorage.getItem("userName"));
	
	function textLoad(){
		$.ajax({
			url : "upload/problem/<%=problemID%>/problemContent.txt",
	       	dataType: "text",
	       	success : function (data) {
	            $('#problemContent').val(data);
	            //$('#problemContent').load(document.URL + ' #problemContent');
	       	}
	   	}); 
	}
	textLoad();
	
	$("#dataUpload").click(function(){
		if(document.getElementById("fileName").files.length == 0){
			alert("업로드할 프로그램을 선택해주세요.");
		}
		else{
			var form = $('#fileData')[0];
	        var formData = new FormData(form);

	        $.ajax({
	            url: "uploadCode.jsp?userID=<%=userID%>&sessionID=<%=sessionID%>&problemID=<%=problemID%>",
	                    processData: false,
	                    contentType: false,
	                    data: formData,
	                    type: 'POST',
	                    success: function(data){
	                    	var f = document.getElementById("postData");
	                		f.setAttribute("method","post");
	                		f.setAttribute("action","upload.jsp");
	                		document.body.appendChild(f);
	                		
	                		var i = document.createElement("input");
	                		i.setAttribute("type","hidden");
	                		i.setAttribute("name","fileName");
	                		i.setAttribute("value",data);
	                		f.appendChild(i);
	                		
	                		var j = document.createElement("input");
	                		j.setAttribute("type","hidden");
	                		j.setAttribute("name","userID");
	                		j.setAttribute("value",sessionStorage.getItem("userID"));
	                		f.appendChild(j);
	                		
	                		var k = document.createElement("input");
	                		k.setAttribute("type","hidden");
	                		k.setAttribute("name","sessionID");
	                		k.setAttribute("value","<%=sessionID%>");
	                		f.appendChild(k);
	                		
	                		var l = document.createElement("input");
	                		l.setAttribute("type","hidden");
	                		l.setAttribute("name","problemID");
	                		l.setAttribute("value","<%=problemID%>");
	                		f.appendChild(l);
	                		
	                		f.submit();
	                    },
	        			error : function(request,status,error){
							console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	    				}
	            });
		}
	});
	
	</script>
</body>
</html>
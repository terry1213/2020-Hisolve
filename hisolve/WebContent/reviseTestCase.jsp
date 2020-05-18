<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.io.File"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%
	String uploadPath = request.getParameter("uploadPath");

	File f1 = new File(uploadPath + "/build");
	if(!f1.exists()){
	if(f1.mkdirs()){
		}
	}
	
	File f2 = new File(uploadPath + "/input");
	if(!f2.exists()){
	if(f2.mkdirs()){
		}
	}
	
	String problemName = request.getParameter("problemName");
	String timeLimit = request.getParameter("timeLimit");
	String problemContent = request.getParameter("problemContent");
	String type = request.getParameter("type");
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
		if(sessionStorage.getItem("allowed")!="testSampleProgram.jsp" && sessionStorage.getItem("allowed")!="testSampleProgram.jsp"){
			alert("잘못된 접근입니다.");
			history.back();
		}
		else{
			sessionStorage.setItem("allowed", "addBaseTar.jsp");
		}
	</script>
	
	<div id="nav" name="nav">
    </div>

<div class="container">
	<div class="row">
		<div class="col-md-8">
			<div class="page-header">
				<h5>뼈대 케이스 등록하기</h5>
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
				<div class="form-group">
					<button type="button" onclick="multi();" class="btn btn-info btn-sm">등록</button>
					<button type="button" onclick="history.back();" class="btn btn-info btn-sm">취소</button>
				</div>						
				
				<input name="uploadPath" id="uploadPath" type="hidden" required value="<%=uploadPath%>">
			</form>
			<form method="post" enctype="multipart/form-data" id="fileData">
							<div class="form-group">
								<label for="programForm"><strong>뼈대 프로그램을 올려주세요.(문제 제출할 내용과 양식 그대로)</strong></label>
							<input type="file" name="programForm" id="programForm" accept=".tar" class="form-control" required>
							</div>
							<div style="display : none;">
                            	<input type="submit" id = "checker">
                            </div>
			</form>
			<form method="post" enctype="multipart/form-data" id="fileData2">
							<div class="form-group">
								<label for="testForm"><strong>Test 프로그램을 올려주세요.(build.sh, test.sh는 필수적으로 포함해야 됨)</strong></label>
							<input type="file" name="testForm" id="testForm" accept=".tar" class="form-control" required>
							</div>
							<div style="display : none;">
                            	<input type="submit" id = "checker2">
                            </div>
			</form>
		</div>
	</div>
</div>



<script>
$('#nav').load("nav.jsp?userName=" + sessionStorage.getItem("userName"));

function multi(){
		
	    var fileCheck = document.getElementById("programForm").value;
	    if(!fileCheck){
	    		document.getElementById("checker").click();     
	            return false;
	    }
	    
	    var fileCheck2 = document.getElementById("testForm").value;
	    if(!fileCheck2){
	    		document.getElementById("checker2").click();
	            return false;
	    }
	    
	    
		var codefile = document.getElementById("programForm").files[0];
		if (codefile) {
	    	var reader = new FileReader();
	    	reader.readAsText(codefile, "UTF-8");
	    	reader.onload = function (evt) {
	    		content = evt.target.result;
	    		
	    		var temp = "programForm";
	     		var form = $('#fileData')[0];
	            var formData = new FormData(form);

	            	$.ajax({
	                url: "uploadTar.jsp?userID=" + sessionStorage.getItem('userID')+"&name="+temp,
	                        processData: false,
	                        contentType: false,
	                        async: false,
	                        data: formData,
	                        type: 'POST',
	                        success: function(data){
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
		
		var codefile2 = document.getElementById("testForm").files[0];
		if (codefile2) {
	    	var reader = new FileReader();
	    	reader.readAsText(codefile, "UTF-8");
	    	reader.onload = function (evt) {
	    		content = evt.target.result;
	    		
	    		var temp = "testForm";
	     		var form = $('#fileData2')[0];
	            var formData = new FormData(form);

	            	$.ajax({
	                url: "uploadTar.jsp?userID=" + sessionStorage.getItem('userID')+"&name="+temp,
	                        processData: false,
	                        contentType: false,
	                        async: false,
	                        data: formData,
	                        type: 'POST',
	                        success: function(data){
	                        	var i = document.createElement("input");
	                        	i.setAttribute("type","hidden");
	                        	i.setAttribute("name","userID");
	                        	i.setAttribute("value",sessionStorage.getItem("userID"));
	                        	document.getElementById('postData').appendChild(i);
	                        	
	                        	document.getElementById('postData').method = "post";
	                        	document.getElementById('postData').action = "addProgramTar.jsp"
	                        	document.getElementById('postData').submit();
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
		
		return true;
}

</script>
</body>
</html>

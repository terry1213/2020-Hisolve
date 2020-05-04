<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.io.File"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%
	String uploadPath = request.getParameter("uploadPath");

	File f1 = new File(uploadPath + "/input");
	if(!f1.exists()){
	if(f1.mkdirs()){
		}
	}
	
	File f2 = new File(uploadPath + "/output");
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
		if(sessionStorage.getItem("allowed")!="createProblem.jsp" && sessionStorage.getItem("allowed")!="testSampleProgram.jsp"){
			alert("잘못된 접근입니다.");
			history.back();
		}
		else{
			sessionStorage.setItem("allowed", "addTestCase.jsp");
		}
	</script>
	
	<div id="nav" name="nav">
    </div>

<div class="container">
	<div class="row">
		<div class="col-md-8">
			<div class="page-header">
				<h5>테스트 케이스 등록하기 (최대 20개)</h5>
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
					<button id="add" class="btn btn-info btn-sm">테스트 케이스 추가 +</button>
					<button id="delete" class="btn btn-info btn-sm">삭제 -</button>
					<button type="submit" class="btn btn-info btn-sm">등록</button>
					<button onclick="history.back();" class="btn btn-info btn-sm">취소</button>
				</div>
				
				<div class="input-group mb-3">
						<input name="inputNum" id="inputNum" type="hidden" value="1" class="form-control" readonly required>
				</div>
				
				<div class="row" id="testCase1">
					<div class="input-group mb-3 col-md-6" style="float: left; padding: 10px 0px 0px 0px;">
						<div class="input-group-prepend">
    						<label style="font-size: 12px;" class="input-group-text" for="input1">input1:</label>
  						</div>
  						<input name="input1" id="input1" type="file" accept=".txt" class="form-control" required>
					</div>
					<div class="input-group mb-3 col-md-6" style="float: left; padding: 10px 0px 0px 0px;">
						<div class="input-group-prepend">
    						<label style="font-size: 12px;" class="input-group-text" for="output1">output1:</label>
  						</div>
  						<input name="output1" id="output1" type="file" accept=".txt" class="form-control" required>
					</div>
				</div>
				
				<input name="uploadPath" id="uploadPath" type="hidden" required value="<%=uploadPath%>">
			</form>
		</div>
	</div>
</div>

<script>
$('#nav').load("nav.jsp?userName=" + sessionStorage.getItem("userName"));

var x = 2;
$(document).ready(function() {
    var max_fields = 20;
    var add_button = $("#add");

    $(add_button).click(function(e) {
        e.preventDefault();
        if (x <= max_fields) {
        	$("#postData").append('<div class="row" id="testCase' + x + '"><div class="input-group mb-3 col-md-6" style="float: left; padding: 10px 0px 0px 0px;"><div class="input-group-prepend"><label style="font-size: 12px;" class="input-group-text" for="input' + x + '">input' + x + ':</label></div><input name="input' + x + '" id="input' + x + '" type="file" accept=".txt" class="form-control" required></div><div class="input-group mb-3 col-md-6" style="float: left; padding: 10px 0px 0px 0px;"><div class="input-group-prepend"><label style="font-size: 12px;" class="input-group-text" for="output' + x + '">output' + x + ':</label></div><input name="output' + x + '" id="output' + x + '" type="file" accept=".txt" class="form-control" required></div></div>');
            $("#inputNum").val(x);
            $("#inputNum").load(document.URL + " #inputNum");
        	x++;
        } else {
            alert('최대 테스트 케이스 수 입니다!')
        }
    });
    
    $("#postData").on("click", "#delete", function(e) {
        e.preventDefault();
        if(x > 2){
            x--;
            $('#testCase'+ x).remove();
            $("#inputNum").val(x-1);
            $("#inputNum").load(document.URL + " #inputNum");
        }
    })
});

$("#postData").submit(function(e){
	
	for(var i = 1; i < x; i++){
		save('input', i);
		save('output', i);
	}
	
	var i = document.createElement("input");
	i.setAttribute("type","hidden");
	i.setAttribute("name","userID");
	i.setAttribute("value",sessionStorage.getItem("userID"));
	document.getElementById('postData').appendChild(i);
	
	document.getElementById('postData').method = "post";
	document.getElementById('postData').action = "addSampleProgram.jsp"
	//document.getElementById('postData').submit();

});

function save(txtType, j){
	var txtfile = document.getElementById(txtType + j).files[0];
	if (txtfile) {
    	var reader = new FileReader();
    	reader.readAsText(txtfile, "UTF-8");
    	reader.onload = function (evt) {
    		content = evt.target.result;
    		
    		$.ajax({
    	    	url:'save.jsp',
    	    	dataType:'text',
    	    	type:'POST',
    	    	data:{'data':content, 'fileName':txtType + (j-1) + '.txt', 'uploadPath':'<%=uploadPath%>/' + txtType},
    	    	success : function(){
    	    		delay(100);
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
}

function delay(gap){
    var then,now; 
then=new Date().getTime(); 
now=then; 
while((now-then)<gap){ 
now=new Date().getTime();  
}
}


</script>
</body>
</html>

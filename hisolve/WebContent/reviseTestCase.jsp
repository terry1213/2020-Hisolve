<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.io.File"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%
	String uploadPath = request.getParameter("uploadPath");
	String problemName = request.getParameter("problemName");
	String timeLimit = request.getParameter("timeLimit");
	String problemContent = request.getParameter("problemContent");
	String inputNum = request.getParameter("inputNum");
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
		if(sessionStorage.getItem("allowed")!="testSampleProgram.jsp" && sessionStorage.getItem("allowed")!="cloneProblem.jsp"){
			alert("잘못된 접근입니다.");
			history.back();
		}
		else{
			sessionStorage.setItem("allowed", "reviseTestCase.jsp");
		}
	</script>
	
<div id="nav" name="nav">
</div>

<div class="container">
	<div class="row">
		<div class="col-md-8">
			<div class="page-header">
				<h5>테스트 케이스 등록하기 (최대 20개)</h5>
				<h6>
					교수명: <script>document.write(sessionStorage.getItem("userName"));</script><br/>
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
				
				<strong><p id="addSign" ></p></strong>
				
				<div id="buttons" class="form-group" style="display:none;">
					<button id="add" class="btn btn-info btn-sm">테스트 케이스 추가 +</button>
					<button id="delete" class="btn btn-info btn-sm">삭제 -</button>
					<button id="submit" class="btn btn-info btn-sm">등록</button>
				</div>
				
				<input id="toAdd" type="button" class="btn btn-info btn-sm" value="다음" onclick="next()">
				
				<div class="input-group mb-3">
						<input name="inputNum" id="inputNum" type="hidden" value="<%=inputNum%>" class="form-control" readonly required>
				</div>
				
				<input name="uploadPath" id="uploadPath" type="hidden" required value="<%=uploadPath%>">
				
				<p id="deleteSign"><strong>기존 <%=inputNum%>개의 테스트 케이스를 수정해 주세요.</strong></p>
				
			</form>
		</div>
	</div>
</div>


<script>
$('#nav').load("nav.jsp?userName=" + sessionStorage.getItem("userName"));

var x = document.getElementById("inputNum").value;
$("#inputNum").load(document.URL + " #inputNum");
var previousTestCase;

for(var i = 1; i <= x; i++){
	$("#postData").append('<div id="whole' + i + '" class="container"><div class="row mb-3"><input type="button" id="onOff' + i + '" onclick="onOff(' + i + ')" value="' + i + '번 테스트 케이스 보기" class="btn btn-info btn-sm"><input type="button" id="deleteTestCase' + i + '" value="삭제" onclick="deleteTestCase(' + i + ')" class="btn btn-info btn-sm"></div>' + '<div class="row" id="testCase' + i + '" style="display: none;"><div class="input-group mb-3 col-md-6" style="float: left; padding: 10px 0px 0px 0px;"><div class="input-group-prepend"><label style="font-size: 12px;" class="input-group-text" for="input' + i + '">input' + i + ':</label></div><textarea name="input' + i + '" id="input' + i + '" class="form-control" style="height: 300px; resize: none;" disabled></textarea></div><div class="input-group mb-3 col-md-6" style="float: left; padding: 10px 0px 0px 0px;"><div class="input-group-prepend"><label style="font-size: 12px;" class="input-group-text" for="output' + i + '">output' + i + ':</label></div><textarea name="output' + i + '" id="output' + i + '" class="form-control" style="height: 300px; resize: none;" disabled></textarea></div></div></div>');
	textLoad(i);
}

x++;

var min_fields = 2;
var max_fields = 20;

$(document).ready(function() {
    
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
        if(x > min_fields){
            x--;
            $('#testCase'+ x).remove();
            $("#inputNum").val(x-1);
            $("#inputNum").load(document.URL + " #inputNum");
            textDelete(x);
        }
    })
    
});

$("#submit").click(function(){
	
	for(var i = 1; i <= previousTestCase; i++){
		$.ajax({
	    	url:'save.jsp',
	    	dataType:'text',
	    	type:'POST',
	    	data:{'data':document.getElementById('input' + i).value, 'fileName':'input' + (i-1) + '.txt', 'uploadPath':'<%=uploadPath%>/input'},
	    	success : function(){
	    		
	        },
	    	error : function(request,status,error){
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	    	}
		});
		$.ajax({
	    	url:'save.jsp',
	    	dataType:'text',
	    	type:'POST',
	    	data:{'data':document.getElementById('output' + i).value, 'fileName':'output' + (i-1) + '.txt', 'uploadPath':'<%=uploadPath%>/output'},
	    	success : function(){
	    		
	        },
	    	error : function(request,status,error){
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	    	}
		});
	}
	
	for(var i = previousTestCase + 1; i < x; i++){
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
});

function textLoad(j){
	$.ajax({
		url : "upload/" + sessionStorage.getItem("userID") + "/problem/test/input/input" + (j-1) + ".txt",
       	dataType: "text",
       	success : function (data) {
            $("#input" + j).val(data);
            $("#input" + j).load(document.URL + " #input" + j);
       	}
   	}); 
	
	$.ajax({
		url : "upload/" + sessionStorage.getItem("userID") + "/problem/test/output/output" + (j-1) + ".txt",
       	dataType: "text",
       	success : function (data) {
            $("#output" + j).val(data);
            $("#output" + j).load(document.URL + " #output" + j);
            textDelete(j);
       	}
   	}); 
}

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

function onOff(n){
	if(document.getElementById("onOff" + n).value == n + "번 테스트 케이스 보기"){
		document.getElementById("testCase" + n).style.display = "block";
		document.getElementById("onOff" + n).value = n + "번 테스트 케이스 닫기";
	}
	else{
		document.getElementById("testCase" + n).style.display = "none";
		document.getElementById("onOff" + n).value = n + "번 테스트 케이스 보기";
	}
	
}

function deleteTestCase(n){
	for(var m = n; m < x-1; m++){
		document.getElementById("input" + m).value = document.getElementById("input" + (m+1)).value;
		document.getElementById("output" + m).value = document.getElementById("output" + (m+1)).value;
	}
	$("#whole" + (x-1)).remove();
	$("#testcase" + (x-1)).remove();
	x--;
	$("#inputNum").val(x-1);
}

function next(){
	previousTestCase = x - 1;
	min_fields = x;
	max_fields = 21 - x;
	document.getElementById("addSign").innerHTML = previousTestCase + "개의 테스트 케이스가 저장되었습니다. <br> 최대 " + (20-previousTestCase) + "개의 테스트 케이스를 더 추가할 수 있습니다.";
	document.getElementById("buttons").style.display = "block";
	document.getElementById("toAdd").type = "hidden";
	document.getElementById("deleteSign").style.display = "none";
	for(var i = 1; i <= previousTestCase; i++){
		document.getElementById("whole" + i).style.display = "none";
	}
	if(x == 1){
		$("#postData").append('<div class="row" id="testCase' + x + '"><div class="input-group mb-3 col-md-6" style="float: left; padding: 10px 0px 0px 0px;"><div class="input-group-prepend"><label style="font-size: 12px;" class="input-group-text" for="input' + x + '">input' + x + ':</label></div><input name="input' + x + '" id="input' + x + '" type="file" accept=".txt" class="form-control" required></div><div class="input-group mb-3 col-md-6" style="float: left; padding: 10px 0px 0px 0px;"><div class="input-group-prepend"><label style="font-size: 12px;" class="input-group-text" for="output' + x + '">output' + x + ':</label></div><input name="output' + x + '" id="output' + x + '" type="file" accept=".txt" class="form-control" required></div></div>');
        $("#inputNum").val(x);
        $("#inputNum").load(document.URL + " #inputNum");
    	x++;
    	min_fields = x;
    	max_fields = 22 - x;
	}
}

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

</script>
</body>
</html>
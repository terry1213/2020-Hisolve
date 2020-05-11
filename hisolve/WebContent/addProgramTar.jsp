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
   
   int listsize=0;
   int listsize2=0;
   
   ProblemDAO problemDAO = new ProblemDAO();
   int problemNum = problemDAO.howmany(userID);
   
   File dir = new File(uploadPath);
   File[] fileList = dir.listFiles();
   String[] nameList = new String[fileList.length];
   
	for(int i = 0 ; i < fileList.length ; i++){
		File file = fileList[i];
		if(file.isFile()){
			String str = file.getName();
			if(str.substring(str.length()-2,str.length()).equals(".c") || str.substring(str.length()-2,str.length()).equals(".h")){
				nameList[listsize] = str;
				listsize++;
			}
		}
	}
          
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
		if(sessionStorage.getItem("allowed")!="addBaseTar.jsp" && sessionStorage.getItem("allowed")!="reviseTestCase.jsp"){
			alert("잘못된 접근입니다.");
			history.back();
		}
		else{
			sessionStorage.setItem("allowed", "addProgramTar.jsp");
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
				
				<h5>테스트 명령어 등록하기 (최대 20개)</h5><br>
				<div class="form-group">
					<button id="add" class="btn btn-info btn-sm"> 추가 +</button>
					<button id="delete" class="btn btn-info btn-sm">삭제 -</button>
				</div>
				
				<div class="input-group mb-3">
						<input name="inputNum" id="inputNum" type="hidden" value="1" class="form-control" readonly required>
				</div>
				
				<div class="row" id="testCase1">
					<div class="input-group mb-3 col-md-6" style="float: left; padding: 10px 0px 0px 0px;">
						<div class="input-group-prepend">
    						<label style="font-size: 12px;" class="input-group-text" for="input1">Command 1:</label>
  						</div>
  						<textarea id ="input1" required></textarea>
					</div>
				</div>
			</form>
			
			<form id = "checkBoxData">
				<p>뼈대파일을 체크하세요</p>
				<% 
					for(int i=0;i<listsize;i++){
				%> 
					<label><input type="checkbox" name="fileNum<%=i%>" value="<%=nameList[i]%>"> <%=nameList[i]%></label>
				<% 
					}
				%>
			</form>
			
			<form method="post" enctype="multipart/form-data" id="fileData">
				<div class="form-group">
                     <label for="sampleProgram"><strong>테스트 케이스에 대한 샘플 프로그램을 올려주세요. (뼈대만 있는 파일을 대신할 파일들을 tar 형식으로 묶어서 제출하세요)</strong></label>
                    <input type="file" name="sampleProgram" id="sampleProgram" accept=".tar" class="form-control" required>
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

var x = 2;
$(document).ready(function() {
    var max_fields = 20;
    var add_button = $("#add");

    $(add_button).click(function(e) {
        e.preventDefault();
        if (x <= max_fields) {
        	$("#postData").append('<div class="row" id="testCase' + x + '"><div class="input-group mb-3 col-md-6" style="float: left; padding: 10px 0px 0px 0px;"><div class="input-group-prepend"><label style="font-size: 12px;" class="input-group-text" for="input' + x + '">Command ' + x + ':</label></div><textarea id = "input' + x + '" requried></textarea></div></div>');
            $("#inputNum").val(x);
            $("#inputNum").load(document.URL + " #inputNum");
        	x++;
        } else {
            alert('최대 Command 수 입니다!')
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

function save(txtType, j){
	var content = document.getElementById(txtType+j).value;
	if (content) {
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
}

var content = "";
$("#test").click(function(){
	
	for(var i = 1; i < x; i++){
		save('input', i);
	}
	
	var testList = new Array();
	
	for(var i=0;i<<%=listsize%>;i++){
        var name = "fileNum" + i;
        $("input[name="+name+"]:checked").each(function(){
                var boneFile = $(this).val();
                $.ajax({                                        
        url:'eraseBoneFile.jsp',
        dataType:'text',
        type:'POST',
        data:{'fileName':boneFile, 'uploadPath':'<%=uploadPath%>/'},
        success : function(){
        },
        error : function(request,status,error){
                        console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        }
                });
        });
	}
	
	var codefile = document.getElementById("sampleProgram").files[0];
	if (codefile) {
    	var reader = new FileReader();
    	reader.readAsText(codefile, "UTF-8");
    	reader.onload = function (evt) {
    		content = evt.target.result;
    		
    		var temp = "sampleProgram";
     		var form = $('#fileData')[0];
            var formData = new FormData(form);

            $.ajax({
                url: "uploadTar.jsp?userID=" + sessionStorage.getItem('userID')+"&name="+temp,
                        processData: false,
                        contentType: false,
                        data: formData,
                        type: 'POST',
                        success: function(){
                        	$.ajax({
                    	    	url:'makeTar.jsp',
                    	    	dataType:'text',
                    	    	type:'POST',
                    	    	traditional : true,
                    	    	data:{'uploadPath':'<%=uploadPath%>'},
                    	    	success : function(){
                    	    		$.ajax({
                            	    	url:'multiResultPage.jsp',
                            	    	dataType:'text',
                            	    	type:'POST',
                            	    	data:{'uploadPath':'<%=uploadPath%>', 'txtPath':'<%=uploadPath%>', 'fileName':"finalProgram.tar", 'userID': sessionStorage.getItem("userID"), 'timeLimit': '<%=timeLimit%>', 'problemName': '<%=problemName%>', 'problemContent': '<%=problemContent%>', 'type': '<%=type%>', 'testing':'NO'},
                            	    	success : function(data){
                            	            $('#result').val(data);
                            	            $('#userID').val(sessionStorage.getItem("userID"));
                             	     		document.getElementById('postData').method = "post";
                            	    		document.getElementById('postData').action = "testSampleProgram.jsp"
                            	    		document.getElementById('postData').submit();
                            	        },
                            	    	error : function(request,status,error){
                            				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                            	    	}
                            		});
                    	        },
                    	    	error : function(request,status,error){
                    				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                    	    	}
                    		});
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
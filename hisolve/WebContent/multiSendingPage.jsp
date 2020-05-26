<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@page import="java.io.*"%>
<%@page import="java.util.Arrays"%>
<%@ page import="user.ResultDAO" %>
<%@ page import="user.ProblemDAO" %>
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
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
<script defer src="https://use.fontawesome.com/releases/v5.0.8/js/solid.js" integrity="sha384-+Ga2s7YBbhOD6nie0DzrZpJes+b2K1xkpKxTFFcx59QmVPaSA8c7pycsNaFwUK6l" crossorigin="anonymous"></script>
<script defer src="https://use.fontawesome.com/releases/v5.0.8/js/fontawesome.js" integrity="sha384-7ox8Q2yzO/uWircfojVuCQOZl+ZZBg2D2J5nkpLqzH1HY0C1dHlTKIbpRz/LG23c" crossorigin="anonymous"></script>
<link rel="stylesheet" type="text/css" href="css/codemirror.css">
<link rel="stylesheet" type="text/css" href="theme/base16-light.css">
<script type ="text/javascript" src="js/codemirror.js "></script>
<script type ="text/javascript" src="js/editor_readonly.js?ver=4"></script>
<script type ="text/javascript" src="js/clike.js"></script>
<script type ="text/javascript" src="js/matchbrackets.js"></script>
<script type ="text/javascript" src="js/active-line.js"></script>

<script src="https://codemirror.net/addon/search/search.js"></script>
<script src="https://codemirror.net/addon/search/searchcursor.js"></script>
</head>
<body>

	<script>
		if(sessionStorage.getItem("allowed")!="applySession.jsp" && sessionStorage.getItem("allowed")!="upload.jsp"){
			alert("잘못된 접근입니다.");
			history.back();
		}
		else{
			sessionStorage.setItem("allowed", "multiSendingPage.jsp");
		}
	</script>

	<%
	String problemID = request.getParameter("problemID");
	String problemName = request.getParameter("problemName");
	String timeLimit = request.getParameter("timeLimit");
	String sessionID = request.getParameter("sessionID");
	String userID = request.getParameter("userID");
	String uploadPath = request.getSession().getServletContext().getRealPath("/upload") + '/' + userID + '/' + sessionID + '/' + problemID;
	
	File f = new File(uploadPath);
	if(!f.exists()){
		f.mkdirs();
	}
	
	String unwrapPath = request.getSession().getServletContext().getRealPath("/upload")+"/problem/"+ problemID;
	Runtime rt = Runtime.getRuntime();
	Process p = rt.exec("tar -xvf " +unwrapPath+"/programForm.tar"+" -C "+unwrapPath);
    p.waitFor();
    p = rt.exec("cp " + unwrapPath + "/problemContent.txt "+uploadPath);
    p.waitFor();
    
	f = new File(unwrapPath);
	File[] fileList = f.listFiles();
	String[] nameList = new String[fileList.length];
	int listsize=0;
	   
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
	
	ResultDAO resultDAO = new ResultDAO();
	ProblemDAO problemDAO = new ProblemDAO();
	
	int valid = 0;
	
	int result = problemDAO.howmany2(problemID);
	String[] skeleton = new String[result];
	skeleton = problemDAO.seeRequiredFile(Integer.valueOf(problemID), result);
	//db에서 뼈대 파일 이름들 가져와서 skeleton 배열에 저장

	
	int opportunity = 0;
	int num = resultDAO.chance(userID,sessionID,problemID);
	if(num==-1){
		opportunity = 50;
	}
	else{
		opportunity = num;
	}
	
	%>
	<div id="nav" name="nav">
	</div>

	<div class="container">
		<div class="row">
			<div class="col-md-8">
				<div class="page-header">
					<h5>문제 풀기</h5>
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
				
				
				<div class="card" style="width:100%;margin-left:2%; margin-bottom:2%; margin-top:2%;">
				<div class="card-header">
			<nav class="navbar navbar-expand-lg navbar-light bg-light">
  			<a class="navbar-brand"><strong id="currentCode">코드를 선택해주세요.</strong></a>
  			<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    			<span class="navbar-toggler-icon"></span>
  			</button>
  			
  			<div class="collapse navbar-collapse" id="navbarSupportedContent">
    			<ul class="navbar-nav mr-auto">
      			<li class="nav-item dropdown">
        			<a class="nav-link dropdown-toggle" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          			코드 선택
        			</a>
        			<div class="dropdown-menu" aria-labelledby="navbarDropdown">
        				<% 
  							for(int i=0;i<listsize;i++){
  								if(nameList[i].equalsIgnoreCase("makefile")){
  									p=rt.exec("cp "+unwrapPath+"/"+nameList[i]+ " " + uploadPath);
  									continue;
  								}
  								if(Arrays.asList(skeleton).contains(nameList[i])){
  									valid = 1;
  									p=rt.exec("cp "+unwrapPath+"/"+nameList[i]+ " " + uploadPath);
  									%><input id="files" type="text" value="<%=nameList[i]%>"/><%
  								}
  								else{
  									valid = 0;
  									p=rt.exec("cp "+unwrapPath+"/"+nameList[i]+ " " + uploadPath);
  								}
  								
  						%>
      					<a class="dropdown-item" onclick="showCode('<%=nameList[i]%>', '<%=valid%>')"><%= nameList[i] %></a>
      					<%
  							}
  	      				%>
        			</div>
      			</li>
    			</ul>
  			</div>
		</nav>
			<form method="post" enctype="multipart/form-data" id="fileData" style="display:none;">
					<div class="form-group">
						<label><strong>프로그램을 올려주세요.</strong></label>
						<input type="file" name="fileName" id="fileName" class="form-control" required>
					</div>
					<button id="dataUpload" class="btn btn-primary">업로드</button>
			</form>
		</div>
			
		<div class="card-body">
			<div style="height:500px;">
				<textarea id="editor"></textarea>
			</div>
		</div>		
		<div id="saveCode" style="width:50%; display:none; float:right;">
    		<button style="width:30%; float:left;" class="btn btn-outline-success my-2 my-sm-0" onclick="saveFile();">저장하기</button>
    	</div>		
			</div>
			<h3>남은 제출 횟수 : <strong id="opportunity"><%=opportunity%></strong></h3>
		<div id="buttons">
			<button id="Cordscore" class="btn btn-primary">채점하기</button>
			<button onclick="history.back();" class="btn btn-primary">돌아가기</button>
			<button class="btn btn-primary" onclick="tossback();">메인으로 가기</button>
		</div>
		</div>
		
		<textarea id="result" style="resize: none; background-color: black; color: white; border: 2px solid gray; height: 300px; width: 100%;" readonly="readonly" disabled></textarea>
	</div>
	
	<script>
	var name = "";
	$('#nav').load("nav.jsp?userName=" + sessionStorage.getItem("userName"));
	var editor = editor("#editor");
	
	function textLoad(){
		$.ajax({
			url : "upload/problem/<%=problemID%>/problemContent.txt",
	       	dataType: "text",
	       	success : function (data) {
	            $('#problemContent').val(data);
	       	}
	   	}); 
	}
	textLoad();
			
	function showCode(fileName, valid){
		eraseEditor();
		fileLoad(fileName);
		name = fileName;
		//saveFile();
		document.getElementById("currentCode").innerHTML = fileName;
		if(valid == 1){ // 뼈대 파일을 바꿀 파일인 경우에만 
			editor.setOption("readOnly", false);
			$('#fileData').show();
			$('#saveCode').show();
		}
		else{
			editor.setOption("readOnly", true);
			$('#fileData').hide();
			$('#saveCode').hide();
		}
	}
	
	function fileLoad(fileName){
		$.ajax({
			url : "upload/<%=userID%>/<%=sessionID%>/<%=problemID%>/"+fileName,
	       	dataType: "text",
	       	success : function (data) {
	       		editor.getDoc().setValue(data);
	       	}
	   	}); 
	}
	
	function saveFile(){
		$.ajax({
        	url:'save.jsp',
        	dataType:'text',
        	type:'POST',
        	data:{'data':editor.getValue(), 'fileName':name, 'uploadPath':'<%=uploadPath%>'},
        	success : function(){
            },
        	error : function(request,status,error){
    			console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        	}
    	});
	}
	
	function uploadFile(){
		$.ajax({
        	url:'save.jsp',
        	dataType:'text',
        	type:'POST',
        	data:{'data':editor.getValue(), 'fileName':name, 'uploadPath':'<%=uploadPath%>'},
        	success : function(){
            },
        	error : function(request,status,error){
    			console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        	}
    	});
	}
	
	function eraseEditor(){
		editor.getDoc().setValue("");
		$('#saveCode').hide();
	}
	
	$("#dataUpload").click(function(ev){
		if(document.getElementById("fileName").files.length == 0){
			alert("업로드할 프로그램을 선택해주세요.");
		}
		else{
			var form = $('#fileData')[0];
	        var formData = new FormData(form);

	        $.ajax({
	            url: "uploadCode.jsp?userID=<%=userID%>&sessionID=<%=sessionID%>&problemID=<%=problemID%>&changeName=" + name,
	                    processData: false,
	                    contentType: false,
	                    async: false,
	                    data: formData,
	                    type: 'POST',
	                    success: function(data){
	                    	editor.getDoc().setValue("");
	            			fileLoad(name);
	                    },
	        			error : function(request,status,error){
	    				}
	            });
		}
		ev.preventDefault();
	});
	
	$("#Cordscore").click(function(ev){
		if(document.getElementById("opportunity").innerHTML == "0"){
			alert("제출 기회를 모두 사용하였습니다.");
		}
		else{
			var requiredFileName = []; 
			var requiredFileResult = [];
			$("#files").each(function(){
				requiredFileName.push(this.value);
				
				$.ajax({
					url : "upload/<%=userID%>/<%=sessionID%>/<%=problemID%>/"+this.value,
			       	dataType: "text",
			       	async: false,
			       	success : function (data) {
			       		requiredFileResult.push(data);
			       	}
			   	}); 
			});
			
			document.getElementById('buttons').style.display = "none";
			$('#result').val("채점중...");
    		$("#result").load(document.URL + " #result");
    		$.ajax({
    	    	url:'makeStudentTar.jsp',
    	    	dataType:'text',
    	    	type:'POST',
    	    	traditional : true,
    	    	data:{'uploadPath':'<%=uploadPath%>', 'testPath':'<%=unwrapPath%>'},
    	    	success : function(){
    	    		$.ajax({
    	            	url:'multiResultPage.jsp',
    	            	dataType:'text',
    	            	type:'POST',
    	            	data:{'uploadPath':'<%=uploadPath%>', 'txtPath':'<%=unwrapPath%>', 'fileName':"finalProgram.tar", 'userID': sessionStorage.getItem("userID"), 'sessionID': '<%=sessionID%>', 'problemID': '<%=problemID%>', 'timeLimit': '<%=timeLimit%>', 'problemName': '<%=problemName%>', 'problemContent': $("#problemContent").val(), 'type': 'multi', 'testing':'NO', 'requiredFileName': requiredFileName, 'requiredFileResult': requiredFileResult},
    	            	success : function(data){
    	            		var opportunity = data.split("opportunity");
    	            		$('#result').val(opportunity[1]);
    	            		$("#result").load(document.URL + " #result");
    	            		document.getElementById("opportunity").innerHTML = opportunity[0];
    	            		document.getElementById('buttons').style.display = "block";
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
		ev.preventDefault();
	});
	
	function tossback(){
        var f = document.createElement("form");
        f.setAttribute("method","post");
        f.setAttribute("action","studentPage.jsp");
        document.body.appendChild(f);
        
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
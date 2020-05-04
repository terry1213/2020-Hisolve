<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import= "java.io.*"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import="user.ResultDAO" %>
<%
	String fileName = request.getParameter("fileName");
	String userID = request.getParameter("userID");
	String sessionID = request.getParameter("sessionID");
	String problemID = request.getParameter("problemID");
	String timeLimit = request.getParameter("timeLimit");
	String problemContent = request.getParameter("problemContent");
	
	String uploadPath = request.getSession().getServletContext().getRealPath("/upload") + '/' + userID + '/' + sessionID + '/' + problemID;
	String txtPath = request.getSession().getServletContext().getRealPath("/upload") + "/problem/" + problemID;
	
	ResultDAO resultDAO = new ResultDAO();
	
	int opportunity = 0;
	int num = resultDAO.chance(userID,sessionID,problemID);
	if(num==-1){
		opportunity = 50;
	}
	else{
		opportunity = num;
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
<link rel="stylesheet" type="text/css" href="css/codemirror.css">
<link rel="stylesheet" type="text/css" href="theme/base16-light.css">
</head>
<body>

	<script>
		if(sessionStorage.getItem("allowed")!="sendingPage.jsp"){
			alert("잘못된 접근입니다.");
			history.back();
		}
		else{
			sessionStorage.setItem("allowed", "upload.jsp");
		}
	</script>

	<div id="nav" name="nav">
	</div>
	
	<div class="card" style="width:60%;margin-left:2%; margin-bottom:2%; margin-top:2%;">
		<div class="card-header">
			<h2><%=problemContent%></h2>
		</div>
		<div class="card-body">
			<div style="height:500px;">
				<textarea id="editor"></textarea>
			</div>
			<textarea id="result" style="resize: none; background-color: black; color: white; border: 2px solid gray; height: 300px; width: 100%;" readonly="readonly" disabled></textarea>
			<div>
				<input id="fileName" type="hidden" name="fileName" value="<%=fileName%>"> 
				<%-- <input id="orgfileName" type="hidden" name="orgfileName" value="<%=orgfileName%>"> --%>
				<input id="uploadPath" type="hidden" name="uploadPath" value="<%=uploadPath%>">
				<input id="txtPath" type="hidden" name="txtPath" value="<%=txtPath%>">
				<input id="timeLimit" type="hidden" name="timeLimit" value="<%=timeLimit%>">
			</div>
			<h3>남은 제출 횟수 : <strong id="opportunity"><%=opportunity%></strong></h3>
			<div id="buttons">
				<button id="submit" class="btn btn-primary">저장 및 채점하기</button>
				<button class="btn btn-primary" onclick="history.back()">돌아가기</button>
				<button class="btn btn-primary" onclick="tossback();">메인으로 가기</button>
			</div>
		</div>
	</div>

	<script type ="text/javascript" src="js/codemirror.js "></script>
    <script type ="text/javascript" src="js/editor.js?ver=1"></script>
    <script type ="text/javascript" src="js/clike.js"></script>
    <script type ="text/javascript" src="js/matchbrackets.js"></script>
    <script type ="text/javascript" src="js/active-line.js"></script>
	<script>
	
    	$('#submit').click( function() {
    		if(document.getElementById("opportunity").innerHTML == "0"){
    			alert("제출 기회를 모두 사용하였습니다.");
    		}
    		else{
    			document.getElementById('buttons').style.display = "none";
    			$('#result').val("채점중...");
        		$("#result").load(document.URL + " #result");
            	$.ajax({
                	url:'save.jsp',
                	dataType:'text',
                	type:'POST',
                	data:{'data':editor.getValue(), 'fileName':$('#fileName').val(), 'uploadPath':$('#uploadPath').val()},
                	success : function(){
                		
                    },
                	error : function(request,status,error){
            			console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                	}
            	});
            	$.ajax({
                	url:'resultPage.jsp',
                	dataType:'text',
                	type:'POST',
                	data:{'fileName':$('#fileName').val(), 'uploadPath':$('#uploadPath').val(), 'txtPath':$('#txtPath').val(), 'userID':sessionStorage.getItem("userID"), 'timeLimit':$('#timeLimit').val(), 'sessionID':"<%=sessionID%>", 'problemID':"<%=problemID%>", 'code':editor.getValue(), 'type':'single', 'testing':'NO'},
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
    		}
    	});
    
    	$(document).ready(function(){
    		$('#nav').load("nav.jsp?userName=" + sessionStorage.getItem("userName"));
    		
    		$.ajax({
        		url : "upload/" + sessionStorage.getItem("userID") + "/<%=sessionID%>/<%=problemID%>/<%=fileName%>",
               	dataType: "text",
               	success : function (data) {
               		editor.getDoc().setValue(data);
               		$.ajax({
                		url : "delete.jsp",
                       	dataType: "text",
                       	type:'POST',
                       	data:{'fileName':$('#fileName').val(), 'deletePath':$('#uploadPath').val()},
                       	success : function (data) {
                       	}
                   	}); 
               	}
           	}); 
    		
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
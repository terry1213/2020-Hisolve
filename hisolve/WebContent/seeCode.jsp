<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import= "java.io.*"%>
<%@ page import="user.ResultDAO" %>
<%@ page import="user.UserDAO" %>
<%@ page import="user.SessionDAO" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%
	String userID = request.getParameter("userID");
	String testID = request.getParameter("testID");
	String sessionID = request.getParameter("sessionID");
	String problemID = request.getParameter("problemID");
	String resultID = request.getParameter("resultID");
	String state = request.getParameter("state");
	String toID = "";
	
	String uploadPath = request.getSession().getServletContext().getRealPath("/upload");
	String txtPath = request.getSession().getServletContext().getRealPath("/upload") + "/problem/" + problemID;
	
	ResultDAO resultDAO = new ResultDAO();
	UserDAO userDAO = new UserDAO();
	SessionDAO sessionDAO = new SessionDAO();
	
	if(userDAO.check(userID).equals("YES")){
		toID = testID;
	}
	else{
		toID = sessionDAO.seeSession2(sessionID)[0];
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
		if(sessionStorage.getItem("allowed")!="seeResult.jsp" && sessionStorage.getItem("allowed")!="seeCode.jsp"){
			alert("잘못된 접근입니다.");
			history.back();
		}
		else{
			sessionStorage.setItem("allowed", "seeCode.jsp");
		}
	</script>
	
	<div id="nav" name="nav">
	</div>
	
	<div class="card" style="float:left; width:50%; margin-left:2%; margin-bottom:2%; margin-top:2%; margin-right:2%;">
		<div class="card-header"><%=testID%> 님이 제출한 코드입니다.</div>
		<div class="card-body" style="height:500px; overflow: auto;">
			<textarea id="editor"><%=resultDAO.seeCode(testID, sessionID, problemID, resultID)%></textarea>
		</div>
		<div id="results" class="card-body" style="height:300px;">
			<textarea id="result" style="resize: none; background-color: black; color: white; height: 80%; max-height:80%; width: 100%;" readonly="readonly" disabled></textarea>
			<div id="buttons">
				<button onclick="history.back();" class="btn btn-primary">돌아가기</button>
				<button id="submit" class="btn btn-primary">테스트</button>
			</div>
		</div>
	</div>
	
	<div class="card" style="float:left; height:700px;width:30%; margin-left:2%; margin-bottom:2%; margin-top:2%;">
		<div class="card-header"><h3 style="margin-top:0;">Comments</h3></div>
		<div class="card-body" id="comments" name="comments" style="overflow: auto; height: 80%; width:100%; background-color:skyblue;">
		<%
			int result = resultDAO.countComment4(sessionID, problemID, resultID);
			int temp[] = new int[result];
			String[][] show = new String[result][7];
		
			temp = resultDAO.selectCommentID(sessionID, problemID, resultID, result);
		
			for(int i=0;i<result;i++){
				show[i] = resultDAO.seeComment(temp[i]);
			}
  			for(int i=0;i<result;i++){
  			%>
  			<div style="clear:both;width:100%; height: auto;">
  				<div <%if(show[i][5].equals(userID)){%>
  						style="float:right;width:50%; height: auto;"><h5 style="float:right;"><%=show[i][5]%></h5>
  					<%}else{%>
  						style="float:left;width:50%; height: auto;"><h5 style="float:left;"><%=show[i][5]%></h5>
  					<%}%>
  					<%if(resultDAO.checkNew(temp[i], "NEW", userID) == 1){
  						resultDAO.changNew(temp[i], "OLD");
  					%>
  						<h5 style="float:right;"><strong>new !</strong></h5>
  					<%}%>
  					<a style="<%if(show[i][5].equals(userID)){%>
  						float:right;
  					<%}else{%>
  						float:left;
  					<%}%>margin-bottom:10px; width: auto; max-width:100%; min-width:100px; height: auto; min-height:30px; clear:both; background-color:lightyellow;" class="form-control"><%=show[i][4]%></a>
  				</div>
  			</div>
  			<%
  			}
  		%>
  		</div>
  		<div class="card-body" style="height: 20%;">
			<textarea class="form-control" id="comment" name="comment" style="resize: none; height: 100%; max-height:100%; width: 80%; float:left; margin-right:5%" placeholder="내용을 입력해주세요."></textarea>
			<button class="btn btn-info" id="uploadComment" name="uploadComment" style="width: 15%; height: 100%; max-height:100%; float:left;" >전송</button>
		</div>
	</div>
	
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	<script type ="text/javascript" src="js/codemirror.js "></script>
   <!--  <script type ="text/javascript" src="js/editor_readonly.js?ver=1"></script> -->
    <script type ="text/javascript" src="js/clike.js"></script>
    <script type ="text/javascript" src="js/matchbrackets.js"></script>
    <script type ="text/javascript" src="js/active-line.js"></script>
	
	<script>
	
	$(document).ready(function(){
		$('#nav').load("nav.jsp?userName=" + sessionStorage.getItem("userName"));
		
		if("<%=userDAO.check(userID)%>" == "NO"){
			document.getElementById('result').style.display = "none";
			document.getElementById('submit').style.display = "none";
			document.getElementById('results').style.height = "100px";
		}
	    
		$('#uploadComment').click( function() {
			if($('#comment').val() != ""){
				$('#comment').val($('#comment').val().replace(/</g, "&lt;"));
				$('#comment').val($('#comment').val().replace(/>/g, "&gt;"));
				$.ajax({
	            	url:'uploadComment.jsp',
	            	dataType:'text',
	            	type:'POST',
	            	data:{'comment':$('#comment').val(), 'sessionID':'<%=sessionID%>', 'problemID':'<%=problemID%>', 'resultID':'<%=resultID%>', 'userID':sessionStorage.getItem("userID"), 'toID':'<%=toID%>'},
	            	success : function(){
	            		$('#comments').load("comments.jsp?userID=<%=userID%>&testID=<%=testID%>&sessionID=<%=sessionID%>&problemID=<%=problemID%>&resultID=<%=resultID%>");
	            		$('#comment').val("");
	            		scroll();
	                },
	            	error : function(request,status,error){
	        			console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	            	}
	        	});
			}
    	});
		
		$('a').each(function() {
	        var txt = $(this).text().replace(/</g, "&lt;");
	        txt = txt.replace(/>/g, "&gt;");
	        txt = txt.replace(/(\n|\r\n)/g, '</br>');
	        txt = txt.replace( /@\d+/g, function (x) {
	        	  return '<a style="cursor:pointer; color:blue; background-color:lightblue; border-radius: 3px;" onclick="lineTag(' + x.slice(1) + ')" >' + x + '</a>';
	        	});
	        $(this).html(txt);
	    });
		
		scroll();
	});
	
	function scroll(){
		var objDiv = document.getElementById("comments");
	    objDiv.scrollTop = objDiv.scrollHeight;
	}
	
	$('#submit').click( function() {
		document.getElementById('buttons').style.display = "none";
		$('#result').val("채점중...");
		$("#result").load(document.URL + " #result");
    	$.ajax({
        	url:'save.jsp',
        	dataType:'text',
        	type:'POST',
        	data:{'data':editor.getValue(), 'fileName':"testingProgram.c", 'uploadPath':"<%=uploadPath%>/" + sessionStorage.getItem("userID")},
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
        	data:{'fileName':"testingProgram.c", 'uploadPath':"<%=uploadPath%>/" + sessionStorage.getItem("userID"), 'txtPath':"<%=txtPath%>", 'userID':sessionStorage.getItem("userID"), 'timeLimit':'1', 'sessionID':"<%=sessionID%>", 'problemID':"<%=problemID%>", 'code':editor.getValue(), 'type':'single', 'testing':'YES'},
        	success : function(data){
        		$('#result').val(data);
        		$("#result").load(document.URL + " #result");
        		document.getElementById('buttons').style.display = "block";
            },
        	error : function(request,status,error){
    			console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        	}
    	});
	});
	
	var code = $("#editor")[0];
	window.editor = CodeMirror.fromTextArea(code, {
		lineNumbers : true,
		mode: "text/x-csrc",
		theme: "base16-light",
		matchBrackets: true,
		lineWrapping: true,
		styleActiveLine: true,
		readOnly: true,
		});
	editor.setSize("100%", "100%");
	
	function lineTag(i){
		editor.setCursor({line: i - 1, ch: 1})
	}
	
	setInterval(function() {
		$.ajax({
        	url:'checkComments.jsp',
        	dataType:'text',
        	type:'POST',
        	data:{'sessionID':'<%=sessionID%>', 'problemID':'<%=problemID%>', 'resultID':'<%=resultID%>', 'userID':sessionStorage.getItem("userID")},
        	success : function(data){
        		if(data == "NEW"){
            		$('#comments').load("comments.jsp?userID=<%=userID%>&testID=<%=testID%>&sessionID=<%=sessionID%>&problemID=<%=problemID%>&resultID=<%=resultID%>");
            		scroll();
        		}
            },
        	error : function(request,status,error){
    			console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        	}
    	});
	}, 10000);
	
	</script>
</body>
</html>
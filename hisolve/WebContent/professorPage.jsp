<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.ResultDAO" %>
<%@ page import="user.ProblemDAO" %>
<%@ page import="user.SessionDAO" %>
<% request.setCharacterEncoding("UTF-8"); %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="css/bootstrap.min.css">
<title>Hisolve</title>

<link rel="icon" href="favicon.ico">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
<script defer src="https://use.fontawesome.com/releases/v5.0.8/js/solid.js" integrity="sha384-+Ga2s7YBbhOD6nie0DzrZpJes+b2K1xkpKxTFFcx59QmVPaSA8c7pycsNaFwUK6l" crossorigin="anonymous"></script>
<script defer src="https://use.fontawesome.com/releases/v5.0.8/js/fontawesome.js" integrity="sha384-7ox8Q2yzO/uWircfojVuCQOZl+ZZBg2D2J5nkpLqzH1HY0C1dHlTKIbpRz/LG23c" crossorigin="anonymous"></script>

</head>
<body>

	<script>
		if(sessionStorage.getItem("allowed")!="loginAction.jsp" && sessionStorage.getItem("allowed")!="change.jsp" && sessionStorage.getItem("allowed")!="showSession.jsp" && sessionStorage.getItem("allowed")!="deleteSession.jsp" && sessionStorage.getItem("allowed")!="testSampleProgram.jsp" && sessionStorage.getItem("allowed")!="showProblem.jsp" && sessionStorage.getItem("allowed")!="createProblem.jsp" && sessionStorage.getItem("allowed")!="createSession.jsp" && sessionStorage.getItem("allowed")!="reviseTime.jsp"){
			alert("잘못된 접근입니다.");
			history.back();
		}
		else{
			sessionStorage.setItem("allowed", "professorPage.jsp");
		}
	</script>

	<div id="nav" name="nav">
	</div>
	
	<% 
		String userID = request.getParameter("userID");
		String userName = request.getParameter("userName");
		
		ResultDAO resultDAO = new ResultDAO();
		SessionDAO sessionDAO = new SessionDAO();
		int result = sessionDAO.howmany(userID);
		String[][] temp = new String[result][2];
		String[][] show = new String[result][5];
		
		temp = sessionDAO.keyinfo(userID,result);
		%>
    				
		<%
		
		for(int i=0;i<result;i++){
			show[i] = sessionDAO.seeSession(temp[i][0],temp[i][1]);
		}
		%>
		
		
	<div class="card" style="width:60%; margin-left:2%; margin-bottom:2%; margin-top:2%;">
		<div class="card-header" style="margin-top:0;"><h2>세션</h2></div>
		<div class="card-body">
		<lu class="list-group">
		<% 
			for(int i=0;i<result;i++){
				String sessionName= show[i][1];
				String openTime = show[i][2];
				String closeTime = show[i][3];
				String sessionID = show[i][4];
		%>
			<li class="list-group-item" style="cursor:pointer; border: 1px solid lightgray; margin-bottom:10px; background-color:lightgray;" onclick="javascript: sessioninfo('<%=sessionName%>','<%=openTime%>','<%=closeTime%>','<%=sessionID%>')">
    			<%
  					int newComment = resultDAO.countComment1(sessionID, userID, "NEW");
     				if(newComment > 0){
     					%>
     					<h3><span style="float:right;" class="badge badge-pill badge-secondary">New Comments! <span class="badge badge-pill badge-success"><%=newComment%></span></span></h3>
     					<%
     				}
     			%>
    			<h4 class="list-group-item-heading" style="font-size : 25px;"><%= show[i][1] %> / <%=show[i][4] %></h4>
    			<h5 class="list-group-item-text" style="font-size : 20px;">시작 시간 : <%= show[i][2] %> <br> 종료 시간 : <%= show[i][3] %></h5>
    		</li>
		<% 
			}
		%>
		</lu>
		</div>

		<center>
			<i class="fas fa-plus-square fa-3x" style="margin-bottom:10px; cursor:pointer;" onclick="location.href='createSession.jsp'"></i>
		</center>
	</div>
		
		<%
		ProblemDAO problemDAO = new ProblemDAO();
		int result1 = problemDAO.howmany(userID);
		int temp1[] = new int[result1];
		String[][] show1 = new String[result1][7];
		
		temp1 = problemDAO.keyinfo(userID,result1);
		
		for(int i=0;i<result1;i++){
			show1[i] = problemDAO.seeproblem(temp1[i]);
		}
	%>

	
	<div class="card" style="width:60%; margin-left:2%; margin-bottom:2%;">
		<div class="card-header" style="margin-top:0; margin-bottom:20px;"><h2>문제 검색</h2></div>
		<div class="card-body">
		<div style="margin-bottom: 10px;">
		<input class="form-control my-0 py-1" id="listSearch" type="text" placeholder="Search" aria-label="Search">
		</div>
		<ul class="list-group" id="myList">
		<% 
			for(int i=result1-1;i>=0;i--){
			
		%>
			<li class="list-group-item" style="cursor:pointer; border: 1px solid lightgray;" onclick="javascript: probleminfo('<%= show1[i][2] %>','<%= show1[i][0] %>','<%= show1[i][3] %>')" >
    			<%= show1[i][2] %>
    		</li>
		<% 
			}
		%>
		</ul>
		<center>
			<i class="fas fa-plus-square fa-3x" style="margin-top:10px; cursor:pointer;" onclick="javascript:createProblem()"></i>
		</center>
		</div>
	</div>
	
	<script>
	
	$(document).ready(function(){
		  $("#listSearch").on("keyup", function() {
		    var value = $(this).val().toLowerCase();
		    $("#myList li").filter(function() {
		      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
		    });
		  });
		  
		  $('#nav').load("nav.jsp?userName=" + sessionStorage.getItem("userName"));
		});

	function sessioninfo(sessionName,openTime,closeTime,sessionID){
		var f = document.createElement("form");
		f.setAttribute("method","post");
		f.setAttribute("action","showSession.jsp");
		document.body.appendChild(f);
	
		var i = document.createElement("input");
		i.setAttribute("type","hidden");
		i.setAttribute("name","sessionName");
		i.setAttribute("value",sessionName);
		f.appendChild(i);
		
		var j = document.createElement("input");
		j.setAttribute("type","hidden");
		j.setAttribute("name","sessionID");
		j.setAttribute("value",sessionID);
		f.appendChild(j);
		
		var k = document.createElement("input");
		k.setAttribute("type","hidden");
		k.setAttribute("name","openTime");
		k.setAttribute("value",openTime);
		f.appendChild(k);
		
		var l = document.createElement("input");
		l.setAttribute("type","hidden");
		l.setAttribute("name","closeTime");
		l.setAttribute("value",closeTime);
		f.appendChild(l);
	
		var m = document.createElement("input");
         m.setAttribute("type","hidden");
         m.setAttribute("name","userID");
         m.setAttribute("value",sessionStorage.getItem("userID"));
         f.appendChild(m);
		
		f.submit();
	}
		
		function probleminfo(problemName,problemID, timeLimit){
			
			var f = document.createElement("form");
			f.setAttribute("method","post");
			f.setAttribute("action","showProblem.jsp");
			document.body.appendChild(f);
		
			var g = document.createElement("input");
			g.setAttribute("type","hidden");
			g.setAttribute("name","problemName");
			g.setAttribute("value",problemName);
			f.appendChild(g);
			
			var h = document.createElement("input");
			h.setAttribute("type","hidden");
			h.setAttribute("name","problemID");
			h.setAttribute("value",problemID);
			f.appendChild(h);
			
			var i = document.createElement("input");
			i.setAttribute("type","hidden");
			i.setAttribute("name","timeLimit");
			i.setAttribute("value",timeLimit);
			f.appendChild(i);
			
			f.submit();
		}

		function createProblem(){
			var f = document.createElement("form");
			f.setAttribute("method","post");
			f.setAttribute("action","createProblem.jsp");
			document.body.appendChild(f);
		
			var g = document.createElement("input");
			g.setAttribute("type","hidden");
			g.setAttribute("name","userID");
			g.setAttribute("value","<%=userID%>");
			f.appendChild(g);
			
			f.submit();
		}
	</script>

</body>
</html>
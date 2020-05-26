<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import="user.StudentDAO" %>
<%@ page import="user.SessionDAO" %>
<%@ page import="user.ResultDAO" %>
<%@page import="java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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
		if(sessionStorage.getItem("allowed")!="apply.jsp" && sessionStorage.getItem("allowed")!="studentPage.jsp" && sessionStorage.getItem("allowed")!="sendingPage.jsp" && sessionStorage.getItem("allowed")!="seeResult.jsp"){
			alert("잘못된 접근입니다.");
			history.back();
		}
		else{
			sessionStorage.setItem("allowed", "applySession.jsp");
		}
	</script>

<script>
	function showProblemInfo(problemID){
		$.ajax({
			url : "upload/problem/" + problemID + "/problemContent.txt",
	       	dataType: "text",
	       	success : function (data) {
	       		document.getElementById('problemInfo' + problemID).innerHTML = "Problem Contents: " + data;
	       	}
	   	}); 
	}
</script>

<%	
	String userID = request.getParameter("userID");	
	String sessionID = request.getParameter("sessionID");
	String state = request.getParameter("state");

	String sessionInfo[] = new String[5];

	sessionInfo[0] = request.getParameter("professorID");
	sessionInfo[1] = request.getParameter("sessionName");
	sessionInfo[2] = request.getParameter("openTime");
	sessionInfo[3] = request.getParameter("closeTime");
	sessionInfo[4] = request.getParameter("sessionID");
	String uploadPath = request.getSession().getServletContext().getRealPath("/upload") + '/' + request.getParameter("userID") + '/' + sessionInfo[4];
	
	File f = new File(uploadPath);
	if(!f.exists()){
		f.mkdirs();
	}
%>

	<div id="nav" name="nav">
	</div>

<% 		
		SessionDAO sessionDAO = new SessionDAO();
		ResultDAO resultDAO = new ResultDAO();
		
		int result1 = sessionDAO.howmany2(sessionInfo[0],sessionInfo[1]);
		int temp[] = new int[result1];
		String[][] show = new String[result1][6];
		
		temp = sessionDAO.keyinfo2(sessionInfo[0],sessionInfo[1],result1);
		
		for(int i=0;i<result1;i++){
			show[i] = sessionDAO.seeproblem(temp[i]);
		}
	%>
	
	<div class="card" style="width:70%;margin-left:2%; margin-bottom:2%; margin-top:2%;">
		<div class="jumbotron">
			<h1><%=sessionInfo[1] %></h1>
  			<h3>SessionID : <%=sessionInfo[4] %></h3>
  			<h3>Session Available : <%= sessionInfo[2] %> ~ <%= sessionInfo[3] %></h3>
  		  	<button type="button" class="btn btn-primary" onclick="studentPage();">돌아가기</button>
		</div>

	<div class="card">
	<div class="card-header">
	<span class="label label-info" style="display: block; width:100px; height:50px; font-size: 15px; line-height:50px;">문제 리스트</span>
	</div>
	<div class="card-body">
		<div class="list-group">
		<% 
			for(int i=0;i<result1;i++){
				int check = sessionDAO.checkResult(userID,sessionID,show[i][0],"correct");
				String correct = "미완료";
				if(check == 1){
					correct = "완료";
				}
				int check2 = sessionDAO.existResult(userID,sessionID,show[i][0]);
		%>
			<a class="list-group-item" style="border: 1px solid lightgray; margin-bottom:10px; background-color:lightgray;">
			<h4 class="list-group-item-heading" style="font-size : 25px;"> Problem Name : <%= show[i][2] %> / 진행 상황 : <%=correct%></h4>
			<% 
    			if(state.equals("right") && show[i][5].equals("single")){
    		%>
    			<button type="button" class="btn btn-primary" onclick="sendInfo(<%=show[i][0]%>, '<%=show[i][2]%>', <%=show[i][3]%>);">
  					문제 풀기 <i class="fas fa-arrow-right"></i>
				</button>
			<% 
    			}
			%>
			
			<% 
    			if(state.equals("right") && show[i][5].equals("multi")){
    		%>
    			<button type="button" class="btn btn-primary" onclick="sendInfo2(<%=show[i][0]%>, '<%=show[i][2]%>', <%=show[i][3]%>);">
  					문제 풀기 <i class="fas fa-arrow-right"></i>
				</button>
			<% 
    			}
			%>
				<%
					if(check2 == 1){
						%>
						<button type="button" class="btn btn-primary" onclick="seeResult(<%=show[i][0]%>);">
  							제출한 코드 보기<i class="fas fa-arrow-right"></i>
						</button>
  					<%
  						int newComment = resultDAO.countComment2(sessionID, show[i][0], userID, "new");
     					if(newComment > 0){
     					%>
     						<span class="badge badge-pill badge-success"><%=newComment%></span>
     					<%
     					}
					}
				%>
    		</a>
			<br>
		<% 
			}
		%>
		</div>
	</div>
	</div>
	</div>
	
	<script>
	$('#nav').load("nav.jsp?userName=" + sessionStorage.getItem("userName"));
	
	function sendInfo(problemID, problemName, timeLimit){
		
		var f = document.createElement("form");
		f.setAttribute("method","post");
		f.setAttribute("action","sendingPage.jsp");
		document.body.appendChild(f);
	
		var i = document.createElement("input");
		i.setAttribute("type","hidden");
		i.setAttribute("name","problemID");
		i.setAttribute("value",problemID);
		f.appendChild(i);
		
		var j = document.createElement("input");
		j.setAttribute("type","hidden");
		j.setAttribute("name","problemName");
		j.setAttribute("value",problemName);
		f.appendChild(j);
		
		var k = document.createElement("input");
		k.setAttribute("type","hidden");
		k.setAttribute("name","timeLimit");
		k.setAttribute("value",timeLimit);
		f.appendChild(k);
		
		var l = document.createElement("input");
		l.setAttribute("type","hidden");
		l.setAttribute("name","sessionID");
		l.setAttribute("value","<%=sessionInfo[4]%>");
		f.appendChild(l);
		
		var m = document.createElement("input");
		m.setAttribute("type","hidden");
		m.setAttribute("name","userID");
		m.setAttribute("value",sessionStorage.getItem("userID"));
		f.appendChild(m);
		
		f.submit();
	}
	
	function sendInfo2(problemID, problemName, timeLimit){
		var f = document.createElement("form");
		f.setAttribute("method","post");
		f.setAttribute("action","multiSendingPage.jsp");
		document.body.appendChild(f);
	
		var i = document.createElement("input");
		i.setAttribute("type","hidden");
		i.setAttribute("name","problemID");
		i.setAttribute("value",problemID);
		f.appendChild(i);
		
		var j = document.createElement("input");
		j.setAttribute("type","hidden");
		j.setAttribute("name","problemName");
		j.setAttribute("value",problemName);
		f.appendChild(j);
		
		var k = document.createElement("input");
		k.setAttribute("type","hidden");
		k.setAttribute("name","timeLimit");
		k.setAttribute("value",timeLimit);
		f.appendChild(k);
		
		var l = document.createElement("input");
		l.setAttribute("type","hidden");
		l.setAttribute("name","sessionID");
		l.setAttribute("value","<%=sessionInfo[4]%>");
		f.appendChild(l);
		
		var m = document.createElement("input");
		m.setAttribute("type","hidden");
		m.setAttribute("name","userID");
		m.setAttribute("value",sessionStorage.getItem("userID"));
		f.appendChild(m);
		
		var o = document.createElement("input");
        o.setAttribute("type","hidden");
        o.setAttribute("name","state");
        o.setAttribute("value","<%=state%>");
        f.appendChild(o);
		
		f.submit();
	}
	
	function seeResult(problemID){
		var f = document.createElement("form");
		f.setAttribute("method","post");
		f.setAttribute("action","seeResult.jsp");
		document.body.appendChild(f);
	
		var i = document.createElement("input");
		i.setAttribute("type","hidden");
		i.setAttribute("name","problemID");
		i.setAttribute("value",problemID);
		f.appendChild(i);
		
		var l = document.createElement("input");
		l.setAttribute("type","hidden");
		l.setAttribute("name","sessionID");
		l.setAttribute("value","<%=sessionInfo[4]%>");
		f.appendChild(l);
		
		var m = document.createElement("input");
		m.setAttribute("type","hidden");
		m.setAttribute("name","userID");
		m.setAttribute("value",sessionStorage.getItem("userID"));
		f.appendChild(m);
		
		var n = document.createElement("input");
		n.setAttribute("type","hidden");
		n.setAttribute("name","testID");
		n.setAttribute("value",sessionStorage.getItem("userID"));
		f.appendChild(n);
		
		var o = document.createElement("input");
        o.setAttribute("type","hidden");
        o.setAttribute("name","state");
        o.setAttribute("value","<%=state%>");
        f.appendChild(o);
		
		f.submit();
	}
	
	function studentPage(){
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
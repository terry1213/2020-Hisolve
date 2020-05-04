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
		if(sessionStorage.getItem("allowed")!="showSession.jsp" && sessionStorage.getItem("allowed")!="addProblem.jsp" && sessionStorage.getItem("allowed")!="showProblem.jsp"){
			alert("잘못된 접근입니다.");
			history.back();
		}
		else{
			sessionStorage.setItem("allowed", "addProblem.jsp");
		}
	</script>

	<div id="nav" name="nav">
	</div>
		<%
		String userID = request.getParameter("userID");
		String sessionName = request.getParameter("sessionName");
		String openTime = request.getParameter("openTime");
		String closeTime = request.getParameter("closeTime");
		String sessionID = request.getParameter("sessionID");
		
		SessionDAO sessionDAO = new SessionDAO();
		ProblemDAO problemDAO = new ProblemDAO();
		int result = problemDAO.howmany(userID);
		int temp[] = new int[result];
		String[][] show = new String[result][7];
		
		temp = problemDAO.keyinfo(userID,result);
		
		for(int i=0;i<result;i++){
			show[i] = problemDAO.seeproblem(temp[i]);
		}
	%>

	
	<div class="card" style="width:60%; margin-left:2%; margin-top:2%;">
		<div class="card-header"><h2>문제 추가하기</h2></div>
		<div class="card-body">
		<input class="form-control my-0 py-1" id="listSearch" type="text" placeholder="Search" aria-label="Search">
		<br>
		<ul class="list-group" id="problemList">
		<% 
			for(int i=0;i<result;i++){
			int result1 = sessionDAO.checkProblem(userID, sessionName, Integer.parseInt(show[i][0]));
			if(result1 == 1){
				continue;
			}
		%>
			<li class="list-group-item" style="cursor:pointer; border: 1px solid lightgray;">
    			<%= show[i][2] %>
    			<i class="fas fa-plus-square fa-2x" style="float:right; cursor:pointer; margin-left:10px;" onclick="javascript:addProblemAction('<%=show[i][0]%>')"></i>
    			<i class="fas fa-search-plus fa-2x" style="float:right; cursor:pointer;" onclick="javascript:probleminfo('<%= show[i][2] %>','<%= show[i][0] %>','<%= show[i][3]%>')"></i>
    		</li>
		<% 
			}
		%>
		</ul>
		<br>
		<button type="button" class="btn btn-primary" onclick="tossback()">세션 페이지로 돌아가기</button>
		</div>
	</div>
	
	
	<script>
	
	$(document).ready(function(){
		$('#nav').load("nav.jsp?userName=" + sessionStorage.getItem("userName"));
		
		  $("#listSearch").on("keyup", function() {
		    var value = $(this).val().toLowerCase();
		    $("#problemList li").filter(function() {
		      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
		    });
		  });
		});
	
		
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
	
	function tossback(problemName,problemID, timeLimit){
		
		var f = document.createElement("form");
		f.setAttribute("method","post");
		f.setAttribute("action","showSession.jsp");
		document.body.appendChild(f);
		
		var g = document.createElement("input");
		g.setAttribute("type","hidden");
		g.setAttribute("name","userID");
		g.setAttribute("value","<%=userID%>");
		f.appendChild(g);
			
		var h = document.createElement("input");
		h.setAttribute("type","hidden");
		h.setAttribute("name","sessionID");
		h.setAttribute("value","<%=sessionID%>");
		f.appendChild(h);
			
		var i = document.createElement("input");
		i.setAttribute("type","hidden");
		i.setAttribute("name","sessionName");
		i.setAttribute("value","<%=sessionName%>");
		f.appendChild(i);
			
		var j = document.createElement("input");
		j.setAttribute("type","hidden");
		j.setAttribute("name","openTime");
		j.setAttribute("value","<%=openTime%>");
		f.appendChild(j);
		
		var k = document.createElement("input");
		k.setAttribute("type","hidden");
		k.setAttribute("name","closeTime");
		k.setAttribute("value","<%=closeTime%>");
		f.appendChild(k);
		
		f.submit();
	}
	
	function addProblemAction(problemID){
		$.ajax({
	    	url:'addProblemAction.jsp',
	    	dataType:'text',
	    	type:'POST',
	    	data:{'problemID':problemID, 'sessionName':'<%=sessionName%>', 'userID': sessionStorage.getItem("userID")},
	    	success : function(data){
	    		alert(data);
	    		location.reload();
        		/* $("#problemList").load(document.URL + " #problemList"); */
	        },
	    	error : function(request,status,error){
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	    	}
		});
	}
	</script>

</body>
</html>
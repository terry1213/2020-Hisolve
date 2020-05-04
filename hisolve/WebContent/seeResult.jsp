<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import= "java.io.*"%>
<%@ page import="user.ResultDAO" %>
<%@ page import="user.ProblemDAO" %>
<%@ page import="user.UserDAO" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%
	String userID = request.getParameter("userID");
	String testID = request.getParameter("testID");
	String sessionID = request.getParameter("sessionID");
	String problemID = request.getParameter("problemID");
	
	ResultDAO resultDAO = new ResultDAO();
	ProblemDAO problemDAO = new ProblemDAO();
	UserDAO userDAO = new UserDAO();
	
	String problemInfo[] = new String[4];
	problemInfo = problemDAO.seeproblem(Integer.parseInt(problemID));
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
<% 		

		int result = resultDAO.howmany(testID, sessionID, problemID);
		int temp[] = new int[result];
		String[][] show = new String[result][6];
		
		temp = resultDAO.keyinfo(testID, sessionID, problemID, result);
		
		for(int i=0;i<result;i++){
			show[i] = resultDAO.seeResult(temp[i]);
		}
	%>
	<script>
		if(sessionStorage.getItem("allowed")!="applySession.jsp" && sessionStorage.getItem("allowed")!="showSession.jsp" && sessionStorage.getItem("allowed")!="seeCode.jsp"){
			alert("잘못된 접근입니다.");
			history.back();
		}
		else{
			sessionStorage.setItem("allowed", "seeResult.jsp");
		}
	</script>

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	
	<div id="nav" name="nav">
	</div>
	
	<div class="card" style="width:60%;margin-left:2%; margin-bottom:2%; margin-top:2%;">
		<div class="card-header">
		<h3 style="margin-top:0;"><%=testID%> 님의 제출 기록</h3>
		</div>
		
		<div class="card-body">
		
			<div class="form-check form-check-inline">
  				<input class="form-check-input" type="radio" name="inlineRadioOptions" id="all" value="all" onclick="allOf();" checked>
  				<label class="form-check-label" for="all">전체</label>
			</div>
			<div class="form-check form-check-inline">
  				<input class="form-check-input" type="radio" name="inlineRadioOptions" id="correct" value="correct" onclick="correct();">
  				<label class="form-check-label" for="correct">정답</label>
			</div>
			<div class="form-check form-check-inline">
  				<input class="form-check-input" type="radio" name="inlineRadioOptions" id="wrong" value="wrong" onclick="wrong();">
  				<label class="form-check-label" for="wrong">오답</label>
			</div>
			<div class="form-check form-check-inline">
  				<input class="form-check-input" type="radio" name="inlineRadioOptions" id="compile" value="compile" onclick="compile();">
  				<label class="form-check-label" for="compile">컴파일 에러</label>
			</div>
		
  			<table class="table table-bordered" id="resultList">
  				<thead>
  					<tr>
  						<th scope="col">채점 번호</th>
      					<th scope="col">최종 결과</th>
      					<th scope="col">제출 시간</th>
  					</tr>
  				</thead>
  				<tbody id="result">
  				<%
  				for(int i=result - 1;i>=0;i--){
  				%>
  					<tr>
  						<td style="width:20%;"><%=i+1%></td>
     					<%
     					if(show[i][5].equals("correct")){
     						%>
     						<td style="cursor:pointer; color:blue; width:40%;" onclick="seeCode('<%=show[i][0]%>');">정답입니다.
     						<%
     					}
     					else{
     						%>
     						<td style="cursor:pointer; color:red; width:40%;" onclick="seeCode('<%=show[i][0]%>');">
     						<%if(show[i][5].equals("wrong")){
     							%>
     							틀렸습니다.
     							<%
     						}else if(show[i][5].equals("compile")){
     							%>
     							컴파일 에러.
     							<%
     						}
     						%>
     						<%
     					}
     					int newComment = resultDAO.countComment3(sessionID, problemID, show[i][0], userID, "NEW");
     					if(newComment > 0){
     						%>
     						<span class="badge badge-pill badge-success"><%=newComment%></span>
     						<%
     					}
     					%>
     					</td>
     					<td><%=resultDAO.seeResultTime(show[i][0])%></td>
  					</tr>
  				<%
  				}
  				%>
  				</tbody>
 			</table>
 			<div class='pagination-container'>
 				<nav>
 					<ul class="pagination">
 						<li id="prev" class="page-item"><a class="page-link">Previous</a></li>
 						<li id="next" class="page-item"><a class="page-link">Next</a></li>
 					</ul>
 				</nav>
			</div>
 			<button onclick="history.back();" class="btn btn-primary">돌아가기</button>
  		</div>
	</div>

	<script>
	$('#nav').load("nav.jsp?userName=" + sessionStorage.getItem("userName"));
	getPagination("");
	var condition = "";
	var currentPage = 1;
	
	function seeCode(resultID){
		var f = document.createElement("form");
		f.setAttribute("method","post");
		f.setAttribute("action","seeCode.jsp");
		document.body.appendChild(f);
	
		var i = document.createElement("input");
		i.setAttribute("type","hidden");
		i.setAttribute("name","problemID");
		i.setAttribute("value","<%=problemID%>");
		f.appendChild(i);
		
		var l = document.createElement("input");
		l.setAttribute("type","hidden");
		l.setAttribute("name","sessionID");
		l.setAttribute("value","<%=sessionID%>");
		f.appendChild(l);
		
		var m = document.createElement("input");
		m.setAttribute("type","hidden");
		m.setAttribute("name","userID");
		m.setAttribute("value","<%=userID%>");
		f.appendChild(m);
		
		var n = document.createElement("input");
		n.setAttribute("type","hidden");
		n.setAttribute("name","resultID");
		n.setAttribute("value",resultID);
		f.appendChild(n);
		
		var o = document.createElement("input");
		o.setAttribute("type","hidden");
		o.setAttribute("name","testID");
		o.setAttribute("value","<%=testID%>");
		f.appendChild(o);
		
		f.submit();
	}
	
	function allOf(){
		$("#result tr").filter(function() {
		      $(this).toggle(true);
		});
		getPagination("");
	}
	
	function correct(){
	    $("#result tr").filter(function() {
		      $(this).toggle($(this).text().toLowerCase().indexOf("정답입니다.") > -1);
		});
	    getPagination("정답입니다.");
	}
	
	function wrong(){
	    $("#result tr").filter(function() {
		      $(this).toggle($(this).text().toLowerCase().indexOf("틀렸습니다.") > -1);
		});
	    getPagination("틀렸습니다.");
	}
	
	function compile(){
	    $("#result tr").filter(function() {
		      $(this).toggle($(this).text().toLowerCase().indexOf("컴파일 에러.") > -1);
		});
	    getPagination("컴파일 에러.");
	}
	
	function getPagination(state){
		currentPage = 1;
  		$('.pagination li').each(function () { 
 			var page = this.id;
			if(page != "prev" && page != "next"){
				this.remove();
			}
		});
		
		condition = state;
		var table = '#resultList';
		var maxRows = 10;
		var trnum = 0;
		var totalRows = 0;
	    $(table + ' tr:gt(0)').each(function() {
	    	if($(this).text().toLowerCase().indexOf(condition) > -1){
		    	trnum++;
		        if (trnum > maxRows) {
		          $(this).hide();
		        }
		        if (trnum <= maxRows) {
		          $(this).show();
		        }
	    	}
	    });
	    totalRows = trnum;
	    
        $('.pagination #next')
        .before(
          '<li id="1" class="page-item"><a class="page-link">1</a></li>'
        )
        
	    if (totalRows > maxRows) {
	        var pagenum = Math.ceil(totalRows / maxRows);
	        for (var i = 2; i <= pagenum; ) {
	          $('.pagination #next')
	            .before(
	              '<li id="' +
	                i +
	                '" class="page-item"><a class="page-link">' +
	                (i++) +
	                '</a></li>'
	            )
	        }
	      }
	      
	      $('.pagination #1').addClass('active');
	      $('.pagination li').on('click', function(evt) {
	        evt.stopImmediatePropagation();
	        evt.preventDefault();
	        var pageNum = this.id;
	        var maxRows = 10;
	        
	        if (pageNum == 'prev') {
	          if (currentPage == 1) {
	            return;
	          }
	          pageNum = --currentPage;
	        }
	        if (pageNum == 'next') {
	          if (currentPage == $('.pagination li').length - 2) {
	            return;
	          }
	          pageNum = ++currentPage;
	        }

	        currentPage = pageNum;
	        var trIndex = 0;
	        $('.pagination li').removeClass('active');
	        $('.pagination #' + currentPage).addClass('active');
	        $(table + ' tr:gt(0)').each(function() {
		    	if($(this).text().toLowerCase().indexOf(condition) > -1){
			          trIndex++;
			          if (
			            trIndex > maxRows * pageNum ||
			            trIndex <= maxRows * pageNum - maxRows
			          ) {
			            $(this).hide();
			          } else {
			            $(this).show();
			          }
		    	}
	        });
	      });
	}
	
	</script>
	
</body>
</html>
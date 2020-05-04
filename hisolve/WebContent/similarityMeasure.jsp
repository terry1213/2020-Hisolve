<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import= "java.io.*"%>
<%@ page import="user.ResultDAO" %>
<%@ page import="user.SessionDAO" %>
<%@ page import="user.ProblemDAO" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%
	String userID = request.getParameter("userID");
	String sessionName = request.getParameter("sessionName");
	String sessionID = request.getParameter("sessionID");
	
	ResultDAO resultDAO = new ResultDAO();
	SessionDAO sessionDAO = new SessionDAO();
	ProblemDAO problemDAO = new ProblemDAO();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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
<!-- <script src="https://codemirror.net/addon/search/jump-to-line.js"></script>
<script src="https://codemirror.net/addon/dialog/dialog.js"></script> -->
<!-- <script src="https://codemirror.net/addon/search/match-highlighter.js"></script>
<script src="https://codemirror.net/addon/selection/mark-selection.js"></script> -->
<!-- <link rel="stylesheet" type="text/css" href="http://lti.cs.vt.edu/OpenDSA/lib/CodeMirror-5.5.0/addon/dialog/dialog.css"> -->

</head>
<body>
	<script>
		if(sessionStorage.getItem("allowed")!="showSession.jsp"){
			alert("잘못된 접근입니다.");
			history.back();
		}
		else{
			sessionStorage.setItem("allowed", "seeResult.jsp");
		}
	</script>
	
	<div id="nav" name="nav">
	</div>
	
	<%
	int result1 = sessionDAO.howmany2(userID,sessionName);
	int temp1[] = new int[result1];
	temp1 = sessionDAO.keyinfo2(userID,sessionName,result1);
	String[][] show1 = new String[result1][4];
	
	int result2 = sessionDAO.howmany4(userID,sessionName);
	String[] temp2 = new String[result2];
	temp2 = sessionDAO.seeStudent(userID,sessionName,result2);
	
	for(int i=0;i<result1;i++){
		show1[i] = sessionDAO.seeproblem(temp1[i]);
	}
	%>
	
	<div class="card" style="width:40%; max-height: 900px; overflow:auto; margin-left:2%; margin-bottom:2%; margin-top:2%; float:left;">
		<div class="card-header">
		<nav class="navbar navbar-expand-lg navbar-light bg-light">
  			<a class="navbar-brand"><strong><%=sessionName%></strong></a>
  			<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
    			<span class="navbar-toggler-icon"></span>
  			</button>
  			
  			<div class="collapse navbar-collapse" id="navbarSupportedContent">
    			<ul class="navbar-nav mr-auto">
      			<li class="nav-item dropdown">
        			<a class="nav-link dropdown-toggle" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          			문제 선택
        			</a>
        			<div class="dropdown-menu" aria-labelledby="navbarDropdown">
        				<% 
  							for(int i=0;i<result1;i++){
  								
  						%>
      					<a class="dropdown-item" onclick="showList('<%=show1[i][0]%>')"><%= show1[i][2] %></a>
      					<%
  							}
  	      				%>
        			</div>
      			</li>
    			</ul>
    			<div id="searchDiv" style="width:60%; display:none;">
    				<input id="searchWord" style="width:65%; float:left;" class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search">
      				<button style="width:30%; float:left;" class="btn btn-outline-success my-2 my-sm-0" onclick="searchWord();">Search</button>
    			</div>
  			</div>
		</nav>
		</div>
		
		<div class="card-body">
		
  			<table class="table table-bordered" id="resultList">
  				<thead>
  					<tr>
  						<th scope="col" style="width:10%;">#</th>
  						<th scope="col" style="width:30%;">아이디</th>
  						<th scope="col" style="width:40%;">문제</th>
  						<th scope="col" style="width:20%;">더보기</th>
  					</tr>
  				</thead>
  				<% 
  				for(int i=0;i<result1;i++){//문제
  				%>
  				<tbody id="<%=show1[i][0]%>">
  					<%
  					for(int j=0;j<result2;j++){//아이디
  					%>

  							<tr id="hd" class="<%=temp2[j]%>">
  								<td><%=j+1%></td>
  								<td><%=temp2[j]%></td>
  								<td><%=show1[i][2]%></td>
  								<td id="<%=temp2[j]%>_updown">
  									<i id="down" class="fas fa-angle-down fa-2x" onclick="down('<%=show1[i][0]%>', '<%=temp2[j]%>');"></i>
  									<i id="up" class="fas fa-angle-up fa-2x" style="display:none" onclick="up('<%=show1[i][0]%>', '<%=temp2[j]%>');"></i>
  								</td>
  							</tr>

  							<tr id="<%=temp2[j]%>">
  								<td></td>
  								<td><strong>최종 결과</strong></td>
  								<td><strong>제출 시간</strong></td>
  								<td><strong>선택</strong></td>
  							</tr>
  							<% 		

							int result3 = resultDAO.howmany(temp2[j], sessionID, show1[i][0]);
							int temp3[] = new int[result3];
							String[][] show3 = new String[result3][6];
		
							temp3 = resultDAO.keyinfo(temp2[j], sessionID, show1[i][0], result3);
		
							for(int k=0;k<result3;k++){
								show3[k] = resultDAO.seeResult(temp3[k]);
							}
					
  							for(int l=result3 - 1;l>=0;l--){
  							%>
							<tr id="<%=temp2[j]%>">
								<td id="code"><textarea id="code_<%=show3[l][0]%>" style="display:none;"><%=show3[l][4]%></textarea></td>
							<%
     						if(show3[l][5].equals("correct")){
     							%>
     							<td style="color:blue;">정답입니다.
     							<%
     						}
     						else{
     							%>
     							<td style="color:red;">
     							<%if(show3[l][5].equals("wrong")){
     								%>
     								틀렸습니다.
     								<%
     							}else if(show3[l][5].equals("compile")){
     								%>
     								컴파일 에러.
     								<%
     							}
     							%>
     							<%
     						}
     						%>
     							</td>
     							<td><%=resultDAO.seeResultTime(show3[l][0])%></td>
  								<td><center><input type="checkbox" class="form-check-input" id="<%=show3[l][0]%>"></center></td>
  							</tr>
  							<%
  							}
  							%>
  					<%
  					}
  					%>
  					
  				</tbody>
      			<%
  				}
  	      		%>
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
	
	<div style="width: 50%; float:left; margin-left: 5%; margin-top:2%;">
		<div class="card">
			<div class="card-header">
				<div style="width:40%; float:left; margin-top:10px;"><h5 id="editor1_header">선택해주세요.</h5></div>
				<div id="searchDiv1" style="width:50%; display:none; float:right;">
    				<input id="searchWord1" style="width:65%; float:left;" class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search">
      				<button style="width:30%; float:left;" class="btn btn-outline-success my-2 my-sm-0" onclick="highlight(0);">Search</button>
    			</div>
			</div>
			<div class="card-body">
				<div style="height:350px; overflow: auto;">
					<textarea id="editor1"></textarea>
				</div>
			</div>
		</div>
		
		<div class="card">
			<div class="card-header">
				<div style="width:40%; float:left; margin-top:10px;"><h5 id="editor2_header">선택해주세요.</h5></div>
				<div id="searchDiv2" style="width:50%; display:none; float:right;">
    				<input id="searchWord2" style="width:65%; float:left;" class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search">
      				<button style="width:30%; float:left;" class="btn btn-outline-success my-2 my-sm-0" onclick="highlight(1);">Search</button>
    			</div>
			</div>
			<div class="card-body">
				<div style="height:350px; overflow: auto;">
					<textarea id="editor2"></textarea>
				</div>
			</div>
		</div>
	</div>
	
	<script>
	var editor = [editor("#editor1"), editor("#editor2")];
	$('#nav').load("nav.jsp?userName=" + sessionStorage.getItem("userName"));
	$('#resultList tbody').hide();
	
	var editor_use = [-1, -1];
	var editor_use_num = 0;
	var search = "";
	var problem = "";
	var word = ["", ""];
	
	$(document).ready(function() {
		
		$("input:checkbox").on('click', function() {
			if ( $(this).prop('checked') ) {
				if(editor_use_num == 2){
					$(this).prop('checked', false);
				}
				else{
					for(var i = 0; i < 2; i++){
						if(editor_use[i] == -1){
							editor[i].getDoc().setValue($("#code_" + $(this).attr('id')).val());
							editor_use[i] = $(this).attr('id');
							$("#editor" + (i+1) + "_header").text($(this).parent().parent().parent().attr('id'));
							editor_use_num++;
							$('#searchDiv' + (i+1)).show();
							$('#searchWord' + (i+1)).val(search);
							highlight(i);
							break;
						}
					}
				}
			}
			else{
				for(var i = 0; i < 2; i++){
					if(editor_use[i] == $(this).attr('id')){
						editor[i].getDoc().setValue("");
						editor_use[i] = -1;
						$("#editor" + (i+1) + "_header").text("선택해주세요.");
						editor_use_num--;
						$('#searchDiv' + (i+1)).hide();
						break;
					}
				}
			}
		});
	});

	
	getPagination("");
	var condition = "";
	var currentPage = 1;
	
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
	    	if($(this).attr('id') == "hd"){
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
	
	function showList(problemID){
		eraseEditor();
		$("#searchWord").val("");
		search = "";
		problem = problemID;
		$('#resultList tbody').hide();
		$('#resultList #' + problemID).show();
		$('#resultList #' + problemID + ' tr').hide();
		$('#resultList #' + problemID + ' #hd').show();
		$('#searchDiv').show();
	}
	
	function searchWord(){
		search = $("#searchWord").val();
		searchWordShow();
	}
	
	function searchWordShow(){
		eraseEditor();
		$('#resultList tbody').hide();
		$('#resultList tbody tr').hide();
		$('#resultList tbody tr #up').hide();
		$('#resultList tbody tr #down').show();
        $('#' + problem + ' #code textarea').each(function() {
	    	if($(this).val().toLowerCase().indexOf(search) > -1){
	    		$(this).closest("tbody").show();
	    		$(this).closest("tbody").children("." + $(this).closest("tr").attr('id')).show();
	    	}
        });
	}
	
	function up(problemID, userID){
		$('#' + problemID + ' #' + userID).hide();
		$('#' + problemID +  ' #' + userID + '_updown #up').hide();
		$('#' + problemID + ' #' + userID + '_updown #down').show();
	}
	
	function down(problemID, userID){
		$('#resultList #' + problemID + ' #' + userID).show();
	    $('#resultList #' + problemID + ' #' + userID + ' textarea').each(function() {
	    	if($(this).val().toLowerCase().indexOf(search) == -1){
	    		$(this).closest(' #' + userID).hide();
	    	}
	    });
		$('#' + problemID +  ' #' + userID + '_updown #up').show();
		$('#' + problemID + ' #' + userID + '_updown #down').hide();
	}
	
	function highlight(i){
		if(word[i] != ""){
			actualHighlight(i, word[i], "background-color : transparent");
		}
		word[i] = $('#searchWord' + (i+1)).val();
		actualHighlight(i, word[i], "background-color : yellow");
	}
	
	function actualHighlight(i, keyword, cssSentence){
	    var cursor = editor[i].getSearchCursor(keyword);
	    var first, from, to;
	    while (cursor.findNext()) {
	        from = cursor.from();
	        to = cursor.to();
	        editor[i].markText(from, to, {
	        	css: cssSentence
	        });
	        if (first === undefined) {
	            first = from;
	        }
	    }
	    if (first) {
	        editor[i].scrollIntoView(first);
	    }
	}
	
	function eraseEditor(){
		for(var i = 0; i < 2; i++){
			if(editor_use[i] != -1){
				$('#resultList tbody tr #' + editor_use[i]).prop('checked', false);
				editor[i].getDoc().setValue("");
				editor_use[i] = -1;
				$("#editor" + (i+1) + "_header").text("선택해주세요.");
				editor_use_num--;
				word[i] = "";
				$('#searchDiv' + (i+1)).hide();
			}
		}
	}
	</script>
	
</body>
</html>
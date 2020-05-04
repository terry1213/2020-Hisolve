<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import= "java.io.*"%>
<%@ page import="user.ResultDAO" %>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
<%
	String userID = request.getParameter("userID");
	String sessionID = request.getParameter("sessionID");
	String problemID = request.getParameter("problemID");
	String resultID = request.getParameter("resultID");
	
	ResultDAO resultDAO = new ResultDAO();
	
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
<script>
$(document).ready(function(){
	$('a').each(function() {
        var txt = $(this).text().replace(/</g, "&lt;");
        txt = txt.replace(/>/g, "&gt;");
        txt = txt.replace(/(\n|\r\n)/g, '</br>');
        txt = txt.replace( /@\d+/g, function (x) {
        	  return '<a style="cursor:pointer; color:blue; background-color:lightblue; border-radius: 3px;" onclick="lineTag(' + x.slice(1) + ')" >' + x + '</a>';
        	});
        $(this).html(txt);
    });
});
</script>
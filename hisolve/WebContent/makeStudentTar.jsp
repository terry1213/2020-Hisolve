<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import= "java.io.*"%>
<%@ page import= "java.util.Arrays"%>
<%
	String uploadPath = request.getParameter("uploadPath");
	String testPath = request.getParameter("testPath");
	String finalFileName = "sampleProgram.tar";
	String temp = "";
	
	int listsize=0;
	
	File dir = new File(uploadPath);
	File[] fileList = dir.listFiles();
	String[] nameList = new String[fileList.length];
	   
	for(int i = 0 ; i < fileList.length ; i++){
		File file = fileList[i];
		if(file.isFile()){
			String str = file.getName();
			if(!str.substring(str.length()-4,str.length()).equals(".tar") && !str.equals("problemContent.txt")){
				nameList[listsize] = str;
				listsize++;
			}
		}
	}
	
	Runtime rt = Runtime.getRuntime();
	Process p;
	
	for(int i=0;i<nameList.length;i++){
    	temp += " ";
    	temp += nameList[i];
    }
    String[] shell = {"/bin/sh", "-c", "cd " + uploadPath + " ; tar -cvf finalProgram.tar" + temp};
    p = rt.exec(shell);
    p.waitFor();
	
	
	
    /* Process p = rt.exec("rm -r "+uploadPath+"/sampleProgram.tar");
    p.waitFor();
    for(int i=0;i<fileList.length;i++){
    	temp += " ";
    	temp += fileList[i];
    }
    String[] shell = {"/bin/sh", "-c", "cd " + uploadPath + " ; tar -cvf sampleProgram.tar" + temp};
    p = rt.exec(shell);
    p.waitFor();*/
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import= "java.io.*"%>
<%
	String uploadPath = request.getParameter("uploadPath");
	String finalFileName = "sampleProgram.tar";
	String temp = "";
	
	File path = new File(uploadPath);

	String fList1[] = path.list(new FilenameFilter() {

	@Override
	public boolean accept(File dir, String name) {
        return name.endsWith(".c");
	}

	});

	String fList2[] = path.list(new FilenameFilter() {
	@Override
	public boolean accept(File dir, String name) {
        return name.endsWith(".h");
	}
	});

	String[] fileList = new String[fList1.length + fList2.length];
	System.arraycopy(fList1,0,fileList,0,fList1.length);
	System.arraycopy(fList2,0,fileList,fList1.length,fList2.length);
	
	Runtime rt = Runtime.getRuntime();
	
    Process p = rt.exec("rm -r "+uploadPath+"/sampleProgram.tar");
    p.waitFor();
    for(int i=0;i<fileList.length;i++){
    	temp += " ";
    	temp += fileList[i];
    }
    String[] shell = {"/bin/sh", "-c", "cd " + uploadPath + " ; tar -cvf sampleProgram.tar" + temp};
    p = rt.exec(shell);
    p.waitFor();
%>
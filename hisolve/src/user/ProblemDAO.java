package user;

import java.sql.*;
import java.util.ArrayList;
import java.util.Calendar;

public class ProblemDAO {
   private Connection conn;
   private PreparedStatement pstmt;
   private ResultSet rs;
   
   public ProblemDAO() {
      try {
    	 String dbURL = "jdbc:mysql://localhost:3306/FALCON?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC&characterEncoding=utf8";
         String dbID = "falcon";
         String dbPassword="falcon";
         Class.forName("com.mysql.cj.jdbc.Driver");
         conn = DriverManager.getConnection(dbURL,dbID,dbPassword);
      } catch (Exception e) {
         e.printStackTrace();
      }
   }
   
   public int insertProblem(String userID, String problemName, String timeLimit, String problemContent, String type) {
	      String SQL = "INSERT INTO PROBLEM(userID, problemName, timeLimit, problemContent, type) VALUES(?,?,?,?,?)";
	      try {
	         pstmt = conn.prepareStatement(SQL,Statement.RETURN_GENERATED_KEYS);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, problemName);
	         pstmt.setString(3, timeLimit);
	         pstmt.setString(4, problemContent);
	         pstmt.setString(5, type);
	         pstmt.executeUpdate();
				ResultSet rs=pstmt.getGeneratedKeys();
				
				if(rs.next()){
					int id=rs.getInt(1);
					return id;
				}
	         //return pstmt.executeUpdate();
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
   public int requiredFile(String problemID, String fileName) {
	      String SQL = "INSERT INTO REQUIREDFILE VALUES(?,?)";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, problemID);
	         pstmt.setString(2, fileName);
	         return pstmt.executeUpdate();
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
   public int deleteProblem(int problemID) {
	      String SQL = "DELETE FROM PROBLEM WHERE problemID=?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setInt(1, problemID);
	         return pstmt.executeUpdate();
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
   public int howmany(String userID) {
	      String SQL = "SELECT COUNT(userID) FROM PROBLEM WHERE userID = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getInt(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
   public int howmany2(String problemID) {
	      String SQL = "SELECT COUNT(fileName) FROM REQUIREDFILE WHERE problemID = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, problemID);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getInt(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
   public int[] keyinfo(String userID, int result) {
	      String SQL = "SELECT problemID FROM PROBLEM WHERE userID = ?";
	      int[] temp = new int[result];
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         rs = pstmt.executeQuery();
	         int i=0;
	         while(rs.next()) {
	        	 temp[i] = rs.getInt(1);
	        	 i++;
	         }
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return temp;
	   }
   
   public String[] seeproblem(int problemID) {
	      String SQL = "SELECT * FROM PROBLEM WHERE problemID = ?";
	      String temp[] = new String[4];
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setInt(1, problemID);
	         rs = pstmt.executeQuery();
	         
	         while(rs.next()) {
	        	 temp[0] = Integer.toString(rs.getInt(1));
	        	 temp[1] = rs.getString(2);
	        	 temp[2] = rs.getString(3);
	        	 temp[3] = rs.getString(4);
	         }
	         return temp;
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return null;
	   }
   
   public String[] seeRequiredFile(int problemID, int result) {
	      String SQL = "SELECT fileName FROM REQUIREDFILE WHERE problemID = ?";
	      String temp[] = new String[result];
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setInt(1, problemID);
	         rs = pstmt.executeQuery();
	         
	         while(rs.next()) {
	        	 temp[0] = rs.getString(1);
	         }
	         return temp;
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return null;
	   }
}
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
         String dbURL = "jdbc:mysql://localhost:3306/FALCON?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";
         String dbID = "falcon";
         String dbPassword="falcon";
         Class.forName("com.mysql.cj.jdbc.Driver");
         conn = DriverManager.getConnection(dbURL,dbID,dbPassword);
      } catch (Exception e) {
         e.printStackTrace();
      }
   }
   
   public int insertProblem(String userID, String problemName, String timeLimit) {
	      String SQL = "INSERT INTO PROBLEM(userID, problemName, timeLimit) VALUES(?,?,?)";
	      try {
	         pstmt = conn.prepareStatement(SQL,Statement.RETURN_GENERATED_KEYS);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, problemName);
	         pstmt.setString(3, timeLimit);
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
   
   public int deleteProblem(String problemName) {
	      String SQL = "DELETE FROM PROBLEM WHERE problemName=?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, problemName);
	         return pstmt.executeUpdate();
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
}
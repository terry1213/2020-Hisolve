package user;

import java.util.*;
import java.sql.*;
import java.util.Calendar;

public class ResultDAO {
   private Connection conn;
   private PreparedStatement pstmt;
   private ResultSet rs;
   
   public ResultDAO() {
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
   
   public int result(String userID, String sessionID, String problemID, String file, String fin) {
      String SQL = "INSERT INTO RESULT(userID, sessionID, problemID, file, final) VALUES(?,?,?,?,?)";
      try {
    	 pstmt = conn.prepareStatement(SQL,Statement.RETURN_GENERATED_KEYS);
         pstmt.setString(1, userID);
         pstmt.setString(2, sessionID);
         pstmt.setString(3, problemID);
         pstmt.setString(4, file);
         pstmt.setString(5, fin);
         pstmt.executeUpdate();
         ResultSet rs=pstmt.getGeneratedKeys();
         if(rs.next()){
        	 int id=rs.getInt(1);
        	 return id;
        	 }
      } catch (Exception e) {
         e.printStackTrace();
      }
      return -1;
   }
   
	public int resultTime(String resultID, String submitTime) {
	      String SQL = "INSERT INTO RESULTTIME VALUES(?,?)";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, resultID);
	         pstmt.setString(2, submitTime);
	         return pstmt.executeUpdate();
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
	public int howmany(String userID, String sessionID, String problemID) {
	      String SQL = "SELECT COUNT(resultID) FROM RESULT WHERE userID = ? AND sessionID = ? AND problemID = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, sessionID);
	         pstmt.setString(3, problemID);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getInt(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
	
	public int[] keyinfo(String userID, String sessionID, String problemID, int result) {
	      String SQL = "SELECT resultID FROM RESULT WHERE userID = ? AND sessionID = ? AND problemID = ?";
	      int[] temp = new int[result];
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, sessionID);
	         pstmt.setString(3, problemID);
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

	public String[] seeResult(int resultID) {
	      String SQL = "SELECT * FROM RESULT WHERE resultID = ?";
	      String temp[] = new String[6];
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setInt(1, resultID);
	         rs = pstmt.executeQuery();
	         
	         while(rs.next()) {
	        	 temp[0] = Integer.toString(rs.getInt(1));
	        	 temp[1] = rs.getString(2);
	        	 temp[2] = rs.getString(3);
	        	 temp[3] = rs.getString(4);
	        	 temp[4] = rs.getString(5);
	        	 temp[5] = rs.getString(6);
	         }
	         return temp;
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return null;
	   }
	
   public int checkResult(String userID, String problemID) {
	      String SQL = "SELECT EXISTS (SELECT * FROM RESULT WHERE userID = ? AND problemID = ?) as success";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, problemID);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getInt(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }

   public int deleteResult(String userID, String problemID) {
	      String SQL = "DELETE FROM RESULT WHERE userID=? AND problemID=?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, problemID);
	         return pstmt.executeUpdate();
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
   public String seeResultTime(String resultID) {
	      String SQL = "SELECT submitTime FROM RESULTTIME WHERE resultID = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, resultID);
	         rs = pstmt.executeQuery();
	         while(rs.next()) {
	        	 return rs.getString(1);
	         }
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return "";
	   }
   
   public String seeCode(String userID, String sessionID, String problemID, String resultID) {
	      String SQL = "SELECT file FROM RESULT WHERE userID = ? AND sessionID = ? AND problemID = ? AND resultID = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, sessionID);
	         pstmt.setString(3, problemID);
	         pstmt.setString(4, resultID);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getString(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return "-1";
	   }
   
   public String[] checkContainer() {
	   String SQL = "SELECT name FROM CONTAINER WHERE state = ?";
	      String temp[] = new String[4];
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, "FREE");
	         rs = pstmt.executeQuery();
	         int i=0;
	         while(rs.next()) {
	        	 temp[i] = rs.getString(1);
	        	 i++;
	         }
	         return temp;
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return null;
   }
   
   public int countContainer(String state) {
	      String SQL = "SELECT COUNT(name) FROM CONTAINER WHERE state = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, state);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getInt(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
   public String changeState(String state ,String name) {
	      String SQL = "UPDATE CONTAINER SET state=? WHERE name = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, state);
	         pstmt.setString(2, name);
	         pstmt.executeUpdate();
				if (rs.next()) {
					return rs.getString(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return "-1";
	   }
   
   public int insertQueue(String userID, String container) {
	      String SQL = "INSERT INTO QUEUE(userID, container) VALUES(?,?)";
	      try {
	    	 pstmt = conn.prepareStatement(SQL,Statement.RETURN_GENERATED_KEYS);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, container);
	         pstmt.executeUpdate();
	         ResultSet rs=pstmt.getGeneratedKeys();
	         if(rs.next()){
	        	 int id=rs.getInt(1);
	        	 return id;
	        	 }
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
   public int checkQueue(String userID) {
	      String SQL = "SELECT EXISTS (SELECT * FROM QUEUE WHERE userID = ? AND container != 'none') as success";
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
   
   public String freeContainer(String userID) {
	      String SQL = "SELECT container FROM QUEUE WHERE userID = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getString(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return "-1";
	   }
   
   public int minJob() {
	      String SQL = "SELECT num FROM QUEUE WHERE num = (SELECT min(num) FROM QUEUE)";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getInt(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
   public int checkJob() {
	      String SQL = "SELECT EXISTS (SELECT * FROM QUEUE) as success";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getInt(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
   public String changeQueue(String container ,int num) {
	      String SQL = "UPDATE QUEUE SET container=? WHERE num = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, container);
	         pstmt.setInt(2, num);
	         pstmt.executeUpdate();
				if (rs.next()) {
					return rs.getString(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return "-1";
	   }
   
   public int deleteJob(String userID) {
	      String SQL = "DELETE FROM QUEUE WHERE userID=?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         return pstmt.executeUpdate();
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
   public int chance(String userID, String sessionID, String problemID) {
	      String SQL = "SELECT opportunity FROM OPPORTUNITY WHERE userID = ? AND sessionID = ? AND problemID = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, sessionID);
	         pstmt.setString(3, problemID);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getInt(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }

   public int insertChance(String userID, String sessionID, String problemID, int opportunity) {
	      String SQL = "INSERT INTO OPPORTUNITY VALUES(?,?,?,?)";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, userID);
	         pstmt.setString(2, sessionID);
	         pstmt.setString(3, problemID);
	         pstmt.setInt(4, opportunity);
	         return pstmt.executeUpdate();
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }

   public String changeChance(String userID, String sessionID, String problemID, int opportunity) {
	      String SQL = "UPDATE OPPORTUNITY SET opportunity=? WHERE userID = ? AND sessionID = ? AND problemID = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setInt(1, opportunity);
	         pstmt.setString(2, userID);
	         pstmt.setString(3, sessionID);
	         pstmt.setString(4, problemID);
	         pstmt.executeUpdate();
				if (rs.next()) {
					return rs.getString(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return "-1";
	   }
   
   public int comment(String sessionID, String problemID, String resultID, String comment, String userID, String toID) {
	      String SQL = "INSERT INTO COMMENT(sessionID, problemID, resultID, comment, userID, new, toID) VALUES(?,?,?,?,?,?,?)";
	      try {
	    	 pstmt = conn.prepareStatement(SQL,Statement.RETURN_GENERATED_KEYS);
	         pstmt.setString(1, sessionID);
	         pstmt.setString(2, problemID);
	         pstmt.setString(3, resultID);
	         pstmt.setString(4, comment);
	         pstmt.setString(5, userID);
	         pstmt.setString(6, "NEW");
	         pstmt.setString(7, toID);
	         pstmt.executeUpdate();
	         ResultSet rs=pstmt.getGeneratedKeys();
	         if(rs.next()){
	        	 int id=rs.getInt(1);
	        	 return id;
	        	 }
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
   public int countComment1(String sessionID, String userID, String state) {
	      String SQL = "SELECT COUNT(commentID) FROM COMMENT WHERE sessionID = ? AND toID = ? AND new = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, sessionID);
	         pstmt.setString(2, userID);
	         pstmt.setString(3, state);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getInt(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
   public int countComment2(String sessionID, String problemID, String userID, String state) {
	      String SQL = "SELECT COUNT(commentID) FROM COMMENT WHERE sessionID = ? AND problemID = ? AND toID = ? AND new = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, sessionID);
	         pstmt.setString(2, problemID);
	         pstmt.setString(3, userID);
	         pstmt.setString(4, state);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getInt(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
   public int countComment3(String sessionID, String problemID, String resultID, String userID, String state) {
	      String SQL = "SELECT COUNT(commentID) FROM COMMENT WHERE sessionID = ? AND problemID = ? AND resultID = ? AND toID = ? AND new = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, sessionID);
	         pstmt.setString(2, problemID);
	         pstmt.setString(3, resultID);
	         pstmt.setString(4, userID);
	         pstmt.setString(5, state);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getInt(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
   public int countComment4(String sessionID, String problemID, String resultID) {
	      String SQL = "SELECT COUNT(commentID) FROM COMMENT WHERE sessionID = ? AND problemID = ? AND resultID = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, sessionID);
	         pstmt.setString(2, problemID);
	         pstmt.setString(3, resultID);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getInt(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
   public int countComment5(String sessionID, String problemID, String userID, String state) {
	      String SQL = "SELECT COUNT(commentID) FROM COMMENT WHERE sessionID = ? AND problemID = ? AND userID = ? AND new = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, sessionID);
	         pstmt.setString(2, problemID);
	         pstmt.setString(3, userID);
	         pstmt.setString(4, state);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getInt(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
   public int countComment6(String sessionID, String problemID, String resultID, String userID, String state) {
	      String SQL = "SELECT COUNT(commentID) FROM COMMENT WHERE sessionID = ? AND problemID = ? AND resultID = ? AND toID = ? AND new = ?";
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, sessionID);
	         pstmt.setString(2, problemID);
	         pstmt.setString(3, resultID);
	         pstmt.setString(4, userID);
	         pstmt.setString(5, state);
	         rs = pstmt.executeQuery();
				if (rs.next()) {
					return rs.getInt(1);
				}
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return -1;
	   }
   
	public int[] selectCommentID(String sessionID, String problemID, String resultID, int result) {
	      String SQL = "SELECT commentID FROM COMMENT WHERE sessionID = ? AND problemID = ? AND resultID = ?";
	      int[] temp = new int[result];
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setString(1, sessionID);
	         pstmt.setString(2, problemID);
	         pstmt.setString(3, resultID);
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
	
	public String[] seeComment(int commentID) {
	      String SQL = "SELECT * FROM COMMENT WHERE commentID = ?";
	      String temp[] = new String[7];
	      try {
	         pstmt = conn.prepareStatement(SQL);
	         pstmt.setInt(1, commentID);
	         rs = pstmt.executeQuery();
	         
	         while(rs.next()) {
	        	 temp[0] = Integer.toString(rs.getInt(1));
	        	 temp[1] = rs.getString(2);
	        	 temp[2] = rs.getString(3);
	        	 temp[3] = rs.getString(4);
	        	 temp[4] = rs.getString(5);
	        	 temp[5] = rs.getString(6);
	        	 temp[6] = rs.getString(7);
	         }
	         return temp;
	      } catch (Exception e) {
	         e.printStackTrace();
	      }
	      return null;
	   }
	
	public int checkNew(int commentID, String state, String userID) {
		String SQL = "SELECT EXISTS (SELECT * FROM COMMENT WHERE commentID = ? AND new = ? AND userID != ?) as success";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, commentID);
			pstmt.setString(2, state);
			pstmt.setString(3, userID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		return -1;
		}
	
	public String changNew(int commentID, String state) {
		String SQL = "UPDATE COMMENT SET new=? WHERE commentID = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, state);
			pstmt.setInt(2, commentID);
			pstmt.executeUpdate();
			if (rs.next()) {
				return rs.getString(1);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		return "-1";
		}
	}

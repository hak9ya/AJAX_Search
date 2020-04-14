package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class UserDAO {

		private Connection conn;
		private PreparedStatement pstmt;
		private ResultSet rs;
		
		public UserDAO() {
			try {
				String dbURL = "jdbc:mysql://localhost:3306/AJAX";
				String dbID = "root";
				String dbPassword = "root";
				Class.forName("com.mysql.jdbc.Driver");
				conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
				
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		
		public ArrayList<User> search(String userName){ // db에 저장되어있는 회원정보를 가져옴
			String SQL = "SELECT * FROM USER WHERE userName LIKE ?"; // LIKE 포함해서
			ArrayList<User> userList = new ArrayList<User>(); // userList 생성
			try {
				pstmt = conn.prepareStatement(SQL); // pstmt에 실제 sql문을 삽입
				pstmt.setString(1, "%" + userName + "%"); // ?에 들어갈 내용, 양 옆의 "%" : 특정한 문자의 결과를 포함한 모든 결과 출력
				rs = pstmt.executeQuery(); // rs에 실행결과를 담음
				while(rs.next()) { // 결과를 하나씩 읽고 userList에 정보를 담음
					User user = new User(); // user 생성
					user.setUserName(rs.getString(1));
					user.setUserAge(rs.getInt(2));
					user.setUserGender(rs.getString(3));
					user.setUserEmail(rs.getString(4));
					userList.add(user); // userList에 추가
				}
			}catch(Exception e){
				e.printStackTrace();
			}
			return userList;
		}
		
		public int register(User user) {
			String SQL = "INSERT INTO USER VALUES(?, ?, ?, ?)";
			try {
				pstmt = conn.prepareStatement(SQL);
				pstmt.setString(1, user.getUserName());
				pstmt.setInt(2, user.getUserAge());
				pstmt.setString(3, user.getUserGender());
				pstmt.setString(4, user.getUserEmail());
				return pstmt.executeUpdate();				
			}catch(Exception e){
				e.printStackTrace();
			}
			return -1; // 데이터베이스 오류
		}
}
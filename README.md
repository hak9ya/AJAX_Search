![2](https://user-images.githubusercontent.com/63631952/94255202-d98d1080-ff62-11ea-9de4-77cd08576133.png)
![3](https://user-images.githubusercontent.com/63631952/94255264-ef023a80-ff62-11ea-91a8-6a924bc5e79b.png)
![ajax](https://user-images.githubusercontent.com/63631952/94255340-0ccf9f80-ff63-11ea-9c96-8f9d4c7e4ce7.png)

# AJAX를 이용한 비동기식 검색구현

## 프로젝트 계획이유
> 부트스트랩을 이용해서 만든 게시판에서 검색을 구현하지 않아서 구현을 해보자는 마음에 프로젝트를 계획했습니다.
> 사실 게시판에 추가적으로 적용해서 할 수는 있었지만 새롭게 해서 복습하고자 만들었고
> 비동기적이게 구현하면 보다 더 편리하게 웹페이지에서 활용할 수 있다는 점이 있어서 AJAX를 사용했습니다.

## 프로젝트 정보(개발환경)
> 1. 개발을 하기 위해 제일 대중적인 Eclipse2020-09를 사용했습니다.
> 2. 웹과 JSP가 연동되기 위한 tomcat9.0 서버를 사용했습니다.
> 3. JSP는 서버 프로그래밍 언어이고 java를 사용하기 때문에 자바 개발 환경인 jdk14를 사용했습니다.
> 4. 프론트엔드 프레임워크인 bootstrap은 3.3.7을 사용했습니다.
> 5. 전반적으로 회원의 데이터를 관리할 DB는 MySQL8.0을 사용했습니다.
> 6. MySQL을 사용해서 만든 데이터베이스를 JDBC5.1.48을 이용하여 JSP와 연동하였습니다.

## 프로젝트 주요 기능
![화면 캡처 2020-09-25 185833](https://user-images.githubusercontent.com/63631952/94255552-60da8400-ff63-11ea-8eb1-eae3a13559ad.png)

- 파싱하기 쉽게 JSON을 사용하여 검색했을때 정보를 JSON형태로 출력
```
package user;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class UserSearchServlet
 */
@WebServlet("/UserSearchServlet")
// 컨트롤러
public class UserSearchServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String userName = request.getParameter("userName");
		response.getWriter().write(getJSON(userName));
	}
	
	public String getJSON(String userName) { // 검색했을때 정보를 JSON형태로 출력하고 다시 파싱해서 보여줌
		if(userName == null) userName = "";
		StringBuffer result = new StringBuffer("");
		result.append("{\"result\":[");
		UserDAO userDAO = new UserDAO();
		ArrayList<User> userList = userDAO.search(userName);
		for(int i = 0; i < userList.size(); i++) { // db에서 가져온 각 사용자 만큼 개별 사용자 정보를 JSON형태로 출력
			result.append("[{\"value\": \"" + userList.get(i).getUserName() + "\"},");
			result.append("{\"value\": \"" + userList.get(i).getUserAge() + "\"},");
			result.append("{\"value\": \"" + userList.get(i).getUserGender() + "\"},");
			result.append("{\"value\": \"" + userList.get(i).getUserEmail() + "\"}],"); // 하나의 회원 정보를 배열의 원소형태로 보여줌
		}
		result.append("]}");
		return result.toString(); // 검색해서 나온 결과를 JSON형태로 출력
	}
}
```
![화면 캡처 2020-09-25 191526](https://user-images.githubusercontent.com/63631952/94255645-85cef700-ff63-11ea-9bc0-f504b0a5b83e.png)

- XMLHttpRequest(AJAX) 기법
```
		var searchRequest = new XMLHttpRequest(); // 웹사이트에 요청을 보내는 역할을 하는 인스턴스 생성
		var registerRequest = new XMLHttpRequest(); // 웹사이트에 요청을 보내는 역할을 하는 인스턴스 생성
		function searchFunction(){
			//post방식으로, userName인 id의 text에 적은 내용이 UTF-8으로 인코딩돼서 실제 파라미터로 넘어감, 서블릿페이지에서 userName을 받아서 처리하고 JSON을 내보냄
			searchRequest.open("Post", "./UserSearchServlet?userName=" + encodeURIComponent(document.getElementById("userName").value), true);
			searchRequest.onreadystatechange = searchProcess;
			searchRequest.send(null); // 요청이 끝났다면 searchProcess를 실행할 수 있도록 만듬
		
		}
```
- onkeyup을 사용하여 바로바로 검색가능
- 회원 등록 기능

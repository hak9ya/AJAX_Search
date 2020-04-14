<%@ page contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="css/bootstrap.css">
	<title>JSP AJAX</title>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	<script type="text/javascript">
		var searchRequest = new XMLHttpRequest(); // 웹사이트에 요청을 보내는 역할을 하는 인스턴스 생성
		var registerRequest = new XMLHttpRequest(); // 웹사이트에 요청을 보내는 역할을 하는 인스턴스 생성
		function searchFunction(){
			//post방식으로, userName인 id의 text에 적은 내용이 UTF-8으로 인코딩돼서 실제 파라미터로 넘어감, 서블릿페이지에서 userName을 받아서 처리하고 JSON을 내보냄
			searchRequest.open("Post", "./UserSearchServlet?userName=" + encodeURIComponent(document.getElementById("userName").value), true);
			searchRequest.onreadystatechange = searchProcess;
			searchRequest.send(null); // 요청이 끝났다면 searchProcess를 실행할 수 있도록 만듬
		
		}
		function searchProcess(){
			var table = document.getElementById("ajaxTable"); // id값이 ajaxTable인 tbody부분을 가져옴
			table.innerHTML = ""; // 안에 내용을 다 지움
			// 성공적으로 통신이 이루어졌는지, readyState==4 : 데이터를 전부 받은 상태, status==200 : 서버로부터 응답상태가 요청에 성공
			if(searchRequest.readyState == 4 && searchRequest.status == 200){
				var object = eval('(' + searchRequest.responseText + ')');
				var result = object.result; // 회원들의 정보가 담긴 배열을 가져옴
				for(var i = 0; i < result.length; i++){
					var row = table.insertRow(0);
					for(var j = 0; j < result[i].length; j++){
						var cell = row.insertCell(j);
						cell.innerHTML = result[i][j].value;
					}
				}
			}
		}
		function registerFunction(){
			registerRequest.open("Post", "./UserRegisterServlet?userName=" + encodeURIComponent(document.getElementById("registerName").value) +
								"&userAge=" + encodeURIComponent(document.getElementById("registerAge").value) +
								"&userGender="  + encodeURIComponent($('input[name=registerGender]:checked').val()) + // Gender는 id값이 아닌 name으로 줬기 때문에 jQuery 사용
								"&userEmail=" + encodeURIComponent(document.getElementById("registerEmail").value), true);
			registerRequest.onreadystatechange = registerProcess;
			registerRequest.send(null);
		}
		function registerProcess(){
			if(registerRequest.readyState == 4 && registerRequest.status == 200){
				var result = registerRequest.responseText;
				if(result != 1){
					alert('등록에 실패했습니다.');
					
				}else{
					var userName = document.getElementById("userName");
					var registerName = document.getElementById("registerName");
					var registerAge = document.getElementById("registerAge");
					var registerEmail = document.getElementById("registerEmail");
					userName.value = "";
					registerName.value = "";
					registerAge.value = "";
					registerEmail.value = "";
					searchFunction();
				}
			}
		}
		window.onload = function(){
			searchFunction();
		}
	</script>
</head>
<body>
	<br>
	<div class="container">
		<div class="form-group row pull-right">
			<div class="col-xs-8">
				<input class="form-control" id="userName" onkeyup="searchFunction()" type="text" size="20">
			</div>
			<div class="cols-xs-2">
			<button class="btn btn-primary" onclick="searchFunction();" type="button">검색</button>
			</div>
		</div>
		<table class="table" style="text-align: center; border: 1px solid #dddddd">
			<thead>
				<tr>
					<th style="background-color: #fafafa; text-align: center;">이름</th>
					<th style="background-color: #fafafa; text-align: center;">나이</th>
					<th style="background-color: #fafafa; text-align: center;">성병</th>
					<th style="background-color: #fafafa; text-align: center;">이메일</th>
				</tr>
			</thead>
			<tbody id="ajaxTable">
			</tbody>
		</table>					
	</div>
	<div class="container">
		<table class="table" style="text-align: center; border: 1px solid #dddddd">
			<thead>
				<tr>
					<th colspan="2" style="background-color: #fafafa; text-align: center;">회원 등록 양식</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td style="background-color: #fafafa; text-align: center;"><h5>이름</h5></td>
					<td><input class="form-control" type="text" id="registerName" size="20"></td>
				</tr>
				<tr>
					<td style="background-color: #fafafa; text-align: center;"><h5>나이</h5></td>
					<td><input class="form-control" type="text" id="registerAge" size="20"></td>
				</tr>
				<tr>
					<td style="background-color: #fafafa; text-align: center;"><h5>성별</h5></td>
					<td>
						<div class="form-group" style="text-align: center; margin: 0 auto;">
							<div class="btn-group" data-toggle="buttons">
								<label class="btn btn-primary active">
									<input type="radio" name="registerGender" autocomplete="off" value="남자" checked>남자
								</label>
								<label class="btn btn-primary">
									<input type="radio" name="registerGender" autocomplete="off" value="여자">여자
								</label>
							</div>
						</div>
					</td>
				</tr>		
				<tr>
					<td style="background-color: #fafafa; text-align: center;"><h5>이메일</h5></td>
					<td><input class="form-control" type="text" id="registerEmail" size="20"></td>
				</tr>
				<tr>
					<td colspan="2"><button class="btn btn-primary pull-right" onclick="registerFunction();" type="button">등록</button></td>
				</tr>
			</tbody>
		</table>
	</div>
</body>
</html>
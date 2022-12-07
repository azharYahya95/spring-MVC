<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Student Confirmation</title>
</head>
<body>

	The Student is confirmed: ${student.firstName} ${student.lastName}
	
	<br><br>
	
	Country: ${student.country}
	
	<br><br>
	
	Favourite Language: ${student.favouriteLanguage}
	
	<br><br>
	
	Operating Systems:
	
	<ul>
		<c:foreach var="temp" items="${student.operatingSystems}">
			<li> ${temp} </li>
		</c:foreach>
	</ul>

</body>
</html>
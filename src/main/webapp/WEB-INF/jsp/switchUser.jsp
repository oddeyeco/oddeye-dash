<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<form method="POST" th:action="@{/impersonate}" class="form">

  <label for="usernameField">User name:</label>

  <input type="text" name="username" id="usernameField" />

  <input type="submit" value="Switch User" />

</form>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib prefix="from" uri="http://www.springframework.org/tags/form" %>
<%@ page session="false" %>
<html>
<head>
    <title>Books Page</title>

    <style type="text/css">
        .tg {
            border-collapse: collapse;
            border-spacing: 0;
            border-color: #ccc;
        }

        .tg td {
            font-family: Arial, sans-serif;
            font-size: 14px;
            padding: 10px 5px;
            border-style: solid;
            border-width: 1px;
            overflow: hidden;
            word-break: normal;
            border-color: #ccc;
            color: #333;
            background-color: #fff;
        }

        .tg th {
            font-family: Arial, sans-serif;
            font-size: 14px;
            font-weight: normal;
            padding: 10px 5px;
            border-style: solid;
            border-width: 1px;
            overflow: hidden;
            word-break: normal;
            border-color: #ccc;
            color: #333;
            background-color: #f0f0f0;
        }

        .tg .tg-4eph {
            background-color: #f9f9f9
        }
    </style>
</head>
<body>

<br/>
<br/>

<h1>Book Shelf</h1>

<div class="panel-body">
    <c:if test="${not empty listBooks}">
        <form action="books">
            <div class="row">
                <div class="col-md-2">Search book by title:</div>
                <div class="col-md-2"><input type="text" name="title" id="title" placeholder="type title here.."></div>
                <div class="col-md-2"><input class="btn btn-xs" type='submit' value='Search'/></div>
            </div>
        </form>
    </c:if>
</div>

<div class="container myrow-container">
    <div class="panel">

        <c:if test="${!empty listBooks}">
            <table class="tg">
                <tr>
                    <th width="80">ID</th>
                    <th width="120">Title</th>
                    <th width="250">Description</th>
                    <th width="120">Author</th>
                    <th width="120">ISBN</th>
                    <th width="120">Print year</th>
                    <th width="120">Red already</th>
                    <th width="60">Read</th>
                    <th width="60">Edit</th>
                    <th width="60">Delete</th>
                </tr>
                <c:forEach items="${listBooks}" var="book">
                    <tr>
                        <td>${book.id}</td>
                        <td><a href="/bookdata/${book.id}" target="_blank">${book.title}</a></td>
                        <td>${book.description}</td>
                        <td>${book.author}</td>
                        <td>${book.isbn}</td>
                        <td>${book.printYear}</td>
                        <td>${book.readAlready}</td>
                        <td><a href="<c:url value='/read/${book.id}'/>">Read</a></td>
                        <td><a href="<c:url value='/edit/${book.id}'/>" target="_blank">Edit</a></td>
                        <td><a href="<c:url value='/remove/${book.id}'/>">Delete</a></td>
                    </tr>
                </c:forEach>
            </table>
        </c:if>

        <div align="center" class="panel-footer" id="pagination">
            <c:url value="/books" var="prev">
                <c:param name="page" value="${page-1}"/>
            </c:url>
            <c:if test="${page > 1}">
                <a href="<c:out value="${prev}" />" class="pn prev">Prev</a>
            </c:if>

            <c:forEach begin="1" end="${maxPages}" step="1" varStatus="i">
                <c:choose>
                    <c:when test="${page == i.index}">
                        <span>${i.index}</span>
                    </c:when>
                    <c:otherwise>
                        <c:url value="/books" var="url">
                            <c:param name="page" value="${i.index}"/>
                        </c:url>
                        <a href='<c:out value="${url}" />'>${i.index}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            <c:url value="/books" var="next">
                <c:param name="page" value="${page + 1}"/>
            </c:url>
            <c:if test="${page + 1 <= maxPages}">
                <a href='<c:out value="${next}" />' class="pn next">Next</a>
            </c:if>
        </div>
    </div>
</div>

<h1>Add a Book</h1>

<c:url var="addAction" value="/books/add"/>

<form:form action="${addAction}" commandName="book">
    <table>
        <c:if test="${!empty book.title}">
            <tr>
                <td>
                    <form:label path="id">
                        <spring:message text="Id"/>
                    </form:label>
                </td>
                <td>
                    <form:input path="id" readonly="true" size="8" disabled="true"/>
                    <form:hidden path="id"/>
                </td>
            </tr>
        </c:if>
        <tr>
            <td>
                <form:label path="title">
                    <spring:message text="Title"/>
                </form:label>
            </td>
            <td>
                <form:input path="title"/>
            </td>
        </tr>
        <tr>
            <td>
                <form:label path="description">
                    <spring:message text="Description"/>
                </form:label>
            </td>
            <td>
                <form:input path="description"/>
            </td>
        </tr>
        <tr>
            <td>
                <form:label path="author">
                    <spring:message text="Author"/>
                </form:label>
            </td>
            <td>
                <form:input path="author"/>
            </td>
        </tr>
        <tr>
            <td>
                <form:label path="isbn">
                    <spring:message text="ISBN"/>
                </form:label>
            </td>
            <td>
                <form:input path="isbn"/>
            </td>
        </tr>
        <tr>
            <td>
                <form:label path="printYear">
                    <spring:message text="Print year"/>
                </form:label>
            </td>
            <td>
                <form:input path="printYear"/>
            </td>
        </tr>
        <tr>
            <td>
                <form:label path="readAlready">
                    <spring:message text="Read alredy"/>
                </form:label>
            </td>
            <td>
                <form:input path="readAlready"/>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <c:if test="${empty book.title}">
                    <input type="submit"
                           value="<spring:message text="Add Book"/>"/>
                </c:if>
            </td>
        </tr>
    </table>
</form:form>
</body>
</html>

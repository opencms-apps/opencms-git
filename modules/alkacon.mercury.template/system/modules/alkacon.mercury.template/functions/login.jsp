<%@page
    pageEncoding="UTF-8"
    buffer="none"
    session="false"
    import="org.opencms.main.*, org.opencms.file.*"
    trimDirectiveWhitespaces="true" %>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms" %>
<%@ taglib prefix="mercury" tagdir="/WEB-INF/tags/mercury" %>

<mercury:setting-defaults>

<c:set var="cssWrapper"             value="${setCssWrapperAll}" />
<c:set var="loginproject"           value="${setting.loginproject.isSet ? setting.loginproject.toString : 'Online'}" />
<c:set var="loginou"                value="${setting.loginou.isSet ? fn:trim(cms.element.setting.loginou.toString) : ''}" />

<%-- Must close setting tag here because the loginBean uses inline code --%>
</mercury:setting-defaults>

<c:if test="${not empty loginou and 'Online' ne loginproject}">
    <c:set var="loginproject" value="${loginou eq '/' ? '' : loginou}${loginproject}"/>
</c:if>

<cms:secureparams />
<fmt:setLocale value="${cms.locale}" />
<cms:bundle basename="alkacon.mercury.template.messages">

<jsp:useBean id="loginBean" class="org.opencms.jsp.CmsJspLoginBean" scope="page">

    <% loginBean.init(pageContext, request, response); %>

    <c:choose>
        <c:when test="${(param.action eq 'login') and (not empty param.loginName) and (not empty param.loginPassword)}">
            <c:set var="loginpage"      value="${empty cms.pageResource.property['login-start'] ? cms.requestContext.uri : cms.pageResource.property['login-start']}" />
            <c:set var="loginresource"  value="${empty param.requestedResource ? loginpage : param.requestedResource}" />
            <c:set var="loginuri"       value="${cms.requestContext.siteRoot}${loginresource}" />
            <c:set var="loginuser"      value="${param.loginName}"/>
            <c:set var="loginpassword"  value="${param.loginPassword}"/>
            <c:choose>
                <c:when test="${not empty loginou}">
                    <c:set var="loginprincipal" value="${loginou eq '/' ? '' : loginou}${loginuser}"/>
                    <c:set var="ignore" value="${loginBean.login(loginprincipal, loginpassword, loginproject, loginresource)}" />
                </c:when>
                <c:otherwise>
                    <mercury:findorgunit uri="${loginuri}">
                        <c:set var="success" value="${false}" />
                        <c:forEach var="ou" items="${parentOUs}">
                            <c:if test="${not success}">
                                <c:set var="loginprincipal" value="${empty ou.name ? '' : '/'}${ou.name}${loginuser}"/>
                                <c:set var="ignore" value="${loginBean.login(loginprincipal, loginpassword, loginproject, loginresource)}" />
                                <c:set var="success" value="${loginBean.loggedIn}" />
                            </c:if>
                        </c:forEach>
                    </mercury:findorgunit>
                </c:otherwise>
            </c:choose>
        </c:when>
        <c:when test="${param.action eq 'logoff'}">
            <c:set var="ignore" value="${loginBean.logout()}" />
        </c:when>
    </c:choose>
</jsp:useBean>

<c:set var="loginError" value="${not loginBean.loginSuccess}" />

<mercury:nl/>
<div class="element type-login-form pivot${cssWrapper}"><%----%>

    <form class="styled-form" target="_self" method="post"><%----%>
        <input type="hidden" name="requestedResource" value="${param.requestedResource}" /><%----%>
        <c:choose>

            <c:when test="${not loginBean.loggedIn}">
                <header><%----%>
                    <fmt:message key="msg.page.login.loggedoff" />
                </header><%----%>
                <fieldset><%----%>
                    <section><%----%>
                        <label class="input ${loginError ? 'state-error' : ''}"><%----%>
                            <span class="icon-prepend fa fa-user"></span><%----%>
                            <input type="text" id="loginName" name="loginName" placeholder="<fmt:message key="msg.page.login.username" />"/><%----%>
                        </label><%----%>
                    </section><%----%>
                    <section><%----%>
                        <label class="input ${loginError ? 'state-error' : ''}"><%----%>
                            <span class="icon-prepend fa fa-lock"></span><%----%>
                            <input type="password" id="loginPassword" name="loginPassword" placeholder="<fmt:message key="msg.page.login.password" />"/><%----%>
                        </label><%----%>
                        <c:if test="${loginError}">
                            <em><fmt:message key="msg.page.login.failed" /></em><%----%>
                        </c:if>
                    </section><%----%>
                </fieldset><%----%>
                <footer><%----%>
                    <button class="btn" type="submit" name="action" value="login" ><fmt:message key="msg.page.login.login" /></button><%----%>
                </footer><%----%>
            </c:when>

            <c:otherwise>
                <header><%----%>
                    <fmt:message key="msg.page.login.status.in" />
                </header><%----%>
                <fieldset><%----%>
                    <section><%----%>
                        <label for="loginName" class="label"><fmt:message key="msg.page.login.loggedin" />:</label><%----%>
                        <div class="input"><%----%>
                            <span class="icon-prepend fa fa-user"></span><%----%>
                            <input type="text" id="loginName" name="loginName" value="${cms.requestContext.currentUser.fullName}"/><%----%>
                        </div><%----%>
                    </section><%----%>
                </fieldset><%----%>
                <footer><%----%>
                    <button class="btn" type="submit" name="action" value="logoff" ><fmt:message key="msg.page.login.logoff" /></button><%----%>
                </footer><%----%>
            </c:otherwise>

        </c:choose>
    </form><%----%>
</div><%----%>
<mercury:nl/>

</cms:bundle>


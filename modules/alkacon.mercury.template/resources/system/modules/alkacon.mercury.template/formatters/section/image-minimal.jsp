<%@page
    pageEncoding="UTF-8"
    buffer="none"
    session="false"
    trimDirectiveWhitespaces="true"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms"%>
<%@ taglib prefix="mercury" tagdir="/WEB-INF/tags/mercury" %>

<mercury:init-messages reload="true">
<cms:formatter var="content" val="value">

<c:set var="setting"                value="${cms.element.setting}" />
<c:set var="cssWrapper"             value="${setting.cssWrapper}" />
<c:set var="showImageLink"          value="${setting.showImageLink.toBoolean}" />

<%--
    Note: Adding the link in ADE will prevent the 'bullseye' OpenCms menu from working.
    That's ok since we intend to use this formatter only for group includes.
    We disable the link if we are in the group editor so ADE works here.
--%>
<c:choose>
    <c:when test="${cssWrapper eq 'no-image'}">
        <c:out value='<div class="no-image"></div>' escapeXml="false" />
    </c:when>
    <c:when test="${not value.Image.isSet and cms.isEditMode}">
        <%-- ###### No image: Output warning in offline version ###### --%>
        <fmt:setLocale value="${cms.workplaceLocale}" />
        <cms:bundle basename="alkacon.mercury.template.messages">
            <mercury:alert type="warning">
                <jsp:attribute name="head">
                    <fmt:message key="msg.page.noImage" />
                </jsp:attribute>
            </mercury:alert>
        </cms:bundle>
    </c:when>
    <c:otherwise>
        <mercury:link
            link="${value.Link}"
            test="${showImageLink and not (cms.isEditMode and cms.modelGroupPage)}"
            setTitle="${true}"
            css="imglink" >

            <mercury:image-simple image="${value.Image}" cssWrapper="${cssWrapper}" />

        </mercury:link>
    </c:otherwise>
</c:choose>

</cms:formatter>
</mercury:init-messages>
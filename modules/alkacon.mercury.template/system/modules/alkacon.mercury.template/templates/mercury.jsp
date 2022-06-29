<%@page
    pageEncoding="UTF-8"
    buffer="none"
    session="false"
    trimDirectiveWhitespaces="true"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="cms" uri="http://www.opencms.org/taglib/cms"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="mercury" tagdir="/WEB-INF/tags/mercury" %>


<fmt:setLocale value="${cms.locale}" />
<cms:bundle basename="alkacon.mercury.template.messages">

<mercury:content-properties>
<mercury:template-parts containerName="mercury-page">

<jsp:attribute name="top">

<c:set var="cmsstatus" value="${cms.isEditMode ? ' opencms-page-editor' : null}${cms.isEditMode and cms.modelGroupPage ? ' opencms-group-editor' : null}" />
<c:set var="pageclass" value="${templateVariant}${allowTemplateMods ? ' '.concat(contentProperties['mercury.css.class']) : null}" />

<!DOCTYPE html>
<html lang="${cms.locale}" class="noscript${cmsstatus}${pageclass}">
<head>

<%-- Special CSS in case JavaScript is disabled --%>
<noscript><style>html.noscript .hide-noscript { display: none !important; }</style></noscript>

<script><%-- Static JavaScript that provides a 'mercury.ready()' method for additional scripts
--%>mercury=function(){var n=function(){var n=[];return{ready:function(t){n.push(t)},load:function(t){n.push(t)},getInitFunctions:function(){return n}}}(),t=function(t){if("function"!=typeof t)return n;n.ready(t)};return t.getInitFunctions=function(){return n.getInitFunctions()},t.load=function(n){this(n)},t.ready=function(n){this(n)},t}();<%--
--%>var __isOnline=${cms.isOnlineProject},<%--
--%>__scriptPath="<cms:link>%(link.weak:/system/modules/alkacon.mercury.theme/js/mercury.js)</cms:link>"<%--
--%></script>
<%-- Load the main JavaScript in async mode --%>
<script async src="<mercury:link-resource resource='%(link.weak:/system/modules/alkacon.mercury.theme/js/mercury.js)'/>"></script>

<mercury:meta-canonical renderMetaTags="${true}" >
    <mercury:meta-info canonicalURL="${canonicalURL}" contentPropertiesSearch="${contentPropertiesSearchDetail}" />
</mercury:meta-canonical>

<cms:enable-ade />

<mercury:load-plugins group="css" />
<mercury:load-plugins group="js-async" />
<mercury:load-plugins group="js-defer" />
<mercury:load-plugins group="template-head-includes" type="jsp-nocache" />

<%-- Common CSS and theme CSS --%>
<c:set var="cssTheme" value="${empty contentPropertiesSearch['mercury.theme'] ? '/system/modules/alkacon.mercury.theme/css/theme-standard.min.css' : contentPropertiesSearch['mercury.theme']}" />
<link href="<mercury:link-resource resource='%(link.weak:/system/modules/alkacon.mercury.theme/css/base.min.css)'/>" rel="stylesheet"><%----%>
<mercury:nl />
<link href="<mercury:link-resource resource='${cssTheme}'/>" rel="stylesheet"><%----%>
<mercury:nl />

<%-- Preload Fork Awesome --%>
<link href="<cms:link>/system/modules/alkacon.mercury.theme/fonts/</cms:link>forkawesome-webfont.woff2?v=1.1.7" rel="preload" as="font" type="font/woff2" crossorigin>

<%-- Include custom CSS / JS if allowed --%>
<c:if test="${allowTemplateMods}">
    <mercury:load-resource path="${contentPropertiesSearch['mercury.extra.css']}" defaultPath="${cms.subSitePath}" name="custom.css">
        <link href="<mercury:link-resource resource='${resourcePath}'/>" rel="stylesheet"><mercury:nl />
    </mercury:load-resource>
    <mercury:load-resource path="${contentPropertiesSearch['mercury.extra.js']}" defaultPath="${cms.subSitePath}" name="custom.js">
        <script src="<mercury:link-resource resource='${resourcePath}'/>" defer></script><mercury:nl />
    </mercury:load-resource>
</c:if>

<%-- Add favicon --%>
<c:set var="faviconPath" value="${empty contentPropertiesSearch['mercury.favicon'] ? '/favicon.png' : contentPropertiesSearch['mercury.favicon']}" />
<c:if test="${not (cms.vfs.existsResource[faviconPath] and cms.vfs.readResource[faviconPath].isImage)}">
    <c:set var="faviconPath">/system/modules/alkacon.mercury.theme/img/favicon.png</c:set>
</c:if>
<c:set var="favIconImage" value="${cms.vfs.readResource[faviconPath].toImage.scaleRatio['1-1']}" />
<link rel="apple-touch-icon" sizes="180x180" href="${favIconImage.scaleWidth[180]}">
<link rel="icon" type="image/png" sizes="32x32" href="${favIconImage.scaleWidth[32]}">
<link rel="icon" type="image/png" sizes="16x16" href="${favIconImage.scaleWidth[16]}">

</head>
<body>

<%-- Skip to main content links  --%>
<a class="btn sr-only sr-only-focusable-fixed" id="skip-to-content" href="#main-content"><fmt:message key="msg.aria.skip-to-content" /></a><%----%>

</jsp:attribute>


<jsp:attribute name="middle">
<c:set var="cssgutter" value="${empty contentPropertiesSearch['mercury.css.gutter'] ? '#' : contentPropertiesSearch['mercury.css.gutter']}" />
<cms:container
    name="mercury-page"
    type="area"
    editableby="ROLE.DEVELOPER">

    <cms:param name="cssgrid" value="#" />
    <cms:param name="cssgutter" value="${cssgutter}" />
    <cms:param name="cssgutterbase" value="${cssgutter}" />

    <c:set var="message"><fmt:message key="msg.page.layout.topContainer" /></c:set>
    <mercury:container-box
        label="${message}"
        boxType="container-box"
        type="area"
        role="ROLE.DEVELOPER"
    />

</cms:container>
<mercury:nl/>
</jsp:attribute>


<jsp:attribute name="bottom">
<%-- Page information transfers OpenCms state information to JavaScript --%>
<mercury:pageinfo contentPropertiesSearch="${contentPropertiesSearch}" />

<%-- Include custom foot if allowed --%>
<c:if test="${allowTemplateIncludes}">
    <mercury:load-resource path="${contentPropertiesSearch['mercury.extra.foot']}">
        <cms:include file="${resourcePath}" cacheable="false" /><mercury:nl />
    </mercury:load-resource>
</c:if>

<%-- Privacy policy banner markup --%>
<mercury:privacy-policy-banner contentUri="${contentUri}" contentPropertiesSearch="${contentPropertiesSearch}" />

</body>
</html>
</jsp:attribute>

</mercury:template-parts>
</mercury:content-properties>

</cms:bundle>

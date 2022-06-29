<%@page
    pageEncoding="UTF-8"
    session="false"
    import="org.opencms.file.*,org.opencms.util.*,org.opencms.jsp.*,org.opencms.xml.content.*,alkacon.mercury.webform.fields.*,alkacon.mercury.webform.captcha.*" %><%

    CmsJspActionElement jsp = new CmsJspActionElement(pageContext, request, response);
    CmsCaptchaSettings settings = CmsCaptchaSettings.getInstance(jsp);
    CmsCaptchaField captcha = new CmsCaptchaField(settings, null, null);
    captcha.writeCaptchaImage(jsp);

%>
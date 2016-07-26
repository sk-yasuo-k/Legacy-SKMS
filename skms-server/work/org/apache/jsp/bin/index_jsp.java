package org.apache.jsp.bin;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class index_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List _jspx_dependants;

  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.AnnotationProcessor _jsp_annotationprocessor;

  public Object getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
    _jsp_annotationprocessor = (org.apache.AnnotationProcessor) getServletConfig().getServletContext().getAttribute(org.apache.AnnotationProcessor.class.getName());
  }

  public void _jspDestroy() {
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write("<!-- saved from url=(0014)about:internet -->\r\n");
      out.write("<html lang=\"en\">\r\n");
      out.write("\r\n");
      out.write("<!-- \r\n");
      out.write("Smart developers always View Source. \r\n");
      out.write("\r\n");
      out.write("This application was built using Adobe Flex, an open source framework\r\n");
      out.write("for building rich Internet applications that get delivered via the\r\n");
      out.write("Flash Player or to desktops via Adobe AIR. \r\n");
      out.write("\r\n");
      out.write("Learn more about Flex at http://flex.org \r\n");
      out.write("// -->\r\n");
      out.write("\r\n");
      out.write("<head>\r\n");
      out.write("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />\r\n");
      out.write("\r\n");
      out.write("<!--  BEGIN Browser History required section -->\r\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"history/history.css\" />\r\n");
      out.write("<!--  END Browser History required section -->\r\n");
      out.write("\r\n");
      out.write("<title></title>\r\n");
      out.write("<script src=\"AC_OETags.js\" language=\"javascript\"></script>\r\n");
      out.write("\r\n");
      out.write("<!--  BEGIN Browser History required section -->\r\n");
      out.write("<script src=\"history/history.js\" language=\"javascript\"></script>\r\n");
      out.write("<!--  END Browser History required section -->\r\n");
      out.write("\r\n");
      out.write("<style>\r\n");
      out.write("body { margin: 0px; overflow:hidden }\r\n");
      out.write("</style>\r\n");
      out.write("<script language=\"JavaScript\" type=\"text/javascript\">\r\n");
      out.write("<!--\r\n");
      out.write("// -----------------------------------------------------------------------------\r\n");
      out.write("// Globals\r\n");
      out.write("// Major version of Flash required\r\n");
      out.write("var requiredMajorVersion = 10;\r\n");
      out.write("// Minor version of Flash required\r\n");
      out.write("var requiredMinorVersion = 0;\r\n");
      out.write("// Minor version of Flash required\r\n");
      out.write("var requiredRevision = 32;\r\n");
      out.write("// -----------------------------------------------------------------------------\r\n");
      out.write("// -->\r\n");
      out.write("</script>\r\n");
      out.write("</head>\r\n");
      out.write("\r\n");

    String i = (String) request.getParameter("i");

      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("<body scroll=\"no\">\r\n");
      out.write("<script language=\"JavaScript\" type=\"text/javascript\">\r\n");
      out.write("<!--\r\n");
      out.write("// Version check for the Flash Player that has the ability to start Player Product Install (6.0r65)\r\n");
      out.write("var hasProductInstall = DetectFlashVer(6, 0, 65);\r\n");
      out.write("\r\n");
      out.write("// Version check based upon the values defined in globals\r\n");
      out.write("var hasRequestedVersion = DetectFlashVer(requiredMajorVersion, requiredMinorVersion, requiredRevision);\r\n");
      out.write("\r\n");
      out.write("if ( hasProductInstall && !hasRequestedVersion ) {\r\n");
      out.write("\t// DO NOT MODIFY THE FOLLOWING FOUR LINES\r\n");
      out.write("\t// Location visited after installation is complete if installation is required\r\n");
      out.write("\tvar MMPlayerType = (isIE == true) ? \"ActiveX\" : \"PlugIn\";\r\n");
      out.write("\tvar MMredirectURL = window.location;\r\n");
      out.write("    document.title = document.title.slice(0, 47) + \" - Flash Player Installation\";\r\n");
      out.write("    var MMdoctitle = document.title;\r\n");
      out.write("\r\n");
      out.write("\tAC_FL_RunContent(\r\n");
      out.write("\t\t\"src\", \"playerProductInstall\",\r\n");
      out.write("\t\t\"FlashVars\", \"MMredirectURL=\"+MMredirectURL+'&MMplayerType='+MMPlayerType+'&MMdoctitle='+MMdoctitle+\"\",\r\n");
      out.write("\t\t\"width\", \"100%\",\r\n");
      out.write("\t\t\"height\", \"100%\",\r\n");
      out.write("\t\t\"align\", \"middle\",\r\n");
      out.write("\t\t\"id\", \"Index\",\r\n");
      out.write("\t\t\"quality\", \"high\",\r\n");
      out.write("\t\t\"bgcolor\", \"#869ca7\",\r\n");
      out.write("\t\t\"name\", \"Index\",\r\n");
      out.write("\t\t\"allowScriptAccess\",\"sameDomain\",\r\n");
      out.write("\t\t\"type\", \"application/x-shockwave-flash\",\r\n");
      out.write("\t\t\"pluginspage\", \"http://www.adobe.com/go/getflashplayer\"\r\n");
      out.write("\t);\r\n");
      out.write("} else if (hasRequestedVersion) {\r\n");
      out.write("\t// if we've detected an acceptable version\r\n");
      out.write("\t// embed the Flash Content SWF when all tests are passed\r\n");
      out.write("\tAC_FL_RunContent(\r\n");
      out.write("\t\t\t\"src\", \"Index\",\r\n");
      out.write("\t\t    \"flashVars\", \"i=");
      out.print( i );
      out.write("\",\r\n");
      out.write("\t\t\t\"width\", \"100%\",\r\n");
      out.write("\t\t\t\"height\", \"100%\",\r\n");
      out.write("\t\t\t\"align\", \"middle\",\r\n");
      out.write("\t\t\t\"id\", \"Index\",\r\n");
      out.write("\t\t\t\"quality\", \"high\",\r\n");
      out.write("\t\t\t\"bgcolor\", \"#869ca7\",\r\n");
      out.write("\t\t\t\"name\", \"Index\",\r\n");
      out.write("\t\t\t\"allowScriptAccess\",\"sameDomain\",\r\n");
      out.write("\t\t\t\"type\", \"application/x-shockwave-flash\",\r\n");
      out.write("\t\t\t\"pluginspage\", \"http://www.adobe.com/go/getflashplayer\"\r\n");
      out.write("\t);\r\n");
      out.write("  } else {  // flash is too old or we can't detect the plugin\r\n");
      out.write("    var alternateContent = 'Alternate HTML content should be placed here. '\r\n");
      out.write("  \t+ 'This content requires the Adobe Flash Player. '\r\n");
      out.write("   \t+ '<a href=http://www.adobe.com/go/getflash/>Get Flash</a>';\r\n");
      out.write("    document.write(alternateContent);  // insert non-flash content\r\n");
      out.write("  }\r\n");
      out.write("// -->\r\n");
      out.write("</script>\r\n");
      out.write("<noscript>\r\n");
      out.write("  \t<object classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\"\r\n");
      out.write("\t\t\tid=\"Index\" width=\"100%\" height=\"100%\"\r\n");
      out.write("\t\t\tcodebase=\"http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab\">\r\n");
      out.write("\t\t\t<param name=\"movie\" value=\"Index.swf\" />\r\n");
      out.write("\t\t\t<param name=\"movie\" value=\"Index.swf\" />\r\n");
      out.write("\t\t\t<param name=\"quality\" value=\"high\" />\r\n");
      out.write("\t\t\t<param name=\"bgcolor\" value=\"#869ca7\" />\r\n");
      out.write("\t\t\t<param name=\"allowScriptAccess\" value=\"sameDomain\" />\r\n");
      out.write("\t\t\t<embed src=\"Index.swf\" quality=\"high\" bgcolor=\"#869ca7\"\r\n");
      out.write("\t\t\t\twidth=\"100%\" height=\"100%\" name=\"Index\" align=\"middle\"\r\n");
      out.write("\t\t\t\tplay=\"true\"\r\n");
      out.write("\t\t\t\tloop=\"false\"\r\n");
      out.write("\t\t\t\tquality=\"high\"\r\n");
      out.write("\t\t\t\tallowScriptAccess=\"sameDomain\"\r\n");
      out.write("\t\t\t\ttype=\"application/x-shockwave-flash\"\r\n");
      out.write("\t\t\t\tpluginspage=\"http://www.adobe.com/go/getflashplayer\">\r\n");
      out.write("\t\t\t</embed>\r\n");
      out.write("\t</object>\r\n");
      out.write("</noscript>\r\n");
      out.write("</body>\r\n");
      out.write("</html>\r\n");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try { out.clearBuffer(); } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}

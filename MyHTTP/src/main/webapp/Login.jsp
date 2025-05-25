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
        <title>FinanceiroBD - Login</title>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-SgOJa3DmI69IUzQ2PVdRZhwQ+dy64/BUtbMJw1MZ8t5HZApcHrRKUc4W0kG879m7" crossorigin="anonymous">
        <style>
            .login-container {
                max-width: 400px;
                margin: 100px auto;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 0 15px rgba(0,0,0,0.1);
                background-color: #fff;
            }
            .password-field { 
                position: relative; 
            }
            .toggle-password { 
                position: absolute; 
                right: 10px; 
                top: 38px; 
                cursor: pointer; 
                z-index: 10;
            }
            .alert {
                margin-top: 15px;
            }
            .logo {
                text-align: center;
                margin-bottom: 30px;
                color: #0d6efd;
            }
        </style>
    </head>
    <body style="background-color: #f8f9fa;">
        <div class="container">
            <div class="login-container">
                <div class="logo">
                    <h2>FinanceiroBD</h2>
                    <p class="text-muted">Sistema de Gestão Financeira</p>
                </div>
                
                <%
                    String erro = (String) request.getAttribute("erro");
                    if (erro != null) {
                %>
                    <div class="alert alert-danger" role="alert">
                        <%= erro %>
                    </div>
                <%
                    }
                    
                    String sucesso = (String) request.getAttribute("sucesso");
                    if (sucesso != null) {
                %>
                    <div class="alert alert-success" role="alert">
                        <%= sucesso %>
                    </div>
                <%
                    }
                %>
                
                <form action="Login.jsp" method="POST">
                    <fieldset class="mb-3">
                        <label for="email" class="form-label">E-mail</label>
                        <input type="email" id="email" name="email" required class="form-control" 
                               placeholder="Digite seu e-mail" 
                               value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>" />
                    </fieldset>
                    
                    <fieldset class="mb-3 password-field">
                        <label for="senha" class="form-label">Senha</label>
                        <input type="password" id="senha" name="senha" required class="form-control" 
                               placeholder="Digite sua senha" minlength="6" />
                        <span class="toggle-password" onclick="togglePassword()">👁️</span>
                    </fieldset>
                    
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="lembrar" name="lembrar">
                        <label class="form-check-label" for="lembrar">
                            Lembrar-me
                        </label>
                    </div>
                    
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary btn-lg">Entrar</button>
                    </div>
                    
                    <hr class="my-4">
                    
                    <div class="text-center">
                        <p class="mb-2">Não tem uma conta?</p>
                        <a href="Usuario.jsp" class="btn btn-outline-secondary">Criar Conta</a>
                    </div>
                </form>
            </div>
        </div>
        
        <script>
            function togglePassword() {
                const senhaField = document.getElementById('senha');
                const toggleIcon = document.querySelector('.toggle-password');
                
                if (senhaField.type === 'password') {
                    senhaField.type = 'text';
                    toggleIcon.textContent = '🙈';
                } else {
                    senhaField.type = 'password';
                    toggleIcon.textContent = '👁️';
                }
            }
            
            // Foco automático no campo email
            document.getElementById('email').focus();
        </script>
    </body>
</html>
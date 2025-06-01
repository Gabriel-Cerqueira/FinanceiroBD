<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Modelo.Usuario"%>
<%@ page import="ModeloDAO.UsuarioDAO"%>
<%@ page import="java.util.ArrayList"%>

<%
// Processamento do formulário
String metodo = request.getMethod();
if (metodo.equals("POST")) {
    String nome = request.getParameter("nome");
    String email = request.getParameter("email");
    String senha = request.getParameter("senha");
    
    if (nome != null && !nome.isEmpty() && 
        email != null && !email.isEmpty() && 
        senha != null && !senha.isEmpty()) {
        
        Usuario novoUsuario = new Usuario();
        novoUsuario.setNome(nome);
        novoUsuario.setEmail(email);
        novoUsuario.setSenha(senha);
        
        UsuarioDAO usuarioDAO = new UsuarioDAO();
        
        try {
            usuarioDAO.inserir(novoUsuario);
            // Redireciona para a página de login com mensagem de sucesso
            request.setAttribute("sucesso", "Conta criada com sucesso! Faça login para continuar.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
            return;
        } catch (Exception e) {
            request.setAttribute("erro", "Erro ao criar conta: " + e.getMessage());
        }
    } else {
        request.setAttribute("erro", "Todos os campos são obrigatórios.");
    }
}
%>

<!DOCTYPE html>
<html>
    <head>
        <title>OurBills - Criar Conta</title>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/css?family=Inter:400,500,700&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            :root {
                --brand-green: #91f549;
                --bg-light: #fafbfc;
                --card-bg: #fff;
                --border: #e0e0e0;
                --text-dark: #212529;
                --text-muted: #6c757d;
                --shadow: 0 2px 8px rgba(0,0,0,0.04);
                --radius: 12px;
            }
            body {
                font-family: 'Inter', Arial, sans-serif;
                background: var(--brand-green);
                color: var(--text-dark);
                margin: 0;
                padding: 0;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
            }
            .container {
                max-width: 900px;
                width: 90%;
                margin: 2rem auto;
            }
            .logo {
                font-size: 2.5rem;
                font-weight: 700;
                letter-spacing: -1px;
                color: #000;
                margin-bottom: 2rem;
                text-align: center;
            }
            .form-container {
                background: white;
                border-radius: var(--radius);
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                padding: 2.5rem;
                margin-bottom: 2rem;
            }
            h1 {
                margin-top: 0;
                margin-bottom: 1.5rem;
                font-size: 1.5rem;
                color: #000;
                font-weight: 600;
            }
            .form-description {
                color: var(--text-muted);
                margin-bottom: 2rem;
            }
            .row {
			    display: flex;
			    flex-wrap: wrap;
			    margin: -0.5rem;
			}
			.col {
			    flex: 1 0 0%;
			    padding: 0.5rem;
			    min-width: 250px;
			    box-sizing: border-box;
			}
			.mb-3 {
			    margin-bottom: 1rem;
			    width: 100%;
			    box-sizing: border-box;
			}
            .form-label {
			    display: block;
			    margin-bottom: 0.5rem;
			    font-weight: 500;
			    color: var(--text-dark);
			    width: 100%;
			    box-sizing: border-box;
			    overflow: hidden;
			    text-overflow: ellipsis;
			    white-space: nowrap;
			}
			.form-control {
			    display: block;
			    width: 100%;
			    box-sizing: border-box;
			    padding: 0.8rem 1rem;
			    font-size: 1rem;
			    font-weight: 400;
			    line-height: 1.5;
			    border: 1px solid var(--border);
			    border-radius: 8px;
			    transition: border-color 0.15s ease-in-out;
			}
            .form-control:focus {
                outline: none;
                border-color: var(--brand-green);
            }
            .password-field {
                position: relative;
            }
            .toggle-password {
                position: absolute;
                right: 1rem;
                top: 50%;
                transform: translateY(-50%);
                cursor: pointer;
                color: var(--text-muted);
            }
            .btn {
                display: inline-block;
                font-weight: 500;
                text-align: center;
                white-space: nowrap;
                vertical-align: middle;
                user-select: none;
                border: none;
                padding: 0.8rem 1.5rem;
                font-size: 1rem;
                line-height: 1.5;
                border-radius: 8px;
                transition: all 0.15s ease-in-out;
                cursor: pointer;
            }
            .btn-primary {
                color: #000;
                background-color: var(--brand-green);
            }
            .btn-primary:hover {
                background-color: #4ae728;
            }
            .btn-secondary {
                color: var(--text-dark);
                background-color: #f1f3f5;
            }
            .btn-secondary:hover {
                background-color: #e9ecef;
            }
            .buttons {
                margin-top: 2rem;
                display: flex;
                gap: 1rem;
            }
            .back-link {
                display: block;
                text-align: center;
                margin-top: 1rem;
                color: #000;
                font-weight: 500;
                text-decoration: none;
            }
            .back-link:hover {
                text-decoration: underline;
            }
            .alert {
                padding: 0.75rem 1rem;
                margin-bottom: 1.5rem;
                border-radius: 8px;
                font-weight: 500;
            }
            .alert-danger {
                background-color: #f8d7da;
                color: #721c24;
            }
            
            @media (max-width: 768px) {
			    .row {
			        flex-direction: column;
			    }
			    .col {
			        width: 100%;
			        min-width: 100%;
			    }
			    .buttons {
			        flex-direction: column;
			    }
			    .btn {
			        width: 100%;
			    }
			}
        </style>
    </head>
    <body>
        <div class="container">
            <div class="logo">OurBills</div>
            <div class="form-container">
                <h1>Crie sua conta</h1>
                <p class="form-description">Preencha seus dados para começar a controlar suas finanças</p>
                
                <% 
                    String erro = (String) request.getAttribute("erro");
                    if (erro != null) {
                %>
                    <div class="alert alert-danger">
                        <%= erro %>
                    </div>
                <% } %>
                
                <form action="Usuario.jsp" method="POST">
                    <div class="row">
                        <div class="col">
                            <div class="mb-3">
                                <label for="nome" class="form-label">Nome completo</label>
                                <input type="text" id="nome" name="nome" required class="form-control" 
                                       placeholder="Digite seu nome" value="<%= request.getParameter("nome") != null ? request.getParameter("nome") : "" %>" />
                            </div>
                        </div>
                        <div class="col">
                            <div class="mb-3">
                                <label for="email" class="form-label">E-mail</label>
                                <input type="email" id="email" name="email" required class="form-control" 
                                       placeholder="Digite seu e-mail" value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>" />
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col">
                            <div class="mb-3 password-field">
                                <label for="senha" class="form-label">Senha</label>
                                <input type="password" id="senha" name="senha" required class="form-control" 
                                       placeholder="Crie uma senha segura" minlength="6" />
                                <span class="toggle-password" onclick="togglePassword()">👁️</span>
                            </div>
                        </div>
                        <div class="col">
                            <!-- Espaço para confirmação de senha ou outro campo futuro -->
                        </div>
                    </div>
                    
                    <div class="buttons" style="display: flex; align-items: center;">
                    	<button type="submit" class="btn btn-primary">Criar conta</button>
                        <button type="reset" class="btn btn-secondary">Limpar</button>
                        <a href="Login.jsp"
						   class="btn btn-secondary"
						   style="margin-left: auto; display: flex; align-items: center; gap: 6px; text-decoration: none;">
						    Cancelar
						</a>
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
                    toggleIcon.textContent = '🔒';
                } else {
                    senhaField.type = 'password';
                    toggleIcon.textContent = '👁️';
                }
            }
        </script>
    </body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Modelo.Usuario"%>
<%@ page import="ModeloDAO.UsuarioDAO"%>
<%@ page import="java.util.ArrayList"%>

<!DOCTYPE html>
<html>
    <head>
        <title>FinanceiroBD - Usuários</title>
        <meta charset="UTF-8"/>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-SgOJa3DmI69IUzQ2PVdRZhwQ+dy64/BUtbMJw1MZ8t5HZApcHrRKUc4W0kG879m7" crossorigin="anonymous">
        <style>
            .password-field { position: relative; }
            .toggle-password { position: absolute; right: 10px; top: 10px; cursor: pointer; }
        </style>
    </head>
    <body class="container">
        <h1 class="mt-4 mb-4">Cadastro de Usuário</h1>
        <form action="usuario" method="POST" class="mb-5">
            <div class="row">
                <div class="col-md-6">
                    <fieldset class="mb-3">
                        <label for="nome" class="form-label">Nome</label>
                        <input type="text" id="nome" name="nome" required class="form-control" />
                    </fieldset>
                </div>
                <div class="col-md-6">
                    <fieldset class="mb-3">
                        <label for="email" class="form-label">E-mail</label>
                        <input type="email" id="email" name="email" required class="form-control" />
                    </fieldset>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <fieldset class="mb-3 password-field">
                        <label for="senha" class="form-label">Senha</label>
                        <input type="password" id="senha" name="senha" required class="form-control" minlength="6" />
                        <span class="toggle-password" onclick="document.getElementById('senha').type = document.getElementById('senha').type === 'password' ? 'text' : 'password';">👁️</span>
                    </fieldset>
                </div>
            </div>
            <br/>
            <button type="submit" class="btn btn-primary">Salvar</button>
            &nbsp;
            <button type="reset" class="btn btn-secondary">Limpar</button>
        </form>
        <hr/>
        <h2>Listagem de Usuários</h2>
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Nome</th>
                        <th>E-mail</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        UsuarioDAO usuarioDAO = new UsuarioDAO();
                        ArrayList<Usuario> usuarios = usuarioDAO.pesquisarTodos();

                        for (Usuario usuario : usuarios) {
                    %>
                        <tr>
                            <td><%= usuario.getIdUsuario() %></td>
                            <td><%= usuario.getNome() %></td>
                            <td><%= usuario.getEmail() %></td>
                        </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="Modelo.Categoria, ModeloDAO.CategoriaDAO" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>FinanceiroBD - Categorias</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container">
    <%
        // Processamento da requisição
        String acao = request.getParameter("acao");
        Categoria categoriaEdit = null;
        CategoriaDAO categoriaDAO = new CategoriaDAO();
        
        // Tratamento de ações (excluir/editar)
        if (acao != null && request.getParameter("id") != null) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (acao.equals("excluir")) {
                categoriaDAO.excluir(id);
            } else if (acao.equals("editar")) {
                categoriaEdit = categoriaDAO.pesquisarPorCodigo(id);
            }
        }
        
        // Processamento do formulário POST
        String metodo = request.getMethod();
        if (metodo.equals("POST")) {
            try {
                String nome = request.getParameter("nome");
                
                // Verifica se é uma edição ou inserção
                if (request.getParameter("id") != null && !request.getParameter("id").isEmpty()) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    Categoria categoria = new Categoria();
                    categoria.setIdCategoria(id);
                    categoria.setNome(nome);
                    categoriaDAO.alterar(categoria);
                } else {
                    Categoria categoria = new Categoria();
                    categoria.setNome(nome);
                    categoriaDAO.inserir(categoria);
                }
                
                // Redireciona para limpar o formulário após submissão
                response.sendRedirect("Categoria.jsp");
                return;
            } catch (Exception e) {
                request.setAttribute("erro", "Erro ao salvar categoria: " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        // Busca de dados para a página
        ArrayList<Categoria> categorias = categoriaDAO.pesquisarTodos();
    %>
    
    <h1>Cadastro de Categorias</h1>
    
    <% if(request.getAttribute("erro") != null) { %>
        <div class="alert alert-danger">
            <%= request.getAttribute("erro") %>
        </div>
    <% } %>
    
    <form action="Categoria.jsp" method="POST">
        <% if(categoriaEdit != null) { %>
            <input type="hidden" name="id" value="<%= categoriaEdit.getIdCategoria() %>" />
        <% } %>

        <fieldset>
            <label for="nome" class="form-label">Nome da Categoria</label>
            <input type="text" id="nome" name="nome" required class="form-control" 
                value="<%= categoriaEdit != null ? categoriaEdit.getNome() : "" %>" />
        </fieldset>

        <br/>
        <button type="submit" class="btn btn-primary">Salvar</button>
        &nbsp;
        <button type="reset" class="btn btn-secondary">Limpar</button>
        <% if(categoriaEdit != null) { %>
            &nbsp;
            <a href="Categoria.jsp" class="btn btn-warning">Cancelar Edição</a>
        <% } %>
    </form>

    <hr/>
    <h2>Listagem de Categorias</h2>
    
    <table class="table table-striped table-hover">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nome</th>
                <th>Ações</th>
            </tr>
        </thead>
        <tbody>
            <% 
            if (categorias != null && !categorias.isEmpty()) {
                for (Categoria categoria : categorias) {
            %>
                <tr>
                    <td><%= categoria.getIdCategoria() %></td>
                    <td><%= categoria.getNome() %></td>
                    <td>
                        <a href="categoria.jsp?acao=editar&id=<%= categoria.getIdCategoria() %>" class="btn btn-sm btn-warning">Editar</a>
                        <a href="javascript:void(0)" onclick="confirmarExclusao(<%= categoria.getIdCategoria() %>)" class="btn btn-sm btn-danger">Excluir</a>
                    </td>
                </tr>
            <% 
                }
            } else {
            %>
                <tr>
                    <td colspan="3" class="text-center">Nenhuma categoria cadastrada</td>
                </tr>
            <% } %>
        </tbody>
    </table>
    
    <div class="mt-3">
        <a href="Transacao.jsp" class="btn btn-primary">Ir para Transações</a>
    </div>
    
    <!-- Script para confirmação de exclusão -->
    <script>
        function confirmarExclusao(id) {
            if (confirm("Tem certeza que deseja excluir esta categoria? Isso pode afetar transações relacionadas.")) {
                window.location.href = "categoria.jsp?acao=excluir&id=" + id;
            }
        }
    </script>
</body>
</html>
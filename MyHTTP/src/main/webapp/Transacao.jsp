<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, java.time.format.DateTimeFormatter, java.time.LocalDate, java.math.BigDecimal" %>
<%@ page import="Modelo.Categoria, Modelo.Transacao, ModeloDAO.CategoriaDAO, ModeloDAO.TransacaoDAO" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>FinanceiroBD - Transações</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container">
    <%
        // Processamento da requisição
        String acao = request.getParameter("acao");
        Transacao transacaoEdit = null;
        TransacaoDAO transacaoDAO = new TransacaoDAO();
        
        // Tratamento de ações (excluir/editar)
        if (acao != null && request.getParameter("id") != null) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (acao.equals("excluir")) {
                transacaoDAO.excluir(id);
            } else if (acao.equals("editar")) {
                transacaoEdit = transacaoDAO.pesquisarPorCodigo(id);
            }
        }
        
        String metodo = request.getMethod();
        if (metodo.equals("POST")) {
            try {
                String dataStr = request.getParameter("data");
                int categoriaId = Integer.parseInt(request.getParameter("categoria_id"));
                String tipoPagamento = request.getParameter("tipo_pagamento");
                String informacaoAdicional = request.getParameter("informacao_adicional");
                BigDecimal valor = new BigDecimal(request.getParameter("valor"));
                String tipoStr = request.getParameter("tipo");
                int usuarioId = Integer.parseInt(request.getParameter("usuario_id"));
                
                LocalDate data = LocalDate.parse(dataStr);
                
                Transacao transacao = new Transacao();
                transacao.setData(data);
                transacao.setCategoriaId(categoriaId);
                transacao.setTipoPagamento(tipoPagamento);
                transacao.setInformacaoAdicional(informacaoAdicional);
                transacao.setValor(valor);
                transacao.setTipo(Transacao.TipoTransacao.valueOf(tipoStr));
                transacao.setUsuarioId(usuarioId);
                
                transacaoDAO.inserir(transacao);
            } catch (Exception e) {
                request.setAttribute("erro", "Erro ao salvar transação: " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        // Busca de dados para a página
        CategoriaDAO categoriaDAO = new CategoriaDAO();
        ArrayList<Categoria> categorias = categoriaDAO.pesquisarTodos();
        ArrayList<Transacao> transacoes = transacaoDAO.pesquisarTodos();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        
        // Disponibiliza dados para uso com EL (Expression Language)
        request.setAttribute("categorias", categorias);
        request.setAttribute("transacoes", transacoes);
        request.setAttribute("transacaoEdit", transacaoEdit);
    %>
    
    <h1>Cadastro de Transação</h1>
    
    <% if(request.getAttribute("erro") != null) { %>
        <div class="alert alert-danger">
            <%= request.getAttribute("erro") %>
        </div>
    <% } %>
    
    <form action="Transacao.jsp" method="POST">
        <% if(transacaoEdit != null) { %>
            <input type="hidden" name="id" value="<%= transacaoEdit.getIdTransacao() %>" />
        <% } %>

        <fieldset>
            <label for="data" class="form-label">Data</label>
            <input type="date" id="data" name="data" required class="form-control" 
                value="<%= transacaoEdit != null ? transacaoEdit.getData() : "" %>" />
        </fieldset>

        <fieldset>
            <label for="categoria_id" class="form-label">Categoria</label>
            <select id="categoria_id" name="categoria_id" required class="form-control">
                <% if (categorias != null && !categorias.isEmpty()) {
                    for (Categoria categoria : categorias) { 
                        boolean selected = transacaoEdit != null && transacaoEdit.getCategoriaId() == categoria.getIdCategoria();
                %>
                    <option value="<%= categoria.getIdCategoria() %>" <%= selected ? "selected" : "" %>>
                        <%= categoria.getNome() %>
                    </option>
                <% 
                    }
                } %>
            </select>
        </fieldset>

        <fieldset>
            <label for="tipo_pagamento" class="form-label">Tipo de Pagamento</label>
            <select id="tipo_pagamento" name="tipo_pagamento" required class="form-control">
                <% 
                String[] tiposPagamento = {"Dinheiro", "Cartão de Crédito", "Cartão de Débito", "Pix", "Transferência"};
                for (String tipo : tiposPagamento) {
                    boolean selected = transacaoEdit != null && transacaoEdit.getTipoPagamento().equals(tipo);
                %>
                    <option value="<%= tipo %>" <%= selected ? "selected" : "" %>><%= tipo %></option>
                <% } %>
            </select>
        </fieldset>

        <fieldset>
            <label for="informacao_adicional" class="form-label">Informação Adicional</label>
            <textarea id="informacao_adicional" name="informacao_adicional" class="form-control"><%= transacaoEdit != null && transacaoEdit.getInformacaoAdicional() != null ? transacaoEdit.getInformacaoAdicional() : "" %></textarea>
        </fieldset>

        <fieldset>
            <label for="valor" class="form-label">Valor (R$)</label>
            <input type="number" step="0.01" id="valor" name="valor" required class="form-control"
                value="<%= transacaoEdit != null ? transacaoEdit.getValor() : "" %>" />
        </fieldset>

        <fieldset>
            <label for="tipo" class="form-label">Tipo de Transação</label>
            <select id="tipo" name="tipo" required class="form-control">
                <option value="ENTRADA" <%= transacaoEdit != null && transacaoEdit.getTipo() == Transacao.TipoTransacao.ENTRADA ? "selected" : "" %>>Entrada (Receita)</option>
                <option value="SAIDA" <%= transacaoEdit != null && transacaoEdit.getTipo() == Transacao.TipoTransacao.SAIDA ? "selected" : "" %>>Saída (Despesa)</option>
            </select>
        </fieldset>

        <fieldset>
            <label for="usuario_id" class="form-label">Usuário</label>
            <input type="number" id="usuario_id" name="usuario_id" required class="form-control" 
                value="<%= transacaoEdit != null ? transacaoEdit.getUsuarioId() : 1 %>" />
        </fieldset>

        <br/>
        <button type="submit" class="btn btn-primary">Salvar</button>
        &nbsp;
        <button type="reset" class="btn btn-secondary">Limpar</button>
    </form>

    <hr/>
    <h2>Listagem de Transações</h2>
    
    <table class="table table-striped table-hover">
        <thead>
            <tr>
                <th>ID</th>
                <th>Data</th>
                <th>Categoria</th>
                <th>Tipo Pagamento</th>
                <th>Informação</th>
                <th>Valor</th>
                <th>Tipo</th>
                <th>Ações</th>
            </tr>
        </thead>
        <tbody>
            <% 
            if (transacoes != null && !transacoes.isEmpty()) {
                for (Transacao transacao : transacoes) {
                    Categoria categoria = categoriaDAO.pesquisarPorCodigo(transacao.getCategoriaId());
                    String nomeCategoria = (categoria != null) ? categoria.getNome() : String.valueOf(transacao.getCategoriaId());
                    String valorClass = transacao.getTipo() == Transacao.TipoTransacao.ENTRADA ? "text-success" : "text-danger";
            %>
                <tr>
                    <td><%= transacao.getIdTransacao() %></td>
                    <td><%= transacao.getData().format(formatter) %></td>
                    <td><%= nomeCategoria %></td>
                    <td><%= transacao.getTipoPagamento() %></td>
                    <td><%= transacao.getInformacaoAdicional() != null ? transacao.getInformacaoAdicional() : "" %></td>
                    <td class="<%= valorClass %>">R$ <%= transacao.getValor() %></td>
                    <td><%= transacao.getTipo() %></td>
                    <td>
                        <a href="Transacao.jsp?acao=editar&id=<%= transacao.getIdTransacao() %>" class="btn btn-sm btn-warning">Editar</a>
                        <a href="javascript:void(0)" onclick="confirmarExclusao(<%= transacao.getIdTransacao() %>)" class="btn btn-sm btn-danger">Excluir</a>
                    </td>
                </tr>
            <% 
                }
            } 
            %>
        </tbody>
    </table>
    

    <script>
        function confirmarExclusao(id) {
            if (confirm("Tem certeza que deseja excluir esta transação?")) {
                window.location.href = "Transacao.jsp?acao=excluir&id=" + id;
            }
        }
    </script>
</body>
</html>
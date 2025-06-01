<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, java.time.format.DateTimeFormatter, java.time.LocalDate, java.math.BigDecimal" %>
<%@ page import="Modelo.Categoria, Modelo.Transacao, ModeloDAO.CategoriaDAO, ModeloDAO.TransacaoDAO, Modelo.Usuario" %>
<%
Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
if (usuarioLogado == null) {
    response.sendRedirect("Login.jsp");
    return;
}

// Processamento de ações
String acao = request.getParameter("acao");
TransacaoDAO transacaoDAO = new TransacaoDAO();
CategoriaDAO categoriaDAO = new CategoriaDAO();

if ("criar".equals(acao) && "POST".equals(request.getMethod())) {
    try {
        Transacao novaTransacao = new Transacao();
        novaTransacao.setTipo(Transacao.TipoTransacao.valueOf(request.getParameter("tipo")));
        novaTransacao.setData(LocalDate.parse(request.getParameter("data")));
        novaTransacao.setCategoriaId(Integer.parseInt(request.getParameter("categoriaId")));
        novaTransacao.setTipoPagamento(request.getParameter("tipoPagamento"));
        novaTransacao.setValor(new BigDecimal(request.getParameter("valor")));
        novaTransacao.setInformacaoAdicional(request.getParameter("informacaoAdicional"));
        novaTransacao.setUsuarioId(usuarioLogado.getIdUsuario());
        
        transacaoDAO.inserir(novaTransacao);
        response.sendRedirect("Transacao.jsp");
        return;
    } catch (Exception e) {
        e.printStackTrace();
    }
} else if ("editar".equals(acao) && "POST".equals(request.getMethod())) {
    try {
        Transacao transacaoEditada = new Transacao();
        transacaoEditada.setIdTransacao(Integer.parseInt(request.getParameter("id")));
        transacaoEditada.setTipo(Transacao.TipoTransacao.valueOf(request.getParameter("tipo")));
        transacaoEditada.setData(LocalDate.parse(request.getParameter("data")));
        transacaoEditada.setCategoriaId(Integer.parseInt(request.getParameter("categoriaId")));
        transacaoEditada.setTipoPagamento(request.getParameter("tipoPagamento"));
        transacaoEditada.setValor(new BigDecimal(request.getParameter("valor")));
        transacaoEditada.setInformacaoAdicional(request.getParameter("informacaoAdicional"));
        transacaoEditada.setUsuarioId(usuarioLogado.getIdUsuario());
        
        transacaoDAO.alterar(transacaoEditada);
        response.sendRedirect("Transacao.jsp");
        return;
    } catch (Exception e) {
        e.printStackTrace();
    }
} else if ("excluir".equals(acao)) {
    try {
        int id = Integer.parseInt(request.getParameter("id"));
        transacaoDAO.excluir(id);
        response.sendRedirect("Transacao.jsp");
        return;
    } catch (Exception e) {
        e.printStackTrace();
    }
}

ArrayList<Transacao> transacoes = transacaoDAO.pesquisarTodos();
ArrayList<Categoria> categorias = categoriaDAO.pesquisarTodos();
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>FinanceiroBD - Transações</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- FONT: Inter -->
    <link href="https://fonts.googleapis.com/css?family=Inter:400,500,700&display=swap" rel="stylesheet">
    <!-- ICONS: Bootstrap (opcional) -->
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
            background: var(--bg-light);
            color: var(--text-dark);
            margin: 0;
        }
        .header {
            background: var(--brand-green);
            padding: 1rem 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .header .logo {
            font-weight: 700;
            font-size: 1.2rem;
            color: #000;
            letter-spacing: -1px;
        }
        .header .profile {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #fff;
            box-shadow: var(--shadow);
            background: #e9ecef;
            cursor: pointer;
        }
        .profile-dropdown {
            position: relative;
            display: inline-block;
        }
        .dropdown-content {
            display: none;
            position: absolute;
            right: 0;
            background-color: white;
            min-width: 120px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            border-radius: 8px;
            z-index: 1001;
            overflow: hidden;
            margin-top: 8px;
        }
        .dropdown-content a {
            color: var(--text-dark);
            padding: 12px 16px;
            text-decoration: none;
            display: block;
            font-weight: 500;
            transition: background-color 0.2s;
        }
        .dropdown-content a:hover {
            background-color: #f1f1f1;
        }
        .dropdown-content a i {
            margin-right: 8px;
            width: 16px;
            color: var(--text-muted);
        }
        .profile-dropdown.show .dropdown-content {
            display: block;
        }
        .main-content {
            padding: 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }
        .top-row {
            display: flex;
            gap: 2rem;
            margin-bottom: 1.5rem;
        }
        .card {
            background: var(--card-bg);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding: 1.5rem 2rem;
            flex: 1;
            min-width: 270px;
            min-height: 120px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .balance-label {
            font-size: 1.05rem;
            color: var(--text-muted);
            font-weight: 500;
        }
        .balance-value {
            font-size: 2.1rem;
            font-weight: 700;
            margin: 0.5rem 0 0.25rem;
        }
        .balance-sub {
            color: var(--text-muted);
            font-size: 1rem;
        }
        .search-create-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 2rem;
            width: 100%;
        }
        .search-create-section {
            display: flex;
            gap: 1rem;
            align-items: center;
            width: 100%;
            justify-content: space-between;
        }
        .search-box {
            position: relative;
            width: 250px;
        }
        .search-box input {
            width: 100%;
            padding: 0.7rem 2.8rem 0.7rem 0.9rem;
            border-radius: 8px;
            border: 1px solid var(--border);
            background: #fff;
            font-size: 1rem;
        }
        .search-box .bi {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
        }
        .btn-create {
            background: var(--brand-green);
            border: none;
            padding: 0.7rem 1.2rem;
            border-radius: 8px;
            font-weight: 600;
            color: #000;
            cursor: pointer;
            transition: background-color 0.2s;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            white-space: nowrap;
        }
        .btn-create:hover {
            background: #a3e619;
        }
        .transactions-table-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            margin-top: 1.2rem;
            padding: 1.5rem 1.5rem 2rem 1.5rem;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            font-size: 1rem;
            margin-top: 0.5rem;
        }
        th, td {
            padding: 0.8rem 0.7rem;
            text-align: left;
        }
        th {
            color: var(--text-dark);
            font-weight: 600;
            border-bottom: 2px solid var(--border);
            background: none;
        }
        td {
            border-bottom: 1px solid var(--border);
        }
        tr:last-child td {
            border-bottom: none;
        }
        .actions-cell {
            white-space: nowrap;
        }
        .actions-cell .btn-action {
            background: none;
            border: none;
            color: #222;
            font-size: 1.13rem;
            margin-right: 8px;
            cursor: pointer;
            transition: color 0.2s;
            padding: 2px 6px;
            border-radius: 5px;
            text-decoration: none;
        }
        .actions-cell .btn-action:last-child {
            margin-right: 0;
        }
        .actions-cell .btn-action:hover {
            background: #f0f0f0;
            color: #000;
        }

        /* Modal Styles */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        .modal {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 2rem;
            width: 90%;
            max-width: 500px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }
        .modal-title {
            font-size: 1.3rem;
            font-weight: 600;
        }
        .modal-close {
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: var(--text-muted);
            padding: 0;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .modal-close:hover {
            color: var(--text-dark);
        }
        .form-group {
            margin-bottom: 1rem;
        }
        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--text-dark);
        }
        .form-input, .form-select {
            width: 100%;
            padding: 0.7rem;
            border: 1px solid var(--border);
            border-radius: 6px;
            font-size: 1rem;
            background: #fff;
            transition: border-color 0.2s;
            box-sizing: border-box;
        }
        .form-input:focus, .form-select:focus {
            outline: none;
            border-color: var(--brand-green);
        }
        .form-buttons {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            margin-top: 1.5rem;
        }
        .btn-secondary {
            background: #f8f9fa;
            border: 1px solid var(--border);
            padding: 0.7rem 1.2rem;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            color: var(--text-dark);
        }
        .btn-secondary:hover {
            background: #e9ecef;
        }
        .btn-primary {
            background: var(--brand-green);
            border: none;
            padding: 0.7rem 1.2rem;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            color: #000;
        }
        .btn-primary:hover {
            background: #a3e619;
        }

        @media (max-width: 900px) {
            .top-row {
                flex-direction: column;
                gap: 1rem;
            }
            .main-content {
                padding: 1rem;
            }
            .search-create-row {
                flex-direction: column;
                gap: 1rem;
                align-items: stretch;
            }
            .search-create-section {
                justify-content: space-between;
            }
            .search-box {
                flex: 1;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <span class="logo">OurBills</span>
        <div class="profile-dropdown" id="profileDropdown">
            <img src="https://ui-avatars.com/api/?name=<%= usuarioLogado.getNome() %>&background=random" alt="Avatar" class="profile" onclick="toggleDropdown()">
            <div class="dropdown-content" id="dropdownContent">
                <a href="Login.jsp" onclick="logout()">
                    <i class="bi bi-box-arrow-right"></i>
                    Sair
                </a>
            </div>
        </div>
    </div>
    <div class="main-content">
        <div class="top-row">
            <div class="card" style="max-width:340px;">
                <span class="balance-label">Lucro</span>
                <span class="balance-value">
                    R$<%
                    BigDecimal total = new BigDecimal("0");
                    for (Transacao t : transacoes) {
                        if (t.getUsuarioId() == usuarioLogado.getIdUsuario() && t.getTipo().name().equals("ENTRADA"))
                            total = total.add(t.getValor());
                        if (t.getUsuarioId() == usuarioLogado.getIdUsuario() && t.getTipo().name().equals("SAIDA"))
                            total = total.subtract(t.getValor());
                    }
                    out.print(total.setScale(2, BigDecimal.ROUND_HALF_EVEN).toString().replace('.', ','));
                    %>
                </span>         
            </div>
        </div>
        <div class="graficos-row" style="display: flex; gap: 20px; margin-bottom: 2.5rem;">
	  <!-- Gráfico de Barras (Gastos Mensais) -->
	  <div class="card" style="flex: 1;">
	    <div class="card-header">
	      <i class="fas fa-chart-bar me-1"></i>
	      Gastos Mensais
	    </div>
	    <div class="card-body" style="min-height: 300px; position: relative;">
	      <canvas id="graficoTransacoes"></canvas>
	    </div>
	  </div>
	  
	  <!-- Gráfico de Linhas (Comparativo Ganhos/Gastos) -->
	  <div class="card" style="flex: 1;">
	    <div class="card-header">
	      <i class="fas fa-chart-line me-1"></i>
	      Comparativo Ganhos/Gastos
	    </div>
	    <div class="card-body" style="min-height: 300px; position: relative;">
	      <canvas id="graficoLinhas"></canvas>
	    </div>
	  </div>
	</div>
	
	<script>
	// Função para processar os dados e criar os gráficos
	function criarGraficos() {
	    // Obter os dados da tabela de transações
	    const transacoes = [
	    <% 
	    // Usar a lista de transações já disponível no JSP
	    for (Transacao t : transacoes) {
	        if (t.getUsuarioId() == usuarioLogado.getIdUsuario()) {
	    %>
	        {
	            data: new Date("<%= t.getData() %>"),
	            valor: <%= t.getValor() %>,
	            tipo: "<%= t.getTipo() %>" 
	        },
	    <% 
	        }
	    } 
	    %>
	    ];
	    
	    // Processar dados por mês
	    const meses = ["Jan", "Fev", "Mar", "Abr", "Mai", "Jun", "Jul", "Ago", "Set", "Out", "Nov", "Dez"];
	    const gastosPorMes = Array(12).fill(0);
	    const ganhosPorMes = Array(12).fill(0);
	    
	    transacoes.forEach(transacao => {
	        const mes = transacao.data.getMonth();
	        if (transacao.tipo === "SAIDA") {
	            gastosPorMes[mes] += Number(transacao.valor);
	        } else if (transacao.tipo === "ENTRADA") {
	            ganhosPorMes[mes] += Number(transacao.valor);
	        }
	    });
	    
	    // Criar o gráfico de barras (Gastos Mensais)
	    const ctxBarras = document.getElementById("graficoTransacoes");
	    new Chart(ctxBarras, {
	        type: 'bar',
	        data: {
	            labels: meses,
	            datasets: [{
	                label: 'Gastos Mensais (R$)',
	                backgroundColor: 'rgba(220, 53, 69, 0.8)',
	                borderColor: 'rgba(220, 53, 69, 1)',
	                borderWidth: 1,
	                data: gastosPorMes,
	            }]
	        },
	        options: {
	            responsive: true,
	            maintainAspectRatio: false,
	            layout: {
	                padding: {
	                    top: 10,
	                    bottom: 10
	                }
	            },
	            scales: {
	                y: {
	                    beginAtZero: true,
	                    title: {
	                        display: true,
	                        text: 'Valor (R$)'
	                    }
	                },
	                x: {
	                    title: {
	                        display: true,
	                        text: 'Mês'
	                    }
	                }
	            }
	        }
	    });
	    
	    // Criar o gráfico de linhas (Comparativo)
	    const ctxLinhas = document.getElementById("graficoLinhas");
	    new Chart(ctxLinhas, {
	        type: 'line',
	        data: {
	            labels: meses,
	            datasets: [
	                {
	                    label: 'Gastos (R$)',
	                    borderColor: '#dc3545',
	                    backgroundColor: 'rgba(220, 53, 69, 0.1)',
	                    borderWidth: 2,
	                    pointBackgroundColor: '#dc3545',
	                    tension: 0.3,
	                    fill: true,
	                    data: gastosPorMes
	                },
	                {
	                    label: 'Ganhos (R$)',
	                    borderColor: '#28a745',
	                    backgroundColor: 'rgba(40, 167, 69, 0.1)',
	                    borderWidth: 2,
	                    pointBackgroundColor: '#28a745',
	                    tension: 0.3,
	                    fill: true,
	                    data: ganhosPorMes
	                }
	            ]
	        },
	        options: {
	            responsive: true,
	            maintainAspectRatio: false,
	            layout: {
	                padding: {
	                    top: 10,
	                    bottom: 10
	                }
	            },
	            scales: {
	                y: {
	                    beginAtZero: true,
	                    title: {
	                        display: true,
	                        text: 'Valor (R$)'
	                    }
	                },
	                x: {
	                    title: {
	                        display: true,
	                        text: 'Mês'
	                    }
	                }
	            }
	        }
	    });
	}
	
	// Executar a função quando a página carregar
	document.addEventListener('DOMContentLoaded', criarGraficos);
	</script>

        <div class="search-create-row">
            <div class="search-box">
                <input type="text" id="search" placeholder="Buscar..."/>
                <i class="bi bi-search"></i>
            </div>
            <button class="btn-create" onclick="openCreateModal()">
                <i class="bi bi-plus-circle"></i>
                Nova Transação
            </button>
        </div>
        <div class="transactions-table-card">
            <div style="font-weight:600;font-size:1.1rem;margin-bottom:1rem;">Transações</div>
            <div style="overflow:auto;">
                <table>
                    <thead>
                        <tr>
                            <th>Data</th>
                            <th>Categoria</th>
                            <th>Opção de Pagamento</th>
                            <th>Informações Adicionais</th>
                            <th>Valor</th>     
                            <th></th>
                        </tr>
                    </thead>
                    <tbody id="transacoes-tbody">
					    <%
					    for (Transacao transacao : transacoes) {
					        if (transacao.getUsuarioId() == usuarioLogado.getIdUsuario()) {
					    %>
					    <tr>
					        <td><%= transacao.getData().format(formatter) %></td>
					        <td>
					            <%
					            Categoria categoria = categoriaDAO.pesquisarPorCodigo(transacao.getCategoriaId());
					            out.print(categoria != null ? categoria.getNome() : "-");
					            %>
					        </td>
					        <td><%= transacao.getTipoPagamento() %></td>
					        <td><%= transacao.getInformacaoAdicional() != null ? transacao.getInformacaoAdicional() : "" %></td>
					        <td style="color: <%= transacao.getTipo().name().equals("ENTRADA") ? "#28a745" : "#dc3545" %>;">
					            R$<%= transacao.getValor().setScale(2, BigDecimal.ROUND_HALF_EVEN).toString().replace('.', ',') %>
					        </td>
					        <td class="actions-cell">
					            <button class="btn-action" type="button" title="Editar" onclick="openEditModal(<%= transacao.getIdTransacao() %>, '<%= transacao.getTipo().name() %>', '<%= transacao.getData() %>', <%= transacao.getCategoriaId() %>, '<%= transacao.getTipoPagamento() %>', <%= transacao.getValor() %>, '<%= transacao.getInformacaoAdicional() != null ? transacao.getInformacaoAdicional().replace("'", "\\'") : "" %>')"><i class="bi bi-pencil"></i></button>
					            <button class="btn-action" type="button" title="Excluir" onclick="confirmarExclusao(<%= transacao.getIdTransacao() %>)"><i class="bi bi-trash"></i></button>
					        </td>
					    </tr>
					    <% }} %>
					</tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Modal de Criação de Transação -->
    <div class="modal-overlay" id="createModal">
        <div class="modal">
            <div class="modal-header">
                <h3 class="modal-title">Nova Transação</h3>
                <button class="modal-close" onclick="closeCreateModal()">&times;</button>
            </div>
            <form id="createTransactionForm" method="post" action="Transacao.jsp?acao=criar">
                <div class="form-group">
                    <label class="form-label" for="tipo">Tipo</label>
                    <select class="form-select" id="tipo" name="tipo" required>
                        <option value="">Selecione o tipo</option>
                        <option value="ENTRADA">Entrada</option>
                        <option value="SAIDA">Saída</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label" for="data">Data</label>
                    <input type="date" class="form-input" id="data" name="data" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="categoria">Categoria</label>
                    <select class="form-select" id="categoria" name="categoriaId" required>
                        <option value="">Selecione uma categoria</option>
                        <% for (Categoria cat : categorias) { %>
                        <option value="<%= cat.getIdCategoria() %>"><%= cat.getNome() %></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label" for="tipoPagamento">Tipo de Pagamento</label>
                    <input type="text" class="form-input" id="tipoPagamento" name="tipoPagamento" placeholder="Ex: Cartão, Dinheiro, PIX..." required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="valor">Valor</label>
                    <input type="number" class="form-input" id="valor" name="valor" step="0.01" min="0" placeholder="0,00" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="informacaoAdicional">Informações Adicionais</label>
                    <input type="text" class="form-input" id="informacaoAdicional" name="informacaoAdicional" placeholder="Descrição opcional">
                </div>
                <div class="form-buttons">
                    <button type="button" class="btn-secondary" onclick="closeCreateModal()">Cancelar</button>
                    <button type="submit" class="btn-primary">Criar Transação</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal de Edição de Transação -->
    <div class="modal-overlay" id="editModal">
        <div class="modal">
            <div class="modal-header">
                <h3 class="modal-title">Editar Transação</h3>
                <button class="modal-close" onclick="closeEditModal()">&times;</button>
            </div>
            <form id="editTransactionForm" method="post" action="Transacao.jsp?acao=editar">
                <input type="hidden" id="editId" name="id">
                <div class="form-group">
                    <label class="form-label" for="editTipo">Tipo</label>
                    <select class="form-select" id="editTipo" name="tipo" required>
                        <option value="">Selecione o tipo</option>
                        <option value="ENTRADA">Entrada</option>
                        <option value="SAIDA">Saída</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label" for="editData">Data</label>
                    <input type="date" class="form-input" id="editData" name="data" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="editCategoria">Categoria</label>
                    <select class="form-select" id="editCategoria" name="categoriaId" required>
                        <option value="">Selecione uma categoria</option>
                        <% for (Categoria cat : categorias) { %>
                        <option value="<%= cat.getIdCategoria() %>"><%= cat.getNome() %></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label" for="editTipoPagamento">Tipo de Pagamento</label>
                    <input type="text" class="form-input" id="editTipoPagamento" name="tipoPagamento" placeholder="Ex: Cartão, Dinheiro, PIX..." required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="editValor">Valor</label>
                    <input type="number" class="form-input" id="editValor" name="valor" step="0.01" min="0" placeholder="0,00" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="editInformacaoAdicional">Informações Adicionais</label>
                    <input type="text" class="form-input" id="editInformacaoAdicional" name="informacaoAdicional" placeholder="Descrição opcional">
                </div>
                <div class="form-buttons">
                    <button type="button" class="btn-secondary" onclick="closeEditModal()">Cancelar</button>
                    <button type="submit" class="btn-primary">Atualizar Transação</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Filtro da tabela pelo search box
        document.getElementById('search').addEventListener('input', function() {
            const q = this.value.toLowerCase();
            document.querySelectorAll('#transacoes-tbody tr').forEach(tr => {
                tr.style.display = Array.from(tr.children).some(td => td.textContent.toLowerCase().includes(q)) ? '' : 'none';
            });
        });

        // Confirmação para exclusão
        function confirmarExclusao(id) {
            if (confirm("Tem certeza que deseja excluir esta transação?")) {
                window.location.href = "Transacao.jsp?acao=excluir&id=" + id;
            }
        }

        // Função para alternar o dropdown
        function toggleDropdown() {
            const dropdown = document.getElementById('profileDropdown');
            dropdown.classList.toggle('show');
        }

        // Função de logout
        function logout() {
            // Limpar a sessão e redirecionar
            window.location.href = 'Login.jsp?logout=true';
        }

        // Fechar dropdown quando clicar fora dele
        window.onclick = function(event) {
            if (!event.target.matches('.profile')) {
                const dropdown = document.getElementById('profileDropdown');
                if (dropdown.classList.contains('show')) {
                    dropdown.classList.remove('show');
                }
            }
        }

        // Funções do Modal de Criação
        function openCreateModal() {
            document.getElementById('createModal').style.display = 'flex';
            // Definir data atual como padrão
            document.getElementById('data').value = new Date().toISOString().split('T')[0];
        }

        function closeCreateModal() {
            document.getElementById('createModal').style.display = 'none';
            document.getElementById('createTransactionForm').reset();
        }

        // Funções do Modal de Edição
        function openEditModal(id, tipo, data, categoriaId, tipoPagamento, valor, informacaoAdicional) {
            document.getElementById('editModal').style.display = 'flex';
            document.getElementById('editId').value = id;
            document.getElementById('editTipo').value = tipo;
            document.getElementById('editData').value = data;
            document.getElementById('editCategoria').value = categoriaId;
            document.getElementById('editTipoPagamento').value = tipoPagamento;
            document.getElementById('editValor').value = valor;
            document.getElementById('editInformacaoAdicional').value = informacaoAdicional;
        }

        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
            document.getElementById('editTransactionForm').reset();
        }

        // Fechar modais ao clicar fora deles
        document.getElementById('createModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeCreateModal();
            }
        });

        document.getElementById('editModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeEditModal();
            }
        });

        // Fechar modais com ESC (incluindo dropdown)
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeCreateModal();
                closeEditModal();
                document.getElementById('profileDropdown').classList.remove('show');
            }
        });
    </script>
</body>
</html>
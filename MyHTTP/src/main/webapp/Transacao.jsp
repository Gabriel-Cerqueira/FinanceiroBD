<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, java.time.format.DateTimeFormatter, java.time.LocalDate, java.math.BigDecimal, java.util.Map" %>
<%@ page import="Modelo.Categoria, Modelo.Transacao, ModeloDAO.CategoriaDAO, ModeloDAO.TransacaoDAO, Modelo.Usuario" %>
<%
Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
if (usuarioLogado == null) {
    response.sendRedirect("Login.jsp");
    return;
}
TransacaoDAO transacaoDAO = new TransacaoDAO();
CategoriaDAO categoriaDAO = new CategoriaDAO();
ArrayList<Transacao> transacoes = transacaoDAO.pesquisarTodos();
ArrayList<Categoria> categorias = categoriaDAO.pesquisarTodos();
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

// Buscar dados para o gráfico
Map<Integer, Map<String, BigDecimal>> dadosGrafico = transacaoDAO.buscarTransacoesPorDiaDoMesAtual(usuarioLogado.getIdUsuario());
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>FinanceiroBD - Transações</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- FONT: Inter -->
    <link href="https://fonts.googleapis.com/css?family=Inter:400,500,700&display=swap" rel="stylesheet">
    <!-- ICONS: Bootstrap (opcional) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --brand-green: #B8FF1B;
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
        .tabs-search-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 2rem;
        }
        .tabs {
            display: flex;
            gap: 2rem;
        }
        .tab {
            font-weight: 500;
            font-size: 1.03rem;
            color: var(--text-dark);
            cursor: pointer;
            background: none;
            border: none;
            outline: none;
            padding: 0.5rem;
            border-bottom: 2px solid transparent;
        }
        .tab.active {
            border-bottom: 2px solid #000;
        }
        .search-box {
            position: relative;
            width: 250px;
        }
        .search-box input {
            width: 100%;
            padding: 0.7rem 2.3rem 0.7rem 0.9rem;
            border-radius: 8px;
            border: 1px solid var(--border);
            background: #fff;
            font-size: 1rem;
        }
        .search-box .bi {
            position: absolute;
            right: 0.7rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
        }
        .charts-row {
            display: flex;
            gap: 2rem;
            margin-bottom: 2.2rem;
        }
        .chart-card {
            background: var(--card-bg);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            flex: 1;
            min-height: 210px;
            padding: 1rem 1.3rem;
        }
        .chart-title {
            font-weight: 500;
            color: var(--text-muted);
            margin-bottom: 0.8rem;
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
        }
        .actions-cell .btn-action:last-child {
            margin-right: 0;
        }
        .actions-cell .btn-action:hover {
            background: #f0f0f0;
            color: #000;
        }
        @media (max-width: 900px) {
            .top-row, .charts-row {
                flex-direction: column;
                gap: 1rem;
            }
            .main-content {
                padding: 1rem;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <span class="logo">OurBills</span>
        <img src="https://ui-avatars.com/api/?name=<%= usuarioLogado.getNome() %>&background=random" alt="Avatar" class="profile">
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
                <span class="balance-sub">+20% mês a mês</span>
            </div>
        </div>
        <div class="tabs-search-row">
            <div class="tabs">
                <button class="tab active" type="button">Mês</button>
                <button class="tab" type="button">Ano</button>
            </div>
            <div class="search-box">
                <input type="text" id="search" placeholder="Search..."/>
                <i class="bi bi-search"></i>
            </div>
        </div>
        <div class="charts-row">
            <div class="chart-card">
                <div class="chart-title">Ganhos vs Gastos (Mês Atual)</div>
                <canvas id="lineChart" height="100"></canvas>
            </div>
            <div class="chart-card">
                <div class="chart-title">&nbsp;</div>
                <!-- Placeholder: gráfico de barras -->
                <canvas id="barChart" height="100"></canvas>
            </div>
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
                            <th>Pago?</th>
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
                            <td>R$<%= transacao.getValor().setScale(2, BigDecimal.ROUND_HALF_EVEN).toString().replace('.', ',') %></td>
                            <td><%= transacao.getValor().intValue() % 2 == 0 ? "SIM" : "NÃO" %></td>
                            <td class="actions-cell">
                                <a href="Transacao.jsp?acao=editar&id=<%= transacao.getIdTransacao() %>" class="btn-action" title="Editar"><i class="bi bi-pencil"></i></a>
                                <button class="btn-action" type="button" title="Excluir" onclick="confirmarExclusao(<%= transacao.getIdTransacao() %>)"><i class="bi bi-trash"></i></button>
                            </td>
                        </tr>
                        <% }} %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
    // Preparar dados para o gráfico de ganhos vs gastos (valores diários, não acumulados)
    const diasDoMes = [];
    const ganhosData = [];
    const gastosData = [];
    
    <%
    LocalDate hoje = LocalDate.now();
    int diasNoMes = hoje.lengthOfMonth();
    
    // Criar arrays com os valores diários
    for (int dia = 1; dia <= diasNoMes; dia++) {
        Map<String, BigDecimal> valoresDia = dadosGrafico.get(dia);
        BigDecimal ganhos = valoresDia.get("ENTRADA");
        BigDecimal gastos = valoresDia.get("SAIDA");
    %>
        diasDoMes.push(<%= dia %>);
        ganhosData.push(<%= ganhos.doubleValue() %>);
        gastosData.push(<%= gastos.doubleValue() %>);
    <%
    }
    %>

    // Gráfico de linhas - Ganhos vs Gastos (valores diários)
    const ctxLine = document.getElementById('lineChart').getContext('2d');
    new Chart(ctxLine, {
        type: 'line',
        data: {
            labels: diasDoMes,
            datasets: [{
                label: 'Ganhos',
                data: ganhosData,
                borderColor: '#22c55e',
                backgroundColor: 'rgba(34, 197, 94, 0.1)',
                borderWidth: 3,
                pointRadius: 4,
                pointBackgroundColor: '#22c55e',
                pointBorderColor: '#fff',
                pointBorderWidth: 2,
                fill: false,
                tension: 0.4
            }, {
                label: 'Gastos',
                data: gastosData,
                borderColor: '#ef4444',
                backgroundColor: 'rgba(239, 68, 68, 0.1)',
                borderWidth: 3,
                pointRadius: 4,
                pointBackgroundColor: '#ef4444',
                pointBorderColor: '#fff',
                pointBorderWidth: 2,
                fill: false,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: true,
                    position: 'top',
                    labels: {
                        usePointStyle: true,
                        padding: 20,
                        font: {
                            family: 'Inter',
                            size: 12
                        }
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    titleFont: {
                        family: 'Inter'
                    },
                    bodyFont: {
                        family: 'Inter'
                    },
                    callbacks: {
                        title: function(context) {
                            return 'Dia ' + context[0].label + ' de <%= hoje.getMonth().getDisplayName(java.time.format.TextStyle.FULL, new java.util.Locale("pt", "BR")) %>';
                        },
                        label: function(context) {
                            return context.dataset.label + ': R$ ' + context.parsed.y.toFixed(2).replace('.', ',');
                        }
                    }
                }
            },
            scales: {
                x: {
                    display: true,
                    grid: {
                        display: false
                    },
                    title: {
                        display: true,
                        text: 'Dia do Mês',
                        font: {
                            family: 'Inter',
                            size: 11
                        }
                    },
                    ticks: {
                        maxTicksLimit: 15, // Limita a quantidade de labels no eixo X
                        font: {
                            family: 'Inter',
                            size: 10
                        }
                    }
                },
                y: {
                    display: true,
                    beginAtZero: true,
                    grid: {
                        color: 'rgba(0, 0, 0, 0.05)'
                    },
                    title: {
                        display: true,
                        text: 'Valor Diário (R$)',
                        font: {
                            family: 'Inter',
                            size: 11
                        }
                    },
                    ticks: {
                        callback: function(value) {
                            return 'R$ ' + value.toFixed(0);
                        },
                        font: {
                            family: 'Inter',
                            size: 10
                        }
                    }
                }
            },
            interaction: {
                intersect: false,
                mode: 'index'
            }
        }
    });

    const ctxBar = document.getElementById('barChart').getContext('2d');
    new Chart(ctxBar, {
        type: 'bar',
        data: {
            labels: ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'],
            datasets: [{
                label: '',
                data: [60000, 70000, 65000, 80000, 56000, 73000, 68000, 72000, 70000, 60000, 75000, 67000],
                backgroundColor: "#000"
            }]
        },
        options: { plugins: { legend: { display: false } }, scales: { x: { display: false }, y: { display: false } } }
    });

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
</script>
</body>
</html>
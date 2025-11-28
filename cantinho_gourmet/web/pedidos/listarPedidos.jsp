<%-- 
    Document   : listarPedidos
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="confeitaria.model.Pedido" %>
<%@ page import="confeitaria.dao.PedidoDAO" %>

<!-- Aqui começa o HTML da página de pedidos -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pedidos - Cantinho Gourmet</title>

    <!-- CSS para estilizar a página. Ainda estou aprendendo, mas basicamente deixa tudo mais bonito -->
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        h1 {
            color: #fa709a;
            font-size: 2em;
        }
        
        .btn-home {
            padding: 10px 20px;
            background: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: all 0.3s;
        }
        
        .btn-home:hover {
            background: #5a6268;
        }
        
        .subtitle {
            color: #666;
            margin-bottom: 30px;
        }
        
        .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        
        .search-box {
            flex: 1;
            min-width: 250px;
            position: relative;
        }
        
        .search-box input {
            width: 100%;
            padding: 12px 40px 12px 15px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        .search-box input:focus {
            outline: none;
            border-color: #fa709a;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: #fa709a;
            color: white;
        }
        
        .btn-primary:hover {
            background: #e85d87;
        }
        
        .btn-info {
            background: #17a2b8;
            color: white;
            font-size: 12px;
            padding: 5px 10px;
        }
        
        .btn-info:hover {
            background: #138496;
        }
        
        .btn-success {
            background: #28a745;
            color: white;
            font-size: 12px;
            padding: 5px 10px;
        }
        
        .btn-success:hover {
            background: #218838;
        }
        
        .btn-danger {
            background: #dc3545;
            color: white;
            font-size: 12px;
            padding: 5px 10px;
        }
        
        .btn-danger:hover {
            background: #c82333;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        th {
            background: #fa709a;
            color: white;
            font-weight: 600;
        }
        
        tr:hover {
            background: #f5f5f5;
        }
        
        .actions {
            display: flex;
            gap: 10px;
        }
        
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #999;
        }
        
        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
        }
        
        .status-pendente {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-preparo {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .status-concluido {
            background: #d4edda;
            color: #155724;
        }
        
        .status-cancelado {
            background: #f8d7da;
            color: #721c24;
        }
        
        .result-count {
            color: #666;
            font-size: 14px;
            margin-top: 10px;
        }
        
        .total-value {
            color: #28a745;
            font-weight: 600;
        }
    </style>
</head>
<body>

    <!-- Div principal -->
    <div class="container">

        <!-- Cabeçalho -->
        <div class="header">
            <div>
                <h1>🛒 Pedidos</h1>
                <p class="subtitle">Gestão de Pedidos (Sistema Transacional)</p>
            </div>

            <!-- Botão pra voltar pro index -->
            <a href="../index.jsp" class="btn-home">🏠 Menu Principal</a>
        </div>

        <!-- Barra com pesquisa e botão de novo pedido -->
        <div class="toolbar">
            <div class="search-box">
                <!-- Input que filtra os pedidos pelo nome do cliente -->
                <input type="text" id="searchInput" placeholder="🔍 Pesquisar por cliente..." onkeyup="filtrarTabela()">
            </div>

            <!-- Botão para ir ao formulário de novo pedido -->
            <a href="formPedido.jsp" class="btn btn-primary">+ Novo Pedido</a>
        </div>

        <p class="result-count" id="resultCount"></p>

        <%
            // Aqui eu crio o DAO pra buscar os pedidos do banco
            PedidoDAO dao = new PedidoDAO();

            // Pego todos os pedidos do banco
            List<Pedido> pedidos = dao.listarTodos();

            // Se tiver pedidos, mostro a tabela
            if (pedidos != null && !pedidos.isEmpty()) {
        %>

        <!-- Tabela com os pedidos -->
        <table id="tabelaPedidos">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Data</th>
                    <th>Cliente</th>
                    <th>Funcionário</th>
                    <th>Status</th>
                    <th>Valor Total</th>
                    <th>Ações</th>
                </tr>
            </thead>

            <tbody>
                <% 
                    // Aqui eu percorro a lista de pedidos e monto a tabela
                    for (Pedido p : pedidos) { 

                        // Aqui eu escolho qual cor o status vai ter
                        String statusClass = "status-pendente";
                        if ("Em Preparo".equals(p.getStatus())) statusClass = "status-preparo";
                        else if ("Concluído".equals(p.getStatus())) statusClass = "status-concluido";
                        else if ("Cancelado".equals(p.getStatus())) statusClass = "status-cancelado";
                %>

                <!-- Cada pedido vira uma linha -->
                <tr>
                    <td>#<%= p.getIdPedido() %></td>

                    <!-- Formatando a data pra visualizar melhor -->
                    <td><%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(p.getDataPedido()) %></td>

                    <!-- Mostra o nome do cliente -->
                    <td><%= p.getNomeCliente() %></td>

                    <!-- Se o funcionário for nulo, coloca um '-' -->
                    <td><%= p.getNomeFuncionario() != null ? p.getNomeFuncionario() : "-" %></td>

                    <!-- Badge colorida do status -->
                    <td><span class="status-badge <%= statusClass %>"><%= p.getStatus() %></span></td>

                    <!-- Formata o valor total com duas casas -->
                    <td class="total-value">R$ <%= String.format("%.2f", p.getValorTotal()) %></td>

                    <td>
                        <!-- Botões de ação -->
                        <div class="actions">

                            <!-- Botão para ver detalhes do pedido -->
                            <a href="detalhesPedido.jsp?id=<%= p.getIdPedido() %>" class="btn btn-info">📋 Detalhes</a>

                            <% if ("Pendente".equals(p.getStatus()) || "Em Preparo".equals(p.getStatus())) { %>
                            <!-- Marcar como concluído -->
                            <a href="processarPedido.jsp?acao=concluir&id=<%= p.getIdPedido() %>" 
                               class="btn btn-success" 
                               onclick="return confirm('Marcar este pedido como concluído?')">✅ Concluir</a>
                            <% } %>

                            <% if (!"Cancelado".equals(p.getStatus()) && !"Concluído".equals(p.getStatus())) { %>
                            <!-- Cancelar o pedido -->
                            <a href="processarPedido.jsp?acao=cancelar&id=<%= p.getIdPedido() %>" 
                               class="btn btn-danger" 
                               onclick="return confirm('Deseja realmente cancelar este pedido?')">❌ Cancelar</a>
                            <% } %>

                        </div>
                    </td>
                </tr>

                <% } %>
            </tbody>
        </table>

        <% } else { %>

        <!-- Se não tiver pedido nenhum -->
        <div class="empty-state">
            <h3>Nenhum pedido cadastrado</h3>
            <p>Comece criando seu primeiro pedido!</p>
        </div>

        <% } %>

        <!-- Mensagem de "sem resultados" quando a pesquisa não encontra nada -->
        <div id="noResults" class="empty-state" style="display: none;">
            <h3>Nenhum resultado encontrado</h3>
            <p>Tente pesquisar com outros termos</p>
        </div>
    </div>

    <!-- Script para filtrar a tabela usando o nome do cliente -->
    <script>
        function filtrarTabela() {
            // Pego o texto digitado
            const input = document.getElementById('searchInput');
            const filter = input.value.toLowerCase();

            // Pego a tabela e suas linhas
            const table = document.getElementById('tabelaPedidos');
            const tbody = table.getElementsByTagName('tbody')[0];
            const rows = tbody.getElementsByTagName('tr');

            const noResults = document.getElementById('noResults');
            const resultCount = document.getElementById('resultCount');

            let visibleCount = 0;

            // Aqui eu verifico cada linha pra ver se contém o nome digitado
            for (let i = 0; i < rows.length; i++) {
                const row = rows[i];
                const cells = row.getElementsByTagName('td');

                // Cliente está na célula 2
                const cliente = cells[2].textContent.toLowerCase();

                if (cliente.includes(filter)) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            }

            // Se nada foi encontrado
            if (visibleCount === 0 && filter !== '') {
                noResults.style.display = 'block';
                table.style.display = 'none';
            } else {
                noResults.style.display = 'none';
                table.style.display = 'table';
            }

            // Mostrar quantidade filtrada
            if (filter !== '') {
                resultCount.textContent = visibleCount + ' resultado(s) encontrado(s)';
            } else {
                resultCount.textContent = '';
            }
        }

        // Quando a página carrega, mostra a quantidade total
        window.onload = function() {
            const table = document.getElementById('tabelaPedidos');
            if (table) {
                const tbody = table.getElementsByTagName('tbody')[0];
                const totalRows = tbody.getElementsByTagName('tr').length;
                document.getElementById('resultCount').textContent = totalRows + ' pedido(s) cadastrado(s)';
            }
        };
    </script>

</body>
</html>

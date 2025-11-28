<%-- 
    Document   : detalhesPedido
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="confeitaria.model.Pedido" %>
<%@ page import="confeitaria.model.ItemPedido" %>
<%@ page import="confeitaria.dao.PedidoDAO" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Detalhes do Pedido - Cantinho Gourmet</title>

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
            max-width: 900px;
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
            padding-bottom: 20px;
            border-bottom: 3px solid #fa709a;
        }
        
        h1 {
            color: #fa709a;
            font-size: 2em;
        }
        
        .status-badge {
            display: inline-block;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 14px;
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
        
        .info-section {
            margin-bottom: 30px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
        }
        
        .info-section h2 {
            color: #333;
            font-size: 1.3em;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #fa709a;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #ddd;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: #666;
        }
        
        .info-value {
            color: #333;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
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
        
        .total-section {
            background: #fff3cd;
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .total-label {
            font-size: 1.5em;
            font-weight: bold;
            color: #333;
        }
        
        .total-value {
            font-size: 2em;
            font-weight: bold;
            color: #fa709a;
        }
        
        .btn-group {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }
        
        .btn {
            flex: 1;
            padding: 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            font-size: 16px;
            font-weight: 500;
            transition: all 0.3s;
            color: white;
        }
        
        .btn-secondary {
            background: #6c757d;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }
        
        .badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            background: #e3f2fd;
            color: #1976d2;
        }
        
        .price {
            color: #28a745;
            font-weight: 600;
        }
    </style>
</head>

<body>
    <div class="container">

        <%
            // Aqui eu pego o parâmetro "id" da URL
            String idParam = request.getParameter("id");

            // Se o id não vier, volto para a lista
            if (idParam == null || idParam.isEmpty()) {
                response.sendRedirect("listarPedidos.jsp");
                return; // Saio daqui para não continuar
            }
            
            // Crio o DAO para buscar no banco
            PedidoDAO dao = new PedidoDAO();

            // Busco o pedido junto com os itens dele
            Pedido pedido = dao.buscarPorIdComItens(Integer.parseInt(idParam));
            
            // Se o pedido não existir, aviso o usuário
            if (pedido == null) {
        %>
            <h2>Pedido não encontrado!</h2>
            <a href="listarPedidos.jsp" class="btn btn-secondary">Voltar</a>

        <%
            } else {

                // Aqui eu escolho qual cor o badge vai ficar dependendo do status
                String statusClass = "status-pendente";

                if ("Em Preparo".equals(pedido.getStatus()))
                    statusClass = "status-preparo";
                else if ("Concluído".equals(pedido.getStatus()))
                    statusClass = "status-concluido";
                else if ("Cancelado".equals(pedido.getStatus()))
                    statusClass = "status-cancelado";
        %>

        <!-- Cabeçalho do pedido -->
        <div class="header">
            <h1>📋 Pedido #<%= pedido.getIdPedido() %></h1>
            <!-- Badge com o status -->
            <span class="status-badge <%= statusClass %>">
                <%= pedido.getStatus() %>
            </span>
        </div>
        
        <!-- Informações gerais do pedido -->
        <div class="info-section">
            <h2>ℹ️ Informações Gerais</h2>

            <div class="info-row">
                <span class="info-label">Data do Pedido:</span>

                <!-- Aqui eu formato a data para algo mais bonito -->
                <span class="info-value">
                    <%= new java.text.SimpleDateFormat("dd/MM/yyyy 'às' HH:mm").format(pedido.getDataPedido()) %>
                </span>
            </div>

            <div class="info-row">
                <span class="info-label">Cliente:</span>
                <span class="info-value"><%= pedido.getNomeCliente() %></span>
            </div>

            <div class="info-row">
                <span class="info-label">Funcionário Responsável:</span>
                <span class="info-value">
                    <%= pedido.getNomeFuncionario() != null ? 
                        pedido.getNomeFuncionario() + " (" + pedido.getCargoFuncionario() + ")" : 
                        "Não informado" %>
                </span>
            </div>

            <!-- Só mostra o fornecedor se tiver -->
            <% if (pedido.getNomeFornecedor() != null && !pedido.getNomeFornecedor().isEmpty()) { %>
            <div class="info-row">
                <span class="info-label">Fornecedor:</span>
                <span class="info-value"><%= pedido.getNomeFornecedor() %></span>
            </div>
            <% } %>

            <!-- Só mostra observações se existir -->
            <% if (pedido.getObservacoes() != null && !pedido.getObservacoes().isEmpty()) { %>
            <div class="info-row">
                <span class="info-label">Observações:</span>
                <span class="info-value"><%= pedido.getObservacoes() %></span>
            </div>
            <% } %>

        </div>
        
        <!-- Itens do pedido -->
        <div class="info-section">
            <h2>🍰 Itens do Pedido</h2>

            <table>
                <thead>
                    <tr>
                        <th>Produto</th>
                        <th>Categoria</th>
                        <th>Qtd</th>
                        <th>Preço Unit.</th>
                        <th>Subtotal</th>
                    </tr>
                </thead>

                <tbody>
                    <% 
                        // Aqui eu faço um for para mostrar cada item do pedido
                        for (ItemPedido item : pedido.getItens()) { 
                    %>
                    <tr>
                        <td><%= item.getNomeProduto() %></td>
                        <td><span class="badge"><%= item.getCategoriaProduto() %></span></td>
                        <td><%= item.getQuantidade() %></td>
                        <td class="price">R$ <%= String.format("%.2f", item.getPrecoUnitario()) %></td>
                        <td class="price">R$ <%= String.format("%.2f", item.getSubtotal()) %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        
        <!-- Total do pedido -->
        <div class="total-section">
            <span class="total-label">Valor Total:</span>
            <span class="total-value">R$ <%= String.format("%.2f", pedido.getValorTotal()) %></span>
        </div>
        
        <!-- Botão de voltar -->
        <div class="btn-group">
            <a href="listarPedidos.jsp" class="btn btn-secondary">← Voltar para Lista</a>
        </div>
        
        <% 
            } // fim do ELSE 
        %>

    </div>
</body>
</html>

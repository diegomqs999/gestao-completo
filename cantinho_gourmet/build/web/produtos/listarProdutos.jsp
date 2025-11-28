<%-- 
    Document   : listarProdutos
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897
--%>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="confeitaria.model.Produto" %>
<%@ page import="confeitaria.dao.ProdutoDAO" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Produtos - Cantinho Gourmet</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
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
            color: #00f2fe;
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
            border-color: #00f2fe;
        }
        
        .search-icon {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
            font-size: 18px;
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
            background: #4facfe;
            color: white;
        }
        
        .btn-primary:hover {
            background: #3b8fd6;
        }
        
        .btn-success {
            background: #28a745;
            color: white;
            font-size: 12px;
            padding: 5px 10px;
        }
        
        .btn-danger {
            background: #dc3545;
            color: white;
            font-size: 12px;
            padding: 5px 10px;
        }
        
        .btn-success:hover {
            background: #218838;
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
            background: #4facfe;
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
        
        .badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            background: #e3f2fd;
            color: #1976d2;
        }
        
        .result-count {
            color: #666;
            font-size: 14px;
            margin-top: 10px;
        }
        
        .price {
            color: #28a745;
            font-weight: 600;
        }
        
        .stock-low {
            color: #dc3545;
            font-weight: 600;
        }
        
        .stock-ok {
            color: #28a745;
        }
    </style>
</head>
<body>
    <div class="container">

        <div class="header">
            <div>
                <h1>🍰 Produtos</h1>
                <p class="subtitle">Gerenciamento de Catálogo</p>
            </div>
            <a href="../index.jsp" class="btn-home">🏠 Menu Principal</a>
        </div>

        <div class="toolbar">
            <!-- campo de busca -->
            <div class="search-box">
                <input type="text" id="searchInput" placeholder="🔍 Pesquisar por nome ou categoria..." onkeyup="filtrarTabela()">
                <span class="search-icon">🔍</span>
            </div>
            <a href="formProduto.jsp" class="btn btn-primary">+ Novo Produto</a>
        </div>

        <p class="result-count" id="resultCount"></p>

        <%
            // carrega a lista de produtos
            ProdutoDAO dao = new ProdutoDAO();
            List<Produto> produtos = dao.listarTodos();

            // verifica se existe algum produto
            if (produtos != null && !produtos.isEmpty()) {
        %>

        <!-- tabela com os produtos -->
        <table id="tabelaProdutos">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Categoria</th>
                    <th>Preço</th>
                    <th>Estoque</th>
                    <th>Ações</th>
                </tr>
            </thead>

            <tbody>
                <% for (Produto p : produtos) { %>
                <tr>
                    <td><%= p.getIdProduto() %></td>
                    <td><%= p.getNome() %></td>
                    <td><span class="badge"><%= p.getCategoria() %></span></td>

                    <!-- formata o preço -->
                    <td class="price">R$ <%= String.format("%.2f", p.getPreco()) %></td>

                    <!-- muda cor conforme o estoque -->
                    <td class="<%= p.getEstoque() < 10 ? "stock-low" : "stock-ok" %>">
                        <%= p.getEstoque() %> un.
                    </td>

                    <!-- botões editar e excluir -->
                    <td>
                        <div class="actions">
                            <a href="formProduto.jsp?id=<%= p.getIdProduto() %>" class="btn btn-success">Editar</a>

                            <a href="processarProduto.jsp?acao=deletar&id=<%= p.getIdProduto() %>"
                               class="btn btn-danger"
                               onclick="return confirm('Deseja realmente excluir este produto?')">
                               Excluir
                            </a>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <% } else { %>

            <!-- caso não tenha produtos -->
            <div class="empty-state">
                <h3>Nenhum produto cadastrado</h3>
                <p>Comece adicionando seu primeiro produto!</p>
            </div>

        <% } %>

        <div id="noResults" class="empty-state" style="display: none;">
            <h3>Nenhum resultado encontrado</h3>
            <p>Tente pesquisar com outros termos</p>
        </div>
    </div>

    <!-- script para filtrar a tabela -->
    <script>
        function filtrarTabela() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toLowerCase();
            const table = document.getElementById('tabelaProdutos');
            const tbody = table.getElementsByTagName('tbody')[0];
            const rows = tbody.getElementsByTagName('tr');
            const noResults = document.getElementById('noResults');
            const resultCount = document.getElementById('resultCount');
            
            let visibleCount = 0;

            // percorre as linhas da tabela
            for (let i = 0; i < rows.length; i++) {
                const row = rows[i];
                const cells = row.getElementsByTagName('td');

                const nome = cells[1].textContent.toLowerCase();
                const categoria = cells[2].textContent.toLowerCase();

                const match = nome.includes(filter) || categoria.includes(filter);

                row.style.display = match ? '' : 'none';
                if (match) visibleCount++;
            }

            // controla mensagens e exibição da tabela
            noResults.style.display = visibleCount === 0 && filter !== '' ? 'block' : 'none';
            table.style.display = visibleCount === 0 && filter !== '' ? 'none' : 'table';

            resultCount.textContent = filter !== '' ? visibleCount + ' resultado(s) encontrado(s)' : '';
        }

        // mostra a contagem inicial de produtos
        window.onload = function() {
            const table = document.getElementById('tabelaProdutos');
            if (table) {
                const total = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr').length;
                document.getElementById('resultCount').textContent = total + ' produto(s) cadastrado(s)';
            }
        };
    </script>

</body>
</html>

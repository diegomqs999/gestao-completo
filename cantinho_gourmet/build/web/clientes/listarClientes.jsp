<%-- 
    Document   : listarClientes
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897
--%>


<%-- 
    Essa página mostra todos os clientes cadastrados.
    Aqui dá pra pesquisar, editar e excluir.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="confeitaria.model.Cliente" %>
<%@ page import="confeitaria.dao.ClienteDAO" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Clientes - Cantinho Gourmet</title>

    <style>
        /* Aqui fica só a parte visual da tela */
        
        body {
            font-family: sans-serif;
            background: linear-gradient(135deg, #667eea, #764ba2);
            padding: 20px;
            min-height: 100vh;
        }

        .container {
            background: white;
            max-width: 1200px;
            margin: auto;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }

        .toolbar {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 10px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #764ba2;
            color: white;
            padding: 12px;
        }

        td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }
        .search-box input {
            width: 900px;
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
            background: #f5576c;
            color: white;
        }
        .btn-primary:hover {
            background: #32d66a;
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
        .btn-home {
            padding: 10px 20px;
            background: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: all 0.3s;
        }

        /* Efeito ao passar o mouse */
        .btn-home:hover {
            background: #5a6268;
        }
    </style>
</head>

<body>
    <div class="container">

        <h1>🎂 Cantinho Gourmet</h1>
        <p class="subtitle">Gerenciamento de Clientes</p>
        
        

        <div class="toolbar">
            <!-- Caixa de pesquisa -->
            <div class="search-box">
                <input type="text" id="searchInput" 
                       placeholder="🔍 Pesquisar por nome ou CPF..." 
                       onkeyup="filtrarTabela()">
                <a href="../index.jsp" class="btn-home">🏠 Menu Principal</a>
            </div>

            <!-- Botão para cadastrar novo cliente -->
            <a href="formCliente.jsp" class="btn btn-primary">+ Novo Cliente</a>
        </div>

        <!-- Texto que mostra quantos resultados tem -->
        <p id="resultCount"></p>

        <%
            // Aqui eu chamo o DAO pra buscar todos os clientes do banco
            ClienteDAO dao = new ClienteDAO();
            List<Cliente> clientes = dao.listarTodos();

            // Se tiver clientes, mostra a tabela
            if (clientes != null && !clientes.isEmpty()) {
        %>

        <table id="tabelaClientes">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>CPF</th>
                    <th>Telefone</th>
                    <th>Email</th>
                    <th>Ações</th>
                </tr>
            </thead>

            <tbody>
                <% 
                    // Aqui eu passo por cada cliente e monto uma linha na tabela
                    for (Cliente c : clientes) { 
                %>

                <tr>
                    <td><%= c.getIdCliente() %></td>
                    <td><%= c.getNome() %></td>
                    <td><%= c.getCpf() %></td>
                    <td><%= c.getTelefone() %></td>
                    <td><%= c.getEmail() %></td>

                    <td>
                        <div class="actions">
                            <!-- Botão de editar -->
                            <a href="formCliente.jsp?id=<%= c.getIdCliente() %>" class="btn btn-success">Editar</a>

                            <!-- Botão de excluir -->
                            <a href="processarCliente.jsp?acao=deletar&id=<%= c.getIdCliente() %>" 
                               class="btn btn-danger"
                               onclick="return confirm('Deseja realmente excluir este cliente?')">
                               Excluir
                            </a>
                        </div>
                    </td>
                </tr>

                <% } %>
            </tbody>
        </table>

        <% 
            } else { 
                // Se não tiver clientes, aparece essa mensagem fofinha kkk
        %>

            <div class="empty-state">
                <h3>Nenhum cliente cadastrado</h3>
                <p>Adicione o seu primeiro cliente 😊</p>
            </div>

        <% } %>

        <!-- Mensagem caso a pesquisa não encontre nada -->
        <div id="noResults" class="empty-state" style="display: none;">
            <h3>Nenhum resultado encontrado</h3>
            <p>Tente pesquisar de outro jeito</p>
        </div>

    </div>

    <script>
        // Função que filtra a tabela quando o usuário digita algo
        function filtrarTabela() {

            const input = document.getElementById('searchInput'); // o campo de pesquisa
            const filter = input.value.toLowerCase(); // texto digitado
            const table = document.getElementById('tabelaClientes'); // tabela
            const tbody = table.getElementsByTagName('tbody')[0]; 
            const rows = tbody.getElementsByTagName('tr'); // todas as linhas da tabela
            const noResults = document.getElementById('noResults');
            const resultCount = document.getElementById('resultCount');

            let visibleCount = 0; // conta quantos aparecem

            for (let i = 0; i < rows.length; i++) {

                const row = rows[i];
                const cells = row.getElementsByTagName('td');

                // pego o nome e o cpf da linha
                const nome = cells[1].textContent.toLowerCase();
                const cpf = cells[2].textContent.toLowerCase();

                // verifico se bate com o texto digitado
                if (nome.includes(filter) || cpf.includes(filter)) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            }

            // Mostra ou esconde mensagem de "nenhum resultado"
            if (visibleCount === 0 && filter !== '') {
                noResults.style.display = 'block';
                table.style.display = 'none';
            } else {
                noResults.style.display = 'none';
                table.style.display = 'table';
            }

            // Atualiza contador de resultados
            if (filter !== '') {
                resultCount.textContent = visibleCount + " resultado(s) encontrado(s)";
            } else {
                resultCount.textContent = "";
            }
        }

        // Quando a página carrega, mostra quantos clientes tem no total
        window.onload = function() {
            const table = document.getElementById('tabelaClientes');

            if (table) {
                const tbody = table.getElementsByTagName('tbody')[0];
                const totalRows = tbody.getElementsByTagName('tr').length;

                document.getElementById('resultCount').textContent =
                    totalRows + " cliente(s) cadastrado(s)";
            }
        };
    </script>

</body>
</html>

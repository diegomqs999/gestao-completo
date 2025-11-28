<%-- 
    Document   : listarFuncionarios
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="confeitaria.model.Funcionario" %>
<%@ page import="confeitaria.dao.FuncionarioDAO" %>

<!-- Aqui começa o HTML da página -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Funcionários - Cantinho Gourmet</title>

    <!-- CSS da página. Serve pra deixar tudo bonitinho -->
    <style>
        /* Reset básico pra tirar margens e espaçamentos padrões */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        /* Estilo geral do fundo da página */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            min-height: 100vh;
            padding: 20px;
        }

        /* Caixa branca central onde fica a tabela */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }

        /* Cabeçalho com título e botão de menu */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }

        h1 {
            color: #38f9d7;
            font-size: 2em;
        }

        /* Botão que leva pro menu principal */
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

        /* Texto menor abaixo do título */
        .subtitle {
            color: #666;
            margin-bottom: 30px;
        }

        /* Barra com pesquisa e botão de novo funcionário */
        .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        /* Caixa da barra de busca */
        .search-box {
            flex: 1;
            min-width: 250px;
            position: relative;
        }

        /* Campo de texto da busca */
        .search-box input {
            width: 100%;
            padding: 12px 40px 12px 15px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }

        /* Efeito ao clicar no campo */
        .search-box input:focus {
            border-color: #38f9d7;
        }

        /* Ícone da lupa dentro do campo */
        .search-icon {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
            font-size: 18px;
        }

        /* Estilo geral dos botões */
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
        }

        /* Botão principal (novo funcionário) */
        .btn-primary {
            background: #43e97b;
            color: white;
        }

        .btn-primary:hover {
            background: #32d66a;
        }

        /* Botões pequenos de editar e excluir */
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

        /* Tabela dos funcionários */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        /* Estilo das células */
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        /* Cabeçalho da tabela */
        th {
            background: #43e97b;
            color: white;
            font-weight: 600;
        }

        /* Quando passa o mouse na linha */
        tr:hover {
            background: #f5f5f5;
        }

        /* Caixa de chips do cargo (badge) */
        .badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            background: #e3f2fd;
            color: #1976d2;
        }

        /* Salário em verde */
        .salary {
            color: #28a745;
            font-weight: 600;
        }
    </style>
</head>

<body>
    <!-- Caixa principal -->
    <div class="container">

        <!-- Cabeçalho com título e botão menu -->
        <div class="header">
            <div>
                <h1>👨‍🍳 Funcionários</h1>
                <p class="subtitle">Gerenciamento de Equipe</p>
            </div>

            <!-- Botão que volta para o menu principal -->
            <a href="../index.jsp" class="btn-home">🏠 Menu Principal</a>
        </div>

        <!-- Barra de pesquisa + botão adicionar -->
        <div class="toolbar">
            <div class="search-box">
                <!-- Campo de pesquisa que chama a função filtrarTabela() -->
                <input type="text" id="searchInput" placeholder="🔍 Pesquisar por nome ou cargo..." onkeyup="filtrarTabela()">
                <span class="search-icon">🔍</span>
            </div>

            <!-- Botão para cadastrar novo funcionário -->
            <a href="formFuncionario.jsp" class="btn btn-primary">+ Novo Funcionário</a>
        </div>

        <!-- Texto que mostra quantidade de resultados -->
        <p class="result-count" id="resultCount"></p>

        <%
            // Aqui eu pego a lista com todos os funcionários cadastrados
            FuncionarioDAO dao = new FuncionarioDAO();
            List<Funcionario> funcionarios = dao.listarTodos();

            // Verifico se tem alguém na lista
            if (funcionarios != null && !funcionarios.isEmpty()) {
        %>

        <!-- Tabela onde aparecem os funcionários -->
        <table id="tabelaFuncionarios">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Cargo</th>
                    <th>Salário</th>
                    <th>Telefone</th>
                    <th>Ações</th>
                </tr>
            </thead>

            <tbody>
                <% for (Funcionario f : funcionarios) { %>
                <!-- Cada linha é um funcionário -->
                <tr>
                    <td><%= f.getIdFuncionario() %></td>
                    <td><%= f.getNome() %></td>

                    <!-- Badge azul com o cargo -->
                    <td><span class="badge"><%= f.getCargo() %></span></td>

                    <!-- Salário formatado com 2 casas -->
                    <td class="salary">R$ <%= String.format("%.2f", f.getSalario()) %></td>

                    <!-- Telefone (se não tiver, mostra "-") -->
                    <td><%= f.getTelefone() != null ? f.getTelefone() : "-" %></td>

                    <td>
                        <div class="actions">
                            <!-- Botão editar -->
                            <a href="formFuncionario.jsp?id=<%= f.getIdFuncionario() %>" class="btn btn-success">Editar</a>

                            <!-- Botão excluir -->
                            <a href="processarFuncionario.jsp?acao=deletar&id=<%= f.getIdFuncionario() %>"
                               class="btn btn-danger"
                               onclick="return confirm('Deseja realmente excluir este funcionário?')">Excluir</a>
                        </div>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <% } else { %>
        <!-- Caso não exista nenhum funcionário -->
        <div class="empty-state">
            <h3>Nenhum funcionário cadastrado</h3>
            <p>Comece adicionando seu primeiro funcionário!</p>
        </div>
        <% } %>

        <!-- Mensagem quando a pesquisa não encontra nada -->
        <div id="noResults" class="empty-state" style="display: none;">
            <h3>Nenhum resultado encontrado</h3>
            <p>Tente pesquisar com outros termos</p>
        </div>

    </div>

    <!-- Script responsável pela busca e filtros -->
    <script>

        // Função que filtra a tabela enquanto digito
        function filtrarTabela() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toLowerCase();
            const table = document.getElementById('tabelaFuncionarios');
            const tbody = table.getElementsByTagName('tbody')[0];
            const rows = tbody.getElementsByTagName('tr');
            const noResults = document.getElementById('noResults');
            const resultCount = document.getElementById('resultCount');
            
            let visibleCount = 0;

            // Aqui eu vou linha por linha verificando se o nome ou cargo contém o texto digitado
            for (let i = 0; i < rows.length; i++) {
                const row = rows[i];
                const cells = row.getElementsByTagName('td');
                let found = false;

                const nome = cells[1].textContent.toLowerCase();
                const cargo = cells[2].textContent.toLowerCase();

                // Se o texto aparecer no nome OU no cargo, eu deixo aparecer
                if (nome.includes(filter) || cargo.includes(filter)) {
                    found = true;
                }

                // Mostra ou esconde a linha
                row.style.display = found ? '' : 'none';
                if (found) visibleCount++;
            }

            // Se não encontrar nada, mostra a mensagem de "nenhum resultado"
            if (visibleCount === 0 && filter !== '') {
                noResults.style.display = 'block';
                table.style.display = 'none';
            } else {
                noResults.style.display = 'none';
                table.style.display = 'table';
            }

            // Mostra quantos resultados foram encontrados
            resultCount.textContent = filter !== '' ? visibleCount + " resultado(s) encontrado(s)" : "";
        }

        // Quando a página carrega, mostra quantos funcionários existem
        window.onload = function() {
            const table = document.getElementById('tabelaFuncionarios');
            if (table) {
                const tbody = table.getElementsByTagName('tbody')[0];
                const totalRows = tbody.getElementsByTagName('tr').length;
                document.getElementById('resultCount').textContent = totalRows + " funcionário(s) cadastrado(s)";
            }
        };
    </script>
</body>
</html>

<%-- 
    Document   : listarFornecedores
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="confeitaria.model.Fornecedor" %>
<%@ page import="confeitaria.dao.FornecedorDAO" %>

<!-- Acima estou configurando a página JSP.
     Também importo as classes que vou usar, como o Fornecedor e o DAO. -->

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Fornecedores - Cantinho Gourmet</title>

    <!-- Aqui começam os estilos da página.
         É tudo CSS para deixar o site bonitinho. -->
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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

        h1 {
            color: #f5576c;
            margin-bottom: 10px;
            font-size: 2em;
        }

        .subtitle {
            color: #666;
            margin-bottom: 30px;
        }

        /* Barra de ferramentas com pesquisa + botão adicionar */
        .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        /* Caixa de pesquisa */
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
            border-color: #f5576c;
        }

        .search-icon {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
            font-size: 18px;
        }

        /* Estilos dos botões */
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

        /* Estilo da tabela */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }

        th {
            background: #f5576c;
            color: white;
        }

        /* Quando passar o mouse nas linhas */
        tr:hover {
            background: #f5f5f5;
        }

        .actions {
            display: flex;
            gap: 10px;
        }

        /* Mensagem quando não tem nada */
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #999;
        }

        /* Etiqueta colorida na tabela */
        .badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            background: #e3f2fd;
            color: #1976d2;
        }

        /* Contador de resultados */
        .result-count {
            color: #666;
            margin-top: 10px;
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

        <!-- Título da página -->
        <h1>🎂 Cantinho Gourmet</h1>
        <p class="subtitle">Gerenciamento de Fornecedores</p>

        <!-- Barra com pesquisa e botão novo fornecedor -->
        <div class="toolbar">
            <div class="search-box">
                <!-- Input onde digito para filtrar a tabela -->
                <input type="text" id="searchInput"
                       placeholder="🔍 Pesquisar por empresa ou CNPJ..."
                       onkeyup="filtrarTabela()">
                <span class="search-icon">🔍</span>
                
               
            </div>
            <a href="../index.jsp" class="btn-home">🏠 Menu Principal</a>

            <!-- Botão que leva ao formulário de novo fornecedor -->
            <a href="formFornecedor.jsp" class="btn btn-primary">+ Novo Fornecedor</a>
        </div>

        <!-- Aqui vai aparecer o número de resultados -->
        <p class="result-count" id="resultCount"></p>

        <%
            // Aqui eu acesso o banco:
            // Crio um objeto DAO e chamo listarTodos()
            FornecedorDAO dao = new FornecedorDAO();
            List<Fornecedor> fornecedores = dao.listarTodos();

            // Se a lista não estiver vazia, mostro a tabela
            if (fornecedores != null && !fornecedores.isEmpty()) {
        %>

        <!-- Tabela que lista os fornecedores -->
        <table id="tabelaFornecedores">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Empresa</th>
                    <th>CNPJ</th>
                    <th>Telefone</th>
                    <th>Tipo de Produto</th>
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody>

                <!-- Aqui eu percorro todos os fornecedores da lista -->
                <% for (Fornecedor f : fornecedores) { %>
                <tr>
                    <td><%= f.getIdFornecedor() %></td>
                    <td><%= f.getNomeEmpresa() %></td>
                    <td><%= f.getCnpj() %></td>
                    <td><%= f.getTelefone() %></td>

                    <!-- Tipo do produto dentro de uma “badge” bonitinha -->
                    <td><span class="badge"><%= f.getTipoProduto() %></span></td>

                    <td>
                        <div class="actions">
                            <!-- Botão editar -->
                            <a href="formFornecedor.jsp?id=<%= f.getIdFornecedor() %>"
                               class="btn btn-success">Editar</a>

                            <!-- Botão excluir -->
                            <a href="processarFornecedor.jsp?acao=deletar&id=<%= f.getIdFornecedor() %>"
                               class="btn btn-danger"
                               onclick="return confirm('Deseja realmente excluir este fornecedor?')">
                               Excluir
                            </a>
                        </div>
                    </td>
                </tr>
                <% } %>

            </tbody>
        </table>

        <% } else { %>

        <!-- Caso a lista de fornecedores esteja vazia -->
        <div class="empty-state">
            <h3>Nenhum fornecedor cadastrado</h3>
            <p>Comece adicionando seu primeiro fornecedor!</p>
        </div>

        <% } %>

        <!-- Quando a pesquisa não encontrar resultados -->
        <div id="noResults" class="empty-state" style="display: none;">
            <h3>Nenhum resultado encontrado</h3>
            <p>Tente pesquisar com outros termos</p>
        </div>

    </div>

    <!-- Aqui começa o JavaScript da página -->
    <script>
        // Função que filtra a tabela digitando no campo de pesquisa
        function filtrarTabela() {
            const input = document.getElementById('searchInput').value.toLowerCase();
            const table = document.getElementById('tabelaFornecedores');
            const tbody = table.getElementsByTagName('tbody')[0];
            const rows = tbody.getElementsByTagName('tr');
            const noResults = document.getElementById('noResults');
            const resultCount = document.getElementById('resultCount');

            let visibleCount = 0;

            // Aqui eu verifico linha por linha
            for (let i = 0; i < rows.length; i++) {
                const cells = rows[i].getElementsByTagName('td');
                const empresa = cells[1].textContent.toLowerCase();
                const cnpj = cells[2].textContent.toLowerCase();

                // Se a empresa OU o cnpj contiverem o que digitei, mostra a linha
                if (empresa.includes(input) || cnpj.includes(input)) {
                    rows[i].style.display = '';
                    visibleCount++;
                } else {
                    rows[i].style.display = 'none';
                }
            }

            // Se não achou nada
            if (visibleCount === 0 && input !== '') {
                noResults.style.display = 'block';
                table.style.display = 'none';
            } else {
                noResults.style.display = 'none';
                table.style.display = 'table';
            }

            // Mostra quantos resultados apareceram
            if (input !== '') {
                resultCount.textContent = visibleCount + ' resultado(s) encontrado(s)';
            } else {
                resultCount.textContent = '';
            }
        }

        // Quando a página carrega, mostra quantos fornecedores existem no total
        window.onload = function() {
            const table = document.getElementById('tabelaFornecedores');
            if (table) {
                const totalRows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr').length;
                document.getElementById('resultCount').textContent =
                    totalRows + ' fornecedor(es) cadastrado(s)';
            }
        };
    </script>
</body>
</html>

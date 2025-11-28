<%-- 
    Document   : formPedido
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="confeitaria.model.Cliente" %>
<%@ page import="confeitaria.model.Produto" %>
<%@ page import="confeitaria.model.Funcionario" %>
<%@ page import="confeitaria.model.Fornecedor" %>
<%@ page import="confeitaria.dao.ClienteDAO" %>
<%@ page import="confeitaria.dao.ProdutoDAO" %>
<%@ page import="confeitaria.dao.FuncionarioDAO" %>
<%@ page import="confeitaria.dao.FornecedorDAO" %>

<!-- Aqui começam as tags HTML normais -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Novo Pedido - Cantinho Gourmet</title>

    <!-- CSS do estilo visual -->
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
        
        h1 {
            color: #fa709a;
            margin-bottom: 30px;
        }
        
        .form-section {
            margin-bottom: 30px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
        }
        
        .form-section h2 {
            color: #333;
            font-size: 1.3em;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #fa709a;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }
        
        select, input, textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        select:focus, input:focus, textarea:focus {
            outline: none;
            border-color: #fa709a;
        }
        
        textarea {
            resize: vertical;
            min-height: 80px;
        }
        
        .item-row {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr auto;
            gap: 10px;
            align-items: end;
            margin-bottom: 10px;
            padding: 15px;
            background: white;
            border-radius: 5px;
        }
        
        .btn-remove {
            padding: 12px 20px;
            background: #dc3545;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-remove:hover {
            background: #c82333;
        }
        
        .btn-add {
            padding: 10px 20px;
            background: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 10px;
            transition: all 0.3s;
        }
        
        .btn-add:hover {
            background: #218838;
        }
        
        .total-section {
            background: #fff3cd;
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
        }
        
        .total-label {
            font-size: 1.3em;
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
            padding: 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: #fa709a;
            color: white;
        }
        
        .btn-primary:hover {
            background: #e85d87;
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
            text-decoration: none;
            text-align: center;
            line-height: 1;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }
        
        .alert {
            padding: 15px;
            background: #d1ecf1;
            border-left: 4px solid #0c5460;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>

<body>
    <div class="container">

        <h1>🛒 Novo Pedido</h1>

        <!-- Mensagem informativa -->
        <div class="alert">
            <strong>💡 Dica:</strong> O estoque vai diminuir automaticamente quando o pedido for salvo!
        </div>

        <!-- FORMULÁRIO PRINCIPAL -->
        <form action="processarPedido.jsp" method="post" id="formPedido">

            <!-- SEÇÃO CLIENTE | FUNCIONÁRIO | FORNECEDOR -->
            <div class="form-section">
                <h2>👤 Informações do Pedido</h2>

                <!-- Selecionar cliente -->
                <div class="form-group">
                    <label>Selecione o Cliente *</label>
                    <select id="idCliente" name="idCliente" required>
                        <option value="">Escolha um cliente...</option>

                        <!-- Aqui eu estou buscando os clientes no banco via DAO -->
                        <%
                            ClienteDAO clienteDAO = new ClienteDAO();
                            List<Cliente> clientes = clienteDAO.listarTodos();
                            for (Cliente c : clientes) {
                        %>
                            <option value="<%= c.getIdCliente() %>">
                                <%= c.getNome() %> - <%= c.getCpf() %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <!-- Selecionar funcionário -->
                <div class="form-group">
                    <label>Funcionário Responsável *</label>
                    <select id="idFuncionario" name="idFuncionario" required>
                        <option value="">Escolha um funcionário...</option>

                        <%
                            FuncionarioDAO funcionarioDAO = new FuncionarioDAO();
                            List<Funcionario> funcionarios = funcionarioDAO.listarTodos();
                            for (Funcionario f : funcionarios) {
                        %>
                            <option value="<%= f.getIdFuncionario() %>">
                                <%= f.getNome() %> - <%= f.getCargo() %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <!-- Fornecedor opcional -->
                <div class="form-group">
                    <label>Fornecedor (Opcional)</label>
                    <select id="idFornecedor" name="idFornecedor">
                        <option value="">Sem fornecedor específico</option>

                        <%
                            FornecedorDAO fornecedorDAO = new FornecedorDAO();
                            List<Fornecedor> fornecedores = fornecedorDAO.listarTodos();
                            for (Fornecedor fr : fornecedores) {
                        %>
                            <option value="<%= fr.getIdFornecedor() %>">
                                <%= fr.getNomeEmpresa() %> - <%= fr.getTipoProduto() %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <!-- Campo de observações -->
                <div class="form-group">
                    <label>Observações</label>
                    <textarea name="observacoes"></textarea>
                </div>
            </div>

            <!-- SEÇÃO DOS PRODUTOS DO PEDIDO -->
            <div class="form-section">
                <h2>🍰 Itens do Pedido</h2>

                <div id="itensContainer">

                    <!-- Primeira linha de item do pedido -->
                    <div class="item-row">

                        <!-- Produto -->
                        <div class="form-group">
                            <label>Produto *</label>
                            <select name="idProduto[]" class="produto-select" required onchange="atualizarPreco(this)">
                                <option value="">Escolha um produto...</option>

                                <!-- Laço para listar produtos do banco -->
                                <%
                                    ProdutoDAO produtoDAO = new ProdutoDAO();
                                    List<Produto> produtos = produtoDAO.listarTodos();
                                    for (Produto p : produtos) {
                                %>
                                    <option value="<%= p.getIdProduto() %>" data-preco="<%= p.getPreco() %>">
                                        <%= p.getNome() %> - R$ <%= String.format("%.2f", p.getPreco()) %> 
                                        (Estoque: <%= p.getEstoque() %>)
                                    </option>
                                <% } %>
                            </select>
                        </div>

                        <!-- Quantidade -->
                        <div class="form-group">
                            <label>Quantidade *</label>
                            <input type="number" name="quantidade[]" class="quantidade-input" min="1" value="1" required onchange="calcularTotal()">
                        </div>

                        <!-- Preço -->
                        <div class="form-group">
                            <label>Preço Unit.</label>
                            <input type="number" name="preco[]" class="preco-input" step="0.01" readonly>
                        </div>

                        <!-- Botão remover -->
                        <button type="button" class="btn-remove" onclick="removerItem(this)" disabled>Remover</button>
                    </div>
                </div>

                <!-- Botão para adicionar novo item -->
                <button type="button" class="btn-add" onclick="adicionarItem()">+ Adicionar Produto</button>
            </div>

            <!-- SEÇÃO DO TOTAL -->
            <div class="total-section">
                <span class="total-label">Valor Total:</span>
                <span class="total-value" id="valorTotal">R$ 0,00</span>
            </div>

            <!-- Botões finais -->
            <div class="btn-group">
                <button type="submit" class="btn btn-primary">Confirmar Pedido</button>
                <a href="listarPedidos.jsp" class="btn btn-secondary">Cancelar</a>
            </div>

        </form>
    </div>

    <!-- SCRIPT JAVASCRIPT PARA CALCULAR TOTAL, ADICIONAR E REMOVER ITENS -->
    <script>

        let itemCount = 1; // contador de itens do pedido

        // Função para adicionar nova linha de produto
        function adicionarItem() {
            const container = document.getElementById('itensContainer');

            // Clono a primeira linha
            const novoItem = document.querySelector('.item-row').cloneNode(true);

            // Limpo os campos
            novoItem.querySelector('.produto-select').selectedIndex = 0;
            novoItem.querySelector('.quantidade-input').value = 1;
            novoItem.querySelector('.preco-input').value = "";
            novoItem.querySelector('.btn-remove').disabled = false;

            container.appendChild(novoItem);
        }

        // Função para remover uma linha de produto
        function removerItem(btn) {
            const linhas = document.querySelectorAll('.item-row');

            // Só deixa remover se tiver mais de 1 item
            if (linhas.length > 1) {
                btn.closest('.item-row').remove();
                calcularTotal();
            }
        }

        // Atualiza o preço quando muda o produto
        function atualizarPreco(select) {
            const row = select.closest('.item-row');
            const precoInput = row.querySelector('.preco-input');
            const option = select.options[select.selectedIndex];

            const preco = option.getAttribute("data-preco");

            if (preco) {
                precoInput.value = parseFloat(preco).toFixed(2);
            } else {
                precoInput.value = "";
            }

            calcularTotal();
        }

        // Calcula o total do pedido
        function calcularTotal() {
            let total = 0;

            const rows = document.querySelectorAll('.item-row');

            rows.forEach(row => {
                const quantidade = parseFloat(row.querySelector('.quantidade-input').value) || 0;
                const preco = parseFloat(row.querySelector('.preco-input').value) || 0;

                total += quantidade * preco;
            });

            document.getElementById('valorTotal').textContent =
                "R$ " + total.toFixed(2).replace(".", ",");
        }

        // Validação antes de enviar
        document.getElementById("formPedido").addEventListener("submit", function(e) {
            const itens = document.querySelectorAll('.item-row');
            let temProduto = false;

            itens.forEach(item => {
                if (item.querySelector(".produto-select").value !== "") {
                    temProduto = true;
                }
            });

            if (!temProduto) {
                alert("Adicione pelo menos um produto!");
                e.preventDefault();
            }
        });

    </script>

</body>
</html>

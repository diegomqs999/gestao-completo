<%-- 
    Document   : formProduto
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="confeitaria.model.Produto" %> <!-- importa classe Produto -->
<%@ page import="confeitaria.dao.ProdutoDAO" %> <!-- importa DAO -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Formulário Produto - Cantinho Gourmet</title>
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
            max-width: 600px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }
        
        h1 {
            color: #00f2fe;
            margin-bottom: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }
        
        input[type="text"],
        input[type="number"],
        select {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        input:focus,
        select:focus {
            outline: none;
            border-color: #00f2fe;
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
            font-size: 16px;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: #4facfe;
            color: white;
        }
        
        .btn-primary:hover {
            background: #3b8fd6;
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
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <%
            String idParam = request.getParameter("id"); // pega id se estiver editando
            Produto produto = null;
            boolean isEdicao = false; // verifica se é edição
            
            if (idParam != null && !idParam.isEmpty()) {
                isEdicao = true;
                ProdutoDAO dao = new ProdutoDAO();
                produto = dao.buscarPorId(Integer.parseInt(idParam)); // busca produto
            }
        %>
        
        <h1><%= isEdicao ? "Editar Produto" : "Novo Produto" %></h1> <!-- título dinâmico -->
        
        <form action="processarProduto.jsp" method="post">
            <input type="hidden" name="acao" value="<%= isEdicao ? "atualizar" : "inserir" %>"> <!-- define ação -->
            <% if (isEdicao && produto != null) { %>
                <input type="hidden" name="id" value="<%= produto.getIdProduto() %>"> <!-- envia id -->
            <% } %>
            
            <div class="form-group">
                <label for="nome">Nome do Produto *</label>
                <input type="text" id="nome" name="nome" 
                       value="<%= isEdicao ? produto.getNome() : "" %>" 
                       required> <!-- nome -->
            </div>
            
            <div class="form-group">
                <label for="categoria">Categoria *</label>
                <select id="categoria" name="categoria" required>
                    <!-- seleciona categoria automaticamente -->
                    <option value="">Selecione...</option>
                    <option value="Bolos" <%= isEdicao && "Bolos".equals(produto.getCategoria()) ? "selected" : "" %>>Bolos</option>
                    <option value="Tortas" <%= isEdicao && "Tortas".equals(produto.getCategoria()) ? "selected" : "" %>>Tortas</option>
                    <option value="Doces" <%= isEdicao && "Doces".equals(produto.getCategoria()) ? "selected" : "" %>>Doces</option>
                    <option value="Salgados" <%= isEdicao && "Salgados".equals(produto.getCategoria()) ? "selected" : "" %>>Salgados</option>
                    <option value="Bebidas" <%= isEdicao && "Bebidas".equals(produto.getCategoria()) ? "selected" : "" %>>Bebidas</option>
                    <option value="Outros" <%= isEdicao && "Outros".equals(produto.getCategoria()) ? "selected" : "" %>>Outros</option>
                </select>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="preco">Preço (R$) *</label>
                    <input type="number" id="preco" name="preco" step="0.01" min="0"
                           value="<%= isEdicao ? produto.getPreco() : "" %>" 
                           required> <!-- preço -->
                </div>
                
                <div class="form-group">
                    <label for="estoque">Estoque *</label>
                    <input type="number" id="estoque" name="estoque" min="0"
                           value="<%= isEdicao ? produto.getEstoque() : "" %>" 
                           required> <!-- estoque -->
                </div>
            </div>
            
            <div class="btn-group">
                <button type="submit" class="btn btn-primary">
                    <%= isEdicao ? "Atualizar" : "Cadastrar" %> <!-- texto do botão -->
                </button>
                <a href="listarProdutos.jsp" class="btn btn-secondary">Cancelar</a>
            </div>
        </form>
    </div>
</body>
</html>

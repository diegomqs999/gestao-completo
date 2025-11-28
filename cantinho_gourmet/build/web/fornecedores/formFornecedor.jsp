<%-- 
    Document   : formFornecedor
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="confeitaria.model.Fornecedor" %>
<%@ page import="confeitaria.dao.FornecedorDAO" %>

<!-- Aqui começa o HTML normal -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Formulário Fornecedor - Cantinho Gourmet</title>

    <style>
        /* Aqui é só o CSS da tela, pra deixar bonitinho */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI';
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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

        /* Título */
        h1 {
            color: #f5576c;
            margin-bottom: 30px;
        }

        /* Campos do formulário */
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }
        
        /* Inputs */
        input[type="text"],
        input[type="email"],
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
            border-color: #f5576c;
        }

        /* Botões */
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
            background: #f5576c;
            color: white;
        }
        
        .btn-primary:hover {
            background: #e14658;
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
            text-align: center;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }

    </style>
</head>
<body>

    <div class="container">

        <%
            // Aqui eu verifico se veio um "id" na URL
            // Se vier, significa que estou editando um fornecedor
            String idParam = request.getParameter("id");
            Fornecedor fornecedor = null;
            boolean isEdicao = false;
            
            if (idParam != null && !idParam.isEmpty()) {
                isEdicao = true; // muda pra modo edição
                FornecedorDAO dao = new FornecedorDAO();
                // Busca o fornecedor no banco pelo ID
                fornecedor = dao.buscarPorId(Integer.parseInt(idParam));
            }
        %>
        
        <!-- Aqui o título muda dependendo se estou editando ou criando -->
        <h1><%= isEdicao ? "Editar Fornecedor" : "Novo Fornecedor" %></h1>
        
        <!-- Aqui começa o formulário que vai enviar pro processarFornecedor.jsp -->
        <form action="processarFornecedor.jsp" method="post">

            <!-- Aqui eu envio a ação escondida: inserir ou atualizar -->
            <input type="hidden" name="acao" value="<%= isEdicao ? "atualizar" : "inserir" %>">

            <!-- Se for edição eu também mando o ID escondido -->
            <% if (isEdicao && fornecedor != null) { %>
                <input type="hidden" name="id" value="<%= fornecedor.getIdFornecedor() %>">
            <% } %>
            
            <!-- Campo nome da empresa -->
            <div class="form-group">
                <label for="nomeEmpresa">Nome da Empresa *</label>
                <input type="text" id="nomeEmpresa" name="nomeEmpresa"
                       value="<%= isEdicao ? fornecedor.getNomeEmpresa() : "" %>"
                       required>
            </div>
            
            <!-- Campo CNPJ -->
            <div class="form-group">
                <label for="cnpj">CNPJ *</label>
                <input type="text" id="cnpj" name="cnpj"
                       value="<%= isEdicao ? fornecedor.getCnpj() : "" %>"
                       placeholder="00.000.000/0000-00"
                       required>
            </div>
            
            <!-- Telefone -->
            <div class="form-group">
                <label for="telefone">Telefone</label>
                <input type="text" id="telefone" name="telefone"
                       value="<%= isEdicao ? fornecedor.getTelefone() : "" %>"
                       placeholder="(00) 0000-0000">
            </div>
            
            <!-- E-mail -->
            <div class="form-group">
                <label for="email">E-mail</label>
                <input type="email" id="email" name="email"
                       value="<%= isEdicao ? fornecedor.getEmail() : "" %>"
                       placeholder="contato@empresa.com">
            </div>
            
            <!-- Endereço -->
            <div class="form-group">
                <label for="endereco">Endereço</label>
                <input type="text" id="endereco" name="endereco"
                       value="<%= isEdicao ? fornecedor.getEndereco() : "" %>"
                       placeholder="Rua, número, bairro">
            </div>
            
            <!-- Tipo de Produto -->
            <div class="form-group">
                <label for="tipoProduto">Tipo de Produto *</label>
                <select id="tipoProduto" name="tipoProduto" required>
                    <option value="">Selecione...</option>
                    <option value="Ingredientes" <%= isEdicao && "Ingredientes".equals(fornecedor.getTipoProduto()) ? "selected" : "" %>>Ingredientes</option>
                    <option value="Embalagens" <%= isEdicao && "Embalagens".equals(fornecedor.getTipoProduto()) ? "selected" : "" %>>Embalagens</option>
                    <option value="Equipamentos" <%= isEdicao && "Equipamentos".equals(fornecedor.getTipoProduto()) ? "selected" : "" %>>Equipamentos</option>
                    <option value="Decoração" <%= isEdicao && "Decoração".equals(fornecedor.getTipoProduto()) ? "selected" : "" %>>Decoração</option>
                    <option value="Outros" <%= isEdicao && "Outros".equals(fornecedor.getTipoProduto()) ? "selected" : "" %>>Outros</option>
                </select>
            </div>
            
            <!-- Botões -->
            <div class="btn-group">
                <button type="submit" class="btn btn-primary">
                    <%= isEdicao ? "Atualizar" : "Cadastrar" %>
                </button>
                <a href="listarFornecedores.jsp" class="btn btn-secondary">Cancelar</a>
            </div>

        </form>
    </div>

</body>
</html>

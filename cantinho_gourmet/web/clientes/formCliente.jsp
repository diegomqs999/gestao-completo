<%-- 
    Document   : formCliente
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897
--%>

<%-- 
    Esse arquivo é o formulário do cliente. Acho que é onde a gente cadastra ou edita um cliente.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="confeitaria.model.Cliente" %>
<%@ page import="confeitaria.dao.ClienteDAO" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Formulário Cliente - Cantinho Gourmet</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            color: #764ba2;
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
        input[type="email"] {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        input:focus {
            outline: none;
            border-color: #667eea;
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
            background: #667eea;
            color: white;
        }
        
        .btn-primary:hover {
            background: #5568d3;
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
    </style>

</head>
<body>
    <div class="container">

        <%
            // Aqui eu estou pegando o "id" da URL. Ex: formCliente.jsp?id=3
            String idParam = request.getParameter("id");

            Cliente cliente = null; // Objeto do cliente que eu vou preencher se for edição
            boolean isEdicao = false; // Aqui eu vou saber se estou editando ou cadastrando
            
            // Se tiver ID, então é edição
            if (idParam != null && !idParam.isEmpty()) {
                isEdicao = true;

                // Criando o DAO pra buscar os dados do cliente
                ClienteDAO dao = new ClienteDAO();

                // Buscando o cliente no banco
                cliente = dao.buscarPorId(Integer.parseInt(idParam));
            }
        %>
        
        <!-- Aqui o título muda dependendo se é edição ou cadastro -->
        <h1><%= isEdicao ? "Editar Cliente" : "Novo Cliente" %></h1>
        
        <!-- O formulário manda os dados para processarCliente.jsp -->
        <form action="processarCliente.jsp" method="post">

            <!-- Aqui envio se estou atualizando ou inserindo -->
            <input type="hidden" name="acao" value="<%= isEdicao ? "atualizar" : "inserir" %>">

            <% if (isEdicao && cliente != null) { %>
                <!-- Se for edição, também mando o ID escondido -->
                <input type="hidden" name="id" value="<%= cliente.getIdCliente() %>">
            <% } %>
            
            <!-- Campo nome -->
            <div class="form-group">
                <label for="nome">Nome Completo *</label>
                <input type="text" id="nome" name="nome" 
                       value="<%= isEdicao && cliente != null ? cliente.getNome() : "" %>" 
                       required>
            </div>
            
            <!-- Campo CPF -->
            <div class="form-group">
                <label for="cpf">CPF *</label>
                <input type="text" id="cpf" name="cpf" 
                       value="<%= isEdicao && cliente != null ? cliente.getCpf() : "" %>" 
                       placeholder="000.000.000-00" 
                       required>
            </div>
            
            <!-- Campo telefone -->
            <div class="form-group">
                <label for="telefone">Telefone</label>
                <input type="text" id="telefone" name="telefone" 
                       value="<%= isEdicao && cliente != null ? cliente.getTelefone() : "" %>" 
                       placeholder="(00) 00000-0000">
            </div>
            
            <!-- Campo email -->
            <div class="form-group">
                <label for="email">E-mail</label>
                <input type="email" id="email" name="email" 
                       value="<%= isEdicao && cliente != null ? cliente.getEmail() : "" %>" 
                       placeholder="cliente@email.com">
            </div>
            
            <!-- Campo endereço -->
            <div class="form-group">
                <label for="endereco">Endereço</label>
                <input type="text" id="endereco" name="endereco" 
                       value="<%= isEdicao && cliente != null ? cliente.getEndereco() : "" %>" 
                       placeholder="Rua, número, bairro">
            </div>
            
            <!-- Botões -->
            <div class="btn-group">
                <button type="submit" class="btn btn-primary">
                    <%= isEdicao ? "Atualizar" : "Cadastrar" %>
                </button>

                <!-- Botão cancelar só volta pra listagem -->
                <a href="listarClientes.jsp" class="btn btn-secondary">Cancelar</a>
            </div>
        </form>
    </div>
</body>
</html>

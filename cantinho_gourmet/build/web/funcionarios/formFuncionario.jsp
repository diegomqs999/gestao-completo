<%-- 
    Document   : formFuncionario
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Importando as classes que vou usar -->
<%@ page import="confeitaria.model.Funcionario" %>
<%@ page import="confeitaria.dao.FuncionarioDAO" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Formulário Funcionário - Cantinho Gourmet</title>

    <style>
        /* Reset básico de CSS */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        /* Configuração do fundo da página */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            min-height: 100vh;
            padding: 20px;
        }

        /* Div principal que segura o formulário */
        .container {
            max-width: 600px; /* tamanho máximo da caixa */
            margin: 0 auto;  /* centraliza */
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2); /* sombra da caixa */
        }

        h1 {
            color: #38f9d7;
            margin-bottom: 30px;
        }

        /* Cada campo do formulário */
        .form-group {
            margin-bottom: 20px;
        }

        /* Label do campo */
        label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }

        /* Estilo de todos os inputs */
        input[type="text"],
        input[type="email"],
        input[type="number"],
        select {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        /* Quando o usuário clica no campo */
        input:focus,
        select:focus {
            outline: none;
            border-color: #38f9d7;
        }

        /* Botões alinhados lado a lado */
        .btn-group {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }

        /* Estilo padrão dos botões */
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

        /* Botão verde de enviar */
        .btn-primary {
            background: #43e97b;
            color: white;
        }

        .btn-primary:hover {
            background: #32d66a;
        }

        /* Botão cinza de cancelar */
        .btn-secondary {
            background: #6c757d;
            color: white;
            text-decoration: none;
            text-align: center;
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
            // Aqui eu pego o ID enviado pela URL (se tiver)
            String idParam = request.getParameter("id");
            Funcionario funcionario = null;
            boolean isEdicao = false;

            // Se o ID existe, quer dizer que estou editando um funcionário
            if (idParam != null && !idParam.isEmpty()) {
                isEdicao = true;

                // Crio o DAO para buscar o funcionário no banco
                FuncionarioDAO dao = new FuncionarioDAO();

                // Busco o funcionário pelo ID
                funcionario = dao.buscarPorId(Integer.parseInt(idParam));
            }
        %>

        <!-- Título muda dependendo se é edição ou cadastro -->
        <h1><%= isEdicao ? "Editar Funcionário" : "Novo Funcionário" %></h1>

        <!-- Formulário que envia para processarFuncionario.jsp -->
        <form action="processarFuncionario.jsp" method="post">

            <!-- Ação usada para saber o que fazer -->
            <input type="hidden" name="acao" value="<%= isEdicao ? "atualizar" : "inserir" %>">

            <% 
                // Se estiver editando, coloco o ID escondido no formulário
                if (isEdicao && funcionario != null) { 
            %>
                <input type="hidden" name="id" value="<%= funcionario.getIdFuncionario() %>">
            <% } %>

            <!-- Campo nome -->
            <div class="form-group">
                <label for="nome">Nome Completo *</label>
                <input type="text" id="nome" name="nome"
                       value="<%= isEdicao && funcionario != null ? funcionario.getNome() : "" %>"
                       required>
            </div>

            <!-- Campo cargo -->
            <div class="form-group">
                <label for="cargo">Cargo *</label>
                <select id="cargo" name="cargo" required>
                    <option value="">Selecione...</option>
                    <option value="Confeiteiro" <%= isEdicao && funcionario != null && "Confeiteiro".equals(funcionario.getCargo()) ? "selected" : "" %>>Confeiteiro</option>
                    <option value="Auxiliar de Cozinha" <%= isEdicao && funcionario != null && "Auxiliar de Cozinha".equals(funcionario.getCargo()) ? "selected" : "" %>>Auxiliar de Cozinha</option>
                    <option value="Atendente" <%= isEdicao && funcionario != null && "Atendente".equals(funcionario.getCargo()) ? "selected" : "" %>>Atendente</option>
                    <option value="Caixa" <%= isEdicao && funcionario != null && "Caixa".equals(funcionario.getCargo()) ? "selected" : "" %>>Caixa</option>
                    <option value="Gerente" <%= isEdicao && funcionario != null && "Gerente".equals(funcionario.getCargo()) ? "selected" : "" %>>Gerente</option>
                    <option value="Entregador" <%= isEdicao && funcionario != null && "Entregador".equals(funcionario.getCargo()) ? "selected" : "" %>>Entregador</option>
                </select>
            </div>

            <!-- Campo salário -->
            <div class="form-group">
                <label for="salario">Salário (R$) *</label>
                <input type="number" id="salario" name="salario" step="0.01" min="0"
                       value="<%= isEdicao && funcionario != null ? funcionario.getSalario() : "" %>"
                       placeholder="0.00"
                       required>
            </div>

            <!-- Campo telefone -->
            <div class="form-group">
                <label for="telefone">Telefone</label>
                <input type="text" id="telefone" name="telefone"
                       value="<%= isEdicao && funcionario != null ? funcionario.getTelefone() : "" %>"
                       placeholder="(00) 00000-0000">
            </div>

            <!-- Campo email -->
            <div class="form-group">
                <label for="email">E-mail</label>
                <input type="email" id="email" name="email"
                       value="<%= isEdicao && funcionario != null ? funcionario.getEmail() : "" %>"
                       placeholder="email@exemplo.com">
            </div>

            <!-- Botões -->
            <div class="btn-group">
                <button type="submit" class="btn btn-primary">
                    <%= isEdicao ? "Atualizar" : "Cadastrar" %>
                </button>

                <a href="listarFuncionarios.jsp" class="btn btn-secondary">Cancelar</a>
            </div>

        </form>

    </div>
</body>
</html>

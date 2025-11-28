<%-- 
    Document   : processarFuncionario
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="confeitaria.model.Funcionario" %>
<%@ page import="confeitaria.dao.FuncionarioDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.StringWriter" %>

<%
    // Aqui eu pego a ação que veio da URL, tipo "inserir", "atualizar" ou "deletar"
    String acao = request.getParameter("acao");

    // Crio o DAO pra poder mexer no banco
    FuncionarioDAO dao = new FuncionarioDAO();

    // Variável que diz se deu certo ou não
    boolean sucesso = false;

    // Aqui fica a mensagem de erro caso aconteça algo
    String mensagemErro = "";

    // Variável pra guardar o erro completo, se tiver
    Exception erroException = null;
    
    try {
        // Se a ação for inserir um funcionário novo
        if ("inserir".equals(acao)) {

            // Crio o objeto funcionário e coloco os dados do formulário nele
            Funcionario funcionario = new Funcionario();
            funcionario.setNome(request.getParameter("nome"));
            funcionario.setCargo(request.getParameter("cargo"));
            funcionario.setSalario(Double.parseDouble(request.getParameter("salario")));
            funcionario.setTelefone(request.getParameter("telefone"));
            funcionario.setEmail(request.getParameter("email"));
            
            // Chamo o método pra inserir no banco
            sucesso = dao.inserir(funcionario);
            
        // Se a ação for atualizar um funcionário existente
        } else if ("atualizar".equals(acao)) {

            Funcionario funcionario = new Funcionario();
            funcionario.setIdFuncionario(Integer.parseInt(request.getParameter("id")));
            funcionario.setNome(request.getParameter("nome"));
            funcionario.setCargo(request.getParameter("cargo"));
            funcionario.setSalario(Double.parseDouble(request.getParameter("salario")));
            funcionario.setTelefone(request.getParameter("telefone"));
            funcionario.setEmail(request.getParameter("email"));
            
            sucesso = dao.atualizar(funcionario);
            
        // Se a ação for deletar pelo ID
        } else if ("deletar".equals(acao)) {

            int id = Integer.parseInt(request.getParameter("id"));
            sucesso = dao.deletar(id);
        }
        
        // Se deu certo, mando pra página de listar
        if (sucesso) {
            response.sendRedirect("listarFuncionarios.jsp");

        // Se não deu certo, coloco mensagem de erro simples
        } else {
            mensagemErro = "Erro: A operação retornou FALSE. Verifique se o banco de dados está acessível e se a tabela existe.";
        }
        
    } catch (Exception e) {

        // Aqui eu pego a mensagem do erro e guardo a exceção completa
        mensagemErro = "ERRO: " + e.getMessage();
        erroException = e;
    }
    
    // Se teve erro, mostro a tela bonita de erro
    if (!mensagemErro.isEmpty()) {
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Erro - Cantinho Gourmet</title>

    <style>
        /* Aqui só tem estilo, então não preciso comentar muito */
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            min-height: 100vh;
        }
        .error-container {
            max-width: 800px;
            margin: 0 auto;
            background: #fff;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
        }
        h2 {
            color: #dc3545;
            margin-bottom: 20px;
        }
        .error-box {
            background: #f8d7da;
            border-left: 4px solid #dc3545;
            padding: 20px;
            margin: 20px 0;
            border-radius: 5px;
        }
        .error-message {
            color: #721c24;
            font-family: monospace;
            word-wrap: break-word;
            white-space: pre-wrap;
        }
        .info-box {
            background: #d1ecf1;
            border-left: 4px solid #0c5460;
            padding: 15px;
            margin: 15px 0;
            border-radius: 5px;
        }
        .info-title {
            font-weight: bold;
            color: #0c5460;
            margin-bottom: 10px;
        }
        .info-list {
            list-style: none;
            padding-left: 0;
        }
        .info-list li {
            padding: 5px 0;
            border-bottom: 1px solid #bee5eb;
        }
        .info-list li:last-child {
            border-bottom: none;
        }
        .btn-group {
            margin-top: 20px;
            display: flex;
            gap: 10px;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            color: white;
            font-weight: 500;
            transition: all 0.3s;
            display: inline-block;
        }
        .btn-primary {
            background: #43e97b;
        }
        .btn-primary:hover {
            background: #32d66a;
        }
        .btn-secondary {
            background: #6c757d;
        }
        .btn-secondary:hover {
            background: #5a6268;
        }
        .stack-trace {
            background: #f4f4f4;
            padding: 15px;
            border-radius: 5px;
            font-family: monospace;
            font-size: 12px;
            max-height: 300px;
            overflow-y: auto;
            margin-top: 15px;
        }
    </style>
</head>

<body>

    <div class="error-container">

        <h2>❌ Erro ao Processar Operação</h2>
        
        <!-- Aqui eu mostro a mensagem do erro -->
        <div class="error-box">
            <div class="error-message"><%= mensagemErro %></div>
        </div>
        
        <!-- Aqui eu mostro os dados que o formulário enviou (pra ajudar a revisar) -->
        <div class="info-box">
            <div class="info-title">📋 Dados Recebidos:</div>
            <ul class="info-list">
                <li><strong>Ação:</strong> <%= acao != null ? acao : "null" %></li>
                <li><strong>Nome:</strong> <%= request.getParameter("nome") != null ? request.getParameter("nome") : "null" %></li>
                <li><strong>Cargo:</strong> <%= request.getParameter("cargo") != null ? request.getParameter("cargo") : "null" %></li>
                <li><strong>Salário:</strong> <%= request.getParameter("salario") != null ? request.getParameter("salario") : "null" %></li>
                <li><strong>Telefone:</strong> <%= request.getParameter("telefone") != null ? request.getParameter("telefone") : "null" %></li>
                <li><strong>Email:</strong> <%= request.getParameter("email") != null ? request.getParameter("email") : "null" %></li>
            </ul>
        </div>
        
        <% if (erroException != null) { %>
        <!-- Aqui eu mostro o erro completo (stack trace), caso exista -->
        <div class="info-box">
            <div class="info-title">🔍 Stack Trace Completo:</div>
            <div class="stack-trace">
                <%
                    // Aqui eu pego o erro completo e transformo em texto pra mostrar na tela
                    StringWriter sw = new StringWriter();
                    PrintWriter pw = new PrintWriter(sw);
                    erroException.printStackTrace(pw);
                    out.println(sw.toString());
                %>
            </div>
        </div>
        <% } %>
        
        <!-- Aqui eu dou dicas do que pode ter dado errado -->
        <div class="info-box">
            <div class="info-title">💡 Possíveis Soluções:</div>
            <ul>
                <li>Verifique se o banco de dados <strong>cantinhoBD</strong> existe</li>
                <li>Verifique se a tabela <strong>funcionarios</strong> existe no banco</li>
                <li>Verifique se o MySQL está rodando</li>
                <li>Verifique o usuário e senha no ConnectionFactory.java</li>
                <li>Verifique o console da IDE para mais detalhes</li>
            </ul>
        </div>
        
        <!-- Botões pra navegar -->
        <div class="btn-group">
            <a href="formFuncionario.jsp" class="btn btn-primary">← Voltar ao Formulário</a>
            <a href="listarFuncionarios.jsp" class="btn btn-secondary">Ver Lista de Funcionários</a>
        </div>

    </div>
</body>
</html>

<%
    } // Fim do IF de erro
%>

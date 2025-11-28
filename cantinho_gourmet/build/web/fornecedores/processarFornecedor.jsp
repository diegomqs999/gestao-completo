<%-- 
    Document   : processarFornecedor
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="confeitaria.model.Fornecedor" %>
<%@ page import="confeitaria.dao.FornecedorDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.StringWriter" %>

<%
    // Aqui eu pego qual ação o usuário está tentando fazer (inserir, atualizar ou deletar)
    String acao = request.getParameter("acao");

    // Crio o DAO que vai conversar com o banco de dados
    FornecedorDAO dao = new FornecedorDAO();

    // Variáveis pra saber se deu certo ou errado
    boolean sucesso = false;
    String mensagemErro = "";
    Exception erroException = null;

    try {
        // Se a ação for inserir um fornecedor novo
        if ("inserir".equals(acao)) {

            // Crio o objeto fornecedor e preencho com os dados do formulário
            Fornecedor fornecedor = new Fornecedor();
            fornecedor.setNomeEmpresa(request.getParameter("nomeEmpresa"));
            fornecedor.setCnpj(request.getParameter("cnpj"));
            fornecedor.setTelefone(request.getParameter("telefone"));
            fornecedor.setEmail(request.getParameter("email"));
            fornecedor.setEndereco(request.getParameter("endereco"));
            fornecedor.setTipoProduto(request.getParameter("tipoProduto"));

            // Mando inserir no banco
            sucesso = dao.inserir(fornecedor);

        // Se for atualizar um fornecedor já existente
        } else if ("atualizar".equals(acao)) {

            Fornecedor fornecedor = new Fornecedor();
            fornecedor.setIdFornecedor(Integer.parseInt(request.getParameter("id")));
            fornecedor.setNomeEmpresa(request.getParameter("nomeEmpresa"));
            fornecedor.setCnpj(request.getParameter("cnpj"));
            fornecedor.setTelefone(request.getParameter("telefone"));
            fornecedor.setEmail(request.getParameter("email"));
            fornecedor.setEndereco(request.getParameter("endereco"));
            fornecedor.setTipoProduto(request.getParameter("tipoProduto"));

            sucesso = dao.atualizar(fornecedor);

        // Se for deletar um fornecedor pelo ID
        } else if ("deletar".equals(acao)) {

            int id = Integer.parseInt(request.getParameter("id"));
            sucesso = dao.deletar(id);
        }

        // Se deu tudo certo, volto pra página com os fornecedores
        if (sucesso) {
            response.sendRedirect("listarFornecedores.jsp");
        } else {
            // Se o DAO retornou false, algo deu errado no MySQL ou na tabela
            mensagemErro = "Erro: A operação retornou FALSE. Verifique se o banco de dados está acessível e se a tabela existe.";
        }

    } catch (Exception e) {
        // Se deu erro no try, salvo a mensagem e a exceção pra mostrar na tela
        mensagemErro = "ERRO: " + e.getMessage();
        erroException = e;
    }

    // Se tiver alguma mensagem de erro, mostro a página abaixo
    if (!mensagemErro.isEmpty()) {
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Erro - Cantinho Gourmet</title>
    <style>
        /* Estilização básica da página de erro */
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
        }
        .btn-primary {
            background: #f5576c;
        }
        .btn-secondary {
            background: #6c757d;
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
        <!-- Título do erro -->
        <h2>❌ Erro ao Processar Operação</h2>

        <!-- Caixa com a mensagem de erro principal -->
        <div class="error-box">
            <div class="error-message"><%= mensagemErro %></div>
        </div>

        <!-- Aqui mostro os dados que vieram do formulário (pra ajudar no debug) -->
        <div class="info-box">
            <div class="info-title">📋 Dados Recebidos:</div>
            <ul class="info-list">
                <li><strong>Ação:</strong> <%= acao %></li>
                <li><strong>Nome Empresa:</strong> <%= request.getParameter("nomeEmpresa") %></li>
                <li><strong>CNPJ:</strong> <%= request.getParameter("cnpj") %></li>
                <li><strong>Telefone:</strong> <%= request.getParameter("telefone") %></li>
                <li><strong>Email:</strong> <%= request.getParameter("email") %></li>
                <li><strong>Endereço:</strong> <%= request.getParameter("endereco") %></li>
                <li><strong>Tipo Produto:</strong> <%= request.getParameter("tipoProduto") %></li>
            </ul>
        </div>

        <% if (erroException != null) { %>
        <!-- Aqui exibo o stack trace completo (bem útil pra achar erros sérios) -->
        <div class="info-box">
            <div class="info-title">🔍 Stack Trace Completo:</div>
            <div class="stack-trace">
                <%
                    StringWriter sw = new StringWriter();
                    PrintWriter pw = new PrintWriter(sw);
                    erroException.printStackTrace(pw);
                    out.println(sw.toString());
                %>
            </div>
        </div>
        <% } %>

        <!-- Sugestões de como resolver o erro -->
        <div class="info-box">
            <div class="info-title">💡 Possíveis Soluções:</div>
            <ul>
                <li>Verifique se o banco <strong>cantinhoBD</strong> existe</li>
                <li>Verifique se a tabela <strong>fornecedores</strong> existe</li>
                <li>Verifique se o MySQL está rodando</li>
                <li>Veja se o usuário e senha no ConnectionFactory estão corretos</li>
            </ul>
        </div>

        <!-- Botões pra voltar -->
        <div class="btn-group">
            <a href="formFornecedor.jsp" class="btn btn-primary">← Voltar ao Formulário</a>
            <a href="listarFornecedores.jsp" class="btn btn-secondary">Ver Lista de Fornecedores</a>
        </div>
    </div>

</body>
</html>

<%
    }
// Fecha o "if" lá de cima
%>

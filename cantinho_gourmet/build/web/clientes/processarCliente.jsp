<%-- 
    Document   : processarCliente
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="confeitaria.model.Cliente" %>
<%@ page import="confeitaria.dao.ClienteDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.StringWriter" %>

<%
    // Aqui eu pego qual ação estou fazendo (inserir, atualizar ou deletar)
    String acao = request.getParameter("acao");
    
    // Crio o DAO para mexer no banco
    ClienteDAO dao = new ClienteDAO();
    
    // Variáveis para ver se deu certo ou deu erro
    boolean sucesso = false;
    String mensagemErro = "";
    Exception erroException = null;
    
    try {
        // Se a ação for inserir, cria um novo cliente e coloca os dados do formulário
        if ("inserir".equals(acao)) {
            Cliente cliente = new Cliente();
            cliente.setNome(request.getParameter("nome"));
            cliente.setCpf(request.getParameter("cpf"));
            cliente.setTelefone(request.getParameter("telefone"));
            cliente.setEmail(request.getParameter("email"));
            cliente.setEndereco(request.getParameter("endereco"));
            
            // Chamo o método do DAO para inserir no banco
            sucesso = dao.inserir(cliente);
            
        } else if ("atualizar".equals(acao)) {
            // Aqui é atualização. Pego o ID e atualizo todos os campos
            Cliente cliente = new Cliente();
            cliente.setIdCliente(Integer.parseInt(request.getParameter("id")));
            cliente.setNome(request.getParameter("nome"));
            cliente.setCpf(request.getParameter("cpf"));
            cliente.setTelefone(request.getParameter("telefone"));
            cliente.setEmail(request.getParameter("email"));
            cliente.setEndereco(request.getParameter("endereco"));
            
            sucesso = dao.atualizar(cliente);
            
        } else if ("deletar".equals(acao)) {
            // Aqui só preciso do ID para deletar
            int id = Integer.parseInt(request.getParameter("id"));
            sucesso = dao.deletar(id);
        }
        
        // Se deu certo, volto para a página de listagem
        if (sucesso) {
            response.sendRedirect("listarClientes.jsp");
        } else {
            // Se deu falso, é porque algo no banco não respondeu
            mensagemErro = "Erro: A operação retornou FALSE. Verifique se o banco de dados está acessível e se a tabela existe.";
        }
        
    } catch (Exception e) {
        // Se cair aqui é porque deu uma exception mesmo
        mensagemErro = "ERRO: " + e.getMessage();
        erroException = e;
    }
    
    // Se tiver mensagem de erro, eu exibo a tela bonitinha abaixo
    if (!mensagemErro.isEmpty()) {
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Erro - Cantinho Gourmet</title>
    <style>
        /* CSS só para deixar a tela mais bonita */
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
        h2 { color: #dc3545; margin-bottom: 20px; }
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
            white-space: pre-wrap;
        }
        .info-box {
            background: #d1ecf1;
            border-left: 4px solid #0c5460;
            padding: 15px;
            margin: 15px 0;
            border-radius: 5px;
        }
        .stack-trace {
            background: #f4f4f4;
            padding: 15px;
            border-radius: 5px;
            font-family: monospace;
            font-size: 12px;
            max-height: 300px;
            overflow-y: auto;
        }
    </style>
</head>
<body>

<div class="error-container">
    <h2>❌ Erro ao Processar Operação</h2>

    <!-- Aqui aparece a mensagem do erro -->
    <div class="error-box">
        <div class="error-message"><%= mensagemErro %></div>
    </div>

    <!-- Aqui mostra os dados que foram enviados -->
    <div class="info-box">
        <strong>📋 Dados Recebidos:</strong>
        <ul>
            <li><strong>Ação:</strong> <%= acao %></li>
            <li><strong>Nome:</strong> <%= request.getParameter("nome") %></li>
            <li><strong>CPF:</strong> <%= request.getParameter("cpf") %></li>
            <li><strong>Telefone:</strong> <%= request.getParameter("telefone") %></li>
            <li><strong>Email:</strong> <%= request.getParameter("email") %></li>
            <li><strong>Endereço:</strong> <%= request.getParameter("endereco") %></li>
        </ul>
    </div>

    <% if (erroException != null) { %>
    <!-- Aqui eu mostro o erro completo (stacktrace) -->
    <div class="info-box">
        <strong>🔍 Stack Trace Completo:</strong>
        <div class="stack-trace">
            <%
                // Aqui eu converto o erro para texto e imprimo
                StringWriter sw = new StringWriter();
                PrintWriter pw = new PrintWriter(sw);
                erroException.printStackTrace(pw);
                out.println(sw.toString());
            %>
        </div>
    </div>
    <% } %>

    <!-- Dicas para resolver o erro -->
    <div class="info-box">
        <strong>💡 Possíveis Soluções:</strong>
        <ul>
            <li>Verificar se o banco <strong>cantinhoBD</strong> existe</li>
            <li>Verificar se a tabela <strong>clientes</strong> existe</li>
            <li>Ver se o MySQL está rodando</li>
            <li>Ver usuário/senha da conexão</li>
        </ul>
    </div>

    <!-- Botões de voltar -->
    <a href="formCliente.jsp" class="btn btn-primary">← Voltar</a>
    <a href="listarClientes.jsp" class="btn btn-secondary">Lista de Clientes</a>

</div>

</body>
</html>

<%
    } // fim do if de erro
%>

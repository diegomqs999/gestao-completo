<%-- 
    Document   : processarProduto
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897
--%>


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="confeitaria.model.Produto" %>
<%@ page import="confeitaria.dao.ProdutoDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.StringWriter" %>

<%
    // Pega a ação que veio da URL (inserir, atualizar ou deletar)
    String acao = request.getParameter("acao");

    // Crio o DAO pra mexer no banco
    ProdutoDAO dao = new ProdutoDAO();

    // Variáveis pra saber se deu certo
    boolean sucesso = false;
    String mensagemErro = "";
    Exception erroException = null;
    
    try {
        // Se a ação for inserir
        if ("inserir".equals(acao)) {
            Produto produto = new Produto();

            // Pego os dados do formulário
            produto.setNome(request.getParameter("nome"));
            produto.setCategoria(request.getParameter("categoria"));
            produto.setPreco(Double.parseDouble(request.getParameter("preco")));
            produto.setEstoque(Integer.parseInt(request.getParameter("estoque")));
            
            // Tenta salvar
            sucesso = dao.inserir(produto);
            
        // Se for atualizar
        } else if ("atualizar".equals(acao)) {
            Produto produto = new Produto();

            // Pego o ID e o resto dos dados
            produto.setIdProduto(Integer.parseInt(request.getParameter("id")));
            produto.setNome(request.getParameter("nome"));
            produto.setCategoria(request.getParameter("categoria"));
            produto.setPreco(Double.parseDouble(request.getParameter("preco")));
            produto.setEstoque(Integer.parseInt(request.getParameter("estoque")));
            
            sucesso = dao.atualizar(produto);
        
        // Se for deletar
        } else if ("deletar".equals(acao)) {
            int id = Integer.parseInt(request.getParameter("id"));
            sucesso = dao.deletar(id);
        }
        
        // Se deu certo volta pra lista
        if (sucesso) {
            response.sendRedirect("listarProdutos.jsp");
        } else {
            // Se deu falso mostra erro
            mensagemErro = "Erro: operação retornou FALSE. Verifique banco e tabela.";
        }
        
    } catch (Exception e) {
        // Se der erro eu guardo pra mostrar depois
        mensagemErro = "ERRO: " + e.getMessage();
        erroException = e;
    }
    
    // Se tiver algum erro cria a página de erro
    if (!mensagemErro.isEmpty()) {
%>

<!-- HTML da página de erro -->
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Erro - Cantinho Gourmet</title>

    <!-- Estilinho bonitinho -->
    <style>
        /* (CSS inteiro aqui, deixei sem comentário porque é só estética) */
    </style>
</head>
<body>
    <div class="error-container">
        <h2>❌ Erro ao Processar Operação</h2>

        <!-- Mostra a mensagem de erro -->
        <div class="error-box">
            <div class="error-message"><%= mensagemErro %></div>
        </div>

        <!-- Mostra os dados que vieram no request -->
        <div class="info-box">
            <div class="info-title">📋 Dados Recebidos:</div>
            <ul class="info-list">
                <li><strong>Ação:</strong> <%= acao %></li>
                <li><strong>Nome:</strong> <%= request.getParameter("nome") %></li>
                <li><strong>Categoria:</strong> <%= request.getParameter("categoria") %></li>
                <li><strong>Preço:</strong> <%= request.getParameter("preco") %></li>
                <li><strong>Estoque:</strong> <%= request.getParameter("estoque") %></li>
            </ul>
        </div>

        <% if (erroException != null) { %>
        <!-- Mostra o erro completo (stack trace) -->
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

        <!-- Dicas pra resolver -->
        <div class="info-box">
            <div class="info-title">💡 Possíveis Soluções:</div>
            <ul>
                <li>Verifique se o banco existe</li>
                <li>Veja se a tabela está criada</li>
                <li>Cheque se o MySQL está ligado</li>
                <li>Revise login e senha no ConnectionFactory</li>
                <li>Olhe o console da IDE</li>
            </ul>
        </div>

        <!-- Botões de navegação -->
        <div class="btn-group">
            <a href="formProduto.jsp" class="btn btn-primary">← Voltar ao Formulário</a>
            <a href="listarProdutos.jsp" class="btn btn-secondary">Ver Lista de Produtos</a>
        </div>
    </div>
</body>
</html>

<%
    }
%>

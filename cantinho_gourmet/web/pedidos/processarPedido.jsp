<%-- 
    Document   : processarPedido
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897
--%>
<<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="confeitaria.model.Pedido" %> 
<%@ page import="confeitaria.model.ItemPedido" %> 
<%@ page import="confeitaria.dao.PedidoDAO" %> 
<%@ page import="confeitaria.dao.ProdutoDAO" %> 
<%@ page import="confeitaria.model.Produto" %> 

<%
    String acao = request.getParameter("acao"); // pega ação da página
    PedidoDAO dao = new PedidoDAO(); // cria DAO pra mexer no BD
    boolean sucesso = false; // pra saber se funcionou
    String mensagemErro = ""; // guarda erro

    try {
        if ("cancelar".equals(acao)) {
            // cancelar o pedido
            int id = Integer.parseInt(request.getParameter("id"));
            sucesso = dao.cancelarPedido(id);

            if (sucesso) {
                response.sendRedirect("listarPedidos.jsp"); // volta pra lista
            } else {
                mensagemErro = "Erro ao cancelar o pedido.";
            }

        } else if ("concluir".equals(acao)) {
            // concluir pedido
            int id = Integer.parseInt(request.getParameter("id"));
            sucesso = dao.atualizarStatus(id, "Concluído");

            if (sucesso) {
                response.sendRedirect("listarPedidos.jsp");
            } else {
                mensagemErro = "Erro ao concluir o pedido.";
            }

        } else {
            // inserir pedido novo

            Pedido pedido = new Pedido(); // novo pedido
            pedido.setIdCliente(Integer.parseInt(request.getParameter("idCliente"))); // cliente

            // pega funcionário e fornecedor se tiver
            String idFuncionario = request.getParameter("idFuncionario");
            String idFornecedor = request.getParameter("idFornecedor");

            if (idFuncionario != null && !idFuncionario.isEmpty()) {
                pedido.setIdFuncionario(Integer.parseInt(idFuncionario));
            }

            if (idFornecedor != null && !idFornecedor.isEmpty()) {
                pedido.setIdFornecedor(Integer.parseInt(idFornecedor));
            }

            pedido.setObservacoes(request.getParameter("observacoes")); // obs
            pedido.setStatus("Pendente"); // status inicial

            // pega arrays dos itens do pedido
            String[] idsProduto = request.getParameterValues("idProduto[]");
            String[] quantidades = request.getParameterValues("quantidade[]");
            String[] precos = request.getParameterValues("preco[]");

            if (idsProduto == null || idsProduto.length == 0) {
                // nenhum produto foi enviado
                mensagemErro = "Nenhum produto foi adicionado ao pedido!";
            } else {
                // monta os itens
                for (int i = 0; i < idsProduto.length; i++) {
                    if (idsProduto[i] != null && !idsProduto[i].isEmpty()) {
                        ItemPedido item = new ItemPedido(); // cria item
                        item.setIdProduto(Integer.parseInt(idsProduto[i]));
                        item.setQuantidade(Integer.parseInt(quantidades[i]));
                        item.setPrecoUnitario(Double.parseDouble(precos[i]));
                        item.calcularSubtotal(); // calcula subtotal
                        pedido.adicionarItem(item); // adiciona no pedido
                    }
                }

                pedido.calcularValorTotal(); // soma tudo

                // salva tudo no banco (com transação)
                sucesso = dao.inserirPedidoCompleto(pedido);

                if (sucesso) {
                    response.sendRedirect("listarPedidos.jsp");
                } else {
                    mensagemErro = "Erro ao processar o pedido. Verifique estoque.";
                }
            }
        }

    } catch (Exception e) {
        mensagemErro = "ERRO: " + e.getMessage(); // erro geral
        e.printStackTrace();
    }

    // se deu erro, mostra tela personalizada
    if (!mensagemErro.isEmpty()) {
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Erro - Cantinho Gourmet</title>
    <style>
        /* css da página de erro */
    </style>
</head>
<body>
    <div class="error-container">
        <h2>❌ Erro ao Processar Pedido</h2>

        <div class="error-box">
            <div class="error-message"><%= mensagemErro %></div> <!-- mostra erro -->
        </div>

        <div class="info-box">
            <div class="info-title">💡 Possíveis Causas:</div>
            <ul>
                <li>Sem estoque</li>
                <li>Dados inválidos</li>
                <li>Erro no banco</li>
                <li>Nenhum produto adicionado</li>
            </ul>
        </div>

        <div class="info-box">
            <div class="info-title">🔒 Segurança da Transação:</div>
            <p>
                <!-- explicação do rollback -->
                Nenhuma alteração foi salva.
            </p>
        </div>

        <div class="btn-group">
            <a href="formPedido.jsp" class="btn btn-primary">← Voltar</a>
            <a href="listarPedidos.jsp" class="btn btn-secondary">Ver Pedidos</a>
        </div>
    </div>
</body>
</html>

<%
    }
%>

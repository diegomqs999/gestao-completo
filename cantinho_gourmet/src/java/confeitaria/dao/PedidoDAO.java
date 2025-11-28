package confeitaria.dao;
/**
 *
 * 
    Document   : PedidoDAO
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897


 */

import confeitaria.model.Pedido;
import confeitaria.model.ItemPedido;
import confeitaria.model.ItemPedido;
import confeitaria.model.Pedido;
import confeitaria.utill.ConnectionFactory;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PedidoDAO {
    
    
    // TRANSAÇÃO: INSERIR PEDIDO COMPLETO
    
    public boolean inserirPedidoCompleto(Pedido pedido) {
        Connection conn = null;
        PreparedStatement stmtPedido = null;
        PreparedStatement stmtItem = null;
        PreparedStatement stmtEstoque = null;
        ResultSet rs = null;
        
        try {
            // Obter conexão
            conn = ConnectionFactory.getConnection();
            
            // INICIAR TRANSAÇÃO
            conn.setAutoCommit(false);
            
            System.out.println("=== INICIANDO TRANSAÇÃO ===");
            
            // 1. INSERIR PEDIDO
            String sqlPedido = "INSERT INTO pedidos (id_cliente, id_funcionario, id_fornecedor, status, valor_total, observacoes) VALUES (?, ?, ?, ?, ?, ?)";
            stmtPedido = conn.prepareStatement(sqlPedido, Statement.RETURN_GENERATED_KEYS);
            stmtPedido.setInt(1, pedido.getIdCliente());
            stmtPedido.setInt(2, pedido.getIdFuncionario());
            stmtPedido.setInt(3, pedido.getIdFornecedor());
            stmtPedido.setString(4, pedido.getStatus());
            stmtPedido.setDouble(5, pedido.getValorTotal());
            stmtPedido.setString(6, pedido.getObservacoes());
            
            int linhasPedido = stmtPedido.executeUpdate();
            System.out.println("✓ Pedido inserido: " + linhasPedido + " linha(s)");
            
            // Obter ID do pedido gerado
            rs = stmtPedido.getGeneratedKeys();
            int idPedido = 0;
            if (rs.next()) {
                idPedido = rs.getInt(1);
                pedido.setIdPedido(idPedido);
                System.out.println("✓ ID do Pedido gerado: " + idPedido);
            }
            
            // 2. INSERIR ITENS DO PEDIDO
            String sqlItem = "INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal) VALUES (?, ?, ?, ?, ?)";
            stmtItem = conn.prepareStatement(sqlItem);
            
            for (ItemPedido item : pedido.getItens()) {
                stmtItem.setInt(1, idPedido);
                stmtItem.setInt(2, item.getIdProduto());
                stmtItem.setInt(3, item.getQuantidade());
                stmtItem.setDouble(4, item.getPrecoUnitario());
                stmtItem.setDouble(5, item.getSubtotal());
                stmtItem.addBatch();
            }
            
            int[] linhasItens = stmtItem.executeBatch();
            System.out.println("✓ Itens inseridos: " + linhasItens.length + " item(ns)");
            
            // 3. ATUALIZAR ESTOQUE DOS PRODUTOS
            String sqlEstoque = "UPDATE produtos SET estoque = estoque - ? WHERE id_produto = ? AND estoque >= ?";
            stmtEstoque = conn.prepareStatement(sqlEstoque);
            
            for (ItemPedido item : pedido.getItens()) {
                stmtEstoque.setInt(1, item.getQuantidade());
                stmtEstoque.setInt(2, item.getIdProduto());
                stmtEstoque.setInt(3, item.getQuantidade());
                
                int linhasEstoque = stmtEstoque.executeUpdate();
                
                if (linhasEstoque == 0) {
                    // Estoque insuficiente - ROLLBACK
                    System.err.println("✗ ERRO: Estoque insuficiente para produto ID " + item.getIdProduto());
                    conn.rollback();
                    System.out.println("=== ROLLBACK EXECUTADO ===");
                    return false;
                }
                
                System.out.println("✓ Estoque atualizado para produto ID " + item.getIdProduto());
            }
            
            // COMMIT - Confirma todas as operações
            conn.commit();
            System.out.println("=== COMMIT EXECUTADO - TRANSAÇÃO CONCLUÍDA ===");
            
            return true;
            
        } catch (SQLException e) {
            System.err.println("✗ ERRO NA TRANSAÇÃO: " + e.getMessage());
            e.printStackTrace();
            
            // ROLLBACK em caso de erro
            if (conn != null) {
                try {
                    conn.rollback();
                    System.out.println("=== ROLLBACK EXECUTADO (Erro) ===");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
            
        } finally {
            // Restaurar autocommit
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            
            // Fechar recursos
            try {
                if (rs != null) rs.close();
                if (stmtPedido != null) stmtPedido.close();
                if (stmtItem != null) stmtItem.close();
                if (stmtEstoque != null) stmtEstoque.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    
    // LISTAR TODOS OS PEDIDOS
    
    public List<Pedido> listarTodos() {
        List<Pedido> pedidos = new ArrayList<>();
        String sql = "SELECT p.*, c.nome as nome_cliente, " +
                     "f.nome as nome_funcionario, f.cargo as cargo_funcionario, " +
                     "fr.nome_empresa as nome_fornecedor " +
                     "FROM pedidos p " +
                     "INNER JOIN clientes c ON p.id_cliente = c.id_cliente " +
                     "LEFT JOIN funcionarios f ON p.id_funcionario = f.id_funcionario " +
                     "LEFT JOIN fornecedores fr ON p.id_fornecedor = fr.id_fornecedor " +
                     "WHERE p.ativo = TRUE ORDER BY p.data_pedido DESC";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Pedido pedido = new Pedido();
                pedido.setIdPedido(rs.getInt("id_pedido"));
                pedido.setIdCliente(rs.getInt("id_cliente"));
                pedido.setNomeCliente(rs.getString("nome_cliente"));
                pedido.setIdFuncionario(rs.getInt("id_funcionario"));
                pedido.setNomeFuncionario(rs.getString("nome_funcionario"));
                pedido.setCargoFuncionario(rs.getString("cargo_funcionario"));
                pedido.setIdFornecedor(rs.getInt("id_fornecedor"));
                pedido.setNomeFornecedor(rs.getString("nome_fornecedor"));
                pedido.setDataPedido(rs.getTimestamp("data_pedido"));
                pedido.setStatus(rs.getString("status"));
                pedido.setValorTotal(rs.getDouble("valor_total"));
                pedido.setObservacoes(rs.getString("observacoes"));
                pedido.setAtivo(rs.getBoolean("ativo"));
                
                pedidos.add(pedido);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return pedidos;
    }
    
        // BUSCAR PEDIDO POR ID COM ITENS
    
    public Pedido buscarPorIdComItens(int idPedido) {
        Pedido pedido = null;
        String sqlPedido = "SELECT p.*, c.nome as nome_cliente, " +
                          "f.nome as nome_funcionario, f.cargo as cargo_funcionario, " +
                          "fr.nome_empresa as nome_fornecedor " +
                          "FROM pedidos p " +
                          "INNER JOIN clientes c ON p.id_cliente = c.id_cliente " +
                          "LEFT JOIN funcionarios f ON p.id_funcionario = f.id_funcionario " +
                          "LEFT JOIN fornecedores fr ON p.id_fornecedor = fr.id_fornecedor " +
                          "WHERE p.id_pedido = ?";
        
        String sqlItens = "SELECT ip.*, pr.nome as nome_produto, pr.categoria as categoria_produto " +
                         "FROM itens_pedido ip " +
                         "INNER JOIN produtos pr ON ip.id_produto = pr.id_produto " +
                         "WHERE ip.id_pedido = ?";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmtPedido = conn.prepareStatement(sqlPedido);
             PreparedStatement stmtItens = conn.prepareStatement(sqlItens)) {
            
            // Buscar pedido
            stmtPedido.setInt(1, idPedido);
            ResultSet rsPedido = stmtPedido.executeQuery();
            
            if (rsPedido.next()) {
                pedido = new Pedido();
                pedido.setIdPedido(rsPedido.getInt("id_pedido"));
                pedido.setIdCliente(rsPedido.getInt("id_cliente"));
                pedido.setNomeCliente(rsPedido.getString("nome_cliente"));
                pedido.setIdFuncionario(rsPedido.getInt("id_funcionario"));
                pedido.setNomeFuncionario(rsPedido.getString("nome_funcionario"));
                pedido.setCargoFuncionario(rsPedido.getString("cargo_funcionario"));
                pedido.setIdFornecedor(rsPedido.getInt("id_fornecedor"));
                pedido.setNomeFornecedor(rsPedido.getString("nome_fornecedor"));
                pedido.setDataPedido(rsPedido.getTimestamp("data_pedido"));
                pedido.setStatus(rsPedido.getString("status"));
                pedido.setValorTotal(rsPedido.getDouble("valor_total"));
                pedido.setObservacoes(rsPedido.getString("observacoes"));
                pedido.setAtivo(rsPedido.getBoolean("ativo"));
                
                // Buscar itens do pedido
                stmtItens.setInt(1, idPedido);
                ResultSet rsItens = stmtItens.executeQuery();
                
                while (rsItens.next()) {
                    ItemPedido item = new ItemPedido();
                    item.setIdItem(rsItens.getInt("id_item"));
                    item.setIdPedido(rsItens.getInt("id_pedido"));
                    item.setIdProduto(rsItens.getInt("id_produto"));
                    item.setNomeProduto(rsItens.getString("nome_produto"));
                    item.setCategoriaProduto(rsItens.getString("categoria_produto"));
                    item.setQuantidade(rsItens.getInt("quantidade"));
                    item.setPrecoUnitario(rsItens.getDouble("preco_unitario"));
                    item.setSubtotal(rsItens.getDouble("subtotal"));
                    
                    pedido.adicionarItem(item);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return pedido;
    }
    
    
    // ATUALIZAR STATUS DO PEDIDO
    
    public boolean atualizarStatus(int idPedido, String novoStatus) {
        String sql = "UPDATE pedidos SET status = ? WHERE id_pedido = ?";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, novoStatus);
            stmt.setInt(2, idPedido);
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
   
    // CANCELAR PEDIDO (Soft Delete)
   
    public boolean cancelarPedido(int idPedido) {
        String sql = "UPDATE pedidos SET ativo = FALSE, status = 'Cancelado' WHERE id_pedido = ?";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, idPedido);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
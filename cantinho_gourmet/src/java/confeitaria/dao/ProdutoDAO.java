/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package confeitaria.dao;
/**
 *
 * 
    Document   : ProdutoDAO
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897


 */


import confeitaria.model.Produto;
import confeitaria.utill.ConnectionFactory;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProdutoDAO {
    
    // CREATE
    public boolean inserir(Produto produto) {
        String sql = "INSERT INTO produtos (nome, categoria, preco, estoque) VALUES (?, ?, ?, ?)";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, produto.getNome());
            stmt.setString(2, produto.getCategoria());
            stmt.setDouble(3, produto.getPreco());
            stmt.setInt(4, produto.getEstoque());

            int linhasAfetadas = stmt.executeUpdate();
            System.out.println("Linhas afetadas: " + linhasAfetadas);
            return linhasAfetadas > 0;

        } catch (SQLException e) {
            System.err.println("ERRO SQL ao inserir produto:");
            System.err.println("Mensagem: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
            return false;
        }
    }
    
    // READ - Listar todos
    public List<Produto> listarTodos() {
        List<Produto> produtos = new ArrayList<>();
        String sql = "SELECT * FROM produtos WHERE ativo = 1 ORDER BY nome";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Produto produto = new Produto();
                produto.setIdProduto(rs.getInt("id_produto"));
                produto.setNome(rs.getString("nome"));
                produto.setCategoria(rs.getString("categoria"));
                produto.setPreco(rs.getDouble("preco"));
                produto.setEstoque(rs.getInt("estoque"));
                produto.setDataCadastro(rs.getTimestamp("data_cadastro"));
                produto.setAtivo(rs.getBoolean("ativo"));
                
                produtos.add(produto);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return produtos;
    }
    
    // READ - Buscar por ID
    public Produto buscarPorId(int id) {
        String sql = "SELECT * FROM produtos WHERE id_produto = ?";
        Produto produto = null;
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                produto = new Produto();
                produto.setIdProduto(rs.getInt("id_produto"));
                produto.setNome(rs.getString("nome"));
                produto.setCategoria(rs.getString("categoria"));
                produto.setPreco(rs.getDouble("preco"));
                produto.setEstoque(rs.getInt("estoque"));
                produto.setDataCadastro(rs.getTimestamp("data_cadastro"));
                produto.setAtivo(rs.getBoolean("ativo"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return produto;
    }
    
    // UPDATE
    public boolean atualizar(Produto produto) {
        String sql = "UPDATE produtos SET nome = ?, categoria = ?, preco = ?, estoque = ? WHERE id_produto = ?";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, produto.getNome());
            stmt.setString(2, produto.getCategoria());
            stmt.setDouble(3, produto.getPreco());
            stmt.setInt(4, produto.getEstoque());
            stmt.setInt(5, produto.getIdProduto());
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // DELETE (Soft delete)
    public boolean deletar(int id) {
        String sql = "UPDATE produtos SET ativo = 0 WHERE id_produto = ?";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // BUSCAR - Pesquisar por nome ou categoria
    public List<Produto> pesquisar(String termo) {
        List<Produto> produtos = new ArrayList<>();
        String sql = "SELECT * FROM produtos WHERE ativo = 1 AND (nome LIKE ? OR categoria LIKE ?) ORDER BY nome";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String termoBusca = "%" + termo + "%";
            stmt.setString(1, termoBusca);
            stmt.setString(2, termoBusca);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Produto produto = new Produto();
                produto.setIdProduto(rs.getInt("id_produto"));
                produto.setNome(rs.getString("nome"));
                produto.setCategoria(rs.getString("categoria"));
                produto.setPreco(rs.getDouble("preco"));
                produto.setEstoque(rs.getInt("estoque"));
                produto.setDataCadastro(rs.getTimestamp("data_cadastro"));
                produto.setAtivo(rs.getBoolean("ativo"));

                produtos.add(produto);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return produtos;
    }
}
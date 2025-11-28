/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package confeitaria.dao;

/**
 *
 * 
    Document   : FornecedorDAO
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897


 */


import confeitaria.model.Fornecedor;
import confeitaria.utill.ConnectionFactory;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FornecedorDAO {
    
    // CREATE
    public boolean inserir(Fornecedor fornecedor) {
        String sql = "INSERT INTO fornecedores (nome_empresa, cnpj, telefone, email, endereco, tipo_produto) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, fornecedor.getNomeEmpresa());
            stmt.setString(2, fornecedor.getCnpj());
            stmt.setString(3, fornecedor.getTelefone());
            stmt.setString(4, fornecedor.getEmail());
            stmt.setString(5, fornecedor.getEndereco());
            stmt.setString(6, fornecedor.getTipoProduto());

            int linhasAfetadas = stmt.executeUpdate();
            System.out.println("Linhas afetadas: " + linhasAfetadas);
            return linhasAfetadas > 0;

        } catch (SQLException e) {
            System.err.println("ERRO SQL ao inserir fornecedor:");
            System.err.println("Mensagem: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
            return false;
        }
    }
    
    // READ - Listar todos
    public List<Fornecedor> listarTodos() {
        List<Fornecedor> fornecedores = new ArrayList<>();
        String sql = "SELECT * FROM fornecedores WHERE ativo = 1 ORDER BY nome_empresa";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Fornecedor fornecedor = new Fornecedor();
                fornecedor.setIdFornecedor(rs.getInt("id_fornecedor"));
                fornecedor.setNomeEmpresa(rs.getString("nome_empresa"));
                fornecedor.setCnpj(rs.getString("cnpj"));
                fornecedor.setTelefone(rs.getString("telefone"));
                fornecedor.setEmail(rs.getString("email"));
                fornecedor.setEndereco(rs.getString("endereco"));
                fornecedor.setTipoProduto(rs.getString("tipo_produto"));
                fornecedor.setDataCadastro(rs.getTimestamp("data_cadastro"));
                fornecedor.setAtivo(rs.getBoolean("ativo"));
                
                fornecedores.add(fornecedor);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return fornecedores;
    }
    
    // READ - Buscar por ID
    public Fornecedor buscarPorId(int id) {
        String sql = "SELECT * FROM fornecedores WHERE id_fornecedor = ?";
        Fornecedor fornecedor = null;
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                fornecedor = new Fornecedor();
                fornecedor.setIdFornecedor(rs.getInt("id_fornecedor"));
                fornecedor.setNomeEmpresa(rs.getString("nome_empresa"));
                fornecedor.setCnpj(rs.getString("cnpj"));
                fornecedor.setTelefone(rs.getString("telefone"));
                fornecedor.setEmail(rs.getString("email"));
                fornecedor.setEndereco(rs.getString("endereco"));
                fornecedor.setTipoProduto(rs.getString("tipo_produto"));
                fornecedor.setDataCadastro(rs.getTimestamp("data_cadastro"));
                fornecedor.setAtivo(rs.getBoolean("ativo"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return fornecedor;
    }
    
    // UPDATE
    public boolean atualizar(Fornecedor fornecedor) {
        String sql = "UPDATE fornecedores SET nome_empresa = ?, cnpj = ?, telefone = ?, email = ?, endereco = ?, tipo_produto = ? WHERE id_fornecedor = ?";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, fornecedor.getNomeEmpresa());
            stmt.setString(2, fornecedor.getCnpj());
            stmt.setString(3, fornecedor.getTelefone());
            stmt.setString(4, fornecedor.getEmail());
            stmt.setString(5, fornecedor.getEndereco());
            stmt.setString(6, fornecedor.getTipoProduto());
            stmt.setInt(7, fornecedor.getIdFornecedor());
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // DELETE (Soft delete)
    public boolean deletar(int id) {
        String sql = "UPDATE fornecedores SET ativo = 0 WHERE id_fornecedor = ?";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    // BUSCAR - Pesquisar por nome empresa ou CNPJ
    public List<Fornecedor> pesquisar(String termo) {
        List<Fornecedor> fornecedores = new ArrayList<>();
        String sql = "SELECT * FROM fornecedores WHERE ativo = 1 AND (nome_empresa LIKE ? OR cnpj LIKE ?) ORDER BY nome_empresa";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String termoBusca = "%" + termo + "%";
            stmt.setString(1, termoBusca);
            stmt.setString(2, termoBusca);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Fornecedor fornecedor = new Fornecedor();
                fornecedor.setIdFornecedor(rs.getInt("id_fornecedor"));
                fornecedor.setNomeEmpresa(rs.getString("nome_empresa"));
                fornecedor.setCnpj(rs.getString("cnpj"));
                fornecedor.setTelefone(rs.getString("telefone"));
                fornecedor.setEmail(rs.getString("email"));
                fornecedor.setEndereco(rs.getString("endereco"));
                fornecedor.setTipoProduto(rs.getString("tipo_produto"));
                fornecedor.setDataCadastro(rs.getTimestamp("data_cadastro"));
                fornecedor.setAtivo(rs.getBoolean("ativo"));

                fornecedores.add(fornecedor);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return fornecedores;
    }
}
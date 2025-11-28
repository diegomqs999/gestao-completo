/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package confeitaria.dao;

/**
 *
 * 
    Document   : FuncionarioDAO
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897


 */

import confeitaria.model.Funcionario;
import confeitaria.utill.ConnectionFactory;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FuncionarioDAO {
    
    // CREATE
    public boolean inserir(Funcionario funcionario) {
        String sql = "INSERT INTO funcionarios (nome, cargo, salario, telefone, email) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, funcionario.getNome());
            stmt.setString(2, funcionario.getCargo());
            stmt.setDouble(3, funcionario.getSalario());
            stmt.setString(4, funcionario.getTelefone());
            stmt.setString(5, funcionario.getEmail());

            int linhasAfetadas = stmt.executeUpdate();
            System.out.println("Linhas afetadas: " + linhasAfetadas);
            return linhasAfetadas > 0;

        } catch (SQLException e) {
            System.err.println("ERRO SQL ao inserir funcionário:");
            System.err.println("Mensagem: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
            return false;
        }
    }
    
    // READ - Listar todos
    public List<Funcionario> listarTodos() {
        List<Funcionario> funcionarios = new ArrayList<>();
        String sql = "SELECT * FROM funcionarios WHERE ativo = 1 ORDER BY nome";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Funcionario funcionario = new Funcionario();
                funcionario.setIdFuncionario(rs.getInt("id_funcionario"));
                funcionario.setNome(rs.getString("nome"));
                funcionario.setCargo(rs.getString("cargo"));
                funcionario.setSalario(rs.getDouble("salario"));
                funcionario.setTelefone(rs.getString("telefone"));
                funcionario.setEmail(rs.getString("email"));
                funcionario.setDataCadastro(rs.getTimestamp("data_cadastro"));
                funcionario.setAtivo(rs.getBoolean("ativo"));
                
                funcionarios.add(funcionario);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return funcionarios;
    }
    
    // READ - Buscar por ID
    public Funcionario buscarPorId(int id) {
        String sql = "SELECT * FROM funcionarios WHERE id_funcionario = ?";
        Funcionario funcionario = null;
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                funcionario = new Funcionario();
                funcionario.setIdFuncionario(rs.getInt("id_funcionario"));
                funcionario.setNome(rs.getString("nome"));
                funcionario.setCargo(rs.getString("cargo"));
                funcionario.setSalario(rs.getDouble("salario"));
                funcionario.setTelefone(rs.getString("telefone"));
                funcionario.setEmail(rs.getString("email"));
                funcionario.setDataCadastro(rs.getTimestamp("data_cadastro"));
                funcionario.setAtivo(rs.getBoolean("ativo"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return funcionario;
    }
    
    // UPDATE
    public boolean atualizar(Funcionario funcionario) {
        String sql = "UPDATE funcionarios SET nome = ?, cargo = ?, salario = ?, telefone = ?, email = ? WHERE id_funcionario = ?";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, funcionario.getNome());
            stmt.setString(2, funcionario.getCargo());
            stmt.setDouble(3, funcionario.getSalario());
            stmt.setString(4, funcionario.getTelefone());
            stmt.setString(5, funcionario.getEmail());
            stmt.setInt(6, funcionario.getIdFuncionario());
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // DELETE (Soft delete)
    public boolean deletar(int id) {
        String sql = "UPDATE funcionarios SET ativo = 0 WHERE id_funcionario = ?";
        
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // BUSCAR - Pesquisar por nome ou cargo
    public List<Funcionario> pesquisar(String termo) {
        List<Funcionario> funcionarios = new ArrayList<>();
        String sql = "SELECT * FROM funcionarios WHERE ativo = 1 AND (nome LIKE ? OR cargo LIKE ?) ORDER BY nome";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String termoBusca = "%" + termo + "%";
            stmt.setString(1, termoBusca);
            stmt.setString(2, termoBusca);

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Funcionario funcionario = new Funcionario();
                funcionario.setIdFuncionario(rs.getInt("id_funcionario"));
                funcionario.setNome(rs.getString("nome"));
                funcionario.setCargo(rs.getString("cargo"));
                funcionario.setSalario(rs.getDouble("salario"));
                funcionario.setTelefone(rs.getString("telefone"));
                funcionario.setEmail(rs.getString("email"));
                funcionario.setDataCadastro(rs.getTimestamp("data_cadastro"));
                funcionario.setAtivo(rs.getBoolean("ativo"));

                funcionarios.add(funcionario);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return funcionarios;
    }
}
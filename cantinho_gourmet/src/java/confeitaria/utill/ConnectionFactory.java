/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package confeitaria.utill;

/**
 *
 * 
    Document   : ConnectionFactory
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897


 */





import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionFactory {
    
    // Configurações do banco de dados
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String URL = "jdbc:mysql://localhost:3306/cantinhoBD?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = ""; 
    
    /**
     * Método para obter conexão com o banco de dados
     * @return Connection - conexão ativa ou null se falhar
     */
    public static Connection getConnection() {
        try {
            // Carregar o driver JDBC
            Class.forName(DRIVER);
            
            // Estabelecer conexão
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            
            System.out.println("✅ Conexão estabelecida com sucesso!");
            return conn;
            
        } catch (ClassNotFoundException e) {
            System.err.println("❌ ERRO: Driver MySQL não encontrado!");
            System.err.println("📦 Certifique-se de adicionar mysql-connector-java.jar ao projeto");
            e.printStackTrace();
            return null;
            
        } catch (SQLException e) {
            System.err.println("❌ ERRO: Não foi possível conectar ao banco de dados!");
            System.err.println("🔍 Verifique:");
            System.err.println("   1. MySQL está rodando?");
            System.err.println("   2. Banco 'cantinhoBD' existe?");
            System.err.println("   3. Usuário e senha estão corretos?");
            System.err.println("   4. Porta 3306 está correta?");
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Método para fechar conexão
     * @param conn - conexão a ser fechada
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                System.out.println("🔒 Conexão fechada com sucesso!");
            } catch (SQLException e) {
                System.err.println("❌ Erro ao fechar conexão!");
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Método de teste - execute este main para testar a conexão
     */
    public static void main(String[] args) {
        System.out.println("🧪 Testando conexão com o banco de dados...\n");
        
        Connection conn = getConnection();
        
        if (conn != null) {
            System.out.println("\n✅ SUCESSO! Conexão funcionando perfeitamente!");
            closeConnection(conn);
        } else {
            System.out.println("\n❌ FALHA! Verifique as configurações acima.");
        }
    }
}
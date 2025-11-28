package confeitaria.model;

/**
 *
 * 
    Document   : Fornecedor
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897


 */

import java.sql.Timestamp;

public class Fornecedor {
    private int idFornecedor;
    private String nomeEmpresa;
    private String cnpj;
    private String telefone;
    private String email;
    private String endereco;
    private String tipoProduto;
    private Timestamp dataCadastro;
    private boolean ativo;
    
    // Construtores
    public Fornecedor() {}
    
    public Fornecedor(String nomeEmpresa, String cnpj, String telefone, String email, String endereco, String tipoProduto) {
        this.nomeEmpresa = nomeEmpresa;
        this.cnpj = cnpj;
        this.telefone = telefone;
        this.email = email;
        this.endereco = endereco;
        this.tipoProduto = tipoProduto;
        this.ativo = true;
    }
    
    // Getters e Setters
    public int getIdFornecedor() {
        return idFornecedor;
    }
    
    public void setIdFornecedor(int idFornecedor) {
        this.idFornecedor = idFornecedor;
    }
    
    public String getNomeEmpresa() {
        return nomeEmpresa;
    }
    
    public void setNomeEmpresa(String nomeEmpresa) {
        this.nomeEmpresa = nomeEmpresa;
    }
    
    public String getCnpj() {
        return cnpj;
    }
    
    public void setCnpj(String cnpj) {
        this.cnpj = cnpj;
    }
    
    public String getTelefone() {
        return telefone;
    }
    
    public void setTelefone(String telefone) {
        this.telefone = telefone;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getEndereco() {
        return endereco;
    }
    
    public void setEndereco(String endereco) {
        this.endereco = endereco;
    }
    
    public String getTipoProduto() {
        return tipoProduto;
    }
    
    public void setTipoProduto(String tipoProduto) {
        this.tipoProduto = tipoProduto;
    }
    
    public Timestamp getDataCadastro() {
        return dataCadastro;
    }
    
    public void setDataCadastro(Timestamp dataCadastro) {
        this.dataCadastro = dataCadastro;
    }
    
    public boolean isAtivo() {
        return ativo;
    }
    
    public void setAtivo(boolean ativo) {
        this.ativo = ativo;
    }
}
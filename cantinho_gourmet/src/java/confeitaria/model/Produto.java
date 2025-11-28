/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package confeitaria.model;
/**
 *
 * 
    Document   : Produto
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897


 */

import java.sql.Timestamp;

public class Produto {
    private int idProduto;
    private String nome;
    private String categoria;
    private double preco;
    private int estoque;
    private Timestamp dataCadastro;
    private boolean ativo;
    
    // Construtores
    public Produto() {}
    
    public Produto(String nome, String categoria, double preco, int estoque) {
        this.nome = nome;
        this.categoria = categoria;
        this.preco = preco;
        this.estoque = estoque;
        this.ativo = true;
    }
    
    // Getters e Setters
    public int getIdProduto() {
        return idProduto;
    }
    
    public void setIdProduto(int idProduto) {
        this.idProduto = idProduto;
    }
    
    public String getNome() {
        return nome;
    }
    
    public void setNome(String nome) {
        this.nome = nome;
    }
    
    public String getCategoria() {
        return categoria;
    }
    
    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }
    
    public double getPreco() {
        return preco;
    }
    
    public void setPreco(double preco) {
        this.preco = preco;
    }
    
    public int getEstoque() {
        return estoque;
    }
    
    public void setEstoque(int estoque) {
        this.estoque = estoque;
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
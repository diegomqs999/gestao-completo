/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package confeitaria.model;

/**
 *
 * 
    Document   : ItemPedido
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897

 */

public class ItemPedido {
    private int idItem;
    private int idPedido;
    private int idProduto;
    private String nomeProduto; // Para exibição
    private String categoriaProduto; // Para exibição
    private int quantidade;
    private double precoUnitario;
    private double subtotal;
    
    // Construtores
    public ItemPedido() {}
    
    public ItemPedido(int idProduto, int quantidade, double precoUnitario) {
        this.idProduto = idProduto;
        this.quantidade = quantidade;
        this.precoUnitario = precoUnitario;
        this.subtotal = quantidade * precoUnitario;
    }
    
    // Métodos auxiliares
    public void calcularSubtotal() {
        this.subtotal = this.quantidade * this.precoUnitario;
    }
    
    // Getters e Setters
    public int getIdItem() {
        return idItem;
    }
    
    public void setIdItem(int idItem) {
        this.idItem = idItem;
    }
    
    public int getIdPedido() {
        return idPedido;
    }
    
    public void setIdPedido(int idPedido) {
        this.idPedido = idPedido;
    }
    
    public int getIdProduto() {
        return idProduto;
    }
    
    public void setIdProduto(int idProduto) {
        this.idProduto = idProduto;
    }
    
    public String getNomeProduto() {
        return nomeProduto;
    }
    
    public void setNomeProduto(String nomeProduto) {
        this.nomeProduto = nomeProduto;
    }
    
    public String getCategoriaProduto() {
        return categoriaProduto;
    }
    
    public void setCategoriaProduto(String categoriaProduto) {
        this.categoriaProduto = categoriaProduto;
    }
    
    public int getQuantidade() {
        return quantidade;
    }
    
    public void setQuantidade(int quantidade) {
        this.quantidade = quantidade;
        calcularSubtotal();
    }
    
    public double getPrecoUnitario() {
        return precoUnitario;
    }
    
    public void setPrecoUnitario(double precoUnitario) {
        this.precoUnitario = precoUnitario;
        calcularSubtotal();
    }
    
    public double getSubtotal() {
        return subtotal;
    }
    
    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }
}
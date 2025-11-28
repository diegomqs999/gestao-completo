/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package confeitaria.model;
/**
 *
 * 
    Document   : Funcionario
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897


 */


import java.sql.Timestamp;

public class Funcionario {
    private int idFuncionario;
    private String nome;
    private String cargo;
    private double salario;
    private String telefone;
    private String email;
    private Timestamp dataCadastro;
    private boolean ativo;
    
    // Construtores
    public Funcionario() {}
    
    public Funcionario(String nome, String cargo, double salario, String telefone, String email) {
        this.nome = nome;
        this.cargo = cargo;
        this.salario = salario;
        this.telefone = telefone;
        this.email = email;
        this.ativo = true;
    }
    
    // Getters e Setters
    public int getIdFuncionario() {
        return idFuncionario;
    }
    
    public void setIdFuncionario(int idFuncionario) {
        this.idFuncionario = idFuncionario;
    }
    
    public String getNome() {
        return nome;
    }
    
    public void setNome(String nome) {
        this.nome = nome;
    }
    
    public String getCargo() {
        return cargo;
    }
    
    public void setCargo(String cargo) {
        this.cargo = cargo;
    }
    
    public double getSalario() {
        return salario;
    }
    
    public void setSalario(double salario) {
        this.salario = salario;
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
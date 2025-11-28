package confeitaria.model;
/**
 *
 * 
    Document   : Pedido
    Author     : Diego Marques Silva Neri  RGM: 112411393
    Author     : Mel Camily Souza Santana RGM: 11241101424
    Author     : Lucas Koiti Yoshikava  RGM: 11241100330
    Author     : Victor Ossamu Watanabe Ikeda RGM: 11241101897


 */

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Pedido {
    
    private int idPedido;
    private int idCliente;
    private String nomeCliente;

    private int idFuncionario;
    private String nomeFuncionario;
    private String cargoFuncionario;

    private int idFornecedor;
    private String nomeFornecedor;

    private Timestamp dataPedido;
    private String status;
    private double valorTotal;
    private String observacoes;
    private boolean ativo;

    private List<ItemPedido> itens;

    // Construtores
    public Pedido() {
        this.itens = new ArrayList<>();
        this.ativo = true;
        this.status = "Pendente";
    }

    public Pedido(int idCliente, String observacoes) {
        this();
        this.idCliente = idCliente;
        this.observacoes = observacoes;
    }

    // Métodos auxiliares
    public void adicionarItem(ItemPedido item) {
        this.itens.add(item);
    }

    public void calcularValorTotal() {
        this.valorTotal = 0.0;
        for (ItemPedido item : itens) {
            this.valorTotal += item.getSubtotal();
        }
    }

    
    // Getters e Setters
  

    public int getIdPedido() {
        return idPedido;
    }

    public void setIdPedido(int idPedido) {
        this.idPedido = idPedido;
    }

    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }

    public String getNomeCliente() {
        return nomeCliente;
    }

    public void setNomeCliente(String nomeCliente) {
        this.nomeCliente = nomeCliente;
    }

    // FUNCIONÁRIO --------------------

    public int getIdFuncionario() {
        return idFuncionario;
    }

    public void setIdFuncionario(int idFuncionario) {
        this.idFuncionario = idFuncionario;
    }

    public String getNomeFuncionario() {
        return nomeFuncionario;
    }

    public void setNomeFuncionario(String nomeFuncionario) {
        this.nomeFuncionario = nomeFuncionario;
    }

    public String getCargoFuncionario() {
        return cargoFuncionario;
    }

    public void setCargoFuncionario(String cargoFuncionario) {
        this.cargoFuncionario = cargoFuncionario;
    }

    // FORNECEDOR ---

    public int getIdFornecedor() {
        return idFornecedor;
    }

    public void setIdFornecedor(int idFornecedor) {
        this.idFornecedor = idFornecedor;
    }

    public String getNomeFornecedor() {
        return nomeFornecedor;
    }

    public void setNomeFornecedor(String nomeFornecedor) {
        this.nomeFornecedor = nomeFornecedor;
    }

    // PEDIDO --

    public Timestamp getDataPedido() {
        return dataPedido;
    }

    public void setDataPedido(Timestamp dataPedido) {
        this.dataPedido = dataPedido;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public double getValorTotal() {
        return valorTotal;
    }

    public void setValorTotal(double valorTotal) {
        this.valorTotal = valorTotal;
    }

    public String getObservacoes() {
        return observacoes;
    }

    public void setObservacoes(String observacoes) {
        this.observacoes = observacoes;
    }

    public boolean isAtivo() {
        return ativo;
    }

    public void setAtivo(boolean ativo) {
        this.ativo = ativo;
    }

    public List<ItemPedido> getItens() {
        return itens;
    }

    public void setItens(List<ItemPedido> itens) {
        this.itens = itens;
    }
}

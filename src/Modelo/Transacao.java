package Modelo;

import java.math.BigDecimal;
import java.time.LocalDate;


public class Transacao {
    private int idTransacao;
    private LocalDate data;
    private int categoriaId;
    private String tipoPagamento;
    private String informacaoAdicional;
    private BigDecimal valor;
    private TipoTransacao tipo;  
    private int usuarioId;  
    
    public enum TipoTransacao {
        ENTRADA, SAIDA
    }
    
    public int getIdTransacao() {
        return idTransacao;
    }
    
    public void setIdTransacao(int idTransacao) {
        this.idTransacao = idTransacao;
    }
    
    public LocalDate getData() {
        return data;
    }
    
    public void setData(LocalDate data) {
        this.data = data;
    }
    
    public int getCategoriaId() {
        return categoriaId;
    }
    
    public void setCategoriaId(int categoriaId) {
        this.categoriaId = categoriaId;
    }
    
    public String getTipoPagamento() {
        return tipoPagamento;
    }
    
    public void setTipoPagamento(String tipoPagamento) {
        this.tipoPagamento = tipoPagamento;
    }
    
    public String getInformacaoAdicional() {
        return informacaoAdicional;
    }
    
    public void setInformacaoAdicional(String informacaoAdicional) {
        this.informacaoAdicional = informacaoAdicional;
    }
    
    public BigDecimal getValor() {
        return valor;
    }
    
    public void setValor(BigDecimal valor) {
        this.valor = valor;
    }
    
    public TipoTransacao getTipo() {
        return tipo;
    }
    
    public void setTipo(TipoTransacao tipo) {
        this.tipo = tipo;
    }
    
    public int getUsuarioId() {
        return usuarioId;
    }
    
    public void setUsuarioId(int usuarioId) {
        this.usuarioId = usuarioId;
    }
}
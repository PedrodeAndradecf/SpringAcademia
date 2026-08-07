package Backend.Estudo.SpringAcademia.domain;

import Backend.Estudo.SpringAcademia.domain.enums.StatusFatura;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "faturas_matricuals")
public class FaturaMatricula {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @Column(name = "data_vencimento")
    private LocalDateTime datavencimento;

    private BigDecimal valor;

    @Column(name = "data_pagamento")
    private LocalDateTime dataPagamento;

    @Column(name = "data_cancelamento")
    private LocalDateTime dataCancelamento;

    private StatusFatura status = StatusFatura.ABERTA;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "matricula_id")
    private Matricula matricula;


    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public LocalDateTime getDatavencimento() {
        return datavencimento;
    }

    public void setDatavencimento(LocalDateTime datavencimento) {
        this.datavencimento = datavencimento;
    }

    public BigDecimal getValor() {
        return valor;
    }

    public void setValor(BigDecimal valor) {
        this.valor = valor;
    }

    public LocalDateTime getDataPagamento() {
        return dataPagamento;
    }

    public void setDataPagamento(LocalDateTime dataPagamento) {
        this.dataPagamento = dataPagamento;
    }

    public LocalDateTime getDataCancelamento() {
        return dataCancelamento;
    }

    public void setDataCancelamento(LocalDateTime dataCancelamento) {
        this.dataCancelamento = dataCancelamento;
    }

    public StatusFatura getStatus() {
        return status;
    }

    public void setStatus(StatusFatura status) {
        this.status = status;
    }

    public Matricula getMatricula() {
        return matricula;
    }

    public void setMatricula(Matricula matricula) {
        this.matricula = matricula;
    }
}

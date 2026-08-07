package Backend.Estudo.SpringAcademia.domain;

import Backend.Estudo.SpringAcademia.domain.enums.StatusMatricula;
import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "matriculas")
public class Matricula {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "data_matricula")
    private LocalDateTime dataMatricula;

    @Column(name = "dia_vencimento")
    private Integer diaVencimento;

    @Column(name = "data_encerramento")
    private LocalDateTime dataEncerramento;

    @Enumerated(EnumType.STRING)
    private StatusMatricula status = StatusMatricula.ATIVA;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "aluno_id")
    private Aluno aluno;


    @PrePersist
    public void prePersist(){
        if(dataMatricula==null){
            this.dataMatricula = LocalDateTime.now();
        }
    }


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public LocalDateTime getDataMatricula() {
        return dataMatricula;
    }

    public void setDataMatricula(LocalDateTime dataMatricula) {
        this.dataMatricula = dataMatricula;
    }

    public Integer getDiaVencimento() {
        return diaVencimento;
    }

    public void setDiaVencimento(Integer diaVencimento) {
        this.diaVencimento = diaVencimento;
    }

    public LocalDateTime getDataEncerramento() {
        return dataEncerramento;
    }

    public void setDataEncerramento(LocalDateTime dataEncerramento) {
        this.dataEncerramento = dataEncerramento;
    }

    public StatusMatricula getStatus() {
        return status;
    }

    public void setStatus(StatusMatricula status) {
        this.status = status;
    }

    public Aluno getAluno() {
        return aluno;
    }

    public void setAluno(Aluno aluno) {
        this.aluno = aluno;
    }
}

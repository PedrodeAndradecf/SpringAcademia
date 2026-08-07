package Backend.Estudo.SpringAcademia.domain;

import jakarta.persistence.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "matricula_modalidade")
public class MatriculaModalidade {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @Column(name = "data_inicio")
    private LocalDate dataInicio;

    @Column(name = "data_fim")
    private LocalDateTime dataFim;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "matricula_id")
    private Matricula matricula;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "modalidade_id")
    private Modalidade modalidade;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "graduacao_id")
    private Graduacao graduacao;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "plano_id")
    private Plano plano;


    @PrePersist
    public void prePersist(){
        if(dataInicio==null){
            this.dataInicio = LocalDate.now();
        }

    }

}

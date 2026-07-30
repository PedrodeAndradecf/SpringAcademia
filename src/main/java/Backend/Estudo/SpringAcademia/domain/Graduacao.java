package Backend.Estudo.SpringAcademia.domain;

import jakarta.persistence.*;

@Entity
@Table(name = "graduacoes")
public class Graduacao {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nome;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "modalidade_id")
    private Modalidade modalidade;
}

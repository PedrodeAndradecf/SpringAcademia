package Backend.Estudo.SpringAcademia.domain;

import jakarta.persistence.*;

@Entity
@Table(name = "planos")
public class Plano {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Long id;

    private String nome;

    private Boolean ativo = true;
}

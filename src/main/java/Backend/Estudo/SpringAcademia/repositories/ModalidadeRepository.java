package Backend.Estudo.SpringAcademia.repositories;

import Backend.Estudo.SpringAcademia.domain.Modalidade;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ModalidadeRepository extends JpaRepository<Modalidade, Long> {
}

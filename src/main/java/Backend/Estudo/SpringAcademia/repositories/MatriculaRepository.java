package Backend.Estudo.SpringAcademia.repositories;

import Backend.Estudo.SpringAcademia.domain.Matricula;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MatriculaRepository extends JpaRepository<Matricula, Long> {
}

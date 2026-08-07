package Backend.Estudo.SpringAcademia.repositories;

import Backend.Estudo.SpringAcademia.domain.Assiduidade;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AssiduidadeRepository extends JpaRepository<Assiduidade, Long> {
}

package Backend.Estudo.SpringAcademia.repositories;

import Backend.Estudo.SpringAcademia.domain.Graduacao;
import org.springframework.data.jpa.repository.JpaRepository;

public interface GraduacaoRepository extends JpaRepository<Graduacao, Long> {
}

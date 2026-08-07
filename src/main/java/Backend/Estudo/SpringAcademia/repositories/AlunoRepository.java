package Backend.Estudo.SpringAcademia.repositories;

import Backend.Estudo.SpringAcademia.domain.Aluno;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AlunoRepository  extends JpaRepository<Aluno, Long> {
    boolean existByEmail(String email);
}

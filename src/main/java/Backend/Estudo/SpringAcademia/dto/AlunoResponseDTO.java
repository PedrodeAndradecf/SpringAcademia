package Backend.Estudo.SpringAcademia.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;

public record AlunoResponseDTO(
        Long id,
        String nome,
        LocalDate dataNascimento,
        String sexo,
        String celular,
        String email,
        String cidade,
        String estado,
        LocalDateTime criadoEm
) {
}

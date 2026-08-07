package Backend.Estudo.SpringAcademia.projection;

import java.math.BigDecimal;
import java.time.LocalDate;

public interface FaturasEmAbertoProjection {

    Long getMatriculaId();
    String getAlunoNome();
    LocalDate getDataVencimento();
    BigDecimal getValor();

}

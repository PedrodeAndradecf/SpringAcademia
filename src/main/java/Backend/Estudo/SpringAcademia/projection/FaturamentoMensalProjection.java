package Backend.Estudo.SpringAcademia.projection;

import java.math.BigDecimal;

public interface FaturamentoMensalProjection {

    BigDecimal getTotalFaturamento();
    String getMes();
}

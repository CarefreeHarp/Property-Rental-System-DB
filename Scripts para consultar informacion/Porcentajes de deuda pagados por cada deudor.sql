select deudor.numero_doc numero_doc,
       sum(abono.valor_abono) suma_abonos,
       sum(prestamo.VALOR_OTORGADO) suma_deuda,
       ROUND((sum(abono.valor_abono)/sum(prestamo.VALOR_OTORGADO)) * 100,2) porcentaje_de_deuda_pagado
  from abono
  join prestamo
on abono.idprestamo = prestamo.id
  right join deudor
on prestamo.iddeudor = deudor.id
 group by deudor.numero_doc
 order by porcentaje_de_deuda_pagado desc;

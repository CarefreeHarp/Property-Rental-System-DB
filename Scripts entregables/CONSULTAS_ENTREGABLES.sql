/*CONSULTAS DEL PROYECTO*/

/*CONSULTA 1*/
SELECT sum(valor_otorgado), EXTRACT(year from FECHA)
FROM PRESTAMO
GROUP BY EXTRACT(year from FECHA);

/*CONSULTA 2*/
select banco.nombre nombre_banco,
       extract(year from prestamo.fecha) anio,
       extract(month from prestamo.fecha) mes,
       sum(prestamo.valor_otorgado) suma_de_prestamos_otorgados
  from banco
  left join prestamo --En caso de existir un banco que no haya otorgado prestamos, de todas formas saldra como resultado y sus valores seran nulos
on prestamo.idbanco = banco.id --Revisar resultado #139 "Banco Sin Plata"
 group by banco.nombre,
          extract(year from prestamo.fecha),
          extract(month from prestamo.fecha)
order by nombre_banco asc, anio asc , mes asc;

